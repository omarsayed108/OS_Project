
obj/user/tst_sleeplock_slave:     file format elf32-i386


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
  800031:	e8 46 02 00 00       	call   80027c <libmain>
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
  80003e:	81 ec 6c 01 00 00    	sub    $0x16c,%esp
	int envID = sys_getenvid();
  800044:	e8 85 18 00 00       	call   8018ce <sys_getenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Acquire the lock
	char cmd1[64] = "__AcquireSleepLock__";
  80004c:	8d 45 98             	lea    -0x68(%ebp),%eax
  80004f:	bb d0 1f 80 00       	mov    $0x801fd0,%ebx
  800054:	ba 15 00 00 00       	mov    $0x15,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800061:	8d 55 ad             	lea    -0x53(%ebp),%edx
  800064:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  800069:	b0 00                	mov    $0x0,%al
  80006b:	89 d7                	mov    %edx,%edi
  80006d:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd1, 0);
  80006f:	83 ec 08             	sub    $0x8,%esp
  800072:	6a 00                	push   $0x0
  800074:	8d 45 98             	lea    -0x68(%ebp),%eax
  800077:	50                   	push   %eax
  800078:	e8 a0 1a 00 00       	call   801b1d <sys_utilities>
  80007d:	83 c4 10             	add    $0x10,%esp
	{
		if (gettst() > 1)
  800080:	e8 ba 19 00 00       	call   801a3f <gettst>
  800085:	83 f8 01             	cmp    $0x1,%eax
  800088:	76 33                	jbe    8000bd <_main+0x85>
		{
			//Other slaves: wait for a while
			env_sleep(RAND(5000, 10000));
  80008a:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	50                   	push   %eax
  800091:	e8 9d 18 00 00       	call   801933 <sys_get_virtual_time>
  800096:	83 c4 0c             	add    $0xc,%esp
  800099:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80009c:	b9 88 13 00 00       	mov    $0x1388,%ecx
  8000a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a6:	f7 f1                	div    %ecx
  8000a8:	89 d0                	mov    %edx,%eax
  8000aa:	05 88 13 00 00       	add    $0x1388,%eax
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	50                   	push   %eax
  8000b3:	e8 f2 1a 00 00       	call   801baa <env_sleep>
  8000b8:	83 c4 10             	add    $0x10,%esp
  8000bb:	eb 0b                	jmp    8000c8 <_main+0x90>
		}
		else
		{
			//this is the first slave inside C.S.! so wait until receiving signal from master
			while (gettst() != 1);
  8000bd:	90                   	nop
  8000be:	e8 7c 19 00 00       	call   801a3f <gettst>
  8000c3:	83 f8 01             	cmp    $0x1,%eax
  8000c6:	75 f6                	jne    8000be <_main+0x86>
		}

		//Check lock value inside C.S.
		int lockVal = 0;
  8000c8:	c7 85 54 ff ff ff 00 	movl   $0x0,-0xac(%ebp)
  8000cf:	00 00 00 
		char cmd2[64] = "__GetLockValue__";
  8000d2:	8d 85 8c fe ff ff    	lea    -0x174(%ebp),%eax
  8000d8:	bb 10 20 80 00       	mov    $0x802010,%ebx
  8000dd:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e2:	89 c7                	mov    %eax,%edi
  8000e4:	89 de                	mov    %ebx,%esi
  8000e6:	89 d1                	mov    %edx,%ecx
  8000e8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000ea:	8d 95 9d fe ff ff    	lea    -0x163(%ebp),%edx
  8000f0:	b9 2f 00 00 00       	mov    $0x2f,%ecx
  8000f5:	b0 00                	mov    $0x0,%al
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(cmd2, (int)(&lockVal));
  8000fb:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800101:	83 ec 08             	sub    $0x8,%esp
  800104:	50                   	push   %eax
  800105:	8d 85 8c fe ff ff    	lea    -0x174(%ebp),%eax
  80010b:	50                   	push   %eax
  80010c:	e8 0c 1a 00 00       	call   801b1d <sys_utilities>
  800111:	83 c4 10             	add    $0x10,%esp
		if (lockVal != 1)
  800114:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  80011a:	83 f8 01             	cmp    $0x1,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
		{
			panic("%~test sleeplock failed! lock is not held while it's expected to be");
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 e0 1e 80 00       	push   $0x801ee0
  800127:	6a 20                	push   $0x20
  800129:	68 24 1f 80 00       	push   $0x801f24
  80012e:	e8 f9 02 00 00       	call   80042c <_panic>
		}

		//Validate the number of blocked processes till now
		int numOfBlockedProcesses = 0;
  800133:	c7 85 50 ff ff ff 00 	movl   $0x0,-0xb0(%ebp)
  80013a:	00 00 00 
		char cmd3[64] = "__GetLockQueueSize__";
  80013d:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800143:	bb 50 20 80 00       	mov    $0x802050,%ebx
  800148:	ba 15 00 00 00       	mov    $0x15,%edx
  80014d:	89 c7                	mov    %eax,%edi
  80014f:	89 de                	mov    %ebx,%esi
  800151:	89 d1                	mov    %edx,%ecx
  800153:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800155:	8d 95 e1 fe ff ff    	lea    -0x11f(%ebp),%edx
  80015b:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  800160:	b0 00                	mov    $0x0,%al
  800162:	89 d7                	mov    %edx,%edi
  800164:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(cmd3, (uint32)(&numOfBlockedProcesses));
  800166:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	50                   	push   %eax
  800170:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800176:	50                   	push   %eax
  800177:	e8 a1 19 00 00       	call   801b1d <sys_utilities>
  80017c:	83 c4 10             	add    $0x10,%esp
		int numOfFinishedProcesses = gettst() -1 /*since master already incremented it by 1*/;
  80017f:	e8 bb 18 00 00       	call   801a3f <gettst>
  800184:	48                   	dec    %eax
  800185:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int numOfSlaves = 0;
  800188:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%ebp)
  80018f:	00 00 00 
		char cmd4[64] = "__NumOfSlaves@Get";
  800192:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
  800198:	bb 90 20 80 00       	mov    $0x802090,%ebx
  80019d:	ba 12 00 00 00       	mov    $0x12,%edx
  8001a2:	89 c7                	mov    %eax,%edi
  8001a4:	89 de                	mov    %ebx,%esi
  8001a6:	89 d1                	mov    %edx,%ecx
  8001a8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001aa:	8d 95 1e ff ff ff    	lea    -0xe2(%ebp),%edx
  8001b0:	b9 2e 00 00 00       	mov    $0x2e,%ecx
  8001b5:	b0 00                	mov    $0x0,%al
  8001b7:	89 d7                	mov    %edx,%edi
  8001b9:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(cmd4, (uint32)(&numOfSlaves));
  8001bb:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	50                   	push   %eax
  8001c5:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
  8001cb:	50                   	push   %eax
  8001cc:	e8 4c 19 00 00       	call   801b1d <sys_utilities>
  8001d1:	83 c4 10             	add    $0x10,%esp

		if (numOfFinishedProcesses + numOfBlockedProcesses != numOfSlaves - 1)
  8001d4:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  8001da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001dd:	01 c2                	add    %eax,%edx
  8001df:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8001e5:	48                   	dec    %eax
  8001e6:	39 c2                	cmp    %eax,%edx
  8001e8:	74 28                	je     800212 <_main+0x1da>
		{
			panic("%~test SleepLock failed! inconsistent number of blocked & waken-up processes. #wakenup %d + #blocked %d != #slaves %d", numOfFinishedProcesses, numOfBlockedProcesses, numOfSlaves-1);
  8001ea:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8001f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8001f3:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8001f9:	83 ec 08             	sub    $0x8,%esp
  8001fc:	52                   	push   %edx
  8001fd:	50                   	push   %eax
  8001fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800201:	68 40 1f 80 00       	push   $0x801f40
  800206:	6a 2e                	push   $0x2e
  800208:	68 24 1f 80 00       	push   $0x801f24
  80020d:	e8 1a 02 00 00       	call   80042c <_panic>
		}

		//indicates finishing
		inctst();
  800212:	e8 0e 18 00 00       	call   801a25 <inctst>
	}
	//Release the lock
	char cmd5[64] = "__ReleaseSleepLock__";
  800217:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  80021d:	bb d0 20 80 00       	mov    $0x8020d0,%ebx
  800222:	ba 15 00 00 00       	mov    $0x15,%edx
  800227:	89 c7                	mov    %eax,%edi
  800229:	89 de                	mov    %ebx,%esi
  80022b:	89 d1                	mov    %edx,%ecx
  80022d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80022f:	8d 95 6d ff ff ff    	lea    -0x93(%ebp),%edx
  800235:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  80023a:	b0 00                	mov    $0x0,%al
  80023c:	89 d7                	mov    %edx,%edi
  80023e:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd5, 0);
  800240:	83 ec 08             	sub    $0x8,%esp
  800243:	6a 00                	push   $0x0
  800245:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	e8 cc 18 00 00       	call   801b1d <sys_utilities>
  800251:	83 c4 10             	add    $0x10,%esp

	cprintf_colored(TEXT_light_magenta, ">>> Slave %d is Finished\n", envID);
  800254:	83 ec 04             	sub    $0x4,%esp
  800257:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025a:	68 b6 1f 80 00       	push   $0x801fb6
  80025f:	6a 0d                	push   $0xd
  800261:	e8 e1 04 00 00       	call   800747 <cprintf_colored>
  800266:	83 c4 10             	add    $0x10,%esp
	printStats = 0;
  800269:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800270:	00 00 00 

	return;
  800273:	90                   	nop
}
  800274:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800277:	5b                   	pop    %ebx
  800278:	5e                   	pop    %esi
  800279:	5f                   	pop    %edi
  80027a:	5d                   	pop    %ebp
  80027b:	c3                   	ret    

0080027c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	57                   	push   %edi
  800280:	56                   	push   %esi
  800281:	53                   	push   %ebx
  800282:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800285:	e8 5d 16 00 00       	call   8018e7 <sys_getenvindex>
  80028a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80028d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800290:	89 d0                	mov    %edx,%eax
  800292:	01 c0                	add    %eax,%eax
  800294:	01 d0                	add    %edx,%eax
  800296:	c1 e0 02             	shl    $0x2,%eax
  800299:	01 d0                	add    %edx,%eax
  80029b:	c1 e0 02             	shl    $0x2,%eax
  80029e:	01 d0                	add    %edx,%eax
  8002a0:	c1 e0 03             	shl    $0x3,%eax
  8002a3:	01 d0                	add    %edx,%eax
  8002a5:	c1 e0 02             	shl    $0x2,%eax
  8002a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002ad:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b7:	8a 40 20             	mov    0x20(%eax),%al
  8002ba:	84 c0                	test   %al,%al
  8002bc:	74 0d                	je     8002cb <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002be:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c3:	83 c0 20             	add    $0x20,%eax
  8002c6:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002cf:	7e 0a                	jle    8002db <libmain+0x5f>
		binaryname = argv[0];
  8002d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d4:	8b 00                	mov    (%eax),%eax
  8002d6:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	ff 75 0c             	pushl  0xc(%ebp)
  8002e1:	ff 75 08             	pushl  0x8(%ebp)
  8002e4:	e8 4f fd ff ff       	call   800038 <_main>
  8002e9:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002ec:	a1 00 30 80 00       	mov    0x803000,%eax
  8002f1:	85 c0                	test   %eax,%eax
  8002f3:	0f 84 01 01 00 00    	je     8003fa <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002f9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002ff:	bb 08 22 80 00       	mov    $0x802208,%ebx
  800304:	ba 0e 00 00 00       	mov    $0xe,%edx
  800309:	89 c7                	mov    %eax,%edi
  80030b:	89 de                	mov    %ebx,%esi
  80030d:	89 d1                	mov    %edx,%ecx
  80030f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800311:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800314:	b9 56 00 00 00       	mov    $0x56,%ecx
  800319:	b0 00                	mov    $0x0,%al
  80031b:	89 d7                	mov    %edx,%edi
  80031d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80031f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800326:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800329:	83 ec 08             	sub    $0x8,%esp
  80032c:	50                   	push   %eax
  80032d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800333:	50                   	push   %eax
  800334:	e8 e4 17 00 00       	call   801b1d <sys_utilities>
  800339:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80033c:	e8 2d 13 00 00       	call   80166e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800341:	83 ec 0c             	sub    $0xc,%esp
  800344:	68 28 21 80 00       	push   $0x802128
  800349:	e8 cc 03 00 00       	call   80071a <cprintf>
  80034e:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800351:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800354:	85 c0                	test   %eax,%eax
  800356:	74 18                	je     800370 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800358:	e8 de 17 00 00       	call   801b3b <sys_get_optimal_num_faults>
  80035d:	83 ec 08             	sub    $0x8,%esp
  800360:	50                   	push   %eax
  800361:	68 50 21 80 00       	push   $0x802150
  800366:	e8 af 03 00 00       	call   80071a <cprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
  80036e:	eb 59                	jmp    8003c9 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800370:	a1 20 30 80 00       	mov    0x803020,%eax
  800375:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80037b:	a1 20 30 80 00       	mov    0x803020,%eax
  800380:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	52                   	push   %edx
  80038a:	50                   	push   %eax
  80038b:	68 74 21 80 00       	push   $0x802174
  800390:	e8 85 03 00 00       	call   80071a <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800398:	a1 20 30 80 00       	mov    0x803020,%eax
  80039d:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8003a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a8:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8003ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b3:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8003b9:	51                   	push   %ecx
  8003ba:	52                   	push   %edx
  8003bb:	50                   	push   %eax
  8003bc:	68 9c 21 80 00       	push   $0x80219c
  8003c1:	e8 54 03 00 00       	call   80071a <cprintf>
  8003c6:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003c9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ce:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8003d4:	83 ec 08             	sub    $0x8,%esp
  8003d7:	50                   	push   %eax
  8003d8:	68 f4 21 80 00       	push   $0x8021f4
  8003dd:	e8 38 03 00 00       	call   80071a <cprintf>
  8003e2:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003e5:	83 ec 0c             	sub    $0xc,%esp
  8003e8:	68 28 21 80 00       	push   $0x802128
  8003ed:	e8 28 03 00 00       	call   80071a <cprintf>
  8003f2:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003f5:	e8 8e 12 00 00       	call   801688 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003fa:	e8 1f 00 00 00       	call   80041e <exit>
}
  8003ff:	90                   	nop
  800400:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800403:	5b                   	pop    %ebx
  800404:	5e                   	pop    %esi
  800405:	5f                   	pop    %edi
  800406:	5d                   	pop    %ebp
  800407:	c3                   	ret    

00800408 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80040e:	83 ec 0c             	sub    $0xc,%esp
  800411:	6a 00                	push   $0x0
  800413:	e8 9b 14 00 00       	call   8018b3 <sys_destroy_env>
  800418:	83 c4 10             	add    $0x10,%esp
}
  80041b:	90                   	nop
  80041c:	c9                   	leave  
  80041d:	c3                   	ret    

0080041e <exit>:

void
exit(void)
{
  80041e:	55                   	push   %ebp
  80041f:	89 e5                	mov    %esp,%ebp
  800421:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800424:	e8 f0 14 00 00       	call   801919 <sys_exit_env>
}
  800429:	90                   	nop
  80042a:	c9                   	leave  
  80042b:	c3                   	ret    

0080042c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800432:	8d 45 10             	lea    0x10(%ebp),%eax
  800435:	83 c0 04             	add    $0x4,%eax
  800438:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80043b:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800440:	85 c0                	test   %eax,%eax
  800442:	74 16                	je     80045a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800444:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	50                   	push   %eax
  80044d:	68 6c 22 80 00       	push   $0x80226c
  800452:	e8 c3 02 00 00       	call   80071a <cprintf>
  800457:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80045a:	a1 04 30 80 00       	mov    0x803004,%eax
  80045f:	83 ec 0c             	sub    $0xc,%esp
  800462:	ff 75 0c             	pushl  0xc(%ebp)
  800465:	ff 75 08             	pushl  0x8(%ebp)
  800468:	50                   	push   %eax
  800469:	68 74 22 80 00       	push   $0x802274
  80046e:	6a 74                	push   $0x74
  800470:	e8 d2 02 00 00       	call   800747 <cprintf_colored>
  800475:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800478:	8b 45 10             	mov    0x10(%ebp),%eax
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	ff 75 f4             	pushl  -0xc(%ebp)
  800481:	50                   	push   %eax
  800482:	e8 24 02 00 00       	call   8006ab <vcprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80048a:	83 ec 08             	sub    $0x8,%esp
  80048d:	6a 00                	push   $0x0
  80048f:	68 9c 22 80 00       	push   $0x80229c
  800494:	e8 12 02 00 00       	call   8006ab <vcprintf>
  800499:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80049c:	e8 7d ff ff ff       	call   80041e <exit>

	// should not return here
	while (1) ;
  8004a1:	eb fe                	jmp    8004a1 <_panic+0x75>

008004a3 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	53                   	push   %ebx
  8004a7:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8004af:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b8:	39 c2                	cmp    %eax,%edx
  8004ba:	74 14                	je     8004d0 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004bc:	83 ec 04             	sub    $0x4,%esp
  8004bf:	68 a0 22 80 00       	push   $0x8022a0
  8004c4:	6a 26                	push   $0x26
  8004c6:	68 ec 22 80 00       	push   $0x8022ec
  8004cb:	e8 5c ff ff ff       	call   80042c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004de:	e9 d9 00 00 00       	jmp    8005bc <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8004e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	01 d0                	add    %edx,%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	85 c0                	test   %eax,%eax
  8004f6:	75 08                	jne    800500 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8004f8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004fb:	e9 b9 00 00 00       	jmp    8005b9 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800500:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800507:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80050e:	eb 79                	jmp    800589 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800510:	a1 20 30 80 00       	mov    0x803020,%eax
  800515:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80051b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80051e:	89 d0                	mov    %edx,%eax
  800520:	01 c0                	add    %eax,%eax
  800522:	01 d0                	add    %edx,%eax
  800524:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80052b:	01 d8                	add    %ebx,%eax
  80052d:	01 d0                	add    %edx,%eax
  80052f:	01 c8                	add    %ecx,%eax
  800531:	8a 40 04             	mov    0x4(%eax),%al
  800534:	84 c0                	test   %al,%al
  800536:	75 4e                	jne    800586 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800538:	a1 20 30 80 00       	mov    0x803020,%eax
  80053d:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800543:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800546:	89 d0                	mov    %edx,%eax
  800548:	01 c0                	add    %eax,%eax
  80054a:	01 d0                	add    %edx,%eax
  80054c:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800553:	01 d8                	add    %ebx,%eax
  800555:	01 d0                	add    %edx,%eax
  800557:	01 c8                	add    %ecx,%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80055e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800561:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800566:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800572:	8b 45 08             	mov    0x8(%ebp),%eax
  800575:	01 c8                	add    %ecx,%eax
  800577:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	75 09                	jne    800586 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  80057d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800584:	eb 19                	jmp    80059f <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800586:	ff 45 e8             	incl   -0x18(%ebp)
  800589:	a1 20 30 80 00       	mov    0x803020,%eax
  80058e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800594:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800597:	39 c2                	cmp    %eax,%edx
  800599:	0f 87 71 ff ff ff    	ja     800510 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80059f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005a3:	75 14                	jne    8005b9 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8005a5:	83 ec 04             	sub    $0x4,%esp
  8005a8:	68 f8 22 80 00       	push   $0x8022f8
  8005ad:	6a 3a                	push   $0x3a
  8005af:	68 ec 22 80 00       	push   $0x8022ec
  8005b4:	e8 73 fe ff ff       	call   80042c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005b9:	ff 45 f0             	incl   -0x10(%ebp)
  8005bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005c2:	0f 8c 1b ff ff ff    	jl     8004e3 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005d6:	eb 2e                	jmp    800606 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8005dd:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8005e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e6:	89 d0                	mov    %edx,%eax
  8005e8:	01 c0                	add    %eax,%eax
  8005ea:	01 d0                	add    %edx,%eax
  8005ec:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8005f3:	01 d8                	add    %ebx,%eax
  8005f5:	01 d0                	add    %edx,%eax
  8005f7:	01 c8                	add    %ecx,%eax
  8005f9:	8a 40 04             	mov    0x4(%eax),%al
  8005fc:	3c 01                	cmp    $0x1,%al
  8005fe:	75 03                	jne    800603 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800600:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800603:	ff 45 e0             	incl   -0x20(%ebp)
  800606:	a1 20 30 80 00       	mov    0x803020,%eax
  80060b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800611:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800614:	39 c2                	cmp    %eax,%edx
  800616:	77 c0                	ja     8005d8 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80061b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80061e:	74 14                	je     800634 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800620:	83 ec 04             	sub    $0x4,%esp
  800623:	68 4c 23 80 00       	push   $0x80234c
  800628:	6a 44                	push   $0x44
  80062a:	68 ec 22 80 00       	push   $0x8022ec
  80062f:	e8 f8 fd ff ff       	call   80042c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800634:	90                   	nop
  800635:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800638:	c9                   	leave  
  800639:	c3                   	ret    

0080063a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
  80063d:	53                   	push   %ebx
  80063e:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800641:	8b 45 0c             	mov    0xc(%ebp),%eax
  800644:	8b 00                	mov    (%eax),%eax
  800646:	8d 48 01             	lea    0x1(%eax),%ecx
  800649:	8b 55 0c             	mov    0xc(%ebp),%edx
  80064c:	89 0a                	mov    %ecx,(%edx)
  80064e:	8b 55 08             	mov    0x8(%ebp),%edx
  800651:	88 d1                	mov    %dl,%cl
  800653:	8b 55 0c             	mov    0xc(%ebp),%edx
  800656:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80065a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065d:	8b 00                	mov    (%eax),%eax
  80065f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800664:	75 30                	jne    800696 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800666:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80066c:	a0 44 30 80 00       	mov    0x803044,%al
  800671:	0f b6 c0             	movzbl %al,%eax
  800674:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800677:	8b 09                	mov    (%ecx),%ecx
  800679:	89 cb                	mov    %ecx,%ebx
  80067b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80067e:	83 c1 08             	add    $0x8,%ecx
  800681:	52                   	push   %edx
  800682:	50                   	push   %eax
  800683:	53                   	push   %ebx
  800684:	51                   	push   %ecx
  800685:	e8 a0 0f 00 00       	call   80162a <sys_cputs>
  80068a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80068d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800690:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800696:	8b 45 0c             	mov    0xc(%ebp),%eax
  800699:	8b 40 04             	mov    0x4(%eax),%eax
  80069c:	8d 50 01             	lea    0x1(%eax),%edx
  80069f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006a5:	90                   	nop
  8006a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006a9:	c9                   	leave  
  8006aa:	c3                   	ret    

008006ab <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006b4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006bb:	00 00 00 
	b.cnt = 0;
  8006be:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006c5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006c8:	ff 75 0c             	pushl  0xc(%ebp)
  8006cb:	ff 75 08             	pushl  0x8(%ebp)
  8006ce:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006d4:	50                   	push   %eax
  8006d5:	68 3a 06 80 00       	push   $0x80063a
  8006da:	e8 5a 02 00 00       	call   800939 <vprintfmt>
  8006df:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006e2:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006e8:	a0 44 30 80 00       	mov    0x803044,%al
  8006ed:	0f b6 c0             	movzbl %al,%eax
  8006f0:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006f6:	52                   	push   %edx
  8006f7:	50                   	push   %eax
  8006f8:	51                   	push   %ecx
  8006f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ff:	83 c0 08             	add    $0x8,%eax
  800702:	50                   	push   %eax
  800703:	e8 22 0f 00 00       	call   80162a <sys_cputs>
  800708:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80070b:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800712:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800720:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800727:	8d 45 0c             	lea    0xc(%ebp),%eax
  80072a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 f4             	pushl  -0xc(%ebp)
  800736:	50                   	push   %eax
  800737:	e8 6f ff ff ff       	call   8006ab <vcprintf>
  80073c:	83 c4 10             	add    $0x10,%esp
  80073f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800742:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800745:	c9                   	leave  
  800746:	c3                   	ret    

00800747 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800747:	55                   	push   %ebp
  800748:	89 e5                	mov    %esp,%ebp
  80074a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80074d:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	c1 e0 08             	shl    $0x8,%eax
  80075a:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80075f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800762:	83 c0 04             	add    $0x4,%eax
  800765:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800768:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	ff 75 f4             	pushl  -0xc(%ebp)
  800771:	50                   	push   %eax
  800772:	e8 34 ff ff ff       	call   8006ab <vcprintf>
  800777:	83 c4 10             	add    $0x10,%esp
  80077a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80077d:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800784:	07 00 00 

	return cnt;
  800787:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80078a:	c9                   	leave  
  80078b:	c3                   	ret    

0080078c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800792:	e8 d7 0e 00 00       	call   80166e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800797:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a6:	50                   	push   %eax
  8007a7:	e8 ff fe ff ff       	call   8006ab <vcprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007b2:	e8 d1 0e 00 00       	call   801688 <sys_unlock_cons>
	return cnt;
  8007b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	53                   	push   %ebx
  8007c0:	83 ec 14             	sub    $0x14,%esp
  8007c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007cf:	8b 45 18             	mov    0x18(%ebp),%eax
  8007d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007da:	77 55                	ja     800831 <printnum+0x75>
  8007dc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007df:	72 05                	jb     8007e6 <printnum+0x2a>
  8007e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007e4:	77 4b                	ja     800831 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007e6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007e9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f4:	52                   	push   %edx
  8007f5:	50                   	push   %eax
  8007f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8007fc:	e8 67 14 00 00       	call   801c68 <__udivdi3>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	83 ec 04             	sub    $0x4,%esp
  800807:	ff 75 20             	pushl  0x20(%ebp)
  80080a:	53                   	push   %ebx
  80080b:	ff 75 18             	pushl  0x18(%ebp)
  80080e:	52                   	push   %edx
  80080f:	50                   	push   %eax
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	ff 75 08             	pushl  0x8(%ebp)
  800816:	e8 a1 ff ff ff       	call   8007bc <printnum>
  80081b:	83 c4 20             	add    $0x20,%esp
  80081e:	eb 1a                	jmp    80083a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	ff 75 20             	pushl  0x20(%ebp)
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	ff d0                	call   *%eax
  80082e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800831:	ff 4d 1c             	decl   0x1c(%ebp)
  800834:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800838:	7f e6                	jg     800820 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80083a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80083d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800845:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800848:	53                   	push   %ebx
  800849:	51                   	push   %ecx
  80084a:	52                   	push   %edx
  80084b:	50                   	push   %eax
  80084c:	e8 27 15 00 00       	call   801d78 <__umoddi3>
  800851:	83 c4 10             	add    $0x10,%esp
  800854:	05 b4 25 80 00       	add    $0x8025b4,%eax
  800859:	8a 00                	mov    (%eax),%al
  80085b:	0f be c0             	movsbl %al,%eax
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	50                   	push   %eax
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	ff d0                	call   *%eax
  80086a:	83 c4 10             	add    $0x10,%esp
}
  80086d:	90                   	nop
  80086e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800871:	c9                   	leave  
  800872:	c3                   	ret    

00800873 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800876:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80087a:	7e 1c                	jle    800898 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	8d 50 08             	lea    0x8(%eax),%edx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	89 10                	mov    %edx,(%eax)
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	83 e8 08             	sub    $0x8,%eax
  800891:	8b 50 04             	mov    0x4(%eax),%edx
  800894:	8b 00                	mov    (%eax),%eax
  800896:	eb 40                	jmp    8008d8 <getuint+0x65>
	else if (lflag)
  800898:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80089c:	74 1e                	je     8008bc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	8d 50 04             	lea    0x4(%eax),%edx
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	89 10                	mov    %edx,(%eax)
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	8b 00                	mov    (%eax),%eax
  8008b0:	83 e8 04             	sub    $0x4,%eax
  8008b3:	8b 00                	mov    (%eax),%eax
  8008b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ba:	eb 1c                	jmp    8008d8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	8d 50 04             	lea    0x4(%eax),%edx
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	89 10                	mov    %edx,(%eax)
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	83 e8 04             	sub    $0x4,%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008d8:	5d                   	pop    %ebp
  8008d9:	c3                   	ret    

008008da <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008dd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008e1:	7e 1c                	jle    8008ff <getint+0x25>
		return va_arg(*ap, long long);
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	8d 50 08             	lea    0x8(%eax),%edx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	89 10                	mov    %edx,(%eax)
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	83 e8 08             	sub    $0x8,%eax
  8008f8:	8b 50 04             	mov    0x4(%eax),%edx
  8008fb:	8b 00                	mov    (%eax),%eax
  8008fd:	eb 38                	jmp    800937 <getint+0x5d>
	else if (lflag)
  8008ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800903:	74 1a                	je     80091f <getint+0x45>
		return va_arg(*ap, long);
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	8d 50 04             	lea    0x4(%eax),%edx
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	89 10                	mov    %edx,(%eax)
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	83 e8 04             	sub    $0x4,%eax
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	99                   	cltd   
  80091d:	eb 18                	jmp    800937 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	8d 50 04             	lea    0x4(%eax),%edx
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	89 10                	mov    %edx,(%eax)
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	83 e8 04             	sub    $0x4,%eax
  800934:	8b 00                	mov    (%eax),%eax
  800936:	99                   	cltd   
}
  800937:	5d                   	pop    %ebp
  800938:	c3                   	ret    

00800939 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	56                   	push   %esi
  80093d:	53                   	push   %ebx
  80093e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800941:	eb 17                	jmp    80095a <vprintfmt+0x21>
			if (ch == '\0')
  800943:	85 db                	test   %ebx,%ebx
  800945:	0f 84 c1 03 00 00    	je     800d0c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	53                   	push   %ebx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80095a:	8b 45 10             	mov    0x10(%ebp),%eax
  80095d:	8d 50 01             	lea    0x1(%eax),%edx
  800960:	89 55 10             	mov    %edx,0x10(%ebp)
  800963:	8a 00                	mov    (%eax),%al
  800965:	0f b6 d8             	movzbl %al,%ebx
  800968:	83 fb 25             	cmp    $0x25,%ebx
  80096b:	75 d6                	jne    800943 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80096d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800971:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800978:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80097f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800986:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80098d:	8b 45 10             	mov    0x10(%ebp),%eax
  800990:	8d 50 01             	lea    0x1(%eax),%edx
  800993:	89 55 10             	mov    %edx,0x10(%ebp)
  800996:	8a 00                	mov    (%eax),%al
  800998:	0f b6 d8             	movzbl %al,%ebx
  80099b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80099e:	83 f8 5b             	cmp    $0x5b,%eax
  8009a1:	0f 87 3d 03 00 00    	ja     800ce4 <vprintfmt+0x3ab>
  8009a7:	8b 04 85 d8 25 80 00 	mov    0x8025d8(,%eax,4),%eax
  8009ae:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009b0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009b4:	eb d7                	jmp    80098d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009ba:	eb d1                	jmp    80098d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009bc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c6:	89 d0                	mov    %edx,%eax
  8009c8:	c1 e0 02             	shl    $0x2,%eax
  8009cb:	01 d0                	add    %edx,%eax
  8009cd:	01 c0                	add    %eax,%eax
  8009cf:	01 d8                	add    %ebx,%eax
  8009d1:	83 e8 30             	sub    $0x30,%eax
  8009d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009da:	8a 00                	mov    (%eax),%al
  8009dc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009df:	83 fb 2f             	cmp    $0x2f,%ebx
  8009e2:	7e 3e                	jle    800a22 <vprintfmt+0xe9>
  8009e4:	83 fb 39             	cmp    $0x39,%ebx
  8009e7:	7f 39                	jg     800a22 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ec:	eb d5                	jmp    8009c3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f1:	83 c0 04             	add    $0x4,%eax
  8009f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fa:	83 e8 04             	sub    $0x4,%eax
  8009fd:	8b 00                	mov    (%eax),%eax
  8009ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a02:	eb 1f                	jmp    800a23 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a08:	79 83                	jns    80098d <vprintfmt+0x54>
				width = 0;
  800a0a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a11:	e9 77 ff ff ff       	jmp    80098d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a16:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a1d:	e9 6b ff ff ff       	jmp    80098d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a22:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a27:	0f 89 60 ff ff ff    	jns    80098d <vprintfmt+0x54>
				width = precision, precision = -1;
  800a2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a33:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a3a:	e9 4e ff ff ff       	jmp    80098d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a3f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a42:	e9 46 ff ff ff       	jmp    80098d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	83 c0 04             	add    $0x4,%eax
  800a4d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a50:	8b 45 14             	mov    0x14(%ebp),%eax
  800a53:	83 e8 04             	sub    $0x4,%eax
  800a56:	8b 00                	mov    (%eax),%eax
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	ff 75 0c             	pushl  0xc(%ebp)
  800a5e:	50                   	push   %eax
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
			break;
  800a67:	e9 9b 02 00 00       	jmp    800d07 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	83 c0 04             	add    $0x4,%eax
  800a72:	89 45 14             	mov    %eax,0x14(%ebp)
  800a75:	8b 45 14             	mov    0x14(%ebp),%eax
  800a78:	83 e8 04             	sub    $0x4,%eax
  800a7b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a7d:	85 db                	test   %ebx,%ebx
  800a7f:	79 02                	jns    800a83 <vprintfmt+0x14a>
				err = -err;
  800a81:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a83:	83 fb 64             	cmp    $0x64,%ebx
  800a86:	7f 0b                	jg     800a93 <vprintfmt+0x15a>
  800a88:	8b 34 9d 20 24 80 00 	mov    0x802420(,%ebx,4),%esi
  800a8f:	85 f6                	test   %esi,%esi
  800a91:	75 19                	jne    800aac <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a93:	53                   	push   %ebx
  800a94:	68 c5 25 80 00       	push   $0x8025c5
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	ff 75 08             	pushl  0x8(%ebp)
  800a9f:	e8 70 02 00 00       	call   800d14 <printfmt>
  800aa4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa7:	e9 5b 02 00 00       	jmp    800d07 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aac:	56                   	push   %esi
  800aad:	68 ce 25 80 00       	push   $0x8025ce
  800ab2:	ff 75 0c             	pushl  0xc(%ebp)
  800ab5:	ff 75 08             	pushl  0x8(%ebp)
  800ab8:	e8 57 02 00 00       	call   800d14 <printfmt>
  800abd:	83 c4 10             	add    $0x10,%esp
			break;
  800ac0:	e9 42 02 00 00       	jmp    800d07 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ac5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac8:	83 c0 04             	add    $0x4,%eax
  800acb:	89 45 14             	mov    %eax,0x14(%ebp)
  800ace:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad1:	83 e8 04             	sub    $0x4,%eax
  800ad4:	8b 30                	mov    (%eax),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 05                	jne    800adf <vprintfmt+0x1a6>
				p = "(null)";
  800ada:	be d1 25 80 00       	mov    $0x8025d1,%esi
			if (width > 0 && padc != '-')
  800adf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae3:	7e 6d                	jle    800b52 <vprintfmt+0x219>
  800ae5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ae9:	74 67                	je     800b52 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800aeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aee:	83 ec 08             	sub    $0x8,%esp
  800af1:	50                   	push   %eax
  800af2:	56                   	push   %esi
  800af3:	e8 1e 03 00 00       	call   800e16 <strnlen>
  800af8:	83 c4 10             	add    $0x10,%esp
  800afb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800afe:	eb 16                	jmp    800b16 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b00:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	ff 75 0c             	pushl  0xc(%ebp)
  800b0a:	50                   	push   %eax
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	ff d0                	call   *%eax
  800b10:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b13:	ff 4d e4             	decl   -0x1c(%ebp)
  800b16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b1a:	7f e4                	jg     800b00 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b1c:	eb 34                	jmp    800b52 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b1e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b22:	74 1c                	je     800b40 <vprintfmt+0x207>
  800b24:	83 fb 1f             	cmp    $0x1f,%ebx
  800b27:	7e 05                	jle    800b2e <vprintfmt+0x1f5>
  800b29:	83 fb 7e             	cmp    $0x7e,%ebx
  800b2c:	7e 12                	jle    800b40 <vprintfmt+0x207>
					putch('?', putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	6a 3f                	push   $0x3f
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
  800b3e:	eb 0f                	jmp    800b4f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 0c             	pushl  0xc(%ebp)
  800b46:	53                   	push   %ebx
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	ff d0                	call   *%eax
  800b4c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b52:	89 f0                	mov    %esi,%eax
  800b54:	8d 70 01             	lea    0x1(%eax),%esi
  800b57:	8a 00                	mov    (%eax),%al
  800b59:	0f be d8             	movsbl %al,%ebx
  800b5c:	85 db                	test   %ebx,%ebx
  800b5e:	74 24                	je     800b84 <vprintfmt+0x24b>
  800b60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b64:	78 b8                	js     800b1e <vprintfmt+0x1e5>
  800b66:	ff 4d e0             	decl   -0x20(%ebp)
  800b69:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b6d:	79 af                	jns    800b1e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6f:	eb 13                	jmp    800b84 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b71:	83 ec 08             	sub    $0x8,%esp
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	6a 20                	push   $0x20
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	ff d0                	call   *%eax
  800b7e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b81:	ff 4d e4             	decl   -0x1c(%ebp)
  800b84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b88:	7f e7                	jg     800b71 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b8a:	e9 78 01 00 00       	jmp    800d07 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 e8             	pushl  -0x18(%ebp)
  800b95:	8d 45 14             	lea    0x14(%ebp),%eax
  800b98:	50                   	push   %eax
  800b99:	e8 3c fd ff ff       	call   8008da <getint>
  800b9e:	83 c4 10             	add    $0x10,%esp
  800ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800baa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bad:	85 d2                	test   %edx,%edx
  800baf:	79 23                	jns    800bd4 <vprintfmt+0x29b>
				putch('-', putdat);
  800bb1:	83 ec 08             	sub    $0x8,%esp
  800bb4:	ff 75 0c             	pushl  0xc(%ebp)
  800bb7:	6a 2d                	push   $0x2d
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	ff d0                	call   *%eax
  800bbe:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc7:	f7 d8                	neg    %eax
  800bc9:	83 d2 00             	adc    $0x0,%edx
  800bcc:	f7 da                	neg    %edx
  800bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bd4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bdb:	e9 bc 00 00 00       	jmp    800c9c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800be0:	83 ec 08             	sub    $0x8,%esp
  800be3:	ff 75 e8             	pushl  -0x18(%ebp)
  800be6:	8d 45 14             	lea    0x14(%ebp),%eax
  800be9:	50                   	push   %eax
  800bea:	e8 84 fc ff ff       	call   800873 <getuint>
  800bef:	83 c4 10             	add    $0x10,%esp
  800bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bf8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bff:	e9 98 00 00 00       	jmp    800c9c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c04:	83 ec 08             	sub    $0x8,%esp
  800c07:	ff 75 0c             	pushl  0xc(%ebp)
  800c0a:	6a 58                	push   $0x58
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	ff d0                	call   *%eax
  800c11:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c14:	83 ec 08             	sub    $0x8,%esp
  800c17:	ff 75 0c             	pushl  0xc(%ebp)
  800c1a:	6a 58                	push   $0x58
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	ff d0                	call   *%eax
  800c21:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c24:	83 ec 08             	sub    $0x8,%esp
  800c27:	ff 75 0c             	pushl  0xc(%ebp)
  800c2a:	6a 58                	push   $0x58
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	ff d0                	call   *%eax
  800c31:	83 c4 10             	add    $0x10,%esp
			break;
  800c34:	e9 ce 00 00 00       	jmp    800d07 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c39:	83 ec 08             	sub    $0x8,%esp
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	6a 30                	push   $0x30
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	ff d0                	call   *%eax
  800c46:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c49:	83 ec 08             	sub    $0x8,%esp
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	6a 78                	push   $0x78
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	ff d0                	call   *%eax
  800c56:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c59:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5c:	83 c0 04             	add    $0x4,%eax
  800c5f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c62:	8b 45 14             	mov    0x14(%ebp),%eax
  800c65:	83 e8 04             	sub    $0x4,%eax
  800c68:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c74:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c7b:	eb 1f                	jmp    800c9c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c7d:	83 ec 08             	sub    $0x8,%esp
  800c80:	ff 75 e8             	pushl  -0x18(%ebp)
  800c83:	8d 45 14             	lea    0x14(%ebp),%eax
  800c86:	50                   	push   %eax
  800c87:	e8 e7 fb ff ff       	call   800873 <getuint>
  800c8c:	83 c4 10             	add    $0x10,%esp
  800c8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c95:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c9c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ca3:	83 ec 04             	sub    $0x4,%esp
  800ca6:	52                   	push   %edx
  800ca7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800caa:	50                   	push   %eax
  800cab:	ff 75 f4             	pushl  -0xc(%ebp)
  800cae:	ff 75 f0             	pushl  -0x10(%ebp)
  800cb1:	ff 75 0c             	pushl  0xc(%ebp)
  800cb4:	ff 75 08             	pushl  0x8(%ebp)
  800cb7:	e8 00 fb ff ff       	call   8007bc <printnum>
  800cbc:	83 c4 20             	add    $0x20,%esp
			break;
  800cbf:	eb 46                	jmp    800d07 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cc1:	83 ec 08             	sub    $0x8,%esp
  800cc4:	ff 75 0c             	pushl  0xc(%ebp)
  800cc7:	53                   	push   %ebx
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	ff d0                	call   *%eax
  800ccd:	83 c4 10             	add    $0x10,%esp
			break;
  800cd0:	eb 35                	jmp    800d07 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cd2:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cd9:	eb 2c                	jmp    800d07 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cdb:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800ce2:	eb 23                	jmp    800d07 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	ff 75 0c             	pushl  0xc(%ebp)
  800cea:	6a 25                	push   $0x25
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	ff d0                	call   *%eax
  800cf1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cf4:	ff 4d 10             	decl   0x10(%ebp)
  800cf7:	eb 03                	jmp    800cfc <vprintfmt+0x3c3>
  800cf9:	ff 4d 10             	decl   0x10(%ebp)
  800cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cff:	48                   	dec    %eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	3c 25                	cmp    $0x25,%al
  800d04:	75 f3                	jne    800cf9 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d06:	90                   	nop
		}
	}
  800d07:	e9 35 fc ff ff       	jmp    800941 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d0c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d1a:	8d 45 10             	lea    0x10(%ebp),%eax
  800d1d:	83 c0 04             	add    $0x4,%eax
  800d20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d23:	8b 45 10             	mov    0x10(%ebp),%eax
  800d26:	ff 75 f4             	pushl  -0xc(%ebp)
  800d29:	50                   	push   %eax
  800d2a:	ff 75 0c             	pushl  0xc(%ebp)
  800d2d:	ff 75 08             	pushl  0x8(%ebp)
  800d30:	e8 04 fc ff ff       	call   800939 <vprintfmt>
  800d35:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d38:	90                   	nop
  800d39:	c9                   	leave  
  800d3a:	c3                   	ret    

00800d3b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d41:	8b 40 08             	mov    0x8(%eax),%eax
  800d44:	8d 50 01             	lea    0x1(%eax),%edx
  800d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	8b 10                	mov    (%eax),%edx
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8b 40 04             	mov    0x4(%eax),%eax
  800d58:	39 c2                	cmp    %eax,%edx
  800d5a:	73 12                	jae    800d6e <sprintputch+0x33>
		*b->buf++ = ch;
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	8b 00                	mov    (%eax),%eax
  800d61:	8d 48 01             	lea    0x1(%eax),%ecx
  800d64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d67:	89 0a                	mov    %ecx,(%edx)
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	88 10                	mov    %dl,(%eax)
}
  800d6e:	90                   	nop
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    

00800d71 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	01 d0                	add    %edx,%eax
  800d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d96:	74 06                	je     800d9e <vsnprintf+0x2d>
  800d98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9c:	7f 07                	jg     800da5 <vsnprintf+0x34>
		return -E_INVAL;
  800d9e:	b8 03 00 00 00       	mov    $0x3,%eax
  800da3:	eb 20                	jmp    800dc5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800da5:	ff 75 14             	pushl  0x14(%ebp)
  800da8:	ff 75 10             	pushl  0x10(%ebp)
  800dab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dae:	50                   	push   %eax
  800daf:	68 3b 0d 80 00       	push   $0x800d3b
  800db4:	e8 80 fb ff ff       	call   800939 <vprintfmt>
  800db9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dbf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dc5:	c9                   	leave  
  800dc6:	c3                   	ret    

00800dc7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dcd:	8d 45 10             	lea    0x10(%ebp),%eax
  800dd0:	83 c0 04             	add    $0x4,%eax
  800dd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800ddc:	50                   	push   %eax
  800ddd:	ff 75 0c             	pushl  0xc(%ebp)
  800de0:	ff 75 08             	pushl  0x8(%ebp)
  800de3:	e8 89 ff ff ff       	call   800d71 <vsnprintf>
  800de8:	83 c4 10             	add    $0x10,%esp
  800deb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800df9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e00:	eb 06                	jmp    800e08 <strlen+0x15>
		n++;
  800e02:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e05:	ff 45 08             	incl   0x8(%ebp)
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8a 00                	mov    (%eax),%al
  800e0d:	84 c0                	test   %al,%al
  800e0f:	75 f1                	jne    800e02 <strlen+0xf>
		n++;
	return n;
  800e11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e14:	c9                   	leave  
  800e15:	c3                   	ret    

00800e16 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e23:	eb 09                	jmp    800e2e <strnlen+0x18>
		n++;
  800e25:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e28:	ff 45 08             	incl   0x8(%ebp)
  800e2b:	ff 4d 0c             	decl   0xc(%ebp)
  800e2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e32:	74 09                	je     800e3d <strnlen+0x27>
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 00                	mov    (%eax),%al
  800e39:	84 c0                	test   %al,%al
  800e3b:	75 e8                	jne    800e25 <strnlen+0xf>
		n++;
	return n;
  800e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e4e:	90                   	nop
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8d 50 01             	lea    0x1(%eax),%edx
  800e55:	89 55 08             	mov    %edx,0x8(%ebp)
  800e58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e61:	8a 12                	mov    (%edx),%dl
  800e63:	88 10                	mov    %dl,(%eax)
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	84 c0                	test   %al,%al
  800e69:	75 e4                	jne    800e4f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e83:	eb 1f                	jmp    800ea4 <strncpy+0x34>
		*dst++ = *src;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	8d 50 01             	lea    0x1(%eax),%edx
  800e8b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e91:	8a 12                	mov    (%edx),%dl
  800e93:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	84 c0                	test   %al,%al
  800e9c:	74 03                	je     800ea1 <strncpy+0x31>
			src++;
  800e9e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ea1:	ff 45 fc             	incl   -0x4(%ebp)
  800ea4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800eaa:	72 d9                	jb     800e85 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eaf:	c9                   	leave  
  800eb0:	c3                   	ret    

00800eb1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ebd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec1:	74 30                	je     800ef3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ec3:	eb 16                	jmp    800edb <strlcpy+0x2a>
			*dst++ = *src++;
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	8d 50 01             	lea    0x1(%eax),%edx
  800ecb:	89 55 08             	mov    %edx,0x8(%ebp)
  800ece:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ed7:	8a 12                	mov    (%edx),%dl
  800ed9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800edb:	ff 4d 10             	decl   0x10(%ebp)
  800ede:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee2:	74 09                	je     800eed <strlcpy+0x3c>
  800ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	84 c0                	test   %al,%al
  800eeb:	75 d8                	jne    800ec5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef9:	29 c2                	sub    %eax,%edx
  800efb:	89 d0                	mov    %edx,%eax
}
  800efd:	c9                   	leave  
  800efe:	c3                   	ret    

00800eff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f02:	eb 06                	jmp    800f0a <strcmp+0xb>
		p++, q++;
  800f04:	ff 45 08             	incl   0x8(%ebp)
  800f07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	84 c0                	test   %al,%al
  800f11:	74 0e                	je     800f21 <strcmp+0x22>
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 10                	mov    (%eax),%dl
  800f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	38 c2                	cmp    %al,%dl
  800f1f:	74 e3                	je     800f04 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	0f b6 d0             	movzbl %al,%edx
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	0f b6 c0             	movzbl %al,%eax
  800f31:	29 c2                	sub    %eax,%edx
  800f33:	89 d0                	mov    %edx,%eax
}
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    

00800f37 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f3a:	eb 09                	jmp    800f45 <strncmp+0xe>
		n--, p++, q++;
  800f3c:	ff 4d 10             	decl   0x10(%ebp)
  800f3f:	ff 45 08             	incl   0x8(%ebp)
  800f42:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f49:	74 17                	je     800f62 <strncmp+0x2b>
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	84 c0                	test   %al,%al
  800f52:	74 0e                	je     800f62 <strncmp+0x2b>
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	8a 10                	mov    (%eax),%dl
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	38 c2                	cmp    %al,%dl
  800f60:	74 da                	je     800f3c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f66:	75 07                	jne    800f6f <strncmp+0x38>
		return 0;
  800f68:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6d:	eb 14                	jmp    800f83 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	0f b6 d0             	movzbl %al,%edx
  800f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	0f b6 c0             	movzbl %al,%eax
  800f7f:	29 c2                	sub    %eax,%edx
  800f81:	89 d0                	mov    %edx,%eax
}
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    

00800f85 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	83 ec 04             	sub    $0x4,%esp
  800f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f91:	eb 12                	jmp    800fa5 <strchr+0x20>
		if (*s == c)
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f9b:	75 05                	jne    800fa2 <strchr+0x1d>
			return (char *) s;
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	eb 11                	jmp    800fb3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fa2:	ff 45 08             	incl   0x8(%ebp)
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	84 c0                	test   %al,%al
  800fac:	75 e5                	jne    800f93 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb3:	c9                   	leave  
  800fb4:	c3                   	ret    

00800fb5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	83 ec 04             	sub    $0x4,%esp
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc1:	eb 0d                	jmp    800fd0 <strfind+0x1b>
		if (*s == c)
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fcb:	74 0e                	je     800fdb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fcd:	ff 45 08             	incl   0x8(%ebp)
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	84 c0                	test   %al,%al
  800fd7:	75 ea                	jne    800fc3 <strfind+0xe>
  800fd9:	eb 01                	jmp    800fdc <strfind+0x27>
		if (*s == c)
			break;
  800fdb:	90                   	nop
	return (char *) s;
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdf:	c9                   	leave  
  800fe0:	c3                   	ret    

00800fe1 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fed:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ff1:	76 63                	jbe    801056 <memset+0x75>
		uint64 data_block = c;
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	99                   	cltd   
  800ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffa:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801000:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801003:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801007:	c1 e0 08             	shl    $0x8,%eax
  80100a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80100d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801010:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801013:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801016:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80101a:	c1 e0 10             	shl    $0x10,%eax
  80101d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801020:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801023:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801026:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801029:	89 c2                	mov    %eax,%edx
  80102b:	b8 00 00 00 00       	mov    $0x0,%eax
  801030:	09 45 f0             	or     %eax,-0x10(%ebp)
  801033:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801036:	eb 18                	jmp    801050 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801038:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80103b:	8d 41 08             	lea    0x8(%ecx),%eax
  80103e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801047:	89 01                	mov    %eax,(%ecx)
  801049:	89 51 04             	mov    %edx,0x4(%ecx)
  80104c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801050:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801054:	77 e2                	ja     801038 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801056:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105a:	74 23                	je     80107f <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80105c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80105f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801062:	eb 0e                	jmp    801072 <memset+0x91>
			*p8++ = (uint8)c;
  801064:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801067:	8d 50 01             	lea    0x1(%eax),%edx
  80106a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80106d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801070:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	8d 50 ff             	lea    -0x1(%eax),%edx
  801078:	89 55 10             	mov    %edx,0x10(%ebp)
  80107b:	85 c0                	test   %eax,%eax
  80107d:	75 e5                	jne    801064 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801082:	c9                   	leave  
  801083:	c3                   	ret    

00801084 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80108a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801096:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80109a:	76 24                	jbe    8010c0 <memcpy+0x3c>
		while(n >= 8){
  80109c:	eb 1c                	jmp    8010ba <memcpy+0x36>
			*d64 = *s64;
  80109e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a1:	8b 50 04             	mov    0x4(%eax),%edx
  8010a4:	8b 00                	mov    (%eax),%eax
  8010a6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010a9:	89 01                	mov    %eax,(%ecx)
  8010ab:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010ae:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010b2:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010b6:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010ba:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010be:	77 de                	ja     80109e <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c4:	74 31                	je     8010f7 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010d2:	eb 16                	jmp    8010ea <memcpy+0x66>
			*d8++ = *s8++;
  8010d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010d7:	8d 50 01             	lea    0x1(%eax),%edx
  8010da:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e3:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010e6:	8a 12                	mov    (%edx),%dl
  8010e8:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	75 dd                	jne    8010d4 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    

008010fc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80110e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801111:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801114:	73 50                	jae    801166 <memmove+0x6a>
  801116:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801119:	8b 45 10             	mov    0x10(%ebp),%eax
  80111c:	01 d0                	add    %edx,%eax
  80111e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801121:	76 43                	jbe    801166 <memmove+0x6a>
		s += n;
  801123:	8b 45 10             	mov    0x10(%ebp),%eax
  801126:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801129:	8b 45 10             	mov    0x10(%ebp),%eax
  80112c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80112f:	eb 10                	jmp    801141 <memmove+0x45>
			*--d = *--s;
  801131:	ff 4d f8             	decl   -0x8(%ebp)
  801134:	ff 4d fc             	decl   -0x4(%ebp)
  801137:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113a:	8a 10                	mov    (%eax),%dl
  80113c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801141:	8b 45 10             	mov    0x10(%ebp),%eax
  801144:	8d 50 ff             	lea    -0x1(%eax),%edx
  801147:	89 55 10             	mov    %edx,0x10(%ebp)
  80114a:	85 c0                	test   %eax,%eax
  80114c:	75 e3                	jne    801131 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80114e:	eb 23                	jmp    801173 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801150:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801153:	8d 50 01             	lea    0x1(%eax),%edx
  801156:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801159:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80115f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801162:	8a 12                	mov    (%edx),%dl
  801164:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116c:	89 55 10             	mov    %edx,0x10(%ebp)
  80116f:	85 c0                	test   %eax,%eax
  801171:	75 dd                	jne    801150 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801184:	8b 45 0c             	mov    0xc(%ebp),%eax
  801187:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80118a:	eb 2a                	jmp    8011b6 <memcmp+0x3e>
		if (*s1 != *s2)
  80118c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118f:	8a 10                	mov    (%eax),%dl
  801191:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	38 c2                	cmp    %al,%dl
  801198:	74 16                	je     8011b0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80119a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	0f b6 d0             	movzbl %al,%edx
  8011a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a5:	8a 00                	mov    (%eax),%al
  8011a7:	0f b6 c0             	movzbl %al,%eax
  8011aa:	29 c2                	sub    %eax,%edx
  8011ac:	89 d0                	mov    %edx,%eax
  8011ae:	eb 18                	jmp    8011c8 <memcmp+0x50>
		s1++, s2++;
  8011b0:	ff 45 fc             	incl   -0x4(%ebp)
  8011b3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	75 c9                	jne    80118c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d6:	01 d0                	add    %edx,%eax
  8011d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011db:	eb 15                	jmp    8011f2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d0             	movzbl %al,%edx
  8011e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e8:	0f b6 c0             	movzbl %al,%eax
  8011eb:	39 c2                	cmp    %eax,%edx
  8011ed:	74 0d                	je     8011fc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011ef:	ff 45 08             	incl   0x8(%ebp)
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011f8:	72 e3                	jb     8011dd <memfind+0x13>
  8011fa:	eb 01                	jmp    8011fd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011fc:	90                   	nop
	return (void *) s;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801200:	c9                   	leave  
  801201:	c3                   	ret    

00801202 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801208:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80120f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801216:	eb 03                	jmp    80121b <strtol+0x19>
		s++;
  801218:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	3c 20                	cmp    $0x20,%al
  801222:	74 f4                	je     801218 <strtol+0x16>
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	3c 09                	cmp    $0x9,%al
  80122b:	74 eb                	je     801218 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	3c 2b                	cmp    $0x2b,%al
  801234:	75 05                	jne    80123b <strtol+0x39>
		s++;
  801236:	ff 45 08             	incl   0x8(%ebp)
  801239:	eb 13                	jmp    80124e <strtol+0x4c>
	else if (*s == '-')
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	3c 2d                	cmp    $0x2d,%al
  801242:	75 0a                	jne    80124e <strtol+0x4c>
		s++, neg = 1;
  801244:	ff 45 08             	incl   0x8(%ebp)
  801247:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80124e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801252:	74 06                	je     80125a <strtol+0x58>
  801254:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801258:	75 20                	jne    80127a <strtol+0x78>
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	3c 30                	cmp    $0x30,%al
  801261:	75 17                	jne    80127a <strtol+0x78>
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	40                   	inc    %eax
  801267:	8a 00                	mov    (%eax),%al
  801269:	3c 78                	cmp    $0x78,%al
  80126b:	75 0d                	jne    80127a <strtol+0x78>
		s += 2, base = 16;
  80126d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801271:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801278:	eb 28                	jmp    8012a2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80127a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80127e:	75 15                	jne    801295 <strtol+0x93>
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	3c 30                	cmp    $0x30,%al
  801287:	75 0c                	jne    801295 <strtol+0x93>
		s++, base = 8;
  801289:	ff 45 08             	incl   0x8(%ebp)
  80128c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801293:	eb 0d                	jmp    8012a2 <strtol+0xa0>
	else if (base == 0)
  801295:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801299:	75 07                	jne    8012a2 <strtol+0xa0>
		base = 10;
  80129b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	3c 2f                	cmp    $0x2f,%al
  8012a9:	7e 19                	jle    8012c4 <strtol+0xc2>
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	3c 39                	cmp    $0x39,%al
  8012b2:	7f 10                	jg     8012c4 <strtol+0xc2>
			dig = *s - '0';
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f be c0             	movsbl %al,%eax
  8012bc:	83 e8 30             	sub    $0x30,%eax
  8012bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c2:	eb 42                	jmp    801306 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	3c 60                	cmp    $0x60,%al
  8012cb:	7e 19                	jle    8012e6 <strtol+0xe4>
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	3c 7a                	cmp    $0x7a,%al
  8012d4:	7f 10                	jg     8012e6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	0f be c0             	movsbl %al,%eax
  8012de:	83 e8 57             	sub    $0x57,%eax
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012e4:	eb 20                	jmp    801306 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	3c 40                	cmp    $0x40,%al
  8012ed:	7e 39                	jle    801328 <strtol+0x126>
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	8a 00                	mov    (%eax),%al
  8012f4:	3c 5a                	cmp    $0x5a,%al
  8012f6:	7f 30                	jg     801328 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	0f be c0             	movsbl %al,%eax
  801300:	83 e8 37             	sub    $0x37,%eax
  801303:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801309:	3b 45 10             	cmp    0x10(%ebp),%eax
  80130c:	7d 19                	jge    801327 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80130e:	ff 45 08             	incl   0x8(%ebp)
  801311:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801314:	0f af 45 10          	imul   0x10(%ebp),%eax
  801318:	89 c2                	mov    %eax,%edx
  80131a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131d:	01 d0                	add    %edx,%eax
  80131f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801322:	e9 7b ff ff ff       	jmp    8012a2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801327:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801328:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80132c:	74 08                	je     801336 <strtol+0x134>
		*endptr = (char *) s;
  80132e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801331:	8b 55 08             	mov    0x8(%ebp),%edx
  801334:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801336:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80133a:	74 07                	je     801343 <strtol+0x141>
  80133c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133f:	f7 d8                	neg    %eax
  801341:	eb 03                	jmp    801346 <strtol+0x144>
  801343:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <ltostr>:

void
ltostr(long value, char *str)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80134e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801355:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80135c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801360:	79 13                	jns    801375 <ltostr+0x2d>
	{
		neg = 1;
  801362:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80136f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801372:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80137d:	99                   	cltd   
  80137e:	f7 f9                	idiv   %ecx
  801380:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801383:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801386:	8d 50 01             	lea    0x1(%eax),%edx
  801389:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80138c:	89 c2                	mov    %eax,%edx
  80138e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801391:	01 d0                	add    %edx,%eax
  801393:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801396:	83 c2 30             	add    $0x30,%edx
  801399:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80139b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80139e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013a3:	f7 e9                	imul   %ecx
  8013a5:	c1 fa 02             	sar    $0x2,%edx
  8013a8:	89 c8                	mov    %ecx,%eax
  8013aa:	c1 f8 1f             	sar    $0x1f,%eax
  8013ad:	29 c2                	sub    %eax,%edx
  8013af:	89 d0                	mov    %edx,%eax
  8013b1:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b8:	75 bb                	jne    801375 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c4:	48                   	dec    %eax
  8013c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013cc:	74 3d                	je     80140b <ltostr+0xc3>
		start = 1 ;
  8013ce:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013d5:	eb 34                	jmp    80140b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	01 d0                	add    %edx,%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ea:	01 c2                	add    %eax,%edx
  8013ec:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f2:	01 c8                	add    %ecx,%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8a 45 eb             	mov    -0x15(%ebp),%al
  801403:	88 02                	mov    %al,(%edx)
		start++ ;
  801405:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801408:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80140b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801411:	7c c4                	jl     8013d7 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801413:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801416:	8b 45 0c             	mov    0xc(%ebp),%eax
  801419:	01 d0                	add    %edx,%eax
  80141b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80141e:	90                   	nop
  80141f:	c9                   	leave  
  801420:	c3                   	ret    

00801421 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
  801424:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801427:	ff 75 08             	pushl  0x8(%ebp)
  80142a:	e8 c4 f9 ff ff       	call   800df3 <strlen>
  80142f:	83 c4 04             	add    $0x4,%esp
  801432:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801435:	ff 75 0c             	pushl  0xc(%ebp)
  801438:	e8 b6 f9 ff ff       	call   800df3 <strlen>
  80143d:	83 c4 04             	add    $0x4,%esp
  801440:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801443:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80144a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801451:	eb 17                	jmp    80146a <strcconcat+0x49>
		final[s] = str1[s] ;
  801453:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801456:	8b 45 10             	mov    0x10(%ebp),%eax
  801459:	01 c2                	add    %eax,%edx
  80145b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	01 c8                	add    %ecx,%eax
  801463:	8a 00                	mov    (%eax),%al
  801465:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801467:	ff 45 fc             	incl   -0x4(%ebp)
  80146a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80146d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801470:	7c e1                	jl     801453 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801472:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801479:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801480:	eb 1f                	jmp    8014a1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801482:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801485:	8d 50 01             	lea    0x1(%eax),%edx
  801488:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80148b:	89 c2                	mov    %eax,%edx
  80148d:	8b 45 10             	mov    0x10(%ebp),%eax
  801490:	01 c2                	add    %eax,%edx
  801492:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801495:	8b 45 0c             	mov    0xc(%ebp),%eax
  801498:	01 c8                	add    %ecx,%eax
  80149a:	8a 00                	mov    (%eax),%al
  80149c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80149e:	ff 45 f8             	incl   -0x8(%ebp)
  8014a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014a7:	7c d9                	jl     801482 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8014af:	01 d0                	add    %edx,%eax
  8014b1:	c6 00 00             	movb   $0x0,(%eax)
}
  8014b4:	90                   	nop
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8014bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c6:	8b 00                	mov    (%eax),%eax
  8014c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d2:	01 d0                	add    %edx,%eax
  8014d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014da:	eb 0c                	jmp    8014e8 <strsplit+0x31>
			*string++ = 0;
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	8d 50 01             	lea    0x1(%eax),%edx
  8014e2:	89 55 08             	mov    %edx,0x8(%ebp)
  8014e5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	8a 00                	mov    (%eax),%al
  8014ed:	84 c0                	test   %al,%al
  8014ef:	74 18                	je     801509 <strsplit+0x52>
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	8a 00                	mov    (%eax),%al
  8014f6:	0f be c0             	movsbl %al,%eax
  8014f9:	50                   	push   %eax
  8014fa:	ff 75 0c             	pushl  0xc(%ebp)
  8014fd:	e8 83 fa ff ff       	call   800f85 <strchr>
  801502:	83 c4 08             	add    $0x8,%esp
  801505:	85 c0                	test   %eax,%eax
  801507:	75 d3                	jne    8014dc <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801509:	8b 45 08             	mov    0x8(%ebp),%eax
  80150c:	8a 00                	mov    (%eax),%al
  80150e:	84 c0                	test   %al,%al
  801510:	74 5a                	je     80156c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801512:	8b 45 14             	mov    0x14(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	83 f8 0f             	cmp    $0xf,%eax
  80151a:	75 07                	jne    801523 <strsplit+0x6c>
		{
			return 0;
  80151c:	b8 00 00 00 00       	mov    $0x0,%eax
  801521:	eb 66                	jmp    801589 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801523:	8b 45 14             	mov    0x14(%ebp),%eax
  801526:	8b 00                	mov    (%eax),%eax
  801528:	8d 48 01             	lea    0x1(%eax),%ecx
  80152b:	8b 55 14             	mov    0x14(%ebp),%edx
  80152e:	89 0a                	mov    %ecx,(%edx)
  801530:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801537:	8b 45 10             	mov    0x10(%ebp),%eax
  80153a:	01 c2                	add    %eax,%edx
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801541:	eb 03                	jmp    801546 <strsplit+0x8f>
			string++;
  801543:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8a 00                	mov    (%eax),%al
  80154b:	84 c0                	test   %al,%al
  80154d:	74 8b                	je     8014da <strsplit+0x23>
  80154f:	8b 45 08             	mov    0x8(%ebp),%eax
  801552:	8a 00                	mov    (%eax),%al
  801554:	0f be c0             	movsbl %al,%eax
  801557:	50                   	push   %eax
  801558:	ff 75 0c             	pushl  0xc(%ebp)
  80155b:	e8 25 fa ff ff       	call   800f85 <strchr>
  801560:	83 c4 08             	add    $0x8,%esp
  801563:	85 c0                	test   %eax,%eax
  801565:	74 dc                	je     801543 <strsplit+0x8c>
			string++;
	}
  801567:	e9 6e ff ff ff       	jmp    8014da <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80156c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80156d:	8b 45 14             	mov    0x14(%ebp),%eax
  801570:	8b 00                	mov    (%eax),%eax
  801572:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801579:	8b 45 10             	mov    0x10(%ebp),%eax
  80157c:	01 d0                	add    %edx,%eax
  80157e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801584:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801597:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80159e:	eb 4a                	jmp    8015ea <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	01 c2                	add    %eax,%edx
  8015a8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	01 c8                	add    %ecx,%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	3c 40                	cmp    $0x40,%al
  8015c0:	7e 25                	jle    8015e7 <str2lower+0x5c>
  8015c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c8:	01 d0                	add    %edx,%eax
  8015ca:	8a 00                	mov    (%eax),%al
  8015cc:	3c 5a                	cmp    $0x5a,%al
  8015ce:	7f 17                	jg     8015e7 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d6:	01 d0                	add    %edx,%eax
  8015d8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015db:	8b 55 08             	mov    0x8(%ebp),%edx
  8015de:	01 ca                	add    %ecx,%edx
  8015e0:	8a 12                	mov    (%edx),%dl
  8015e2:	83 c2 20             	add    $0x20,%edx
  8015e5:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015e7:	ff 45 fc             	incl   -0x4(%ebp)
  8015ea:	ff 75 0c             	pushl  0xc(%ebp)
  8015ed:	e8 01 f8 ff ff       	call   800df3 <strlen>
  8015f2:	83 c4 04             	add    $0x4,%esp
  8015f5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015f8:	7f a6                	jg     8015a0 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	57                   	push   %edi
  801603:	56                   	push   %esi
  801604:	53                   	push   %ebx
  801605:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801611:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801614:	8b 7d 18             	mov    0x18(%ebp),%edi
  801617:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80161a:	cd 30                	int    $0x30
  80161c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80161f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801622:	83 c4 10             	add    $0x10,%esp
  801625:	5b                   	pop    %ebx
  801626:	5e                   	pop    %esi
  801627:	5f                   	pop    %edi
  801628:	5d                   	pop    %ebp
  801629:	c3                   	ret    

0080162a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 04             	sub    $0x4,%esp
  801630:	8b 45 10             	mov    0x10(%ebp),%eax
  801633:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801636:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801639:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	6a 00                	push   $0x0
  801642:	51                   	push   %ecx
  801643:	52                   	push   %edx
  801644:	ff 75 0c             	pushl  0xc(%ebp)
  801647:	50                   	push   %eax
  801648:	6a 00                	push   $0x0
  80164a:	e8 b0 ff ff ff       	call   8015ff <syscall>
  80164f:	83 c4 18             	add    $0x18,%esp
}
  801652:	90                   	nop
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <sys_cgetc>:

int
sys_cgetc(void)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 02                	push   $0x2
  801664:	e8 96 ff ff ff       	call   8015ff <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 03                	push   $0x3
  80167d:	e8 7d ff ff ff       	call   8015ff <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 04                	push   $0x4
  801697:	e8 63 ff ff ff       	call   8015ff <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
}
  80169f:	90                   	nop
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	52                   	push   %edx
  8016b2:	50                   	push   %eax
  8016b3:	6a 08                	push   $0x8
  8016b5:	e8 45 ff ff ff       	call   8015ff <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	56                   	push   %esi
  8016c3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016c4:	8b 75 18             	mov    0x18(%ebp),%esi
  8016c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	56                   	push   %esi
  8016d4:	53                   	push   %ebx
  8016d5:	51                   	push   %ecx
  8016d6:	52                   	push   %edx
  8016d7:	50                   	push   %eax
  8016d8:	6a 09                	push   $0x9
  8016da:	e8 20 ff ff ff       	call   8015ff <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
}
  8016e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e5:	5b                   	pop    %ebx
  8016e6:	5e                   	pop    %esi
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    

008016e9 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	ff 75 08             	pushl  0x8(%ebp)
  8016f7:	6a 0a                	push   $0xa
  8016f9:	e8 01 ff ff ff       	call   8015ff <syscall>
  8016fe:	83 c4 18             	add    $0x18,%esp
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	ff 75 0c             	pushl  0xc(%ebp)
  80170f:	ff 75 08             	pushl  0x8(%ebp)
  801712:	6a 0b                	push   $0xb
  801714:	e8 e6 fe ff ff       	call   8015ff <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 0c                	push   $0xc
  80172d:	e8 cd fe ff ff       	call   8015ff <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 0d                	push   $0xd
  801746:	e8 b4 fe ff ff       	call   8015ff <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 0e                	push   $0xe
  80175f:	e8 9b fe ff ff       	call   8015ff <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 0f                	push   $0xf
  801778:	e8 82 fe ff ff       	call   8015ff <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	ff 75 08             	pushl  0x8(%ebp)
  801790:	6a 10                	push   $0x10
  801792:	e8 68 fe ff ff       	call   8015ff <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 11                	push   $0x11
  8017ab:	e8 4f fe ff ff       	call   8015ff <syscall>
  8017b0:	83 c4 18             	add    $0x18,%esp
}
  8017b3:	90                   	nop
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <sys_cputc>:

void
sys_cputc(const char c)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	83 ec 04             	sub    $0x4,%esp
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017c2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	50                   	push   %eax
  8017cf:	6a 01                	push   $0x1
  8017d1:	e8 29 fe ff ff       	call   8015ff <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	90                   	nop
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 14                	push   $0x14
  8017eb:	e8 0f fe ff ff       	call   8015ff <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	90                   	nop
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801802:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801805:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	6a 00                	push   $0x0
  80180e:	51                   	push   %ecx
  80180f:	52                   	push   %edx
  801810:	ff 75 0c             	pushl  0xc(%ebp)
  801813:	50                   	push   %eax
  801814:	6a 15                	push   $0x15
  801816:	e8 e4 fd ff ff       	call   8015ff <syscall>
  80181b:	83 c4 18             	add    $0x18,%esp
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801823:	8b 55 0c             	mov    0xc(%ebp),%edx
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	52                   	push   %edx
  801830:	50                   	push   %eax
  801831:	6a 16                	push   $0x16
  801833:	e8 c7 fd ff ff       	call   8015ff <syscall>
  801838:	83 c4 18             	add    $0x18,%esp
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801840:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801843:	8b 55 0c             	mov    0xc(%ebp),%edx
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	51                   	push   %ecx
  80184e:	52                   	push   %edx
  80184f:	50                   	push   %eax
  801850:	6a 17                	push   $0x17
  801852:	e8 a8 fd ff ff       	call   8015ff <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80185f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	52                   	push   %edx
  80186c:	50                   	push   %eax
  80186d:	6a 18                	push   $0x18
  80186f:	e8 8b fd ff ff       	call   8015ff <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	6a 00                	push   $0x0
  801881:	ff 75 14             	pushl  0x14(%ebp)
  801884:	ff 75 10             	pushl  0x10(%ebp)
  801887:	ff 75 0c             	pushl  0xc(%ebp)
  80188a:	50                   	push   %eax
  80188b:	6a 19                	push   $0x19
  80188d:	e8 6d fd ff ff       	call   8015ff <syscall>
  801892:	83 c4 18             	add    $0x18,%esp
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	50                   	push   %eax
  8018a6:	6a 1a                	push   $0x1a
  8018a8:	e8 52 fd ff ff       	call   8015ff <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	90                   	nop
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	50                   	push   %eax
  8018c2:	6a 1b                	push   $0x1b
  8018c4:	e8 36 fd ff ff       	call   8015ff <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 05                	push   $0x5
  8018dd:	e8 1d fd ff ff       	call   8015ff <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 06                	push   $0x6
  8018f6:	e8 04 fd ff ff       	call   8015ff <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 07                	push   $0x7
  80190f:	e8 eb fc ff ff       	call   8015ff <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_exit_env>:


void sys_exit_env(void)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 1c                	push   $0x1c
  801928:	e8 d2 fc ff ff       	call   8015ff <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	90                   	nop
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801939:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80193c:	8d 50 04             	lea    0x4(%eax),%edx
  80193f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	52                   	push   %edx
  801949:	50                   	push   %eax
  80194a:	6a 1d                	push   $0x1d
  80194c:	e8 ae fc ff ff       	call   8015ff <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
	return result;
  801954:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801957:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80195d:	89 01                	mov    %eax,(%ecx)
  80195f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	c9                   	leave  
  801966:	c2 04 00             	ret    $0x4

00801969 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	ff 75 10             	pushl  0x10(%ebp)
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	ff 75 08             	pushl  0x8(%ebp)
  801979:	6a 13                	push   $0x13
  80197b:	e8 7f fc ff ff       	call   8015ff <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
	return ;
  801983:	90                   	nop
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_rcr2>:
uint32 sys_rcr2()
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 1e                	push   $0x1e
  801995:	e8 65 fc ff ff       	call   8015ff <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 04             	sub    $0x4,%esp
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019ab:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	50                   	push   %eax
  8019b8:	6a 1f                	push   $0x1f
  8019ba:	e8 40 fc ff ff       	call   8015ff <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c2:	90                   	nop
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <rsttst>:
void rsttst()
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 21                	push   $0x21
  8019d4:	e8 26 fc ff ff       	call   8015ff <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019dc:	90                   	nop
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 04             	sub    $0x4,%esp
  8019e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019eb:	8b 55 18             	mov    0x18(%ebp),%edx
  8019ee:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019f2:	52                   	push   %edx
  8019f3:	50                   	push   %eax
  8019f4:	ff 75 10             	pushl  0x10(%ebp)
  8019f7:	ff 75 0c             	pushl  0xc(%ebp)
  8019fa:	ff 75 08             	pushl  0x8(%ebp)
  8019fd:	6a 20                	push   $0x20
  8019ff:	e8 fb fb ff ff       	call   8015ff <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
	return ;
  801a07:	90                   	nop
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <chktst>:
void chktst(uint32 n)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	ff 75 08             	pushl  0x8(%ebp)
  801a18:	6a 22                	push   $0x22
  801a1a:	e8 e0 fb ff ff       	call   8015ff <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a22:	90                   	nop
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <inctst>:

void inctst()
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 23                	push   $0x23
  801a34:	e8 c6 fb ff ff       	call   8015ff <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3c:	90                   	nop
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <gettst>:
uint32 gettst()
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 24                	push   $0x24
  801a4e:	e8 ac fb ff ff       	call   8015ff <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 25                	push   $0x25
  801a67:	e8 93 fb ff ff       	call   8015ff <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
  801a6f:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801a74:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	ff 75 08             	pushl  0x8(%ebp)
  801a91:	6a 26                	push   $0x26
  801a93:	e8 67 fb ff ff       	call   8015ff <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9b:	90                   	nop
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801aa2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aa5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	6a 00                	push   $0x0
  801ab0:	53                   	push   %ebx
  801ab1:	51                   	push   %ecx
  801ab2:	52                   	push   %edx
  801ab3:	50                   	push   %eax
  801ab4:	6a 27                	push   $0x27
  801ab6:	e8 44 fb ff ff       	call   8015ff <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	52                   	push   %edx
  801ad3:	50                   	push   %eax
  801ad4:	6a 28                	push   $0x28
  801ad6:	e8 24 fb ff ff       	call   8015ff <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ae3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ae6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	6a 00                	push   $0x0
  801aee:	51                   	push   %ecx
  801aef:	ff 75 10             	pushl  0x10(%ebp)
  801af2:	52                   	push   %edx
  801af3:	50                   	push   %eax
  801af4:	6a 29                	push   $0x29
  801af6:	e8 04 fb ff ff       	call   8015ff <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	ff 75 10             	pushl  0x10(%ebp)
  801b0a:	ff 75 0c             	pushl  0xc(%ebp)
  801b0d:	ff 75 08             	pushl  0x8(%ebp)
  801b10:	6a 12                	push   $0x12
  801b12:	e8 e8 fa ff ff       	call   8015ff <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1a:	90                   	nop
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	52                   	push   %edx
  801b2d:	50                   	push   %eax
  801b2e:	6a 2a                	push   $0x2a
  801b30:	e8 ca fa ff ff       	call   8015ff <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
	return;
  801b38:	90                   	nop
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 2b                	push   $0x2b
  801b4a:	e8 b0 fa ff ff       	call   8015ff <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	ff 75 0c             	pushl  0xc(%ebp)
  801b60:	ff 75 08             	pushl  0x8(%ebp)
  801b63:	6a 2d                	push   $0x2d
  801b65:	e8 95 fa ff ff       	call   8015ff <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
	return;
  801b6d:	90                   	nop
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	ff 75 0c             	pushl  0xc(%ebp)
  801b7c:	ff 75 08             	pushl  0x8(%ebp)
  801b7f:	6a 2c                	push   $0x2c
  801b81:	e8 79 fa ff ff       	call   8015ff <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
	return ;
  801b89:	90                   	nop
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	52                   	push   %edx
  801b9c:	50                   	push   %eax
  801b9d:	6a 2e                	push   $0x2e
  801b9f:	e8 5b fa ff ff       	call   8015ff <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba7:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801bb0:	8b 55 08             	mov    0x8(%ebp),%edx
  801bb3:	89 d0                	mov    %edx,%eax
  801bb5:	c1 e0 02             	shl    $0x2,%eax
  801bb8:	01 d0                	add    %edx,%eax
  801bba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bc1:	01 d0                	add    %edx,%eax
  801bc3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bca:	01 d0                	add    %edx,%eax
  801bcc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bd3:	01 d0                	add    %edx,%eax
  801bd5:	c1 e0 04             	shl    $0x4,%eax
  801bd8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801bdb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801be2:	0f 31                	rdtsc  
  801be4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801be7:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801bea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bf3:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801bf6:	eb 46                	jmp    801c3e <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801bf8:	0f 31                	rdtsc  
  801bfa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801bfd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801c00:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c03:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801c06:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801c09:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801c0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c12:	29 c2                	sub    %eax,%edx
  801c14:	89 d0                	mov    %edx,%eax
  801c16:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801c19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1f:	89 d1                	mov    %edx,%ecx
  801c21:	29 c1                	sub    %eax,%ecx
  801c23:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c29:	39 c2                	cmp    %eax,%edx
  801c2b:	0f 97 c0             	seta   %al
  801c2e:	0f b6 c0             	movzbl %al,%eax
  801c31:	29 c1                	sub    %eax,%ecx
  801c33:	89 c8                	mov    %ecx,%eax
  801c35:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801c38:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c41:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801c44:	72 b2                	jb     801bf8 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801c46:	90                   	nop
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801c4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801c56:	eb 03                	jmp    801c5b <busy_wait+0x12>
  801c58:	ff 45 fc             	incl   -0x4(%ebp)
  801c5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c5e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c61:	72 f5                	jb     801c58 <busy_wait+0xf>
	return i;
  801c63:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <__udivdi3>:
  801c68:	55                   	push   %ebp
  801c69:	57                   	push   %edi
  801c6a:	56                   	push   %esi
  801c6b:	53                   	push   %ebx
  801c6c:	83 ec 1c             	sub    $0x1c,%esp
  801c6f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c73:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c7f:	89 ca                	mov    %ecx,%edx
  801c81:	89 f8                	mov    %edi,%eax
  801c83:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c87:	85 f6                	test   %esi,%esi
  801c89:	75 2d                	jne    801cb8 <__udivdi3+0x50>
  801c8b:	39 cf                	cmp    %ecx,%edi
  801c8d:	77 65                	ja     801cf4 <__udivdi3+0x8c>
  801c8f:	89 fd                	mov    %edi,%ebp
  801c91:	85 ff                	test   %edi,%edi
  801c93:	75 0b                	jne    801ca0 <__udivdi3+0x38>
  801c95:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9a:	31 d2                	xor    %edx,%edx
  801c9c:	f7 f7                	div    %edi
  801c9e:	89 c5                	mov    %eax,%ebp
  801ca0:	31 d2                	xor    %edx,%edx
  801ca2:	89 c8                	mov    %ecx,%eax
  801ca4:	f7 f5                	div    %ebp
  801ca6:	89 c1                	mov    %eax,%ecx
  801ca8:	89 d8                	mov    %ebx,%eax
  801caa:	f7 f5                	div    %ebp
  801cac:	89 cf                	mov    %ecx,%edi
  801cae:	89 fa                	mov    %edi,%edx
  801cb0:	83 c4 1c             	add    $0x1c,%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5e                   	pop    %esi
  801cb5:	5f                   	pop    %edi
  801cb6:	5d                   	pop    %ebp
  801cb7:	c3                   	ret    
  801cb8:	39 ce                	cmp    %ecx,%esi
  801cba:	77 28                	ja     801ce4 <__udivdi3+0x7c>
  801cbc:	0f bd fe             	bsr    %esi,%edi
  801cbf:	83 f7 1f             	xor    $0x1f,%edi
  801cc2:	75 40                	jne    801d04 <__udivdi3+0x9c>
  801cc4:	39 ce                	cmp    %ecx,%esi
  801cc6:	72 0a                	jb     801cd2 <__udivdi3+0x6a>
  801cc8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ccc:	0f 87 9e 00 00 00    	ja     801d70 <__udivdi3+0x108>
  801cd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd7:	89 fa                	mov    %edi,%edx
  801cd9:	83 c4 1c             	add    $0x1c,%esp
  801cdc:	5b                   	pop    %ebx
  801cdd:	5e                   	pop    %esi
  801cde:	5f                   	pop    %edi
  801cdf:	5d                   	pop    %ebp
  801ce0:	c3                   	ret    
  801ce1:	8d 76 00             	lea    0x0(%esi),%esi
  801ce4:	31 ff                	xor    %edi,%edi
  801ce6:	31 c0                	xor    %eax,%eax
  801ce8:	89 fa                	mov    %edi,%edx
  801cea:	83 c4 1c             	add    $0x1c,%esp
  801ced:	5b                   	pop    %ebx
  801cee:	5e                   	pop    %esi
  801cef:	5f                   	pop    %edi
  801cf0:	5d                   	pop    %ebp
  801cf1:	c3                   	ret    
  801cf2:	66 90                	xchg   %ax,%ax
  801cf4:	89 d8                	mov    %ebx,%eax
  801cf6:	f7 f7                	div    %edi
  801cf8:	31 ff                	xor    %edi,%edi
  801cfa:	89 fa                	mov    %edi,%edx
  801cfc:	83 c4 1c             	add    $0x1c,%esp
  801cff:	5b                   	pop    %ebx
  801d00:	5e                   	pop    %esi
  801d01:	5f                   	pop    %edi
  801d02:	5d                   	pop    %ebp
  801d03:	c3                   	ret    
  801d04:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d09:	89 eb                	mov    %ebp,%ebx
  801d0b:	29 fb                	sub    %edi,%ebx
  801d0d:	89 f9                	mov    %edi,%ecx
  801d0f:	d3 e6                	shl    %cl,%esi
  801d11:	89 c5                	mov    %eax,%ebp
  801d13:	88 d9                	mov    %bl,%cl
  801d15:	d3 ed                	shr    %cl,%ebp
  801d17:	89 e9                	mov    %ebp,%ecx
  801d19:	09 f1                	or     %esi,%ecx
  801d1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d1f:	89 f9                	mov    %edi,%ecx
  801d21:	d3 e0                	shl    %cl,%eax
  801d23:	89 c5                	mov    %eax,%ebp
  801d25:	89 d6                	mov    %edx,%esi
  801d27:	88 d9                	mov    %bl,%cl
  801d29:	d3 ee                	shr    %cl,%esi
  801d2b:	89 f9                	mov    %edi,%ecx
  801d2d:	d3 e2                	shl    %cl,%edx
  801d2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d33:	88 d9                	mov    %bl,%cl
  801d35:	d3 e8                	shr    %cl,%eax
  801d37:	09 c2                	or     %eax,%edx
  801d39:	89 d0                	mov    %edx,%eax
  801d3b:	89 f2                	mov    %esi,%edx
  801d3d:	f7 74 24 0c          	divl   0xc(%esp)
  801d41:	89 d6                	mov    %edx,%esi
  801d43:	89 c3                	mov    %eax,%ebx
  801d45:	f7 e5                	mul    %ebp
  801d47:	39 d6                	cmp    %edx,%esi
  801d49:	72 19                	jb     801d64 <__udivdi3+0xfc>
  801d4b:	74 0b                	je     801d58 <__udivdi3+0xf0>
  801d4d:	89 d8                	mov    %ebx,%eax
  801d4f:	31 ff                	xor    %edi,%edi
  801d51:	e9 58 ff ff ff       	jmp    801cae <__udivdi3+0x46>
  801d56:	66 90                	xchg   %ax,%ax
  801d58:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d5c:	89 f9                	mov    %edi,%ecx
  801d5e:	d3 e2                	shl    %cl,%edx
  801d60:	39 c2                	cmp    %eax,%edx
  801d62:	73 e9                	jae    801d4d <__udivdi3+0xe5>
  801d64:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d67:	31 ff                	xor    %edi,%edi
  801d69:	e9 40 ff ff ff       	jmp    801cae <__udivdi3+0x46>
  801d6e:	66 90                	xchg   %ax,%ax
  801d70:	31 c0                	xor    %eax,%eax
  801d72:	e9 37 ff ff ff       	jmp    801cae <__udivdi3+0x46>
  801d77:	90                   	nop

00801d78 <__umoddi3>:
  801d78:	55                   	push   %ebp
  801d79:	57                   	push   %edi
  801d7a:	56                   	push   %esi
  801d7b:	53                   	push   %ebx
  801d7c:	83 ec 1c             	sub    $0x1c,%esp
  801d7f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d83:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d97:	89 f3                	mov    %esi,%ebx
  801d99:	89 fa                	mov    %edi,%edx
  801d9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d9f:	89 34 24             	mov    %esi,(%esp)
  801da2:	85 c0                	test   %eax,%eax
  801da4:	75 1a                	jne    801dc0 <__umoddi3+0x48>
  801da6:	39 f7                	cmp    %esi,%edi
  801da8:	0f 86 a2 00 00 00    	jbe    801e50 <__umoddi3+0xd8>
  801dae:	89 c8                	mov    %ecx,%eax
  801db0:	89 f2                	mov    %esi,%edx
  801db2:	f7 f7                	div    %edi
  801db4:	89 d0                	mov    %edx,%eax
  801db6:	31 d2                	xor    %edx,%edx
  801db8:	83 c4 1c             	add    $0x1c,%esp
  801dbb:	5b                   	pop    %ebx
  801dbc:	5e                   	pop    %esi
  801dbd:	5f                   	pop    %edi
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    
  801dc0:	39 f0                	cmp    %esi,%eax
  801dc2:	0f 87 ac 00 00 00    	ja     801e74 <__umoddi3+0xfc>
  801dc8:	0f bd e8             	bsr    %eax,%ebp
  801dcb:	83 f5 1f             	xor    $0x1f,%ebp
  801dce:	0f 84 ac 00 00 00    	je     801e80 <__umoddi3+0x108>
  801dd4:	bf 20 00 00 00       	mov    $0x20,%edi
  801dd9:	29 ef                	sub    %ebp,%edi
  801ddb:	89 fe                	mov    %edi,%esi
  801ddd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801de1:	89 e9                	mov    %ebp,%ecx
  801de3:	d3 e0                	shl    %cl,%eax
  801de5:	89 d7                	mov    %edx,%edi
  801de7:	89 f1                	mov    %esi,%ecx
  801de9:	d3 ef                	shr    %cl,%edi
  801deb:	09 c7                	or     %eax,%edi
  801ded:	89 e9                	mov    %ebp,%ecx
  801def:	d3 e2                	shl    %cl,%edx
  801df1:	89 14 24             	mov    %edx,(%esp)
  801df4:	89 d8                	mov    %ebx,%eax
  801df6:	d3 e0                	shl    %cl,%eax
  801df8:	89 c2                	mov    %eax,%edx
  801dfa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dfe:	d3 e0                	shl    %cl,%eax
  801e00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e04:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e08:	89 f1                	mov    %esi,%ecx
  801e0a:	d3 e8                	shr    %cl,%eax
  801e0c:	09 d0                	or     %edx,%eax
  801e0e:	d3 eb                	shr    %cl,%ebx
  801e10:	89 da                	mov    %ebx,%edx
  801e12:	f7 f7                	div    %edi
  801e14:	89 d3                	mov    %edx,%ebx
  801e16:	f7 24 24             	mull   (%esp)
  801e19:	89 c6                	mov    %eax,%esi
  801e1b:	89 d1                	mov    %edx,%ecx
  801e1d:	39 d3                	cmp    %edx,%ebx
  801e1f:	0f 82 87 00 00 00    	jb     801eac <__umoddi3+0x134>
  801e25:	0f 84 91 00 00 00    	je     801ebc <__umoddi3+0x144>
  801e2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e2f:	29 f2                	sub    %esi,%edx
  801e31:	19 cb                	sbb    %ecx,%ebx
  801e33:	89 d8                	mov    %ebx,%eax
  801e35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e39:	d3 e0                	shl    %cl,%eax
  801e3b:	89 e9                	mov    %ebp,%ecx
  801e3d:	d3 ea                	shr    %cl,%edx
  801e3f:	09 d0                	or     %edx,%eax
  801e41:	89 e9                	mov    %ebp,%ecx
  801e43:	d3 eb                	shr    %cl,%ebx
  801e45:	89 da                	mov    %ebx,%edx
  801e47:	83 c4 1c             	add    $0x1c,%esp
  801e4a:	5b                   	pop    %ebx
  801e4b:	5e                   	pop    %esi
  801e4c:	5f                   	pop    %edi
  801e4d:	5d                   	pop    %ebp
  801e4e:	c3                   	ret    
  801e4f:	90                   	nop
  801e50:	89 fd                	mov    %edi,%ebp
  801e52:	85 ff                	test   %edi,%edi
  801e54:	75 0b                	jne    801e61 <__umoddi3+0xe9>
  801e56:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5b:	31 d2                	xor    %edx,%edx
  801e5d:	f7 f7                	div    %edi
  801e5f:	89 c5                	mov    %eax,%ebp
  801e61:	89 f0                	mov    %esi,%eax
  801e63:	31 d2                	xor    %edx,%edx
  801e65:	f7 f5                	div    %ebp
  801e67:	89 c8                	mov    %ecx,%eax
  801e69:	f7 f5                	div    %ebp
  801e6b:	89 d0                	mov    %edx,%eax
  801e6d:	e9 44 ff ff ff       	jmp    801db6 <__umoddi3+0x3e>
  801e72:	66 90                	xchg   %ax,%ax
  801e74:	89 c8                	mov    %ecx,%eax
  801e76:	89 f2                	mov    %esi,%edx
  801e78:	83 c4 1c             	add    $0x1c,%esp
  801e7b:	5b                   	pop    %ebx
  801e7c:	5e                   	pop    %esi
  801e7d:	5f                   	pop    %edi
  801e7e:	5d                   	pop    %ebp
  801e7f:	c3                   	ret    
  801e80:	3b 04 24             	cmp    (%esp),%eax
  801e83:	72 06                	jb     801e8b <__umoddi3+0x113>
  801e85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e89:	77 0f                	ja     801e9a <__umoddi3+0x122>
  801e8b:	89 f2                	mov    %esi,%edx
  801e8d:	29 f9                	sub    %edi,%ecx
  801e8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e93:	89 14 24             	mov    %edx,(%esp)
  801e96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e9e:	8b 14 24             	mov    (%esp),%edx
  801ea1:	83 c4 1c             	add    $0x1c,%esp
  801ea4:	5b                   	pop    %ebx
  801ea5:	5e                   	pop    %esi
  801ea6:	5f                   	pop    %edi
  801ea7:	5d                   	pop    %ebp
  801ea8:	c3                   	ret    
  801ea9:	8d 76 00             	lea    0x0(%esi),%esi
  801eac:	2b 04 24             	sub    (%esp),%eax
  801eaf:	19 fa                	sbb    %edi,%edx
  801eb1:	89 d1                	mov    %edx,%ecx
  801eb3:	89 c6                	mov    %eax,%esi
  801eb5:	e9 71 ff ff ff       	jmp    801e2b <__umoddi3+0xb3>
  801eba:	66 90                	xchg   %ax,%ax
  801ebc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ec0:	72 ea                	jb     801eac <__umoddi3+0x134>
  801ec2:	89 d9                	mov    %ebx,%ecx
  801ec4:	e9 62 ff ff ff       	jmp    801e2b <__umoddi3+0xb3>
