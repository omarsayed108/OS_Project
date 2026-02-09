
obj/user/tst_chan_one_master:     file format elf32-i386


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
  800031:	e8 97 02 00 00       	call   8002cd <libmain>
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
  80003e:	81 ec 3c 01 00 00    	sub    $0x13c,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800044:	83 ec 08             	sub    $0x8,%esp
  800047:	68 80 21 80 00       	push   $0x802180
  80004c:	6a 0e                	push   $0xe
  80004e:	e8 45 07 00 00       	call   800798 <cprintf_colored>
  800053:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	68 b0 21 80 00       	push   $0x8021b0
  80005e:	6a 0e                	push   $0xe
  800060:	e8 33 07 00 00       	call   800798 <cprintf_colored>
  800065:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	68 80 21 80 00       	push   $0x802180
  800070:	6a 0e                	push   $0xe
  800072:	e8 21 07 00 00       	call   800798 <cprintf_colored>
  800077:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80007a:	e8 a8 1a 00 00       	call   801b27 <sys_getenvid>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	char slavesCnt[10];
	readline("Enter the number of Slave Programs: ", slavesCnt);
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	8d 45 ce             	lea    -0x32(%ebp),%eax
  800088:	50                   	push   %eax
  800089:	68 0c 22 80 00       	push   $0x80220c
  80008e:	e8 b1 0d 00 00       	call   800e44 <readline>
  800093:	83 c4 10             	add    $0x10,%esp
	int numOfSlaves = strtol(slavesCnt, NULL, 10);
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	6a 00                	push   $0x0
  80009d:	8d 45 ce             	lea    -0x32(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 b5 13 00 00       	call   80145b <strtol>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//Save number of slaved to be checked later
	char cmd1[64] = "__NumOfSlaves@Set";
  8000ac:	8d 45 88             	lea    -0x78(%ebp),%eax
  8000af:	bb 96 23 80 00       	mov    $0x802396,%ebx
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
  8000da:	e8 97 1c 00 00       	call   801d76 <sys_utilities>
  8000df:	83 c4 10             	add    $0x10,%esp

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  8000e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000e9:	eb 6a                	jmp    800155 <_main+0x11d>
	{
		id = sys_create_env("tstChanOneSlave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f0:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  8000f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fb:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800101:	89 c1                	mov    %eax,%ecx
  800103:	a1 20 30 80 00       	mov    0x803020,%eax
  800108:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80010e:	52                   	push   %edx
  80010f:	51                   	push   %ecx
  800110:	50                   	push   %eax
  800111:	68 31 22 80 00       	push   $0x802231
  800116:	e8 b7 19 00 00       	call   801ad2 <sys_create_env>
  80011b:	83 c4 10             	add    $0x10,%esp
  80011e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (id== E_ENV_CREATION_ERROR)
  800121:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  800125:	75 1d                	jne    800144 <_main+0x10c>
		{
			cprintf_colored(TEXT_TESTERR_CLR, "\n%~insufficient number of processes in the system! only %d slave processes are created\n", i);
  800127:	83 ec 04             	sub    $0x4,%esp
  80012a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80012d:	68 44 22 80 00       	push   $0x802244
  800132:	6a 0c                	push   $0xc
  800134:	e8 5f 06 00 00       	call   800798 <cprintf_colored>
  800139:	83 c4 10             	add    $0x10,%esp
			numOfSlaves = i;
  80013c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			break;
  800142:	eb 19                	jmp    80015d <_main+0x125>
		}
		sys_run_env(id);
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	ff 75 d8             	pushl  -0x28(%ebp)
  80014a:	e8 a1 19 00 00       	call   801af0 <sys_run_env>
  80014f:	83 c4 10             	add    $0x10,%esp
	char cmd1[64] = "__NumOfSlaves@Set";
	sys_utilities(cmd1, (uint32)(&numOfSlaves));

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  800152:	ff 45 e4             	incl   -0x1c(%ebp)
  800155:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800158:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80015b:	7c 8e                	jl     8000eb <_main+0xb3>
		}
		sys_run_env(id);
	}

	//Wait until all slaves are blocked
	int numOfBlockedProcesses = 0;
  80015d:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
	char cmd2[64] = "__GetChanQueueSize__";
  800164:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  80016a:	bb d6 23 80 00       	mov    $0x8023d6,%ebx
  80016f:	ba 15 00 00 00       	mov    $0x15,%edx
  800174:	89 c7                	mov    %eax,%edi
  800176:	89 de                	mov    %ebx,%esi
  800178:	89 d1                	mov    %edx,%ecx
  80017a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80017c:	8d 95 59 ff ff ff    	lea    -0xa7(%ebp),%edx
  800182:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  800187:	b0 00                	mov    $0x0,%al
  800189:	89 d7                	mov    %edx,%edi
  80018b:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
  80018d:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	50                   	push   %eax
  800194:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  80019a:	50                   	push   %eax
  80019b:	e8 d6 1b 00 00       	call   801d76 <sys_utilities>
  8001a0:	83 c4 10             	add    $0x10,%esp
	int cnt = 0;
  8001a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	while (numOfBlockedProcesses != numOfSlaves)
  8001aa:	eb 76                	jmp    800222 <_main+0x1ea>
	{
		env_sleep(5000);
  8001ac:	83 ec 0c             	sub    $0xc,%esp
  8001af:	68 88 13 00 00       	push   $0x1388
  8001b4:	e8 4a 1c 00 00       	call   801e03 <env_sleep>
  8001b9:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  8001bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001bf:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8001c2:	75 1c                	jne    8001e0 <_main+0x1a8>
		{
			panic("%~test channels failed! unexpected number of blocked slaves. Expected = %d, Current = %d", numOfSlaves, numOfBlockedProcesses);
  8001c4:	8b 55 84             	mov    -0x7c(%ebp),%edx
  8001c7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	52                   	push   %edx
  8001ce:	50                   	push   %eax
  8001cf:	68 9c 22 80 00       	push   $0x80229c
  8001d4:	6a 2d                	push   $0x2d
  8001d6:	68 f5 22 80 00       	push   $0x8022f5
  8001db:	e8 9d 02 00 00       	call   80047d <_panic>
		}
		char cmd3[64] = "__GetChanQueueSize__";
  8001e0:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  8001e6:	bb d6 23 80 00       	mov    $0x8023d6,%ebx
  8001eb:	ba 15 00 00 00       	mov    $0x15,%edx
  8001f0:	89 c7                	mov    %eax,%edi
  8001f2:	89 de                	mov    %ebx,%esi
  8001f4:	89 d1                	mov    %edx,%ecx
  8001f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001f8:	8d 95 d9 fe ff ff    	lea    -0x127(%ebp),%edx
  8001fe:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  800203:	b0 00                	mov    $0x0,%al
  800205:	89 d7                	mov    %edx,%edi
  800207:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(cmd3, (uint32)(&numOfBlockedProcesses));
  800209:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	50                   	push   %eax
  800210:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  800216:	50                   	push   %eax
  800217:	e8 5a 1b 00 00       	call   801d76 <sys_utilities>
  80021c:	83 c4 10             	add    $0x10,%esp
		cnt++ ;
  80021f:	ff 45 e0             	incl   -0x20(%ebp)
	//Wait until all slaves are blocked
	int numOfBlockedProcesses = 0;
	char cmd2[64] = "__GetChanQueueSize__";
	sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
	int cnt = 0;
	while (numOfBlockedProcesses != numOfSlaves)
  800222:	8b 55 84             	mov    -0x7c(%ebp),%edx
  800225:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800228:	39 c2                	cmp    %eax,%edx
  80022a:	75 80                	jne    8001ac <_main+0x174>
		char cmd3[64] = "__GetChanQueueSize__";
		sys_utilities(cmd3, (uint32)(&numOfBlockedProcesses));
		cnt++ ;
	}

	rsttst();
  80022c:	e8 ed 19 00 00       	call   801c1e <rsttst>

	//Wakeup one
	char cmd4[64] = "__WakeupOne__";
  800231:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  800237:	bb 16 24 80 00       	mov    $0x802416,%ebx
  80023c:	ba 0e 00 00 00       	mov    $0xe,%edx
  800241:	89 c7                	mov    %eax,%edi
  800243:	89 de                	mov    %ebx,%esi
  800245:	89 d1                	mov    %edx,%ecx
  800247:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800249:	8d 95 12 ff ff ff    	lea    -0xee(%ebp),%edx
  80024f:	b9 32 00 00 00       	mov    $0x32,%ecx
  800254:	b0 00                	mov    $0x0,%al
  800256:	89 d7                	mov    %edx,%edi
  800258:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd4, 0);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	6a 00                	push   $0x0
  80025f:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  800265:	50                   	push   %eax
  800266:	e8 0b 1b 00 00       	call   801d76 <sys_utilities>
  80026b:	83 c4 10             	add    $0x10,%esp

	//Wait until all slave finished
	cnt = 0;
  80026e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	while (gettst() != numOfSlaves)
  800275:	eb 2f                	jmp    8002a6 <_main+0x26e>
	{
		env_sleep(10000);
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	68 10 27 00 00       	push   $0x2710
  80027f:	e8 7f 1b 00 00       	call   801e03 <env_sleep>
  800284:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  800287:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80028a:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  80028d:	75 14                	jne    8002a3 <_main+0x26b>
		{
			panic("%~test channels failed! not all slaves finished");
  80028f:	83 ec 04             	sub    $0x4,%esp
  800292:	68 10 23 80 00       	push   $0x802310
  800297:	6a 41                	push   $0x41
  800299:	68 f5 22 80 00       	push   $0x8022f5
  80029e:	e8 da 01 00 00       	call   80047d <_panic>
		}
		cnt++ ;
  8002a3:	ff 45 e0             	incl   -0x20(%ebp)
	char cmd4[64] = "__WakeupOne__";
	sys_utilities(cmd4, 0);

	//Wait until all slave finished
	cnt = 0;
	while (gettst() != numOfSlaves)
  8002a6:	e8 ed 19 00 00       	call   801c98 <gettst>
  8002ab:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8002ae:	39 d0                	cmp    %edx,%eax
  8002b0:	75 c5                	jne    800277 <_main+0x23f>
			panic("%~test channels failed! not all slaves finished");
		}
		cnt++ ;
	}

	cprintf_colored(TEXT_light_green, "%~\n\nCongratulations!! Test of Channel (sleep & wakeup ONE) completed successfully!!\n\n");
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	68 40 23 80 00       	push   $0x802340
  8002ba:	6a 0a                	push   $0xa
  8002bc:	e8 d7 04 00 00       	call   800798 <cprintf_colored>
  8002c1:	83 c4 10             	add    $0x10,%esp

	return;
  8002c4:	90                   	nop
}
  8002c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c8:	5b                   	pop    %ebx
  8002c9:	5e                   	pop    %esi
  8002ca:	5f                   	pop    %edi
  8002cb:	5d                   	pop    %ebp
  8002cc:	c3                   	ret    

008002cd <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	57                   	push   %edi
  8002d1:	56                   	push   %esi
  8002d2:	53                   	push   %ebx
  8002d3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002d6:	e8 65 18 00 00       	call   801b40 <sys_getenvindex>
  8002db:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e1:	89 d0                	mov    %edx,%eax
  8002e3:	01 c0                	add    %eax,%eax
  8002e5:	01 d0                	add    %edx,%eax
  8002e7:	c1 e0 02             	shl    $0x2,%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	c1 e0 02             	shl    $0x2,%eax
  8002ef:	01 d0                	add    %edx,%eax
  8002f1:	c1 e0 03             	shl    $0x3,%eax
  8002f4:	01 d0                	add    %edx,%eax
  8002f6:	c1 e0 02             	shl    $0x2,%eax
  8002f9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002fe:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800303:	a1 20 30 80 00       	mov    0x803020,%eax
  800308:	8a 40 20             	mov    0x20(%eax),%al
  80030b:	84 c0                	test   %al,%al
  80030d:	74 0d                	je     80031c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80030f:	a1 20 30 80 00       	mov    0x803020,%eax
  800314:	83 c0 20             	add    $0x20,%eax
  800317:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80031c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800320:	7e 0a                	jle    80032c <libmain+0x5f>
		binaryname = argv[0];
  800322:	8b 45 0c             	mov    0xc(%ebp),%eax
  800325:	8b 00                	mov    (%eax),%eax
  800327:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	ff 75 0c             	pushl  0xc(%ebp)
  800332:	ff 75 08             	pushl  0x8(%ebp)
  800335:	e8 fe fc ff ff       	call   800038 <_main>
  80033a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80033d:	a1 00 30 80 00       	mov    0x803000,%eax
  800342:	85 c0                	test   %eax,%eax
  800344:	0f 84 01 01 00 00    	je     80044b <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80034a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800350:	bb 50 25 80 00       	mov    $0x802550,%ebx
  800355:	ba 0e 00 00 00       	mov    $0xe,%edx
  80035a:	89 c7                	mov    %eax,%edi
  80035c:	89 de                	mov    %ebx,%esi
  80035e:	89 d1                	mov    %edx,%ecx
  800360:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800362:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800365:	b9 56 00 00 00       	mov    $0x56,%ecx
  80036a:	b0 00                	mov    $0x0,%al
  80036c:	89 d7                	mov    %edx,%edi
  80036e:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800370:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800377:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80037a:	83 ec 08             	sub    $0x8,%esp
  80037d:	50                   	push   %eax
  80037e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800384:	50                   	push   %eax
  800385:	e8 ec 19 00 00       	call   801d76 <sys_utilities>
  80038a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80038d:	e8 35 15 00 00       	call   8018c7 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800392:	83 ec 0c             	sub    $0xc,%esp
  800395:	68 70 24 80 00       	push   $0x802470
  80039a:	e8 cc 03 00 00       	call   80076b <cprintf>
  80039f:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a5:	85 c0                	test   %eax,%eax
  8003a7:	74 18                	je     8003c1 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003a9:	e8 e6 19 00 00       	call   801d94 <sys_get_optimal_num_faults>
  8003ae:	83 ec 08             	sub    $0x8,%esp
  8003b1:	50                   	push   %eax
  8003b2:	68 98 24 80 00       	push   $0x802498
  8003b7:	e8 af 03 00 00       	call   80076b <cprintf>
  8003bc:	83 c4 10             	add    $0x10,%esp
  8003bf:	eb 59                	jmp    80041a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c6:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8003cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d1:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8003d7:	83 ec 04             	sub    $0x4,%esp
  8003da:	52                   	push   %edx
  8003db:	50                   	push   %eax
  8003dc:	68 bc 24 80 00       	push   $0x8024bc
  8003e1:	e8 85 03 00 00       	call   80076b <cprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ee:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8003f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f9:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8003ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800404:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80040a:	51                   	push   %ecx
  80040b:	52                   	push   %edx
  80040c:	50                   	push   %eax
  80040d:	68 e4 24 80 00       	push   $0x8024e4
  800412:	e8 54 03 00 00       	call   80076b <cprintf>
  800417:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80041a:	a1 20 30 80 00       	mov    0x803020,%eax
  80041f:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800425:	83 ec 08             	sub    $0x8,%esp
  800428:	50                   	push   %eax
  800429:	68 3c 25 80 00       	push   $0x80253c
  80042e:	e8 38 03 00 00       	call   80076b <cprintf>
  800433:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800436:	83 ec 0c             	sub    $0xc,%esp
  800439:	68 70 24 80 00       	push   $0x802470
  80043e:	e8 28 03 00 00       	call   80076b <cprintf>
  800443:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800446:	e8 96 14 00 00       	call   8018e1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80044b:	e8 1f 00 00 00       	call   80046f <exit>
}
  800450:	90                   	nop
  800451:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800454:	5b                   	pop    %ebx
  800455:	5e                   	pop    %esi
  800456:	5f                   	pop    %edi
  800457:	5d                   	pop    %ebp
  800458:	c3                   	ret    

00800459 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80045f:	83 ec 0c             	sub    $0xc,%esp
  800462:	6a 00                	push   $0x0
  800464:	e8 a3 16 00 00       	call   801b0c <sys_destroy_env>
  800469:	83 c4 10             	add    $0x10,%esp
}
  80046c:	90                   	nop
  80046d:	c9                   	leave  
  80046e:	c3                   	ret    

0080046f <exit>:

void
exit(void)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800475:	e8 f8 16 00 00       	call   801b72 <sys_exit_env>
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800483:	8d 45 10             	lea    0x10(%ebp),%eax
  800486:	83 c0 04             	add    $0x4,%eax
  800489:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80048c:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800491:	85 c0                	test   %eax,%eax
  800493:	74 16                	je     8004ab <_panic+0x2e>
		cprintf("%s: ", argv0);
  800495:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	50                   	push   %eax
  80049e:	68 b4 25 80 00       	push   $0x8025b4
  8004a3:	e8 c3 02 00 00       	call   80076b <cprintf>
  8004a8:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004ab:	a1 04 30 80 00       	mov    0x803004,%eax
  8004b0:	83 ec 0c             	sub    $0xc,%esp
  8004b3:	ff 75 0c             	pushl  0xc(%ebp)
  8004b6:	ff 75 08             	pushl  0x8(%ebp)
  8004b9:	50                   	push   %eax
  8004ba:	68 bc 25 80 00       	push   $0x8025bc
  8004bf:	6a 74                	push   $0x74
  8004c1:	e8 d2 02 00 00       	call   800798 <cprintf_colored>
  8004c6:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d2:	50                   	push   %eax
  8004d3:	e8 24 02 00 00       	call   8006fc <vcprintf>
  8004d8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	6a 00                	push   $0x0
  8004e0:	68 e4 25 80 00       	push   $0x8025e4
  8004e5:	e8 12 02 00 00       	call   8006fc <vcprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004ed:	e8 7d ff ff ff       	call   80046f <exit>

	// should not return here
	while (1) ;
  8004f2:	eb fe                	jmp    8004f2 <_panic+0x75>

008004f4 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004f4:	55                   	push   %ebp
  8004f5:	89 e5                	mov    %esp,%ebp
  8004f7:	53                   	push   %ebx
  8004f8:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800500:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800506:	8b 45 0c             	mov    0xc(%ebp),%eax
  800509:	39 c2                	cmp    %eax,%edx
  80050b:	74 14                	je     800521 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	68 e8 25 80 00       	push   $0x8025e8
  800515:	6a 26                	push   $0x26
  800517:	68 34 26 80 00       	push   $0x802634
  80051c:	e8 5c ff ff ff       	call   80047d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800521:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800528:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80052f:	e9 d9 00 00 00       	jmp    80060d <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800534:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800537:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	01 d0                	add    %edx,%eax
  800543:	8b 00                	mov    (%eax),%eax
  800545:	85 c0                	test   %eax,%eax
  800547:	75 08                	jne    800551 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800549:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80054c:	e9 b9 00 00 00       	jmp    80060a <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800551:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800558:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80055f:	eb 79                	jmp    8005da <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800561:	a1 20 30 80 00       	mov    0x803020,%eax
  800566:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80056c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80056f:	89 d0                	mov    %edx,%eax
  800571:	01 c0                	add    %eax,%eax
  800573:	01 d0                	add    %edx,%eax
  800575:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80057c:	01 d8                	add    %ebx,%eax
  80057e:	01 d0                	add    %edx,%eax
  800580:	01 c8                	add    %ecx,%eax
  800582:	8a 40 04             	mov    0x4(%eax),%al
  800585:	84 c0                	test   %al,%al
  800587:	75 4e                	jne    8005d7 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800589:	a1 20 30 80 00       	mov    0x803020,%eax
  80058e:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800594:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800597:	89 d0                	mov    %edx,%eax
  800599:	01 c0                	add    %eax,%eax
  80059b:	01 d0                	add    %edx,%eax
  80059d:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8005a4:	01 d8                	add    %ebx,%eax
  8005a6:	01 d0                	add    %edx,%eax
  8005a8:	01 c8                	add    %ecx,%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005b7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ca:	39 c2                	cmp    %eax,%edx
  8005cc:	75 09                	jne    8005d7 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8005ce:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005d5:	eb 19                	jmp    8005f0 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d7:	ff 45 e8             	incl   -0x18(%ebp)
  8005da:	a1 20 30 80 00       	mov    0x803020,%eax
  8005df:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e8:	39 c2                	cmp    %eax,%edx
  8005ea:	0f 87 71 ff ff ff    	ja     800561 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f4:	75 14                	jne    80060a <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8005f6:	83 ec 04             	sub    $0x4,%esp
  8005f9:	68 40 26 80 00       	push   $0x802640
  8005fe:	6a 3a                	push   $0x3a
  800600:	68 34 26 80 00       	push   $0x802634
  800605:	e8 73 fe ff ff       	call   80047d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80060a:	ff 45 f0             	incl   -0x10(%ebp)
  80060d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800610:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800613:	0f 8c 1b ff ff ff    	jl     800534 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800619:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800620:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800627:	eb 2e                	jmp    800657 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800629:	a1 20 30 80 00       	mov    0x803020,%eax
  80062e:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800634:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800637:	89 d0                	mov    %edx,%eax
  800639:	01 c0                	add    %eax,%eax
  80063b:	01 d0                	add    %edx,%eax
  80063d:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800644:	01 d8                	add    %ebx,%eax
  800646:	01 d0                	add    %edx,%eax
  800648:	01 c8                	add    %ecx,%eax
  80064a:	8a 40 04             	mov    0x4(%eax),%al
  80064d:	3c 01                	cmp    $0x1,%al
  80064f:	75 03                	jne    800654 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800651:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800654:	ff 45 e0             	incl   -0x20(%ebp)
  800657:	a1 20 30 80 00       	mov    0x803020,%eax
  80065c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800662:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800665:	39 c2                	cmp    %eax,%edx
  800667:	77 c0                	ja     800629 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80066f:	74 14                	je     800685 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800671:	83 ec 04             	sub    $0x4,%esp
  800674:	68 94 26 80 00       	push   $0x802694
  800679:	6a 44                	push   $0x44
  80067b:	68 34 26 80 00       	push   $0x802634
  800680:	e8 f8 fd ff ff       	call   80047d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800685:	90                   	nop
  800686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800689:	c9                   	leave  
  80068a:	c3                   	ret    

0080068b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
  80068e:	53                   	push   %ebx
  80068f:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800692:	8b 45 0c             	mov    0xc(%ebp),%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	8d 48 01             	lea    0x1(%eax),%ecx
  80069a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069d:	89 0a                	mov    %ecx,(%edx)
  80069f:	8b 55 08             	mov    0x8(%ebp),%edx
  8006a2:	88 d1                	mov    %dl,%cl
  8006a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b5:	75 30                	jne    8006e7 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006b7:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006bd:	a0 44 30 80 00       	mov    0x803044,%al
  8006c2:	0f b6 c0             	movzbl %al,%eax
  8006c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c8:	8b 09                	mov    (%ecx),%ecx
  8006ca:	89 cb                	mov    %ecx,%ebx
  8006cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006cf:	83 c1 08             	add    $0x8,%ecx
  8006d2:	52                   	push   %edx
  8006d3:	50                   	push   %eax
  8006d4:	53                   	push   %ebx
  8006d5:	51                   	push   %ecx
  8006d6:	e8 a8 11 00 00       	call   801883 <sys_cputs>
  8006db:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ea:	8b 40 04             	mov    0x4(%eax),%eax
  8006ed:	8d 50 01             	lea    0x1(%eax),%edx
  8006f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006f6:	90                   	nop
  8006f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fa:	c9                   	leave  
  8006fb:	c3                   	ret    

008006fc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
  8006ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800705:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80070c:	00 00 00 
	b.cnt = 0;
  80070f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800716:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800719:	ff 75 0c             	pushl  0xc(%ebp)
  80071c:	ff 75 08             	pushl  0x8(%ebp)
  80071f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800725:	50                   	push   %eax
  800726:	68 8b 06 80 00       	push   $0x80068b
  80072b:	e8 5a 02 00 00       	call   80098a <vprintfmt>
  800730:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800733:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800739:	a0 44 30 80 00       	mov    0x803044,%al
  80073e:	0f b6 c0             	movzbl %al,%eax
  800741:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800747:	52                   	push   %edx
  800748:	50                   	push   %eax
  800749:	51                   	push   %ecx
  80074a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800750:	83 c0 08             	add    $0x8,%eax
  800753:	50                   	push   %eax
  800754:	e8 2a 11 00 00       	call   801883 <sys_cputs>
  800759:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80075c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800763:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800769:	c9                   	leave  
  80076a:	c3                   	ret    

0080076b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800771:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800778:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 f4             	pushl  -0xc(%ebp)
  800787:	50                   	push   %eax
  800788:	e8 6f ff ff ff       	call   8006fc <vcprintf>
  80078d:	83 c4 10             	add    $0x10,%esp
  800790:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800793:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800796:	c9                   	leave  
  800797:	c3                   	ret    

00800798 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80079e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	c1 e0 08             	shl    $0x8,%eax
  8007ab:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8007b0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b3:	83 c0 04             	add    $0x4,%eax
  8007b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	e8 34 ff ff ff       	call   8006fc <vcprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007ce:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007d5:	07 00 00 

	return cnt;
  8007d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007db:	c9                   	leave  
  8007dc:	c3                   	ret    

008007dd <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007e3:	e8 df 10 00 00       	call   8018c7 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f7:	50                   	push   %eax
  8007f8:	e8 ff fe ff ff       	call   8006fc <vcprintf>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800803:	e8 d9 10 00 00       	call   8018e1 <sys_unlock_cons>
	return cnt;
  800808:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80080b:	c9                   	leave  
  80080c:	c3                   	ret    

0080080d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	53                   	push   %ebx
  800811:	83 ec 14             	sub    $0x14,%esp
  800814:	8b 45 10             	mov    0x10(%ebp),%eax
  800817:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800820:	8b 45 18             	mov    0x18(%ebp),%eax
  800823:	ba 00 00 00 00       	mov    $0x0,%edx
  800828:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082b:	77 55                	ja     800882 <printnum+0x75>
  80082d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800830:	72 05                	jb     800837 <printnum+0x2a>
  800832:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800835:	77 4b                	ja     800882 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800837:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80083a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80083d:	8b 45 18             	mov    0x18(%ebp),%eax
  800840:	ba 00 00 00 00       	mov    $0x0,%edx
  800845:	52                   	push   %edx
  800846:	50                   	push   %eax
  800847:	ff 75 f4             	pushl  -0xc(%ebp)
  80084a:	ff 75 f0             	pushl  -0x10(%ebp)
  80084d:	e8 ae 16 00 00       	call   801f00 <__udivdi3>
  800852:	83 c4 10             	add    $0x10,%esp
  800855:	83 ec 04             	sub    $0x4,%esp
  800858:	ff 75 20             	pushl  0x20(%ebp)
  80085b:	53                   	push   %ebx
  80085c:	ff 75 18             	pushl  0x18(%ebp)
  80085f:	52                   	push   %edx
  800860:	50                   	push   %eax
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	ff 75 08             	pushl  0x8(%ebp)
  800867:	e8 a1 ff ff ff       	call   80080d <printnum>
  80086c:	83 c4 20             	add    $0x20,%esp
  80086f:	eb 1a                	jmp    80088b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	ff 75 0c             	pushl  0xc(%ebp)
  800877:	ff 75 20             	pushl  0x20(%ebp)
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	ff d0                	call   *%eax
  80087f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800882:	ff 4d 1c             	decl   0x1c(%ebp)
  800885:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800889:	7f e6                	jg     800871 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80088b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80088e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800896:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800899:	53                   	push   %ebx
  80089a:	51                   	push   %ecx
  80089b:	52                   	push   %edx
  80089c:	50                   	push   %eax
  80089d:	e8 6e 17 00 00       	call   802010 <__umoddi3>
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	05 f4 28 80 00       	add    $0x8028f4,%eax
  8008aa:	8a 00                	mov    (%eax),%al
  8008ac:	0f be c0             	movsbl %al,%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	ff 75 0c             	pushl  0xc(%ebp)
  8008b5:	50                   	push   %eax
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	ff d0                	call   *%eax
  8008bb:	83 c4 10             	add    $0x10,%esp
}
  8008be:	90                   	nop
  8008bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    

008008c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008cb:	7e 1c                	jle    8008e9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	8d 50 08             	lea    0x8(%eax),%edx
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	89 10                	mov    %edx,(%eax)
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	83 e8 08             	sub    $0x8,%eax
  8008e2:	8b 50 04             	mov    0x4(%eax),%edx
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	eb 40                	jmp    800929 <getuint+0x65>
	else if (lflag)
  8008e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ed:	74 1e                	je     80090d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	8d 50 04             	lea    0x4(%eax),%edx
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	89 10                	mov    %edx,(%eax)
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	83 e8 04             	sub    $0x4,%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	ba 00 00 00 00       	mov    $0x0,%edx
  80090b:	eb 1c                	jmp    800929 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	8d 50 04             	lea    0x4(%eax),%edx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	89 10                	mov    %edx,(%eax)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	83 e8 04             	sub    $0x4,%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80092e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800932:	7e 1c                	jle    800950 <getint+0x25>
		return va_arg(*ap, long long);
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 00                	mov    (%eax),%eax
  800939:	8d 50 08             	lea    0x8(%eax),%edx
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	89 10                	mov    %edx,(%eax)
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	83 e8 08             	sub    $0x8,%eax
  800949:	8b 50 04             	mov    0x4(%eax),%edx
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	eb 38                	jmp    800988 <getint+0x5d>
	else if (lflag)
  800950:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800954:	74 1a                	je     800970 <getint+0x45>
		return va_arg(*ap, long);
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	8d 50 04             	lea    0x4(%eax),%edx
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	89 10                	mov    %edx,(%eax)
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	83 e8 04             	sub    $0x4,%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	99                   	cltd   
  80096e:	eb 18                	jmp    800988 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8b 00                	mov    (%eax),%eax
  800975:	8d 50 04             	lea    0x4(%eax),%edx
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	89 10                	mov    %edx,(%eax)
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8b 00                	mov    (%eax),%eax
  800982:	83 e8 04             	sub    $0x4,%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	99                   	cltd   
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	56                   	push   %esi
  80098e:	53                   	push   %ebx
  80098f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800992:	eb 17                	jmp    8009ab <vprintfmt+0x21>
			if (ch == '\0')
  800994:	85 db                	test   %ebx,%ebx
  800996:	0f 84 c1 03 00 00    	je     800d5d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	53                   	push   %ebx
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	ff d0                	call   *%eax
  8009a8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ae:	8d 50 01             	lea    0x1(%eax),%edx
  8009b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b4:	8a 00                	mov    (%eax),%al
  8009b6:	0f b6 d8             	movzbl %al,%ebx
  8009b9:	83 fb 25             	cmp    $0x25,%ebx
  8009bc:	75 d6                	jne    800994 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009de:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e1:	8d 50 01             	lea    0x1(%eax),%edx
  8009e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e7:	8a 00                	mov    (%eax),%al
  8009e9:	0f b6 d8             	movzbl %al,%ebx
  8009ec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ef:	83 f8 5b             	cmp    $0x5b,%eax
  8009f2:	0f 87 3d 03 00 00    	ja     800d35 <vprintfmt+0x3ab>
  8009f8:	8b 04 85 18 29 80 00 	mov    0x802918(,%eax,4),%eax
  8009ff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a01:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a05:	eb d7                	jmp    8009de <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a07:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a0b:	eb d1                	jmp    8009de <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a0d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a17:	89 d0                	mov    %edx,%eax
  800a19:	c1 e0 02             	shl    $0x2,%eax
  800a1c:	01 d0                	add    %edx,%eax
  800a1e:	01 c0                	add    %eax,%eax
  800a20:	01 d8                	add    %ebx,%eax
  800a22:	83 e8 30             	sub    $0x30,%eax
  800a25:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a28:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2b:	8a 00                	mov    (%eax),%al
  800a2d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a30:	83 fb 2f             	cmp    $0x2f,%ebx
  800a33:	7e 3e                	jle    800a73 <vprintfmt+0xe9>
  800a35:	83 fb 39             	cmp    $0x39,%ebx
  800a38:	7f 39                	jg     800a73 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a3a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a3d:	eb d5                	jmp    800a14 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a42:	83 c0 04             	add    $0x4,%eax
  800a45:	89 45 14             	mov    %eax,0x14(%ebp)
  800a48:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4b:	83 e8 04             	sub    $0x4,%eax
  800a4e:	8b 00                	mov    (%eax),%eax
  800a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a53:	eb 1f                	jmp    800a74 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a59:	79 83                	jns    8009de <vprintfmt+0x54>
				width = 0;
  800a5b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a62:	e9 77 ff ff ff       	jmp    8009de <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a67:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a6e:	e9 6b ff ff ff       	jmp    8009de <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a73:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a78:	0f 89 60 ff ff ff    	jns    8009de <vprintfmt+0x54>
				width = precision, precision = -1;
  800a7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a84:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a8b:	e9 4e ff ff ff       	jmp    8009de <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a90:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a93:	e9 46 ff ff ff       	jmp    8009de <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a98:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9b:	83 c0 04             	add    $0x4,%eax
  800a9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa1:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa4:	83 e8 04             	sub    $0x4,%eax
  800aa7:	8b 00                	mov    (%eax),%eax
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	50                   	push   %eax
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	ff d0                	call   *%eax
  800ab5:	83 c4 10             	add    $0x10,%esp
			break;
  800ab8:	e9 9b 02 00 00       	jmp    800d58 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800abd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac0:	83 c0 04             	add    $0x4,%eax
  800ac3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac9:	83 e8 04             	sub    $0x4,%eax
  800acc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ace:	85 db                	test   %ebx,%ebx
  800ad0:	79 02                	jns    800ad4 <vprintfmt+0x14a>
				err = -err;
  800ad2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ad4:	83 fb 64             	cmp    $0x64,%ebx
  800ad7:	7f 0b                	jg     800ae4 <vprintfmt+0x15a>
  800ad9:	8b 34 9d 60 27 80 00 	mov    0x802760(,%ebx,4),%esi
  800ae0:	85 f6                	test   %esi,%esi
  800ae2:	75 19                	jne    800afd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ae4:	53                   	push   %ebx
  800ae5:	68 05 29 80 00       	push   $0x802905
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	ff 75 08             	pushl  0x8(%ebp)
  800af0:	e8 70 02 00 00       	call   800d65 <printfmt>
  800af5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800af8:	e9 5b 02 00 00       	jmp    800d58 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800afd:	56                   	push   %esi
  800afe:	68 0e 29 80 00       	push   $0x80290e
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	e8 57 02 00 00       	call   800d65 <printfmt>
  800b0e:	83 c4 10             	add    $0x10,%esp
			break;
  800b11:	e9 42 02 00 00       	jmp    800d58 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b16:	8b 45 14             	mov    0x14(%ebp),%eax
  800b19:	83 c0 04             	add    $0x4,%eax
  800b1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	83 e8 04             	sub    $0x4,%eax
  800b25:	8b 30                	mov    (%eax),%esi
  800b27:	85 f6                	test   %esi,%esi
  800b29:	75 05                	jne    800b30 <vprintfmt+0x1a6>
				p = "(null)";
  800b2b:	be 11 29 80 00       	mov    $0x802911,%esi
			if (width > 0 && padc != '-')
  800b30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b34:	7e 6d                	jle    800ba3 <vprintfmt+0x219>
  800b36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b3a:	74 67                	je     800ba3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	50                   	push   %eax
  800b43:	56                   	push   %esi
  800b44:	e8 26 05 00 00       	call   80106f <strnlen>
  800b49:	83 c4 10             	add    $0x10,%esp
  800b4c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b4f:	eb 16                	jmp    800b67 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b51:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	50                   	push   %eax
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	ff d0                	call   *%eax
  800b61:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b64:	ff 4d e4             	decl   -0x1c(%ebp)
  800b67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6b:	7f e4                	jg     800b51 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6d:	eb 34                	jmp    800ba3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b73:	74 1c                	je     800b91 <vprintfmt+0x207>
  800b75:	83 fb 1f             	cmp    $0x1f,%ebx
  800b78:	7e 05                	jle    800b7f <vprintfmt+0x1f5>
  800b7a:	83 fb 7e             	cmp    $0x7e,%ebx
  800b7d:	7e 12                	jle    800b91 <vprintfmt+0x207>
					putch('?', putdat);
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	6a 3f                	push   $0x3f
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	ff d0                	call   *%eax
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	eb 0f                	jmp    800ba0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	53                   	push   %ebx
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	ff d0                	call   *%eax
  800b9d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba0:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba3:	89 f0                	mov    %esi,%eax
  800ba5:	8d 70 01             	lea    0x1(%eax),%esi
  800ba8:	8a 00                	mov    (%eax),%al
  800baa:	0f be d8             	movsbl %al,%ebx
  800bad:	85 db                	test   %ebx,%ebx
  800baf:	74 24                	je     800bd5 <vprintfmt+0x24b>
  800bb1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb5:	78 b8                	js     800b6f <vprintfmt+0x1e5>
  800bb7:	ff 4d e0             	decl   -0x20(%ebp)
  800bba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bbe:	79 af                	jns    800b6f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc0:	eb 13                	jmp    800bd5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bc2:	83 ec 08             	sub    $0x8,%esp
  800bc5:	ff 75 0c             	pushl  0xc(%ebp)
  800bc8:	6a 20                	push   $0x20
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	ff d0                	call   *%eax
  800bcf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd2:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd9:	7f e7                	jg     800bc2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bdb:	e9 78 01 00 00       	jmp    800d58 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800be0:	83 ec 08             	sub    $0x8,%esp
  800be3:	ff 75 e8             	pushl  -0x18(%ebp)
  800be6:	8d 45 14             	lea    0x14(%ebp),%eax
  800be9:	50                   	push   %eax
  800bea:	e8 3c fd ff ff       	call   80092b <getint>
  800bef:	83 c4 10             	add    $0x10,%esp
  800bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfe:	85 d2                	test   %edx,%edx
  800c00:	79 23                	jns    800c25 <vprintfmt+0x29b>
				putch('-', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 2d                	push   $0x2d
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c18:	f7 d8                	neg    %eax
  800c1a:	83 d2 00             	adc    $0x0,%edx
  800c1d:	f7 da                	neg    %edx
  800c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2c:	e9 bc 00 00 00       	jmp    800ced <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 e8             	pushl  -0x18(%ebp)
  800c37:	8d 45 14             	lea    0x14(%ebp),%eax
  800c3a:	50                   	push   %eax
  800c3b:	e8 84 fc ff ff       	call   8008c4 <getuint>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c49:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c50:	e9 98 00 00 00       	jmp    800ced <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c55:	83 ec 08             	sub    $0x8,%esp
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	6a 58                	push   $0x58
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	ff d0                	call   *%eax
  800c62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	ff 75 0c             	pushl  0xc(%ebp)
  800c6b:	6a 58                	push   $0x58
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	ff d0                	call   *%eax
  800c72:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	6a 58                	push   $0x58
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	ff d0                	call   *%eax
  800c82:	83 c4 10             	add    $0x10,%esp
			break;
  800c85:	e9 ce 00 00 00       	jmp    800d58 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	6a 30                	push   $0x30
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	ff d0                	call   *%eax
  800c97:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c9a:	83 ec 08             	sub    $0x8,%esp
  800c9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ca0:	6a 78                	push   $0x78
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	ff d0                	call   *%eax
  800ca7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800caa:	8b 45 14             	mov    0x14(%ebp),%eax
  800cad:	83 c0 04             	add    $0x4,%eax
  800cb0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb6:	83 e8 04             	sub    $0x4,%eax
  800cb9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cc5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ccc:	eb 1f                	jmp    800ced <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd7:	50                   	push   %eax
  800cd8:	e8 e7 fb ff ff       	call   8008c4 <getuint>
  800cdd:	83 c4 10             	add    $0x10,%esp
  800ce0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ce6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ced:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf4:	83 ec 04             	sub    $0x4,%esp
  800cf7:	52                   	push   %edx
  800cf8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cfb:	50                   	push   %eax
  800cfc:	ff 75 f4             	pushl  -0xc(%ebp)
  800cff:	ff 75 f0             	pushl  -0x10(%ebp)
  800d02:	ff 75 0c             	pushl  0xc(%ebp)
  800d05:	ff 75 08             	pushl  0x8(%ebp)
  800d08:	e8 00 fb ff ff       	call   80080d <printnum>
  800d0d:	83 c4 20             	add    $0x20,%esp
			break;
  800d10:	eb 46                	jmp    800d58 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	53                   	push   %ebx
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	ff d0                	call   *%eax
  800d1e:	83 c4 10             	add    $0x10,%esp
			break;
  800d21:	eb 35                	jmp    800d58 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d23:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d2a:	eb 2c                	jmp    800d58 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d2c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d33:	eb 23                	jmp    800d58 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d35:	83 ec 08             	sub    $0x8,%esp
  800d38:	ff 75 0c             	pushl  0xc(%ebp)
  800d3b:	6a 25                	push   $0x25
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	ff d0                	call   *%eax
  800d42:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d45:	ff 4d 10             	decl   0x10(%ebp)
  800d48:	eb 03                	jmp    800d4d <vprintfmt+0x3c3>
  800d4a:	ff 4d 10             	decl   0x10(%ebp)
  800d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d50:	48                   	dec    %eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	3c 25                	cmp    $0x25,%al
  800d55:	75 f3                	jne    800d4a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d57:	90                   	nop
		}
	}
  800d58:	e9 35 fc ff ff       	jmp    800992 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d5d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d61:	5b                   	pop    %ebx
  800d62:	5e                   	pop    %esi
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d6b:	8d 45 10             	lea    0x10(%ebp),%eax
  800d6e:	83 c0 04             	add    $0x4,%eax
  800d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d74:	8b 45 10             	mov    0x10(%ebp),%eax
  800d77:	ff 75 f4             	pushl  -0xc(%ebp)
  800d7a:	50                   	push   %eax
  800d7b:	ff 75 0c             	pushl  0xc(%ebp)
  800d7e:	ff 75 08             	pushl  0x8(%ebp)
  800d81:	e8 04 fc ff ff       	call   80098a <vprintfmt>
  800d86:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d89:	90                   	nop
  800d8a:	c9                   	leave  
  800d8b:	c3                   	ret    

00800d8c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	8b 40 08             	mov    0x8(%eax),%eax
  800d95:	8d 50 01             	lea    0x1(%eax),%edx
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da1:	8b 10                	mov    (%eax),%edx
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8b 40 04             	mov    0x4(%eax),%eax
  800da9:	39 c2                	cmp    %eax,%edx
  800dab:	73 12                	jae    800dbf <sprintputch+0x33>
		*b->buf++ = ch;
  800dad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db0:	8b 00                	mov    (%eax),%eax
  800db2:	8d 48 01             	lea    0x1(%eax),%ecx
  800db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db8:	89 0a                	mov    %ecx,(%edx)
  800dba:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbd:	88 10                	mov    %dl,(%eax)
}
  800dbf:	90                   	nop
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    

00800dc2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	01 d0                	add    %edx,%eax
  800dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ddc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800de3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800de7:	74 06                	je     800def <vsnprintf+0x2d>
  800de9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ded:	7f 07                	jg     800df6 <vsnprintf+0x34>
		return -E_INVAL;
  800def:	b8 03 00 00 00       	mov    $0x3,%eax
  800df4:	eb 20                	jmp    800e16 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800df6:	ff 75 14             	pushl  0x14(%ebp)
  800df9:	ff 75 10             	pushl  0x10(%ebp)
  800dfc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dff:	50                   	push   %eax
  800e00:	68 8c 0d 80 00       	push   $0x800d8c
  800e05:	e8 80 fb ff ff       	call   80098a <vprintfmt>
  800e0a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e10:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e16:	c9                   	leave  
  800e17:	c3                   	ret    

00800e18 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e1e:	8d 45 10             	lea    0x10(%ebp),%eax
  800e21:	83 c0 04             	add    $0x4,%eax
  800e24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e27:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2d:	50                   	push   %eax
  800e2e:	ff 75 0c             	pushl  0xc(%ebp)
  800e31:	ff 75 08             	pushl  0x8(%ebp)
  800e34:	e8 89 ff ff ff       	call   800dc2 <vsnprintf>
  800e39:	83 c4 10             	add    $0x10,%esp
  800e3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e42:	c9                   	leave  
  800e43:	c3                   	ret    

00800e44 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800e4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e4e:	74 13                	je     800e63 <readline+0x1f>
		cprintf("%s", prompt);
  800e50:	83 ec 08             	sub    $0x8,%esp
  800e53:	ff 75 08             	pushl  0x8(%ebp)
  800e56:	68 88 2a 80 00       	push   $0x802a88
  800e5b:	e8 0b f9 ff ff       	call   80076b <cprintf>
  800e60:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e6a:	83 ec 0c             	sub    $0xc,%esp
  800e6d:	6a 00                	push   $0x0
  800e6f:	e8 7f 10 00 00       	call   801ef3 <iscons>
  800e74:	83 c4 10             	add    $0x10,%esp
  800e77:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e7a:	e8 61 10 00 00       	call   801ee0 <getchar>
  800e7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e86:	79 22                	jns    800eaa <readline+0x66>
			if (c != -E_EOF)
  800e88:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e8c:	0f 84 ad 00 00 00    	je     800f3f <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e92:	83 ec 08             	sub    $0x8,%esp
  800e95:	ff 75 ec             	pushl  -0x14(%ebp)
  800e98:	68 8b 2a 80 00       	push   $0x802a8b
  800e9d:	e8 c9 f8 ff ff       	call   80076b <cprintf>
  800ea2:	83 c4 10             	add    $0x10,%esp
			break;
  800ea5:	e9 95 00 00 00       	jmp    800f3f <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800eaa:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800eae:	7e 34                	jle    800ee4 <readline+0xa0>
  800eb0:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800eb7:	7f 2b                	jg     800ee4 <readline+0xa0>
			if (echoing)
  800eb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ebd:	74 0e                	je     800ecd <readline+0x89>
				cputchar(c);
  800ebf:	83 ec 0c             	sub    $0xc,%esp
  800ec2:	ff 75 ec             	pushl  -0x14(%ebp)
  800ec5:	e8 f7 0f 00 00       	call   801ec1 <cputchar>
  800eca:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed0:	8d 50 01             	lea    0x1(%eax),%edx
  800ed3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ed6:	89 c2                	mov    %eax,%edx
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	01 d0                	add    %edx,%eax
  800edd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ee0:	88 10                	mov    %dl,(%eax)
  800ee2:	eb 56                	jmp    800f3a <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800ee4:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ee8:	75 1f                	jne    800f09 <readline+0xc5>
  800eea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800eee:	7e 19                	jle    800f09 <readline+0xc5>
			if (echoing)
  800ef0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ef4:	74 0e                	je     800f04 <readline+0xc0>
				cputchar(c);
  800ef6:	83 ec 0c             	sub    $0xc,%esp
  800ef9:	ff 75 ec             	pushl  -0x14(%ebp)
  800efc:	e8 c0 0f 00 00       	call   801ec1 <cputchar>
  800f01:	83 c4 10             	add    $0x10,%esp

			i--;
  800f04:	ff 4d f4             	decl   -0xc(%ebp)
  800f07:	eb 31                	jmp    800f3a <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800f09:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800f0d:	74 0a                	je     800f19 <readline+0xd5>
  800f0f:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800f13:	0f 85 61 ff ff ff    	jne    800e7a <readline+0x36>
			if (echoing)
  800f19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f1d:	74 0e                	je     800f2d <readline+0xe9>
				cputchar(c);
  800f1f:	83 ec 0c             	sub    $0xc,%esp
  800f22:	ff 75 ec             	pushl  -0x14(%ebp)
  800f25:	e8 97 0f 00 00       	call   801ec1 <cputchar>
  800f2a:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	01 d0                	add    %edx,%eax
  800f35:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800f38:	eb 06                	jmp    800f40 <readline+0xfc>
		}
	}
  800f3a:	e9 3b ff ff ff       	jmp    800e7a <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800f3f:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800f40:	90                   	nop
  800f41:	c9                   	leave  
  800f42:	c3                   	ret    

00800f43 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800f49:	e8 79 09 00 00       	call   8018c7 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800f4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f52:	74 13                	je     800f67 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800f54:	83 ec 08             	sub    $0x8,%esp
  800f57:	ff 75 08             	pushl  0x8(%ebp)
  800f5a:	68 88 2a 80 00       	push   $0x802a88
  800f5f:	e8 07 f8 ff ff       	call   80076b <cprintf>
  800f64:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800f67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800f6e:	83 ec 0c             	sub    $0xc,%esp
  800f71:	6a 00                	push   $0x0
  800f73:	e8 7b 0f 00 00       	call   801ef3 <iscons>
  800f78:	83 c4 10             	add    $0x10,%esp
  800f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800f7e:	e8 5d 0f 00 00       	call   801ee0 <getchar>
  800f83:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800f86:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f8a:	79 22                	jns    800fae <atomic_readline+0x6b>
				if (c != -E_EOF)
  800f8c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f90:	0f 84 ad 00 00 00    	je     801043 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 ec             	pushl  -0x14(%ebp)
  800f9c:	68 8b 2a 80 00       	push   $0x802a8b
  800fa1:	e8 c5 f7 ff ff       	call   80076b <cprintf>
  800fa6:	83 c4 10             	add    $0x10,%esp
				break;
  800fa9:	e9 95 00 00 00       	jmp    801043 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800fae:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800fb2:	7e 34                	jle    800fe8 <atomic_readline+0xa5>
  800fb4:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800fbb:	7f 2b                	jg     800fe8 <atomic_readline+0xa5>
				if (echoing)
  800fbd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fc1:	74 0e                	je     800fd1 <atomic_readline+0x8e>
					cputchar(c);
  800fc3:	83 ec 0c             	sub    $0xc,%esp
  800fc6:	ff 75 ec             	pushl  -0x14(%ebp)
  800fc9:	e8 f3 0e 00 00       	call   801ec1 <cputchar>
  800fce:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd4:	8d 50 01             	lea    0x1(%eax),%edx
  800fd7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800fda:	89 c2                	mov    %eax,%edx
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	01 d0                	add    %edx,%eax
  800fe1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fe4:	88 10                	mov    %dl,(%eax)
  800fe6:	eb 56                	jmp    80103e <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800fe8:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800fec:	75 1f                	jne    80100d <atomic_readline+0xca>
  800fee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ff2:	7e 19                	jle    80100d <atomic_readline+0xca>
				if (echoing)
  800ff4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ff8:	74 0e                	je     801008 <atomic_readline+0xc5>
					cputchar(c);
  800ffa:	83 ec 0c             	sub    $0xc,%esp
  800ffd:	ff 75 ec             	pushl  -0x14(%ebp)
  801000:	e8 bc 0e 00 00       	call   801ec1 <cputchar>
  801005:	83 c4 10             	add    $0x10,%esp
				i--;
  801008:	ff 4d f4             	decl   -0xc(%ebp)
  80100b:	eb 31                	jmp    80103e <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80100d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801011:	74 0a                	je     80101d <atomic_readline+0xda>
  801013:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801017:	0f 85 61 ff ff ff    	jne    800f7e <atomic_readline+0x3b>
				if (echoing)
  80101d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801021:	74 0e                	je     801031 <atomic_readline+0xee>
					cputchar(c);
  801023:	83 ec 0c             	sub    $0xc,%esp
  801026:	ff 75 ec             	pushl  -0x14(%ebp)
  801029:	e8 93 0e 00 00       	call   801ec1 <cputchar>
  80102e:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801031:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	01 d0                	add    %edx,%eax
  801039:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80103c:	eb 06                	jmp    801044 <atomic_readline+0x101>
			}
		}
  80103e:	e9 3b ff ff ff       	jmp    800f7e <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801043:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801044:	e8 98 08 00 00       	call   8018e1 <sys_unlock_cons>
}
  801049:	90                   	nop
  80104a:	c9                   	leave  
  80104b:	c3                   	ret    

0080104c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801052:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801059:	eb 06                	jmp    801061 <strlen+0x15>
		n++;
  80105b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80105e:	ff 45 08             	incl   0x8(%ebp)
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	84 c0                	test   %al,%al
  801068:	75 f1                	jne    80105b <strlen+0xf>
		n++;
	return n;
  80106a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80106d:	c9                   	leave  
  80106e:	c3                   	ret    

0080106f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801075:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80107c:	eb 09                	jmp    801087 <strnlen+0x18>
		n++;
  80107e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801081:	ff 45 08             	incl   0x8(%ebp)
  801084:	ff 4d 0c             	decl   0xc(%ebp)
  801087:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80108b:	74 09                	je     801096 <strnlen+0x27>
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	84 c0                	test   %al,%al
  801094:	75 e8                	jne    80107e <strnlen+0xf>
		n++;
	return n;
  801096:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010a7:	90                   	nop
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	8d 50 01             	lea    0x1(%eax),%edx
  8010ae:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010ba:	8a 12                	mov    (%edx),%dl
  8010bc:	88 10                	mov    %dl,(%eax)
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	84 c0                	test   %al,%al
  8010c2:	75 e4                	jne    8010a8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010c7:	c9                   	leave  
  8010c8:	c3                   	ret    

008010c9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010dc:	eb 1f                	jmp    8010fd <strncpy+0x34>
		*dst++ = *src;
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	8d 50 01             	lea    0x1(%eax),%edx
  8010e4:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ea:	8a 12                	mov    (%edx),%dl
  8010ec:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	84 c0                	test   %al,%al
  8010f5:	74 03                	je     8010fa <strncpy+0x31>
			src++;
  8010f7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010fa:	ff 45 fc             	incl   -0x4(%ebp)
  8010fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801100:	3b 45 10             	cmp    0x10(%ebp),%eax
  801103:	72 d9                	jb     8010de <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801105:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801108:	c9                   	leave  
  801109:	c3                   	ret    

0080110a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801116:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111a:	74 30                	je     80114c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80111c:	eb 16                	jmp    801134 <strlcpy+0x2a>
			*dst++ = *src++;
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8d 50 01             	lea    0x1(%eax),%edx
  801124:	89 55 08             	mov    %edx,0x8(%ebp)
  801127:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80112d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801130:	8a 12                	mov    (%edx),%dl
  801132:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801134:	ff 4d 10             	decl   0x10(%ebp)
  801137:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113b:	74 09                	je     801146 <strlcpy+0x3c>
  80113d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	84 c0                	test   %al,%al
  801144:	75 d8                	jne    80111e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80114c:	8b 55 08             	mov    0x8(%ebp),%edx
  80114f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801152:	29 c2                	sub    %eax,%edx
  801154:	89 d0                	mov    %edx,%eax
}
  801156:	c9                   	leave  
  801157:	c3                   	ret    

00801158 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80115b:	eb 06                	jmp    801163 <strcmp+0xb>
		p++, q++;
  80115d:	ff 45 08             	incl   0x8(%ebp)
  801160:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	84 c0                	test   %al,%al
  80116a:	74 0e                	je     80117a <strcmp+0x22>
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	8a 10                	mov    (%eax),%dl
  801171:	8b 45 0c             	mov    0xc(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	38 c2                	cmp    %al,%dl
  801178:	74 e3                	je     80115d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	0f b6 d0             	movzbl %al,%edx
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	0f b6 c0             	movzbl %al,%eax
  80118a:	29 c2                	sub    %eax,%edx
  80118c:	89 d0                	mov    %edx,%eax
}
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    

00801190 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801193:	eb 09                	jmp    80119e <strncmp+0xe>
		n--, p++, q++;
  801195:	ff 4d 10             	decl   0x10(%ebp)
  801198:	ff 45 08             	incl   0x8(%ebp)
  80119b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80119e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a2:	74 17                	je     8011bb <strncmp+0x2b>
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	84 c0                	test   %al,%al
  8011ab:	74 0e                	je     8011bb <strncmp+0x2b>
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 10                	mov    (%eax),%dl
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	8a 00                	mov    (%eax),%al
  8011b7:	38 c2                	cmp    %al,%dl
  8011b9:	74 da                	je     801195 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bf:	75 07                	jne    8011c8 <strncmp+0x38>
		return 0;
  8011c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c6:	eb 14                	jmp    8011dc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	0f b6 d0             	movzbl %al,%edx
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f b6 c0             	movzbl %al,%eax
  8011d8:	29 c2                	sub    %eax,%edx
  8011da:	89 d0                	mov    %edx,%eax
}
  8011dc:	5d                   	pop    %ebp
  8011dd:	c3                   	ret    

008011de <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	83 ec 04             	sub    $0x4,%esp
  8011e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011ea:	eb 12                	jmp    8011fe <strchr+0x20>
		if (*s == c)
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	8a 00                	mov    (%eax),%al
  8011f1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011f4:	75 05                	jne    8011fb <strchr+0x1d>
			return (char *) s;
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	eb 11                	jmp    80120c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011fb:	ff 45 08             	incl   0x8(%ebp)
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	84 c0                	test   %al,%al
  801205:	75 e5                	jne    8011ec <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801207:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 04             	sub    $0x4,%esp
  801214:	8b 45 0c             	mov    0xc(%ebp),%eax
  801217:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80121a:	eb 0d                	jmp    801229 <strfind+0x1b>
		if (*s == c)
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801224:	74 0e                	je     801234 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801226:	ff 45 08             	incl   0x8(%ebp)
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	84 c0                	test   %al,%al
  801230:	75 ea                	jne    80121c <strfind+0xe>
  801232:	eb 01                	jmp    801235 <strfind+0x27>
		if (*s == c)
			break;
  801234:	90                   	nop
	return (char *) s;
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801238:	c9                   	leave  
  801239:	c3                   	ret    

0080123a <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801246:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80124a:	76 63                	jbe    8012af <memset+0x75>
		uint64 data_block = c;
  80124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124f:	99                   	cltd   
  801250:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801253:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801259:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801260:	c1 e0 08             	shl    $0x8,%eax
  801263:	09 45 f0             	or     %eax,-0x10(%ebp)
  801266:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801269:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80126c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801273:	c1 e0 10             	shl    $0x10,%eax
  801276:	09 45 f0             	or     %eax,-0x10(%ebp)
  801279:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80127c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801282:	89 c2                	mov    %eax,%edx
  801284:	b8 00 00 00 00       	mov    $0x0,%eax
  801289:	09 45 f0             	or     %eax,-0x10(%ebp)
  80128c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80128f:	eb 18                	jmp    8012a9 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801291:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801294:	8d 41 08             	lea    0x8(%ecx),%eax
  801297:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80129a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80129d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a0:	89 01                	mov    %eax,(%ecx)
  8012a2:	89 51 04             	mov    %edx,0x4(%ecx)
  8012a5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8012a9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012ad:	77 e2                	ja     801291 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8012af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b3:	74 23                	je     8012d8 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8012b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012bb:	eb 0e                	jmp    8012cb <memset+0x91>
			*p8++ = (uint8)c;
  8012bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c0:	8d 50 01             	lea    0x1(%eax),%edx
  8012c3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c9:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	75 e5                	jne    8012bd <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012db:	c9                   	leave  
  8012dc:	c3                   	ret    

008012dd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8012e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8012ef:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012f3:	76 24                	jbe    801319 <memcpy+0x3c>
		while(n >= 8){
  8012f5:	eb 1c                	jmp    801313 <memcpy+0x36>
			*d64 = *s64;
  8012f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fa:	8b 50 04             	mov    0x4(%eax),%edx
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801302:	89 01                	mov    %eax,(%ecx)
  801304:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801307:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80130b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80130f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801313:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801317:	77 de                	ja     8012f7 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801319:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80131d:	74 31                	je     801350 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80131f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801322:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801325:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801328:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80132b:	eb 16                	jmp    801343 <memcpy+0x66>
			*d8++ = *s8++;
  80132d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801330:	8d 50 01             	lea    0x1(%eax),%edx
  801333:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801336:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801339:	8d 4a 01             	lea    0x1(%edx),%ecx
  80133c:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80133f:	8a 12                	mov    (%edx),%dl
  801341:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801343:	8b 45 10             	mov    0x10(%ebp),%eax
  801346:	8d 50 ff             	lea    -0x1(%eax),%edx
  801349:	89 55 10             	mov    %edx,0x10(%ebp)
  80134c:	85 c0                	test   %eax,%eax
  80134e:	75 dd                	jne    80132d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801353:	c9                   	leave  
  801354:	c3                   	ret    

00801355 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801367:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80136a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80136d:	73 50                	jae    8013bf <memmove+0x6a>
  80136f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801372:	8b 45 10             	mov    0x10(%ebp),%eax
  801375:	01 d0                	add    %edx,%eax
  801377:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80137a:	76 43                	jbe    8013bf <memmove+0x6a>
		s += n;
  80137c:	8b 45 10             	mov    0x10(%ebp),%eax
  80137f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801382:	8b 45 10             	mov    0x10(%ebp),%eax
  801385:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801388:	eb 10                	jmp    80139a <memmove+0x45>
			*--d = *--s;
  80138a:	ff 4d f8             	decl   -0x8(%ebp)
  80138d:	ff 4d fc             	decl   -0x4(%ebp)
  801390:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801393:	8a 10                	mov    (%eax),%dl
  801395:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801398:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80139a:	8b 45 10             	mov    0x10(%ebp),%eax
  80139d:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a0:	89 55 10             	mov    %edx,0x10(%ebp)
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	75 e3                	jne    80138a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013a7:	eb 23                	jmp    8013cc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ac:	8d 50 01             	lea    0x1(%eax),%edx
  8013af:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013b8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013bb:	8a 12                	mov    (%edx),%dl
  8013bd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013c5:	89 55 10             	mov    %edx,0x10(%ebp)
  8013c8:	85 c0                	test   %eax,%eax
  8013ca:	75 dd                	jne    8013a9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013e3:	eb 2a                	jmp    80140f <memcmp+0x3e>
		if (*s1 != *s2)
  8013e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e8:	8a 10                	mov    (%eax),%dl
  8013ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	38 c2                	cmp    %al,%dl
  8013f1:	74 16                	je     801409 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	0f b6 d0             	movzbl %al,%edx
  8013fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f b6 c0             	movzbl %al,%eax
  801403:	29 c2                	sub    %eax,%edx
  801405:	89 d0                	mov    %edx,%eax
  801407:	eb 18                	jmp    801421 <memcmp+0x50>
		s1++, s2++;
  801409:	ff 45 fc             	incl   -0x4(%ebp)
  80140c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80140f:	8b 45 10             	mov    0x10(%ebp),%eax
  801412:	8d 50 ff             	lea    -0x1(%eax),%edx
  801415:	89 55 10             	mov    %edx,0x10(%ebp)
  801418:	85 c0                	test   %eax,%eax
  80141a:	75 c9                	jne    8013e5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80141c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801429:	8b 55 08             	mov    0x8(%ebp),%edx
  80142c:	8b 45 10             	mov    0x10(%ebp),%eax
  80142f:	01 d0                	add    %edx,%eax
  801431:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801434:	eb 15                	jmp    80144b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	0f b6 d0             	movzbl %al,%edx
  80143e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801441:	0f b6 c0             	movzbl %al,%eax
  801444:	39 c2                	cmp    %eax,%edx
  801446:	74 0d                	je     801455 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801448:	ff 45 08             	incl   0x8(%ebp)
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801451:	72 e3                	jb     801436 <memfind+0x13>
  801453:	eb 01                	jmp    801456 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801455:	90                   	nop
	return (void *) s;
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801461:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801468:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80146f:	eb 03                	jmp    801474 <strtol+0x19>
		s++;
  801471:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	3c 20                	cmp    $0x20,%al
  80147b:	74 f4                	je     801471 <strtol+0x16>
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	3c 09                	cmp    $0x9,%al
  801484:	74 eb                	je     801471 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	8a 00                	mov    (%eax),%al
  80148b:	3c 2b                	cmp    $0x2b,%al
  80148d:	75 05                	jne    801494 <strtol+0x39>
		s++;
  80148f:	ff 45 08             	incl   0x8(%ebp)
  801492:	eb 13                	jmp    8014a7 <strtol+0x4c>
	else if (*s == '-')
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	3c 2d                	cmp    $0x2d,%al
  80149b:	75 0a                	jne    8014a7 <strtol+0x4c>
		s++, neg = 1;
  80149d:	ff 45 08             	incl   0x8(%ebp)
  8014a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ab:	74 06                	je     8014b3 <strtol+0x58>
  8014ad:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014b1:	75 20                	jne    8014d3 <strtol+0x78>
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	3c 30                	cmp    $0x30,%al
  8014ba:	75 17                	jne    8014d3 <strtol+0x78>
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	40                   	inc    %eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	3c 78                	cmp    $0x78,%al
  8014c4:	75 0d                	jne    8014d3 <strtol+0x78>
		s += 2, base = 16;
  8014c6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014ca:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014d1:	eb 28                	jmp    8014fb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d7:	75 15                	jne    8014ee <strtol+0x93>
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8a 00                	mov    (%eax),%al
  8014de:	3c 30                	cmp    $0x30,%al
  8014e0:	75 0c                	jne    8014ee <strtol+0x93>
		s++, base = 8;
  8014e2:	ff 45 08             	incl   0x8(%ebp)
  8014e5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014ec:	eb 0d                	jmp    8014fb <strtol+0xa0>
	else if (base == 0)
  8014ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014f2:	75 07                	jne    8014fb <strtol+0xa0>
		base = 10;
  8014f4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	3c 2f                	cmp    $0x2f,%al
  801502:	7e 19                	jle    80151d <strtol+0xc2>
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	3c 39                	cmp    $0x39,%al
  80150b:	7f 10                	jg     80151d <strtol+0xc2>
			dig = *s - '0';
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	8a 00                	mov    (%eax),%al
  801512:	0f be c0             	movsbl %al,%eax
  801515:	83 e8 30             	sub    $0x30,%eax
  801518:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80151b:	eb 42                	jmp    80155f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	3c 60                	cmp    $0x60,%al
  801524:	7e 19                	jle    80153f <strtol+0xe4>
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	3c 7a                	cmp    $0x7a,%al
  80152d:	7f 10                	jg     80153f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8a 00                	mov    (%eax),%al
  801534:	0f be c0             	movsbl %al,%eax
  801537:	83 e8 57             	sub    $0x57,%eax
  80153a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80153d:	eb 20                	jmp    80155f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	3c 40                	cmp    $0x40,%al
  801546:	7e 39                	jle    801581 <strtol+0x126>
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	3c 5a                	cmp    $0x5a,%al
  80154f:	7f 30                	jg     801581 <strtol+0x126>
			dig = *s - 'A' + 10;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	0f be c0             	movsbl %al,%eax
  801559:	83 e8 37             	sub    $0x37,%eax
  80155c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80155f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801562:	3b 45 10             	cmp    0x10(%ebp),%eax
  801565:	7d 19                	jge    801580 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801567:	ff 45 08             	incl   0x8(%ebp)
  80156a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801571:	89 c2                	mov    %eax,%edx
  801573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801576:	01 d0                	add    %edx,%eax
  801578:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80157b:	e9 7b ff ff ff       	jmp    8014fb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801580:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801581:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801585:	74 08                	je     80158f <strtol+0x134>
		*endptr = (char *) s;
  801587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158a:	8b 55 08             	mov    0x8(%ebp),%edx
  80158d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80158f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801593:	74 07                	je     80159c <strtol+0x141>
  801595:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801598:	f7 d8                	neg    %eax
  80159a:	eb 03                	jmp    80159f <strtol+0x144>
  80159c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <ltostr>:

void
ltostr(long value, char *str)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b9:	79 13                	jns    8015ce <ltostr+0x2d>
	{
		neg = 1;
  8015bb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015c8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015cb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015d6:	99                   	cltd   
  8015d7:	f7 f9                	idiv   %ecx
  8015d9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015df:	8d 50 01             	lea    0x1(%eax),%edx
  8015e2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015e5:	89 c2                	mov    %eax,%edx
  8015e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ea:	01 d0                	add    %edx,%eax
  8015ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015ef:	83 c2 30             	add    $0x30,%edx
  8015f2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015f7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015fc:	f7 e9                	imul   %ecx
  8015fe:	c1 fa 02             	sar    $0x2,%edx
  801601:	89 c8                	mov    %ecx,%eax
  801603:	c1 f8 1f             	sar    $0x1f,%eax
  801606:	29 c2                	sub    %eax,%edx
  801608:	89 d0                	mov    %edx,%eax
  80160a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80160d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801611:	75 bb                	jne    8015ce <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801613:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80161a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80161d:	48                   	dec    %eax
  80161e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801621:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801625:	74 3d                	je     801664 <ltostr+0xc3>
		start = 1 ;
  801627:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80162e:	eb 34                	jmp    801664 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801630:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801633:	8b 45 0c             	mov    0xc(%ebp),%eax
  801636:	01 d0                	add    %edx,%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80163d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801640:	8b 45 0c             	mov    0xc(%ebp),%eax
  801643:	01 c2                	add    %eax,%edx
  801645:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164b:	01 c8                	add    %ecx,%eax
  80164d:	8a 00                	mov    (%eax),%al
  80164f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801651:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801654:	8b 45 0c             	mov    0xc(%ebp),%eax
  801657:	01 c2                	add    %eax,%edx
  801659:	8a 45 eb             	mov    -0x15(%ebp),%al
  80165c:	88 02                	mov    %al,(%edx)
		start++ ;
  80165e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801661:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801667:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80166a:	7c c4                	jl     801630 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80166c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80166f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801672:	01 d0                	add    %edx,%eax
  801674:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801677:	90                   	nop
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801680:	ff 75 08             	pushl  0x8(%ebp)
  801683:	e8 c4 f9 ff ff       	call   80104c <strlen>
  801688:	83 c4 04             	add    $0x4,%esp
  80168b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	e8 b6 f9 ff ff       	call   80104c <strlen>
  801696:	83 c4 04             	add    $0x4,%esp
  801699:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80169c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016aa:	eb 17                	jmp    8016c3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	01 c2                	add    %eax,%edx
  8016b4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	01 c8                	add    %ecx,%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016c0:	ff 45 fc             	incl   -0x4(%ebp)
  8016c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016c9:	7c e1                	jl     8016ac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016d9:	eb 1f                	jmp    8016fa <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016de:	8d 50 01             	lea    0x1(%eax),%edx
  8016e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016e4:	89 c2                	mov    %eax,%edx
  8016e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e9:	01 c2                	add    %eax,%edx
  8016eb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f1:	01 c8                	add    %ecx,%eax
  8016f3:	8a 00                	mov    (%eax),%al
  8016f5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016f7:	ff 45 f8             	incl   -0x8(%ebp)
  8016fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801700:	7c d9                	jl     8016db <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801702:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801705:	8b 45 10             	mov    0x10(%ebp),%eax
  801708:	01 d0                	add    %edx,%eax
  80170a:	c6 00 00             	movb   $0x0,(%eax)
}
  80170d:	90                   	nop
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801713:	8b 45 14             	mov    0x14(%ebp),%eax
  801716:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80171c:	8b 45 14             	mov    0x14(%ebp),%eax
  80171f:	8b 00                	mov    (%eax),%eax
  801721:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801728:	8b 45 10             	mov    0x10(%ebp),%eax
  80172b:	01 d0                	add    %edx,%eax
  80172d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801733:	eb 0c                	jmp    801741 <strsplit+0x31>
			*string++ = 0;
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	8d 50 01             	lea    0x1(%eax),%edx
  80173b:	89 55 08             	mov    %edx,0x8(%ebp)
  80173e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	84 c0                	test   %al,%al
  801748:	74 18                	je     801762 <strsplit+0x52>
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8a 00                	mov    (%eax),%al
  80174f:	0f be c0             	movsbl %al,%eax
  801752:	50                   	push   %eax
  801753:	ff 75 0c             	pushl  0xc(%ebp)
  801756:	e8 83 fa ff ff       	call   8011de <strchr>
  80175b:	83 c4 08             	add    $0x8,%esp
  80175e:	85 c0                	test   %eax,%eax
  801760:	75 d3                	jne    801735 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	8a 00                	mov    (%eax),%al
  801767:	84 c0                	test   %al,%al
  801769:	74 5a                	je     8017c5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80176b:	8b 45 14             	mov    0x14(%ebp),%eax
  80176e:	8b 00                	mov    (%eax),%eax
  801770:	83 f8 0f             	cmp    $0xf,%eax
  801773:	75 07                	jne    80177c <strsplit+0x6c>
		{
			return 0;
  801775:	b8 00 00 00 00       	mov    $0x0,%eax
  80177a:	eb 66                	jmp    8017e2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80177c:	8b 45 14             	mov    0x14(%ebp),%eax
  80177f:	8b 00                	mov    (%eax),%eax
  801781:	8d 48 01             	lea    0x1(%eax),%ecx
  801784:	8b 55 14             	mov    0x14(%ebp),%edx
  801787:	89 0a                	mov    %ecx,(%edx)
  801789:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801790:	8b 45 10             	mov    0x10(%ebp),%eax
  801793:	01 c2                	add    %eax,%edx
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80179a:	eb 03                	jmp    80179f <strsplit+0x8f>
			string++;
  80179c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	84 c0                	test   %al,%al
  8017a6:	74 8b                	je     801733 <strsplit+0x23>
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	8a 00                	mov    (%eax),%al
  8017ad:	0f be c0             	movsbl %al,%eax
  8017b0:	50                   	push   %eax
  8017b1:	ff 75 0c             	pushl  0xc(%ebp)
  8017b4:	e8 25 fa ff ff       	call   8011de <strchr>
  8017b9:	83 c4 08             	add    $0x8,%esp
  8017bc:	85 c0                	test   %eax,%eax
  8017be:	74 dc                	je     80179c <strsplit+0x8c>
			string++;
	}
  8017c0:	e9 6e ff ff ff       	jmp    801733 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017c5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c9:	8b 00                	mov    (%eax),%eax
  8017cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d5:	01 d0                	add    %edx,%eax
  8017d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017dd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8017f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017f7:	eb 4a                	jmp    801843 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8017f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	01 c2                	add    %eax,%edx
  801801:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801804:	8b 45 0c             	mov    0xc(%ebp),%eax
  801807:	01 c8                	add    %ecx,%eax
  801809:	8a 00                	mov    (%eax),%al
  80180b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80180d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801810:	8b 45 0c             	mov    0xc(%ebp),%eax
  801813:	01 d0                	add    %edx,%eax
  801815:	8a 00                	mov    (%eax),%al
  801817:	3c 40                	cmp    $0x40,%al
  801819:	7e 25                	jle    801840 <str2lower+0x5c>
  80181b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801821:	01 d0                	add    %edx,%eax
  801823:	8a 00                	mov    (%eax),%al
  801825:	3c 5a                	cmp    $0x5a,%al
  801827:	7f 17                	jg     801840 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801829:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	01 d0                	add    %edx,%eax
  801831:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801834:	8b 55 08             	mov    0x8(%ebp),%edx
  801837:	01 ca                	add    %ecx,%edx
  801839:	8a 12                	mov    (%edx),%dl
  80183b:	83 c2 20             	add    $0x20,%edx
  80183e:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801840:	ff 45 fc             	incl   -0x4(%ebp)
  801843:	ff 75 0c             	pushl  0xc(%ebp)
  801846:	e8 01 f8 ff ff       	call   80104c <strlen>
  80184b:	83 c4 04             	add    $0x4,%esp
  80184e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801851:	7f a6                	jg     8017f9 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801853:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	57                   	push   %edi
  80185c:	56                   	push   %esi
  80185d:	53                   	push   %ebx
  80185e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	8b 55 0c             	mov    0xc(%ebp),%edx
  801867:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80186a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80186d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801870:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801873:	cd 30                	int    $0x30
  801875:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801878:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80187b:	83 c4 10             	add    $0x10,%esp
  80187e:	5b                   	pop    %ebx
  80187f:	5e                   	pop    %esi
  801880:	5f                   	pop    %edi
  801881:	5d                   	pop    %ebp
  801882:	c3                   	ret    

00801883 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 04             	sub    $0x4,%esp
  801889:	8b 45 10             	mov    0x10(%ebp),%eax
  80188c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80188f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801892:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	6a 00                	push   $0x0
  80189b:	51                   	push   %ecx
  80189c:	52                   	push   %edx
  80189d:	ff 75 0c             	pushl  0xc(%ebp)
  8018a0:	50                   	push   %eax
  8018a1:	6a 00                	push   $0x0
  8018a3:	e8 b0 ff ff ff       	call   801858 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
}
  8018ab:	90                   	nop
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_cgetc>:

int
sys_cgetc(void)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 02                	push   $0x2
  8018bd:	e8 96 ff ff ff       	call   801858 <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 03                	push   $0x3
  8018d6:	e8 7d ff ff ff       	call   801858 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	90                   	nop
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 04                	push   $0x4
  8018f0:	e8 63 ff ff ff       	call   801858 <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	90                   	nop
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	52                   	push   %edx
  80190b:	50                   	push   %eax
  80190c:	6a 08                	push   $0x8
  80190e:	e8 45 ff ff ff       	call   801858 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	56                   	push   %esi
  80191c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80191d:	8b 75 18             	mov    0x18(%ebp),%esi
  801920:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801923:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801926:	8b 55 0c             	mov    0xc(%ebp),%edx
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	56                   	push   %esi
  80192d:	53                   	push   %ebx
  80192e:	51                   	push   %ecx
  80192f:	52                   	push   %edx
  801930:	50                   	push   %eax
  801931:	6a 09                	push   $0x9
  801933:	e8 20 ff ff ff       	call   801858 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80193e:	5b                   	pop    %ebx
  80193f:	5e                   	pop    %esi
  801940:	5d                   	pop    %ebp
  801941:	c3                   	ret    

00801942 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	ff 75 08             	pushl  0x8(%ebp)
  801950:	6a 0a                	push   $0xa
  801952:	e8 01 ff ff ff       	call   801858 <syscall>
  801957:	83 c4 18             	add    $0x18,%esp
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	ff 75 0c             	pushl  0xc(%ebp)
  801968:	ff 75 08             	pushl  0x8(%ebp)
  80196b:	6a 0b                	push   $0xb
  80196d:	e8 e6 fe ff ff       	call   801858 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 0c                	push   $0xc
  801986:	e8 cd fe ff ff       	call   801858 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 0d                	push   $0xd
  80199f:	e8 b4 fe ff ff       	call   801858 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 0e                	push   $0xe
  8019b8:	e8 9b fe ff ff       	call   801858 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 0f                	push   $0xf
  8019d1:	e8 82 fe ff ff       	call   801858 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	ff 75 08             	pushl  0x8(%ebp)
  8019e9:	6a 10                	push   $0x10
  8019eb:	e8 68 fe ff ff       	call   801858 <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 11                	push   $0x11
  801a04:	e8 4f fe ff ff       	call   801858 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	90                   	nop
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_cputc>:

void
sys_cputc(const char c)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 04             	sub    $0x4,%esp
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a1b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	50                   	push   %eax
  801a28:	6a 01                	push   $0x1
  801a2a:	e8 29 fe ff ff       	call   801858 <syscall>
  801a2f:	83 c4 18             	add    $0x18,%esp
}
  801a32:	90                   	nop
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 14                	push   $0x14
  801a44:	e8 0f fe ff ff       	call   801858 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	90                   	nop
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	83 ec 04             	sub    $0x4,%esp
  801a55:	8b 45 10             	mov    0x10(%ebp),%eax
  801a58:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a5b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a5e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a62:	8b 45 08             	mov    0x8(%ebp),%eax
  801a65:	6a 00                	push   $0x0
  801a67:	51                   	push   %ecx
  801a68:	52                   	push   %edx
  801a69:	ff 75 0c             	pushl  0xc(%ebp)
  801a6c:	50                   	push   %eax
  801a6d:	6a 15                	push   $0x15
  801a6f:	e8 e4 fd ff ff       	call   801858 <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	52                   	push   %edx
  801a89:	50                   	push   %eax
  801a8a:	6a 16                	push   $0x16
  801a8c:	e8 c7 fd ff ff       	call   801858 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	51                   	push   %ecx
  801aa7:	52                   	push   %edx
  801aa8:	50                   	push   %eax
  801aa9:	6a 17                	push   $0x17
  801aab:	e8 a8 fd ff ff       	call   801858 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	52                   	push   %edx
  801ac5:	50                   	push   %eax
  801ac6:	6a 18                	push   $0x18
  801ac8:	e8 8b fd ff ff       	call   801858 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	ff 75 14             	pushl  0x14(%ebp)
  801add:	ff 75 10             	pushl  0x10(%ebp)
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	50                   	push   %eax
  801ae4:	6a 19                	push   $0x19
  801ae6:	e8 6d fd ff ff       	call   801858 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	50                   	push   %eax
  801aff:	6a 1a                	push   $0x1a
  801b01:	e8 52 fd ff ff       	call   801858 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	90                   	nop
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	50                   	push   %eax
  801b1b:	6a 1b                	push   $0x1b
  801b1d:	e8 36 fd ff ff       	call   801858 <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 05                	push   $0x5
  801b36:	e8 1d fd ff ff       	call   801858 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 06                	push   $0x6
  801b4f:	e8 04 fd ff ff       	call   801858 <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 07                	push   $0x7
  801b68:	e8 eb fc ff ff       	call   801858 <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_exit_env>:


void sys_exit_env(void)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 1c                	push   $0x1c
  801b81:	e8 d2 fc ff ff       	call   801858 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	90                   	nop
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b92:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b95:	8d 50 04             	lea    0x4(%eax),%edx
  801b98:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	52                   	push   %edx
  801ba2:	50                   	push   %eax
  801ba3:	6a 1d                	push   $0x1d
  801ba5:	e8 ae fc ff ff       	call   801858 <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
	return result;
  801bad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bb3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb6:	89 01                	mov    %eax,(%ecx)
  801bb8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	c9                   	leave  
  801bbf:	c2 04 00             	ret    $0x4

00801bc2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	ff 75 10             	pushl  0x10(%ebp)
  801bcc:	ff 75 0c             	pushl  0xc(%ebp)
  801bcf:	ff 75 08             	pushl  0x8(%ebp)
  801bd2:	6a 13                	push   $0x13
  801bd4:	e8 7f fc ff ff       	call   801858 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdc:	90                   	nop
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <sys_rcr2>:
uint32 sys_rcr2()
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 1e                	push   $0x1e
  801bee:	e8 65 fc ff ff       	call   801858 <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	83 ec 04             	sub    $0x4,%esp
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c04:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	50                   	push   %eax
  801c11:	6a 1f                	push   $0x1f
  801c13:	e8 40 fc ff ff       	call   801858 <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1b:	90                   	nop
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <rsttst>:
void rsttst()
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 21                	push   $0x21
  801c2d:	e8 26 fc ff ff       	call   801858 <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
	return ;
  801c35:	90                   	nop
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 04             	sub    $0x4,%esp
  801c3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c41:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c44:	8b 55 18             	mov    0x18(%ebp),%edx
  801c47:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c4b:	52                   	push   %edx
  801c4c:	50                   	push   %eax
  801c4d:	ff 75 10             	pushl  0x10(%ebp)
  801c50:	ff 75 0c             	pushl  0xc(%ebp)
  801c53:	ff 75 08             	pushl  0x8(%ebp)
  801c56:	6a 20                	push   $0x20
  801c58:	e8 fb fb ff ff       	call   801858 <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c60:	90                   	nop
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <chktst>:
void chktst(uint32 n)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	ff 75 08             	pushl  0x8(%ebp)
  801c71:	6a 22                	push   $0x22
  801c73:	e8 e0 fb ff ff       	call   801858 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7b:	90                   	nop
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <inctst>:

void inctst()
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 23                	push   $0x23
  801c8d:	e8 c6 fb ff ff       	call   801858 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
	return ;
  801c95:	90                   	nop
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <gettst>:
uint32 gettst()
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 24                	push   $0x24
  801ca7:	e8 ac fb ff ff       	call   801858 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 25                	push   $0x25
  801cc0:	e8 93 fb ff ff       	call   801858 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
  801cc8:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801ccd:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	ff 75 08             	pushl  0x8(%ebp)
  801cea:	6a 26                	push   $0x26
  801cec:	e8 67 fb ff ff       	call   801858 <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf4:	90                   	nop
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cfb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cfe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	6a 00                	push   $0x0
  801d09:	53                   	push   %ebx
  801d0a:	51                   	push   %ecx
  801d0b:	52                   	push   %edx
  801d0c:	50                   	push   %eax
  801d0d:	6a 27                	push   $0x27
  801d0f:	e8 44 fb ff ff       	call   801858 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	52                   	push   %edx
  801d2c:	50                   	push   %eax
  801d2d:	6a 28                	push   $0x28
  801d2f:	e8 24 fb ff ff       	call   801858 <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d3c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	6a 00                	push   $0x0
  801d47:	51                   	push   %ecx
  801d48:	ff 75 10             	pushl  0x10(%ebp)
  801d4b:	52                   	push   %edx
  801d4c:	50                   	push   %eax
  801d4d:	6a 29                	push   $0x29
  801d4f:	e8 04 fb ff ff       	call   801858 <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	ff 75 10             	pushl  0x10(%ebp)
  801d63:	ff 75 0c             	pushl  0xc(%ebp)
  801d66:	ff 75 08             	pushl  0x8(%ebp)
  801d69:	6a 12                	push   $0x12
  801d6b:	e8 e8 fa ff ff       	call   801858 <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
	return ;
  801d73:	90                   	nop
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	52                   	push   %edx
  801d86:	50                   	push   %eax
  801d87:	6a 2a                	push   $0x2a
  801d89:	e8 ca fa ff ff       	call   801858 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
	return;
  801d91:	90                   	nop
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 2b                	push   $0x2b
  801da3:	e8 b0 fa ff ff       	call   801858 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	ff 75 0c             	pushl  0xc(%ebp)
  801db9:	ff 75 08             	pushl  0x8(%ebp)
  801dbc:	6a 2d                	push   $0x2d
  801dbe:	e8 95 fa ff ff       	call   801858 <syscall>
  801dc3:	83 c4 18             	add    $0x18,%esp
	return;
  801dc6:	90                   	nop
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	ff 75 0c             	pushl  0xc(%ebp)
  801dd5:	ff 75 08             	pushl  0x8(%ebp)
  801dd8:	6a 2c                	push   $0x2c
  801dda:	e8 79 fa ff ff       	call   801858 <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
	return ;
  801de2:	90                   	nop
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801de8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	52                   	push   %edx
  801df5:	50                   	push   %eax
  801df6:	6a 2e                	push   $0x2e
  801df8:	e8 5b fa ff ff       	call   801858 <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
	return ;
  801e00:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801e09:	8b 55 08             	mov    0x8(%ebp),%edx
  801e0c:	89 d0                	mov    %edx,%eax
  801e0e:	c1 e0 02             	shl    $0x2,%eax
  801e11:	01 d0                	add    %edx,%eax
  801e13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e1a:	01 d0                	add    %edx,%eax
  801e1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e23:	01 d0                	add    %edx,%eax
  801e25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e2c:	01 d0                	add    %edx,%eax
  801e2e:	c1 e0 04             	shl    $0x4,%eax
  801e31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801e34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e3b:	0f 31                	rdtsc  
  801e3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e40:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e4c:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e4f:	eb 46                	jmp    801e97 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e51:	0f 31                	rdtsc  
  801e53:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e56:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e59:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e5c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e62:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e65:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6b:	29 c2                	sub    %eax,%edx
  801e6d:	89 d0                	mov    %edx,%eax
  801e6f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e78:	89 d1                	mov    %edx,%ecx
  801e7a:	29 c1                	sub    %eax,%ecx
  801e7c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e82:	39 c2                	cmp    %eax,%edx
  801e84:	0f 97 c0             	seta   %al
  801e87:	0f b6 c0             	movzbl %al,%eax
  801e8a:	29 c1                	sub    %eax,%ecx
  801e8c:	89 c8                	mov    %ecx,%eax
  801e8e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e9a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e9d:	72 b2                	jb     801e51 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e9f:	90                   	nop
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801ea8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801eaf:	eb 03                	jmp    801eb4 <busy_wait+0x12>
  801eb1:	ff 45 fc             	incl   -0x4(%ebp)
  801eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eb7:	3b 45 08             	cmp    0x8(%ebp),%eax
  801eba:	72 f5                	jb     801eb1 <busy_wait+0xf>
	return i;
  801ebc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801ecd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801ed1:	83 ec 0c             	sub    $0xc,%esp
  801ed4:	50                   	push   %eax
  801ed5:	e8 35 fb ff ff       	call   801a0f <sys_cputc>
  801eda:	83 c4 10             	add    $0x10,%esp
}
  801edd:	90                   	nop
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <getchar>:


int
getchar(void)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801ee6:	e8 c3 f9 ff ff       	call   8018ae <sys_cgetc>
  801eeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <iscons>:

int iscons(int fdnum)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801ef6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801efb:	5d                   	pop    %ebp
  801efc:	c3                   	ret    
  801efd:	66 90                	xchg   %ax,%ax
  801eff:	90                   	nop

00801f00 <__udivdi3>:
  801f00:	55                   	push   %ebp
  801f01:	57                   	push   %edi
  801f02:	56                   	push   %esi
  801f03:	53                   	push   %ebx
  801f04:	83 ec 1c             	sub    $0x1c,%esp
  801f07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f17:	89 ca                	mov    %ecx,%edx
  801f19:	89 f8                	mov    %edi,%eax
  801f1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f1f:	85 f6                	test   %esi,%esi
  801f21:	75 2d                	jne    801f50 <__udivdi3+0x50>
  801f23:	39 cf                	cmp    %ecx,%edi
  801f25:	77 65                	ja     801f8c <__udivdi3+0x8c>
  801f27:	89 fd                	mov    %edi,%ebp
  801f29:	85 ff                	test   %edi,%edi
  801f2b:	75 0b                	jne    801f38 <__udivdi3+0x38>
  801f2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f32:	31 d2                	xor    %edx,%edx
  801f34:	f7 f7                	div    %edi
  801f36:	89 c5                	mov    %eax,%ebp
  801f38:	31 d2                	xor    %edx,%edx
  801f3a:	89 c8                	mov    %ecx,%eax
  801f3c:	f7 f5                	div    %ebp
  801f3e:	89 c1                	mov    %eax,%ecx
  801f40:	89 d8                	mov    %ebx,%eax
  801f42:	f7 f5                	div    %ebp
  801f44:	89 cf                	mov    %ecx,%edi
  801f46:	89 fa                	mov    %edi,%edx
  801f48:	83 c4 1c             	add    $0x1c,%esp
  801f4b:	5b                   	pop    %ebx
  801f4c:	5e                   	pop    %esi
  801f4d:	5f                   	pop    %edi
  801f4e:	5d                   	pop    %ebp
  801f4f:	c3                   	ret    
  801f50:	39 ce                	cmp    %ecx,%esi
  801f52:	77 28                	ja     801f7c <__udivdi3+0x7c>
  801f54:	0f bd fe             	bsr    %esi,%edi
  801f57:	83 f7 1f             	xor    $0x1f,%edi
  801f5a:	75 40                	jne    801f9c <__udivdi3+0x9c>
  801f5c:	39 ce                	cmp    %ecx,%esi
  801f5e:	72 0a                	jb     801f6a <__udivdi3+0x6a>
  801f60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f64:	0f 87 9e 00 00 00    	ja     802008 <__udivdi3+0x108>
  801f6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6f:	89 fa                	mov    %edi,%edx
  801f71:	83 c4 1c             	add    $0x1c,%esp
  801f74:	5b                   	pop    %ebx
  801f75:	5e                   	pop    %esi
  801f76:	5f                   	pop    %edi
  801f77:	5d                   	pop    %ebp
  801f78:	c3                   	ret    
  801f79:	8d 76 00             	lea    0x0(%esi),%esi
  801f7c:	31 ff                	xor    %edi,%edi
  801f7e:	31 c0                	xor    %eax,%eax
  801f80:	89 fa                	mov    %edi,%edx
  801f82:	83 c4 1c             	add    $0x1c,%esp
  801f85:	5b                   	pop    %ebx
  801f86:	5e                   	pop    %esi
  801f87:	5f                   	pop    %edi
  801f88:	5d                   	pop    %ebp
  801f89:	c3                   	ret    
  801f8a:	66 90                	xchg   %ax,%ax
  801f8c:	89 d8                	mov    %ebx,%eax
  801f8e:	f7 f7                	div    %edi
  801f90:	31 ff                	xor    %edi,%edi
  801f92:	89 fa                	mov    %edi,%edx
  801f94:	83 c4 1c             	add    $0x1c,%esp
  801f97:	5b                   	pop    %ebx
  801f98:	5e                   	pop    %esi
  801f99:	5f                   	pop    %edi
  801f9a:	5d                   	pop    %ebp
  801f9b:	c3                   	ret    
  801f9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801fa1:	89 eb                	mov    %ebp,%ebx
  801fa3:	29 fb                	sub    %edi,%ebx
  801fa5:	89 f9                	mov    %edi,%ecx
  801fa7:	d3 e6                	shl    %cl,%esi
  801fa9:	89 c5                	mov    %eax,%ebp
  801fab:	88 d9                	mov    %bl,%cl
  801fad:	d3 ed                	shr    %cl,%ebp
  801faf:	89 e9                	mov    %ebp,%ecx
  801fb1:	09 f1                	or     %esi,%ecx
  801fb3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801fb7:	89 f9                	mov    %edi,%ecx
  801fb9:	d3 e0                	shl    %cl,%eax
  801fbb:	89 c5                	mov    %eax,%ebp
  801fbd:	89 d6                	mov    %edx,%esi
  801fbf:	88 d9                	mov    %bl,%cl
  801fc1:	d3 ee                	shr    %cl,%esi
  801fc3:	89 f9                	mov    %edi,%ecx
  801fc5:	d3 e2                	shl    %cl,%edx
  801fc7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fcb:	88 d9                	mov    %bl,%cl
  801fcd:	d3 e8                	shr    %cl,%eax
  801fcf:	09 c2                	or     %eax,%edx
  801fd1:	89 d0                	mov    %edx,%eax
  801fd3:	89 f2                	mov    %esi,%edx
  801fd5:	f7 74 24 0c          	divl   0xc(%esp)
  801fd9:	89 d6                	mov    %edx,%esi
  801fdb:	89 c3                	mov    %eax,%ebx
  801fdd:	f7 e5                	mul    %ebp
  801fdf:	39 d6                	cmp    %edx,%esi
  801fe1:	72 19                	jb     801ffc <__udivdi3+0xfc>
  801fe3:	74 0b                	je     801ff0 <__udivdi3+0xf0>
  801fe5:	89 d8                	mov    %ebx,%eax
  801fe7:	31 ff                	xor    %edi,%edi
  801fe9:	e9 58 ff ff ff       	jmp    801f46 <__udivdi3+0x46>
  801fee:	66 90                	xchg   %ax,%ax
  801ff0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ff4:	89 f9                	mov    %edi,%ecx
  801ff6:	d3 e2                	shl    %cl,%edx
  801ff8:	39 c2                	cmp    %eax,%edx
  801ffa:	73 e9                	jae    801fe5 <__udivdi3+0xe5>
  801ffc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fff:	31 ff                	xor    %edi,%edi
  802001:	e9 40 ff ff ff       	jmp    801f46 <__udivdi3+0x46>
  802006:	66 90                	xchg   %ax,%ax
  802008:	31 c0                	xor    %eax,%eax
  80200a:	e9 37 ff ff ff       	jmp    801f46 <__udivdi3+0x46>
  80200f:	90                   	nop

00802010 <__umoddi3>:
  802010:	55                   	push   %ebp
  802011:	57                   	push   %edi
  802012:	56                   	push   %esi
  802013:	53                   	push   %ebx
  802014:	83 ec 1c             	sub    $0x1c,%esp
  802017:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80201b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80201f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802023:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802027:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80202b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80202f:	89 f3                	mov    %esi,%ebx
  802031:	89 fa                	mov    %edi,%edx
  802033:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802037:	89 34 24             	mov    %esi,(%esp)
  80203a:	85 c0                	test   %eax,%eax
  80203c:	75 1a                	jne    802058 <__umoddi3+0x48>
  80203e:	39 f7                	cmp    %esi,%edi
  802040:	0f 86 a2 00 00 00    	jbe    8020e8 <__umoddi3+0xd8>
  802046:	89 c8                	mov    %ecx,%eax
  802048:	89 f2                	mov    %esi,%edx
  80204a:	f7 f7                	div    %edi
  80204c:	89 d0                	mov    %edx,%eax
  80204e:	31 d2                	xor    %edx,%edx
  802050:	83 c4 1c             	add    $0x1c,%esp
  802053:	5b                   	pop    %ebx
  802054:	5e                   	pop    %esi
  802055:	5f                   	pop    %edi
  802056:	5d                   	pop    %ebp
  802057:	c3                   	ret    
  802058:	39 f0                	cmp    %esi,%eax
  80205a:	0f 87 ac 00 00 00    	ja     80210c <__umoddi3+0xfc>
  802060:	0f bd e8             	bsr    %eax,%ebp
  802063:	83 f5 1f             	xor    $0x1f,%ebp
  802066:	0f 84 ac 00 00 00    	je     802118 <__umoddi3+0x108>
  80206c:	bf 20 00 00 00       	mov    $0x20,%edi
  802071:	29 ef                	sub    %ebp,%edi
  802073:	89 fe                	mov    %edi,%esi
  802075:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802079:	89 e9                	mov    %ebp,%ecx
  80207b:	d3 e0                	shl    %cl,%eax
  80207d:	89 d7                	mov    %edx,%edi
  80207f:	89 f1                	mov    %esi,%ecx
  802081:	d3 ef                	shr    %cl,%edi
  802083:	09 c7                	or     %eax,%edi
  802085:	89 e9                	mov    %ebp,%ecx
  802087:	d3 e2                	shl    %cl,%edx
  802089:	89 14 24             	mov    %edx,(%esp)
  80208c:	89 d8                	mov    %ebx,%eax
  80208e:	d3 e0                	shl    %cl,%eax
  802090:	89 c2                	mov    %eax,%edx
  802092:	8b 44 24 08          	mov    0x8(%esp),%eax
  802096:	d3 e0                	shl    %cl,%eax
  802098:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020a0:	89 f1                	mov    %esi,%ecx
  8020a2:	d3 e8                	shr    %cl,%eax
  8020a4:	09 d0                	or     %edx,%eax
  8020a6:	d3 eb                	shr    %cl,%ebx
  8020a8:	89 da                	mov    %ebx,%edx
  8020aa:	f7 f7                	div    %edi
  8020ac:	89 d3                	mov    %edx,%ebx
  8020ae:	f7 24 24             	mull   (%esp)
  8020b1:	89 c6                	mov    %eax,%esi
  8020b3:	89 d1                	mov    %edx,%ecx
  8020b5:	39 d3                	cmp    %edx,%ebx
  8020b7:	0f 82 87 00 00 00    	jb     802144 <__umoddi3+0x134>
  8020bd:	0f 84 91 00 00 00    	je     802154 <__umoddi3+0x144>
  8020c3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020c7:	29 f2                	sub    %esi,%edx
  8020c9:	19 cb                	sbb    %ecx,%ebx
  8020cb:	89 d8                	mov    %ebx,%eax
  8020cd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020d1:	d3 e0                	shl    %cl,%eax
  8020d3:	89 e9                	mov    %ebp,%ecx
  8020d5:	d3 ea                	shr    %cl,%edx
  8020d7:	09 d0                	or     %edx,%eax
  8020d9:	89 e9                	mov    %ebp,%ecx
  8020db:	d3 eb                	shr    %cl,%ebx
  8020dd:	89 da                	mov    %ebx,%edx
  8020df:	83 c4 1c             	add    $0x1c,%esp
  8020e2:	5b                   	pop    %ebx
  8020e3:	5e                   	pop    %esi
  8020e4:	5f                   	pop    %edi
  8020e5:	5d                   	pop    %ebp
  8020e6:	c3                   	ret    
  8020e7:	90                   	nop
  8020e8:	89 fd                	mov    %edi,%ebp
  8020ea:	85 ff                	test   %edi,%edi
  8020ec:	75 0b                	jne    8020f9 <__umoddi3+0xe9>
  8020ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f3:	31 d2                	xor    %edx,%edx
  8020f5:	f7 f7                	div    %edi
  8020f7:	89 c5                	mov    %eax,%ebp
  8020f9:	89 f0                	mov    %esi,%eax
  8020fb:	31 d2                	xor    %edx,%edx
  8020fd:	f7 f5                	div    %ebp
  8020ff:	89 c8                	mov    %ecx,%eax
  802101:	f7 f5                	div    %ebp
  802103:	89 d0                	mov    %edx,%eax
  802105:	e9 44 ff ff ff       	jmp    80204e <__umoddi3+0x3e>
  80210a:	66 90                	xchg   %ax,%ax
  80210c:	89 c8                	mov    %ecx,%eax
  80210e:	89 f2                	mov    %esi,%edx
  802110:	83 c4 1c             	add    $0x1c,%esp
  802113:	5b                   	pop    %ebx
  802114:	5e                   	pop    %esi
  802115:	5f                   	pop    %edi
  802116:	5d                   	pop    %ebp
  802117:	c3                   	ret    
  802118:	3b 04 24             	cmp    (%esp),%eax
  80211b:	72 06                	jb     802123 <__umoddi3+0x113>
  80211d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802121:	77 0f                	ja     802132 <__umoddi3+0x122>
  802123:	89 f2                	mov    %esi,%edx
  802125:	29 f9                	sub    %edi,%ecx
  802127:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80212b:	89 14 24             	mov    %edx,(%esp)
  80212e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802132:	8b 44 24 04          	mov    0x4(%esp),%eax
  802136:	8b 14 24             	mov    (%esp),%edx
  802139:	83 c4 1c             	add    $0x1c,%esp
  80213c:	5b                   	pop    %ebx
  80213d:	5e                   	pop    %esi
  80213e:	5f                   	pop    %edi
  80213f:	5d                   	pop    %ebp
  802140:	c3                   	ret    
  802141:	8d 76 00             	lea    0x0(%esi),%esi
  802144:	2b 04 24             	sub    (%esp),%eax
  802147:	19 fa                	sbb    %edi,%edx
  802149:	89 d1                	mov    %edx,%ecx
  80214b:	89 c6                	mov    %eax,%esi
  80214d:	e9 71 ff ff ff       	jmp    8020c3 <__umoddi3+0xb3>
  802152:	66 90                	xchg   %ax,%ax
  802154:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802158:	72 ea                	jb     802144 <__umoddi3+0x134>
  80215a:	89 d9                	mov    %ebx,%ecx
  80215c:	e9 62 ff ff ff       	jmp    8020c3 <__umoddi3+0xb3>
