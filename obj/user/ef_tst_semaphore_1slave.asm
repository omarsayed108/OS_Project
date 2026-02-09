
obj/user/ef_tst_semaphore_1slave:     file format elf32-i386


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
  800031:	e8 fa 00 00 00       	call   800130 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program: enter critical section, print it's ID, exit and signal the master program
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 71 17 00 00       	call   8017b4 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int id = sys_getenvindex();
  800046:	e8 50 17 00 00       	call   80179b <sys_getenvindex>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("%d: before the critical section\n", id);
  80004e:	83 ec 08             	sub    $0x8,%esp
  800051:	ff 75 f0             	pushl  -0x10(%ebp)
  800054:	68 00 1e 80 00       	push   $0x801e00
  800059:	e8 70 05 00 00       	call   8005ce <cprintf>
  80005e:	83 c4 10             	add    $0x10,%esp

	struct semaphore cs1 = get_semaphore(parentenvID, "cs1");
  800061:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 21 1e 80 00       	push   $0x801e21
  80006c:	ff 75 f4             	pushl  -0xc(%ebp)
  80006f:	50                   	push   %eax
  800070:	e8 03 1a 00 00       	call   801a78 <get_semaphore>
  800075:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = get_semaphore(parentenvID, "depend1");
  800078:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80007b:	83 ec 04             	sub    $0x4,%esp
  80007e:	68 25 1e 80 00       	push   $0x801e25
  800083:	ff 75 f4             	pushl  -0xc(%ebp)
  800086:	50                   	push   %eax
  800087:	e8 ec 19 00 00       	call   801a78 <get_semaphore>
  80008c:	83 c4 0c             	add    $0xc,%esp

	wait_semaphore(cs1);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	ff 75 e8             	pushl  -0x18(%ebp)
  800095:	e8 f8 19 00 00       	call   801a92 <wait_semaphore>
  80009a:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("%d: inside the critical section\n", id) ;
  80009d:	83 ec 08             	sub    $0x8,%esp
  8000a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a3:	68 30 1e 80 00       	push   $0x801e30
  8000a8:	e8 21 05 00 00       	call   8005ce <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp
		cprintf("my ID is %d\n", id);
  8000b0:	83 ec 08             	sub    $0x8,%esp
  8000b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b6:	68 51 1e 80 00       	push   $0x801e51
  8000bb:	e8 0e 05 00 00       	call   8005ce <cprintf>
  8000c0:	83 c4 10             	add    $0x10,%esp
		int sem1val = semaphore_count(cs1);
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000c9:	e8 f8 19 00 00       	call   801ac6 <semaphore_count>
  8000ce:	83 c4 10             	add    $0x10,%esp
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (sem1val > 0)
  8000d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8000d8:	7e 14                	jle    8000ee <_main+0xb6>
			panic("Error: more than 1 process inside the CS... please review your semaphore code again...");
  8000da:	83 ec 04             	sub    $0x4,%esp
  8000dd:	68 60 1e 80 00       	push   $0x801e60
  8000e2:	6a 15                	push   $0x15
  8000e4:	68 b8 1e 80 00       	push   $0x801eb8
  8000e9:	e8 f2 01 00 00       	call   8002e0 <_panic>
		env_sleep(1000) ;
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	68 e8 03 00 00       	push   $0x3e8
  8000f6:	e8 d6 19 00 00       	call   801ad1 <env_sleep>
  8000fb:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cs1);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 e8             	pushl  -0x18(%ebp)
  800104:	e8 a3 19 00 00       	call   801aac <signal_semaphore>
  800109:	83 c4 10             	add    $0x10,%esp

	cprintf("%d: after the critical section\n", id);
  80010c:	83 ec 08             	sub    $0x8,%esp
  80010f:	ff 75 f0             	pushl  -0x10(%ebp)
  800112:	68 d8 1e 80 00       	push   $0x801ed8
  800117:	e8 b2 04 00 00       	call   8005ce <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(depend1);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 82 19 00 00       	call   801aac <signal_semaphore>
  80012a:	83 c4 10             	add    $0x10,%esp
	return;
  80012d:	90                   	nop
}
  80012e:	c9                   	leave  
  80012f:	c3                   	ret    

00800130 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	57                   	push   %edi
  800134:	56                   	push   %esi
  800135:	53                   	push   %ebx
  800136:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800139:	e8 5d 16 00 00       	call   80179b <sys_getenvindex>
  80013e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800141:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800144:	89 d0                	mov    %edx,%eax
  800146:	01 c0                	add    %eax,%eax
  800148:	01 d0                	add    %edx,%eax
  80014a:	c1 e0 02             	shl    $0x2,%eax
  80014d:	01 d0                	add    %edx,%eax
  80014f:	c1 e0 02             	shl    $0x2,%eax
  800152:	01 d0                	add    %edx,%eax
  800154:	c1 e0 03             	shl    $0x3,%eax
  800157:	01 d0                	add    %edx,%eax
  800159:	c1 e0 02             	shl    $0x2,%eax
  80015c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800161:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800166:	a1 20 30 80 00       	mov    0x803020,%eax
  80016b:	8a 40 20             	mov    0x20(%eax),%al
  80016e:	84 c0                	test   %al,%al
  800170:	74 0d                	je     80017f <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800172:	a1 20 30 80 00       	mov    0x803020,%eax
  800177:	83 c0 20             	add    $0x20,%eax
  80017a:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800183:	7e 0a                	jle    80018f <libmain+0x5f>
		binaryname = argv[0];
  800185:	8b 45 0c             	mov    0xc(%ebp),%eax
  800188:	8b 00                	mov    (%eax),%eax
  80018a:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80018f:	83 ec 08             	sub    $0x8,%esp
  800192:	ff 75 0c             	pushl  0xc(%ebp)
  800195:	ff 75 08             	pushl  0x8(%ebp)
  800198:	e8 9b fe ff ff       	call   800038 <_main>
  80019d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001a0:	a1 00 30 80 00       	mov    0x803000,%eax
  8001a5:	85 c0                	test   %eax,%eax
  8001a7:	0f 84 01 01 00 00    	je     8002ae <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001ad:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001b3:	bb f0 1f 80 00       	mov    $0x801ff0,%ebx
  8001b8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001bd:	89 c7                	mov    %eax,%edi
  8001bf:	89 de                	mov    %ebx,%esi
  8001c1:	89 d1                	mov    %edx,%ecx
  8001c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001c5:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001c8:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001cd:	b0 00                	mov    $0x0,%al
  8001cf:	89 d7                	mov    %edx,%edi
  8001d1:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001da:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	50                   	push   %eax
  8001e1:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001e7:	50                   	push   %eax
  8001e8:	e8 e4 17 00 00       	call   8019d1 <sys_utilities>
  8001ed:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001f0:	e8 2d 13 00 00       	call   801522 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 10 1f 80 00       	push   $0x801f10
  8001fd:	e8 cc 03 00 00       	call   8005ce <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800205:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800208:	85 c0                	test   %eax,%eax
  80020a:	74 18                	je     800224 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80020c:	e8 de 17 00 00       	call   8019ef <sys_get_optimal_num_faults>
  800211:	83 ec 08             	sub    $0x8,%esp
  800214:	50                   	push   %eax
  800215:	68 38 1f 80 00       	push   $0x801f38
  80021a:	e8 af 03 00 00       	call   8005ce <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
  800222:	eb 59                	jmp    80027d <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800224:	a1 20 30 80 00       	mov    0x803020,%eax
  800229:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80022f:	a1 20 30 80 00       	mov    0x803020,%eax
  800234:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	52                   	push   %edx
  80023e:	50                   	push   %eax
  80023f:	68 5c 1f 80 00       	push   $0x801f5c
  800244:	e8 85 03 00 00       	call   8005ce <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80024c:	a1 20 30 80 00       	mov    0x803020,%eax
  800251:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800257:	a1 20 30 80 00       	mov    0x803020,%eax
  80025c:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800262:	a1 20 30 80 00       	mov    0x803020,%eax
  800267:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80026d:	51                   	push   %ecx
  80026e:	52                   	push   %edx
  80026f:	50                   	push   %eax
  800270:	68 84 1f 80 00       	push   $0x801f84
  800275:	e8 54 03 00 00       	call   8005ce <cprintf>
  80027a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80027d:	a1 20 30 80 00       	mov    0x803020,%eax
  800282:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800288:	83 ec 08             	sub    $0x8,%esp
  80028b:	50                   	push   %eax
  80028c:	68 dc 1f 80 00       	push   $0x801fdc
  800291:	e8 38 03 00 00       	call   8005ce <cprintf>
  800296:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	68 10 1f 80 00       	push   $0x801f10
  8002a1:	e8 28 03 00 00       	call   8005ce <cprintf>
  8002a6:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002a9:	e8 8e 12 00 00       	call   80153c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002ae:	e8 1f 00 00 00       	call   8002d2 <exit>
}
  8002b3:	90                   	nop
  8002b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b7:	5b                   	pop    %ebx
  8002b8:	5e                   	pop    %esi
  8002b9:	5f                   	pop    %edi
  8002ba:	5d                   	pop    %ebp
  8002bb:	c3                   	ret    

008002bc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002c2:	83 ec 0c             	sub    $0xc,%esp
  8002c5:	6a 00                	push   $0x0
  8002c7:	e8 9b 14 00 00       	call   801767 <sys_destroy_env>
  8002cc:	83 c4 10             	add    $0x10,%esp
}
  8002cf:	90                   	nop
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <exit>:

void
exit(void)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002d8:	e8 f0 14 00 00       	call   8017cd <sys_exit_env>
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002e6:	8d 45 10             	lea    0x10(%ebp),%eax
  8002e9:	83 c0 04             	add    $0x4,%eax
  8002ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002ef:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002f4:	85 c0                	test   %eax,%eax
  8002f6:	74 16                	je     80030e <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002f8:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002fd:	83 ec 08             	sub    $0x8,%esp
  800300:	50                   	push   %eax
  800301:	68 54 20 80 00       	push   $0x802054
  800306:	e8 c3 02 00 00       	call   8005ce <cprintf>
  80030b:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80030e:	a1 04 30 80 00       	mov    0x803004,%eax
  800313:	83 ec 0c             	sub    $0xc,%esp
  800316:	ff 75 0c             	pushl  0xc(%ebp)
  800319:	ff 75 08             	pushl  0x8(%ebp)
  80031c:	50                   	push   %eax
  80031d:	68 5c 20 80 00       	push   $0x80205c
  800322:	6a 74                	push   $0x74
  800324:	e8 d2 02 00 00       	call   8005fb <cprintf_colored>
  800329:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80032c:	8b 45 10             	mov    0x10(%ebp),%eax
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	ff 75 f4             	pushl  -0xc(%ebp)
  800335:	50                   	push   %eax
  800336:	e8 24 02 00 00       	call   80055f <vcprintf>
  80033b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	6a 00                	push   $0x0
  800343:	68 84 20 80 00       	push   $0x802084
  800348:	e8 12 02 00 00       	call   80055f <vcprintf>
  80034d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800350:	e8 7d ff ff ff       	call   8002d2 <exit>

	// should not return here
	while (1) ;
  800355:	eb fe                	jmp    800355 <_panic+0x75>

00800357 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	53                   	push   %ebx
  80035b:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80035e:	a1 20 30 80 00       	mov    0x803020,%eax
  800363:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036c:	39 c2                	cmp    %eax,%edx
  80036e:	74 14                	je     800384 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	68 88 20 80 00       	push   $0x802088
  800378:	6a 26                	push   $0x26
  80037a:	68 d4 20 80 00       	push   $0x8020d4
  80037f:	e8 5c ff ff ff       	call   8002e0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800392:	e9 d9 00 00 00       	jmp    800470 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	75 08                	jne    8003b4 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8003ac:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003af:	e9 b9 00 00 00       	jmp    80046d <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8003b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c2:	eb 79                	jmp    80043d <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c9:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8003df:	01 d8                	add    %ebx,%eax
  8003e1:	01 d0                	add    %edx,%eax
  8003e3:	01 c8                	add    %ecx,%eax
  8003e5:	8a 40 04             	mov    0x4(%eax),%al
  8003e8:	84 c0                	test   %al,%al
  8003ea:	75 4e                	jne    80043a <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ec:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f1:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8003f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003fa:	89 d0                	mov    %edx,%eax
  8003fc:	01 c0                	add    %eax,%eax
  8003fe:	01 d0                	add    %edx,%eax
  800400:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800407:	01 d8                	add    %ebx,%eax
  800409:	01 d0                	add    %edx,%eax
  80040b:	01 c8                	add    %ecx,%eax
  80040d:	8b 00                	mov    (%eax),%eax
  80040f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800412:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800415:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	01 c8                	add    %ecx,%eax
  80042b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80042d:	39 c2                	cmp    %eax,%edx
  80042f:	75 09                	jne    80043a <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800431:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800438:	eb 19                	jmp    800453 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043a:	ff 45 e8             	incl   -0x18(%ebp)
  80043d:	a1 20 30 80 00       	mov    0x803020,%eax
  800442:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800448:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044b:	39 c2                	cmp    %eax,%edx
  80044d:	0f 87 71 ff ff ff    	ja     8003c4 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800453:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800457:	75 14                	jne    80046d <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800459:	83 ec 04             	sub    $0x4,%esp
  80045c:	68 e0 20 80 00       	push   $0x8020e0
  800461:	6a 3a                	push   $0x3a
  800463:	68 d4 20 80 00       	push   $0x8020d4
  800468:	e8 73 fe ff ff       	call   8002e0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80046d:	ff 45 f0             	incl   -0x10(%ebp)
  800470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800473:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800476:	0f 8c 1b ff ff ff    	jl     800397 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80047c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800483:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80048a:	eb 2e                	jmp    8004ba <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80048c:	a1 20 30 80 00       	mov    0x803020,%eax
  800491:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800497:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80049a:	89 d0                	mov    %edx,%eax
  80049c:	01 c0                	add    %eax,%eax
  80049e:	01 d0                	add    %edx,%eax
  8004a0:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004a7:	01 d8                	add    %ebx,%eax
  8004a9:	01 d0                	add    %edx,%eax
  8004ab:	01 c8                	add    %ecx,%eax
  8004ad:	8a 40 04             	mov    0x4(%eax),%al
  8004b0:	3c 01                	cmp    $0x1,%al
  8004b2:	75 03                	jne    8004b7 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8004b4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b7:	ff 45 e0             	incl   -0x20(%ebp)
  8004ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8004bf:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c8:	39 c2                	cmp    %eax,%edx
  8004ca:	77 c0                	ja     80048c <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004cf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004d2:	74 14                	je     8004e8 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8004d4:	83 ec 04             	sub    $0x4,%esp
  8004d7:	68 34 21 80 00       	push   $0x802134
  8004dc:	6a 44                	push   $0x44
  8004de:	68 d4 20 80 00       	push   $0x8020d4
  8004e3:	e8 f8 fd ff ff       	call   8002e0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004e8:	90                   	nop
  8004e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004ec:	c9                   	leave  
  8004ed:	c3                   	ret    

008004ee <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004ee:	55                   	push   %ebp
  8004ef:	89 e5                	mov    %esp,%ebp
  8004f1:	53                   	push   %ebx
  8004f2:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f8:	8b 00                	mov    (%eax),%eax
  8004fa:	8d 48 01             	lea    0x1(%eax),%ecx
  8004fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800500:	89 0a                	mov    %ecx,(%edx)
  800502:	8b 55 08             	mov    0x8(%ebp),%edx
  800505:	88 d1                	mov    %dl,%cl
  800507:	8b 55 0c             	mov    0xc(%ebp),%edx
  80050a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800511:	8b 00                	mov    (%eax),%eax
  800513:	3d ff 00 00 00       	cmp    $0xff,%eax
  800518:	75 30                	jne    80054a <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80051a:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800520:	a0 44 30 80 00       	mov    0x803044,%al
  800525:	0f b6 c0             	movzbl %al,%eax
  800528:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80052b:	8b 09                	mov    (%ecx),%ecx
  80052d:	89 cb                	mov    %ecx,%ebx
  80052f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800532:	83 c1 08             	add    $0x8,%ecx
  800535:	52                   	push   %edx
  800536:	50                   	push   %eax
  800537:	53                   	push   %ebx
  800538:	51                   	push   %ecx
  800539:	e8 a0 0f 00 00       	call   8014de <sys_cputs>
  80053e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800541:	8b 45 0c             	mov    0xc(%ebp),%eax
  800544:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80054a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054d:	8b 40 04             	mov    0x4(%eax),%eax
  800550:	8d 50 01             	lea    0x1(%eax),%edx
  800553:	8b 45 0c             	mov    0xc(%ebp),%eax
  800556:	89 50 04             	mov    %edx,0x4(%eax)
}
  800559:	90                   	nop
  80055a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055d:	c9                   	leave  
  80055e:	c3                   	ret    

0080055f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80055f:	55                   	push   %ebp
  800560:	89 e5                	mov    %esp,%ebp
  800562:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800568:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80056f:	00 00 00 
	b.cnt = 0;
  800572:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800579:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80057c:	ff 75 0c             	pushl  0xc(%ebp)
  80057f:	ff 75 08             	pushl  0x8(%ebp)
  800582:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800588:	50                   	push   %eax
  800589:	68 ee 04 80 00       	push   $0x8004ee
  80058e:	e8 5a 02 00 00       	call   8007ed <vprintfmt>
  800593:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800596:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80059c:	a0 44 30 80 00       	mov    0x803044,%al
  8005a1:	0f b6 c0             	movzbl %al,%eax
  8005a4:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005aa:	52                   	push   %edx
  8005ab:	50                   	push   %eax
  8005ac:	51                   	push   %ecx
  8005ad:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b3:	83 c0 08             	add    $0x8,%eax
  8005b6:	50                   	push   %eax
  8005b7:	e8 22 0f 00 00       	call   8014de <sys_cputs>
  8005bc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005bf:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005c6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005cc:	c9                   	leave  
  8005cd:	c3                   	ret    

008005ce <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005ce:	55                   	push   %ebp
  8005cf:	89 e5                	mov    %esp,%ebp
  8005d1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d4:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005db:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e4:	83 ec 08             	sub    $0x8,%esp
  8005e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ea:	50                   	push   %eax
  8005eb:	e8 6f ff ff ff       	call   80055f <vcprintf>
  8005f0:	83 c4 10             	add    $0x10,%esp
  8005f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f9:	c9                   	leave  
  8005fa:	c3                   	ret    

008005fb <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005fb:	55                   	push   %ebp
  8005fc:	89 e5                	mov    %esp,%ebp
  8005fe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800601:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	c1 e0 08             	shl    $0x8,%eax
  80060e:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800613:	8d 45 0c             	lea    0xc(%ebp),%eax
  800616:	83 c0 04             	add    $0x4,%eax
  800619:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80061c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	ff 75 f4             	pushl  -0xc(%ebp)
  800625:	50                   	push   %eax
  800626:	e8 34 ff ff ff       	call   80055f <vcprintf>
  80062b:	83 c4 10             	add    $0x10,%esp
  80062e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800631:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800638:	07 00 00 

	return cnt;
  80063b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80063e:	c9                   	leave  
  80063f:	c3                   	ret    

00800640 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800640:	55                   	push   %ebp
  800641:	89 e5                	mov    %esp,%ebp
  800643:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800646:	e8 d7 0e 00 00       	call   801522 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80064b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80064e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 f4             	pushl  -0xc(%ebp)
  80065a:	50                   	push   %eax
  80065b:	e8 ff fe ff ff       	call   80055f <vcprintf>
  800660:	83 c4 10             	add    $0x10,%esp
  800663:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800666:	e8 d1 0e 00 00       	call   80153c <sys_unlock_cons>
	return cnt;
  80066b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80066e:	c9                   	leave  
  80066f:	c3                   	ret    

00800670 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800670:	55                   	push   %ebp
  800671:	89 e5                	mov    %esp,%ebp
  800673:	53                   	push   %ebx
  800674:	83 ec 14             	sub    $0x14,%esp
  800677:	8b 45 10             	mov    0x10(%ebp),%eax
  80067a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800683:	8b 45 18             	mov    0x18(%ebp),%eax
  800686:	ba 00 00 00 00       	mov    $0x0,%edx
  80068b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80068e:	77 55                	ja     8006e5 <printnum+0x75>
  800690:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800693:	72 05                	jb     80069a <printnum+0x2a>
  800695:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800698:	77 4b                	ja     8006e5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80069a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80069d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006a0:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a8:	52                   	push   %edx
  8006a9:	50                   	push   %eax
  8006aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8006b0:	e8 db 14 00 00       	call   801b90 <__udivdi3>
  8006b5:	83 c4 10             	add    $0x10,%esp
  8006b8:	83 ec 04             	sub    $0x4,%esp
  8006bb:	ff 75 20             	pushl  0x20(%ebp)
  8006be:	53                   	push   %ebx
  8006bf:	ff 75 18             	pushl  0x18(%ebp)
  8006c2:	52                   	push   %edx
  8006c3:	50                   	push   %eax
  8006c4:	ff 75 0c             	pushl  0xc(%ebp)
  8006c7:	ff 75 08             	pushl  0x8(%ebp)
  8006ca:	e8 a1 ff ff ff       	call   800670 <printnum>
  8006cf:	83 c4 20             	add    $0x20,%esp
  8006d2:	eb 1a                	jmp    8006ee <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	ff 75 0c             	pushl  0xc(%ebp)
  8006da:	ff 75 20             	pushl  0x20(%ebp)
  8006dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e0:	ff d0                	call   *%eax
  8006e2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006e5:	ff 4d 1c             	decl   0x1c(%ebp)
  8006e8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006ec:	7f e6                	jg     8006d4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ee:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006fc:	53                   	push   %ebx
  8006fd:	51                   	push   %ecx
  8006fe:	52                   	push   %edx
  8006ff:	50                   	push   %eax
  800700:	e8 9b 15 00 00       	call   801ca0 <__umoddi3>
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	05 94 23 80 00       	add    $0x802394,%eax
  80070d:	8a 00                	mov    (%eax),%al
  80070f:	0f be c0             	movsbl %al,%eax
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	50                   	push   %eax
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	ff d0                	call   *%eax
  80071e:	83 c4 10             	add    $0x10,%esp
}
  800721:	90                   	nop
  800722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800725:	c9                   	leave  
  800726:	c3                   	ret    

00800727 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800727:	55                   	push   %ebp
  800728:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80072a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80072e:	7e 1c                	jle    80074c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	8d 50 08             	lea    0x8(%eax),%edx
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	89 10                	mov    %edx,(%eax)
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	83 e8 08             	sub    $0x8,%eax
  800745:	8b 50 04             	mov    0x4(%eax),%edx
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	eb 40                	jmp    80078c <getuint+0x65>
	else if (lflag)
  80074c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800750:	74 1e                	je     800770 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	8d 50 04             	lea    0x4(%eax),%edx
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	89 10                	mov    %edx,(%eax)
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	83 e8 04             	sub    $0x4,%eax
  800767:	8b 00                	mov    (%eax),%eax
  800769:	ba 00 00 00 00       	mov    $0x0,%edx
  80076e:	eb 1c                	jmp    80078c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800770:	8b 45 08             	mov    0x8(%ebp),%eax
  800773:	8b 00                	mov    (%eax),%eax
  800775:	8d 50 04             	lea    0x4(%eax),%edx
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	89 10                	mov    %edx,(%eax)
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	83 e8 04             	sub    $0x4,%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80078c:	5d                   	pop    %ebp
  80078d:	c3                   	ret    

0080078e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80078e:	55                   	push   %ebp
  80078f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800791:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800795:	7e 1c                	jle    8007b3 <getint+0x25>
		return va_arg(*ap, long long);
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	8b 00                	mov    (%eax),%eax
  80079c:	8d 50 08             	lea    0x8(%eax),%edx
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	89 10                	mov    %edx,(%eax)
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	83 e8 08             	sub    $0x8,%eax
  8007ac:	8b 50 04             	mov    0x4(%eax),%edx
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	eb 38                	jmp    8007eb <getint+0x5d>
	else if (lflag)
  8007b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007b7:	74 1a                	je     8007d3 <getint+0x45>
		return va_arg(*ap, long);
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	8d 50 04             	lea    0x4(%eax),%edx
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	89 10                	mov    %edx,(%eax)
  8007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	83 e8 04             	sub    $0x4,%eax
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	99                   	cltd   
  8007d1:	eb 18                	jmp    8007eb <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	8d 50 04             	lea    0x4(%eax),%edx
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	89 10                	mov    %edx,(%eax)
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	83 e8 04             	sub    $0x4,%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	99                   	cltd   
}
  8007eb:	5d                   	pop    %ebp
  8007ec:	c3                   	ret    

008007ed <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	56                   	push   %esi
  8007f1:	53                   	push   %ebx
  8007f2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f5:	eb 17                	jmp    80080e <vprintfmt+0x21>
			if (ch == '\0')
  8007f7:	85 db                	test   %ebx,%ebx
  8007f9:	0f 84 c1 03 00 00    	je     800bc0 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	53                   	push   %ebx
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	ff d0                	call   *%eax
  80080b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80080e:	8b 45 10             	mov    0x10(%ebp),%eax
  800811:	8d 50 01             	lea    0x1(%eax),%edx
  800814:	89 55 10             	mov    %edx,0x10(%ebp)
  800817:	8a 00                	mov    (%eax),%al
  800819:	0f b6 d8             	movzbl %al,%ebx
  80081c:	83 fb 25             	cmp    $0x25,%ebx
  80081f:	75 d6                	jne    8007f7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800821:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800825:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80082c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800833:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80083a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800841:	8b 45 10             	mov    0x10(%ebp),%eax
  800844:	8d 50 01             	lea    0x1(%eax),%edx
  800847:	89 55 10             	mov    %edx,0x10(%ebp)
  80084a:	8a 00                	mov    (%eax),%al
  80084c:	0f b6 d8             	movzbl %al,%ebx
  80084f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800852:	83 f8 5b             	cmp    $0x5b,%eax
  800855:	0f 87 3d 03 00 00    	ja     800b98 <vprintfmt+0x3ab>
  80085b:	8b 04 85 b8 23 80 00 	mov    0x8023b8(,%eax,4),%eax
  800862:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800864:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800868:	eb d7                	jmp    800841 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80086a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80086e:	eb d1                	jmp    800841 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800870:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800877:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80087a:	89 d0                	mov    %edx,%eax
  80087c:	c1 e0 02             	shl    $0x2,%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	01 c0                	add    %eax,%eax
  800883:	01 d8                	add    %ebx,%eax
  800885:	83 e8 30             	sub    $0x30,%eax
  800888:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80088b:	8b 45 10             	mov    0x10(%ebp),%eax
  80088e:	8a 00                	mov    (%eax),%al
  800890:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800893:	83 fb 2f             	cmp    $0x2f,%ebx
  800896:	7e 3e                	jle    8008d6 <vprintfmt+0xe9>
  800898:	83 fb 39             	cmp    $0x39,%ebx
  80089b:	7f 39                	jg     8008d6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80089d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008a0:	eb d5                	jmp    800877 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	83 c0 04             	add    $0x4,%eax
  8008a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ae:	83 e8 04             	sub    $0x4,%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008b6:	eb 1f                	jmp    8008d7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008bc:	79 83                	jns    800841 <vprintfmt+0x54>
				width = 0;
  8008be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008c5:	e9 77 ff ff ff       	jmp    800841 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008ca:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008d1:	e9 6b ff ff ff       	jmp    800841 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008d6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008db:	0f 89 60 ff ff ff    	jns    800841 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008e7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008ee:	e9 4e ff ff ff       	jmp    800841 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008f3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008f6:	e9 46 ff ff ff       	jmp    800841 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	83 c0 04             	add    $0x4,%eax
  800901:	89 45 14             	mov    %eax,0x14(%ebp)
  800904:	8b 45 14             	mov    0x14(%ebp),%eax
  800907:	83 e8 04             	sub    $0x4,%eax
  80090a:	8b 00                	mov    (%eax),%eax
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	50                   	push   %eax
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	ff d0                	call   *%eax
  800918:	83 c4 10             	add    $0x10,%esp
			break;
  80091b:	e9 9b 02 00 00       	jmp    800bbb <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800920:	8b 45 14             	mov    0x14(%ebp),%eax
  800923:	83 c0 04             	add    $0x4,%eax
  800926:	89 45 14             	mov    %eax,0x14(%ebp)
  800929:	8b 45 14             	mov    0x14(%ebp),%eax
  80092c:	83 e8 04             	sub    $0x4,%eax
  80092f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800931:	85 db                	test   %ebx,%ebx
  800933:	79 02                	jns    800937 <vprintfmt+0x14a>
				err = -err;
  800935:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800937:	83 fb 64             	cmp    $0x64,%ebx
  80093a:	7f 0b                	jg     800947 <vprintfmt+0x15a>
  80093c:	8b 34 9d 00 22 80 00 	mov    0x802200(,%ebx,4),%esi
  800943:	85 f6                	test   %esi,%esi
  800945:	75 19                	jne    800960 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800947:	53                   	push   %ebx
  800948:	68 a5 23 80 00       	push   $0x8023a5
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	ff 75 08             	pushl  0x8(%ebp)
  800953:	e8 70 02 00 00       	call   800bc8 <printfmt>
  800958:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80095b:	e9 5b 02 00 00       	jmp    800bbb <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800960:	56                   	push   %esi
  800961:	68 ae 23 80 00       	push   $0x8023ae
  800966:	ff 75 0c             	pushl  0xc(%ebp)
  800969:	ff 75 08             	pushl  0x8(%ebp)
  80096c:	e8 57 02 00 00       	call   800bc8 <printfmt>
  800971:	83 c4 10             	add    $0x10,%esp
			break;
  800974:	e9 42 02 00 00       	jmp    800bbb <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800979:	8b 45 14             	mov    0x14(%ebp),%eax
  80097c:	83 c0 04             	add    $0x4,%eax
  80097f:	89 45 14             	mov    %eax,0x14(%ebp)
  800982:	8b 45 14             	mov    0x14(%ebp),%eax
  800985:	83 e8 04             	sub    $0x4,%eax
  800988:	8b 30                	mov    (%eax),%esi
  80098a:	85 f6                	test   %esi,%esi
  80098c:	75 05                	jne    800993 <vprintfmt+0x1a6>
				p = "(null)";
  80098e:	be b1 23 80 00       	mov    $0x8023b1,%esi
			if (width > 0 && padc != '-')
  800993:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800997:	7e 6d                	jle    800a06 <vprintfmt+0x219>
  800999:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80099d:	74 67                	je     800a06 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80099f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009a2:	83 ec 08             	sub    $0x8,%esp
  8009a5:	50                   	push   %eax
  8009a6:	56                   	push   %esi
  8009a7:	e8 1e 03 00 00       	call   800cca <strnlen>
  8009ac:	83 c4 10             	add    $0x10,%esp
  8009af:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009b2:	eb 16                	jmp    8009ca <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009b4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	50                   	push   %eax
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	ff d0                	call   *%eax
  8009c4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ce:	7f e4                	jg     8009b4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d0:	eb 34                	jmp    800a06 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009d2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009d6:	74 1c                	je     8009f4 <vprintfmt+0x207>
  8009d8:	83 fb 1f             	cmp    $0x1f,%ebx
  8009db:	7e 05                	jle    8009e2 <vprintfmt+0x1f5>
  8009dd:	83 fb 7e             	cmp    $0x7e,%ebx
  8009e0:	7e 12                	jle    8009f4 <vprintfmt+0x207>
					putch('?', putdat);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	ff 75 0c             	pushl  0xc(%ebp)
  8009e8:	6a 3f                	push   $0x3f
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	ff d0                	call   *%eax
  8009ef:	83 c4 10             	add    $0x10,%esp
  8009f2:	eb 0f                	jmp    800a03 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009f4:	83 ec 08             	sub    $0x8,%esp
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	53                   	push   %ebx
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	ff d0                	call   *%eax
  800a00:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a03:	ff 4d e4             	decl   -0x1c(%ebp)
  800a06:	89 f0                	mov    %esi,%eax
  800a08:	8d 70 01             	lea    0x1(%eax),%esi
  800a0b:	8a 00                	mov    (%eax),%al
  800a0d:	0f be d8             	movsbl %al,%ebx
  800a10:	85 db                	test   %ebx,%ebx
  800a12:	74 24                	je     800a38 <vprintfmt+0x24b>
  800a14:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a18:	78 b8                	js     8009d2 <vprintfmt+0x1e5>
  800a1a:	ff 4d e0             	decl   -0x20(%ebp)
  800a1d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a21:	79 af                	jns    8009d2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a23:	eb 13                	jmp    800a38 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a25:	83 ec 08             	sub    $0x8,%esp
  800a28:	ff 75 0c             	pushl  0xc(%ebp)
  800a2b:	6a 20                	push   $0x20
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	ff d0                	call   *%eax
  800a32:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a35:	ff 4d e4             	decl   -0x1c(%ebp)
  800a38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3c:	7f e7                	jg     800a25 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a3e:	e9 78 01 00 00       	jmp    800bbb <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 e8             	pushl  -0x18(%ebp)
  800a49:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4c:	50                   	push   %eax
  800a4d:	e8 3c fd ff ff       	call   80078e <getint>
  800a52:	83 c4 10             	add    $0x10,%esp
  800a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a61:	85 d2                	test   %edx,%edx
  800a63:	79 23                	jns    800a88 <vprintfmt+0x29b>
				putch('-', putdat);
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 0c             	pushl  0xc(%ebp)
  800a6b:	6a 2d                	push   $0x2d
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	ff d0                	call   *%eax
  800a72:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7b:	f7 d8                	neg    %eax
  800a7d:	83 d2 00             	adc    $0x0,%edx
  800a80:	f7 da                	neg    %edx
  800a82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a85:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a88:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a8f:	e9 bc 00 00 00       	jmp    800b50 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 e8             	pushl  -0x18(%ebp)
  800a9a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a9d:	50                   	push   %eax
  800a9e:	e8 84 fc ff ff       	call   800727 <getuint>
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aac:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ab3:	e9 98 00 00 00       	jmp    800b50 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ab8:	83 ec 08             	sub    $0x8,%esp
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	6a 58                	push   $0x58
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	ff d0                	call   *%eax
  800ac5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	6a 58                	push   $0x58
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	ff d0                	call   *%eax
  800ad5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	ff 75 0c             	pushl  0xc(%ebp)
  800ade:	6a 58                	push   $0x58
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	ff d0                	call   *%eax
  800ae5:	83 c4 10             	add    $0x10,%esp
			break;
  800ae8:	e9 ce 00 00 00       	jmp    800bbb <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800aed:	83 ec 08             	sub    $0x8,%esp
  800af0:	ff 75 0c             	pushl  0xc(%ebp)
  800af3:	6a 30                	push   $0x30
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	ff d0                	call   *%eax
  800afa:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800afd:	83 ec 08             	sub    $0x8,%esp
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	6a 78                	push   $0x78
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	ff d0                	call   *%eax
  800b0a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b10:	83 c0 04             	add    $0x4,%eax
  800b13:	89 45 14             	mov    %eax,0x14(%ebp)
  800b16:	8b 45 14             	mov    0x14(%ebp),%eax
  800b19:	83 e8 04             	sub    $0x4,%eax
  800b1c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b28:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b2f:	eb 1f                	jmp    800b50 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 e8             	pushl  -0x18(%ebp)
  800b37:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3a:	50                   	push   %eax
  800b3b:	e8 e7 fb ff ff       	call   800727 <getuint>
  800b40:	83 c4 10             	add    $0x10,%esp
  800b43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b49:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b50:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b57:	83 ec 04             	sub    $0x4,%esp
  800b5a:	52                   	push   %edx
  800b5b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b5e:	50                   	push   %eax
  800b5f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b62:	ff 75 f0             	pushl  -0x10(%ebp)
  800b65:	ff 75 0c             	pushl  0xc(%ebp)
  800b68:	ff 75 08             	pushl  0x8(%ebp)
  800b6b:	e8 00 fb ff ff       	call   800670 <printnum>
  800b70:	83 c4 20             	add    $0x20,%esp
			break;
  800b73:	eb 46                	jmp    800bbb <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	53                   	push   %ebx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	ff d0                	call   *%eax
  800b81:	83 c4 10             	add    $0x10,%esp
			break;
  800b84:	eb 35                	jmp    800bbb <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b86:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b8d:	eb 2c                	jmp    800bbb <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b8f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b96:	eb 23                	jmp    800bbb <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	ff 75 0c             	pushl  0xc(%ebp)
  800b9e:	6a 25                	push   $0x25
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	ff d0                	call   *%eax
  800ba5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba8:	ff 4d 10             	decl   0x10(%ebp)
  800bab:	eb 03                	jmp    800bb0 <vprintfmt+0x3c3>
  800bad:	ff 4d 10             	decl   0x10(%ebp)
  800bb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb3:	48                   	dec    %eax
  800bb4:	8a 00                	mov    (%eax),%al
  800bb6:	3c 25                	cmp    $0x25,%al
  800bb8:	75 f3                	jne    800bad <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bba:	90                   	nop
		}
	}
  800bbb:	e9 35 fc ff ff       	jmp    8007f5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bc0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc4:	5b                   	pop    %ebx
  800bc5:	5e                   	pop    %esi
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    

00800bc8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bce:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd1:	83 c0 04             	add    $0x4,%eax
  800bd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bda:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdd:	50                   	push   %eax
  800bde:	ff 75 0c             	pushl  0xc(%ebp)
  800be1:	ff 75 08             	pushl  0x8(%ebp)
  800be4:	e8 04 fc ff ff       	call   8007ed <vprintfmt>
  800be9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bec:	90                   	nop
  800bed:	c9                   	leave  
  800bee:	c3                   	ret    

00800bef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf5:	8b 40 08             	mov    0x8(%eax),%eax
  800bf8:	8d 50 01             	lea    0x1(%eax),%edx
  800bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfe:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c04:	8b 10                	mov    (%eax),%edx
  800c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c09:	8b 40 04             	mov    0x4(%eax),%eax
  800c0c:	39 c2                	cmp    %eax,%edx
  800c0e:	73 12                	jae    800c22 <sprintputch+0x33>
		*b->buf++ = ch;
  800c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c13:	8b 00                	mov    (%eax),%eax
  800c15:	8d 48 01             	lea    0x1(%eax),%ecx
  800c18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1b:	89 0a                	mov    %ecx,(%edx)
  800c1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c20:	88 10                	mov    %dl,(%eax)
}
  800c22:	90                   	nop
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c34:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	01 d0                	add    %edx,%eax
  800c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c4a:	74 06                	je     800c52 <vsnprintf+0x2d>
  800c4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c50:	7f 07                	jg     800c59 <vsnprintf+0x34>
		return -E_INVAL;
  800c52:	b8 03 00 00 00       	mov    $0x3,%eax
  800c57:	eb 20                	jmp    800c79 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c59:	ff 75 14             	pushl  0x14(%ebp)
  800c5c:	ff 75 10             	pushl  0x10(%ebp)
  800c5f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c62:	50                   	push   %eax
  800c63:	68 ef 0b 80 00       	push   $0x800bef
  800c68:	e8 80 fb ff ff       	call   8007ed <vprintfmt>
  800c6d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c73:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c81:	8d 45 10             	lea    0x10(%ebp),%eax
  800c84:	83 c0 04             	add    $0x4,%eax
  800c87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c90:	50                   	push   %eax
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	ff 75 08             	pushl  0x8(%ebp)
  800c97:	e8 89 ff ff ff       	call   800c25 <vsnprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp
  800c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb4:	eb 06                	jmp    800cbc <strlen+0x15>
		n++;
  800cb6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb9:	ff 45 08             	incl   0x8(%ebp)
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	84 c0                	test   %al,%al
  800cc3:	75 f1                	jne    800cb6 <strlen+0xf>
		n++;
	return n;
  800cc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd7:	eb 09                	jmp    800ce2 <strnlen+0x18>
		n++;
  800cd9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cdc:	ff 45 08             	incl   0x8(%ebp)
  800cdf:	ff 4d 0c             	decl   0xc(%ebp)
  800ce2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce6:	74 09                	je     800cf1 <strnlen+0x27>
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	84 c0                	test   %al,%al
  800cef:	75 e8                	jne    800cd9 <strnlen+0xf>
		n++;
	return n;
  800cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf4:	c9                   	leave  
  800cf5:	c3                   	ret    

00800cf6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d02:	90                   	nop
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8d 50 01             	lea    0x1(%eax),%edx
  800d09:	89 55 08             	mov    %edx,0x8(%ebp)
  800d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d12:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d15:	8a 12                	mov    (%edx),%dl
  800d17:	88 10                	mov    %dl,(%eax)
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	84 c0                	test   %al,%al
  800d1d:	75 e4                	jne    800d03 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d22:	c9                   	leave  
  800d23:	c3                   	ret    

00800d24 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d37:	eb 1f                	jmp    800d58 <strncpy+0x34>
		*dst++ = *src;
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8d 50 01             	lea    0x1(%eax),%edx
  800d3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d45:	8a 12                	mov    (%edx),%dl
  800d47:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	84 c0                	test   %al,%al
  800d50:	74 03                	je     800d55 <strncpy+0x31>
			src++;
  800d52:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d55:	ff 45 fc             	incl   -0x4(%ebp)
  800d58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d5e:	72 d9                	jb     800d39 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d60:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d63:	c9                   	leave  
  800d64:	c3                   	ret    

00800d65 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d75:	74 30                	je     800da7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d77:	eb 16                	jmp    800d8f <strlcpy+0x2a>
			*dst++ = *src++;
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8d 50 01             	lea    0x1(%eax),%edx
  800d7f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d88:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d8b:	8a 12                	mov    (%edx),%dl
  800d8d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d8f:	ff 4d 10             	decl   0x10(%ebp)
  800d92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d96:	74 09                	je     800da1 <strlcpy+0x3c>
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	8a 00                	mov    (%eax),%al
  800d9d:	84 c0                	test   %al,%al
  800d9f:	75 d8                	jne    800d79 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da7:	8b 55 08             	mov    0x8(%ebp),%edx
  800daa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dad:	29 c2                	sub    %eax,%edx
  800daf:	89 d0                	mov    %edx,%eax
}
  800db1:	c9                   	leave  
  800db2:	c3                   	ret    

00800db3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800db6:	eb 06                	jmp    800dbe <strcmp+0xb>
		p++, q++;
  800db8:	ff 45 08             	incl   0x8(%ebp)
  800dbb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	84 c0                	test   %al,%al
  800dc5:	74 0e                	je     800dd5 <strcmp+0x22>
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8a 10                	mov    (%eax),%dl
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	38 c2                	cmp    %al,%dl
  800dd3:	74 e3                	je     800db8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	8a 00                	mov    (%eax),%al
  800dda:	0f b6 d0             	movzbl %al,%edx
  800ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	0f b6 c0             	movzbl %al,%eax
  800de5:	29 c2                	sub    %eax,%edx
  800de7:	89 d0                	mov    %edx,%eax
}
  800de9:	5d                   	pop    %ebp
  800dea:	c3                   	ret    

00800deb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dee:	eb 09                	jmp    800df9 <strncmp+0xe>
		n--, p++, q++;
  800df0:	ff 4d 10             	decl   0x10(%ebp)
  800df3:	ff 45 08             	incl   0x8(%ebp)
  800df6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfd:	74 17                	je     800e16 <strncmp+0x2b>
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	84 c0                	test   %al,%al
  800e06:	74 0e                	je     800e16 <strncmp+0x2b>
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8a 10                	mov    (%eax),%dl
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	38 c2                	cmp    %al,%dl
  800e14:	74 da                	je     800df0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1a:	75 07                	jne    800e23 <strncmp+0x38>
		return 0;
  800e1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e21:	eb 14                	jmp    800e37 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	0f b6 d0             	movzbl %al,%edx
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	0f b6 c0             	movzbl %al,%eax
  800e33:	29 c2                	sub    %eax,%edx
  800e35:	89 d0                	mov    %edx,%eax
}
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 04             	sub    $0x4,%esp
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e45:	eb 12                	jmp    800e59 <strchr+0x20>
		if (*s == c)
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e4f:	75 05                	jne    800e56 <strchr+0x1d>
			return (char *) s;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	eb 11                	jmp    800e67 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e56:	ff 45 08             	incl   0x8(%ebp)
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	84 c0                	test   %al,%al
  800e60:	75 e5                	jne    800e47 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 04             	sub    $0x4,%esp
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e75:	eb 0d                	jmp    800e84 <strfind+0x1b>
		if (*s == c)
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7f:	74 0e                	je     800e8f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e81:	ff 45 08             	incl   0x8(%ebp)
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	84 c0                	test   %al,%al
  800e8b:	75 ea                	jne    800e77 <strfind+0xe>
  800e8d:	eb 01                	jmp    800e90 <strfind+0x27>
		if (*s == c)
			break;
  800e8f:	90                   	nop
	return (char *) s;
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ea1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea5:	76 63                	jbe    800f0a <memset+0x75>
		uint64 data_block = c;
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	99                   	cltd   
  800eab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eae:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb7:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ebb:	c1 e0 08             	shl    $0x8,%eax
  800ebe:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec1:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eca:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ece:	c1 e0 10             	shl    $0x10,%eax
  800ed1:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ed4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800edd:	89 c2                	mov    %eax,%edx
  800edf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee4:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ee7:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800eea:	eb 18                	jmp    800f04 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800eec:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eef:	8d 41 08             	lea    0x8(%ecx),%eax
  800ef2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800efb:	89 01                	mov    %eax,(%ecx)
  800efd:	89 51 04             	mov    %edx,0x4(%ecx)
  800f00:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f04:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f08:	77 e2                	ja     800eec <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0e:	74 23                	je     800f33 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f13:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f16:	eb 0e                	jmp    800f26 <memset+0x91>
			*p8++ = (uint8)c;
  800f18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1b:	8d 50 01             	lea    0x1(%eax),%edx
  800f1e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f24:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f26:	8b 45 10             	mov    0x10(%ebp),%eax
  800f29:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f2c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f2f:	85 c0                	test   %eax,%eax
  800f31:	75 e5                	jne    800f18 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f4a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f4e:	76 24                	jbe    800f74 <memcpy+0x3c>
		while(n >= 8){
  800f50:	eb 1c                	jmp    800f6e <memcpy+0x36>
			*d64 = *s64;
  800f52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f55:	8b 50 04             	mov    0x4(%eax),%edx
  800f58:	8b 00                	mov    (%eax),%eax
  800f5a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f5d:	89 01                	mov    %eax,(%ecx)
  800f5f:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f62:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f66:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f6a:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f6e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f72:	77 de                	ja     800f52 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f78:	74 31                	je     800fab <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f86:	eb 16                	jmp    800f9e <memcpy+0x66>
			*d8++ = *s8++;
  800f88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8b:	8d 50 01             	lea    0x1(%eax),%edx
  800f8e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f94:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f97:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f9a:	8a 12                	mov    (%edx),%dl
  800f9c:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa4:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa7:	85 c0                	test   %eax,%eax
  800fa9:	75 dd                	jne    800f88 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fae:	c9                   	leave  
  800faf:	c3                   	ret    

00800fb0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc8:	73 50                	jae    80101a <memmove+0x6a>
  800fca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd0:	01 d0                	add    %edx,%eax
  800fd2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fd5:	76 43                	jbe    80101a <memmove+0x6a>
		s += n;
  800fd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fda:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fe3:	eb 10                	jmp    800ff5 <memmove+0x45>
			*--d = *--s;
  800fe5:	ff 4d f8             	decl   -0x8(%ebp)
  800fe8:	ff 4d fc             	decl   -0x4(%ebp)
  800feb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fee:	8a 10                	mov    (%eax),%dl
  800ff0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ff5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffb:	89 55 10             	mov    %edx,0x10(%ebp)
  800ffe:	85 c0                	test   %eax,%eax
  801000:	75 e3                	jne    800fe5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801002:	eb 23                	jmp    801027 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801004:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801007:	8d 50 01             	lea    0x1(%eax),%edx
  80100a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80100d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801010:	8d 4a 01             	lea    0x1(%edx),%ecx
  801013:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801016:	8a 12                	mov    (%edx),%dl
  801018:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80101a:	8b 45 10             	mov    0x10(%ebp),%eax
  80101d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801020:	89 55 10             	mov    %edx,0x10(%ebp)
  801023:	85 c0                	test   %eax,%eax
  801025:	75 dd                	jne    801004 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80102a:	c9                   	leave  
  80102b:	c3                   	ret    

0080102c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80103e:	eb 2a                	jmp    80106a <memcmp+0x3e>
		if (*s1 != *s2)
  801040:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801043:	8a 10                	mov    (%eax),%dl
  801045:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	38 c2                	cmp    %al,%dl
  80104c:	74 16                	je     801064 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80104e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801051:	8a 00                	mov    (%eax),%al
  801053:	0f b6 d0             	movzbl %al,%edx
  801056:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801059:	8a 00                	mov    (%eax),%al
  80105b:	0f b6 c0             	movzbl %al,%eax
  80105e:	29 c2                	sub    %eax,%edx
  801060:	89 d0                	mov    %edx,%eax
  801062:	eb 18                	jmp    80107c <memcmp+0x50>
		s1++, s2++;
  801064:	ff 45 fc             	incl   -0x4(%ebp)
  801067:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80106a:	8b 45 10             	mov    0x10(%ebp),%eax
  80106d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801070:	89 55 10             	mov    %edx,0x10(%ebp)
  801073:	85 c0                	test   %eax,%eax
  801075:	75 c9                	jne    801040 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801077:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80107c:	c9                   	leave  
  80107d:	c3                   	ret    

0080107e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801084:	8b 55 08             	mov    0x8(%ebp),%edx
  801087:	8b 45 10             	mov    0x10(%ebp),%eax
  80108a:	01 d0                	add    %edx,%eax
  80108c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80108f:	eb 15                	jmp    8010a6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	0f b6 d0             	movzbl %al,%edx
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	0f b6 c0             	movzbl %al,%eax
  80109f:	39 c2                	cmp    %eax,%edx
  8010a1:	74 0d                	je     8010b0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010a3:	ff 45 08             	incl   0x8(%ebp)
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010ac:	72 e3                	jb     801091 <memfind+0x13>
  8010ae:	eb 01                	jmp    8010b1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010b0:	90                   	nop
	return (void *) s;
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ca:	eb 03                	jmp    8010cf <strtol+0x19>
		s++;
  8010cc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 20                	cmp    $0x20,%al
  8010d6:	74 f4                	je     8010cc <strtol+0x16>
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	3c 09                	cmp    $0x9,%al
  8010df:	74 eb                	je     8010cc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	3c 2b                	cmp    $0x2b,%al
  8010e8:	75 05                	jne    8010ef <strtol+0x39>
		s++;
  8010ea:	ff 45 08             	incl   0x8(%ebp)
  8010ed:	eb 13                	jmp    801102 <strtol+0x4c>
	else if (*s == '-')
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	3c 2d                	cmp    $0x2d,%al
  8010f6:	75 0a                	jne    801102 <strtol+0x4c>
		s++, neg = 1;
  8010f8:	ff 45 08             	incl   0x8(%ebp)
  8010fb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	74 06                	je     80110e <strtol+0x58>
  801108:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80110c:	75 20                	jne    80112e <strtol+0x78>
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 30                	cmp    $0x30,%al
  801115:	75 17                	jne    80112e <strtol+0x78>
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	40                   	inc    %eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	3c 78                	cmp    $0x78,%al
  80111f:	75 0d                	jne    80112e <strtol+0x78>
		s += 2, base = 16;
  801121:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801125:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80112c:	eb 28                	jmp    801156 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80112e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801132:	75 15                	jne    801149 <strtol+0x93>
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	3c 30                	cmp    $0x30,%al
  80113b:	75 0c                	jne    801149 <strtol+0x93>
		s++, base = 8;
  80113d:	ff 45 08             	incl   0x8(%ebp)
  801140:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801147:	eb 0d                	jmp    801156 <strtol+0xa0>
	else if (base == 0)
  801149:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114d:	75 07                	jne    801156 <strtol+0xa0>
		base = 10;
  80114f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	3c 2f                	cmp    $0x2f,%al
  80115d:	7e 19                	jle    801178 <strtol+0xc2>
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	3c 39                	cmp    $0x39,%al
  801166:	7f 10                	jg     801178 <strtol+0xc2>
			dig = *s - '0';
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	0f be c0             	movsbl %al,%eax
  801170:	83 e8 30             	sub    $0x30,%eax
  801173:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801176:	eb 42                	jmp    8011ba <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	3c 60                	cmp    $0x60,%al
  80117f:	7e 19                	jle    80119a <strtol+0xe4>
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	3c 7a                	cmp    $0x7a,%al
  801188:	7f 10                	jg     80119a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	0f be c0             	movsbl %al,%eax
  801192:	83 e8 57             	sub    $0x57,%eax
  801195:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801198:	eb 20                	jmp    8011ba <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	3c 40                	cmp    $0x40,%al
  8011a1:	7e 39                	jle    8011dc <strtol+0x126>
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	3c 5a                	cmp    $0x5a,%al
  8011aa:	7f 30                	jg     8011dc <strtol+0x126>
			dig = *s - 'A' + 10;
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	0f be c0             	movsbl %al,%eax
  8011b4:	83 e8 37             	sub    $0x37,%eax
  8011b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011c0:	7d 19                	jge    8011db <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011c2:	ff 45 08             	incl   0x8(%ebp)
  8011c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c8:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011cc:	89 c2                	mov    %eax,%edx
  8011ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d1:	01 d0                	add    %edx,%eax
  8011d3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011d6:	e9 7b ff ff ff       	jmp    801156 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011db:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e0:	74 08                	je     8011ea <strtol+0x134>
		*endptr = (char *) s;
  8011e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ee:	74 07                	je     8011f7 <strtol+0x141>
  8011f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f3:	f7 d8                	neg    %eax
  8011f5:	eb 03                	jmp    8011fa <strtol+0x144>
  8011f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011fa:	c9                   	leave  
  8011fb:	c3                   	ret    

008011fc <ltostr>:

void
ltostr(long value, char *str)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801202:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801209:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801210:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801214:	79 13                	jns    801229 <ltostr+0x2d>
	{
		neg = 1;
  801216:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801223:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801226:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801231:	99                   	cltd   
  801232:	f7 f9                	idiv   %ecx
  801234:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123a:	8d 50 01             	lea    0x1(%eax),%edx
  80123d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801240:	89 c2                	mov    %eax,%edx
  801242:	8b 45 0c             	mov    0xc(%ebp),%eax
  801245:	01 d0                	add    %edx,%eax
  801247:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80124a:	83 c2 30             	add    $0x30,%edx
  80124d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80124f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801252:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801257:	f7 e9                	imul   %ecx
  801259:	c1 fa 02             	sar    $0x2,%edx
  80125c:	89 c8                	mov    %ecx,%eax
  80125e:	c1 f8 1f             	sar    $0x1f,%eax
  801261:	29 c2                	sub    %eax,%edx
  801263:	89 d0                	mov    %edx,%eax
  801265:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801268:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80126c:	75 bb                	jne    801229 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80126e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801275:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801278:	48                   	dec    %eax
  801279:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80127c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801280:	74 3d                	je     8012bf <ltostr+0xc3>
		start = 1 ;
  801282:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801289:	eb 34                	jmp    8012bf <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80128b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801291:	01 d0                	add    %edx,%eax
  801293:	8a 00                	mov    (%eax),%al
  801295:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801298:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80129b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129e:	01 c2                	add    %eax,%edx
  8012a0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a6:	01 c8                	add    %ecx,%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b2:	01 c2                	add    %eax,%edx
  8012b4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012b7:	88 02                	mov    %al,(%edx)
		start++ ;
  8012b9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012bc:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c5:	7c c4                	jl     80128b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012c7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cd:	01 d0                	add    %edx,%eax
  8012cf:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012d2:	90                   	nop
  8012d3:	c9                   	leave  
  8012d4:	c3                   	ret    

008012d5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012db:	ff 75 08             	pushl  0x8(%ebp)
  8012de:	e8 c4 f9 ff ff       	call   800ca7 <strlen>
  8012e3:	83 c4 04             	add    $0x4,%esp
  8012e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012e9:	ff 75 0c             	pushl  0xc(%ebp)
  8012ec:	e8 b6 f9 ff ff       	call   800ca7 <strlen>
  8012f1:	83 c4 04             	add    $0x4,%esp
  8012f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801305:	eb 17                	jmp    80131e <strcconcat+0x49>
		final[s] = str1[s] ;
  801307:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130a:	8b 45 10             	mov    0x10(%ebp),%eax
  80130d:	01 c2                	add    %eax,%edx
  80130f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	01 c8                	add    %ecx,%eax
  801317:	8a 00                	mov    (%eax),%al
  801319:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80131b:	ff 45 fc             	incl   -0x4(%ebp)
  80131e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801321:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801324:	7c e1                	jl     801307 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801326:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80132d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801334:	eb 1f                	jmp    801355 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801336:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801339:	8d 50 01             	lea    0x1(%eax),%edx
  80133c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80133f:	89 c2                	mov    %eax,%edx
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	01 c2                	add    %eax,%edx
  801346:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	01 c8                	add    %ecx,%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801352:	ff 45 f8             	incl   -0x8(%ebp)
  801355:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801358:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80135b:	7c d9                	jl     801336 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80135d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801360:	8b 45 10             	mov    0x10(%ebp),%eax
  801363:	01 d0                	add    %edx,%eax
  801365:	c6 00 00             	movb   $0x0,(%eax)
}
  801368:	90                   	nop
  801369:	c9                   	leave  
  80136a:	c3                   	ret    

0080136b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80136e:	8b 45 14             	mov    0x14(%ebp),%eax
  801371:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801377:	8b 45 14             	mov    0x14(%ebp),%eax
  80137a:	8b 00                	mov    (%eax),%eax
  80137c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801383:	8b 45 10             	mov    0x10(%ebp),%eax
  801386:	01 d0                	add    %edx,%eax
  801388:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138e:	eb 0c                	jmp    80139c <strsplit+0x31>
			*string++ = 0;
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8d 50 01             	lea    0x1(%eax),%edx
  801396:	89 55 08             	mov    %edx,0x8(%ebp)
  801399:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	84 c0                	test   %al,%al
  8013a3:	74 18                	je     8013bd <strsplit+0x52>
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	0f be c0             	movsbl %al,%eax
  8013ad:	50                   	push   %eax
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	e8 83 fa ff ff       	call   800e39 <strchr>
  8013b6:	83 c4 08             	add    $0x8,%esp
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	75 d3                	jne    801390 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	84 c0                	test   %al,%al
  8013c4:	74 5a                	je     801420 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c9:	8b 00                	mov    (%eax),%eax
  8013cb:	83 f8 0f             	cmp    $0xf,%eax
  8013ce:	75 07                	jne    8013d7 <strsplit+0x6c>
		{
			return 0;
  8013d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d5:	eb 66                	jmp    80143d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8013da:	8b 00                	mov    (%eax),%eax
  8013dc:	8d 48 01             	lea    0x1(%eax),%ecx
  8013df:	8b 55 14             	mov    0x14(%ebp),%edx
  8013e2:	89 0a                	mov    %ecx,(%edx)
  8013e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ee:	01 c2                	add    %eax,%edx
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f5:	eb 03                	jmp    8013fa <strsplit+0x8f>
			string++;
  8013f7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fd:	8a 00                	mov    (%eax),%al
  8013ff:	84 c0                	test   %al,%al
  801401:	74 8b                	je     80138e <strsplit+0x23>
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	0f be c0             	movsbl %al,%eax
  80140b:	50                   	push   %eax
  80140c:	ff 75 0c             	pushl  0xc(%ebp)
  80140f:	e8 25 fa ff ff       	call   800e39 <strchr>
  801414:	83 c4 08             	add    $0x8,%esp
  801417:	85 c0                	test   %eax,%eax
  801419:	74 dc                	je     8013f7 <strsplit+0x8c>
			string++;
	}
  80141b:	e9 6e ff ff ff       	jmp    80138e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801420:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801421:	8b 45 14             	mov    0x14(%ebp),%eax
  801424:	8b 00                	mov    (%eax),%eax
  801426:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80142d:	8b 45 10             	mov    0x10(%ebp),%eax
  801430:	01 d0                	add    %edx,%eax
  801432:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801438:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80143d:	c9                   	leave  
  80143e:	c3                   	ret    

0080143f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80144b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801452:	eb 4a                	jmp    80149e <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801454:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	01 c2                	add    %eax,%edx
  80145c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80145f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801462:	01 c8                	add    %ecx,%eax
  801464:	8a 00                	mov    (%eax),%al
  801466:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801468:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146e:	01 d0                	add    %edx,%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3c 40                	cmp    $0x40,%al
  801474:	7e 25                	jle    80149b <str2lower+0x5c>
  801476:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147c:	01 d0                	add    %edx,%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	3c 5a                	cmp    $0x5a,%al
  801482:	7f 17                	jg     80149b <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801484:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	01 d0                	add    %edx,%eax
  80148c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80148f:	8b 55 08             	mov    0x8(%ebp),%edx
  801492:	01 ca                	add    %ecx,%edx
  801494:	8a 12                	mov    (%edx),%dl
  801496:	83 c2 20             	add    $0x20,%edx
  801499:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80149b:	ff 45 fc             	incl   -0x4(%ebp)
  80149e:	ff 75 0c             	pushl  0xc(%ebp)
  8014a1:	e8 01 f8 ff ff       	call   800ca7 <strlen>
  8014a6:	83 c4 04             	add    $0x4,%esp
  8014a9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014ac:	7f a6                	jg     801454 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	57                   	push   %edi
  8014b7:	56                   	push   %esi
  8014b8:	53                   	push   %ebx
  8014b9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014c8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014cb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014ce:	cd 30                	int    $0x30
  8014d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	5b                   	pop    %ebx
  8014da:	5e                   	pop    %esi
  8014db:	5f                   	pop    %edi
  8014dc:	5d                   	pop    %ebp
  8014dd:	c3                   	ret    

008014de <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 04             	sub    $0x4,%esp
  8014e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014ea:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014ed:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	6a 00                	push   $0x0
  8014f6:	51                   	push   %ecx
  8014f7:	52                   	push   %edx
  8014f8:	ff 75 0c             	pushl  0xc(%ebp)
  8014fb:	50                   	push   %eax
  8014fc:	6a 00                	push   $0x0
  8014fe:	e8 b0 ff ff ff       	call   8014b3 <syscall>
  801503:	83 c4 18             	add    $0x18,%esp
}
  801506:	90                   	nop
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <sys_cgetc>:

int
sys_cgetc(void)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 02                	push   $0x2
  801518:	e8 96 ff ff ff       	call   8014b3 <syscall>
  80151d:	83 c4 18             	add    $0x18,%esp
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 03                	push   $0x3
  801531:	e8 7d ff ff ff       	call   8014b3 <syscall>
  801536:	83 c4 18             	add    $0x18,%esp
}
  801539:	90                   	nop
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    

0080153c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 04                	push   $0x4
  80154b:	e8 63 ff ff ff       	call   8014b3 <syscall>
  801550:	83 c4 18             	add    $0x18,%esp
}
  801553:	90                   	nop
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801559:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	52                   	push   %edx
  801566:	50                   	push   %eax
  801567:	6a 08                	push   $0x8
  801569:	e8 45 ff ff ff       	call   8014b3 <syscall>
  80156e:	83 c4 18             	add    $0x18,%esp
}
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	56                   	push   %esi
  801577:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801578:	8b 75 18             	mov    0x18(%ebp),%esi
  80157b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80157e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801581:	8b 55 0c             	mov    0xc(%ebp),%edx
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	56                   	push   %esi
  801588:	53                   	push   %ebx
  801589:	51                   	push   %ecx
  80158a:	52                   	push   %edx
  80158b:	50                   	push   %eax
  80158c:	6a 09                	push   $0x9
  80158e:	e8 20 ff ff ff       	call   8014b3 <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
}
  801596:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801599:	5b                   	pop    %ebx
  80159a:	5e                   	pop    %esi
  80159b:	5d                   	pop    %ebp
  80159c:	c3                   	ret    

0080159d <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	ff 75 08             	pushl  0x8(%ebp)
  8015ab:	6a 0a                	push   $0xa
  8015ad:	e8 01 ff ff ff       	call   8014b3 <syscall>
  8015b2:	83 c4 18             	add    $0x18,%esp
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	ff 75 0c             	pushl  0xc(%ebp)
  8015c3:	ff 75 08             	pushl  0x8(%ebp)
  8015c6:	6a 0b                	push   $0xb
  8015c8:	e8 e6 fe ff ff       	call   8014b3 <syscall>
  8015cd:	83 c4 18             	add    $0x18,%esp
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 0c                	push   $0xc
  8015e1:	e8 cd fe ff ff       	call   8014b3 <syscall>
  8015e6:	83 c4 18             	add    $0x18,%esp
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 0d                	push   $0xd
  8015fa:	e8 b4 fe ff ff       	call   8014b3 <syscall>
  8015ff:	83 c4 18             	add    $0x18,%esp
}
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 0e                	push   $0xe
  801613:	e8 9b fe ff ff       	call   8014b3 <syscall>
  801618:	83 c4 18             	add    $0x18,%esp
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 0f                	push   $0xf
  80162c:	e8 82 fe ff ff       	call   8014b3 <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	ff 75 08             	pushl  0x8(%ebp)
  801644:	6a 10                	push   $0x10
  801646:	e8 68 fe ff ff       	call   8014b3 <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 11                	push   $0x11
  80165f:	e8 4f fe ff ff       	call   8014b3 <syscall>
  801664:	83 c4 18             	add    $0x18,%esp
}
  801667:	90                   	nop
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <sys_cputc>:

void
sys_cputc(const char c)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	83 ec 04             	sub    $0x4,%esp
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801676:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	50                   	push   %eax
  801683:	6a 01                	push   $0x1
  801685:	e8 29 fe ff ff       	call   8014b3 <syscall>
  80168a:	83 c4 18             	add    $0x18,%esp
}
  80168d:	90                   	nop
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 14                	push   $0x14
  80169f:	e8 0f fe ff ff       	call   8014b3 <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
}
  8016a7:	90                   	nop
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	83 ec 04             	sub    $0x4,%esp
  8016b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016b6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016b9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	6a 00                	push   $0x0
  8016c2:	51                   	push   %ecx
  8016c3:	52                   	push   %edx
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	50                   	push   %eax
  8016c8:	6a 15                	push   $0x15
  8016ca:	e8 e4 fd ff ff       	call   8014b3 <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	52                   	push   %edx
  8016e4:	50                   	push   %eax
  8016e5:	6a 16                	push   $0x16
  8016e7:	e8 c7 fd ff ff       	call   8014b3 <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	51                   	push   %ecx
  801702:	52                   	push   %edx
  801703:	50                   	push   %eax
  801704:	6a 17                	push   $0x17
  801706:	e8 a8 fd ff ff       	call   8014b3 <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801713:	8b 55 0c             	mov    0xc(%ebp),%edx
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	52                   	push   %edx
  801720:	50                   	push   %eax
  801721:	6a 18                	push   $0x18
  801723:	e8 8b fd ff ff       	call   8014b3 <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	6a 00                	push   $0x0
  801735:	ff 75 14             	pushl  0x14(%ebp)
  801738:	ff 75 10             	pushl  0x10(%ebp)
  80173b:	ff 75 0c             	pushl  0xc(%ebp)
  80173e:	50                   	push   %eax
  80173f:	6a 19                	push   $0x19
  801741:	e8 6d fd ff ff       	call   8014b3 <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	50                   	push   %eax
  80175a:	6a 1a                	push   $0x1a
  80175c:	e8 52 fd ff ff       	call   8014b3 <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
}
  801764:	90                   	nop
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	50                   	push   %eax
  801776:	6a 1b                	push   $0x1b
  801778:	e8 36 fd ff ff       	call   8014b3 <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 05                	push   $0x5
  801791:	e8 1d fd ff ff       	call   8014b3 <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 06                	push   $0x6
  8017aa:	e8 04 fd ff ff       	call   8014b3 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 07                	push   $0x7
  8017c3:	e8 eb fc ff ff       	call   8014b3 <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_exit_env>:


void sys_exit_env(void)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 1c                	push   $0x1c
  8017dc:	e8 d2 fc ff ff       	call   8014b3 <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	90                   	nop
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017ed:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017f0:	8d 50 04             	lea    0x4(%eax),%edx
  8017f3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	52                   	push   %edx
  8017fd:	50                   	push   %eax
  8017fe:	6a 1d                	push   $0x1d
  801800:	e8 ae fc ff ff       	call   8014b3 <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
	return result;
  801808:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80180b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801811:	89 01                	mov    %eax,(%ecx)
  801813:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	c9                   	leave  
  80181a:	c2 04 00             	ret    $0x4

0080181d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	ff 75 10             	pushl  0x10(%ebp)
  801827:	ff 75 0c             	pushl  0xc(%ebp)
  80182a:	ff 75 08             	pushl  0x8(%ebp)
  80182d:	6a 13                	push   $0x13
  80182f:	e8 7f fc ff ff       	call   8014b3 <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
	return ;
  801837:	90                   	nop
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_rcr2>:
uint32 sys_rcr2()
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 1e                	push   $0x1e
  801849:	e8 65 fc ff ff       	call   8014b3 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	83 ec 04             	sub    $0x4,%esp
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80185f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	50                   	push   %eax
  80186c:	6a 1f                	push   $0x1f
  80186e:	e8 40 fc ff ff       	call   8014b3 <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
	return ;
  801876:	90                   	nop
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <rsttst>:
void rsttst()
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 21                	push   $0x21
  801888:	e8 26 fc ff ff       	call   8014b3 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
	return ;
  801890:	90                   	nop
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 04             	sub    $0x4,%esp
  801899:	8b 45 14             	mov    0x14(%ebp),%eax
  80189c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80189f:	8b 55 18             	mov    0x18(%ebp),%edx
  8018a2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018a6:	52                   	push   %edx
  8018a7:	50                   	push   %eax
  8018a8:	ff 75 10             	pushl  0x10(%ebp)
  8018ab:	ff 75 0c             	pushl  0xc(%ebp)
  8018ae:	ff 75 08             	pushl  0x8(%ebp)
  8018b1:	6a 20                	push   $0x20
  8018b3:	e8 fb fb ff ff       	call   8014b3 <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018bb:	90                   	nop
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <chktst>:
void chktst(uint32 n)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	ff 75 08             	pushl  0x8(%ebp)
  8018cc:	6a 22                	push   $0x22
  8018ce:	e8 e0 fb ff ff       	call   8014b3 <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d6:	90                   	nop
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <inctst>:

void inctst()
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 23                	push   $0x23
  8018e8:	e8 c6 fb ff ff       	call   8014b3 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f0:	90                   	nop
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <gettst>:
uint32 gettst()
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 24                	push   $0x24
  801902:	e8 ac fb ff ff       	call   8014b3 <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 25                	push   $0x25
  80191b:	e8 93 fb ff ff       	call   8014b3 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
  801923:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801928:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	ff 75 08             	pushl  0x8(%ebp)
  801945:	6a 26                	push   $0x26
  801947:	e8 67 fb ff ff       	call   8014b3 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
	return ;
  80194f:	90                   	nop
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801956:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801959:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80195c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	6a 00                	push   $0x0
  801964:	53                   	push   %ebx
  801965:	51                   	push   %ecx
  801966:	52                   	push   %edx
  801967:	50                   	push   %eax
  801968:	6a 27                	push   $0x27
  80196a:	e8 44 fb ff ff       	call   8014b3 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80197a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	52                   	push   %edx
  801987:	50                   	push   %eax
  801988:	6a 28                	push   $0x28
  80198a:	e8 24 fb ff ff       	call   8014b3 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801997:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80199a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	6a 00                	push   $0x0
  8019a2:	51                   	push   %ecx
  8019a3:	ff 75 10             	pushl  0x10(%ebp)
  8019a6:	52                   	push   %edx
  8019a7:	50                   	push   %eax
  8019a8:	6a 29                	push   $0x29
  8019aa:	e8 04 fb ff ff       	call   8014b3 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	ff 75 10             	pushl  0x10(%ebp)
  8019be:	ff 75 0c             	pushl  0xc(%ebp)
  8019c1:	ff 75 08             	pushl  0x8(%ebp)
  8019c4:	6a 12                	push   $0x12
  8019c6:	e8 e8 fa ff ff       	call   8014b3 <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ce:	90                   	nop
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	52                   	push   %edx
  8019e1:	50                   	push   %eax
  8019e2:	6a 2a                	push   $0x2a
  8019e4:	e8 ca fa ff ff       	call   8014b3 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
	return;
  8019ec:	90                   	nop
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 2b                	push   $0x2b
  8019fe:	e8 b0 fa ff ff       	call   8014b3 <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	ff 75 0c             	pushl  0xc(%ebp)
  801a14:	ff 75 08             	pushl  0x8(%ebp)
  801a17:	6a 2d                	push   $0x2d
  801a19:	e8 95 fa ff ff       	call   8014b3 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
	return;
  801a21:	90                   	nop
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	ff 75 0c             	pushl  0xc(%ebp)
  801a30:	ff 75 08             	pushl  0x8(%ebp)
  801a33:	6a 2c                	push   $0x2c
  801a35:	e8 79 fa ff ff       	call   8014b3 <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3d:	90                   	nop
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	52                   	push   %edx
  801a50:	50                   	push   %eax
  801a51:	6a 2e                	push   $0x2e
  801a53:	e8 5b fa ff ff       	call   8014b3 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5b:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  801a64:	83 ec 04             	sub    $0x4,%esp
  801a67:	68 28 25 80 00       	push   $0x802528
  801a6c:	6a 07                	push   $0x7
  801a6e:	68 57 25 80 00       	push   $0x802557
  801a73:	e8 68 e8 ff ff       	call   8002e0 <_panic>

00801a78 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  801a7e:	83 ec 04             	sub    $0x4,%esp
  801a81:	68 68 25 80 00       	push   $0x802568
  801a86:	6a 0b                	push   $0xb
  801a88:	68 57 25 80 00       	push   $0x802557
  801a8d:	e8 4e e8 ff ff       	call   8002e0 <_panic>

00801a92 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  801a98:	83 ec 04             	sub    $0x4,%esp
  801a9b:	68 94 25 80 00       	push   $0x802594
  801aa0:	6a 10                	push   $0x10
  801aa2:	68 57 25 80 00       	push   $0x802557
  801aa7:	e8 34 e8 ff ff       	call   8002e0 <_panic>

00801aac <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  801ab2:	83 ec 04             	sub    $0x4,%esp
  801ab5:	68 c4 25 80 00       	push   $0x8025c4
  801aba:	6a 15                	push   $0x15
  801abc:	68 57 25 80 00       	push   $0x802557
  801ac1:	e8 1a e8 ff ff       	call   8002e0 <_panic>

00801ac6 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	8b 40 10             	mov    0x10(%eax),%eax
}
  801acf:	5d                   	pop    %ebp
  801ad0:	c3                   	ret    

00801ad1 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801ad7:	8b 55 08             	mov    0x8(%ebp),%edx
  801ada:	89 d0                	mov    %edx,%eax
  801adc:	c1 e0 02             	shl    $0x2,%eax
  801adf:	01 d0                	add    %edx,%eax
  801ae1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae8:	01 d0                	add    %edx,%eax
  801aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af1:	01 d0                	add    %edx,%eax
  801af3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801afa:	01 d0                	add    %edx,%eax
  801afc:	c1 e0 04             	shl    $0x4,%eax
  801aff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801b02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801b09:	0f 31                	rdtsc  
  801b0b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b0e:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b14:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b1a:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801b1d:	eb 46                	jmp    801b65 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801b1f:	0f 31                	rdtsc  
  801b21:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b27:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b2a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801b2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b30:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801b33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b39:	29 c2                	sub    %eax,%edx
  801b3b:	89 d0                	mov    %edx,%eax
  801b3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801b40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b46:	89 d1                	mov    %edx,%ecx
  801b48:	29 c1                	sub    %eax,%ecx
  801b4a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b50:	39 c2                	cmp    %eax,%edx
  801b52:	0f 97 c0             	seta   %al
  801b55:	0f b6 c0             	movzbl %al,%eax
  801b58:	29 c1                	sub    %eax,%ecx
  801b5a:	89 c8                	mov    %ecx,%eax
  801b5c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801b5f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801b65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b6b:	72 b2                	jb     801b1f <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801b6d:	90                   	nop
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801b76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801b7d:	eb 03                	jmp    801b82 <busy_wait+0x12>
  801b7f:	ff 45 fc             	incl   -0x4(%ebp)
  801b82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b85:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b88:	72 f5                	jb     801b7f <busy_wait+0xf>
	return i;
  801b8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    
  801b8f:	90                   	nop

00801b90 <__udivdi3>:
  801b90:	55                   	push   %ebp
  801b91:	57                   	push   %edi
  801b92:	56                   	push   %esi
  801b93:	53                   	push   %ebx
  801b94:	83 ec 1c             	sub    $0x1c,%esp
  801b97:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b9b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ba3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ba7:	89 ca                	mov    %ecx,%edx
  801ba9:	89 f8                	mov    %edi,%eax
  801bab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801baf:	85 f6                	test   %esi,%esi
  801bb1:	75 2d                	jne    801be0 <__udivdi3+0x50>
  801bb3:	39 cf                	cmp    %ecx,%edi
  801bb5:	77 65                	ja     801c1c <__udivdi3+0x8c>
  801bb7:	89 fd                	mov    %edi,%ebp
  801bb9:	85 ff                	test   %edi,%edi
  801bbb:	75 0b                	jne    801bc8 <__udivdi3+0x38>
  801bbd:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc2:	31 d2                	xor    %edx,%edx
  801bc4:	f7 f7                	div    %edi
  801bc6:	89 c5                	mov    %eax,%ebp
  801bc8:	31 d2                	xor    %edx,%edx
  801bca:	89 c8                	mov    %ecx,%eax
  801bcc:	f7 f5                	div    %ebp
  801bce:	89 c1                	mov    %eax,%ecx
  801bd0:	89 d8                	mov    %ebx,%eax
  801bd2:	f7 f5                	div    %ebp
  801bd4:	89 cf                	mov    %ecx,%edi
  801bd6:	89 fa                	mov    %edi,%edx
  801bd8:	83 c4 1c             	add    $0x1c,%esp
  801bdb:	5b                   	pop    %ebx
  801bdc:	5e                   	pop    %esi
  801bdd:	5f                   	pop    %edi
  801bde:	5d                   	pop    %ebp
  801bdf:	c3                   	ret    
  801be0:	39 ce                	cmp    %ecx,%esi
  801be2:	77 28                	ja     801c0c <__udivdi3+0x7c>
  801be4:	0f bd fe             	bsr    %esi,%edi
  801be7:	83 f7 1f             	xor    $0x1f,%edi
  801bea:	75 40                	jne    801c2c <__udivdi3+0x9c>
  801bec:	39 ce                	cmp    %ecx,%esi
  801bee:	72 0a                	jb     801bfa <__udivdi3+0x6a>
  801bf0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bf4:	0f 87 9e 00 00 00    	ja     801c98 <__udivdi3+0x108>
  801bfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801bff:	89 fa                	mov    %edi,%edx
  801c01:	83 c4 1c             	add    $0x1c,%esp
  801c04:	5b                   	pop    %ebx
  801c05:	5e                   	pop    %esi
  801c06:	5f                   	pop    %edi
  801c07:	5d                   	pop    %ebp
  801c08:	c3                   	ret    
  801c09:	8d 76 00             	lea    0x0(%esi),%esi
  801c0c:	31 ff                	xor    %edi,%edi
  801c0e:	31 c0                	xor    %eax,%eax
  801c10:	89 fa                	mov    %edi,%edx
  801c12:	83 c4 1c             	add    $0x1c,%esp
  801c15:	5b                   	pop    %ebx
  801c16:	5e                   	pop    %esi
  801c17:	5f                   	pop    %edi
  801c18:	5d                   	pop    %ebp
  801c19:	c3                   	ret    
  801c1a:	66 90                	xchg   %ax,%ax
  801c1c:	89 d8                	mov    %ebx,%eax
  801c1e:	f7 f7                	div    %edi
  801c20:	31 ff                	xor    %edi,%edi
  801c22:	89 fa                	mov    %edi,%edx
  801c24:	83 c4 1c             	add    $0x1c,%esp
  801c27:	5b                   	pop    %ebx
  801c28:	5e                   	pop    %esi
  801c29:	5f                   	pop    %edi
  801c2a:	5d                   	pop    %ebp
  801c2b:	c3                   	ret    
  801c2c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c31:	89 eb                	mov    %ebp,%ebx
  801c33:	29 fb                	sub    %edi,%ebx
  801c35:	89 f9                	mov    %edi,%ecx
  801c37:	d3 e6                	shl    %cl,%esi
  801c39:	89 c5                	mov    %eax,%ebp
  801c3b:	88 d9                	mov    %bl,%cl
  801c3d:	d3 ed                	shr    %cl,%ebp
  801c3f:	89 e9                	mov    %ebp,%ecx
  801c41:	09 f1                	or     %esi,%ecx
  801c43:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c47:	89 f9                	mov    %edi,%ecx
  801c49:	d3 e0                	shl    %cl,%eax
  801c4b:	89 c5                	mov    %eax,%ebp
  801c4d:	89 d6                	mov    %edx,%esi
  801c4f:	88 d9                	mov    %bl,%cl
  801c51:	d3 ee                	shr    %cl,%esi
  801c53:	89 f9                	mov    %edi,%ecx
  801c55:	d3 e2                	shl    %cl,%edx
  801c57:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c5b:	88 d9                	mov    %bl,%cl
  801c5d:	d3 e8                	shr    %cl,%eax
  801c5f:	09 c2                	or     %eax,%edx
  801c61:	89 d0                	mov    %edx,%eax
  801c63:	89 f2                	mov    %esi,%edx
  801c65:	f7 74 24 0c          	divl   0xc(%esp)
  801c69:	89 d6                	mov    %edx,%esi
  801c6b:	89 c3                	mov    %eax,%ebx
  801c6d:	f7 e5                	mul    %ebp
  801c6f:	39 d6                	cmp    %edx,%esi
  801c71:	72 19                	jb     801c8c <__udivdi3+0xfc>
  801c73:	74 0b                	je     801c80 <__udivdi3+0xf0>
  801c75:	89 d8                	mov    %ebx,%eax
  801c77:	31 ff                	xor    %edi,%edi
  801c79:	e9 58 ff ff ff       	jmp    801bd6 <__udivdi3+0x46>
  801c7e:	66 90                	xchg   %ax,%ax
  801c80:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c84:	89 f9                	mov    %edi,%ecx
  801c86:	d3 e2                	shl    %cl,%edx
  801c88:	39 c2                	cmp    %eax,%edx
  801c8a:	73 e9                	jae    801c75 <__udivdi3+0xe5>
  801c8c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c8f:	31 ff                	xor    %edi,%edi
  801c91:	e9 40 ff ff ff       	jmp    801bd6 <__udivdi3+0x46>
  801c96:	66 90                	xchg   %ax,%ax
  801c98:	31 c0                	xor    %eax,%eax
  801c9a:	e9 37 ff ff ff       	jmp    801bd6 <__udivdi3+0x46>
  801c9f:	90                   	nop

00801ca0 <__umoddi3>:
  801ca0:	55                   	push   %ebp
  801ca1:	57                   	push   %edi
  801ca2:	56                   	push   %esi
  801ca3:	53                   	push   %ebx
  801ca4:	83 ec 1c             	sub    $0x1c,%esp
  801ca7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cab:	8b 74 24 34          	mov    0x34(%esp),%esi
  801caf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cb3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cbb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cbf:	89 f3                	mov    %esi,%ebx
  801cc1:	89 fa                	mov    %edi,%edx
  801cc3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cc7:	89 34 24             	mov    %esi,(%esp)
  801cca:	85 c0                	test   %eax,%eax
  801ccc:	75 1a                	jne    801ce8 <__umoddi3+0x48>
  801cce:	39 f7                	cmp    %esi,%edi
  801cd0:	0f 86 a2 00 00 00    	jbe    801d78 <__umoddi3+0xd8>
  801cd6:	89 c8                	mov    %ecx,%eax
  801cd8:	89 f2                	mov    %esi,%edx
  801cda:	f7 f7                	div    %edi
  801cdc:	89 d0                	mov    %edx,%eax
  801cde:	31 d2                	xor    %edx,%edx
  801ce0:	83 c4 1c             	add    $0x1c,%esp
  801ce3:	5b                   	pop    %ebx
  801ce4:	5e                   	pop    %esi
  801ce5:	5f                   	pop    %edi
  801ce6:	5d                   	pop    %ebp
  801ce7:	c3                   	ret    
  801ce8:	39 f0                	cmp    %esi,%eax
  801cea:	0f 87 ac 00 00 00    	ja     801d9c <__umoddi3+0xfc>
  801cf0:	0f bd e8             	bsr    %eax,%ebp
  801cf3:	83 f5 1f             	xor    $0x1f,%ebp
  801cf6:	0f 84 ac 00 00 00    	je     801da8 <__umoddi3+0x108>
  801cfc:	bf 20 00 00 00       	mov    $0x20,%edi
  801d01:	29 ef                	sub    %ebp,%edi
  801d03:	89 fe                	mov    %edi,%esi
  801d05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d09:	89 e9                	mov    %ebp,%ecx
  801d0b:	d3 e0                	shl    %cl,%eax
  801d0d:	89 d7                	mov    %edx,%edi
  801d0f:	89 f1                	mov    %esi,%ecx
  801d11:	d3 ef                	shr    %cl,%edi
  801d13:	09 c7                	or     %eax,%edi
  801d15:	89 e9                	mov    %ebp,%ecx
  801d17:	d3 e2                	shl    %cl,%edx
  801d19:	89 14 24             	mov    %edx,(%esp)
  801d1c:	89 d8                	mov    %ebx,%eax
  801d1e:	d3 e0                	shl    %cl,%eax
  801d20:	89 c2                	mov    %eax,%edx
  801d22:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d26:	d3 e0                	shl    %cl,%eax
  801d28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d2c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d30:	89 f1                	mov    %esi,%ecx
  801d32:	d3 e8                	shr    %cl,%eax
  801d34:	09 d0                	or     %edx,%eax
  801d36:	d3 eb                	shr    %cl,%ebx
  801d38:	89 da                	mov    %ebx,%edx
  801d3a:	f7 f7                	div    %edi
  801d3c:	89 d3                	mov    %edx,%ebx
  801d3e:	f7 24 24             	mull   (%esp)
  801d41:	89 c6                	mov    %eax,%esi
  801d43:	89 d1                	mov    %edx,%ecx
  801d45:	39 d3                	cmp    %edx,%ebx
  801d47:	0f 82 87 00 00 00    	jb     801dd4 <__umoddi3+0x134>
  801d4d:	0f 84 91 00 00 00    	je     801de4 <__umoddi3+0x144>
  801d53:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d57:	29 f2                	sub    %esi,%edx
  801d59:	19 cb                	sbb    %ecx,%ebx
  801d5b:	89 d8                	mov    %ebx,%eax
  801d5d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d61:	d3 e0                	shl    %cl,%eax
  801d63:	89 e9                	mov    %ebp,%ecx
  801d65:	d3 ea                	shr    %cl,%edx
  801d67:	09 d0                	or     %edx,%eax
  801d69:	89 e9                	mov    %ebp,%ecx
  801d6b:	d3 eb                	shr    %cl,%ebx
  801d6d:	89 da                	mov    %ebx,%edx
  801d6f:	83 c4 1c             	add    $0x1c,%esp
  801d72:	5b                   	pop    %ebx
  801d73:	5e                   	pop    %esi
  801d74:	5f                   	pop    %edi
  801d75:	5d                   	pop    %ebp
  801d76:	c3                   	ret    
  801d77:	90                   	nop
  801d78:	89 fd                	mov    %edi,%ebp
  801d7a:	85 ff                	test   %edi,%edi
  801d7c:	75 0b                	jne    801d89 <__umoddi3+0xe9>
  801d7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d83:	31 d2                	xor    %edx,%edx
  801d85:	f7 f7                	div    %edi
  801d87:	89 c5                	mov    %eax,%ebp
  801d89:	89 f0                	mov    %esi,%eax
  801d8b:	31 d2                	xor    %edx,%edx
  801d8d:	f7 f5                	div    %ebp
  801d8f:	89 c8                	mov    %ecx,%eax
  801d91:	f7 f5                	div    %ebp
  801d93:	89 d0                	mov    %edx,%eax
  801d95:	e9 44 ff ff ff       	jmp    801cde <__umoddi3+0x3e>
  801d9a:	66 90                	xchg   %ax,%ax
  801d9c:	89 c8                	mov    %ecx,%eax
  801d9e:	89 f2                	mov    %esi,%edx
  801da0:	83 c4 1c             	add    $0x1c,%esp
  801da3:	5b                   	pop    %ebx
  801da4:	5e                   	pop    %esi
  801da5:	5f                   	pop    %edi
  801da6:	5d                   	pop    %ebp
  801da7:	c3                   	ret    
  801da8:	3b 04 24             	cmp    (%esp),%eax
  801dab:	72 06                	jb     801db3 <__umoddi3+0x113>
  801dad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801db1:	77 0f                	ja     801dc2 <__umoddi3+0x122>
  801db3:	89 f2                	mov    %esi,%edx
  801db5:	29 f9                	sub    %edi,%ecx
  801db7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801dbb:	89 14 24             	mov    %edx,(%esp)
  801dbe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dc2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dc6:	8b 14 24             	mov    (%esp),%edx
  801dc9:	83 c4 1c             	add    $0x1c,%esp
  801dcc:	5b                   	pop    %ebx
  801dcd:	5e                   	pop    %esi
  801dce:	5f                   	pop    %edi
  801dcf:	5d                   	pop    %ebp
  801dd0:	c3                   	ret    
  801dd1:	8d 76 00             	lea    0x0(%esi),%esi
  801dd4:	2b 04 24             	sub    (%esp),%eax
  801dd7:	19 fa                	sbb    %edi,%edx
  801dd9:	89 d1                	mov    %edx,%ecx
  801ddb:	89 c6                	mov    %eax,%esi
  801ddd:	e9 71 ff ff ff       	jmp    801d53 <__umoddi3+0xb3>
  801de2:	66 90                	xchg   %ax,%ax
  801de4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801de8:	72 ea                	jb     801dd4 <__umoddi3+0x134>
  801dea:	89 d9                	mov    %ebx,%ecx
  801dec:	e9 62 ff ff ff       	jmp    801d53 <__umoddi3+0xb3>
