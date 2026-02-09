
obj/user/fos_alloc:     file format elf32-i386


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


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 a3 19 00 00       	call   8019f3 <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 00 37 80 00       	push   $0x803700
  800061:	e8 d4 03 00 00       	call   80043a <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 13 37 80 00       	push   $0x803713
  8000be:	e8 77 03 00 00       	call   80043a <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 9b 1a 00 00       	call   801b77 <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 09 19 00 00       	call   8019f3 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 13 37 80 00       	push   $0x803713
  800114:	e8 21 03 00 00       	call   80043a <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 45 1a 00 00       	call   801b77 <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
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
  800141:	e8 57 21 00 00       	call   80229d <sys_getenvindex>
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
  8001bb:	bb 18 38 80 00       	mov    $0x803818,%ebx
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
  8001f0:	e8 de 22 00 00       	call   8024d3 <sys_utilities>
  8001f5:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001f8:	e8 27 1e 00 00       	call   802024 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	68 38 37 80 00       	push   $0x803738
  800205:	e8 be 01 00 00       	call   8003c8 <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80020d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800210:	85 c0                	test   %eax,%eax
  800212:	74 18                	je     80022c <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800214:	e8 d8 22 00 00       	call   8024f1 <sys_get_optimal_num_faults>
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	50                   	push   %eax
  80021d:	68 60 37 80 00       	push   $0x803760
  800222:	e8 a1 01 00 00       	call   8003c8 <cprintf>
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
  800247:	68 84 37 80 00       	push   $0x803784
  80024c:	e8 77 01 00 00       	call   8003c8 <cprintf>
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
  800278:	68 ac 37 80 00       	push   $0x8037ac
  80027d:	e8 46 01 00 00       	call   8003c8 <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800285:	a1 20 50 80 00       	mov    0x805020,%eax
  80028a:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	50                   	push   %eax
  800294:	68 04 38 80 00       	push   $0x803804
  800299:	e8 2a 01 00 00       	call   8003c8 <cprintf>
  80029e:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 38 37 80 00       	push   $0x803738
  8002a9:	e8 1a 01 00 00       	call   8003c8 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002b1:	e8 88 1d 00 00       	call   80203e <sys_unlock_cons>
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
  8002cf:	e8 95 1f 00 00       	call   802269 <sys_destroy_env>
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
  8002e0:	e8 ea 1f 00 00       	call   8022cf <sys_exit_env>
}
  8002e5:	90                   	nop
  8002e6:	c9                   	leave  
  8002e7:	c3                   	ret    

008002e8 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	53                   	push   %ebx
  8002ec:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8002ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f2:	8b 00                	mov    (%eax),%eax
  8002f4:	8d 48 01             	lea    0x1(%eax),%ecx
  8002f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002fa:	89 0a                	mov    %ecx,(%edx)
  8002fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ff:	88 d1                	mov    %dl,%cl
  800301:	8b 55 0c             	mov    0xc(%ebp),%edx
  800304:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030b:	8b 00                	mov    (%eax),%eax
  80030d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800312:	75 30                	jne    800344 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800314:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  80031a:	a0 44 50 80 00       	mov    0x805044,%al
  80031f:	0f b6 c0             	movzbl %al,%eax
  800322:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800325:	8b 09                	mov    (%ecx),%ecx
  800327:	89 cb                	mov    %ecx,%ebx
  800329:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80032c:	83 c1 08             	add    $0x8,%ecx
  80032f:	52                   	push   %edx
  800330:	50                   	push   %eax
  800331:	53                   	push   %ebx
  800332:	51                   	push   %ecx
  800333:	e8 a8 1c 00 00       	call   801fe0 <sys_cputs>
  800338:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80033b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800344:	8b 45 0c             	mov    0xc(%ebp),%eax
  800347:	8b 40 04             	mov    0x4(%eax),%eax
  80034a:	8d 50 01             	lea    0x1(%eax),%edx
  80034d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800350:	89 50 04             	mov    %edx,0x4(%eax)
}
  800353:	90                   	nop
  800354:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800362:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800369:	00 00 00 
	b.cnt = 0;
  80036c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800373:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800376:	ff 75 0c             	pushl  0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800382:	50                   	push   %eax
  800383:	68 e8 02 80 00       	push   $0x8002e8
  800388:	e8 5a 02 00 00       	call   8005e7 <vprintfmt>
  80038d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800390:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  800396:	a0 44 50 80 00       	mov    0x805044,%al
  80039b:	0f b6 c0             	movzbl %al,%eax
  80039e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8003a4:	52                   	push   %edx
  8003a5:	50                   	push   %eax
  8003a6:	51                   	push   %ecx
  8003a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ad:	83 c0 08             	add    $0x8,%eax
  8003b0:	50                   	push   %eax
  8003b1:	e8 2a 1c 00 00       	call   801fe0 <sys_cputs>
  8003b6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003b9:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8003c0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003c6:	c9                   	leave  
  8003c7:	c3                   	ret    

008003c8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003ce:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  8003d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003db:	8b 45 08             	mov    0x8(%ebp),%eax
  8003de:	83 ec 08             	sub    $0x8,%esp
  8003e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e4:	50                   	push   %eax
  8003e5:	e8 6f ff ff ff       	call   800359 <vcprintf>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003f3:	c9                   	leave  
  8003f4:	c3                   	ret    

008003f5 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8003f5:	55                   	push   %ebp
  8003f6:	89 e5                	mov    %esp,%ebp
  8003f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003fb:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800402:	8b 45 08             	mov    0x8(%ebp),%eax
  800405:	c1 e0 08             	shl    $0x8,%eax
  800408:	a3 18 d1 81 00       	mov    %eax,0x81d118
	va_start(ap, fmt);
  80040d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800410:	83 c0 04             	add    $0x4,%eax
  800413:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800416:	8b 45 0c             	mov    0xc(%ebp),%eax
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	ff 75 f4             	pushl  -0xc(%ebp)
  80041f:	50                   	push   %eax
  800420:	e8 34 ff ff ff       	call   800359 <vcprintf>
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80042b:	c7 05 18 d1 81 00 00 	movl   $0x700,0x81d118
  800432:	07 00 00 

	return cnt;
  800435:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800438:	c9                   	leave  
  800439:	c3                   	ret    

0080043a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
  80043d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800440:	e8 df 1b 00 00       	call   802024 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800445:	8d 45 0c             	lea    0xc(%ebp),%eax
  800448:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	83 ec 08             	sub    $0x8,%esp
  800451:	ff 75 f4             	pushl  -0xc(%ebp)
  800454:	50                   	push   %eax
  800455:	e8 ff fe ff ff       	call   800359 <vcprintf>
  80045a:	83 c4 10             	add    $0x10,%esp
  80045d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800460:	e8 d9 1b 00 00       	call   80203e <sys_unlock_cons>
	return cnt;
  800465:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800468:	c9                   	leave  
  800469:	c3                   	ret    

0080046a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80046a:	55                   	push   %ebp
  80046b:	89 e5                	mov    %esp,%ebp
  80046d:	53                   	push   %ebx
  80046e:	83 ec 14             	sub    $0x14,%esp
  800471:	8b 45 10             	mov    0x10(%ebp),%eax
  800474:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800477:	8b 45 14             	mov    0x14(%ebp),%eax
  80047a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80047d:	8b 45 18             	mov    0x18(%ebp),%eax
  800480:	ba 00 00 00 00       	mov    $0x0,%edx
  800485:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800488:	77 55                	ja     8004df <printnum+0x75>
  80048a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80048d:	72 05                	jb     800494 <printnum+0x2a>
  80048f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800492:	77 4b                	ja     8004df <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800494:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800497:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80049a:	8b 45 18             	mov    0x18(%ebp),%eax
  80049d:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a2:	52                   	push   %edx
  8004a3:	50                   	push   %eax
  8004a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8004aa:	e8 e1 2f 00 00       	call   803490 <__udivdi3>
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	ff 75 20             	pushl  0x20(%ebp)
  8004b8:	53                   	push   %ebx
  8004b9:	ff 75 18             	pushl  0x18(%ebp)
  8004bc:	52                   	push   %edx
  8004bd:	50                   	push   %eax
  8004be:	ff 75 0c             	pushl  0xc(%ebp)
  8004c1:	ff 75 08             	pushl  0x8(%ebp)
  8004c4:	e8 a1 ff ff ff       	call   80046a <printnum>
  8004c9:	83 c4 20             	add    $0x20,%esp
  8004cc:	eb 1a                	jmp    8004e8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	ff 75 0c             	pushl  0xc(%ebp)
  8004d4:	ff 75 20             	pushl  0x20(%ebp)
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	ff d0                	call   *%eax
  8004dc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004df:	ff 4d 1c             	decl   0x1c(%ebp)
  8004e2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004e6:	7f e6                	jg     8004ce <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004e8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004f6:	53                   	push   %ebx
  8004f7:	51                   	push   %ecx
  8004f8:	52                   	push   %edx
  8004f9:	50                   	push   %eax
  8004fa:	e8 a1 30 00 00       	call   8035a0 <__umoddi3>
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	05 94 3a 80 00       	add    $0x803a94,%eax
  800507:	8a 00                	mov    (%eax),%al
  800509:	0f be c0             	movsbl %al,%eax
  80050c:	83 ec 08             	sub    $0x8,%esp
  80050f:	ff 75 0c             	pushl  0xc(%ebp)
  800512:	50                   	push   %eax
  800513:	8b 45 08             	mov    0x8(%ebp),%eax
  800516:	ff d0                	call   *%eax
  800518:	83 c4 10             	add    $0x10,%esp
}
  80051b:	90                   	nop
  80051c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80051f:	c9                   	leave  
  800520:	c3                   	ret    

00800521 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800521:	55                   	push   %ebp
  800522:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800524:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800528:	7e 1c                	jle    800546 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	8d 50 08             	lea    0x8(%eax),%edx
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	89 10                	mov    %edx,(%eax)
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	83 e8 08             	sub    $0x8,%eax
  80053f:	8b 50 04             	mov    0x4(%eax),%edx
  800542:	8b 00                	mov    (%eax),%eax
  800544:	eb 40                	jmp    800586 <getuint+0x65>
	else if (lflag)
  800546:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80054a:	74 1e                	je     80056a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	8d 50 04             	lea    0x4(%eax),%edx
  800554:	8b 45 08             	mov    0x8(%ebp),%eax
  800557:	89 10                	mov    %edx,(%eax)
  800559:	8b 45 08             	mov    0x8(%ebp),%eax
  80055c:	8b 00                	mov    (%eax),%eax
  80055e:	83 e8 04             	sub    $0x4,%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	ba 00 00 00 00       	mov    $0x0,%edx
  800568:	eb 1c                	jmp    800586 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	8b 00                	mov    (%eax),%eax
  80056f:	8d 50 04             	lea    0x4(%eax),%edx
  800572:	8b 45 08             	mov    0x8(%ebp),%eax
  800575:	89 10                	mov    %edx,(%eax)
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	83 e8 04             	sub    $0x4,%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800586:	5d                   	pop    %ebp
  800587:	c3                   	ret    

00800588 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80058b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80058f:	7e 1c                	jle    8005ad <getint+0x25>
		return va_arg(*ap, long long);
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	8b 00                	mov    (%eax),%eax
  800596:	8d 50 08             	lea    0x8(%eax),%edx
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	89 10                	mov    %edx,(%eax)
  80059e:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	83 e8 08             	sub    $0x8,%eax
  8005a6:	8b 50 04             	mov    0x4(%eax),%edx
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	eb 38                	jmp    8005e5 <getint+0x5d>
	else if (lflag)
  8005ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005b1:	74 1a                	je     8005cd <getint+0x45>
		return va_arg(*ap, long);
  8005b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b6:	8b 00                	mov    (%eax),%eax
  8005b8:	8d 50 04             	lea    0x4(%eax),%edx
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	89 10                	mov    %edx,(%eax)
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	83 e8 04             	sub    $0x4,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	99                   	cltd   
  8005cb:	eb 18                	jmp    8005e5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	8d 50 04             	lea    0x4(%eax),%edx
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	89 10                	mov    %edx,(%eax)
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	83 e8 04             	sub    $0x4,%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	99                   	cltd   
}
  8005e5:	5d                   	pop    %ebp
  8005e6:	c3                   	ret    

008005e7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  8005ea:	56                   	push   %esi
  8005eb:	53                   	push   %ebx
  8005ec:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005ef:	eb 17                	jmp    800608 <vprintfmt+0x21>
			if (ch == '\0')
  8005f1:	85 db                	test   %ebx,%ebx
  8005f3:	0f 84 c1 03 00 00    	je     8009ba <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	ff 75 0c             	pushl  0xc(%ebp)
  8005ff:	53                   	push   %ebx
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	ff d0                	call   *%eax
  800605:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800608:	8b 45 10             	mov    0x10(%ebp),%eax
  80060b:	8d 50 01             	lea    0x1(%eax),%edx
  80060e:	89 55 10             	mov    %edx,0x10(%ebp)
  800611:	8a 00                	mov    (%eax),%al
  800613:	0f b6 d8             	movzbl %al,%ebx
  800616:	83 fb 25             	cmp    $0x25,%ebx
  800619:	75 d6                	jne    8005f1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80061b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80061f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800626:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80062d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800634:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80063b:	8b 45 10             	mov    0x10(%ebp),%eax
  80063e:	8d 50 01             	lea    0x1(%eax),%edx
  800641:	89 55 10             	mov    %edx,0x10(%ebp)
  800644:	8a 00                	mov    (%eax),%al
  800646:	0f b6 d8             	movzbl %al,%ebx
  800649:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80064c:	83 f8 5b             	cmp    $0x5b,%eax
  80064f:	0f 87 3d 03 00 00    	ja     800992 <vprintfmt+0x3ab>
  800655:	8b 04 85 b8 3a 80 00 	mov    0x803ab8(,%eax,4),%eax
  80065c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80065e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800662:	eb d7                	jmp    80063b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800664:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800668:	eb d1                	jmp    80063b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80066a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800671:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800674:	89 d0                	mov    %edx,%eax
  800676:	c1 e0 02             	shl    $0x2,%eax
  800679:	01 d0                	add    %edx,%eax
  80067b:	01 c0                	add    %eax,%eax
  80067d:	01 d8                	add    %ebx,%eax
  80067f:	83 e8 30             	sub    $0x30,%eax
  800682:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800685:	8b 45 10             	mov    0x10(%ebp),%eax
  800688:	8a 00                	mov    (%eax),%al
  80068a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80068d:	83 fb 2f             	cmp    $0x2f,%ebx
  800690:	7e 3e                	jle    8006d0 <vprintfmt+0xe9>
  800692:	83 fb 39             	cmp    $0x39,%ebx
  800695:	7f 39                	jg     8006d0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800697:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80069a:	eb d5                	jmp    800671 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	83 c0 04             	add    $0x4,%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	83 e8 04             	sub    $0x4,%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006b0:	eb 1f                	jmp    8006d1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b6:	79 83                	jns    80063b <vprintfmt+0x54>
				width = 0;
  8006b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006bf:	e9 77 ff ff ff       	jmp    80063b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006c4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006cb:	e9 6b ff ff ff       	jmp    80063b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006d0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d5:	0f 89 60 ff ff ff    	jns    80063b <vprintfmt+0x54>
				width = precision, precision = -1;
  8006db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006e1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006e8:	e9 4e ff ff ff       	jmp    80063b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006ed:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006f0:	e9 46 ff ff ff       	jmp    80063b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	83 c0 04             	add    $0x4,%eax
  8006fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	83 e8 04             	sub    $0x4,%eax
  800704:	8b 00                	mov    (%eax),%eax
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	ff 75 0c             	pushl  0xc(%ebp)
  80070c:	50                   	push   %eax
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	ff d0                	call   *%eax
  800712:	83 c4 10             	add    $0x10,%esp
			break;
  800715:	e9 9b 02 00 00       	jmp    8009b5 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	83 c0 04             	add    $0x4,%eax
  800720:	89 45 14             	mov    %eax,0x14(%ebp)
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	83 e8 04             	sub    $0x4,%eax
  800729:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80072b:	85 db                	test   %ebx,%ebx
  80072d:	79 02                	jns    800731 <vprintfmt+0x14a>
				err = -err;
  80072f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800731:	83 fb 64             	cmp    $0x64,%ebx
  800734:	7f 0b                	jg     800741 <vprintfmt+0x15a>
  800736:	8b 34 9d 00 39 80 00 	mov    0x803900(,%ebx,4),%esi
  80073d:	85 f6                	test   %esi,%esi
  80073f:	75 19                	jne    80075a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800741:	53                   	push   %ebx
  800742:	68 a5 3a 80 00       	push   $0x803aa5
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 08             	pushl  0x8(%ebp)
  80074d:	e8 70 02 00 00       	call   8009c2 <printfmt>
  800752:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800755:	e9 5b 02 00 00       	jmp    8009b5 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80075a:	56                   	push   %esi
  80075b:	68 ae 3a 80 00       	push   $0x803aae
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	ff 75 08             	pushl  0x8(%ebp)
  800766:	e8 57 02 00 00       	call   8009c2 <printfmt>
  80076b:	83 c4 10             	add    $0x10,%esp
			break;
  80076e:	e9 42 02 00 00       	jmp    8009b5 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	83 c0 04             	add    $0x4,%eax
  800779:	89 45 14             	mov    %eax,0x14(%ebp)
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	83 e8 04             	sub    $0x4,%eax
  800782:	8b 30                	mov    (%eax),%esi
  800784:	85 f6                	test   %esi,%esi
  800786:	75 05                	jne    80078d <vprintfmt+0x1a6>
				p = "(null)";
  800788:	be b1 3a 80 00       	mov    $0x803ab1,%esi
			if (width > 0 && padc != '-')
  80078d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800791:	7e 6d                	jle    800800 <vprintfmt+0x219>
  800793:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800797:	74 67                	je     800800 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	50                   	push   %eax
  8007a0:	56                   	push   %esi
  8007a1:	e8 1e 03 00 00       	call   800ac4 <strnlen>
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007ac:	eb 16                	jmp    8007c4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007ae:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	ff 75 0c             	pushl  0xc(%ebp)
  8007b8:	50                   	push   %eax
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	ff d0                	call   *%eax
  8007be:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c1:	ff 4d e4             	decl   -0x1c(%ebp)
  8007c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c8:	7f e4                	jg     8007ae <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ca:	eb 34                	jmp    800800 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007d0:	74 1c                	je     8007ee <vprintfmt+0x207>
  8007d2:	83 fb 1f             	cmp    $0x1f,%ebx
  8007d5:	7e 05                	jle    8007dc <vprintfmt+0x1f5>
  8007d7:	83 fb 7e             	cmp    $0x7e,%ebx
  8007da:	7e 12                	jle    8007ee <vprintfmt+0x207>
					putch('?', putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	ff 75 0c             	pushl  0xc(%ebp)
  8007e2:	6a 3f                	push   $0x3f
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	ff d0                	call   *%eax
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	eb 0f                	jmp    8007fd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	53                   	push   %ebx
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	ff d0                	call   *%eax
  8007fa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007fd:	ff 4d e4             	decl   -0x1c(%ebp)
  800800:	89 f0                	mov    %esi,%eax
  800802:	8d 70 01             	lea    0x1(%eax),%esi
  800805:	8a 00                	mov    (%eax),%al
  800807:	0f be d8             	movsbl %al,%ebx
  80080a:	85 db                	test   %ebx,%ebx
  80080c:	74 24                	je     800832 <vprintfmt+0x24b>
  80080e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800812:	78 b8                	js     8007cc <vprintfmt+0x1e5>
  800814:	ff 4d e0             	decl   -0x20(%ebp)
  800817:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80081b:	79 af                	jns    8007cc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80081d:	eb 13                	jmp    800832 <vprintfmt+0x24b>
				putch(' ', putdat);
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	ff 75 0c             	pushl  0xc(%ebp)
  800825:	6a 20                	push   $0x20
  800827:	8b 45 08             	mov    0x8(%ebp),%eax
  80082a:	ff d0                	call   *%eax
  80082c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80082f:	ff 4d e4             	decl   -0x1c(%ebp)
  800832:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800836:	7f e7                	jg     80081f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800838:	e9 78 01 00 00       	jmp    8009b5 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 e8             	pushl  -0x18(%ebp)
  800843:	8d 45 14             	lea    0x14(%ebp),%eax
  800846:	50                   	push   %eax
  800847:	e8 3c fd ff ff       	call   800588 <getint>
  80084c:	83 c4 10             	add    $0x10,%esp
  80084f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800852:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800858:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80085b:	85 d2                	test   %edx,%edx
  80085d:	79 23                	jns    800882 <vprintfmt+0x29b>
				putch('-', putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	6a 2d                	push   $0x2d
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	ff d0                	call   *%eax
  80086c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80086f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800875:	f7 d8                	neg    %eax
  800877:	83 d2 00             	adc    $0x0,%edx
  80087a:	f7 da                	neg    %edx
  80087c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800882:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800889:	e9 bc 00 00 00       	jmp    80094a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80088e:	83 ec 08             	sub    $0x8,%esp
  800891:	ff 75 e8             	pushl  -0x18(%ebp)
  800894:	8d 45 14             	lea    0x14(%ebp),%eax
  800897:	50                   	push   %eax
  800898:	e8 84 fc ff ff       	call   800521 <getuint>
  80089d:	83 c4 10             	add    $0x10,%esp
  8008a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008a6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ad:	e9 98 00 00 00       	jmp    80094a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	ff 75 0c             	pushl  0xc(%ebp)
  8008b8:	6a 58                	push   $0x58
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	ff d0                	call   *%eax
  8008bf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	6a 58                	push   $0x58
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	ff d0                	call   *%eax
  8008cf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	6a 58                	push   $0x58
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	ff d0                	call   *%eax
  8008df:	83 c4 10             	add    $0x10,%esp
			break;
  8008e2:	e9 ce 00 00 00       	jmp    8009b5 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 0c             	pushl  0xc(%ebp)
  8008ed:	6a 30                	push   $0x30
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	ff d0                	call   *%eax
  8008f4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	ff 75 0c             	pushl  0xc(%ebp)
  8008fd:	6a 78                	push   $0x78
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	ff d0                	call   *%eax
  800904:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	83 c0 04             	add    $0x4,%eax
  80090d:	89 45 14             	mov    %eax,0x14(%ebp)
  800910:	8b 45 14             	mov    0x14(%ebp),%eax
  800913:	83 e8 04             	sub    $0x4,%eax
  800916:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800918:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80091b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800922:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800929:	eb 1f                	jmp    80094a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 e8             	pushl  -0x18(%ebp)
  800931:	8d 45 14             	lea    0x14(%ebp),%eax
  800934:	50                   	push   %eax
  800935:	e8 e7 fb ff ff       	call   800521 <getuint>
  80093a:	83 c4 10             	add    $0x10,%esp
  80093d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800940:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800943:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80094a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80094e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800951:	83 ec 04             	sub    $0x4,%esp
  800954:	52                   	push   %edx
  800955:	ff 75 e4             	pushl  -0x1c(%ebp)
  800958:	50                   	push   %eax
  800959:	ff 75 f4             	pushl  -0xc(%ebp)
  80095c:	ff 75 f0             	pushl  -0x10(%ebp)
  80095f:	ff 75 0c             	pushl  0xc(%ebp)
  800962:	ff 75 08             	pushl  0x8(%ebp)
  800965:	e8 00 fb ff ff       	call   80046a <printnum>
  80096a:	83 c4 20             	add    $0x20,%esp
			break;
  80096d:	eb 46                	jmp    8009b5 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	53                   	push   %ebx
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	ff d0                	call   *%eax
  80097b:	83 c4 10             	add    $0x10,%esp
			break;
  80097e:	eb 35                	jmp    8009b5 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800980:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800987:	eb 2c                	jmp    8009b5 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800989:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800990:	eb 23                	jmp    8009b5 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	6a 25                	push   $0x25
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	ff d0                	call   *%eax
  80099f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009a2:	ff 4d 10             	decl   0x10(%ebp)
  8009a5:	eb 03                	jmp    8009aa <vprintfmt+0x3c3>
  8009a7:	ff 4d 10             	decl   0x10(%ebp)
  8009aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ad:	48                   	dec    %eax
  8009ae:	8a 00                	mov    (%eax),%al
  8009b0:	3c 25                	cmp    $0x25,%al
  8009b2:	75 f3                	jne    8009a7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009b4:	90                   	nop
		}
	}
  8009b5:	e9 35 fc ff ff       	jmp    8005ef <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009ba:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009be:	5b                   	pop    %ebx
  8009bf:	5e                   	pop    %esi
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009c8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009cb:	83 c0 04             	add    $0x4,%eax
  8009ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d7:	50                   	push   %eax
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	ff 75 08             	pushl  0x8(%ebp)
  8009de:	e8 04 fc ff ff       	call   8005e7 <vprintfmt>
  8009e3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009e6:	90                   	nop
  8009e7:	c9                   	leave  
  8009e8:	c3                   	ret    

008009e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ef:	8b 40 08             	mov    0x8(%eax),%eax
  8009f2:	8d 50 01             	lea    0x1(%eax),%edx
  8009f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fe:	8b 10                	mov    (%eax),%edx
  800a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a03:	8b 40 04             	mov    0x4(%eax),%eax
  800a06:	39 c2                	cmp    %eax,%edx
  800a08:	73 12                	jae    800a1c <sprintputch+0x33>
		*b->buf++ = ch;
  800a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0d:	8b 00                	mov    (%eax),%eax
  800a0f:	8d 48 01             	lea    0x1(%eax),%ecx
  800a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a15:	89 0a                	mov    %ecx,(%edx)
  800a17:	8b 55 08             	mov    0x8(%ebp),%edx
  800a1a:	88 10                	mov    %dl,(%eax)
}
  800a1c:	90                   	nop
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	01 d0                	add    %edx,%eax
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a44:	74 06                	je     800a4c <vsnprintf+0x2d>
  800a46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a4a:	7f 07                	jg     800a53 <vsnprintf+0x34>
		return -E_INVAL;
  800a4c:	b8 03 00 00 00       	mov    $0x3,%eax
  800a51:	eb 20                	jmp    800a73 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a53:	ff 75 14             	pushl  0x14(%ebp)
  800a56:	ff 75 10             	pushl  0x10(%ebp)
  800a59:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a5c:	50                   	push   %eax
  800a5d:	68 e9 09 80 00       	push   $0x8009e9
  800a62:	e8 80 fb ff ff       	call   8005e7 <vprintfmt>
  800a67:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a6d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a73:	c9                   	leave  
  800a74:	c3                   	ret    

00800a75 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800a7e:	83 c0 04             	add    $0x4,%eax
  800a81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a84:	8b 45 10             	mov    0x10(%ebp),%eax
  800a87:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8a:	50                   	push   %eax
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 89 ff ff ff       	call   800a1f <vsnprintf>
  800a96:	83 c4 10             	add    $0x10,%esp
  800a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a9f:	c9                   	leave  
  800aa0:	c3                   	ret    

00800aa1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800aa7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aae:	eb 06                	jmp    800ab6 <strlen+0x15>
		n++;
  800ab0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ab3:	ff 45 08             	incl   0x8(%ebp)
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	8a 00                	mov    (%eax),%al
  800abb:	84 c0                	test   %al,%al
  800abd:	75 f1                	jne    800ab0 <strlen+0xf>
		n++;
	return n;
  800abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ad1:	eb 09                	jmp    800adc <strnlen+0x18>
		n++;
  800ad3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ad6:	ff 45 08             	incl   0x8(%ebp)
  800ad9:	ff 4d 0c             	decl   0xc(%ebp)
  800adc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae0:	74 09                	je     800aeb <strnlen+0x27>
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	8a 00                	mov    (%eax),%al
  800ae7:	84 c0                	test   %al,%al
  800ae9:	75 e8                	jne    800ad3 <strnlen+0xf>
		n++;
	return n;
  800aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    

00800af0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800afc:	90                   	nop
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8d 50 01             	lea    0x1(%eax),%edx
  800b03:	89 55 08             	mov    %edx,0x8(%ebp)
  800b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b09:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b0c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b0f:	8a 12                	mov    (%edx),%dl
  800b11:	88 10                	mov    %dl,(%eax)
  800b13:	8a 00                	mov    (%eax),%al
  800b15:	84 c0                	test   %al,%al
  800b17:	75 e4                	jne    800afd <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b31:	eb 1f                	jmp    800b52 <strncpy+0x34>
		*dst++ = *src;
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	8d 50 01             	lea    0x1(%eax),%edx
  800b39:	89 55 08             	mov    %edx,0x8(%ebp)
  800b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3f:	8a 12                	mov    (%edx),%dl
  800b41:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8a 00                	mov    (%eax),%al
  800b48:	84 c0                	test   %al,%al
  800b4a:	74 03                	je     800b4f <strncpy+0x31>
			src++;
  800b4c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b4f:	ff 45 fc             	incl   -0x4(%ebp)
  800b52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b55:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b58:	72 d9                	jb     800b33 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b6f:	74 30                	je     800ba1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b71:	eb 16                	jmp    800b89 <strlcpy+0x2a>
			*dst++ = *src++;
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8d 50 01             	lea    0x1(%eax),%edx
  800b79:	89 55 08             	mov    %edx,0x8(%ebp)
  800b7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b82:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b85:	8a 12                	mov    (%edx),%dl
  800b87:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b89:	ff 4d 10             	decl   0x10(%ebp)
  800b8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b90:	74 09                	je     800b9b <strlcpy+0x3c>
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	8a 00                	mov    (%eax),%al
  800b97:	84 c0                	test   %al,%al
  800b99:	75 d8                	jne    800b73 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba7:	29 c2                	sub    %eax,%edx
  800ba9:	89 d0                	mov    %edx,%eax
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bb0:	eb 06                	jmp    800bb8 <strcmp+0xb>
		p++, q++;
  800bb2:	ff 45 08             	incl   0x8(%ebp)
  800bb5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8a 00                	mov    (%eax),%al
  800bbd:	84 c0                	test   %al,%al
  800bbf:	74 0e                	je     800bcf <strcmp+0x22>
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	8a 10                	mov    (%eax),%dl
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	8a 00                	mov    (%eax),%al
  800bcb:	38 c2                	cmp    %al,%dl
  800bcd:	74 e3                	je     800bb2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	8a 00                	mov    (%eax),%al
  800bd4:	0f b6 d0             	movzbl %al,%edx
  800bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bda:	8a 00                	mov    (%eax),%al
  800bdc:	0f b6 c0             	movzbl %al,%eax
  800bdf:	29 c2                	sub    %eax,%edx
  800be1:	89 d0                	mov    %edx,%eax
}
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800be8:	eb 09                	jmp    800bf3 <strncmp+0xe>
		n--, p++, q++;
  800bea:	ff 4d 10             	decl   0x10(%ebp)
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800bf3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf7:	74 17                	je     800c10 <strncmp+0x2b>
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	74 0e                	je     800c10 <strncmp+0x2b>
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8a 10                	mov    (%eax),%dl
  800c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	38 c2                	cmp    %al,%dl
  800c0e:	74 da                	je     800bea <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c14:	75 07                	jne    800c1d <strncmp+0x38>
		return 0;
  800c16:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1b:	eb 14                	jmp    800c31 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	8a 00                	mov    (%eax),%al
  800c22:	0f b6 d0             	movzbl %al,%edx
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	8a 00                	mov    (%eax),%al
  800c2a:	0f b6 c0             	movzbl %al,%eax
  800c2d:	29 c2                	sub    %eax,%edx
  800c2f:	89 d0                	mov    %edx,%eax
}
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	83 ec 04             	sub    $0x4,%esp
  800c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c3f:	eb 12                	jmp    800c53 <strchr+0x20>
		if (*s == c)
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c49:	75 05                	jne    800c50 <strchr+0x1d>
			return (char *) s;
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	eb 11                	jmp    800c61 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c50:	ff 45 08             	incl   0x8(%ebp)
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	8a 00                	mov    (%eax),%al
  800c58:	84 c0                	test   %al,%al
  800c5a:	75 e5                	jne    800c41 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 04             	sub    $0x4,%esp
  800c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c6f:	eb 0d                	jmp    800c7e <strfind+0x1b>
		if (*s == c)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c79:	74 0e                	je     800c89 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c7b:	ff 45 08             	incl   0x8(%ebp)
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8a 00                	mov    (%eax),%al
  800c83:	84 c0                	test   %al,%al
  800c85:	75 ea                	jne    800c71 <strfind+0xe>
  800c87:	eb 01                	jmp    800c8a <strfind+0x27>
		if (*s == c)
			break;
  800c89:	90                   	nop
	return (char *) s;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800c9b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c9f:	76 63                	jbe    800d04 <memset+0x75>
		uint64 data_block = c;
  800ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca4:	99                   	cltd   
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb1:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800cb5:	c1 e0 08             	shl    $0x8,%eax
  800cb8:	09 45 f0             	or     %eax,-0x10(%ebp)
  800cbb:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc4:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800cc8:	c1 e0 10             	shl    $0x10,%eax
  800ccb:	09 45 f0             	or     %eax,-0x10(%ebp)
  800cce:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cd7:	89 c2                	mov    %eax,%edx
  800cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cde:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ce1:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ce4:	eb 18                	jmp    800cfe <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ce6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ce9:	8d 41 08             	lea    0x8(%ecx),%eax
  800cec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cf5:	89 01                	mov    %eax,(%ecx)
  800cf7:	89 51 04             	mov    %edx,0x4(%ecx)
  800cfa:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800cfe:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d02:	77 e2                	ja     800ce6 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800d04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d08:	74 23                	je     800d2d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d10:	eb 0e                	jmp    800d20 <memset+0x91>
			*p8++ = (uint8)c;
  800d12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d15:	8d 50 01             	lea    0x1(%eax),%edx
  800d18:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800d20:	8b 45 10             	mov    0x10(%ebp),%eax
  800d23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d26:	89 55 10             	mov    %edx,0x10(%ebp)
  800d29:	85 c0                	test   %eax,%eax
  800d2b:	75 e5                	jne    800d12 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800d44:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d48:	76 24                	jbe    800d6e <memcpy+0x3c>
		while(n >= 8){
  800d4a:	eb 1c                	jmp    800d68 <memcpy+0x36>
			*d64 = *s64;
  800d4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4f:	8b 50 04             	mov    0x4(%eax),%edx
  800d52:	8b 00                	mov    (%eax),%eax
  800d54:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800d57:	89 01                	mov    %eax,(%ecx)
  800d59:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800d5c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800d60:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800d64:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800d68:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d6c:	77 de                	ja     800d4c <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800d6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d72:	74 31                	je     800da5 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d77:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800d7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800d80:	eb 16                	jmp    800d98 <memcpy+0x66>
			*d8++ = *s8++;
  800d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d85:	8d 50 01             	lea    0x1(%eax),%edx
  800d88:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800d8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d91:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800d94:	8a 12                	mov    (%edx),%dl
  800d96:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800d98:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9e:	89 55 10             	mov    %edx,0x10(%ebp)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	75 dd                	jne    800d82 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dc2:	73 50                	jae    800e14 <memmove+0x6a>
  800dc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dca:	01 d0                	add    %edx,%eax
  800dcc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dcf:	76 43                	jbe    800e14 <memmove+0x6a>
		s += n;
  800dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800dd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dda:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ddd:	eb 10                	jmp    800def <memmove+0x45>
			*--d = *--s;
  800ddf:	ff 4d f8             	decl   -0x8(%ebp)
  800de2:	ff 4d fc             	decl   -0x4(%ebp)
  800de5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de8:	8a 10                	mov    (%eax),%dl
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df5:	89 55 10             	mov    %edx,0x10(%ebp)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	75 e3                	jne    800ddf <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dfc:	eb 23                	jmp    800e21 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e01:	8d 50 01             	lea    0x1(%eax),%edx
  800e04:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e0a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e10:	8a 12                	mov    (%edx),%dl
  800e12:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e14:	8b 45 10             	mov    0x10(%ebp),%eax
  800e17:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1d:	85 c0                	test   %eax,%eax
  800e1f:	75 dd                	jne    800dfe <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e24:	c9                   	leave  
  800e25:	c3                   	ret    

00800e26 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e35:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e38:	eb 2a                	jmp    800e64 <memcmp+0x3e>
		if (*s1 != *s2)
  800e3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3d:	8a 10                	mov    (%eax),%dl
  800e3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	38 c2                	cmp    %al,%dl
  800e46:	74 16                	je     800e5e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	0f b6 d0             	movzbl %al,%edx
  800e50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	0f b6 c0             	movzbl %al,%eax
  800e58:	29 c2                	sub    %eax,%edx
  800e5a:	89 d0                	mov    %edx,%eax
  800e5c:	eb 18                	jmp    800e76 <memcmp+0x50>
		s1++, s2++;
  800e5e:	ff 45 fc             	incl   -0x4(%ebp)
  800e61:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e64:	8b 45 10             	mov    0x10(%ebp),%eax
  800e67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6d:	85 c0                	test   %eax,%eax
  800e6f:	75 c9                	jne    800e3a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e76:	c9                   	leave  
  800e77:	c3                   	ret    

00800e78 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e81:	8b 45 10             	mov    0x10(%ebp),%eax
  800e84:	01 d0                	add    %edx,%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e89:	eb 15                	jmp    800ea0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 00                	mov    (%eax),%al
  800e90:	0f b6 d0             	movzbl %al,%edx
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	0f b6 c0             	movzbl %al,%eax
  800e99:	39 c2                	cmp    %eax,%edx
  800e9b:	74 0d                	je     800eaa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e9d:	ff 45 08             	incl   0x8(%ebp)
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ea6:	72 e3                	jb     800e8b <memfind+0x13>
  800ea8:	eb 01                	jmp    800eab <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eaa:	90                   	nop
	return (void *) s;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eae:	c9                   	leave  
  800eaf:	c3                   	ret    

00800eb0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800eb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ebd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ec4:	eb 03                	jmp    800ec9 <strtol+0x19>
		s++;
  800ec6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	8a 00                	mov    (%eax),%al
  800ece:	3c 20                	cmp    $0x20,%al
  800ed0:	74 f4                	je     800ec6 <strtol+0x16>
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	3c 09                	cmp    $0x9,%al
  800ed9:	74 eb                	je     800ec6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	3c 2b                	cmp    $0x2b,%al
  800ee2:	75 05                	jne    800ee9 <strtol+0x39>
		s++;
  800ee4:	ff 45 08             	incl   0x8(%ebp)
  800ee7:	eb 13                	jmp    800efc <strtol+0x4c>
	else if (*s == '-')
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	3c 2d                	cmp    $0x2d,%al
  800ef0:	75 0a                	jne    800efc <strtol+0x4c>
		s++, neg = 1;
  800ef2:	ff 45 08             	incl   0x8(%ebp)
  800ef5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800efc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f00:	74 06                	je     800f08 <strtol+0x58>
  800f02:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f06:	75 20                	jne    800f28 <strtol+0x78>
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	3c 30                	cmp    $0x30,%al
  800f0f:	75 17                	jne    800f28 <strtol+0x78>
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	40                   	inc    %eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	3c 78                	cmp    $0x78,%al
  800f19:	75 0d                	jne    800f28 <strtol+0x78>
		s += 2, base = 16;
  800f1b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f1f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f26:	eb 28                	jmp    800f50 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2c:	75 15                	jne    800f43 <strtol+0x93>
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	3c 30                	cmp    $0x30,%al
  800f35:	75 0c                	jne    800f43 <strtol+0x93>
		s++, base = 8;
  800f37:	ff 45 08             	incl   0x8(%ebp)
  800f3a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f41:	eb 0d                	jmp    800f50 <strtol+0xa0>
	else if (base == 0)
  800f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f47:	75 07                	jne    800f50 <strtol+0xa0>
		base = 10;
  800f49:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 2f                	cmp    $0x2f,%al
  800f57:	7e 19                	jle    800f72 <strtol+0xc2>
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 39                	cmp    $0x39,%al
  800f60:	7f 10                	jg     800f72 <strtol+0xc2>
			dig = *s - '0';
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	0f be c0             	movsbl %al,%eax
  800f6a:	83 e8 30             	sub    $0x30,%eax
  800f6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f70:	eb 42                	jmp    800fb4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	3c 60                	cmp    $0x60,%al
  800f79:	7e 19                	jle    800f94 <strtol+0xe4>
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	3c 7a                	cmp    $0x7a,%al
  800f82:	7f 10                	jg     800f94 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	0f be c0             	movsbl %al,%eax
  800f8c:	83 e8 57             	sub    $0x57,%eax
  800f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f92:	eb 20                	jmp    800fb4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	3c 40                	cmp    $0x40,%al
  800f9b:	7e 39                	jle    800fd6 <strtol+0x126>
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	3c 5a                	cmp    $0x5a,%al
  800fa4:	7f 30                	jg     800fd6 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	0f be c0             	movsbl %al,%eax
  800fae:	83 e8 37             	sub    $0x37,%eax
  800fb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fba:	7d 19                	jge    800fd5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fbc:	ff 45 08             	incl   0x8(%ebp)
  800fbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fc6:	89 c2                	mov    %eax,%edx
  800fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fcb:	01 d0                	add    %edx,%eax
  800fcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fd0:	e9 7b ff ff ff       	jmp    800f50 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fd5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fd6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fda:	74 08                	je     800fe4 <strtol+0x134>
		*endptr = (char *) s;
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fe4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fe8:	74 07                	je     800ff1 <strtol+0x141>
  800fea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fed:	f7 d8                	neg    %eax
  800fef:	eb 03                	jmp    800ff4 <strtol+0x144>
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <ltostr>:

void
ltostr(long value, char *str)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ffc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801003:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80100a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80100e:	79 13                	jns    801023 <ltostr+0x2d>
	{
		neg = 1;
  801010:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80101d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801020:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80102b:	99                   	cltd   
  80102c:	f7 f9                	idiv   %ecx
  80102e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801031:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801034:	8d 50 01             	lea    0x1(%eax),%edx
  801037:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80103a:	89 c2                	mov    %eax,%edx
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	01 d0                	add    %edx,%eax
  801041:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801044:	83 c2 30             	add    $0x30,%edx
  801047:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801049:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801051:	f7 e9                	imul   %ecx
  801053:	c1 fa 02             	sar    $0x2,%edx
  801056:	89 c8                	mov    %ecx,%eax
  801058:	c1 f8 1f             	sar    $0x1f,%eax
  80105b:	29 c2                	sub    %eax,%edx
  80105d:	89 d0                	mov    %edx,%eax
  80105f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801066:	75 bb                	jne    801023 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801068:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80106f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801072:	48                   	dec    %eax
  801073:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801076:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80107a:	74 3d                	je     8010b9 <ltostr+0xc3>
		start = 1 ;
  80107c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801083:	eb 34                	jmp    8010b9 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801085:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	01 d0                	add    %edx,%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801092:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801095:	8b 45 0c             	mov    0xc(%ebp),%eax
  801098:	01 c2                	add    %eax,%edx
  80109a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80109d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a0:	01 c8                	add    %ecx,%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ac:	01 c2                	add    %eax,%edx
  8010ae:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010b1:	88 02                	mov    %al,(%edx)
		start++ ;
  8010b3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010b6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010bf:	7c c4                	jl     801085 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010c1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c7:	01 d0                	add    %edx,%eax
  8010c9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010cc:	90                   	nop
  8010cd:	c9                   	leave  
  8010ce:	c3                   	ret    

008010cf <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010d5:	ff 75 08             	pushl  0x8(%ebp)
  8010d8:	e8 c4 f9 ff ff       	call   800aa1 <strlen>
  8010dd:	83 c4 04             	add    $0x4,%esp
  8010e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010e3:	ff 75 0c             	pushl  0xc(%ebp)
  8010e6:	e8 b6 f9 ff ff       	call   800aa1 <strlen>
  8010eb:	83 c4 04             	add    $0x4,%esp
  8010ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ff:	eb 17                	jmp    801118 <strcconcat+0x49>
		final[s] = str1[s] ;
  801101:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801104:	8b 45 10             	mov    0x10(%ebp),%eax
  801107:	01 c2                	add    %eax,%edx
  801109:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	01 c8                	add    %ecx,%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801115:	ff 45 fc             	incl   -0x4(%ebp)
  801118:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80111e:	7c e1                	jl     801101 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801120:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801127:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80112e:	eb 1f                	jmp    80114f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801130:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801133:	8d 50 01             	lea    0x1(%eax),%edx
  801136:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801139:	89 c2                	mov    %eax,%edx
  80113b:	8b 45 10             	mov    0x10(%ebp),%eax
  80113e:	01 c2                	add    %eax,%edx
  801140:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 c8                	add    %ecx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80114c:	ff 45 f8             	incl   -0x8(%ebp)
  80114f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801152:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801155:	7c d9                	jl     801130 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801157:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115a:	8b 45 10             	mov    0x10(%ebp),%eax
  80115d:	01 d0                	add    %edx,%eax
  80115f:	c6 00 00             	movb   $0x0,(%eax)
}
  801162:	90                   	nop
  801163:	c9                   	leave  
  801164:	c3                   	ret    

00801165 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801168:	8b 45 14             	mov    0x14(%ebp),%eax
  80116b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801171:	8b 45 14             	mov    0x14(%ebp),%eax
  801174:	8b 00                	mov    (%eax),%eax
  801176:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117d:	8b 45 10             	mov    0x10(%ebp),%eax
  801180:	01 d0                	add    %edx,%eax
  801182:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801188:	eb 0c                	jmp    801196 <strsplit+0x31>
			*string++ = 0;
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8d 50 01             	lea    0x1(%eax),%edx
  801190:	89 55 08             	mov    %edx,0x8(%ebp)
  801193:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	84 c0                	test   %al,%al
  80119d:	74 18                	je     8011b7 <strsplit+0x52>
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	0f be c0             	movsbl %al,%eax
  8011a7:	50                   	push   %eax
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	e8 83 fa ff ff       	call   800c33 <strchr>
  8011b0:	83 c4 08             	add    $0x8,%esp
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	75 d3                	jne    80118a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	84 c0                	test   %al,%al
  8011be:	74 5a                	je     80121a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c3:	8b 00                	mov    (%eax),%eax
  8011c5:	83 f8 0f             	cmp    $0xf,%eax
  8011c8:	75 07                	jne    8011d1 <strsplit+0x6c>
		{
			return 0;
  8011ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cf:	eb 66                	jmp    801237 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	8d 48 01             	lea    0x1(%eax),%ecx
  8011d9:	8b 55 14             	mov    0x14(%ebp),%edx
  8011dc:	89 0a                	mov    %ecx,(%edx)
  8011de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e8:	01 c2                	add    %eax,%edx
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011ef:	eb 03                	jmp    8011f4 <strsplit+0x8f>
			string++;
  8011f1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	84 c0                	test   %al,%al
  8011fb:	74 8b                	je     801188 <strsplit+0x23>
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	0f be c0             	movsbl %al,%eax
  801205:	50                   	push   %eax
  801206:	ff 75 0c             	pushl  0xc(%ebp)
  801209:	e8 25 fa ff ff       	call   800c33 <strchr>
  80120e:	83 c4 08             	add    $0x8,%esp
  801211:	85 c0                	test   %eax,%eax
  801213:	74 dc                	je     8011f1 <strsplit+0x8c>
			string++;
	}
  801215:	e9 6e ff ff ff       	jmp    801188 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80121a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80121b:	8b 45 14             	mov    0x14(%ebp),%eax
  80121e:	8b 00                	mov    (%eax),%eax
  801220:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801227:	8b 45 10             	mov    0x10(%ebp),%eax
  80122a:	01 d0                	add    %edx,%eax
  80122c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801232:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801237:	c9                   	leave  
  801238:	c3                   	ret    

00801239 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
  80123c:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801245:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80124c:	eb 4a                	jmp    801298 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80124e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	01 c2                	add    %eax,%edx
  801256:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	01 c8                	add    %ecx,%eax
  80125e:	8a 00                	mov    (%eax),%al
  801260:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801262:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	01 d0                	add    %edx,%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 40                	cmp    $0x40,%al
  80126e:	7e 25                	jle    801295 <str2lower+0x5c>
  801270:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801273:	8b 45 0c             	mov    0xc(%ebp),%eax
  801276:	01 d0                	add    %edx,%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 5a                	cmp    $0x5a,%al
  80127c:	7f 17                	jg     801295 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80127e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801289:	8b 55 08             	mov    0x8(%ebp),%edx
  80128c:	01 ca                	add    %ecx,%edx
  80128e:	8a 12                	mov    (%edx),%dl
  801290:	83 c2 20             	add    $0x20,%edx
  801293:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801295:	ff 45 fc             	incl   -0x4(%ebp)
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	e8 01 f8 ff ff       	call   800aa1 <strlen>
  8012a0:	83 c4 04             	add    $0x4,%esp
  8012a3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012a6:	7f a6                	jg     80124e <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8012a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  8012b3:	83 ec 0c             	sub    $0xc,%esp
  8012b6:	6a 10                	push   $0x10
  8012b8:	e8 b2 15 00 00       	call   80286f <alloc_block>
  8012bd:	83 c4 10             	add    $0x10,%esp
  8012c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  8012c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012c7:	75 14                	jne    8012dd <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  8012c9:	83 ec 04             	sub    $0x4,%esp
  8012cc:	68 28 3c 80 00       	push   $0x803c28
  8012d1:	6a 14                	push   $0x14
  8012d3:	68 51 3c 80 00       	push   $0x803c51
  8012d8:	e8 a4 1f 00 00       	call   803281 <_panic>

	node->start = start;
  8012dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e3:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  8012e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012eb:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  8012ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  8012f5:	a1 24 50 80 00       	mov    0x805024,%eax
  8012fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012fd:	eb 18                	jmp    801317 <insert_page_alloc+0x6a>
		if (start < it->start)
  8012ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801302:	8b 00                	mov    (%eax),%eax
  801304:	3b 45 08             	cmp    0x8(%ebp),%eax
  801307:	77 37                	ja     801340 <insert_page_alloc+0x93>
			break;
		prev = it;
  801309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130c:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  80130f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801314:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801317:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80131b:	74 08                	je     801325 <insert_page_alloc+0x78>
  80131d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801320:	8b 40 08             	mov    0x8(%eax),%eax
  801323:	eb 05                	jmp    80132a <insert_page_alloc+0x7d>
  801325:	b8 00 00 00 00       	mov    $0x0,%eax
  80132a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80132f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801334:	85 c0                	test   %eax,%eax
  801336:	75 c7                	jne    8012ff <insert_page_alloc+0x52>
  801338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80133c:	75 c1                	jne    8012ff <insert_page_alloc+0x52>
  80133e:	eb 01                	jmp    801341 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801340:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801341:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801345:	75 64                	jne    8013ab <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801347:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80134b:	75 14                	jne    801361 <insert_page_alloc+0xb4>
  80134d:	83 ec 04             	sub    $0x4,%esp
  801350:	68 60 3c 80 00       	push   $0x803c60
  801355:	6a 21                	push   $0x21
  801357:	68 51 3c 80 00       	push   $0x803c51
  80135c:	e8 20 1f 00 00       	call   803281 <_panic>
  801361:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801367:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80136a:	89 50 08             	mov    %edx,0x8(%eax)
  80136d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801370:	8b 40 08             	mov    0x8(%eax),%eax
  801373:	85 c0                	test   %eax,%eax
  801375:	74 0d                	je     801384 <insert_page_alloc+0xd7>
  801377:	a1 24 50 80 00       	mov    0x805024,%eax
  80137c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80137f:	89 50 0c             	mov    %edx,0xc(%eax)
  801382:	eb 08                	jmp    80138c <insert_page_alloc+0xdf>
  801384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801387:	a3 28 50 80 00       	mov    %eax,0x805028
  80138c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80138f:	a3 24 50 80 00       	mov    %eax,0x805024
  801394:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801397:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80139e:	a1 30 50 80 00       	mov    0x805030,%eax
  8013a3:	40                   	inc    %eax
  8013a4:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  8013a9:	eb 71                	jmp    80141c <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  8013ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013af:	74 06                	je     8013b7 <insert_page_alloc+0x10a>
  8013b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013b5:	75 14                	jne    8013cb <insert_page_alloc+0x11e>
  8013b7:	83 ec 04             	sub    $0x4,%esp
  8013ba:	68 84 3c 80 00       	push   $0x803c84
  8013bf:	6a 23                	push   $0x23
  8013c1:	68 51 3c 80 00       	push   $0x803c51
  8013c6:	e8 b6 1e 00 00       	call   803281 <_panic>
  8013cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ce:	8b 50 08             	mov    0x8(%eax),%edx
  8013d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013d4:	89 50 08             	mov    %edx,0x8(%eax)
  8013d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013da:	8b 40 08             	mov    0x8(%eax),%eax
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	74 0c                	je     8013ed <insert_page_alloc+0x140>
  8013e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e4:	8b 40 08             	mov    0x8(%eax),%eax
  8013e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ea:	89 50 0c             	mov    %edx,0xc(%eax)
  8013ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013f3:	89 50 08             	mov    %edx,0x8(%eax)
  8013f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013fc:	89 50 0c             	mov    %edx,0xc(%eax)
  8013ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801402:	8b 40 08             	mov    0x8(%eax),%eax
  801405:	85 c0                	test   %eax,%eax
  801407:	75 08                	jne    801411 <insert_page_alloc+0x164>
  801409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80140c:	a3 28 50 80 00       	mov    %eax,0x805028
  801411:	a1 30 50 80 00       	mov    0x805030,%eax
  801416:	40                   	inc    %eax
  801417:	a3 30 50 80 00       	mov    %eax,0x805030
}
  80141c:	90                   	nop
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801425:	a1 24 50 80 00       	mov    0x805024,%eax
  80142a:	85 c0                	test   %eax,%eax
  80142c:	75 0c                	jne    80143a <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  80142e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801433:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801438:	eb 67                	jmp    8014a1 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  80143a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80143f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801442:	a1 24 50 80 00       	mov    0x805024,%eax
  801447:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80144a:	eb 26                	jmp    801472 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  80144c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144f:	8b 10                	mov    (%eax),%edx
  801451:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801454:	8b 40 04             	mov    0x4(%eax),%eax
  801457:	01 d0                	add    %edx,%eax
  801459:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  80145c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801462:	76 06                	jbe    80146a <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801467:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80146a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80146f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801472:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801476:	74 08                	je     801480 <recompute_page_alloc_break+0x61>
  801478:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80147b:	8b 40 08             	mov    0x8(%eax),%eax
  80147e:	eb 05                	jmp    801485 <recompute_page_alloc_break+0x66>
  801480:	b8 00 00 00 00       	mov    $0x0,%eax
  801485:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80148a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80148f:	85 c0                	test   %eax,%eax
  801491:	75 b9                	jne    80144c <recompute_page_alloc_break+0x2d>
  801493:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801497:	75 b3                	jne    80144c <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801499:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149c:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  8014a9:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8014b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014b6:	01 d0                	add    %edx,%eax
  8014b8:	48                   	dec    %eax
  8014b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8014bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c4:	f7 75 d8             	divl   -0x28(%ebp)
  8014c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014ca:	29 d0                	sub    %edx,%eax
  8014cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  8014cf:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8014d3:	75 0a                	jne    8014df <alloc_pages_custom_fit+0x3c>
		return NULL;
  8014d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014da:	e9 7e 01 00 00       	jmp    80165d <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  8014df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  8014e6:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  8014ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  8014f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  8014f8:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8014fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801500:	a1 24 50 80 00       	mov    0x805024,%eax
  801505:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801508:	eb 69                	jmp    801573 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  80150a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80150d:	8b 00                	mov    (%eax),%eax
  80150f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801512:	76 47                	jbe    80155b <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801514:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801517:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  80151a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151d:	8b 00                	mov    (%eax),%eax
  80151f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801522:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801525:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801528:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80152b:	72 2e                	jb     80155b <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  80152d:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801531:	75 14                	jne    801547 <alloc_pages_custom_fit+0xa4>
  801533:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801536:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801539:	75 0c                	jne    801547 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  80153b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80153e:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801541:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801545:	eb 14                	jmp    80155b <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801547:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80154a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80154d:	76 0c                	jbe    80155b <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  80154f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801552:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801555:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801558:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  80155b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80155e:	8b 10                	mov    (%eax),%edx
  801560:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801563:	8b 40 04             	mov    0x4(%eax),%eax
  801566:	01 d0                	add    %edx,%eax
  801568:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  80156b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801570:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801573:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801577:	74 08                	je     801581 <alloc_pages_custom_fit+0xde>
  801579:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157c:	8b 40 08             	mov    0x8(%eax),%eax
  80157f:	eb 05                	jmp    801586 <alloc_pages_custom_fit+0xe3>
  801581:	b8 00 00 00 00       	mov    $0x0,%eax
  801586:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80158b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801590:	85 c0                	test   %eax,%eax
  801592:	0f 85 72 ff ff ff    	jne    80150a <alloc_pages_custom_fit+0x67>
  801598:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80159c:	0f 85 68 ff ff ff    	jne    80150a <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  8015a2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8015a7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8015aa:	76 47                	jbe    8015f3 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  8015ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015af:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  8015b2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8015b7:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8015ba:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  8015bd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015c0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8015c3:	72 2e                	jb     8015f3 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  8015c5:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8015c9:	75 14                	jne    8015df <alloc_pages_custom_fit+0x13c>
  8015cb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015ce:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8015d1:	75 0c                	jne    8015df <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  8015d3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8015d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  8015d9:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8015dd:	eb 14                	jmp    8015f3 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  8015df:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015e2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8015e5:	76 0c                	jbe    8015f3 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  8015e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8015ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  8015ed:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  8015f3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  8015fa:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8015fe:	74 08                	je     801608 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801603:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801606:	eb 40                	jmp    801648 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801608:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80160c:	74 08                	je     801616 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  80160e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801611:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801614:	eb 32                	jmp    801648 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801616:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80161b:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80161e:	89 c2                	mov    %eax,%edx
  801620:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801625:	39 c2                	cmp    %eax,%edx
  801627:	73 07                	jae    801630 <alloc_pages_custom_fit+0x18d>
			return NULL;
  801629:	b8 00 00 00 00       	mov    $0x0,%eax
  80162e:	eb 2d                	jmp    80165d <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801630:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801635:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801638:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80163e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801641:	01 d0                	add    %edx,%eax
  801643:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801648:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80164b:	83 ec 08             	sub    $0x8,%esp
  80164e:	ff 75 d0             	pushl  -0x30(%ebp)
  801651:	50                   	push   %eax
  801652:	e8 56 fc ff ff       	call   8012ad <insert_page_alloc>
  801657:	83 c4 10             	add    $0x10,%esp

	return result;
  80165a:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80166b:	a1 24 50 80 00       	mov    0x805024,%eax
  801670:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801673:	eb 1a                	jmp    80168f <find_allocated_size+0x30>
		if (it->start == va)
  801675:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801678:	8b 00                	mov    (%eax),%eax
  80167a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80167d:	75 08                	jne    801687 <find_allocated_size+0x28>
			return it->size;
  80167f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801682:	8b 40 04             	mov    0x4(%eax),%eax
  801685:	eb 34                	jmp    8016bb <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801687:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80168c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80168f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801693:	74 08                	je     80169d <find_allocated_size+0x3e>
  801695:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801698:	8b 40 08             	mov    0x8(%eax),%eax
  80169b:	eb 05                	jmp    8016a2 <find_allocated_size+0x43>
  80169d:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8016a7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	75 c5                	jne    801675 <find_allocated_size+0x16>
  8016b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016b4:	75 bf                	jne    801675 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  8016b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8016c9:	a1 24 50 80 00       	mov    0x805024,%eax
  8016ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d1:	e9 e1 01 00 00       	jmp    8018b7 <free_pages+0x1fa>
		if (it->start == va) {
  8016d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d9:	8b 00                	mov    (%eax),%eax
  8016db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8016de:	0f 85 cb 01 00 00    	jne    8018af <free_pages+0x1f2>

			uint32 start = it->start;
  8016e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e7:	8b 00                	mov    (%eax),%eax
  8016e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  8016ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ef:	8b 40 04             	mov    0x4(%eax),%eax
  8016f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  8016f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016f8:	f7 d0                	not    %eax
  8016fa:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8016fd:	73 1d                	jae    80171c <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  8016ff:	83 ec 0c             	sub    $0xc,%esp
  801702:	ff 75 e4             	pushl  -0x1c(%ebp)
  801705:	ff 75 e8             	pushl  -0x18(%ebp)
  801708:	68 b8 3c 80 00       	push   $0x803cb8
  80170d:	68 a5 00 00 00       	push   $0xa5
  801712:	68 51 3c 80 00       	push   $0x803c51
  801717:	e8 65 1b 00 00       	call   803281 <_panic>
			}

			uint32 start_end = start + size;
  80171c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80171f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801722:	01 d0                	add    %edx,%eax
  801724:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801727:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80172a:	85 c0                	test   %eax,%eax
  80172c:	79 19                	jns    801747 <free_pages+0x8a>
  80172e:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801735:	77 10                	ja     801747 <free_pages+0x8a>
  801737:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  80173e:	77 07                	ja     801747 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801740:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801743:	85 c0                	test   %eax,%eax
  801745:	78 2c                	js     801773 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801747:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80174a:	83 ec 0c             	sub    $0xc,%esp
  80174d:	68 00 00 00 a0       	push   $0xa0000000
  801752:	ff 75 e0             	pushl  -0x20(%ebp)
  801755:	ff 75 e4             	pushl  -0x1c(%ebp)
  801758:	ff 75 e8             	pushl  -0x18(%ebp)
  80175b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80175e:	50                   	push   %eax
  80175f:	68 fc 3c 80 00       	push   $0x803cfc
  801764:	68 ad 00 00 00       	push   $0xad
  801769:	68 51 3c 80 00       	push   $0x803c51
  80176e:	e8 0e 1b 00 00       	call   803281 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801773:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801776:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801779:	e9 88 00 00 00       	jmp    801806 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  80177e:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801785:	76 17                	jbe    80179e <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801787:	ff 75 f0             	pushl  -0x10(%ebp)
  80178a:	68 60 3d 80 00       	push   $0x803d60
  80178f:	68 b4 00 00 00       	push   $0xb4
  801794:	68 51 3c 80 00       	push   $0x803c51
  801799:	e8 e3 1a 00 00       	call   803281 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  80179e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a1:	05 00 10 00 00       	add    $0x1000,%eax
  8017a6:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  8017a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	79 2e                	jns    8017de <free_pages+0x121>
  8017b0:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8017b7:	77 25                	ja     8017de <free_pages+0x121>
  8017b9:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8017c0:	77 1c                	ja     8017de <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  8017c2:	83 ec 08             	sub    $0x8,%esp
  8017c5:	68 00 10 00 00       	push   $0x1000
  8017ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8017cd:	e8 38 0d 00 00       	call   80250a <sys_free_user_mem>
  8017d2:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8017d5:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8017dc:	eb 28                	jmp    801806 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  8017de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e1:	68 00 00 00 a0       	push   $0xa0000000
  8017e6:	ff 75 dc             	pushl  -0x24(%ebp)
  8017e9:	68 00 10 00 00       	push   $0x1000
  8017ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8017f1:	50                   	push   %eax
  8017f2:	68 a0 3d 80 00       	push   $0x803da0
  8017f7:	68 bd 00 00 00       	push   $0xbd
  8017fc:	68 51 3c 80 00       	push   $0x803c51
  801801:	e8 7b 1a 00 00       	call   803281 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801809:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80180c:	0f 82 6c ff ff ff    	jb     80177e <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801812:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801816:	75 17                	jne    80182f <free_pages+0x172>
  801818:	83 ec 04             	sub    $0x4,%esp
  80181b:	68 02 3e 80 00       	push   $0x803e02
  801820:	68 c1 00 00 00       	push   $0xc1
  801825:	68 51 3c 80 00       	push   $0x803c51
  80182a:	e8 52 1a 00 00       	call   803281 <_panic>
  80182f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801832:	8b 40 08             	mov    0x8(%eax),%eax
  801835:	85 c0                	test   %eax,%eax
  801837:	74 11                	je     80184a <free_pages+0x18d>
  801839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183c:	8b 40 08             	mov    0x8(%eax),%eax
  80183f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801842:	8b 52 0c             	mov    0xc(%edx),%edx
  801845:	89 50 0c             	mov    %edx,0xc(%eax)
  801848:	eb 0b                	jmp    801855 <free_pages+0x198>
  80184a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184d:	8b 40 0c             	mov    0xc(%eax),%eax
  801850:	a3 28 50 80 00       	mov    %eax,0x805028
  801855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801858:	8b 40 0c             	mov    0xc(%eax),%eax
  80185b:	85 c0                	test   %eax,%eax
  80185d:	74 11                	je     801870 <free_pages+0x1b3>
  80185f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801862:	8b 40 0c             	mov    0xc(%eax),%eax
  801865:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801868:	8b 52 08             	mov    0x8(%edx),%edx
  80186b:	89 50 08             	mov    %edx,0x8(%eax)
  80186e:	eb 0b                	jmp    80187b <free_pages+0x1be>
  801870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801873:	8b 40 08             	mov    0x8(%eax),%eax
  801876:	a3 24 50 80 00       	mov    %eax,0x805024
  80187b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801888:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80188f:	a1 30 50 80 00       	mov    0x805030,%eax
  801894:	48                   	dec    %eax
  801895:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  80189a:	83 ec 0c             	sub    $0xc,%esp
  80189d:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a0:	e8 24 15 00 00       	call   802dc9 <free_block>
  8018a5:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  8018a8:	e8 72 fb ff ff       	call   80141f <recompute_page_alloc_break>

			return;
  8018ad:	eb 37                	jmp    8018e6 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8018af:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018bb:	74 08                	je     8018c5 <free_pages+0x208>
  8018bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c0:	8b 40 08             	mov    0x8(%eax),%eax
  8018c3:	eb 05                	jmp    8018ca <free_pages+0x20d>
  8018c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ca:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8018cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	0f 85 fa fd ff ff    	jne    8016d6 <free_pages+0x19>
  8018dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018e0:	0f 85 f0 fd ff ff    	jne    8016d6 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  8018eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    

008018f2 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8018f8:	a1 08 50 80 00       	mov    0x805008,%eax
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	74 60                	je     801961 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801901:	83 ec 08             	sub    $0x8,%esp
  801904:	68 00 00 00 82       	push   $0x82000000
  801909:	68 00 00 00 80       	push   $0x80000000
  80190e:	e8 0d 0d 00 00       	call   802620 <initialize_dynamic_allocator>
  801913:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801916:	e8 f3 0a 00 00       	call   80240e <sys_get_uheap_strategy>
  80191b:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801920:	a1 40 50 80 00       	mov    0x805040,%eax
  801925:	05 00 10 00 00       	add    $0x1000,%eax
  80192a:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  80192f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801934:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801939:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801940:	00 00 00 
  801943:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  80194a:	00 00 00 
  80194d:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801954:	00 00 00 

		__firstTimeFlag = 0;
  801957:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80195e:	00 00 00 
	}
}
  801961:	90                   	nop
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80196a:	8b 45 08             	mov    0x8(%ebp),%eax
  80196d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801973:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801978:	83 ec 08             	sub    $0x8,%esp
  80197b:	68 06 04 00 00       	push   $0x406
  801980:	50                   	push   %eax
  801981:	e8 d2 06 00 00       	call   802058 <__sys_allocate_page>
  801986:	83 c4 10             	add    $0x10,%esp
  801989:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80198c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801990:	79 17                	jns    8019a9 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801992:	83 ec 04             	sub    $0x4,%esp
  801995:	68 20 3e 80 00       	push   $0x803e20
  80199a:	68 ea 00 00 00       	push   $0xea
  80199f:	68 51 3c 80 00       	push   $0x803c51
  8019a4:	e8 d8 18 00 00       	call   803281 <_panic>
	return 0;
  8019a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019c4:	83 ec 0c             	sub    $0xc,%esp
  8019c7:	50                   	push   %eax
  8019c8:	e8 d2 06 00 00       	call   80209f <__sys_unmap_frame>
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8019d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019d7:	79 17                	jns    8019f0 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  8019d9:	83 ec 04             	sub    $0x4,%esp
  8019dc:	68 5c 3e 80 00       	push   $0x803e5c
  8019e1:	68 f5 00 00 00       	push   $0xf5
  8019e6:	68 51 3c 80 00       	push   $0x803c51
  8019eb:	e8 91 18 00 00       	call   803281 <_panic>
}
  8019f0:	90                   	nop
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8019f9:	e8 f4 fe ff ff       	call   8018f2 <uheap_init>
	if (size == 0) return NULL ;
  8019fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a02:	75 0a                	jne    801a0e <malloc+0x1b>
  801a04:	b8 00 00 00 00       	mov    $0x0,%eax
  801a09:	e9 67 01 00 00       	jmp    801b75 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801a0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801a15:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801a1c:	77 16                	ja     801a34 <malloc+0x41>
		result = alloc_block(size);
  801a1e:	83 ec 0c             	sub    $0xc,%esp
  801a21:	ff 75 08             	pushl  0x8(%ebp)
  801a24:	e8 46 0e 00 00       	call   80286f <alloc_block>
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a2f:	e9 3e 01 00 00       	jmp    801b72 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801a34:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a3b:	8b 55 08             	mov    0x8(%ebp),%edx
  801a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a41:	01 d0                	add    %edx,%eax
  801a43:	48                   	dec    %eax
  801a44:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4f:	f7 75 f0             	divl   -0x10(%ebp)
  801a52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a55:	29 d0                	sub    %edx,%eax
  801a57:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801a5a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801a5f:	85 c0                	test   %eax,%eax
  801a61:	75 0a                	jne    801a6d <malloc+0x7a>
			return NULL;
  801a63:	b8 00 00 00 00       	mov    $0x0,%eax
  801a68:	e9 08 01 00 00       	jmp    801b75 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801a6d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801a72:	85 c0                	test   %eax,%eax
  801a74:	74 0f                	je     801a85 <malloc+0x92>
  801a76:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801a7c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801a81:	39 c2                	cmp    %eax,%edx
  801a83:	73 0a                	jae    801a8f <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801a85:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801a8a:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801a8f:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801a94:	83 f8 05             	cmp    $0x5,%eax
  801a97:	75 11                	jne    801aaa <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801a99:	83 ec 0c             	sub    $0xc,%esp
  801a9c:	ff 75 e8             	pushl  -0x18(%ebp)
  801a9f:	e8 ff f9 ff ff       	call   8014a3 <alloc_pages_custom_fit>
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801aaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aae:	0f 84 be 00 00 00    	je     801b72 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801aba:	83 ec 0c             	sub    $0xc,%esp
  801abd:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac0:	e8 9a fb ff ff       	call   80165f <find_allocated_size>
  801ac5:	83 c4 10             	add    $0x10,%esp
  801ac8:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801acb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801acf:	75 17                	jne    801ae8 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801ad1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad4:	68 9c 3e 80 00       	push   $0x803e9c
  801ad9:	68 24 01 00 00       	push   $0x124
  801ade:	68 51 3c 80 00       	push   $0x803c51
  801ae3:	e8 99 17 00 00       	call   803281 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801ae8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aeb:	f7 d0                	not    %eax
  801aed:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801af0:	73 1d                	jae    801b0f <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801af2:	83 ec 0c             	sub    $0xc,%esp
  801af5:	ff 75 e0             	pushl  -0x20(%ebp)
  801af8:	ff 75 e4             	pushl  -0x1c(%ebp)
  801afb:	68 e4 3e 80 00       	push   $0x803ee4
  801b00:	68 29 01 00 00       	push   $0x129
  801b05:	68 51 3c 80 00       	push   $0x803c51
  801b0a:	e8 72 17 00 00       	call   803281 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801b0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b15:	01 d0                	add    %edx,%eax
  801b17:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801b1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	79 2c                	jns    801b4d <malloc+0x15a>
  801b21:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801b28:	77 23                	ja     801b4d <malloc+0x15a>
  801b2a:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801b31:	77 1a                	ja     801b4d <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801b33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b36:	85 c0                	test   %eax,%eax
  801b38:	79 13                	jns    801b4d <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801b3a:	83 ec 08             	sub    $0x8,%esp
  801b3d:	ff 75 e0             	pushl  -0x20(%ebp)
  801b40:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b43:	e8 de 09 00 00       	call   802526 <sys_allocate_user_mem>
  801b48:	83 c4 10             	add    $0x10,%esp
  801b4b:	eb 25                	jmp    801b72 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801b4d:	68 00 00 00 a0       	push   $0xa0000000
  801b52:	ff 75 dc             	pushl  -0x24(%ebp)
  801b55:	ff 75 e0             	pushl  -0x20(%ebp)
  801b58:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b5b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b5e:	68 20 3f 80 00       	push   $0x803f20
  801b63:	68 33 01 00 00       	push   $0x133
  801b68:	68 51 3c 80 00       	push   $0x803c51
  801b6d:	e8 0f 17 00 00       	call   803281 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801b7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b81:	0f 84 26 01 00 00    	je     801cad <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b90:	85 c0                	test   %eax,%eax
  801b92:	79 1c                	jns    801bb0 <free+0x39>
  801b94:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801b9b:	77 13                	ja     801bb0 <free+0x39>
		free_block(virtual_address);
  801b9d:	83 ec 0c             	sub    $0xc,%esp
  801ba0:	ff 75 08             	pushl  0x8(%ebp)
  801ba3:	e8 21 12 00 00       	call   802dc9 <free_block>
  801ba8:	83 c4 10             	add    $0x10,%esp
		return;
  801bab:	e9 01 01 00 00       	jmp    801cb1 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801bb0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801bb5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801bb8:	0f 82 d8 00 00 00    	jb     801c96 <free+0x11f>
  801bbe:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801bc5:	0f 87 cb 00 00 00    	ja     801c96 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bce:	25 ff 0f 00 00       	and    $0xfff,%eax
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	74 17                	je     801bee <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801bd7:	ff 75 08             	pushl  0x8(%ebp)
  801bda:	68 90 3f 80 00       	push   $0x803f90
  801bdf:	68 57 01 00 00       	push   $0x157
  801be4:	68 51 3c 80 00       	push   $0x803c51
  801be9:	e8 93 16 00 00       	call   803281 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801bee:	83 ec 0c             	sub    $0xc,%esp
  801bf1:	ff 75 08             	pushl  0x8(%ebp)
  801bf4:	e8 66 fa ff ff       	call   80165f <find_allocated_size>
  801bf9:	83 c4 10             	add    $0x10,%esp
  801bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801bff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c03:	0f 84 a7 00 00 00    	je     801cb0 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0c:	f7 d0                	not    %eax
  801c0e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c11:	73 1d                	jae    801c30 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801c13:	83 ec 0c             	sub    $0xc,%esp
  801c16:	ff 75 f0             	pushl  -0x10(%ebp)
  801c19:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1c:	68 b8 3f 80 00       	push   $0x803fb8
  801c21:	68 61 01 00 00       	push   $0x161
  801c26:	68 51 3c 80 00       	push   $0x803c51
  801c2b:	e8 51 16 00 00       	call   803281 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801c30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c36:	01 d0                	add    %edx,%eax
  801c38:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3e:	85 c0                	test   %eax,%eax
  801c40:	79 19                	jns    801c5b <free+0xe4>
  801c42:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801c49:	77 10                	ja     801c5b <free+0xe4>
  801c4b:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801c52:	77 07                	ja     801c5b <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801c54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c57:	85 c0                	test   %eax,%eax
  801c59:	78 2b                	js     801c86 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801c5b:	83 ec 0c             	sub    $0xc,%esp
  801c5e:	68 00 00 00 a0       	push   $0xa0000000
  801c63:	ff 75 ec             	pushl  -0x14(%ebp)
  801c66:	ff 75 f0             	pushl  -0x10(%ebp)
  801c69:	ff 75 f4             	pushl  -0xc(%ebp)
  801c6c:	ff 75 f0             	pushl  -0x10(%ebp)
  801c6f:	ff 75 08             	pushl  0x8(%ebp)
  801c72:	68 f4 3f 80 00       	push   $0x803ff4
  801c77:	68 69 01 00 00       	push   $0x169
  801c7c:	68 51 3c 80 00       	push   $0x803c51
  801c81:	e8 fb 15 00 00       	call   803281 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  801c86:	83 ec 0c             	sub    $0xc,%esp
  801c89:	ff 75 08             	pushl  0x8(%ebp)
  801c8c:	e8 2c fa ff ff       	call   8016bd <free_pages>
  801c91:	83 c4 10             	add    $0x10,%esp
		return;
  801c94:	eb 1b                	jmp    801cb1 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  801c96:	ff 75 08             	pushl  0x8(%ebp)
  801c99:	68 50 40 80 00       	push   $0x804050
  801c9e:	68 70 01 00 00       	push   $0x170
  801ca3:	68 51 3c 80 00       	push   $0x803c51
  801ca8:	e8 d4 15 00 00       	call   803281 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801cad:	90                   	nop
  801cae:	eb 01                	jmp    801cb1 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  801cb0:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 38             	sub    $0x38,%esp
  801cb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbc:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cbf:	e8 2e fc ff ff       	call   8018f2 <uheap_init>
	if (size == 0) return NULL ;
  801cc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cc8:	75 0a                	jne    801cd4 <smalloc+0x21>
  801cca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccf:	e9 3d 01 00 00       	jmp    801e11 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  801cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  801cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cdd:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ce2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  801ce5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ce9:	74 0e                	je     801cf9 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  801ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cee:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801cf1:	05 00 10 00 00       	add    $0x1000,%eax
  801cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  801cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfc:	c1 e8 0c             	shr    $0xc,%eax
  801cff:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  801d02:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d07:	85 c0                	test   %eax,%eax
  801d09:	75 0a                	jne    801d15 <smalloc+0x62>
		return NULL;
  801d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d10:	e9 fc 00 00 00       	jmp    801e11 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  801d15:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801d1a:	85 c0                	test   %eax,%eax
  801d1c:	74 0f                	je     801d2d <smalloc+0x7a>
  801d1e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801d24:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d29:	39 c2                	cmp    %eax,%edx
  801d2b:	73 0a                	jae    801d37 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  801d2d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d32:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  801d37:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d3c:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801d41:	29 c2                	sub    %eax,%edx
  801d43:	89 d0                	mov    %edx,%eax
  801d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  801d48:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801d4e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d53:	29 c2                	sub    %eax,%edx
  801d55:	89 d0                	mov    %edx,%eax
  801d57:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d60:	77 13                	ja     801d75 <smalloc+0xc2>
  801d62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d65:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d68:	77 0b                	ja     801d75 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  801d6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d6d:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801d70:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801d73:	73 0a                	jae    801d7f <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7a:	e9 92 00 00 00       	jmp    801e11 <smalloc+0x15e>
	}

	void *va = NULL;
  801d7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801d86:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801d8b:	83 f8 05             	cmp    $0x5,%eax
  801d8e:	75 11                	jne    801da1 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  801d90:	83 ec 0c             	sub    $0xc,%esp
  801d93:	ff 75 f4             	pushl  -0xc(%ebp)
  801d96:	e8 08 f7 ff ff       	call   8014a3 <alloc_pages_custom_fit>
  801d9b:	83 c4 10             	add    $0x10,%esp
  801d9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  801da1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801da5:	75 27                	jne    801dce <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  801da7:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  801dae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801db1:	2b 45 f4             	sub    -0xc(%ebp),%eax
  801db4:	89 c2                	mov    %eax,%edx
  801db6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801dbb:	39 c2                	cmp    %eax,%edx
  801dbd:	73 07                	jae    801dc6 <smalloc+0x113>
			return NULL;}
  801dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc4:	eb 4b                	jmp    801e11 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  801dc6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  801dce:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801dd2:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd5:	50                   	push   %eax
  801dd6:	ff 75 0c             	pushl  0xc(%ebp)
  801dd9:	ff 75 08             	pushl  0x8(%ebp)
  801ddc:	e8 cb 03 00 00       	call   8021ac <sys_create_shared_object>
  801de1:	83 c4 10             	add    $0x10,%esp
  801de4:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  801de7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801deb:	79 07                	jns    801df4 <smalloc+0x141>
		return NULL;
  801ded:	b8 00 00 00 00       	mov    $0x0,%eax
  801df2:	eb 1d                	jmp    801e11 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  801df4:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801df9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  801dfc:	75 10                	jne    801e0e <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  801dfe:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e07:	01 d0                	add    %edx,%eax
  801e09:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  801e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e19:	e8 d4 fa ff ff       	call   8018f2 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  801e1e:	83 ec 08             	sub    $0x8,%esp
  801e21:	ff 75 0c             	pushl  0xc(%ebp)
  801e24:	ff 75 08             	pushl  0x8(%ebp)
  801e27:	e8 aa 03 00 00       	call   8021d6 <sys_size_of_shared_object>
  801e2c:	83 c4 10             	add    $0x10,%esp
  801e2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  801e32:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e36:	7f 0a                	jg     801e42 <sget+0x2f>
		return NULL;
  801e38:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3d:	e9 32 01 00 00       	jmp    801f74 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  801e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e45:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  801e48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e4b:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e50:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  801e53:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e57:	74 0e                	je     801e67 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  801e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  801e5f:	05 00 10 00 00       	add    $0x1000,%eax
  801e64:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  801e67:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	75 0a                	jne    801e7a <sget+0x67>
		return NULL;
  801e70:	b8 00 00 00 00       	mov    $0x0,%eax
  801e75:	e9 fa 00 00 00       	jmp    801f74 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  801e7a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e7f:	85 c0                	test   %eax,%eax
  801e81:	74 0f                	je     801e92 <sget+0x7f>
  801e83:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801e89:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e8e:	39 c2                	cmp    %eax,%edx
  801e90:	73 0a                	jae    801e9c <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  801e92:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e97:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  801e9c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ea1:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801ea6:	29 c2                	sub    %eax,%edx
  801ea8:	89 d0                	mov    %edx,%eax
  801eaa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  801ead:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801eb3:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801eb8:	29 c2                	sub    %eax,%edx
  801eba:	89 d0                	mov    %edx,%eax
  801ebc:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  801ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ec5:	77 13                	ja     801eda <sget+0xc7>
  801ec7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eca:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ecd:	77 0b                	ja     801eda <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  801ecf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ed2:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  801ed5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801ed8:	73 0a                	jae    801ee4 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  801eda:	b8 00 00 00 00       	mov    $0x0,%eax
  801edf:	e9 90 00 00 00       	jmp    801f74 <sget+0x161>

	void *va = NULL;
  801ee4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  801eeb:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801ef0:	83 f8 05             	cmp    $0x5,%eax
  801ef3:	75 11                	jne    801f06 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  801ef5:	83 ec 0c             	sub    $0xc,%esp
  801ef8:	ff 75 f4             	pushl  -0xc(%ebp)
  801efb:	e8 a3 f5 ff ff       	call   8014a3 <alloc_pages_custom_fit>
  801f00:	83 c4 10             	add    $0x10,%esp
  801f03:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  801f06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f0a:	75 27                	jne    801f33 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  801f0c:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  801f13:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f16:	2b 45 f4             	sub    -0xc(%ebp),%eax
  801f19:	89 c2                	mov    %eax,%edx
  801f1b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f20:	39 c2                	cmp    %eax,%edx
  801f22:	73 07                	jae    801f2b <sget+0x118>
			return NULL;
  801f24:	b8 00 00 00 00       	mov    $0x0,%eax
  801f29:	eb 49                	jmp    801f74 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  801f2b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  801f33:	83 ec 04             	sub    $0x4,%esp
  801f36:	ff 75 f0             	pushl  -0x10(%ebp)
  801f39:	ff 75 0c             	pushl  0xc(%ebp)
  801f3c:	ff 75 08             	pushl  0x8(%ebp)
  801f3f:	e8 af 02 00 00       	call   8021f3 <sys_get_shared_object>
  801f44:	83 c4 10             	add    $0x10,%esp
  801f47:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  801f4a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801f4e:	79 07                	jns    801f57 <sget+0x144>
		return NULL;
  801f50:	b8 00 00 00 00       	mov    $0x0,%eax
  801f55:	eb 1d                	jmp    801f74 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  801f57:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f5c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  801f5f:	75 10                	jne    801f71 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  801f61:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6a:	01 d0                	add    %edx,%eax
  801f6c:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  801f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f7c:	e8 71 f9 ff ff       	call   8018f2 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801f81:	83 ec 04             	sub    $0x4,%esp
  801f84:	68 74 40 80 00       	push   $0x804074
  801f89:	68 19 02 00 00       	push   $0x219
  801f8e:	68 51 3c 80 00       	push   $0x803c51
  801f93:	e8 e9 12 00 00       	call   803281 <_panic>

00801f98 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801f9e:	83 ec 04             	sub    $0x4,%esp
  801fa1:	68 9c 40 80 00       	push   $0x80409c
  801fa6:	68 2b 02 00 00       	push   $0x22b
  801fab:	68 51 3c 80 00       	push   $0x803c51
  801fb0:	e8 cc 12 00 00       	call   803281 <_panic>

00801fb5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	57                   	push   %edi
  801fb9:	56                   	push   %esi
  801fba:	53                   	push   %ebx
  801fbb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fc7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fca:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fcd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fd0:	cd 30                	int    $0x30
  801fd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fd8:	83 c4 10             	add    $0x10,%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5f                   	pop    %edi
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    

00801fe0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 04             	sub    $0x4,%esp
  801fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801fec:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fef:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	6a 00                	push   $0x0
  801ff8:	51                   	push   %ecx
  801ff9:	52                   	push   %edx
  801ffa:	ff 75 0c             	pushl  0xc(%ebp)
  801ffd:	50                   	push   %eax
  801ffe:	6a 00                	push   $0x0
  802000:	e8 b0 ff ff ff       	call   801fb5 <syscall>
  802005:	83 c4 18             	add    $0x18,%esp
}
  802008:	90                   	nop
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <sys_cgetc>:

int
sys_cgetc(void)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 02                	push   $0x2
  80201a:	e8 96 ff ff ff       	call   801fb5 <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 03                	push   $0x3
  802033:	e8 7d ff ff ff       	call   801fb5 <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
}
  80203b:	90                   	nop
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 04                	push   $0x4
  80204d:	e8 63 ff ff ff       	call   801fb5 <syscall>
  802052:	83 c4 18             	add    $0x18,%esp
}
  802055:	90                   	nop
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80205b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	52                   	push   %edx
  802068:	50                   	push   %eax
  802069:	6a 08                	push   $0x8
  80206b:	e8 45 ff ff ff       	call   801fb5 <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	56                   	push   %esi
  802079:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80207a:	8b 75 18             	mov    0x18(%ebp),%esi
  80207d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802080:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802083:	8b 55 0c             	mov    0xc(%ebp),%edx
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	56                   	push   %esi
  80208a:	53                   	push   %ebx
  80208b:	51                   	push   %ecx
  80208c:	52                   	push   %edx
  80208d:	50                   	push   %eax
  80208e:	6a 09                	push   $0x9
  802090:	e8 20 ff ff ff       	call   801fb5 <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
}
  802098:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80209b:	5b                   	pop    %ebx
  80209c:	5e                   	pop    %esi
  80209d:	5d                   	pop    %ebp
  80209e:	c3                   	ret    

0080209f <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	ff 75 08             	pushl  0x8(%ebp)
  8020ad:	6a 0a                	push   $0xa
  8020af:	e8 01 ff ff ff       	call   801fb5 <syscall>
  8020b4:	83 c4 18             	add    $0x18,%esp
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	ff 75 0c             	pushl  0xc(%ebp)
  8020c5:	ff 75 08             	pushl  0x8(%ebp)
  8020c8:	6a 0b                	push   $0xb
  8020ca:	e8 e6 fe ff ff       	call   801fb5 <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 0c                	push   $0xc
  8020e3:	e8 cd fe ff ff       	call   801fb5 <syscall>
  8020e8:	83 c4 18             	add    $0x18,%esp
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 0d                	push   $0xd
  8020fc:	e8 b4 fe ff ff       	call   801fb5 <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 0e                	push   $0xe
  802115:	e8 9b fe ff ff       	call   801fb5 <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 0f                	push   $0xf
  80212e:	e8 82 fe ff ff       	call   801fb5 <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	ff 75 08             	pushl  0x8(%ebp)
  802146:	6a 10                	push   $0x10
  802148:	e8 68 fe ff ff       	call   801fb5 <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
}
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 11                	push   $0x11
  802161:	e8 4f fe ff ff       	call   801fb5 <syscall>
  802166:	83 c4 18             	add    $0x18,%esp
}
  802169:	90                   	nop
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <sys_cputc>:

void
sys_cputc(const char c)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 04             	sub    $0x4,%esp
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802178:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	50                   	push   %eax
  802185:	6a 01                	push   $0x1
  802187:	e8 29 fe ff ff       	call   801fb5 <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
}
  80218f:	90                   	nop
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 14                	push   $0x14
  8021a1:	e8 0f fe ff ff       	call   801fb5 <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
}
  8021a9:	90                   	nop
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 04             	sub    $0x4,%esp
  8021b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021b8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021bb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	6a 00                	push   $0x0
  8021c4:	51                   	push   %ecx
  8021c5:	52                   	push   %edx
  8021c6:	ff 75 0c             	pushl  0xc(%ebp)
  8021c9:	50                   	push   %eax
  8021ca:	6a 15                	push   $0x15
  8021cc:	e8 e4 fd ff ff       	call   801fb5 <syscall>
  8021d1:	83 c4 18             	add    $0x18,%esp
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	52                   	push   %edx
  8021e6:	50                   	push   %eax
  8021e7:	6a 16                	push   $0x16
  8021e9:	e8 c7 fd ff ff       	call   801fb5 <syscall>
  8021ee:	83 c4 18             	add    $0x18,%esp
}
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	51                   	push   %ecx
  802204:	52                   	push   %edx
  802205:	50                   	push   %eax
  802206:	6a 17                	push   $0x17
  802208:	e8 a8 fd ff ff       	call   801fb5 <syscall>
  80220d:	83 c4 18             	add    $0x18,%esp
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802215:	8b 55 0c             	mov    0xc(%ebp),%edx
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	52                   	push   %edx
  802222:	50                   	push   %eax
  802223:	6a 18                	push   $0x18
  802225:	e8 8b fd ff ff       	call   801fb5 <syscall>
  80222a:	83 c4 18             	add    $0x18,%esp
}
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	6a 00                	push   $0x0
  802237:	ff 75 14             	pushl  0x14(%ebp)
  80223a:	ff 75 10             	pushl  0x10(%ebp)
  80223d:	ff 75 0c             	pushl  0xc(%ebp)
  802240:	50                   	push   %eax
  802241:	6a 19                	push   $0x19
  802243:	e8 6d fd ff ff       	call   801fb5 <syscall>
  802248:	83 c4 18             	add    $0x18,%esp
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	50                   	push   %eax
  80225c:	6a 1a                	push   $0x1a
  80225e:	e8 52 fd ff ff       	call   801fb5 <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
}
  802266:	90                   	nop
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	50                   	push   %eax
  802278:	6a 1b                	push   $0x1b
  80227a:	e8 36 fd ff ff       	call   801fb5 <syscall>
  80227f:	83 c4 18             	add    $0x18,%esp
}
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 05                	push   $0x5
  802293:	e8 1d fd ff ff       	call   801fb5 <syscall>
  802298:	83 c4 18             	add    $0x18,%esp
}
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 06                	push   $0x6
  8022ac:	e8 04 fd ff ff       	call   801fb5 <syscall>
  8022b1:	83 c4 18             	add    $0x18,%esp
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 07                	push   $0x7
  8022c5:	e8 eb fc ff ff       	call   801fb5 <syscall>
  8022ca:	83 c4 18             	add    $0x18,%esp
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <sys_exit_env>:


void sys_exit_env(void)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 1c                	push   $0x1c
  8022de:	e8 d2 fc ff ff       	call   801fb5 <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
}
  8022e6:	90                   	nop
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
  8022ec:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022ef:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022f2:	8d 50 04             	lea    0x4(%eax),%edx
  8022f5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	52                   	push   %edx
  8022ff:	50                   	push   %eax
  802300:	6a 1d                	push   $0x1d
  802302:	e8 ae fc ff ff       	call   801fb5 <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
	return result;
  80230a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80230d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802310:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802313:	89 01                	mov    %eax,(%ecx)
  802315:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	c9                   	leave  
  80231c:	c2 04 00             	ret    $0x4

0080231f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	ff 75 10             	pushl  0x10(%ebp)
  802329:	ff 75 0c             	pushl  0xc(%ebp)
  80232c:	ff 75 08             	pushl  0x8(%ebp)
  80232f:	6a 13                	push   $0x13
  802331:	e8 7f fc ff ff       	call   801fb5 <syscall>
  802336:	83 c4 18             	add    $0x18,%esp
	return ;
  802339:	90                   	nop
}
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <sys_rcr2>:
uint32 sys_rcr2()
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 1e                	push   $0x1e
  80234b:	e8 65 fc ff ff       	call   801fb5 <syscall>
  802350:	83 c4 18             	add    $0x18,%esp
}
  802353:	c9                   	leave  
  802354:	c3                   	ret    

00802355 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
  802358:	83 ec 04             	sub    $0x4,%esp
  80235b:	8b 45 08             	mov    0x8(%ebp),%eax
  80235e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802361:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	50                   	push   %eax
  80236e:	6a 1f                	push   $0x1f
  802370:	e8 40 fc ff ff       	call   801fb5 <syscall>
  802375:	83 c4 18             	add    $0x18,%esp
	return ;
  802378:	90                   	nop
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <rsttst>:
void rsttst()
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 21                	push   $0x21
  80238a:	e8 26 fc ff ff       	call   801fb5 <syscall>
  80238f:	83 c4 18             	add    $0x18,%esp
	return ;
  802392:	90                   	nop
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	83 ec 04             	sub    $0x4,%esp
  80239b:	8b 45 14             	mov    0x14(%ebp),%eax
  80239e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023a1:	8b 55 18             	mov    0x18(%ebp),%edx
  8023a4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023a8:	52                   	push   %edx
  8023a9:	50                   	push   %eax
  8023aa:	ff 75 10             	pushl  0x10(%ebp)
  8023ad:	ff 75 0c             	pushl  0xc(%ebp)
  8023b0:	ff 75 08             	pushl  0x8(%ebp)
  8023b3:	6a 20                	push   $0x20
  8023b5:	e8 fb fb ff ff       	call   801fb5 <syscall>
  8023ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8023bd:	90                   	nop
}
  8023be:	c9                   	leave  
  8023bf:	c3                   	ret    

008023c0 <chktst>:
void chktst(uint32 n)
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	ff 75 08             	pushl  0x8(%ebp)
  8023ce:	6a 22                	push   $0x22
  8023d0:	e8 e0 fb ff ff       	call   801fb5 <syscall>
  8023d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d8:	90                   	nop
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <inctst>:

void inctst()
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 23                	push   $0x23
  8023ea:	e8 c6 fb ff ff       	call   801fb5 <syscall>
  8023ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f2:	90                   	nop
}
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <gettst>:
uint32 gettst()
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 24                	push   $0x24
  802404:	e8 ac fb ff ff       	call   801fb5 <syscall>
  802409:	83 c4 18             	add    $0x18,%esp
}
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 25                	push   $0x25
  80241d:	e8 93 fb ff ff       	call   801fb5 <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
  802425:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  80242a:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	ff 75 08             	pushl  0x8(%ebp)
  802447:	6a 26                	push   $0x26
  802449:	e8 67 fb ff ff       	call   801fb5 <syscall>
  80244e:	83 c4 18             	add    $0x18,%esp
	return ;
  802451:	90                   	nop
}
  802452:	c9                   	leave  
  802453:	c3                   	ret    

00802454 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
  802457:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802458:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80245b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80245e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	6a 00                	push   $0x0
  802466:	53                   	push   %ebx
  802467:	51                   	push   %ecx
  802468:	52                   	push   %edx
  802469:	50                   	push   %eax
  80246a:	6a 27                	push   $0x27
  80246c:	e8 44 fb ff ff       	call   801fb5 <syscall>
  802471:	83 c4 18             	add    $0x18,%esp
}
  802474:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802477:	c9                   	leave  
  802478:	c3                   	ret    

00802479 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802479:	55                   	push   %ebp
  80247a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80247c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	52                   	push   %edx
  802489:	50                   	push   %eax
  80248a:	6a 28                	push   $0x28
  80248c:	e8 24 fb ff ff       	call   801fb5 <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802499:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80249c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	6a 00                	push   $0x0
  8024a4:	51                   	push   %ecx
  8024a5:	ff 75 10             	pushl  0x10(%ebp)
  8024a8:	52                   	push   %edx
  8024a9:	50                   	push   %eax
  8024aa:	6a 29                	push   $0x29
  8024ac:	e8 04 fb ff ff       	call   801fb5 <syscall>
  8024b1:	83 c4 18             	add    $0x18,%esp
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	ff 75 10             	pushl  0x10(%ebp)
  8024c0:	ff 75 0c             	pushl  0xc(%ebp)
  8024c3:	ff 75 08             	pushl  0x8(%ebp)
  8024c6:	6a 12                	push   $0x12
  8024c8:	e8 e8 fa ff ff       	call   801fb5 <syscall>
  8024cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d0:	90                   	nop
}
  8024d1:	c9                   	leave  
  8024d2:	c3                   	ret    

008024d3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8024d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	52                   	push   %edx
  8024e3:	50                   	push   %eax
  8024e4:	6a 2a                	push   $0x2a
  8024e6:	e8 ca fa ff ff       	call   801fb5 <syscall>
  8024eb:	83 c4 18             	add    $0x18,%esp
	return;
  8024ee:	90                   	nop
}
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 2b                	push   $0x2b
  802500:	e8 b0 fa ff ff       	call   801fb5 <syscall>
  802505:	83 c4 18             	add    $0x18,%esp
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	ff 75 0c             	pushl  0xc(%ebp)
  802516:	ff 75 08             	pushl  0x8(%ebp)
  802519:	6a 2d                	push   $0x2d
  80251b:	e8 95 fa ff ff       	call   801fb5 <syscall>
  802520:	83 c4 18             	add    $0x18,%esp
	return;
  802523:	90                   	nop
}
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	ff 75 0c             	pushl  0xc(%ebp)
  802532:	ff 75 08             	pushl  0x8(%ebp)
  802535:	6a 2c                	push   $0x2c
  802537:	e8 79 fa ff ff       	call   801fb5 <syscall>
  80253c:	83 c4 18             	add    $0x18,%esp
	return ;
  80253f:	90                   	nop
}
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802545:	8b 55 0c             	mov    0xc(%ebp),%edx
  802548:	8b 45 08             	mov    0x8(%ebp),%eax
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	52                   	push   %edx
  802552:	50                   	push   %eax
  802553:	6a 2e                	push   $0x2e
  802555:	e8 5b fa ff ff       	call   801fb5 <syscall>
  80255a:	83 c4 18             	add    $0x18,%esp
	return ;
  80255d:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802566:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  80256d:	72 09                	jb     802578 <to_page_va+0x18>
  80256f:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802576:	72 14                	jb     80258c <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802578:	83 ec 04             	sub    $0x4,%esp
  80257b:	68 c0 40 80 00       	push   $0x8040c0
  802580:	6a 15                	push   $0x15
  802582:	68 eb 40 80 00       	push   $0x8040eb
  802587:	e8 f5 0c 00 00       	call   803281 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	ba 60 50 80 00       	mov    $0x805060,%edx
  802594:	29 d0                	sub    %edx,%eax
  802596:	c1 f8 02             	sar    $0x2,%eax
  802599:	89 c2                	mov    %eax,%edx
  80259b:	89 d0                	mov    %edx,%eax
  80259d:	c1 e0 02             	shl    $0x2,%eax
  8025a0:	01 d0                	add    %edx,%eax
  8025a2:	c1 e0 02             	shl    $0x2,%eax
  8025a5:	01 d0                	add    %edx,%eax
  8025a7:	c1 e0 02             	shl    $0x2,%eax
  8025aa:	01 d0                	add    %edx,%eax
  8025ac:	89 c1                	mov    %eax,%ecx
  8025ae:	c1 e1 08             	shl    $0x8,%ecx
  8025b1:	01 c8                	add    %ecx,%eax
  8025b3:	89 c1                	mov    %eax,%ecx
  8025b5:	c1 e1 10             	shl    $0x10,%ecx
  8025b8:	01 c8                	add    %ecx,%eax
  8025ba:	01 c0                	add    %eax,%eax
  8025bc:	01 d0                	add    %edx,%eax
  8025be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	c1 e0 0c             	shl    $0xc,%eax
  8025c7:	89 c2                	mov    %eax,%edx
  8025c9:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8025ce:	01 d0                	add    %edx,%eax
}
  8025d0:	c9                   	leave  
  8025d1:	c3                   	ret    

008025d2 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
  8025d5:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8025d8:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8025dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e0:	29 c2                	sub    %eax,%edx
  8025e2:	89 d0                	mov    %edx,%eax
  8025e4:	c1 e8 0c             	shr    $0xc,%eax
  8025e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8025ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ee:	78 09                	js     8025f9 <to_page_info+0x27>
  8025f0:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8025f7:	7e 14                	jle    80260d <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  8025f9:	83 ec 04             	sub    $0x4,%esp
  8025fc:	68 04 41 80 00       	push   $0x804104
  802601:	6a 22                	push   $0x22
  802603:	68 eb 40 80 00       	push   $0x8040eb
  802608:	e8 74 0c 00 00       	call   803281 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80260d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802610:	89 d0                	mov    %edx,%eax
  802612:	01 c0                	add    %eax,%eax
  802614:	01 d0                	add    %edx,%eax
  802616:	c1 e0 02             	shl    $0x2,%eax
  802619:	05 60 50 80 00       	add    $0x805060,%eax
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802626:	8b 45 08             	mov    0x8(%ebp),%eax
  802629:	05 00 00 00 02       	add    $0x2000000,%eax
  80262e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802631:	73 16                	jae    802649 <initialize_dynamic_allocator+0x29>
  802633:	68 28 41 80 00       	push   $0x804128
  802638:	68 4e 41 80 00       	push   $0x80414e
  80263d:	6a 34                	push   $0x34
  80263f:	68 eb 40 80 00       	push   $0x8040eb
  802644:	e8 38 0c 00 00       	call   803281 <_panic>
		is_initialized = 1;
  802649:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  802650:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  80265b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80265e:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802663:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  80266a:	00 00 00 
  80266d:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802674:	00 00 00 
  802677:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  80267e:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802681:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802688:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80268f:	eb 36                	jmp    8026c7 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	c1 e0 04             	shl    $0x4,%eax
  802697:	05 80 d0 81 00       	add    $0x81d080,%eax
  80269c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	c1 e0 04             	shl    $0x4,%eax
  8026a8:	05 84 d0 81 00       	add    $0x81d084,%eax
  8026ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	c1 e0 04             	shl    $0x4,%eax
  8026b9:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8026be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  8026c4:	ff 45 f4             	incl   -0xc(%ebp)
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026cd:	72 c2                	jb     802691 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  8026cf:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8026d5:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8026da:	29 c2                	sub    %eax,%edx
  8026dc:	89 d0                	mov    %edx,%eax
  8026de:	c1 e8 0c             	shr    $0xc,%eax
  8026e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  8026e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8026eb:	e9 c8 00 00 00       	jmp    8027b8 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  8026f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f3:	89 d0                	mov    %edx,%eax
  8026f5:	01 c0                	add    %eax,%eax
  8026f7:	01 d0                	add    %edx,%eax
  8026f9:	c1 e0 02             	shl    $0x2,%eax
  8026fc:	05 68 50 80 00       	add    $0x805068,%eax
  802701:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802706:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802709:	89 d0                	mov    %edx,%eax
  80270b:	01 c0                	add    %eax,%eax
  80270d:	01 d0                	add    %edx,%eax
  80270f:	c1 e0 02             	shl    $0x2,%eax
  802712:	05 6a 50 80 00       	add    $0x80506a,%eax
  802717:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80271c:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802722:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802725:	89 c8                	mov    %ecx,%eax
  802727:	01 c0                	add    %eax,%eax
  802729:	01 c8                	add    %ecx,%eax
  80272b:	c1 e0 02             	shl    $0x2,%eax
  80272e:	05 64 50 80 00       	add    $0x805064,%eax
  802733:	89 10                	mov    %edx,(%eax)
  802735:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802738:	89 d0                	mov    %edx,%eax
  80273a:	01 c0                	add    %eax,%eax
  80273c:	01 d0                	add    %edx,%eax
  80273e:	c1 e0 02             	shl    $0x2,%eax
  802741:	05 64 50 80 00       	add    $0x805064,%eax
  802746:	8b 00                	mov    (%eax),%eax
  802748:	85 c0                	test   %eax,%eax
  80274a:	74 1b                	je     802767 <initialize_dynamic_allocator+0x147>
  80274c:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802752:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802755:	89 c8                	mov    %ecx,%eax
  802757:	01 c0                	add    %eax,%eax
  802759:	01 c8                	add    %ecx,%eax
  80275b:	c1 e0 02             	shl    $0x2,%eax
  80275e:	05 60 50 80 00       	add    $0x805060,%eax
  802763:	89 02                	mov    %eax,(%edx)
  802765:	eb 16                	jmp    80277d <initialize_dynamic_allocator+0x15d>
  802767:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80276a:	89 d0                	mov    %edx,%eax
  80276c:	01 c0                	add    %eax,%eax
  80276e:	01 d0                	add    %edx,%eax
  802770:	c1 e0 02             	shl    $0x2,%eax
  802773:	05 60 50 80 00       	add    $0x805060,%eax
  802778:	a3 48 50 80 00       	mov    %eax,0x805048
  80277d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802780:	89 d0                	mov    %edx,%eax
  802782:	01 c0                	add    %eax,%eax
  802784:	01 d0                	add    %edx,%eax
  802786:	c1 e0 02             	shl    $0x2,%eax
  802789:	05 60 50 80 00       	add    $0x805060,%eax
  80278e:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802793:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802796:	89 d0                	mov    %edx,%eax
  802798:	01 c0                	add    %eax,%eax
  80279a:	01 d0                	add    %edx,%eax
  80279c:	c1 e0 02             	shl    $0x2,%eax
  80279f:	05 60 50 80 00       	add    $0x805060,%eax
  8027a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027aa:	a1 54 50 80 00       	mov    0x805054,%eax
  8027af:	40                   	inc    %eax
  8027b0:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  8027b5:	ff 45 f0             	incl   -0x10(%ebp)
  8027b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8027be:	0f 82 2c ff ff ff    	jb     8026f0 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8027c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027ca:	eb 2f                	jmp    8027fb <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  8027cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027cf:	89 d0                	mov    %edx,%eax
  8027d1:	01 c0                	add    %eax,%eax
  8027d3:	01 d0                	add    %edx,%eax
  8027d5:	c1 e0 02             	shl    $0x2,%eax
  8027d8:	05 68 50 80 00       	add    $0x805068,%eax
  8027dd:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  8027e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027e5:	89 d0                	mov    %edx,%eax
  8027e7:	01 c0                	add    %eax,%eax
  8027e9:	01 d0                	add    %edx,%eax
  8027eb:	c1 e0 02             	shl    $0x2,%eax
  8027ee:	05 6a 50 80 00       	add    $0x80506a,%eax
  8027f3:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8027f8:	ff 45 ec             	incl   -0x14(%ebp)
  8027fb:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802802:	76 c8                	jbe    8027cc <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802804:	90                   	nop
  802805:	c9                   	leave  
  802806:	c3                   	ret    

00802807 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802807:	55                   	push   %ebp
  802808:	89 e5                	mov    %esp,%ebp
  80280a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  80280d:	8b 55 08             	mov    0x8(%ebp),%edx
  802810:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802815:	29 c2                	sub    %eax,%edx
  802817:	89 d0                	mov    %edx,%eax
  802819:	c1 e8 0c             	shr    $0xc,%eax
  80281c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  80281f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802822:	89 d0                	mov    %edx,%eax
  802824:	01 c0                	add    %eax,%eax
  802826:	01 d0                	add    %edx,%eax
  802828:	c1 e0 02             	shl    $0x2,%eax
  80282b:	05 68 50 80 00       	add    $0x805068,%eax
  802830:	8b 00                	mov    (%eax),%eax
  802832:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802835:	c9                   	leave  
  802836:	c3                   	ret    

00802837 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802837:	55                   	push   %ebp
  802838:	89 e5                	mov    %esp,%ebp
  80283a:	83 ec 14             	sub    $0x14,%esp
  80283d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802840:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802844:	77 07                	ja     80284d <nearest_pow2_ceil.1513+0x16>
  802846:	b8 01 00 00 00       	mov    $0x1,%eax
  80284b:	eb 20                	jmp    80286d <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  80284d:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802854:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802857:	eb 08                	jmp    802861 <nearest_pow2_ceil.1513+0x2a>
  802859:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80285c:	01 c0                	add    %eax,%eax
  80285e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802861:	d1 6d 08             	shrl   0x8(%ebp)
  802864:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802868:	75 ef                	jne    802859 <nearest_pow2_ceil.1513+0x22>
        return power;
  80286a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  80286d:	c9                   	leave  
  80286e:	c3                   	ret    

0080286f <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80286f:	55                   	push   %ebp
  802870:	89 e5                	mov    %esp,%ebp
  802872:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802875:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80287c:	76 16                	jbe    802894 <alloc_block+0x25>
  80287e:	68 64 41 80 00       	push   $0x804164
  802883:	68 4e 41 80 00       	push   $0x80414e
  802888:	6a 72                	push   $0x72
  80288a:	68 eb 40 80 00       	push   $0x8040eb
  80288f:	e8 ed 09 00 00       	call   803281 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802894:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802898:	75 0a                	jne    8028a4 <alloc_block+0x35>
  80289a:	b8 00 00 00 00       	mov    $0x0,%eax
  80289f:	e9 bd 04 00 00       	jmp    802d61 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8028a4:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8028b1:	73 06                	jae    8028b9 <alloc_block+0x4a>
        size = min_block_size;
  8028b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b6:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  8028b9:	83 ec 0c             	sub    $0xc,%esp
  8028bc:	8d 45 cc             	lea    -0x34(%ebp),%eax
  8028bf:	ff 75 08             	pushl  0x8(%ebp)
  8028c2:	89 c1                	mov    %eax,%ecx
  8028c4:	e8 6e ff ff ff       	call   802837 <nearest_pow2_ceil.1513>
  8028c9:	83 c4 10             	add    $0x10,%esp
  8028cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  8028cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028d2:	83 ec 0c             	sub    $0xc,%esp
  8028d5:	8d 45 cc             	lea    -0x34(%ebp),%eax
  8028d8:	52                   	push   %edx
  8028d9:	89 c1                	mov    %eax,%ecx
  8028db:	e8 83 04 00 00       	call   802d63 <log2_ceil.1520>
  8028e0:	83 c4 10             	add    $0x10,%esp
  8028e3:	83 e8 03             	sub    $0x3,%eax
  8028e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  8028e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ec:	c1 e0 04             	shl    $0x4,%eax
  8028ef:	05 80 d0 81 00       	add    $0x81d080,%eax
  8028f4:	8b 00                	mov    (%eax),%eax
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	0f 84 d8 00 00 00    	je     8029d6 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8028fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802901:	c1 e0 04             	shl    $0x4,%eax
  802904:	05 80 d0 81 00       	add    $0x81d080,%eax
  802909:	8b 00                	mov    (%eax),%eax
  80290b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  80290e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802912:	75 17                	jne    80292b <alloc_block+0xbc>
  802914:	83 ec 04             	sub    $0x4,%esp
  802917:	68 85 41 80 00       	push   $0x804185
  80291c:	68 98 00 00 00       	push   $0x98
  802921:	68 eb 40 80 00       	push   $0x8040eb
  802926:	e8 56 09 00 00       	call   803281 <_panic>
  80292b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80292e:	8b 00                	mov    (%eax),%eax
  802930:	85 c0                	test   %eax,%eax
  802932:	74 10                	je     802944 <alloc_block+0xd5>
  802934:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802937:	8b 00                	mov    (%eax),%eax
  802939:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80293c:	8b 52 04             	mov    0x4(%edx),%edx
  80293f:	89 50 04             	mov    %edx,0x4(%eax)
  802942:	eb 14                	jmp    802958 <alloc_block+0xe9>
  802944:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802947:	8b 40 04             	mov    0x4(%eax),%eax
  80294a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80294d:	c1 e2 04             	shl    $0x4,%edx
  802950:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802956:	89 02                	mov    %eax,(%edx)
  802958:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80295b:	8b 40 04             	mov    0x4(%eax),%eax
  80295e:	85 c0                	test   %eax,%eax
  802960:	74 0f                	je     802971 <alloc_block+0x102>
  802962:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802965:	8b 40 04             	mov    0x4(%eax),%eax
  802968:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80296b:	8b 12                	mov    (%edx),%edx
  80296d:	89 10                	mov    %edx,(%eax)
  80296f:	eb 13                	jmp    802984 <alloc_block+0x115>
  802971:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802974:	8b 00                	mov    (%eax),%eax
  802976:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802979:	c1 e2 04             	shl    $0x4,%edx
  80297c:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802982:	89 02                	mov    %eax,(%edx)
  802984:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802987:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80298d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802990:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802997:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299a:	c1 e0 04             	shl    $0x4,%eax
  80299d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8029a2:	8b 00                	mov    (%eax),%eax
  8029a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8029a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029aa:	c1 e0 04             	shl    $0x4,%eax
  8029ad:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8029b2:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  8029b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029b7:	83 ec 0c             	sub    $0xc,%esp
  8029ba:	50                   	push   %eax
  8029bb:	e8 12 fc ff ff       	call   8025d2 <to_page_info>
  8029c0:	83 c4 10             	add    $0x10,%esp
  8029c3:	89 c2                	mov    %eax,%edx
  8029c5:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8029c9:	48                   	dec    %eax
  8029ca:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  8029ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029d1:	e9 8b 03 00 00       	jmp    802d61 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  8029d6:	a1 48 50 80 00       	mov    0x805048,%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	0f 84 64 02 00 00    	je     802c47 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  8029e3:	a1 48 50 80 00       	mov    0x805048,%eax
  8029e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  8029eb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8029ef:	75 17                	jne    802a08 <alloc_block+0x199>
  8029f1:	83 ec 04             	sub    $0x4,%esp
  8029f4:	68 85 41 80 00       	push   $0x804185
  8029f9:	68 a0 00 00 00       	push   $0xa0
  8029fe:	68 eb 40 80 00       	push   $0x8040eb
  802a03:	e8 79 08 00 00       	call   803281 <_panic>
  802a08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a0b:	8b 00                	mov    (%eax),%eax
  802a0d:	85 c0                	test   %eax,%eax
  802a0f:	74 10                	je     802a21 <alloc_block+0x1b2>
  802a11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a14:	8b 00                	mov    (%eax),%eax
  802a16:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a19:	8b 52 04             	mov    0x4(%edx),%edx
  802a1c:	89 50 04             	mov    %edx,0x4(%eax)
  802a1f:	eb 0b                	jmp    802a2c <alloc_block+0x1bd>
  802a21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a24:	8b 40 04             	mov    0x4(%eax),%eax
  802a27:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802a2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a2f:	8b 40 04             	mov    0x4(%eax),%eax
  802a32:	85 c0                	test   %eax,%eax
  802a34:	74 0f                	je     802a45 <alloc_block+0x1d6>
  802a36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a39:	8b 40 04             	mov    0x4(%eax),%eax
  802a3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a3f:	8b 12                	mov    (%edx),%edx
  802a41:	89 10                	mov    %edx,(%eax)
  802a43:	eb 0a                	jmp    802a4f <alloc_block+0x1e0>
  802a45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a48:	8b 00                	mov    (%eax),%eax
  802a4a:	a3 48 50 80 00       	mov    %eax,0x805048
  802a4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a62:	a1 54 50 80 00       	mov    0x805054,%eax
  802a67:	48                   	dec    %eax
  802a68:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802a6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a70:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a73:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802a77:	b8 00 10 00 00       	mov    $0x1000,%eax
  802a7c:	99                   	cltd   
  802a7d:	f7 7d e8             	idivl  -0x18(%ebp)
  802a80:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a83:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802a87:	83 ec 0c             	sub    $0xc,%esp
  802a8a:	ff 75 dc             	pushl  -0x24(%ebp)
  802a8d:	e8 ce fa ff ff       	call   802560 <to_page_va>
  802a92:	83 c4 10             	add    $0x10,%esp
  802a95:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802a98:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a9b:	83 ec 0c             	sub    $0xc,%esp
  802a9e:	50                   	push   %eax
  802a9f:	e8 c0 ee ff ff       	call   801964 <get_page>
  802aa4:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802aa7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802aae:	e9 aa 00 00 00       	jmp    802b5d <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802aba:	89 c2                	mov    %eax,%edx
  802abc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802abf:	01 d0                	add    %edx,%eax
  802ac1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802ac4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802ac8:	75 17                	jne    802ae1 <alloc_block+0x272>
  802aca:	83 ec 04             	sub    $0x4,%esp
  802acd:	68 a4 41 80 00       	push   $0x8041a4
  802ad2:	68 aa 00 00 00       	push   $0xaa
  802ad7:	68 eb 40 80 00       	push   $0x8040eb
  802adc:	e8 a0 07 00 00       	call   803281 <_panic>
  802ae1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae4:	c1 e0 04             	shl    $0x4,%eax
  802ae7:	05 84 d0 81 00       	add    $0x81d084,%eax
  802aec:	8b 10                	mov    (%eax),%edx
  802aee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802af1:	89 50 04             	mov    %edx,0x4(%eax)
  802af4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802af7:	8b 40 04             	mov    0x4(%eax),%eax
  802afa:	85 c0                	test   %eax,%eax
  802afc:	74 14                	je     802b12 <alloc_block+0x2a3>
  802afe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b01:	c1 e0 04             	shl    $0x4,%eax
  802b04:	05 84 d0 81 00       	add    $0x81d084,%eax
  802b09:	8b 00                	mov    (%eax),%eax
  802b0b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802b0e:	89 10                	mov    %edx,(%eax)
  802b10:	eb 11                	jmp    802b23 <alloc_block+0x2b4>
  802b12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b15:	c1 e0 04             	shl    $0x4,%eax
  802b18:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802b1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b21:	89 02                	mov    %eax,(%edx)
  802b23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b26:	c1 e0 04             	shl    $0x4,%eax
  802b29:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802b2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b32:	89 02                	mov    %eax,(%edx)
  802b34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b40:	c1 e0 04             	shl    $0x4,%eax
  802b43:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802b48:	8b 00                	mov    (%eax),%eax
  802b4a:	8d 50 01             	lea    0x1(%eax),%edx
  802b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b50:	c1 e0 04             	shl    $0x4,%eax
  802b53:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802b58:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802b5a:	ff 45 f4             	incl   -0xc(%ebp)
  802b5d:	b8 00 10 00 00       	mov    $0x1000,%eax
  802b62:	99                   	cltd   
  802b63:	f7 7d e8             	idivl  -0x18(%ebp)
  802b66:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b69:	0f 8f 44 ff ff ff    	jg     802ab3 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802b6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b72:	c1 e0 04             	shl    $0x4,%eax
  802b75:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b7a:	8b 00                	mov    (%eax),%eax
  802b7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802b7f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802b83:	75 17                	jne    802b9c <alloc_block+0x32d>
  802b85:	83 ec 04             	sub    $0x4,%esp
  802b88:	68 85 41 80 00       	push   $0x804185
  802b8d:	68 ae 00 00 00       	push   $0xae
  802b92:	68 eb 40 80 00       	push   $0x8040eb
  802b97:	e8 e5 06 00 00       	call   803281 <_panic>
  802b9c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b9f:	8b 00                	mov    (%eax),%eax
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	74 10                	je     802bb5 <alloc_block+0x346>
  802ba5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802bad:	8b 52 04             	mov    0x4(%edx),%edx
  802bb0:	89 50 04             	mov    %edx,0x4(%eax)
  802bb3:	eb 14                	jmp    802bc9 <alloc_block+0x35a>
  802bb5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bb8:	8b 40 04             	mov    0x4(%eax),%eax
  802bbb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bbe:	c1 e2 04             	shl    $0x4,%edx
  802bc1:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802bc7:	89 02                	mov    %eax,(%edx)
  802bc9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bcc:	8b 40 04             	mov    0x4(%eax),%eax
  802bcf:	85 c0                	test   %eax,%eax
  802bd1:	74 0f                	je     802be2 <alloc_block+0x373>
  802bd3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bd6:	8b 40 04             	mov    0x4(%eax),%eax
  802bd9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802bdc:	8b 12                	mov    (%edx),%edx
  802bde:	89 10                	mov    %edx,(%eax)
  802be0:	eb 13                	jmp    802bf5 <alloc_block+0x386>
  802be2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802be5:	8b 00                	mov    (%eax),%eax
  802be7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bea:	c1 e2 04             	shl    $0x4,%edx
  802bed:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802bf3:	89 02                	mov    %eax,(%edx)
  802bf5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bf8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bfe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0b:	c1 e0 04             	shl    $0x4,%eax
  802c0e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802c13:	8b 00                	mov    (%eax),%eax
  802c15:	8d 50 ff             	lea    -0x1(%eax),%edx
  802c18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1b:	c1 e0 04             	shl    $0x4,%eax
  802c1e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802c23:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802c25:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c28:	83 ec 0c             	sub    $0xc,%esp
  802c2b:	50                   	push   %eax
  802c2c:	e8 a1 f9 ff ff       	call   8025d2 <to_page_info>
  802c31:	83 c4 10             	add    $0x10,%esp
  802c34:	89 c2                	mov    %eax,%edx
  802c36:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802c3a:	48                   	dec    %eax
  802c3b:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802c3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c42:	e9 1a 01 00 00       	jmp    802d61 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802c47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4a:	40                   	inc    %eax
  802c4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802c4e:	e9 ed 00 00 00       	jmp    802d40 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c56:	c1 e0 04             	shl    $0x4,%eax
  802c59:	05 80 d0 81 00       	add    $0x81d080,%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	85 c0                	test   %eax,%eax
  802c62:	0f 84 d5 00 00 00    	je     802d3d <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6b:	c1 e0 04             	shl    $0x4,%eax
  802c6e:	05 80 d0 81 00       	add    $0x81d080,%eax
  802c73:	8b 00                	mov    (%eax),%eax
  802c75:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  802c78:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c7c:	75 17                	jne    802c95 <alloc_block+0x426>
  802c7e:	83 ec 04             	sub    $0x4,%esp
  802c81:	68 85 41 80 00       	push   $0x804185
  802c86:	68 b8 00 00 00       	push   $0xb8
  802c8b:	68 eb 40 80 00       	push   $0x8040eb
  802c90:	e8 ec 05 00 00       	call   803281 <_panic>
  802c95:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c98:	8b 00                	mov    (%eax),%eax
  802c9a:	85 c0                	test   %eax,%eax
  802c9c:	74 10                	je     802cae <alloc_block+0x43f>
  802c9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ca1:	8b 00                	mov    (%eax),%eax
  802ca3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ca6:	8b 52 04             	mov    0x4(%edx),%edx
  802ca9:	89 50 04             	mov    %edx,0x4(%eax)
  802cac:	eb 14                	jmp    802cc2 <alloc_block+0x453>
  802cae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb1:	8b 40 04             	mov    0x4(%eax),%eax
  802cb4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb7:	c1 e2 04             	shl    $0x4,%edx
  802cba:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802cc0:	89 02                	mov    %eax,(%edx)
  802cc2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cc5:	8b 40 04             	mov    0x4(%eax),%eax
  802cc8:	85 c0                	test   %eax,%eax
  802cca:	74 0f                	je     802cdb <alloc_block+0x46c>
  802ccc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cd5:	8b 12                	mov    (%edx),%edx
  802cd7:	89 10                	mov    %edx,(%eax)
  802cd9:	eb 13                	jmp    802cee <alloc_block+0x47f>
  802cdb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cde:	8b 00                	mov    (%eax),%eax
  802ce0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce3:	c1 e2 04             	shl    $0x4,%edx
  802ce6:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802cec:	89 02                	mov    %eax,(%edx)
  802cee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cf1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cfa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d04:	c1 e0 04             	shl    $0x4,%eax
  802d07:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d0c:	8b 00                	mov    (%eax),%eax
  802d0e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d14:	c1 e0 04             	shl    $0x4,%eax
  802d17:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d1c:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  802d1e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d21:	83 ec 0c             	sub    $0xc,%esp
  802d24:	50                   	push   %eax
  802d25:	e8 a8 f8 ff ff       	call   8025d2 <to_page_info>
  802d2a:	83 c4 10             	add    $0x10,%esp
  802d2d:	89 c2                	mov    %eax,%edx
  802d2f:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802d33:	48                   	dec    %eax
  802d34:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  802d38:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d3b:	eb 24                	jmp    802d61 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802d3d:	ff 45 f0             	incl   -0x10(%ebp)
  802d40:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802d44:	0f 8e 09 ff ff ff    	jle    802c53 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  802d4a:	83 ec 04             	sub    $0x4,%esp
  802d4d:	68 c7 41 80 00       	push   $0x8041c7
  802d52:	68 bf 00 00 00       	push   $0xbf
  802d57:	68 eb 40 80 00       	push   $0x8040eb
  802d5c:	e8 20 05 00 00       	call   803281 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  802d61:	c9                   	leave  
  802d62:	c3                   	ret    

00802d63 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  802d63:	55                   	push   %ebp
  802d64:	89 e5                	mov    %esp,%ebp
  802d66:	83 ec 14             	sub    $0x14,%esp
  802d69:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  802d6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d70:	75 07                	jne    802d79 <log2_ceil.1520+0x16>
  802d72:	b8 00 00 00 00       	mov    $0x0,%eax
  802d77:	eb 1b                	jmp    802d94 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  802d79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  802d80:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  802d83:	eb 06                	jmp    802d8b <log2_ceil.1520+0x28>
            x >>= 1;
  802d85:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  802d88:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  802d8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d8f:	75 f4                	jne    802d85 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  802d91:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802d94:	c9                   	leave  
  802d95:	c3                   	ret    

00802d96 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  802d96:	55                   	push   %ebp
  802d97:	89 e5                	mov    %esp,%ebp
  802d99:	83 ec 14             	sub    $0x14,%esp
  802d9c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  802d9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802da3:	75 07                	jne    802dac <log2_ceil.1547+0x16>
  802da5:	b8 00 00 00 00       	mov    $0x0,%eax
  802daa:	eb 1b                	jmp    802dc7 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  802dac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  802db3:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  802db6:	eb 06                	jmp    802dbe <log2_ceil.1547+0x28>
			x >>= 1;
  802db8:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  802dbb:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  802dbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc2:	75 f4                	jne    802db8 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  802dc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  802dc7:	c9                   	leave  
  802dc8:	c3                   	ret    

00802dc9 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802dc9:	55                   	push   %ebp
  802dca:	89 e5                	mov    %esp,%ebp
  802dcc:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802dcf:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd2:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802dd7:	39 c2                	cmp    %eax,%edx
  802dd9:	72 0c                	jb     802de7 <free_block+0x1e>
  802ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dde:	a1 40 50 80 00       	mov    0x805040,%eax
  802de3:	39 c2                	cmp    %eax,%edx
  802de5:	72 19                	jb     802e00 <free_block+0x37>
  802de7:	68 cc 41 80 00       	push   $0x8041cc
  802dec:	68 4e 41 80 00       	push   $0x80414e
  802df1:	68 d0 00 00 00       	push   $0xd0
  802df6:	68 eb 40 80 00       	push   $0x8040eb
  802dfb:	e8 81 04 00 00       	call   803281 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  802e00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e04:	0f 84 42 03 00 00    	je     80314c <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  802e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802e12:	39 c2                	cmp    %eax,%edx
  802e14:	72 0c                	jb     802e22 <free_block+0x59>
  802e16:	8b 55 08             	mov    0x8(%ebp),%edx
  802e19:	a1 40 50 80 00       	mov    0x805040,%eax
  802e1e:	39 c2                	cmp    %eax,%edx
  802e20:	72 17                	jb     802e39 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  802e22:	83 ec 04             	sub    $0x4,%esp
  802e25:	68 04 42 80 00       	push   $0x804204
  802e2a:	68 e6 00 00 00       	push   $0xe6
  802e2f:	68 eb 40 80 00       	push   $0x8040eb
  802e34:	e8 48 04 00 00       	call   803281 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  802e39:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802e41:	29 c2                	sub    %eax,%edx
  802e43:	89 d0                	mov    %edx,%eax
  802e45:	83 e0 07             	and    $0x7,%eax
  802e48:	85 c0                	test   %eax,%eax
  802e4a:	74 17                	je     802e63 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  802e4c:	83 ec 04             	sub    $0x4,%esp
  802e4f:	68 38 42 80 00       	push   $0x804238
  802e54:	68 ea 00 00 00       	push   $0xea
  802e59:	68 eb 40 80 00       	push   $0x8040eb
  802e5e:	e8 1e 04 00 00       	call   803281 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	83 ec 0c             	sub    $0xc,%esp
  802e69:	50                   	push   %eax
  802e6a:	e8 63 f7 ff ff       	call   8025d2 <to_page_info>
  802e6f:	83 c4 10             	add    $0x10,%esp
  802e72:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  802e75:	83 ec 0c             	sub    $0xc,%esp
  802e78:	ff 75 08             	pushl  0x8(%ebp)
  802e7b:	e8 87 f9 ff ff       	call   802807 <get_block_size>
  802e80:	83 c4 10             	add    $0x10,%esp
  802e83:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  802e86:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e8a:	75 17                	jne    802ea3 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  802e8c:	83 ec 04             	sub    $0x4,%esp
  802e8f:	68 64 42 80 00       	push   $0x804264
  802e94:	68 f1 00 00 00       	push   $0xf1
  802e99:	68 eb 40 80 00       	push   $0x8040eb
  802e9e:	e8 de 03 00 00       	call   803281 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  802ea3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ea6:	83 ec 0c             	sub    $0xc,%esp
  802ea9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  802eac:	52                   	push   %edx
  802ead:	89 c1                	mov    %eax,%ecx
  802eaf:	e8 e2 fe ff ff       	call   802d96 <log2_ceil.1547>
  802eb4:	83 c4 10             	add    $0x10,%esp
  802eb7:	83 e8 03             	sub    $0x3,%eax
  802eba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  802ec3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ec7:	75 17                	jne    802ee0 <free_block+0x117>
  802ec9:	83 ec 04             	sub    $0x4,%esp
  802ecc:	68 b0 42 80 00       	push   $0x8042b0
  802ed1:	68 f6 00 00 00       	push   $0xf6
  802ed6:	68 eb 40 80 00       	push   $0x8040eb
  802edb:	e8 a1 03 00 00       	call   803281 <_panic>
  802ee0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee3:	c1 e0 04             	shl    $0x4,%eax
  802ee6:	05 80 d0 81 00       	add    $0x81d080,%eax
  802eeb:	8b 10                	mov    (%eax),%edx
  802eed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef0:	89 10                	mov    %edx,(%eax)
  802ef2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef5:	8b 00                	mov    (%eax),%eax
  802ef7:	85 c0                	test   %eax,%eax
  802ef9:	74 15                	je     802f10 <free_block+0x147>
  802efb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802efe:	c1 e0 04             	shl    $0x4,%eax
  802f01:	05 80 d0 81 00       	add    $0x81d080,%eax
  802f06:	8b 00                	mov    (%eax),%eax
  802f08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f0b:	89 50 04             	mov    %edx,0x4(%eax)
  802f0e:	eb 11                	jmp    802f21 <free_block+0x158>
  802f10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f13:	c1 e0 04             	shl    $0x4,%eax
  802f16:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802f1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1f:	89 02                	mov    %eax,(%edx)
  802f21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f24:	c1 e0 04             	shl    $0x4,%eax
  802f27:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802f2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f30:	89 02                	mov    %eax,(%edx)
  802f32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f3f:	c1 e0 04             	shl    $0x4,%eax
  802f42:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f47:	8b 00                	mov    (%eax),%eax
  802f49:	8d 50 01             	lea    0x1(%eax),%edx
  802f4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4f:	c1 e0 04             	shl    $0x4,%eax
  802f52:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f57:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  802f59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802f60:	40                   	inc    %eax
  802f61:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f64:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  802f68:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802f70:	29 c2                	sub    %eax,%edx
  802f72:	89 d0                	mov    %edx,%eax
  802f74:	c1 e8 0c             	shr    $0xc,%eax
  802f77:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  802f7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802f81:	0f b7 c8             	movzwl %ax,%ecx
  802f84:	b8 00 10 00 00       	mov    $0x1000,%eax
  802f89:	99                   	cltd   
  802f8a:	f7 7d e8             	idivl  -0x18(%ebp)
  802f8d:	39 c1                	cmp    %eax,%ecx
  802f8f:	0f 85 b8 01 00 00    	jne    80314d <free_block+0x384>
    	uint32 blocks_removed = 0;
  802f95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  802f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9f:	c1 e0 04             	shl    $0x4,%eax
  802fa2:	05 80 d0 81 00       	add    $0x81d080,%eax
  802fa7:	8b 00                	mov    (%eax),%eax
  802fa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  802fac:	e9 d5 00 00 00       	jmp    803086 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  802fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb4:	8b 00                	mov    (%eax),%eax
  802fb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  802fb9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fbc:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802fc1:	29 c2                	sub    %eax,%edx
  802fc3:	89 d0                	mov    %edx,%eax
  802fc5:	c1 e8 0c             	shr    $0xc,%eax
  802fc8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  802fcb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fce:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802fd1:	0f 85 a9 00 00 00    	jne    803080 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  802fd7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fdb:	75 17                	jne    802ff4 <free_block+0x22b>
  802fdd:	83 ec 04             	sub    $0x4,%esp
  802fe0:	68 85 41 80 00       	push   $0x804185
  802fe5:	68 04 01 00 00       	push   $0x104
  802fea:	68 eb 40 80 00       	push   $0x8040eb
  802fef:	e8 8d 02 00 00       	call   803281 <_panic>
  802ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff7:	8b 00                	mov    (%eax),%eax
  802ff9:	85 c0                	test   %eax,%eax
  802ffb:	74 10                	je     80300d <free_block+0x244>
  802ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803000:	8b 00                	mov    (%eax),%eax
  803002:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803005:	8b 52 04             	mov    0x4(%edx),%edx
  803008:	89 50 04             	mov    %edx,0x4(%eax)
  80300b:	eb 14                	jmp    803021 <free_block+0x258>
  80300d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803010:	8b 40 04             	mov    0x4(%eax),%eax
  803013:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803016:	c1 e2 04             	shl    $0x4,%edx
  803019:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80301f:	89 02                	mov    %eax,(%edx)
  803021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803024:	8b 40 04             	mov    0x4(%eax),%eax
  803027:	85 c0                	test   %eax,%eax
  803029:	74 0f                	je     80303a <free_block+0x271>
  80302b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302e:	8b 40 04             	mov    0x4(%eax),%eax
  803031:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803034:	8b 12                	mov    (%edx),%edx
  803036:	89 10                	mov    %edx,(%eax)
  803038:	eb 13                	jmp    80304d <free_block+0x284>
  80303a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303d:	8b 00                	mov    (%eax),%eax
  80303f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803042:	c1 e2 04             	shl    $0x4,%edx
  803045:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80304b:	89 02                	mov    %eax,(%edx)
  80304d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803050:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803059:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803060:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803063:	c1 e0 04             	shl    $0x4,%eax
  803066:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80306b:	8b 00                	mov    (%eax),%eax
  80306d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803070:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803073:	c1 e0 04             	shl    $0x4,%eax
  803076:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80307b:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  80307d:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803080:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803083:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803086:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80308a:	0f 85 21 ff ff ff    	jne    802fb1 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803090:	b8 00 10 00 00       	mov    $0x1000,%eax
  803095:	99                   	cltd   
  803096:	f7 7d e8             	idivl  -0x18(%ebp)
  803099:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80309c:	74 17                	je     8030b5 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  80309e:	83 ec 04             	sub    $0x4,%esp
  8030a1:	68 d4 42 80 00       	push   $0x8042d4
  8030a6:	68 0c 01 00 00       	push   $0x10c
  8030ab:	68 eb 40 80 00       	push   $0x8040eb
  8030b0:	e8 cc 01 00 00       	call   803281 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  8030b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b8:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  8030be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c1:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8030c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030cb:	75 17                	jne    8030e4 <free_block+0x31b>
  8030cd:	83 ec 04             	sub    $0x4,%esp
  8030d0:	68 a4 41 80 00       	push   $0x8041a4
  8030d5:	68 11 01 00 00       	push   $0x111
  8030da:	68 eb 40 80 00       	push   $0x8040eb
  8030df:	e8 9d 01 00 00       	call   803281 <_panic>
  8030e4:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8030ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ed:	89 50 04             	mov    %edx,0x4(%eax)
  8030f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f3:	8b 40 04             	mov    0x4(%eax),%eax
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	74 0c                	je     803106 <free_block+0x33d>
  8030fa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8030ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803102:	89 10                	mov    %edx,(%eax)
  803104:	eb 08                	jmp    80310e <free_block+0x345>
  803106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803109:	a3 48 50 80 00       	mov    %eax,0x805048
  80310e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803111:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803119:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311f:	a1 54 50 80 00       	mov    0x805054,%eax
  803124:	40                   	inc    %eax
  803125:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  80312a:	83 ec 0c             	sub    $0xc,%esp
  80312d:	ff 75 ec             	pushl  -0x14(%ebp)
  803130:	e8 2b f4 ff ff       	call   802560 <to_page_va>
  803135:	83 c4 10             	add    $0x10,%esp
  803138:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  80313b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80313e:	83 ec 0c             	sub    $0xc,%esp
  803141:	50                   	push   %eax
  803142:	e8 69 e8 ff ff       	call   8019b0 <return_page>
  803147:	83 c4 10             	add    $0x10,%esp
  80314a:	eb 01                	jmp    80314d <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80314c:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  80314d:	c9                   	leave  
  80314e:	c3                   	ret    

0080314f <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  80314f:	55                   	push   %ebp
  803150:	89 e5                	mov    %esp,%ebp
  803152:	83 ec 14             	sub    $0x14,%esp
  803155:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803158:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80315c:	77 07                	ja     803165 <nearest_pow2_ceil.1572+0x16>
      return 1;
  80315e:	b8 01 00 00 00       	mov    $0x1,%eax
  803163:	eb 20                	jmp    803185 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803165:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  80316c:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  80316f:	eb 08                	jmp    803179 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803171:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803174:	01 c0                	add    %eax,%eax
  803176:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803179:	d1 6d 08             	shrl   0x8(%ebp)
  80317c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803180:	75 ef                	jne    803171 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803182:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803185:	c9                   	leave  
  803186:	c3                   	ret    

00803187 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803187:	55                   	push   %ebp
  803188:	89 e5                	mov    %esp,%ebp
  80318a:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  80318d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803191:	75 13                	jne    8031a6 <realloc_block+0x1f>
    return alloc_block(new_size);
  803193:	83 ec 0c             	sub    $0xc,%esp
  803196:	ff 75 0c             	pushl  0xc(%ebp)
  803199:	e8 d1 f6 ff ff       	call   80286f <alloc_block>
  80319e:	83 c4 10             	add    $0x10,%esp
  8031a1:	e9 d9 00 00 00       	jmp    80327f <realloc_block+0xf8>
  }

  if (new_size == 0) {
  8031a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031aa:	75 18                	jne    8031c4 <realloc_block+0x3d>
    free_block(va);
  8031ac:	83 ec 0c             	sub    $0xc,%esp
  8031af:	ff 75 08             	pushl  0x8(%ebp)
  8031b2:	e8 12 fc ff ff       	call   802dc9 <free_block>
  8031b7:	83 c4 10             	add    $0x10,%esp
    return NULL;
  8031ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8031bf:	e9 bb 00 00 00       	jmp    80327f <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  8031c4:	83 ec 0c             	sub    $0xc,%esp
  8031c7:	ff 75 08             	pushl  0x8(%ebp)
  8031ca:	e8 38 f6 ff ff       	call   802807 <get_block_size>
  8031cf:	83 c4 10             	add    $0x10,%esp
  8031d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8031d5:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  8031dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031df:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8031e2:	73 06                	jae    8031ea <realloc_block+0x63>
    new_size = min_block_size;
  8031e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e7:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  8031ea:	83 ec 0c             	sub    $0xc,%esp
  8031ed:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8031f0:	ff 75 0c             	pushl  0xc(%ebp)
  8031f3:	89 c1                	mov    %eax,%ecx
  8031f5:	e8 55 ff ff ff       	call   80314f <nearest_pow2_ceil.1572>
  8031fa:	83 c4 10             	add    $0x10,%esp
  8031fd:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803200:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803203:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803206:	75 05                	jne    80320d <realloc_block+0x86>
    return va;
  803208:	8b 45 08             	mov    0x8(%ebp),%eax
  80320b:	eb 72                	jmp    80327f <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  80320d:	83 ec 0c             	sub    $0xc,%esp
  803210:	ff 75 0c             	pushl  0xc(%ebp)
  803213:	e8 57 f6 ff ff       	call   80286f <alloc_block>
  803218:	83 c4 10             	add    $0x10,%esp
  80321b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  80321e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803222:	75 07                	jne    80322b <realloc_block+0xa4>
    return NULL;
  803224:	b8 00 00 00 00       	mov    $0x0,%eax
  803229:	eb 54                	jmp    80327f <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  80322b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80322e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803231:	39 d0                	cmp    %edx,%eax
  803233:	76 02                	jbe    803237 <realloc_block+0xb0>
  803235:	89 d0                	mov    %edx,%eax
  803237:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  80323a:	8b 45 08             	mov    0x8(%ebp),%eax
  80323d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803240:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803243:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803246:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80324d:	eb 17                	jmp    803266 <realloc_block+0xdf>
    dst[i] = src[i];
  80324f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803255:	01 c2                	add    %eax,%edx
  803257:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80325a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325d:	01 c8                	add    %ecx,%eax
  80325f:	8a 00                	mov    (%eax),%al
  803261:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803263:	ff 45 f4             	incl   -0xc(%ebp)
  803266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803269:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80326c:	72 e1                	jb     80324f <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  80326e:	83 ec 0c             	sub    $0xc,%esp
  803271:	ff 75 08             	pushl  0x8(%ebp)
  803274:	e8 50 fb ff ff       	call   802dc9 <free_block>
  803279:	83 c4 10             	add    $0x10,%esp

  return new_va;
  80327c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80327f:	c9                   	leave  
  803280:	c3                   	ret    

00803281 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803281:	55                   	push   %ebp
  803282:	89 e5                	mov    %esp,%ebp
  803284:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803287:	8d 45 10             	lea    0x10(%ebp),%eax
  80328a:	83 c0 04             	add    $0x4,%eax
  80328d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803290:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  803295:	85 c0                	test   %eax,%eax
  803297:	74 16                	je     8032af <_panic+0x2e>
		cprintf("%s: ", argv0);
  803299:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  80329e:	83 ec 08             	sub    $0x8,%esp
  8032a1:	50                   	push   %eax
  8032a2:	68 08 43 80 00       	push   $0x804308
  8032a7:	e8 1c d1 ff ff       	call   8003c8 <cprintf>
  8032ac:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8032af:	a1 04 50 80 00       	mov    0x805004,%eax
  8032b4:	83 ec 0c             	sub    $0xc,%esp
  8032b7:	ff 75 0c             	pushl  0xc(%ebp)
  8032ba:	ff 75 08             	pushl  0x8(%ebp)
  8032bd:	50                   	push   %eax
  8032be:	68 10 43 80 00       	push   $0x804310
  8032c3:	6a 74                	push   $0x74
  8032c5:	e8 2b d1 ff ff       	call   8003f5 <cprintf_colored>
  8032ca:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8032cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8032d0:	83 ec 08             	sub    $0x8,%esp
  8032d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8032d6:	50                   	push   %eax
  8032d7:	e8 7d d0 ff ff       	call   800359 <vcprintf>
  8032dc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8032df:	83 ec 08             	sub    $0x8,%esp
  8032e2:	6a 00                	push   $0x0
  8032e4:	68 38 43 80 00       	push   $0x804338
  8032e9:	e8 6b d0 ff ff       	call   800359 <vcprintf>
  8032ee:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8032f1:	e8 e4 cf ff ff       	call   8002da <exit>

	// should not return here
	while (1) ;
  8032f6:	eb fe                	jmp    8032f6 <_panic+0x75>

008032f8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8032f8:	55                   	push   %ebp
  8032f9:	89 e5                	mov    %esp,%ebp
  8032fb:	53                   	push   %ebx
  8032fc:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8032ff:	a1 20 50 80 00       	mov    0x805020,%eax
  803304:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80330a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80330d:	39 c2                	cmp    %eax,%edx
  80330f:	74 14                	je     803325 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803311:	83 ec 04             	sub    $0x4,%esp
  803314:	68 3c 43 80 00       	push   $0x80433c
  803319:	6a 26                	push   $0x26
  80331b:	68 88 43 80 00       	push   $0x804388
  803320:	e8 5c ff ff ff       	call   803281 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803325:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80332c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803333:	e9 d9 00 00 00       	jmp    803411 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  803338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	01 d0                	add    %edx,%eax
  803347:	8b 00                	mov    (%eax),%eax
  803349:	85 c0                	test   %eax,%eax
  80334b:	75 08                	jne    803355 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80334d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803350:	e9 b9 00 00 00       	jmp    80340e <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  803355:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80335c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803363:	eb 79                	jmp    8033de <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803365:	a1 20 50 80 00       	mov    0x805020,%eax
  80336a:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803370:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803373:	89 d0                	mov    %edx,%eax
  803375:	01 c0                	add    %eax,%eax
  803377:	01 d0                	add    %edx,%eax
  803379:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803380:	01 d8                	add    %ebx,%eax
  803382:	01 d0                	add    %edx,%eax
  803384:	01 c8                	add    %ecx,%eax
  803386:	8a 40 04             	mov    0x4(%eax),%al
  803389:	84 c0                	test   %al,%al
  80338b:	75 4e                	jne    8033db <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80338d:	a1 20 50 80 00       	mov    0x805020,%eax
  803392:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803398:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80339b:	89 d0                	mov    %edx,%eax
  80339d:	01 c0                	add    %eax,%eax
  80339f:	01 d0                	add    %edx,%eax
  8033a1:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8033a8:	01 d8                	add    %ebx,%eax
  8033aa:	01 d0                	add    %edx,%eax
  8033ac:	01 c8                	add    %ecx,%eax
  8033ae:	8b 00                	mov    (%eax),%eax
  8033b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8033b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8033bb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8033bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8033c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ca:	01 c8                	add    %ecx,%eax
  8033cc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8033ce:	39 c2                	cmp    %eax,%edx
  8033d0:	75 09                	jne    8033db <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8033d2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8033d9:	eb 19                	jmp    8033f4 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033db:	ff 45 e8             	incl   -0x18(%ebp)
  8033de:	a1 20 50 80 00       	mov    0x805020,%eax
  8033e3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8033e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ec:	39 c2                	cmp    %eax,%edx
  8033ee:	0f 87 71 ff ff ff    	ja     803365 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8033f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033f8:	75 14                	jne    80340e <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8033fa:	83 ec 04             	sub    $0x4,%esp
  8033fd:	68 94 43 80 00       	push   $0x804394
  803402:	6a 3a                	push   $0x3a
  803404:	68 88 43 80 00       	push   $0x804388
  803409:	e8 73 fe ff ff       	call   803281 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80340e:	ff 45 f0             	incl   -0x10(%ebp)
  803411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803414:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803417:	0f 8c 1b ff ff ff    	jl     803338 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80341d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803424:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80342b:	eb 2e                	jmp    80345b <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80342d:	a1 20 50 80 00       	mov    0x805020,%eax
  803432:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803438:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80343b:	89 d0                	mov    %edx,%eax
  80343d:	01 c0                	add    %eax,%eax
  80343f:	01 d0                	add    %edx,%eax
  803441:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803448:	01 d8                	add    %ebx,%eax
  80344a:	01 d0                	add    %edx,%eax
  80344c:	01 c8                	add    %ecx,%eax
  80344e:	8a 40 04             	mov    0x4(%eax),%al
  803451:	3c 01                	cmp    $0x1,%al
  803453:	75 03                	jne    803458 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  803455:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803458:	ff 45 e0             	incl   -0x20(%ebp)
  80345b:	a1 20 50 80 00       	mov    0x805020,%eax
  803460:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803466:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803469:	39 c2                	cmp    %eax,%edx
  80346b:	77 c0                	ja     80342d <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80346d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803470:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803473:	74 14                	je     803489 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  803475:	83 ec 04             	sub    $0x4,%esp
  803478:	68 e8 43 80 00       	push   $0x8043e8
  80347d:	6a 44                	push   $0x44
  80347f:	68 88 43 80 00       	push   $0x804388
  803484:	e8 f8 fd ff ff       	call   803281 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803489:	90                   	nop
  80348a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
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
