
obj/user/tst_sleeplock_master:     file format elf32-i386


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
  800031:	e8 73 02 00 00       	call   8002a9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create and run slaves, wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec fc 00 00 00    	sub    $0xfc,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800044:	83 ec 08             	sub    $0x8,%esp
  800047:	68 40 21 80 00       	push   $0x802140
  80004c:	6a 0e                	push   $0xe
  80004e:	e8 21 07 00 00       	call   800774 <cprintf_colored>
  800053:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	68 70 21 80 00       	push   $0x802170
  80005e:	6a 0e                	push   $0xe
  800060:	e8 0f 07 00 00       	call   800774 <cprintf_colored>
  800065:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	68 40 21 80 00       	push   $0x802140
  800070:	6a 0e                	push   $0xe
  800072:	e8 fd 06 00 00       	call   800774 <cprintf_colored>
  800077:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80007a:	e8 84 1a 00 00       	call   801b03 <sys_getenvid>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	char slavesCnt[10];
	readline("Enter the number of Slave Programs: ", slavesCnt);
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	8d 45 ce             	lea    -0x32(%ebp),%eax
  800088:	50                   	push   %eax
  800089:	68 cc 21 80 00       	push   $0x8021cc
  80008e:	e8 8d 0d 00 00       	call   800e20 <readline>
  800093:	83 c4 10             	add    $0x10,%esp
	int numOfSlaves = strtol(slavesCnt, NULL, 10);
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	6a 00                	push   $0x0
  80009d:	8d 45 ce             	lea    -0x32(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 91 13 00 00       	call   801437 <strtol>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//Save number of slaved to be checked later
	char cmd1[64] = "__NumOfSlaves@Set";
  8000ac:	8d 45 88             	lea    -0x78(%ebp),%eax
  8000af:	bb 64 23 80 00       	mov    $0x802364,%ebx
  8000b4:	ba 12 00 00 00       	mov    $0x12,%edx
  8000b9:	89 c7                	mov    %eax,%edi
  8000bb:	89 de                	mov    %ebx,%esi
  8000bd:	89 d1                	mov    %edx,%ecx
  8000bf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000c1:	8d 55 9a             	lea    -0x66(%ebp),%edx
  8000c4:	b9 2e 00 00 00       	mov    $0x2e,%ecx
  8000c9:	b0 00                	mov    $0x0,%al
  8000cb:	89 d7                	mov    %edx,%edi
  8000cd:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd1, (uint32)(&numOfSlaves));
  8000cf:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	50                   	push   %eax
  8000d6:	8d 45 88             	lea    -0x78(%ebp),%eax
  8000d9:	50                   	push   %eax
  8000da:	e8 73 1c 00 00       	call   801d52 <sys_utilities>
  8000df:	83 c4 10             	add    $0x10,%esp

	rsttst();
  8000e2:	e8 13 1b 00 00       	call   801bfa <rsttst>

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  8000e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000ee:	eb 6a                	jmp    80015a <_main+0x122>
	{
		id = sys_create_env("tstSleepLockSlave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f5:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  8000fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800100:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800106:	89 c1                	mov    %eax,%ecx
  800108:	a1 20 30 80 00       	mov    0x803020,%eax
  80010d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800113:	52                   	push   %edx
  800114:	51                   	push   %ecx
  800115:	50                   	push   %eax
  800116:	68 f1 21 80 00       	push   $0x8021f1
  80011b:	e8 8e 19 00 00       	call   801aae <sys_create_env>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (id== E_ENV_CREATION_ERROR)
  800126:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  80012a:	75 1d                	jne    800149 <_main+0x111>
		{
			cprintf_colored(TEXT_TESTERR_CLR,"\n%~insufficient number of processes in the system! only %d slave processes are created\n", i);
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800132:	68 04 22 80 00       	push   $0x802204
  800137:	6a 0c                	push   $0xc
  800139:	e8 36 06 00 00       	call   800774 <cprintf_colored>
  80013e:	83 c4 10             	add    $0x10,%esp
			numOfSlaves = i;
  800141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800144:	89 45 c8             	mov    %eax,-0x38(%ebp)
			break;
  800147:	eb 19                	jmp    800162 <_main+0x12a>
		}
		sys_run_env(id);
  800149:	83 ec 0c             	sub    $0xc,%esp
  80014c:	ff 75 d8             	pushl  -0x28(%ebp)
  80014f:	e8 78 19 00 00       	call   801acc <sys_run_env>
  800154:	83 c4 10             	add    $0x10,%esp

	rsttst();

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  800157:	ff 45 e4             	incl   -0x1c(%ebp)
  80015a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80015d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800160:	7c 8e                	jl     8000f0 <_main+0xb8>
		}
		sys_run_env(id);
	}

	//Wait until all slaves, except the one inside C.S., are blocked
	int numOfBlockedProcesses = 0;
  800162:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
	char cmd2[64] = "__GetLockQueueSize__";
  800169:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  80016f:	bb a4 23 80 00       	mov    $0x8023a4,%ebx
  800174:	ba 15 00 00 00       	mov    $0x15,%edx
  800179:	89 c7                	mov    %eax,%edi
  80017b:	89 de                	mov    %ebx,%esi
  80017d:	89 d1                	mov    %edx,%ecx
  80017f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800181:	8d 95 59 ff ff ff    	lea    -0xa7(%ebp),%edx
  800187:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  80018c:	b0 00                	mov    $0x0,%al
  80018e:	89 d7                	mov    %edx,%edi
  800190:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
  800192:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	50                   	push   %eax
  800199:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  80019f:	50                   	push   %eax
  8001a0:	e8 ad 1b 00 00       	call   801d52 <sys_utilities>
  8001a5:	83 c4 10             	add    $0x10,%esp
	int cnt = 0;
  8001a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	while (numOfBlockedProcesses != numOfSlaves-1)
  8001af:	eb 77                	jmp    800228 <_main+0x1f0>
	{
		env_sleep(5000);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 88 13 00 00       	push   $0x1388
  8001b9:	e8 21 1c 00 00       	call   801ddf <env_sleep>
  8001be:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  8001c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001c4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8001c7:	75 1d                	jne    8001e6 <_main+0x1ae>
		{
			panic("%~test sleeplock failed! unexpected number of blocked slaves. Expected = %d, Current = %d", numOfSlaves-1, numOfBlockedProcesses);
  8001c9:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8001cc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8001cf:	4a                   	dec    %edx
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	50                   	push   %eax
  8001d4:	52                   	push   %edx
  8001d5:	68 5c 22 80 00       	push   $0x80225c
  8001da:	6a 2f                	push   $0x2f
  8001dc:	68 b6 22 80 00       	push   $0x8022b6
  8001e1:	e8 73 02 00 00       	call   800459 <_panic>
		}
		char cmd3[64] = "__GetLockQueueSize__";
  8001e6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  8001ec:	bb a4 23 80 00       	mov    $0x8023a4,%ebx
  8001f1:	ba 15 00 00 00       	mov    $0x15,%edx
  8001f6:	89 c7                	mov    %eax,%edi
  8001f8:	89 de                	mov    %ebx,%esi
  8001fa:	89 d1                	mov    %edx,%ecx
  8001fc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001fe:	8d 95 19 ff ff ff    	lea    -0xe7(%ebp),%edx
  800204:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  800209:	b0 00                	mov    $0x0,%al
  80020b:	89 d7                	mov    %edx,%edi
  80020d:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(cmd3, (uint32)(&numOfBlockedProcesses));
  80020f:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800212:	83 ec 08             	sub    $0x8,%esp
  800215:	50                   	push   %eax
  800216:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  80021c:	50                   	push   %eax
  80021d:	e8 30 1b 00 00       	call   801d52 <sys_utilities>
  800222:	83 c4 10             	add    $0x10,%esp
		cnt++ ;
  800225:	ff 45 e0             	incl   -0x20(%ebp)
	//Wait until all slaves, except the one inside C.S., are blocked
	int numOfBlockedProcesses = 0;
	char cmd2[64] = "__GetLockQueueSize__";
	sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
	int cnt = 0;
	while (numOfBlockedProcesses != numOfSlaves-1)
  800228:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80022b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80022e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800231:	39 c2                	cmp    %eax,%edx
  800233:	0f 85 78 ff ff ff    	jne    8001b1 <_main+0x179>
		cnt++ ;
	}
	//cprintf("\numOfBlockedProcesses = %d\n", numOfBlockedProcesses);

	//signal the slave inside the critical section to leave it
	inctst();
  800239:	e8 1c 1a 00 00       	call   801c5a <inctst>

	//Wait until all slave finished
	cnt = 0;
  80023e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	while (gettst() != numOfSlaves +1/*since master already increment it by 1*/)
  800245:	eb 3a                	jmp    800281 <_main+0x249>
	{
		env_sleep(15000);
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	68 98 3a 00 00       	push   $0x3a98
  80024f:	e8 8b 1b 00 00       	call   801ddf <env_sleep>
  800254:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  800257:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80025a:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  80025d:	75 1f                	jne    80027e <_main+0x246>
		{
			panic("%~test sleeplock failed! not all processes finished. Expected %d, Actual %d", numOfSlaves +1, gettst());
  80025f:	e8 10 1a 00 00       	call   801c74 <gettst>
  800264:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800267:	42                   	inc    %edx
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	50                   	push   %eax
  80026c:	52                   	push   %edx
  80026d:	68 d4 22 80 00       	push   $0x8022d4
  800272:	6a 41                	push   $0x41
  800274:	68 b6 22 80 00       	push   $0x8022b6
  800279:	e8 db 01 00 00       	call   800459 <_panic>
		}
		cnt++ ;
  80027e:	ff 45 e0             	incl   -0x20(%ebp)
	//signal the slave inside the critical section to leave it
	inctst();

	//Wait until all slave finished
	cnt = 0;
	while (gettst() != numOfSlaves +1/*since master already increment it by 1*/)
  800281:	e8 ee 19 00 00       	call   801c74 <gettst>
  800286:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800289:	42                   	inc    %edx
  80028a:	39 d0                	cmp    %edx,%eax
  80028c:	75 b9                	jne    800247 <_main+0x20f>
			panic("%~test sleeplock failed! not all processes finished. Expected %d, Actual %d", numOfSlaves +1, gettst());
		}
		cnt++ ;
	}

	cprintf_colored(TEXT_light_green, "%~\n\nCongratulations!! Test of Sleep Lock completed successfully!!\n\n");
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	68 20 23 80 00       	push   $0x802320
  800296:	6a 0a                	push   $0xa
  800298:	e8 d7 04 00 00       	call   800774 <cprintf_colored>
  80029d:	83 c4 10             	add    $0x10,%esp
}
  8002a0:	90                   	nop
  8002a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a4:	5b                   	pop    %ebx
  8002a5:	5e                   	pop    %esi
  8002a6:	5f                   	pop    %edi
  8002a7:	5d                   	pop    %ebp
  8002a8:	c3                   	ret    

008002a9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002b2:	e8 65 18 00 00       	call   801b1c <sys_getenvindex>
  8002b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002bd:	89 d0                	mov    %edx,%eax
  8002bf:	01 c0                	add    %eax,%eax
  8002c1:	01 d0                	add    %edx,%eax
  8002c3:	c1 e0 02             	shl    $0x2,%eax
  8002c6:	01 d0                	add    %edx,%eax
  8002c8:	c1 e0 02             	shl    $0x2,%eax
  8002cb:	01 d0                	add    %edx,%eax
  8002cd:	c1 e0 03             	shl    $0x3,%eax
  8002d0:	01 d0                	add    %edx,%eax
  8002d2:	c1 e0 02             	shl    $0x2,%eax
  8002d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002da:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002df:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e4:	8a 40 20             	mov    0x20(%eax),%al
  8002e7:	84 c0                	test   %al,%al
  8002e9:	74 0d                	je     8002f8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f0:	83 c0 20             	add    $0x20,%eax
  8002f3:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002fc:	7e 0a                	jle    800308 <libmain+0x5f>
		binaryname = argv[0];
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	8b 00                	mov    (%eax),%eax
  800303:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	ff 75 0c             	pushl  0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 22 fd ff ff       	call   800038 <_main>
  800316:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800319:	a1 00 30 80 00       	mov    0x803000,%eax
  80031e:	85 c0                	test   %eax,%eax
  800320:	0f 84 01 01 00 00    	je     800427 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800326:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80032c:	bb dc 24 80 00       	mov    $0x8024dc,%ebx
  800331:	ba 0e 00 00 00       	mov    $0xe,%edx
  800336:	89 c7                	mov    %eax,%edi
  800338:	89 de                	mov    %ebx,%esi
  80033a:	89 d1                	mov    %edx,%ecx
  80033c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80033e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800341:	b9 56 00 00 00       	mov    $0x56,%ecx
  800346:	b0 00                	mov    $0x0,%al
  800348:	89 d7                	mov    %edx,%edi
  80034a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80034c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800353:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	50                   	push   %eax
  80035a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800360:	50                   	push   %eax
  800361:	e8 ec 19 00 00       	call   801d52 <sys_utilities>
  800366:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800369:	e8 35 15 00 00       	call   8018a3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80036e:	83 ec 0c             	sub    $0xc,%esp
  800371:	68 fc 23 80 00       	push   $0x8023fc
  800376:	e8 cc 03 00 00       	call   800747 <cprintf>
  80037b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80037e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800381:	85 c0                	test   %eax,%eax
  800383:	74 18                	je     80039d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800385:	e8 e6 19 00 00       	call   801d70 <sys_get_optimal_num_faults>
  80038a:	83 ec 08             	sub    $0x8,%esp
  80038d:	50                   	push   %eax
  80038e:	68 24 24 80 00       	push   $0x802424
  800393:	e8 af 03 00 00       	call   800747 <cprintf>
  800398:	83 c4 10             	add    $0x10,%esp
  80039b:	eb 59                	jmp    8003f6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80039d:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a2:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8003a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ad:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8003b3:	83 ec 04             	sub    $0x4,%esp
  8003b6:	52                   	push   %edx
  8003b7:	50                   	push   %eax
  8003b8:	68 48 24 80 00       	push   $0x802448
  8003bd:	e8 85 03 00 00       	call   800747 <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ca:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8003d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d5:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8003db:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e0:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8003e6:	51                   	push   %ecx
  8003e7:	52                   	push   %edx
  8003e8:	50                   	push   %eax
  8003e9:	68 70 24 80 00       	push   $0x802470
  8003ee:	e8 54 03 00 00       	call   800747 <cprintf>
  8003f3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fb:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800401:	83 ec 08             	sub    $0x8,%esp
  800404:	50                   	push   %eax
  800405:	68 c8 24 80 00       	push   $0x8024c8
  80040a:	e8 38 03 00 00       	call   800747 <cprintf>
  80040f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800412:	83 ec 0c             	sub    $0xc,%esp
  800415:	68 fc 23 80 00       	push   $0x8023fc
  80041a:	e8 28 03 00 00       	call   800747 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800422:	e8 96 14 00 00       	call   8018bd <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800427:	e8 1f 00 00 00       	call   80044b <exit>
}
  80042c:	90                   	nop
  80042d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800430:	5b                   	pop    %ebx
  800431:	5e                   	pop    %esi
  800432:	5f                   	pop    %edi
  800433:	5d                   	pop    %ebp
  800434:	c3                   	ret    

00800435 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
  800438:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80043b:	83 ec 0c             	sub    $0xc,%esp
  80043e:	6a 00                	push   $0x0
  800440:	e8 a3 16 00 00       	call   801ae8 <sys_destroy_env>
  800445:	83 c4 10             	add    $0x10,%esp
}
  800448:	90                   	nop
  800449:	c9                   	leave  
  80044a:	c3                   	ret    

0080044b <exit>:

void
exit(void)
{
  80044b:	55                   	push   %ebp
  80044c:	89 e5                	mov    %esp,%ebp
  80044e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800451:	e8 f8 16 00 00       	call   801b4e <sys_exit_env>
}
  800456:	90                   	nop
  800457:	c9                   	leave  
  800458:	c3                   	ret    

00800459 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80045f:	8d 45 10             	lea    0x10(%ebp),%eax
  800462:	83 c0 04             	add    $0x4,%eax
  800465:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800468:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80046d:	85 c0                	test   %eax,%eax
  80046f:	74 16                	je     800487 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800471:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	50                   	push   %eax
  80047a:	68 40 25 80 00       	push   $0x802540
  80047f:	e8 c3 02 00 00       	call   800747 <cprintf>
  800484:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800487:	a1 04 30 80 00       	mov    0x803004,%eax
  80048c:	83 ec 0c             	sub    $0xc,%esp
  80048f:	ff 75 0c             	pushl  0xc(%ebp)
  800492:	ff 75 08             	pushl  0x8(%ebp)
  800495:	50                   	push   %eax
  800496:	68 48 25 80 00       	push   $0x802548
  80049b:	6a 74                	push   $0x74
  80049d:	e8 d2 02 00 00       	call   800774 <cprintf_colored>
  8004a2:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ae:	50                   	push   %eax
  8004af:	e8 24 02 00 00       	call   8006d8 <vcprintf>
  8004b4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	6a 00                	push   $0x0
  8004bc:	68 70 25 80 00       	push   $0x802570
  8004c1:	e8 12 02 00 00       	call   8006d8 <vcprintf>
  8004c6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004c9:	e8 7d ff ff ff       	call   80044b <exit>

	// should not return here
	while (1) ;
  8004ce:	eb fe                	jmp    8004ce <_panic+0x75>

008004d0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	53                   	push   %ebx
  8004d4:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8004dc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e5:	39 c2                	cmp    %eax,%edx
  8004e7:	74 14                	je     8004fd <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	68 74 25 80 00       	push   $0x802574
  8004f1:	6a 26                	push   $0x26
  8004f3:	68 c0 25 80 00       	push   $0x8025c0
  8004f8:	e8 5c ff ff ff       	call   800459 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800504:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80050b:	e9 d9 00 00 00       	jmp    8005e9 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800510:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800513:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	01 d0                	add    %edx,%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	85 c0                	test   %eax,%eax
  800523:	75 08                	jne    80052d <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800525:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800528:	e9 b9 00 00 00       	jmp    8005e6 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80052d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800534:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80053b:	eb 79                	jmp    8005b6 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80053d:	a1 20 30 80 00       	mov    0x803020,%eax
  800542:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800548:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80054b:	89 d0                	mov    %edx,%eax
  80054d:	01 c0                	add    %eax,%eax
  80054f:	01 d0                	add    %edx,%eax
  800551:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800558:	01 d8                	add    %ebx,%eax
  80055a:	01 d0                	add    %edx,%eax
  80055c:	01 c8                	add    %ecx,%eax
  80055e:	8a 40 04             	mov    0x4(%eax),%al
  800561:	84 c0                	test   %al,%al
  800563:	75 4e                	jne    8005b3 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800565:	a1 20 30 80 00       	mov    0x803020,%eax
  80056a:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800570:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800573:	89 d0                	mov    %edx,%eax
  800575:	01 c0                	add    %eax,%eax
  800577:	01 d0                	add    %edx,%eax
  800579:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800580:	01 d8                	add    %ebx,%eax
  800582:	01 d0                	add    %edx,%eax
  800584:	01 c8                	add    %ecx,%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80058b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80058e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800593:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800598:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80059f:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a2:	01 c8                	add    %ecx,%eax
  8005a4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a6:	39 c2                	cmp    %eax,%edx
  8005a8:	75 09                	jne    8005b3 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8005aa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005b1:	eb 19                	jmp    8005cc <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b3:	ff 45 e8             	incl   -0x18(%ebp)
  8005b6:	a1 20 30 80 00       	mov    0x803020,%eax
  8005bb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c4:	39 c2                	cmp    %eax,%edx
  8005c6:	0f 87 71 ff ff ff    	ja     80053d <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005d0:	75 14                	jne    8005e6 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8005d2:	83 ec 04             	sub    $0x4,%esp
  8005d5:	68 cc 25 80 00       	push   $0x8025cc
  8005da:	6a 3a                	push   $0x3a
  8005dc:	68 c0 25 80 00       	push   $0x8025c0
  8005e1:	e8 73 fe ff ff       	call   800459 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005e6:	ff 45 f0             	incl   -0x10(%ebp)
  8005e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005ef:	0f 8c 1b ff ff ff    	jl     800510 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800603:	eb 2e                	jmp    800633 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800605:	a1 20 30 80 00       	mov    0x803020,%eax
  80060a:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800610:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800613:	89 d0                	mov    %edx,%eax
  800615:	01 c0                	add    %eax,%eax
  800617:	01 d0                	add    %edx,%eax
  800619:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800620:	01 d8                	add    %ebx,%eax
  800622:	01 d0                	add    %edx,%eax
  800624:	01 c8                	add    %ecx,%eax
  800626:	8a 40 04             	mov    0x4(%eax),%al
  800629:	3c 01                	cmp    $0x1,%al
  80062b:	75 03                	jne    800630 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  80062d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800630:	ff 45 e0             	incl   -0x20(%ebp)
  800633:	a1 20 30 80 00       	mov    0x803020,%eax
  800638:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80063e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800641:	39 c2                	cmp    %eax,%edx
  800643:	77 c0                	ja     800605 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800648:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80064b:	74 14                	je     800661 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  80064d:	83 ec 04             	sub    $0x4,%esp
  800650:	68 20 26 80 00       	push   $0x802620
  800655:	6a 44                	push   $0x44
  800657:	68 c0 25 80 00       	push   $0x8025c0
  80065c:	e8 f8 fd ff ff       	call   800459 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800661:	90                   	nop
  800662:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
  80066a:	53                   	push   %ebx
  80066b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80066e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	8d 48 01             	lea    0x1(%eax),%ecx
  800676:	8b 55 0c             	mov    0xc(%ebp),%edx
  800679:	89 0a                	mov    %ecx,(%edx)
  80067b:	8b 55 08             	mov    0x8(%ebp),%edx
  80067e:	88 d1                	mov    %dl,%cl
  800680:	8b 55 0c             	mov    0xc(%ebp),%edx
  800683:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800691:	75 30                	jne    8006c3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800693:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800699:	a0 44 30 80 00       	mov    0x803044,%al
  80069e:	0f b6 c0             	movzbl %al,%eax
  8006a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006a4:	8b 09                	mov    (%ecx),%ecx
  8006a6:	89 cb                	mov    %ecx,%ebx
  8006a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ab:	83 c1 08             	add    $0x8,%ecx
  8006ae:	52                   	push   %edx
  8006af:	50                   	push   %eax
  8006b0:	53                   	push   %ebx
  8006b1:	51                   	push   %ecx
  8006b2:	e8 a8 11 00 00       	call   80185f <sys_cputs>
  8006b7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c6:	8b 40 04             	mov    0x4(%eax),%eax
  8006c9:	8d 50 01             	lea    0x1(%eax),%edx
  8006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cf:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006d2:	90                   	nop
  8006d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006d6:	c9                   	leave  
  8006d7:	c3                   	ret    

008006d8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d8:	55                   	push   %ebp
  8006d9:	89 e5                	mov    %esp,%ebp
  8006db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e8:	00 00 00 
	b.cnt = 0;
  8006eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006f2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	ff 75 08             	pushl  0x8(%ebp)
  8006fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800701:	50                   	push   %eax
  800702:	68 67 06 80 00       	push   $0x800667
  800707:	e8 5a 02 00 00       	call   800966 <vprintfmt>
  80070c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80070f:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800715:	a0 44 30 80 00       	mov    0x803044,%al
  80071a:	0f b6 c0             	movzbl %al,%eax
  80071d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800723:	52                   	push   %edx
  800724:	50                   	push   %eax
  800725:	51                   	push   %ecx
  800726:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072c:	83 c0 08             	add    $0x8,%eax
  80072f:	50                   	push   %eax
  800730:	e8 2a 11 00 00       	call   80185f <sys_cputs>
  800735:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800738:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80073f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800745:	c9                   	leave  
  800746:	c3                   	ret    

00800747 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800747:	55                   	push   %ebp
  800748:	89 e5                	mov    %esp,%ebp
  80074a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80074d:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800754:	8d 45 0c             	lea    0xc(%ebp),%eax
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 f4             	pushl  -0xc(%ebp)
  800763:	50                   	push   %eax
  800764:	e8 6f ff ff ff       	call   8006d8 <vcprintf>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80076f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800772:	c9                   	leave  
  800773:	c3                   	ret    

00800774 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80077a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	c1 e0 08             	shl    $0x8,%eax
  800787:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80078c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80078f:	83 c0 04             	add    $0x4,%eax
  800792:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800795:	8b 45 0c             	mov    0xc(%ebp),%eax
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	ff 75 f4             	pushl  -0xc(%ebp)
  80079e:	50                   	push   %eax
  80079f:	e8 34 ff ff ff       	call   8006d8 <vcprintf>
  8007a4:	83 c4 10             	add    $0x10,%esp
  8007a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007aa:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007b1:	07 00 00 

	return cnt;
  8007b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b7:	c9                   	leave  
  8007b8:	c3                   	ret    

008007b9 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007bf:	e8 df 10 00 00       	call   8018a3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007c4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d3:	50                   	push   %eax
  8007d4:	e8 ff fe ff ff       	call   8006d8 <vcprintf>
  8007d9:	83 c4 10             	add    $0x10,%esp
  8007dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007df:	e8 d9 10 00 00       	call   8018bd <sys_unlock_cons>
	return cnt;
  8007e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e7:	c9                   	leave  
  8007e8:	c3                   	ret    

008007e9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	53                   	push   %ebx
  8007ed:	83 ec 14             	sub    $0x14,%esp
  8007f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007fc:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800804:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800807:	77 55                	ja     80085e <printnum+0x75>
  800809:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080c:	72 05                	jb     800813 <printnum+0x2a>
  80080e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800811:	77 4b                	ja     80085e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800813:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800816:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800819:	8b 45 18             	mov    0x18(%ebp),%eax
  80081c:	ba 00 00 00 00       	mov    $0x0,%edx
  800821:	52                   	push   %edx
  800822:	50                   	push   %eax
  800823:	ff 75 f4             	pushl  -0xc(%ebp)
  800826:	ff 75 f0             	pushl  -0x10(%ebp)
  800829:	e8 ae 16 00 00       	call   801edc <__udivdi3>
  80082e:	83 c4 10             	add    $0x10,%esp
  800831:	83 ec 04             	sub    $0x4,%esp
  800834:	ff 75 20             	pushl  0x20(%ebp)
  800837:	53                   	push   %ebx
  800838:	ff 75 18             	pushl  0x18(%ebp)
  80083b:	52                   	push   %edx
  80083c:	50                   	push   %eax
  80083d:	ff 75 0c             	pushl  0xc(%ebp)
  800840:	ff 75 08             	pushl  0x8(%ebp)
  800843:	e8 a1 ff ff ff       	call   8007e9 <printnum>
  800848:	83 c4 20             	add    $0x20,%esp
  80084b:	eb 1a                	jmp    800867 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	ff 75 0c             	pushl  0xc(%ebp)
  800853:	ff 75 20             	pushl  0x20(%ebp)
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	ff d0                	call   *%eax
  80085b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085e:	ff 4d 1c             	decl   0x1c(%ebp)
  800861:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800865:	7f e6                	jg     80084d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800867:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80086a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80086f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800875:	53                   	push   %ebx
  800876:	51                   	push   %ecx
  800877:	52                   	push   %edx
  800878:	50                   	push   %eax
  800879:	e8 6e 17 00 00       	call   801fec <__umoddi3>
  80087e:	83 c4 10             	add    $0x10,%esp
  800881:	05 94 28 80 00       	add    $0x802894,%eax
  800886:	8a 00                	mov    (%eax),%al
  800888:	0f be c0             	movsbl %al,%eax
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	ff 75 0c             	pushl  0xc(%ebp)
  800891:	50                   	push   %eax
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	ff d0                	call   *%eax
  800897:	83 c4 10             	add    $0x10,%esp
}
  80089a:	90                   	nop
  80089b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089e:	c9                   	leave  
  80089f:	c3                   	ret    

008008a0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a7:	7e 1c                	jle    8008c5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	8b 00                	mov    (%eax),%eax
  8008ae:	8d 50 08             	lea    0x8(%eax),%edx
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	89 10                	mov    %edx,(%eax)
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	83 e8 08             	sub    $0x8,%eax
  8008be:	8b 50 04             	mov    0x4(%eax),%edx
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	eb 40                	jmp    800905 <getuint+0x65>
	else if (lflag)
  8008c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c9:	74 1e                	je     8008e9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	8d 50 04             	lea    0x4(%eax),%edx
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	89 10                	mov    %edx,(%eax)
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	83 e8 04             	sub    $0x4,%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e7:	eb 1c                	jmp    800905 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	8d 50 04             	lea    0x4(%eax),%edx
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	89 10                	mov    %edx,(%eax)
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	83 e8 04             	sub    $0x4,%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80090a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090e:	7e 1c                	jle    80092c <getint+0x25>
		return va_arg(*ap, long long);
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	8d 50 08             	lea    0x8(%eax),%edx
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	89 10                	mov    %edx,(%eax)
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	83 e8 08             	sub    $0x8,%eax
  800925:	8b 50 04             	mov    0x4(%eax),%edx
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	eb 38                	jmp    800964 <getint+0x5d>
	else if (lflag)
  80092c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800930:	74 1a                	je     80094c <getint+0x45>
		return va_arg(*ap, long);
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	8d 50 04             	lea    0x4(%eax),%edx
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	89 10                	mov    %edx,(%eax)
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	83 e8 04             	sub    $0x4,%eax
  800947:	8b 00                	mov    (%eax),%eax
  800949:	99                   	cltd   
  80094a:	eb 18                	jmp    800964 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 10                	mov    %edx,(%eax)
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	83 e8 04             	sub    $0x4,%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	99                   	cltd   
}
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    

00800966 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	56                   	push   %esi
  80096a:	53                   	push   %ebx
  80096b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096e:	eb 17                	jmp    800987 <vprintfmt+0x21>
			if (ch == '\0')
  800970:	85 db                	test   %ebx,%ebx
  800972:	0f 84 c1 03 00 00    	je     800d39 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	53                   	push   %ebx
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	ff d0                	call   *%eax
  800984:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800987:	8b 45 10             	mov    0x10(%ebp),%eax
  80098a:	8d 50 01             	lea    0x1(%eax),%edx
  80098d:	89 55 10             	mov    %edx,0x10(%ebp)
  800990:	8a 00                	mov    (%eax),%al
  800992:	0f b6 d8             	movzbl %al,%ebx
  800995:	83 fb 25             	cmp    $0x25,%ebx
  800998:	75 d6                	jne    800970 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80099a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80099e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009b3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bd:	8d 50 01             	lea    0x1(%eax),%edx
  8009c0:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c3:	8a 00                	mov    (%eax),%al
  8009c5:	0f b6 d8             	movzbl %al,%ebx
  8009c8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009cb:	83 f8 5b             	cmp    $0x5b,%eax
  8009ce:	0f 87 3d 03 00 00    	ja     800d11 <vprintfmt+0x3ab>
  8009d4:	8b 04 85 b8 28 80 00 	mov    0x8028b8(,%eax,4),%eax
  8009db:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009dd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009e1:	eb d7                	jmp    8009ba <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e7:	eb d1                	jmp    8009ba <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f3:	89 d0                	mov    %edx,%eax
  8009f5:	c1 e0 02             	shl    $0x2,%eax
  8009f8:	01 d0                	add    %edx,%eax
  8009fa:	01 c0                	add    %eax,%eax
  8009fc:	01 d8                	add    %ebx,%eax
  8009fe:	83 e8 30             	sub    $0x30,%eax
  800a01:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a04:	8b 45 10             	mov    0x10(%ebp),%eax
  800a07:	8a 00                	mov    (%eax),%al
  800a09:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a0c:	83 fb 2f             	cmp    $0x2f,%ebx
  800a0f:	7e 3e                	jle    800a4f <vprintfmt+0xe9>
  800a11:	83 fb 39             	cmp    $0x39,%ebx
  800a14:	7f 39                	jg     800a4f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a16:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a19:	eb d5                	jmp    8009f0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1e:	83 c0 04             	add    $0x4,%eax
  800a21:	89 45 14             	mov    %eax,0x14(%ebp)
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	83 e8 04             	sub    $0x4,%eax
  800a2a:	8b 00                	mov    (%eax),%eax
  800a2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a2f:	eb 1f                	jmp    800a50 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a35:	79 83                	jns    8009ba <vprintfmt+0x54>
				width = 0;
  800a37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a3e:	e9 77 ff ff ff       	jmp    8009ba <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a43:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a4a:	e9 6b ff ff ff       	jmp    8009ba <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a4f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a54:	0f 89 60 ff ff ff    	jns    8009ba <vprintfmt+0x54>
				width = precision, precision = -1;
  800a5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a60:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a67:	e9 4e ff ff ff       	jmp    8009ba <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a6c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a6f:	e9 46 ff ff ff       	jmp    8009ba <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	83 c0 04             	add    $0x4,%eax
  800a7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a80:	83 e8 04             	sub    $0x4,%eax
  800a83:	8b 00                	mov    (%eax),%eax
  800a85:	83 ec 08             	sub    $0x8,%esp
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	50                   	push   %eax
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	ff d0                	call   *%eax
  800a91:	83 c4 10             	add    $0x10,%esp
			break;
  800a94:	e9 9b 02 00 00       	jmp    800d34 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a99:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9c:	83 c0 04             	add    $0x4,%eax
  800a9f:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa5:	83 e8 04             	sub    $0x4,%eax
  800aa8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aaa:	85 db                	test   %ebx,%ebx
  800aac:	79 02                	jns    800ab0 <vprintfmt+0x14a>
				err = -err;
  800aae:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ab0:	83 fb 64             	cmp    $0x64,%ebx
  800ab3:	7f 0b                	jg     800ac0 <vprintfmt+0x15a>
  800ab5:	8b 34 9d 00 27 80 00 	mov    0x802700(,%ebx,4),%esi
  800abc:	85 f6                	test   %esi,%esi
  800abe:	75 19                	jne    800ad9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ac0:	53                   	push   %ebx
  800ac1:	68 a5 28 80 00       	push   $0x8028a5
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	ff 75 08             	pushl  0x8(%ebp)
  800acc:	e8 70 02 00 00       	call   800d41 <printfmt>
  800ad1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad4:	e9 5b 02 00 00       	jmp    800d34 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad9:	56                   	push   %esi
  800ada:	68 ae 28 80 00       	push   $0x8028ae
  800adf:	ff 75 0c             	pushl  0xc(%ebp)
  800ae2:	ff 75 08             	pushl  0x8(%ebp)
  800ae5:	e8 57 02 00 00       	call   800d41 <printfmt>
  800aea:	83 c4 10             	add    $0x10,%esp
			break;
  800aed:	e9 42 02 00 00       	jmp    800d34 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800af2:	8b 45 14             	mov    0x14(%ebp),%eax
  800af5:	83 c0 04             	add    $0x4,%eax
  800af8:	89 45 14             	mov    %eax,0x14(%ebp)
  800afb:	8b 45 14             	mov    0x14(%ebp),%eax
  800afe:	83 e8 04             	sub    $0x4,%eax
  800b01:	8b 30                	mov    (%eax),%esi
  800b03:	85 f6                	test   %esi,%esi
  800b05:	75 05                	jne    800b0c <vprintfmt+0x1a6>
				p = "(null)";
  800b07:	be b1 28 80 00       	mov    $0x8028b1,%esi
			if (width > 0 && padc != '-')
  800b0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b10:	7e 6d                	jle    800b7f <vprintfmt+0x219>
  800b12:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b16:	74 67                	je     800b7f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b1b:	83 ec 08             	sub    $0x8,%esp
  800b1e:	50                   	push   %eax
  800b1f:	56                   	push   %esi
  800b20:	e8 26 05 00 00       	call   80104b <strnlen>
  800b25:	83 c4 10             	add    $0x10,%esp
  800b28:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b2b:	eb 16                	jmp    800b43 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b2d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	50                   	push   %eax
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	ff d0                	call   *%eax
  800b3d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b40:	ff 4d e4             	decl   -0x1c(%ebp)
  800b43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b47:	7f e4                	jg     800b2d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b49:	eb 34                	jmp    800b7f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b4f:	74 1c                	je     800b6d <vprintfmt+0x207>
  800b51:	83 fb 1f             	cmp    $0x1f,%ebx
  800b54:	7e 05                	jle    800b5b <vprintfmt+0x1f5>
  800b56:	83 fb 7e             	cmp    $0x7e,%ebx
  800b59:	7e 12                	jle    800b6d <vprintfmt+0x207>
					putch('?', putdat);
  800b5b:	83 ec 08             	sub    $0x8,%esp
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	6a 3f                	push   $0x3f
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	ff d0                	call   *%eax
  800b68:	83 c4 10             	add    $0x10,%esp
  800b6b:	eb 0f                	jmp    800b7c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	53                   	push   %ebx
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	ff d0                	call   *%eax
  800b79:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7f:	89 f0                	mov    %esi,%eax
  800b81:	8d 70 01             	lea    0x1(%eax),%esi
  800b84:	8a 00                	mov    (%eax),%al
  800b86:	0f be d8             	movsbl %al,%ebx
  800b89:	85 db                	test   %ebx,%ebx
  800b8b:	74 24                	je     800bb1 <vprintfmt+0x24b>
  800b8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b91:	78 b8                	js     800b4b <vprintfmt+0x1e5>
  800b93:	ff 4d e0             	decl   -0x20(%ebp)
  800b96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b9a:	79 af                	jns    800b4b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9c:	eb 13                	jmp    800bb1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b9e:	83 ec 08             	sub    $0x8,%esp
  800ba1:	ff 75 0c             	pushl  0xc(%ebp)
  800ba4:	6a 20                	push   $0x20
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	ff d0                	call   *%eax
  800bab:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bae:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb5:	7f e7                	jg     800b9e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb7:	e9 78 01 00 00       	jmp    800d34 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bbc:	83 ec 08             	sub    $0x8,%esp
  800bbf:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc2:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc5:	50                   	push   %eax
  800bc6:	e8 3c fd ff ff       	call   800907 <getint>
  800bcb:	83 c4 10             	add    $0x10,%esp
  800bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bda:	85 d2                	test   %edx,%edx
  800bdc:	79 23                	jns    800c01 <vprintfmt+0x29b>
				putch('-', putdat);
  800bde:	83 ec 08             	sub    $0x8,%esp
  800be1:	ff 75 0c             	pushl  0xc(%ebp)
  800be4:	6a 2d                	push   $0x2d
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	ff d0                	call   *%eax
  800beb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf4:	f7 d8                	neg    %eax
  800bf6:	83 d2 00             	adc    $0x0,%edx
  800bf9:	f7 da                	neg    %edx
  800bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c01:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c08:	e9 bc 00 00 00       	jmp    800cc9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c0d:	83 ec 08             	sub    $0x8,%esp
  800c10:	ff 75 e8             	pushl  -0x18(%ebp)
  800c13:	8d 45 14             	lea    0x14(%ebp),%eax
  800c16:	50                   	push   %eax
  800c17:	e8 84 fc ff ff       	call   8008a0 <getuint>
  800c1c:	83 c4 10             	add    $0x10,%esp
  800c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2c:	e9 98 00 00 00       	jmp    800cc9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	6a 58                	push   $0x58
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	ff d0                	call   *%eax
  800c3e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c41:	83 ec 08             	sub    $0x8,%esp
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	6a 58                	push   $0x58
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	ff d0                	call   *%eax
  800c4e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c51:	83 ec 08             	sub    $0x8,%esp
  800c54:	ff 75 0c             	pushl  0xc(%ebp)
  800c57:	6a 58                	push   $0x58
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	ff d0                	call   *%eax
  800c5e:	83 c4 10             	add    $0x10,%esp
			break;
  800c61:	e9 ce 00 00 00       	jmp    800d34 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c66:	83 ec 08             	sub    $0x8,%esp
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	6a 30                	push   $0x30
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	ff d0                	call   *%eax
  800c73:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	6a 78                	push   $0x78
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	ff d0                	call   *%eax
  800c83:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c86:	8b 45 14             	mov    0x14(%ebp),%eax
  800c89:	83 c0 04             	add    $0x4,%eax
  800c8c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c92:	83 e8 04             	sub    $0x4,%eax
  800c95:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ca1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca8:	eb 1f                	jmp    800cc9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800caa:	83 ec 08             	sub    $0x8,%esp
  800cad:	ff 75 e8             	pushl  -0x18(%ebp)
  800cb0:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb3:	50                   	push   %eax
  800cb4:	e8 e7 fb ff ff       	call   8008a0 <getuint>
  800cb9:	83 c4 10             	add    $0x10,%esp
  800cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cc2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd0:	83 ec 04             	sub    $0x4,%esp
  800cd3:	52                   	push   %edx
  800cd4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd7:	50                   	push   %eax
  800cd8:	ff 75 f4             	pushl  -0xc(%ebp)
  800cdb:	ff 75 f0             	pushl  -0x10(%ebp)
  800cde:	ff 75 0c             	pushl  0xc(%ebp)
  800ce1:	ff 75 08             	pushl  0x8(%ebp)
  800ce4:	e8 00 fb ff ff       	call   8007e9 <printnum>
  800ce9:	83 c4 20             	add    $0x20,%esp
			break;
  800cec:	eb 46                	jmp    800d34 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cee:	83 ec 08             	sub    $0x8,%esp
  800cf1:	ff 75 0c             	pushl  0xc(%ebp)
  800cf4:	53                   	push   %ebx
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	ff d0                	call   *%eax
  800cfa:	83 c4 10             	add    $0x10,%esp
			break;
  800cfd:	eb 35                	jmp    800d34 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cff:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d06:	eb 2c                	jmp    800d34 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d08:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d0f:	eb 23                	jmp    800d34 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d11:	83 ec 08             	sub    $0x8,%esp
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	6a 25                	push   $0x25
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	ff d0                	call   *%eax
  800d1e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d21:	ff 4d 10             	decl   0x10(%ebp)
  800d24:	eb 03                	jmp    800d29 <vprintfmt+0x3c3>
  800d26:	ff 4d 10             	decl   0x10(%ebp)
  800d29:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2c:	48                   	dec    %eax
  800d2d:	8a 00                	mov    (%eax),%al
  800d2f:	3c 25                	cmp    $0x25,%al
  800d31:	75 f3                	jne    800d26 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d33:	90                   	nop
		}
	}
  800d34:	e9 35 fc ff ff       	jmp    80096e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d39:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d47:	8d 45 10             	lea    0x10(%ebp),%eax
  800d4a:	83 c0 04             	add    $0x4,%eax
  800d4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d50:	8b 45 10             	mov    0x10(%ebp),%eax
  800d53:	ff 75 f4             	pushl  -0xc(%ebp)
  800d56:	50                   	push   %eax
  800d57:	ff 75 0c             	pushl  0xc(%ebp)
  800d5a:	ff 75 08             	pushl  0x8(%ebp)
  800d5d:	e8 04 fc ff ff       	call   800966 <vprintfmt>
  800d62:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d65:	90                   	nop
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	8b 40 08             	mov    0x8(%eax),%eax
  800d71:	8d 50 01             	lea    0x1(%eax),%edx
  800d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d77:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7d:	8b 10                	mov    (%eax),%edx
  800d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d82:	8b 40 04             	mov    0x4(%eax),%eax
  800d85:	39 c2                	cmp    %eax,%edx
  800d87:	73 12                	jae    800d9b <sprintputch+0x33>
		*b->buf++ = ch;
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	8b 00                	mov    (%eax),%eax
  800d8e:	8d 48 01             	lea    0x1(%eax),%ecx
  800d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d94:	89 0a                	mov    %ecx,(%edx)
  800d96:	8b 55 08             	mov    0x8(%ebp),%edx
  800d99:	88 10                	mov    %dl,(%eax)
}
  800d9b:	90                   	nop
  800d9c:	5d                   	pop    %ebp
  800d9d:	c3                   	ret    

00800d9e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	01 d0                	add    %edx,%eax
  800db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dbf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dc3:	74 06                	je     800dcb <vsnprintf+0x2d>
  800dc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc9:	7f 07                	jg     800dd2 <vsnprintf+0x34>
		return -E_INVAL;
  800dcb:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd0:	eb 20                	jmp    800df2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dd2:	ff 75 14             	pushl  0x14(%ebp)
  800dd5:	ff 75 10             	pushl  0x10(%ebp)
  800dd8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ddb:	50                   	push   %eax
  800ddc:	68 68 0d 80 00       	push   $0x800d68
  800de1:	e8 80 fb ff ff       	call   800966 <vprintfmt>
  800de6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800de9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dec:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800def:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800df2:	c9                   	leave  
  800df3:	c3                   	ret    

00800df4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dfa:	8d 45 10             	lea    0x10(%ebp),%eax
  800dfd:	83 c0 04             	add    $0x4,%eax
  800e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	ff 75 f4             	pushl  -0xc(%ebp)
  800e09:	50                   	push   %eax
  800e0a:	ff 75 0c             	pushl  0xc(%ebp)
  800e0d:	ff 75 08             	pushl  0x8(%ebp)
  800e10:	e8 89 ff ff ff       	call   800d9e <vsnprintf>
  800e15:	83 c4 10             	add    $0x10,%esp
  800e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800e26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e2a:	74 13                	je     800e3f <readline+0x1f>
		cprintf("%s", prompt);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 08             	pushl  0x8(%ebp)
  800e32:	68 28 2a 80 00       	push   $0x802a28
  800e37:	e8 0b f9 ff ff       	call   800747 <cprintf>
  800e3c:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e46:	83 ec 0c             	sub    $0xc,%esp
  800e49:	6a 00                	push   $0x0
  800e4b:	e8 7f 10 00 00       	call   801ecf <iscons>
  800e50:	83 c4 10             	add    $0x10,%esp
  800e53:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e56:	e8 61 10 00 00       	call   801ebc <getchar>
  800e5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e5e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e62:	79 22                	jns    800e86 <readline+0x66>
			if (c != -E_EOF)
  800e64:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e68:	0f 84 ad 00 00 00    	je     800f1b <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e6e:	83 ec 08             	sub    $0x8,%esp
  800e71:	ff 75 ec             	pushl  -0x14(%ebp)
  800e74:	68 2b 2a 80 00       	push   $0x802a2b
  800e79:	e8 c9 f8 ff ff       	call   800747 <cprintf>
  800e7e:	83 c4 10             	add    $0x10,%esp
			break;
  800e81:	e9 95 00 00 00       	jmp    800f1b <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800e86:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800e8a:	7e 34                	jle    800ec0 <readline+0xa0>
  800e8c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800e93:	7f 2b                	jg     800ec0 <readline+0xa0>
			if (echoing)
  800e95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e99:	74 0e                	je     800ea9 <readline+0x89>
				cputchar(c);
  800e9b:	83 ec 0c             	sub    $0xc,%esp
  800e9e:	ff 75 ec             	pushl  -0x14(%ebp)
  800ea1:	e8 f7 0f 00 00       	call   801e9d <cputchar>
  800ea6:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eac:	8d 50 01             	lea    0x1(%eax),%edx
  800eaf:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800eb2:	89 c2                	mov    %eax,%edx
  800eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb7:	01 d0                	add    %edx,%eax
  800eb9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ebc:	88 10                	mov    %dl,(%eax)
  800ebe:	eb 56                	jmp    800f16 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800ec0:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ec4:	75 1f                	jne    800ee5 <readline+0xc5>
  800ec6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800eca:	7e 19                	jle    800ee5 <readline+0xc5>
			if (echoing)
  800ecc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ed0:	74 0e                	je     800ee0 <readline+0xc0>
				cputchar(c);
  800ed2:	83 ec 0c             	sub    $0xc,%esp
  800ed5:	ff 75 ec             	pushl  -0x14(%ebp)
  800ed8:	e8 c0 0f 00 00       	call   801e9d <cputchar>
  800edd:	83 c4 10             	add    $0x10,%esp

			i--;
  800ee0:	ff 4d f4             	decl   -0xc(%ebp)
  800ee3:	eb 31                	jmp    800f16 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800ee5:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ee9:	74 0a                	je     800ef5 <readline+0xd5>
  800eeb:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800eef:	0f 85 61 ff ff ff    	jne    800e56 <readline+0x36>
			if (echoing)
  800ef5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ef9:	74 0e                	je     800f09 <readline+0xe9>
				cputchar(c);
  800efb:	83 ec 0c             	sub    $0xc,%esp
  800efe:	ff 75 ec             	pushl  -0x14(%ebp)
  800f01:	e8 97 0f 00 00       	call   801e9d <cputchar>
  800f06:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0f:	01 d0                	add    %edx,%eax
  800f11:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800f14:	eb 06                	jmp    800f1c <readline+0xfc>
		}
	}
  800f16:	e9 3b ff ff ff       	jmp    800e56 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800f1b:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800f1c:	90                   	nop
  800f1d:	c9                   	leave  
  800f1e:	c3                   	ret    

00800f1f <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800f25:	e8 79 09 00 00       	call   8018a3 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800f2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f2e:	74 13                	je     800f43 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	ff 75 08             	pushl  0x8(%ebp)
  800f36:	68 28 2a 80 00       	push   $0x802a28
  800f3b:	e8 07 f8 ff ff       	call   800747 <cprintf>
  800f40:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800f43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800f4a:	83 ec 0c             	sub    $0xc,%esp
  800f4d:	6a 00                	push   $0x0
  800f4f:	e8 7b 0f 00 00       	call   801ecf <iscons>
  800f54:	83 c4 10             	add    $0x10,%esp
  800f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800f5a:	e8 5d 0f 00 00       	call   801ebc <getchar>
  800f5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800f62:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f66:	79 22                	jns    800f8a <atomic_readline+0x6b>
				if (c != -E_EOF)
  800f68:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f6c:	0f 84 ad 00 00 00    	je     80101f <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800f72:	83 ec 08             	sub    $0x8,%esp
  800f75:	ff 75 ec             	pushl  -0x14(%ebp)
  800f78:	68 2b 2a 80 00       	push   $0x802a2b
  800f7d:	e8 c5 f7 ff ff       	call   800747 <cprintf>
  800f82:	83 c4 10             	add    $0x10,%esp
				break;
  800f85:	e9 95 00 00 00       	jmp    80101f <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800f8a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800f8e:	7e 34                	jle    800fc4 <atomic_readline+0xa5>
  800f90:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800f97:	7f 2b                	jg     800fc4 <atomic_readline+0xa5>
				if (echoing)
  800f99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f9d:	74 0e                	je     800fad <atomic_readline+0x8e>
					cputchar(c);
  800f9f:	83 ec 0c             	sub    $0xc,%esp
  800fa2:	ff 75 ec             	pushl  -0x14(%ebp)
  800fa5:	e8 f3 0e 00 00       	call   801e9d <cputchar>
  800faa:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb0:	8d 50 01             	lea    0x1(%eax),%edx
  800fb3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800fb6:	89 c2                	mov    %eax,%edx
  800fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbb:	01 d0                	add    %edx,%eax
  800fbd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fc0:	88 10                	mov    %dl,(%eax)
  800fc2:	eb 56                	jmp    80101a <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800fc4:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800fc8:	75 1f                	jne    800fe9 <atomic_readline+0xca>
  800fca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800fce:	7e 19                	jle    800fe9 <atomic_readline+0xca>
				if (echoing)
  800fd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fd4:	74 0e                	je     800fe4 <atomic_readline+0xc5>
					cputchar(c);
  800fd6:	83 ec 0c             	sub    $0xc,%esp
  800fd9:	ff 75 ec             	pushl  -0x14(%ebp)
  800fdc:	e8 bc 0e 00 00       	call   801e9d <cputchar>
  800fe1:	83 c4 10             	add    $0x10,%esp
				i--;
  800fe4:	ff 4d f4             	decl   -0xc(%ebp)
  800fe7:	eb 31                	jmp    80101a <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800fe9:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800fed:	74 0a                	je     800ff9 <atomic_readline+0xda>
  800fef:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800ff3:	0f 85 61 ff ff ff    	jne    800f5a <atomic_readline+0x3b>
				if (echoing)
  800ff9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ffd:	74 0e                	je     80100d <atomic_readline+0xee>
					cputchar(c);
  800fff:	83 ec 0c             	sub    $0xc,%esp
  801002:	ff 75 ec             	pushl  -0x14(%ebp)
  801005:	e8 93 0e 00 00       	call   801e9d <cputchar>
  80100a:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80100d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	01 d0                	add    %edx,%eax
  801015:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801018:	eb 06                	jmp    801020 <atomic_readline+0x101>
			}
		}
  80101a:	e9 3b ff ff ff       	jmp    800f5a <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80101f:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801020:	e8 98 08 00 00       	call   8018bd <sys_unlock_cons>
}
  801025:	90                   	nop
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80102e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801035:	eb 06                	jmp    80103d <strlen+0x15>
		n++;
  801037:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80103a:	ff 45 08             	incl   0x8(%ebp)
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	84 c0                	test   %al,%al
  801044:	75 f1                	jne    801037 <strlen+0xf>
		n++;
	return n;
  801046:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801051:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801058:	eb 09                	jmp    801063 <strnlen+0x18>
		n++;
  80105a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80105d:	ff 45 08             	incl   0x8(%ebp)
  801060:	ff 4d 0c             	decl   0xc(%ebp)
  801063:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801067:	74 09                	je     801072 <strnlen+0x27>
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	84 c0                	test   %al,%al
  801070:	75 e8                	jne    80105a <strnlen+0xf>
		n++;
	return n;
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801083:	90                   	nop
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8d 50 01             	lea    0x1(%eax),%edx
  80108a:	89 55 08             	mov    %edx,0x8(%ebp)
  80108d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801090:	8d 4a 01             	lea    0x1(%edx),%ecx
  801093:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801096:	8a 12                	mov    (%edx),%dl
  801098:	88 10                	mov    %dl,(%eax)
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	84 c0                	test   %al,%al
  80109e:	75 e4                	jne    801084 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010b8:	eb 1f                	jmp    8010d9 <strncpy+0x34>
		*dst++ = *src;
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8d 50 01             	lea    0x1(%eax),%edx
  8010c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c6:	8a 12                	mov    (%edx),%dl
  8010c8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	84 c0                	test   %al,%al
  8010d1:	74 03                	je     8010d6 <strncpy+0x31>
			src++;
  8010d3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010d6:	ff 45 fc             	incl   -0x4(%ebp)
  8010d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010dc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010df:	72 d9                	jb     8010ba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010e4:	c9                   	leave  
  8010e5:	c3                   	ret    

008010e6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f6:	74 30                	je     801128 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010f8:	eb 16                	jmp    801110 <strlcpy+0x2a>
			*dst++ = *src++;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8d 50 01             	lea    0x1(%eax),%edx
  801100:	89 55 08             	mov    %edx,0x8(%ebp)
  801103:	8b 55 0c             	mov    0xc(%ebp),%edx
  801106:	8d 4a 01             	lea    0x1(%edx),%ecx
  801109:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80110c:	8a 12                	mov    (%edx),%dl
  80110e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801110:	ff 4d 10             	decl   0x10(%ebp)
  801113:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801117:	74 09                	je     801122 <strlcpy+0x3c>
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	84 c0                	test   %al,%al
  801120:	75 d8                	jne    8010fa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801128:	8b 55 08             	mov    0x8(%ebp),%edx
  80112b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112e:	29 c2                	sub    %eax,%edx
  801130:	89 d0                	mov    %edx,%eax
}
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801137:	eb 06                	jmp    80113f <strcmp+0xb>
		p++, q++;
  801139:	ff 45 08             	incl   0x8(%ebp)
  80113c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	84 c0                	test   %al,%al
  801146:	74 0e                	je     801156 <strcmp+0x22>
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 10                	mov    (%eax),%dl
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	38 c2                	cmp    %al,%dl
  801154:	74 e3                	je     801139 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	0f b6 d0             	movzbl %al,%edx
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f b6 c0             	movzbl %al,%eax
  801166:	29 c2                	sub    %eax,%edx
  801168:	89 d0                	mov    %edx,%eax
}
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    

0080116c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80116f:	eb 09                	jmp    80117a <strncmp+0xe>
		n--, p++, q++;
  801171:	ff 4d 10             	decl   0x10(%ebp)
  801174:	ff 45 08             	incl   0x8(%ebp)
  801177:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80117a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117e:	74 17                	je     801197 <strncmp+0x2b>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	84 c0                	test   %al,%al
  801187:	74 0e                	je     801197 <strncmp+0x2b>
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 10                	mov    (%eax),%dl
  80118e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	38 c2                	cmp    %al,%dl
  801195:	74 da                	je     801171 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801197:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119b:	75 07                	jne    8011a4 <strncmp+0x38>
		return 0;
  80119d:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a2:	eb 14                	jmp    8011b8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	0f b6 d0             	movzbl %al,%edx
  8011ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	0f b6 c0             	movzbl %al,%eax
  8011b4:	29 c2                	sub    %eax,%edx
  8011b6:	89 d0                	mov    %edx,%eax
}
  8011b8:	5d                   	pop    %ebp
  8011b9:	c3                   	ret    

008011ba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	83 ec 04             	sub    $0x4,%esp
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011c6:	eb 12                	jmp    8011da <strchr+0x20>
		if (*s == c)
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011d0:	75 05                	jne    8011d7 <strchr+0x1d>
			return (char *) s;
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	eb 11                	jmp    8011e8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011d7:	ff 45 08             	incl   0x8(%ebp)
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	84 c0                	test   %al,%al
  8011e1:	75 e5                	jne    8011c8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e8:	c9                   	leave  
  8011e9:	c3                   	ret    

008011ea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	83 ec 04             	sub    $0x4,%esp
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011f6:	eb 0d                	jmp    801205 <strfind+0x1b>
		if (*s == c)
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8a 00                	mov    (%eax),%al
  8011fd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801200:	74 0e                	je     801210 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801202:	ff 45 08             	incl   0x8(%ebp)
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	84 c0                	test   %al,%al
  80120c:	75 ea                	jne    8011f8 <strfind+0xe>
  80120e:	eb 01                	jmp    801211 <strfind+0x27>
		if (*s == c)
			break;
  801210:	90                   	nop
	return (char *) s;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801222:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801226:	76 63                	jbe    80128b <memset+0x75>
		uint64 data_block = c;
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	99                   	cltd   
  80122c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80122f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801232:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801235:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801238:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80123c:	c1 e0 08             	shl    $0x8,%eax
  80123f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801242:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801248:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80124f:	c1 e0 10             	shl    $0x10,%eax
  801252:	09 45 f0             	or     %eax,-0x10(%ebp)
  801255:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125e:	89 c2                	mov    %eax,%edx
  801260:	b8 00 00 00 00       	mov    $0x0,%eax
  801265:	09 45 f0             	or     %eax,-0x10(%ebp)
  801268:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80126b:	eb 18                	jmp    801285 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80126d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801270:	8d 41 08             	lea    0x8(%ecx),%eax
  801273:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801276:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801279:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127c:	89 01                	mov    %eax,(%ecx)
  80127e:	89 51 04             	mov    %edx,0x4(%ecx)
  801281:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801285:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801289:	77 e2                	ja     80126d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80128b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128f:	74 23                	je     8012b4 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801291:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801294:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801297:	eb 0e                	jmp    8012a7 <memset+0x91>
			*p8++ = (uint8)c;
  801299:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129c:	8d 50 01             	lea    0x1(%eax),%edx
  80129f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a5:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8012a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012aa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ad:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b0:	85 c0                	test   %eax,%eax
  8012b2:	75 e5                	jne    801299 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8012cb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012cf:	76 24                	jbe    8012f5 <memcpy+0x3c>
		while(n >= 8){
  8012d1:	eb 1c                	jmp    8012ef <memcpy+0x36>
			*d64 = *s64;
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	8b 50 04             	mov    0x4(%eax),%edx
  8012d9:	8b 00                	mov    (%eax),%eax
  8012db:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012de:	89 01                	mov    %eax,(%ecx)
  8012e0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8012e3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8012e7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8012eb:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8012ef:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012f3:	77 de                	ja     8012d3 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8012f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f9:	74 31                	je     80132c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801301:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801304:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801307:	eb 16                	jmp    80131f <memcpy+0x66>
			*d8++ = *s8++;
  801309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130c:	8d 50 01             	lea    0x1(%eax),%edx
  80130f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801312:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801315:	8d 4a 01             	lea    0x1(%edx),%ecx
  801318:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80131b:	8a 12                	mov    (%edx),%dl
  80131d:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	8d 50 ff             	lea    -0x1(%eax),%edx
  801325:	89 55 10             	mov    %edx,0x10(%ebp)
  801328:	85 c0                	test   %eax,%eax
  80132a:	75 dd                	jne    801309 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801343:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801346:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801349:	73 50                	jae    80139b <memmove+0x6a>
  80134b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80134e:	8b 45 10             	mov    0x10(%ebp),%eax
  801351:	01 d0                	add    %edx,%eax
  801353:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801356:	76 43                	jbe    80139b <memmove+0x6a>
		s += n;
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80135e:	8b 45 10             	mov    0x10(%ebp),%eax
  801361:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801364:	eb 10                	jmp    801376 <memmove+0x45>
			*--d = *--s;
  801366:	ff 4d f8             	decl   -0x8(%ebp)
  801369:	ff 4d fc             	decl   -0x4(%ebp)
  80136c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80136f:	8a 10                	mov    (%eax),%dl
  801371:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801374:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801376:	8b 45 10             	mov    0x10(%ebp),%eax
  801379:	8d 50 ff             	lea    -0x1(%eax),%edx
  80137c:	89 55 10             	mov    %edx,0x10(%ebp)
  80137f:	85 c0                	test   %eax,%eax
  801381:	75 e3                	jne    801366 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801383:	eb 23                	jmp    8013a8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801385:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801388:	8d 50 01             	lea    0x1(%eax),%edx
  80138b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80138e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801391:	8d 4a 01             	lea    0x1(%edx),%ecx
  801394:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801397:	8a 12                	mov    (%edx),%dl
  801399:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80139b:	8b 45 10             	mov    0x10(%ebp),%eax
  80139e:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a1:	89 55 10             	mov    %edx,0x10(%ebp)
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	75 dd                	jne    801385 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    

008013ad <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013bf:	eb 2a                	jmp    8013eb <memcmp+0x3e>
		if (*s1 != *s2)
  8013c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c4:	8a 10                	mov    (%eax),%dl
  8013c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	38 c2                	cmp    %al,%dl
  8013cd:	74 16                	je     8013e5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	0f b6 d0             	movzbl %al,%edx
  8013d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	0f b6 c0             	movzbl %al,%eax
  8013df:	29 c2                	sub    %eax,%edx
  8013e1:	89 d0                	mov    %edx,%eax
  8013e3:	eb 18                	jmp    8013fd <memcmp+0x50>
		s1++, s2++;
  8013e5:	ff 45 fc             	incl   -0x4(%ebp)
  8013e8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ee:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013f1:	89 55 10             	mov    %edx,0x10(%ebp)
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	75 c9                	jne    8013c1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801405:	8b 55 08             	mov    0x8(%ebp),%edx
  801408:	8b 45 10             	mov    0x10(%ebp),%eax
  80140b:	01 d0                	add    %edx,%eax
  80140d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801410:	eb 15                	jmp    801427 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	0f b6 d0             	movzbl %al,%edx
  80141a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141d:	0f b6 c0             	movzbl %al,%eax
  801420:	39 c2                	cmp    %eax,%edx
  801422:	74 0d                	je     801431 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801424:	ff 45 08             	incl   0x8(%ebp)
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80142d:	72 e3                	jb     801412 <memfind+0x13>
  80142f:	eb 01                	jmp    801432 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801431:	90                   	nop
	return (void *) s;
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80143d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801444:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80144b:	eb 03                	jmp    801450 <strtol+0x19>
		s++;
  80144d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	8a 00                	mov    (%eax),%al
  801455:	3c 20                	cmp    $0x20,%al
  801457:	74 f4                	je     80144d <strtol+0x16>
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	8a 00                	mov    (%eax),%al
  80145e:	3c 09                	cmp    $0x9,%al
  801460:	74 eb                	je     80144d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	8a 00                	mov    (%eax),%al
  801467:	3c 2b                	cmp    $0x2b,%al
  801469:	75 05                	jne    801470 <strtol+0x39>
		s++;
  80146b:	ff 45 08             	incl   0x8(%ebp)
  80146e:	eb 13                	jmp    801483 <strtol+0x4c>
	else if (*s == '-')
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	8a 00                	mov    (%eax),%al
  801475:	3c 2d                	cmp    $0x2d,%al
  801477:	75 0a                	jne    801483 <strtol+0x4c>
		s++, neg = 1;
  801479:	ff 45 08             	incl   0x8(%ebp)
  80147c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801483:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801487:	74 06                	je     80148f <strtol+0x58>
  801489:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80148d:	75 20                	jne    8014af <strtol+0x78>
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	3c 30                	cmp    $0x30,%al
  801496:	75 17                	jne    8014af <strtol+0x78>
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	40                   	inc    %eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	3c 78                	cmp    $0x78,%al
  8014a0:	75 0d                	jne    8014af <strtol+0x78>
		s += 2, base = 16;
  8014a2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014a6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014ad:	eb 28                	jmp    8014d7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b3:	75 15                	jne    8014ca <strtol+0x93>
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	3c 30                	cmp    $0x30,%al
  8014bc:	75 0c                	jne    8014ca <strtol+0x93>
		s++, base = 8;
  8014be:	ff 45 08             	incl   0x8(%ebp)
  8014c1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014c8:	eb 0d                	jmp    8014d7 <strtol+0xa0>
	else if (base == 0)
  8014ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ce:	75 07                	jne    8014d7 <strtol+0xa0>
		base = 10;
  8014d0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	8a 00                	mov    (%eax),%al
  8014dc:	3c 2f                	cmp    $0x2f,%al
  8014de:	7e 19                	jle    8014f9 <strtol+0xc2>
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	8a 00                	mov    (%eax),%al
  8014e5:	3c 39                	cmp    $0x39,%al
  8014e7:	7f 10                	jg     8014f9 <strtol+0xc2>
			dig = *s - '0';
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	8a 00                	mov    (%eax),%al
  8014ee:	0f be c0             	movsbl %al,%eax
  8014f1:	83 e8 30             	sub    $0x30,%eax
  8014f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014f7:	eb 42                	jmp    80153b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	3c 60                	cmp    $0x60,%al
  801500:	7e 19                	jle    80151b <strtol+0xe4>
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	3c 7a                	cmp    $0x7a,%al
  801509:	7f 10                	jg     80151b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	8a 00                	mov    (%eax),%al
  801510:	0f be c0             	movsbl %al,%eax
  801513:	83 e8 57             	sub    $0x57,%eax
  801516:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801519:	eb 20                	jmp    80153b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	3c 40                	cmp    $0x40,%al
  801522:	7e 39                	jle    80155d <strtol+0x126>
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	3c 5a                	cmp    $0x5a,%al
  80152b:	7f 30                	jg     80155d <strtol+0x126>
			dig = *s - 'A' + 10;
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	0f be c0             	movsbl %al,%eax
  801535:	83 e8 37             	sub    $0x37,%eax
  801538:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80153b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801541:	7d 19                	jge    80155c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801543:	ff 45 08             	incl   0x8(%ebp)
  801546:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801549:	0f af 45 10          	imul   0x10(%ebp),%eax
  80154d:	89 c2                	mov    %eax,%edx
  80154f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801552:	01 d0                	add    %edx,%eax
  801554:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801557:	e9 7b ff ff ff       	jmp    8014d7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80155c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80155d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801561:	74 08                	je     80156b <strtol+0x134>
		*endptr = (char *) s;
  801563:	8b 45 0c             	mov    0xc(%ebp),%eax
  801566:	8b 55 08             	mov    0x8(%ebp),%edx
  801569:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80156b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80156f:	74 07                	je     801578 <strtol+0x141>
  801571:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801574:	f7 d8                	neg    %eax
  801576:	eb 03                	jmp    80157b <strtol+0x144>
  801578:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <ltostr>:

void
ltostr(long value, char *str)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801583:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80158a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801591:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801595:	79 13                	jns    8015aa <ltostr+0x2d>
	{
		neg = 1;
  801597:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015a4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015a7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015b2:	99                   	cltd   
  8015b3:	f7 f9                	idiv   %ecx
  8015b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bb:	8d 50 01             	lea    0x1(%eax),%edx
  8015be:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015c1:	89 c2                	mov    %eax,%edx
  8015c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c6:	01 d0                	add    %edx,%eax
  8015c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015cb:	83 c2 30             	add    $0x30,%edx
  8015ce:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015d3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015d8:	f7 e9                	imul   %ecx
  8015da:	c1 fa 02             	sar    $0x2,%edx
  8015dd:	89 c8                	mov    %ecx,%eax
  8015df:	c1 f8 1f             	sar    $0x1f,%eax
  8015e2:	29 c2                	sub    %eax,%edx
  8015e4:	89 d0                	mov    %edx,%eax
  8015e6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8015e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015ed:	75 bb                	jne    8015aa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f9:	48                   	dec    %eax
  8015fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801601:	74 3d                	je     801640 <ltostr+0xc3>
		start = 1 ;
  801603:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80160a:	eb 34                	jmp    801640 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80160c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	01 d0                	add    %edx,%eax
  801614:	8a 00                	mov    (%eax),%al
  801616:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	01 c2                	add    %eax,%edx
  801621:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801624:	8b 45 0c             	mov    0xc(%ebp),%eax
  801627:	01 c8                	add    %ecx,%eax
  801629:	8a 00                	mov    (%eax),%al
  80162b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80162d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801630:	8b 45 0c             	mov    0xc(%ebp),%eax
  801633:	01 c2                	add    %eax,%edx
  801635:	8a 45 eb             	mov    -0x15(%ebp),%al
  801638:	88 02                	mov    %al,(%edx)
		start++ ;
  80163a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80163d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801643:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801646:	7c c4                	jl     80160c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801648:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80164b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164e:	01 d0                	add    %edx,%eax
  801650:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801653:	90                   	nop
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80165c:	ff 75 08             	pushl  0x8(%ebp)
  80165f:	e8 c4 f9 ff ff       	call   801028 <strlen>
  801664:	83 c4 04             	add    $0x4,%esp
  801667:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80166a:	ff 75 0c             	pushl  0xc(%ebp)
  80166d:	e8 b6 f9 ff ff       	call   801028 <strlen>
  801672:	83 c4 04             	add    $0x4,%esp
  801675:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801678:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80167f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801686:	eb 17                	jmp    80169f <strcconcat+0x49>
		final[s] = str1[s] ;
  801688:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168b:	8b 45 10             	mov    0x10(%ebp),%eax
  80168e:	01 c2                	add    %eax,%edx
  801690:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	01 c8                	add    %ecx,%eax
  801698:	8a 00                	mov    (%eax),%al
  80169a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80169c:	ff 45 fc             	incl   -0x4(%ebp)
  80169f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016a5:	7c e1                	jl     801688 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016b5:	eb 1f                	jmp    8016d6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ba:	8d 50 01             	lea    0x1(%eax),%edx
  8016bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016c0:	89 c2                	mov    %eax,%edx
  8016c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c5:	01 c2                	add    %eax,%edx
  8016c7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cd:	01 c8                	add    %ecx,%eax
  8016cf:	8a 00                	mov    (%eax),%al
  8016d1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016d3:	ff 45 f8             	incl   -0x8(%ebp)
  8016d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016dc:	7c d9                	jl     8016b7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e4:	01 d0                	add    %edx,%eax
  8016e6:	c6 00 00             	movb   $0x0,(%eax)
}
  8016e9:	90                   	nop
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016fb:	8b 00                	mov    (%eax),%eax
  8016fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801704:	8b 45 10             	mov    0x10(%ebp),%eax
  801707:	01 d0                	add    %edx,%eax
  801709:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80170f:	eb 0c                	jmp    80171d <strsplit+0x31>
			*string++ = 0;
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8d 50 01             	lea    0x1(%eax),%edx
  801717:	89 55 08             	mov    %edx,0x8(%ebp)
  80171a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	8a 00                	mov    (%eax),%al
  801722:	84 c0                	test   %al,%al
  801724:	74 18                	je     80173e <strsplit+0x52>
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8a 00                	mov    (%eax),%al
  80172b:	0f be c0             	movsbl %al,%eax
  80172e:	50                   	push   %eax
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	e8 83 fa ff ff       	call   8011ba <strchr>
  801737:	83 c4 08             	add    $0x8,%esp
  80173a:	85 c0                	test   %eax,%eax
  80173c:	75 d3                	jne    801711 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8a 00                	mov    (%eax),%al
  801743:	84 c0                	test   %al,%al
  801745:	74 5a                	je     8017a1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801747:	8b 45 14             	mov    0x14(%ebp),%eax
  80174a:	8b 00                	mov    (%eax),%eax
  80174c:	83 f8 0f             	cmp    $0xf,%eax
  80174f:	75 07                	jne    801758 <strsplit+0x6c>
		{
			return 0;
  801751:	b8 00 00 00 00       	mov    $0x0,%eax
  801756:	eb 66                	jmp    8017be <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801758:	8b 45 14             	mov    0x14(%ebp),%eax
  80175b:	8b 00                	mov    (%eax),%eax
  80175d:	8d 48 01             	lea    0x1(%eax),%ecx
  801760:	8b 55 14             	mov    0x14(%ebp),%edx
  801763:	89 0a                	mov    %ecx,(%edx)
  801765:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80176c:	8b 45 10             	mov    0x10(%ebp),%eax
  80176f:	01 c2                	add    %eax,%edx
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801776:	eb 03                	jmp    80177b <strsplit+0x8f>
			string++;
  801778:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	8a 00                	mov    (%eax),%al
  801780:	84 c0                	test   %al,%al
  801782:	74 8b                	je     80170f <strsplit+0x23>
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8a 00                	mov    (%eax),%al
  801789:	0f be c0             	movsbl %al,%eax
  80178c:	50                   	push   %eax
  80178d:	ff 75 0c             	pushl  0xc(%ebp)
  801790:	e8 25 fa ff ff       	call   8011ba <strchr>
  801795:	83 c4 08             	add    $0x8,%esp
  801798:	85 c0                	test   %eax,%eax
  80179a:	74 dc                	je     801778 <strsplit+0x8c>
			string++;
	}
  80179c:	e9 6e ff ff ff       	jmp    80170f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017a1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a5:	8b 00                	mov    (%eax),%eax
  8017a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b1:	01 d0                	add    %edx,%eax
  8017b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8017cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017d3:	eb 4a                	jmp    80181f <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8017d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	01 c2                	add    %eax,%edx
  8017dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e3:	01 c8                	add    %ecx,%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8017e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ef:	01 d0                	add    %edx,%eax
  8017f1:	8a 00                	mov    (%eax),%al
  8017f3:	3c 40                	cmp    $0x40,%al
  8017f5:	7e 25                	jle    80181c <str2lower+0x5c>
  8017f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fd:	01 d0                	add    %edx,%eax
  8017ff:	8a 00                	mov    (%eax),%al
  801801:	3c 5a                	cmp    $0x5a,%al
  801803:	7f 17                	jg     80181c <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801805:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	01 d0                	add    %edx,%eax
  80180d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801810:	8b 55 08             	mov    0x8(%ebp),%edx
  801813:	01 ca                	add    %ecx,%edx
  801815:	8a 12                	mov    (%edx),%dl
  801817:	83 c2 20             	add    $0x20,%edx
  80181a:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80181c:	ff 45 fc             	incl   -0x4(%ebp)
  80181f:	ff 75 0c             	pushl  0xc(%ebp)
  801822:	e8 01 f8 ff ff       	call   801028 <strlen>
  801827:	83 c4 04             	add    $0x4,%esp
  80182a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80182d:	7f a6                	jg     8017d5 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80182f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	57                   	push   %edi
  801838:	56                   	push   %esi
  801839:	53                   	push   %ebx
  80183a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8b 55 0c             	mov    0xc(%ebp),%edx
  801843:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801846:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801849:	8b 7d 18             	mov    0x18(%ebp),%edi
  80184c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80184f:	cd 30                	int    $0x30
  801851:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801854:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801857:	83 c4 10             	add    $0x10,%esp
  80185a:	5b                   	pop    %ebx
  80185b:	5e                   	pop    %esi
  80185c:	5f                   	pop    %edi
  80185d:	5d                   	pop    %ebp
  80185e:	c3                   	ret    

0080185f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 04             	sub    $0x4,%esp
  801865:	8b 45 10             	mov    0x10(%ebp),%eax
  801868:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80186b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80186e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	51                   	push   %ecx
  801878:	52                   	push   %edx
  801879:	ff 75 0c             	pushl  0xc(%ebp)
  80187c:	50                   	push   %eax
  80187d:	6a 00                	push   $0x0
  80187f:	e8 b0 ff ff ff       	call   801834 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	90                   	nop
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <sys_cgetc>:

int
sys_cgetc(void)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 02                	push   $0x2
  801899:	e8 96 ff ff ff       	call   801834 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 03                	push   $0x3
  8018b2:	e8 7d ff ff ff       	call   801834 <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	90                   	nop
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 04                	push   $0x4
  8018cc:	e8 63 ff ff ff       	call   801834 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	90                   	nop
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	52                   	push   %edx
  8018e7:	50                   	push   %eax
  8018e8:	6a 08                	push   $0x8
  8018ea:	e8 45 ff ff ff       	call   801834 <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	56                   	push   %esi
  8018f8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018f9:	8b 75 18             	mov    0x18(%ebp),%esi
  8018fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801902:	8b 55 0c             	mov    0xc(%ebp),%edx
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	56                   	push   %esi
  801909:	53                   	push   %ebx
  80190a:	51                   	push   %ecx
  80190b:	52                   	push   %edx
  80190c:	50                   	push   %eax
  80190d:	6a 09                	push   $0x9
  80190f:	e8 20 ff ff ff       	call   801834 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80191a:	5b                   	pop    %ebx
  80191b:	5e                   	pop    %esi
  80191c:	5d                   	pop    %ebp
  80191d:	c3                   	ret    

0080191e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	ff 75 08             	pushl  0x8(%ebp)
  80192c:	6a 0a                	push   $0xa
  80192e:	e8 01 ff ff ff       	call   801834 <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
}
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	ff 75 0c             	pushl  0xc(%ebp)
  801944:	ff 75 08             	pushl  0x8(%ebp)
  801947:	6a 0b                	push   $0xb
  801949:	e8 e6 fe ff ff       	call   801834 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 0c                	push   $0xc
  801962:	e8 cd fe ff ff       	call   801834 <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 0d                	push   $0xd
  80197b:	e8 b4 fe ff ff       	call   801834 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 0e                	push   $0xe
  801994:	e8 9b fe ff ff       	call   801834 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 0f                	push   $0xf
  8019ad:	e8 82 fe ff ff       	call   801834 <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	ff 75 08             	pushl  0x8(%ebp)
  8019c5:	6a 10                	push   $0x10
  8019c7:	e8 68 fe ff ff       	call   801834 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 11                	push   $0x11
  8019e0:	e8 4f fe ff ff       	call   801834 <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	90                   	nop
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_cputc>:

void
sys_cputc(const char c)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	83 ec 04             	sub    $0x4,%esp
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	50                   	push   %eax
  801a04:	6a 01                	push   $0x1
  801a06:	e8 29 fe ff ff       	call   801834 <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	90                   	nop
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 14                	push   $0x14
  801a20:	e8 0f fe ff ff       	call   801834 <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	90                   	nop
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	83 ec 04             	sub    $0x4,%esp
  801a31:	8b 45 10             	mov    0x10(%ebp),%eax
  801a34:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a37:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a3a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	6a 00                	push   $0x0
  801a43:	51                   	push   %ecx
  801a44:	52                   	push   %edx
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	50                   	push   %eax
  801a49:	6a 15                	push   $0x15
  801a4b:	e8 e4 fd ff ff       	call   801834 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	52                   	push   %edx
  801a65:	50                   	push   %eax
  801a66:	6a 16                	push   $0x16
  801a68:	e8 c7 fd ff ff       	call   801834 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a75:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	51                   	push   %ecx
  801a83:	52                   	push   %edx
  801a84:	50                   	push   %eax
  801a85:	6a 17                	push   $0x17
  801a87:	e8 a8 fd ff ff       	call   801834 <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	52                   	push   %edx
  801aa1:	50                   	push   %eax
  801aa2:	6a 18                	push   $0x18
  801aa4:	e8 8b fd ff ff       	call   801834 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	6a 00                	push   $0x0
  801ab6:	ff 75 14             	pushl  0x14(%ebp)
  801ab9:	ff 75 10             	pushl  0x10(%ebp)
  801abc:	ff 75 0c             	pushl  0xc(%ebp)
  801abf:	50                   	push   %eax
  801ac0:	6a 19                	push   $0x19
  801ac2:	e8 6d fd ff ff       	call   801834 <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_run_env>:

void sys_run_env(int32 envId)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	50                   	push   %eax
  801adb:	6a 1a                	push   $0x1a
  801add:	e8 52 fd ff ff       	call   801834 <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
}
  801ae5:	90                   	nop
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	50                   	push   %eax
  801af7:	6a 1b                	push   $0x1b
  801af9:	e8 36 fd ff ff       	call   801834 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 05                	push   $0x5
  801b12:	e8 1d fd ff ff       	call   801834 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 06                	push   $0x6
  801b2b:	e8 04 fd ff ff       	call   801834 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 07                	push   $0x7
  801b44:	e8 eb fc ff ff       	call   801834 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_exit_env>:


void sys_exit_env(void)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 1c                	push   $0x1c
  801b5d:	e8 d2 fc ff ff       	call   801834 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
}
  801b65:	90                   	nop
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b6e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b71:	8d 50 04             	lea    0x4(%eax),%edx
  801b74:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	52                   	push   %edx
  801b7e:	50                   	push   %eax
  801b7f:	6a 1d                	push   $0x1d
  801b81:	e8 ae fc ff ff       	call   801834 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
	return result;
  801b89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b8f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b92:	89 01                	mov    %eax,(%ecx)
  801b94:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	c9                   	leave  
  801b9b:	c2 04 00             	ret    $0x4

00801b9e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	ff 75 10             	pushl  0x10(%ebp)
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	ff 75 08             	pushl  0x8(%ebp)
  801bae:	6a 13                	push   $0x13
  801bb0:	e8 7f fc ff ff       	call   801834 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb8:	90                   	nop
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_rcr2>:
uint32 sys_rcr2()
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 1e                	push   $0x1e
  801bca:	e8 65 fc ff ff       	call   801834 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	83 ec 04             	sub    $0x4,%esp
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801be0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	50                   	push   %eax
  801bed:	6a 1f                	push   $0x1f
  801bef:	e8 40 fc ff ff       	call   801834 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf7:	90                   	nop
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <rsttst>:
void rsttst()
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 21                	push   $0x21
  801c09:	e8 26 fc ff ff       	call   801834 <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c11:	90                   	nop
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 04             	sub    $0x4,%esp
  801c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c20:	8b 55 18             	mov    0x18(%ebp),%edx
  801c23:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c27:	52                   	push   %edx
  801c28:	50                   	push   %eax
  801c29:	ff 75 10             	pushl  0x10(%ebp)
  801c2c:	ff 75 0c             	pushl  0xc(%ebp)
  801c2f:	ff 75 08             	pushl  0x8(%ebp)
  801c32:	6a 20                	push   $0x20
  801c34:	e8 fb fb ff ff       	call   801834 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3c:	90                   	nop
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <chktst>:
void chktst(uint32 n)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	ff 75 08             	pushl  0x8(%ebp)
  801c4d:	6a 22                	push   $0x22
  801c4f:	e8 e0 fb ff ff       	call   801834 <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
	return ;
  801c57:	90                   	nop
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <inctst>:

void inctst()
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 23                	push   $0x23
  801c69:	e8 c6 fb ff ff       	call   801834 <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c71:	90                   	nop
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <gettst>:
uint32 gettst()
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 24                	push   $0x24
  801c83:	e8 ac fb ff ff       	call   801834 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 25                	push   $0x25
  801c9c:	e8 93 fb ff ff       	call   801834 <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
  801ca4:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801ca9:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	ff 75 08             	pushl  0x8(%ebp)
  801cc6:	6a 26                	push   $0x26
  801cc8:	e8 67 fb ff ff       	call   801834 <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd0:	90                   	nop
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cd7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cda:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	6a 00                	push   $0x0
  801ce5:	53                   	push   %ebx
  801ce6:	51                   	push   %ecx
  801ce7:	52                   	push   %edx
  801ce8:	50                   	push   %eax
  801ce9:	6a 27                	push   $0x27
  801ceb:	e8 44 fb ff ff       	call   801834 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
}
  801cf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	52                   	push   %edx
  801d08:	50                   	push   %eax
  801d09:	6a 28                	push   $0x28
  801d0b:	e8 24 fb ff ff       	call   801834 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d18:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	6a 00                	push   $0x0
  801d23:	51                   	push   %ecx
  801d24:	ff 75 10             	pushl  0x10(%ebp)
  801d27:	52                   	push   %edx
  801d28:	50                   	push   %eax
  801d29:	6a 29                	push   $0x29
  801d2b:	e8 04 fb ff ff       	call   801834 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	ff 75 10             	pushl  0x10(%ebp)
  801d3f:	ff 75 0c             	pushl  0xc(%ebp)
  801d42:	ff 75 08             	pushl  0x8(%ebp)
  801d45:	6a 12                	push   $0x12
  801d47:	e8 e8 fa ff ff       	call   801834 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4f:	90                   	nop
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	52                   	push   %edx
  801d62:	50                   	push   %eax
  801d63:	6a 2a                	push   $0x2a
  801d65:	e8 ca fa ff ff       	call   801834 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
	return;
  801d6d:	90                   	nop
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 2b                	push   $0x2b
  801d7f:	e8 b0 fa ff ff       	call   801834 <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	ff 75 0c             	pushl  0xc(%ebp)
  801d95:	ff 75 08             	pushl  0x8(%ebp)
  801d98:	6a 2d                	push   $0x2d
  801d9a:	e8 95 fa ff ff       	call   801834 <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
	return;
  801da2:	90                   	nop
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	ff 75 0c             	pushl  0xc(%ebp)
  801db1:	ff 75 08             	pushl  0x8(%ebp)
  801db4:	6a 2c                	push   $0x2c
  801db6:	e8 79 fa ff ff       	call   801834 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbe:	90                   	nop
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	52                   	push   %edx
  801dd1:	50                   	push   %eax
  801dd2:	6a 2e                	push   $0x2e
  801dd4:	e8 5b fa ff ff       	call   801834 <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddc:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801de5:	8b 55 08             	mov    0x8(%ebp),%edx
  801de8:	89 d0                	mov    %edx,%eax
  801dea:	c1 e0 02             	shl    $0x2,%eax
  801ded:	01 d0                	add    %edx,%eax
  801def:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801df6:	01 d0                	add    %edx,%eax
  801df8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dff:	01 d0                	add    %edx,%eax
  801e01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e08:	01 d0                	add    %edx,%eax
  801e0a:	c1 e0 04             	shl    $0x4,%eax
  801e0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801e10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e17:	0f 31                	rdtsc  
  801e19:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e1c:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e22:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e28:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e2b:	eb 46                	jmp    801e73 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e2d:	0f 31                	rdtsc  
  801e2f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e32:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e38:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e3e:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e47:	29 c2                	sub    %eax,%edx
  801e49:	89 d0                	mov    %edx,%eax
  801e4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e4e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e54:	89 d1                	mov    %edx,%ecx
  801e56:	29 c1                	sub    %eax,%ecx
  801e58:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e5e:	39 c2                	cmp    %eax,%edx
  801e60:	0f 97 c0             	seta   %al
  801e63:	0f b6 c0             	movzbl %al,%eax
  801e66:	29 c1                	sub    %eax,%ecx
  801e68:	89 c8                	mov    %ecx,%eax
  801e6a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e79:	72 b2                	jb     801e2d <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e7b:	90                   	nop
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801e8b:	eb 03                	jmp    801e90 <busy_wait+0x12>
  801e8d:	ff 45 fc             	incl   -0x4(%ebp)
  801e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e93:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e96:	72 f5                	jb     801e8d <busy_wait+0xf>
	return i;
  801e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea6:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801ea9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801ead:	83 ec 0c             	sub    $0xc,%esp
  801eb0:	50                   	push   %eax
  801eb1:	e8 35 fb ff ff       	call   8019eb <sys_cputc>
  801eb6:	83 c4 10             	add    $0x10,%esp
}
  801eb9:	90                   	nop
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <getchar>:


int
getchar(void)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801ec2:	e8 c3 f9 ff ff       	call   80188a <sys_cgetc>
  801ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <iscons>:

int iscons(int fdnum)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801ed2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ed7:	5d                   	pop    %ebp
  801ed8:	c3                   	ret    
  801ed9:	66 90                	xchg   %ax,%ax
  801edb:	90                   	nop

00801edc <__udivdi3>:
  801edc:	55                   	push   %ebp
  801edd:	57                   	push   %edi
  801ede:	56                   	push   %esi
  801edf:	53                   	push   %ebx
  801ee0:	83 ec 1c             	sub    $0x1c,%esp
  801ee3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ee7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801eeb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801eef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ef3:	89 ca                	mov    %ecx,%edx
  801ef5:	89 f8                	mov    %edi,%eax
  801ef7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801efb:	85 f6                	test   %esi,%esi
  801efd:	75 2d                	jne    801f2c <__udivdi3+0x50>
  801eff:	39 cf                	cmp    %ecx,%edi
  801f01:	77 65                	ja     801f68 <__udivdi3+0x8c>
  801f03:	89 fd                	mov    %edi,%ebp
  801f05:	85 ff                	test   %edi,%edi
  801f07:	75 0b                	jne    801f14 <__udivdi3+0x38>
  801f09:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0e:	31 d2                	xor    %edx,%edx
  801f10:	f7 f7                	div    %edi
  801f12:	89 c5                	mov    %eax,%ebp
  801f14:	31 d2                	xor    %edx,%edx
  801f16:	89 c8                	mov    %ecx,%eax
  801f18:	f7 f5                	div    %ebp
  801f1a:	89 c1                	mov    %eax,%ecx
  801f1c:	89 d8                	mov    %ebx,%eax
  801f1e:	f7 f5                	div    %ebp
  801f20:	89 cf                	mov    %ecx,%edi
  801f22:	89 fa                	mov    %edi,%edx
  801f24:	83 c4 1c             	add    $0x1c,%esp
  801f27:	5b                   	pop    %ebx
  801f28:	5e                   	pop    %esi
  801f29:	5f                   	pop    %edi
  801f2a:	5d                   	pop    %ebp
  801f2b:	c3                   	ret    
  801f2c:	39 ce                	cmp    %ecx,%esi
  801f2e:	77 28                	ja     801f58 <__udivdi3+0x7c>
  801f30:	0f bd fe             	bsr    %esi,%edi
  801f33:	83 f7 1f             	xor    $0x1f,%edi
  801f36:	75 40                	jne    801f78 <__udivdi3+0x9c>
  801f38:	39 ce                	cmp    %ecx,%esi
  801f3a:	72 0a                	jb     801f46 <__udivdi3+0x6a>
  801f3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f40:	0f 87 9e 00 00 00    	ja     801fe4 <__udivdi3+0x108>
  801f46:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4b:	89 fa                	mov    %edi,%edx
  801f4d:	83 c4 1c             	add    $0x1c,%esp
  801f50:	5b                   	pop    %ebx
  801f51:	5e                   	pop    %esi
  801f52:	5f                   	pop    %edi
  801f53:	5d                   	pop    %ebp
  801f54:	c3                   	ret    
  801f55:	8d 76 00             	lea    0x0(%esi),%esi
  801f58:	31 ff                	xor    %edi,%edi
  801f5a:	31 c0                	xor    %eax,%eax
  801f5c:	89 fa                	mov    %edi,%edx
  801f5e:	83 c4 1c             	add    $0x1c,%esp
  801f61:	5b                   	pop    %ebx
  801f62:	5e                   	pop    %esi
  801f63:	5f                   	pop    %edi
  801f64:	5d                   	pop    %ebp
  801f65:	c3                   	ret    
  801f66:	66 90                	xchg   %ax,%ax
  801f68:	89 d8                	mov    %ebx,%eax
  801f6a:	f7 f7                	div    %edi
  801f6c:	31 ff                	xor    %edi,%edi
  801f6e:	89 fa                	mov    %edi,%edx
  801f70:	83 c4 1c             	add    $0x1c,%esp
  801f73:	5b                   	pop    %ebx
  801f74:	5e                   	pop    %esi
  801f75:	5f                   	pop    %edi
  801f76:	5d                   	pop    %ebp
  801f77:	c3                   	ret    
  801f78:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f7d:	89 eb                	mov    %ebp,%ebx
  801f7f:	29 fb                	sub    %edi,%ebx
  801f81:	89 f9                	mov    %edi,%ecx
  801f83:	d3 e6                	shl    %cl,%esi
  801f85:	89 c5                	mov    %eax,%ebp
  801f87:	88 d9                	mov    %bl,%cl
  801f89:	d3 ed                	shr    %cl,%ebp
  801f8b:	89 e9                	mov    %ebp,%ecx
  801f8d:	09 f1                	or     %esi,%ecx
  801f8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f93:	89 f9                	mov    %edi,%ecx
  801f95:	d3 e0                	shl    %cl,%eax
  801f97:	89 c5                	mov    %eax,%ebp
  801f99:	89 d6                	mov    %edx,%esi
  801f9b:	88 d9                	mov    %bl,%cl
  801f9d:	d3 ee                	shr    %cl,%esi
  801f9f:	89 f9                	mov    %edi,%ecx
  801fa1:	d3 e2                	shl    %cl,%edx
  801fa3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fa7:	88 d9                	mov    %bl,%cl
  801fa9:	d3 e8                	shr    %cl,%eax
  801fab:	09 c2                	or     %eax,%edx
  801fad:	89 d0                	mov    %edx,%eax
  801faf:	89 f2                	mov    %esi,%edx
  801fb1:	f7 74 24 0c          	divl   0xc(%esp)
  801fb5:	89 d6                	mov    %edx,%esi
  801fb7:	89 c3                	mov    %eax,%ebx
  801fb9:	f7 e5                	mul    %ebp
  801fbb:	39 d6                	cmp    %edx,%esi
  801fbd:	72 19                	jb     801fd8 <__udivdi3+0xfc>
  801fbf:	74 0b                	je     801fcc <__udivdi3+0xf0>
  801fc1:	89 d8                	mov    %ebx,%eax
  801fc3:	31 ff                	xor    %edi,%edi
  801fc5:	e9 58 ff ff ff       	jmp    801f22 <__udivdi3+0x46>
  801fca:	66 90                	xchg   %ax,%ax
  801fcc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fd0:	89 f9                	mov    %edi,%ecx
  801fd2:	d3 e2                	shl    %cl,%edx
  801fd4:	39 c2                	cmp    %eax,%edx
  801fd6:	73 e9                	jae    801fc1 <__udivdi3+0xe5>
  801fd8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fdb:	31 ff                	xor    %edi,%edi
  801fdd:	e9 40 ff ff ff       	jmp    801f22 <__udivdi3+0x46>
  801fe2:	66 90                	xchg   %ax,%ax
  801fe4:	31 c0                	xor    %eax,%eax
  801fe6:	e9 37 ff ff ff       	jmp    801f22 <__udivdi3+0x46>
  801feb:	90                   	nop

00801fec <__umoddi3>:
  801fec:	55                   	push   %ebp
  801fed:	57                   	push   %edi
  801fee:	56                   	push   %esi
  801fef:	53                   	push   %ebx
  801ff0:	83 ec 1c             	sub    $0x1c,%esp
  801ff3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ff7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ffb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802003:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802007:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80200b:	89 f3                	mov    %esi,%ebx
  80200d:	89 fa                	mov    %edi,%edx
  80200f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802013:	89 34 24             	mov    %esi,(%esp)
  802016:	85 c0                	test   %eax,%eax
  802018:	75 1a                	jne    802034 <__umoddi3+0x48>
  80201a:	39 f7                	cmp    %esi,%edi
  80201c:	0f 86 a2 00 00 00    	jbe    8020c4 <__umoddi3+0xd8>
  802022:	89 c8                	mov    %ecx,%eax
  802024:	89 f2                	mov    %esi,%edx
  802026:	f7 f7                	div    %edi
  802028:	89 d0                	mov    %edx,%eax
  80202a:	31 d2                	xor    %edx,%edx
  80202c:	83 c4 1c             	add    $0x1c,%esp
  80202f:	5b                   	pop    %ebx
  802030:	5e                   	pop    %esi
  802031:	5f                   	pop    %edi
  802032:	5d                   	pop    %ebp
  802033:	c3                   	ret    
  802034:	39 f0                	cmp    %esi,%eax
  802036:	0f 87 ac 00 00 00    	ja     8020e8 <__umoddi3+0xfc>
  80203c:	0f bd e8             	bsr    %eax,%ebp
  80203f:	83 f5 1f             	xor    $0x1f,%ebp
  802042:	0f 84 ac 00 00 00    	je     8020f4 <__umoddi3+0x108>
  802048:	bf 20 00 00 00       	mov    $0x20,%edi
  80204d:	29 ef                	sub    %ebp,%edi
  80204f:	89 fe                	mov    %edi,%esi
  802051:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802055:	89 e9                	mov    %ebp,%ecx
  802057:	d3 e0                	shl    %cl,%eax
  802059:	89 d7                	mov    %edx,%edi
  80205b:	89 f1                	mov    %esi,%ecx
  80205d:	d3 ef                	shr    %cl,%edi
  80205f:	09 c7                	or     %eax,%edi
  802061:	89 e9                	mov    %ebp,%ecx
  802063:	d3 e2                	shl    %cl,%edx
  802065:	89 14 24             	mov    %edx,(%esp)
  802068:	89 d8                	mov    %ebx,%eax
  80206a:	d3 e0                	shl    %cl,%eax
  80206c:	89 c2                	mov    %eax,%edx
  80206e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802072:	d3 e0                	shl    %cl,%eax
  802074:	89 44 24 04          	mov    %eax,0x4(%esp)
  802078:	8b 44 24 08          	mov    0x8(%esp),%eax
  80207c:	89 f1                	mov    %esi,%ecx
  80207e:	d3 e8                	shr    %cl,%eax
  802080:	09 d0                	or     %edx,%eax
  802082:	d3 eb                	shr    %cl,%ebx
  802084:	89 da                	mov    %ebx,%edx
  802086:	f7 f7                	div    %edi
  802088:	89 d3                	mov    %edx,%ebx
  80208a:	f7 24 24             	mull   (%esp)
  80208d:	89 c6                	mov    %eax,%esi
  80208f:	89 d1                	mov    %edx,%ecx
  802091:	39 d3                	cmp    %edx,%ebx
  802093:	0f 82 87 00 00 00    	jb     802120 <__umoddi3+0x134>
  802099:	0f 84 91 00 00 00    	je     802130 <__umoddi3+0x144>
  80209f:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020a3:	29 f2                	sub    %esi,%edx
  8020a5:	19 cb                	sbb    %ecx,%ebx
  8020a7:	89 d8                	mov    %ebx,%eax
  8020a9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020ad:	d3 e0                	shl    %cl,%eax
  8020af:	89 e9                	mov    %ebp,%ecx
  8020b1:	d3 ea                	shr    %cl,%edx
  8020b3:	09 d0                	or     %edx,%eax
  8020b5:	89 e9                	mov    %ebp,%ecx
  8020b7:	d3 eb                	shr    %cl,%ebx
  8020b9:	89 da                	mov    %ebx,%edx
  8020bb:	83 c4 1c             	add    $0x1c,%esp
  8020be:	5b                   	pop    %ebx
  8020bf:	5e                   	pop    %esi
  8020c0:	5f                   	pop    %edi
  8020c1:	5d                   	pop    %ebp
  8020c2:	c3                   	ret    
  8020c3:	90                   	nop
  8020c4:	89 fd                	mov    %edi,%ebp
  8020c6:	85 ff                	test   %edi,%edi
  8020c8:	75 0b                	jne    8020d5 <__umoddi3+0xe9>
  8020ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8020cf:	31 d2                	xor    %edx,%edx
  8020d1:	f7 f7                	div    %edi
  8020d3:	89 c5                	mov    %eax,%ebp
  8020d5:	89 f0                	mov    %esi,%eax
  8020d7:	31 d2                	xor    %edx,%edx
  8020d9:	f7 f5                	div    %ebp
  8020db:	89 c8                	mov    %ecx,%eax
  8020dd:	f7 f5                	div    %ebp
  8020df:	89 d0                	mov    %edx,%eax
  8020e1:	e9 44 ff ff ff       	jmp    80202a <__umoddi3+0x3e>
  8020e6:	66 90                	xchg   %ax,%ax
  8020e8:	89 c8                	mov    %ecx,%eax
  8020ea:	89 f2                	mov    %esi,%edx
  8020ec:	83 c4 1c             	add    $0x1c,%esp
  8020ef:	5b                   	pop    %ebx
  8020f0:	5e                   	pop    %esi
  8020f1:	5f                   	pop    %edi
  8020f2:	5d                   	pop    %ebp
  8020f3:	c3                   	ret    
  8020f4:	3b 04 24             	cmp    (%esp),%eax
  8020f7:	72 06                	jb     8020ff <__umoddi3+0x113>
  8020f9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020fd:	77 0f                	ja     80210e <__umoddi3+0x122>
  8020ff:	89 f2                	mov    %esi,%edx
  802101:	29 f9                	sub    %edi,%ecx
  802103:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802107:	89 14 24             	mov    %edx,(%esp)
  80210a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80210e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802112:	8b 14 24             	mov    (%esp),%edx
  802115:	83 c4 1c             	add    $0x1c,%esp
  802118:	5b                   	pop    %ebx
  802119:	5e                   	pop    %esi
  80211a:	5f                   	pop    %edi
  80211b:	5d                   	pop    %ebp
  80211c:	c3                   	ret    
  80211d:	8d 76 00             	lea    0x0(%esi),%esi
  802120:	2b 04 24             	sub    (%esp),%eax
  802123:	19 fa                	sbb    %edi,%edx
  802125:	89 d1                	mov    %edx,%ecx
  802127:	89 c6                	mov    %eax,%esi
  802129:	e9 71 ff ff ff       	jmp    80209f <__umoddi3+0xb3>
  80212e:	66 90                	xchg   %ax,%ax
  802130:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802134:	72 ea                	jb     802120 <__umoddi3+0x134>
  802136:	89 d9                	mov    %ebx,%ecx
  802138:	e9 62 ff ff ff       	jmp    80209f <__umoddi3+0xb3>
