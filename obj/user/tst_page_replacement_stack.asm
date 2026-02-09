
obj/user/tst_page_replacement_stack:     file format elf32-i386


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
  800031:	e8 fd 00 00 00       	call   800133 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 14 a0 00 00    	sub    $0xa014,%esp
	int8 arr[PAGE_SIZE*10];

	uint32 kilo = 1024;
  800042:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)

//	cprintf("envID = %d\n",envID);

	int freePages = sys_calculate_free_frames();
  800049:	e8 87 15 00 00       	call   8015d5 <sys_calculate_free_frames>
  80004e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800051:	e8 ca 15 00 00       	call   801620 <sys_pf_calculate_allocated_pages>
  800056:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800059:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800060:	eb 15                	jmp    800077 <_main+0x3f>
		arr[i] = -1 ;
  800062:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  800068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c6 00 ff             	movb   $0xff,(%eax)

	int freePages = sys_calculate_free_frames();
	int usedDiskPages = sys_pf_calculate_allocated_pages();

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800070:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  800077:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  80007e:	7e e2                	jle    800062 <_main+0x2a>
		arr[i] = -1 ;


	cprintf_colored(TEXT_cyan, "%~\nchecking REPLACEMENT fault handling of STACK pages... \n");
  800080:	83 ec 08             	sub    $0x8,%esp
  800083:	68 e0 1c 80 00       	push   $0x801ce0
  800088:	6a 03                	push   $0x3
  80008a:	e8 6f 05 00 00       	call   8005fe <cprintf_colored>
  80008f:	83 c4 10             	add    $0x10,%esp
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800092:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800099:	eb 2c                	jmp    8000c7 <_main+0x8f>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");
  80009b:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  8000a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a4:	01 d0                	add    %edx,%eax
  8000a6:	8a 00                	mov    (%eax),%al
  8000a8:	3c ff                	cmp    $0xff,%al
  8000aa:	74 14                	je     8000c0 <_main+0x88>
  8000ac:	83 ec 04             	sub    $0x4,%esp
  8000af:	68 1c 1d 80 00       	push   $0x801d1c
  8000b4:	6a 1a                	push   $0x1a
  8000b6:	68 4c 1d 80 00       	push   $0x801d4c
  8000bb:	e8 23 02 00 00       	call   8002e3 <_panic>
		arr[i] = -1 ;


	cprintf_colored(TEXT_cyan, "%~\nchecking REPLACEMENT fault handling of STACK pages... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000c0:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8000c7:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8000ce:	7e cb                	jle    80009b <_main+0x63>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  10) panic("Unexpected extra/less pages have been added to page file");
  8000d0:	e8 4b 15 00 00       	call   801620 <sys_pf_calculate_allocated_pages>
  8000d5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000d8:	83 f8 0a             	cmp    $0xa,%eax
  8000db:	74 14                	je     8000f1 <_main+0xb9>
  8000dd:	83 ec 04             	sub    $0x4,%esp
  8000e0:	68 70 1d 80 00       	push   $0x801d70
  8000e5:	6a 1c                	push   $0x1c
  8000e7:	68 4c 1d 80 00       	push   $0x801d4c
  8000ec:	e8 f2 01 00 00       	call   8002e3 <_panic>

		if( (freePages - (sys_calculate_free_frames() + sys_calculate_modified_frames())) != 0 ) panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  8000f1:	e8 df 14 00 00       	call   8015d5 <sys_calculate_free_frames>
  8000f6:	89 c3                	mov    %eax,%ebx
  8000f8:	e8 f1 14 00 00       	call   8015ee <sys_calculate_modified_frames>
  8000fd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	39 c2                	cmp    %eax,%edx
  800105:	74 14                	je     80011b <_main+0xe3>
  800107:	83 ec 04             	sub    $0x4,%esp
  80010a:	68 ac 1d 80 00       	push   $0x801dac
  80010f:	6a 1e                	push   $0x1e
  800111:	68 4c 1d 80 00       	push   $0x801d4c
  800116:	e8 c8 01 00 00       	call   8002e3 <_panic>
	}//consider tables of PF, disk pages

	cprintf_colored(TEXT_light_green, "%~\nCongratulations: stack pages created, modified and read is completed successfully\n\n");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 10 1e 80 00       	push   $0x801e10
  800123:	6a 0a                	push   $0xa
  800125:	e8 d4 04 00 00       	call   8005fe <cprintf_colored>
  80012a:	83 c4 10             	add    $0x10,%esp


	return;
  80012d:	90                   	nop
}
  80012e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800131:	c9                   	leave  
  800132:	c3                   	ret    

00800133 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800133:	55                   	push   %ebp
  800134:	89 e5                	mov    %esp,%ebp
  800136:	57                   	push   %edi
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80013c:	e8 5d 16 00 00       	call   80179e <sys_getenvindex>
  800141:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800144:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800147:	89 d0                	mov    %edx,%eax
  800149:	01 c0                	add    %eax,%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	c1 e0 02             	shl    $0x2,%eax
  800150:	01 d0                	add    %edx,%eax
  800152:	c1 e0 02             	shl    $0x2,%eax
  800155:	01 d0                	add    %edx,%eax
  800157:	c1 e0 03             	shl    $0x3,%eax
  80015a:	01 d0                	add    %edx,%eax
  80015c:	c1 e0 02             	shl    $0x2,%eax
  80015f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800164:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800169:	a1 20 30 80 00       	mov    0x803020,%eax
  80016e:	8a 40 20             	mov    0x20(%eax),%al
  800171:	84 c0                	test   %al,%al
  800173:	74 0d                	je     800182 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800175:	a1 20 30 80 00       	mov    0x803020,%eax
  80017a:	83 c0 20             	add    $0x20,%eax
  80017d:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800182:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800186:	7e 0a                	jle    800192 <libmain+0x5f>
		binaryname = argv[0];
  800188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018b:	8b 00                	mov    (%eax),%eax
  80018d:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800192:	83 ec 08             	sub    $0x8,%esp
  800195:	ff 75 0c             	pushl  0xc(%ebp)
  800198:	ff 75 08             	pushl  0x8(%ebp)
  80019b:	e8 98 fe ff ff       	call   800038 <_main>
  8001a0:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001a3:	a1 00 30 80 00       	mov    0x803000,%eax
  8001a8:	85 c0                	test   %eax,%eax
  8001aa:	0f 84 01 01 00 00    	je     8002b1 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001b0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001b6:	bb 60 1f 80 00       	mov    $0x801f60,%ebx
  8001bb:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c0:	89 c7                	mov    %eax,%edi
  8001c2:	89 de                	mov    %ebx,%esi
  8001c4:	89 d1                	mov    %edx,%ecx
  8001c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001c8:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001cb:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001d0:	b0 00                	mov    $0x0,%al
  8001d2:	89 d7                	mov    %edx,%edi
  8001d4:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001e0:	83 ec 08             	sub    $0x8,%esp
  8001e3:	50                   	push   %eax
  8001e4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001ea:	50                   	push   %eax
  8001eb:	e8 e4 17 00 00       	call   8019d4 <sys_utilities>
  8001f0:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001f3:	e8 2d 13 00 00       	call   801525 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001f8:	83 ec 0c             	sub    $0xc,%esp
  8001fb:	68 80 1e 80 00       	push   $0x801e80
  800200:	e8 cc 03 00 00       	call   8005d1 <cprintf>
  800205:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800208:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80020b:	85 c0                	test   %eax,%eax
  80020d:	74 18                	je     800227 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80020f:	e8 de 17 00 00       	call   8019f2 <sys_get_optimal_num_faults>
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	50                   	push   %eax
  800218:	68 a8 1e 80 00       	push   $0x801ea8
  80021d:	e8 af 03 00 00       	call   8005d1 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
  800225:	eb 59                	jmp    800280 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800232:	a1 20 30 80 00       	mov    0x803020,%eax
  800237:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80023d:	83 ec 04             	sub    $0x4,%esp
  800240:	52                   	push   %edx
  800241:	50                   	push   %eax
  800242:	68 cc 1e 80 00       	push   $0x801ecc
  800247:	e8 85 03 00 00       	call   8005d1 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80024f:	a1 20 30 80 00       	mov    0x803020,%eax
  800254:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  80025a:	a1 20 30 80 00       	mov    0x803020,%eax
  80025f:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800265:	a1 20 30 80 00       	mov    0x803020,%eax
  80026a:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800270:	51                   	push   %ecx
  800271:	52                   	push   %edx
  800272:	50                   	push   %eax
  800273:	68 f4 1e 80 00       	push   $0x801ef4
  800278:	e8 54 03 00 00       	call   8005d1 <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800280:	a1 20 30 80 00       	mov    0x803020,%eax
  800285:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80028b:	83 ec 08             	sub    $0x8,%esp
  80028e:	50                   	push   %eax
  80028f:	68 4c 1f 80 00       	push   $0x801f4c
  800294:	e8 38 03 00 00       	call   8005d1 <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	68 80 1e 80 00       	push   $0x801e80
  8002a4:	e8 28 03 00 00       	call   8005d1 <cprintf>
  8002a9:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002ac:	e8 8e 12 00 00       	call   80153f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002b1:	e8 1f 00 00 00       	call   8002d5 <exit>
}
  8002b6:	90                   	nop
  8002b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ba:	5b                   	pop    %ebx
  8002bb:	5e                   	pop    %esi
  8002bc:	5f                   	pop    %edi
  8002bd:	5d                   	pop    %ebp
  8002be:	c3                   	ret    

008002bf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002c5:	83 ec 0c             	sub    $0xc,%esp
  8002c8:	6a 00                	push   $0x0
  8002ca:	e8 9b 14 00 00       	call   80176a <sys_destroy_env>
  8002cf:	83 c4 10             	add    $0x10,%esp
}
  8002d2:	90                   	nop
  8002d3:	c9                   	leave  
  8002d4:	c3                   	ret    

008002d5 <exit>:

void
exit(void)
{
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002db:	e8 f0 14 00 00       	call   8017d0 <sys_exit_env>
}
  8002e0:	90                   	nop
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    

008002e3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002e9:	8d 45 10             	lea    0x10(%ebp),%eax
  8002ec:	83 c0 04             	add    $0x4,%eax
  8002ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f2:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002f7:	85 c0                	test   %eax,%eax
  8002f9:	74 16                	je     800311 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002fb:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	50                   	push   %eax
  800304:	68 c4 1f 80 00       	push   $0x801fc4
  800309:	e8 c3 02 00 00       	call   8005d1 <cprintf>
  80030e:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800311:	a1 04 30 80 00       	mov    0x803004,%eax
  800316:	83 ec 0c             	sub    $0xc,%esp
  800319:	ff 75 0c             	pushl  0xc(%ebp)
  80031c:	ff 75 08             	pushl  0x8(%ebp)
  80031f:	50                   	push   %eax
  800320:	68 cc 1f 80 00       	push   $0x801fcc
  800325:	6a 74                	push   $0x74
  800327:	e8 d2 02 00 00       	call   8005fe <cprintf_colored>
  80032c:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80032f:	8b 45 10             	mov    0x10(%ebp),%eax
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	ff 75 f4             	pushl  -0xc(%ebp)
  800338:	50                   	push   %eax
  800339:	e8 24 02 00 00       	call   800562 <vcprintf>
  80033e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	6a 00                	push   $0x0
  800346:	68 f4 1f 80 00       	push   $0x801ff4
  80034b:	e8 12 02 00 00       	call   800562 <vcprintf>
  800350:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800353:	e8 7d ff ff ff       	call   8002d5 <exit>

	// should not return here
	while (1) ;
  800358:	eb fe                	jmp    800358 <_panic+0x75>

0080035a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	53                   	push   %ebx
  80035e:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800361:	a1 20 30 80 00       	mov    0x803020,%eax
  800366:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80036c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036f:	39 c2                	cmp    %eax,%edx
  800371:	74 14                	je     800387 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800373:	83 ec 04             	sub    $0x4,%esp
  800376:	68 f8 1f 80 00       	push   $0x801ff8
  80037b:	6a 26                	push   $0x26
  80037d:	68 44 20 80 00       	push   $0x802044
  800382:	e8 5c ff ff ff       	call   8002e3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800395:	e9 d9 00 00 00       	jmp    800473 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  80039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	01 d0                	add    %edx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
  8003ab:	85 c0                	test   %eax,%eax
  8003ad:	75 08                	jne    8003b7 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8003af:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003b2:	e9 b9 00 00 00       	jmp    800470 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8003b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c5:	eb 79                	jmp    800440 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003cc:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d5:	89 d0                	mov    %edx,%eax
  8003d7:	01 c0                	add    %eax,%eax
  8003d9:	01 d0                	add    %edx,%eax
  8003db:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003e2:	01 d8                	add    %ebx,%eax
  8003e4:	01 d0                	add    %edx,%eax
  8003e6:	01 c8                	add    %ecx,%eax
  8003e8:	8a 40 04             	mov    0x4(%eax),%al
  8003eb:	84 c0                	test   %al,%al
  8003ed:	75 4e                	jne    80043d <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f4:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003fd:	89 d0                	mov    %edx,%eax
  8003ff:	01 c0                	add    %eax,%eax
  800401:	01 d0                	add    %edx,%eax
  800403:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80040a:	01 d8                	add    %ebx,%eax
  80040c:	01 d0                	add    %edx,%eax
  80040e:	01 c8                	add    %ecx,%eax
  800410:	8b 00                	mov    (%eax),%eax
  800412:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800415:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800418:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800422:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	01 c8                	add    %ecx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800430:	39 c2                	cmp    %eax,%edx
  800432:	75 09                	jne    80043d <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800434:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80043b:	eb 19                	jmp    800456 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043d:	ff 45 e8             	incl   -0x18(%ebp)
  800440:	a1 20 30 80 00       	mov    0x803020,%eax
  800445:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80044b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044e:	39 c2                	cmp    %eax,%edx
  800450:	0f 87 71 ff ff ff    	ja     8003c7 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800456:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80045a:	75 14                	jne    800470 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80045c:	83 ec 04             	sub    $0x4,%esp
  80045f:	68 50 20 80 00       	push   $0x802050
  800464:	6a 3a                	push   $0x3a
  800466:	68 44 20 80 00       	push   $0x802044
  80046b:	e8 73 fe ff ff       	call   8002e3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800470:	ff 45 f0             	incl   -0x10(%ebp)
  800473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800476:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800479:	0f 8c 1b ff ff ff    	jl     80039a <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80047f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800486:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80048d:	eb 2e                	jmp    8004bd <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80048f:	a1 20 30 80 00       	mov    0x803020,%eax
  800494:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80049a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80049d:	89 d0                	mov    %edx,%eax
  80049f:	01 c0                	add    %eax,%eax
  8004a1:	01 d0                	add    %edx,%eax
  8004a3:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004aa:	01 d8                	add    %ebx,%eax
  8004ac:	01 d0                	add    %edx,%eax
  8004ae:	01 c8                	add    %ecx,%eax
  8004b0:	8a 40 04             	mov    0x4(%eax),%al
  8004b3:	3c 01                	cmp    $0x1,%al
  8004b5:	75 03                	jne    8004ba <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8004b7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ba:	ff 45 e0             	incl   -0x20(%ebp)
  8004bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004cb:	39 c2                	cmp    %eax,%edx
  8004cd:	77 c0                	ja     80048f <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004d2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004d5:	74 14                	je     8004eb <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 a4 20 80 00       	push   $0x8020a4
  8004df:	6a 44                	push   $0x44
  8004e1:	68 44 20 80 00       	push   $0x802044
  8004e6:	e8 f8 fd ff ff       	call   8002e3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004eb:	90                   	nop
  8004ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004ef:	c9                   	leave  
  8004f0:	c3                   	ret    

008004f1 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	53                   	push   %ebx
  8004f5:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fb:	8b 00                	mov    (%eax),%eax
  8004fd:	8d 48 01             	lea    0x1(%eax),%ecx
  800500:	8b 55 0c             	mov    0xc(%ebp),%edx
  800503:	89 0a                	mov    %ecx,(%edx)
  800505:	8b 55 08             	mov    0x8(%ebp),%edx
  800508:	88 d1                	mov    %dl,%cl
  80050a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80050d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800511:	8b 45 0c             	mov    0xc(%ebp),%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	3d ff 00 00 00       	cmp    $0xff,%eax
  80051b:	75 30                	jne    80054d <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80051d:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800523:	a0 44 30 80 00       	mov    0x803044,%al
  800528:	0f b6 c0             	movzbl %al,%eax
  80052b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80052e:	8b 09                	mov    (%ecx),%ecx
  800530:	89 cb                	mov    %ecx,%ebx
  800532:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800535:	83 c1 08             	add    $0x8,%ecx
  800538:	52                   	push   %edx
  800539:	50                   	push   %eax
  80053a:	53                   	push   %ebx
  80053b:	51                   	push   %ecx
  80053c:	e8 a0 0f 00 00       	call   8014e1 <sys_cputs>
  800541:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800544:	8b 45 0c             	mov    0xc(%ebp),%eax
  800547:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80054d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800550:	8b 40 04             	mov    0x4(%eax),%eax
  800553:	8d 50 01             	lea    0x1(%eax),%edx
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	89 50 04             	mov    %edx,0x4(%eax)
}
  80055c:	90                   	nop
  80055d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800560:	c9                   	leave  
  800561:	c3                   	ret    

00800562 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800562:	55                   	push   %ebp
  800563:	89 e5                	mov    %esp,%ebp
  800565:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80056b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800572:	00 00 00 
	b.cnt = 0;
  800575:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80057c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80057f:	ff 75 0c             	pushl  0xc(%ebp)
  800582:	ff 75 08             	pushl  0x8(%ebp)
  800585:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80058b:	50                   	push   %eax
  80058c:	68 f1 04 80 00       	push   $0x8004f1
  800591:	e8 5a 02 00 00       	call   8007f0 <vprintfmt>
  800596:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800599:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80059f:	a0 44 30 80 00       	mov    0x803044,%al
  8005a4:	0f b6 c0             	movzbl %al,%eax
  8005a7:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005ad:	52                   	push   %edx
  8005ae:	50                   	push   %eax
  8005af:	51                   	push   %ecx
  8005b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b6:	83 c0 08             	add    $0x8,%eax
  8005b9:	50                   	push   %eax
  8005ba:	e8 22 0f 00 00       	call   8014e1 <sys_cputs>
  8005bf:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005c2:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005cf:	c9                   	leave  
  8005d0:	c3                   	ret    

008005d1 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005d1:	55                   	push   %ebp
  8005d2:	89 e5                	mov    %esp,%ebp
  8005d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d7:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	83 ec 08             	sub    $0x8,%esp
  8005ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ed:	50                   	push   %eax
  8005ee:	e8 6f ff ff ff       	call   800562 <vcprintf>
  8005f3:	83 c4 10             	add    $0x10,%esp
  8005f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005fc:	c9                   	leave  
  8005fd:	c3                   	ret    

008005fe <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800604:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80060b:	8b 45 08             	mov    0x8(%ebp),%eax
  80060e:	c1 e0 08             	shl    $0x8,%eax
  800611:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800616:	8d 45 0c             	lea    0xc(%ebp),%eax
  800619:	83 c0 04             	add    $0x4,%eax
  80061c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80061f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	ff 75 f4             	pushl  -0xc(%ebp)
  800628:	50                   	push   %eax
  800629:	e8 34 ff ff ff       	call   800562 <vcprintf>
  80062e:	83 c4 10             	add    $0x10,%esp
  800631:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800634:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80063b:	07 00 00 

	return cnt;
  80063e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800641:	c9                   	leave  
  800642:	c3                   	ret    

00800643 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800643:	55                   	push   %ebp
  800644:	89 e5                	mov    %esp,%ebp
  800646:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800649:	e8 d7 0e 00 00       	call   801525 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80064e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800651:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	ff 75 f4             	pushl  -0xc(%ebp)
  80065d:	50                   	push   %eax
  80065e:	e8 ff fe ff ff       	call   800562 <vcprintf>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800669:	e8 d1 0e 00 00       	call   80153f <sys_unlock_cons>
	return cnt;
  80066e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800671:	c9                   	leave  
  800672:	c3                   	ret    

00800673 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800673:	55                   	push   %ebp
  800674:	89 e5                	mov    %esp,%ebp
  800676:	53                   	push   %ebx
  800677:	83 ec 14             	sub    $0x14,%esp
  80067a:	8b 45 10             	mov    0x10(%ebp),%eax
  80067d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800686:	8b 45 18             	mov    0x18(%ebp),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800691:	77 55                	ja     8006e8 <printnum+0x75>
  800693:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800696:	72 05                	jb     80069d <printnum+0x2a>
  800698:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80069b:	77 4b                	ja     8006e8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80069d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006a3:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ab:	52                   	push   %edx
  8006ac:	50                   	push   %eax
  8006ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8006b3:	e8 ac 13 00 00       	call   801a64 <__udivdi3>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	83 ec 04             	sub    $0x4,%esp
  8006be:	ff 75 20             	pushl  0x20(%ebp)
  8006c1:	53                   	push   %ebx
  8006c2:	ff 75 18             	pushl  0x18(%ebp)
  8006c5:	52                   	push   %edx
  8006c6:	50                   	push   %eax
  8006c7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ca:	ff 75 08             	pushl  0x8(%ebp)
  8006cd:	e8 a1 ff ff ff       	call   800673 <printnum>
  8006d2:	83 c4 20             	add    $0x20,%esp
  8006d5:	eb 1a                	jmp    8006f1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	ff 75 0c             	pushl  0xc(%ebp)
  8006dd:	ff 75 20             	pushl  0x20(%ebp)
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	ff d0                	call   *%eax
  8006e5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006e8:	ff 4d 1c             	decl   0x1c(%ebp)
  8006eb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006ef:	7f e6                	jg     8006d7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006f1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ff:	53                   	push   %ebx
  800700:	51                   	push   %ecx
  800701:	52                   	push   %edx
  800702:	50                   	push   %eax
  800703:	e8 6c 14 00 00       	call   801b74 <__umoddi3>
  800708:	83 c4 10             	add    $0x10,%esp
  80070b:	05 14 23 80 00       	add    $0x802314,%eax
  800710:	8a 00                	mov    (%eax),%al
  800712:	0f be c0             	movsbl %al,%eax
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	ff 75 0c             	pushl  0xc(%ebp)
  80071b:	50                   	push   %eax
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	ff d0                	call   *%eax
  800721:	83 c4 10             	add    $0x10,%esp
}
  800724:	90                   	nop
  800725:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800728:	c9                   	leave  
  800729:	c3                   	ret    

0080072a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80072d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800731:	7e 1c                	jle    80074f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	8d 50 08             	lea    0x8(%eax),%edx
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	89 10                	mov    %edx,(%eax)
  800740:	8b 45 08             	mov    0x8(%ebp),%eax
  800743:	8b 00                	mov    (%eax),%eax
  800745:	83 e8 08             	sub    $0x8,%eax
  800748:	8b 50 04             	mov    0x4(%eax),%edx
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	eb 40                	jmp    80078f <getuint+0x65>
	else if (lflag)
  80074f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800753:	74 1e                	je     800773 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	8d 50 04             	lea    0x4(%eax),%edx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	89 10                	mov    %edx,(%eax)
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	8b 00                	mov    (%eax),%eax
  800767:	83 e8 04             	sub    $0x4,%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	ba 00 00 00 00       	mov    $0x0,%edx
  800771:	eb 1c                	jmp    80078f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	8d 50 04             	lea    0x4(%eax),%edx
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	89 10                	mov    %edx,(%eax)
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	83 e8 04             	sub    $0x4,%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80078f:	5d                   	pop    %ebp
  800790:	c3                   	ret    

00800791 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800794:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800798:	7e 1c                	jle    8007b6 <getint+0x25>
		return va_arg(*ap, long long);
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	8d 50 08             	lea    0x8(%eax),%edx
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	89 10                	mov    %edx,(%eax)
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	83 e8 08             	sub    $0x8,%eax
  8007af:	8b 50 04             	mov    0x4(%eax),%edx
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	eb 38                	jmp    8007ee <getint+0x5d>
	else if (lflag)
  8007b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ba:	74 1a                	je     8007d6 <getint+0x45>
		return va_arg(*ap, long);
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	8d 50 04             	lea    0x4(%eax),%edx
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	89 10                	mov    %edx,(%eax)
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	99                   	cltd   
  8007d4:	eb 18                	jmp    8007ee <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	8d 50 04             	lea    0x4(%eax),%edx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	89 10                	mov    %edx,(%eax)
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	8b 00                	mov    (%eax),%eax
  8007e8:	83 e8 04             	sub    $0x4,%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	99                   	cltd   
}
  8007ee:	5d                   	pop    %ebp
  8007ef:	c3                   	ret    

008007f0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	56                   	push   %esi
  8007f4:	53                   	push   %ebx
  8007f5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f8:	eb 17                	jmp    800811 <vprintfmt+0x21>
			if (ch == '\0')
  8007fa:	85 db                	test   %ebx,%ebx
  8007fc:	0f 84 c1 03 00 00    	je     800bc3 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	ff 75 0c             	pushl  0xc(%ebp)
  800808:	53                   	push   %ebx
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	ff d0                	call   *%eax
  80080e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800811:	8b 45 10             	mov    0x10(%ebp),%eax
  800814:	8d 50 01             	lea    0x1(%eax),%edx
  800817:	89 55 10             	mov    %edx,0x10(%ebp)
  80081a:	8a 00                	mov    (%eax),%al
  80081c:	0f b6 d8             	movzbl %al,%ebx
  80081f:	83 fb 25             	cmp    $0x25,%ebx
  800822:	75 d6                	jne    8007fa <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800824:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800828:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80082f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800836:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80083d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800844:	8b 45 10             	mov    0x10(%ebp),%eax
  800847:	8d 50 01             	lea    0x1(%eax),%edx
  80084a:	89 55 10             	mov    %edx,0x10(%ebp)
  80084d:	8a 00                	mov    (%eax),%al
  80084f:	0f b6 d8             	movzbl %al,%ebx
  800852:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800855:	83 f8 5b             	cmp    $0x5b,%eax
  800858:	0f 87 3d 03 00 00    	ja     800b9b <vprintfmt+0x3ab>
  80085e:	8b 04 85 38 23 80 00 	mov    0x802338(,%eax,4),%eax
  800865:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800867:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80086b:	eb d7                	jmp    800844 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80086d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800871:	eb d1                	jmp    800844 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800873:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80087a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80087d:	89 d0                	mov    %edx,%eax
  80087f:	c1 e0 02             	shl    $0x2,%eax
  800882:	01 d0                	add    %edx,%eax
  800884:	01 c0                	add    %eax,%eax
  800886:	01 d8                	add    %ebx,%eax
  800888:	83 e8 30             	sub    $0x30,%eax
  80088b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80088e:	8b 45 10             	mov    0x10(%ebp),%eax
  800891:	8a 00                	mov    (%eax),%al
  800893:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800896:	83 fb 2f             	cmp    $0x2f,%ebx
  800899:	7e 3e                	jle    8008d9 <vprintfmt+0xe9>
  80089b:	83 fb 39             	cmp    $0x39,%ebx
  80089e:	7f 39                	jg     8008d9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008a3:	eb d5                	jmp    80087a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 c0 04             	add    $0x4,%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b1:	83 e8 04             	sub    $0x4,%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008b9:	eb 1f                	jmp    8008da <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008bf:	79 83                	jns    800844 <vprintfmt+0x54>
				width = 0;
  8008c1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008c8:	e9 77 ff ff ff       	jmp    800844 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008cd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008d4:	e9 6b ff ff ff       	jmp    800844 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008d9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008de:	0f 89 60 ff ff ff    	jns    800844 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ea:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008f1:	e9 4e ff ff ff       	jmp    800844 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008f6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008f9:	e9 46 ff ff ff       	jmp    800844 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	83 c0 04             	add    $0x4,%eax
  800904:	89 45 14             	mov    %eax,0x14(%ebp)
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	83 e8 04             	sub    $0x4,%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	50                   	push   %eax
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
			break;
  80091e:	e9 9b 02 00 00       	jmp    800bbe <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	83 c0 04             	add    $0x4,%eax
  800929:	89 45 14             	mov    %eax,0x14(%ebp)
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	83 e8 04             	sub    $0x4,%eax
  800932:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800934:	85 db                	test   %ebx,%ebx
  800936:	79 02                	jns    80093a <vprintfmt+0x14a>
				err = -err;
  800938:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80093a:	83 fb 64             	cmp    $0x64,%ebx
  80093d:	7f 0b                	jg     80094a <vprintfmt+0x15a>
  80093f:	8b 34 9d 80 21 80 00 	mov    0x802180(,%ebx,4),%esi
  800946:	85 f6                	test   %esi,%esi
  800948:	75 19                	jne    800963 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80094a:	53                   	push   %ebx
  80094b:	68 25 23 80 00       	push   $0x802325
  800950:	ff 75 0c             	pushl  0xc(%ebp)
  800953:	ff 75 08             	pushl  0x8(%ebp)
  800956:	e8 70 02 00 00       	call   800bcb <printfmt>
  80095b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80095e:	e9 5b 02 00 00       	jmp    800bbe <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800963:	56                   	push   %esi
  800964:	68 2e 23 80 00       	push   $0x80232e
  800969:	ff 75 0c             	pushl  0xc(%ebp)
  80096c:	ff 75 08             	pushl  0x8(%ebp)
  80096f:	e8 57 02 00 00       	call   800bcb <printfmt>
  800974:	83 c4 10             	add    $0x10,%esp
			break;
  800977:	e9 42 02 00 00       	jmp    800bbe <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80097c:	8b 45 14             	mov    0x14(%ebp),%eax
  80097f:	83 c0 04             	add    $0x4,%eax
  800982:	89 45 14             	mov    %eax,0x14(%ebp)
  800985:	8b 45 14             	mov    0x14(%ebp),%eax
  800988:	83 e8 04             	sub    $0x4,%eax
  80098b:	8b 30                	mov    (%eax),%esi
  80098d:	85 f6                	test   %esi,%esi
  80098f:	75 05                	jne    800996 <vprintfmt+0x1a6>
				p = "(null)";
  800991:	be 31 23 80 00       	mov    $0x802331,%esi
			if (width > 0 && padc != '-')
  800996:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099a:	7e 6d                	jle    800a09 <vprintfmt+0x219>
  80099c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009a0:	74 67                	je     800a09 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009a5:	83 ec 08             	sub    $0x8,%esp
  8009a8:	50                   	push   %eax
  8009a9:	56                   	push   %esi
  8009aa:	e8 1e 03 00 00       	call   800ccd <strnlen>
  8009af:	83 c4 10             	add    $0x10,%esp
  8009b2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009b5:	eb 16                	jmp    8009cd <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009b7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	50                   	push   %eax
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ca:	ff 4d e4             	decl   -0x1c(%ebp)
  8009cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d1:	7f e4                	jg     8009b7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d3:	eb 34                	jmp    800a09 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009d5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009d9:	74 1c                	je     8009f7 <vprintfmt+0x207>
  8009db:	83 fb 1f             	cmp    $0x1f,%ebx
  8009de:	7e 05                	jle    8009e5 <vprintfmt+0x1f5>
  8009e0:	83 fb 7e             	cmp    $0x7e,%ebx
  8009e3:	7e 12                	jle    8009f7 <vprintfmt+0x207>
					putch('?', putdat);
  8009e5:	83 ec 08             	sub    $0x8,%esp
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	6a 3f                	push   $0x3f
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	ff d0                	call   *%eax
  8009f2:	83 c4 10             	add    $0x10,%esp
  8009f5:	eb 0f                	jmp    800a06 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009f7:	83 ec 08             	sub    $0x8,%esp
  8009fa:	ff 75 0c             	pushl  0xc(%ebp)
  8009fd:	53                   	push   %ebx
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	ff d0                	call   *%eax
  800a03:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a06:	ff 4d e4             	decl   -0x1c(%ebp)
  800a09:	89 f0                	mov    %esi,%eax
  800a0b:	8d 70 01             	lea    0x1(%eax),%esi
  800a0e:	8a 00                	mov    (%eax),%al
  800a10:	0f be d8             	movsbl %al,%ebx
  800a13:	85 db                	test   %ebx,%ebx
  800a15:	74 24                	je     800a3b <vprintfmt+0x24b>
  800a17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a1b:	78 b8                	js     8009d5 <vprintfmt+0x1e5>
  800a1d:	ff 4d e0             	decl   -0x20(%ebp)
  800a20:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a24:	79 af                	jns    8009d5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a26:	eb 13                	jmp    800a3b <vprintfmt+0x24b>
				putch(' ', putdat);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	6a 20                	push   $0x20
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	ff d0                	call   *%eax
  800a35:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a38:	ff 4d e4             	decl   -0x1c(%ebp)
  800a3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3f:	7f e7                	jg     800a28 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a41:	e9 78 01 00 00       	jmp    800bbe <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4f:	50                   	push   %eax
  800a50:	e8 3c fd ff ff       	call   800791 <getint>
  800a55:	83 c4 10             	add    $0x10,%esp
  800a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a64:	85 d2                	test   %edx,%edx
  800a66:	79 23                	jns    800a8b <vprintfmt+0x29b>
				putch('-', putdat);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	6a 2d                	push   $0x2d
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	ff d0                	call   *%eax
  800a75:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7e:	f7 d8                	neg    %eax
  800a80:	83 d2 00             	adc    $0x0,%edx
  800a83:	f7 da                	neg    %edx
  800a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a8b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a92:	e9 bc 00 00 00       	jmp    800b53 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a9d:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa0:	50                   	push   %eax
  800aa1:	e8 84 fc ff ff       	call   80072a <getuint>
  800aa6:	83 c4 10             	add    $0x10,%esp
  800aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aaf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ab6:	e9 98 00 00 00       	jmp    800b53 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	6a 58                	push   $0x58
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	ff d0                	call   *%eax
  800ac8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	ff 75 0c             	pushl  0xc(%ebp)
  800ad1:	6a 58                	push   $0x58
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	ff d0                	call   *%eax
  800ad8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	6a 58                	push   $0x58
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	ff d0                	call   *%eax
  800ae8:	83 c4 10             	add    $0x10,%esp
			break;
  800aeb:	e9 ce 00 00 00       	jmp    800bbe <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	6a 30                	push   $0x30
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	ff d0                	call   *%eax
  800afd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	6a 78                	push   $0x78
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	ff d0                	call   *%eax
  800b0d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b10:	8b 45 14             	mov    0x14(%ebp),%eax
  800b13:	83 c0 04             	add    $0x4,%eax
  800b16:	89 45 14             	mov    %eax,0x14(%ebp)
  800b19:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1c:	83 e8 04             	sub    $0x4,%eax
  800b1f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b2b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b32:	eb 1f                	jmp    800b53 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	ff 75 e8             	pushl  -0x18(%ebp)
  800b3a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3d:	50                   	push   %eax
  800b3e:	e8 e7 fb ff ff       	call   80072a <getuint>
  800b43:	83 c4 10             	add    $0x10,%esp
  800b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b49:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b4c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b53:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5a:	83 ec 04             	sub    $0x4,%esp
  800b5d:	52                   	push   %edx
  800b5e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b61:	50                   	push   %eax
  800b62:	ff 75 f4             	pushl  -0xc(%ebp)
  800b65:	ff 75 f0             	pushl  -0x10(%ebp)
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	ff 75 08             	pushl  0x8(%ebp)
  800b6e:	e8 00 fb ff ff       	call   800673 <printnum>
  800b73:	83 c4 20             	add    $0x20,%esp
			break;
  800b76:	eb 46                	jmp    800bbe <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b78:	83 ec 08             	sub    $0x8,%esp
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	53                   	push   %ebx
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	ff d0                	call   *%eax
  800b84:	83 c4 10             	add    $0x10,%esp
			break;
  800b87:	eb 35                	jmp    800bbe <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b89:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b90:	eb 2c                	jmp    800bbe <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b92:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b99:	eb 23                	jmp    800bbe <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ba1:	6a 25                	push   $0x25
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	ff d0                	call   *%eax
  800ba8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bab:	ff 4d 10             	decl   0x10(%ebp)
  800bae:	eb 03                	jmp    800bb3 <vprintfmt+0x3c3>
  800bb0:	ff 4d 10             	decl   0x10(%ebp)
  800bb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb6:	48                   	dec    %eax
  800bb7:	8a 00                	mov    (%eax),%al
  800bb9:	3c 25                	cmp    $0x25,%al
  800bbb:	75 f3                	jne    800bb0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bbd:	90                   	nop
		}
	}
  800bbe:	e9 35 fc ff ff       	jmp    8007f8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bc3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bd1:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd4:	83 c0 04             	add    $0x4,%eax
  800bd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bda:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdd:	ff 75 f4             	pushl  -0xc(%ebp)
  800be0:	50                   	push   %eax
  800be1:	ff 75 0c             	pushl  0xc(%ebp)
  800be4:	ff 75 08             	pushl  0x8(%ebp)
  800be7:	e8 04 fc ff ff       	call   8007f0 <vprintfmt>
  800bec:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bef:	90                   	nop
  800bf0:	c9                   	leave  
  800bf1:	c3                   	ret    

00800bf2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	8b 40 08             	mov    0x8(%eax),%eax
  800bfb:	8d 50 01             	lea    0x1(%eax),%edx
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c07:	8b 10                	mov    (%eax),%edx
  800c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0c:	8b 40 04             	mov    0x4(%eax),%eax
  800c0f:	39 c2                	cmp    %eax,%edx
  800c11:	73 12                	jae    800c25 <sprintputch+0x33>
		*b->buf++ = ch;
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8b 00                	mov    (%eax),%eax
  800c18:	8d 48 01             	lea    0x1(%eax),%ecx
  800c1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1e:	89 0a                	mov    %ecx,(%edx)
  800c20:	8b 55 08             	mov    0x8(%ebp),%edx
  800c23:	88 10                	mov    %dl,(%eax)
}
  800c25:	90                   	nop
  800c26:	5d                   	pop    %ebp
  800c27:	c3                   	ret    

00800c28 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	01 d0                	add    %edx,%eax
  800c3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c4d:	74 06                	je     800c55 <vsnprintf+0x2d>
  800c4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c53:	7f 07                	jg     800c5c <vsnprintf+0x34>
		return -E_INVAL;
  800c55:	b8 03 00 00 00       	mov    $0x3,%eax
  800c5a:	eb 20                	jmp    800c7c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c5c:	ff 75 14             	pushl  0x14(%ebp)
  800c5f:	ff 75 10             	pushl  0x10(%ebp)
  800c62:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c65:	50                   	push   %eax
  800c66:	68 f2 0b 80 00       	push   $0x800bf2
  800c6b:	e8 80 fb ff ff       	call   8007f0 <vprintfmt>
  800c70:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c76:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c7c:	c9                   	leave  
  800c7d:	c3                   	ret    

00800c7e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c84:	8d 45 10             	lea    0x10(%ebp),%eax
  800c87:	83 c0 04             	add    $0x4,%eax
  800c8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c90:	ff 75 f4             	pushl  -0xc(%ebp)
  800c93:	50                   	push   %eax
  800c94:	ff 75 0c             	pushl  0xc(%ebp)
  800c97:	ff 75 08             	pushl  0x8(%ebp)
  800c9a:	e8 89 ff ff ff       	call   800c28 <vsnprintf>
  800c9f:	83 c4 10             	add    $0x10,%esp
  800ca2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb7:	eb 06                	jmp    800cbf <strlen+0x15>
		n++;
  800cb9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cbc:	ff 45 08             	incl   0x8(%ebp)
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	84 c0                	test   %al,%al
  800cc6:	75 f1                	jne    800cb9 <strlen+0xf>
		n++;
	return n;
  800cc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ccb:	c9                   	leave  
  800ccc:	c3                   	ret    

00800ccd <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cda:	eb 09                	jmp    800ce5 <strnlen+0x18>
		n++;
  800cdc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cdf:	ff 45 08             	incl   0x8(%ebp)
  800ce2:	ff 4d 0c             	decl   0xc(%ebp)
  800ce5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce9:	74 09                	je     800cf4 <strnlen+0x27>
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	84 c0                	test   %al,%al
  800cf2:	75 e8                	jne    800cdc <strnlen+0xf>
		n++;
	return n;
  800cf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf7:	c9                   	leave  
  800cf8:	c3                   	ret    

00800cf9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d05:	90                   	nop
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8d 50 01             	lea    0x1(%eax),%edx
  800d0c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d12:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d15:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d18:	8a 12                	mov    (%edx),%dl
  800d1a:	88 10                	mov    %dl,(%eax)
  800d1c:	8a 00                	mov    (%eax),%al
  800d1e:	84 c0                	test   %al,%al
  800d20:	75 e4                	jne    800d06 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3a:	eb 1f                	jmp    800d5b <strncpy+0x34>
		*dst++ = *src;
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8d 50 01             	lea    0x1(%eax),%edx
  800d42:	89 55 08             	mov    %edx,0x8(%ebp)
  800d45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d48:	8a 12                	mov    (%edx),%dl
  800d4a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	84 c0                	test   %al,%al
  800d53:	74 03                	je     800d58 <strncpy+0x31>
			src++;
  800d55:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d58:	ff 45 fc             	incl   -0x4(%ebp)
  800d5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d61:	72 d9                	jb     800d3c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d63:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d78:	74 30                	je     800daa <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d7a:	eb 16                	jmp    800d92 <strlcpy+0x2a>
			*dst++ = *src++;
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8d 50 01             	lea    0x1(%eax),%edx
  800d82:	89 55 08             	mov    %edx,0x8(%ebp)
  800d85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d88:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d8b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d8e:	8a 12                	mov    (%edx),%dl
  800d90:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d92:	ff 4d 10             	decl   0x10(%ebp)
  800d95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d99:	74 09                	je     800da4 <strlcpy+0x3c>
  800d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	84 c0                	test   %al,%al
  800da2:	75 d8                	jne    800d7c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800daa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db0:	29 c2                	sub    %eax,%edx
  800db2:	89 d0                	mov    %edx,%eax
}
  800db4:	c9                   	leave  
  800db5:	c3                   	ret    

00800db6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800db9:	eb 06                	jmp    800dc1 <strcmp+0xb>
		p++, q++;
  800dbb:	ff 45 08             	incl   0x8(%ebp)
  800dbe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	84 c0                	test   %al,%al
  800dc8:	74 0e                	je     800dd8 <strcmp+0x22>
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 10                	mov    (%eax),%dl
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	38 c2                	cmp    %al,%dl
  800dd6:	74 e3                	je     800dbb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	0f b6 d0             	movzbl %al,%edx
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 c0             	movzbl %al,%eax
  800de8:	29 c2                	sub    %eax,%edx
  800dea:	89 d0                	mov    %edx,%eax
}
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    

00800dee <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800df1:	eb 09                	jmp    800dfc <strncmp+0xe>
		n--, p++, q++;
  800df3:	ff 4d 10             	decl   0x10(%ebp)
  800df6:	ff 45 08             	incl   0x8(%ebp)
  800df9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e00:	74 17                	je     800e19 <strncmp+0x2b>
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	84 c0                	test   %al,%al
  800e09:	74 0e                	je     800e19 <strncmp+0x2b>
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8a 10                	mov    (%eax),%dl
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	38 c2                	cmp    %al,%dl
  800e17:	74 da                	je     800df3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1d:	75 07                	jne    800e26 <strncmp+0x38>
		return 0;
  800e1f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e24:	eb 14                	jmp    800e3a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8a 00                	mov    (%eax),%al
  800e2b:	0f b6 d0             	movzbl %al,%edx
  800e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	0f b6 c0             	movzbl %al,%eax
  800e36:	29 c2                	sub    %eax,%edx
  800e38:	89 d0                	mov    %edx,%eax
}
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 04             	sub    $0x4,%esp
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e45:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e48:	eb 12                	jmp    800e5c <strchr+0x20>
		if (*s == c)
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e52:	75 05                	jne    800e59 <strchr+0x1d>
			return (char *) s;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	eb 11                	jmp    800e6a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e59:	ff 45 08             	incl   0x8(%ebp)
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	84 c0                	test   %al,%al
  800e63:	75 e5                	jne    800e4a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6a:	c9                   	leave  
  800e6b:	c3                   	ret    

00800e6c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	83 ec 04             	sub    $0x4,%esp
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e78:	eb 0d                	jmp    800e87 <strfind+0x1b>
		if (*s == c)
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e82:	74 0e                	je     800e92 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e84:	ff 45 08             	incl   0x8(%ebp)
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	84 c0                	test   %al,%al
  800e8e:	75 ea                	jne    800e7a <strfind+0xe>
  800e90:	eb 01                	jmp    800e93 <strfind+0x27>
		if (*s == c)
			break;
  800e92:	90                   	nop
	return (char *) s;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e96:	c9                   	leave  
  800e97:	c3                   	ret    

00800e98 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ea4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea8:	76 63                	jbe    800f0d <memset+0x75>
		uint64 data_block = c;
  800eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ead:	99                   	cltd   
  800eae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eba:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ebe:	c1 e0 08             	shl    $0x8,%eax
  800ec1:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ecd:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ed1:	c1 e0 10             	shl    $0x10,%eax
  800ed4:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ed7:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee0:	89 c2                	mov    %eax,%edx
  800ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eea:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800eed:	eb 18                	jmp    800f07 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800eef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ef2:	8d 41 08             	lea    0x8(%ecx),%eax
  800ef5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800efb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800efe:	89 01                	mov    %eax,(%ecx)
  800f00:	89 51 04             	mov    %edx,0x4(%ecx)
  800f03:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f07:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f0b:	77 e2                	ja     800eef <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f11:	74 23                	je     800f36 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f16:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f19:	eb 0e                	jmp    800f29 <memset+0x91>
			*p8++ = (uint8)c;
  800f1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1e:	8d 50 01             	lea    0x1(%eax),%edx
  800f21:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f27:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f29:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f2f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f32:	85 c0                	test   %eax,%eax
  800f34:	75 e5                	jne    800f1b <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f4d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f51:	76 24                	jbe    800f77 <memcpy+0x3c>
		while(n >= 8){
  800f53:	eb 1c                	jmp    800f71 <memcpy+0x36>
			*d64 = *s64;
  800f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f58:	8b 50 04             	mov    0x4(%eax),%edx
  800f5b:	8b 00                	mov    (%eax),%eax
  800f5d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f60:	89 01                	mov    %eax,(%ecx)
  800f62:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f65:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f69:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f6d:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f71:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f75:	77 de                	ja     800f55 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7b:	74 31                	je     800fae <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f80:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f86:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f89:	eb 16                	jmp    800fa1 <memcpy+0x66>
			*d8++ = *s8++;
  800f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8e:	8d 50 01             	lea    0x1(%eax),%edx
  800f91:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f97:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f9a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f9d:	8a 12                	mov    (%edx),%dl
  800f9f:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa7:	89 55 10             	mov    %edx,0x10(%ebp)
  800faa:	85 c0                	test   %eax,%eax
  800fac:	75 dd                	jne    800f8b <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    

00800fb3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fcb:	73 50                	jae    80101d <memmove+0x6a>
  800fcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	01 d0                	add    %edx,%eax
  800fd5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fd8:	76 43                	jbe    80101d <memmove+0x6a>
		s += n;
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fe6:	eb 10                	jmp    800ff8 <memmove+0x45>
			*--d = *--s;
  800fe8:	ff 4d f8             	decl   -0x8(%ebp)
  800feb:	ff 4d fc             	decl   -0x4(%ebp)
  800fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff1:	8a 10                	mov    (%eax),%dl
  800ff3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ff8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffe:	89 55 10             	mov    %edx,0x10(%ebp)
  801001:	85 c0                	test   %eax,%eax
  801003:	75 e3                	jne    800fe8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801005:	eb 23                	jmp    80102a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801007:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100a:	8d 50 01             	lea    0x1(%eax),%edx
  80100d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801010:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801013:	8d 4a 01             	lea    0x1(%edx),%ecx
  801016:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801019:	8a 12                	mov    (%edx),%dl
  80101b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80101d:	8b 45 10             	mov    0x10(%ebp),%eax
  801020:	8d 50 ff             	lea    -0x1(%eax),%edx
  801023:	89 55 10             	mov    %edx,0x10(%ebp)
  801026:	85 c0                	test   %eax,%eax
  801028:	75 dd                	jne    801007 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80102d:	c9                   	leave  
  80102e:	c3                   	ret    

0080102f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80103b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801041:	eb 2a                	jmp    80106d <memcmp+0x3e>
		if (*s1 != *s2)
  801043:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801046:	8a 10                	mov    (%eax),%dl
  801048:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	38 c2                	cmp    %al,%dl
  80104f:	74 16                	je     801067 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801051:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	0f b6 d0             	movzbl %al,%edx
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	0f b6 c0             	movzbl %al,%eax
  801061:	29 c2                	sub    %eax,%edx
  801063:	89 d0                	mov    %edx,%eax
  801065:	eb 18                	jmp    80107f <memcmp+0x50>
		s1++, s2++;
  801067:	ff 45 fc             	incl   -0x4(%ebp)
  80106a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80106d:	8b 45 10             	mov    0x10(%ebp),%eax
  801070:	8d 50 ff             	lea    -0x1(%eax),%edx
  801073:	89 55 10             	mov    %edx,0x10(%ebp)
  801076:	85 c0                	test   %eax,%eax
  801078:	75 c9                	jne    801043 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80107a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80107f:	c9                   	leave  
  801080:	c3                   	ret    

00801081 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801087:	8b 55 08             	mov    0x8(%ebp),%edx
  80108a:	8b 45 10             	mov    0x10(%ebp),%eax
  80108d:	01 d0                	add    %edx,%eax
  80108f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801092:	eb 15                	jmp    8010a9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	8a 00                	mov    (%eax),%al
  801099:	0f b6 d0             	movzbl %al,%edx
  80109c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109f:	0f b6 c0             	movzbl %al,%eax
  8010a2:	39 c2                	cmp    %eax,%edx
  8010a4:	74 0d                	je     8010b3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010a6:	ff 45 08             	incl   0x8(%ebp)
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010af:	72 e3                	jb     801094 <memfind+0x13>
  8010b1:	eb 01                	jmp    8010b4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010b3:	90                   	nop
	return (void *) s;
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    

008010b9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010cd:	eb 03                	jmp    8010d2 <strtol+0x19>
		s++;
  8010cf:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	3c 20                	cmp    $0x20,%al
  8010d9:	74 f4                	je     8010cf <strtol+0x16>
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	3c 09                	cmp    $0x9,%al
  8010e2:	74 eb                	je     8010cf <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	3c 2b                	cmp    $0x2b,%al
  8010eb:	75 05                	jne    8010f2 <strtol+0x39>
		s++;
  8010ed:	ff 45 08             	incl   0x8(%ebp)
  8010f0:	eb 13                	jmp    801105 <strtol+0x4c>
	else if (*s == '-')
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	3c 2d                	cmp    $0x2d,%al
  8010f9:	75 0a                	jne    801105 <strtol+0x4c>
		s++, neg = 1;
  8010fb:	ff 45 08             	incl   0x8(%ebp)
  8010fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801105:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801109:	74 06                	je     801111 <strtol+0x58>
  80110b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80110f:	75 20                	jne    801131 <strtol+0x78>
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	3c 30                	cmp    $0x30,%al
  801118:	75 17                	jne    801131 <strtol+0x78>
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	40                   	inc    %eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	3c 78                	cmp    $0x78,%al
  801122:	75 0d                	jne    801131 <strtol+0x78>
		s += 2, base = 16;
  801124:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801128:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80112f:	eb 28                	jmp    801159 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801131:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801135:	75 15                	jne    80114c <strtol+0x93>
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	3c 30                	cmp    $0x30,%al
  80113e:	75 0c                	jne    80114c <strtol+0x93>
		s++, base = 8;
  801140:	ff 45 08             	incl   0x8(%ebp)
  801143:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80114a:	eb 0d                	jmp    801159 <strtol+0xa0>
	else if (base == 0)
  80114c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801150:	75 07                	jne    801159 <strtol+0xa0>
		base = 10;
  801152:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	3c 2f                	cmp    $0x2f,%al
  801160:	7e 19                	jle    80117b <strtol+0xc2>
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	3c 39                	cmp    $0x39,%al
  801169:	7f 10                	jg     80117b <strtol+0xc2>
			dig = *s - '0';
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	0f be c0             	movsbl %al,%eax
  801173:	83 e8 30             	sub    $0x30,%eax
  801176:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801179:	eb 42                	jmp    8011bd <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
  80117e:	8a 00                	mov    (%eax),%al
  801180:	3c 60                	cmp    $0x60,%al
  801182:	7e 19                	jle    80119d <strtol+0xe4>
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	3c 7a                	cmp    $0x7a,%al
  80118b:	7f 10                	jg     80119d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	0f be c0             	movsbl %al,%eax
  801195:	83 e8 57             	sub    $0x57,%eax
  801198:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80119b:	eb 20                	jmp    8011bd <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	3c 40                	cmp    $0x40,%al
  8011a4:	7e 39                	jle    8011df <strtol+0x126>
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	3c 5a                	cmp    $0x5a,%al
  8011ad:	7f 30                	jg     8011df <strtol+0x126>
			dig = *s - 'A' + 10;
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8a 00                	mov    (%eax),%al
  8011b4:	0f be c0             	movsbl %al,%eax
  8011b7:	83 e8 37             	sub    $0x37,%eax
  8011ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011c3:	7d 19                	jge    8011de <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011c5:	ff 45 08             	incl   0x8(%ebp)
  8011c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cb:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011cf:	89 c2                	mov    %eax,%edx
  8011d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d4:	01 d0                	add    %edx,%eax
  8011d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011d9:	e9 7b ff ff ff       	jmp    801159 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011de:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e3:	74 08                	je     8011ed <strtol+0x134>
		*endptr = (char *) s;
  8011e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011eb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011f1:	74 07                	je     8011fa <strtol+0x141>
  8011f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f6:	f7 d8                	neg    %eax
  8011f8:	eb 03                	jmp    8011fd <strtol+0x144>
  8011fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    

008011ff <ltostr>:

void
ltostr(long value, char *str)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801205:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80120c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801217:	79 13                	jns    80122c <ltostr+0x2d>
	{
		neg = 1;
  801219:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801226:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801229:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801234:	99                   	cltd   
  801235:	f7 f9                	idiv   %ecx
  801237:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80123a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123d:	8d 50 01             	lea    0x1(%eax),%edx
  801240:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801243:	89 c2                	mov    %eax,%edx
  801245:	8b 45 0c             	mov    0xc(%ebp),%eax
  801248:	01 d0                	add    %edx,%eax
  80124a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80124d:	83 c2 30             	add    $0x30,%edx
  801250:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801252:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801255:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80125a:	f7 e9                	imul   %ecx
  80125c:	c1 fa 02             	sar    $0x2,%edx
  80125f:	89 c8                	mov    %ecx,%eax
  801261:	c1 f8 1f             	sar    $0x1f,%eax
  801264:	29 c2                	sub    %eax,%edx
  801266:	89 d0                	mov    %edx,%eax
  801268:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80126b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80126f:	75 bb                	jne    80122c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801271:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801278:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127b:	48                   	dec    %eax
  80127c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80127f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801283:	74 3d                	je     8012c2 <ltostr+0xc3>
		start = 1 ;
  801285:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80128c:	eb 34                	jmp    8012c2 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80128e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801291:	8b 45 0c             	mov    0xc(%ebp),%eax
  801294:	01 d0                	add    %edx,%eax
  801296:	8a 00                	mov    (%eax),%al
  801298:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80129b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 c2                	add    %eax,%edx
  8012a3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a9:	01 c8                	add    %ecx,%eax
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b5:	01 c2                	add    %eax,%edx
  8012b7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012ba:	88 02                	mov    %al,(%edx)
		start++ ;
  8012bc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012bf:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c8:	7c c4                	jl     80128e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012ca:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012d5:	90                   	nop
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012de:	ff 75 08             	pushl  0x8(%ebp)
  8012e1:	e8 c4 f9 ff ff       	call   800caa <strlen>
  8012e6:	83 c4 04             	add    $0x4,%esp
  8012e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012ec:	ff 75 0c             	pushl  0xc(%ebp)
  8012ef:	e8 b6 f9 ff ff       	call   800caa <strlen>
  8012f4:	83 c4 04             	add    $0x4,%esp
  8012f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801308:	eb 17                	jmp    801321 <strcconcat+0x49>
		final[s] = str1[s] ;
  80130a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130d:	8b 45 10             	mov    0x10(%ebp),%eax
  801310:	01 c2                	add    %eax,%edx
  801312:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	01 c8                	add    %ecx,%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80131e:	ff 45 fc             	incl   -0x4(%ebp)
  801321:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801324:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801327:	7c e1                	jl     80130a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801329:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801330:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801337:	eb 1f                	jmp    801358 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801339:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133c:	8d 50 01             	lea    0x1(%eax),%edx
  80133f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801342:	89 c2                	mov    %eax,%edx
  801344:	8b 45 10             	mov    0x10(%ebp),%eax
  801347:	01 c2                	add    %eax,%edx
  801349:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80134c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134f:	01 c8                	add    %ecx,%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801355:	ff 45 f8             	incl   -0x8(%ebp)
  801358:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80135e:	7c d9                	jl     801339 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801360:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801363:	8b 45 10             	mov    0x10(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	c6 00 00             	movb   $0x0,(%eax)
}
  80136b:	90                   	nop
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801371:	8b 45 14             	mov    0x14(%ebp),%eax
  801374:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80137a:	8b 45 14             	mov    0x14(%ebp),%eax
  80137d:	8b 00                	mov    (%eax),%eax
  80137f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801386:	8b 45 10             	mov    0x10(%ebp),%eax
  801389:	01 d0                	add    %edx,%eax
  80138b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801391:	eb 0c                	jmp    80139f <strsplit+0x31>
			*string++ = 0;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	8d 50 01             	lea    0x1(%eax),%edx
  801399:	89 55 08             	mov    %edx,0x8(%ebp)
  80139c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	84 c0                	test   %al,%al
  8013a6:	74 18                	je     8013c0 <strsplit+0x52>
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	0f be c0             	movsbl %al,%eax
  8013b0:	50                   	push   %eax
  8013b1:	ff 75 0c             	pushl  0xc(%ebp)
  8013b4:	e8 83 fa ff ff       	call   800e3c <strchr>
  8013b9:	83 c4 08             	add    $0x8,%esp
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	75 d3                	jne    801393 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	84 c0                	test   %al,%al
  8013c7:	74 5a                	je     801423 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cc:	8b 00                	mov    (%eax),%eax
  8013ce:	83 f8 0f             	cmp    $0xf,%eax
  8013d1:	75 07                	jne    8013da <strsplit+0x6c>
		{
			return 0;
  8013d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d8:	eb 66                	jmp    801440 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013da:	8b 45 14             	mov    0x14(%ebp),%eax
  8013dd:	8b 00                	mov    (%eax),%eax
  8013df:	8d 48 01             	lea    0x1(%eax),%ecx
  8013e2:	8b 55 14             	mov    0x14(%ebp),%edx
  8013e5:	89 0a                	mov    %ecx,(%edx)
  8013e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f1:	01 c2                	add    %eax,%edx
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f8:	eb 03                	jmp    8013fd <strsplit+0x8f>
			string++;
  8013fa:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	8a 00                	mov    (%eax),%al
  801402:	84 c0                	test   %al,%al
  801404:	74 8b                	je     801391 <strsplit+0x23>
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	0f be c0             	movsbl %al,%eax
  80140e:	50                   	push   %eax
  80140f:	ff 75 0c             	pushl  0xc(%ebp)
  801412:	e8 25 fa ff ff       	call   800e3c <strchr>
  801417:	83 c4 08             	add    $0x8,%esp
  80141a:	85 c0                	test   %eax,%eax
  80141c:	74 dc                	je     8013fa <strsplit+0x8c>
			string++;
	}
  80141e:	e9 6e ff ff ff       	jmp    801391 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801423:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801424:	8b 45 14             	mov    0x14(%ebp),%eax
  801427:	8b 00                	mov    (%eax),%eax
  801429:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801430:	8b 45 10             	mov    0x10(%ebp),%eax
  801433:	01 d0                	add    %edx,%eax
  801435:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80143b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801440:	c9                   	leave  
  801441:	c3                   	ret    

00801442 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80144e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801455:	eb 4a                	jmp    8014a1 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801457:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	01 c2                	add    %eax,%edx
  80145f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801462:	8b 45 0c             	mov    0xc(%ebp),%eax
  801465:	01 c8                	add    %ecx,%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80146b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801471:	01 d0                	add    %edx,%eax
  801473:	8a 00                	mov    (%eax),%al
  801475:	3c 40                	cmp    $0x40,%al
  801477:	7e 25                	jle    80149e <str2lower+0x5c>
  801479:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147f:	01 d0                	add    %edx,%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	3c 5a                	cmp    $0x5a,%al
  801485:	7f 17                	jg     80149e <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801487:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	01 d0                	add    %edx,%eax
  80148f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801492:	8b 55 08             	mov    0x8(%ebp),%edx
  801495:	01 ca                	add    %ecx,%edx
  801497:	8a 12                	mov    (%edx),%dl
  801499:	83 c2 20             	add    $0x20,%edx
  80149c:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80149e:	ff 45 fc             	incl   -0x4(%ebp)
  8014a1:	ff 75 0c             	pushl  0xc(%ebp)
  8014a4:	e8 01 f8 ff ff       	call   800caa <strlen>
  8014a9:	83 c4 04             	add    $0x4,%esp
  8014ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014af:	7f a6                	jg     801457 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	57                   	push   %edi
  8014ba:	56                   	push   %esi
  8014bb:	53                   	push   %ebx
  8014bc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014cb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014ce:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014d1:	cd 30                	int    $0x30
  8014d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	5b                   	pop    %ebx
  8014dd:	5e                   	pop    %esi
  8014de:	5f                   	pop    %edi
  8014df:	5d                   	pop    %ebp
  8014e0:	c3                   	ret    

008014e1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
  8014e4:	83 ec 04             	sub    $0x4,%esp
  8014e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014ed:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014f0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	6a 00                	push   $0x0
  8014f9:	51                   	push   %ecx
  8014fa:	52                   	push   %edx
  8014fb:	ff 75 0c             	pushl  0xc(%ebp)
  8014fe:	50                   	push   %eax
  8014ff:	6a 00                	push   $0x0
  801501:	e8 b0 ff ff ff       	call   8014b6 <syscall>
  801506:	83 c4 18             	add    $0x18,%esp
}
  801509:	90                   	nop
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    

0080150c <sys_cgetc>:

int
sys_cgetc(void)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 02                	push   $0x2
  80151b:	e8 96 ff ff ff       	call   8014b6 <syscall>
  801520:	83 c4 18             	add    $0x18,%esp
}
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 03                	push   $0x3
  801534:	e8 7d ff ff ff       	call   8014b6 <syscall>
  801539:	83 c4 18             	add    $0x18,%esp
}
  80153c:	90                   	nop
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 04                	push   $0x4
  80154e:	e8 63 ff ff ff       	call   8014b6 <syscall>
  801553:	83 c4 18             	add    $0x18,%esp
}
  801556:	90                   	nop
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80155c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	52                   	push   %edx
  801569:	50                   	push   %eax
  80156a:	6a 08                	push   $0x8
  80156c:	e8 45 ff ff ff       	call   8014b6 <syscall>
  801571:	83 c4 18             	add    $0x18,%esp
}
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	56                   	push   %esi
  80157a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80157b:	8b 75 18             	mov    0x18(%ebp),%esi
  80157e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801581:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801584:	8b 55 0c             	mov    0xc(%ebp),%edx
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	56                   	push   %esi
  80158b:	53                   	push   %ebx
  80158c:	51                   	push   %ecx
  80158d:	52                   	push   %edx
  80158e:	50                   	push   %eax
  80158f:	6a 09                	push   $0x9
  801591:	e8 20 ff ff ff       	call   8014b6 <syscall>
  801596:	83 c4 18             	add    $0x18,%esp
}
  801599:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80159c:	5b                   	pop    %ebx
  80159d:	5e                   	pop    %esi
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    

008015a0 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	ff 75 08             	pushl  0x8(%ebp)
  8015ae:	6a 0a                	push   $0xa
  8015b0:	e8 01 ff ff ff       	call   8014b6 <syscall>
  8015b5:	83 c4 18             	add    $0x18,%esp
}
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	ff 75 0c             	pushl  0xc(%ebp)
  8015c6:	ff 75 08             	pushl  0x8(%ebp)
  8015c9:	6a 0b                	push   $0xb
  8015cb:	e8 e6 fe ff ff       	call   8014b6 <syscall>
  8015d0:	83 c4 18             	add    $0x18,%esp
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 0c                	push   $0xc
  8015e4:	e8 cd fe ff ff       	call   8014b6 <syscall>
  8015e9:	83 c4 18             	add    $0x18,%esp
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 0d                	push   $0xd
  8015fd:	e8 b4 fe ff ff       	call   8014b6 <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 0e                	push   $0xe
  801616:	e8 9b fe ff ff       	call   8014b6 <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
}
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 0f                	push   $0xf
  80162f:	e8 82 fe ff ff       	call   8014b6 <syscall>
  801634:	83 c4 18             	add    $0x18,%esp
}
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	ff 75 08             	pushl  0x8(%ebp)
  801647:	6a 10                	push   $0x10
  801649:	e8 68 fe ff ff       	call   8014b6 <syscall>
  80164e:	83 c4 18             	add    $0x18,%esp
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 11                	push   $0x11
  801662:	e8 4f fe ff ff       	call   8014b6 <syscall>
  801667:	83 c4 18             	add    $0x18,%esp
}
  80166a:	90                   	nop
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <sys_cputc>:

void
sys_cputc(const char c)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 04             	sub    $0x4,%esp
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801679:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	50                   	push   %eax
  801686:	6a 01                	push   $0x1
  801688:	e8 29 fe ff ff       	call   8014b6 <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	90                   	nop
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 14                	push   $0x14
  8016a2:	e8 0f fe ff ff       	call   8014b6 <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
}
  8016aa:	90                   	nop
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 04             	sub    $0x4,%esp
  8016b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016b9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016bc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	51                   	push   %ecx
  8016c6:	52                   	push   %edx
  8016c7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ca:	50                   	push   %eax
  8016cb:	6a 15                	push   $0x15
  8016cd:	e8 e4 fd ff ff       	call   8014b6 <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	52                   	push   %edx
  8016e7:	50                   	push   %eax
  8016e8:	6a 16                	push   $0x16
  8016ea:	e8 c7 fd ff ff       	call   8014b6 <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	51                   	push   %ecx
  801705:	52                   	push   %edx
  801706:	50                   	push   %eax
  801707:	6a 17                	push   $0x17
  801709:	e8 a8 fd ff ff       	call   8014b6 <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801716:	8b 55 0c             	mov    0xc(%ebp),%edx
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	52                   	push   %edx
  801723:	50                   	push   %eax
  801724:	6a 18                	push   $0x18
  801726:	e8 8b fd ff ff       	call   8014b6 <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	6a 00                	push   $0x0
  801738:	ff 75 14             	pushl  0x14(%ebp)
  80173b:	ff 75 10             	pushl  0x10(%ebp)
  80173e:	ff 75 0c             	pushl  0xc(%ebp)
  801741:	50                   	push   %eax
  801742:	6a 19                	push   $0x19
  801744:	e8 6d fd ff ff       	call   8014b6 <syscall>
  801749:	83 c4 18             	add    $0x18,%esp
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	50                   	push   %eax
  80175d:	6a 1a                	push   $0x1a
  80175f:	e8 52 fd ff ff       	call   8014b6 <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
}
  801767:	90                   	nop
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	50                   	push   %eax
  801779:	6a 1b                	push   $0x1b
  80177b:	e8 36 fd ff ff       	call   8014b6 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 05                	push   $0x5
  801794:	e8 1d fd ff ff       	call   8014b6 <syscall>
  801799:	83 c4 18             	add    $0x18,%esp
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 06                	push   $0x6
  8017ad:	e8 04 fd ff ff       	call   8014b6 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 07                	push   $0x7
  8017c6:	e8 eb fc ff ff       	call   8014b6 <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_exit_env>:


void sys_exit_env(void)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 1c                	push   $0x1c
  8017df:	e8 d2 fc ff ff       	call   8014b6 <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
}
  8017e7:	90                   	nop
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017f0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017f3:	8d 50 04             	lea    0x4(%eax),%edx
  8017f6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	52                   	push   %edx
  801800:	50                   	push   %eax
  801801:	6a 1d                	push   $0x1d
  801803:	e8 ae fc ff ff       	call   8014b6 <syscall>
  801808:	83 c4 18             	add    $0x18,%esp
	return result;
  80180b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80180e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801811:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801814:	89 01                	mov    %eax,(%ecx)
  801816:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	c9                   	leave  
  80181d:	c2 04 00             	ret    $0x4

00801820 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	ff 75 10             	pushl  0x10(%ebp)
  80182a:	ff 75 0c             	pushl  0xc(%ebp)
  80182d:	ff 75 08             	pushl  0x8(%ebp)
  801830:	6a 13                	push   $0x13
  801832:	e8 7f fc ff ff       	call   8014b6 <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
	return ;
  80183a:	90                   	nop
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <sys_rcr2>:
uint32 sys_rcr2()
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 1e                	push   $0x1e
  80184c:	e8 65 fc ff ff       	call   8014b6 <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	83 ec 04             	sub    $0x4,%esp
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801862:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	50                   	push   %eax
  80186f:	6a 1f                	push   $0x1f
  801871:	e8 40 fc ff ff       	call   8014b6 <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
	return ;
  801879:	90                   	nop
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <rsttst>:
void rsttst()
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 21                	push   $0x21
  80188b:	e8 26 fc ff ff       	call   8014b6 <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
	return ;
  801893:	90                   	nop
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 04             	sub    $0x4,%esp
  80189c:	8b 45 14             	mov    0x14(%ebp),%eax
  80189f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018a2:	8b 55 18             	mov    0x18(%ebp),%edx
  8018a5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018a9:	52                   	push   %edx
  8018aa:	50                   	push   %eax
  8018ab:	ff 75 10             	pushl  0x10(%ebp)
  8018ae:	ff 75 0c             	pushl  0xc(%ebp)
  8018b1:	ff 75 08             	pushl  0x8(%ebp)
  8018b4:	6a 20                	push   $0x20
  8018b6:	e8 fb fb ff ff       	call   8014b6 <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018be:	90                   	nop
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <chktst>:
void chktst(uint32 n)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	ff 75 08             	pushl  0x8(%ebp)
  8018cf:	6a 22                	push   $0x22
  8018d1:	e8 e0 fb ff ff       	call   8014b6 <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d9:	90                   	nop
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <inctst>:

void inctst()
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 23                	push   $0x23
  8018eb:	e8 c6 fb ff ff       	call   8014b6 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f3:	90                   	nop
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <gettst>:
uint32 gettst()
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 24                	push   $0x24
  801905:	e8 ac fb ff ff       	call   8014b6 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 25                	push   $0x25
  80191e:	e8 93 fb ff ff       	call   8014b6 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
  801926:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80192b:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	ff 75 08             	pushl  0x8(%ebp)
  801948:	6a 26                	push   $0x26
  80194a:	e8 67 fb ff ff       	call   8014b6 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
	return ;
  801952:	90                   	nop
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801959:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80195c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80195f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	6a 00                	push   $0x0
  801967:	53                   	push   %ebx
  801968:	51                   	push   %ecx
  801969:	52                   	push   %edx
  80196a:	50                   	push   %eax
  80196b:	6a 27                	push   $0x27
  80196d:	e8 44 fb ff ff       	call   8014b6 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80197d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	52                   	push   %edx
  80198a:	50                   	push   %eax
  80198b:	6a 28                	push   $0x28
  80198d:	e8 24 fb ff ff       	call   8014b6 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80199a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80199d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	6a 00                	push   $0x0
  8019a5:	51                   	push   %ecx
  8019a6:	ff 75 10             	pushl  0x10(%ebp)
  8019a9:	52                   	push   %edx
  8019aa:	50                   	push   %eax
  8019ab:	6a 29                	push   $0x29
  8019ad:	e8 04 fb ff ff       	call   8014b6 <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	ff 75 10             	pushl  0x10(%ebp)
  8019c1:	ff 75 0c             	pushl  0xc(%ebp)
  8019c4:	ff 75 08             	pushl  0x8(%ebp)
  8019c7:	6a 12                	push   $0x12
  8019c9:	e8 e8 fa ff ff       	call   8014b6 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d1:	90                   	nop
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	52                   	push   %edx
  8019e4:	50                   	push   %eax
  8019e5:	6a 2a                	push   $0x2a
  8019e7:	e8 ca fa ff ff       	call   8014b6 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
	return;
  8019ef:	90                   	nop
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 2b                	push   $0x2b
  801a01:	e8 b0 fa ff ff       	call   8014b6 <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	ff 75 0c             	pushl  0xc(%ebp)
  801a17:	ff 75 08             	pushl  0x8(%ebp)
  801a1a:	6a 2d                	push   $0x2d
  801a1c:	e8 95 fa ff ff       	call   8014b6 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
	return;
  801a24:	90                   	nop
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	6a 2c                	push   $0x2c
  801a38:	e8 79 fa ff ff       	call   8014b6 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a40:	90                   	nop
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801a46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	52                   	push   %edx
  801a53:	50                   	push   %eax
  801a54:	6a 2e                	push   $0x2e
  801a56:	e8 5b fa ff ff       	call   8014b6 <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5e:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    
  801a61:	66 90                	xchg   %ax,%ax
  801a63:	90                   	nop

00801a64 <__udivdi3>:
  801a64:	55                   	push   %ebp
  801a65:	57                   	push   %edi
  801a66:	56                   	push   %esi
  801a67:	53                   	push   %ebx
  801a68:	83 ec 1c             	sub    $0x1c,%esp
  801a6b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a6f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a7b:	89 ca                	mov    %ecx,%edx
  801a7d:	89 f8                	mov    %edi,%eax
  801a7f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a83:	85 f6                	test   %esi,%esi
  801a85:	75 2d                	jne    801ab4 <__udivdi3+0x50>
  801a87:	39 cf                	cmp    %ecx,%edi
  801a89:	77 65                	ja     801af0 <__udivdi3+0x8c>
  801a8b:	89 fd                	mov    %edi,%ebp
  801a8d:	85 ff                	test   %edi,%edi
  801a8f:	75 0b                	jne    801a9c <__udivdi3+0x38>
  801a91:	b8 01 00 00 00       	mov    $0x1,%eax
  801a96:	31 d2                	xor    %edx,%edx
  801a98:	f7 f7                	div    %edi
  801a9a:	89 c5                	mov    %eax,%ebp
  801a9c:	31 d2                	xor    %edx,%edx
  801a9e:	89 c8                	mov    %ecx,%eax
  801aa0:	f7 f5                	div    %ebp
  801aa2:	89 c1                	mov    %eax,%ecx
  801aa4:	89 d8                	mov    %ebx,%eax
  801aa6:	f7 f5                	div    %ebp
  801aa8:	89 cf                	mov    %ecx,%edi
  801aaa:	89 fa                	mov    %edi,%edx
  801aac:	83 c4 1c             	add    $0x1c,%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5f                   	pop    %edi
  801ab2:	5d                   	pop    %ebp
  801ab3:	c3                   	ret    
  801ab4:	39 ce                	cmp    %ecx,%esi
  801ab6:	77 28                	ja     801ae0 <__udivdi3+0x7c>
  801ab8:	0f bd fe             	bsr    %esi,%edi
  801abb:	83 f7 1f             	xor    $0x1f,%edi
  801abe:	75 40                	jne    801b00 <__udivdi3+0x9c>
  801ac0:	39 ce                	cmp    %ecx,%esi
  801ac2:	72 0a                	jb     801ace <__udivdi3+0x6a>
  801ac4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ac8:	0f 87 9e 00 00 00    	ja     801b6c <__udivdi3+0x108>
  801ace:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad3:	89 fa                	mov    %edi,%edx
  801ad5:	83 c4 1c             	add    $0x1c,%esp
  801ad8:	5b                   	pop    %ebx
  801ad9:	5e                   	pop    %esi
  801ada:	5f                   	pop    %edi
  801adb:	5d                   	pop    %ebp
  801adc:	c3                   	ret    
  801add:	8d 76 00             	lea    0x0(%esi),%esi
  801ae0:	31 ff                	xor    %edi,%edi
  801ae2:	31 c0                	xor    %eax,%eax
  801ae4:	89 fa                	mov    %edi,%edx
  801ae6:	83 c4 1c             	add    $0x1c,%esp
  801ae9:	5b                   	pop    %ebx
  801aea:	5e                   	pop    %esi
  801aeb:	5f                   	pop    %edi
  801aec:	5d                   	pop    %ebp
  801aed:	c3                   	ret    
  801aee:	66 90                	xchg   %ax,%ax
  801af0:	89 d8                	mov    %ebx,%eax
  801af2:	f7 f7                	div    %edi
  801af4:	31 ff                	xor    %edi,%edi
  801af6:	89 fa                	mov    %edi,%edx
  801af8:	83 c4 1c             	add    $0x1c,%esp
  801afb:	5b                   	pop    %ebx
  801afc:	5e                   	pop    %esi
  801afd:	5f                   	pop    %edi
  801afe:	5d                   	pop    %ebp
  801aff:	c3                   	ret    
  801b00:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b05:	89 eb                	mov    %ebp,%ebx
  801b07:	29 fb                	sub    %edi,%ebx
  801b09:	89 f9                	mov    %edi,%ecx
  801b0b:	d3 e6                	shl    %cl,%esi
  801b0d:	89 c5                	mov    %eax,%ebp
  801b0f:	88 d9                	mov    %bl,%cl
  801b11:	d3 ed                	shr    %cl,%ebp
  801b13:	89 e9                	mov    %ebp,%ecx
  801b15:	09 f1                	or     %esi,%ecx
  801b17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b1b:	89 f9                	mov    %edi,%ecx
  801b1d:	d3 e0                	shl    %cl,%eax
  801b1f:	89 c5                	mov    %eax,%ebp
  801b21:	89 d6                	mov    %edx,%esi
  801b23:	88 d9                	mov    %bl,%cl
  801b25:	d3 ee                	shr    %cl,%esi
  801b27:	89 f9                	mov    %edi,%ecx
  801b29:	d3 e2                	shl    %cl,%edx
  801b2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b2f:	88 d9                	mov    %bl,%cl
  801b31:	d3 e8                	shr    %cl,%eax
  801b33:	09 c2                	or     %eax,%edx
  801b35:	89 d0                	mov    %edx,%eax
  801b37:	89 f2                	mov    %esi,%edx
  801b39:	f7 74 24 0c          	divl   0xc(%esp)
  801b3d:	89 d6                	mov    %edx,%esi
  801b3f:	89 c3                	mov    %eax,%ebx
  801b41:	f7 e5                	mul    %ebp
  801b43:	39 d6                	cmp    %edx,%esi
  801b45:	72 19                	jb     801b60 <__udivdi3+0xfc>
  801b47:	74 0b                	je     801b54 <__udivdi3+0xf0>
  801b49:	89 d8                	mov    %ebx,%eax
  801b4b:	31 ff                	xor    %edi,%edi
  801b4d:	e9 58 ff ff ff       	jmp    801aaa <__udivdi3+0x46>
  801b52:	66 90                	xchg   %ax,%ax
  801b54:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b58:	89 f9                	mov    %edi,%ecx
  801b5a:	d3 e2                	shl    %cl,%edx
  801b5c:	39 c2                	cmp    %eax,%edx
  801b5e:	73 e9                	jae    801b49 <__udivdi3+0xe5>
  801b60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b63:	31 ff                	xor    %edi,%edi
  801b65:	e9 40 ff ff ff       	jmp    801aaa <__udivdi3+0x46>
  801b6a:	66 90                	xchg   %ax,%ax
  801b6c:	31 c0                	xor    %eax,%eax
  801b6e:	e9 37 ff ff ff       	jmp    801aaa <__udivdi3+0x46>
  801b73:	90                   	nop

00801b74 <__umoddi3>:
  801b74:	55                   	push   %ebp
  801b75:	57                   	push   %edi
  801b76:	56                   	push   %esi
  801b77:	53                   	push   %ebx
  801b78:	83 ec 1c             	sub    $0x1c,%esp
  801b7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b87:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b93:	89 f3                	mov    %esi,%ebx
  801b95:	89 fa                	mov    %edi,%edx
  801b97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b9b:	89 34 24             	mov    %esi,(%esp)
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	75 1a                	jne    801bbc <__umoddi3+0x48>
  801ba2:	39 f7                	cmp    %esi,%edi
  801ba4:	0f 86 a2 00 00 00    	jbe    801c4c <__umoddi3+0xd8>
  801baa:	89 c8                	mov    %ecx,%eax
  801bac:	89 f2                	mov    %esi,%edx
  801bae:	f7 f7                	div    %edi
  801bb0:	89 d0                	mov    %edx,%eax
  801bb2:	31 d2                	xor    %edx,%edx
  801bb4:	83 c4 1c             	add    $0x1c,%esp
  801bb7:	5b                   	pop    %ebx
  801bb8:	5e                   	pop    %esi
  801bb9:	5f                   	pop    %edi
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    
  801bbc:	39 f0                	cmp    %esi,%eax
  801bbe:	0f 87 ac 00 00 00    	ja     801c70 <__umoddi3+0xfc>
  801bc4:	0f bd e8             	bsr    %eax,%ebp
  801bc7:	83 f5 1f             	xor    $0x1f,%ebp
  801bca:	0f 84 ac 00 00 00    	je     801c7c <__umoddi3+0x108>
  801bd0:	bf 20 00 00 00       	mov    $0x20,%edi
  801bd5:	29 ef                	sub    %ebp,%edi
  801bd7:	89 fe                	mov    %edi,%esi
  801bd9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bdd:	89 e9                	mov    %ebp,%ecx
  801bdf:	d3 e0                	shl    %cl,%eax
  801be1:	89 d7                	mov    %edx,%edi
  801be3:	89 f1                	mov    %esi,%ecx
  801be5:	d3 ef                	shr    %cl,%edi
  801be7:	09 c7                	or     %eax,%edi
  801be9:	89 e9                	mov    %ebp,%ecx
  801beb:	d3 e2                	shl    %cl,%edx
  801bed:	89 14 24             	mov    %edx,(%esp)
  801bf0:	89 d8                	mov    %ebx,%eax
  801bf2:	d3 e0                	shl    %cl,%eax
  801bf4:	89 c2                	mov    %eax,%edx
  801bf6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bfa:	d3 e0                	shl    %cl,%eax
  801bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c00:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c04:	89 f1                	mov    %esi,%ecx
  801c06:	d3 e8                	shr    %cl,%eax
  801c08:	09 d0                	or     %edx,%eax
  801c0a:	d3 eb                	shr    %cl,%ebx
  801c0c:	89 da                	mov    %ebx,%edx
  801c0e:	f7 f7                	div    %edi
  801c10:	89 d3                	mov    %edx,%ebx
  801c12:	f7 24 24             	mull   (%esp)
  801c15:	89 c6                	mov    %eax,%esi
  801c17:	89 d1                	mov    %edx,%ecx
  801c19:	39 d3                	cmp    %edx,%ebx
  801c1b:	0f 82 87 00 00 00    	jb     801ca8 <__umoddi3+0x134>
  801c21:	0f 84 91 00 00 00    	je     801cb8 <__umoddi3+0x144>
  801c27:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c2b:	29 f2                	sub    %esi,%edx
  801c2d:	19 cb                	sbb    %ecx,%ebx
  801c2f:	89 d8                	mov    %ebx,%eax
  801c31:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c35:	d3 e0                	shl    %cl,%eax
  801c37:	89 e9                	mov    %ebp,%ecx
  801c39:	d3 ea                	shr    %cl,%edx
  801c3b:	09 d0                	or     %edx,%eax
  801c3d:	89 e9                	mov    %ebp,%ecx
  801c3f:	d3 eb                	shr    %cl,%ebx
  801c41:	89 da                	mov    %ebx,%edx
  801c43:	83 c4 1c             	add    $0x1c,%esp
  801c46:	5b                   	pop    %ebx
  801c47:	5e                   	pop    %esi
  801c48:	5f                   	pop    %edi
  801c49:	5d                   	pop    %ebp
  801c4a:	c3                   	ret    
  801c4b:	90                   	nop
  801c4c:	89 fd                	mov    %edi,%ebp
  801c4e:	85 ff                	test   %edi,%edi
  801c50:	75 0b                	jne    801c5d <__umoddi3+0xe9>
  801c52:	b8 01 00 00 00       	mov    $0x1,%eax
  801c57:	31 d2                	xor    %edx,%edx
  801c59:	f7 f7                	div    %edi
  801c5b:	89 c5                	mov    %eax,%ebp
  801c5d:	89 f0                	mov    %esi,%eax
  801c5f:	31 d2                	xor    %edx,%edx
  801c61:	f7 f5                	div    %ebp
  801c63:	89 c8                	mov    %ecx,%eax
  801c65:	f7 f5                	div    %ebp
  801c67:	89 d0                	mov    %edx,%eax
  801c69:	e9 44 ff ff ff       	jmp    801bb2 <__umoddi3+0x3e>
  801c6e:	66 90                	xchg   %ax,%ax
  801c70:	89 c8                	mov    %ecx,%eax
  801c72:	89 f2                	mov    %esi,%edx
  801c74:	83 c4 1c             	add    $0x1c,%esp
  801c77:	5b                   	pop    %ebx
  801c78:	5e                   	pop    %esi
  801c79:	5f                   	pop    %edi
  801c7a:	5d                   	pop    %ebp
  801c7b:	c3                   	ret    
  801c7c:	3b 04 24             	cmp    (%esp),%eax
  801c7f:	72 06                	jb     801c87 <__umoddi3+0x113>
  801c81:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c85:	77 0f                	ja     801c96 <__umoddi3+0x122>
  801c87:	89 f2                	mov    %esi,%edx
  801c89:	29 f9                	sub    %edi,%ecx
  801c8b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c8f:	89 14 24             	mov    %edx,(%esp)
  801c92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c96:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c9a:	8b 14 24             	mov    (%esp),%edx
  801c9d:	83 c4 1c             	add    $0x1c,%esp
  801ca0:	5b                   	pop    %ebx
  801ca1:	5e                   	pop    %esi
  801ca2:	5f                   	pop    %edi
  801ca3:	5d                   	pop    %ebp
  801ca4:	c3                   	ret    
  801ca5:	8d 76 00             	lea    0x0(%esi),%esi
  801ca8:	2b 04 24             	sub    (%esp),%eax
  801cab:	19 fa                	sbb    %edi,%edx
  801cad:	89 d1                	mov    %edx,%ecx
  801caf:	89 c6                	mov    %eax,%esi
  801cb1:	e9 71 ff ff ff       	jmp    801c27 <__umoddi3+0xb3>
  801cb6:	66 90                	xchg   %ax,%ax
  801cb8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cbc:	72 ea                	jb     801ca8 <__umoddi3+0x134>
  801cbe:	89 d9                	mov    %ebx,%ecx
  801cc0:	e9 62 ff ff ff       	jmp    801c27 <__umoddi3+0xb3>
