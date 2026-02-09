
obj/user/tst_chan_all_master:     file format elf32-i386


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
  800031:	e8 57 02 00 00       	call   80028d <libmain>
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
  80004e:	e8 05 07 00 00       	call   800758 <cprintf_colored>
  800053:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	68 70 21 80 00       	push   $0x802170
  80005e:	6a 0e                	push   $0xe
  800060:	e8 f3 06 00 00       	call   800758 <cprintf_colored>
  800065:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	68 40 21 80 00       	push   $0x802140
  800070:	6a 0e                	push   $0xe
  800072:	e8 e1 06 00 00       	call   800758 <cprintf_colored>
  800077:	83 c4 10             	add    $0x10,%esp


	int envID = sys_getenvid();
  80007a:	e8 68 1a 00 00       	call   801ae7 <sys_getenvid>
  80007f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	char slavesCnt[10];
	readline("Enter the number of Slave Programs: ", slavesCnt);
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	8d 45 ca             	lea    -0x36(%ebp),%eax
  800088:	50                   	push   %eax
  800089:	68 cc 21 80 00       	push   $0x8021cc
  80008e:	e8 71 0d 00 00       	call   800e04 <readline>
  800093:	83 c4 10             	add    $0x10,%esp
	int numOfSlaves = strtol(slavesCnt, NULL, 10);
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	6a 00                	push   $0x0
  80009d:	8d 45 ca             	lea    -0x36(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 75 13 00 00       	call   80141b <strtol>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  8000ac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8000b3:	eb 6a                	jmp    80011f <_main+0xe7>
	{
		id = sys_create_env("tstChanAllSlave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ba:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  8000c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c5:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8000cb:	89 c1                	mov    %eax,%ecx
  8000cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000d8:	52                   	push   %edx
  8000d9:	51                   	push   %ecx
  8000da:	50                   	push   %eax
  8000db:	68 f1 21 80 00       	push   $0x8021f1
  8000e0:	e8 ad 19 00 00       	call   801a92 <sys_create_env>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (id== E_ENV_CREATION_ERROR)
  8000eb:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  8000ef:	75 1d                	jne    80010e <_main+0xd6>
		{
			cprintf_colored(TEXT_TESTERR_CLR, "\n%~insufficient number of processes in the system! only %d slave processes are created\n", i);
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	68 04 22 80 00       	push   $0x802204
  8000fc:	6a 0c                	push   $0xc
  8000fe:	e8 55 06 00 00       	call   800758 <cprintf_colored>
  800103:	83 c4 10             	add    $0x10,%esp
			numOfSlaves = i;
  800106:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			break;
  80010c:	eb 19                	jmp    800127 <_main+0xef>
		}
		sys_run_env(id);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 d4             	pushl  -0x2c(%ebp)
  800114:	e8 97 19 00 00       	call   801ab0 <sys_run_env>
  800119:	83 c4 10             	add    $0x10,%esp
	readline("Enter the number of Slave Programs: ", slavesCnt);
	int numOfSlaves = strtol(slavesCnt, NULL, 10);

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  80011c:	ff 45 e0             	incl   -0x20(%ebp)
  80011f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800122:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800125:	7c 8e                	jl     8000b5 <_main+0x7d>
		}
		sys_run_env(id);
	}

	//Wait until all slaves are blocked
	int numOfBlockedProcesses = 0;
  800127:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	char cmd1[64] = "__GetChanQueueSize__";
  80012e:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800131:	bb 56 23 80 00       	mov    $0x802356,%ebx
  800136:	ba 15 00 00 00       	mov    $0x15,%edx
  80013b:	89 c7                	mov    %eax,%edi
  80013d:	89 de                	mov    %ebx,%esi
  80013f:	89 d1                	mov    %edx,%ecx
  800141:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800143:	8d 55 99             	lea    -0x67(%ebp),%edx
  800146:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  80014b:	b0 00                	mov    $0x0,%al
  80014d:	89 d7                	mov    %edx,%edi
  80014f:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd1, (uint32)(&numOfBlockedProcesses));
  800151:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  800154:	83 ec 08             	sub    $0x8,%esp
  800157:	50                   	push   %eax
  800158:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80015b:	50                   	push   %eax
  80015c:	e8 d5 1b 00 00       	call   801d36 <sys_utilities>
  800161:	83 c4 10             	add    $0x10,%esp
	int cnt = 0;
  800164:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	while (numOfBlockedProcesses != numOfSlaves)
  80016b:	eb 75                	jmp    8001e2 <_main+0x1aa>
	{
		env_sleep(5000);
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	68 88 13 00 00       	push   $0x1388
  800175:	e8 49 1c 00 00       	call   801dc3 <env_sleep>
  80017a:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  80017d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800180:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800183:	75 1b                	jne    8001a0 <_main+0x168>
		{
			panic("%~test channels failed! unexpected number of blocked slaves. Expected = %d, Current = %d", numOfSlaves, numOfBlockedProcesses);
  800185:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	50                   	push   %eax
  80018c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80018f:	68 5c 22 80 00       	push   $0x80225c
  800194:	6a 2a                	push   $0x2a
  800196:	68 b5 22 80 00       	push   $0x8022b5
  80019b:	e8 9d 02 00 00       	call   80043d <_panic>
		}
		char cmd2[64] = "__GetChanQueueSize__";
  8001a0:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  8001a6:	bb 56 23 80 00       	mov    $0x802356,%ebx
  8001ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8001b0:	89 c7                	mov    %eax,%edi
  8001b2:	89 de                	mov    %ebx,%esi
  8001b4:	89 d1                	mov    %edx,%ecx
  8001b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001b8:	8d 95 19 ff ff ff    	lea    -0xe7(%ebp),%edx
  8001be:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  8001c3:	b0 00                	mov    $0x0,%al
  8001c5:	89 d7                	mov    %edx,%edi
  8001c7:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
  8001c9:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	50                   	push   %eax
  8001d0:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  8001d6:	50                   	push   %eax
  8001d7:	e8 5a 1b 00 00       	call   801d36 <sys_utilities>
  8001dc:	83 c4 10             	add    $0x10,%esp
		cnt++ ;
  8001df:	ff 45 dc             	incl   -0x24(%ebp)
	//Wait until all slaves are blocked
	int numOfBlockedProcesses = 0;
	char cmd1[64] = "__GetChanQueueSize__";
	sys_utilities(cmd1, (uint32)(&numOfBlockedProcesses));
	int cnt = 0;
	while (numOfBlockedProcesses != numOfSlaves)
  8001e2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001e5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001e8:	75 83                	jne    80016d <_main+0x135>
		char cmd2[64] = "__GetChanQueueSize__";
		sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
		cnt++ ;
	}

	rsttst();
  8001ea:	e8 ef 19 00 00       	call   801bde <rsttst>

	//Wakeup all
	char cmd3[64] = "__WakeupAll__";
  8001ef:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  8001f5:	bb 96 23 80 00       	mov    $0x802396,%ebx
  8001fa:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ff:	89 c7                	mov    %eax,%edi
  800201:	89 de                	mov    %ebx,%esi
  800203:	89 d1                	mov    %edx,%ecx
  800205:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800207:	8d 95 52 ff ff ff    	lea    -0xae(%ebp),%edx
  80020d:	b9 32 00 00 00       	mov    $0x32,%ecx
  800212:	b0 00                	mov    $0x0,%al
  800214:	89 d7                	mov    %edx,%edi
  800216:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd3, 0);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	6a 00                	push   $0x0
  80021d:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  800223:	50                   	push   %eax
  800224:	e8 0d 1b 00 00       	call   801d36 <sys_utilities>
  800229:	83 c4 10             	add    $0x10,%esp

	//Wait until all slave finished
	cnt = 0;
  80022c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	while (gettst() != numOfSlaves)
  800233:	eb 2f                	jmp    800264 <_main+0x22c>
	{
		env_sleep(5000);
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	68 88 13 00 00       	push   $0x1388
  80023d:	e8 81 1b 00 00       	call   801dc3 <env_sleep>
  800242:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  800245:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800248:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80024b:	75 14                	jne    800261 <_main+0x229>
		{
			panic("%~test channels failed! not all slaves finished");
  80024d:	83 ec 04             	sub    $0x4,%esp
  800250:	68 d0 22 80 00       	push   $0x8022d0
  800255:	6a 3e                	push   $0x3e
  800257:	68 b5 22 80 00       	push   $0x8022b5
  80025c:	e8 dc 01 00 00       	call   80043d <_panic>
		}
		cnt++ ;
  800261:	ff 45 dc             	incl   -0x24(%ebp)
	char cmd3[64] = "__WakeupAll__";
	sys_utilities(cmd3, 0);

	//Wait until all slave finished
	cnt = 0;
	while (gettst() != numOfSlaves)
  800264:	e8 ef 19 00 00       	call   801c58 <gettst>
  800269:	89 c2                	mov    %eax,%edx
  80026b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80026e:	39 c2                	cmp    %eax,%edx
  800270:	75 c3                	jne    800235 <_main+0x1fd>
			panic("%~test channels failed! not all slaves finished");
		}
		cnt++ ;
	}

	cprintf_colored(TEXT_light_green, "%~\n\nCongratulations!! Test of Channel (sleep & wakeup ALL) completed successfully!!\n\n");
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	68 00 23 80 00       	push   $0x802300
  80027a:	6a 0a                	push   $0xa
  80027c:	e8 d7 04 00 00       	call   800758 <cprintf_colored>
  800281:	83 c4 10             	add    $0x10,%esp

	return;
  800284:	90                   	nop
}
  800285:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800288:	5b                   	pop    %ebx
  800289:	5e                   	pop    %esi
  80028a:	5f                   	pop    %edi
  80028b:	5d                   	pop    %ebp
  80028c:	c3                   	ret    

0080028d <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	57                   	push   %edi
  800291:	56                   	push   %esi
  800292:	53                   	push   %ebx
  800293:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800296:	e8 65 18 00 00       	call   801b00 <sys_getenvindex>
  80029b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80029e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a1:	89 d0                	mov    %edx,%eax
  8002a3:	01 c0                	add    %eax,%eax
  8002a5:	01 d0                	add    %edx,%eax
  8002a7:	c1 e0 02             	shl    $0x2,%eax
  8002aa:	01 d0                	add    %edx,%eax
  8002ac:	c1 e0 02             	shl    $0x2,%eax
  8002af:	01 d0                	add    %edx,%eax
  8002b1:	c1 e0 03             	shl    $0x3,%eax
  8002b4:	01 d0                	add    %edx,%eax
  8002b6:	c1 e0 02             	shl    $0x2,%eax
  8002b9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002be:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c8:	8a 40 20             	mov    0x20(%eax),%al
  8002cb:	84 c0                	test   %al,%al
  8002cd:	74 0d                	je     8002dc <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d4:	83 c0 20             	add    $0x20,%eax
  8002d7:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002e0:	7e 0a                	jle    8002ec <libmain+0x5f>
		binaryname = argv[0];
  8002e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e5:	8b 00                	mov    (%eax),%eax
  8002e7:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002ec:	83 ec 08             	sub    $0x8,%esp
  8002ef:	ff 75 0c             	pushl  0xc(%ebp)
  8002f2:	ff 75 08             	pushl  0x8(%ebp)
  8002f5:	e8 3e fd ff ff       	call   800038 <_main>
  8002fa:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002fd:	a1 00 30 80 00       	mov    0x803000,%eax
  800302:	85 c0                	test   %eax,%eax
  800304:	0f 84 01 01 00 00    	je     80040b <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80030a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800310:	bb d0 24 80 00       	mov    $0x8024d0,%ebx
  800315:	ba 0e 00 00 00       	mov    $0xe,%edx
  80031a:	89 c7                	mov    %eax,%edi
  80031c:	89 de                	mov    %ebx,%esi
  80031e:	89 d1                	mov    %edx,%ecx
  800320:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800322:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800325:	b9 56 00 00 00       	mov    $0x56,%ecx
  80032a:	b0 00                	mov    $0x0,%al
  80032c:	89 d7                	mov    %edx,%edi
  80032e:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800330:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800337:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80033a:	83 ec 08             	sub    $0x8,%esp
  80033d:	50                   	push   %eax
  80033e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800344:	50                   	push   %eax
  800345:	e8 ec 19 00 00       	call   801d36 <sys_utilities>
  80034a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80034d:	e8 35 15 00 00       	call   801887 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	68 f0 23 80 00       	push   $0x8023f0
  80035a:	e8 cc 03 00 00       	call   80072b <cprintf>
  80035f:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800362:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800365:	85 c0                	test   %eax,%eax
  800367:	74 18                	je     800381 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800369:	e8 e6 19 00 00       	call   801d54 <sys_get_optimal_num_faults>
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	50                   	push   %eax
  800372:	68 18 24 80 00       	push   $0x802418
  800377:	e8 af 03 00 00       	call   80072b <cprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	eb 59                	jmp    8003da <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800381:	a1 20 30 80 00       	mov    0x803020,%eax
  800386:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80038c:	a1 20 30 80 00       	mov    0x803020,%eax
  800391:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800397:	83 ec 04             	sub    $0x4,%esp
  80039a:	52                   	push   %edx
  80039b:	50                   	push   %eax
  80039c:	68 3c 24 80 00       	push   $0x80243c
  8003a1:	e8 85 03 00 00       	call   80072b <cprintf>
  8003a6:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ae:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8003b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b9:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8003bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c4:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8003ca:	51                   	push   %ecx
  8003cb:	52                   	push   %edx
  8003cc:	50                   	push   %eax
  8003cd:	68 64 24 80 00       	push   $0x802464
  8003d2:	e8 54 03 00 00       	call   80072b <cprintf>
  8003d7:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003da:	a1 20 30 80 00       	mov    0x803020,%eax
  8003df:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8003e5:	83 ec 08             	sub    $0x8,%esp
  8003e8:	50                   	push   %eax
  8003e9:	68 bc 24 80 00       	push   $0x8024bc
  8003ee:	e8 38 03 00 00       	call   80072b <cprintf>
  8003f3:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003f6:	83 ec 0c             	sub    $0xc,%esp
  8003f9:	68 f0 23 80 00       	push   $0x8023f0
  8003fe:	e8 28 03 00 00       	call   80072b <cprintf>
  800403:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800406:	e8 96 14 00 00       	call   8018a1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80040b:	e8 1f 00 00 00       	call   80042f <exit>
}
  800410:	90                   	nop
  800411:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800414:	5b                   	pop    %ebx
  800415:	5e                   	pop    %esi
  800416:	5f                   	pop    %edi
  800417:	5d                   	pop    %ebp
  800418:	c3                   	ret    

00800419 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80041f:	83 ec 0c             	sub    $0xc,%esp
  800422:	6a 00                	push   $0x0
  800424:	e8 a3 16 00 00       	call   801acc <sys_destroy_env>
  800429:	83 c4 10             	add    $0x10,%esp
}
  80042c:	90                   	nop
  80042d:	c9                   	leave  
  80042e:	c3                   	ret    

0080042f <exit>:

void
exit(void)
{
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
  800432:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800435:	e8 f8 16 00 00       	call   801b32 <sys_exit_env>
}
  80043a:	90                   	nop
  80043b:	c9                   	leave  
  80043c:	c3                   	ret    

0080043d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
  800440:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800443:	8d 45 10             	lea    0x10(%ebp),%eax
  800446:	83 c0 04             	add    $0x4,%eax
  800449:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80044c:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800451:	85 c0                	test   %eax,%eax
  800453:	74 16                	je     80046b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800455:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	50                   	push   %eax
  80045e:	68 34 25 80 00       	push   $0x802534
  800463:	e8 c3 02 00 00       	call   80072b <cprintf>
  800468:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80046b:	a1 04 30 80 00       	mov    0x803004,%eax
  800470:	83 ec 0c             	sub    $0xc,%esp
  800473:	ff 75 0c             	pushl  0xc(%ebp)
  800476:	ff 75 08             	pushl  0x8(%ebp)
  800479:	50                   	push   %eax
  80047a:	68 3c 25 80 00       	push   $0x80253c
  80047f:	6a 74                	push   $0x74
  800481:	e8 d2 02 00 00       	call   800758 <cprintf_colored>
  800486:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800489:	8b 45 10             	mov    0x10(%ebp),%eax
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	ff 75 f4             	pushl  -0xc(%ebp)
  800492:	50                   	push   %eax
  800493:	e8 24 02 00 00       	call   8006bc <vcprintf>
  800498:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	6a 00                	push   $0x0
  8004a0:	68 64 25 80 00       	push   $0x802564
  8004a5:	e8 12 02 00 00       	call   8006bc <vcprintf>
  8004aa:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004ad:	e8 7d ff ff ff       	call   80042f <exit>

	// should not return here
	while (1) ;
  8004b2:	eb fe                	jmp    8004b2 <_panic+0x75>

008004b4 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	53                   	push   %ebx
  8004b8:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c9:	39 c2                	cmp    %eax,%edx
  8004cb:	74 14                	je     8004e1 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004cd:	83 ec 04             	sub    $0x4,%esp
  8004d0:	68 68 25 80 00       	push   $0x802568
  8004d5:	6a 26                	push   $0x26
  8004d7:	68 b4 25 80 00       	push   $0x8025b4
  8004dc:	e8 5c ff ff ff       	call   80043d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ef:	e9 d9 00 00 00       	jmp    8005cd <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8004f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	85 c0                	test   %eax,%eax
  800507:	75 08                	jne    800511 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800509:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80050c:	e9 b9 00 00 00       	jmp    8005ca <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800511:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800518:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80051f:	eb 79                	jmp    80059a <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800521:	a1 20 30 80 00       	mov    0x803020,%eax
  800526:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80052c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80052f:	89 d0                	mov    %edx,%eax
  800531:	01 c0                	add    %eax,%eax
  800533:	01 d0                	add    %edx,%eax
  800535:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80053c:	01 d8                	add    %ebx,%eax
  80053e:	01 d0                	add    %edx,%eax
  800540:	01 c8                	add    %ecx,%eax
  800542:	8a 40 04             	mov    0x4(%eax),%al
  800545:	84 c0                	test   %al,%al
  800547:	75 4e                	jne    800597 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800549:	a1 20 30 80 00       	mov    0x803020,%eax
  80054e:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800554:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800557:	89 d0                	mov    %edx,%eax
  800559:	01 c0                	add    %eax,%eax
  80055b:	01 d0                	add    %edx,%eax
  80055d:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800564:	01 d8                	add    %ebx,%eax
  800566:	01 d0                	add    %edx,%eax
  800568:	01 c8                	add    %ecx,%eax
  80056a:	8b 00                	mov    (%eax),%eax
  80056c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80056f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800572:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800577:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80057c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800583:	8b 45 08             	mov    0x8(%ebp),%eax
  800586:	01 c8                	add    %ecx,%eax
  800588:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80058a:	39 c2                	cmp    %eax,%edx
  80058c:	75 09                	jne    800597 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  80058e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800595:	eb 19                	jmp    8005b0 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800597:	ff 45 e8             	incl   -0x18(%ebp)
  80059a:	a1 20 30 80 00       	mov    0x803020,%eax
  80059f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	39 c2                	cmp    %eax,%edx
  8005aa:	0f 87 71 ff ff ff    	ja     800521 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005b4:	75 14                	jne    8005ca <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	68 c0 25 80 00       	push   $0x8025c0
  8005be:	6a 3a                	push   $0x3a
  8005c0:	68 b4 25 80 00       	push   $0x8025b4
  8005c5:	e8 73 fe ff ff       	call   80043d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005ca:	ff 45 f0             	incl   -0x10(%ebp)
  8005cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005d3:	0f 8c 1b ff ff ff    	jl     8004f4 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005e7:	eb 2e                	jmp    800617 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ee:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8005f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005f7:	89 d0                	mov    %edx,%eax
  8005f9:	01 c0                	add    %eax,%eax
  8005fb:	01 d0                	add    %edx,%eax
  8005fd:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800604:	01 d8                	add    %ebx,%eax
  800606:	01 d0                	add    %edx,%eax
  800608:	01 c8                	add    %ecx,%eax
  80060a:	8a 40 04             	mov    0x4(%eax),%al
  80060d:	3c 01                	cmp    $0x1,%al
  80060f:	75 03                	jne    800614 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800611:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800614:	ff 45 e0             	incl   -0x20(%ebp)
  800617:	a1 20 30 80 00       	mov    0x803020,%eax
  80061c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800622:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800625:	39 c2                	cmp    %eax,%edx
  800627:	77 c0                	ja     8005e9 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80062c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80062f:	74 14                	je     800645 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800631:	83 ec 04             	sub    $0x4,%esp
  800634:	68 14 26 80 00       	push   $0x802614
  800639:	6a 44                	push   $0x44
  80063b:	68 b4 25 80 00       	push   $0x8025b4
  800640:	e8 f8 fd ff ff       	call   80043d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800645:	90                   	nop
  800646:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
  80064e:	53                   	push   %ebx
  80064f:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800652:	8b 45 0c             	mov    0xc(%ebp),%eax
  800655:	8b 00                	mov    (%eax),%eax
  800657:	8d 48 01             	lea    0x1(%eax),%ecx
  80065a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80065d:	89 0a                	mov    %ecx,(%edx)
  80065f:	8b 55 08             	mov    0x8(%ebp),%edx
  800662:	88 d1                	mov    %dl,%cl
  800664:	8b 55 0c             	mov    0xc(%ebp),%edx
  800667:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80066b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066e:	8b 00                	mov    (%eax),%eax
  800670:	3d ff 00 00 00       	cmp    $0xff,%eax
  800675:	75 30                	jne    8006a7 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800677:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80067d:	a0 44 30 80 00       	mov    0x803044,%al
  800682:	0f b6 c0             	movzbl %al,%eax
  800685:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800688:	8b 09                	mov    (%ecx),%ecx
  80068a:	89 cb                	mov    %ecx,%ebx
  80068c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80068f:	83 c1 08             	add    $0x8,%ecx
  800692:	52                   	push   %edx
  800693:	50                   	push   %eax
  800694:	53                   	push   %ebx
  800695:	51                   	push   %ecx
  800696:	e8 a8 11 00 00       	call   801843 <sys_cputs>
  80069b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80069e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006aa:	8b 40 04             	mov    0x4(%eax),%eax
  8006ad:	8d 50 01             	lea    0x1(%eax),%edx
  8006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006b6:	90                   	nop
  8006b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ba:	c9                   	leave  
  8006bb:	c3                   	ret    

008006bc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006bc:	55                   	push   %ebp
  8006bd:	89 e5                	mov    %esp,%ebp
  8006bf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006c5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006cc:	00 00 00 
	b.cnt = 0;
  8006cf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006d6:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006d9:	ff 75 0c             	pushl  0xc(%ebp)
  8006dc:	ff 75 08             	pushl  0x8(%ebp)
  8006df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006e5:	50                   	push   %eax
  8006e6:	68 4b 06 80 00       	push   $0x80064b
  8006eb:	e8 5a 02 00 00       	call   80094a <vprintfmt>
  8006f0:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006f3:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006f9:	a0 44 30 80 00       	mov    0x803044,%al
  8006fe:	0f b6 c0             	movzbl %al,%eax
  800701:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800707:	52                   	push   %edx
  800708:	50                   	push   %eax
  800709:	51                   	push   %ecx
  80070a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800710:	83 c0 08             	add    $0x8,%eax
  800713:	50                   	push   %eax
  800714:	e8 2a 11 00 00       	call   801843 <sys_cputs>
  800719:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80071c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800723:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800731:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800738:	8d 45 0c             	lea    0xc(%ebp),%eax
  80073b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	ff 75 f4             	pushl  -0xc(%ebp)
  800747:	50                   	push   %eax
  800748:	e8 6f ff ff ff       	call   8006bc <vcprintf>
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800753:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800756:	c9                   	leave  
  800757:	c3                   	ret    

00800758 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80075e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	c1 e0 08             	shl    $0x8,%eax
  80076b:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800770:	8d 45 0c             	lea    0xc(%ebp),%eax
  800773:	83 c0 04             	add    $0x4,%eax
  800776:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800779:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	ff 75 f4             	pushl  -0xc(%ebp)
  800782:	50                   	push   %eax
  800783:	e8 34 ff ff ff       	call   8006bc <vcprintf>
  800788:	83 c4 10             	add    $0x10,%esp
  80078b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80078e:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800795:	07 00 00 

	return cnt;
  800798:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079b:	c9                   	leave  
  80079c:	c3                   	ret    

0080079d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007a3:	e8 df 10 00 00       	call   801887 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007a8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b7:	50                   	push   %eax
  8007b8:	e8 ff fe ff ff       	call   8006bc <vcprintf>
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007c3:	e8 d9 10 00 00       	call   8018a1 <sys_unlock_cons>
	return cnt;
  8007c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007cb:	c9                   	leave  
  8007cc:	c3                   	ret    

008007cd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007cd:	55                   	push   %ebp
  8007ce:	89 e5                	mov    %esp,%ebp
  8007d0:	53                   	push   %ebx
  8007d1:	83 ec 14             	sub    $0x14,%esp
  8007d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007e0:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007eb:	77 55                	ja     800842 <printnum+0x75>
  8007ed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f0:	72 05                	jb     8007f7 <printnum+0x2a>
  8007f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007f5:	77 4b                	ja     800842 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007f7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007fa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007fd:	8b 45 18             	mov    0x18(%ebp),%eax
  800800:	ba 00 00 00 00       	mov    $0x0,%edx
  800805:	52                   	push   %edx
  800806:	50                   	push   %eax
  800807:	ff 75 f4             	pushl  -0xc(%ebp)
  80080a:	ff 75 f0             	pushl  -0x10(%ebp)
  80080d:	e8 ae 16 00 00       	call   801ec0 <__udivdi3>
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	83 ec 04             	sub    $0x4,%esp
  800818:	ff 75 20             	pushl  0x20(%ebp)
  80081b:	53                   	push   %ebx
  80081c:	ff 75 18             	pushl  0x18(%ebp)
  80081f:	52                   	push   %edx
  800820:	50                   	push   %eax
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	ff 75 08             	pushl  0x8(%ebp)
  800827:	e8 a1 ff ff ff       	call   8007cd <printnum>
  80082c:	83 c4 20             	add    $0x20,%esp
  80082f:	eb 1a                	jmp    80084b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	ff 75 0c             	pushl  0xc(%ebp)
  800837:	ff 75 20             	pushl  0x20(%ebp)
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800842:	ff 4d 1c             	decl   0x1c(%ebp)
  800845:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800849:	7f e6                	jg     800831 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80084b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80084e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800856:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800859:	53                   	push   %ebx
  80085a:	51                   	push   %ecx
  80085b:	52                   	push   %edx
  80085c:	50                   	push   %eax
  80085d:	e8 6e 17 00 00       	call   801fd0 <__umoddi3>
  800862:	83 c4 10             	add    $0x10,%esp
  800865:	05 74 28 80 00       	add    $0x802874,%eax
  80086a:	8a 00                	mov    (%eax),%al
  80086c:	0f be c0             	movsbl %al,%eax
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	50                   	push   %eax
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
}
  80087e:	90                   	nop
  80087f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800882:	c9                   	leave  
  800883:	c3                   	ret    

00800884 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800887:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80088b:	7e 1c                	jle    8008a9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	8b 00                	mov    (%eax),%eax
  800892:	8d 50 08             	lea    0x8(%eax),%edx
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	89 10                	mov    %edx,(%eax)
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	83 e8 08             	sub    $0x8,%eax
  8008a2:	8b 50 04             	mov    0x4(%eax),%edx
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	eb 40                	jmp    8008e9 <getuint+0x65>
	else if (lflag)
  8008a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ad:	74 1e                	je     8008cd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	8b 00                	mov    (%eax),%eax
  8008b4:	8d 50 04             	lea    0x4(%eax),%edx
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	89 10                	mov    %edx,(%eax)
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	83 e8 04             	sub    $0x4,%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cb:	eb 1c                	jmp    8008e9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	8d 50 04             	lea    0x4(%eax),%edx
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	89 10                	mov    %edx,(%eax)
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	83 e8 04             	sub    $0x4,%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ee:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f2:	7e 1c                	jle    800910 <getint+0x25>
		return va_arg(*ap, long long);
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	8d 50 08             	lea    0x8(%eax),%edx
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	89 10                	mov    %edx,(%eax)
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	83 e8 08             	sub    $0x8,%eax
  800909:	8b 50 04             	mov    0x4(%eax),%edx
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	eb 38                	jmp    800948 <getint+0x5d>
	else if (lflag)
  800910:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800914:	74 1a                	je     800930 <getint+0x45>
		return va_arg(*ap, long);
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	8d 50 04             	lea    0x4(%eax),%edx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	89 10                	mov    %edx,(%eax)
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	83 e8 04             	sub    $0x4,%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	99                   	cltd   
  80092e:	eb 18                	jmp    800948 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	8d 50 04             	lea    0x4(%eax),%edx
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	89 10                	mov    %edx,(%eax)
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	83 e8 04             	sub    $0x4,%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	99                   	cltd   
}
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	56                   	push   %esi
  80094e:	53                   	push   %ebx
  80094f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800952:	eb 17                	jmp    80096b <vprintfmt+0x21>
			if (ch == '\0')
  800954:	85 db                	test   %ebx,%ebx
  800956:	0f 84 c1 03 00 00    	je     800d1d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80095c:	83 ec 08             	sub    $0x8,%esp
  80095f:	ff 75 0c             	pushl  0xc(%ebp)
  800962:	53                   	push   %ebx
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	ff d0                	call   *%eax
  800968:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096b:	8b 45 10             	mov    0x10(%ebp),%eax
  80096e:	8d 50 01             	lea    0x1(%eax),%edx
  800971:	89 55 10             	mov    %edx,0x10(%ebp)
  800974:	8a 00                	mov    (%eax),%al
  800976:	0f b6 d8             	movzbl %al,%ebx
  800979:	83 fb 25             	cmp    $0x25,%ebx
  80097c:	75 d6                	jne    800954 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80097e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800982:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800989:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800990:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800997:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80099e:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a1:	8d 50 01             	lea    0x1(%eax),%edx
  8009a4:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a7:	8a 00                	mov    (%eax),%al
  8009a9:	0f b6 d8             	movzbl %al,%ebx
  8009ac:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009af:	83 f8 5b             	cmp    $0x5b,%eax
  8009b2:	0f 87 3d 03 00 00    	ja     800cf5 <vprintfmt+0x3ab>
  8009b8:	8b 04 85 98 28 80 00 	mov    0x802898(,%eax,4),%eax
  8009bf:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009c5:	eb d7                	jmp    80099e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009c7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009cb:	eb d1                	jmp    80099e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009cd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d7:	89 d0                	mov    %edx,%eax
  8009d9:	c1 e0 02             	shl    $0x2,%eax
  8009dc:	01 d0                	add    %edx,%eax
  8009de:	01 c0                	add    %eax,%eax
  8009e0:	01 d8                	add    %ebx,%eax
  8009e2:	83 e8 30             	sub    $0x30,%eax
  8009e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009eb:	8a 00                	mov    (%eax),%al
  8009ed:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009f0:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f3:	7e 3e                	jle    800a33 <vprintfmt+0xe9>
  8009f5:	83 fb 39             	cmp    $0x39,%ebx
  8009f8:	7f 39                	jg     800a33 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009fa:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009fd:	eb d5                	jmp    8009d4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	83 c0 04             	add    $0x4,%eax
  800a05:	89 45 14             	mov    %eax,0x14(%ebp)
  800a08:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0b:	83 e8 04             	sub    $0x4,%eax
  800a0e:	8b 00                	mov    (%eax),%eax
  800a10:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a13:	eb 1f                	jmp    800a34 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a19:	79 83                	jns    80099e <vprintfmt+0x54>
				width = 0;
  800a1b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a22:	e9 77 ff ff ff       	jmp    80099e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a27:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a2e:	e9 6b ff ff ff       	jmp    80099e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a33:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a38:	0f 89 60 ff ff ff    	jns    80099e <vprintfmt+0x54>
				width = precision, precision = -1;
  800a3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a44:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a4b:	e9 4e ff ff ff       	jmp    80099e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a50:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a53:	e9 46 ff ff ff       	jmp    80099e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	83 c0 04             	add    $0x4,%eax
  800a5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a61:	8b 45 14             	mov    0x14(%ebp),%eax
  800a64:	83 e8 04             	sub    $0x4,%eax
  800a67:	8b 00                	mov    (%eax),%eax
  800a69:	83 ec 08             	sub    $0x8,%esp
  800a6c:	ff 75 0c             	pushl  0xc(%ebp)
  800a6f:	50                   	push   %eax
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	ff d0                	call   *%eax
  800a75:	83 c4 10             	add    $0x10,%esp
			break;
  800a78:	e9 9b 02 00 00       	jmp    800d18 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a80:	83 c0 04             	add    $0x4,%eax
  800a83:	89 45 14             	mov    %eax,0x14(%ebp)
  800a86:	8b 45 14             	mov    0x14(%ebp),%eax
  800a89:	83 e8 04             	sub    $0x4,%eax
  800a8c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a8e:	85 db                	test   %ebx,%ebx
  800a90:	79 02                	jns    800a94 <vprintfmt+0x14a>
				err = -err;
  800a92:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a94:	83 fb 64             	cmp    $0x64,%ebx
  800a97:	7f 0b                	jg     800aa4 <vprintfmt+0x15a>
  800a99:	8b 34 9d e0 26 80 00 	mov    0x8026e0(,%ebx,4),%esi
  800aa0:	85 f6                	test   %esi,%esi
  800aa2:	75 19                	jne    800abd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa4:	53                   	push   %ebx
  800aa5:	68 85 28 80 00       	push   $0x802885
  800aaa:	ff 75 0c             	pushl  0xc(%ebp)
  800aad:	ff 75 08             	pushl  0x8(%ebp)
  800ab0:	e8 70 02 00 00       	call   800d25 <printfmt>
  800ab5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab8:	e9 5b 02 00 00       	jmp    800d18 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800abd:	56                   	push   %esi
  800abe:	68 8e 28 80 00       	push   $0x80288e
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	ff 75 08             	pushl  0x8(%ebp)
  800ac9:	e8 57 02 00 00       	call   800d25 <printfmt>
  800ace:	83 c4 10             	add    $0x10,%esp
			break;
  800ad1:	e9 42 02 00 00       	jmp    800d18 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad9:	83 c0 04             	add    $0x4,%eax
  800adc:	89 45 14             	mov    %eax,0x14(%ebp)
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	83 e8 04             	sub    $0x4,%eax
  800ae5:	8b 30                	mov    (%eax),%esi
  800ae7:	85 f6                	test   %esi,%esi
  800ae9:	75 05                	jne    800af0 <vprintfmt+0x1a6>
				p = "(null)";
  800aeb:	be 91 28 80 00       	mov    $0x802891,%esi
			if (width > 0 && padc != '-')
  800af0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af4:	7e 6d                	jle    800b63 <vprintfmt+0x219>
  800af6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800afa:	74 67                	je     800b63 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800afc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	50                   	push   %eax
  800b03:	56                   	push   %esi
  800b04:	e8 26 05 00 00       	call   80102f <strnlen>
  800b09:	83 c4 10             	add    $0x10,%esp
  800b0c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b0f:	eb 16                	jmp    800b27 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b11:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b15:	83 ec 08             	sub    $0x8,%esp
  800b18:	ff 75 0c             	pushl  0xc(%ebp)
  800b1b:	50                   	push   %eax
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	ff d0                	call   *%eax
  800b21:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b24:	ff 4d e4             	decl   -0x1c(%ebp)
  800b27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2b:	7f e4                	jg     800b11 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2d:	eb 34                	jmp    800b63 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b33:	74 1c                	je     800b51 <vprintfmt+0x207>
  800b35:	83 fb 1f             	cmp    $0x1f,%ebx
  800b38:	7e 05                	jle    800b3f <vprintfmt+0x1f5>
  800b3a:	83 fb 7e             	cmp    $0x7e,%ebx
  800b3d:	7e 12                	jle    800b51 <vprintfmt+0x207>
					putch('?', putdat);
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	ff 75 0c             	pushl  0xc(%ebp)
  800b45:	6a 3f                	push   $0x3f
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	ff d0                	call   *%eax
  800b4c:	83 c4 10             	add    $0x10,%esp
  800b4f:	eb 0f                	jmp    800b60 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b51:	83 ec 08             	sub    $0x8,%esp
  800b54:	ff 75 0c             	pushl  0xc(%ebp)
  800b57:	53                   	push   %ebx
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	ff d0                	call   *%eax
  800b5d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b60:	ff 4d e4             	decl   -0x1c(%ebp)
  800b63:	89 f0                	mov    %esi,%eax
  800b65:	8d 70 01             	lea    0x1(%eax),%esi
  800b68:	8a 00                	mov    (%eax),%al
  800b6a:	0f be d8             	movsbl %al,%ebx
  800b6d:	85 db                	test   %ebx,%ebx
  800b6f:	74 24                	je     800b95 <vprintfmt+0x24b>
  800b71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b75:	78 b8                	js     800b2f <vprintfmt+0x1e5>
  800b77:	ff 4d e0             	decl   -0x20(%ebp)
  800b7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7e:	79 af                	jns    800b2f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b80:	eb 13                	jmp    800b95 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	6a 20                	push   $0x20
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	ff d0                	call   *%eax
  800b8f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b92:	ff 4d e4             	decl   -0x1c(%ebp)
  800b95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b99:	7f e7                	jg     800b82 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b9b:	e9 78 01 00 00       	jmp    800d18 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ba0:	83 ec 08             	sub    $0x8,%esp
  800ba3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba9:	50                   	push   %eax
  800baa:	e8 3c fd ff ff       	call   8008eb <getint>
  800baf:	83 c4 10             	add    $0x10,%esp
  800bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bbe:	85 d2                	test   %edx,%edx
  800bc0:	79 23                	jns    800be5 <vprintfmt+0x29b>
				putch('-', putdat);
  800bc2:	83 ec 08             	sub    $0x8,%esp
  800bc5:	ff 75 0c             	pushl  0xc(%ebp)
  800bc8:	6a 2d                	push   $0x2d
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	ff d0                	call   *%eax
  800bcf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd8:	f7 d8                	neg    %eax
  800bda:	83 d2 00             	adc    $0x0,%edx
  800bdd:	f7 da                	neg    %edx
  800bdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800be5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bec:	e9 bc 00 00 00       	jmp    800cad <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf1:	83 ec 08             	sub    $0x8,%esp
  800bf4:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf7:	8d 45 14             	lea    0x14(%ebp),%eax
  800bfa:	50                   	push   %eax
  800bfb:	e8 84 fc ff ff       	call   800884 <getuint>
  800c00:	83 c4 10             	add    $0x10,%esp
  800c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c09:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c10:	e9 98 00 00 00       	jmp    800cad <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c15:	83 ec 08             	sub    $0x8,%esp
  800c18:	ff 75 0c             	pushl  0xc(%ebp)
  800c1b:	6a 58                	push   $0x58
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	ff d0                	call   *%eax
  800c22:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c25:	83 ec 08             	sub    $0x8,%esp
  800c28:	ff 75 0c             	pushl  0xc(%ebp)
  800c2b:	6a 58                	push   $0x58
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	ff d0                	call   *%eax
  800c32:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	6a 58                	push   $0x58
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	ff d0                	call   *%eax
  800c42:	83 c4 10             	add    $0x10,%esp
			break;
  800c45:	e9 ce 00 00 00       	jmp    800d18 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c4a:	83 ec 08             	sub    $0x8,%esp
  800c4d:	ff 75 0c             	pushl  0xc(%ebp)
  800c50:	6a 30                	push   $0x30
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	ff d0                	call   *%eax
  800c57:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c5a:	83 ec 08             	sub    $0x8,%esp
  800c5d:	ff 75 0c             	pushl  0xc(%ebp)
  800c60:	6a 78                	push   $0x78
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	ff d0                	call   *%eax
  800c67:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6d:	83 c0 04             	add    $0x4,%eax
  800c70:	89 45 14             	mov    %eax,0x14(%ebp)
  800c73:	8b 45 14             	mov    0x14(%ebp),%eax
  800c76:	83 e8 04             	sub    $0x4,%eax
  800c79:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c8c:	eb 1f                	jmp    800cad <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 e8             	pushl  -0x18(%ebp)
  800c94:	8d 45 14             	lea    0x14(%ebp),%eax
  800c97:	50                   	push   %eax
  800c98:	e8 e7 fb ff ff       	call   800884 <getuint>
  800c9d:	83 c4 10             	add    $0x10,%esp
  800ca0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ca6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cad:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb4:	83 ec 04             	sub    $0x4,%esp
  800cb7:	52                   	push   %edx
  800cb8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cbb:	50                   	push   %eax
  800cbc:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbf:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc2:	ff 75 0c             	pushl  0xc(%ebp)
  800cc5:	ff 75 08             	pushl  0x8(%ebp)
  800cc8:	e8 00 fb ff ff       	call   8007cd <printnum>
  800ccd:	83 c4 20             	add    $0x20,%esp
			break;
  800cd0:	eb 46                	jmp    800d18 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd2:	83 ec 08             	sub    $0x8,%esp
  800cd5:	ff 75 0c             	pushl  0xc(%ebp)
  800cd8:	53                   	push   %ebx
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	ff d0                	call   *%eax
  800cde:	83 c4 10             	add    $0x10,%esp
			break;
  800ce1:	eb 35                	jmp    800d18 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ce3:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cea:	eb 2c                	jmp    800d18 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cec:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800cf3:	eb 23                	jmp    800d18 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cf5:	83 ec 08             	sub    $0x8,%esp
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	6a 25                	push   $0x25
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	ff d0                	call   *%eax
  800d02:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d05:	ff 4d 10             	decl   0x10(%ebp)
  800d08:	eb 03                	jmp    800d0d <vprintfmt+0x3c3>
  800d0a:	ff 4d 10             	decl   0x10(%ebp)
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	48                   	dec    %eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	3c 25                	cmp    $0x25,%al
  800d15:	75 f3                	jne    800d0a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d17:	90                   	nop
		}
	}
  800d18:	e9 35 fc ff ff       	jmp    800952 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d1d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    

00800d25 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d2b:	8d 45 10             	lea    0x10(%ebp),%eax
  800d2e:	83 c0 04             	add    $0x4,%eax
  800d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d34:	8b 45 10             	mov    0x10(%ebp),%eax
  800d37:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3a:	50                   	push   %eax
  800d3b:	ff 75 0c             	pushl  0xc(%ebp)
  800d3e:	ff 75 08             	pushl  0x8(%ebp)
  800d41:	e8 04 fc ff ff       	call   80094a <vprintfmt>
  800d46:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d49:	90                   	nop
  800d4a:	c9                   	leave  
  800d4b:	c3                   	ret    

00800d4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	8b 40 08             	mov    0x8(%eax),%eax
  800d55:	8d 50 01             	lea    0x1(%eax),%edx
  800d58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	8b 10                	mov    (%eax),%edx
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	8b 40 04             	mov    0x4(%eax),%eax
  800d69:	39 c2                	cmp    %eax,%edx
  800d6b:	73 12                	jae    800d7f <sprintputch+0x33>
		*b->buf++ = ch;
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	8b 00                	mov    (%eax),%eax
  800d72:	8d 48 01             	lea    0x1(%eax),%ecx
  800d75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d78:	89 0a                	mov    %ecx,(%edx)
  800d7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7d:	88 10                	mov    %dl,(%eax)
}
  800d7f:	90                   	nop
  800d80:	5d                   	pop    %ebp
  800d81:	c3                   	ret    

00800d82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	01 d0                	add    %edx,%eax
  800d99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800da3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800da7:	74 06                	je     800daf <vsnprintf+0x2d>
  800da9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dad:	7f 07                	jg     800db6 <vsnprintf+0x34>
		return -E_INVAL;
  800daf:	b8 03 00 00 00       	mov    $0x3,%eax
  800db4:	eb 20                	jmp    800dd6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800db6:	ff 75 14             	pushl  0x14(%ebp)
  800db9:	ff 75 10             	pushl  0x10(%ebp)
  800dbc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dbf:	50                   	push   %eax
  800dc0:	68 4c 0d 80 00       	push   $0x800d4c
  800dc5:	e8 80 fb ff ff       	call   80094a <vprintfmt>
  800dca:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dd6:	c9                   	leave  
  800dd7:	c3                   	ret    

00800dd8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dde:	8d 45 10             	lea    0x10(%ebp),%eax
  800de1:	83 c0 04             	add    $0x4,%eax
  800de4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800de7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dea:	ff 75 f4             	pushl  -0xc(%ebp)
  800ded:	50                   	push   %eax
  800dee:	ff 75 0c             	pushl  0xc(%ebp)
  800df1:	ff 75 08             	pushl  0x8(%ebp)
  800df4:	e8 89 ff ff ff       	call   800d82 <vsnprintf>
  800df9:	83 c4 10             	add    $0x10,%esp
  800dfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800e0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e0e:	74 13                	je     800e23 <readline+0x1f>
		cprintf("%s", prompt);
  800e10:	83 ec 08             	sub    $0x8,%esp
  800e13:	ff 75 08             	pushl  0x8(%ebp)
  800e16:	68 08 2a 80 00       	push   $0x802a08
  800e1b:	e8 0b f9 ff ff       	call   80072b <cprintf>
  800e20:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e2a:	83 ec 0c             	sub    $0xc,%esp
  800e2d:	6a 00                	push   $0x0
  800e2f:	e8 7f 10 00 00       	call   801eb3 <iscons>
  800e34:	83 c4 10             	add    $0x10,%esp
  800e37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e3a:	e8 61 10 00 00       	call   801ea0 <getchar>
  800e3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e42:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e46:	79 22                	jns    800e6a <readline+0x66>
			if (c != -E_EOF)
  800e48:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e4c:	0f 84 ad 00 00 00    	je     800eff <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e52:	83 ec 08             	sub    $0x8,%esp
  800e55:	ff 75 ec             	pushl  -0x14(%ebp)
  800e58:	68 0b 2a 80 00       	push   $0x802a0b
  800e5d:	e8 c9 f8 ff ff       	call   80072b <cprintf>
  800e62:	83 c4 10             	add    $0x10,%esp
			break;
  800e65:	e9 95 00 00 00       	jmp    800eff <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800e6a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800e6e:	7e 34                	jle    800ea4 <readline+0xa0>
  800e70:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800e77:	7f 2b                	jg     800ea4 <readline+0xa0>
			if (echoing)
  800e79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e7d:	74 0e                	je     800e8d <readline+0x89>
				cputchar(c);
  800e7f:	83 ec 0c             	sub    $0xc,%esp
  800e82:	ff 75 ec             	pushl  -0x14(%ebp)
  800e85:	e8 f7 0f 00 00       	call   801e81 <cputchar>
  800e8a:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e90:	8d 50 01             	lea    0x1(%eax),%edx
  800e93:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800e96:	89 c2                	mov    %eax,%edx
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	01 d0                	add    %edx,%eax
  800e9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ea0:	88 10                	mov    %dl,(%eax)
  800ea2:	eb 56                	jmp    800efa <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800ea4:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ea8:	75 1f                	jne    800ec9 <readline+0xc5>
  800eaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800eae:	7e 19                	jle    800ec9 <readline+0xc5>
			if (echoing)
  800eb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800eb4:	74 0e                	je     800ec4 <readline+0xc0>
				cputchar(c);
  800eb6:	83 ec 0c             	sub    $0xc,%esp
  800eb9:	ff 75 ec             	pushl  -0x14(%ebp)
  800ebc:	e8 c0 0f 00 00       	call   801e81 <cputchar>
  800ec1:	83 c4 10             	add    $0x10,%esp

			i--;
  800ec4:	ff 4d f4             	decl   -0xc(%ebp)
  800ec7:	eb 31                	jmp    800efa <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800ec9:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ecd:	74 0a                	je     800ed9 <readline+0xd5>
  800ecf:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800ed3:	0f 85 61 ff ff ff    	jne    800e3a <readline+0x36>
			if (echoing)
  800ed9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800edd:	74 0e                	je     800eed <readline+0xe9>
				cputchar(c);
  800edf:	83 ec 0c             	sub    $0xc,%esp
  800ee2:	ff 75 ec             	pushl  -0x14(%ebp)
  800ee5:	e8 97 0f 00 00       	call   801e81 <cputchar>
  800eea:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800eed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	01 d0                	add    %edx,%eax
  800ef5:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800ef8:	eb 06                	jmp    800f00 <readline+0xfc>
		}
	}
  800efa:	e9 3b ff ff ff       	jmp    800e3a <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800eff:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800f00:	90                   	nop
  800f01:	c9                   	leave  
  800f02:	c3                   	ret    

00800f03 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800f09:	e8 79 09 00 00       	call   801887 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800f0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f12:	74 13                	je     800f27 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	ff 75 08             	pushl  0x8(%ebp)
  800f1a:	68 08 2a 80 00       	push   $0x802a08
  800f1f:	e8 07 f8 ff ff       	call   80072b <cprintf>
  800f24:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800f27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800f2e:	83 ec 0c             	sub    $0xc,%esp
  800f31:	6a 00                	push   $0x0
  800f33:	e8 7b 0f 00 00       	call   801eb3 <iscons>
  800f38:	83 c4 10             	add    $0x10,%esp
  800f3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800f3e:	e8 5d 0f 00 00       	call   801ea0 <getchar>
  800f43:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800f46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f4a:	79 22                	jns    800f6e <atomic_readline+0x6b>
				if (c != -E_EOF)
  800f4c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f50:	0f 84 ad 00 00 00    	je     801003 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800f56:	83 ec 08             	sub    $0x8,%esp
  800f59:	ff 75 ec             	pushl  -0x14(%ebp)
  800f5c:	68 0b 2a 80 00       	push   $0x802a0b
  800f61:	e8 c5 f7 ff ff       	call   80072b <cprintf>
  800f66:	83 c4 10             	add    $0x10,%esp
				break;
  800f69:	e9 95 00 00 00       	jmp    801003 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800f6e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800f72:	7e 34                	jle    800fa8 <atomic_readline+0xa5>
  800f74:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800f7b:	7f 2b                	jg     800fa8 <atomic_readline+0xa5>
				if (echoing)
  800f7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f81:	74 0e                	je     800f91 <atomic_readline+0x8e>
					cputchar(c);
  800f83:	83 ec 0c             	sub    $0xc,%esp
  800f86:	ff 75 ec             	pushl  -0x14(%ebp)
  800f89:	e8 f3 0e 00 00       	call   801e81 <cputchar>
  800f8e:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f94:	8d 50 01             	lea    0x1(%eax),%edx
  800f97:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800f9a:	89 c2                	mov    %eax,%edx
  800f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9f:	01 d0                	add    %edx,%eax
  800fa1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fa4:	88 10                	mov    %dl,(%eax)
  800fa6:	eb 56                	jmp    800ffe <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800fa8:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800fac:	75 1f                	jne    800fcd <atomic_readline+0xca>
  800fae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800fb2:	7e 19                	jle    800fcd <atomic_readline+0xca>
				if (echoing)
  800fb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fb8:	74 0e                	je     800fc8 <atomic_readline+0xc5>
					cputchar(c);
  800fba:	83 ec 0c             	sub    $0xc,%esp
  800fbd:	ff 75 ec             	pushl  -0x14(%ebp)
  800fc0:	e8 bc 0e 00 00       	call   801e81 <cputchar>
  800fc5:	83 c4 10             	add    $0x10,%esp
				i--;
  800fc8:	ff 4d f4             	decl   -0xc(%ebp)
  800fcb:	eb 31                	jmp    800ffe <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800fcd:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800fd1:	74 0a                	je     800fdd <atomic_readline+0xda>
  800fd3:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800fd7:	0f 85 61 ff ff ff    	jne    800f3e <atomic_readline+0x3b>
				if (echoing)
  800fdd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fe1:	74 0e                	je     800ff1 <atomic_readline+0xee>
					cputchar(c);
  800fe3:	83 ec 0c             	sub    $0xc,%esp
  800fe6:	ff 75 ec             	pushl  -0x14(%ebp)
  800fe9:	e8 93 0e 00 00       	call   801e81 <cputchar>
  800fee:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800ff1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff7:	01 d0                	add    %edx,%eax
  800ff9:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800ffc:	eb 06                	jmp    801004 <atomic_readline+0x101>
			}
		}
  800ffe:	e9 3b ff ff ff       	jmp    800f3e <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801003:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801004:	e8 98 08 00 00       	call   8018a1 <sys_unlock_cons>
}
  801009:	90                   	nop
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801019:	eb 06                	jmp    801021 <strlen+0x15>
		n++;
  80101b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80101e:	ff 45 08             	incl   0x8(%ebp)
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	84 c0                	test   %al,%al
  801028:	75 f1                	jne    80101b <strlen+0xf>
		n++;
	return n;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80102d:	c9                   	leave  
  80102e:	c3                   	ret    

0080102f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801035:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80103c:	eb 09                	jmp    801047 <strnlen+0x18>
		n++;
  80103e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801041:	ff 45 08             	incl   0x8(%ebp)
  801044:	ff 4d 0c             	decl   0xc(%ebp)
  801047:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80104b:	74 09                	je     801056 <strnlen+0x27>
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	84 c0                	test   %al,%al
  801054:	75 e8                	jne    80103e <strnlen+0xf>
		n++;
	return n;
  801056:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801067:	90                   	nop
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	8d 50 01             	lea    0x1(%eax),%edx
  80106e:	89 55 08             	mov    %edx,0x8(%ebp)
  801071:	8b 55 0c             	mov    0xc(%ebp),%edx
  801074:	8d 4a 01             	lea    0x1(%edx),%ecx
  801077:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80107a:	8a 12                	mov    (%edx),%dl
  80107c:	88 10                	mov    %dl,(%eax)
  80107e:	8a 00                	mov    (%eax),%al
  801080:	84 c0                	test   %al,%al
  801082:	75 e4                	jne    801068 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801084:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801087:	c9                   	leave  
  801088:	c3                   	ret    

00801089 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109c:	eb 1f                	jmp    8010bd <strncpy+0x34>
		*dst++ = *src;
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8d 50 01             	lea    0x1(%eax),%edx
  8010a4:	89 55 08             	mov    %edx,0x8(%ebp)
  8010a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010aa:	8a 12                	mov    (%edx),%dl
  8010ac:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	84 c0                	test   %al,%al
  8010b5:	74 03                	je     8010ba <strncpy+0x31>
			src++;
  8010b7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010ba:	ff 45 fc             	incl   -0x4(%ebp)
  8010bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c3:	72 d9                	jb     80109e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c8:	c9                   	leave  
  8010c9:	c3                   	ret    

008010ca <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010da:	74 30                	je     80110c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010dc:	eb 16                	jmp    8010f4 <strlcpy+0x2a>
			*dst++ = *src++;
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	8d 50 01             	lea    0x1(%eax),%edx
  8010e4:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010f0:	8a 12                	mov    (%edx),%dl
  8010f2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010f4:	ff 4d 10             	decl   0x10(%ebp)
  8010f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fb:	74 09                	je     801106 <strlcpy+0x3c>
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	8a 00                	mov    (%eax),%al
  801102:	84 c0                	test   %al,%al
  801104:	75 d8                	jne    8010de <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80110c:	8b 55 08             	mov    0x8(%ebp),%edx
  80110f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801112:	29 c2                	sub    %eax,%edx
  801114:	89 d0                	mov    %edx,%eax
}
  801116:	c9                   	leave  
  801117:	c3                   	ret    

00801118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80111b:	eb 06                	jmp    801123 <strcmp+0xb>
		p++, q++;
  80111d:	ff 45 08             	incl   0x8(%ebp)
  801120:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	84 c0                	test   %al,%al
  80112a:	74 0e                	je     80113a <strcmp+0x22>
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 10                	mov    (%eax),%dl
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	38 c2                	cmp    %al,%dl
  801138:	74 e3                	je     80111d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	0f b6 d0             	movzbl %al,%edx
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	0f b6 c0             	movzbl %al,%eax
  80114a:	29 c2                	sub    %eax,%edx
  80114c:	89 d0                	mov    %edx,%eax
}
  80114e:	5d                   	pop    %ebp
  80114f:	c3                   	ret    

00801150 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801153:	eb 09                	jmp    80115e <strncmp+0xe>
		n--, p++, q++;
  801155:	ff 4d 10             	decl   0x10(%ebp)
  801158:	ff 45 08             	incl   0x8(%ebp)
  80115b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80115e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801162:	74 17                	je     80117b <strncmp+0x2b>
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	84 c0                	test   %al,%al
  80116b:	74 0e                	je     80117b <strncmp+0x2b>
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 10                	mov    (%eax),%dl
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	38 c2                	cmp    %al,%dl
  801179:	74 da                	je     801155 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80117b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117f:	75 07                	jne    801188 <strncmp+0x38>
		return 0;
  801181:	b8 00 00 00 00       	mov    $0x0,%eax
  801186:	eb 14                	jmp    80119c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	0f b6 d0             	movzbl %al,%edx
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	8a 00                	mov    (%eax),%al
  801195:	0f b6 c0             	movzbl %al,%eax
  801198:	29 c2                	sub    %eax,%edx
  80119a:	89 d0                	mov    %edx,%eax
}
  80119c:	5d                   	pop    %ebp
  80119d:	c3                   	ret    

0080119e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	83 ec 04             	sub    $0x4,%esp
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011aa:	eb 12                	jmp    8011be <strchr+0x20>
		if (*s == c)
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011b4:	75 05                	jne    8011bb <strchr+0x1d>
			return (char *) s;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	eb 11                	jmp    8011cc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011bb:	ff 45 08             	incl   0x8(%ebp)
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	84 c0                	test   %al,%al
  8011c5:	75 e5                	jne    8011ac <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011cc:	c9                   	leave  
  8011cd:	c3                   	ret    

008011ce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	83 ec 04             	sub    $0x4,%esp
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011da:	eb 0d                	jmp    8011e9 <strfind+0x1b>
		if (*s == c)
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011df:	8a 00                	mov    (%eax),%al
  8011e1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011e4:	74 0e                	je     8011f4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011e6:	ff 45 08             	incl   0x8(%ebp)
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	84 c0                	test   %al,%al
  8011f0:	75 ea                	jne    8011dc <strfind+0xe>
  8011f2:	eb 01                	jmp    8011f5 <strfind+0x27>
		if (*s == c)
			break;
  8011f4:	90                   	nop
	return (char *) s;
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801206:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80120a:	76 63                	jbe    80126f <memset+0x75>
		uint64 data_block = c;
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	99                   	cltd   
  801210:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801213:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801216:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801219:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801220:	c1 e0 08             	shl    $0x8,%eax
  801223:	09 45 f0             	or     %eax,-0x10(%ebp)
  801226:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801229:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801233:	c1 e0 10             	shl    $0x10,%eax
  801236:	09 45 f0             	or     %eax,-0x10(%ebp)
  801239:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80123c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801242:	89 c2                	mov    %eax,%edx
  801244:	b8 00 00 00 00       	mov    $0x0,%eax
  801249:	09 45 f0             	or     %eax,-0x10(%ebp)
  80124c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80124f:	eb 18                	jmp    801269 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801251:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801254:	8d 41 08             	lea    0x8(%ecx),%eax
  801257:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80125a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801260:	89 01                	mov    %eax,(%ecx)
  801262:	89 51 04             	mov    %edx,0x4(%ecx)
  801265:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801269:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80126d:	77 e2                	ja     801251 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80126f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801273:	74 23                	je     801298 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801275:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801278:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80127b:	eb 0e                	jmp    80128b <memset+0x91>
			*p8++ = (uint8)c;
  80127d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801280:	8d 50 01             	lea    0x1(%eax),%edx
  801283:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801286:	8b 55 0c             	mov    0xc(%ebp),%edx
  801289:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80128b:	8b 45 10             	mov    0x10(%ebp),%eax
  80128e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801291:	89 55 10             	mov    %edx,0x10(%ebp)
  801294:	85 c0                	test   %eax,%eax
  801296:	75 e5                	jne    80127d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80129b:	c9                   	leave  
  80129c:	c3                   	ret    

0080129d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
  8012a0:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8012a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8012af:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012b3:	76 24                	jbe    8012d9 <memcpy+0x3c>
		while(n >= 8){
  8012b5:	eb 1c                	jmp    8012d3 <memcpy+0x36>
			*d64 = *s64;
  8012b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ba:	8b 50 04             	mov    0x4(%eax),%edx
  8012bd:	8b 00                	mov    (%eax),%eax
  8012bf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012c2:	89 01                	mov    %eax,(%ecx)
  8012c4:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8012c7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8012cb:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8012cf:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8012d3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012d7:	77 de                	ja     8012b7 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8012d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012dd:	74 31                	je     801310 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8012e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8012eb:	eb 16                	jmp    801303 <memcpy+0x66>
			*d8++ = *s8++;
  8012ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f0:	8d 50 01             	lea    0x1(%eax),%edx
  8012f3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8012f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012fc:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8012ff:	8a 12                	mov    (%edx),%dl
  801301:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801303:	8b 45 10             	mov    0x10(%ebp),%eax
  801306:	8d 50 ff             	lea    -0x1(%eax),%edx
  801309:	89 55 10             	mov    %edx,0x10(%ebp)
  80130c:	85 c0                	test   %eax,%eax
  80130e:	75 dd                	jne    8012ed <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80131b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801327:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80132d:	73 50                	jae    80137f <memmove+0x6a>
  80132f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801332:	8b 45 10             	mov    0x10(%ebp),%eax
  801335:	01 d0                	add    %edx,%eax
  801337:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80133a:	76 43                	jbe    80137f <memmove+0x6a>
		s += n;
  80133c:	8b 45 10             	mov    0x10(%ebp),%eax
  80133f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801342:	8b 45 10             	mov    0x10(%ebp),%eax
  801345:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801348:	eb 10                	jmp    80135a <memmove+0x45>
			*--d = *--s;
  80134a:	ff 4d f8             	decl   -0x8(%ebp)
  80134d:	ff 4d fc             	decl   -0x4(%ebp)
  801350:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801353:	8a 10                	mov    (%eax),%dl
  801355:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801358:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80135a:	8b 45 10             	mov    0x10(%ebp),%eax
  80135d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801360:	89 55 10             	mov    %edx,0x10(%ebp)
  801363:	85 c0                	test   %eax,%eax
  801365:	75 e3                	jne    80134a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801367:	eb 23                	jmp    80138c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801369:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136c:	8d 50 01             	lea    0x1(%eax),%edx
  80136f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801372:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801375:	8d 4a 01             	lea    0x1(%edx),%ecx
  801378:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80137b:	8a 12                	mov    (%edx),%dl
  80137d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80137f:	8b 45 10             	mov    0x10(%ebp),%eax
  801382:	8d 50 ff             	lea    -0x1(%eax),%edx
  801385:	89 55 10             	mov    %edx,0x10(%ebp)
  801388:	85 c0                	test   %eax,%eax
  80138a:	75 dd                	jne    801369 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80139d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013a3:	eb 2a                	jmp    8013cf <memcmp+0x3e>
		if (*s1 != *s2)
  8013a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a8:	8a 10                	mov    (%eax),%dl
  8013aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	38 c2                	cmp    %al,%dl
  8013b1:	74 16                	je     8013c9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	0f b6 d0             	movzbl %al,%edx
  8013bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	0f b6 c0             	movzbl %al,%eax
  8013c3:	29 c2                	sub    %eax,%edx
  8013c5:	89 d0                	mov    %edx,%eax
  8013c7:	eb 18                	jmp    8013e1 <memcmp+0x50>
		s1++, s2++;
  8013c9:	ff 45 fc             	incl   -0x4(%ebp)
  8013cc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013d5:	89 55 10             	mov    %edx,0x10(%ebp)
  8013d8:	85 c0                	test   %eax,%eax
  8013da:	75 c9                	jne    8013a5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    

008013e3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ef:	01 d0                	add    %edx,%eax
  8013f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013f4:	eb 15                	jmp    80140b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	0f b6 d0             	movzbl %al,%edx
  8013fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801401:	0f b6 c0             	movzbl %al,%eax
  801404:	39 c2                	cmp    %eax,%edx
  801406:	74 0d                	je     801415 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801408:	ff 45 08             	incl   0x8(%ebp)
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801411:	72 e3                	jb     8013f6 <memfind+0x13>
  801413:	eb 01                	jmp    801416 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801415:	90                   	nop
	return (void *) s;
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801421:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801428:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80142f:	eb 03                	jmp    801434 <strtol+0x19>
		s++;
  801431:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	8a 00                	mov    (%eax),%al
  801439:	3c 20                	cmp    $0x20,%al
  80143b:	74 f4                	je     801431 <strtol+0x16>
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	3c 09                	cmp    $0x9,%al
  801444:	74 eb                	je     801431 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	8a 00                	mov    (%eax),%al
  80144b:	3c 2b                	cmp    $0x2b,%al
  80144d:	75 05                	jne    801454 <strtol+0x39>
		s++;
  80144f:	ff 45 08             	incl   0x8(%ebp)
  801452:	eb 13                	jmp    801467 <strtol+0x4c>
	else if (*s == '-')
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	3c 2d                	cmp    $0x2d,%al
  80145b:	75 0a                	jne    801467 <strtol+0x4c>
		s++, neg = 1;
  80145d:	ff 45 08             	incl   0x8(%ebp)
  801460:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801467:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80146b:	74 06                	je     801473 <strtol+0x58>
  80146d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801471:	75 20                	jne    801493 <strtol+0x78>
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	8a 00                	mov    (%eax),%al
  801478:	3c 30                	cmp    $0x30,%al
  80147a:	75 17                	jne    801493 <strtol+0x78>
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	40                   	inc    %eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	3c 78                	cmp    $0x78,%al
  801484:	75 0d                	jne    801493 <strtol+0x78>
		s += 2, base = 16;
  801486:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80148a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801491:	eb 28                	jmp    8014bb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801493:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801497:	75 15                	jne    8014ae <strtol+0x93>
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	3c 30                	cmp    $0x30,%al
  8014a0:	75 0c                	jne    8014ae <strtol+0x93>
		s++, base = 8;
  8014a2:	ff 45 08             	incl   0x8(%ebp)
  8014a5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014ac:	eb 0d                	jmp    8014bb <strtol+0xa0>
	else if (base == 0)
  8014ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b2:	75 07                	jne    8014bb <strtol+0xa0>
		base = 10;
  8014b4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	8a 00                	mov    (%eax),%al
  8014c0:	3c 2f                	cmp    $0x2f,%al
  8014c2:	7e 19                	jle    8014dd <strtol+0xc2>
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	8a 00                	mov    (%eax),%al
  8014c9:	3c 39                	cmp    $0x39,%al
  8014cb:	7f 10                	jg     8014dd <strtol+0xc2>
			dig = *s - '0';
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	8a 00                	mov    (%eax),%al
  8014d2:	0f be c0             	movsbl %al,%eax
  8014d5:	83 e8 30             	sub    $0x30,%eax
  8014d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014db:	eb 42                	jmp    80151f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	8a 00                	mov    (%eax),%al
  8014e2:	3c 60                	cmp    $0x60,%al
  8014e4:	7e 19                	jle    8014ff <strtol+0xe4>
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	8a 00                	mov    (%eax),%al
  8014eb:	3c 7a                	cmp    $0x7a,%al
  8014ed:	7f 10                	jg     8014ff <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f2:	8a 00                	mov    (%eax),%al
  8014f4:	0f be c0             	movsbl %al,%eax
  8014f7:	83 e8 57             	sub    $0x57,%eax
  8014fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014fd:	eb 20                	jmp    80151f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	8a 00                	mov    (%eax),%al
  801504:	3c 40                	cmp    $0x40,%al
  801506:	7e 39                	jle    801541 <strtol+0x126>
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	8a 00                	mov    (%eax),%al
  80150d:	3c 5a                	cmp    $0x5a,%al
  80150f:	7f 30                	jg     801541 <strtol+0x126>
			dig = *s - 'A' + 10;
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	8a 00                	mov    (%eax),%al
  801516:	0f be c0             	movsbl %al,%eax
  801519:	83 e8 37             	sub    $0x37,%eax
  80151c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80151f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801522:	3b 45 10             	cmp    0x10(%ebp),%eax
  801525:	7d 19                	jge    801540 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801527:	ff 45 08             	incl   0x8(%ebp)
  80152a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801531:	89 c2                	mov    %eax,%edx
  801533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80153b:	e9 7b ff ff ff       	jmp    8014bb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801540:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801541:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801545:	74 08                	je     80154f <strtol+0x134>
		*endptr = (char *) s;
  801547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154a:	8b 55 08             	mov    0x8(%ebp),%edx
  80154d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80154f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801553:	74 07                	je     80155c <strtol+0x141>
  801555:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801558:	f7 d8                	neg    %eax
  80155a:	eb 03                	jmp    80155f <strtol+0x144>
  80155c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <ltostr>:

void
ltostr(long value, char *str)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801567:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80156e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801575:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801579:	79 13                	jns    80158e <ltostr+0x2d>
	{
		neg = 1;
  80157b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801582:	8b 45 0c             	mov    0xc(%ebp),%eax
  801585:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801588:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80158b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801596:	99                   	cltd   
  801597:	f7 f9                	idiv   %ecx
  801599:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80159c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80159f:	8d 50 01             	lea    0x1(%eax),%edx
  8015a2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015a5:	89 c2                	mov    %eax,%edx
  8015a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015aa:	01 d0                	add    %edx,%eax
  8015ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015af:	83 c2 30             	add    $0x30,%edx
  8015b2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015b7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015bc:	f7 e9                	imul   %ecx
  8015be:	c1 fa 02             	sar    $0x2,%edx
  8015c1:	89 c8                	mov    %ecx,%eax
  8015c3:	c1 f8 1f             	sar    $0x1f,%eax
  8015c6:	29 c2                	sub    %eax,%edx
  8015c8:	89 d0                	mov    %edx,%eax
  8015ca:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8015cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015d1:	75 bb                	jne    80158e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015dd:	48                   	dec    %eax
  8015de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015e5:	74 3d                	je     801624 <ltostr+0xc3>
		start = 1 ;
  8015e7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015ee:	eb 34                	jmp    801624 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8015f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	01 d0                	add    %edx,%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801600:	8b 45 0c             	mov    0xc(%ebp),%eax
  801603:	01 c2                	add    %eax,%edx
  801605:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801608:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160b:	01 c8                	add    %ecx,%eax
  80160d:	8a 00                	mov    (%eax),%al
  80160f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801611:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801614:	8b 45 0c             	mov    0xc(%ebp),%eax
  801617:	01 c2                	add    %eax,%edx
  801619:	8a 45 eb             	mov    -0x15(%ebp),%al
  80161c:	88 02                	mov    %al,(%edx)
		start++ ;
  80161e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801621:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801627:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80162a:	7c c4                	jl     8015f0 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80162c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80162f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801632:	01 d0                	add    %edx,%eax
  801634:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801637:	90                   	nop
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801640:	ff 75 08             	pushl  0x8(%ebp)
  801643:	e8 c4 f9 ff ff       	call   80100c <strlen>
  801648:	83 c4 04             	add    $0x4,%esp
  80164b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80164e:	ff 75 0c             	pushl  0xc(%ebp)
  801651:	e8 b6 f9 ff ff       	call   80100c <strlen>
  801656:	83 c4 04             	add    $0x4,%esp
  801659:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80165c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801663:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80166a:	eb 17                	jmp    801683 <strcconcat+0x49>
		final[s] = str1[s] ;
  80166c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80166f:	8b 45 10             	mov    0x10(%ebp),%eax
  801672:	01 c2                	add    %eax,%edx
  801674:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	01 c8                	add    %ecx,%eax
  80167c:	8a 00                	mov    (%eax),%al
  80167e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801680:	ff 45 fc             	incl   -0x4(%ebp)
  801683:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801686:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801689:	7c e1                	jl     80166c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80168b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801692:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801699:	eb 1f                	jmp    8016ba <strcconcat+0x80>
		final[s++] = str2[i] ;
  80169b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80169e:	8d 50 01             	lea    0x1(%eax),%edx
  8016a1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016a4:	89 c2                	mov    %eax,%edx
  8016a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a9:	01 c2                	add    %eax,%edx
  8016ab:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b1:	01 c8                	add    %ecx,%eax
  8016b3:	8a 00                	mov    (%eax),%al
  8016b5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016b7:	ff 45 f8             	incl   -0x8(%ebp)
  8016ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016c0:	7c d9                	jl     80169b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c8:	01 d0                	add    %edx,%eax
  8016ca:	c6 00 00             	movb   $0x0,(%eax)
}
  8016cd:	90                   	nop
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    

008016d0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8016df:	8b 00                	mov    (%eax),%eax
  8016e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016eb:	01 d0                	add    %edx,%eax
  8016ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016f3:	eb 0c                	jmp    801701 <strsplit+0x31>
			*string++ = 0;
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	8d 50 01             	lea    0x1(%eax),%edx
  8016fb:	89 55 08             	mov    %edx,0x8(%ebp)
  8016fe:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	84 c0                	test   %al,%al
  801708:	74 18                	je     801722 <strsplit+0x52>
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	8a 00                	mov    (%eax),%al
  80170f:	0f be c0             	movsbl %al,%eax
  801712:	50                   	push   %eax
  801713:	ff 75 0c             	pushl  0xc(%ebp)
  801716:	e8 83 fa ff ff       	call   80119e <strchr>
  80171b:	83 c4 08             	add    $0x8,%esp
  80171e:	85 c0                	test   %eax,%eax
  801720:	75 d3                	jne    8016f5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	8a 00                	mov    (%eax),%al
  801727:	84 c0                	test   %al,%al
  801729:	74 5a                	je     801785 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80172b:	8b 45 14             	mov    0x14(%ebp),%eax
  80172e:	8b 00                	mov    (%eax),%eax
  801730:	83 f8 0f             	cmp    $0xf,%eax
  801733:	75 07                	jne    80173c <strsplit+0x6c>
		{
			return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
  80173a:	eb 66                	jmp    8017a2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80173c:	8b 45 14             	mov    0x14(%ebp),%eax
  80173f:	8b 00                	mov    (%eax),%eax
  801741:	8d 48 01             	lea    0x1(%eax),%ecx
  801744:	8b 55 14             	mov    0x14(%ebp),%edx
  801747:	89 0a                	mov    %ecx,(%edx)
  801749:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801750:	8b 45 10             	mov    0x10(%ebp),%eax
  801753:	01 c2                	add    %eax,%edx
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80175a:	eb 03                	jmp    80175f <strsplit+0x8f>
			string++;
  80175c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	8a 00                	mov    (%eax),%al
  801764:	84 c0                	test   %al,%al
  801766:	74 8b                	je     8016f3 <strsplit+0x23>
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	8a 00                	mov    (%eax),%al
  80176d:	0f be c0             	movsbl %al,%eax
  801770:	50                   	push   %eax
  801771:	ff 75 0c             	pushl  0xc(%ebp)
  801774:	e8 25 fa ff ff       	call   80119e <strchr>
  801779:	83 c4 08             	add    $0x8,%esp
  80177c:	85 c0                	test   %eax,%eax
  80177e:	74 dc                	je     80175c <strsplit+0x8c>
			string++;
	}
  801780:	e9 6e ff ff ff       	jmp    8016f3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801785:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801786:	8b 45 14             	mov    0x14(%ebp),%eax
  801789:	8b 00                	mov    (%eax),%eax
  80178b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801792:	8b 45 10             	mov    0x10(%ebp),%eax
  801795:	01 d0                	add    %edx,%eax
  801797:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80179d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8017b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017b7:	eb 4a                	jmp    801803 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8017b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	01 c2                	add    %eax,%edx
  8017c1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c7:	01 c8                	add    %ecx,%eax
  8017c9:	8a 00                	mov    (%eax),%al
  8017cb:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8017cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d3:	01 d0                	add    %edx,%eax
  8017d5:	8a 00                	mov    (%eax),%al
  8017d7:	3c 40                	cmp    $0x40,%al
  8017d9:	7e 25                	jle    801800 <str2lower+0x5c>
  8017db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e1:	01 d0                	add    %edx,%eax
  8017e3:	8a 00                	mov    (%eax),%al
  8017e5:	3c 5a                	cmp    $0x5a,%al
  8017e7:	7f 17                	jg     801800 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8017e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	01 d0                	add    %edx,%eax
  8017f1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f7:	01 ca                	add    %ecx,%edx
  8017f9:	8a 12                	mov    (%edx),%dl
  8017fb:	83 c2 20             	add    $0x20,%edx
  8017fe:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801800:	ff 45 fc             	incl   -0x4(%ebp)
  801803:	ff 75 0c             	pushl  0xc(%ebp)
  801806:	e8 01 f8 ff ff       	call   80100c <strlen>
  80180b:	83 c4 04             	add    $0x4,%esp
  80180e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801811:	7f a6                	jg     8017b9 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801813:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	57                   	push   %edi
  80181c:	56                   	push   %esi
  80181d:	53                   	push   %ebx
  80181e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	8b 55 0c             	mov    0xc(%ebp),%edx
  801827:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80182a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80182d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801830:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801833:	cd 30                	int    $0x30
  801835:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801838:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	5b                   	pop    %ebx
  80183f:	5e                   	pop    %esi
  801840:	5f                   	pop    %edi
  801841:	5d                   	pop    %ebp
  801842:	c3                   	ret    

00801843 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 04             	sub    $0x4,%esp
  801849:	8b 45 10             	mov    0x10(%ebp),%eax
  80184c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80184f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801852:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	6a 00                	push   $0x0
  80185b:	51                   	push   %ecx
  80185c:	52                   	push   %edx
  80185d:	ff 75 0c             	pushl  0xc(%ebp)
  801860:	50                   	push   %eax
  801861:	6a 00                	push   $0x0
  801863:	e8 b0 ff ff ff       	call   801818 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	90                   	nop
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_cgetc>:

int
sys_cgetc(void)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 02                	push   $0x2
  80187d:	e8 96 ff ff ff       	call   801818 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 03                	push   $0x3
  801896:	e8 7d ff ff ff       	call   801818 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	90                   	nop
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 04                	push   $0x4
  8018b0:	e8 63 ff ff ff       	call   801818 <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	90                   	nop
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	52                   	push   %edx
  8018cb:	50                   	push   %eax
  8018cc:	6a 08                	push   $0x8
  8018ce:	e8 45 ff ff ff       	call   801818 <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	56                   	push   %esi
  8018dc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018dd:	8b 75 18             	mov    0x18(%ebp),%esi
  8018e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	56                   	push   %esi
  8018ed:	53                   	push   %ebx
  8018ee:	51                   	push   %ecx
  8018ef:	52                   	push   %edx
  8018f0:	50                   	push   %eax
  8018f1:	6a 09                	push   $0x9
  8018f3:	e8 20 ff ff ff       	call   801818 <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp
}
  8018fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fe:	5b                   	pop    %ebx
  8018ff:	5e                   	pop    %esi
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    

00801902 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	ff 75 08             	pushl  0x8(%ebp)
  801910:	6a 0a                	push   $0xa
  801912:	e8 01 ff ff ff       	call   801818 <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	ff 75 0c             	pushl  0xc(%ebp)
  801928:	ff 75 08             	pushl  0x8(%ebp)
  80192b:	6a 0b                	push   $0xb
  80192d:	e8 e6 fe ff ff       	call   801818 <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 0c                	push   $0xc
  801946:	e8 cd fe ff ff       	call   801818 <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 0d                	push   $0xd
  80195f:	e8 b4 fe ff ff       	call   801818 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 0e                	push   $0xe
  801978:	e8 9b fe ff ff       	call   801818 <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 0f                	push   $0xf
  801991:	e8 82 fe ff ff       	call   801818 <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	ff 75 08             	pushl  0x8(%ebp)
  8019a9:	6a 10                	push   $0x10
  8019ab:	e8 68 fe ff ff       	call   801818 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 11                	push   $0x11
  8019c4:	e8 4f fe ff ff       	call   801818 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	90                   	nop
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_cputc>:

void
sys_cputc(const char c)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	83 ec 04             	sub    $0x4,%esp
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019db:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	50                   	push   %eax
  8019e8:	6a 01                	push   $0x1
  8019ea:	e8 29 fe ff ff       	call   801818 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	90                   	nop
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 14                	push   $0x14
  801a04:	e8 0f fe ff ff       	call   801818 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	90                   	nop
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 04             	sub    $0x4,%esp
  801a15:	8b 45 10             	mov    0x10(%ebp),%eax
  801a18:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a1b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a1e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	6a 00                	push   $0x0
  801a27:	51                   	push   %ecx
  801a28:	52                   	push   %edx
  801a29:	ff 75 0c             	pushl  0xc(%ebp)
  801a2c:	50                   	push   %eax
  801a2d:	6a 15                	push   $0x15
  801a2f:	e8 e4 fd ff ff       	call   801818 <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	52                   	push   %edx
  801a49:	50                   	push   %eax
  801a4a:	6a 16                	push   $0x16
  801a4c:	e8 c7 fd ff ff       	call   801818 <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a59:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	51                   	push   %ecx
  801a67:	52                   	push   %edx
  801a68:	50                   	push   %eax
  801a69:	6a 17                	push   $0x17
  801a6b:	e8 a8 fd ff ff       	call   801818 <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	52                   	push   %edx
  801a85:	50                   	push   %eax
  801a86:	6a 18                	push   $0x18
  801a88:	e8 8b fd ff ff       	call   801818 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a95:	8b 45 08             	mov    0x8(%ebp),%eax
  801a98:	6a 00                	push   $0x0
  801a9a:	ff 75 14             	pushl  0x14(%ebp)
  801a9d:	ff 75 10             	pushl  0x10(%ebp)
  801aa0:	ff 75 0c             	pushl  0xc(%ebp)
  801aa3:	50                   	push   %eax
  801aa4:	6a 19                	push   $0x19
  801aa6:	e8 6d fd ff ff       	call   801818 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	50                   	push   %eax
  801abf:	6a 1a                	push   $0x1a
  801ac1:	e8 52 fd ff ff       	call   801818 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	90                   	nop
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	50                   	push   %eax
  801adb:	6a 1b                	push   $0x1b
  801add:	e8 36 fd ff ff       	call   801818 <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 05                	push   $0x5
  801af6:	e8 1d fd ff ff       	call   801818 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 06                	push   $0x6
  801b0f:	e8 04 fd ff ff       	call   801818 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 07                	push   $0x7
  801b28:	e8 eb fc ff ff       	call   801818 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_exit_env>:


void sys_exit_env(void)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 1c                	push   $0x1c
  801b41:	e8 d2 fc ff ff       	call   801818 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	90                   	nop
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b52:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b55:	8d 50 04             	lea    0x4(%eax),%edx
  801b58:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	52                   	push   %edx
  801b62:	50                   	push   %eax
  801b63:	6a 1d                	push   $0x1d
  801b65:	e8 ae fc ff ff       	call   801818 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
	return result;
  801b6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b73:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b76:	89 01                	mov    %eax,(%ecx)
  801b78:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	c9                   	leave  
  801b7f:	c2 04 00             	ret    $0x4

00801b82 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	ff 75 10             	pushl  0x10(%ebp)
  801b8c:	ff 75 0c             	pushl  0xc(%ebp)
  801b8f:	ff 75 08             	pushl  0x8(%ebp)
  801b92:	6a 13                	push   $0x13
  801b94:	e8 7f fc ff ff       	call   801818 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9c:	90                   	nop
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_rcr2>:
uint32 sys_rcr2()
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 1e                	push   $0x1e
  801bae:	e8 65 fc ff ff       	call   801818 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	83 ec 04             	sub    $0x4,%esp
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bc4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	50                   	push   %eax
  801bd1:	6a 1f                	push   $0x1f
  801bd3:	e8 40 fc ff ff       	call   801818 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdb:	90                   	nop
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <rsttst>:
void rsttst()
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 21                	push   $0x21
  801bed:	e8 26 fc ff ff       	call   801818 <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf5:	90                   	nop
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	83 ec 04             	sub    $0x4,%esp
  801bfe:	8b 45 14             	mov    0x14(%ebp),%eax
  801c01:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c04:	8b 55 18             	mov    0x18(%ebp),%edx
  801c07:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c0b:	52                   	push   %edx
  801c0c:	50                   	push   %eax
  801c0d:	ff 75 10             	pushl  0x10(%ebp)
  801c10:	ff 75 0c             	pushl  0xc(%ebp)
  801c13:	ff 75 08             	pushl  0x8(%ebp)
  801c16:	6a 20                	push   $0x20
  801c18:	e8 fb fb ff ff       	call   801818 <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c20:	90                   	nop
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <chktst>:
void chktst(uint32 n)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	ff 75 08             	pushl  0x8(%ebp)
  801c31:	6a 22                	push   $0x22
  801c33:	e8 e0 fb ff ff       	call   801818 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3b:	90                   	nop
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <inctst>:

void inctst()
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 23                	push   $0x23
  801c4d:	e8 c6 fb ff ff       	call   801818 <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
	return ;
  801c55:	90                   	nop
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <gettst>:
uint32 gettst()
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 24                	push   $0x24
  801c67:	e8 ac fb ff ff       	call   801818 <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 25                	push   $0x25
  801c80:	e8 93 fb ff ff       	call   801818 <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
  801c88:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801c8d:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	ff 75 08             	pushl  0x8(%ebp)
  801caa:	6a 26                	push   $0x26
  801cac:	e8 67 fb ff ff       	call   801818 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb4:	90                   	nop
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cbb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cbe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	6a 00                	push   $0x0
  801cc9:	53                   	push   %ebx
  801cca:	51                   	push   %ecx
  801ccb:	52                   	push   %edx
  801ccc:	50                   	push   %eax
  801ccd:	6a 27                	push   $0x27
  801ccf:	e8 44 fb ff ff       	call   801818 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	52                   	push   %edx
  801cec:	50                   	push   %eax
  801ced:	6a 28                	push   $0x28
  801cef:	e8 24 fb ff ff       	call   801818 <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cfc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	6a 00                	push   $0x0
  801d07:	51                   	push   %ecx
  801d08:	ff 75 10             	pushl  0x10(%ebp)
  801d0b:	52                   	push   %edx
  801d0c:	50                   	push   %eax
  801d0d:	6a 29                	push   $0x29
  801d0f:	e8 04 fb ff ff       	call   801818 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	ff 75 10             	pushl  0x10(%ebp)
  801d23:	ff 75 0c             	pushl  0xc(%ebp)
  801d26:	ff 75 08             	pushl  0x8(%ebp)
  801d29:	6a 12                	push   $0x12
  801d2b:	e8 e8 fa ff ff       	call   801818 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
	return ;
  801d33:	90                   	nop
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	52                   	push   %edx
  801d46:	50                   	push   %eax
  801d47:	6a 2a                	push   $0x2a
  801d49:	e8 ca fa ff ff       	call   801818 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
	return;
  801d51:	90                   	nop
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 2b                	push   $0x2b
  801d63:	e8 b0 fa ff ff       	call   801818 <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	ff 75 0c             	pushl  0xc(%ebp)
  801d79:	ff 75 08             	pushl  0x8(%ebp)
  801d7c:	6a 2d                	push   $0x2d
  801d7e:	e8 95 fa ff ff       	call   801818 <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
	return;
  801d86:	90                   	nop
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	ff 75 0c             	pushl  0xc(%ebp)
  801d95:	ff 75 08             	pushl  0x8(%ebp)
  801d98:	6a 2c                	push   $0x2c
  801d9a:	e8 79 fa ff ff       	call   801818 <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801da2:	90                   	nop
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801da8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	52                   	push   %edx
  801db5:	50                   	push   %eax
  801db6:	6a 2e                	push   $0x2e
  801db8:	e8 5b fa ff ff       	call   801818 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc0:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  801dcc:	89 d0                	mov    %edx,%eax
  801dce:	c1 e0 02             	shl    $0x2,%eax
  801dd1:	01 d0                	add    %edx,%eax
  801dd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dda:	01 d0                	add    %edx,%eax
  801ddc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801de3:	01 d0                	add    %edx,%eax
  801de5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dec:	01 d0                	add    %edx,%eax
  801dee:	c1 e0 04             	shl    $0x4,%eax
  801df1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801df4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801dfb:	0f 31                	rdtsc  
  801dfd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e00:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e06:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e0c:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e0f:	eb 46                	jmp    801e57 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e11:	0f 31                	rdtsc  
  801e13:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e16:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e1c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e22:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2b:	29 c2                	sub    %eax,%edx
  801e2d:	89 d0                	mov    %edx,%eax
  801e2f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e38:	89 d1                	mov    %edx,%ecx
  801e3a:	29 c1                	sub    %eax,%ecx
  801e3c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e42:	39 c2                	cmp    %eax,%edx
  801e44:	0f 97 c0             	seta   %al
  801e47:	0f b6 c0             	movzbl %al,%eax
  801e4a:	29 c1                	sub    %eax,%ecx
  801e4c:	89 c8                	mov    %ecx,%eax
  801e4e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e51:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e5a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e5d:	72 b2                	jb     801e11 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e5f:	90                   	nop
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801e6f:	eb 03                	jmp    801e74 <busy_wait+0x12>
  801e71:	ff 45 fc             	incl   -0x4(%ebp)
  801e74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e77:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e7a:	72 f5                	jb     801e71 <busy_wait+0xf>
	return i;
  801e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801e8d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801e91:	83 ec 0c             	sub    $0xc,%esp
  801e94:	50                   	push   %eax
  801e95:	e8 35 fb ff ff       	call   8019cf <sys_cputc>
  801e9a:	83 c4 10             	add    $0x10,%esp
}
  801e9d:	90                   	nop
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <getchar>:


int
getchar(void)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801ea6:	e8 c3 f9 ff ff       	call   80186e <sys_cgetc>
  801eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <iscons>:

int iscons(int fdnum)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801eb6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ebb:	5d                   	pop    %ebp
  801ebc:	c3                   	ret    
  801ebd:	66 90                	xchg   %ax,%ax
  801ebf:	90                   	nop

00801ec0 <__udivdi3>:
  801ec0:	55                   	push   %ebp
  801ec1:	57                   	push   %edi
  801ec2:	56                   	push   %esi
  801ec3:	53                   	push   %ebx
  801ec4:	83 ec 1c             	sub    $0x1c,%esp
  801ec7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ecb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ecf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ed3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ed7:	89 ca                	mov    %ecx,%edx
  801ed9:	89 f8                	mov    %edi,%eax
  801edb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801edf:	85 f6                	test   %esi,%esi
  801ee1:	75 2d                	jne    801f10 <__udivdi3+0x50>
  801ee3:	39 cf                	cmp    %ecx,%edi
  801ee5:	77 65                	ja     801f4c <__udivdi3+0x8c>
  801ee7:	89 fd                	mov    %edi,%ebp
  801ee9:	85 ff                	test   %edi,%edi
  801eeb:	75 0b                	jne    801ef8 <__udivdi3+0x38>
  801eed:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef2:	31 d2                	xor    %edx,%edx
  801ef4:	f7 f7                	div    %edi
  801ef6:	89 c5                	mov    %eax,%ebp
  801ef8:	31 d2                	xor    %edx,%edx
  801efa:	89 c8                	mov    %ecx,%eax
  801efc:	f7 f5                	div    %ebp
  801efe:	89 c1                	mov    %eax,%ecx
  801f00:	89 d8                	mov    %ebx,%eax
  801f02:	f7 f5                	div    %ebp
  801f04:	89 cf                	mov    %ecx,%edi
  801f06:	89 fa                	mov    %edi,%edx
  801f08:	83 c4 1c             	add    $0x1c,%esp
  801f0b:	5b                   	pop    %ebx
  801f0c:	5e                   	pop    %esi
  801f0d:	5f                   	pop    %edi
  801f0e:	5d                   	pop    %ebp
  801f0f:	c3                   	ret    
  801f10:	39 ce                	cmp    %ecx,%esi
  801f12:	77 28                	ja     801f3c <__udivdi3+0x7c>
  801f14:	0f bd fe             	bsr    %esi,%edi
  801f17:	83 f7 1f             	xor    $0x1f,%edi
  801f1a:	75 40                	jne    801f5c <__udivdi3+0x9c>
  801f1c:	39 ce                	cmp    %ecx,%esi
  801f1e:	72 0a                	jb     801f2a <__udivdi3+0x6a>
  801f20:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f24:	0f 87 9e 00 00 00    	ja     801fc8 <__udivdi3+0x108>
  801f2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2f:	89 fa                	mov    %edi,%edx
  801f31:	83 c4 1c             	add    $0x1c,%esp
  801f34:	5b                   	pop    %ebx
  801f35:	5e                   	pop    %esi
  801f36:	5f                   	pop    %edi
  801f37:	5d                   	pop    %ebp
  801f38:	c3                   	ret    
  801f39:	8d 76 00             	lea    0x0(%esi),%esi
  801f3c:	31 ff                	xor    %edi,%edi
  801f3e:	31 c0                	xor    %eax,%eax
  801f40:	89 fa                	mov    %edi,%edx
  801f42:	83 c4 1c             	add    $0x1c,%esp
  801f45:	5b                   	pop    %ebx
  801f46:	5e                   	pop    %esi
  801f47:	5f                   	pop    %edi
  801f48:	5d                   	pop    %ebp
  801f49:	c3                   	ret    
  801f4a:	66 90                	xchg   %ax,%ax
  801f4c:	89 d8                	mov    %ebx,%eax
  801f4e:	f7 f7                	div    %edi
  801f50:	31 ff                	xor    %edi,%edi
  801f52:	89 fa                	mov    %edi,%edx
  801f54:	83 c4 1c             	add    $0x1c,%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5f                   	pop    %edi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    
  801f5c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f61:	89 eb                	mov    %ebp,%ebx
  801f63:	29 fb                	sub    %edi,%ebx
  801f65:	89 f9                	mov    %edi,%ecx
  801f67:	d3 e6                	shl    %cl,%esi
  801f69:	89 c5                	mov    %eax,%ebp
  801f6b:	88 d9                	mov    %bl,%cl
  801f6d:	d3 ed                	shr    %cl,%ebp
  801f6f:	89 e9                	mov    %ebp,%ecx
  801f71:	09 f1                	or     %esi,%ecx
  801f73:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f77:	89 f9                	mov    %edi,%ecx
  801f79:	d3 e0                	shl    %cl,%eax
  801f7b:	89 c5                	mov    %eax,%ebp
  801f7d:	89 d6                	mov    %edx,%esi
  801f7f:	88 d9                	mov    %bl,%cl
  801f81:	d3 ee                	shr    %cl,%esi
  801f83:	89 f9                	mov    %edi,%ecx
  801f85:	d3 e2                	shl    %cl,%edx
  801f87:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f8b:	88 d9                	mov    %bl,%cl
  801f8d:	d3 e8                	shr    %cl,%eax
  801f8f:	09 c2                	or     %eax,%edx
  801f91:	89 d0                	mov    %edx,%eax
  801f93:	89 f2                	mov    %esi,%edx
  801f95:	f7 74 24 0c          	divl   0xc(%esp)
  801f99:	89 d6                	mov    %edx,%esi
  801f9b:	89 c3                	mov    %eax,%ebx
  801f9d:	f7 e5                	mul    %ebp
  801f9f:	39 d6                	cmp    %edx,%esi
  801fa1:	72 19                	jb     801fbc <__udivdi3+0xfc>
  801fa3:	74 0b                	je     801fb0 <__udivdi3+0xf0>
  801fa5:	89 d8                	mov    %ebx,%eax
  801fa7:	31 ff                	xor    %edi,%edi
  801fa9:	e9 58 ff ff ff       	jmp    801f06 <__udivdi3+0x46>
  801fae:	66 90                	xchg   %ax,%ax
  801fb0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fb4:	89 f9                	mov    %edi,%ecx
  801fb6:	d3 e2                	shl    %cl,%edx
  801fb8:	39 c2                	cmp    %eax,%edx
  801fba:	73 e9                	jae    801fa5 <__udivdi3+0xe5>
  801fbc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fbf:	31 ff                	xor    %edi,%edi
  801fc1:	e9 40 ff ff ff       	jmp    801f06 <__udivdi3+0x46>
  801fc6:	66 90                	xchg   %ax,%ax
  801fc8:	31 c0                	xor    %eax,%eax
  801fca:	e9 37 ff ff ff       	jmp    801f06 <__udivdi3+0x46>
  801fcf:	90                   	nop

00801fd0 <__umoddi3>:
  801fd0:	55                   	push   %ebp
  801fd1:	57                   	push   %edi
  801fd2:	56                   	push   %esi
  801fd3:	53                   	push   %ebx
  801fd4:	83 ec 1c             	sub    $0x1c,%esp
  801fd7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801fdb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fdf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fe3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fe7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801feb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fef:	89 f3                	mov    %esi,%ebx
  801ff1:	89 fa                	mov    %edi,%edx
  801ff3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ff7:	89 34 24             	mov    %esi,(%esp)
  801ffa:	85 c0                	test   %eax,%eax
  801ffc:	75 1a                	jne    802018 <__umoddi3+0x48>
  801ffe:	39 f7                	cmp    %esi,%edi
  802000:	0f 86 a2 00 00 00    	jbe    8020a8 <__umoddi3+0xd8>
  802006:	89 c8                	mov    %ecx,%eax
  802008:	89 f2                	mov    %esi,%edx
  80200a:	f7 f7                	div    %edi
  80200c:	89 d0                	mov    %edx,%eax
  80200e:	31 d2                	xor    %edx,%edx
  802010:	83 c4 1c             	add    $0x1c,%esp
  802013:	5b                   	pop    %ebx
  802014:	5e                   	pop    %esi
  802015:	5f                   	pop    %edi
  802016:	5d                   	pop    %ebp
  802017:	c3                   	ret    
  802018:	39 f0                	cmp    %esi,%eax
  80201a:	0f 87 ac 00 00 00    	ja     8020cc <__umoddi3+0xfc>
  802020:	0f bd e8             	bsr    %eax,%ebp
  802023:	83 f5 1f             	xor    $0x1f,%ebp
  802026:	0f 84 ac 00 00 00    	je     8020d8 <__umoddi3+0x108>
  80202c:	bf 20 00 00 00       	mov    $0x20,%edi
  802031:	29 ef                	sub    %ebp,%edi
  802033:	89 fe                	mov    %edi,%esi
  802035:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802039:	89 e9                	mov    %ebp,%ecx
  80203b:	d3 e0                	shl    %cl,%eax
  80203d:	89 d7                	mov    %edx,%edi
  80203f:	89 f1                	mov    %esi,%ecx
  802041:	d3 ef                	shr    %cl,%edi
  802043:	09 c7                	or     %eax,%edi
  802045:	89 e9                	mov    %ebp,%ecx
  802047:	d3 e2                	shl    %cl,%edx
  802049:	89 14 24             	mov    %edx,(%esp)
  80204c:	89 d8                	mov    %ebx,%eax
  80204e:	d3 e0                	shl    %cl,%eax
  802050:	89 c2                	mov    %eax,%edx
  802052:	8b 44 24 08          	mov    0x8(%esp),%eax
  802056:	d3 e0                	shl    %cl,%eax
  802058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802060:	89 f1                	mov    %esi,%ecx
  802062:	d3 e8                	shr    %cl,%eax
  802064:	09 d0                	or     %edx,%eax
  802066:	d3 eb                	shr    %cl,%ebx
  802068:	89 da                	mov    %ebx,%edx
  80206a:	f7 f7                	div    %edi
  80206c:	89 d3                	mov    %edx,%ebx
  80206e:	f7 24 24             	mull   (%esp)
  802071:	89 c6                	mov    %eax,%esi
  802073:	89 d1                	mov    %edx,%ecx
  802075:	39 d3                	cmp    %edx,%ebx
  802077:	0f 82 87 00 00 00    	jb     802104 <__umoddi3+0x134>
  80207d:	0f 84 91 00 00 00    	je     802114 <__umoddi3+0x144>
  802083:	8b 54 24 04          	mov    0x4(%esp),%edx
  802087:	29 f2                	sub    %esi,%edx
  802089:	19 cb                	sbb    %ecx,%ebx
  80208b:	89 d8                	mov    %ebx,%eax
  80208d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802091:	d3 e0                	shl    %cl,%eax
  802093:	89 e9                	mov    %ebp,%ecx
  802095:	d3 ea                	shr    %cl,%edx
  802097:	09 d0                	or     %edx,%eax
  802099:	89 e9                	mov    %ebp,%ecx
  80209b:	d3 eb                	shr    %cl,%ebx
  80209d:	89 da                	mov    %ebx,%edx
  80209f:	83 c4 1c             	add    $0x1c,%esp
  8020a2:	5b                   	pop    %ebx
  8020a3:	5e                   	pop    %esi
  8020a4:	5f                   	pop    %edi
  8020a5:	5d                   	pop    %ebp
  8020a6:	c3                   	ret    
  8020a7:	90                   	nop
  8020a8:	89 fd                	mov    %edi,%ebp
  8020aa:	85 ff                	test   %edi,%edi
  8020ac:	75 0b                	jne    8020b9 <__umoddi3+0xe9>
  8020ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b3:	31 d2                	xor    %edx,%edx
  8020b5:	f7 f7                	div    %edi
  8020b7:	89 c5                	mov    %eax,%ebp
  8020b9:	89 f0                	mov    %esi,%eax
  8020bb:	31 d2                	xor    %edx,%edx
  8020bd:	f7 f5                	div    %ebp
  8020bf:	89 c8                	mov    %ecx,%eax
  8020c1:	f7 f5                	div    %ebp
  8020c3:	89 d0                	mov    %edx,%eax
  8020c5:	e9 44 ff ff ff       	jmp    80200e <__umoddi3+0x3e>
  8020ca:	66 90                	xchg   %ax,%ax
  8020cc:	89 c8                	mov    %ecx,%eax
  8020ce:	89 f2                	mov    %esi,%edx
  8020d0:	83 c4 1c             	add    $0x1c,%esp
  8020d3:	5b                   	pop    %ebx
  8020d4:	5e                   	pop    %esi
  8020d5:	5f                   	pop    %edi
  8020d6:	5d                   	pop    %ebp
  8020d7:	c3                   	ret    
  8020d8:	3b 04 24             	cmp    (%esp),%eax
  8020db:	72 06                	jb     8020e3 <__umoddi3+0x113>
  8020dd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020e1:	77 0f                	ja     8020f2 <__umoddi3+0x122>
  8020e3:	89 f2                	mov    %esi,%edx
  8020e5:	29 f9                	sub    %edi,%ecx
  8020e7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020eb:	89 14 24             	mov    %edx,(%esp)
  8020ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020f2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020f6:	8b 14 24             	mov    (%esp),%edx
  8020f9:	83 c4 1c             	add    $0x1c,%esp
  8020fc:	5b                   	pop    %ebx
  8020fd:	5e                   	pop    %esi
  8020fe:	5f                   	pop    %edi
  8020ff:	5d                   	pop    %ebp
  802100:	c3                   	ret    
  802101:	8d 76 00             	lea    0x0(%esi),%esi
  802104:	2b 04 24             	sub    (%esp),%eax
  802107:	19 fa                	sbb    %edi,%edx
  802109:	89 d1                	mov    %edx,%ecx
  80210b:	89 c6                	mov    %eax,%esi
  80210d:	e9 71 ff ff ff       	jmp    802083 <__umoddi3+0xb3>
  802112:	66 90                	xchg   %ax,%ax
  802114:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802118:	72 ea                	jb     802104 <__umoddi3+0x134>
  80211a:	89 d9                	mov    %ebx,%ecx
  80211c:	e9 62 ff ff ff       	jmp    802083 <__umoddi3+0xb3>
