
obj/user/tst_chan_one_slave:     file format elf32-i386


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
  800031:	e8 a6 01 00 00       	call   8001dc <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
extern volatile bool printStats ;

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
	int envID = sys_getenvid();
  800044:	e8 e5 17 00 00       	call   80182e <sys_getenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Sleep on the channel
	char cmd0[64] = "__Sleep__";
  80004c:	8d 45 98             	lea    -0x68(%ebp),%eax
  80004f:	bb c1 1e 80 00       	mov    $0x801ec1,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800061:	8d 55 a2             	lea    -0x5e(%ebp),%edx
  800064:	b9 36 00 00 00       	mov    $0x36,%ecx
  800069:	b0 00                	mov    $0x0,%al
  80006b:	89 d7                	mov    %edx,%edi
  80006d:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd0, 0);
  80006f:	83 ec 08             	sub    $0x8,%esp
  800072:	6a 00                	push   $0x0
  800074:	8d 45 98             	lea    -0x68(%ebp),%eax
  800077:	50                   	push   %eax
  800078:	e8 00 1a 00 00       	call   801a7d <sys_utilities>
  80007d:	83 c4 10             	add    $0x10,%esp

	//wait for a while
	env_sleep(RAND(1000, 5000));
  800080:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	50                   	push   %eax
  800087:	e8 07 18 00 00       	call   801893 <sys_get_virtual_time>
  80008c:	83 c4 0c             	add    $0xc,%esp
  80008f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800092:	b9 a0 0f 00 00       	mov    $0xfa0,%ecx
  800097:	ba 00 00 00 00       	mov    $0x0,%edx
  80009c:	f7 f1                	div    %ecx
  80009e:	89 d0                	mov    %edx,%eax
  8000a0:	05 e8 03 00 00       	add    $0x3e8,%eax
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	50                   	push   %eax
  8000a9:	e8 5c 1a 00 00       	call   801b0a <env_sleep>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//Validate the number of blocked processes till now
	int numOfBlockedProcesses = 0;
  8000b1:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
	char cmd1[64] = "__GetChanQueueSize__";
  8000b8:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8000be:	bb 01 1f 80 00       	mov    $0x801f01,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000d0:	8d 95 69 ff ff ff    	lea    -0x97(%ebp),%edx
  8000d6:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  8000db:	b0 00                	mov    $0x0,%al
  8000dd:	89 d7                	mov    %edx,%edi
  8000df:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd1, (uint32)(&numOfBlockedProcesses));
  8000e1:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000e4:	83 ec 08             	sub    $0x8,%esp
  8000e7:	50                   	push   %eax
  8000e8:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8000ee:	50                   	push   %eax
  8000ef:	e8 89 19 00 00       	call   801a7d <sys_utilities>
  8000f4:	83 c4 10             	add    $0x10,%esp
	int numOfWakenupProcesses = gettst() ;
  8000f7:	e8 a3 18 00 00       	call   80199f <gettst>
  8000fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int numOfSlaves = 0;
  8000ff:	c7 85 50 ff ff ff 00 	movl   $0x0,-0xb0(%ebp)
  800106:	00 00 00 
	char cmd2[64] = "__NumOfSlaves@Get";
  800109:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
  80010f:	bb 41 1f 80 00       	mov    $0x801f41,%ebx
  800114:	ba 12 00 00 00       	mov    $0x12,%edx
  800119:	89 c7                	mov    %eax,%edi
  80011b:	89 de                	mov    %ebx,%esi
  80011d:	89 d1                	mov    %edx,%ecx
  80011f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800121:	8d 95 22 ff ff ff    	lea    -0xde(%ebp),%edx
  800127:	b9 2e 00 00 00       	mov    $0x2e,%ecx
  80012c:	b0 00                	mov    $0x0,%al
  80012e:	89 d7                	mov    %edx,%edi
  800130:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd2, (uint32)(&numOfSlaves));
  800132:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	50                   	push   %eax
  80013c:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
  800142:	50                   	push   %eax
  800143:	e8 35 19 00 00       	call   801a7d <sys_utilities>
  800148:	83 c4 10             	add    $0x10,%esp

	if (numOfWakenupProcesses + numOfBlockedProcesses != numOfSlaves - 1 /*Except this process since it not indicating wakeup yet*/)
  80014b:	8b 55 94             	mov    -0x6c(%ebp),%edx
  80014e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800151:	01 c2                	add    %eax,%edx
  800153:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800159:	48                   	dec    %eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
	{
		panic("%~test channels failed! inconsistent number of blocked & waken-up processes.");
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 40 1e 80 00       	push   $0x801e40
  800166:	6a 1d                	push   $0x1d
  800168:	68 8d 1e 80 00       	push   $0x801e8d
  80016d:	e8 1a 02 00 00       	call   80038c <_panic>
	}

	//indicates wakenup
	inctst();
  800172:	e8 0e 18 00 00       	call   801985 <inctst>

	//wakeup another one
	char cmd3[64] = "__WakeupOne__";
  800177:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80017d:	bb 81 1f 80 00       	mov    $0x801f81,%ebx
  800182:	ba 0e 00 00 00       	mov    $0xe,%edx
  800187:	89 c7                	mov    %eax,%edi
  800189:	89 de                	mov    %ebx,%esi
  80018b:	89 d1                	mov    %edx,%ecx
  80018d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80018f:	8d 95 de fe ff ff    	lea    -0x122(%ebp),%edx
  800195:	b9 32 00 00 00       	mov    $0x32,%ecx
  80019a:	b0 00                	mov    $0x0,%al
  80019c:	89 d7                	mov    %edx,%edi
  80019e:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd3, 0);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	6a 00                	push   $0x0
  8001a5:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  8001ab:	50                   	push   %eax
  8001ac:	e8 cc 18 00 00       	call   801a7d <sys_utilities>
  8001b1:	83 c4 10             	add    $0x10,%esp

	cprintf_colored(TEXT_light_magenta, ">>> Slave %d is Finished\n", envID);
  8001b4:	83 ec 04             	sub    $0x4,%esp
  8001b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ba:	68 a7 1e 80 00       	push   $0x801ea7
  8001bf:	6a 0d                	push   $0xd
  8001c1:	e8 e1 04 00 00       	call   8006a7 <cprintf_colored>
  8001c6:	83 c4 10             	add    $0x10,%esp
	printStats = 0;
  8001c9:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  8001d0:	00 00 00 
	return;
  8001d3:	90                   	nop
}
  8001d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d7:	5b                   	pop    %ebx
  8001d8:	5e                   	pop    %esi
  8001d9:	5f                   	pop    %edi
  8001da:	5d                   	pop    %ebp
  8001db:	c3                   	ret    

008001dc <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	57                   	push   %edi
  8001e0:	56                   	push   %esi
  8001e1:	53                   	push   %ebx
  8001e2:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001e5:	e8 5d 16 00 00       	call   801847 <sys_getenvindex>
  8001ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001f0:	89 d0                	mov    %edx,%eax
  8001f2:	01 c0                	add    %eax,%eax
  8001f4:	01 d0                	add    %edx,%eax
  8001f6:	c1 e0 02             	shl    $0x2,%eax
  8001f9:	01 d0                	add    %edx,%eax
  8001fb:	c1 e0 02             	shl    $0x2,%eax
  8001fe:	01 d0                	add    %edx,%eax
  800200:	c1 e0 03             	shl    $0x3,%eax
  800203:	01 d0                	add    %edx,%eax
  800205:	c1 e0 02             	shl    $0x2,%eax
  800208:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80020d:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800212:	a1 20 30 80 00       	mov    0x803020,%eax
  800217:	8a 40 20             	mov    0x20(%eax),%al
  80021a:	84 c0                	test   %al,%al
  80021c:	74 0d                	je     80022b <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80021e:	a1 20 30 80 00       	mov    0x803020,%eax
  800223:	83 c0 20             	add    $0x20,%eax
  800226:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80022b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80022f:	7e 0a                	jle    80023b <libmain+0x5f>
		binaryname = argv[0];
  800231:	8b 45 0c             	mov    0xc(%ebp),%eax
  800234:	8b 00                	mov    (%eax),%eax
  800236:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	ff 75 0c             	pushl  0xc(%ebp)
  800241:	ff 75 08             	pushl  0x8(%ebp)
  800244:	e8 ef fd ff ff       	call   800038 <_main>
  800249:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80024c:	a1 00 30 80 00       	mov    0x803000,%eax
  800251:	85 c0                	test   %eax,%eax
  800253:	0f 84 01 01 00 00    	je     80035a <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800259:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80025f:	bb bc 20 80 00       	mov    $0x8020bc,%ebx
  800264:	ba 0e 00 00 00       	mov    $0xe,%edx
  800269:	89 c7                	mov    %eax,%edi
  80026b:	89 de                	mov    %ebx,%esi
  80026d:	89 d1                	mov    %edx,%ecx
  80026f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800271:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800274:	b9 56 00 00 00       	mov    $0x56,%ecx
  800279:	b0 00                	mov    $0x0,%al
  80027b:	89 d7                	mov    %edx,%edi
  80027d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80027f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800286:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800289:	83 ec 08             	sub    $0x8,%esp
  80028c:	50                   	push   %eax
  80028d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	e8 e4 17 00 00       	call   801a7d <sys_utilities>
  800299:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80029c:	e8 2d 13 00 00       	call   8015ce <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 dc 1f 80 00       	push   $0x801fdc
  8002a9:	e8 cc 03 00 00       	call   80067a <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8002b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b4:	85 c0                	test   %eax,%eax
  8002b6:	74 18                	je     8002d0 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8002b8:	e8 de 17 00 00       	call   801a9b <sys_get_optimal_num_faults>
  8002bd:	83 ec 08             	sub    $0x8,%esp
  8002c0:	50                   	push   %eax
  8002c1:	68 04 20 80 00       	push   $0x802004
  8002c6:	e8 af 03 00 00       	call   80067a <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	eb 59                	jmp    800329 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d5:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8002db:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e0:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	52                   	push   %edx
  8002ea:	50                   	push   %eax
  8002eb:	68 28 20 80 00       	push   $0x802028
  8002f0:	e8 85 03 00 00       	call   80067a <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002fd:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800303:	a1 20 30 80 00       	mov    0x803020,%eax
  800308:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80030e:	a1 20 30 80 00       	mov    0x803020,%eax
  800313:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800319:	51                   	push   %ecx
  80031a:	52                   	push   %edx
  80031b:	50                   	push   %eax
  80031c:	68 50 20 80 00       	push   $0x802050
  800321:	e8 54 03 00 00       	call   80067a <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800329:	a1 20 30 80 00       	mov    0x803020,%eax
  80032e:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	50                   	push   %eax
  800338:	68 a8 20 80 00       	push   $0x8020a8
  80033d:	e8 38 03 00 00       	call   80067a <cprintf>
  800342:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 dc 1f 80 00       	push   $0x801fdc
  80034d:	e8 28 03 00 00       	call   80067a <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800355:	e8 8e 12 00 00       	call   8015e8 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80035a:	e8 1f 00 00 00       	call   80037e <exit>
}
  80035f:	90                   	nop
  800360:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800363:	5b                   	pop    %ebx
  800364:	5e                   	pop    %esi
  800365:	5f                   	pop    %edi
  800366:	5d                   	pop    %ebp
  800367:	c3                   	ret    

00800368 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80036e:	83 ec 0c             	sub    $0xc,%esp
  800371:	6a 00                	push   $0x0
  800373:	e8 9b 14 00 00       	call   801813 <sys_destroy_env>
  800378:	83 c4 10             	add    $0x10,%esp
}
  80037b:	90                   	nop
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <exit>:

void
exit(void)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800384:	e8 f0 14 00 00       	call   801879 <sys_exit_env>
}
  800389:	90                   	nop
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800392:	8d 45 10             	lea    0x10(%ebp),%eax
  800395:	83 c0 04             	add    $0x4,%eax
  800398:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80039b:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003a0:	85 c0                	test   %eax,%eax
  8003a2:	74 16                	je     8003ba <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003a4:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003a9:	83 ec 08             	sub    $0x8,%esp
  8003ac:	50                   	push   %eax
  8003ad:	68 20 21 80 00       	push   $0x802120
  8003b2:	e8 c3 02 00 00       	call   80067a <cprintf>
  8003b7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8003ba:	a1 04 30 80 00       	mov    0x803004,%eax
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	ff 75 0c             	pushl  0xc(%ebp)
  8003c5:	ff 75 08             	pushl  0x8(%ebp)
  8003c8:	50                   	push   %eax
  8003c9:	68 28 21 80 00       	push   $0x802128
  8003ce:	6a 74                	push   $0x74
  8003d0:	e8 d2 02 00 00       	call   8006a7 <cprintf_colored>
  8003d5:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8003d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003db:	83 ec 08             	sub    $0x8,%esp
  8003de:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e1:	50                   	push   %eax
  8003e2:	e8 24 02 00 00       	call   80060b <vcprintf>
  8003e7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003ea:	83 ec 08             	sub    $0x8,%esp
  8003ed:	6a 00                	push   $0x0
  8003ef:	68 50 21 80 00       	push   $0x802150
  8003f4:	e8 12 02 00 00       	call   80060b <vcprintf>
  8003f9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003fc:	e8 7d ff ff ff       	call   80037e <exit>

	// should not return here
	while (1) ;
  800401:	eb fe                	jmp    800401 <_panic+0x75>

00800403 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	53                   	push   %ebx
  800407:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80040a:	a1 20 30 80 00       	mov    0x803020,%eax
  80040f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800415:	8b 45 0c             	mov    0xc(%ebp),%eax
  800418:	39 c2                	cmp    %eax,%edx
  80041a:	74 14                	je     800430 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80041c:	83 ec 04             	sub    $0x4,%esp
  80041f:	68 54 21 80 00       	push   $0x802154
  800424:	6a 26                	push   $0x26
  800426:	68 a0 21 80 00       	push   $0x8021a0
  80042b:	e8 5c ff ff ff       	call   80038c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800430:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800437:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80043e:	e9 d9 00 00 00       	jmp    80051c <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800446:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	01 d0                	add    %edx,%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	85 c0                	test   %eax,%eax
  800456:	75 08                	jne    800460 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800458:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80045b:	e9 b9 00 00 00       	jmp    800519 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800460:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800467:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80046e:	eb 79                	jmp    8004e9 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800470:	a1 20 30 80 00       	mov    0x803020,%eax
  800475:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80047b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80047e:	89 d0                	mov    %edx,%eax
  800480:	01 c0                	add    %eax,%eax
  800482:	01 d0                	add    %edx,%eax
  800484:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80048b:	01 d8                	add    %ebx,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	01 c8                	add    %ecx,%eax
  800491:	8a 40 04             	mov    0x4(%eax),%al
  800494:	84 c0                	test   %al,%al
  800496:	75 4e                	jne    8004e6 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800498:	a1 20 30 80 00       	mov    0x803020,%eax
  80049d:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8004a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a6:	89 d0                	mov    %edx,%eax
  8004a8:	01 c0                	add    %eax,%eax
  8004aa:	01 d0                	add    %edx,%eax
  8004ac:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004b3:	01 d8                	add    %ebx,%eax
  8004b5:	01 d0                	add    %edx,%eax
  8004b7:	01 c8                	add    %ecx,%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004c6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004cb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d5:	01 c8                	add    %ecx,%eax
  8004d7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004d9:	39 c2                	cmp    %eax,%edx
  8004db:	75 09                	jne    8004e6 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8004dd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004e4:	eb 19                	jmp    8004ff <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e6:	ff 45 e8             	incl   -0x18(%ebp)
  8004e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ee:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004f7:	39 c2                	cmp    %eax,%edx
  8004f9:	0f 87 71 ff ff ff    	ja     800470 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800503:	75 14                	jne    800519 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800505:	83 ec 04             	sub    $0x4,%esp
  800508:	68 ac 21 80 00       	push   $0x8021ac
  80050d:	6a 3a                	push   $0x3a
  80050f:	68 a0 21 80 00       	push   $0x8021a0
  800514:	e8 73 fe ff ff       	call   80038c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800519:	ff 45 f0             	incl   -0x10(%ebp)
  80051c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800522:	0f 8c 1b ff ff ff    	jl     800443 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800528:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800536:	eb 2e                	jmp    800566 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800538:	a1 20 30 80 00       	mov    0x803020,%eax
  80053d:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800543:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800546:	89 d0                	mov    %edx,%eax
  800548:	01 c0                	add    %eax,%eax
  80054a:	01 d0                	add    %edx,%eax
  80054c:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800553:	01 d8                	add    %ebx,%eax
  800555:	01 d0                	add    %edx,%eax
  800557:	01 c8                	add    %ecx,%eax
  800559:	8a 40 04             	mov    0x4(%eax),%al
  80055c:	3c 01                	cmp    $0x1,%al
  80055e:	75 03                	jne    800563 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800560:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800563:	ff 45 e0             	incl   -0x20(%ebp)
  800566:	a1 20 30 80 00       	mov    0x803020,%eax
  80056b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800571:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800574:	39 c2                	cmp    %eax,%edx
  800576:	77 c0                	ja     800538 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80057e:	74 14                	je     800594 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 00 22 80 00       	push   $0x802200
  800588:	6a 44                	push   $0x44
  80058a:	68 a0 21 80 00       	push   $0x8021a0
  80058f:	e8 f8 fd ff ff       	call   80038c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800594:	90                   	nop
  800595:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800598:	c9                   	leave  
  800599:	c3                   	ret    

0080059a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80059a:	55                   	push   %ebp
  80059b:	89 e5                	mov    %esp,%ebp
  80059d:	53                   	push   %ebx
  80059e:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	8d 48 01             	lea    0x1(%eax),%ecx
  8005a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ac:	89 0a                	mov    %ecx,(%edx)
  8005ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8005b1:	88 d1                	mov    %dl,%cl
  8005b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005c4:	75 30                	jne    8005f6 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8005c6:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8005cc:	a0 44 30 80 00       	mov    0x803044,%al
  8005d1:	0f b6 c0             	movzbl %al,%eax
  8005d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005d7:	8b 09                	mov    (%ecx),%ecx
  8005d9:	89 cb                	mov    %ecx,%ebx
  8005db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005de:	83 c1 08             	add    $0x8,%ecx
  8005e1:	52                   	push   %edx
  8005e2:	50                   	push   %eax
  8005e3:	53                   	push   %ebx
  8005e4:	51                   	push   %ecx
  8005e5:	e8 a0 0f 00 00       	call   80158a <sys_cputs>
  8005ea:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f9:	8b 40 04             	mov    0x4(%eax),%eax
  8005fc:	8d 50 01             	lea    0x1(%eax),%edx
  8005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800602:	89 50 04             	mov    %edx,0x4(%eax)
}
  800605:	90                   	nop
  800606:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800609:	c9                   	leave  
  80060a:	c3                   	ret    

0080060b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80060b:	55                   	push   %ebp
  80060c:	89 e5                	mov    %esp,%ebp
  80060e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800614:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80061b:	00 00 00 
	b.cnt = 0;
  80061e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800625:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800628:	ff 75 0c             	pushl  0xc(%ebp)
  80062b:	ff 75 08             	pushl  0x8(%ebp)
  80062e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800634:	50                   	push   %eax
  800635:	68 9a 05 80 00       	push   $0x80059a
  80063a:	e8 5a 02 00 00       	call   800899 <vprintfmt>
  80063f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800642:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800648:	a0 44 30 80 00       	mov    0x803044,%al
  80064d:	0f b6 c0             	movzbl %al,%eax
  800650:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800656:	52                   	push   %edx
  800657:	50                   	push   %eax
  800658:	51                   	push   %ecx
  800659:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80065f:	83 c0 08             	add    $0x8,%eax
  800662:	50                   	push   %eax
  800663:	e8 22 0f 00 00       	call   80158a <sys_cputs>
  800668:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80066b:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800672:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800678:	c9                   	leave  
  800679:	c3                   	ret    

0080067a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
  80067d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800680:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800687:	8d 45 0c             	lea    0xc(%ebp),%eax
  80068a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80068d:	8b 45 08             	mov    0x8(%ebp),%eax
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	ff 75 f4             	pushl  -0xc(%ebp)
  800696:	50                   	push   %eax
  800697:	e8 6f ff ff ff       	call   80060b <vcprintf>
  80069c:	83 c4 10             	add    $0x10,%esp
  80069f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006a5:	c9                   	leave  
  8006a6:	c3                   	ret    

008006a7 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8006a7:	55                   	push   %ebp
  8006a8:	89 e5                	mov    %esp,%ebp
  8006aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ad:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	c1 e0 08             	shl    $0x8,%eax
  8006ba:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8006bf:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006c2:	83 c0 04             	add    $0x4,%eax
  8006c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d1:	50                   	push   %eax
  8006d2:	e8 34 ff ff ff       	call   80060b <vcprintf>
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8006dd:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8006e4:	07 00 00 

	return cnt;
  8006e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ea:	c9                   	leave  
  8006eb:	c3                   	ret    

008006ec <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
  8006ef:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006f2:	e8 d7 0e 00 00       	call   8015ce <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006f7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	ff 75 f4             	pushl  -0xc(%ebp)
  800706:	50                   	push   %eax
  800707:	e8 ff fe ff ff       	call   80060b <vcprintf>
  80070c:	83 c4 10             	add    $0x10,%esp
  80070f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800712:	e8 d1 0e 00 00       	call   8015e8 <sys_unlock_cons>
	return cnt;
  800717:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80071a:	c9                   	leave  
  80071b:	c3                   	ret    

0080071c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80071c:	55                   	push   %ebp
  80071d:	89 e5                	mov    %esp,%ebp
  80071f:	53                   	push   %ebx
  800720:	83 ec 14             	sub    $0x14,%esp
  800723:	8b 45 10             	mov    0x10(%ebp),%eax
  800726:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80072f:	8b 45 18             	mov    0x18(%ebp),%eax
  800732:	ba 00 00 00 00       	mov    $0x0,%edx
  800737:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80073a:	77 55                	ja     800791 <printnum+0x75>
  80073c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80073f:	72 05                	jb     800746 <printnum+0x2a>
  800741:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800744:	77 4b                	ja     800791 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800746:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800749:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80074c:	8b 45 18             	mov    0x18(%ebp),%eax
  80074f:	ba 00 00 00 00       	mov    $0x0,%edx
  800754:	52                   	push   %edx
  800755:	50                   	push   %eax
  800756:	ff 75 f4             	pushl  -0xc(%ebp)
  800759:	ff 75 f0             	pushl  -0x10(%ebp)
  80075c:	e8 67 14 00 00       	call   801bc8 <__udivdi3>
  800761:	83 c4 10             	add    $0x10,%esp
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	ff 75 20             	pushl  0x20(%ebp)
  80076a:	53                   	push   %ebx
  80076b:	ff 75 18             	pushl  0x18(%ebp)
  80076e:	52                   	push   %edx
  80076f:	50                   	push   %eax
  800770:	ff 75 0c             	pushl  0xc(%ebp)
  800773:	ff 75 08             	pushl  0x8(%ebp)
  800776:	e8 a1 ff ff ff       	call   80071c <printnum>
  80077b:	83 c4 20             	add    $0x20,%esp
  80077e:	eb 1a                	jmp    80079a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	ff 75 0c             	pushl  0xc(%ebp)
  800786:	ff 75 20             	pushl  0x20(%ebp)
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	ff d0                	call   *%eax
  80078e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800791:	ff 4d 1c             	decl   0x1c(%ebp)
  800794:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800798:	7f e6                	jg     800780 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80079a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80079d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a8:	53                   	push   %ebx
  8007a9:	51                   	push   %ecx
  8007aa:	52                   	push   %edx
  8007ab:	50                   	push   %eax
  8007ac:	e8 27 15 00 00       	call   801cd8 <__umoddi3>
  8007b1:	83 c4 10             	add    $0x10,%esp
  8007b4:	05 74 24 80 00       	add    $0x802474,%eax
  8007b9:	8a 00                	mov    (%eax),%al
  8007bb:	0f be c0             	movsbl %al,%eax
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	ff 75 0c             	pushl  0xc(%ebp)
  8007c4:	50                   	push   %eax
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	ff d0                	call   *%eax
  8007ca:	83 c4 10             	add    $0x10,%esp
}
  8007cd:	90                   	nop
  8007ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007da:	7e 1c                	jle    8007f8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	8d 50 08             	lea    0x8(%eax),%edx
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	89 10                	mov    %edx,(%eax)
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	83 e8 08             	sub    $0x8,%eax
  8007f1:	8b 50 04             	mov    0x4(%eax),%edx
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	eb 40                	jmp    800838 <getuint+0x65>
	else if (lflag)
  8007f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007fc:	74 1e                	je     80081c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	8b 00                	mov    (%eax),%eax
  800803:	8d 50 04             	lea    0x4(%eax),%edx
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	89 10                	mov    %edx,(%eax)
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	8b 00                	mov    (%eax),%eax
  800810:	83 e8 04             	sub    $0x4,%eax
  800813:	8b 00                	mov    (%eax),%eax
  800815:	ba 00 00 00 00       	mov    $0x0,%edx
  80081a:	eb 1c                	jmp    800838 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	8d 50 04             	lea    0x4(%eax),%edx
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	89 10                	mov    %edx,(%eax)
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	83 e8 04             	sub    $0x4,%eax
  800831:	8b 00                	mov    (%eax),%eax
  800833:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800838:	5d                   	pop    %ebp
  800839:	c3                   	ret    

0080083a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80083d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800841:	7e 1c                	jle    80085f <getint+0x25>
		return va_arg(*ap, long long);
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	8b 00                	mov    (%eax),%eax
  800848:	8d 50 08             	lea    0x8(%eax),%edx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	89 10                	mov    %edx,(%eax)
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	83 e8 08             	sub    $0x8,%eax
  800858:	8b 50 04             	mov    0x4(%eax),%edx
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	eb 38                	jmp    800897 <getint+0x5d>
	else if (lflag)
  80085f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800863:	74 1a                	je     80087f <getint+0x45>
		return va_arg(*ap, long);
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	8d 50 04             	lea    0x4(%eax),%edx
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	89 10                	mov    %edx,(%eax)
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	8b 00                	mov    (%eax),%eax
  800877:	83 e8 04             	sub    $0x4,%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	99                   	cltd   
  80087d:	eb 18                	jmp    800897 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	8b 00                	mov    (%eax),%eax
  800884:	8d 50 04             	lea    0x4(%eax),%edx
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	89 10                	mov    %edx,(%eax)
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	83 e8 04             	sub    $0x4,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	99                   	cltd   
}
  800897:	5d                   	pop    %ebp
  800898:	c3                   	ret    

00800899 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	56                   	push   %esi
  80089d:	53                   	push   %ebx
  80089e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a1:	eb 17                	jmp    8008ba <vprintfmt+0x21>
			if (ch == '\0')
  8008a3:	85 db                	test   %ebx,%ebx
  8008a5:	0f 84 c1 03 00 00    	je     800c6c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008ab:	83 ec 08             	sub    $0x8,%esp
  8008ae:	ff 75 0c             	pushl  0xc(%ebp)
  8008b1:	53                   	push   %ebx
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	ff d0                	call   *%eax
  8008b7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bd:	8d 50 01             	lea    0x1(%eax),%edx
  8008c0:	89 55 10             	mov    %edx,0x10(%ebp)
  8008c3:	8a 00                	mov    (%eax),%al
  8008c5:	0f b6 d8             	movzbl %al,%ebx
  8008c8:	83 fb 25             	cmp    $0x25,%ebx
  8008cb:	75 d6                	jne    8008a3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008cd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008d1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008d8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008df:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008e6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f0:	8d 50 01             	lea    0x1(%eax),%edx
  8008f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8008f6:	8a 00                	mov    (%eax),%al
  8008f8:	0f b6 d8             	movzbl %al,%ebx
  8008fb:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008fe:	83 f8 5b             	cmp    $0x5b,%eax
  800901:	0f 87 3d 03 00 00    	ja     800c44 <vprintfmt+0x3ab>
  800907:	8b 04 85 98 24 80 00 	mov    0x802498(,%eax,4),%eax
  80090e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800910:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800914:	eb d7                	jmp    8008ed <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800916:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80091a:	eb d1                	jmp    8008ed <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800923:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800926:	89 d0                	mov    %edx,%eax
  800928:	c1 e0 02             	shl    $0x2,%eax
  80092b:	01 d0                	add    %edx,%eax
  80092d:	01 c0                	add    %eax,%eax
  80092f:	01 d8                	add    %ebx,%eax
  800931:	83 e8 30             	sub    $0x30,%eax
  800934:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800937:	8b 45 10             	mov    0x10(%ebp),%eax
  80093a:	8a 00                	mov    (%eax),%al
  80093c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80093f:	83 fb 2f             	cmp    $0x2f,%ebx
  800942:	7e 3e                	jle    800982 <vprintfmt+0xe9>
  800944:	83 fb 39             	cmp    $0x39,%ebx
  800947:	7f 39                	jg     800982 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800949:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80094c:	eb d5                	jmp    800923 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	83 c0 04             	add    $0x4,%eax
  800954:	89 45 14             	mov    %eax,0x14(%ebp)
  800957:	8b 45 14             	mov    0x14(%ebp),%eax
  80095a:	83 e8 04             	sub    $0x4,%eax
  80095d:	8b 00                	mov    (%eax),%eax
  80095f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800962:	eb 1f                	jmp    800983 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800964:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800968:	79 83                	jns    8008ed <vprintfmt+0x54>
				width = 0;
  80096a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800971:	e9 77 ff ff ff       	jmp    8008ed <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800976:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80097d:	e9 6b ff ff ff       	jmp    8008ed <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800982:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800987:	0f 89 60 ff ff ff    	jns    8008ed <vprintfmt+0x54>
				width = precision, precision = -1;
  80098d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800990:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800993:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80099a:	e9 4e ff ff ff       	jmp    8008ed <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80099f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009a2:	e9 46 ff ff ff       	jmp    8008ed <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009aa:	83 c0 04             	add    $0x4,%eax
  8009ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b3:	83 e8 04             	sub    $0x4,%eax
  8009b6:	8b 00                	mov    (%eax),%eax
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	50                   	push   %eax
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	ff d0                	call   *%eax
  8009c4:	83 c4 10             	add    $0x10,%esp
			break;
  8009c7:	e9 9b 02 00 00       	jmp    800c67 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cf:	83 c0 04             	add    $0x4,%eax
  8009d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 e8 04             	sub    $0x4,%eax
  8009db:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009dd:	85 db                	test   %ebx,%ebx
  8009df:	79 02                	jns    8009e3 <vprintfmt+0x14a>
				err = -err;
  8009e1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009e3:	83 fb 64             	cmp    $0x64,%ebx
  8009e6:	7f 0b                	jg     8009f3 <vprintfmt+0x15a>
  8009e8:	8b 34 9d e0 22 80 00 	mov    0x8022e0(,%ebx,4),%esi
  8009ef:	85 f6                	test   %esi,%esi
  8009f1:	75 19                	jne    800a0c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009f3:	53                   	push   %ebx
  8009f4:	68 85 24 80 00       	push   $0x802485
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	ff 75 08             	pushl  0x8(%ebp)
  8009ff:	e8 70 02 00 00       	call   800c74 <printfmt>
  800a04:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a07:	e9 5b 02 00 00       	jmp    800c67 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a0c:	56                   	push   %esi
  800a0d:	68 8e 24 80 00       	push   $0x80248e
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	ff 75 08             	pushl  0x8(%ebp)
  800a18:	e8 57 02 00 00       	call   800c74 <printfmt>
  800a1d:	83 c4 10             	add    $0x10,%esp
			break;
  800a20:	e9 42 02 00 00       	jmp    800c67 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 30                	mov    (%eax),%esi
  800a36:	85 f6                	test   %esi,%esi
  800a38:	75 05                	jne    800a3f <vprintfmt+0x1a6>
				p = "(null)";
  800a3a:	be 91 24 80 00       	mov    $0x802491,%esi
			if (width > 0 && padc != '-')
  800a3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a43:	7e 6d                	jle    800ab2 <vprintfmt+0x219>
  800a45:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a49:	74 67                	je     800ab2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	50                   	push   %eax
  800a52:	56                   	push   %esi
  800a53:	e8 1e 03 00 00       	call   800d76 <strnlen>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a5e:	eb 16                	jmp    800a76 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a60:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	50                   	push   %eax
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a73:	ff 4d e4             	decl   -0x1c(%ebp)
  800a76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7a:	7f e4                	jg     800a60 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a7c:	eb 34                	jmp    800ab2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a7e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a82:	74 1c                	je     800aa0 <vprintfmt+0x207>
  800a84:	83 fb 1f             	cmp    $0x1f,%ebx
  800a87:	7e 05                	jle    800a8e <vprintfmt+0x1f5>
  800a89:	83 fb 7e             	cmp    $0x7e,%ebx
  800a8c:	7e 12                	jle    800aa0 <vprintfmt+0x207>
					putch('?', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 3f                	push   $0x3f
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
  800a9e:	eb 0f                	jmp    800aaf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 0c             	pushl  0xc(%ebp)
  800aa6:	53                   	push   %ebx
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	ff d0                	call   *%eax
  800aac:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aaf:	ff 4d e4             	decl   -0x1c(%ebp)
  800ab2:	89 f0                	mov    %esi,%eax
  800ab4:	8d 70 01             	lea    0x1(%eax),%esi
  800ab7:	8a 00                	mov    (%eax),%al
  800ab9:	0f be d8             	movsbl %al,%ebx
  800abc:	85 db                	test   %ebx,%ebx
  800abe:	74 24                	je     800ae4 <vprintfmt+0x24b>
  800ac0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac4:	78 b8                	js     800a7e <vprintfmt+0x1e5>
  800ac6:	ff 4d e0             	decl   -0x20(%ebp)
  800ac9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800acd:	79 af                	jns    800a7e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800acf:	eb 13                	jmp    800ae4 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	6a 20                	push   $0x20
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	ff d0                	call   *%eax
  800ade:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ae1:	ff 4d e4             	decl   -0x1c(%ebp)
  800ae4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae8:	7f e7                	jg     800ad1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800aea:	e9 78 01 00 00       	jmp    800c67 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	ff 75 e8             	pushl  -0x18(%ebp)
  800af5:	8d 45 14             	lea    0x14(%ebp),%eax
  800af8:	50                   	push   %eax
  800af9:	e8 3c fd ff ff       	call   80083a <getint>
  800afe:	83 c4 10             	add    $0x10,%esp
  800b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b04:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b0d:	85 d2                	test   %edx,%edx
  800b0f:	79 23                	jns    800b34 <vprintfmt+0x29b>
				putch('-', putdat);
  800b11:	83 ec 08             	sub    $0x8,%esp
  800b14:	ff 75 0c             	pushl  0xc(%ebp)
  800b17:	6a 2d                	push   $0x2d
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	ff d0                	call   *%eax
  800b1e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b27:	f7 d8                	neg    %eax
  800b29:	83 d2 00             	adc    $0x0,%edx
  800b2c:	f7 da                	neg    %edx
  800b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b31:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b34:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b3b:	e9 bc 00 00 00       	jmp    800bfc <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 e8             	pushl  -0x18(%ebp)
  800b46:	8d 45 14             	lea    0x14(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	e8 84 fc ff ff       	call   8007d3 <getuint>
  800b4f:	83 c4 10             	add    $0x10,%esp
  800b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b58:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b5f:	e9 98 00 00 00       	jmp    800bfc <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b64:	83 ec 08             	sub    $0x8,%esp
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	6a 58                	push   $0x58
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	ff d0                	call   *%eax
  800b71:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b74:	83 ec 08             	sub    $0x8,%esp
  800b77:	ff 75 0c             	pushl  0xc(%ebp)
  800b7a:	6a 58                	push   $0x58
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	ff d0                	call   *%eax
  800b81:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	6a 58                	push   $0x58
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	ff d0                	call   *%eax
  800b91:	83 c4 10             	add    $0x10,%esp
			break;
  800b94:	e9 ce 00 00 00       	jmp    800c67 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b99:	83 ec 08             	sub    $0x8,%esp
  800b9c:	ff 75 0c             	pushl  0xc(%ebp)
  800b9f:	6a 30                	push   $0x30
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	ff d0                	call   *%eax
  800ba6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ba9:	83 ec 08             	sub    $0x8,%esp
  800bac:	ff 75 0c             	pushl  0xc(%ebp)
  800baf:	6a 78                	push   $0x78
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	ff d0                	call   *%eax
  800bb6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbc:	83 c0 04             	add    $0x4,%eax
  800bbf:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc5:	83 e8 04             	sub    $0x4,%eax
  800bc8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bd4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bdb:	eb 1f                	jmp    800bfc <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bdd:	83 ec 08             	sub    $0x8,%esp
  800be0:	ff 75 e8             	pushl  -0x18(%ebp)
  800be3:	8d 45 14             	lea    0x14(%ebp),%eax
  800be6:	50                   	push   %eax
  800be7:	e8 e7 fb ff ff       	call   8007d3 <getuint>
  800bec:	83 c4 10             	add    $0x10,%esp
  800bef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bf5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bfc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c03:	83 ec 04             	sub    $0x4,%esp
  800c06:	52                   	push   %edx
  800c07:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c0a:	50                   	push   %eax
  800c0b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c0e:	ff 75 f0             	pushl  -0x10(%ebp)
  800c11:	ff 75 0c             	pushl  0xc(%ebp)
  800c14:	ff 75 08             	pushl  0x8(%ebp)
  800c17:	e8 00 fb ff ff       	call   80071c <printnum>
  800c1c:	83 c4 20             	add    $0x20,%esp
			break;
  800c1f:	eb 46                	jmp    800c67 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c21:	83 ec 08             	sub    $0x8,%esp
  800c24:	ff 75 0c             	pushl  0xc(%ebp)
  800c27:	53                   	push   %ebx
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	ff d0                	call   *%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
			break;
  800c30:	eb 35                	jmp    800c67 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c32:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800c39:	eb 2c                	jmp    800c67 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c3b:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800c42:	eb 23                	jmp    800c67 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c44:	83 ec 08             	sub    $0x8,%esp
  800c47:	ff 75 0c             	pushl  0xc(%ebp)
  800c4a:	6a 25                	push   $0x25
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	ff d0                	call   *%eax
  800c51:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c54:	ff 4d 10             	decl   0x10(%ebp)
  800c57:	eb 03                	jmp    800c5c <vprintfmt+0x3c3>
  800c59:	ff 4d 10             	decl   0x10(%ebp)
  800c5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5f:	48                   	dec    %eax
  800c60:	8a 00                	mov    (%eax),%al
  800c62:	3c 25                	cmp    $0x25,%al
  800c64:	75 f3                	jne    800c59 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c66:	90                   	nop
		}
	}
  800c67:	e9 35 fc ff ff       	jmp    8008a1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c6c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c70:	5b                   	pop    %ebx
  800c71:	5e                   	pop    %esi
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c7a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c7d:	83 c0 04             	add    $0x4,%eax
  800c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c83:	8b 45 10             	mov    0x10(%ebp),%eax
  800c86:	ff 75 f4             	pushl  -0xc(%ebp)
  800c89:	50                   	push   %eax
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	ff 75 08             	pushl  0x8(%ebp)
  800c90:	e8 04 fc ff ff       	call   800899 <vprintfmt>
  800c95:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c98:	90                   	nop
  800c99:	c9                   	leave  
  800c9a:	c3                   	ret    

00800c9b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	8b 40 08             	mov    0x8(%eax),%eax
  800ca4:	8d 50 01             	lea    0x1(%eax),%edx
  800ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caa:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb0:	8b 10                	mov    (%eax),%edx
  800cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb5:	8b 40 04             	mov    0x4(%eax),%eax
  800cb8:	39 c2                	cmp    %eax,%edx
  800cba:	73 12                	jae    800cce <sprintputch+0x33>
		*b->buf++ = ch;
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8b 00                	mov    (%eax),%eax
  800cc1:	8d 48 01             	lea    0x1(%eax),%ecx
  800cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc7:	89 0a                	mov    %ecx,(%edx)
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	88 10                	mov    %dl,(%eax)
}
  800cce:	90                   	nop
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    

00800cd1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	01 d0                	add    %edx,%eax
  800ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ceb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cf6:	74 06                	je     800cfe <vsnprintf+0x2d>
  800cf8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfc:	7f 07                	jg     800d05 <vsnprintf+0x34>
		return -E_INVAL;
  800cfe:	b8 03 00 00 00       	mov    $0x3,%eax
  800d03:	eb 20                	jmp    800d25 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d05:	ff 75 14             	pushl  0x14(%ebp)
  800d08:	ff 75 10             	pushl  0x10(%ebp)
  800d0b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d0e:	50                   	push   %eax
  800d0f:	68 9b 0c 80 00       	push   $0x800c9b
  800d14:	e8 80 fb ff ff       	call   800899 <vprintfmt>
  800d19:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d1f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d2d:	8d 45 10             	lea    0x10(%ebp),%eax
  800d30:	83 c0 04             	add    $0x4,%eax
  800d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d36:	8b 45 10             	mov    0x10(%ebp),%eax
  800d39:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3c:	50                   	push   %eax
  800d3d:	ff 75 0c             	pushl  0xc(%ebp)
  800d40:	ff 75 08             	pushl  0x8(%ebp)
  800d43:	e8 89 ff ff ff       	call   800cd1 <vsnprintf>
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d60:	eb 06                	jmp    800d68 <strlen+0x15>
		n++;
  800d62:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d65:	ff 45 08             	incl   0x8(%ebp)
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	84 c0                	test   %al,%al
  800d6f:	75 f1                	jne    800d62 <strlen+0xf>
		n++;
	return n;
  800d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d74:	c9                   	leave  
  800d75:	c3                   	ret    

00800d76 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d83:	eb 09                	jmp    800d8e <strnlen+0x18>
		n++;
  800d85:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d88:	ff 45 08             	incl   0x8(%ebp)
  800d8b:	ff 4d 0c             	decl   0xc(%ebp)
  800d8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d92:	74 09                	je     800d9d <strnlen+0x27>
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	84 c0                	test   %al,%al
  800d9b:	75 e8                	jne    800d85 <strnlen+0xf>
		n++;
	return n;
  800d9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da0:	c9                   	leave  
  800da1:	c3                   	ret    

00800da2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dae:	90                   	nop
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8d 50 01             	lea    0x1(%eax),%edx
  800db5:	89 55 08             	mov    %edx,0x8(%ebp)
  800db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dbe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dc1:	8a 12                	mov    (%edx),%dl
  800dc3:	88 10                	mov    %dl,(%eax)
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	84 c0                	test   %al,%al
  800dc9:	75 e4                	jne    800daf <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dce:	c9                   	leave  
  800dcf:	c3                   	ret    

00800dd0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ddc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800de3:	eb 1f                	jmp    800e04 <strncpy+0x34>
		*dst++ = *src;
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8d 50 01             	lea    0x1(%eax),%edx
  800deb:	89 55 08             	mov    %edx,0x8(%ebp)
  800dee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df1:	8a 12                	mov    (%edx),%dl
  800df3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	84 c0                	test   %al,%al
  800dfc:	74 03                	je     800e01 <strncpy+0x31>
			src++;
  800dfe:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e01:	ff 45 fc             	incl   -0x4(%ebp)
  800e04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e07:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e0a:	72 d9                	jb     800de5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e21:	74 30                	je     800e53 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e23:	eb 16                	jmp    800e3b <strlcpy+0x2a>
			*dst++ = *src++;
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8d 50 01             	lea    0x1(%eax),%edx
  800e2b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e34:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e37:	8a 12                	mov    (%edx),%dl
  800e39:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e3b:	ff 4d 10             	decl   0x10(%ebp)
  800e3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e42:	74 09                	je     800e4d <strlcpy+0x3c>
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	84 c0                	test   %al,%al
  800e4b:	75 d8                	jne    800e25 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e53:	8b 55 08             	mov    0x8(%ebp),%edx
  800e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e59:	29 c2                	sub    %eax,%edx
  800e5b:	89 d0                	mov    %edx,%eax
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    

00800e5f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e62:	eb 06                	jmp    800e6a <strcmp+0xb>
		p++, q++;
  800e64:	ff 45 08             	incl   0x8(%ebp)
  800e67:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	84 c0                	test   %al,%al
  800e71:	74 0e                	je     800e81 <strcmp+0x22>
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 10                	mov    (%eax),%dl
  800e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	38 c2                	cmp    %al,%dl
  800e7f:	74 e3                	je     800e64 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	0f b6 d0             	movzbl %al,%edx
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 c0             	movzbl %al,%eax
  800e91:	29 c2                	sub    %eax,%edx
  800e93:	89 d0                	mov    %edx,%eax
}
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e9a:	eb 09                	jmp    800ea5 <strncmp+0xe>
		n--, p++, q++;
  800e9c:	ff 4d 10             	decl   0x10(%ebp)
  800e9f:	ff 45 08             	incl   0x8(%ebp)
  800ea2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ea5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea9:	74 17                	je     800ec2 <strncmp+0x2b>
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	8a 00                	mov    (%eax),%al
  800eb0:	84 c0                	test   %al,%al
  800eb2:	74 0e                	je     800ec2 <strncmp+0x2b>
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	8a 10                	mov    (%eax),%dl
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	38 c2                	cmp    %al,%dl
  800ec0:	74 da                	je     800e9c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ec2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec6:	75 07                	jne    800ecf <strncmp+0x38>
		return 0;
  800ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ecd:	eb 14                	jmp    800ee3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	0f b6 d0             	movzbl %al,%edx
  800ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	0f b6 c0             	movzbl %al,%eax
  800edf:	29 c2                	sub    %eax,%edx
  800ee1:	89 d0                	mov    %edx,%eax
}
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    

00800ee5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 04             	sub    $0x4,%esp
  800eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eee:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef1:	eb 12                	jmp    800f05 <strchr+0x20>
		if (*s == c)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800efb:	75 05                	jne    800f02 <strchr+0x1d>
			return (char *) s;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	eb 11                	jmp    800f13 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	84 c0                	test   %al,%al
  800f0c:	75 e5                	jne    800ef3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 04             	sub    $0x4,%esp
  800f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f21:	eb 0d                	jmp    800f30 <strfind+0x1b>
		if (*s == c)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f2b:	74 0e                	je     800f3b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f2d:	ff 45 08             	incl   0x8(%ebp)
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	84 c0                	test   %al,%al
  800f37:	75 ea                	jne    800f23 <strfind+0xe>
  800f39:	eb 01                	jmp    800f3c <strfind+0x27>
		if (*s == c)
			break;
  800f3b:	90                   	nop
	return (char *) s;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f4d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f51:	76 63                	jbe    800fb6 <memset+0x75>
		uint64 data_block = c;
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	99                   	cltd   
  800f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f5a:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f63:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f67:	c1 e0 08             	shl    $0x8,%eax
  800f6a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f6d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f76:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f7a:	c1 e0 10             	shl    $0x10,%eax
  800f7d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f80:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f89:	89 c2                	mov    %eax,%edx
  800f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f90:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f93:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f96:	eb 18                	jmp    800fb0 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f98:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f9b:	8d 41 08             	lea    0x8(%ecx),%eax
  800f9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa7:	89 01                	mov    %eax,(%ecx)
  800fa9:	89 51 04             	mov    %edx,0x4(%ecx)
  800fac:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800fb0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fb4:	77 e2                	ja     800f98 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800fb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fba:	74 23                	je     800fdf <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800fbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fc2:	eb 0e                	jmp    800fd2 <memset+0x91>
			*p8++ = (uint8)c;
  800fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc7:	8d 50 01             	lea    0x1(%eax),%edx
  800fca:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd0:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd8:	89 55 10             	mov    %edx,0x10(%ebp)
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	75 e5                	jne    800fc4 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe2:	c9                   	leave  
  800fe3:	c3                   	ret    

00800fe4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ff6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ffa:	76 24                	jbe    801020 <memcpy+0x3c>
		while(n >= 8){
  800ffc:	eb 1c                	jmp    80101a <memcpy+0x36>
			*d64 = *s64;
  800ffe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801001:	8b 50 04             	mov    0x4(%eax),%edx
  801004:	8b 00                	mov    (%eax),%eax
  801006:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801009:	89 01                	mov    %eax,(%ecx)
  80100b:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80100e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801012:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801016:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80101a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80101e:	77 de                	ja     800ffe <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801020:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801024:	74 31                	je     801057 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801026:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801029:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80102c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801032:	eb 16                	jmp    80104a <memcpy+0x66>
			*d8++ = *s8++;
  801034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801037:	8d 50 01             	lea    0x1(%eax),%edx
  80103a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80103d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801040:	8d 4a 01             	lea    0x1(%edx),%ecx
  801043:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801046:	8a 12                	mov    (%edx),%dl
  801048:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80104a:	8b 45 10             	mov    0x10(%ebp),%eax
  80104d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801050:	89 55 10             	mov    %edx,0x10(%ebp)
  801053:	85 c0                	test   %eax,%eax
  801055:	75 dd                	jne    801034 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    

0080105c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801062:	8b 45 0c             	mov    0xc(%ebp),%eax
  801065:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80106e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801071:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801074:	73 50                	jae    8010c6 <memmove+0x6a>
  801076:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801079:	8b 45 10             	mov    0x10(%ebp),%eax
  80107c:	01 d0                	add    %edx,%eax
  80107e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801081:	76 43                	jbe    8010c6 <memmove+0x6a>
		s += n;
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801089:	8b 45 10             	mov    0x10(%ebp),%eax
  80108c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80108f:	eb 10                	jmp    8010a1 <memmove+0x45>
			*--d = *--s;
  801091:	ff 4d f8             	decl   -0x8(%ebp)
  801094:	ff 4d fc             	decl   -0x4(%ebp)
  801097:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109a:	8a 10                	mov    (%eax),%dl
  80109c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	75 e3                	jne    801091 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010ae:	eb 23                	jmp    8010d3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b3:	8d 50 01             	lea    0x1(%eax),%edx
  8010b6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010c2:	8a 12                	mov    (%edx),%dl
  8010c4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cc:	89 55 10             	mov    %edx,0x10(%ebp)
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	75 dd                	jne    8010b0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d6:	c9                   	leave  
  8010d7:	c3                   	ret    

008010d8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010d8:	55                   	push   %ebp
  8010d9:	89 e5                	mov    %esp,%ebp
  8010db:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010ea:	eb 2a                	jmp    801116 <memcmp+0x3e>
		if (*s1 != *s2)
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	8a 10                	mov    (%eax),%dl
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	38 c2                	cmp    %al,%dl
  8010f8:	74 16                	je     801110 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f b6 d0             	movzbl %al,%edx
  801102:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	0f b6 c0             	movzbl %al,%eax
  80110a:	29 c2                	sub    %eax,%edx
  80110c:	89 d0                	mov    %edx,%eax
  80110e:	eb 18                	jmp    801128 <memcmp+0x50>
		s1++, s2++;
  801110:	ff 45 fc             	incl   -0x4(%ebp)
  801113:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801116:	8b 45 10             	mov    0x10(%ebp),%eax
  801119:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111c:	89 55 10             	mov    %edx,0x10(%ebp)
  80111f:	85 c0                	test   %eax,%eax
  801121:	75 c9                	jne    8010ec <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801123:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801128:	c9                   	leave  
  801129:	c3                   	ret    

0080112a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801130:	8b 55 08             	mov    0x8(%ebp),%edx
  801133:	8b 45 10             	mov    0x10(%ebp),%eax
  801136:	01 d0                	add    %edx,%eax
  801138:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80113b:	eb 15                	jmp    801152 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	0f b6 d0             	movzbl %al,%edx
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	0f b6 c0             	movzbl %al,%eax
  80114b:	39 c2                	cmp    %eax,%edx
  80114d:	74 0d                	je     80115c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80114f:	ff 45 08             	incl   0x8(%ebp)
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801158:	72 e3                	jb     80113d <memfind+0x13>
  80115a:	eb 01                	jmp    80115d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80115c:	90                   	nop
	return (void *) s;
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801160:	c9                   	leave  
  801161:	c3                   	ret    

00801162 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801168:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80116f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801176:	eb 03                	jmp    80117b <strtol+0x19>
		s++;
  801178:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
  80117e:	8a 00                	mov    (%eax),%al
  801180:	3c 20                	cmp    $0x20,%al
  801182:	74 f4                	je     801178 <strtol+0x16>
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	3c 09                	cmp    $0x9,%al
  80118b:	74 eb                	je     801178 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	3c 2b                	cmp    $0x2b,%al
  801194:	75 05                	jne    80119b <strtol+0x39>
		s++;
  801196:	ff 45 08             	incl   0x8(%ebp)
  801199:	eb 13                	jmp    8011ae <strtol+0x4c>
	else if (*s == '-')
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	3c 2d                	cmp    $0x2d,%al
  8011a2:	75 0a                	jne    8011ae <strtol+0x4c>
		s++, neg = 1;
  8011a4:	ff 45 08             	incl   0x8(%ebp)
  8011a7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b2:	74 06                	je     8011ba <strtol+0x58>
  8011b4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011b8:	75 20                	jne    8011da <strtol+0x78>
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	3c 30                	cmp    $0x30,%al
  8011c1:	75 17                	jne    8011da <strtol+0x78>
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	40                   	inc    %eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	3c 78                	cmp    $0x78,%al
  8011cb:	75 0d                	jne    8011da <strtol+0x78>
		s += 2, base = 16;
  8011cd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011d1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011d8:	eb 28                	jmp    801202 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011de:	75 15                	jne    8011f5 <strtol+0x93>
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 30                	cmp    $0x30,%al
  8011e7:	75 0c                	jne    8011f5 <strtol+0x93>
		s++, base = 8;
  8011e9:	ff 45 08             	incl   0x8(%ebp)
  8011ec:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011f3:	eb 0d                	jmp    801202 <strtol+0xa0>
	else if (base == 0)
  8011f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f9:	75 07                	jne    801202 <strtol+0xa0>
		base = 10;
  8011fb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	3c 2f                	cmp    $0x2f,%al
  801209:	7e 19                	jle    801224 <strtol+0xc2>
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	3c 39                	cmp    $0x39,%al
  801212:	7f 10                	jg     801224 <strtol+0xc2>
			dig = *s - '0';
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	8a 00                	mov    (%eax),%al
  801219:	0f be c0             	movsbl %al,%eax
  80121c:	83 e8 30             	sub    $0x30,%eax
  80121f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801222:	eb 42                	jmp    801266 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	3c 60                	cmp    $0x60,%al
  80122b:	7e 19                	jle    801246 <strtol+0xe4>
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	3c 7a                	cmp    $0x7a,%al
  801234:	7f 10                	jg     801246 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	8a 00                	mov    (%eax),%al
  80123b:	0f be c0             	movsbl %al,%eax
  80123e:	83 e8 57             	sub    $0x57,%eax
  801241:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801244:	eb 20                	jmp    801266 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	8a 00                	mov    (%eax),%al
  80124b:	3c 40                	cmp    $0x40,%al
  80124d:	7e 39                	jle    801288 <strtol+0x126>
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	3c 5a                	cmp    $0x5a,%al
  801256:	7f 30                	jg     801288 <strtol+0x126>
			dig = *s - 'A' + 10;
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	0f be c0             	movsbl %al,%eax
  801260:	83 e8 37             	sub    $0x37,%eax
  801263:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801269:	3b 45 10             	cmp    0x10(%ebp),%eax
  80126c:	7d 19                	jge    801287 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80126e:	ff 45 08             	incl   0x8(%ebp)
  801271:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801274:	0f af 45 10          	imul   0x10(%ebp),%eax
  801278:	89 c2                	mov    %eax,%edx
  80127a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127d:	01 d0                	add    %edx,%eax
  80127f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801282:	e9 7b ff ff ff       	jmp    801202 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801287:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801288:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80128c:	74 08                	je     801296 <strtol+0x134>
		*endptr = (char *) s;
  80128e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801291:	8b 55 08             	mov    0x8(%ebp),%edx
  801294:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801296:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80129a:	74 07                	je     8012a3 <strtol+0x141>
  80129c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129f:	f7 d8                	neg    %eax
  8012a1:	eb 03                	jmp    8012a6 <strtol+0x144>
  8012a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <ltostr>:

void
ltostr(long value, char *str)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012c0:	79 13                	jns    8012d5 <ltostr+0x2d>
	{
		neg = 1;
  8012c2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012cf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012d2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012dd:	99                   	cltd   
  8012de:	f7 f9                	idiv   %ecx
  8012e0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e6:	8d 50 01             	lea    0x1(%eax),%edx
  8012e9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ec:	89 c2                	mov    %eax,%edx
  8012ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f1:	01 d0                	add    %edx,%eax
  8012f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012f6:	83 c2 30             	add    $0x30,%edx
  8012f9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012fe:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801303:	f7 e9                	imul   %ecx
  801305:	c1 fa 02             	sar    $0x2,%edx
  801308:	89 c8                	mov    %ecx,%eax
  80130a:	c1 f8 1f             	sar    $0x1f,%eax
  80130d:	29 c2                	sub    %eax,%edx
  80130f:	89 d0                	mov    %edx,%eax
  801311:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801314:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801318:	75 bb                	jne    8012d5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80131a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801321:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801324:	48                   	dec    %eax
  801325:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801328:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80132c:	74 3d                	je     80136b <ltostr+0xc3>
		start = 1 ;
  80132e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801335:	eb 34                	jmp    80136b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801337:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80133a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133d:	01 d0                	add    %edx,%eax
  80133f:	8a 00                	mov    (%eax),%al
  801341:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801344:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	01 c2                	add    %eax,%edx
  80134c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80134f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801352:	01 c8                	add    %ecx,%eax
  801354:	8a 00                	mov    (%eax),%al
  801356:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801358:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	01 c2                	add    %eax,%edx
  801360:	8a 45 eb             	mov    -0x15(%ebp),%al
  801363:	88 02                	mov    %al,(%edx)
		start++ ;
  801365:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801368:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80136b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801371:	7c c4                	jl     801337 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801373:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801376:	8b 45 0c             	mov    0xc(%ebp),%eax
  801379:	01 d0                	add    %edx,%eax
  80137b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80137e:	90                   	nop
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801387:	ff 75 08             	pushl  0x8(%ebp)
  80138a:	e8 c4 f9 ff ff       	call   800d53 <strlen>
  80138f:	83 c4 04             	add    $0x4,%esp
  801392:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801395:	ff 75 0c             	pushl  0xc(%ebp)
  801398:	e8 b6 f9 ff ff       	call   800d53 <strlen>
  80139d:	83 c4 04             	add    $0x4,%esp
  8013a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013b1:	eb 17                	jmp    8013ca <strcconcat+0x49>
		final[s] = str1[s] ;
  8013b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b9:	01 c2                	add    %eax,%edx
  8013bb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	01 c8                	add    %ecx,%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013c7:	ff 45 fc             	incl   -0x4(%ebp)
  8013ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013cd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013d0:	7c e1                	jl     8013b3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013e0:	eb 1f                	jmp    801401 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e5:	8d 50 01             	lea    0x1(%eax),%edx
  8013e8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013eb:	89 c2                	mov    %eax,%edx
  8013ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f0:	01 c2                	add    %eax,%edx
  8013f2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f8:	01 c8                	add    %ecx,%eax
  8013fa:	8a 00                	mov    (%eax),%al
  8013fc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013fe:	ff 45 f8             	incl   -0x8(%ebp)
  801401:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801404:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801407:	7c d9                	jl     8013e2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801409:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80140c:	8b 45 10             	mov    0x10(%ebp),%eax
  80140f:	01 d0                	add    %edx,%eax
  801411:	c6 00 00             	movb   $0x0,(%eax)
}
  801414:	90                   	nop
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80141a:	8b 45 14             	mov    0x14(%ebp),%eax
  80141d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801423:	8b 45 14             	mov    0x14(%ebp),%eax
  801426:	8b 00                	mov    (%eax),%eax
  801428:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80142f:	8b 45 10             	mov    0x10(%ebp),%eax
  801432:	01 d0                	add    %edx,%eax
  801434:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80143a:	eb 0c                	jmp    801448 <strsplit+0x31>
			*string++ = 0;
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8d 50 01             	lea    0x1(%eax),%edx
  801442:	89 55 08             	mov    %edx,0x8(%ebp)
  801445:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	84 c0                	test   %al,%al
  80144f:	74 18                	je     801469 <strsplit+0x52>
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	0f be c0             	movsbl %al,%eax
  801459:	50                   	push   %eax
  80145a:	ff 75 0c             	pushl  0xc(%ebp)
  80145d:	e8 83 fa ff ff       	call   800ee5 <strchr>
  801462:	83 c4 08             	add    $0x8,%esp
  801465:	85 c0                	test   %eax,%eax
  801467:	75 d3                	jne    80143c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	84 c0                	test   %al,%al
  801470:	74 5a                	je     8014cc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801472:	8b 45 14             	mov    0x14(%ebp),%eax
  801475:	8b 00                	mov    (%eax),%eax
  801477:	83 f8 0f             	cmp    $0xf,%eax
  80147a:	75 07                	jne    801483 <strsplit+0x6c>
		{
			return 0;
  80147c:	b8 00 00 00 00       	mov    $0x0,%eax
  801481:	eb 66                	jmp    8014e9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801483:	8b 45 14             	mov    0x14(%ebp),%eax
  801486:	8b 00                	mov    (%eax),%eax
  801488:	8d 48 01             	lea    0x1(%eax),%ecx
  80148b:	8b 55 14             	mov    0x14(%ebp),%edx
  80148e:	89 0a                	mov    %ecx,(%edx)
  801490:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801497:	8b 45 10             	mov    0x10(%ebp),%eax
  80149a:	01 c2                	add    %eax,%edx
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014a1:	eb 03                	jmp    8014a6 <strsplit+0x8f>
			string++;
  8014a3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	8a 00                	mov    (%eax),%al
  8014ab:	84 c0                	test   %al,%al
  8014ad:	74 8b                	je     80143a <strsplit+0x23>
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	0f be c0             	movsbl %al,%eax
  8014b7:	50                   	push   %eax
  8014b8:	ff 75 0c             	pushl  0xc(%ebp)
  8014bb:	e8 25 fa ff ff       	call   800ee5 <strchr>
  8014c0:	83 c4 08             	add    $0x8,%esp
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	74 dc                	je     8014a3 <strsplit+0x8c>
			string++;
	}
  8014c7:	e9 6e ff ff ff       	jmp    80143a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014cc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d0:	8b 00                	mov    (%eax),%eax
  8014d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014e4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014fe:	eb 4a                	jmp    80154a <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801500:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	01 c2                	add    %eax,%edx
  801508:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	01 c8                	add    %ecx,%eax
  801510:	8a 00                	mov    (%eax),%al
  801512:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801514:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151a:	01 d0                	add    %edx,%eax
  80151c:	8a 00                	mov    (%eax),%al
  80151e:	3c 40                	cmp    $0x40,%al
  801520:	7e 25                	jle    801547 <str2lower+0x5c>
  801522:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	01 d0                	add    %edx,%eax
  80152a:	8a 00                	mov    (%eax),%al
  80152c:	3c 5a                	cmp    $0x5a,%al
  80152e:	7f 17                	jg     801547 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801530:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80153b:	8b 55 08             	mov    0x8(%ebp),%edx
  80153e:	01 ca                	add    %ecx,%edx
  801540:	8a 12                	mov    (%edx),%dl
  801542:	83 c2 20             	add    $0x20,%edx
  801545:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801547:	ff 45 fc             	incl   -0x4(%ebp)
  80154a:	ff 75 0c             	pushl  0xc(%ebp)
  80154d:	e8 01 f8 ff ff       	call   800d53 <strlen>
  801552:	83 c4 04             	add    $0x4,%esp
  801555:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801558:	7f a6                	jg     801500 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80155a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	57                   	push   %edi
  801563:	56                   	push   %esi
  801564:	53                   	push   %ebx
  801565:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801571:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801574:	8b 7d 18             	mov    0x18(%ebp),%edi
  801577:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80157a:	cd 30                	int    $0x30
  80157c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80157f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	5b                   	pop    %ebx
  801586:	5e                   	pop    %esi
  801587:	5f                   	pop    %edi
  801588:	5d                   	pop    %ebp
  801589:	c3                   	ret    

0080158a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 04             	sub    $0x4,%esp
  801590:	8b 45 10             	mov    0x10(%ebp),%eax
  801593:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801596:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801599:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	6a 00                	push   $0x0
  8015a2:	51                   	push   %ecx
  8015a3:	52                   	push   %edx
  8015a4:	ff 75 0c             	pushl  0xc(%ebp)
  8015a7:	50                   	push   %eax
  8015a8:	6a 00                	push   $0x0
  8015aa:	e8 b0 ff ff ff       	call   80155f <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
}
  8015b2:	90                   	nop
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 02                	push   $0x2
  8015c4:	e8 96 ff ff ff       	call   80155f <syscall>
  8015c9:	83 c4 18             	add    $0x18,%esp
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 03                	push   $0x3
  8015dd:	e8 7d ff ff ff       	call   80155f <syscall>
  8015e2:	83 c4 18             	add    $0x18,%esp
}
  8015e5:	90                   	nop
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 04                	push   $0x4
  8015f7:	e8 63 ff ff ff       	call   80155f <syscall>
  8015fc:	83 c4 18             	add    $0x18,%esp
}
  8015ff:	90                   	nop
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801605:	8b 55 0c             	mov    0xc(%ebp),%edx
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	52                   	push   %edx
  801612:	50                   	push   %eax
  801613:	6a 08                	push   $0x8
  801615:	e8 45 ff ff ff       	call   80155f <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	56                   	push   %esi
  801623:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801624:	8b 75 18             	mov    0x18(%ebp),%esi
  801627:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80162a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80162d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	56                   	push   %esi
  801634:	53                   	push   %ebx
  801635:	51                   	push   %ecx
  801636:	52                   	push   %edx
  801637:	50                   	push   %eax
  801638:	6a 09                	push   $0x9
  80163a:	e8 20 ff ff ff       	call   80155f <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
}
  801642:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801645:	5b                   	pop    %ebx
  801646:	5e                   	pop    %esi
  801647:	5d                   	pop    %ebp
  801648:	c3                   	ret    

00801649 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	ff 75 08             	pushl  0x8(%ebp)
  801657:	6a 0a                	push   $0xa
  801659:	e8 01 ff ff ff       	call   80155f <syscall>
  80165e:	83 c4 18             	add    $0x18,%esp
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	ff 75 0c             	pushl  0xc(%ebp)
  80166f:	ff 75 08             	pushl  0x8(%ebp)
  801672:	6a 0b                	push   $0xb
  801674:	e8 e6 fe ff ff       	call   80155f <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
}
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 0c                	push   $0xc
  80168d:	e8 cd fe ff ff       	call   80155f <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 0d                	push   $0xd
  8016a6:	e8 b4 fe ff ff       	call   80155f <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 0e                	push   $0xe
  8016bf:	e8 9b fe ff ff       	call   80155f <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 0f                	push   $0xf
  8016d8:	e8 82 fe ff ff       	call   80155f <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	ff 75 08             	pushl  0x8(%ebp)
  8016f0:	6a 10                	push   $0x10
  8016f2:	e8 68 fe ff ff       	call   80155f <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 11                	push   $0x11
  80170b:	e8 4f fe ff ff       	call   80155f <syscall>
  801710:	83 c4 18             	add    $0x18,%esp
}
  801713:	90                   	nop
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <sys_cputc>:

void
sys_cputc(const char c)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 04             	sub    $0x4,%esp
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801722:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	50                   	push   %eax
  80172f:	6a 01                	push   $0x1
  801731:	e8 29 fe ff ff       	call   80155f <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
}
  801739:	90                   	nop
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 14                	push   $0x14
  80174b:	e8 0f fe ff ff       	call   80155f <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	90                   	nop
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 04             	sub    $0x4,%esp
  80175c:	8b 45 10             	mov    0x10(%ebp),%eax
  80175f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801762:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801765:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	6a 00                	push   $0x0
  80176e:	51                   	push   %ecx
  80176f:	52                   	push   %edx
  801770:	ff 75 0c             	pushl  0xc(%ebp)
  801773:	50                   	push   %eax
  801774:	6a 15                	push   $0x15
  801776:	e8 e4 fd ff ff       	call   80155f <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801783:	8b 55 0c             	mov    0xc(%ebp),%edx
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	52                   	push   %edx
  801790:	50                   	push   %eax
  801791:	6a 16                	push   $0x16
  801793:	e8 c7 fd ff ff       	call   80155f <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	51                   	push   %ecx
  8017ae:	52                   	push   %edx
  8017af:	50                   	push   %eax
  8017b0:	6a 17                	push   $0x17
  8017b2:	e8 a8 fd ff ff       	call   80155f <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	52                   	push   %edx
  8017cc:	50                   	push   %eax
  8017cd:	6a 18                	push   $0x18
  8017cf:	e8 8b fd ff ff       	call   80155f <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	6a 00                	push   $0x0
  8017e1:	ff 75 14             	pushl  0x14(%ebp)
  8017e4:	ff 75 10             	pushl  0x10(%ebp)
  8017e7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ea:	50                   	push   %eax
  8017eb:	6a 19                	push   $0x19
  8017ed:	e8 6d fd ff ff       	call   80155f <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	50                   	push   %eax
  801806:	6a 1a                	push   $0x1a
  801808:	e8 52 fd ff ff       	call   80155f <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	90                   	nop
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	50                   	push   %eax
  801822:	6a 1b                	push   $0x1b
  801824:	e8 36 fd ff ff       	call   80155f <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 05                	push   $0x5
  80183d:	e8 1d fd ff ff       	call   80155f <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 06                	push   $0x6
  801856:	e8 04 fd ff ff       	call   80155f <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 07                	push   $0x7
  80186f:	e8 eb fc ff ff       	call   80155f <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_exit_env>:


void sys_exit_env(void)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 1c                	push   $0x1c
  801888:	e8 d2 fc ff ff       	call   80155f <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	90                   	nop
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801899:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80189c:	8d 50 04             	lea    0x4(%eax),%edx
  80189f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	52                   	push   %edx
  8018a9:	50                   	push   %eax
  8018aa:	6a 1d                	push   $0x1d
  8018ac:	e8 ae fc ff ff       	call   80155f <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
	return result;
  8018b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018bd:	89 01                	mov    %eax,(%ecx)
  8018bf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	c9                   	leave  
  8018c6:	c2 04 00             	ret    $0x4

008018c9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	ff 75 10             	pushl  0x10(%ebp)
  8018d3:	ff 75 0c             	pushl  0xc(%ebp)
  8018d6:	ff 75 08             	pushl  0x8(%ebp)
  8018d9:	6a 13                	push   $0x13
  8018db:	e8 7f fc ff ff       	call   80155f <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e3:	90                   	nop
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 1e                	push   $0x1e
  8018f5:	e8 65 fc ff ff       	call   80155f <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 04             	sub    $0x4,%esp
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80190b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	50                   	push   %eax
  801918:	6a 1f                	push   $0x1f
  80191a:	e8 40 fc ff ff       	call   80155f <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
	return ;
  801922:	90                   	nop
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <rsttst>:
void rsttst()
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 21                	push   $0x21
  801934:	e8 26 fc ff ff       	call   80155f <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
	return ;
  80193c:	90                   	nop
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	83 ec 04             	sub    $0x4,%esp
  801945:	8b 45 14             	mov    0x14(%ebp),%eax
  801948:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80194b:	8b 55 18             	mov    0x18(%ebp),%edx
  80194e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801952:	52                   	push   %edx
  801953:	50                   	push   %eax
  801954:	ff 75 10             	pushl  0x10(%ebp)
  801957:	ff 75 0c             	pushl  0xc(%ebp)
  80195a:	ff 75 08             	pushl  0x8(%ebp)
  80195d:	6a 20                	push   $0x20
  80195f:	e8 fb fb ff ff       	call   80155f <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
	return ;
  801967:	90                   	nop
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <chktst>:
void chktst(uint32 n)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	ff 75 08             	pushl  0x8(%ebp)
  801978:	6a 22                	push   $0x22
  80197a:	e8 e0 fb ff ff       	call   80155f <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
	return ;
  801982:	90                   	nop
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <inctst>:

void inctst()
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 23                	push   $0x23
  801994:	e8 c6 fb ff ff       	call   80155f <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
	return ;
  80199c:	90                   	nop
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <gettst>:
uint32 gettst()
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 24                	push   $0x24
  8019ae:	e8 ac fb ff ff       	call   80155f <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 25                	push   $0x25
  8019c7:	e8 93 fb ff ff       	call   80155f <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
  8019cf:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8019d4:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	ff 75 08             	pushl  0x8(%ebp)
  8019f1:	6a 26                	push   $0x26
  8019f3:	e8 67 fb ff ff       	call   80155f <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fb:	90                   	nop
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a02:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a05:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	6a 00                	push   $0x0
  801a10:	53                   	push   %ebx
  801a11:	51                   	push   %ecx
  801a12:	52                   	push   %edx
  801a13:	50                   	push   %eax
  801a14:	6a 27                	push   $0x27
  801a16:	e8 44 fb ff ff       	call   80155f <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	52                   	push   %edx
  801a33:	50                   	push   %eax
  801a34:	6a 28                	push   $0x28
  801a36:	e8 24 fb ff ff       	call   80155f <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a43:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	6a 00                	push   $0x0
  801a4e:	51                   	push   %ecx
  801a4f:	ff 75 10             	pushl  0x10(%ebp)
  801a52:	52                   	push   %edx
  801a53:	50                   	push   %eax
  801a54:	6a 29                	push   $0x29
  801a56:	e8 04 fb ff ff       	call   80155f <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	ff 75 10             	pushl  0x10(%ebp)
  801a6a:	ff 75 0c             	pushl  0xc(%ebp)
  801a6d:	ff 75 08             	pushl  0x8(%ebp)
  801a70:	6a 12                	push   $0x12
  801a72:	e8 e8 fa ff ff       	call   80155f <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7a:	90                   	nop
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801a80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	52                   	push   %edx
  801a8d:	50                   	push   %eax
  801a8e:	6a 2a                	push   $0x2a
  801a90:	e8 ca fa ff ff       	call   80155f <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
	return;
  801a98:	90                   	nop
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 2b                	push   $0x2b
  801aaa:	e8 b0 fa ff ff       	call   80155f <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	ff 75 0c             	pushl  0xc(%ebp)
  801ac0:	ff 75 08             	pushl  0x8(%ebp)
  801ac3:	6a 2d                	push   $0x2d
  801ac5:	e8 95 fa ff ff       	call   80155f <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
	return;
  801acd:	90                   	nop
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	ff 75 0c             	pushl  0xc(%ebp)
  801adc:	ff 75 08             	pushl  0x8(%ebp)
  801adf:	6a 2c                	push   $0x2c
  801ae1:	e8 79 fa ff ff       	call   80155f <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae9:	90                   	nop
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	52                   	push   %edx
  801afc:	50                   	push   %eax
  801afd:	6a 2e                	push   $0x2e
  801aff:	e8 5b fa ff ff       	call   80155f <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
	return ;
  801b07:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801b10:	8b 55 08             	mov    0x8(%ebp),%edx
  801b13:	89 d0                	mov    %edx,%eax
  801b15:	c1 e0 02             	shl    $0x2,%eax
  801b18:	01 d0                	add    %edx,%eax
  801b1a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b21:	01 d0                	add    %edx,%eax
  801b23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b2a:	01 d0                	add    %edx,%eax
  801b2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b33:	01 d0                	add    %edx,%eax
  801b35:	c1 e0 04             	shl    $0x4,%eax
  801b38:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801b3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801b42:	0f 31                	rdtsc  
  801b44:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b47:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b53:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801b56:	eb 46                	jmp    801b9e <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801b58:	0f 31                	rdtsc  
  801b5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b5d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b60:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b63:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801b66:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b69:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801b6c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b72:	29 c2                	sub    %eax,%edx
  801b74:	89 d0                	mov    %edx,%eax
  801b76:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801b79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7f:	89 d1                	mov    %edx,%ecx
  801b81:	29 c1                	sub    %eax,%ecx
  801b83:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b89:	39 c2                	cmp    %eax,%edx
  801b8b:	0f 97 c0             	seta   %al
  801b8e:	0f b6 c0             	movzbl %al,%eax
  801b91:	29 c1                	sub    %eax,%ecx
  801b93:	89 c8                	mov    %ecx,%eax
  801b95:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801b98:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801b9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ba1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801ba4:	72 b2                	jb     801b58 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801ba6:	90                   	nop
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801baf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801bb6:	eb 03                	jmp    801bbb <busy_wait+0x12>
  801bb8:	ff 45 fc             	incl   -0x4(%ebp)
  801bbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bbe:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bc1:	72 f5                	jb     801bb8 <busy_wait+0xf>
	return i;
  801bc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <__udivdi3>:
  801bc8:	55                   	push   %ebp
  801bc9:	57                   	push   %edi
  801bca:	56                   	push   %esi
  801bcb:	53                   	push   %ebx
  801bcc:	83 ec 1c             	sub    $0x1c,%esp
  801bcf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bd3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bdb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bdf:	89 ca                	mov    %ecx,%edx
  801be1:	89 f8                	mov    %edi,%eax
  801be3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801be7:	85 f6                	test   %esi,%esi
  801be9:	75 2d                	jne    801c18 <__udivdi3+0x50>
  801beb:	39 cf                	cmp    %ecx,%edi
  801bed:	77 65                	ja     801c54 <__udivdi3+0x8c>
  801bef:	89 fd                	mov    %edi,%ebp
  801bf1:	85 ff                	test   %edi,%edi
  801bf3:	75 0b                	jne    801c00 <__udivdi3+0x38>
  801bf5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfa:	31 d2                	xor    %edx,%edx
  801bfc:	f7 f7                	div    %edi
  801bfe:	89 c5                	mov    %eax,%ebp
  801c00:	31 d2                	xor    %edx,%edx
  801c02:	89 c8                	mov    %ecx,%eax
  801c04:	f7 f5                	div    %ebp
  801c06:	89 c1                	mov    %eax,%ecx
  801c08:	89 d8                	mov    %ebx,%eax
  801c0a:	f7 f5                	div    %ebp
  801c0c:	89 cf                	mov    %ecx,%edi
  801c0e:	89 fa                	mov    %edi,%edx
  801c10:	83 c4 1c             	add    $0x1c,%esp
  801c13:	5b                   	pop    %ebx
  801c14:	5e                   	pop    %esi
  801c15:	5f                   	pop    %edi
  801c16:	5d                   	pop    %ebp
  801c17:	c3                   	ret    
  801c18:	39 ce                	cmp    %ecx,%esi
  801c1a:	77 28                	ja     801c44 <__udivdi3+0x7c>
  801c1c:	0f bd fe             	bsr    %esi,%edi
  801c1f:	83 f7 1f             	xor    $0x1f,%edi
  801c22:	75 40                	jne    801c64 <__udivdi3+0x9c>
  801c24:	39 ce                	cmp    %ecx,%esi
  801c26:	72 0a                	jb     801c32 <__udivdi3+0x6a>
  801c28:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c2c:	0f 87 9e 00 00 00    	ja     801cd0 <__udivdi3+0x108>
  801c32:	b8 01 00 00 00       	mov    $0x1,%eax
  801c37:	89 fa                	mov    %edi,%edx
  801c39:	83 c4 1c             	add    $0x1c,%esp
  801c3c:	5b                   	pop    %ebx
  801c3d:	5e                   	pop    %esi
  801c3e:	5f                   	pop    %edi
  801c3f:	5d                   	pop    %ebp
  801c40:	c3                   	ret    
  801c41:	8d 76 00             	lea    0x0(%esi),%esi
  801c44:	31 ff                	xor    %edi,%edi
  801c46:	31 c0                	xor    %eax,%eax
  801c48:	89 fa                	mov    %edi,%edx
  801c4a:	83 c4 1c             	add    $0x1c,%esp
  801c4d:	5b                   	pop    %ebx
  801c4e:	5e                   	pop    %esi
  801c4f:	5f                   	pop    %edi
  801c50:	5d                   	pop    %ebp
  801c51:	c3                   	ret    
  801c52:	66 90                	xchg   %ax,%ax
  801c54:	89 d8                	mov    %ebx,%eax
  801c56:	f7 f7                	div    %edi
  801c58:	31 ff                	xor    %edi,%edi
  801c5a:	89 fa                	mov    %edi,%edx
  801c5c:	83 c4 1c             	add    $0x1c,%esp
  801c5f:	5b                   	pop    %ebx
  801c60:	5e                   	pop    %esi
  801c61:	5f                   	pop    %edi
  801c62:	5d                   	pop    %ebp
  801c63:	c3                   	ret    
  801c64:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c69:	89 eb                	mov    %ebp,%ebx
  801c6b:	29 fb                	sub    %edi,%ebx
  801c6d:	89 f9                	mov    %edi,%ecx
  801c6f:	d3 e6                	shl    %cl,%esi
  801c71:	89 c5                	mov    %eax,%ebp
  801c73:	88 d9                	mov    %bl,%cl
  801c75:	d3 ed                	shr    %cl,%ebp
  801c77:	89 e9                	mov    %ebp,%ecx
  801c79:	09 f1                	or     %esi,%ecx
  801c7b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c7f:	89 f9                	mov    %edi,%ecx
  801c81:	d3 e0                	shl    %cl,%eax
  801c83:	89 c5                	mov    %eax,%ebp
  801c85:	89 d6                	mov    %edx,%esi
  801c87:	88 d9                	mov    %bl,%cl
  801c89:	d3 ee                	shr    %cl,%esi
  801c8b:	89 f9                	mov    %edi,%ecx
  801c8d:	d3 e2                	shl    %cl,%edx
  801c8f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c93:	88 d9                	mov    %bl,%cl
  801c95:	d3 e8                	shr    %cl,%eax
  801c97:	09 c2                	or     %eax,%edx
  801c99:	89 d0                	mov    %edx,%eax
  801c9b:	89 f2                	mov    %esi,%edx
  801c9d:	f7 74 24 0c          	divl   0xc(%esp)
  801ca1:	89 d6                	mov    %edx,%esi
  801ca3:	89 c3                	mov    %eax,%ebx
  801ca5:	f7 e5                	mul    %ebp
  801ca7:	39 d6                	cmp    %edx,%esi
  801ca9:	72 19                	jb     801cc4 <__udivdi3+0xfc>
  801cab:	74 0b                	je     801cb8 <__udivdi3+0xf0>
  801cad:	89 d8                	mov    %ebx,%eax
  801caf:	31 ff                	xor    %edi,%edi
  801cb1:	e9 58 ff ff ff       	jmp    801c0e <__udivdi3+0x46>
  801cb6:	66 90                	xchg   %ax,%ax
  801cb8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cbc:	89 f9                	mov    %edi,%ecx
  801cbe:	d3 e2                	shl    %cl,%edx
  801cc0:	39 c2                	cmp    %eax,%edx
  801cc2:	73 e9                	jae    801cad <__udivdi3+0xe5>
  801cc4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cc7:	31 ff                	xor    %edi,%edi
  801cc9:	e9 40 ff ff ff       	jmp    801c0e <__udivdi3+0x46>
  801cce:	66 90                	xchg   %ax,%ax
  801cd0:	31 c0                	xor    %eax,%eax
  801cd2:	e9 37 ff ff ff       	jmp    801c0e <__udivdi3+0x46>
  801cd7:	90                   	nop

00801cd8 <__umoddi3>:
  801cd8:	55                   	push   %ebp
  801cd9:	57                   	push   %edi
  801cda:	56                   	push   %esi
  801cdb:	53                   	push   %ebx
  801cdc:	83 ec 1c             	sub    $0x1c,%esp
  801cdf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ce3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ce7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ceb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cf3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cf7:	89 f3                	mov    %esi,%ebx
  801cf9:	89 fa                	mov    %edi,%edx
  801cfb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cff:	89 34 24             	mov    %esi,(%esp)
  801d02:	85 c0                	test   %eax,%eax
  801d04:	75 1a                	jne    801d20 <__umoddi3+0x48>
  801d06:	39 f7                	cmp    %esi,%edi
  801d08:	0f 86 a2 00 00 00    	jbe    801db0 <__umoddi3+0xd8>
  801d0e:	89 c8                	mov    %ecx,%eax
  801d10:	89 f2                	mov    %esi,%edx
  801d12:	f7 f7                	div    %edi
  801d14:	89 d0                	mov    %edx,%eax
  801d16:	31 d2                	xor    %edx,%edx
  801d18:	83 c4 1c             	add    $0x1c,%esp
  801d1b:	5b                   	pop    %ebx
  801d1c:	5e                   	pop    %esi
  801d1d:	5f                   	pop    %edi
  801d1e:	5d                   	pop    %ebp
  801d1f:	c3                   	ret    
  801d20:	39 f0                	cmp    %esi,%eax
  801d22:	0f 87 ac 00 00 00    	ja     801dd4 <__umoddi3+0xfc>
  801d28:	0f bd e8             	bsr    %eax,%ebp
  801d2b:	83 f5 1f             	xor    $0x1f,%ebp
  801d2e:	0f 84 ac 00 00 00    	je     801de0 <__umoddi3+0x108>
  801d34:	bf 20 00 00 00       	mov    $0x20,%edi
  801d39:	29 ef                	sub    %ebp,%edi
  801d3b:	89 fe                	mov    %edi,%esi
  801d3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d41:	89 e9                	mov    %ebp,%ecx
  801d43:	d3 e0                	shl    %cl,%eax
  801d45:	89 d7                	mov    %edx,%edi
  801d47:	89 f1                	mov    %esi,%ecx
  801d49:	d3 ef                	shr    %cl,%edi
  801d4b:	09 c7                	or     %eax,%edi
  801d4d:	89 e9                	mov    %ebp,%ecx
  801d4f:	d3 e2                	shl    %cl,%edx
  801d51:	89 14 24             	mov    %edx,(%esp)
  801d54:	89 d8                	mov    %ebx,%eax
  801d56:	d3 e0                	shl    %cl,%eax
  801d58:	89 c2                	mov    %eax,%edx
  801d5a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d5e:	d3 e0                	shl    %cl,%eax
  801d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d64:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d68:	89 f1                	mov    %esi,%ecx
  801d6a:	d3 e8                	shr    %cl,%eax
  801d6c:	09 d0                	or     %edx,%eax
  801d6e:	d3 eb                	shr    %cl,%ebx
  801d70:	89 da                	mov    %ebx,%edx
  801d72:	f7 f7                	div    %edi
  801d74:	89 d3                	mov    %edx,%ebx
  801d76:	f7 24 24             	mull   (%esp)
  801d79:	89 c6                	mov    %eax,%esi
  801d7b:	89 d1                	mov    %edx,%ecx
  801d7d:	39 d3                	cmp    %edx,%ebx
  801d7f:	0f 82 87 00 00 00    	jb     801e0c <__umoddi3+0x134>
  801d85:	0f 84 91 00 00 00    	je     801e1c <__umoddi3+0x144>
  801d8b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d8f:	29 f2                	sub    %esi,%edx
  801d91:	19 cb                	sbb    %ecx,%ebx
  801d93:	89 d8                	mov    %ebx,%eax
  801d95:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d99:	d3 e0                	shl    %cl,%eax
  801d9b:	89 e9                	mov    %ebp,%ecx
  801d9d:	d3 ea                	shr    %cl,%edx
  801d9f:	09 d0                	or     %edx,%eax
  801da1:	89 e9                	mov    %ebp,%ecx
  801da3:	d3 eb                	shr    %cl,%ebx
  801da5:	89 da                	mov    %ebx,%edx
  801da7:	83 c4 1c             	add    $0x1c,%esp
  801daa:	5b                   	pop    %ebx
  801dab:	5e                   	pop    %esi
  801dac:	5f                   	pop    %edi
  801dad:	5d                   	pop    %ebp
  801dae:	c3                   	ret    
  801daf:	90                   	nop
  801db0:	89 fd                	mov    %edi,%ebp
  801db2:	85 ff                	test   %edi,%edi
  801db4:	75 0b                	jne    801dc1 <__umoddi3+0xe9>
  801db6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbb:	31 d2                	xor    %edx,%edx
  801dbd:	f7 f7                	div    %edi
  801dbf:	89 c5                	mov    %eax,%ebp
  801dc1:	89 f0                	mov    %esi,%eax
  801dc3:	31 d2                	xor    %edx,%edx
  801dc5:	f7 f5                	div    %ebp
  801dc7:	89 c8                	mov    %ecx,%eax
  801dc9:	f7 f5                	div    %ebp
  801dcb:	89 d0                	mov    %edx,%eax
  801dcd:	e9 44 ff ff ff       	jmp    801d16 <__umoddi3+0x3e>
  801dd2:	66 90                	xchg   %ax,%ax
  801dd4:	89 c8                	mov    %ecx,%eax
  801dd6:	89 f2                	mov    %esi,%edx
  801dd8:	83 c4 1c             	add    $0x1c,%esp
  801ddb:	5b                   	pop    %ebx
  801ddc:	5e                   	pop    %esi
  801ddd:	5f                   	pop    %edi
  801dde:	5d                   	pop    %ebp
  801ddf:	c3                   	ret    
  801de0:	3b 04 24             	cmp    (%esp),%eax
  801de3:	72 06                	jb     801deb <__umoddi3+0x113>
  801de5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801de9:	77 0f                	ja     801dfa <__umoddi3+0x122>
  801deb:	89 f2                	mov    %esi,%edx
  801ded:	29 f9                	sub    %edi,%ecx
  801def:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801df3:	89 14 24             	mov    %edx,(%esp)
  801df6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dfa:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dfe:	8b 14 24             	mov    (%esp),%edx
  801e01:	83 c4 1c             	add    $0x1c,%esp
  801e04:	5b                   	pop    %ebx
  801e05:	5e                   	pop    %esi
  801e06:	5f                   	pop    %edi
  801e07:	5d                   	pop    %ebp
  801e08:	c3                   	ret    
  801e09:	8d 76 00             	lea    0x0(%esi),%esi
  801e0c:	2b 04 24             	sub    (%esp),%eax
  801e0f:	19 fa                	sbb    %edi,%edx
  801e11:	89 d1                	mov    %edx,%ecx
  801e13:	89 c6                	mov    %eax,%esi
  801e15:	e9 71 ff ff ff       	jmp    801d8b <__umoddi3+0xb3>
  801e1a:	66 90                	xchg   %ax,%ax
  801e1c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e20:	72 ea                	jb     801e0c <__umoddi3+0x134>
  801e22:	89 d9                	mov    %ebx,%ecx
  801e24:	e9 62 ff ff ff       	jmp    801d8b <__umoddi3+0xb3>
