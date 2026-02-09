
obj/user/ef_tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 60 01 00 00       	call   800196 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003e:	a1 20 50 80 00       	mov    0x805020,%eax
  800043:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800049:	a1 20 50 80 00       	mov    0x805020,%eax
  80004e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 20 38 80 00       	push   $0x803820
  800060:	6a 0b                	push   $0xb
  800062:	68 3c 38 80 00       	push   $0x80383c
  800067:	e8 da 02 00 00       	call   800346 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006c:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	z = sget(sys_getparentenvid(),"z");
  800073:	e8 aa 24 00 00       	call   802522 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 5c 38 80 00       	push   $0x80385c
  800080:	50                   	push   %eax
  800081:	e8 f9 1f 00 00       	call   80207f <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	inctst(); //to indicate that the shared object is taken
  80008c:	e8 b6 25 00 00       	call   802647 <inctst>
	cprintf("Slave B2 env used z (getSharedObject)\n");
  800091:	83 ec 0c             	sub    $0xc,%esp
  800094:	68 60 38 80 00       	push   $0x803860
  800099:	e8 96 05 00 00       	call   800634 <cprintf>
  80009e:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 88 38 80 00       	push   $0x803888
  8000a9:	e8 86 05 00 00       	call   800634 <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 28 23 00 00       	push   $0x2328
  8000b9:	e8 2f 34 00 00       	call   8034ed <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=5) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 9a 25 00 00       	call   802661 <gettst>
  8000c7:	83 f8 05             	cmp    $0x5,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	sys_lock_cons(); //critical section to ensure it's executed at atomically
  8000cc:	e8 bf 21 00 00       	call   802290 <sys_lock_cons>
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000d1:	e8 6a 22 00 00       	call   802340 <sys_calculate_free_frames>
  8000d6:	89 45 ec             	mov    %eax,-0x14(%ebp)

		sfree(z);
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8000df:	e8 20 21 00 00       	call   802204 <sfree>
  8000e4:	83 c4 10             	add    $0x10,%esp
		cprintf("Slave B2 env removed z\n");
  8000e7:	83 ec 0c             	sub    $0xc,%esp
  8000ea:	68 a8 38 80 00       	push   $0x8038a8
  8000ef:	e8 40 05 00 00       	call   800634 <cprintf>
  8000f4:	83 c4 10             	add    $0x10,%esp

		expected = 2+1; /*2pages+1table*/
  8000f7:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%ebp)
		if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal %d !, Expected:\nfrom the env: 1 table and 2 for frames of z\nframes_storage of z: should be cleared now\n", expected);
  8000fe:	e8 3d 22 00 00       	call   802340 <sys_calculate_free_frames>
  800103:	89 c2                	mov    %eax,%edx
  800105:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800108:	29 c2                	sub    %eax,%edx
  80010a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80010d:	39 c2                	cmp    %eax,%edx
  80010f:	74 14                	je     800125 <_main+0xed>
  800111:	ff 75 e8             	pushl  -0x18(%ebp)
  800114:	68 c0 38 80 00       	push   $0x8038c0
  800119:	6a 29                	push   $0x29
  80011b:	68 3c 38 80 00       	push   $0x80383c
  800120:	e8 21 02 00 00       	call   800346 <_panic>
	}
	sys_unlock_cons();
  800125:	e8 80 21 00 00       	call   8022aa <sys_unlock_cons>
	//To indicate that it's completed successfully
	inctst();
  80012a:	e8 18 25 00 00       	call   802647 <inctst>

	//to ensure that the other environments completed successfully
	while (gettst()!=7) ;// panic("test failed");
  80012f:	90                   	nop
  800130:	e8 2c 25 00 00       	call   802661 <gettst>
  800135:	83 f8 07             	cmp    $0x7,%eax
  800138:	75 f6                	jne    800130 <_main+0xf8>

	cprintf("Step B is finished!!\n\n\n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 50 39 80 00       	push   $0x803950
  800142:	e8 ed 04 00 00       	call   800634 <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
	cprintf("Test of freeSharedObjects [5] is finished!!\n\n\n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 68 39 80 00       	push   $0x803968
  800152:	e8 dd 04 00 00       	call   800634 <cprintf>
  800157:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80015a:	e8 c3 23 00 00       	call   802522 <sys_getparentenvid>
  80015f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(parentenvID > 0)
  800162:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800166:	7e 2b                	jle    800193 <_main+0x15b>
	{
		//Get the check-finishing counter
		int *finish = NULL;
  800168:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		finish = sget(parentenvID, "finish_children") ;
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	68 97 39 80 00       	push   $0x803997
  800177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80017a:	e8 00 1f 00 00       	call   80207f <sget>
  80017f:	83 c4 10             	add    $0x10,%esp
  800182:	89 45 e0             	mov    %eax,-0x20(%ebp)
		(*finish)++ ;
  800185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800188:	8b 00                	mov    (%eax),%eax
  80018a:	8d 50 01             	lea    0x1(%eax),%edx
  80018d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800190:	89 10                	mov    %edx,(%eax)
	}
	return;
  800192:	90                   	nop
  800193:	90                   	nop
}
  800194:	c9                   	leave  
  800195:	c3                   	ret    

00800196 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	57                   	push   %edi
  80019a:	56                   	push   %esi
  80019b:	53                   	push   %ebx
  80019c:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80019f:	e8 65 23 00 00       	call   802509 <sys_getenvindex>
  8001a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001aa:	89 d0                	mov    %edx,%eax
  8001ac:	01 c0                	add    %eax,%eax
  8001ae:	01 d0                	add    %edx,%eax
  8001b0:	c1 e0 02             	shl    $0x2,%eax
  8001b3:	01 d0                	add    %edx,%eax
  8001b5:	c1 e0 02             	shl    $0x2,%eax
  8001b8:	01 d0                	add    %edx,%eax
  8001ba:	c1 e0 03             	shl    $0x3,%eax
  8001bd:	01 d0                	add    %edx,%eax
  8001bf:	c1 e0 02             	shl    $0x2,%eax
  8001c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c7:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d1:	8a 40 20             	mov    0x20(%eax),%al
  8001d4:	84 c0                	test   %al,%al
  8001d6:	74 0d                	je     8001e5 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8001d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8001dd:	83 c0 20             	add    $0x20,%eax
  8001e0:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e9:	7e 0a                	jle    8001f5 <libmain+0x5f>
		binaryname = argv[0];
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	8b 00                	mov    (%eax),%eax
  8001f0:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	ff 75 0c             	pushl  0xc(%ebp)
  8001fb:	ff 75 08             	pushl  0x8(%ebp)
  8001fe:	e8 35 fe ff ff       	call   800038 <_main>
  800203:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800206:	a1 00 50 80 00       	mov    0x805000,%eax
  80020b:	85 c0                	test   %eax,%eax
  80020d:	0f 84 01 01 00 00    	je     800314 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800213:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800219:	bb a0 3a 80 00       	mov    $0x803aa0,%ebx
  80021e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800223:	89 c7                	mov    %eax,%edi
  800225:	89 de                	mov    %ebx,%esi
  800227:	89 d1                	mov    %edx,%ecx
  800229:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80022b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80022e:	b9 56 00 00 00       	mov    $0x56,%ecx
  800233:	b0 00                	mov    $0x0,%al
  800235:	89 d7                	mov    %edx,%edi
  800237:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800239:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800240:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	50                   	push   %eax
  800247:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80024d:	50                   	push   %eax
  80024e:	e8 ec 24 00 00       	call   80273f <sys_utilities>
  800253:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800256:	e8 35 20 00 00       	call   802290 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 c0 39 80 00       	push   $0x8039c0
  800263:	e8 cc 03 00 00       	call   800634 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80026b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80026e:	85 c0                	test   %eax,%eax
  800270:	74 18                	je     80028a <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800272:	e8 e6 24 00 00       	call   80275d <sys_get_optimal_num_faults>
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	50                   	push   %eax
  80027b:	68 e8 39 80 00       	push   $0x8039e8
  800280:	e8 af 03 00 00       	call   800634 <cprintf>
  800285:	83 c4 10             	add    $0x10,%esp
  800288:	eb 59                	jmp    8002e3 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80028a:	a1 20 50 80 00       	mov    0x805020,%eax
  80028f:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800295:	a1 20 50 80 00       	mov    0x805020,%eax
  80029a:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8002a0:	83 ec 04             	sub    $0x4,%esp
  8002a3:	52                   	push   %edx
  8002a4:	50                   	push   %eax
  8002a5:	68 0c 3a 80 00       	push   $0x803a0c
  8002aa:	e8 85 03 00 00       	call   800634 <cprintf>
  8002af:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b7:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8002bd:	a1 20 50 80 00       	mov    0x805020,%eax
  8002c2:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8002c8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002cd:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8002d3:	51                   	push   %ecx
  8002d4:	52                   	push   %edx
  8002d5:	50                   	push   %eax
  8002d6:	68 34 3a 80 00       	push   $0x803a34
  8002db:	e8 54 03 00 00       	call   800634 <cprintf>
  8002e0:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e8:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	50                   	push   %eax
  8002f2:	68 8c 3a 80 00       	push   $0x803a8c
  8002f7:	e8 38 03 00 00       	call   800634 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002ff:	83 ec 0c             	sub    $0xc,%esp
  800302:	68 c0 39 80 00       	push   $0x8039c0
  800307:	e8 28 03 00 00       	call   800634 <cprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80030f:	e8 96 1f 00 00       	call   8022aa <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800314:	e8 1f 00 00 00       	call   800338 <exit>
}
  800319:	90                   	nop
  80031a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031d:	5b                   	pop    %ebx
  80031e:	5e                   	pop    %esi
  80031f:	5f                   	pop    %edi
  800320:	5d                   	pop    %ebp
  800321:	c3                   	ret    

00800322 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	6a 00                	push   $0x0
  80032d:	e8 a3 21 00 00       	call   8024d5 <sys_destroy_env>
  800332:	83 c4 10             	add    $0x10,%esp
}
  800335:	90                   	nop
  800336:	c9                   	leave  
  800337:	c3                   	ret    

00800338 <exit>:

void
exit(void)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80033e:	e8 f8 21 00 00       	call   80253b <sys_exit_env>
}
  800343:	90                   	nop
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80034c:	8d 45 10             	lea    0x10(%ebp),%eax
  80034f:	83 c0 04             	add    $0x4,%eax
  800352:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800355:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80035a:	85 c0                	test   %eax,%eax
  80035c:	74 16                	je     800374 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80035e:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800363:	83 ec 08             	sub    $0x8,%esp
  800366:	50                   	push   %eax
  800367:	68 04 3b 80 00       	push   $0x803b04
  80036c:	e8 c3 02 00 00       	call   800634 <cprintf>
  800371:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800374:	a1 04 50 80 00       	mov    0x805004,%eax
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	ff 75 0c             	pushl  0xc(%ebp)
  80037f:	ff 75 08             	pushl  0x8(%ebp)
  800382:	50                   	push   %eax
  800383:	68 0c 3b 80 00       	push   $0x803b0c
  800388:	6a 74                	push   $0x74
  80038a:	e8 d2 02 00 00       	call   800661 <cprintf_colored>
  80038f:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800392:	8b 45 10             	mov    0x10(%ebp),%eax
  800395:	83 ec 08             	sub    $0x8,%esp
  800398:	ff 75 f4             	pushl  -0xc(%ebp)
  80039b:	50                   	push   %eax
  80039c:	e8 24 02 00 00       	call   8005c5 <vcprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	6a 00                	push   $0x0
  8003a9:	68 34 3b 80 00       	push   $0x803b34
  8003ae:	e8 12 02 00 00       	call   8005c5 <vcprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003b6:	e8 7d ff ff ff       	call   800338 <exit>

	// should not return here
	while (1) ;
  8003bb:	eb fe                	jmp    8003bb <_panic+0x75>

008003bd <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	53                   	push   %ebx
  8003c1:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8003c9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d2:	39 c2                	cmp    %eax,%edx
  8003d4:	74 14                	je     8003ea <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003d6:	83 ec 04             	sub    $0x4,%esp
  8003d9:	68 38 3b 80 00       	push   $0x803b38
  8003de:	6a 26                	push   $0x26
  8003e0:	68 84 3b 80 00       	push   $0x803b84
  8003e5:	e8 5c ff ff ff       	call   800346 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003f8:	e9 d9 00 00 00       	jmp    8004d6 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8003fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800400:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800407:	8b 45 08             	mov    0x8(%ebp),%eax
  80040a:	01 d0                	add    %edx,%eax
  80040c:	8b 00                	mov    (%eax),%eax
  80040e:	85 c0                	test   %eax,%eax
  800410:	75 08                	jne    80041a <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800412:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800415:	e9 b9 00 00 00       	jmp    8004d3 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80041a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800421:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800428:	eb 79                	jmp    8004a3 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80042a:	a1 20 50 80 00       	mov    0x805020,%eax
  80042f:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800435:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800438:	89 d0                	mov    %edx,%eax
  80043a:	01 c0                	add    %eax,%eax
  80043c:	01 d0                	add    %edx,%eax
  80043e:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800445:	01 d8                	add    %ebx,%eax
  800447:	01 d0                	add    %edx,%eax
  800449:	01 c8                	add    %ecx,%eax
  80044b:	8a 40 04             	mov    0x4(%eax),%al
  80044e:	84 c0                	test   %al,%al
  800450:	75 4e                	jne    8004a0 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800452:	a1 20 50 80 00       	mov    0x805020,%eax
  800457:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80045d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800460:	89 d0                	mov    %edx,%eax
  800462:	01 c0                	add    %eax,%eax
  800464:	01 d0                	add    %edx,%eax
  800466:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80046d:	01 d8                	add    %ebx,%eax
  80046f:	01 d0                	add    %edx,%eax
  800471:	01 c8                	add    %ecx,%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800478:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80047b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800480:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800485:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80048c:	8b 45 08             	mov    0x8(%ebp),%eax
  80048f:	01 c8                	add    %ecx,%eax
  800491:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800493:	39 c2                	cmp    %eax,%edx
  800495:	75 09                	jne    8004a0 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800497:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80049e:	eb 19                	jmp    8004b9 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a0:	ff 45 e8             	incl   -0x18(%ebp)
  8004a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004b1:	39 c2                	cmp    %eax,%edx
  8004b3:	0f 87 71 ff ff ff    	ja     80042a <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004bd:	75 14                	jne    8004d3 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8004bf:	83 ec 04             	sub    $0x4,%esp
  8004c2:	68 90 3b 80 00       	push   $0x803b90
  8004c7:	6a 3a                	push   $0x3a
  8004c9:	68 84 3b 80 00       	push   $0x803b84
  8004ce:	e8 73 fe ff ff       	call   800346 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004d3:	ff 45 f0             	incl   -0x10(%ebp)
  8004d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004dc:	0f 8c 1b ff ff ff    	jl     8003fd <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004f0:	eb 2e                	jmp    800520 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f7:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8004fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800500:	89 d0                	mov    %edx,%eax
  800502:	01 c0                	add    %eax,%eax
  800504:	01 d0                	add    %edx,%eax
  800506:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80050d:	01 d8                	add    %ebx,%eax
  80050f:	01 d0                	add    %edx,%eax
  800511:	01 c8                	add    %ecx,%eax
  800513:	8a 40 04             	mov    0x4(%eax),%al
  800516:	3c 01                	cmp    $0x1,%al
  800518:	75 03                	jne    80051d <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  80051a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80051d:	ff 45 e0             	incl   -0x20(%ebp)
  800520:	a1 20 50 80 00       	mov    0x805020,%eax
  800525:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80052b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052e:	39 c2                	cmp    %eax,%edx
  800530:	77 c0                	ja     8004f2 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800535:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800538:	74 14                	je     80054e <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  80053a:	83 ec 04             	sub    $0x4,%esp
  80053d:	68 e4 3b 80 00       	push   $0x803be4
  800542:	6a 44                	push   $0x44
  800544:	68 84 3b 80 00       	push   $0x803b84
  800549:	e8 f8 fd ff ff       	call   800346 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80054e:	90                   	nop
  80054f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800552:	c9                   	leave  
  800553:	c3                   	ret    

00800554 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800554:	55                   	push   %ebp
  800555:	89 e5                	mov    %esp,%ebp
  800557:	53                   	push   %ebx
  800558:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80055b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	8d 48 01             	lea    0x1(%eax),%ecx
  800563:	8b 55 0c             	mov    0xc(%ebp),%edx
  800566:	89 0a                	mov    %ecx,(%edx)
  800568:	8b 55 08             	mov    0x8(%ebp),%edx
  80056b:	88 d1                	mov    %dl,%cl
  80056d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800570:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800574:	8b 45 0c             	mov    0xc(%ebp),%eax
  800577:	8b 00                	mov    (%eax),%eax
  800579:	3d ff 00 00 00       	cmp    $0xff,%eax
  80057e:	75 30                	jne    8005b0 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800580:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800586:	a0 44 50 80 00       	mov    0x805044,%al
  80058b:	0f b6 c0             	movzbl %al,%eax
  80058e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800591:	8b 09                	mov    (%ecx),%ecx
  800593:	89 cb                	mov    %ecx,%ebx
  800595:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800598:	83 c1 08             	add    $0x8,%ecx
  80059b:	52                   	push   %edx
  80059c:	50                   	push   %eax
  80059d:	53                   	push   %ebx
  80059e:	51                   	push   %ecx
  80059f:	e8 a8 1c 00 00       	call   80224c <sys_cputs>
  8005a4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b3:	8b 40 04             	mov    0x4(%eax),%eax
  8005b6:	8d 50 01             	lea    0x1(%eax),%edx
  8005b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005bf:	90                   	nop
  8005c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005c3:	c9                   	leave  
  8005c4:	c3                   	ret    

008005c5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005c5:	55                   	push   %ebp
  8005c6:	89 e5                	mov    %esp,%ebp
  8005c8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005ce:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005d5:	00 00 00 
	b.cnt = 0;
  8005d8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005df:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ee:	50                   	push   %eax
  8005ef:	68 54 05 80 00       	push   $0x800554
  8005f4:	e8 5a 02 00 00       	call   800853 <vprintfmt>
  8005f9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8005fc:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800602:	a0 44 50 80 00       	mov    0x805044,%al
  800607:	0f b6 c0             	movzbl %al,%eax
  80060a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800610:	52                   	push   %edx
  800611:	50                   	push   %eax
  800612:	51                   	push   %ecx
  800613:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800619:	83 c0 08             	add    $0x8,%eax
  80061c:	50                   	push   %eax
  80061d:	e8 2a 1c 00 00       	call   80224c <sys_cputs>
  800622:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800625:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  80062c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800632:	c9                   	leave  
  800633:	c3                   	ret    

00800634 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80063a:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800641:	8d 45 0c             	lea    0xc(%ebp),%eax
  800644:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 f4             	pushl  -0xc(%ebp)
  800650:	50                   	push   %eax
  800651:	e8 6f ff ff ff       	call   8005c5 <vcprintf>
  800656:	83 c4 10             	add    $0x10,%esp
  800659:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80065c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80065f:	c9                   	leave  
  800660:	c3                   	ret    

00800661 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800661:	55                   	push   %ebp
  800662:	89 e5                	mov    %esp,%ebp
  800664:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800667:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	c1 e0 08             	shl    $0x8,%eax
  800674:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800679:	8d 45 0c             	lea    0xc(%ebp),%eax
  80067c:	83 c0 04             	add    $0x4,%eax
  80067f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800682:	8b 45 0c             	mov    0xc(%ebp),%eax
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	ff 75 f4             	pushl  -0xc(%ebp)
  80068b:	50                   	push   %eax
  80068c:	e8 34 ff ff ff       	call   8005c5 <vcprintf>
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800697:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  80069e:	07 00 00 

	return cnt;
  8006a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006a4:	c9                   	leave  
  8006a5:	c3                   	ret    

008006a6 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
  8006a9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006ac:	e8 df 1b 00 00       	call   802290 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006b1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	83 ec 08             	sub    $0x8,%esp
  8006bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c0:	50                   	push   %eax
  8006c1:	e8 ff fe ff ff       	call   8005c5 <vcprintf>
  8006c6:	83 c4 10             	add    $0x10,%esp
  8006c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006cc:	e8 d9 1b 00 00       	call   8022aa <sys_unlock_cons>
	return cnt;
  8006d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d4:	c9                   	leave  
  8006d5:	c3                   	ret    

008006d6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006d6:	55                   	push   %ebp
  8006d7:	89 e5                	mov    %esp,%ebp
  8006d9:	53                   	push   %ebx
  8006da:	83 ec 14             	sub    $0x14,%esp
  8006dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006e9:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006f4:	77 55                	ja     80074b <printnum+0x75>
  8006f6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006f9:	72 05                	jb     800700 <printnum+0x2a>
  8006fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006fe:	77 4b                	ja     80074b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800700:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800703:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800706:	8b 45 18             	mov    0x18(%ebp),%eax
  800709:	ba 00 00 00 00       	mov    $0x0,%edx
  80070e:	52                   	push   %edx
  80070f:	50                   	push   %eax
  800710:	ff 75 f4             	pushl  -0xc(%ebp)
  800713:	ff 75 f0             	pushl  -0x10(%ebp)
  800716:	e8 91 2e 00 00       	call   8035ac <__udivdi3>
  80071b:	83 c4 10             	add    $0x10,%esp
  80071e:	83 ec 04             	sub    $0x4,%esp
  800721:	ff 75 20             	pushl  0x20(%ebp)
  800724:	53                   	push   %ebx
  800725:	ff 75 18             	pushl  0x18(%ebp)
  800728:	52                   	push   %edx
  800729:	50                   	push   %eax
  80072a:	ff 75 0c             	pushl  0xc(%ebp)
  80072d:	ff 75 08             	pushl  0x8(%ebp)
  800730:	e8 a1 ff ff ff       	call   8006d6 <printnum>
  800735:	83 c4 20             	add    $0x20,%esp
  800738:	eb 1a                	jmp    800754 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	ff 75 0c             	pushl  0xc(%ebp)
  800740:	ff 75 20             	pushl  0x20(%ebp)
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	ff d0                	call   *%eax
  800748:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80074b:	ff 4d 1c             	decl   0x1c(%ebp)
  80074e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800752:	7f e6                	jg     80073a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800754:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800757:	bb 00 00 00 00       	mov    $0x0,%ebx
  80075c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80075f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800762:	53                   	push   %ebx
  800763:	51                   	push   %ecx
  800764:	52                   	push   %edx
  800765:	50                   	push   %eax
  800766:	e8 51 2f 00 00       	call   8036bc <__umoddi3>
  80076b:	83 c4 10             	add    $0x10,%esp
  80076e:	05 54 3e 80 00       	add    $0x803e54,%eax
  800773:	8a 00                	mov    (%eax),%al
  800775:	0f be c0             	movsbl %al,%eax
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	ff 75 0c             	pushl  0xc(%ebp)
  80077e:	50                   	push   %eax
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	ff d0                	call   *%eax
  800784:	83 c4 10             	add    $0x10,%esp
}
  800787:	90                   	nop
  800788:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800790:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800794:	7e 1c                	jle    8007b2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  8007b0:	eb 40                	jmp    8007f2 <getuint+0x65>
	else if (lflag)
  8007b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007b6:	74 1e                	je     8007d6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	8b 00                	mov    (%eax),%eax
  8007bd:	8d 50 04             	lea    0x4(%eax),%edx
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	89 10                	mov    %edx,(%eax)
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	83 e8 04             	sub    $0x4,%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d4:	eb 1c                	jmp    8007f2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	8d 50 04             	lea    0x4(%eax),%edx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	89 10                	mov    %edx,(%eax)
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	8b 00                	mov    (%eax),%eax
  8007e8:	83 e8 04             	sub    $0x4,%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007f2:	5d                   	pop    %ebp
  8007f3:	c3                   	ret    

008007f4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007f4:	55                   	push   %ebp
  8007f5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007f7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007fb:	7e 1c                	jle    800819 <getint+0x25>
		return va_arg(*ap, long long);
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	8b 00                	mov    (%eax),%eax
  800802:	8d 50 08             	lea    0x8(%eax),%edx
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	89 10                	mov    %edx,(%eax)
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	83 e8 08             	sub    $0x8,%eax
  800812:	8b 50 04             	mov    0x4(%eax),%edx
  800815:	8b 00                	mov    (%eax),%eax
  800817:	eb 38                	jmp    800851 <getint+0x5d>
	else if (lflag)
  800819:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80081d:	74 1a                	je     800839 <getint+0x45>
		return va_arg(*ap, long);
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	8d 50 04             	lea    0x4(%eax),%edx
  800827:	8b 45 08             	mov    0x8(%ebp),%eax
  80082a:	89 10                	mov    %edx,(%eax)
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	83 e8 04             	sub    $0x4,%eax
  800834:	8b 00                	mov    (%eax),%eax
  800836:	99                   	cltd   
  800837:	eb 18                	jmp    800851 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	8d 50 04             	lea    0x4(%eax),%edx
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	89 10                	mov    %edx,(%eax)
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	83 e8 04             	sub    $0x4,%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	99                   	cltd   
}
  800851:	5d                   	pop    %ebp
  800852:	c3                   	ret    

00800853 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	56                   	push   %esi
  800857:	53                   	push   %ebx
  800858:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80085b:	eb 17                	jmp    800874 <vprintfmt+0x21>
			if (ch == '\0')
  80085d:	85 db                	test   %ebx,%ebx
  80085f:	0f 84 c1 03 00 00    	je     800c26 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	53                   	push   %ebx
  80086c:	8b 45 08             	mov    0x8(%ebp),%eax
  80086f:	ff d0                	call   *%eax
  800871:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800874:	8b 45 10             	mov    0x10(%ebp),%eax
  800877:	8d 50 01             	lea    0x1(%eax),%edx
  80087a:	89 55 10             	mov    %edx,0x10(%ebp)
  80087d:	8a 00                	mov    (%eax),%al
  80087f:	0f b6 d8             	movzbl %al,%ebx
  800882:	83 fb 25             	cmp    $0x25,%ebx
  800885:	75 d6                	jne    80085d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800887:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80088b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800892:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800899:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008a0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008aa:	8d 50 01             	lea    0x1(%eax),%edx
  8008ad:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b0:	8a 00                	mov    (%eax),%al
  8008b2:	0f b6 d8             	movzbl %al,%ebx
  8008b5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008b8:	83 f8 5b             	cmp    $0x5b,%eax
  8008bb:	0f 87 3d 03 00 00    	ja     800bfe <vprintfmt+0x3ab>
  8008c1:	8b 04 85 78 3e 80 00 	mov    0x803e78(,%eax,4),%eax
  8008c8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008ca:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008ce:	eb d7                	jmp    8008a7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008d0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008d4:	eb d1                	jmp    8008a7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008e0:	89 d0                	mov    %edx,%eax
  8008e2:	c1 e0 02             	shl    $0x2,%eax
  8008e5:	01 d0                	add    %edx,%eax
  8008e7:	01 c0                	add    %eax,%eax
  8008e9:	01 d8                	add    %ebx,%eax
  8008eb:	83 e8 30             	sub    $0x30,%eax
  8008ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f4:	8a 00                	mov    (%eax),%al
  8008f6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008f9:	83 fb 2f             	cmp    $0x2f,%ebx
  8008fc:	7e 3e                	jle    80093c <vprintfmt+0xe9>
  8008fe:	83 fb 39             	cmp    $0x39,%ebx
  800901:	7f 39                	jg     80093c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800903:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800906:	eb d5                	jmp    8008dd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800908:	8b 45 14             	mov    0x14(%ebp),%eax
  80090b:	83 c0 04             	add    $0x4,%eax
  80090e:	89 45 14             	mov    %eax,0x14(%ebp)
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	83 e8 04             	sub    $0x4,%eax
  800917:	8b 00                	mov    (%eax),%eax
  800919:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80091c:	eb 1f                	jmp    80093d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80091e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800922:	79 83                	jns    8008a7 <vprintfmt+0x54>
				width = 0;
  800924:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80092b:	e9 77 ff ff ff       	jmp    8008a7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800930:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800937:	e9 6b ff ff ff       	jmp    8008a7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80093c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80093d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800941:	0f 89 60 ff ff ff    	jns    8008a7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800947:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80094a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80094d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800954:	e9 4e ff ff ff       	jmp    8008a7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800959:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80095c:	e9 46 ff ff ff       	jmp    8008a7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	83 c0 04             	add    $0x4,%eax
  800967:	89 45 14             	mov    %eax,0x14(%ebp)
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	83 e8 04             	sub    $0x4,%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	50                   	push   %eax
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	ff d0                	call   *%eax
  80097e:	83 c4 10             	add    $0x10,%esp
			break;
  800981:	e9 9b 02 00 00       	jmp    800c21 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800986:	8b 45 14             	mov    0x14(%ebp),%eax
  800989:	83 c0 04             	add    $0x4,%eax
  80098c:	89 45 14             	mov    %eax,0x14(%ebp)
  80098f:	8b 45 14             	mov    0x14(%ebp),%eax
  800992:	83 e8 04             	sub    $0x4,%eax
  800995:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800997:	85 db                	test   %ebx,%ebx
  800999:	79 02                	jns    80099d <vprintfmt+0x14a>
				err = -err;
  80099b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80099d:	83 fb 64             	cmp    $0x64,%ebx
  8009a0:	7f 0b                	jg     8009ad <vprintfmt+0x15a>
  8009a2:	8b 34 9d c0 3c 80 00 	mov    0x803cc0(,%ebx,4),%esi
  8009a9:	85 f6                	test   %esi,%esi
  8009ab:	75 19                	jne    8009c6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ad:	53                   	push   %ebx
  8009ae:	68 65 3e 80 00       	push   $0x803e65
  8009b3:	ff 75 0c             	pushl  0xc(%ebp)
  8009b6:	ff 75 08             	pushl  0x8(%ebp)
  8009b9:	e8 70 02 00 00       	call   800c2e <printfmt>
  8009be:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009c1:	e9 5b 02 00 00       	jmp    800c21 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009c6:	56                   	push   %esi
  8009c7:	68 6e 3e 80 00       	push   $0x803e6e
  8009cc:	ff 75 0c             	pushl  0xc(%ebp)
  8009cf:	ff 75 08             	pushl  0x8(%ebp)
  8009d2:	e8 57 02 00 00       	call   800c2e <printfmt>
  8009d7:	83 c4 10             	add    $0x10,%esp
			break;
  8009da:	e9 42 02 00 00       	jmp    800c21 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009df:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e2:	83 c0 04             	add    $0x4,%eax
  8009e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009eb:	83 e8 04             	sub    $0x4,%eax
  8009ee:	8b 30                	mov    (%eax),%esi
  8009f0:	85 f6                	test   %esi,%esi
  8009f2:	75 05                	jne    8009f9 <vprintfmt+0x1a6>
				p = "(null)";
  8009f4:	be 71 3e 80 00       	mov    $0x803e71,%esi
			if (width > 0 && padc != '-')
  8009f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fd:	7e 6d                	jle    800a6c <vprintfmt+0x219>
  8009ff:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a03:	74 67                	je     800a6c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a08:	83 ec 08             	sub    $0x8,%esp
  800a0b:	50                   	push   %eax
  800a0c:	56                   	push   %esi
  800a0d:	e8 1e 03 00 00       	call   800d30 <strnlen>
  800a12:	83 c4 10             	add    $0x10,%esp
  800a15:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a18:	eb 16                	jmp    800a30 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a1a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	50                   	push   %eax
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a2d:	ff 4d e4             	decl   -0x1c(%ebp)
  800a30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a34:	7f e4                	jg     800a1a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a36:	eb 34                	jmp    800a6c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a38:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a3c:	74 1c                	je     800a5a <vprintfmt+0x207>
  800a3e:	83 fb 1f             	cmp    $0x1f,%ebx
  800a41:	7e 05                	jle    800a48 <vprintfmt+0x1f5>
  800a43:	83 fb 7e             	cmp    $0x7e,%ebx
  800a46:	7e 12                	jle    800a5a <vprintfmt+0x207>
					putch('?', putdat);
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	ff 75 0c             	pushl  0xc(%ebp)
  800a4e:	6a 3f                	push   $0x3f
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	ff d0                	call   *%eax
  800a55:	83 c4 10             	add    $0x10,%esp
  800a58:	eb 0f                	jmp    800a69 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a5a:	83 ec 08             	sub    $0x8,%esp
  800a5d:	ff 75 0c             	pushl  0xc(%ebp)
  800a60:	53                   	push   %ebx
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	ff d0                	call   *%eax
  800a66:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a69:	ff 4d e4             	decl   -0x1c(%ebp)
  800a6c:	89 f0                	mov    %esi,%eax
  800a6e:	8d 70 01             	lea    0x1(%eax),%esi
  800a71:	8a 00                	mov    (%eax),%al
  800a73:	0f be d8             	movsbl %al,%ebx
  800a76:	85 db                	test   %ebx,%ebx
  800a78:	74 24                	je     800a9e <vprintfmt+0x24b>
  800a7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a7e:	78 b8                	js     800a38 <vprintfmt+0x1e5>
  800a80:	ff 4d e0             	decl   -0x20(%ebp)
  800a83:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a87:	79 af                	jns    800a38 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a89:	eb 13                	jmp    800a9e <vprintfmt+0x24b>
				putch(' ', putdat);
  800a8b:	83 ec 08             	sub    $0x8,%esp
  800a8e:	ff 75 0c             	pushl  0xc(%ebp)
  800a91:	6a 20                	push   $0x20
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	ff d0                	call   *%eax
  800a98:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a9b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa2:	7f e7                	jg     800a8b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800aa4:	e9 78 01 00 00       	jmp    800c21 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 e8             	pushl  -0x18(%ebp)
  800aaf:	8d 45 14             	lea    0x14(%ebp),%eax
  800ab2:	50                   	push   %eax
  800ab3:	e8 3c fd ff ff       	call   8007f4 <getint>
  800ab8:	83 c4 10             	add    $0x10,%esp
  800abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800abe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac7:	85 d2                	test   %edx,%edx
  800ac9:	79 23                	jns    800aee <vprintfmt+0x29b>
				putch('-', putdat);
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	ff 75 0c             	pushl  0xc(%ebp)
  800ad1:	6a 2d                	push   $0x2d
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	ff d0                	call   *%eax
  800ad8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ade:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ae1:	f7 d8                	neg    %eax
  800ae3:	83 d2 00             	adc    $0x0,%edx
  800ae6:	f7 da                	neg    %edx
  800ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aeb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800af5:	e9 bc 00 00 00       	jmp    800bb6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 e8             	pushl  -0x18(%ebp)
  800b00:	8d 45 14             	lea    0x14(%ebp),%eax
  800b03:	50                   	push   %eax
  800b04:	e8 84 fc ff ff       	call   80078d <getuint>
  800b09:	83 c4 10             	add    $0x10,%esp
  800b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b19:	e9 98 00 00 00       	jmp    800bb6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	6a 58                	push   $0x58
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	6a 58                	push   $0x58
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	6a 58                	push   $0x58
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	ff d0                	call   *%eax
  800b4b:	83 c4 10             	add    $0x10,%esp
			break;
  800b4e:	e9 ce 00 00 00       	jmp    800c21 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	6a 30                	push   $0x30
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	ff d0                	call   *%eax
  800b60:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b63:	83 ec 08             	sub    $0x8,%esp
  800b66:	ff 75 0c             	pushl  0xc(%ebp)
  800b69:	6a 78                	push   $0x78
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	ff d0                	call   *%eax
  800b70:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b73:	8b 45 14             	mov    0x14(%ebp),%eax
  800b76:	83 c0 04             	add    $0x4,%eax
  800b79:	89 45 14             	mov    %eax,0x14(%ebp)
  800b7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7f:	83 e8 04             	sub    $0x4,%eax
  800b82:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b8e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b95:	eb 1f                	jmp    800bb6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b97:	83 ec 08             	sub    $0x8,%esp
  800b9a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b9d:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba0:	50                   	push   %eax
  800ba1:	e8 e7 fb ff ff       	call   80078d <getuint>
  800ba6:	83 c4 10             	add    $0x10,%esp
  800ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800baf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bb6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbd:	83 ec 04             	sub    $0x4,%esp
  800bc0:	52                   	push   %edx
  800bc1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bc4:	50                   	push   %eax
  800bc5:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc8:	ff 75 f0             	pushl  -0x10(%ebp)
  800bcb:	ff 75 0c             	pushl  0xc(%ebp)
  800bce:	ff 75 08             	pushl  0x8(%ebp)
  800bd1:	e8 00 fb ff ff       	call   8006d6 <printnum>
  800bd6:	83 c4 20             	add    $0x20,%esp
			break;
  800bd9:	eb 46                	jmp    800c21 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bdb:	83 ec 08             	sub    $0x8,%esp
  800bde:	ff 75 0c             	pushl  0xc(%ebp)
  800be1:	53                   	push   %ebx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	ff d0                	call   *%eax
  800be7:	83 c4 10             	add    $0x10,%esp
			break;
  800bea:	eb 35                	jmp    800c21 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800bec:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800bf3:	eb 2c                	jmp    800c21 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bf5:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800bfc:	eb 23                	jmp    800c21 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bfe:	83 ec 08             	sub    $0x8,%esp
  800c01:	ff 75 0c             	pushl  0xc(%ebp)
  800c04:	6a 25                	push   $0x25
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	ff d0                	call   *%eax
  800c0b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c0e:	ff 4d 10             	decl   0x10(%ebp)
  800c11:	eb 03                	jmp    800c16 <vprintfmt+0x3c3>
  800c13:	ff 4d 10             	decl   0x10(%ebp)
  800c16:	8b 45 10             	mov    0x10(%ebp),%eax
  800c19:	48                   	dec    %eax
  800c1a:	8a 00                	mov    (%eax),%al
  800c1c:	3c 25                	cmp    $0x25,%al
  800c1e:	75 f3                	jne    800c13 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c20:	90                   	nop
		}
	}
  800c21:	e9 35 fc ff ff       	jmp    80085b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c26:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c27:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c2a:	5b                   	pop    %ebx
  800c2b:	5e                   	pop    %esi
  800c2c:	5d                   	pop    %ebp
  800c2d:	c3                   	ret    

00800c2e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c34:	8d 45 10             	lea    0x10(%ebp),%eax
  800c37:	83 c0 04             	add    $0x4,%eax
  800c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c40:	ff 75 f4             	pushl  -0xc(%ebp)
  800c43:	50                   	push   %eax
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	ff 75 08             	pushl  0x8(%ebp)
  800c4a:	e8 04 fc ff ff       	call   800853 <vprintfmt>
  800c4f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c52:	90                   	nop
  800c53:	c9                   	leave  
  800c54:	c3                   	ret    

00800c55 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5b:	8b 40 08             	mov    0x8(%eax),%eax
  800c5e:	8d 50 01             	lea    0x1(%eax),%edx
  800c61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c64:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6a:	8b 10                	mov    (%eax),%edx
  800c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6f:	8b 40 04             	mov    0x4(%eax),%eax
  800c72:	39 c2                	cmp    %eax,%edx
  800c74:	73 12                	jae    800c88 <sprintputch+0x33>
		*b->buf++ = ch;
  800c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c79:	8b 00                	mov    (%eax),%eax
  800c7b:	8d 48 01             	lea    0x1(%eax),%ecx
  800c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c81:	89 0a                	mov    %ecx,(%edx)
  800c83:	8b 55 08             	mov    0x8(%ebp),%edx
  800c86:	88 10                	mov    %dl,(%eax)
}
  800c88:	90                   	nop
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	01 d0                	add    %edx,%eax
  800ca2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cb0:	74 06                	je     800cb8 <vsnprintf+0x2d>
  800cb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb6:	7f 07                	jg     800cbf <vsnprintf+0x34>
		return -E_INVAL;
  800cb8:	b8 03 00 00 00       	mov    $0x3,%eax
  800cbd:	eb 20                	jmp    800cdf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cbf:	ff 75 14             	pushl  0x14(%ebp)
  800cc2:	ff 75 10             	pushl  0x10(%ebp)
  800cc5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cc8:	50                   	push   %eax
  800cc9:	68 55 0c 80 00       	push   $0x800c55
  800cce:	e8 80 fb ff ff       	call   800853 <vprintfmt>
  800cd3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cdf:	c9                   	leave  
  800ce0:	c3                   	ret    

00800ce1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ce7:	8d 45 10             	lea    0x10(%ebp),%eax
  800cea:	83 c0 04             	add    $0x4,%eax
  800ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cf0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf3:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf6:	50                   	push   %eax
  800cf7:	ff 75 0c             	pushl  0xc(%ebp)
  800cfa:	ff 75 08             	pushl  0x8(%ebp)
  800cfd:	e8 89 ff ff ff       	call   800c8b <vsnprintf>
  800d02:	83 c4 10             	add    $0x10,%esp
  800d05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d0b:	c9                   	leave  
  800d0c:	c3                   	ret    

00800d0d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d1a:	eb 06                	jmp    800d22 <strlen+0x15>
		n++;
  800d1c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d1f:	ff 45 08             	incl   0x8(%ebp)
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	84 c0                	test   %al,%al
  800d29:	75 f1                	jne    800d1c <strlen+0xf>
		n++;
	return n;
  800d2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d2e:	c9                   	leave  
  800d2f:	c3                   	ret    

00800d30 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3d:	eb 09                	jmp    800d48 <strnlen+0x18>
		n++;
  800d3f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d42:	ff 45 08             	incl   0x8(%ebp)
  800d45:	ff 4d 0c             	decl   0xc(%ebp)
  800d48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4c:	74 09                	je     800d57 <strnlen+0x27>
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	84 c0                	test   %al,%al
  800d55:	75 e8                	jne    800d3f <strnlen+0xf>
		n++;
	return n;
  800d57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d5a:	c9                   	leave  
  800d5b:	c3                   	ret    

00800d5c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d68:	90                   	nop
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8d 50 01             	lea    0x1(%eax),%edx
  800d6f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d75:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d78:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d7b:	8a 12                	mov    (%edx),%dl
  800d7d:	88 10                	mov    %dl,(%eax)
  800d7f:	8a 00                	mov    (%eax),%al
  800d81:	84 c0                	test   %al,%al
  800d83:	75 e4                	jne    800d69 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d85:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d88:	c9                   	leave  
  800d89:	c3                   	ret    

00800d8a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d9d:	eb 1f                	jmp    800dbe <strncpy+0x34>
		*dst++ = *src;
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	8d 50 01             	lea    0x1(%eax),%edx
  800da5:	89 55 08             	mov    %edx,0x8(%ebp)
  800da8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dab:	8a 12                	mov    (%edx),%dl
  800dad:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	84 c0                	test   %al,%al
  800db6:	74 03                	je     800dbb <strncpy+0x31>
			src++;
  800db8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dbb:	ff 45 fc             	incl   -0x4(%ebp)
  800dbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dc4:	72 d9                	jb     800d9f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dc9:	c9                   	leave  
  800dca:	c3                   	ret    

00800dcb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddb:	74 30                	je     800e0d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ddd:	eb 16                	jmp    800df5 <strlcpy+0x2a>
			*dst++ = *src++;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	8d 50 01             	lea    0x1(%eax),%edx
  800de5:	89 55 08             	mov    %edx,0x8(%ebp)
  800de8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800deb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dee:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800df1:	8a 12                	mov    (%edx),%dl
  800df3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800df5:	ff 4d 10             	decl   0x10(%ebp)
  800df8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfc:	74 09                	je     800e07 <strlcpy+0x3c>
  800dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	84 c0                	test   %al,%al
  800e05:	75 d8                	jne    800ddf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e13:	29 c2                	sub    %eax,%edx
  800e15:	89 d0                	mov    %edx,%eax
}
  800e17:	c9                   	leave  
  800e18:	c3                   	ret    

00800e19 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e1c:	eb 06                	jmp    800e24 <strcmp+0xb>
		p++, q++;
  800e1e:	ff 45 08             	incl   0x8(%ebp)
  800e21:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	84 c0                	test   %al,%al
  800e2b:	74 0e                	je     800e3b <strcmp+0x22>
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 10                	mov    (%eax),%dl
  800e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	38 c2                	cmp    %al,%dl
  800e39:	74 e3                	je     800e1e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	0f b6 d0             	movzbl %al,%edx
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	8a 00                	mov    (%eax),%al
  800e48:	0f b6 c0             	movzbl %al,%eax
  800e4b:	29 c2                	sub    %eax,%edx
  800e4d:	89 d0                	mov    %edx,%eax
}
  800e4f:	5d                   	pop    %ebp
  800e50:	c3                   	ret    

00800e51 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e54:	eb 09                	jmp    800e5f <strncmp+0xe>
		n--, p++, q++;
  800e56:	ff 4d 10             	decl   0x10(%ebp)
  800e59:	ff 45 08             	incl   0x8(%ebp)
  800e5c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e63:	74 17                	je     800e7c <strncmp+0x2b>
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	84 c0                	test   %al,%al
  800e6c:	74 0e                	je     800e7c <strncmp+0x2b>
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	8a 10                	mov    (%eax),%dl
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	38 c2                	cmp    %al,%dl
  800e7a:	74 da                	je     800e56 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e80:	75 07                	jne    800e89 <strncmp+0x38>
		return 0;
  800e82:	b8 00 00 00 00       	mov    $0x0,%eax
  800e87:	eb 14                	jmp    800e9d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 d0             	movzbl %al,%edx
  800e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	0f b6 c0             	movzbl %al,%eax
  800e99:	29 c2                	sub    %eax,%edx
  800e9b:	89 d0                	mov    %edx,%eax
}
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	83 ec 04             	sub    $0x4,%esp
  800ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eab:	eb 12                	jmp    800ebf <strchr+0x20>
		if (*s == c)
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eb5:	75 05                	jne    800ebc <strchr+0x1d>
			return (char *) s;
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	eb 11                	jmp    800ecd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ebc:	ff 45 08             	incl   0x8(%ebp)
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	84 c0                	test   %al,%al
  800ec6:	75 e5                	jne    800ead <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ec8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 04             	sub    $0x4,%esp
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800edb:	eb 0d                	jmp    800eea <strfind+0x1b>
		if (*s == c)
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ee5:	74 0e                	je     800ef5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ee7:	ff 45 08             	incl   0x8(%ebp)
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	84 c0                	test   %al,%al
  800ef1:	75 ea                	jne    800edd <strfind+0xe>
  800ef3:	eb 01                	jmp    800ef6 <strfind+0x27>
		if (*s == c)
			break;
  800ef5:	90                   	nop
	return (char *) s;
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f07:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f0b:	76 63                	jbe    800f70 <memset+0x75>
		uint64 data_block = c;
  800f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f10:	99                   	cltd   
  800f11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f14:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f21:	c1 e0 08             	shl    $0x8,%eax
  800f24:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f27:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f30:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f34:	c1 e0 10             	shl    $0x10,%eax
  800f37:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f3a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f43:	89 c2                	mov    %eax,%edx
  800f45:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f4d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f50:	eb 18                	jmp    800f6a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f52:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f55:	8d 41 08             	lea    0x8(%ecx),%eax
  800f58:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f61:	89 01                	mov    %eax,(%ecx)
  800f63:	89 51 04             	mov    %edx,0x4(%ecx)
  800f66:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f6a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f6e:	77 e2                	ja     800f52 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f74:	74 23                	je     800f99 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f79:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f7c:	eb 0e                	jmp    800f8c <memset+0x91>
			*p8++ = (uint8)c;
  800f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f81:	8d 50 01             	lea    0x1(%eax),%edx
  800f84:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f92:	89 55 10             	mov    %edx,0x10(%ebp)
  800f95:	85 c0                	test   %eax,%eax
  800f97:	75 e5                	jne    800f7e <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9c:	c9                   	leave  
  800f9d:	c3                   	ret    

00800f9e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800fb0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fb4:	76 24                	jbe    800fda <memcpy+0x3c>
		while(n >= 8){
  800fb6:	eb 1c                	jmp    800fd4 <memcpy+0x36>
			*d64 = *s64;
  800fb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbb:	8b 50 04             	mov    0x4(%eax),%edx
  800fbe:	8b 00                	mov    (%eax),%eax
  800fc0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fc3:	89 01                	mov    %eax,(%ecx)
  800fc5:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800fc8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800fcc:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800fd0:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800fd4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fd8:	77 de                	ja     800fb8 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800fda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fde:	74 31                	je     801011 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800fe0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800fe6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800fec:	eb 16                	jmp    801004 <memcpy+0x66>
			*d8++ = *s8++;
  800fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff1:	8d 50 01             	lea    0x1(%eax),%edx
  800ff4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ff7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ffa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ffd:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801000:	8a 12                	mov    (%edx),%dl
  801002:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801004:	8b 45 10             	mov    0x10(%ebp),%eax
  801007:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100a:	89 55 10             	mov    %edx,0x10(%ebp)
  80100d:	85 c0                	test   %eax,%eax
  80100f:	75 dd                	jne    800fee <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801028:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80102e:	73 50                	jae    801080 <memmove+0x6a>
  801030:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801033:	8b 45 10             	mov    0x10(%ebp),%eax
  801036:	01 d0                	add    %edx,%eax
  801038:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80103b:	76 43                	jbe    801080 <memmove+0x6a>
		s += n;
  80103d:	8b 45 10             	mov    0x10(%ebp),%eax
  801040:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801043:	8b 45 10             	mov    0x10(%ebp),%eax
  801046:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801049:	eb 10                	jmp    80105b <memmove+0x45>
			*--d = *--s;
  80104b:	ff 4d f8             	decl   -0x8(%ebp)
  80104e:	ff 4d fc             	decl   -0x4(%ebp)
  801051:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801054:	8a 10                	mov    (%eax),%dl
  801056:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801059:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801061:	89 55 10             	mov    %edx,0x10(%ebp)
  801064:	85 c0                	test   %eax,%eax
  801066:	75 e3                	jne    80104b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801068:	eb 23                	jmp    80108d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80106a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106d:	8d 50 01             	lea    0x1(%eax),%edx
  801070:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801073:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801076:	8d 4a 01             	lea    0x1(%edx),%ecx
  801079:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80107c:	8a 12                	mov    (%edx),%dl
  80107e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801080:	8b 45 10             	mov    0x10(%ebp),%eax
  801083:	8d 50 ff             	lea    -0x1(%eax),%edx
  801086:	89 55 10             	mov    %edx,0x10(%ebp)
  801089:	85 c0                	test   %eax,%eax
  80108b:	75 dd                	jne    80106a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80109e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010a4:	eb 2a                	jmp    8010d0 <memcmp+0x3e>
		if (*s1 != *s2)
  8010a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a9:	8a 10                	mov    (%eax),%dl
  8010ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	38 c2                	cmp    %al,%dl
  8010b2:	74 16                	je     8010ca <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	0f b6 d0             	movzbl %al,%edx
  8010bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bf:	8a 00                	mov    (%eax),%al
  8010c1:	0f b6 c0             	movzbl %al,%eax
  8010c4:	29 c2                	sub    %eax,%edx
  8010c6:	89 d0                	mov    %edx,%eax
  8010c8:	eb 18                	jmp    8010e2 <memcmp+0x50>
		s1++, s2++;
  8010ca:	ff 45 fc             	incl   -0x4(%ebp)
  8010cd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	75 c9                	jne    8010a6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e2:	c9                   	leave  
  8010e3:	c3                   	ret    

008010e4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f0:	01 d0                	add    %edx,%eax
  8010f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010f5:	eb 15                	jmp    80110c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	0f b6 d0             	movzbl %al,%edx
  8010ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801102:	0f b6 c0             	movzbl %al,%eax
  801105:	39 c2                	cmp    %eax,%edx
  801107:	74 0d                	je     801116 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801109:	ff 45 08             	incl   0x8(%ebp)
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801112:	72 e3                	jb     8010f7 <memfind+0x13>
  801114:	eb 01                	jmp    801117 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801116:	90                   	nop
	return (void *) s;
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801122:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801129:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801130:	eb 03                	jmp    801135 <strtol+0x19>
		s++;
  801132:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	3c 20                	cmp    $0x20,%al
  80113c:	74 f4                	je     801132 <strtol+0x16>
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8a 00                	mov    (%eax),%al
  801143:	3c 09                	cmp    $0x9,%al
  801145:	74 eb                	je     801132 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	3c 2b                	cmp    $0x2b,%al
  80114e:	75 05                	jne    801155 <strtol+0x39>
		s++;
  801150:	ff 45 08             	incl   0x8(%ebp)
  801153:	eb 13                	jmp    801168 <strtol+0x4c>
	else if (*s == '-')
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 2d                	cmp    $0x2d,%al
  80115c:	75 0a                	jne    801168 <strtol+0x4c>
		s++, neg = 1;
  80115e:	ff 45 08             	incl   0x8(%ebp)
  801161:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801168:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116c:	74 06                	je     801174 <strtol+0x58>
  80116e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801172:	75 20                	jne    801194 <strtol+0x78>
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	3c 30                	cmp    $0x30,%al
  80117b:	75 17                	jne    801194 <strtol+0x78>
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	40                   	inc    %eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	3c 78                	cmp    $0x78,%al
  801185:	75 0d                	jne    801194 <strtol+0x78>
		s += 2, base = 16;
  801187:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80118b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801192:	eb 28                	jmp    8011bc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801194:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801198:	75 15                	jne    8011af <strtol+0x93>
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	3c 30                	cmp    $0x30,%al
  8011a1:	75 0c                	jne    8011af <strtol+0x93>
		s++, base = 8;
  8011a3:	ff 45 08             	incl   0x8(%ebp)
  8011a6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011ad:	eb 0d                	jmp    8011bc <strtol+0xa0>
	else if (base == 0)
  8011af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b3:	75 07                	jne    8011bc <strtol+0xa0>
		base = 10;
  8011b5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	3c 2f                	cmp    $0x2f,%al
  8011c3:	7e 19                	jle    8011de <strtol+0xc2>
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	3c 39                	cmp    $0x39,%al
  8011cc:	7f 10                	jg     8011de <strtol+0xc2>
			dig = *s - '0';
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	0f be c0             	movsbl %al,%eax
  8011d6:	83 e8 30             	sub    $0x30,%eax
  8011d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011dc:	eb 42                	jmp    801220 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	3c 60                	cmp    $0x60,%al
  8011e5:	7e 19                	jle    801200 <strtol+0xe4>
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	3c 7a                	cmp    $0x7a,%al
  8011ee:	7f 10                	jg     801200 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	0f be c0             	movsbl %al,%eax
  8011f8:	83 e8 57             	sub    $0x57,%eax
  8011fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011fe:	eb 20                	jmp    801220 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	3c 40                	cmp    $0x40,%al
  801207:	7e 39                	jle    801242 <strtol+0x126>
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	3c 5a                	cmp    $0x5a,%al
  801210:	7f 30                	jg     801242 <strtol+0x126>
			dig = *s - 'A' + 10;
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	0f be c0             	movsbl %al,%eax
  80121a:	83 e8 37             	sub    $0x37,%eax
  80121d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801223:	3b 45 10             	cmp    0x10(%ebp),%eax
  801226:	7d 19                	jge    801241 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801228:	ff 45 08             	incl   0x8(%ebp)
  80122b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801232:	89 c2                	mov    %eax,%edx
  801234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80123c:	e9 7b ff ff ff       	jmp    8011bc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801241:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801242:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801246:	74 08                	je     801250 <strtol+0x134>
		*endptr = (char *) s;
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	8b 55 08             	mov    0x8(%ebp),%edx
  80124e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801250:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801254:	74 07                	je     80125d <strtol+0x141>
  801256:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801259:	f7 d8                	neg    %eax
  80125b:	eb 03                	jmp    801260 <strtol+0x144>
  80125d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <ltostr>:

void
ltostr(long value, char *str)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801268:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80126f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801276:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127a:	79 13                	jns    80128f <ltostr+0x2d>
	{
		neg = 1;
  80127c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801289:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80128c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801297:	99                   	cltd   
  801298:	f7 f9                	idiv   %ecx
  80129a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80129d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a0:	8d 50 01             	lea    0x1(%eax),%edx
  8012a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a6:	89 c2                	mov    %eax,%edx
  8012a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ab:	01 d0                	add    %edx,%eax
  8012ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012b0:	83 c2 30             	add    $0x30,%edx
  8012b3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012b8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012bd:	f7 e9                	imul   %ecx
  8012bf:	c1 fa 02             	sar    $0x2,%edx
  8012c2:	89 c8                	mov    %ecx,%eax
  8012c4:	c1 f8 1f             	sar    $0x1f,%eax
  8012c7:	29 c2                	sub    %eax,%edx
  8012c9:	89 d0                	mov    %edx,%eax
  8012cb:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d2:	75 bb                	jne    80128f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012de:	48                   	dec    %eax
  8012df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012e6:	74 3d                	je     801325 <ltostr+0xc3>
		start = 1 ;
  8012e8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012ef:	eb 34                	jmp    801325 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f7:	01 d0                	add    %edx,%eax
  8012f9:	8a 00                	mov    (%eax),%al
  8012fb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801301:	8b 45 0c             	mov    0xc(%ebp),%eax
  801304:	01 c2                	add    %eax,%edx
  801306:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801309:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130c:	01 c8                	add    %ecx,%eax
  80130e:	8a 00                	mov    (%eax),%al
  801310:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801312:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801315:	8b 45 0c             	mov    0xc(%ebp),%eax
  801318:	01 c2                	add    %eax,%edx
  80131a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80131d:	88 02                	mov    %al,(%edx)
		start++ ;
  80131f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801322:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801328:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80132b:	7c c4                	jl     8012f1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80132d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801330:	8b 45 0c             	mov    0xc(%ebp),%eax
  801333:	01 d0                	add    %edx,%eax
  801335:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801338:	90                   	nop
  801339:	c9                   	leave  
  80133a:	c3                   	ret    

0080133b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801341:	ff 75 08             	pushl  0x8(%ebp)
  801344:	e8 c4 f9 ff ff       	call   800d0d <strlen>
  801349:	83 c4 04             	add    $0x4,%esp
  80134c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80134f:	ff 75 0c             	pushl  0xc(%ebp)
  801352:	e8 b6 f9 ff ff       	call   800d0d <strlen>
  801357:	83 c4 04             	add    $0x4,%esp
  80135a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80135d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801364:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136b:	eb 17                	jmp    801384 <strcconcat+0x49>
		final[s] = str1[s] ;
  80136d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801370:	8b 45 10             	mov    0x10(%ebp),%eax
  801373:	01 c2                	add    %eax,%edx
  801375:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	01 c8                	add    %ecx,%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801381:	ff 45 fc             	incl   -0x4(%ebp)
  801384:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801387:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80138a:	7c e1                	jl     80136d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80138c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801393:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80139a:	eb 1f                	jmp    8013bb <strcconcat+0x80>
		final[s++] = str2[i] ;
  80139c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80139f:	8d 50 01             	lea    0x1(%eax),%edx
  8013a2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013a5:	89 c2                	mov    %eax,%edx
  8013a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013aa:	01 c2                	add    %eax,%edx
  8013ac:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b2:	01 c8                	add    %ecx,%eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013b8:	ff 45 f8             	incl   -0x8(%ebp)
  8013bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013c1:	7c d9                	jl     80139c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c9:	01 d0                	add    %edx,%eax
  8013cb:	c6 00 00             	movb   $0x0,(%eax)
}
  8013ce:	90                   	nop
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e0:	8b 00                	mov    (%eax),%eax
  8013e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ec:	01 d0                	add    %edx,%eax
  8013ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013f4:	eb 0c                	jmp    801402 <strsplit+0x31>
			*string++ = 0;
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8d 50 01             	lea    0x1(%eax),%edx
  8013fc:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ff:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	84 c0                	test   %al,%al
  801409:	74 18                	je     801423 <strsplit+0x52>
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	0f be c0             	movsbl %al,%eax
  801413:	50                   	push   %eax
  801414:	ff 75 0c             	pushl  0xc(%ebp)
  801417:	e8 83 fa ff ff       	call   800e9f <strchr>
  80141c:	83 c4 08             	add    $0x8,%esp
  80141f:	85 c0                	test   %eax,%eax
  801421:	75 d3                	jne    8013f6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	84 c0                	test   %al,%al
  80142a:	74 5a                	je     801486 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80142c:	8b 45 14             	mov    0x14(%ebp),%eax
  80142f:	8b 00                	mov    (%eax),%eax
  801431:	83 f8 0f             	cmp    $0xf,%eax
  801434:	75 07                	jne    80143d <strsplit+0x6c>
		{
			return 0;
  801436:	b8 00 00 00 00       	mov    $0x0,%eax
  80143b:	eb 66                	jmp    8014a3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80143d:	8b 45 14             	mov    0x14(%ebp),%eax
  801440:	8b 00                	mov    (%eax),%eax
  801442:	8d 48 01             	lea    0x1(%eax),%ecx
  801445:	8b 55 14             	mov    0x14(%ebp),%edx
  801448:	89 0a                	mov    %ecx,(%edx)
  80144a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801451:	8b 45 10             	mov    0x10(%ebp),%eax
  801454:	01 c2                	add    %eax,%edx
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80145b:	eb 03                	jmp    801460 <strsplit+0x8f>
			string++;
  80145d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	8a 00                	mov    (%eax),%al
  801465:	84 c0                	test   %al,%al
  801467:	74 8b                	je     8013f4 <strsplit+0x23>
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	0f be c0             	movsbl %al,%eax
  801471:	50                   	push   %eax
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	e8 25 fa ff ff       	call   800e9f <strchr>
  80147a:	83 c4 08             	add    $0x8,%esp
  80147d:	85 c0                	test   %eax,%eax
  80147f:	74 dc                	je     80145d <strsplit+0x8c>
			string++;
	}
  801481:	e9 6e ff ff ff       	jmp    8013f4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801486:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801487:	8b 45 14             	mov    0x14(%ebp),%eax
  80148a:	8b 00                	mov    (%eax),%eax
  80148c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801493:	8b 45 10             	mov    0x10(%ebp),%eax
  801496:	01 d0                	add    %edx,%eax
  801498:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80149e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014b8:	eb 4a                	jmp    801504 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8014ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	01 c2                	add    %eax,%edx
  8014c2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	01 c8                	add    %ecx,%eax
  8014ca:	8a 00                	mov    (%eax),%al
  8014cc:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d4:	01 d0                	add    %edx,%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	3c 40                	cmp    $0x40,%al
  8014da:	7e 25                	jle    801501 <str2lower+0x5c>
  8014dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e2:	01 d0                	add    %edx,%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	3c 5a                	cmp    $0x5a,%al
  8014e8:	7f 17                	jg     801501 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8014ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	01 d0                	add    %edx,%eax
  8014f2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f8:	01 ca                	add    %ecx,%edx
  8014fa:	8a 12                	mov    (%edx),%dl
  8014fc:	83 c2 20             	add    $0x20,%edx
  8014ff:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801501:	ff 45 fc             	incl   -0x4(%ebp)
  801504:	ff 75 0c             	pushl  0xc(%ebp)
  801507:	e8 01 f8 ff ff       	call   800d0d <strlen>
  80150c:	83 c4 04             	add    $0x4,%esp
  80150f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801512:	7f a6                	jg     8014ba <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801514:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  80151f:	83 ec 0c             	sub    $0xc,%esp
  801522:	6a 10                	push   $0x10
  801524:	e8 b2 15 00 00       	call   802adb <alloc_block>
  801529:	83 c4 10             	add    $0x10,%esp
  80152c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  80152f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801533:	75 14                	jne    801549 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801535:	83 ec 04             	sub    $0x4,%esp
  801538:	68 e8 3f 80 00       	push   $0x803fe8
  80153d:	6a 14                	push   $0x14
  80153f:	68 11 40 80 00       	push   $0x804011
  801544:	e8 fd ed ff ff       	call   800346 <_panic>

	node->start = start;
  801549:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80154c:	8b 55 08             	mov    0x8(%ebp),%edx
  80154f:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801551:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801554:	8b 55 0c             	mov    0xc(%ebp),%edx
  801557:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  80155a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801561:	a1 24 50 80 00       	mov    0x805024,%eax
  801566:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801569:	eb 18                	jmp    801583 <insert_page_alloc+0x6a>
		if (start < it->start)
  80156b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156e:	8b 00                	mov    (%eax),%eax
  801570:	3b 45 08             	cmp    0x8(%ebp),%eax
  801573:	77 37                	ja     8015ac <insert_page_alloc+0x93>
			break;
		prev = it;
  801575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801578:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  80157b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801580:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801583:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801587:	74 08                	je     801591 <insert_page_alloc+0x78>
  801589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158c:	8b 40 08             	mov    0x8(%eax),%eax
  80158f:	eb 05                	jmp    801596 <insert_page_alloc+0x7d>
  801591:	b8 00 00 00 00       	mov    $0x0,%eax
  801596:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80159b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	75 c7                	jne    80156b <insert_page_alloc+0x52>
  8015a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015a8:	75 c1                	jne    80156b <insert_page_alloc+0x52>
  8015aa:	eb 01                	jmp    8015ad <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8015ac:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8015ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015b1:	75 64                	jne    801617 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8015b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015b7:	75 14                	jne    8015cd <insert_page_alloc+0xb4>
  8015b9:	83 ec 04             	sub    $0x4,%esp
  8015bc:	68 20 40 80 00       	push   $0x804020
  8015c1:	6a 21                	push   $0x21
  8015c3:	68 11 40 80 00       	push   $0x804011
  8015c8:	e8 79 ed ff ff       	call   800346 <_panic>
  8015cd:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8015d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d6:	89 50 08             	mov    %edx,0x8(%eax)
  8015d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015dc:	8b 40 08             	mov    0x8(%eax),%eax
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	74 0d                	je     8015f0 <insert_page_alloc+0xd7>
  8015e3:	a1 24 50 80 00       	mov    0x805024,%eax
  8015e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015eb:	89 50 0c             	mov    %edx,0xc(%eax)
  8015ee:	eb 08                	jmp    8015f8 <insert_page_alloc+0xdf>
  8015f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f3:	a3 28 50 80 00       	mov    %eax,0x805028
  8015f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015fb:	a3 24 50 80 00       	mov    %eax,0x805024
  801600:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801603:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80160a:	a1 30 50 80 00       	mov    0x805030,%eax
  80160f:	40                   	inc    %eax
  801610:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801615:	eb 71                	jmp    801688 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801617:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80161b:	74 06                	je     801623 <insert_page_alloc+0x10a>
  80161d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801621:	75 14                	jne    801637 <insert_page_alloc+0x11e>
  801623:	83 ec 04             	sub    $0x4,%esp
  801626:	68 44 40 80 00       	push   $0x804044
  80162b:	6a 23                	push   $0x23
  80162d:	68 11 40 80 00       	push   $0x804011
  801632:	e8 0f ed ff ff       	call   800346 <_panic>
  801637:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163a:	8b 50 08             	mov    0x8(%eax),%edx
  80163d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801640:	89 50 08             	mov    %edx,0x8(%eax)
  801643:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801646:	8b 40 08             	mov    0x8(%eax),%eax
  801649:	85 c0                	test   %eax,%eax
  80164b:	74 0c                	je     801659 <insert_page_alloc+0x140>
  80164d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801650:	8b 40 08             	mov    0x8(%eax),%eax
  801653:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801656:	89 50 0c             	mov    %edx,0xc(%eax)
  801659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80165f:	89 50 08             	mov    %edx,0x8(%eax)
  801662:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801665:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801668:	89 50 0c             	mov    %edx,0xc(%eax)
  80166b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166e:	8b 40 08             	mov    0x8(%eax),%eax
  801671:	85 c0                	test   %eax,%eax
  801673:	75 08                	jne    80167d <insert_page_alloc+0x164>
  801675:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801678:	a3 28 50 80 00       	mov    %eax,0x805028
  80167d:	a1 30 50 80 00       	mov    0x805030,%eax
  801682:	40                   	inc    %eax
  801683:	a3 30 50 80 00       	mov    %eax,0x805030
}
  801688:	90                   	nop
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801691:	a1 24 50 80 00       	mov    0x805024,%eax
  801696:	85 c0                	test   %eax,%eax
  801698:	75 0c                	jne    8016a6 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  80169a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80169f:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  8016a4:	eb 67                	jmp    80170d <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  8016a6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8016ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8016ae:	a1 24 50 80 00       	mov    0x805024,%eax
  8016b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8016b6:	eb 26                	jmp    8016de <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  8016b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016bb:	8b 10                	mov    (%eax),%edx
  8016bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c0:	8b 40 04             	mov    0x4(%eax),%eax
  8016c3:	01 d0                	add    %edx,%eax
  8016c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  8016c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016ce:	76 06                	jbe    8016d6 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  8016d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8016d6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8016de:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016e2:	74 08                	je     8016ec <recompute_page_alloc_break+0x61>
  8016e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e7:	8b 40 08             	mov    0x8(%eax),%eax
  8016ea:	eb 05                	jmp    8016f1 <recompute_page_alloc_break+0x66>
  8016ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8016f6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	75 b9                	jne    8016b8 <recompute_page_alloc_break+0x2d>
  8016ff:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801703:	75 b3                	jne    8016b8 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801705:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801708:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801715:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80171c:	8b 55 08             	mov    0x8(%ebp),%edx
  80171f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801722:	01 d0                	add    %edx,%eax
  801724:	48                   	dec    %eax
  801725:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801728:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80172b:	ba 00 00 00 00       	mov    $0x0,%edx
  801730:	f7 75 d8             	divl   -0x28(%ebp)
  801733:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801736:	29 d0                	sub    %edx,%eax
  801738:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  80173b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80173f:	75 0a                	jne    80174b <alloc_pages_custom_fit+0x3c>
		return NULL;
  801741:	b8 00 00 00 00       	mov    $0x0,%eax
  801746:	e9 7e 01 00 00       	jmp    8018c9 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  80174b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801752:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801756:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  80175d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801764:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801769:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  80176c:	a1 24 50 80 00       	mov    0x805024,%eax
  801771:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801774:	eb 69                	jmp    8017df <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801776:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801779:	8b 00                	mov    (%eax),%eax
  80177b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80177e:	76 47                	jbe    8017c7 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801783:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801786:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801789:	8b 00                	mov    (%eax),%eax
  80178b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80178e:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801791:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801794:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801797:	72 2e                	jb     8017c7 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801799:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80179d:	75 14                	jne    8017b3 <alloc_pages_custom_fit+0xa4>
  80179f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017a2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017a5:	75 0c                	jne    8017b3 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  8017a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  8017ad:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8017b1:	eb 14                	jmp    8017c7 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  8017b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017b6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8017b9:	76 0c                	jbe    8017c7 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  8017bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017be:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  8017c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  8017c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017ca:	8b 10                	mov    (%eax),%edx
  8017cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017cf:	8b 40 04             	mov    0x4(%eax),%eax
  8017d2:	01 d0                	add    %edx,%eax
  8017d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8017d7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017e3:	74 08                	je     8017ed <alloc_pages_custom_fit+0xde>
  8017e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017e8:	8b 40 08             	mov    0x8(%eax),%eax
  8017eb:	eb 05                	jmp    8017f2 <alloc_pages_custom_fit+0xe3>
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8017f7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	0f 85 72 ff ff ff    	jne    801776 <alloc_pages_custom_fit+0x67>
  801804:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801808:	0f 85 68 ff ff ff    	jne    801776 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  80180e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801813:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801816:	76 47                	jbe    80185f <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801818:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80181b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  80181e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801823:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801826:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801829:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80182c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80182f:	72 2e                	jb     80185f <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801831:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801835:	75 14                	jne    80184b <alloc_pages_custom_fit+0x13c>
  801837:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80183a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80183d:	75 0c                	jne    80184b <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  80183f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801842:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801845:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801849:	eb 14                	jmp    80185f <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  80184b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80184e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801851:	76 0c                	jbe    80185f <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801853:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801856:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801859:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80185c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  80185f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801866:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80186a:	74 08                	je     801874 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  80186c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801872:	eb 40                	jmp    8018b4 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801874:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801878:	74 08                	je     801882 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  80187a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80187d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801880:	eb 32                	jmp    8018b4 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801882:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801887:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80188a:	89 c2                	mov    %eax,%edx
  80188c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801891:	39 c2                	cmp    %eax,%edx
  801893:	73 07                	jae    80189c <alloc_pages_custom_fit+0x18d>
			return NULL;
  801895:	b8 00 00 00 00       	mov    $0x0,%eax
  80189a:	eb 2d                	jmp    8018c9 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  80189c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8018a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  8018a4:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8018aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8018ad:	01 d0                	add    %edx,%eax
  8018af:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  8018b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018b7:	83 ec 08             	sub    $0x8,%esp
  8018ba:	ff 75 d0             	pushl  -0x30(%ebp)
  8018bd:	50                   	push   %eax
  8018be:	e8 56 fc ff ff       	call   801519 <insert_page_alloc>
  8018c3:	83 c4 10             	add    $0x10,%esp

	return result;
  8018c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8018d7:	a1 24 50 80 00       	mov    0x805024,%eax
  8018dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8018df:	eb 1a                	jmp    8018fb <find_allocated_size+0x30>
		if (it->start == va)
  8018e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018e4:	8b 00                	mov    (%eax),%eax
  8018e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018e9:	75 08                	jne    8018f3 <find_allocated_size+0x28>
			return it->size;
  8018eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ee:	8b 40 04             	mov    0x4(%eax),%eax
  8018f1:	eb 34                	jmp    801927 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8018f3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8018fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ff:	74 08                	je     801909 <find_allocated_size+0x3e>
  801901:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801904:	8b 40 08             	mov    0x8(%eax),%eax
  801907:	eb 05                	jmp    80190e <find_allocated_size+0x43>
  801909:	b8 00 00 00 00       	mov    $0x0,%eax
  80190e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801913:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801918:	85 c0                	test   %eax,%eax
  80191a:	75 c5                	jne    8018e1 <find_allocated_size+0x16>
  80191c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801920:	75 bf                	jne    8018e1 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801922:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801935:	a1 24 50 80 00       	mov    0x805024,%eax
  80193a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80193d:	e9 e1 01 00 00       	jmp    801b23 <free_pages+0x1fa>
		if (it->start == va) {
  801942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801945:	8b 00                	mov    (%eax),%eax
  801947:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80194a:	0f 85 cb 01 00 00    	jne    801b1b <free_pages+0x1f2>

			uint32 start = it->start;
  801950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801953:	8b 00                	mov    (%eax),%eax
  801955:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195b:	8b 40 04             	mov    0x4(%eax),%eax
  80195e:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801964:	f7 d0                	not    %eax
  801966:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801969:	73 1d                	jae    801988 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  80196b:	83 ec 0c             	sub    $0xc,%esp
  80196e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801971:	ff 75 e8             	pushl  -0x18(%ebp)
  801974:	68 78 40 80 00       	push   $0x804078
  801979:	68 a5 00 00 00       	push   $0xa5
  80197e:	68 11 40 80 00       	push   $0x804011
  801983:	e8 be e9 ff ff       	call   800346 <_panic>
			}

			uint32 start_end = start + size;
  801988:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80198b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80198e:	01 d0                	add    %edx,%eax
  801990:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801993:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801996:	85 c0                	test   %eax,%eax
  801998:	79 19                	jns    8019b3 <free_pages+0x8a>
  80199a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8019a1:	77 10                	ja     8019b3 <free_pages+0x8a>
  8019a3:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  8019aa:	77 07                	ja     8019b3 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  8019ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	78 2c                	js     8019df <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  8019b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019b6:	83 ec 0c             	sub    $0xc,%esp
  8019b9:	68 00 00 00 a0       	push   $0xa0000000
  8019be:	ff 75 e0             	pushl  -0x20(%ebp)
  8019c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019c4:	ff 75 e8             	pushl  -0x18(%ebp)
  8019c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019ca:	50                   	push   %eax
  8019cb:	68 bc 40 80 00       	push   $0x8040bc
  8019d0:	68 ad 00 00 00       	push   $0xad
  8019d5:	68 11 40 80 00       	push   $0x804011
  8019da:	e8 67 e9 ff ff       	call   800346 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8019df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019e5:	e9 88 00 00 00       	jmp    801a72 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  8019ea:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  8019f1:	76 17                	jbe    801a0a <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  8019f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8019f6:	68 20 41 80 00       	push   $0x804120
  8019fb:	68 b4 00 00 00       	push   $0xb4
  801a00:	68 11 40 80 00       	push   $0x804011
  801a05:	e8 3c e9 ff ff       	call   800346 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0d:	05 00 10 00 00       	add    $0x1000,%eax
  801a12:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	79 2e                	jns    801a4a <free_pages+0x121>
  801a1c:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801a23:	77 25                	ja     801a4a <free_pages+0x121>
  801a25:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801a2c:	77 1c                	ja     801a4a <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801a2e:	83 ec 08             	sub    $0x8,%esp
  801a31:	68 00 10 00 00       	push   $0x1000
  801a36:	ff 75 f0             	pushl  -0x10(%ebp)
  801a39:	e8 38 0d 00 00       	call   802776 <sys_free_user_mem>
  801a3e:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801a41:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801a48:	eb 28                	jmp    801a72 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4d:	68 00 00 00 a0       	push   $0xa0000000
  801a52:	ff 75 dc             	pushl  -0x24(%ebp)
  801a55:	68 00 10 00 00       	push   $0x1000
  801a5a:	ff 75 f0             	pushl  -0x10(%ebp)
  801a5d:	50                   	push   %eax
  801a5e:	68 60 41 80 00       	push   $0x804160
  801a63:	68 bd 00 00 00       	push   $0xbd
  801a68:	68 11 40 80 00       	push   $0x804011
  801a6d:	e8 d4 e8 ff ff       	call   800346 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a75:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801a78:	0f 82 6c ff ff ff    	jb     8019ea <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801a7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a82:	75 17                	jne    801a9b <free_pages+0x172>
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	68 c2 41 80 00       	push   $0x8041c2
  801a8c:	68 c1 00 00 00       	push   $0xc1
  801a91:	68 11 40 80 00       	push   $0x804011
  801a96:	e8 ab e8 ff ff       	call   800346 <_panic>
  801a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9e:	8b 40 08             	mov    0x8(%eax),%eax
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	74 11                	je     801ab6 <free_pages+0x18d>
  801aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa8:	8b 40 08             	mov    0x8(%eax),%eax
  801aab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aae:	8b 52 0c             	mov    0xc(%edx),%edx
  801ab1:	89 50 0c             	mov    %edx,0xc(%eax)
  801ab4:	eb 0b                	jmp    801ac1 <free_pages+0x198>
  801ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab9:	8b 40 0c             	mov    0xc(%eax),%eax
  801abc:	a3 28 50 80 00       	mov    %eax,0x805028
  801ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	74 11                	je     801adc <free_pages+0x1b3>
  801acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ace:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad4:	8b 52 08             	mov    0x8(%edx),%edx
  801ad7:	89 50 08             	mov    %edx,0x8(%eax)
  801ada:	eb 0b                	jmp    801ae7 <free_pages+0x1be>
  801adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801adf:	8b 40 08             	mov    0x8(%eax),%eax
  801ae2:	a3 24 50 80 00       	mov    %eax,0x805024
  801ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801afb:	a1 30 50 80 00       	mov    0x805030,%eax
  801b00:	48                   	dec    %eax
  801b01:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801b06:	83 ec 0c             	sub    $0xc,%esp
  801b09:	ff 75 f4             	pushl  -0xc(%ebp)
  801b0c:	e8 24 15 00 00       	call   803035 <free_block>
  801b11:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801b14:	e8 72 fb ff ff       	call   80168b <recompute_page_alloc_break>

			return;
  801b19:	eb 37                	jmp    801b52 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801b1b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b27:	74 08                	je     801b31 <free_pages+0x208>
  801b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2c:	8b 40 08             	mov    0x8(%eax),%eax
  801b2f:	eb 05                	jmp    801b36 <free_pages+0x20d>
  801b31:	b8 00 00 00 00       	mov    $0x0,%eax
  801b36:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801b3b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801b40:	85 c0                	test   %eax,%eax
  801b42:	0f 85 fa fd ff ff    	jne    801942 <free_pages+0x19>
  801b48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b4c:	0f 85 f0 fd ff ff    	jne    801942 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801b57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b5c:	5d                   	pop    %ebp
  801b5d:	c3                   	ret    

00801b5e <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b64:	a1 08 50 80 00       	mov    0x805008,%eax
  801b69:	85 c0                	test   %eax,%eax
  801b6b:	74 60                	je     801bcd <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b6d:	83 ec 08             	sub    $0x8,%esp
  801b70:	68 00 00 00 82       	push   $0x82000000
  801b75:	68 00 00 00 80       	push   $0x80000000
  801b7a:	e8 0d 0d 00 00       	call   80288c <initialize_dynamic_allocator>
  801b7f:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b82:	e8 f3 0a 00 00       	call   80267a <sys_get_uheap_strategy>
  801b87:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b8c:	a1 40 50 80 00       	mov    0x805040,%eax
  801b91:	05 00 10 00 00       	add    $0x1000,%eax
  801b96:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b9b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ba0:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801ba5:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801bac:	00 00 00 
  801baf:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801bb6:	00 00 00 
  801bb9:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801bc0:	00 00 00 

		__firstTimeFlag = 0;
  801bc3:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801bca:	00 00 00 
	}
}
  801bcd:	90                   	nop
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801be4:	83 ec 08             	sub    $0x8,%esp
  801be7:	68 06 04 00 00       	push   $0x406
  801bec:	50                   	push   %eax
  801bed:	e8 d2 06 00 00       	call   8022c4 <__sys_allocate_page>
  801bf2:	83 c4 10             	add    $0x10,%esp
  801bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bf8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bfc:	79 17                	jns    801c15 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801bfe:	83 ec 04             	sub    $0x4,%esp
  801c01:	68 e0 41 80 00       	push   $0x8041e0
  801c06:	68 ea 00 00 00       	push   $0xea
  801c0b:	68 11 40 80 00       	push   $0x804011
  801c10:	e8 31 e7 ff ff       	call   800346 <_panic>
	return 0;
  801c15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c30:	83 ec 0c             	sub    $0xc,%esp
  801c33:	50                   	push   %eax
  801c34:	e8 d2 06 00 00       	call   80230b <__sys_unmap_frame>
  801c39:	83 c4 10             	add    $0x10,%esp
  801c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c43:	79 17                	jns    801c5c <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801c45:	83 ec 04             	sub    $0x4,%esp
  801c48:	68 1c 42 80 00       	push   $0x80421c
  801c4d:	68 f5 00 00 00       	push   $0xf5
  801c52:	68 11 40 80 00       	push   $0x804011
  801c57:	e8 ea e6 ff ff       	call   800346 <_panic>
}
  801c5c:	90                   	nop
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c65:	e8 f4 fe ff ff       	call   801b5e <uheap_init>
	if (size == 0) return NULL ;
  801c6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c6e:	75 0a                	jne    801c7a <malloc+0x1b>
  801c70:	b8 00 00 00 00       	mov    $0x0,%eax
  801c75:	e9 67 01 00 00       	jmp    801de1 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801c81:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c88:	77 16                	ja     801ca0 <malloc+0x41>
		result = alloc_block(size);
  801c8a:	83 ec 0c             	sub    $0xc,%esp
  801c8d:	ff 75 08             	pushl  0x8(%ebp)
  801c90:	e8 46 0e 00 00       	call   802adb <alloc_block>
  801c95:	83 c4 10             	add    $0x10,%esp
  801c98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c9b:	e9 3e 01 00 00       	jmp    801dde <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801ca0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  801caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cad:	01 d0                	add    %edx,%eax
  801caf:	48                   	dec    %eax
  801cb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801cb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbb:	f7 75 f0             	divl   -0x10(%ebp)
  801cbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc1:	29 d0                	sub    %edx,%eax
  801cc3:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801cc6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ccb:	85 c0                	test   %eax,%eax
  801ccd:	75 0a                	jne    801cd9 <malloc+0x7a>
			return NULL;
  801ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd4:	e9 08 01 00 00       	jmp    801de1 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801cd9:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	74 0f                	je     801cf1 <malloc+0x92>
  801ce2:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801ce8:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ced:	39 c2                	cmp    %eax,%edx
  801cef:	73 0a                	jae    801cfb <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801cf1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801cf6:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801cfb:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801d00:	83 f8 05             	cmp    $0x5,%eax
  801d03:	75 11                	jne    801d16 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801d05:	83 ec 0c             	sub    $0xc,%esp
  801d08:	ff 75 e8             	pushl  -0x18(%ebp)
  801d0b:	e8 ff f9 ff ff       	call   80170f <alloc_pages_custom_fit>
  801d10:	83 c4 10             	add    $0x10,%esp
  801d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801d16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d1a:	0f 84 be 00 00 00    	je     801dde <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801d26:	83 ec 0c             	sub    $0xc,%esp
  801d29:	ff 75 f4             	pushl  -0xc(%ebp)
  801d2c:	e8 9a fb ff ff       	call   8018cb <find_allocated_size>
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801d37:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d3b:	75 17                	jne    801d54 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801d3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d40:	68 5c 42 80 00       	push   $0x80425c
  801d45:	68 24 01 00 00       	push   $0x124
  801d4a:	68 11 40 80 00       	push   $0x804011
  801d4f:	e8 f2 e5 ff ff       	call   800346 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801d54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d57:	f7 d0                	not    %eax
  801d59:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d5c:	73 1d                	jae    801d7b <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801d5e:	83 ec 0c             	sub    $0xc,%esp
  801d61:	ff 75 e0             	pushl  -0x20(%ebp)
  801d64:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d67:	68 a4 42 80 00       	push   $0x8042a4
  801d6c:	68 29 01 00 00       	push   $0x129
  801d71:	68 11 40 80 00       	push   $0x804011
  801d76:	e8 cb e5 ff ff       	call   800346 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801d7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d81:	01 d0                	add    %edx,%eax
  801d83:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d89:	85 c0                	test   %eax,%eax
  801d8b:	79 2c                	jns    801db9 <malloc+0x15a>
  801d8d:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801d94:	77 23                	ja     801db9 <malloc+0x15a>
  801d96:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801d9d:	77 1a                	ja     801db9 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801d9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801da2:	85 c0                	test   %eax,%eax
  801da4:	79 13                	jns    801db9 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801da6:	83 ec 08             	sub    $0x8,%esp
  801da9:	ff 75 e0             	pushl  -0x20(%ebp)
  801dac:	ff 75 e4             	pushl  -0x1c(%ebp)
  801daf:	e8 de 09 00 00       	call   802792 <sys_allocate_user_mem>
  801db4:	83 c4 10             	add    $0x10,%esp
  801db7:	eb 25                	jmp    801dde <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801db9:	68 00 00 00 a0       	push   $0xa0000000
  801dbe:	ff 75 dc             	pushl  -0x24(%ebp)
  801dc1:	ff 75 e0             	pushl  -0x20(%ebp)
  801dc4:	ff 75 e4             	pushl  -0x1c(%ebp)
  801dc7:	ff 75 f4             	pushl  -0xc(%ebp)
  801dca:	68 e0 42 80 00       	push   $0x8042e0
  801dcf:	68 33 01 00 00       	push   $0x133
  801dd4:	68 11 40 80 00       	push   $0x804011
  801dd9:	e8 68 e5 ff ff       	call   800346 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801de9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ded:	0f 84 26 01 00 00    	je     801f19 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801df3:	8b 45 08             	mov    0x8(%ebp),%eax
  801df6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfc:	85 c0                	test   %eax,%eax
  801dfe:	79 1c                	jns    801e1c <free+0x39>
  801e00:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801e07:	77 13                	ja     801e1c <free+0x39>
		free_block(virtual_address);
  801e09:	83 ec 0c             	sub    $0xc,%esp
  801e0c:	ff 75 08             	pushl  0x8(%ebp)
  801e0f:	e8 21 12 00 00       	call   803035 <free_block>
  801e14:	83 c4 10             	add    $0x10,%esp
		return;
  801e17:	e9 01 01 00 00       	jmp    801f1d <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801e1c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e21:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801e24:	0f 82 d8 00 00 00    	jb     801f02 <free+0x11f>
  801e2a:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801e31:	0f 87 cb 00 00 00    	ja     801f02 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3a:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	74 17                	je     801e5a <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801e43:	ff 75 08             	pushl  0x8(%ebp)
  801e46:	68 50 43 80 00       	push   $0x804350
  801e4b:	68 57 01 00 00       	push   $0x157
  801e50:	68 11 40 80 00       	push   $0x804011
  801e55:	e8 ec e4 ff ff       	call   800346 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	ff 75 08             	pushl  0x8(%ebp)
  801e60:	e8 66 fa ff ff       	call   8018cb <find_allocated_size>
  801e65:	83 c4 10             	add    $0x10,%esp
  801e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801e6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e6f:	0f 84 a7 00 00 00    	je     801f1c <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e78:	f7 d0                	not    %eax
  801e7a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e7d:	73 1d                	jae    801e9c <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801e7f:	83 ec 0c             	sub    $0xc,%esp
  801e82:	ff 75 f0             	pushl  -0x10(%ebp)
  801e85:	ff 75 f4             	pushl  -0xc(%ebp)
  801e88:	68 78 43 80 00       	push   $0x804378
  801e8d:	68 61 01 00 00       	push   $0x161
  801e92:	68 11 40 80 00       	push   $0x804011
  801e97:	e8 aa e4 ff ff       	call   800346 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801e9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea2:	01 d0                	add    %edx,%eax
  801ea4:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	79 19                	jns    801ec7 <free+0xe4>
  801eae:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801eb5:	77 10                	ja     801ec7 <free+0xe4>
  801eb7:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801ebe:	77 07                	ja     801ec7 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801ec0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	78 2b                	js     801ef2 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801ec7:	83 ec 0c             	sub    $0xc,%esp
  801eca:	68 00 00 00 a0       	push   $0xa0000000
  801ecf:	ff 75 ec             	pushl  -0x14(%ebp)
  801ed2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ed5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed8:	ff 75 f0             	pushl  -0x10(%ebp)
  801edb:	ff 75 08             	pushl  0x8(%ebp)
  801ede:	68 b4 43 80 00       	push   $0x8043b4
  801ee3:	68 69 01 00 00       	push   $0x169
  801ee8:	68 11 40 80 00       	push   $0x804011
  801eed:	e8 54 e4 ff ff       	call   800346 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  801ef2:	83 ec 0c             	sub    $0xc,%esp
  801ef5:	ff 75 08             	pushl  0x8(%ebp)
  801ef8:	e8 2c fa ff ff       	call   801929 <free_pages>
  801efd:	83 c4 10             	add    $0x10,%esp
		return;
  801f00:	eb 1b                	jmp    801f1d <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  801f02:	ff 75 08             	pushl  0x8(%ebp)
  801f05:	68 10 44 80 00       	push   $0x804410
  801f0a:	68 70 01 00 00       	push   $0x170
  801f0f:	68 11 40 80 00       	push   $0x804011
  801f14:	e8 2d e4 ff ff       	call   800346 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801f19:	90                   	nop
  801f1a:	eb 01                	jmp    801f1d <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  801f1c:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 38             	sub    $0x38,%esp
  801f25:	8b 45 10             	mov    0x10(%ebp),%eax
  801f28:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f2b:	e8 2e fc ff ff       	call   801b5e <uheap_init>
	if (size == 0) return NULL ;
  801f30:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f34:	75 0a                	jne    801f40 <smalloc+0x21>
  801f36:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3b:	e9 3d 01 00 00       	jmp    80207d <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  801f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  801f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f49:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  801f51:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f55:	74 0e                	je     801f65 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  801f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5a:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801f5d:	05 00 10 00 00       	add    $0x1000,%eax
  801f62:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  801f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f68:	c1 e8 0c             	shr    $0xc,%eax
  801f6b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  801f6e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f73:	85 c0                	test   %eax,%eax
  801f75:	75 0a                	jne    801f81 <smalloc+0x62>
		return NULL;
  801f77:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7c:	e9 fc 00 00 00       	jmp    80207d <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  801f81:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f86:	85 c0                	test   %eax,%eax
  801f88:	74 0f                	je     801f99 <smalloc+0x7a>
  801f8a:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f90:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f95:	39 c2                	cmp    %eax,%edx
  801f97:	73 0a                	jae    801fa3 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  801f99:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f9e:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  801fa3:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801fa8:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801fad:	29 c2                	sub    %eax,%edx
  801faf:	89 d0                	mov    %edx,%eax
  801fb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  801fb4:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801fba:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801fbf:	29 c2                	sub    %eax,%edx
  801fc1:	89 d0                	mov    %edx,%eax
  801fc3:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801fcc:	77 13                	ja     801fe1 <smalloc+0xc2>
  801fce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fd1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801fd4:	77 0b                	ja     801fe1 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  801fd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fd9:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801fdc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801fdf:	73 0a                	jae    801feb <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  801fe1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe6:	e9 92 00 00 00       	jmp    80207d <smalloc+0x15e>
	}

	void *va = NULL;
  801feb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801ff2:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801ff7:	83 f8 05             	cmp    $0x5,%eax
  801ffa:	75 11                	jne    80200d <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  801ffc:	83 ec 0c             	sub    $0xc,%esp
  801fff:	ff 75 f4             	pushl  -0xc(%ebp)
  802002:	e8 08 f7 ff ff       	call   80170f <alloc_pages_custom_fit>
  802007:	83 c4 10             	add    $0x10,%esp
  80200a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  80200d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802011:	75 27                	jne    80203a <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802013:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  80201a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80201d:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802020:	89 c2                	mov    %eax,%edx
  802022:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802027:	39 c2                	cmp    %eax,%edx
  802029:	73 07                	jae    802032 <smalloc+0x113>
			return NULL;}
  80202b:	b8 00 00 00 00       	mov    $0x0,%eax
  802030:	eb 4b                	jmp    80207d <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  802032:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802037:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  80203a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80203e:	ff 75 f0             	pushl  -0x10(%ebp)
  802041:	50                   	push   %eax
  802042:	ff 75 0c             	pushl  0xc(%ebp)
  802045:	ff 75 08             	pushl  0x8(%ebp)
  802048:	e8 cb 03 00 00       	call   802418 <sys_create_shared_object>
  80204d:	83 c4 10             	add    $0x10,%esp
  802050:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  802053:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802057:	79 07                	jns    802060 <smalloc+0x141>
		return NULL;
  802059:	b8 00 00 00 00       	mov    $0x0,%eax
  80205e:	eb 1d                	jmp    80207d <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802060:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802065:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802068:	75 10                	jne    80207a <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  80206a:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802073:	01 d0                	add    %edx,%eax
  802075:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  80207a:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802085:	e8 d4 fa ff ff       	call   801b5e <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80208a:	83 ec 08             	sub    $0x8,%esp
  80208d:	ff 75 0c             	pushl  0xc(%ebp)
  802090:	ff 75 08             	pushl  0x8(%ebp)
  802093:	e8 aa 03 00 00       	call   802442 <sys_size_of_shared_object>
  802098:	83 c4 10             	add    $0x10,%esp
  80209b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  80209e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020a2:	7f 0a                	jg     8020ae <sget+0x2f>
		return NULL;
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a9:	e9 32 01 00 00       	jmp    8021e0 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8020ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8020b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b7:	25 ff 0f 00 00       	and    $0xfff,%eax
  8020bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8020bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8020c3:	74 0e                	je     8020d3 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8020c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8020cb:	05 00 10 00 00       	add    $0x1000,%eax
  8020d0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8020d3:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	75 0a                	jne    8020e6 <sget+0x67>
		return NULL;
  8020dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e1:	e9 fa 00 00 00       	jmp    8021e0 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8020e6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020eb:	85 c0                	test   %eax,%eax
  8020ed:	74 0f                	je     8020fe <sget+0x7f>
  8020ef:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020f5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020fa:	39 c2                	cmp    %eax,%edx
  8020fc:	73 0a                	jae    802108 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8020fe:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802103:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802108:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80210d:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802112:	29 c2                	sub    %eax,%edx
  802114:	89 d0                	mov    %edx,%eax
  802116:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802119:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80211f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802124:	29 c2                	sub    %eax,%edx
  802126:	89 d0                	mov    %edx,%eax
  802128:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80212b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802131:	77 13                	ja     802146 <sget+0xc7>
  802133:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802136:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802139:	77 0b                	ja     802146 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  80213b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80213e:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802141:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802144:	73 0a                	jae    802150 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
  80214b:	e9 90 00 00 00       	jmp    8021e0 <sget+0x161>

	void *va = NULL;
  802150:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802157:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80215c:	83 f8 05             	cmp    $0x5,%eax
  80215f:	75 11                	jne    802172 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802161:	83 ec 0c             	sub    $0xc,%esp
  802164:	ff 75 f4             	pushl  -0xc(%ebp)
  802167:	e8 a3 f5 ff ff       	call   80170f <alloc_pages_custom_fit>
  80216c:	83 c4 10             	add    $0x10,%esp
  80216f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  802172:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802176:	75 27                	jne    80219f <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802178:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  80217f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802182:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802185:	89 c2                	mov    %eax,%edx
  802187:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80218c:	39 c2                	cmp    %eax,%edx
  80218e:	73 07                	jae    802197 <sget+0x118>
			return NULL;
  802190:	b8 00 00 00 00       	mov    $0x0,%eax
  802195:	eb 49                	jmp    8021e0 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802197:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80219c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  80219f:	83 ec 04             	sub    $0x4,%esp
  8021a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8021a5:	ff 75 0c             	pushl  0xc(%ebp)
  8021a8:	ff 75 08             	pushl  0x8(%ebp)
  8021ab:	e8 af 02 00 00       	call   80245f <sys_get_shared_object>
  8021b0:	83 c4 10             	add    $0x10,%esp
  8021b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8021b6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8021ba:	79 07                	jns    8021c3 <sget+0x144>
		return NULL;
  8021bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c1:	eb 1d                	jmp    8021e0 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8021c3:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8021c8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8021cb:	75 10                	jne    8021dd <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8021cd:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	01 d0                	add    %edx,%eax
  8021d8:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8021dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021e8:	e8 71 f9 ff ff       	call   801b5e <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8021ed:	83 ec 04             	sub    $0x4,%esp
  8021f0:	68 34 44 80 00       	push   $0x804434
  8021f5:	68 19 02 00 00       	push   $0x219
  8021fa:	68 11 40 80 00       	push   $0x804011
  8021ff:	e8 42 e1 ff ff       	call   800346 <_panic>

00802204 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80220a:	83 ec 04             	sub    $0x4,%esp
  80220d:	68 5c 44 80 00       	push   $0x80445c
  802212:	68 2b 02 00 00       	push   $0x22b
  802217:	68 11 40 80 00       	push   $0x804011
  80221c:	e8 25 e1 ff ff       	call   800346 <_panic>

00802221 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	57                   	push   %edi
  802225:	56                   	push   %esi
  802226:	53                   	push   %ebx
  802227:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802230:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802233:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802236:	8b 7d 18             	mov    0x18(%ebp),%edi
  802239:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80223c:	cd 30                	int    $0x30
  80223e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802241:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802244:	83 c4 10             	add    $0x10,%esp
  802247:	5b                   	pop    %ebx
  802248:	5e                   	pop    %esi
  802249:	5f                   	pop    %edi
  80224a:	5d                   	pop    %ebp
  80224b:	c3                   	ret    

0080224c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	83 ec 04             	sub    $0x4,%esp
  802252:	8b 45 10             	mov    0x10(%ebp),%eax
  802255:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802258:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80225b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	6a 00                	push   $0x0
  802264:	51                   	push   %ecx
  802265:	52                   	push   %edx
  802266:	ff 75 0c             	pushl  0xc(%ebp)
  802269:	50                   	push   %eax
  80226a:	6a 00                	push   $0x0
  80226c:	e8 b0 ff ff ff       	call   802221 <syscall>
  802271:	83 c4 18             	add    $0x18,%esp
}
  802274:	90                   	nop
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_cgetc>:

int
sys_cgetc(void)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 02                	push   $0x2
  802286:	e8 96 ff ff ff       	call   802221 <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
}
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 03                	push   $0x3
  80229f:	e8 7d ff ff ff       	call   802221 <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
}
  8022a7:	90                   	nop
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 04                	push   $0x4
  8022b9:	e8 63 ff ff ff       	call   802221 <syscall>
  8022be:	83 c4 18             	add    $0x18,%esp
}
  8022c1:	90                   	nop
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	52                   	push   %edx
  8022d4:	50                   	push   %eax
  8022d5:	6a 08                	push   $0x8
  8022d7:	e8 45 ff ff ff       	call   802221 <syscall>
  8022dc:	83 c4 18             	add    $0x18,%esp
}
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
  8022e4:	56                   	push   %esi
  8022e5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022e6:	8b 75 18             	mov    0x18(%ebp),%esi
  8022e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	56                   	push   %esi
  8022f6:	53                   	push   %ebx
  8022f7:	51                   	push   %ecx
  8022f8:	52                   	push   %edx
  8022f9:	50                   	push   %eax
  8022fa:	6a 09                	push   $0x9
  8022fc:	e8 20 ff ff ff       	call   802221 <syscall>
  802301:	83 c4 18             	add    $0x18,%esp
}
  802304:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802307:	5b                   	pop    %ebx
  802308:	5e                   	pop    %esi
  802309:	5d                   	pop    %ebp
  80230a:	c3                   	ret    

0080230b <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	ff 75 08             	pushl  0x8(%ebp)
  802319:	6a 0a                	push   $0xa
  80231b:	e8 01 ff ff ff       	call   802221 <syscall>
  802320:	83 c4 18             	add    $0x18,%esp
}
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	ff 75 0c             	pushl  0xc(%ebp)
  802331:	ff 75 08             	pushl  0x8(%ebp)
  802334:	6a 0b                	push   $0xb
  802336:	e8 e6 fe ff ff       	call   802221 <syscall>
  80233b:	83 c4 18             	add    $0x18,%esp
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 0c                	push   $0xc
  80234f:	e8 cd fe ff ff       	call   802221 <syscall>
  802354:	83 c4 18             	add    $0x18,%esp
}
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 0d                	push   $0xd
  802368:	e8 b4 fe ff ff       	call   802221 <syscall>
  80236d:	83 c4 18             	add    $0x18,%esp
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 0e                	push   $0xe
  802381:	e8 9b fe ff ff       	call   802221 <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80238e:	6a 00                	push   $0x0
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 0f                	push   $0xf
  80239a:	e8 82 fe ff ff       	call   802221 <syscall>
  80239f:	83 c4 18             	add    $0x18,%esp
}
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	ff 75 08             	pushl  0x8(%ebp)
  8023b2:	6a 10                	push   $0x10
  8023b4:	e8 68 fe ff ff       	call   802221 <syscall>
  8023b9:	83 c4 18             	add    $0x18,%esp
}
  8023bc:	c9                   	leave  
  8023bd:	c3                   	ret    

008023be <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 11                	push   $0x11
  8023cd:	e8 4f fe ff ff       	call   802221 <syscall>
  8023d2:	83 c4 18             	add    $0x18,%esp
}
  8023d5:	90                   	nop
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <sys_cputc>:

void
sys_cputc(const char c)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
  8023db:	83 ec 04             	sub    $0x4,%esp
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023e4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	50                   	push   %eax
  8023f1:	6a 01                	push   $0x1
  8023f3:	e8 29 fe ff ff       	call   802221 <syscall>
  8023f8:	83 c4 18             	add    $0x18,%esp
}
  8023fb:	90                   	nop
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 14                	push   $0x14
  80240d:	e8 0f fe ff ff       	call   802221 <syscall>
  802412:	83 c4 18             	add    $0x18,%esp
}
  802415:	90                   	nop
  802416:	c9                   	leave  
  802417:	c3                   	ret    

00802418 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
  80241b:	83 ec 04             	sub    $0x4,%esp
  80241e:	8b 45 10             	mov    0x10(%ebp),%eax
  802421:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802424:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802427:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	6a 00                	push   $0x0
  802430:	51                   	push   %ecx
  802431:	52                   	push   %edx
  802432:	ff 75 0c             	pushl  0xc(%ebp)
  802435:	50                   	push   %eax
  802436:	6a 15                	push   $0x15
  802438:	e8 e4 fd ff ff       	call   802221 <syscall>
  80243d:	83 c4 18             	add    $0x18,%esp
}
  802440:	c9                   	leave  
  802441:	c3                   	ret    

00802442 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802445:	8b 55 0c             	mov    0xc(%ebp),%edx
  802448:	8b 45 08             	mov    0x8(%ebp),%eax
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	52                   	push   %edx
  802452:	50                   	push   %eax
  802453:	6a 16                	push   $0x16
  802455:	e8 c7 fd ff ff       	call   802221 <syscall>
  80245a:	83 c4 18             	add    $0x18,%esp
}
  80245d:	c9                   	leave  
  80245e:	c3                   	ret    

0080245f <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802462:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802465:	8b 55 0c             	mov    0xc(%ebp),%edx
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	51                   	push   %ecx
  802470:	52                   	push   %edx
  802471:	50                   	push   %eax
  802472:	6a 17                	push   $0x17
  802474:	e8 a8 fd ff ff       	call   802221 <syscall>
  802479:	83 c4 18             	add    $0x18,%esp
}
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802481:	8b 55 0c             	mov    0xc(%ebp),%edx
  802484:	8b 45 08             	mov    0x8(%ebp),%eax
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	52                   	push   %edx
  80248e:	50                   	push   %eax
  80248f:	6a 18                	push   $0x18
  802491:	e8 8b fd ff ff       	call   802221 <syscall>
  802496:	83 c4 18             	add    $0x18,%esp
}
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	6a 00                	push   $0x0
  8024a3:	ff 75 14             	pushl  0x14(%ebp)
  8024a6:	ff 75 10             	pushl  0x10(%ebp)
  8024a9:	ff 75 0c             	pushl  0xc(%ebp)
  8024ac:	50                   	push   %eax
  8024ad:	6a 19                	push   $0x19
  8024af:	e8 6d fd ff ff       	call   802221 <syscall>
  8024b4:	83 c4 18             	add    $0x18,%esp
}
  8024b7:	c9                   	leave  
  8024b8:	c3                   	ret    

008024b9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8024bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	50                   	push   %eax
  8024c8:	6a 1a                	push   $0x1a
  8024ca:	e8 52 fd ff ff       	call   802221 <syscall>
  8024cf:	83 c4 18             	add    $0x18,%esp
}
  8024d2:	90                   	nop
  8024d3:	c9                   	leave  
  8024d4:	c3                   	ret    

008024d5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	50                   	push   %eax
  8024e4:	6a 1b                	push   $0x1b
  8024e6:	e8 36 fd ff ff       	call   802221 <syscall>
  8024eb:	83 c4 18             	add    $0x18,%esp
}
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 05                	push   $0x5
  8024ff:	e8 1d fd ff ff       	call   802221 <syscall>
  802504:	83 c4 18             	add    $0x18,%esp
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 06                	push   $0x6
  802518:	e8 04 fd ff ff       	call   802221 <syscall>
  80251d:	83 c4 18             	add    $0x18,%esp
}
  802520:	c9                   	leave  
  802521:	c3                   	ret    

00802522 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 07                	push   $0x7
  802531:	e8 eb fc ff ff       	call   802221 <syscall>
  802536:	83 c4 18             	add    $0x18,%esp
}
  802539:	c9                   	leave  
  80253a:	c3                   	ret    

0080253b <sys_exit_env>:


void sys_exit_env(void)
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 1c                	push   $0x1c
  80254a:	e8 d2 fc ff ff       	call   802221 <syscall>
  80254f:	83 c4 18             	add    $0x18,%esp
}
  802552:	90                   	nop
  802553:	c9                   	leave  
  802554:	c3                   	ret    

00802555 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802555:	55                   	push   %ebp
  802556:	89 e5                	mov    %esp,%ebp
  802558:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80255b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80255e:	8d 50 04             	lea    0x4(%eax),%edx
  802561:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	52                   	push   %edx
  80256b:	50                   	push   %eax
  80256c:	6a 1d                	push   $0x1d
  80256e:	e8 ae fc ff ff       	call   802221 <syscall>
  802573:	83 c4 18             	add    $0x18,%esp
	return result;
  802576:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802579:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80257c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80257f:	89 01                	mov    %eax,(%ecx)
  802581:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802584:	8b 45 08             	mov    0x8(%ebp),%eax
  802587:	c9                   	leave  
  802588:	c2 04 00             	ret    $0x4

0080258b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80258b:	55                   	push   %ebp
  80258c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	ff 75 10             	pushl  0x10(%ebp)
  802595:	ff 75 0c             	pushl  0xc(%ebp)
  802598:	ff 75 08             	pushl  0x8(%ebp)
  80259b:	6a 13                	push   $0x13
  80259d:	e8 7f fc ff ff       	call   802221 <syscall>
  8025a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a5:	90                   	nop
}
  8025a6:	c9                   	leave  
  8025a7:	c3                   	ret    

008025a8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 1e                	push   $0x1e
  8025b7:	e8 65 fc ff ff       	call   802221 <syscall>
  8025bc:	83 c4 18             	add    $0x18,%esp
}
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    

008025c1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8025c1:	55                   	push   %ebp
  8025c2:	89 e5                	mov    %esp,%ebp
  8025c4:	83 ec 04             	sub    $0x4,%esp
  8025c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025cd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	50                   	push   %eax
  8025da:	6a 1f                	push   $0x1f
  8025dc:	e8 40 fc ff ff       	call   802221 <syscall>
  8025e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8025e4:	90                   	nop
}
  8025e5:	c9                   	leave  
  8025e6:	c3                   	ret    

008025e7 <rsttst>:
void rsttst()
{
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 21                	push   $0x21
  8025f6:	e8 26 fc ff ff       	call   802221 <syscall>
  8025fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8025fe:	90                   	nop
}
  8025ff:	c9                   	leave  
  802600:	c3                   	ret    

00802601 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
  802604:	83 ec 04             	sub    $0x4,%esp
  802607:	8b 45 14             	mov    0x14(%ebp),%eax
  80260a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80260d:	8b 55 18             	mov    0x18(%ebp),%edx
  802610:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802614:	52                   	push   %edx
  802615:	50                   	push   %eax
  802616:	ff 75 10             	pushl  0x10(%ebp)
  802619:	ff 75 0c             	pushl  0xc(%ebp)
  80261c:	ff 75 08             	pushl  0x8(%ebp)
  80261f:	6a 20                	push   $0x20
  802621:	e8 fb fb ff ff       	call   802221 <syscall>
  802626:	83 c4 18             	add    $0x18,%esp
	return ;
  802629:	90                   	nop
}
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <chktst>:
void chktst(uint32 n)
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80262f:	6a 00                	push   $0x0
  802631:	6a 00                	push   $0x0
  802633:	6a 00                	push   $0x0
  802635:	6a 00                	push   $0x0
  802637:	ff 75 08             	pushl  0x8(%ebp)
  80263a:	6a 22                	push   $0x22
  80263c:	e8 e0 fb ff ff       	call   802221 <syscall>
  802641:	83 c4 18             	add    $0x18,%esp
	return ;
  802644:	90                   	nop
}
  802645:	c9                   	leave  
  802646:	c3                   	ret    

00802647 <inctst>:

void inctst()
{
  802647:	55                   	push   %ebp
  802648:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 23                	push   $0x23
  802656:	e8 c6 fb ff ff       	call   802221 <syscall>
  80265b:	83 c4 18             	add    $0x18,%esp
	return ;
  80265e:	90                   	nop
}
  80265f:	c9                   	leave  
  802660:	c3                   	ret    

00802661 <gettst>:
uint32 gettst()
{
  802661:	55                   	push   %ebp
  802662:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802664:	6a 00                	push   $0x0
  802666:	6a 00                	push   $0x0
  802668:	6a 00                	push   $0x0
  80266a:	6a 00                	push   $0x0
  80266c:	6a 00                	push   $0x0
  80266e:	6a 24                	push   $0x24
  802670:	e8 ac fb ff ff       	call   802221 <syscall>
  802675:	83 c4 18             	add    $0x18,%esp
}
  802678:	c9                   	leave  
  802679:	c3                   	ret    

0080267a <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80267a:	55                   	push   %ebp
  80267b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	6a 25                	push   $0x25
  802689:	e8 93 fb ff ff       	call   802221 <syscall>
  80268e:	83 c4 18             	add    $0x18,%esp
  802691:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802696:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  80269b:	c9                   	leave  
  80269c:	c3                   	ret    

0080269d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80269d:	55                   	push   %ebp
  80269e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8026a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a3:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	ff 75 08             	pushl  0x8(%ebp)
  8026b3:	6a 26                	push   $0x26
  8026b5:	e8 67 fb ff ff       	call   802221 <syscall>
  8026ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8026bd:	90                   	nop
}
  8026be:	c9                   	leave  
  8026bf:	c3                   	ret    

008026c0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
  8026c3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d0:	6a 00                	push   $0x0
  8026d2:	53                   	push   %ebx
  8026d3:	51                   	push   %ecx
  8026d4:	52                   	push   %edx
  8026d5:	50                   	push   %eax
  8026d6:	6a 27                	push   $0x27
  8026d8:	e8 44 fb ff ff       	call   802221 <syscall>
  8026dd:	83 c4 18             	add    $0x18,%esp
}
  8026e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026e3:	c9                   	leave  
  8026e4:	c3                   	ret    

008026e5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ee:	6a 00                	push   $0x0
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 00                	push   $0x0
  8026f4:	52                   	push   %edx
  8026f5:	50                   	push   %eax
  8026f6:	6a 28                	push   $0x28
  8026f8:	e8 24 fb ff ff       	call   802221 <syscall>
  8026fd:	83 c4 18             	add    $0x18,%esp
}
  802700:	c9                   	leave  
  802701:	c3                   	ret    

00802702 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802702:	55                   	push   %ebp
  802703:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802705:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802708:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270b:	8b 45 08             	mov    0x8(%ebp),%eax
  80270e:	6a 00                	push   $0x0
  802710:	51                   	push   %ecx
  802711:	ff 75 10             	pushl  0x10(%ebp)
  802714:	52                   	push   %edx
  802715:	50                   	push   %eax
  802716:	6a 29                	push   $0x29
  802718:	e8 04 fb ff ff       	call   802221 <syscall>
  80271d:	83 c4 18             	add    $0x18,%esp
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	ff 75 10             	pushl  0x10(%ebp)
  80272c:	ff 75 0c             	pushl  0xc(%ebp)
  80272f:	ff 75 08             	pushl  0x8(%ebp)
  802732:	6a 12                	push   $0x12
  802734:	e8 e8 fa ff ff       	call   802221 <syscall>
  802739:	83 c4 18             	add    $0x18,%esp
	return ;
  80273c:	90                   	nop
}
  80273d:	c9                   	leave  
  80273e:	c3                   	ret    

0080273f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80273f:	55                   	push   %ebp
  802740:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802742:	8b 55 0c             	mov    0xc(%ebp),%edx
  802745:	8b 45 08             	mov    0x8(%ebp),%eax
  802748:	6a 00                	push   $0x0
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	52                   	push   %edx
  80274f:	50                   	push   %eax
  802750:	6a 2a                	push   $0x2a
  802752:	e8 ca fa ff ff       	call   802221 <syscall>
  802757:	83 c4 18             	add    $0x18,%esp
	return;
  80275a:	90                   	nop
}
  80275b:	c9                   	leave  
  80275c:	c3                   	ret    

0080275d <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80275d:	55                   	push   %ebp
  80275e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802760:	6a 00                	push   $0x0
  802762:	6a 00                	push   $0x0
  802764:	6a 00                	push   $0x0
  802766:	6a 00                	push   $0x0
  802768:	6a 00                	push   $0x0
  80276a:	6a 2b                	push   $0x2b
  80276c:	e8 b0 fa ff ff       	call   802221 <syscall>
  802771:	83 c4 18             	add    $0x18,%esp
}
  802774:	c9                   	leave  
  802775:	c3                   	ret    

00802776 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	ff 75 0c             	pushl  0xc(%ebp)
  802782:	ff 75 08             	pushl  0x8(%ebp)
  802785:	6a 2d                	push   $0x2d
  802787:	e8 95 fa ff ff       	call   802221 <syscall>
  80278c:	83 c4 18             	add    $0x18,%esp
	return;
  80278f:	90                   	nop
}
  802790:	c9                   	leave  
  802791:	c3                   	ret    

00802792 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802792:	55                   	push   %ebp
  802793:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802795:	6a 00                	push   $0x0
  802797:	6a 00                	push   $0x0
  802799:	6a 00                	push   $0x0
  80279b:	ff 75 0c             	pushl  0xc(%ebp)
  80279e:	ff 75 08             	pushl  0x8(%ebp)
  8027a1:	6a 2c                	push   $0x2c
  8027a3:	e8 79 fa ff ff       	call   802221 <syscall>
  8027a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8027ab:	90                   	nop
}
  8027ac:	c9                   	leave  
  8027ad:	c3                   	ret    

008027ae <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8027b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	52                   	push   %edx
  8027be:	50                   	push   %eax
  8027bf:	6a 2e                	push   $0x2e
  8027c1:	e8 5b fa ff ff       	call   802221 <syscall>
  8027c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8027c9:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  8027ca:	c9                   	leave  
  8027cb:	c3                   	ret    

008027cc <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8027cc:	55                   	push   %ebp
  8027cd:	89 e5                	mov    %esp,%ebp
  8027cf:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8027d2:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  8027d9:	72 09                	jb     8027e4 <to_page_va+0x18>
  8027db:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  8027e2:	72 14                	jb     8027f8 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8027e4:	83 ec 04             	sub    $0x4,%esp
  8027e7:	68 80 44 80 00       	push   $0x804480
  8027ec:	6a 15                	push   $0x15
  8027ee:	68 ab 44 80 00       	push   $0x8044ab
  8027f3:	e8 4e db ff ff       	call   800346 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8027f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fb:	ba 60 50 80 00       	mov    $0x805060,%edx
  802800:	29 d0                	sub    %edx,%eax
  802802:	c1 f8 02             	sar    $0x2,%eax
  802805:	89 c2                	mov    %eax,%edx
  802807:	89 d0                	mov    %edx,%eax
  802809:	c1 e0 02             	shl    $0x2,%eax
  80280c:	01 d0                	add    %edx,%eax
  80280e:	c1 e0 02             	shl    $0x2,%eax
  802811:	01 d0                	add    %edx,%eax
  802813:	c1 e0 02             	shl    $0x2,%eax
  802816:	01 d0                	add    %edx,%eax
  802818:	89 c1                	mov    %eax,%ecx
  80281a:	c1 e1 08             	shl    $0x8,%ecx
  80281d:	01 c8                	add    %ecx,%eax
  80281f:	89 c1                	mov    %eax,%ecx
  802821:	c1 e1 10             	shl    $0x10,%ecx
  802824:	01 c8                	add    %ecx,%eax
  802826:	01 c0                	add    %eax,%eax
  802828:	01 d0                	add    %edx,%eax
  80282a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	c1 e0 0c             	shl    $0xc,%eax
  802833:	89 c2                	mov    %eax,%edx
  802835:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80283a:	01 d0                	add    %edx,%eax
}
  80283c:	c9                   	leave  
  80283d:	c3                   	ret    

0080283e <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80283e:	55                   	push   %ebp
  80283f:	89 e5                	mov    %esp,%ebp
  802841:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802844:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802849:	8b 55 08             	mov    0x8(%ebp),%edx
  80284c:	29 c2                	sub    %eax,%edx
  80284e:	89 d0                	mov    %edx,%eax
  802850:	c1 e8 0c             	shr    $0xc,%eax
  802853:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802856:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285a:	78 09                	js     802865 <to_page_info+0x27>
  80285c:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802863:	7e 14                	jle    802879 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802865:	83 ec 04             	sub    $0x4,%esp
  802868:	68 c4 44 80 00       	push   $0x8044c4
  80286d:	6a 22                	push   $0x22
  80286f:	68 ab 44 80 00       	push   $0x8044ab
  802874:	e8 cd da ff ff       	call   800346 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802879:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287c:	89 d0                	mov    %edx,%eax
  80287e:	01 c0                	add    %eax,%eax
  802880:	01 d0                	add    %edx,%eax
  802882:	c1 e0 02             	shl    $0x2,%eax
  802885:	05 60 50 80 00       	add    $0x805060,%eax
}
  80288a:	c9                   	leave  
  80288b:	c3                   	ret    

0080288c <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80288c:	55                   	push   %ebp
  80288d:	89 e5                	mov    %esp,%ebp
  80288f:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802892:	8b 45 08             	mov    0x8(%ebp),%eax
  802895:	05 00 00 00 02       	add    $0x2000000,%eax
  80289a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80289d:	73 16                	jae    8028b5 <initialize_dynamic_allocator+0x29>
  80289f:	68 e8 44 80 00       	push   $0x8044e8
  8028a4:	68 0e 45 80 00       	push   $0x80450e
  8028a9:	6a 34                	push   $0x34
  8028ab:	68 ab 44 80 00       	push   $0x8044ab
  8028b0:	e8 91 da ff ff       	call   800346 <_panic>
		is_initialized = 1;
  8028b5:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  8028bc:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  8028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c2:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  8028c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ca:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  8028cf:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  8028d6:	00 00 00 
  8028d9:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8028e0:	00 00 00 
  8028e3:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  8028ea:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  8028ed:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  8028f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028fb:	eb 36                	jmp    802933 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	c1 e0 04             	shl    $0x4,%eax
  802903:	05 80 d0 81 00       	add    $0x81d080,%eax
  802908:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	c1 e0 04             	shl    $0x4,%eax
  802914:	05 84 d0 81 00       	add    $0x81d084,%eax
  802919:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	c1 e0 04             	shl    $0x4,%eax
  802925:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80292a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802930:	ff 45 f4             	incl   -0xc(%ebp)
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802939:	72 c2                	jb     8028fd <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  80293b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802941:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802946:	29 c2                	sub    %eax,%edx
  802948:	89 d0                	mov    %edx,%eax
  80294a:	c1 e8 0c             	shr    $0xc,%eax
  80294d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802950:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802957:	e9 c8 00 00 00       	jmp    802a24 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  80295c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80295f:	89 d0                	mov    %edx,%eax
  802961:	01 c0                	add    %eax,%eax
  802963:	01 d0                	add    %edx,%eax
  802965:	c1 e0 02             	shl    $0x2,%eax
  802968:	05 68 50 80 00       	add    $0x805068,%eax
  80296d:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802972:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802975:	89 d0                	mov    %edx,%eax
  802977:	01 c0                	add    %eax,%eax
  802979:	01 d0                	add    %edx,%eax
  80297b:	c1 e0 02             	shl    $0x2,%eax
  80297e:	05 6a 50 80 00       	add    $0x80506a,%eax
  802983:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802988:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80298e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802991:	89 c8                	mov    %ecx,%eax
  802993:	01 c0                	add    %eax,%eax
  802995:	01 c8                	add    %ecx,%eax
  802997:	c1 e0 02             	shl    $0x2,%eax
  80299a:	05 64 50 80 00       	add    $0x805064,%eax
  80299f:	89 10                	mov    %edx,(%eax)
  8029a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a4:	89 d0                	mov    %edx,%eax
  8029a6:	01 c0                	add    %eax,%eax
  8029a8:	01 d0                	add    %edx,%eax
  8029aa:	c1 e0 02             	shl    $0x2,%eax
  8029ad:	05 64 50 80 00       	add    $0x805064,%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	74 1b                	je     8029d3 <initialize_dynamic_allocator+0x147>
  8029b8:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8029be:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8029c1:	89 c8                	mov    %ecx,%eax
  8029c3:	01 c0                	add    %eax,%eax
  8029c5:	01 c8                	add    %ecx,%eax
  8029c7:	c1 e0 02             	shl    $0x2,%eax
  8029ca:	05 60 50 80 00       	add    $0x805060,%eax
  8029cf:	89 02                	mov    %eax,(%edx)
  8029d1:	eb 16                	jmp    8029e9 <initialize_dynamic_allocator+0x15d>
  8029d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029d6:	89 d0                	mov    %edx,%eax
  8029d8:	01 c0                	add    %eax,%eax
  8029da:	01 d0                	add    %edx,%eax
  8029dc:	c1 e0 02             	shl    $0x2,%eax
  8029df:	05 60 50 80 00       	add    $0x805060,%eax
  8029e4:	a3 48 50 80 00       	mov    %eax,0x805048
  8029e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ec:	89 d0                	mov    %edx,%eax
  8029ee:	01 c0                	add    %eax,%eax
  8029f0:	01 d0                	add    %edx,%eax
  8029f2:	c1 e0 02             	shl    $0x2,%eax
  8029f5:	05 60 50 80 00       	add    $0x805060,%eax
  8029fa:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8029ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a02:	89 d0                	mov    %edx,%eax
  802a04:	01 c0                	add    %eax,%eax
  802a06:	01 d0                	add    %edx,%eax
  802a08:	c1 e0 02             	shl    $0x2,%eax
  802a0b:	05 60 50 80 00       	add    $0x805060,%eax
  802a10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a16:	a1 54 50 80 00       	mov    0x805054,%eax
  802a1b:	40                   	inc    %eax
  802a1c:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802a21:	ff 45 f0             	incl   -0x10(%ebp)
  802a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a27:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802a2a:	0f 82 2c ff ff ff    	jb     80295c <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a33:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a36:	eb 2f                	jmp    802a67 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802a38:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a3b:	89 d0                	mov    %edx,%eax
  802a3d:	01 c0                	add    %eax,%eax
  802a3f:	01 d0                	add    %edx,%eax
  802a41:	c1 e0 02             	shl    $0x2,%eax
  802a44:	05 68 50 80 00       	add    $0x805068,%eax
  802a49:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802a4e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a51:	89 d0                	mov    %edx,%eax
  802a53:	01 c0                	add    %eax,%eax
  802a55:	01 d0                	add    %edx,%eax
  802a57:	c1 e0 02             	shl    $0x2,%eax
  802a5a:	05 6a 50 80 00       	add    $0x80506a,%eax
  802a5f:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802a64:	ff 45 ec             	incl   -0x14(%ebp)
  802a67:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802a6e:	76 c8                	jbe    802a38 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802a70:	90                   	nop
  802a71:	c9                   	leave  
  802a72:	c3                   	ret    

00802a73 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802a73:	55                   	push   %ebp
  802a74:	89 e5                	mov    %esp,%ebp
  802a76:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802a79:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a81:	29 c2                	sub    %eax,%edx
  802a83:	89 d0                	mov    %edx,%eax
  802a85:	c1 e8 0c             	shr    $0xc,%eax
  802a88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802a8b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a8e:	89 d0                	mov    %edx,%eax
  802a90:	01 c0                	add    %eax,%eax
  802a92:	01 d0                	add    %edx,%eax
  802a94:	c1 e0 02             	shl    $0x2,%eax
  802a97:	05 68 50 80 00       	add    $0x805068,%eax
  802a9c:	8b 00                	mov    (%eax),%eax
  802a9e:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802aa1:	c9                   	leave  
  802aa2:	c3                   	ret    

00802aa3 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802aa3:	55                   	push   %ebp
  802aa4:	89 e5                	mov    %esp,%ebp
  802aa6:	83 ec 14             	sub    $0x14,%esp
  802aa9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802aac:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802ab0:	77 07                	ja     802ab9 <nearest_pow2_ceil.1513+0x16>
  802ab2:	b8 01 00 00 00       	mov    $0x1,%eax
  802ab7:	eb 20                	jmp    802ad9 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802ab9:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802ac0:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802ac3:	eb 08                	jmp    802acd <nearest_pow2_ceil.1513+0x2a>
  802ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ac8:	01 c0                	add    %eax,%eax
  802aca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802acd:	d1 6d 08             	shrl   0x8(%ebp)
  802ad0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad4:	75 ef                	jne    802ac5 <nearest_pow2_ceil.1513+0x22>
        return power;
  802ad6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802ad9:	c9                   	leave  
  802ada:	c3                   	ret    

00802adb <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802adb:	55                   	push   %ebp
  802adc:	89 e5                	mov    %esp,%ebp
  802ade:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802ae1:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802ae8:	76 16                	jbe    802b00 <alloc_block+0x25>
  802aea:	68 24 45 80 00       	push   $0x804524
  802aef:	68 0e 45 80 00       	push   $0x80450e
  802af4:	6a 72                	push   $0x72
  802af6:	68 ab 44 80 00       	push   $0x8044ab
  802afb:	e8 46 d8 ff ff       	call   800346 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802b00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b04:	75 0a                	jne    802b10 <alloc_block+0x35>
  802b06:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0b:	e9 bd 04 00 00       	jmp    802fcd <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802b10:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b1d:	73 06                	jae    802b25 <alloc_block+0x4a>
        size = min_block_size;
  802b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b22:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802b25:	83 ec 0c             	sub    $0xc,%esp
  802b28:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802b2b:	ff 75 08             	pushl  0x8(%ebp)
  802b2e:	89 c1                	mov    %eax,%ecx
  802b30:	e8 6e ff ff ff       	call   802aa3 <nearest_pow2_ceil.1513>
  802b35:	83 c4 10             	add    $0x10,%esp
  802b38:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802b3b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b3e:	83 ec 0c             	sub    $0xc,%esp
  802b41:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802b44:	52                   	push   %edx
  802b45:	89 c1                	mov    %eax,%ecx
  802b47:	e8 83 04 00 00       	call   802fcf <log2_ceil.1520>
  802b4c:	83 c4 10             	add    $0x10,%esp
  802b4f:	83 e8 03             	sub    $0x3,%eax
  802b52:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802b55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b58:	c1 e0 04             	shl    $0x4,%eax
  802b5b:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b60:	8b 00                	mov    (%eax),%eax
  802b62:	85 c0                	test   %eax,%eax
  802b64:	0f 84 d8 00 00 00    	je     802c42 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802b6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b6d:	c1 e0 04             	shl    $0x4,%eax
  802b70:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802b7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b7e:	75 17                	jne    802b97 <alloc_block+0xbc>
  802b80:	83 ec 04             	sub    $0x4,%esp
  802b83:	68 45 45 80 00       	push   $0x804545
  802b88:	68 98 00 00 00       	push   $0x98
  802b8d:	68 ab 44 80 00       	push   $0x8044ab
  802b92:	e8 af d7 ff ff       	call   800346 <_panic>
  802b97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	85 c0                	test   %eax,%eax
  802b9e:	74 10                	je     802bb0 <alloc_block+0xd5>
  802ba0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba3:	8b 00                	mov    (%eax),%eax
  802ba5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ba8:	8b 52 04             	mov    0x4(%edx),%edx
  802bab:	89 50 04             	mov    %edx,0x4(%eax)
  802bae:	eb 14                	jmp    802bc4 <alloc_block+0xe9>
  802bb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb3:	8b 40 04             	mov    0x4(%eax),%eax
  802bb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bb9:	c1 e2 04             	shl    $0x4,%edx
  802bbc:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802bc2:	89 02                	mov    %eax,(%edx)
  802bc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc7:	8b 40 04             	mov    0x4(%eax),%eax
  802bca:	85 c0                	test   %eax,%eax
  802bcc:	74 0f                	je     802bdd <alloc_block+0x102>
  802bce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd1:	8b 40 04             	mov    0x4(%eax),%eax
  802bd4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bd7:	8b 12                	mov    (%edx),%edx
  802bd9:	89 10                	mov    %edx,(%eax)
  802bdb:	eb 13                	jmp    802bf0 <alloc_block+0x115>
  802bdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be0:	8b 00                	mov    (%eax),%eax
  802be2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802be5:	c1 e2 04             	shl    $0x4,%edx
  802be8:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802bee:	89 02                	mov    %eax,(%edx)
  802bf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bfc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c06:	c1 e0 04             	shl    $0x4,%eax
  802c09:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	8d 50 ff             	lea    -0x1(%eax),%edx
  802c13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c16:	c1 e0 04             	shl    $0x4,%eax
  802c19:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802c1e:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802c20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c23:	83 ec 0c             	sub    $0xc,%esp
  802c26:	50                   	push   %eax
  802c27:	e8 12 fc ff ff       	call   80283e <to_page_info>
  802c2c:	83 c4 10             	add    $0x10,%esp
  802c2f:	89 c2                	mov    %eax,%edx
  802c31:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802c35:	48                   	dec    %eax
  802c36:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802c3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c3d:	e9 8b 03 00 00       	jmp    802fcd <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802c42:	a1 48 50 80 00       	mov    0x805048,%eax
  802c47:	85 c0                	test   %eax,%eax
  802c49:	0f 84 64 02 00 00    	je     802eb3 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802c4f:	a1 48 50 80 00       	mov    0x805048,%eax
  802c54:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802c57:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c5b:	75 17                	jne    802c74 <alloc_block+0x199>
  802c5d:	83 ec 04             	sub    $0x4,%esp
  802c60:	68 45 45 80 00       	push   $0x804545
  802c65:	68 a0 00 00 00       	push   $0xa0
  802c6a:	68 ab 44 80 00       	push   $0x8044ab
  802c6f:	e8 d2 d6 ff ff       	call   800346 <_panic>
  802c74:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	74 10                	je     802c8d <alloc_block+0x1b2>
  802c7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c80:	8b 00                	mov    (%eax),%eax
  802c82:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c85:	8b 52 04             	mov    0x4(%edx),%edx
  802c88:	89 50 04             	mov    %edx,0x4(%eax)
  802c8b:	eb 0b                	jmp    802c98 <alloc_block+0x1bd>
  802c8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c90:	8b 40 04             	mov    0x4(%eax),%eax
  802c93:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802c98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c9b:	8b 40 04             	mov    0x4(%eax),%eax
  802c9e:	85 c0                	test   %eax,%eax
  802ca0:	74 0f                	je     802cb1 <alloc_block+0x1d6>
  802ca2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ca5:	8b 40 04             	mov    0x4(%eax),%eax
  802ca8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cab:	8b 12                	mov    (%edx),%edx
  802cad:	89 10                	mov    %edx,(%eax)
  802caf:	eb 0a                	jmp    802cbb <alloc_block+0x1e0>
  802cb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	a3 48 50 80 00       	mov    %eax,0x805048
  802cbb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cce:	a1 54 50 80 00       	mov    0x805054,%eax
  802cd3:	48                   	dec    %eax
  802cd4:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802cd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cdc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cdf:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802ce3:	b8 00 10 00 00       	mov    $0x1000,%eax
  802ce8:	99                   	cltd   
  802ce9:	f7 7d e8             	idivl  -0x18(%ebp)
  802cec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cef:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802cf3:	83 ec 0c             	sub    $0xc,%esp
  802cf6:	ff 75 dc             	pushl  -0x24(%ebp)
  802cf9:	e8 ce fa ff ff       	call   8027cc <to_page_va>
  802cfe:	83 c4 10             	add    $0x10,%esp
  802d01:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802d04:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d07:	83 ec 0c             	sub    $0xc,%esp
  802d0a:	50                   	push   %eax
  802d0b:	e8 c0 ee ff ff       	call   801bd0 <get_page>
  802d10:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802d13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d1a:	e9 aa 00 00 00       	jmp    802dc9 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802d26:	89 c2                	mov    %eax,%edx
  802d28:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d2b:	01 d0                	add    %edx,%eax
  802d2d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802d30:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d34:	75 17                	jne    802d4d <alloc_block+0x272>
  802d36:	83 ec 04             	sub    $0x4,%esp
  802d39:	68 64 45 80 00       	push   $0x804564
  802d3e:	68 aa 00 00 00       	push   $0xaa
  802d43:	68 ab 44 80 00       	push   $0x8044ab
  802d48:	e8 f9 d5 ff ff       	call   800346 <_panic>
  802d4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d50:	c1 e0 04             	shl    $0x4,%eax
  802d53:	05 84 d0 81 00       	add    $0x81d084,%eax
  802d58:	8b 10                	mov    (%eax),%edx
  802d5a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d5d:	89 50 04             	mov    %edx,0x4(%eax)
  802d60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d63:	8b 40 04             	mov    0x4(%eax),%eax
  802d66:	85 c0                	test   %eax,%eax
  802d68:	74 14                	je     802d7e <alloc_block+0x2a3>
  802d6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d6d:	c1 e0 04             	shl    $0x4,%eax
  802d70:	05 84 d0 81 00       	add    $0x81d084,%eax
  802d75:	8b 00                	mov    (%eax),%eax
  802d77:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802d7a:	89 10                	mov    %edx,(%eax)
  802d7c:	eb 11                	jmp    802d8f <alloc_block+0x2b4>
  802d7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d81:	c1 e0 04             	shl    $0x4,%eax
  802d84:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802d8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d8d:	89 02                	mov    %eax,(%edx)
  802d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d92:	c1 e0 04             	shl    $0x4,%eax
  802d95:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802d9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d9e:	89 02                	mov    %eax,(%edx)
  802da0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802da3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dac:	c1 e0 04             	shl    $0x4,%eax
  802daf:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802db4:	8b 00                	mov    (%eax),%eax
  802db6:	8d 50 01             	lea    0x1(%eax),%edx
  802db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dbc:	c1 e0 04             	shl    $0x4,%eax
  802dbf:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802dc4:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802dc6:	ff 45 f4             	incl   -0xc(%ebp)
  802dc9:	b8 00 10 00 00       	mov    $0x1000,%eax
  802dce:	99                   	cltd   
  802dcf:	f7 7d e8             	idivl  -0x18(%ebp)
  802dd2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802dd5:	0f 8f 44 ff ff ff    	jg     802d1f <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dde:	c1 e0 04             	shl    $0x4,%eax
  802de1:	05 80 d0 81 00       	add    $0x81d080,%eax
  802de6:	8b 00                	mov    (%eax),%eax
  802de8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802deb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802def:	75 17                	jne    802e08 <alloc_block+0x32d>
  802df1:	83 ec 04             	sub    $0x4,%esp
  802df4:	68 45 45 80 00       	push   $0x804545
  802df9:	68 ae 00 00 00       	push   $0xae
  802dfe:	68 ab 44 80 00       	push   $0x8044ab
  802e03:	e8 3e d5 ff ff       	call   800346 <_panic>
  802e08:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e0b:	8b 00                	mov    (%eax),%eax
  802e0d:	85 c0                	test   %eax,%eax
  802e0f:	74 10                	je     802e21 <alloc_block+0x346>
  802e11:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e14:	8b 00                	mov    (%eax),%eax
  802e16:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e19:	8b 52 04             	mov    0x4(%edx),%edx
  802e1c:	89 50 04             	mov    %edx,0x4(%eax)
  802e1f:	eb 14                	jmp    802e35 <alloc_block+0x35a>
  802e21:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e24:	8b 40 04             	mov    0x4(%eax),%eax
  802e27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e2a:	c1 e2 04             	shl    $0x4,%edx
  802e2d:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802e33:	89 02                	mov    %eax,(%edx)
  802e35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e38:	8b 40 04             	mov    0x4(%eax),%eax
  802e3b:	85 c0                	test   %eax,%eax
  802e3d:	74 0f                	je     802e4e <alloc_block+0x373>
  802e3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e42:	8b 40 04             	mov    0x4(%eax),%eax
  802e45:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e48:	8b 12                	mov    (%edx),%edx
  802e4a:	89 10                	mov    %edx,(%eax)
  802e4c:	eb 13                	jmp    802e61 <alloc_block+0x386>
  802e4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e51:	8b 00                	mov    (%eax),%eax
  802e53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e56:	c1 e2 04             	shl    $0x4,%edx
  802e59:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802e5f:	89 02                	mov    %eax,(%edx)
  802e61:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e77:	c1 e0 04             	shl    $0x4,%eax
  802e7a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e7f:	8b 00                	mov    (%eax),%eax
  802e81:	8d 50 ff             	lea    -0x1(%eax),%edx
  802e84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e87:	c1 e0 04             	shl    $0x4,%eax
  802e8a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e8f:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802e91:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e94:	83 ec 0c             	sub    $0xc,%esp
  802e97:	50                   	push   %eax
  802e98:	e8 a1 f9 ff ff       	call   80283e <to_page_info>
  802e9d:	83 c4 10             	add    $0x10,%esp
  802ea0:	89 c2                	mov    %eax,%edx
  802ea2:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802ea6:	48                   	dec    %eax
  802ea7:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802eab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802eae:	e9 1a 01 00 00       	jmp    802fcd <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802eb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb6:	40                   	inc    %eax
  802eb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802eba:	e9 ed 00 00 00       	jmp    802fac <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec2:	c1 e0 04             	shl    $0x4,%eax
  802ec5:	05 80 d0 81 00       	add    $0x81d080,%eax
  802eca:	8b 00                	mov    (%eax),%eax
  802ecc:	85 c0                	test   %eax,%eax
  802ece:	0f 84 d5 00 00 00    	je     802fa9 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed7:	c1 e0 04             	shl    $0x4,%eax
  802eda:	05 80 d0 81 00       	add    $0x81d080,%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  802ee4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ee8:	75 17                	jne    802f01 <alloc_block+0x426>
  802eea:	83 ec 04             	sub    $0x4,%esp
  802eed:	68 45 45 80 00       	push   $0x804545
  802ef2:	68 b8 00 00 00       	push   $0xb8
  802ef7:	68 ab 44 80 00       	push   $0x8044ab
  802efc:	e8 45 d4 ff ff       	call   800346 <_panic>
  802f01:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f04:	8b 00                	mov    (%eax),%eax
  802f06:	85 c0                	test   %eax,%eax
  802f08:	74 10                	je     802f1a <alloc_block+0x43f>
  802f0a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f0d:	8b 00                	mov    (%eax),%eax
  802f0f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f12:	8b 52 04             	mov    0x4(%edx),%edx
  802f15:	89 50 04             	mov    %edx,0x4(%eax)
  802f18:	eb 14                	jmp    802f2e <alloc_block+0x453>
  802f1a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f1d:	8b 40 04             	mov    0x4(%eax),%eax
  802f20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f23:	c1 e2 04             	shl    $0x4,%edx
  802f26:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802f2c:	89 02                	mov    %eax,(%edx)
  802f2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f31:	8b 40 04             	mov    0x4(%eax),%eax
  802f34:	85 c0                	test   %eax,%eax
  802f36:	74 0f                	je     802f47 <alloc_block+0x46c>
  802f38:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f3b:	8b 40 04             	mov    0x4(%eax),%eax
  802f3e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f41:	8b 12                	mov    (%edx),%edx
  802f43:	89 10                	mov    %edx,(%eax)
  802f45:	eb 13                	jmp    802f5a <alloc_block+0x47f>
  802f47:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f4f:	c1 e2 04             	shl    $0x4,%edx
  802f52:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802f58:	89 02                	mov    %eax,(%edx)
  802f5a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f63:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f70:	c1 e0 04             	shl    $0x4,%eax
  802f73:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f78:	8b 00                	mov    (%eax),%eax
  802f7a:	8d 50 ff             	lea    -0x1(%eax),%edx
  802f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f80:	c1 e0 04             	shl    $0x4,%eax
  802f83:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f88:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  802f8a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f8d:	83 ec 0c             	sub    $0xc,%esp
  802f90:	50                   	push   %eax
  802f91:	e8 a8 f8 ff ff       	call   80283e <to_page_info>
  802f96:	83 c4 10             	add    $0x10,%esp
  802f99:	89 c2                	mov    %eax,%edx
  802f9b:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802f9f:	48                   	dec    %eax
  802fa0:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  802fa4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fa7:	eb 24                	jmp    802fcd <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802fa9:	ff 45 f0             	incl   -0x10(%ebp)
  802fac:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802fb0:	0f 8e 09 ff ff ff    	jle    802ebf <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  802fb6:	83 ec 04             	sub    $0x4,%esp
  802fb9:	68 87 45 80 00       	push   $0x804587
  802fbe:	68 bf 00 00 00       	push   $0xbf
  802fc3:	68 ab 44 80 00       	push   $0x8044ab
  802fc8:	e8 79 d3 ff ff       	call   800346 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  802fcd:	c9                   	leave  
  802fce:	c3                   	ret    

00802fcf <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  802fcf:	55                   	push   %ebp
  802fd0:	89 e5                	mov    %esp,%ebp
  802fd2:	83 ec 14             	sub    $0x14,%esp
  802fd5:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  802fd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fdc:	75 07                	jne    802fe5 <log2_ceil.1520+0x16>
  802fde:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe3:	eb 1b                	jmp    803000 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  802fe5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  802fec:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  802fef:	eb 06                	jmp    802ff7 <log2_ceil.1520+0x28>
            x >>= 1;
  802ff1:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  802ff4:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  802ff7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ffb:	75 f4                	jne    802ff1 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  802ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803000:	c9                   	leave  
  803001:	c3                   	ret    

00803002 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  803002:	55                   	push   %ebp
  803003:	89 e5                	mov    %esp,%ebp
  803005:	83 ec 14             	sub    $0x14,%esp
  803008:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  80300b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300f:	75 07                	jne    803018 <log2_ceil.1547+0x16>
  803011:	b8 00 00 00 00       	mov    $0x0,%eax
  803016:	eb 1b                	jmp    803033 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  803018:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  80301f:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  803022:	eb 06                	jmp    80302a <log2_ceil.1547+0x28>
			x >>= 1;
  803024:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  803027:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  80302a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302e:	75 f4                	jne    803024 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  803030:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803033:	c9                   	leave  
  803034:	c3                   	ret    

00803035 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803035:	55                   	push   %ebp
  803036:	89 e5                	mov    %esp,%ebp
  803038:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80303b:	8b 55 08             	mov    0x8(%ebp),%edx
  80303e:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803043:	39 c2                	cmp    %eax,%edx
  803045:	72 0c                	jb     803053 <free_block+0x1e>
  803047:	8b 55 08             	mov    0x8(%ebp),%edx
  80304a:	a1 40 50 80 00       	mov    0x805040,%eax
  80304f:	39 c2                	cmp    %eax,%edx
  803051:	72 19                	jb     80306c <free_block+0x37>
  803053:	68 8c 45 80 00       	push   $0x80458c
  803058:	68 0e 45 80 00       	push   $0x80450e
  80305d:	68 d0 00 00 00       	push   $0xd0
  803062:	68 ab 44 80 00       	push   $0x8044ab
  803067:	e8 da d2 ff ff       	call   800346 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80306c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803070:	0f 84 42 03 00 00    	je     8033b8 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  803076:	8b 55 08             	mov    0x8(%ebp),%edx
  803079:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80307e:	39 c2                	cmp    %eax,%edx
  803080:	72 0c                	jb     80308e <free_block+0x59>
  803082:	8b 55 08             	mov    0x8(%ebp),%edx
  803085:	a1 40 50 80 00       	mov    0x805040,%eax
  80308a:	39 c2                	cmp    %eax,%edx
  80308c:	72 17                	jb     8030a5 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  80308e:	83 ec 04             	sub    $0x4,%esp
  803091:	68 c4 45 80 00       	push   $0x8045c4
  803096:	68 e6 00 00 00       	push   $0xe6
  80309b:	68 ab 44 80 00       	push   $0x8044ab
  8030a0:	e8 a1 d2 ff ff       	call   800346 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8030a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a8:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8030ad:	29 c2                	sub    %eax,%edx
  8030af:	89 d0                	mov    %edx,%eax
  8030b1:	83 e0 07             	and    $0x7,%eax
  8030b4:	85 c0                	test   %eax,%eax
  8030b6:	74 17                	je     8030cf <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8030b8:	83 ec 04             	sub    $0x4,%esp
  8030bb:	68 f8 45 80 00       	push   $0x8045f8
  8030c0:	68 ea 00 00 00       	push   $0xea
  8030c5:	68 ab 44 80 00       	push   $0x8044ab
  8030ca:	e8 77 d2 ff ff       	call   800346 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	83 ec 0c             	sub    $0xc,%esp
  8030d5:	50                   	push   %eax
  8030d6:	e8 63 f7 ff ff       	call   80283e <to_page_info>
  8030db:	83 c4 10             	add    $0x10,%esp
  8030de:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8030e1:	83 ec 0c             	sub    $0xc,%esp
  8030e4:	ff 75 08             	pushl  0x8(%ebp)
  8030e7:	e8 87 f9 ff ff       	call   802a73 <get_block_size>
  8030ec:	83 c4 10             	add    $0x10,%esp
  8030ef:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8030f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030f6:	75 17                	jne    80310f <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8030f8:	83 ec 04             	sub    $0x4,%esp
  8030fb:	68 24 46 80 00       	push   $0x804624
  803100:	68 f1 00 00 00       	push   $0xf1
  803105:	68 ab 44 80 00       	push   $0x8044ab
  80310a:	e8 37 d2 ff ff       	call   800346 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  80310f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803112:	83 ec 0c             	sub    $0xc,%esp
  803115:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803118:	52                   	push   %edx
  803119:	89 c1                	mov    %eax,%ecx
  80311b:	e8 e2 fe ff ff       	call   803002 <log2_ceil.1547>
  803120:	83 c4 10             	add    $0x10,%esp
  803123:	83 e8 03             	sub    $0x3,%eax
  803126:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803129:	8b 45 08             	mov    0x8(%ebp),%eax
  80312c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  80312f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803133:	75 17                	jne    80314c <free_block+0x117>
  803135:	83 ec 04             	sub    $0x4,%esp
  803138:	68 70 46 80 00       	push   $0x804670
  80313d:	68 f6 00 00 00       	push   $0xf6
  803142:	68 ab 44 80 00       	push   $0x8044ab
  803147:	e8 fa d1 ff ff       	call   800346 <_panic>
  80314c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314f:	c1 e0 04             	shl    $0x4,%eax
  803152:	05 80 d0 81 00       	add    $0x81d080,%eax
  803157:	8b 10                	mov    (%eax),%edx
  803159:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80315c:	89 10                	mov    %edx,(%eax)
  80315e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803161:	8b 00                	mov    (%eax),%eax
  803163:	85 c0                	test   %eax,%eax
  803165:	74 15                	je     80317c <free_block+0x147>
  803167:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80316a:	c1 e0 04             	shl    $0x4,%eax
  80316d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803172:	8b 00                	mov    (%eax),%eax
  803174:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803177:	89 50 04             	mov    %edx,0x4(%eax)
  80317a:	eb 11                	jmp    80318d <free_block+0x158>
  80317c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317f:	c1 e0 04             	shl    $0x4,%eax
  803182:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803188:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80318b:	89 02                	mov    %eax,(%edx)
  80318d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803190:	c1 e0 04             	shl    $0x4,%eax
  803193:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803199:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80319c:	89 02                	mov    %eax,(%edx)
  80319e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ab:	c1 e0 04             	shl    $0x4,%eax
  8031ae:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031b3:	8b 00                	mov    (%eax),%eax
  8031b5:	8d 50 01             	lea    0x1(%eax),%edx
  8031b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031bb:	c1 e0 04             	shl    $0x4,%eax
  8031be:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031c3:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8031c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c8:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8031cc:	40                   	inc    %eax
  8031cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031d0:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8031d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d7:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031dc:	29 c2                	sub    %eax,%edx
  8031de:	89 d0                	mov    %edx,%eax
  8031e0:	c1 e8 0c             	shr    $0xc,%eax
  8031e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8031e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8031ed:	0f b7 c8             	movzwl %ax,%ecx
  8031f0:	b8 00 10 00 00       	mov    $0x1000,%eax
  8031f5:	99                   	cltd   
  8031f6:	f7 7d e8             	idivl  -0x18(%ebp)
  8031f9:	39 c1                	cmp    %eax,%ecx
  8031fb:	0f 85 b8 01 00 00    	jne    8033b9 <free_block+0x384>
    	uint32 blocks_removed = 0;
  803201:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803208:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80320b:	c1 e0 04             	shl    $0x4,%eax
  80320e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803218:	e9 d5 00 00 00       	jmp    8032f2 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  80321d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803220:	8b 00                	mov    (%eax),%eax
  803222:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803225:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803228:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80322d:	29 c2                	sub    %eax,%edx
  80322f:	89 d0                	mov    %edx,%eax
  803231:	c1 e8 0c             	shr    $0xc,%eax
  803234:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803237:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80323a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80323d:	0f 85 a9 00 00 00    	jne    8032ec <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  803243:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803247:	75 17                	jne    803260 <free_block+0x22b>
  803249:	83 ec 04             	sub    $0x4,%esp
  80324c:	68 45 45 80 00       	push   $0x804545
  803251:	68 04 01 00 00       	push   $0x104
  803256:	68 ab 44 80 00       	push   $0x8044ab
  80325b:	e8 e6 d0 ff ff       	call   800346 <_panic>
  803260:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803263:	8b 00                	mov    (%eax),%eax
  803265:	85 c0                	test   %eax,%eax
  803267:	74 10                	je     803279 <free_block+0x244>
  803269:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326c:	8b 00                	mov    (%eax),%eax
  80326e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803271:	8b 52 04             	mov    0x4(%edx),%edx
  803274:	89 50 04             	mov    %edx,0x4(%eax)
  803277:	eb 14                	jmp    80328d <free_block+0x258>
  803279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327c:	8b 40 04             	mov    0x4(%eax),%eax
  80327f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803282:	c1 e2 04             	shl    $0x4,%edx
  803285:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80328b:	89 02                	mov    %eax,(%edx)
  80328d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803290:	8b 40 04             	mov    0x4(%eax),%eax
  803293:	85 c0                	test   %eax,%eax
  803295:	74 0f                	je     8032a6 <free_block+0x271>
  803297:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329a:	8b 40 04             	mov    0x4(%eax),%eax
  80329d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032a0:	8b 12                	mov    (%edx),%edx
  8032a2:	89 10                	mov    %edx,(%eax)
  8032a4:	eb 13                	jmp    8032b9 <free_block+0x284>
  8032a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a9:	8b 00                	mov    (%eax),%eax
  8032ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032ae:	c1 e2 04             	shl    $0x4,%edx
  8032b1:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8032b7:	89 02                	mov    %eax,(%edx)
  8032b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032cf:	c1 e0 04             	shl    $0x4,%eax
  8032d2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032d7:	8b 00                	mov    (%eax),%eax
  8032d9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8032dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032df:	c1 e0 04             	shl    $0x4,%eax
  8032e2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032e7:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8032e9:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8032ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8032f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032f6:	0f 85 21 ff ff ff    	jne    80321d <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8032fc:	b8 00 10 00 00       	mov    $0x1000,%eax
  803301:	99                   	cltd   
  803302:	f7 7d e8             	idivl  -0x18(%ebp)
  803305:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803308:	74 17                	je     803321 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  80330a:	83 ec 04             	sub    $0x4,%esp
  80330d:	68 94 46 80 00       	push   $0x804694
  803312:	68 0c 01 00 00       	push   $0x10c
  803317:	68 ab 44 80 00       	push   $0x8044ab
  80331c:	e8 25 d0 ff ff       	call   800346 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803321:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803324:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  80332a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332d:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803333:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803337:	75 17                	jne    803350 <free_block+0x31b>
  803339:	83 ec 04             	sub    $0x4,%esp
  80333c:	68 64 45 80 00       	push   $0x804564
  803341:	68 11 01 00 00       	push   $0x111
  803346:	68 ab 44 80 00       	push   $0x8044ab
  80334b:	e8 f6 cf ff ff       	call   800346 <_panic>
  803350:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803356:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803359:	89 50 04             	mov    %edx,0x4(%eax)
  80335c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80335f:	8b 40 04             	mov    0x4(%eax),%eax
  803362:	85 c0                	test   %eax,%eax
  803364:	74 0c                	je     803372 <free_block+0x33d>
  803366:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80336b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80336e:	89 10                	mov    %edx,(%eax)
  803370:	eb 08                	jmp    80337a <free_block+0x345>
  803372:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803375:	a3 48 50 80 00       	mov    %eax,0x805048
  80337a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80337d:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803382:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803385:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80338b:	a1 54 50 80 00       	mov    0x805054,%eax
  803390:	40                   	inc    %eax
  803391:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803396:	83 ec 0c             	sub    $0xc,%esp
  803399:	ff 75 ec             	pushl  -0x14(%ebp)
  80339c:	e8 2b f4 ff ff       	call   8027cc <to_page_va>
  8033a1:	83 c4 10             	add    $0x10,%esp
  8033a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8033a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033aa:	83 ec 0c             	sub    $0xc,%esp
  8033ad:	50                   	push   %eax
  8033ae:	e8 69 e8 ff ff       	call   801c1c <return_page>
  8033b3:	83 c4 10             	add    $0x10,%esp
  8033b6:	eb 01                	jmp    8033b9 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8033b8:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8033b9:	c9                   	leave  
  8033ba:	c3                   	ret    

008033bb <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8033bb:	55                   	push   %ebp
  8033bc:	89 e5                	mov    %esp,%ebp
  8033be:	83 ec 14             	sub    $0x14,%esp
  8033c1:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8033c4:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8033c8:	77 07                	ja     8033d1 <nearest_pow2_ceil.1572+0x16>
      return 1;
  8033ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8033cf:	eb 20                	jmp    8033f1 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8033d1:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8033d8:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8033db:	eb 08                	jmp    8033e5 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8033dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033e0:	01 c0                	add    %eax,%eax
  8033e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8033e5:	d1 6d 08             	shrl   0x8(%ebp)
  8033e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ec:	75 ef                	jne    8033dd <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8033ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8033f1:	c9                   	leave  
  8033f2:	c3                   	ret    

008033f3 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8033f3:	55                   	push   %ebp
  8033f4:	89 e5                	mov    %esp,%ebp
  8033f6:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8033f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033fd:	75 13                	jne    803412 <realloc_block+0x1f>
    return alloc_block(new_size);
  8033ff:	83 ec 0c             	sub    $0xc,%esp
  803402:	ff 75 0c             	pushl  0xc(%ebp)
  803405:	e8 d1 f6 ff ff       	call   802adb <alloc_block>
  80340a:	83 c4 10             	add    $0x10,%esp
  80340d:	e9 d9 00 00 00       	jmp    8034eb <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803412:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803416:	75 18                	jne    803430 <realloc_block+0x3d>
    free_block(va);
  803418:	83 ec 0c             	sub    $0xc,%esp
  80341b:	ff 75 08             	pushl  0x8(%ebp)
  80341e:	e8 12 fc ff ff       	call   803035 <free_block>
  803423:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803426:	b8 00 00 00 00       	mov    $0x0,%eax
  80342b:	e9 bb 00 00 00       	jmp    8034eb <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803430:	83 ec 0c             	sub    $0xc,%esp
  803433:	ff 75 08             	pushl  0x8(%ebp)
  803436:	e8 38 f6 ff ff       	call   802a73 <get_block_size>
  80343b:	83 c4 10             	add    $0x10,%esp
  80343e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803441:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80344e:	73 06                	jae    803456 <realloc_block+0x63>
    new_size = min_block_size;
  803450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803453:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803456:	83 ec 0c             	sub    $0xc,%esp
  803459:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80345c:	ff 75 0c             	pushl  0xc(%ebp)
  80345f:	89 c1                	mov    %eax,%ecx
  803461:	e8 55 ff ff ff       	call   8033bb <nearest_pow2_ceil.1572>
  803466:	83 c4 10             	add    $0x10,%esp
  803469:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  80346c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803472:	75 05                	jne    803479 <realloc_block+0x86>
    return va;
  803474:	8b 45 08             	mov    0x8(%ebp),%eax
  803477:	eb 72                	jmp    8034eb <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803479:	83 ec 0c             	sub    $0xc,%esp
  80347c:	ff 75 0c             	pushl  0xc(%ebp)
  80347f:	e8 57 f6 ff ff       	call   802adb <alloc_block>
  803484:	83 c4 10             	add    $0x10,%esp
  803487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  80348a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80348e:	75 07                	jne    803497 <realloc_block+0xa4>
    return NULL;
  803490:	b8 00 00 00 00       	mov    $0x0,%eax
  803495:	eb 54                	jmp    8034eb <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803497:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80349a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349d:	39 d0                	cmp    %edx,%eax
  80349f:	76 02                	jbe    8034a3 <realloc_block+0xb0>
  8034a1:	89 d0                	mov    %edx,%eax
  8034a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  8034a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8034ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8034b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8034b9:	eb 17                	jmp    8034d2 <realloc_block+0xdf>
    dst[i] = src[i];
  8034bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8034be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c1:	01 c2                	add    %eax,%edx
  8034c3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8034c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c9:	01 c8                	add    %ecx,%eax
  8034cb:	8a 00                	mov    (%eax),%al
  8034cd:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  8034cf:	ff 45 f4             	incl   -0xc(%ebp)
  8034d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8034d8:	72 e1                	jb     8034bb <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  8034da:	83 ec 0c             	sub    $0xc,%esp
  8034dd:	ff 75 08             	pushl  0x8(%ebp)
  8034e0:	e8 50 fb ff ff       	call   803035 <free_block>
  8034e5:	83 c4 10             	add    $0x10,%esp

  return new_va;
  8034e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8034eb:	c9                   	leave  
  8034ec:	c3                   	ret    

008034ed <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8034ed:	55                   	push   %ebp
  8034ee:	89 e5                	mov    %esp,%ebp
  8034f0:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8034f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f6:	89 d0                	mov    %edx,%eax
  8034f8:	c1 e0 02             	shl    $0x2,%eax
  8034fb:	01 d0                	add    %edx,%eax
  8034fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803504:	01 d0                	add    %edx,%eax
  803506:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80350d:	01 d0                	add    %edx,%eax
  80350f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803516:	01 d0                	add    %edx,%eax
  803518:	c1 e0 04             	shl    $0x4,%eax
  80351b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  80351e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803525:	0f 31                	rdtsc  
  803527:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80352a:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  80352d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803530:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803533:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803536:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803539:	eb 46                	jmp    803581 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80353b:	0f 31                	rdtsc  
  80353d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  803540:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803543:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803546:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803549:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80354c:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80354f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803555:	29 c2                	sub    %eax,%edx
  803557:	89 d0                	mov    %edx,%eax
  803559:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80355c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80355f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803562:	89 d1                	mov    %edx,%ecx
  803564:	29 c1                	sub    %eax,%ecx
  803566:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803569:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80356c:	39 c2                	cmp    %eax,%edx
  80356e:	0f 97 c0             	seta   %al
  803571:	0f b6 c0             	movzbl %al,%eax
  803574:	29 c1                	sub    %eax,%ecx
  803576:	89 c8                	mov    %ecx,%eax
  803578:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80357b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80357e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803581:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803584:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803587:	72 b2                	jb     80353b <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803589:	90                   	nop
  80358a:	c9                   	leave  
  80358b:	c3                   	ret    

0080358c <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80358c:	55                   	push   %ebp
  80358d:	89 e5                	mov    %esp,%ebp
  80358f:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803592:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803599:	eb 03                	jmp    80359e <busy_wait+0x12>
  80359b:	ff 45 fc             	incl   -0x4(%ebp)
  80359e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8035a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035a4:	72 f5                	jb     80359b <busy_wait+0xf>
	return i;
  8035a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8035a9:	c9                   	leave  
  8035aa:	c3                   	ret    
  8035ab:	90                   	nop

008035ac <__udivdi3>:
  8035ac:	55                   	push   %ebp
  8035ad:	57                   	push   %edi
  8035ae:	56                   	push   %esi
  8035af:	53                   	push   %ebx
  8035b0:	83 ec 1c             	sub    $0x1c,%esp
  8035b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035c3:	89 ca                	mov    %ecx,%edx
  8035c5:	89 f8                	mov    %edi,%eax
  8035c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035cb:	85 f6                	test   %esi,%esi
  8035cd:	75 2d                	jne    8035fc <__udivdi3+0x50>
  8035cf:	39 cf                	cmp    %ecx,%edi
  8035d1:	77 65                	ja     803638 <__udivdi3+0x8c>
  8035d3:	89 fd                	mov    %edi,%ebp
  8035d5:	85 ff                	test   %edi,%edi
  8035d7:	75 0b                	jne    8035e4 <__udivdi3+0x38>
  8035d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8035de:	31 d2                	xor    %edx,%edx
  8035e0:	f7 f7                	div    %edi
  8035e2:	89 c5                	mov    %eax,%ebp
  8035e4:	31 d2                	xor    %edx,%edx
  8035e6:	89 c8                	mov    %ecx,%eax
  8035e8:	f7 f5                	div    %ebp
  8035ea:	89 c1                	mov    %eax,%ecx
  8035ec:	89 d8                	mov    %ebx,%eax
  8035ee:	f7 f5                	div    %ebp
  8035f0:	89 cf                	mov    %ecx,%edi
  8035f2:	89 fa                	mov    %edi,%edx
  8035f4:	83 c4 1c             	add    $0x1c,%esp
  8035f7:	5b                   	pop    %ebx
  8035f8:	5e                   	pop    %esi
  8035f9:	5f                   	pop    %edi
  8035fa:	5d                   	pop    %ebp
  8035fb:	c3                   	ret    
  8035fc:	39 ce                	cmp    %ecx,%esi
  8035fe:	77 28                	ja     803628 <__udivdi3+0x7c>
  803600:	0f bd fe             	bsr    %esi,%edi
  803603:	83 f7 1f             	xor    $0x1f,%edi
  803606:	75 40                	jne    803648 <__udivdi3+0x9c>
  803608:	39 ce                	cmp    %ecx,%esi
  80360a:	72 0a                	jb     803616 <__udivdi3+0x6a>
  80360c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803610:	0f 87 9e 00 00 00    	ja     8036b4 <__udivdi3+0x108>
  803616:	b8 01 00 00 00       	mov    $0x1,%eax
  80361b:	89 fa                	mov    %edi,%edx
  80361d:	83 c4 1c             	add    $0x1c,%esp
  803620:	5b                   	pop    %ebx
  803621:	5e                   	pop    %esi
  803622:	5f                   	pop    %edi
  803623:	5d                   	pop    %ebp
  803624:	c3                   	ret    
  803625:	8d 76 00             	lea    0x0(%esi),%esi
  803628:	31 ff                	xor    %edi,%edi
  80362a:	31 c0                	xor    %eax,%eax
  80362c:	89 fa                	mov    %edi,%edx
  80362e:	83 c4 1c             	add    $0x1c,%esp
  803631:	5b                   	pop    %ebx
  803632:	5e                   	pop    %esi
  803633:	5f                   	pop    %edi
  803634:	5d                   	pop    %ebp
  803635:	c3                   	ret    
  803636:	66 90                	xchg   %ax,%ax
  803638:	89 d8                	mov    %ebx,%eax
  80363a:	f7 f7                	div    %edi
  80363c:	31 ff                	xor    %edi,%edi
  80363e:	89 fa                	mov    %edi,%edx
  803640:	83 c4 1c             	add    $0x1c,%esp
  803643:	5b                   	pop    %ebx
  803644:	5e                   	pop    %esi
  803645:	5f                   	pop    %edi
  803646:	5d                   	pop    %ebp
  803647:	c3                   	ret    
  803648:	bd 20 00 00 00       	mov    $0x20,%ebp
  80364d:	89 eb                	mov    %ebp,%ebx
  80364f:	29 fb                	sub    %edi,%ebx
  803651:	89 f9                	mov    %edi,%ecx
  803653:	d3 e6                	shl    %cl,%esi
  803655:	89 c5                	mov    %eax,%ebp
  803657:	88 d9                	mov    %bl,%cl
  803659:	d3 ed                	shr    %cl,%ebp
  80365b:	89 e9                	mov    %ebp,%ecx
  80365d:	09 f1                	or     %esi,%ecx
  80365f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803663:	89 f9                	mov    %edi,%ecx
  803665:	d3 e0                	shl    %cl,%eax
  803667:	89 c5                	mov    %eax,%ebp
  803669:	89 d6                	mov    %edx,%esi
  80366b:	88 d9                	mov    %bl,%cl
  80366d:	d3 ee                	shr    %cl,%esi
  80366f:	89 f9                	mov    %edi,%ecx
  803671:	d3 e2                	shl    %cl,%edx
  803673:	8b 44 24 08          	mov    0x8(%esp),%eax
  803677:	88 d9                	mov    %bl,%cl
  803679:	d3 e8                	shr    %cl,%eax
  80367b:	09 c2                	or     %eax,%edx
  80367d:	89 d0                	mov    %edx,%eax
  80367f:	89 f2                	mov    %esi,%edx
  803681:	f7 74 24 0c          	divl   0xc(%esp)
  803685:	89 d6                	mov    %edx,%esi
  803687:	89 c3                	mov    %eax,%ebx
  803689:	f7 e5                	mul    %ebp
  80368b:	39 d6                	cmp    %edx,%esi
  80368d:	72 19                	jb     8036a8 <__udivdi3+0xfc>
  80368f:	74 0b                	je     80369c <__udivdi3+0xf0>
  803691:	89 d8                	mov    %ebx,%eax
  803693:	31 ff                	xor    %edi,%edi
  803695:	e9 58 ff ff ff       	jmp    8035f2 <__udivdi3+0x46>
  80369a:	66 90                	xchg   %ax,%ax
  80369c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036a0:	89 f9                	mov    %edi,%ecx
  8036a2:	d3 e2                	shl    %cl,%edx
  8036a4:	39 c2                	cmp    %eax,%edx
  8036a6:	73 e9                	jae    803691 <__udivdi3+0xe5>
  8036a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036ab:	31 ff                	xor    %edi,%edi
  8036ad:	e9 40 ff ff ff       	jmp    8035f2 <__udivdi3+0x46>
  8036b2:	66 90                	xchg   %ax,%ax
  8036b4:	31 c0                	xor    %eax,%eax
  8036b6:	e9 37 ff ff ff       	jmp    8035f2 <__udivdi3+0x46>
  8036bb:	90                   	nop

008036bc <__umoddi3>:
  8036bc:	55                   	push   %ebp
  8036bd:	57                   	push   %edi
  8036be:	56                   	push   %esi
  8036bf:	53                   	push   %ebx
  8036c0:	83 ec 1c             	sub    $0x1c,%esp
  8036c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036db:	89 f3                	mov    %esi,%ebx
  8036dd:	89 fa                	mov    %edi,%edx
  8036df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036e3:	89 34 24             	mov    %esi,(%esp)
  8036e6:	85 c0                	test   %eax,%eax
  8036e8:	75 1a                	jne    803704 <__umoddi3+0x48>
  8036ea:	39 f7                	cmp    %esi,%edi
  8036ec:	0f 86 a2 00 00 00    	jbe    803794 <__umoddi3+0xd8>
  8036f2:	89 c8                	mov    %ecx,%eax
  8036f4:	89 f2                	mov    %esi,%edx
  8036f6:	f7 f7                	div    %edi
  8036f8:	89 d0                	mov    %edx,%eax
  8036fa:	31 d2                	xor    %edx,%edx
  8036fc:	83 c4 1c             	add    $0x1c,%esp
  8036ff:	5b                   	pop    %ebx
  803700:	5e                   	pop    %esi
  803701:	5f                   	pop    %edi
  803702:	5d                   	pop    %ebp
  803703:	c3                   	ret    
  803704:	39 f0                	cmp    %esi,%eax
  803706:	0f 87 ac 00 00 00    	ja     8037b8 <__umoddi3+0xfc>
  80370c:	0f bd e8             	bsr    %eax,%ebp
  80370f:	83 f5 1f             	xor    $0x1f,%ebp
  803712:	0f 84 ac 00 00 00    	je     8037c4 <__umoddi3+0x108>
  803718:	bf 20 00 00 00       	mov    $0x20,%edi
  80371d:	29 ef                	sub    %ebp,%edi
  80371f:	89 fe                	mov    %edi,%esi
  803721:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803725:	89 e9                	mov    %ebp,%ecx
  803727:	d3 e0                	shl    %cl,%eax
  803729:	89 d7                	mov    %edx,%edi
  80372b:	89 f1                	mov    %esi,%ecx
  80372d:	d3 ef                	shr    %cl,%edi
  80372f:	09 c7                	or     %eax,%edi
  803731:	89 e9                	mov    %ebp,%ecx
  803733:	d3 e2                	shl    %cl,%edx
  803735:	89 14 24             	mov    %edx,(%esp)
  803738:	89 d8                	mov    %ebx,%eax
  80373a:	d3 e0                	shl    %cl,%eax
  80373c:	89 c2                	mov    %eax,%edx
  80373e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803742:	d3 e0                	shl    %cl,%eax
  803744:	89 44 24 04          	mov    %eax,0x4(%esp)
  803748:	8b 44 24 08          	mov    0x8(%esp),%eax
  80374c:	89 f1                	mov    %esi,%ecx
  80374e:	d3 e8                	shr    %cl,%eax
  803750:	09 d0                	or     %edx,%eax
  803752:	d3 eb                	shr    %cl,%ebx
  803754:	89 da                	mov    %ebx,%edx
  803756:	f7 f7                	div    %edi
  803758:	89 d3                	mov    %edx,%ebx
  80375a:	f7 24 24             	mull   (%esp)
  80375d:	89 c6                	mov    %eax,%esi
  80375f:	89 d1                	mov    %edx,%ecx
  803761:	39 d3                	cmp    %edx,%ebx
  803763:	0f 82 87 00 00 00    	jb     8037f0 <__umoddi3+0x134>
  803769:	0f 84 91 00 00 00    	je     803800 <__umoddi3+0x144>
  80376f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803773:	29 f2                	sub    %esi,%edx
  803775:	19 cb                	sbb    %ecx,%ebx
  803777:	89 d8                	mov    %ebx,%eax
  803779:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80377d:	d3 e0                	shl    %cl,%eax
  80377f:	89 e9                	mov    %ebp,%ecx
  803781:	d3 ea                	shr    %cl,%edx
  803783:	09 d0                	or     %edx,%eax
  803785:	89 e9                	mov    %ebp,%ecx
  803787:	d3 eb                	shr    %cl,%ebx
  803789:	89 da                	mov    %ebx,%edx
  80378b:	83 c4 1c             	add    $0x1c,%esp
  80378e:	5b                   	pop    %ebx
  80378f:	5e                   	pop    %esi
  803790:	5f                   	pop    %edi
  803791:	5d                   	pop    %ebp
  803792:	c3                   	ret    
  803793:	90                   	nop
  803794:	89 fd                	mov    %edi,%ebp
  803796:	85 ff                	test   %edi,%edi
  803798:	75 0b                	jne    8037a5 <__umoddi3+0xe9>
  80379a:	b8 01 00 00 00       	mov    $0x1,%eax
  80379f:	31 d2                	xor    %edx,%edx
  8037a1:	f7 f7                	div    %edi
  8037a3:	89 c5                	mov    %eax,%ebp
  8037a5:	89 f0                	mov    %esi,%eax
  8037a7:	31 d2                	xor    %edx,%edx
  8037a9:	f7 f5                	div    %ebp
  8037ab:	89 c8                	mov    %ecx,%eax
  8037ad:	f7 f5                	div    %ebp
  8037af:	89 d0                	mov    %edx,%eax
  8037b1:	e9 44 ff ff ff       	jmp    8036fa <__umoddi3+0x3e>
  8037b6:	66 90                	xchg   %ax,%ax
  8037b8:	89 c8                	mov    %ecx,%eax
  8037ba:	89 f2                	mov    %esi,%edx
  8037bc:	83 c4 1c             	add    $0x1c,%esp
  8037bf:	5b                   	pop    %ebx
  8037c0:	5e                   	pop    %esi
  8037c1:	5f                   	pop    %edi
  8037c2:	5d                   	pop    %ebp
  8037c3:	c3                   	ret    
  8037c4:	3b 04 24             	cmp    (%esp),%eax
  8037c7:	72 06                	jb     8037cf <__umoddi3+0x113>
  8037c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037cd:	77 0f                	ja     8037de <__umoddi3+0x122>
  8037cf:	89 f2                	mov    %esi,%edx
  8037d1:	29 f9                	sub    %edi,%ecx
  8037d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037d7:	89 14 24             	mov    %edx,(%esp)
  8037da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037e2:	8b 14 24             	mov    (%esp),%edx
  8037e5:	83 c4 1c             	add    $0x1c,%esp
  8037e8:	5b                   	pop    %ebx
  8037e9:	5e                   	pop    %esi
  8037ea:	5f                   	pop    %edi
  8037eb:	5d                   	pop    %ebp
  8037ec:	c3                   	ret    
  8037ed:	8d 76 00             	lea    0x0(%esi),%esi
  8037f0:	2b 04 24             	sub    (%esp),%eax
  8037f3:	19 fa                	sbb    %edi,%edx
  8037f5:	89 d1                	mov    %edx,%ecx
  8037f7:	89 c6                	mov    %eax,%esi
  8037f9:	e9 71 ff ff ff       	jmp    80376f <__umoddi3+0xb3>
  8037fe:	66 90                	xchg   %ax,%ax
  803800:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803804:	72 ea                	jb     8037f0 <__umoddi3+0x134>
  803806:	89 d9                	mov    %ebx,%ecx
  803808:	e9 62 ff ff ff       	jmp    80376f <__umoddi3+0xb3>
