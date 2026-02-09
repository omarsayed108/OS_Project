
obj/user/fib_loop:     file format elf32-i386


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
  800031:	e8 41 01 00 00       	call   800177 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 fibonacci(int n, int64 *memo);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int index=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 80 39 80 00       	push   $0x803980
  800057:	e8 83 0b 00 00       	call   800bdf <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 85 10 00 00       	call   8010f7 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 b2 1b 00 00       	call   801c3a <malloc>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int64 res = fibonacci(index, memo) ;
  80008e:	83 ec 08             	sub    $0x8,%esp
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	ff 75 f4             	pushl  -0xc(%ebp)
  800097:	e8 35 00 00 00       	call   8000d1 <fibonacci>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8000a2:	89 55 ec             	mov    %edx,-0x14(%ebp)

	free(memo);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000ab:	e8 0e 1d 00 00       	call   801dbe <free>
  8000b0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8000bc:	68 9e 39 80 00       	push   $0x80399e
  8000c1:	e8 b3 03 00 00       	call   800479 <atomic_cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000c9:	e8 54 25 00 00       	call   802622 <inctst>
	return;
  8000ce:	90                   	nop
}
  8000cf:	c9                   	leave  
  8000d0:	c3                   	ret    

008000d1 <fibonacci>:


int64 fibonacci(int n, int64 *memo)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i <= n; ++i)
  8000d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000e0:	eb 72                	jmp    800154 <fibonacci+0x83>
	{
		if (i <= 1)
  8000e2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8000e6:	7f 1e                	jg     800106 <fibonacci+0x35>
			memo[i] = 1;
  8000e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f5:	01 d0                	add    %edx,%eax
  8000f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  8000fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  800104:	eb 4b                	jmp    800151 <fibonacci+0x80>
		else
			memo[i] = memo[i-1] + memo[i-2] ;
  800106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800109:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800110:	8b 45 0c             	mov    0xc(%ebp),%eax
  800113:	8d 34 02             	lea    (%edx,%eax,1),%esi
  800116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800119:	05 ff ff ff 1f       	add    $0x1fffffff,%eax
  80011e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800125:	8b 45 0c             	mov    0xc(%ebp),%eax
  800128:	01 d0                	add    %edx,%eax
  80012a:	8b 08                	mov    (%eax),%ecx
  80012c:	8b 58 04             	mov    0x4(%eax),%ebx
  80012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800132:	05 fe ff ff 1f       	add    $0x1ffffffe,%eax
  800137:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80013e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800141:	01 d0                	add    %edx,%eax
  800143:	8b 50 04             	mov    0x4(%eax),%edx
  800146:	8b 00                	mov    (%eax),%eax
  800148:	01 c8                	add    %ecx,%eax
  80014a:	11 da                	adc    %ebx,%edx
  80014c:	89 06                	mov    %eax,(%esi)
  80014e:	89 56 04             	mov    %edx,0x4(%esi)
}


int64 fibonacci(int n, int64 *memo)
{
	for (int i = 0; i <= n; ++i)
  800151:	ff 45 f4             	incl   -0xc(%ebp)
  800154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800157:	3b 45 08             	cmp    0x8(%ebp),%eax
  80015a:	7e 86                	jle    8000e2 <fibonacci+0x11>
		if (i <= 1)
			memo[i] = 1;
		else
			memo[i] = memo[i-1] + memo[i-2] ;
	}
	return memo[n];
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800166:	8b 45 0c             	mov    0xc(%ebp),%eax
  800169:	01 d0                	add    %edx,%eax
  80016b:	8b 50 04             	mov    0x4(%eax),%edx
  80016e:	8b 00                	mov    (%eax),%eax
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	5b                   	pop    %ebx
  800174:	5e                   	pop    %esi
  800175:	5d                   	pop    %ebp
  800176:	c3                   	ret    

00800177 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	57                   	push   %edi
  80017b:	56                   	push   %esi
  80017c:	53                   	push   %ebx
  80017d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800180:	e8 5f 23 00 00       	call   8024e4 <sys_getenvindex>
  800185:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800188:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80018b:	89 d0                	mov    %edx,%eax
  80018d:	01 c0                	add    %eax,%eax
  80018f:	01 d0                	add    %edx,%eax
  800191:	c1 e0 02             	shl    $0x2,%eax
  800194:	01 d0                	add    %edx,%eax
  800196:	c1 e0 02             	shl    $0x2,%eax
  800199:	01 d0                	add    %edx,%eax
  80019b:	c1 e0 03             	shl    $0x3,%eax
  80019e:	01 d0                	add    %edx,%eax
  8001a0:	c1 e0 02             	shl    $0x2,%eax
  8001a3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a8:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b2:	8a 40 20             	mov    0x20(%eax),%al
  8001b5:	84 c0                	test   %al,%al
  8001b7:	74 0d                	je     8001c6 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8001b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8001be:	83 c0 20             	add    $0x20,%eax
  8001c1:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ca:	7e 0a                	jle    8001d6 <libmain+0x5f>
		binaryname = argv[0];
  8001cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001cf:	8b 00                	mov    (%eax),%eax
  8001d1:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8001d6:	83 ec 08             	sub    $0x8,%esp
  8001d9:	ff 75 0c             	pushl  0xc(%ebp)
  8001dc:	ff 75 08             	pushl  0x8(%ebp)
  8001df:	e8 54 fe ff ff       	call   800038 <_main>
  8001e4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001e7:	a1 00 50 80 00       	mov    0x805000,%eax
  8001ec:	85 c0                	test   %eax,%eax
  8001ee:	0f 84 01 01 00 00    	je     8002f5 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001f4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001fa:	bb ac 3a 80 00       	mov    $0x803aac,%ebx
  8001ff:	ba 0e 00 00 00       	mov    $0xe,%edx
  800204:	89 c7                	mov    %eax,%edi
  800206:	89 de                	mov    %ebx,%esi
  800208:	89 d1                	mov    %edx,%ecx
  80020a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80020c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80020f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800214:	b0 00                	mov    $0x0,%al
  800216:	89 d7                	mov    %edx,%edi
  800218:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80021a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800221:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	50                   	push   %eax
  800228:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80022e:	50                   	push   %eax
  80022f:	e8 e6 24 00 00       	call   80271a <sys_utilities>
  800234:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800237:	e8 2f 20 00 00       	call   80226b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	68 cc 39 80 00       	push   $0x8039cc
  800244:	e8 be 01 00 00       	call   800407 <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80024c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80024f:	85 c0                	test   %eax,%eax
  800251:	74 18                	je     80026b <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800253:	e8 e0 24 00 00       	call   802738 <sys_get_optimal_num_faults>
  800258:	83 ec 08             	sub    $0x8,%esp
  80025b:	50                   	push   %eax
  80025c:	68 f4 39 80 00       	push   $0x8039f4
  800261:	e8 a1 01 00 00       	call   800407 <cprintf>
  800266:	83 c4 10             	add    $0x10,%esp
  800269:	eb 59                	jmp    8002c4 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80026b:	a1 20 50 80 00       	mov    0x805020,%eax
  800270:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800276:	a1 20 50 80 00       	mov    0x805020,%eax
  80027b:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800281:	83 ec 04             	sub    $0x4,%esp
  800284:	52                   	push   %edx
  800285:	50                   	push   %eax
  800286:	68 18 3a 80 00       	push   $0x803a18
  80028b:	e8 77 01 00 00       	call   800407 <cprintf>
  800290:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800293:	a1 20 50 80 00       	mov    0x805020,%eax
  800298:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  80029e:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a3:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8002a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ae:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8002b4:	51                   	push   %ecx
  8002b5:	52                   	push   %edx
  8002b6:	50                   	push   %eax
  8002b7:	68 40 3a 80 00       	push   $0x803a40
  8002bc:	e8 46 01 00 00       	call   800407 <cprintf>
  8002c1:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8002c9:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8002cf:	83 ec 08             	sub    $0x8,%esp
  8002d2:	50                   	push   %eax
  8002d3:	68 98 3a 80 00       	push   $0x803a98
  8002d8:	e8 2a 01 00 00       	call   800407 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 cc 39 80 00       	push   $0x8039cc
  8002e8:	e8 1a 01 00 00       	call   800407 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002f0:	e8 90 1f 00 00       	call   802285 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002f5:	e8 1f 00 00 00       	call   800319 <exit>
}
  8002fa:	90                   	nop
  8002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fe:	5b                   	pop    %ebx
  8002ff:	5e                   	pop    %esi
  800300:	5f                   	pop    %edi
  800301:	5d                   	pop    %ebp
  800302:	c3                   	ret    

00800303 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	6a 00                	push   $0x0
  80030e:	e8 9d 21 00 00       	call   8024b0 <sys_destroy_env>
  800313:	83 c4 10             	add    $0x10,%esp
}
  800316:	90                   	nop
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <exit>:

void
exit(void)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80031f:	e8 f2 21 00 00       	call   802516 <sys_exit_env>
}
  800324:	90                   	nop
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	53                   	push   %ebx
  80032b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80032e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800331:	8b 00                	mov    (%eax),%eax
  800333:	8d 48 01             	lea    0x1(%eax),%ecx
  800336:	8b 55 0c             	mov    0xc(%ebp),%edx
  800339:	89 0a                	mov    %ecx,(%edx)
  80033b:	8b 55 08             	mov    0x8(%ebp),%edx
  80033e:	88 d1                	mov    %dl,%cl
  800340:	8b 55 0c             	mov    0xc(%ebp),%edx
  800343:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034a:	8b 00                	mov    (%eax),%eax
  80034c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800351:	75 30                	jne    800383 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800353:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  800359:	a0 44 50 80 00       	mov    0x805044,%al
  80035e:	0f b6 c0             	movzbl %al,%eax
  800361:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800364:	8b 09                	mov    (%ecx),%ecx
  800366:	89 cb                	mov    %ecx,%ebx
  800368:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80036b:	83 c1 08             	add    $0x8,%ecx
  80036e:	52                   	push   %edx
  80036f:	50                   	push   %eax
  800370:	53                   	push   %ebx
  800371:	51                   	push   %ecx
  800372:	e8 b0 1e 00 00       	call   802227 <sys_cputs>
  800377:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80037a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800383:	8b 45 0c             	mov    0xc(%ebp),%eax
  800386:	8b 40 04             	mov    0x4(%eax),%eax
  800389:	8d 50 01             	lea    0x1(%eax),%edx
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800392:	90                   	nop
  800393:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800396:	c9                   	leave  
  800397:	c3                   	ret    

00800398 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003a1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003a8:	00 00 00 
	b.cnt = 0;
  8003ab:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003b2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003b5:	ff 75 0c             	pushl  0xc(%ebp)
  8003b8:	ff 75 08             	pushl  0x8(%ebp)
  8003bb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003c1:	50                   	push   %eax
  8003c2:	68 27 03 80 00       	push   $0x800327
  8003c7:	e8 5a 02 00 00       	call   800626 <vprintfmt>
  8003cc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8003cf:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  8003d5:	a0 44 50 80 00       	mov    0x805044,%al
  8003da:	0f b6 c0             	movzbl %al,%eax
  8003dd:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8003e3:	52                   	push   %edx
  8003e4:	50                   	push   %eax
  8003e5:	51                   	push   %ecx
  8003e6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ec:	83 c0 08             	add    $0x8,%eax
  8003ef:	50                   	push   %eax
  8003f0:	e8 32 1e 00 00       	call   802227 <sys_cputs>
  8003f5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003f8:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8003ff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800405:	c9                   	leave  
  800406:	c3                   	ret    

00800407 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80040d:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800414:	8d 45 0c             	lea    0xc(%ebp),%eax
  800417:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	83 ec 08             	sub    $0x8,%esp
  800420:	ff 75 f4             	pushl  -0xc(%ebp)
  800423:	50                   	push   %eax
  800424:	e8 6f ff ff ff       	call   800398 <vcprintf>
  800429:	83 c4 10             	add    $0x10,%esp
  80042c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80042f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800432:	c9                   	leave  
  800433:	c3                   	ret    

00800434 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80043a:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	c1 e0 08             	shl    $0x8,%eax
  800447:	a3 18 d1 81 00       	mov    %eax,0x81d118
	va_start(ap, fmt);
  80044c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80044f:	83 c0 04             	add    $0x4,%eax
  800452:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800455:	8b 45 0c             	mov    0xc(%ebp),%eax
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 f4             	pushl  -0xc(%ebp)
  80045e:	50                   	push   %eax
  80045f:	e8 34 ff ff ff       	call   800398 <vcprintf>
  800464:	83 c4 10             	add    $0x10,%esp
  800467:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80046a:	c7 05 18 d1 81 00 00 	movl   $0x700,0x81d118
  800471:	07 00 00 

	return cnt;
  800474:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800477:	c9                   	leave  
  800478:	c3                   	ret    

00800479 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80047f:	e8 e7 1d 00 00       	call   80226b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800484:	8d 45 0c             	lea    0xc(%ebp),%eax
  800487:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	83 ec 08             	sub    $0x8,%esp
  800490:	ff 75 f4             	pushl  -0xc(%ebp)
  800493:	50                   	push   %eax
  800494:	e8 ff fe ff ff       	call   800398 <vcprintf>
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80049f:	e8 e1 1d 00 00       	call   802285 <sys_unlock_cons>
	return cnt;
  8004a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004a7:	c9                   	leave  
  8004a8:	c3                   	ret    

008004a9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a9:	55                   	push   %ebp
  8004aa:	89 e5                	mov    %esp,%ebp
  8004ac:	53                   	push   %ebx
  8004ad:	83 ec 14             	sub    $0x14,%esp
  8004b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004bc:	8b 45 18             	mov    0x18(%ebp),%eax
  8004bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004c7:	77 55                	ja     80051e <printnum+0x75>
  8004c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004cc:	72 05                	jb     8004d3 <printnum+0x2a>
  8004ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004d1:	77 4b                	ja     80051e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004d6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004d9:	8b 45 18             	mov    0x18(%ebp),%eax
  8004dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e1:	52                   	push   %edx
  8004e2:	50                   	push   %eax
  8004e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8004e9:	e8 26 32 00 00       	call   803714 <__udivdi3>
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	ff 75 20             	pushl  0x20(%ebp)
  8004f7:	53                   	push   %ebx
  8004f8:	ff 75 18             	pushl  0x18(%ebp)
  8004fb:	52                   	push   %edx
  8004fc:	50                   	push   %eax
  8004fd:	ff 75 0c             	pushl  0xc(%ebp)
  800500:	ff 75 08             	pushl  0x8(%ebp)
  800503:	e8 a1 ff ff ff       	call   8004a9 <printnum>
  800508:	83 c4 20             	add    $0x20,%esp
  80050b:	eb 1a                	jmp    800527 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	ff 75 0c             	pushl  0xc(%ebp)
  800513:	ff 75 20             	pushl  0x20(%ebp)
  800516:	8b 45 08             	mov    0x8(%ebp),%eax
  800519:	ff d0                	call   *%eax
  80051b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051e:	ff 4d 1c             	decl   0x1c(%ebp)
  800521:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800525:	7f e6                	jg     80050d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800527:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80052a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80052f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800535:	53                   	push   %ebx
  800536:	51                   	push   %ecx
  800537:	52                   	push   %edx
  800538:	50                   	push   %eax
  800539:	e8 e6 32 00 00       	call   803824 <__umoddi3>
  80053e:	83 c4 10             	add    $0x10,%esp
  800541:	05 34 3d 80 00       	add    $0x803d34,%eax
  800546:	8a 00                	mov    (%eax),%al
  800548:	0f be c0             	movsbl %al,%eax
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	ff 75 0c             	pushl  0xc(%ebp)
  800551:	50                   	push   %eax
  800552:	8b 45 08             	mov    0x8(%ebp),%eax
  800555:	ff d0                	call   *%eax
  800557:	83 c4 10             	add    $0x10,%esp
}
  80055a:	90                   	nop
  80055b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800563:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800567:	7e 1c                	jle    800585 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	8d 50 08             	lea    0x8(%eax),%edx
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	89 10                	mov    %edx,(%eax)
  800576:	8b 45 08             	mov    0x8(%ebp),%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	83 e8 08             	sub    $0x8,%eax
  80057e:	8b 50 04             	mov    0x4(%eax),%edx
  800581:	8b 00                	mov    (%eax),%eax
  800583:	eb 40                	jmp    8005c5 <getuint+0x65>
	else if (lflag)
  800585:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800589:	74 1e                	je     8005a9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80058b:	8b 45 08             	mov    0x8(%ebp),%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	8d 50 04             	lea    0x4(%eax),%edx
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	89 10                	mov    %edx,(%eax)
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	83 e8 04             	sub    $0x4,%eax
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a7:	eb 1c                	jmp    8005c5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	8d 50 04             	lea    0x4(%eax),%edx
  8005b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b4:	89 10                	mov    %edx,(%eax)
  8005b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	83 e8 04             	sub    $0x4,%eax
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005c5:	5d                   	pop    %ebp
  8005c6:	c3                   	ret    

008005c7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005ca:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005ce:	7e 1c                	jle    8005ec <getint+0x25>
		return va_arg(*ap, long long);
  8005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d3:	8b 00                	mov    (%eax),%eax
  8005d5:	8d 50 08             	lea    0x8(%eax),%edx
  8005d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005db:	89 10                	mov    %edx,(%eax)
  8005dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	83 e8 08             	sub    $0x8,%eax
  8005e5:	8b 50 04             	mov    0x4(%eax),%edx
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	eb 38                	jmp    800624 <getint+0x5d>
	else if (lflag)
  8005ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005f0:	74 1a                	je     80060c <getint+0x45>
		return va_arg(*ap, long);
  8005f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	8d 50 04             	lea    0x4(%eax),%edx
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	89 10                	mov    %edx,(%eax)
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	83 e8 04             	sub    $0x4,%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	99                   	cltd   
  80060a:	eb 18                	jmp    800624 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80060c:	8b 45 08             	mov    0x8(%ebp),%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	8d 50 04             	lea    0x4(%eax),%edx
  800614:	8b 45 08             	mov    0x8(%ebp),%eax
  800617:	89 10                	mov    %edx,(%eax)
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	8b 00                	mov    (%eax),%eax
  80061e:	83 e8 04             	sub    $0x4,%eax
  800621:	8b 00                	mov    (%eax),%eax
  800623:	99                   	cltd   
}
  800624:	5d                   	pop    %ebp
  800625:	c3                   	ret    

00800626 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	56                   	push   %esi
  80062a:	53                   	push   %ebx
  80062b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80062e:	eb 17                	jmp    800647 <vprintfmt+0x21>
			if (ch == '\0')
  800630:	85 db                	test   %ebx,%ebx
  800632:	0f 84 c1 03 00 00    	je     8009f9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 0c             	pushl  0xc(%ebp)
  80063e:	53                   	push   %ebx
  80063f:	8b 45 08             	mov    0x8(%ebp),%eax
  800642:	ff d0                	call   *%eax
  800644:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800647:	8b 45 10             	mov    0x10(%ebp),%eax
  80064a:	8d 50 01             	lea    0x1(%eax),%edx
  80064d:	89 55 10             	mov    %edx,0x10(%ebp)
  800650:	8a 00                	mov    (%eax),%al
  800652:	0f b6 d8             	movzbl %al,%ebx
  800655:	83 fb 25             	cmp    $0x25,%ebx
  800658:	75 d6                	jne    800630 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80065a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80065e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800665:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80066c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800673:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067a:	8b 45 10             	mov    0x10(%ebp),%eax
  80067d:	8d 50 01             	lea    0x1(%eax),%edx
  800680:	89 55 10             	mov    %edx,0x10(%ebp)
  800683:	8a 00                	mov    (%eax),%al
  800685:	0f b6 d8             	movzbl %al,%ebx
  800688:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80068b:	83 f8 5b             	cmp    $0x5b,%eax
  80068e:	0f 87 3d 03 00 00    	ja     8009d1 <vprintfmt+0x3ab>
  800694:	8b 04 85 58 3d 80 00 	mov    0x803d58(,%eax,4),%eax
  80069b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80069d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006a1:	eb d7                	jmp    80067a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006a3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006a7:	eb d1                	jmp    80067a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006b3:	89 d0                	mov    %edx,%eax
  8006b5:	c1 e0 02             	shl    $0x2,%eax
  8006b8:	01 d0                	add    %edx,%eax
  8006ba:	01 c0                	add    %eax,%eax
  8006bc:	01 d8                	add    %ebx,%eax
  8006be:	83 e8 30             	sub    $0x30,%eax
  8006c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c7:	8a 00                	mov    (%eax),%al
  8006c9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006cc:	83 fb 2f             	cmp    $0x2f,%ebx
  8006cf:	7e 3e                	jle    80070f <vprintfmt+0xe9>
  8006d1:	83 fb 39             	cmp    $0x39,%ebx
  8006d4:	7f 39                	jg     80070f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006d6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006d9:	eb d5                	jmp    8006b0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	83 c0 04             	add    $0x4,%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	83 e8 04             	sub    $0x4,%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006ef:	eb 1f                	jmp    800710 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f5:	79 83                	jns    80067a <vprintfmt+0x54>
				width = 0;
  8006f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006fe:	e9 77 ff ff ff       	jmp    80067a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800703:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80070a:	e9 6b ff ff ff       	jmp    80067a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80070f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800710:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800714:	0f 89 60 ff ff ff    	jns    80067a <vprintfmt+0x54>
				width = precision, precision = -1;
  80071a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800720:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800727:	e9 4e ff ff ff       	jmp    80067a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80072c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80072f:	e9 46 ff ff ff       	jmp    80067a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	83 c0 04             	add    $0x4,%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	83 e8 04             	sub    $0x4,%eax
  800743:	8b 00                	mov    (%eax),%eax
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	ff 75 0c             	pushl  0xc(%ebp)
  80074b:	50                   	push   %eax
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	ff d0                	call   *%eax
  800751:	83 c4 10             	add    $0x10,%esp
			break;
  800754:	e9 9b 02 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	83 c0 04             	add    $0x4,%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	83 e8 04             	sub    $0x4,%eax
  800768:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80076a:	85 db                	test   %ebx,%ebx
  80076c:	79 02                	jns    800770 <vprintfmt+0x14a>
				err = -err;
  80076e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800770:	83 fb 64             	cmp    $0x64,%ebx
  800773:	7f 0b                	jg     800780 <vprintfmt+0x15a>
  800775:	8b 34 9d a0 3b 80 00 	mov    0x803ba0(,%ebx,4),%esi
  80077c:	85 f6                	test   %esi,%esi
  80077e:	75 19                	jne    800799 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800780:	53                   	push   %ebx
  800781:	68 45 3d 80 00       	push   $0x803d45
  800786:	ff 75 0c             	pushl  0xc(%ebp)
  800789:	ff 75 08             	pushl  0x8(%ebp)
  80078c:	e8 70 02 00 00       	call   800a01 <printfmt>
  800791:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800794:	e9 5b 02 00 00       	jmp    8009f4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800799:	56                   	push   %esi
  80079a:	68 4e 3d 80 00       	push   $0x803d4e
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	ff 75 08             	pushl  0x8(%ebp)
  8007a5:	e8 57 02 00 00       	call   800a01 <printfmt>
  8007aa:	83 c4 10             	add    $0x10,%esp
			break;
  8007ad:	e9 42 02 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	83 c0 04             	add    $0x4,%eax
  8007b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	83 e8 04             	sub    $0x4,%eax
  8007c1:	8b 30                	mov    (%eax),%esi
  8007c3:	85 f6                	test   %esi,%esi
  8007c5:	75 05                	jne    8007cc <vprintfmt+0x1a6>
				p = "(null)";
  8007c7:	be 51 3d 80 00       	mov    $0x803d51,%esi
			if (width > 0 && padc != '-')
  8007cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d0:	7e 6d                	jle    80083f <vprintfmt+0x219>
  8007d2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007d6:	74 67                	je     80083f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	50                   	push   %eax
  8007df:	56                   	push   %esi
  8007e0:	e8 26 05 00 00       	call   800d0b <strnlen>
  8007e5:	83 c4 10             	add    $0x10,%esp
  8007e8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007eb:	eb 16                	jmp    800803 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007ed:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 0c             	pushl  0xc(%ebp)
  8007f7:	50                   	push   %eax
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	ff d0                	call   *%eax
  8007fd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800800:	ff 4d e4             	decl   -0x1c(%ebp)
  800803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800807:	7f e4                	jg     8007ed <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800809:	eb 34                	jmp    80083f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80080b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80080f:	74 1c                	je     80082d <vprintfmt+0x207>
  800811:	83 fb 1f             	cmp    $0x1f,%ebx
  800814:	7e 05                	jle    80081b <vprintfmt+0x1f5>
  800816:	83 fb 7e             	cmp    $0x7e,%ebx
  800819:	7e 12                	jle    80082d <vprintfmt+0x207>
					putch('?', putdat);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	ff 75 0c             	pushl  0xc(%ebp)
  800821:	6a 3f                	push   $0x3f
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	ff d0                	call   *%eax
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	eb 0f                	jmp    80083c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	53                   	push   %ebx
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	ff d0                	call   *%eax
  800839:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80083c:	ff 4d e4             	decl   -0x1c(%ebp)
  80083f:	89 f0                	mov    %esi,%eax
  800841:	8d 70 01             	lea    0x1(%eax),%esi
  800844:	8a 00                	mov    (%eax),%al
  800846:	0f be d8             	movsbl %al,%ebx
  800849:	85 db                	test   %ebx,%ebx
  80084b:	74 24                	je     800871 <vprintfmt+0x24b>
  80084d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800851:	78 b8                	js     80080b <vprintfmt+0x1e5>
  800853:	ff 4d e0             	decl   -0x20(%ebp)
  800856:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085a:	79 af                	jns    80080b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80085c:	eb 13                	jmp    800871 <vprintfmt+0x24b>
				putch(' ', putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	6a 20                	push   $0x20
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086e:	ff 4d e4             	decl   -0x1c(%ebp)
  800871:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800875:	7f e7                	jg     80085e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800877:	e9 78 01 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	ff 75 e8             	pushl  -0x18(%ebp)
  800882:	8d 45 14             	lea    0x14(%ebp),%eax
  800885:	50                   	push   %eax
  800886:	e8 3c fd ff ff       	call   8005c7 <getint>
  80088b:	83 c4 10             	add    $0x10,%esp
  80088e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800891:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800897:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089a:	85 d2                	test   %edx,%edx
  80089c:	79 23                	jns    8008c1 <vprintfmt+0x29b>
				putch('-', putdat);
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	6a 2d                	push   $0x2d
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	ff d0                	call   *%eax
  8008ab:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b4:	f7 d8                	neg    %eax
  8008b6:	83 d2 00             	adc    $0x0,%edx
  8008b9:	f7 da                	neg    %edx
  8008bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008c1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008c8:	e9 bc 00 00 00       	jmp    800989 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008cd:	83 ec 08             	sub    $0x8,%esp
  8008d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8008d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d6:	50                   	push   %eax
  8008d7:	e8 84 fc ff ff       	call   800560 <getuint>
  8008dc:	83 c4 10             	add    $0x10,%esp
  8008df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008e5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ec:	e9 98 00 00 00       	jmp    800989 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	ff 75 0c             	pushl  0xc(%ebp)
  8008f7:	6a 58                	push   $0x58
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	ff d0                	call   *%eax
  8008fe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800901:	83 ec 08             	sub    $0x8,%esp
  800904:	ff 75 0c             	pushl  0xc(%ebp)
  800907:	6a 58                	push   $0x58
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	ff d0                	call   *%eax
  80090e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	6a 58                	push   $0x58
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	ff d0                	call   *%eax
  80091e:	83 c4 10             	add    $0x10,%esp
			break;
  800921:	e9 ce 00 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800926:	83 ec 08             	sub    $0x8,%esp
  800929:	ff 75 0c             	pushl  0xc(%ebp)
  80092c:	6a 30                	push   $0x30
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	6a 78                	push   $0x78
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	ff d0                	call   *%eax
  800943:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	83 c0 04             	add    $0x4,%eax
  80094c:	89 45 14             	mov    %eax,0x14(%ebp)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	83 e8 04             	sub    $0x4,%eax
  800955:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800957:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800961:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800968:	eb 1f                	jmp    800989 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80096a:	83 ec 08             	sub    $0x8,%esp
  80096d:	ff 75 e8             	pushl  -0x18(%ebp)
  800970:	8d 45 14             	lea    0x14(%ebp),%eax
  800973:	50                   	push   %eax
  800974:	e8 e7 fb ff ff       	call   800560 <getuint>
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800982:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800989:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80098d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800990:	83 ec 04             	sub    $0x4,%esp
  800993:	52                   	push   %edx
  800994:	ff 75 e4             	pushl  -0x1c(%ebp)
  800997:	50                   	push   %eax
  800998:	ff 75 f4             	pushl  -0xc(%ebp)
  80099b:	ff 75 f0             	pushl  -0x10(%ebp)
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	ff 75 08             	pushl  0x8(%ebp)
  8009a4:	e8 00 fb ff ff       	call   8004a9 <printnum>
  8009a9:	83 c4 20             	add    $0x20,%esp
			break;
  8009ac:	eb 46                	jmp    8009f4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 0c             	pushl  0xc(%ebp)
  8009b4:	53                   	push   %ebx
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	ff d0                	call   *%eax
  8009ba:	83 c4 10             	add    $0x10,%esp
			break;
  8009bd:	eb 35                	jmp    8009f4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009bf:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  8009c6:	eb 2c                	jmp    8009f4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009c8:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  8009cf:	eb 23                	jmp    8009f4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009d1:	83 ec 08             	sub    $0x8,%esp
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	6a 25                	push   $0x25
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	ff d0                	call   *%eax
  8009de:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e1:	ff 4d 10             	decl   0x10(%ebp)
  8009e4:	eb 03                	jmp    8009e9 <vprintfmt+0x3c3>
  8009e6:	ff 4d 10             	decl   0x10(%ebp)
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	48                   	dec    %eax
  8009ed:	8a 00                	mov    (%eax),%al
  8009ef:	3c 25                	cmp    $0x25,%al
  8009f1:	75 f3                	jne    8009e6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009f3:	90                   	nop
		}
	}
  8009f4:	e9 35 fc ff ff       	jmp    80062e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009f9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009fd:	5b                   	pop    %ebx
  8009fe:	5e                   	pop    %esi
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a07:	8d 45 10             	lea    0x10(%ebp),%eax
  800a0a:	83 c0 04             	add    $0x4,%eax
  800a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a10:	8b 45 10             	mov    0x10(%ebp),%eax
  800a13:	ff 75 f4             	pushl  -0xc(%ebp)
  800a16:	50                   	push   %eax
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	ff 75 08             	pushl  0x8(%ebp)
  800a1d:	e8 04 fc ff ff       	call   800626 <vprintfmt>
  800a22:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a25:	90                   	nop
  800a26:	c9                   	leave  
  800a27:	c3                   	ret    

00800a28 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2e:	8b 40 08             	mov    0x8(%eax),%eax
  800a31:	8d 50 01             	lea    0x1(%eax),%edx
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3d:	8b 10                	mov    (%eax),%edx
  800a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a42:	8b 40 04             	mov    0x4(%eax),%eax
  800a45:	39 c2                	cmp    %eax,%edx
  800a47:	73 12                	jae    800a5b <sprintputch+0x33>
		*b->buf++ = ch;
  800a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4c:	8b 00                	mov    (%eax),%eax
  800a4e:	8d 48 01             	lea    0x1(%eax),%ecx
  800a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a54:	89 0a                	mov    %ecx,(%edx)
  800a56:	8b 55 08             	mov    0x8(%ebp),%edx
  800a59:	88 10                	mov    %dl,(%eax)
}
  800a5b:	90                   	nop
  800a5c:	5d                   	pop    %ebp
  800a5d:	c3                   	ret    

00800a5e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
  800a61:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	01 d0                	add    %edx,%eax
  800a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a83:	74 06                	je     800a8b <vsnprintf+0x2d>
  800a85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a89:	7f 07                	jg     800a92 <vsnprintf+0x34>
		return -E_INVAL;
  800a8b:	b8 03 00 00 00       	mov    $0x3,%eax
  800a90:	eb 20                	jmp    800ab2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a92:	ff 75 14             	pushl  0x14(%ebp)
  800a95:	ff 75 10             	pushl  0x10(%ebp)
  800a98:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a9b:	50                   	push   %eax
  800a9c:	68 28 0a 80 00       	push   $0x800a28
  800aa1:	e8 80 fb ff ff       	call   800626 <vprintfmt>
  800aa6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ab2:	c9                   	leave  
  800ab3:	c3                   	ret    

00800ab4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aba:	8d 45 10             	lea    0x10(%ebp),%eax
  800abd:	83 c0 04             	add    $0x4,%eax
  800ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ac3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac9:	50                   	push   %eax
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	ff 75 08             	pushl  0x8(%ebp)
  800ad0:	e8 89 ff ff ff       	call   800a5e <vsnprintf>
  800ad5:	83 c4 10             	add    $0x10,%esp
  800ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ade:	c9                   	leave  
  800adf:	c3                   	ret    

00800ae0 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800ae6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aea:	74 13                	je     800aff <readline+0x1f>
		cprintf("%s", prompt);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 08             	pushl  0x8(%ebp)
  800af2:	68 c8 3e 80 00       	push   $0x803ec8
  800af7:	e8 0b f9 ff ff       	call   800407 <cprintf>
  800afc:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800aff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800b06:	83 ec 0c             	sub    $0xc,%esp
  800b09:	6a 00                	push   $0x0
  800b0b:	e8 ea 29 00 00       	call   8034fa <iscons>
  800b10:	83 c4 10             	add    $0x10,%esp
  800b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800b16:	e8 cc 29 00 00       	call   8034e7 <getchar>
  800b1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800b1e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b22:	79 22                	jns    800b46 <readline+0x66>
			if (c != -E_EOF)
  800b24:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800b28:	0f 84 ad 00 00 00    	je     800bdb <readline+0xfb>
				cprintf("read error: %e\n", c);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 ec             	pushl  -0x14(%ebp)
  800b34:	68 cb 3e 80 00       	push   $0x803ecb
  800b39:	e8 c9 f8 ff ff       	call   800407 <cprintf>
  800b3e:	83 c4 10             	add    $0x10,%esp
			break;
  800b41:	e9 95 00 00 00       	jmp    800bdb <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800b46:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b4a:	7e 34                	jle    800b80 <readline+0xa0>
  800b4c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b53:	7f 2b                	jg     800b80 <readline+0xa0>
			if (echoing)
  800b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b59:	74 0e                	je     800b69 <readline+0x89>
				cputchar(c);
  800b5b:	83 ec 0c             	sub    $0xc,%esp
  800b5e:	ff 75 ec             	pushl  -0x14(%ebp)
  800b61:	e8 62 29 00 00       	call   8034c8 <cputchar>
  800b66:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b6c:	8d 50 01             	lea    0x1(%eax),%edx
  800b6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b72:	89 c2                	mov    %eax,%edx
  800b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b77:	01 d0                	add    %edx,%eax
  800b79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b7c:	88 10                	mov    %dl,(%eax)
  800b7e:	eb 56                	jmp    800bd6 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800b80:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b84:	75 1f                	jne    800ba5 <readline+0xc5>
  800b86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b8a:	7e 19                	jle    800ba5 <readline+0xc5>
			if (echoing)
  800b8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b90:	74 0e                	je     800ba0 <readline+0xc0>
				cputchar(c);
  800b92:	83 ec 0c             	sub    $0xc,%esp
  800b95:	ff 75 ec             	pushl  -0x14(%ebp)
  800b98:	e8 2b 29 00 00       	call   8034c8 <cputchar>
  800b9d:	83 c4 10             	add    $0x10,%esp

			i--;
  800ba0:	ff 4d f4             	decl   -0xc(%ebp)
  800ba3:	eb 31                	jmp    800bd6 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800ba5:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ba9:	74 0a                	je     800bb5 <readline+0xd5>
  800bab:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800baf:	0f 85 61 ff ff ff    	jne    800b16 <readline+0x36>
			if (echoing)
  800bb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bb9:	74 0e                	je     800bc9 <readline+0xe9>
				cputchar(c);
  800bbb:	83 ec 0c             	sub    $0xc,%esp
  800bbe:	ff 75 ec             	pushl  -0x14(%ebp)
  800bc1:	e8 02 29 00 00       	call   8034c8 <cputchar>
  800bc6:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800bc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcf:	01 d0                	add    %edx,%eax
  800bd1:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800bd4:	eb 06                	jmp    800bdc <readline+0xfc>
		}
	}
  800bd6:	e9 3b ff ff ff       	jmp    800b16 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800bdb:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800bdc:	90                   	nop
  800bdd:	c9                   	leave  
  800bde:	c3                   	ret    

00800bdf <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800be5:	e8 81 16 00 00       	call   80226b <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800bea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bee:	74 13                	je     800c03 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800bf0:	83 ec 08             	sub    $0x8,%esp
  800bf3:	ff 75 08             	pushl  0x8(%ebp)
  800bf6:	68 c8 3e 80 00       	push   $0x803ec8
  800bfb:	e8 07 f8 ff ff       	call   800407 <cprintf>
  800c00:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800c03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800c0a:	83 ec 0c             	sub    $0xc,%esp
  800c0d:	6a 00                	push   $0x0
  800c0f:	e8 e6 28 00 00       	call   8034fa <iscons>
  800c14:	83 c4 10             	add    $0x10,%esp
  800c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800c1a:	e8 c8 28 00 00       	call   8034e7 <getchar>
  800c1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800c22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c26:	79 22                	jns    800c4a <atomic_readline+0x6b>
				if (c != -E_EOF)
  800c28:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800c2c:	0f 84 ad 00 00 00    	je     800cdf <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 ec             	pushl  -0x14(%ebp)
  800c38:	68 cb 3e 80 00       	push   $0x803ecb
  800c3d:	e8 c5 f7 ff ff       	call   800407 <cprintf>
  800c42:	83 c4 10             	add    $0x10,%esp
				break;
  800c45:	e9 95 00 00 00       	jmp    800cdf <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800c4a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800c4e:	7e 34                	jle    800c84 <atomic_readline+0xa5>
  800c50:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800c57:	7f 2b                	jg     800c84 <atomic_readline+0xa5>
				if (echoing)
  800c59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c5d:	74 0e                	je     800c6d <atomic_readline+0x8e>
					cputchar(c);
  800c5f:	83 ec 0c             	sub    $0xc,%esp
  800c62:	ff 75 ec             	pushl  -0x14(%ebp)
  800c65:	e8 5e 28 00 00       	call   8034c8 <cputchar>
  800c6a:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c70:	8d 50 01             	lea    0x1(%eax),%edx
  800c73:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800c76:	89 c2                	mov    %eax,%edx
  800c78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7b:	01 d0                	add    %edx,%eax
  800c7d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800c80:	88 10                	mov    %dl,(%eax)
  800c82:	eb 56                	jmp    800cda <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800c84:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800c88:	75 1f                	jne    800ca9 <atomic_readline+0xca>
  800c8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c8e:	7e 19                	jle    800ca9 <atomic_readline+0xca>
				if (echoing)
  800c90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c94:	74 0e                	je     800ca4 <atomic_readline+0xc5>
					cputchar(c);
  800c96:	83 ec 0c             	sub    $0xc,%esp
  800c99:	ff 75 ec             	pushl  -0x14(%ebp)
  800c9c:	e8 27 28 00 00       	call   8034c8 <cputchar>
  800ca1:	83 c4 10             	add    $0x10,%esp
				i--;
  800ca4:	ff 4d f4             	decl   -0xc(%ebp)
  800ca7:	eb 31                	jmp    800cda <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800ca9:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800cad:	74 0a                	je     800cb9 <atomic_readline+0xda>
  800caf:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800cb3:	0f 85 61 ff ff ff    	jne    800c1a <atomic_readline+0x3b>
				if (echoing)
  800cb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cbd:	74 0e                	je     800ccd <atomic_readline+0xee>
					cputchar(c);
  800cbf:	83 ec 0c             	sub    $0xc,%esp
  800cc2:	ff 75 ec             	pushl  -0x14(%ebp)
  800cc5:	e8 fe 27 00 00       	call   8034c8 <cputchar>
  800cca:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd3:	01 d0                	add    %edx,%eax
  800cd5:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800cd8:	eb 06                	jmp    800ce0 <atomic_readline+0x101>
			}
		}
  800cda:	e9 3b ff ff ff       	jmp    800c1a <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800cdf:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800ce0:	e8 a0 15 00 00       	call   802285 <sys_unlock_cons>
}
  800ce5:	90                   	nop
  800ce6:	c9                   	leave  
  800ce7:	c3                   	ret    

00800ce8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf5:	eb 06                	jmp    800cfd <strlen+0x15>
		n++;
  800cf7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cfa:	ff 45 08             	incl   0x8(%ebp)
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	84 c0                	test   %al,%al
  800d04:	75 f1                	jne    800cf7 <strlen+0xf>
		n++;
	return n;
  800d06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d09:	c9                   	leave  
  800d0a:	c3                   	ret    

00800d0b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d18:	eb 09                	jmp    800d23 <strnlen+0x18>
		n++;
  800d1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d1d:	ff 45 08             	incl   0x8(%ebp)
  800d20:	ff 4d 0c             	decl   0xc(%ebp)
  800d23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d27:	74 09                	je     800d32 <strnlen+0x27>
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	84 c0                	test   %al,%al
  800d30:	75 e8                	jne    800d1a <strnlen+0xf>
		n++;
	return n;
  800d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d35:	c9                   	leave  
  800d36:	c3                   	ret    

00800d37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d43:	90                   	nop
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8d 50 01             	lea    0x1(%eax),%edx
  800d4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d56:	8a 12                	mov    (%edx),%dl
  800d58:	88 10                	mov    %dl,(%eax)
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	84 c0                	test   %al,%al
  800d5e:	75 e4                	jne    800d44 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d63:	c9                   	leave  
  800d64:	c3                   	ret    

00800d65 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d78:	eb 1f                	jmp    800d99 <strncpy+0x34>
		*dst++ = *src;
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	8d 50 01             	lea    0x1(%eax),%edx
  800d80:	89 55 08             	mov    %edx,0x8(%ebp)
  800d83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d86:	8a 12                	mov    (%edx),%dl
  800d88:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	74 03                	je     800d96 <strncpy+0x31>
			src++;
  800d93:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d96:	ff 45 fc             	incl   -0x4(%ebp)
  800d99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d9f:	72 d9                	jb     800d7a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800da1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800db2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db6:	74 30                	je     800de8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800db8:	eb 16                	jmp    800dd0 <strlcpy+0x2a>
			*dst++ = *src++;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8d 50 01             	lea    0x1(%eax),%edx
  800dc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dcc:	8a 12                	mov    (%edx),%dl
  800dce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dd0:	ff 4d 10             	decl   0x10(%ebp)
  800dd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd7:	74 09                	je     800de2 <strlcpy+0x3c>
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	84 c0                	test   %al,%al
  800de0:	75 d8                	jne    800dba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dee:	29 c2                	sub    %eax,%edx
  800df0:	89 d0                	mov    %edx,%eax
}
  800df2:	c9                   	leave  
  800df3:	c3                   	ret    

00800df4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800df7:	eb 06                	jmp    800dff <strcmp+0xb>
		p++, q++;
  800df9:	ff 45 08             	incl   0x8(%ebp)
  800dfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	84 c0                	test   %al,%al
  800e06:	74 0e                	je     800e16 <strcmp+0x22>
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8a 10                	mov    (%eax),%dl
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	38 c2                	cmp    %al,%dl
  800e14:	74 e3                	je     800df9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8a 00                	mov    (%eax),%al
  800e1b:	0f b6 d0             	movzbl %al,%edx
  800e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	0f b6 c0             	movzbl %al,%eax
  800e26:	29 c2                	sub    %eax,%edx
  800e28:	89 d0                	mov    %edx,%eax
}
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e2f:	eb 09                	jmp    800e3a <strncmp+0xe>
		n--, p++, q++;
  800e31:	ff 4d 10             	decl   0x10(%ebp)
  800e34:	ff 45 08             	incl   0x8(%ebp)
  800e37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3e:	74 17                	je     800e57 <strncmp+0x2b>
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	84 c0                	test   %al,%al
  800e47:	74 0e                	je     800e57 <strncmp+0x2b>
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 10                	mov    (%eax),%dl
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	38 c2                	cmp    %al,%dl
  800e55:	74 da                	je     800e31 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5b:	75 07                	jne    800e64 <strncmp+0x38>
		return 0;
  800e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e62:	eb 14                	jmp    800e78 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8a 00                	mov    (%eax),%al
  800e69:	0f b6 d0             	movzbl %al,%edx
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	0f b6 c0             	movzbl %al,%eax
  800e74:	29 c2                	sub    %eax,%edx
  800e76:	89 d0                	mov    %edx,%eax
}
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 04             	sub    $0x4,%esp
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e86:	eb 12                	jmp    800e9a <strchr+0x20>
		if (*s == c)
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e90:	75 05                	jne    800e97 <strchr+0x1d>
			return (char *) s;
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	eb 11                	jmp    800ea8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e97:	ff 45 08             	incl   0x8(%ebp)
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	84 c0                	test   %al,%al
  800ea1:	75 e5                	jne    800e88 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ea3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 04             	sub    $0x4,%esp
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eb6:	eb 0d                	jmp    800ec5 <strfind+0x1b>
		if (*s == c)
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ec0:	74 0e                	je     800ed0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ec2:	ff 45 08             	incl   0x8(%ebp)
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	8a 00                	mov    (%eax),%al
  800eca:	84 c0                	test   %al,%al
  800ecc:	75 ea                	jne    800eb8 <strfind+0xe>
  800ece:	eb 01                	jmp    800ed1 <strfind+0x27>
		if (*s == c)
			break;
  800ed0:	90                   	nop
	return (char *) s;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed4:	c9                   	leave  
  800ed5:	c3                   	ret    

00800ed6 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ee2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ee6:	76 63                	jbe    800f4b <memset+0x75>
		uint64 data_block = c;
  800ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eeb:	99                   	cltd   
  800eec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eef:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef8:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800efc:	c1 e0 08             	shl    $0x8,%eax
  800eff:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f02:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f0f:	c1 e0 10             	shl    $0x10,%eax
  800f12:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f15:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1e:	89 c2                	mov    %eax,%edx
  800f20:	b8 00 00 00 00       	mov    $0x0,%eax
  800f25:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f28:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f2b:	eb 18                	jmp    800f45 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f2d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f30:	8d 41 08             	lea    0x8(%ecx),%eax
  800f33:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3c:	89 01                	mov    %eax,(%ecx)
  800f3e:	89 51 04             	mov    %edx,0x4(%ecx)
  800f41:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f45:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f49:	77 e2                	ja     800f2d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4f:	74 23                	je     800f74 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f54:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f57:	eb 0e                	jmp    800f67 <memset+0x91>
			*p8++ = (uint8)c;
  800f59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5c:	8d 50 01             	lea    0x1(%eax),%edx
  800f5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f65:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f67:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f70:	85 c0                	test   %eax,%eax
  800f72:	75 e5                	jne    800f59 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f77:	c9                   	leave  
  800f78:	c3                   	ret    

00800f79 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f8b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f8f:	76 24                	jbe    800fb5 <memcpy+0x3c>
		while(n >= 8){
  800f91:	eb 1c                	jmp    800faf <memcpy+0x36>
			*d64 = *s64;
  800f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f96:	8b 50 04             	mov    0x4(%eax),%edx
  800f99:	8b 00                	mov    (%eax),%eax
  800f9b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f9e:	89 01                	mov    %eax,(%ecx)
  800fa0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800fa3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800fa7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800fab:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800faf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fb3:	77 de                	ja     800f93 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800fb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb9:	74 31                	je     800fec <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800fc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800fc7:	eb 16                	jmp    800fdf <memcpy+0x66>
			*d8++ = *s8++;
  800fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fcc:	8d 50 01             	lea    0x1(%eax),%edx
  800fcf:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800fd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fd8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fdb:	8a 12                	mov    (%edx),%dl
  800fdd:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	75 dd                	jne    800fc9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801003:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801006:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801009:	73 50                	jae    80105b <memmove+0x6a>
  80100b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100e:	8b 45 10             	mov    0x10(%ebp),%eax
  801011:	01 d0                	add    %edx,%eax
  801013:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801016:	76 43                	jbe    80105b <memmove+0x6a>
		s += n;
  801018:	8b 45 10             	mov    0x10(%ebp),%eax
  80101b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80101e:	8b 45 10             	mov    0x10(%ebp),%eax
  801021:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801024:	eb 10                	jmp    801036 <memmove+0x45>
			*--d = *--s;
  801026:	ff 4d f8             	decl   -0x8(%ebp)
  801029:	ff 4d fc             	decl   -0x4(%ebp)
  80102c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102f:	8a 10                	mov    (%eax),%dl
  801031:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801034:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103c:	89 55 10             	mov    %edx,0x10(%ebp)
  80103f:	85 c0                	test   %eax,%eax
  801041:	75 e3                	jne    801026 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801043:	eb 23                	jmp    801068 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801045:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801048:	8d 50 01             	lea    0x1(%eax),%edx
  80104b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80104e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801051:	8d 4a 01             	lea    0x1(%edx),%ecx
  801054:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801057:	8a 12                	mov    (%edx),%dl
  801059:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801061:	89 55 10             	mov    %edx,0x10(%ebp)
  801064:	85 c0                	test   %eax,%eax
  801066:	75 dd                	jne    801045 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106b:	c9                   	leave  
  80106c:	c3                   	ret    

0080106d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801079:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80107f:	eb 2a                	jmp    8010ab <memcmp+0x3e>
		if (*s1 != *s2)
  801081:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801084:	8a 10                	mov    (%eax),%dl
  801086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	38 c2                	cmp    %al,%dl
  80108d:	74 16                	je     8010a5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80108f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	0f b6 d0             	movzbl %al,%edx
  801097:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	0f b6 c0             	movzbl %al,%eax
  80109f:	29 c2                	sub    %eax,%edx
  8010a1:	89 d0                	mov    %edx,%eax
  8010a3:	eb 18                	jmp    8010bd <memcmp+0x50>
		s1++, s2++;
  8010a5:	ff 45 fc             	incl   -0x4(%ebp)
  8010a8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	75 c9                	jne    801081 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    

008010bf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	01 d0                	add    %edx,%eax
  8010cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010d0:	eb 15                	jmp    8010e7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	0f b6 d0             	movzbl %al,%edx
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	0f b6 c0             	movzbl %al,%eax
  8010e0:	39 c2                	cmp    %eax,%edx
  8010e2:	74 0d                	je     8010f1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010e4:	ff 45 08             	incl   0x8(%ebp)
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010ed:	72 e3                	jb     8010d2 <memfind+0x13>
  8010ef:	eb 01                	jmp    8010f2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010f1:	90                   	nop
	return (void *) s;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801104:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80110b:	eb 03                	jmp    801110 <strtol+0x19>
		s++;
  80110d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	3c 20                	cmp    $0x20,%al
  801117:	74 f4                	je     80110d <strtol+0x16>
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	3c 09                	cmp    $0x9,%al
  801120:	74 eb                	je     80110d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	3c 2b                	cmp    $0x2b,%al
  801129:	75 05                	jne    801130 <strtol+0x39>
		s++;
  80112b:	ff 45 08             	incl   0x8(%ebp)
  80112e:	eb 13                	jmp    801143 <strtol+0x4c>
	else if (*s == '-')
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 2d                	cmp    $0x2d,%al
  801137:	75 0a                	jne    801143 <strtol+0x4c>
		s++, neg = 1;
  801139:	ff 45 08             	incl   0x8(%ebp)
  80113c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801143:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801147:	74 06                	je     80114f <strtol+0x58>
  801149:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80114d:	75 20                	jne    80116f <strtol+0x78>
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	3c 30                	cmp    $0x30,%al
  801156:	75 17                	jne    80116f <strtol+0x78>
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	40                   	inc    %eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	3c 78                	cmp    $0x78,%al
  801160:	75 0d                	jne    80116f <strtol+0x78>
		s += 2, base = 16;
  801162:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801166:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80116d:	eb 28                	jmp    801197 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80116f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801173:	75 15                	jne    80118a <strtol+0x93>
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	3c 30                	cmp    $0x30,%al
  80117c:	75 0c                	jne    80118a <strtol+0x93>
		s++, base = 8;
  80117e:	ff 45 08             	incl   0x8(%ebp)
  801181:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801188:	eb 0d                	jmp    801197 <strtol+0xa0>
	else if (base == 0)
  80118a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118e:	75 07                	jne    801197 <strtol+0xa0>
		base = 10;
  801190:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 2f                	cmp    $0x2f,%al
  80119e:	7e 19                	jle    8011b9 <strtol+0xc2>
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	3c 39                	cmp    $0x39,%al
  8011a7:	7f 10                	jg     8011b9 <strtol+0xc2>
			dig = *s - '0';
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	0f be c0             	movsbl %al,%eax
  8011b1:	83 e8 30             	sub    $0x30,%eax
  8011b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011b7:	eb 42                	jmp    8011fb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	3c 60                	cmp    $0x60,%al
  8011c0:	7e 19                	jle    8011db <strtol+0xe4>
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	3c 7a                	cmp    $0x7a,%al
  8011c9:	7f 10                	jg     8011db <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	0f be c0             	movsbl %al,%eax
  8011d3:	83 e8 57             	sub    $0x57,%eax
  8011d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011d9:	eb 20                	jmp    8011fb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	3c 40                	cmp    $0x40,%al
  8011e2:	7e 39                	jle    80121d <strtol+0x126>
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	3c 5a                	cmp    $0x5a,%al
  8011eb:	7f 30                	jg     80121d <strtol+0x126>
			dig = *s - 'A' + 10;
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f0:	8a 00                	mov    (%eax),%al
  8011f2:	0f be c0             	movsbl %al,%eax
  8011f5:	83 e8 37             	sub    $0x37,%eax
  8011f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011fe:	3b 45 10             	cmp    0x10(%ebp),%eax
  801201:	7d 19                	jge    80121c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801209:	0f af 45 10          	imul   0x10(%ebp),%eax
  80120d:	89 c2                	mov    %eax,%edx
  80120f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801212:	01 d0                	add    %edx,%eax
  801214:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801217:	e9 7b ff ff ff       	jmp    801197 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80121c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80121d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801221:	74 08                	je     80122b <strtol+0x134>
		*endptr = (char *) s;
  801223:	8b 45 0c             	mov    0xc(%ebp),%eax
  801226:	8b 55 08             	mov    0x8(%ebp),%edx
  801229:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80122b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80122f:	74 07                	je     801238 <strtol+0x141>
  801231:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801234:	f7 d8                	neg    %eax
  801236:	eb 03                	jmp    80123b <strtol+0x144>
  801238:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <ltostr>:

void
ltostr(long value, char *str)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80124a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801251:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801255:	79 13                	jns    80126a <ltostr+0x2d>
	{
		neg = 1;
  801257:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80125e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801261:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801264:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801267:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801272:	99                   	cltd   
  801273:	f7 f9                	idiv   %ecx
  801275:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801278:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127b:	8d 50 01             	lea    0x1(%eax),%edx
  80127e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801281:	89 c2                	mov    %eax,%edx
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	01 d0                	add    %edx,%eax
  801288:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80128b:	83 c2 30             	add    $0x30,%edx
  80128e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801290:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801293:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801298:	f7 e9                	imul   %ecx
  80129a:	c1 fa 02             	sar    $0x2,%edx
  80129d:	89 c8                	mov    %ecx,%eax
  80129f:	c1 f8 1f             	sar    $0x1f,%eax
  8012a2:	29 c2                	sub    %eax,%edx
  8012a4:	89 d0                	mov    %edx,%eax
  8012a6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ad:	75 bb                	jne    80126a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b9:	48                   	dec    %eax
  8012ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c1:	74 3d                	je     801300 <ltostr+0xc3>
		start = 1 ;
  8012c3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012ca:	eb 34                	jmp    801300 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d2:	01 d0                	add    %edx,%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	01 c2                	add    %eax,%edx
  8012e1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e7:	01 c8                	add    %ecx,%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f3:	01 c2                	add    %eax,%edx
  8012f5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012f8:	88 02                	mov    %al,(%edx)
		start++ ;
  8012fa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012fd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801303:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801306:	7c c4                	jl     8012cc <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801308:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80130b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130e:	01 d0                	add    %edx,%eax
  801310:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801313:	90                   	nop
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80131c:	ff 75 08             	pushl  0x8(%ebp)
  80131f:	e8 c4 f9 ff ff       	call   800ce8 <strlen>
  801324:	83 c4 04             	add    $0x4,%esp
  801327:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80132a:	ff 75 0c             	pushl  0xc(%ebp)
  80132d:	e8 b6 f9 ff ff       	call   800ce8 <strlen>
  801332:	83 c4 04             	add    $0x4,%esp
  801335:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801338:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80133f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801346:	eb 17                	jmp    80135f <strcconcat+0x49>
		final[s] = str1[s] ;
  801348:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80134b:	8b 45 10             	mov    0x10(%ebp),%eax
  80134e:	01 c2                	add    %eax,%edx
  801350:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	01 c8                	add    %ecx,%eax
  801358:	8a 00                	mov    (%eax),%al
  80135a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80135c:	ff 45 fc             	incl   -0x4(%ebp)
  80135f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801362:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801365:	7c e1                	jl     801348 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801367:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80136e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801375:	eb 1f                	jmp    801396 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801377:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137a:	8d 50 01             	lea    0x1(%eax),%edx
  80137d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801380:	89 c2                	mov    %eax,%edx
  801382:	8b 45 10             	mov    0x10(%ebp),%eax
  801385:	01 c2                	add    %eax,%edx
  801387:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80138a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138d:	01 c8                	add    %ecx,%eax
  80138f:	8a 00                	mov    (%eax),%al
  801391:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801393:	ff 45 f8             	incl   -0x8(%ebp)
  801396:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801399:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80139c:	7c d9                	jl     801377 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80139e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a4:	01 d0                	add    %edx,%eax
  8013a6:	c6 00 00             	movb   $0x0,(%eax)
}
  8013a9:	90                   	nop
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013af:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bb:	8b 00                	mov    (%eax),%eax
  8013bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013cf:	eb 0c                	jmp    8013dd <strsplit+0x31>
			*string++ = 0;
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8d 50 01             	lea    0x1(%eax),%edx
  8013d7:	89 55 08             	mov    %edx,0x8(%ebp)
  8013da:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	84 c0                	test   %al,%al
  8013e4:	74 18                	je     8013fe <strsplit+0x52>
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	0f be c0             	movsbl %al,%eax
  8013ee:	50                   	push   %eax
  8013ef:	ff 75 0c             	pushl  0xc(%ebp)
  8013f2:	e8 83 fa ff ff       	call   800e7a <strchr>
  8013f7:	83 c4 08             	add    $0x8,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	75 d3                	jne    8013d1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8a 00                	mov    (%eax),%al
  801403:	84 c0                	test   %al,%al
  801405:	74 5a                	je     801461 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801407:	8b 45 14             	mov    0x14(%ebp),%eax
  80140a:	8b 00                	mov    (%eax),%eax
  80140c:	83 f8 0f             	cmp    $0xf,%eax
  80140f:	75 07                	jne    801418 <strsplit+0x6c>
		{
			return 0;
  801411:	b8 00 00 00 00       	mov    $0x0,%eax
  801416:	eb 66                	jmp    80147e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801418:	8b 45 14             	mov    0x14(%ebp),%eax
  80141b:	8b 00                	mov    (%eax),%eax
  80141d:	8d 48 01             	lea    0x1(%eax),%ecx
  801420:	8b 55 14             	mov    0x14(%ebp),%edx
  801423:	89 0a                	mov    %ecx,(%edx)
  801425:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80142c:	8b 45 10             	mov    0x10(%ebp),%eax
  80142f:	01 c2                	add    %eax,%edx
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801436:	eb 03                	jmp    80143b <strsplit+0x8f>
			string++;
  801438:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	8a 00                	mov    (%eax),%al
  801440:	84 c0                	test   %al,%al
  801442:	74 8b                	je     8013cf <strsplit+0x23>
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	0f be c0             	movsbl %al,%eax
  80144c:	50                   	push   %eax
  80144d:	ff 75 0c             	pushl  0xc(%ebp)
  801450:	e8 25 fa ff ff       	call   800e7a <strchr>
  801455:	83 c4 08             	add    $0x8,%esp
  801458:	85 c0                	test   %eax,%eax
  80145a:	74 dc                	je     801438 <strsplit+0x8c>
			string++;
	}
  80145c:	e9 6e ff ff ff       	jmp    8013cf <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801461:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801462:	8b 45 14             	mov    0x14(%ebp),%eax
  801465:	8b 00                	mov    (%eax),%eax
  801467:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80146e:	8b 45 10             	mov    0x10(%ebp),%eax
  801471:	01 d0                	add    %edx,%eax
  801473:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801479:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80148c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801493:	eb 4a                	jmp    8014df <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801495:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	01 c2                	add    %eax,%edx
  80149d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a3:	01 c8                	add    %ecx,%eax
  8014a5:	8a 00                	mov    (%eax),%al
  8014a7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014af:	01 d0                	add    %edx,%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	3c 40                	cmp    $0x40,%al
  8014b5:	7e 25                	jle    8014dc <str2lower+0x5c>
  8014b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bd:	01 d0                	add    %edx,%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	3c 5a                	cmp    $0x5a,%al
  8014c3:	7f 17                	jg     8014dc <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8014c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	01 d0                	add    %edx,%eax
  8014cd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d3:	01 ca                	add    %ecx,%edx
  8014d5:	8a 12                	mov    (%edx),%dl
  8014d7:	83 c2 20             	add    $0x20,%edx
  8014da:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014dc:	ff 45 fc             	incl   -0x4(%ebp)
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	e8 01 f8 ff ff       	call   800ce8 <strlen>
  8014e7:	83 c4 04             	add    $0x4,%esp
  8014ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014ed:	7f a6                	jg     801495 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	6a 10                	push   $0x10
  8014ff:	e8 b2 15 00 00       	call   802ab6 <alloc_block>
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  80150a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80150e:	75 14                	jne    801524 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801510:	83 ec 04             	sub    $0x4,%esp
  801513:	68 dc 3e 80 00       	push   $0x803edc
  801518:	6a 14                	push   $0x14
  80151a:	68 05 3f 80 00       	push   $0x803f05
  80151f:	e8 e0 1f 00 00       	call   803504 <_panic>

	node->start = start;
  801524:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801527:	8b 55 08             	mov    0x8(%ebp),%edx
  80152a:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  80152c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801532:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801535:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  80153c:	a1 24 50 80 00       	mov    0x805024,%eax
  801541:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801544:	eb 18                	jmp    80155e <insert_page_alloc+0x6a>
		if (start < it->start)
  801546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801549:	8b 00                	mov    (%eax),%eax
  80154b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80154e:	77 37                	ja     801587 <insert_page_alloc+0x93>
			break;
		prev = it;
  801550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801553:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801556:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80155b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80155e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801562:	74 08                	je     80156c <insert_page_alloc+0x78>
  801564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801567:	8b 40 08             	mov    0x8(%eax),%eax
  80156a:	eb 05                	jmp    801571 <insert_page_alloc+0x7d>
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
  801571:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801576:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80157b:	85 c0                	test   %eax,%eax
  80157d:	75 c7                	jne    801546 <insert_page_alloc+0x52>
  80157f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801583:	75 c1                	jne    801546 <insert_page_alloc+0x52>
  801585:	eb 01                	jmp    801588 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801587:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801588:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80158c:	75 64                	jne    8015f2 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  80158e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801592:	75 14                	jne    8015a8 <insert_page_alloc+0xb4>
  801594:	83 ec 04             	sub    $0x4,%esp
  801597:	68 14 3f 80 00       	push   $0x803f14
  80159c:	6a 21                	push   $0x21
  80159e:	68 05 3f 80 00       	push   $0x803f05
  8015a3:	e8 5c 1f 00 00       	call   803504 <_panic>
  8015a8:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8015ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b1:	89 50 08             	mov    %edx,0x8(%eax)
  8015b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b7:	8b 40 08             	mov    0x8(%eax),%eax
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	74 0d                	je     8015cb <insert_page_alloc+0xd7>
  8015be:	a1 24 50 80 00       	mov    0x805024,%eax
  8015c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015c6:	89 50 0c             	mov    %edx,0xc(%eax)
  8015c9:	eb 08                	jmp    8015d3 <insert_page_alloc+0xdf>
  8015cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ce:	a3 28 50 80 00       	mov    %eax,0x805028
  8015d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d6:	a3 24 50 80 00       	mov    %eax,0x805024
  8015db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015de:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8015e5:	a1 30 50 80 00       	mov    0x805030,%eax
  8015ea:	40                   	inc    %eax
  8015eb:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  8015f0:	eb 71                	jmp    801663 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  8015f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015f6:	74 06                	je     8015fe <insert_page_alloc+0x10a>
  8015f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015fc:	75 14                	jne    801612 <insert_page_alloc+0x11e>
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	68 38 3f 80 00       	push   $0x803f38
  801606:	6a 23                	push   $0x23
  801608:	68 05 3f 80 00       	push   $0x803f05
  80160d:	e8 f2 1e 00 00       	call   803504 <_panic>
  801612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801615:	8b 50 08             	mov    0x8(%eax),%edx
  801618:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80161b:	89 50 08             	mov    %edx,0x8(%eax)
  80161e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801621:	8b 40 08             	mov    0x8(%eax),%eax
  801624:	85 c0                	test   %eax,%eax
  801626:	74 0c                	je     801634 <insert_page_alloc+0x140>
  801628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162b:	8b 40 08             	mov    0x8(%eax),%eax
  80162e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801631:	89 50 0c             	mov    %edx,0xc(%eax)
  801634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801637:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80163a:	89 50 08             	mov    %edx,0x8(%eax)
  80163d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801640:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801643:	89 50 0c             	mov    %edx,0xc(%eax)
  801646:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801649:	8b 40 08             	mov    0x8(%eax),%eax
  80164c:	85 c0                	test   %eax,%eax
  80164e:	75 08                	jne    801658 <insert_page_alloc+0x164>
  801650:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801653:	a3 28 50 80 00       	mov    %eax,0x805028
  801658:	a1 30 50 80 00       	mov    0x805030,%eax
  80165d:	40                   	inc    %eax
  80165e:	a3 30 50 80 00       	mov    %eax,0x805030
}
  801663:	90                   	nop
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  80166c:	a1 24 50 80 00       	mov    0x805024,%eax
  801671:	85 c0                	test   %eax,%eax
  801673:	75 0c                	jne    801681 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801675:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80167a:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  80167f:	eb 67                	jmp    8016e8 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801681:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801686:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801689:	a1 24 50 80 00       	mov    0x805024,%eax
  80168e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801691:	eb 26                	jmp    8016b9 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801693:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801696:	8b 10                	mov    (%eax),%edx
  801698:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169b:	8b 40 04             	mov    0x4(%eax),%eax
  80169e:	01 d0                	add    %edx,%eax
  8016a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  8016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016a9:	76 06                	jbe    8016b1 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  8016ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8016b1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8016b9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016bd:	74 08                	je     8016c7 <recompute_page_alloc_break+0x61>
  8016bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c2:	8b 40 08             	mov    0x8(%eax),%eax
  8016c5:	eb 05                	jmp    8016cc <recompute_page_alloc_break+0x66>
  8016c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8016d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	75 b9                	jne    801693 <recompute_page_alloc_break+0x2d>
  8016da:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016de:	75 b3                	jne    801693 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  8016e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e3:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  8016f0:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8016f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016fd:	01 d0                	add    %edx,%eax
  8016ff:	48                   	dec    %eax
  801700:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801703:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801706:	ba 00 00 00 00       	mov    $0x0,%edx
  80170b:	f7 75 d8             	divl   -0x28(%ebp)
  80170e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801711:	29 d0                	sub    %edx,%eax
  801713:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801716:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80171a:	75 0a                	jne    801726 <alloc_pages_custom_fit+0x3c>
		return NULL;
  80171c:	b8 00 00 00 00       	mov    $0x0,%eax
  801721:	e9 7e 01 00 00       	jmp    8018a4 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801726:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  80172d:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801731:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801738:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  80173f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801744:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801747:	a1 24 50 80 00       	mov    0x805024,%eax
  80174c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80174f:	eb 69                	jmp    8017ba <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801751:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801754:	8b 00                	mov    (%eax),%eax
  801756:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801759:	76 47                	jbe    8017a2 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  80175b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80175e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801761:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801764:	8b 00                	mov    (%eax),%eax
  801766:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801769:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  80176c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80176f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801772:	72 2e                	jb     8017a2 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801774:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801778:	75 14                	jne    80178e <alloc_pages_custom_fit+0xa4>
  80177a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80177d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801780:	75 0c                	jne    80178e <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801782:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801785:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801788:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  80178c:	eb 14                	jmp    8017a2 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  80178e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801791:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801794:	76 0c                	jbe    8017a2 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801796:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801799:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  80179c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80179f:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  8017a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017a5:	8b 10                	mov    (%eax),%edx
  8017a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017aa:	8b 40 04             	mov    0x4(%eax),%eax
  8017ad:	01 d0                	add    %edx,%eax
  8017af:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8017b2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017be:	74 08                	je     8017c8 <alloc_pages_custom_fit+0xde>
  8017c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017c3:	8b 40 08             	mov    0x8(%eax),%eax
  8017c6:	eb 05                	jmp    8017cd <alloc_pages_custom_fit+0xe3>
  8017c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8017d2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	0f 85 72 ff ff ff    	jne    801751 <alloc_pages_custom_fit+0x67>
  8017df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017e3:	0f 85 68 ff ff ff    	jne    801751 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  8017e9:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8017ee:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017f1:	76 47                	jbe    80183a <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  8017f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  8017f9:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8017fe:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801801:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801804:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801807:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80180a:	72 2e                	jb     80183a <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  80180c:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801810:	75 14                	jne    801826 <alloc_pages_custom_fit+0x13c>
  801812:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801815:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801818:	75 0c                	jne    801826 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  80181a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80181d:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801820:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801824:	eb 14                	jmp    80183a <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801826:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801829:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80182c:	76 0c                	jbe    80183a <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  80182e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801831:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801834:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801837:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  80183a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801841:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801845:	74 08                	je     80184f <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80184d:	eb 40                	jmp    80188f <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  80184f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801853:	74 08                	je     80185d <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801855:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801858:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80185b:	eb 32                	jmp    80188f <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  80185d:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801862:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801865:	89 c2                	mov    %eax,%edx
  801867:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80186c:	39 c2                	cmp    %eax,%edx
  80186e:	73 07                	jae    801877 <alloc_pages_custom_fit+0x18d>
			return NULL;
  801870:	b8 00 00 00 00       	mov    $0x0,%eax
  801875:	eb 2d                	jmp    8018a4 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801877:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80187c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  80187f:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801885:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801888:	01 d0                	add    %edx,%eax
  80188a:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  80188f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801892:	83 ec 08             	sub    $0x8,%esp
  801895:	ff 75 d0             	pushl  -0x30(%ebp)
  801898:	50                   	push   %eax
  801899:	e8 56 fc ff ff       	call   8014f4 <insert_page_alloc>
  80189e:	83 c4 10             	add    $0x10,%esp

	return result;
  8018a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8018b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8018b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8018ba:	eb 1a                	jmp    8018d6 <find_allocated_size+0x30>
		if (it->start == va)
  8018bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018bf:	8b 00                	mov    (%eax),%eax
  8018c1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018c4:	75 08                	jne    8018ce <find_allocated_size+0x28>
			return it->size;
  8018c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018c9:	8b 40 04             	mov    0x4(%eax),%eax
  8018cc:	eb 34                	jmp    801902 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8018ce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8018d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018da:	74 08                	je     8018e4 <find_allocated_size+0x3e>
  8018dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018df:	8b 40 08             	mov    0x8(%eax),%eax
  8018e2:	eb 05                	jmp    8018e9 <find_allocated_size+0x43>
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8018ee:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	75 c5                	jne    8018bc <find_allocated_size+0x16>
  8018f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018fb:	75 bf                	jne    8018bc <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  8018fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801910:	a1 24 50 80 00       	mov    0x805024,%eax
  801915:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801918:	e9 e1 01 00 00       	jmp    801afe <free_pages+0x1fa>
		if (it->start == va) {
  80191d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801920:	8b 00                	mov    (%eax),%eax
  801922:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801925:	0f 85 cb 01 00 00    	jne    801af6 <free_pages+0x1f2>

			uint32 start = it->start;
  80192b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192e:	8b 00                	mov    (%eax),%eax
  801930:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801936:	8b 40 04             	mov    0x4(%eax),%eax
  801939:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  80193c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80193f:	f7 d0                	not    %eax
  801941:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801944:	73 1d                	jae    801963 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801946:	83 ec 0c             	sub    $0xc,%esp
  801949:	ff 75 e4             	pushl  -0x1c(%ebp)
  80194c:	ff 75 e8             	pushl  -0x18(%ebp)
  80194f:	68 6c 3f 80 00       	push   $0x803f6c
  801954:	68 a5 00 00 00       	push   $0xa5
  801959:	68 05 3f 80 00       	push   $0x803f05
  80195e:	e8 a1 1b 00 00       	call   803504 <_panic>
			}

			uint32 start_end = start + size;
  801963:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801966:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801969:	01 d0                	add    %edx,%eax
  80196b:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  80196e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801971:	85 c0                	test   %eax,%eax
  801973:	79 19                	jns    80198e <free_pages+0x8a>
  801975:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80197c:	77 10                	ja     80198e <free_pages+0x8a>
  80197e:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801985:	77 07                	ja     80198e <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801987:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80198a:	85 c0                	test   %eax,%eax
  80198c:	78 2c                	js     8019ba <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  80198e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801991:	83 ec 0c             	sub    $0xc,%esp
  801994:	68 00 00 00 a0       	push   $0xa0000000
  801999:	ff 75 e0             	pushl  -0x20(%ebp)
  80199c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80199f:	ff 75 e8             	pushl  -0x18(%ebp)
  8019a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019a5:	50                   	push   %eax
  8019a6:	68 b0 3f 80 00       	push   $0x803fb0
  8019ab:	68 ad 00 00 00       	push   $0xad
  8019b0:	68 05 3f 80 00       	push   $0x803f05
  8019b5:	e8 4a 1b 00 00       	call   803504 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8019ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019c0:	e9 88 00 00 00       	jmp    801a4d <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  8019c5:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  8019cc:	76 17                	jbe    8019e5 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  8019ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8019d1:	68 14 40 80 00       	push   $0x804014
  8019d6:	68 b4 00 00 00       	push   $0xb4
  8019db:	68 05 3f 80 00       	push   $0x803f05
  8019e0:	e8 1f 1b 00 00       	call   803504 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  8019e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e8:	05 00 10 00 00       	add    $0x1000,%eax
  8019ed:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  8019f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	79 2e                	jns    801a25 <free_pages+0x121>
  8019f7:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8019fe:	77 25                	ja     801a25 <free_pages+0x121>
  801a00:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801a07:	77 1c                	ja     801a25 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801a09:	83 ec 08             	sub    $0x8,%esp
  801a0c:	68 00 10 00 00       	push   $0x1000
  801a11:	ff 75 f0             	pushl  -0x10(%ebp)
  801a14:	e8 38 0d 00 00       	call   802751 <sys_free_user_mem>
  801a19:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801a1c:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801a23:	eb 28                	jmp    801a4d <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a28:	68 00 00 00 a0       	push   $0xa0000000
  801a2d:	ff 75 dc             	pushl  -0x24(%ebp)
  801a30:	68 00 10 00 00       	push   $0x1000
  801a35:	ff 75 f0             	pushl  -0x10(%ebp)
  801a38:	50                   	push   %eax
  801a39:	68 54 40 80 00       	push   $0x804054
  801a3e:	68 bd 00 00 00       	push   $0xbd
  801a43:	68 05 3f 80 00       	push   $0x803f05
  801a48:	e8 b7 1a 00 00       	call   803504 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a50:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801a53:	0f 82 6c ff ff ff    	jb     8019c5 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801a59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a5d:	75 17                	jne    801a76 <free_pages+0x172>
  801a5f:	83 ec 04             	sub    $0x4,%esp
  801a62:	68 b6 40 80 00       	push   $0x8040b6
  801a67:	68 c1 00 00 00       	push   $0xc1
  801a6c:	68 05 3f 80 00       	push   $0x803f05
  801a71:	e8 8e 1a 00 00       	call   803504 <_panic>
  801a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a79:	8b 40 08             	mov    0x8(%eax),%eax
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	74 11                	je     801a91 <free_pages+0x18d>
  801a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a83:	8b 40 08             	mov    0x8(%eax),%eax
  801a86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a89:	8b 52 0c             	mov    0xc(%edx),%edx
  801a8c:	89 50 0c             	mov    %edx,0xc(%eax)
  801a8f:	eb 0b                	jmp    801a9c <free_pages+0x198>
  801a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a94:	8b 40 0c             	mov    0xc(%eax),%eax
  801a97:	a3 28 50 80 00       	mov    %eax,0x805028
  801a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa2:	85 c0                	test   %eax,%eax
  801aa4:	74 11                	je     801ab7 <free_pages+0x1b3>
  801aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa9:	8b 40 0c             	mov    0xc(%eax),%eax
  801aac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aaf:	8b 52 08             	mov    0x8(%edx),%edx
  801ab2:	89 50 08             	mov    %edx,0x8(%eax)
  801ab5:	eb 0b                	jmp    801ac2 <free_pages+0x1be>
  801ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aba:	8b 40 08             	mov    0x8(%eax),%eax
  801abd:	a3 24 50 80 00       	mov    %eax,0x805024
  801ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801ad6:	a1 30 50 80 00       	mov    0x805030,%eax
  801adb:	48                   	dec    %eax
  801adc:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801ae1:	83 ec 0c             	sub    $0xc,%esp
  801ae4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae7:	e8 24 15 00 00       	call   803010 <free_block>
  801aec:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801aef:	e8 72 fb ff ff       	call   801666 <recompute_page_alloc_break>

			return;
  801af4:	eb 37                	jmp    801b2d <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801af6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801afb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801afe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b02:	74 08                	je     801b0c <free_pages+0x208>
  801b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b07:	8b 40 08             	mov    0x8(%eax),%eax
  801b0a:	eb 05                	jmp    801b11 <free_pages+0x20d>
  801b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b11:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801b16:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	0f 85 fa fd ff ff    	jne    80191d <free_pages+0x19>
  801b23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b27:	0f 85 f0 fd ff ff    	jne    80191d <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801b32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b37:	5d                   	pop    %ebp
  801b38:	c3                   	ret    

00801b39 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b3f:	a1 08 50 80 00       	mov    0x805008,%eax
  801b44:	85 c0                	test   %eax,%eax
  801b46:	74 60                	je     801ba8 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b48:	83 ec 08             	sub    $0x8,%esp
  801b4b:	68 00 00 00 82       	push   $0x82000000
  801b50:	68 00 00 00 80       	push   $0x80000000
  801b55:	e8 0d 0d 00 00       	call   802867 <initialize_dynamic_allocator>
  801b5a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b5d:	e8 f3 0a 00 00       	call   802655 <sys_get_uheap_strategy>
  801b62:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b67:	a1 40 50 80 00       	mov    0x805040,%eax
  801b6c:	05 00 10 00 00       	add    $0x1000,%eax
  801b71:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b76:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801b7b:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801b80:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801b87:	00 00 00 
  801b8a:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801b91:	00 00 00 
  801b94:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801b9b:	00 00 00 

		__firstTimeFlag = 0;
  801b9e:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801ba5:	00 00 00 
	}
}
  801ba8:	90                   	nop
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bbf:	83 ec 08             	sub    $0x8,%esp
  801bc2:	68 06 04 00 00       	push   $0x406
  801bc7:	50                   	push   %eax
  801bc8:	e8 d2 06 00 00       	call   80229f <__sys_allocate_page>
  801bcd:	83 c4 10             	add    $0x10,%esp
  801bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bd7:	79 17                	jns    801bf0 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801bd9:	83 ec 04             	sub    $0x4,%esp
  801bdc:	68 d4 40 80 00       	push   $0x8040d4
  801be1:	68 ea 00 00 00       	push   $0xea
  801be6:	68 05 3f 80 00       	push   $0x803f05
  801beb:	e8 14 19 00 00       	call   803504 <_panic>
	return 0;
  801bf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c0b:	83 ec 0c             	sub    $0xc,%esp
  801c0e:	50                   	push   %eax
  801c0f:	e8 d2 06 00 00       	call   8022e6 <__sys_unmap_frame>
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c1e:	79 17                	jns    801c37 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801c20:	83 ec 04             	sub    $0x4,%esp
  801c23:	68 10 41 80 00       	push   $0x804110
  801c28:	68 f5 00 00 00       	push   $0xf5
  801c2d:	68 05 3f 80 00       	push   $0x803f05
  801c32:	e8 cd 18 00 00       	call   803504 <_panic>
}
  801c37:	90                   	nop
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c40:	e8 f4 fe ff ff       	call   801b39 <uheap_init>
	if (size == 0) return NULL ;
  801c45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c49:	75 0a                	jne    801c55 <malloc+0x1b>
  801c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c50:	e9 67 01 00 00       	jmp    801dbc <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801c55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801c5c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c63:	77 16                	ja     801c7b <malloc+0x41>
		result = alloc_block(size);
  801c65:	83 ec 0c             	sub    $0xc,%esp
  801c68:	ff 75 08             	pushl  0x8(%ebp)
  801c6b:	e8 46 0e 00 00       	call   802ab6 <alloc_block>
  801c70:	83 c4 10             	add    $0x10,%esp
  801c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c76:	e9 3e 01 00 00       	jmp    801db9 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801c7b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c82:	8b 55 08             	mov    0x8(%ebp),%edx
  801c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c88:	01 d0                	add    %edx,%eax
  801c8a:	48                   	dec    %eax
  801c8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c91:	ba 00 00 00 00       	mov    $0x0,%edx
  801c96:	f7 75 f0             	divl   -0x10(%ebp)
  801c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c9c:	29 d0                	sub    %edx,%eax
  801c9e:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801ca1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	75 0a                	jne    801cb4 <malloc+0x7a>
			return NULL;
  801caa:	b8 00 00 00 00       	mov    $0x0,%eax
  801caf:	e9 08 01 00 00       	jmp    801dbc <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801cb4:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801cb9:	85 c0                	test   %eax,%eax
  801cbb:	74 0f                	je     801ccc <malloc+0x92>
  801cbd:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801cc3:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801cc8:	39 c2                	cmp    %eax,%edx
  801cca:	73 0a                	jae    801cd6 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801ccc:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801cd1:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801cd6:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801cdb:	83 f8 05             	cmp    $0x5,%eax
  801cde:	75 11                	jne    801cf1 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801ce0:	83 ec 0c             	sub    $0xc,%esp
  801ce3:	ff 75 e8             	pushl  -0x18(%ebp)
  801ce6:	e8 ff f9 ff ff       	call   8016ea <alloc_pages_custom_fit>
  801ceb:	83 c4 10             	add    $0x10,%esp
  801cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801cf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cf5:	0f 84 be 00 00 00    	je     801db9 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801d01:	83 ec 0c             	sub    $0xc,%esp
  801d04:	ff 75 f4             	pushl  -0xc(%ebp)
  801d07:	e8 9a fb ff ff       	call   8018a6 <find_allocated_size>
  801d0c:	83 c4 10             	add    $0x10,%esp
  801d0f:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801d12:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d16:	75 17                	jne    801d2f <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801d18:	ff 75 f4             	pushl  -0xc(%ebp)
  801d1b:	68 50 41 80 00       	push   $0x804150
  801d20:	68 24 01 00 00       	push   $0x124
  801d25:	68 05 3f 80 00       	push   $0x803f05
  801d2a:	e8 d5 17 00 00       	call   803504 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d32:	f7 d0                	not    %eax
  801d34:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d37:	73 1d                	jae    801d56 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801d39:	83 ec 0c             	sub    $0xc,%esp
  801d3c:	ff 75 e0             	pushl  -0x20(%ebp)
  801d3f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d42:	68 98 41 80 00       	push   $0x804198
  801d47:	68 29 01 00 00       	push   $0x129
  801d4c:	68 05 3f 80 00       	push   $0x803f05
  801d51:	e8 ae 17 00 00       	call   803504 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801d56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d5c:	01 d0                	add    %edx,%eax
  801d5e:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801d61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d64:	85 c0                	test   %eax,%eax
  801d66:	79 2c                	jns    801d94 <malloc+0x15a>
  801d68:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801d6f:	77 23                	ja     801d94 <malloc+0x15a>
  801d71:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801d78:	77 1a                	ja     801d94 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801d7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d7d:	85 c0                	test   %eax,%eax
  801d7f:	79 13                	jns    801d94 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801d81:	83 ec 08             	sub    $0x8,%esp
  801d84:	ff 75 e0             	pushl  -0x20(%ebp)
  801d87:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d8a:	e8 de 09 00 00       	call   80276d <sys_allocate_user_mem>
  801d8f:	83 c4 10             	add    $0x10,%esp
  801d92:	eb 25                	jmp    801db9 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801d94:	68 00 00 00 a0       	push   $0xa0000000
  801d99:	ff 75 dc             	pushl  -0x24(%ebp)
  801d9c:	ff 75 e0             	pushl  -0x20(%ebp)
  801d9f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801da2:	ff 75 f4             	pushl  -0xc(%ebp)
  801da5:	68 d4 41 80 00       	push   $0x8041d4
  801daa:	68 33 01 00 00       	push   $0x133
  801daf:	68 05 3f 80 00       	push   $0x803f05
  801db4:	e8 4b 17 00 00       	call   803504 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801dc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801dc8:	0f 84 26 01 00 00    	je     801ef4 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	79 1c                	jns    801df7 <free+0x39>
  801ddb:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801de2:	77 13                	ja     801df7 <free+0x39>
		free_block(virtual_address);
  801de4:	83 ec 0c             	sub    $0xc,%esp
  801de7:	ff 75 08             	pushl  0x8(%ebp)
  801dea:	e8 21 12 00 00       	call   803010 <free_block>
  801def:	83 c4 10             	add    $0x10,%esp
		return;
  801df2:	e9 01 01 00 00       	jmp    801ef8 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801df7:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801dfc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801dff:	0f 82 d8 00 00 00    	jb     801edd <free+0x11f>
  801e05:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801e0c:	0f 87 cb 00 00 00    	ja     801edd <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e15:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	74 17                	je     801e35 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801e1e:	ff 75 08             	pushl  0x8(%ebp)
  801e21:	68 44 42 80 00       	push   $0x804244
  801e26:	68 57 01 00 00       	push   $0x157
  801e2b:	68 05 3f 80 00       	push   $0x803f05
  801e30:	e8 cf 16 00 00       	call   803504 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801e35:	83 ec 0c             	sub    $0xc,%esp
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	e8 66 fa ff ff       	call   8018a6 <find_allocated_size>
  801e40:	83 c4 10             	add    $0x10,%esp
  801e43:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801e46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e4a:	0f 84 a7 00 00 00    	je     801ef7 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e53:	f7 d0                	not    %eax
  801e55:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e58:	73 1d                	jae    801e77 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e60:	ff 75 f4             	pushl  -0xc(%ebp)
  801e63:	68 6c 42 80 00       	push   $0x80426c
  801e68:	68 61 01 00 00       	push   $0x161
  801e6d:	68 05 3f 80 00       	push   $0x803f05
  801e72:	e8 8d 16 00 00       	call   803504 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801e77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7d:	01 d0                	add    %edx,%eax
  801e7f:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e85:	85 c0                	test   %eax,%eax
  801e87:	79 19                	jns    801ea2 <free+0xe4>
  801e89:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801e90:	77 10                	ja     801ea2 <free+0xe4>
  801e92:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801e99:	77 07                	ja     801ea2 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801e9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	78 2b                	js     801ecd <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801ea2:	83 ec 0c             	sub    $0xc,%esp
  801ea5:	68 00 00 00 a0       	push   $0xa0000000
  801eaa:	ff 75 ec             	pushl  -0x14(%ebp)
  801ead:	ff 75 f0             	pushl  -0x10(%ebp)
  801eb0:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb3:	ff 75 f0             	pushl  -0x10(%ebp)
  801eb6:	ff 75 08             	pushl  0x8(%ebp)
  801eb9:	68 a8 42 80 00       	push   $0x8042a8
  801ebe:	68 69 01 00 00       	push   $0x169
  801ec3:	68 05 3f 80 00       	push   $0x803f05
  801ec8:	e8 37 16 00 00       	call   803504 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  801ecd:	83 ec 0c             	sub    $0xc,%esp
  801ed0:	ff 75 08             	pushl  0x8(%ebp)
  801ed3:	e8 2c fa ff ff       	call   801904 <free_pages>
  801ed8:	83 c4 10             	add    $0x10,%esp
		return;
  801edb:	eb 1b                	jmp    801ef8 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  801edd:	ff 75 08             	pushl  0x8(%ebp)
  801ee0:	68 04 43 80 00       	push   $0x804304
  801ee5:	68 70 01 00 00       	push   $0x170
  801eea:	68 05 3f 80 00       	push   $0x803f05
  801eef:	e8 10 16 00 00       	call   803504 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801ef4:	90                   	nop
  801ef5:	eb 01                	jmp    801ef8 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  801ef7:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 38             	sub    $0x38,%esp
  801f00:	8b 45 10             	mov    0x10(%ebp),%eax
  801f03:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f06:	e8 2e fc ff ff       	call   801b39 <uheap_init>
	if (size == 0) return NULL ;
  801f0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f0f:	75 0a                	jne    801f1b <smalloc+0x21>
  801f11:	b8 00 00 00 00       	mov    $0x0,%eax
  801f16:	e9 3d 01 00 00       	jmp    802058 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  801f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  801f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f24:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f29:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  801f2c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f30:	74 0e                	je     801f40 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  801f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f35:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801f38:	05 00 10 00 00       	add    $0x1000,%eax
  801f3d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  801f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f43:	c1 e8 0c             	shr    $0xc,%eax
  801f46:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  801f49:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	75 0a                	jne    801f5c <smalloc+0x62>
		return NULL;
  801f52:	b8 00 00 00 00       	mov    $0x0,%eax
  801f57:	e9 fc 00 00 00       	jmp    802058 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  801f5c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f61:	85 c0                	test   %eax,%eax
  801f63:	74 0f                	je     801f74 <smalloc+0x7a>
  801f65:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f6b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f70:	39 c2                	cmp    %eax,%edx
  801f72:	73 0a                	jae    801f7e <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  801f74:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f79:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  801f7e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f83:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801f88:	29 c2                	sub    %eax,%edx
  801f8a:	89 d0                	mov    %edx,%eax
  801f8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  801f8f:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f95:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f9a:	29 c2                	sub    %eax,%edx
  801f9c:	89 d0                	mov    %edx,%eax
  801f9e:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801fa7:	77 13                	ja     801fbc <smalloc+0xc2>
  801fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fac:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801faf:	77 0b                	ja     801fbc <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  801fb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fb4:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801fb7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801fba:	73 0a                	jae    801fc6 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  801fbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc1:	e9 92 00 00 00       	jmp    802058 <smalloc+0x15e>
	}

	void *va = NULL;
  801fc6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801fcd:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801fd2:	83 f8 05             	cmp    $0x5,%eax
  801fd5:	75 11                	jne    801fe8 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  801fd7:	83 ec 0c             	sub    $0xc,%esp
  801fda:	ff 75 f4             	pushl  -0xc(%ebp)
  801fdd:	e8 08 f7 ff ff       	call   8016ea <alloc_pages_custom_fit>
  801fe2:	83 c4 10             	add    $0x10,%esp
  801fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  801fe8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fec:	75 27                	jne    802015 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  801fee:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  801ff5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ff8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  801ffb:	89 c2                	mov    %eax,%edx
  801ffd:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802002:	39 c2                	cmp    %eax,%edx
  802004:	73 07                	jae    80200d <smalloc+0x113>
			return NULL;}
  802006:	b8 00 00 00 00       	mov    $0x0,%eax
  80200b:	eb 4b                	jmp    802058 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  80200d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802012:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  802015:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802019:	ff 75 f0             	pushl  -0x10(%ebp)
  80201c:	50                   	push   %eax
  80201d:	ff 75 0c             	pushl  0xc(%ebp)
  802020:	ff 75 08             	pushl  0x8(%ebp)
  802023:	e8 cb 03 00 00       	call   8023f3 <sys_create_shared_object>
  802028:	83 c4 10             	add    $0x10,%esp
  80202b:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80202e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802032:	79 07                	jns    80203b <smalloc+0x141>
		return NULL;
  802034:	b8 00 00 00 00       	mov    $0x0,%eax
  802039:	eb 1d                	jmp    802058 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  80203b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802040:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802043:	75 10                	jne    802055 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802045:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80204b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204e:	01 d0                	add    %edx,%eax
  802050:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  802055:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802060:	e8 d4 fa ff ff       	call   801b39 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802065:	83 ec 08             	sub    $0x8,%esp
  802068:	ff 75 0c             	pushl  0xc(%ebp)
  80206b:	ff 75 08             	pushl  0x8(%ebp)
  80206e:	e8 aa 03 00 00       	call   80241d <sys_size_of_shared_object>
  802073:	83 c4 10             	add    $0x10,%esp
  802076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802079:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80207d:	7f 0a                	jg     802089 <sget+0x2f>
		return NULL;
  80207f:	b8 00 00 00 00       	mov    $0x0,%eax
  802084:	e9 32 01 00 00       	jmp    8021bb <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  802089:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  80208f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802092:	25 ff 0f 00 00       	and    $0xfff,%eax
  802097:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  80209a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80209e:	74 0e                	je     8020ae <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8020a6:	05 00 10 00 00       	add    $0x1000,%eax
  8020ab:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8020ae:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	75 0a                	jne    8020c1 <sget+0x67>
		return NULL;
  8020b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bc:	e9 fa 00 00 00       	jmp    8021bb <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8020c1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	74 0f                	je     8020d9 <sget+0x7f>
  8020ca:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020d0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020d5:	39 c2                	cmp    %eax,%edx
  8020d7:	73 0a                	jae    8020e3 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8020d9:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020de:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8020e3:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020e8:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8020ed:	29 c2                	sub    %eax,%edx
  8020ef:	89 d0                	mov    %edx,%eax
  8020f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8020f4:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020fa:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020ff:	29 c2                	sub    %eax,%edx
  802101:	89 d0                	mov    %edx,%eax
  802103:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802109:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80210c:	77 13                	ja     802121 <sget+0xc7>
  80210e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802111:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802114:	77 0b                	ja     802121 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802116:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802119:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80211c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80211f:	73 0a                	jae    80212b <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802121:	b8 00 00 00 00       	mov    $0x0,%eax
  802126:	e9 90 00 00 00       	jmp    8021bb <sget+0x161>

	void *va = NULL;
  80212b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802132:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802137:	83 f8 05             	cmp    $0x5,%eax
  80213a:	75 11                	jne    80214d <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80213c:	83 ec 0c             	sub    $0xc,%esp
  80213f:	ff 75 f4             	pushl  -0xc(%ebp)
  802142:	e8 a3 f5 ff ff       	call   8016ea <alloc_pages_custom_fit>
  802147:	83 c4 10             	add    $0x10,%esp
  80214a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  80214d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802151:	75 27                	jne    80217a <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802153:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  80215a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80215d:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802160:	89 c2                	mov    %eax,%edx
  802162:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802167:	39 c2                	cmp    %eax,%edx
  802169:	73 07                	jae    802172 <sget+0x118>
			return NULL;
  80216b:	b8 00 00 00 00       	mov    $0x0,%eax
  802170:	eb 49                	jmp    8021bb <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802172:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802177:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  80217a:	83 ec 04             	sub    $0x4,%esp
  80217d:	ff 75 f0             	pushl  -0x10(%ebp)
  802180:	ff 75 0c             	pushl  0xc(%ebp)
  802183:	ff 75 08             	pushl  0x8(%ebp)
  802186:	e8 af 02 00 00       	call   80243a <sys_get_shared_object>
  80218b:	83 c4 10             	add    $0x10,%esp
  80218e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  802191:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802195:	79 07                	jns    80219e <sget+0x144>
		return NULL;
  802197:	b8 00 00 00 00       	mov    $0x0,%eax
  80219c:	eb 1d                	jmp    8021bb <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  80219e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8021a3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8021a6:	75 10                	jne    8021b8 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8021a8:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	01 d0                	add    %edx,%eax
  8021b3:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8021b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021c3:	e8 71 f9 ff ff       	call   801b39 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8021c8:	83 ec 04             	sub    $0x4,%esp
  8021cb:	68 28 43 80 00       	push   $0x804328
  8021d0:	68 19 02 00 00       	push   $0x219
  8021d5:	68 05 3f 80 00       	push   $0x803f05
  8021da:	e8 25 13 00 00       	call   803504 <_panic>

008021df <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8021e5:	83 ec 04             	sub    $0x4,%esp
  8021e8:	68 50 43 80 00       	push   $0x804350
  8021ed:	68 2b 02 00 00       	push   $0x22b
  8021f2:	68 05 3f 80 00       	push   $0x803f05
  8021f7:	e8 08 13 00 00       	call   803504 <_panic>

008021fc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	57                   	push   %edi
  802200:	56                   	push   %esi
  802201:	53                   	push   %ebx
  802202:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802205:	8b 45 08             	mov    0x8(%ebp),%eax
  802208:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80220e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802211:	8b 7d 18             	mov    0x18(%ebp),%edi
  802214:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802217:	cd 30                	int    $0x30
  802219:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80221c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80221f:	83 c4 10             	add    $0x10,%esp
  802222:	5b                   	pop    %ebx
  802223:	5e                   	pop    %esi
  802224:	5f                   	pop    %edi
  802225:	5d                   	pop    %ebp
  802226:	c3                   	ret    

00802227 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	83 ec 04             	sub    $0x4,%esp
  80222d:	8b 45 10             	mov    0x10(%ebp),%eax
  802230:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802233:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802236:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	6a 00                	push   $0x0
  80223f:	51                   	push   %ecx
  802240:	52                   	push   %edx
  802241:	ff 75 0c             	pushl  0xc(%ebp)
  802244:	50                   	push   %eax
  802245:	6a 00                	push   $0x0
  802247:	e8 b0 ff ff ff       	call   8021fc <syscall>
  80224c:	83 c4 18             	add    $0x18,%esp
}
  80224f:	90                   	nop
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <sys_cgetc>:

int
sys_cgetc(void)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 02                	push   $0x2
  802261:	e8 96 ff ff ff       	call   8021fc <syscall>
  802266:	83 c4 18             	add    $0x18,%esp
}
  802269:	c9                   	leave  
  80226a:	c3                   	ret    

0080226b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 03                	push   $0x3
  80227a:	e8 7d ff ff ff       	call   8021fc <syscall>
  80227f:	83 c4 18             	add    $0x18,%esp
}
  802282:	90                   	nop
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 04                	push   $0x4
  802294:	e8 63 ff ff ff       	call   8021fc <syscall>
  802299:	83 c4 18             	add    $0x18,%esp
}
  80229c:	90                   	nop
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	52                   	push   %edx
  8022af:	50                   	push   %eax
  8022b0:	6a 08                	push   $0x8
  8022b2:	e8 45 ff ff ff       	call   8021fc <syscall>
  8022b7:	83 c4 18             	add    $0x18,%esp
}
  8022ba:	c9                   	leave  
  8022bb:	c3                   	ret    

008022bc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	56                   	push   %esi
  8022c0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022c1:	8b 75 18             	mov    0x18(%ebp),%esi
  8022c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	56                   	push   %esi
  8022d1:	53                   	push   %ebx
  8022d2:	51                   	push   %ecx
  8022d3:	52                   	push   %edx
  8022d4:	50                   	push   %eax
  8022d5:	6a 09                	push   $0x9
  8022d7:	e8 20 ff ff ff       	call   8021fc <syscall>
  8022dc:	83 c4 18             	add    $0x18,%esp
}
  8022df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022e2:	5b                   	pop    %ebx
  8022e3:	5e                   	pop    %esi
  8022e4:	5d                   	pop    %ebp
  8022e5:	c3                   	ret    

008022e6 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	ff 75 08             	pushl  0x8(%ebp)
  8022f4:	6a 0a                	push   $0xa
  8022f6:	e8 01 ff ff ff       	call   8021fc <syscall>
  8022fb:	83 c4 18             	add    $0x18,%esp
}
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	ff 75 0c             	pushl  0xc(%ebp)
  80230c:	ff 75 08             	pushl  0x8(%ebp)
  80230f:	6a 0b                	push   $0xb
  802311:	e8 e6 fe ff ff       	call   8021fc <syscall>
  802316:	83 c4 18             	add    $0x18,%esp
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 0c                	push   $0xc
  80232a:	e8 cd fe ff ff       	call   8021fc <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
}
  802332:	c9                   	leave  
  802333:	c3                   	ret    

00802334 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 0d                	push   $0xd
  802343:	e8 b4 fe ff ff       	call   8021fc <syscall>
  802348:	83 c4 18             	add    $0x18,%esp
}
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	6a 0e                	push   $0xe
  80235c:	e8 9b fe ff ff       	call   8021fc <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
}
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 0f                	push   $0xf
  802375:	e8 82 fe ff ff       	call   8021fc <syscall>
  80237a:	83 c4 18             	add    $0x18,%esp
}
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    

0080237f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	ff 75 08             	pushl  0x8(%ebp)
  80238d:	6a 10                	push   $0x10
  80238f:	e8 68 fe ff ff       	call   8021fc <syscall>
  802394:	83 c4 18             	add    $0x18,%esp
}
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 11                	push   $0x11
  8023a8:	e8 4f fe ff ff       	call   8021fc <syscall>
  8023ad:	83 c4 18             	add    $0x18,%esp
}
  8023b0:	90                   	nop
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
  8023b6:	83 ec 04             	sub    $0x4,%esp
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023bf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	50                   	push   %eax
  8023cc:	6a 01                	push   $0x1
  8023ce:	e8 29 fe ff ff       	call   8021fc <syscall>
  8023d3:	83 c4 18             	add    $0x18,%esp
}
  8023d6:	90                   	nop
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 14                	push   $0x14
  8023e8:	e8 0f fe ff ff       	call   8021fc <syscall>
  8023ed:	83 c4 18             	add    $0x18,%esp
}
  8023f0:	90                   	nop
  8023f1:	c9                   	leave  
  8023f2:	c3                   	ret    

008023f3 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
  8023f6:	83 ec 04             	sub    $0x4,%esp
  8023f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8023fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023ff:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802402:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	6a 00                	push   $0x0
  80240b:	51                   	push   %ecx
  80240c:	52                   	push   %edx
  80240d:	ff 75 0c             	pushl  0xc(%ebp)
  802410:	50                   	push   %eax
  802411:	6a 15                	push   $0x15
  802413:	e8 e4 fd ff ff       	call   8021fc <syscall>
  802418:	83 c4 18             	add    $0x18,%esp
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802420:	8b 55 0c             	mov    0xc(%ebp),%edx
  802423:	8b 45 08             	mov    0x8(%ebp),%eax
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	52                   	push   %edx
  80242d:	50                   	push   %eax
  80242e:	6a 16                	push   $0x16
  802430:	e8 c7 fd ff ff       	call   8021fc <syscall>
  802435:	83 c4 18             	add    $0x18,%esp
}
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80243d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802440:	8b 55 0c             	mov    0xc(%ebp),%edx
  802443:	8b 45 08             	mov    0x8(%ebp),%eax
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	51                   	push   %ecx
  80244b:	52                   	push   %edx
  80244c:	50                   	push   %eax
  80244d:	6a 17                	push   $0x17
  80244f:	e8 a8 fd ff ff       	call   8021fc <syscall>
  802454:	83 c4 18             	add    $0x18,%esp
}
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80245c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	52                   	push   %edx
  802469:	50                   	push   %eax
  80246a:	6a 18                	push   $0x18
  80246c:	e8 8b fd ff ff       	call   8021fc <syscall>
  802471:	83 c4 18             	add    $0x18,%esp
}
  802474:	c9                   	leave  
  802475:	c3                   	ret    

00802476 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802476:	55                   	push   %ebp
  802477:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	6a 00                	push   $0x0
  80247e:	ff 75 14             	pushl  0x14(%ebp)
  802481:	ff 75 10             	pushl  0x10(%ebp)
  802484:	ff 75 0c             	pushl  0xc(%ebp)
  802487:	50                   	push   %eax
  802488:	6a 19                	push   $0x19
  80248a:	e8 6d fd ff ff       	call   8021fc <syscall>
  80248f:	83 c4 18             	add    $0x18,%esp
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	50                   	push   %eax
  8024a3:	6a 1a                	push   $0x1a
  8024a5:	e8 52 fd ff ff       	call   8021fc <syscall>
  8024aa:	83 c4 18             	add    $0x18,%esp
}
  8024ad:	90                   	nop
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	50                   	push   %eax
  8024bf:	6a 1b                	push   $0x1b
  8024c1:	e8 36 fd ff ff       	call   8021fc <syscall>
  8024c6:	83 c4 18             	add    $0x18,%esp
}
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 05                	push   $0x5
  8024da:	e8 1d fd ff ff       	call   8021fc <syscall>
  8024df:	83 c4 18             	add    $0x18,%esp
}
  8024e2:	c9                   	leave  
  8024e3:	c3                   	ret    

008024e4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 06                	push   $0x6
  8024f3:	e8 04 fd ff ff       	call   8021fc <syscall>
  8024f8:	83 c4 18             	add    $0x18,%esp
}
  8024fb:	c9                   	leave  
  8024fc:	c3                   	ret    

008024fd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024fd:	55                   	push   %ebp
  8024fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 07                	push   $0x7
  80250c:	e8 eb fc ff ff       	call   8021fc <syscall>
  802511:	83 c4 18             	add    $0x18,%esp
}
  802514:	c9                   	leave  
  802515:	c3                   	ret    

00802516 <sys_exit_env>:


void sys_exit_env(void)
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 1c                	push   $0x1c
  802525:	e8 d2 fc ff ff       	call   8021fc <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
}
  80252d:	90                   	nop
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
  802533:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802536:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802539:	8d 50 04             	lea    0x4(%eax),%edx
  80253c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	52                   	push   %edx
  802546:	50                   	push   %eax
  802547:	6a 1d                	push   $0x1d
  802549:	e8 ae fc ff ff       	call   8021fc <syscall>
  80254e:	83 c4 18             	add    $0x18,%esp
	return result;
  802551:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802554:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802557:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80255a:	89 01                	mov    %eax,(%ecx)
  80255c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80255f:	8b 45 08             	mov    0x8(%ebp),%eax
  802562:	c9                   	leave  
  802563:	c2 04 00             	ret    $0x4

00802566 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	ff 75 10             	pushl  0x10(%ebp)
  802570:	ff 75 0c             	pushl  0xc(%ebp)
  802573:	ff 75 08             	pushl  0x8(%ebp)
  802576:	6a 13                	push   $0x13
  802578:	e8 7f fc ff ff       	call   8021fc <syscall>
  80257d:	83 c4 18             	add    $0x18,%esp
	return ;
  802580:	90                   	nop
}
  802581:	c9                   	leave  
  802582:	c3                   	ret    

00802583 <sys_rcr2>:
uint32 sys_rcr2()
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 1e                	push   $0x1e
  802592:	e8 65 fc ff ff       	call   8021fc <syscall>
  802597:	83 c4 18             	add    $0x18,%esp
}
  80259a:	c9                   	leave  
  80259b:	c3                   	ret    

0080259c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80259c:	55                   	push   %ebp
  80259d:	89 e5                	mov    %esp,%ebp
  80259f:	83 ec 04             	sub    $0x4,%esp
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025a8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	50                   	push   %eax
  8025b5:	6a 1f                	push   $0x1f
  8025b7:	e8 40 fc ff ff       	call   8021fc <syscall>
  8025bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8025bf:	90                   	nop
}
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <rsttst>:
void rsttst()
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 21                	push   $0x21
  8025d1:	e8 26 fc ff ff       	call   8021fc <syscall>
  8025d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8025d9:	90                   	nop
}
  8025da:	c9                   	leave  
  8025db:	c3                   	ret    

008025dc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	83 ec 04             	sub    $0x4,%esp
  8025e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8025e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025e8:	8b 55 18             	mov    0x18(%ebp),%edx
  8025eb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025ef:	52                   	push   %edx
  8025f0:	50                   	push   %eax
  8025f1:	ff 75 10             	pushl  0x10(%ebp)
  8025f4:	ff 75 0c             	pushl  0xc(%ebp)
  8025f7:	ff 75 08             	pushl  0x8(%ebp)
  8025fa:	6a 20                	push   $0x20
  8025fc:	e8 fb fb ff ff       	call   8021fc <syscall>
  802601:	83 c4 18             	add    $0x18,%esp
	return ;
  802604:	90                   	nop
}
  802605:	c9                   	leave  
  802606:	c3                   	ret    

00802607 <chktst>:
void chktst(uint32 n)
{
  802607:	55                   	push   %ebp
  802608:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	ff 75 08             	pushl  0x8(%ebp)
  802615:	6a 22                	push   $0x22
  802617:	e8 e0 fb ff ff       	call   8021fc <syscall>
  80261c:	83 c4 18             	add    $0x18,%esp
	return ;
  80261f:	90                   	nop
}
  802620:	c9                   	leave  
  802621:	c3                   	ret    

00802622 <inctst>:

void inctst()
{
  802622:	55                   	push   %ebp
  802623:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802625:	6a 00                	push   $0x0
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 23                	push   $0x23
  802631:	e8 c6 fb ff ff       	call   8021fc <syscall>
  802636:	83 c4 18             	add    $0x18,%esp
	return ;
  802639:	90                   	nop
}
  80263a:	c9                   	leave  
  80263b:	c3                   	ret    

0080263c <gettst>:
uint32 gettst()
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80263f:	6a 00                	push   $0x0
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 24                	push   $0x24
  80264b:	e8 ac fb ff ff       	call   8021fc <syscall>
  802650:	83 c4 18             	add    $0x18,%esp
}
  802653:	c9                   	leave  
  802654:	c3                   	ret    

00802655 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 25                	push   $0x25
  802664:	e8 93 fb ff ff       	call   8021fc <syscall>
  802669:	83 c4 18             	add    $0x18,%esp
  80266c:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802671:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802676:	c9                   	leave  
  802677:	c3                   	ret    

00802678 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	6a 00                	push   $0x0
  802689:	6a 00                	push   $0x0
  80268b:	ff 75 08             	pushl  0x8(%ebp)
  80268e:	6a 26                	push   $0x26
  802690:	e8 67 fb ff ff       	call   8021fc <syscall>
  802695:	83 c4 18             	add    $0x18,%esp
	return ;
  802698:	90                   	nop
}
  802699:	c9                   	leave  
  80269a:	c3                   	ret    

0080269b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
  80269e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80269f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ab:	6a 00                	push   $0x0
  8026ad:	53                   	push   %ebx
  8026ae:	51                   	push   %ecx
  8026af:	52                   	push   %edx
  8026b0:	50                   	push   %eax
  8026b1:	6a 27                	push   $0x27
  8026b3:	e8 44 fb ff ff       	call   8021fc <syscall>
  8026b8:	83 c4 18             	add    $0x18,%esp
}
  8026bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026be:	c9                   	leave  
  8026bf:	c3                   	ret    

008026c0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	6a 00                	push   $0x0
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	52                   	push   %edx
  8026d0:	50                   	push   %eax
  8026d1:	6a 28                	push   $0x28
  8026d3:	e8 24 fb ff ff       	call   8021fc <syscall>
  8026d8:	83 c4 18             	add    $0x18,%esp
}
  8026db:	c9                   	leave  
  8026dc:	c3                   	ret    

008026dd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8026dd:	55                   	push   %ebp
  8026de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8026e0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e9:	6a 00                	push   $0x0
  8026eb:	51                   	push   %ecx
  8026ec:	ff 75 10             	pushl  0x10(%ebp)
  8026ef:	52                   	push   %edx
  8026f0:	50                   	push   %eax
  8026f1:	6a 29                	push   $0x29
  8026f3:	e8 04 fb ff ff       	call   8021fc <syscall>
  8026f8:	83 c4 18             	add    $0x18,%esp
}
  8026fb:	c9                   	leave  
  8026fc:	c3                   	ret    

008026fd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	ff 75 10             	pushl  0x10(%ebp)
  802707:	ff 75 0c             	pushl  0xc(%ebp)
  80270a:	ff 75 08             	pushl  0x8(%ebp)
  80270d:	6a 12                	push   $0x12
  80270f:	e8 e8 fa ff ff       	call   8021fc <syscall>
  802714:	83 c4 18             	add    $0x18,%esp
	return ;
  802717:	90                   	nop
}
  802718:	c9                   	leave  
  802719:	c3                   	ret    

0080271a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80271a:	55                   	push   %ebp
  80271b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80271d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802720:	8b 45 08             	mov    0x8(%ebp),%eax
  802723:	6a 00                	push   $0x0
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	52                   	push   %edx
  80272a:	50                   	push   %eax
  80272b:	6a 2a                	push   $0x2a
  80272d:	e8 ca fa ff ff       	call   8021fc <syscall>
  802732:	83 c4 18             	add    $0x18,%esp
	return;
  802735:	90                   	nop
}
  802736:	c9                   	leave  
  802737:	c3                   	ret    

00802738 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802738:	55                   	push   %ebp
  802739:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	6a 2b                	push   $0x2b
  802747:	e8 b0 fa ff ff       	call   8021fc <syscall>
  80274c:	83 c4 18             	add    $0x18,%esp
}
  80274f:	c9                   	leave  
  802750:	c3                   	ret    

00802751 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802751:	55                   	push   %ebp
  802752:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	ff 75 0c             	pushl  0xc(%ebp)
  80275d:	ff 75 08             	pushl  0x8(%ebp)
  802760:	6a 2d                	push   $0x2d
  802762:	e8 95 fa ff ff       	call   8021fc <syscall>
  802767:	83 c4 18             	add    $0x18,%esp
	return;
  80276a:	90                   	nop
}
  80276b:	c9                   	leave  
  80276c:	c3                   	ret    

0080276d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80276d:	55                   	push   %ebp
  80276e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	ff 75 0c             	pushl  0xc(%ebp)
  802779:	ff 75 08             	pushl  0x8(%ebp)
  80277c:	6a 2c                	push   $0x2c
  80277e:	e8 79 fa ff ff       	call   8021fc <syscall>
  802783:	83 c4 18             	add    $0x18,%esp
	return ;
  802786:	90                   	nop
}
  802787:	c9                   	leave  
  802788:	c3                   	ret    

00802789 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802789:	55                   	push   %ebp
  80278a:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80278c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	6a 00                	push   $0x0
  802794:	6a 00                	push   $0x0
  802796:	6a 00                	push   $0x0
  802798:	52                   	push   %edx
  802799:	50                   	push   %eax
  80279a:	6a 2e                	push   $0x2e
  80279c:	e8 5b fa ff ff       	call   8021fc <syscall>
  8027a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8027a4:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  8027a5:	c9                   	leave  
  8027a6:	c3                   	ret    

008027a7 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
  8027aa:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8027ad:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  8027b4:	72 09                	jb     8027bf <to_page_va+0x18>
  8027b6:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  8027bd:	72 14                	jb     8027d3 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8027bf:	83 ec 04             	sub    $0x4,%esp
  8027c2:	68 74 43 80 00       	push   $0x804374
  8027c7:	6a 15                	push   $0x15
  8027c9:	68 9f 43 80 00       	push   $0x80439f
  8027ce:	e8 31 0d 00 00       	call   803504 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8027d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d6:	ba 60 50 80 00       	mov    $0x805060,%edx
  8027db:	29 d0                	sub    %edx,%eax
  8027dd:	c1 f8 02             	sar    $0x2,%eax
  8027e0:	89 c2                	mov    %eax,%edx
  8027e2:	89 d0                	mov    %edx,%eax
  8027e4:	c1 e0 02             	shl    $0x2,%eax
  8027e7:	01 d0                	add    %edx,%eax
  8027e9:	c1 e0 02             	shl    $0x2,%eax
  8027ec:	01 d0                	add    %edx,%eax
  8027ee:	c1 e0 02             	shl    $0x2,%eax
  8027f1:	01 d0                	add    %edx,%eax
  8027f3:	89 c1                	mov    %eax,%ecx
  8027f5:	c1 e1 08             	shl    $0x8,%ecx
  8027f8:	01 c8                	add    %ecx,%eax
  8027fa:	89 c1                	mov    %eax,%ecx
  8027fc:	c1 e1 10             	shl    $0x10,%ecx
  8027ff:	01 c8                	add    %ecx,%eax
  802801:	01 c0                	add    %eax,%eax
  802803:	01 d0                	add    %edx,%eax
  802805:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	c1 e0 0c             	shl    $0xc,%eax
  80280e:	89 c2                	mov    %eax,%edx
  802810:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802815:	01 d0                	add    %edx,%eax
}
  802817:	c9                   	leave  
  802818:	c3                   	ret    

00802819 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802819:	55                   	push   %ebp
  80281a:	89 e5                	mov    %esp,%ebp
  80281c:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80281f:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802824:	8b 55 08             	mov    0x8(%ebp),%edx
  802827:	29 c2                	sub    %eax,%edx
  802829:	89 d0                	mov    %edx,%eax
  80282b:	c1 e8 0c             	shr    $0xc,%eax
  80282e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802835:	78 09                	js     802840 <to_page_info+0x27>
  802837:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80283e:	7e 14                	jle    802854 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802840:	83 ec 04             	sub    $0x4,%esp
  802843:	68 b8 43 80 00       	push   $0x8043b8
  802848:	6a 22                	push   $0x22
  80284a:	68 9f 43 80 00       	push   $0x80439f
  80284f:	e8 b0 0c 00 00       	call   803504 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802854:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802857:	89 d0                	mov    %edx,%eax
  802859:	01 c0                	add    %eax,%eax
  80285b:	01 d0                	add    %edx,%eax
  80285d:	c1 e0 02             	shl    $0x2,%eax
  802860:	05 60 50 80 00       	add    $0x805060,%eax
}
  802865:	c9                   	leave  
  802866:	c3                   	ret    

00802867 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802867:	55                   	push   %ebp
  802868:	89 e5                	mov    %esp,%ebp
  80286a:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	05 00 00 00 02       	add    $0x2000000,%eax
  802875:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802878:	73 16                	jae    802890 <initialize_dynamic_allocator+0x29>
  80287a:	68 dc 43 80 00       	push   $0x8043dc
  80287f:	68 02 44 80 00       	push   $0x804402
  802884:	6a 34                	push   $0x34
  802886:	68 9f 43 80 00       	push   $0x80439f
  80288b:	e8 74 0c 00 00       	call   803504 <_panic>
		is_initialized = 1;
  802890:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  802897:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  80289a:	8b 45 08             	mov    0x8(%ebp),%eax
  80289d:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  8028a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028a5:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  8028aa:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  8028b1:	00 00 00 
  8028b4:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8028bb:	00 00 00 
  8028be:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  8028c5:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  8028c8:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  8028cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028d6:	eb 36                	jmp    80290e <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	c1 e0 04             	shl    $0x4,%eax
  8028de:	05 80 d0 81 00       	add    $0x81d080,%eax
  8028e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	c1 e0 04             	shl    $0x4,%eax
  8028ef:	05 84 d0 81 00       	add    $0x81d084,%eax
  8028f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	c1 e0 04             	shl    $0x4,%eax
  802900:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802905:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  80290b:	ff 45 f4             	incl   -0xc(%ebp)
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802914:	72 c2                	jb     8028d8 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802916:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80291c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802921:	29 c2                	sub    %eax,%edx
  802923:	89 d0                	mov    %edx,%eax
  802925:	c1 e8 0c             	shr    $0xc,%eax
  802928:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  80292b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802932:	e9 c8 00 00 00       	jmp    8029ff <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802937:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80293a:	89 d0                	mov    %edx,%eax
  80293c:	01 c0                	add    %eax,%eax
  80293e:	01 d0                	add    %edx,%eax
  802940:	c1 e0 02             	shl    $0x2,%eax
  802943:	05 68 50 80 00       	add    $0x805068,%eax
  802948:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  80294d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802950:	89 d0                	mov    %edx,%eax
  802952:	01 c0                	add    %eax,%eax
  802954:	01 d0                	add    %edx,%eax
  802956:	c1 e0 02             	shl    $0x2,%eax
  802959:	05 6a 50 80 00       	add    $0x80506a,%eax
  80295e:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802963:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802969:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80296c:	89 c8                	mov    %ecx,%eax
  80296e:	01 c0                	add    %eax,%eax
  802970:	01 c8                	add    %ecx,%eax
  802972:	c1 e0 02             	shl    $0x2,%eax
  802975:	05 64 50 80 00       	add    $0x805064,%eax
  80297a:	89 10                	mov    %edx,(%eax)
  80297c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80297f:	89 d0                	mov    %edx,%eax
  802981:	01 c0                	add    %eax,%eax
  802983:	01 d0                	add    %edx,%eax
  802985:	c1 e0 02             	shl    $0x2,%eax
  802988:	05 64 50 80 00       	add    $0x805064,%eax
  80298d:	8b 00                	mov    (%eax),%eax
  80298f:	85 c0                	test   %eax,%eax
  802991:	74 1b                	je     8029ae <initialize_dynamic_allocator+0x147>
  802993:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802999:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80299c:	89 c8                	mov    %ecx,%eax
  80299e:	01 c0                	add    %eax,%eax
  8029a0:	01 c8                	add    %ecx,%eax
  8029a2:	c1 e0 02             	shl    $0x2,%eax
  8029a5:	05 60 50 80 00       	add    $0x805060,%eax
  8029aa:	89 02                	mov    %eax,(%edx)
  8029ac:	eb 16                	jmp    8029c4 <initialize_dynamic_allocator+0x15d>
  8029ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029b1:	89 d0                	mov    %edx,%eax
  8029b3:	01 c0                	add    %eax,%eax
  8029b5:	01 d0                	add    %edx,%eax
  8029b7:	c1 e0 02             	shl    $0x2,%eax
  8029ba:	05 60 50 80 00       	add    $0x805060,%eax
  8029bf:	a3 48 50 80 00       	mov    %eax,0x805048
  8029c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029c7:	89 d0                	mov    %edx,%eax
  8029c9:	01 c0                	add    %eax,%eax
  8029cb:	01 d0                	add    %edx,%eax
  8029cd:	c1 e0 02             	shl    $0x2,%eax
  8029d0:	05 60 50 80 00       	add    $0x805060,%eax
  8029d5:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8029da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029dd:	89 d0                	mov    %edx,%eax
  8029df:	01 c0                	add    %eax,%eax
  8029e1:	01 d0                	add    %edx,%eax
  8029e3:	c1 e0 02             	shl    $0x2,%eax
  8029e6:	05 60 50 80 00       	add    $0x805060,%eax
  8029eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f1:	a1 54 50 80 00       	mov    0x805054,%eax
  8029f6:	40                   	inc    %eax
  8029f7:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  8029fc:	ff 45 f0             	incl   -0x10(%ebp)
  8029ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a02:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802a05:	0f 82 2c ff ff ff    	jb     802937 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802a0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a11:	eb 2f                	jmp    802a42 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802a13:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a16:	89 d0                	mov    %edx,%eax
  802a18:	01 c0                	add    %eax,%eax
  802a1a:	01 d0                	add    %edx,%eax
  802a1c:	c1 e0 02             	shl    $0x2,%eax
  802a1f:	05 68 50 80 00       	add    $0x805068,%eax
  802a24:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802a29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a2c:	89 d0                	mov    %edx,%eax
  802a2e:	01 c0                	add    %eax,%eax
  802a30:	01 d0                	add    %edx,%eax
  802a32:	c1 e0 02             	shl    $0x2,%eax
  802a35:	05 6a 50 80 00       	add    $0x80506a,%eax
  802a3a:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802a3f:	ff 45 ec             	incl   -0x14(%ebp)
  802a42:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802a49:	76 c8                	jbe    802a13 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802a4b:	90                   	nop
  802a4c:	c9                   	leave  
  802a4d:	c3                   	ret    

00802a4e <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802a4e:	55                   	push   %ebp
  802a4f:	89 e5                	mov    %esp,%ebp
  802a51:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802a54:	8b 55 08             	mov    0x8(%ebp),%edx
  802a57:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a5c:	29 c2                	sub    %eax,%edx
  802a5e:	89 d0                	mov    %edx,%eax
  802a60:	c1 e8 0c             	shr    $0xc,%eax
  802a63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802a66:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a69:	89 d0                	mov    %edx,%eax
  802a6b:	01 c0                	add    %eax,%eax
  802a6d:	01 d0                	add    %edx,%eax
  802a6f:	c1 e0 02             	shl    $0x2,%eax
  802a72:	05 68 50 80 00       	add    $0x805068,%eax
  802a77:	8b 00                	mov    (%eax),%eax
  802a79:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802a7c:	c9                   	leave  
  802a7d:	c3                   	ret    

00802a7e <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802a7e:	55                   	push   %ebp
  802a7f:	89 e5                	mov    %esp,%ebp
  802a81:	83 ec 14             	sub    $0x14,%esp
  802a84:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802a87:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802a8b:	77 07                	ja     802a94 <nearest_pow2_ceil.1513+0x16>
  802a8d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a92:	eb 20                	jmp    802ab4 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802a94:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802a9b:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802a9e:	eb 08                	jmp    802aa8 <nearest_pow2_ceil.1513+0x2a>
  802aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802aa3:	01 c0                	add    %eax,%eax
  802aa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802aa8:	d1 6d 08             	shrl   0x8(%ebp)
  802aab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aaf:	75 ef                	jne    802aa0 <nearest_pow2_ceil.1513+0x22>
        return power;
  802ab1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802ab4:	c9                   	leave  
  802ab5:	c3                   	ret    

00802ab6 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802ab6:	55                   	push   %ebp
  802ab7:	89 e5                	mov    %esp,%ebp
  802ab9:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802abc:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802ac3:	76 16                	jbe    802adb <alloc_block+0x25>
  802ac5:	68 18 44 80 00       	push   $0x804418
  802aca:	68 02 44 80 00       	push   $0x804402
  802acf:	6a 72                	push   $0x72
  802ad1:	68 9f 43 80 00       	push   $0x80439f
  802ad6:	e8 29 0a 00 00       	call   803504 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802adb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802adf:	75 0a                	jne    802aeb <alloc_block+0x35>
  802ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae6:	e9 bd 04 00 00       	jmp    802fa8 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802aeb:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802af8:	73 06                	jae    802b00 <alloc_block+0x4a>
        size = min_block_size;
  802afa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afd:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802b00:	83 ec 0c             	sub    $0xc,%esp
  802b03:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802b06:	ff 75 08             	pushl  0x8(%ebp)
  802b09:	89 c1                	mov    %eax,%ecx
  802b0b:	e8 6e ff ff ff       	call   802a7e <nearest_pow2_ceil.1513>
  802b10:	83 c4 10             	add    $0x10,%esp
  802b13:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802b16:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b19:	83 ec 0c             	sub    $0xc,%esp
  802b1c:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802b1f:	52                   	push   %edx
  802b20:	89 c1                	mov    %eax,%ecx
  802b22:	e8 83 04 00 00       	call   802faa <log2_ceil.1520>
  802b27:	83 c4 10             	add    $0x10,%esp
  802b2a:	83 e8 03             	sub    $0x3,%eax
  802b2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b33:	c1 e0 04             	shl    $0x4,%eax
  802b36:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b3b:	8b 00                	mov    (%eax),%eax
  802b3d:	85 c0                	test   %eax,%eax
  802b3f:	0f 84 d8 00 00 00    	je     802c1d <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802b45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b48:	c1 e0 04             	shl    $0x4,%eax
  802b4b:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b50:	8b 00                	mov    (%eax),%eax
  802b52:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802b55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b59:	75 17                	jne    802b72 <alloc_block+0xbc>
  802b5b:	83 ec 04             	sub    $0x4,%esp
  802b5e:	68 39 44 80 00       	push   $0x804439
  802b63:	68 98 00 00 00       	push   $0x98
  802b68:	68 9f 43 80 00       	push   $0x80439f
  802b6d:	e8 92 09 00 00       	call   803504 <_panic>
  802b72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	85 c0                	test   %eax,%eax
  802b79:	74 10                	je     802b8b <alloc_block+0xd5>
  802b7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b7e:	8b 00                	mov    (%eax),%eax
  802b80:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b83:	8b 52 04             	mov    0x4(%edx),%edx
  802b86:	89 50 04             	mov    %edx,0x4(%eax)
  802b89:	eb 14                	jmp    802b9f <alloc_block+0xe9>
  802b8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8e:	8b 40 04             	mov    0x4(%eax),%eax
  802b91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b94:	c1 e2 04             	shl    $0x4,%edx
  802b97:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802b9d:	89 02                	mov    %eax,(%edx)
  802b9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba2:	8b 40 04             	mov    0x4(%eax),%eax
  802ba5:	85 c0                	test   %eax,%eax
  802ba7:	74 0f                	je     802bb8 <alloc_block+0x102>
  802ba9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bac:	8b 40 04             	mov    0x4(%eax),%eax
  802baf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bb2:	8b 12                	mov    (%edx),%edx
  802bb4:	89 10                	mov    %edx,(%eax)
  802bb6:	eb 13                	jmp    802bcb <alloc_block+0x115>
  802bb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bbb:	8b 00                	mov    (%eax),%eax
  802bbd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bc0:	c1 e2 04             	shl    $0x4,%edx
  802bc3:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802bc9:	89 02                	mov    %eax,(%edx)
  802bcb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be1:	c1 e0 04             	shl    $0x4,%eax
  802be4:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	8d 50 ff             	lea    -0x1(%eax),%edx
  802bee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf1:	c1 e0 04             	shl    $0x4,%eax
  802bf4:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802bf9:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802bfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bfe:	83 ec 0c             	sub    $0xc,%esp
  802c01:	50                   	push   %eax
  802c02:	e8 12 fc ff ff       	call   802819 <to_page_info>
  802c07:	83 c4 10             	add    $0x10,%esp
  802c0a:	89 c2                	mov    %eax,%edx
  802c0c:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802c10:	48                   	dec    %eax
  802c11:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802c15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c18:	e9 8b 03 00 00       	jmp    802fa8 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802c1d:	a1 48 50 80 00       	mov    0x805048,%eax
  802c22:	85 c0                	test   %eax,%eax
  802c24:	0f 84 64 02 00 00    	je     802e8e <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802c2a:	a1 48 50 80 00       	mov    0x805048,%eax
  802c2f:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802c32:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c36:	75 17                	jne    802c4f <alloc_block+0x199>
  802c38:	83 ec 04             	sub    $0x4,%esp
  802c3b:	68 39 44 80 00       	push   $0x804439
  802c40:	68 a0 00 00 00       	push   $0xa0
  802c45:	68 9f 43 80 00       	push   $0x80439f
  802c4a:	e8 b5 08 00 00       	call   803504 <_panic>
  802c4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c52:	8b 00                	mov    (%eax),%eax
  802c54:	85 c0                	test   %eax,%eax
  802c56:	74 10                	je     802c68 <alloc_block+0x1b2>
  802c58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c5b:	8b 00                	mov    (%eax),%eax
  802c5d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c60:	8b 52 04             	mov    0x4(%edx),%edx
  802c63:	89 50 04             	mov    %edx,0x4(%eax)
  802c66:	eb 0b                	jmp    802c73 <alloc_block+0x1bd>
  802c68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c6b:	8b 40 04             	mov    0x4(%eax),%eax
  802c6e:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802c73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c76:	8b 40 04             	mov    0x4(%eax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	74 0f                	je     802c8c <alloc_block+0x1d6>
  802c7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c80:	8b 40 04             	mov    0x4(%eax),%eax
  802c83:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c86:	8b 12                	mov    (%edx),%edx
  802c88:	89 10                	mov    %edx,(%eax)
  802c8a:	eb 0a                	jmp    802c96 <alloc_block+0x1e0>
  802c8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c8f:	8b 00                	mov    (%eax),%eax
  802c91:	a3 48 50 80 00       	mov    %eax,0x805048
  802c96:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ca2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca9:	a1 54 50 80 00       	mov    0x805054,%eax
  802cae:	48                   	dec    %eax
  802caf:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802cb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cb7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cba:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802cbe:	b8 00 10 00 00       	mov    $0x1000,%eax
  802cc3:	99                   	cltd   
  802cc4:	f7 7d e8             	idivl  -0x18(%ebp)
  802cc7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cca:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802cce:	83 ec 0c             	sub    $0xc,%esp
  802cd1:	ff 75 dc             	pushl  -0x24(%ebp)
  802cd4:	e8 ce fa ff ff       	call   8027a7 <to_page_va>
  802cd9:	83 c4 10             	add    $0x10,%esp
  802cdc:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802cdf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ce2:	83 ec 0c             	sub    $0xc,%esp
  802ce5:	50                   	push   %eax
  802ce6:	e8 c0 ee ff ff       	call   801bab <get_page>
  802ceb:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802cee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802cf5:	e9 aa 00 00 00       	jmp    802da4 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802d01:	89 c2                	mov    %eax,%edx
  802d03:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d06:	01 d0                	add    %edx,%eax
  802d08:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802d0b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d0f:	75 17                	jne    802d28 <alloc_block+0x272>
  802d11:	83 ec 04             	sub    $0x4,%esp
  802d14:	68 58 44 80 00       	push   $0x804458
  802d19:	68 aa 00 00 00       	push   $0xaa
  802d1e:	68 9f 43 80 00       	push   $0x80439f
  802d23:	e8 dc 07 00 00       	call   803504 <_panic>
  802d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d2b:	c1 e0 04             	shl    $0x4,%eax
  802d2e:	05 84 d0 81 00       	add    $0x81d084,%eax
  802d33:	8b 10                	mov    (%eax),%edx
  802d35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d38:	89 50 04             	mov    %edx,0x4(%eax)
  802d3b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d3e:	8b 40 04             	mov    0x4(%eax),%eax
  802d41:	85 c0                	test   %eax,%eax
  802d43:	74 14                	je     802d59 <alloc_block+0x2a3>
  802d45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d48:	c1 e0 04             	shl    $0x4,%eax
  802d4b:	05 84 d0 81 00       	add    $0x81d084,%eax
  802d50:	8b 00                	mov    (%eax),%eax
  802d52:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802d55:	89 10                	mov    %edx,(%eax)
  802d57:	eb 11                	jmp    802d6a <alloc_block+0x2b4>
  802d59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d5c:	c1 e0 04             	shl    $0x4,%eax
  802d5f:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802d65:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d68:	89 02                	mov    %eax,(%edx)
  802d6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d6d:	c1 e0 04             	shl    $0x4,%eax
  802d70:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802d76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d79:	89 02                	mov    %eax,(%edx)
  802d7b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d87:	c1 e0 04             	shl    $0x4,%eax
  802d8a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d8f:	8b 00                	mov    (%eax),%eax
  802d91:	8d 50 01             	lea    0x1(%eax),%edx
  802d94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d97:	c1 e0 04             	shl    $0x4,%eax
  802d9a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d9f:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802da1:	ff 45 f4             	incl   -0xc(%ebp)
  802da4:	b8 00 10 00 00       	mov    $0x1000,%eax
  802da9:	99                   	cltd   
  802daa:	f7 7d e8             	idivl  -0x18(%ebp)
  802dad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802db0:	0f 8f 44 ff ff ff    	jg     802cfa <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db9:	c1 e0 04             	shl    $0x4,%eax
  802dbc:	05 80 d0 81 00       	add    $0x81d080,%eax
  802dc1:	8b 00                	mov    (%eax),%eax
  802dc3:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802dc6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802dca:	75 17                	jne    802de3 <alloc_block+0x32d>
  802dcc:	83 ec 04             	sub    $0x4,%esp
  802dcf:	68 39 44 80 00       	push   $0x804439
  802dd4:	68 ae 00 00 00       	push   $0xae
  802dd9:	68 9f 43 80 00       	push   $0x80439f
  802dde:	e8 21 07 00 00       	call   803504 <_panic>
  802de3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802de6:	8b 00                	mov    (%eax),%eax
  802de8:	85 c0                	test   %eax,%eax
  802dea:	74 10                	je     802dfc <alloc_block+0x346>
  802dec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802def:	8b 00                	mov    (%eax),%eax
  802df1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802df4:	8b 52 04             	mov    0x4(%edx),%edx
  802df7:	89 50 04             	mov    %edx,0x4(%eax)
  802dfa:	eb 14                	jmp    802e10 <alloc_block+0x35a>
  802dfc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dff:	8b 40 04             	mov    0x4(%eax),%eax
  802e02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e05:	c1 e2 04             	shl    $0x4,%edx
  802e08:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802e0e:	89 02                	mov    %eax,(%edx)
  802e10:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e13:	8b 40 04             	mov    0x4(%eax),%eax
  802e16:	85 c0                	test   %eax,%eax
  802e18:	74 0f                	je     802e29 <alloc_block+0x373>
  802e1a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e1d:	8b 40 04             	mov    0x4(%eax),%eax
  802e20:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e23:	8b 12                	mov    (%edx),%edx
  802e25:	89 10                	mov    %edx,(%eax)
  802e27:	eb 13                	jmp    802e3c <alloc_block+0x386>
  802e29:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e2c:	8b 00                	mov    (%eax),%eax
  802e2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e31:	c1 e2 04             	shl    $0x4,%edx
  802e34:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802e3a:	89 02                	mov    %eax,(%edx)
  802e3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e45:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e52:	c1 e0 04             	shl    $0x4,%eax
  802e55:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e5a:	8b 00                	mov    (%eax),%eax
  802e5c:	8d 50 ff             	lea    -0x1(%eax),%edx
  802e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e62:	c1 e0 04             	shl    $0x4,%eax
  802e65:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e6a:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802e6c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e6f:	83 ec 0c             	sub    $0xc,%esp
  802e72:	50                   	push   %eax
  802e73:	e8 a1 f9 ff ff       	call   802819 <to_page_info>
  802e78:	83 c4 10             	add    $0x10,%esp
  802e7b:	89 c2                	mov    %eax,%edx
  802e7d:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802e81:	48                   	dec    %eax
  802e82:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802e86:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e89:	e9 1a 01 00 00       	jmp    802fa8 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802e8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e91:	40                   	inc    %eax
  802e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e95:	e9 ed 00 00 00       	jmp    802f87 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9d:	c1 e0 04             	shl    $0x4,%eax
  802ea0:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ea5:	8b 00                	mov    (%eax),%eax
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	0f 84 d5 00 00 00    	je     802f84 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb2:	c1 e0 04             	shl    $0x4,%eax
  802eb5:	05 80 d0 81 00       	add    $0x81d080,%eax
  802eba:	8b 00                	mov    (%eax),%eax
  802ebc:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  802ebf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ec3:	75 17                	jne    802edc <alloc_block+0x426>
  802ec5:	83 ec 04             	sub    $0x4,%esp
  802ec8:	68 39 44 80 00       	push   $0x804439
  802ecd:	68 b8 00 00 00       	push   $0xb8
  802ed2:	68 9f 43 80 00       	push   $0x80439f
  802ed7:	e8 28 06 00 00       	call   803504 <_panic>
  802edc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	85 c0                	test   %eax,%eax
  802ee3:	74 10                	je     802ef5 <alloc_block+0x43f>
  802ee5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ee8:	8b 00                	mov    (%eax),%eax
  802eea:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802eed:	8b 52 04             	mov    0x4(%edx),%edx
  802ef0:	89 50 04             	mov    %edx,0x4(%eax)
  802ef3:	eb 14                	jmp    802f09 <alloc_block+0x453>
  802ef5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ef8:	8b 40 04             	mov    0x4(%eax),%eax
  802efb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802efe:	c1 e2 04             	shl    $0x4,%edx
  802f01:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802f07:	89 02                	mov    %eax,(%edx)
  802f09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f0c:	8b 40 04             	mov    0x4(%eax),%eax
  802f0f:	85 c0                	test   %eax,%eax
  802f11:	74 0f                	je     802f22 <alloc_block+0x46c>
  802f13:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f16:	8b 40 04             	mov    0x4(%eax),%eax
  802f19:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f1c:	8b 12                	mov    (%edx),%edx
  802f1e:	89 10                	mov    %edx,(%eax)
  802f20:	eb 13                	jmp    802f35 <alloc_block+0x47f>
  802f22:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f25:	8b 00                	mov    (%eax),%eax
  802f27:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f2a:	c1 e2 04             	shl    $0x4,%edx
  802f2d:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802f33:	89 02                	mov    %eax,(%edx)
  802f35:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4b:	c1 e0 04             	shl    $0x4,%eax
  802f4e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f53:	8b 00                	mov    (%eax),%eax
  802f55:	8d 50 ff             	lea    -0x1(%eax),%edx
  802f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5b:	c1 e0 04             	shl    $0x4,%eax
  802f5e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f63:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  802f65:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f68:	83 ec 0c             	sub    $0xc,%esp
  802f6b:	50                   	push   %eax
  802f6c:	e8 a8 f8 ff ff       	call   802819 <to_page_info>
  802f71:	83 c4 10             	add    $0x10,%esp
  802f74:	89 c2                	mov    %eax,%edx
  802f76:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802f7a:	48                   	dec    %eax
  802f7b:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  802f7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f82:	eb 24                	jmp    802fa8 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802f84:	ff 45 f0             	incl   -0x10(%ebp)
  802f87:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802f8b:	0f 8e 09 ff ff ff    	jle    802e9a <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  802f91:	83 ec 04             	sub    $0x4,%esp
  802f94:	68 7b 44 80 00       	push   $0x80447b
  802f99:	68 bf 00 00 00       	push   $0xbf
  802f9e:	68 9f 43 80 00       	push   $0x80439f
  802fa3:	e8 5c 05 00 00       	call   803504 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  802fa8:	c9                   	leave  
  802fa9:	c3                   	ret    

00802faa <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  802faa:	55                   	push   %ebp
  802fab:	89 e5                	mov    %esp,%ebp
  802fad:	83 ec 14             	sub    $0x14,%esp
  802fb0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  802fb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb7:	75 07                	jne    802fc0 <log2_ceil.1520+0x16>
  802fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  802fbe:	eb 1b                	jmp    802fdb <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  802fc0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  802fc7:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  802fca:	eb 06                	jmp    802fd2 <log2_ceil.1520+0x28>
            x >>= 1;
  802fcc:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  802fcf:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  802fd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd6:	75 f4                	jne    802fcc <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  802fd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802fdb:	c9                   	leave  
  802fdc:	c3                   	ret    

00802fdd <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  802fdd:	55                   	push   %ebp
  802fde:	89 e5                	mov    %esp,%ebp
  802fe0:	83 ec 14             	sub    $0x14,%esp
  802fe3:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  802fe6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fea:	75 07                	jne    802ff3 <log2_ceil.1547+0x16>
  802fec:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff1:	eb 1b                	jmp    80300e <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  802ff3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  802ffa:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  802ffd:	eb 06                	jmp    803005 <log2_ceil.1547+0x28>
			x >>= 1;
  802fff:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  803002:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  803005:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803009:	75 f4                	jne    802fff <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  80300b:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80300e:	c9                   	leave  
  80300f:	c3                   	ret    

00803010 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803010:	55                   	push   %ebp
  803011:	89 e5                	mov    %esp,%ebp
  803013:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803016:	8b 55 08             	mov    0x8(%ebp),%edx
  803019:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80301e:	39 c2                	cmp    %eax,%edx
  803020:	72 0c                	jb     80302e <free_block+0x1e>
  803022:	8b 55 08             	mov    0x8(%ebp),%edx
  803025:	a1 40 50 80 00       	mov    0x805040,%eax
  80302a:	39 c2                	cmp    %eax,%edx
  80302c:	72 19                	jb     803047 <free_block+0x37>
  80302e:	68 80 44 80 00       	push   $0x804480
  803033:	68 02 44 80 00       	push   $0x804402
  803038:	68 d0 00 00 00       	push   $0xd0
  80303d:	68 9f 43 80 00       	push   $0x80439f
  803042:	e8 bd 04 00 00       	call   803504 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803047:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80304b:	0f 84 42 03 00 00    	je     803393 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  803051:	8b 55 08             	mov    0x8(%ebp),%edx
  803054:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803059:	39 c2                	cmp    %eax,%edx
  80305b:	72 0c                	jb     803069 <free_block+0x59>
  80305d:	8b 55 08             	mov    0x8(%ebp),%edx
  803060:	a1 40 50 80 00       	mov    0x805040,%eax
  803065:	39 c2                	cmp    %eax,%edx
  803067:	72 17                	jb     803080 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803069:	83 ec 04             	sub    $0x4,%esp
  80306c:	68 b8 44 80 00       	push   $0x8044b8
  803071:	68 e6 00 00 00       	push   $0xe6
  803076:	68 9f 43 80 00       	push   $0x80439f
  80307b:	e8 84 04 00 00       	call   803504 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  803080:	8b 55 08             	mov    0x8(%ebp),%edx
  803083:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803088:	29 c2                	sub    %eax,%edx
  80308a:	89 d0                	mov    %edx,%eax
  80308c:	83 e0 07             	and    $0x7,%eax
  80308f:	85 c0                	test   %eax,%eax
  803091:	74 17                	je     8030aa <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803093:	83 ec 04             	sub    $0x4,%esp
  803096:	68 ec 44 80 00       	push   $0x8044ec
  80309b:	68 ea 00 00 00       	push   $0xea
  8030a0:	68 9f 43 80 00       	push   $0x80439f
  8030a5:	e8 5a 04 00 00       	call   803504 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ad:	83 ec 0c             	sub    $0xc,%esp
  8030b0:	50                   	push   %eax
  8030b1:	e8 63 f7 ff ff       	call   802819 <to_page_info>
  8030b6:	83 c4 10             	add    $0x10,%esp
  8030b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8030bc:	83 ec 0c             	sub    $0xc,%esp
  8030bf:	ff 75 08             	pushl  0x8(%ebp)
  8030c2:	e8 87 f9 ff ff       	call   802a4e <get_block_size>
  8030c7:	83 c4 10             	add    $0x10,%esp
  8030ca:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8030cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d1:	75 17                	jne    8030ea <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8030d3:	83 ec 04             	sub    $0x4,%esp
  8030d6:	68 18 45 80 00       	push   $0x804518
  8030db:	68 f1 00 00 00       	push   $0xf1
  8030e0:	68 9f 43 80 00       	push   $0x80439f
  8030e5:	e8 1a 04 00 00       	call   803504 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8030ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ed:	83 ec 0c             	sub    $0xc,%esp
  8030f0:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8030f3:	52                   	push   %edx
  8030f4:	89 c1                	mov    %eax,%ecx
  8030f6:	e8 e2 fe ff ff       	call   802fdd <log2_ceil.1547>
  8030fb:	83 c4 10             	add    $0x10,%esp
  8030fe:	83 e8 03             	sub    $0x3,%eax
  803101:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  80310a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80310e:	75 17                	jne    803127 <free_block+0x117>
  803110:	83 ec 04             	sub    $0x4,%esp
  803113:	68 64 45 80 00       	push   $0x804564
  803118:	68 f6 00 00 00       	push   $0xf6
  80311d:	68 9f 43 80 00       	push   $0x80439f
  803122:	e8 dd 03 00 00       	call   803504 <_panic>
  803127:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312a:	c1 e0 04             	shl    $0x4,%eax
  80312d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803132:	8b 10                	mov    (%eax),%edx
  803134:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803137:	89 10                	mov    %edx,(%eax)
  803139:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	85 c0                	test   %eax,%eax
  803140:	74 15                	je     803157 <free_block+0x147>
  803142:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803145:	c1 e0 04             	shl    $0x4,%eax
  803148:	05 80 d0 81 00       	add    $0x81d080,%eax
  80314d:	8b 00                	mov    (%eax),%eax
  80314f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803152:	89 50 04             	mov    %edx,0x4(%eax)
  803155:	eb 11                	jmp    803168 <free_block+0x158>
  803157:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315a:	c1 e0 04             	shl    $0x4,%eax
  80315d:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803163:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803166:	89 02                	mov    %eax,(%edx)
  803168:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80316b:	c1 e0 04             	shl    $0x4,%eax
  80316e:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803174:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803177:	89 02                	mov    %eax,(%edx)
  803179:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80317c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803183:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803186:	c1 e0 04             	shl    $0x4,%eax
  803189:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80318e:	8b 00                	mov    (%eax),%eax
  803190:	8d 50 01             	lea    0x1(%eax),%edx
  803193:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803196:	c1 e0 04             	shl    $0x4,%eax
  803199:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80319e:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8031a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a3:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8031a7:	40                   	inc    %eax
  8031a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031ab:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8031af:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b2:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031b7:	29 c2                	sub    %eax,%edx
  8031b9:	89 d0                	mov    %edx,%eax
  8031bb:	c1 e8 0c             	shr    $0xc,%eax
  8031be:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8031c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c4:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8031c8:	0f b7 c8             	movzwl %ax,%ecx
  8031cb:	b8 00 10 00 00       	mov    $0x1000,%eax
  8031d0:	99                   	cltd   
  8031d1:	f7 7d e8             	idivl  -0x18(%ebp)
  8031d4:	39 c1                	cmp    %eax,%ecx
  8031d6:	0f 85 b8 01 00 00    	jne    803394 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8031dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8031e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e6:	c1 e0 04             	shl    $0x4,%eax
  8031e9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8031ee:	8b 00                	mov    (%eax),%eax
  8031f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8031f3:	e9 d5 00 00 00       	jmp    8032cd <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  8031f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fb:	8b 00                	mov    (%eax),%eax
  8031fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803200:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803203:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803208:	29 c2                	sub    %eax,%edx
  80320a:	89 d0                	mov    %edx,%eax
  80320c:	c1 e8 0c             	shr    $0xc,%eax
  80320f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803212:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803215:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803218:	0f 85 a9 00 00 00    	jne    8032c7 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  80321e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803222:	75 17                	jne    80323b <free_block+0x22b>
  803224:	83 ec 04             	sub    $0x4,%esp
  803227:	68 39 44 80 00       	push   $0x804439
  80322c:	68 04 01 00 00       	push   $0x104
  803231:	68 9f 43 80 00       	push   $0x80439f
  803236:	e8 c9 02 00 00       	call   803504 <_panic>
  80323b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323e:	8b 00                	mov    (%eax),%eax
  803240:	85 c0                	test   %eax,%eax
  803242:	74 10                	je     803254 <free_block+0x244>
  803244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803247:	8b 00                	mov    (%eax),%eax
  803249:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80324c:	8b 52 04             	mov    0x4(%edx),%edx
  80324f:	89 50 04             	mov    %edx,0x4(%eax)
  803252:	eb 14                	jmp    803268 <free_block+0x258>
  803254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803257:	8b 40 04             	mov    0x4(%eax),%eax
  80325a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80325d:	c1 e2 04             	shl    $0x4,%edx
  803260:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803266:	89 02                	mov    %eax,(%edx)
  803268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326b:	8b 40 04             	mov    0x4(%eax),%eax
  80326e:	85 c0                	test   %eax,%eax
  803270:	74 0f                	je     803281 <free_block+0x271>
  803272:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803275:	8b 40 04             	mov    0x4(%eax),%eax
  803278:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80327b:	8b 12                	mov    (%edx),%edx
  80327d:	89 10                	mov    %edx,(%eax)
  80327f:	eb 13                	jmp    803294 <free_block+0x284>
  803281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803284:	8b 00                	mov    (%eax),%eax
  803286:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803289:	c1 e2 04             	shl    $0x4,%edx
  80328c:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803292:	89 02                	mov    %eax,(%edx)
  803294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803297:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032aa:	c1 e0 04             	shl    $0x4,%eax
  8032ad:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032b2:	8b 00                	mov    (%eax),%eax
  8032b4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8032b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ba:	c1 e0 04             	shl    $0x4,%eax
  8032bd:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032c2:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8032c4:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8032c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8032cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032d1:	0f 85 21 ff ff ff    	jne    8031f8 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8032d7:	b8 00 10 00 00       	mov    $0x1000,%eax
  8032dc:	99                   	cltd   
  8032dd:	f7 7d e8             	idivl  -0x18(%ebp)
  8032e0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8032e3:	74 17                	je     8032fc <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8032e5:	83 ec 04             	sub    $0x4,%esp
  8032e8:	68 88 45 80 00       	push   $0x804588
  8032ed:	68 0c 01 00 00       	push   $0x10c
  8032f2:	68 9f 43 80 00       	push   $0x80439f
  8032f7:	e8 08 02 00 00       	call   803504 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  8032fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ff:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803305:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803308:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  80330e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803312:	75 17                	jne    80332b <free_block+0x31b>
  803314:	83 ec 04             	sub    $0x4,%esp
  803317:	68 58 44 80 00       	push   $0x804458
  80331c:	68 11 01 00 00       	push   $0x111
  803321:	68 9f 43 80 00       	push   $0x80439f
  803326:	e8 d9 01 00 00       	call   803504 <_panic>
  80332b:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803331:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803334:	89 50 04             	mov    %edx,0x4(%eax)
  803337:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333a:	8b 40 04             	mov    0x4(%eax),%eax
  80333d:	85 c0                	test   %eax,%eax
  80333f:	74 0c                	je     80334d <free_block+0x33d>
  803341:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803346:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803349:	89 10                	mov    %edx,(%eax)
  80334b:	eb 08                	jmp    803355 <free_block+0x345>
  80334d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803350:	a3 48 50 80 00       	mov    %eax,0x805048
  803355:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803358:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80335d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803360:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803366:	a1 54 50 80 00       	mov    0x805054,%eax
  80336b:	40                   	inc    %eax
  80336c:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803371:	83 ec 0c             	sub    $0xc,%esp
  803374:	ff 75 ec             	pushl  -0x14(%ebp)
  803377:	e8 2b f4 ff ff       	call   8027a7 <to_page_va>
  80337c:	83 c4 10             	add    $0x10,%esp
  80337f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803382:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803385:	83 ec 0c             	sub    $0xc,%esp
  803388:	50                   	push   %eax
  803389:	e8 69 e8 ff ff       	call   801bf7 <return_page>
  80338e:	83 c4 10             	add    $0x10,%esp
  803391:	eb 01                	jmp    803394 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803393:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803394:	c9                   	leave  
  803395:	c3                   	ret    

00803396 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803396:	55                   	push   %ebp
  803397:	89 e5                	mov    %esp,%ebp
  803399:	83 ec 14             	sub    $0x14,%esp
  80339c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  80339f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8033a3:	77 07                	ja     8033ac <nearest_pow2_ceil.1572+0x16>
      return 1;
  8033a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8033aa:	eb 20                	jmp    8033cc <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8033ac:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8033b3:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8033b6:	eb 08                	jmp    8033c0 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8033b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033bb:	01 c0                	add    %eax,%eax
  8033bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8033c0:	d1 6d 08             	shrl   0x8(%ebp)
  8033c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033c7:	75 ef                	jne    8033b8 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8033c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8033cc:	c9                   	leave  
  8033cd:	c3                   	ret    

008033ce <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8033ce:	55                   	push   %ebp
  8033cf:	89 e5                	mov    %esp,%ebp
  8033d1:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8033d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d8:	75 13                	jne    8033ed <realloc_block+0x1f>
    return alloc_block(new_size);
  8033da:	83 ec 0c             	sub    $0xc,%esp
  8033dd:	ff 75 0c             	pushl  0xc(%ebp)
  8033e0:	e8 d1 f6 ff ff       	call   802ab6 <alloc_block>
  8033e5:	83 c4 10             	add    $0x10,%esp
  8033e8:	e9 d9 00 00 00       	jmp    8034c6 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  8033ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033f1:	75 18                	jne    80340b <realloc_block+0x3d>
    free_block(va);
  8033f3:	83 ec 0c             	sub    $0xc,%esp
  8033f6:	ff 75 08             	pushl  0x8(%ebp)
  8033f9:	e8 12 fc ff ff       	call   803010 <free_block>
  8033fe:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803401:	b8 00 00 00 00       	mov    $0x0,%eax
  803406:	e9 bb 00 00 00       	jmp    8034c6 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  80340b:	83 ec 0c             	sub    $0xc,%esp
  80340e:	ff 75 08             	pushl  0x8(%ebp)
  803411:	e8 38 f6 ff ff       	call   802a4e <get_block_size>
  803416:	83 c4 10             	add    $0x10,%esp
  803419:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  80341c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803423:	8b 45 0c             	mov    0xc(%ebp),%eax
  803426:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803429:	73 06                	jae    803431 <realloc_block+0x63>
    new_size = min_block_size;
  80342b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342e:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803431:	83 ec 0c             	sub    $0xc,%esp
  803434:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803437:	ff 75 0c             	pushl  0xc(%ebp)
  80343a:	89 c1                	mov    %eax,%ecx
  80343c:	e8 55 ff ff ff       	call   803396 <nearest_pow2_ceil.1572>
  803441:	83 c4 10             	add    $0x10,%esp
  803444:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80344d:	75 05                	jne    803454 <realloc_block+0x86>
    return va;
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	eb 72                	jmp    8034c6 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803454:	83 ec 0c             	sub    $0xc,%esp
  803457:	ff 75 0c             	pushl  0xc(%ebp)
  80345a:	e8 57 f6 ff ff       	call   802ab6 <alloc_block>
  80345f:	83 c4 10             	add    $0x10,%esp
  803462:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803465:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803469:	75 07                	jne    803472 <realloc_block+0xa4>
    return NULL;
  80346b:	b8 00 00 00 00       	mov    $0x0,%eax
  803470:	eb 54                	jmp    8034c6 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803472:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803475:	8b 45 0c             	mov    0xc(%ebp),%eax
  803478:	39 d0                	cmp    %edx,%eax
  80347a:	76 02                	jbe    80347e <realloc_block+0xb0>
  80347c:	89 d0                	mov    %edx,%eax
  80347e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803481:	8b 45 08             	mov    0x8(%ebp),%eax
  803484:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  80348d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803494:	eb 17                	jmp    8034ad <realloc_block+0xdf>
    dst[i] = src[i];
  803496:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349c:	01 c2                	add    %eax,%edx
  80349e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a4:	01 c8                	add    %ecx,%eax
  8034a6:	8a 00                	mov    (%eax),%al
  8034a8:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  8034aa:	ff 45 f4             	incl   -0xc(%ebp)
  8034ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8034b3:	72 e1                	jb     803496 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  8034b5:	83 ec 0c             	sub    $0xc,%esp
  8034b8:	ff 75 08             	pushl  0x8(%ebp)
  8034bb:	e8 50 fb ff ff       	call   803010 <free_block>
  8034c0:	83 c4 10             	add    $0x10,%esp

  return new_va;
  8034c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8034c6:	c9                   	leave  
  8034c7:	c3                   	ret    

008034c8 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8034c8:	55                   	push   %ebp
  8034c9:	89 e5                	mov    %esp,%ebp
  8034cb:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8034ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8034d4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8034d8:	83 ec 0c             	sub    $0xc,%esp
  8034db:	50                   	push   %eax
  8034dc:	e8 d2 ee ff ff       	call   8023b3 <sys_cputc>
  8034e1:	83 c4 10             	add    $0x10,%esp
}
  8034e4:	90                   	nop
  8034e5:	c9                   	leave  
  8034e6:	c3                   	ret    

008034e7 <getchar>:


int
getchar(void)
{
  8034e7:	55                   	push   %ebp
  8034e8:	89 e5                	mov    %esp,%ebp
  8034ea:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8034ed:	e8 60 ed ff ff       	call   802252 <sys_cgetc>
  8034f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8034f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8034f8:	c9                   	leave  
  8034f9:	c3                   	ret    

008034fa <iscons>:

int iscons(int fdnum)
{
  8034fa:	55                   	push   %ebp
  8034fb:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8034fd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803502:	5d                   	pop    %ebp
  803503:	c3                   	ret    

00803504 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803504:	55                   	push   %ebp
  803505:	89 e5                	mov    %esp,%ebp
  803507:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80350a:	8d 45 10             	lea    0x10(%ebp),%eax
  80350d:	83 c0 04             	add    $0x4,%eax
  803510:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803513:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  803518:	85 c0                	test   %eax,%eax
  80351a:	74 16                	je     803532 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80351c:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  803521:	83 ec 08             	sub    $0x8,%esp
  803524:	50                   	push   %eax
  803525:	68 bc 45 80 00       	push   $0x8045bc
  80352a:	e8 d8 ce ff ff       	call   800407 <cprintf>
  80352f:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803532:	a1 04 50 80 00       	mov    0x805004,%eax
  803537:	83 ec 0c             	sub    $0xc,%esp
  80353a:	ff 75 0c             	pushl  0xc(%ebp)
  80353d:	ff 75 08             	pushl  0x8(%ebp)
  803540:	50                   	push   %eax
  803541:	68 c4 45 80 00       	push   $0x8045c4
  803546:	6a 74                	push   $0x74
  803548:	e8 e7 ce ff ff       	call   800434 <cprintf_colored>
  80354d:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803550:	8b 45 10             	mov    0x10(%ebp),%eax
  803553:	83 ec 08             	sub    $0x8,%esp
  803556:	ff 75 f4             	pushl  -0xc(%ebp)
  803559:	50                   	push   %eax
  80355a:	e8 39 ce ff ff       	call   800398 <vcprintf>
  80355f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803562:	83 ec 08             	sub    $0x8,%esp
  803565:	6a 00                	push   $0x0
  803567:	68 ec 45 80 00       	push   $0x8045ec
  80356c:	e8 27 ce ff ff       	call   800398 <vcprintf>
  803571:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803574:	e8 a0 cd ff ff       	call   800319 <exit>

	// should not return here
	while (1) ;
  803579:	eb fe                	jmp    803579 <_panic+0x75>

0080357b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80357b:	55                   	push   %ebp
  80357c:	89 e5                	mov    %esp,%ebp
  80357e:	53                   	push   %ebx
  80357f:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803582:	a1 20 50 80 00       	mov    0x805020,%eax
  803587:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80358d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803590:	39 c2                	cmp    %eax,%edx
  803592:	74 14                	je     8035a8 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803594:	83 ec 04             	sub    $0x4,%esp
  803597:	68 f0 45 80 00       	push   $0x8045f0
  80359c:	6a 26                	push   $0x26
  80359e:	68 3c 46 80 00       	push   $0x80463c
  8035a3:	e8 5c ff ff ff       	call   803504 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8035a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8035af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8035b6:	e9 d9 00 00 00       	jmp    803694 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8035bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c8:	01 d0                	add    %edx,%eax
  8035ca:	8b 00                	mov    (%eax),%eax
  8035cc:	85 c0                	test   %eax,%eax
  8035ce:	75 08                	jne    8035d8 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8035d0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8035d3:	e9 b9 00 00 00       	jmp    803691 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8035d8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8035df:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8035e6:	eb 79                	jmp    803661 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8035e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8035ed:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8035f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035f6:	89 d0                	mov    %edx,%eax
  8035f8:	01 c0                	add    %eax,%eax
  8035fa:	01 d0                	add    %edx,%eax
  8035fc:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803603:	01 d8                	add    %ebx,%eax
  803605:	01 d0                	add    %edx,%eax
  803607:	01 c8                	add    %ecx,%eax
  803609:	8a 40 04             	mov    0x4(%eax),%al
  80360c:	84 c0                	test   %al,%al
  80360e:	75 4e                	jne    80365e <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803610:	a1 20 50 80 00       	mov    0x805020,%eax
  803615:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80361b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80361e:	89 d0                	mov    %edx,%eax
  803620:	01 c0                	add    %eax,%eax
  803622:	01 d0                	add    %edx,%eax
  803624:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80362b:	01 d8                	add    %ebx,%eax
  80362d:	01 d0                	add    %edx,%eax
  80362f:	01 c8                	add    %ecx,%eax
  803631:	8b 00                	mov    (%eax),%eax
  803633:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803636:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803639:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80363e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803643:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80364a:	8b 45 08             	mov    0x8(%ebp),%eax
  80364d:	01 c8                	add    %ecx,%eax
  80364f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803651:	39 c2                	cmp    %eax,%edx
  803653:	75 09                	jne    80365e <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  803655:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80365c:	eb 19                	jmp    803677 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80365e:	ff 45 e8             	incl   -0x18(%ebp)
  803661:	a1 20 50 80 00       	mov    0x805020,%eax
  803666:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80366c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366f:	39 c2                	cmp    %eax,%edx
  803671:	0f 87 71 ff ff ff    	ja     8035e8 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803677:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80367b:	75 14                	jne    803691 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80367d:	83 ec 04             	sub    $0x4,%esp
  803680:	68 48 46 80 00       	push   $0x804648
  803685:	6a 3a                	push   $0x3a
  803687:	68 3c 46 80 00       	push   $0x80463c
  80368c:	e8 73 fe ff ff       	call   803504 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803691:	ff 45 f0             	incl   -0x10(%ebp)
  803694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803697:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80369a:	0f 8c 1b ff ff ff    	jl     8035bb <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8036a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036a7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8036ae:	eb 2e                	jmp    8036de <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8036b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8036b5:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8036bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036be:	89 d0                	mov    %edx,%eax
  8036c0:	01 c0                	add    %eax,%eax
  8036c2:	01 d0                	add    %edx,%eax
  8036c4:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8036cb:	01 d8                	add    %ebx,%eax
  8036cd:	01 d0                	add    %edx,%eax
  8036cf:	01 c8                	add    %ecx,%eax
  8036d1:	8a 40 04             	mov    0x4(%eax),%al
  8036d4:	3c 01                	cmp    $0x1,%al
  8036d6:	75 03                	jne    8036db <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8036d8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036db:	ff 45 e0             	incl   -0x20(%ebp)
  8036de:	a1 20 50 80 00       	mov    0x805020,%eax
  8036e3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8036e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036ec:	39 c2                	cmp    %eax,%edx
  8036ee:	77 c0                	ja     8036b0 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8036f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8036f6:	74 14                	je     80370c <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8036f8:	83 ec 04             	sub    $0x4,%esp
  8036fb:	68 9c 46 80 00       	push   $0x80469c
  803700:	6a 44                	push   $0x44
  803702:	68 3c 46 80 00       	push   $0x80463c
  803707:	e8 f8 fd ff ff       	call   803504 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80370c:	90                   	nop
  80370d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803710:	c9                   	leave  
  803711:	c3                   	ret    
  803712:	66 90                	xchg   %ax,%ax

00803714 <__udivdi3>:
  803714:	55                   	push   %ebp
  803715:	57                   	push   %edi
  803716:	56                   	push   %esi
  803717:	53                   	push   %ebx
  803718:	83 ec 1c             	sub    $0x1c,%esp
  80371b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80371f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803723:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803727:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80372b:	89 ca                	mov    %ecx,%edx
  80372d:	89 f8                	mov    %edi,%eax
  80372f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803733:	85 f6                	test   %esi,%esi
  803735:	75 2d                	jne    803764 <__udivdi3+0x50>
  803737:	39 cf                	cmp    %ecx,%edi
  803739:	77 65                	ja     8037a0 <__udivdi3+0x8c>
  80373b:	89 fd                	mov    %edi,%ebp
  80373d:	85 ff                	test   %edi,%edi
  80373f:	75 0b                	jne    80374c <__udivdi3+0x38>
  803741:	b8 01 00 00 00       	mov    $0x1,%eax
  803746:	31 d2                	xor    %edx,%edx
  803748:	f7 f7                	div    %edi
  80374a:	89 c5                	mov    %eax,%ebp
  80374c:	31 d2                	xor    %edx,%edx
  80374e:	89 c8                	mov    %ecx,%eax
  803750:	f7 f5                	div    %ebp
  803752:	89 c1                	mov    %eax,%ecx
  803754:	89 d8                	mov    %ebx,%eax
  803756:	f7 f5                	div    %ebp
  803758:	89 cf                	mov    %ecx,%edi
  80375a:	89 fa                	mov    %edi,%edx
  80375c:	83 c4 1c             	add    $0x1c,%esp
  80375f:	5b                   	pop    %ebx
  803760:	5e                   	pop    %esi
  803761:	5f                   	pop    %edi
  803762:	5d                   	pop    %ebp
  803763:	c3                   	ret    
  803764:	39 ce                	cmp    %ecx,%esi
  803766:	77 28                	ja     803790 <__udivdi3+0x7c>
  803768:	0f bd fe             	bsr    %esi,%edi
  80376b:	83 f7 1f             	xor    $0x1f,%edi
  80376e:	75 40                	jne    8037b0 <__udivdi3+0x9c>
  803770:	39 ce                	cmp    %ecx,%esi
  803772:	72 0a                	jb     80377e <__udivdi3+0x6a>
  803774:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803778:	0f 87 9e 00 00 00    	ja     80381c <__udivdi3+0x108>
  80377e:	b8 01 00 00 00       	mov    $0x1,%eax
  803783:	89 fa                	mov    %edi,%edx
  803785:	83 c4 1c             	add    $0x1c,%esp
  803788:	5b                   	pop    %ebx
  803789:	5e                   	pop    %esi
  80378a:	5f                   	pop    %edi
  80378b:	5d                   	pop    %ebp
  80378c:	c3                   	ret    
  80378d:	8d 76 00             	lea    0x0(%esi),%esi
  803790:	31 ff                	xor    %edi,%edi
  803792:	31 c0                	xor    %eax,%eax
  803794:	89 fa                	mov    %edi,%edx
  803796:	83 c4 1c             	add    $0x1c,%esp
  803799:	5b                   	pop    %ebx
  80379a:	5e                   	pop    %esi
  80379b:	5f                   	pop    %edi
  80379c:	5d                   	pop    %ebp
  80379d:	c3                   	ret    
  80379e:	66 90                	xchg   %ax,%ax
  8037a0:	89 d8                	mov    %ebx,%eax
  8037a2:	f7 f7                	div    %edi
  8037a4:	31 ff                	xor    %edi,%edi
  8037a6:	89 fa                	mov    %edi,%edx
  8037a8:	83 c4 1c             	add    $0x1c,%esp
  8037ab:	5b                   	pop    %ebx
  8037ac:	5e                   	pop    %esi
  8037ad:	5f                   	pop    %edi
  8037ae:	5d                   	pop    %ebp
  8037af:	c3                   	ret    
  8037b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037b5:	89 eb                	mov    %ebp,%ebx
  8037b7:	29 fb                	sub    %edi,%ebx
  8037b9:	89 f9                	mov    %edi,%ecx
  8037bb:	d3 e6                	shl    %cl,%esi
  8037bd:	89 c5                	mov    %eax,%ebp
  8037bf:	88 d9                	mov    %bl,%cl
  8037c1:	d3 ed                	shr    %cl,%ebp
  8037c3:	89 e9                	mov    %ebp,%ecx
  8037c5:	09 f1                	or     %esi,%ecx
  8037c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037cb:	89 f9                	mov    %edi,%ecx
  8037cd:	d3 e0                	shl    %cl,%eax
  8037cf:	89 c5                	mov    %eax,%ebp
  8037d1:	89 d6                	mov    %edx,%esi
  8037d3:	88 d9                	mov    %bl,%cl
  8037d5:	d3 ee                	shr    %cl,%esi
  8037d7:	89 f9                	mov    %edi,%ecx
  8037d9:	d3 e2                	shl    %cl,%edx
  8037db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037df:	88 d9                	mov    %bl,%cl
  8037e1:	d3 e8                	shr    %cl,%eax
  8037e3:	09 c2                	or     %eax,%edx
  8037e5:	89 d0                	mov    %edx,%eax
  8037e7:	89 f2                	mov    %esi,%edx
  8037e9:	f7 74 24 0c          	divl   0xc(%esp)
  8037ed:	89 d6                	mov    %edx,%esi
  8037ef:	89 c3                	mov    %eax,%ebx
  8037f1:	f7 e5                	mul    %ebp
  8037f3:	39 d6                	cmp    %edx,%esi
  8037f5:	72 19                	jb     803810 <__udivdi3+0xfc>
  8037f7:	74 0b                	je     803804 <__udivdi3+0xf0>
  8037f9:	89 d8                	mov    %ebx,%eax
  8037fb:	31 ff                	xor    %edi,%edi
  8037fd:	e9 58 ff ff ff       	jmp    80375a <__udivdi3+0x46>
  803802:	66 90                	xchg   %ax,%ax
  803804:	8b 54 24 08          	mov    0x8(%esp),%edx
  803808:	89 f9                	mov    %edi,%ecx
  80380a:	d3 e2                	shl    %cl,%edx
  80380c:	39 c2                	cmp    %eax,%edx
  80380e:	73 e9                	jae    8037f9 <__udivdi3+0xe5>
  803810:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803813:	31 ff                	xor    %edi,%edi
  803815:	e9 40 ff ff ff       	jmp    80375a <__udivdi3+0x46>
  80381a:	66 90                	xchg   %ax,%ax
  80381c:	31 c0                	xor    %eax,%eax
  80381e:	e9 37 ff ff ff       	jmp    80375a <__udivdi3+0x46>
  803823:	90                   	nop

00803824 <__umoddi3>:
  803824:	55                   	push   %ebp
  803825:	57                   	push   %edi
  803826:	56                   	push   %esi
  803827:	53                   	push   %ebx
  803828:	83 ec 1c             	sub    $0x1c,%esp
  80382b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80382f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803833:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803837:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80383b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80383f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803843:	89 f3                	mov    %esi,%ebx
  803845:	89 fa                	mov    %edi,%edx
  803847:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80384b:	89 34 24             	mov    %esi,(%esp)
  80384e:	85 c0                	test   %eax,%eax
  803850:	75 1a                	jne    80386c <__umoddi3+0x48>
  803852:	39 f7                	cmp    %esi,%edi
  803854:	0f 86 a2 00 00 00    	jbe    8038fc <__umoddi3+0xd8>
  80385a:	89 c8                	mov    %ecx,%eax
  80385c:	89 f2                	mov    %esi,%edx
  80385e:	f7 f7                	div    %edi
  803860:	89 d0                	mov    %edx,%eax
  803862:	31 d2                	xor    %edx,%edx
  803864:	83 c4 1c             	add    $0x1c,%esp
  803867:	5b                   	pop    %ebx
  803868:	5e                   	pop    %esi
  803869:	5f                   	pop    %edi
  80386a:	5d                   	pop    %ebp
  80386b:	c3                   	ret    
  80386c:	39 f0                	cmp    %esi,%eax
  80386e:	0f 87 ac 00 00 00    	ja     803920 <__umoddi3+0xfc>
  803874:	0f bd e8             	bsr    %eax,%ebp
  803877:	83 f5 1f             	xor    $0x1f,%ebp
  80387a:	0f 84 ac 00 00 00    	je     80392c <__umoddi3+0x108>
  803880:	bf 20 00 00 00       	mov    $0x20,%edi
  803885:	29 ef                	sub    %ebp,%edi
  803887:	89 fe                	mov    %edi,%esi
  803889:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80388d:	89 e9                	mov    %ebp,%ecx
  80388f:	d3 e0                	shl    %cl,%eax
  803891:	89 d7                	mov    %edx,%edi
  803893:	89 f1                	mov    %esi,%ecx
  803895:	d3 ef                	shr    %cl,%edi
  803897:	09 c7                	or     %eax,%edi
  803899:	89 e9                	mov    %ebp,%ecx
  80389b:	d3 e2                	shl    %cl,%edx
  80389d:	89 14 24             	mov    %edx,(%esp)
  8038a0:	89 d8                	mov    %ebx,%eax
  8038a2:	d3 e0                	shl    %cl,%eax
  8038a4:	89 c2                	mov    %eax,%edx
  8038a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038aa:	d3 e0                	shl    %cl,%eax
  8038ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038b4:	89 f1                	mov    %esi,%ecx
  8038b6:	d3 e8                	shr    %cl,%eax
  8038b8:	09 d0                	or     %edx,%eax
  8038ba:	d3 eb                	shr    %cl,%ebx
  8038bc:	89 da                	mov    %ebx,%edx
  8038be:	f7 f7                	div    %edi
  8038c0:	89 d3                	mov    %edx,%ebx
  8038c2:	f7 24 24             	mull   (%esp)
  8038c5:	89 c6                	mov    %eax,%esi
  8038c7:	89 d1                	mov    %edx,%ecx
  8038c9:	39 d3                	cmp    %edx,%ebx
  8038cb:	0f 82 87 00 00 00    	jb     803958 <__umoddi3+0x134>
  8038d1:	0f 84 91 00 00 00    	je     803968 <__umoddi3+0x144>
  8038d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038db:	29 f2                	sub    %esi,%edx
  8038dd:	19 cb                	sbb    %ecx,%ebx
  8038df:	89 d8                	mov    %ebx,%eax
  8038e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038e5:	d3 e0                	shl    %cl,%eax
  8038e7:	89 e9                	mov    %ebp,%ecx
  8038e9:	d3 ea                	shr    %cl,%edx
  8038eb:	09 d0                	or     %edx,%eax
  8038ed:	89 e9                	mov    %ebp,%ecx
  8038ef:	d3 eb                	shr    %cl,%ebx
  8038f1:	89 da                	mov    %ebx,%edx
  8038f3:	83 c4 1c             	add    $0x1c,%esp
  8038f6:	5b                   	pop    %ebx
  8038f7:	5e                   	pop    %esi
  8038f8:	5f                   	pop    %edi
  8038f9:	5d                   	pop    %ebp
  8038fa:	c3                   	ret    
  8038fb:	90                   	nop
  8038fc:	89 fd                	mov    %edi,%ebp
  8038fe:	85 ff                	test   %edi,%edi
  803900:	75 0b                	jne    80390d <__umoddi3+0xe9>
  803902:	b8 01 00 00 00       	mov    $0x1,%eax
  803907:	31 d2                	xor    %edx,%edx
  803909:	f7 f7                	div    %edi
  80390b:	89 c5                	mov    %eax,%ebp
  80390d:	89 f0                	mov    %esi,%eax
  80390f:	31 d2                	xor    %edx,%edx
  803911:	f7 f5                	div    %ebp
  803913:	89 c8                	mov    %ecx,%eax
  803915:	f7 f5                	div    %ebp
  803917:	89 d0                	mov    %edx,%eax
  803919:	e9 44 ff ff ff       	jmp    803862 <__umoddi3+0x3e>
  80391e:	66 90                	xchg   %ax,%ax
  803920:	89 c8                	mov    %ecx,%eax
  803922:	89 f2                	mov    %esi,%edx
  803924:	83 c4 1c             	add    $0x1c,%esp
  803927:	5b                   	pop    %ebx
  803928:	5e                   	pop    %esi
  803929:	5f                   	pop    %edi
  80392a:	5d                   	pop    %ebp
  80392b:	c3                   	ret    
  80392c:	3b 04 24             	cmp    (%esp),%eax
  80392f:	72 06                	jb     803937 <__umoddi3+0x113>
  803931:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803935:	77 0f                	ja     803946 <__umoddi3+0x122>
  803937:	89 f2                	mov    %esi,%edx
  803939:	29 f9                	sub    %edi,%ecx
  80393b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80393f:	89 14 24             	mov    %edx,(%esp)
  803942:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803946:	8b 44 24 04          	mov    0x4(%esp),%eax
  80394a:	8b 14 24             	mov    (%esp),%edx
  80394d:	83 c4 1c             	add    $0x1c,%esp
  803950:	5b                   	pop    %ebx
  803951:	5e                   	pop    %esi
  803952:	5f                   	pop    %edi
  803953:	5d                   	pop    %ebp
  803954:	c3                   	ret    
  803955:	8d 76 00             	lea    0x0(%esi),%esi
  803958:	2b 04 24             	sub    (%esp),%eax
  80395b:	19 fa                	sbb    %edi,%edx
  80395d:	89 d1                	mov    %edx,%ecx
  80395f:	89 c6                	mov    %eax,%esi
  803961:	e9 71 ff ff ff       	jmp    8038d7 <__umoddi3+0xb3>
  803966:	66 90                	xchg   %ax,%ax
  803968:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80396c:	72 ea                	jb     803958 <__umoddi3+0x134>
  80396e:	89 d9                	mov    %ebx,%ecx
  803970:	e9 62 ff ff ff       	jmp    8038d7 <__umoddi3+0xb3>
