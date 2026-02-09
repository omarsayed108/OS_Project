
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 5d 02 00 00       	call   800293 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
extern volatile bool printStats;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	printStats = 0;
  80003e:	c7 05 00 50 80 00 00 	movl   $0x0,0x805000
  800045:	00 00 00 

	int32 parentenvID = sys_getparentenvid();
  800048:	e8 c4 23 00 00       	call   802411 <sys_getparentenvid>
  80004d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	68 a0 3a 80 00       	push   $0x803aa0
  800058:	ff 75 ec             	pushl  -0x14(%ebp)
  80005b:	e8 0e 1f 00 00       	call   801f6e <sget>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int *protType = sget(parentenvID, "protType") ;
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	68 a2 3a 80 00       	push   $0x803aa2
  80006e:	ff 75 ec             	pushl  -0x14(%ebp)
  800071:	e8 f8 1e 00 00       	call   801f6e <sget>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int * finishedCount = sget(parentenvID, "finishedCount") ;
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	68 ab 3a 80 00       	push   $0x803aab
  800084:	ff 75 ec             	pushl  -0x14(%ebp)
  800087:	e8 e2 1e 00 00       	call   801f6e <sget>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	struct semaphore T, finished, finishedCountMutex ;
	struct uspinlock *sT, *sfinishedCountMutex;

	if (*protType == 1)
  800092:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800095:	8b 00                	mov    (%eax),%eax
  800097:	83 f8 01             	cmp    $0x1,%eax
  80009a:	75 47                	jne    8000e3 <_main+0xab>
	{
		T = get_semaphore(parentenvID, "T");
  80009c:	8d 45 bc             	lea    -0x44(%ebp),%eax
  80009f:	83 ec 04             	sub    $0x4,%esp
  8000a2:	68 b9 3a 80 00       	push   $0x803ab9
  8000a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8000aa:	50                   	push   %eax
  8000ab:	e8 46 33 00 00       	call   8033f6 <get_semaphore>
  8000b0:	83 c4 0c             	add    $0xc,%esp
		finished = get_semaphore(parentenvID, "finished");
  8000b3:	8d 45 b8             	lea    -0x48(%ebp),%eax
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	68 bb 3a 80 00       	push   $0x803abb
  8000be:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c1:	50                   	push   %eax
  8000c2:	e8 2f 33 00 00       	call   8033f6 <get_semaphore>
  8000c7:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = get_semaphore(parentenvID, "finishedCountMutex");
  8000ca:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 c4 3a 80 00       	push   $0x803ac4
  8000d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d8:	50                   	push   %eax
  8000d9:	e8 18 33 00 00       	call   8033f6 <get_semaphore>
  8000de:	83 c4 0c             	add    $0xc,%esp
  8000e1:	eb 36                	jmp    800119 <_main+0xe1>
	}
	else if (*protType == 2)
  8000e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e6:	8b 00                	mov    (%eax),%eax
  8000e8:	83 f8 02             	cmp    $0x2,%eax
  8000eb:	75 2c                	jne    800119 <_main+0xe1>
	{
		sT = sget(parentenvID, "T");
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	68 b9 3a 80 00       	push   $0x803ab9
  8000f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f8:	e8 71 1e 00 00       	call   801f6e <sget>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 f4             	mov    %eax,-0xc(%ebp)
		sfinishedCountMutex = sget(parentenvID, "finishedCountMutex");
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	68 c4 3a 80 00       	push   $0x803ac4
  80010b:	ff 75 ec             	pushl  -0x14(%ebp)
  80010e:	e8 5b 1e 00 00       	call   801f6e <sget>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	/*[2] DO THE JOB*/
	int Z ;
	if (*protType == 1)
  800119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	83 f8 01             	cmp    $0x1,%eax
  800121:	75 10                	jne    800133 <_main+0xfb>
	{
		wait_semaphore(T);
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	ff 75 bc             	pushl  -0x44(%ebp)
  800129:	e8 e2 32 00 00       	call   803410 <wait_semaphore>
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	eb 18                	jmp    80014b <_main+0x113>
	}
	else if (*protType == 2)
  800133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800136:	8b 00                	mov    (%eax),%eax
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	75 0e                	jne    80014b <_main+0x113>
	{
		acquire_uspinlock(sT);
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	ff 75 f4             	pushl  -0xc(%ebp)
  800143:	e8 14 34 00 00       	call   80355c <acquire_uspinlock>
  800148:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  80014b:	8d 45 c0             	lea    -0x40(%ebp),%eax
  80014e:	83 ec 0c             	sub    $0xc,%esp
  800151:	50                   	push   %eax
  800152:	e8 ed 22 00 00       	call   802444 <sys_get_virtual_time>
  800157:	83 c4 0c             	add    $0xc,%esp
  80015a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80015d:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  800162:	ba 00 00 00 00       	mov    $0x0,%edx
  800167:	f7 f1                	div    %ecx
  800169:	89 d0                	mov    %edx,%eax
  80016b:	05 d0 07 00 00       	add    $0x7d0,%eax
  800170:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  800173:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	50                   	push   %eax
  80017a:	e8 d0 32 00 00       	call   80344f <env_sleep>
  80017f:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  800182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800185:	8b 00                	mov    (%eax),%eax
  800187:	40                   	inc    %eax
  800188:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  80018b:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	50                   	push   %eax
  800192:	e8 ad 22 00 00       	call   802444 <sys_get_virtual_time>
  800197:	83 c4 0c             	add    $0xc,%esp
  80019a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80019d:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8001a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a7:	f7 f1                	div    %ecx
  8001a9:	89 d0                	mov    %edx,%eax
  8001ab:	05 d0 07 00 00       	add    $0x7d0,%eax
  8001b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  8001b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	50                   	push   %eax
  8001ba:	e8 90 32 00 00       	call   80344f <env_sleep>
  8001bf:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  8001c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001c8:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  8001ca:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	50                   	push   %eax
  8001d1:	e8 6e 22 00 00       	call   802444 <sys_get_virtual_time>
  8001d6:	83 c4 0c             	add    $0xc,%esp
  8001d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001dc:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8001e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8001e6:	f7 f1                	div    %ecx
  8001e8:	89 d0                	mov    %edx,%eax
  8001ea:	05 d0 07 00 00       	add    $0x7d0,%eax
  8001ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  8001f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	e8 51 32 00 00       	call   80344f <env_sleep>
  8001fe:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	if (*protType == 1)
  800201:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800204:	8b 00                	mov    (%eax),%eax
  800206:	83 f8 01             	cmp    $0x1,%eax
  800209:	75 39                	jne    800244 <_main+0x20c>
	{
		signal_semaphore(finished);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 b8             	pushl  -0x48(%ebp)
  800211:	e8 14 32 00 00       	call   80342a <signal_semaphore>
  800216:	83 c4 10             	add    $0x10,%esp

		wait_semaphore(finishedCountMutex);
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80021f:	e8 ec 31 00 00       	call   803410 <wait_semaphore>
  800224:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  800227:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022a:	8b 00                	mov    (%eax),%eax
  80022c:	8d 50 01             	lea    0x1(%eax),%edx
  80022f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800232:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(finishedCountMutex);
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	ff 75 b4             	pushl  -0x4c(%ebp)
  80023a:	e8 eb 31 00 00       	call   80342a <signal_semaphore>
  80023f:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
		}
		sys_unlock_cons();
	}
}
  800242:	eb 4c                	jmp    800290 <_main+0x258>
		{
			(*finishedCount)++ ;
		}
		signal_semaphore(finishedCountMutex);
	}
	else if (*protType == 2)
  800244:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800247:	8b 00                	mov    (%eax),%eax
  800249:	83 f8 02             	cmp    $0x2,%eax
  80024c:	75 2b                	jne    800279 <_main+0x241>
	{
		acquire_uspinlock(sfinishedCountMutex);
  80024e:	83 ec 0c             	sub    $0xc,%esp
  800251:	ff 75 f0             	pushl  -0x10(%ebp)
  800254:	e8 03 33 00 00       	call   80355c <acquire_uspinlock>
  800259:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  80025c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80025f:	8b 00                	mov    (%eax),%eax
  800261:	8d 50 01             	lea    0x1(%eax),%edx
  800264:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800267:	89 10                	mov    %edx,(%eax)
		}
		release_uspinlock(sfinishedCountMutex);
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	ff 75 f0             	pushl  -0x10(%ebp)
  80026f:	e8 40 33 00 00       	call   8035b4 <release_uspinlock>
  800274:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
		}
		sys_unlock_cons();
	}
}
  800277:	eb 17                	jmp    800290 <_main+0x258>
			(*finishedCount)++ ;
		}
		release_uspinlock(sfinishedCountMutex);
	}else
	{
		sys_lock_cons();
  800279:	e8 01 1f 00 00       	call   80217f <sys_lock_cons>
		{
			(*finishedCount)++ ;
  80027e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800281:	8b 00                	mov    (%eax),%eax
  800283:	8d 50 01             	lea    0x1(%eax),%edx
  800286:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800289:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80028b:	e8 09 1f 00 00       	call   802199 <sys_unlock_cons>
	}
}
  800290:	90                   	nop
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	57                   	push   %edi
  800297:	56                   	push   %esi
  800298:	53                   	push   %ebx
  800299:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80029c:	e8 57 21 00 00       	call   8023f8 <sys_getenvindex>
  8002a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a7:	89 d0                	mov    %edx,%eax
  8002a9:	01 c0                	add    %eax,%eax
  8002ab:	01 d0                	add    %edx,%eax
  8002ad:	c1 e0 02             	shl    $0x2,%eax
  8002b0:	01 d0                	add    %edx,%eax
  8002b2:	c1 e0 02             	shl    $0x2,%eax
  8002b5:	01 d0                	add    %edx,%eax
  8002b7:	c1 e0 03             	shl    $0x3,%eax
  8002ba:	01 d0                	add    %edx,%eax
  8002bc:	c1 e0 02             	shl    $0x2,%eax
  8002bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002c4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ce:	8a 40 20             	mov    0x20(%eax),%al
  8002d1:	84 c0                	test   %al,%al
  8002d3:	74 0d                	je     8002e2 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8002da:	83 c0 20             	add    $0x20,%eax
  8002dd:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002e6:	7e 0a                	jle    8002f2 <libmain+0x5f>
		binaryname = argv[0];
  8002e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8002f2:	83 ec 08             	sub    $0x8,%esp
  8002f5:	ff 75 0c             	pushl  0xc(%ebp)
  8002f8:	ff 75 08             	pushl  0x8(%ebp)
  8002fb:	e8 38 fd ff ff       	call   800038 <_main>
  800300:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800303:	a1 00 50 80 00       	mov    0x805000,%eax
  800308:	85 c0                	test   %eax,%eax
  80030a:	0f 84 01 01 00 00    	je     800411 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800310:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800316:	bb d0 3b 80 00       	mov    $0x803bd0,%ebx
  80031b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800320:	89 c7                	mov    %eax,%edi
  800322:	89 de                	mov    %ebx,%esi
  800324:	89 d1                	mov    %edx,%ecx
  800326:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800328:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80032b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800330:	b0 00                	mov    $0x0,%al
  800332:	89 d7                	mov    %edx,%edi
  800334:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800336:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80033d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800340:	83 ec 08             	sub    $0x8,%esp
  800343:	50                   	push   %eax
  800344:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80034a:	50                   	push   %eax
  80034b:	e8 de 22 00 00       	call   80262e <sys_utilities>
  800350:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800353:	e8 27 1e 00 00       	call   80217f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800358:	83 ec 0c             	sub    $0xc,%esp
  80035b:	68 f0 3a 80 00       	push   $0x803af0
  800360:	e8 be 01 00 00       	call   800523 <cprintf>
  800365:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036b:	85 c0                	test   %eax,%eax
  80036d:	74 18                	je     800387 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80036f:	e8 d8 22 00 00       	call   80264c <sys_get_optimal_num_faults>
  800374:	83 ec 08             	sub    $0x8,%esp
  800377:	50                   	push   %eax
  800378:	68 18 3b 80 00       	push   $0x803b18
  80037d:	e8 a1 01 00 00       	call   800523 <cprintf>
  800382:	83 c4 10             	add    $0x10,%esp
  800385:	eb 59                	jmp    8003e0 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800387:	a1 20 50 80 00       	mov    0x805020,%eax
  80038c:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800392:	a1 20 50 80 00       	mov    0x805020,%eax
  800397:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	52                   	push   %edx
  8003a1:	50                   	push   %eax
  8003a2:	68 3c 3b 80 00       	push   $0x803b3c
  8003a7:	e8 77 01 00 00       	call   800523 <cprintf>
  8003ac:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003af:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b4:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8003ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8003bf:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8003c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ca:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8003d0:	51                   	push   %ecx
  8003d1:	52                   	push   %edx
  8003d2:	50                   	push   %eax
  8003d3:	68 64 3b 80 00       	push   $0x803b64
  8003d8:	e8 46 01 00 00       	call   800523 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e5:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	50                   	push   %eax
  8003ef:	68 bc 3b 80 00       	push   $0x803bbc
  8003f4:	e8 2a 01 00 00       	call   800523 <cprintf>
  8003f9:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003fc:	83 ec 0c             	sub    $0xc,%esp
  8003ff:	68 f0 3a 80 00       	push   $0x803af0
  800404:	e8 1a 01 00 00       	call   800523 <cprintf>
  800409:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80040c:	e8 88 1d 00 00       	call   802199 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800411:	e8 1f 00 00 00       	call   800435 <exit>
}
  800416:	90                   	nop
  800417:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80041a:	5b                   	pop    %ebx
  80041b:	5e                   	pop    %esi
  80041c:	5f                   	pop    %edi
  80041d:	5d                   	pop    %ebp
  80041e:	c3                   	ret    

0080041f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80041f:	55                   	push   %ebp
  800420:	89 e5                	mov    %esp,%ebp
  800422:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800425:	83 ec 0c             	sub    $0xc,%esp
  800428:	6a 00                	push   $0x0
  80042a:	e8 95 1f 00 00       	call   8023c4 <sys_destroy_env>
  80042f:	83 c4 10             	add    $0x10,%esp
}
  800432:	90                   	nop
  800433:	c9                   	leave  
  800434:	c3                   	ret    

00800435 <exit>:

void
exit(void)
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
  800438:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80043b:	e8 ea 1f 00 00       	call   80242a <sys_exit_env>
}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	53                   	push   %ebx
  800447:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80044a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	8d 48 01             	lea    0x1(%eax),%ecx
  800452:	8b 55 0c             	mov    0xc(%ebp),%edx
  800455:	89 0a                	mov    %ecx,(%edx)
  800457:	8b 55 08             	mov    0x8(%ebp),%edx
  80045a:	88 d1                	mov    %dl,%cl
  80045c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800463:	8b 45 0c             	mov    0xc(%ebp),%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	3d ff 00 00 00       	cmp    $0xff,%eax
  80046d:	75 30                	jne    80049f <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80046f:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  800475:	a0 44 50 80 00       	mov    0x805044,%al
  80047a:	0f b6 c0             	movzbl %al,%eax
  80047d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800480:	8b 09                	mov    (%ecx),%ecx
  800482:	89 cb                	mov    %ecx,%ebx
  800484:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800487:	83 c1 08             	add    $0x8,%ecx
  80048a:	52                   	push   %edx
  80048b:	50                   	push   %eax
  80048c:	53                   	push   %ebx
  80048d:	51                   	push   %ecx
  80048e:	e8 a8 1c 00 00       	call   80213b <sys_cputs>
  800493:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800496:	8b 45 0c             	mov    0xc(%ebp),%eax
  800499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	8b 40 04             	mov    0x4(%eax),%eax
  8004a5:	8d 50 01             	lea    0x1(%eax),%edx
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004ae:	90                   	nop
  8004af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c4:	00 00 00 
	b.cnt = 0;
  8004c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004ce:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d1:	ff 75 0c             	pushl  0xc(%ebp)
  8004d4:	ff 75 08             	pushl  0x8(%ebp)
  8004d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004dd:	50                   	push   %eax
  8004de:	68 43 04 80 00       	push   $0x800443
  8004e3:	e8 5a 02 00 00       	call   800742 <vprintfmt>
  8004e8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004eb:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  8004f1:	a0 44 50 80 00       	mov    0x805044,%al
  8004f6:	0f b6 c0             	movzbl %al,%eax
  8004f9:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004ff:	52                   	push   %edx
  800500:	50                   	push   %eax
  800501:	51                   	push   %ecx
  800502:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800508:	83 c0 08             	add    $0x8,%eax
  80050b:	50                   	push   %eax
  80050c:	e8 2a 1c 00 00       	call   80213b <sys_cputs>
  800511:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800514:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  80051b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800521:	c9                   	leave  
  800522:	c3                   	ret    

00800523 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800529:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800530:	8d 45 0c             	lea    0xc(%ebp),%eax
  800533:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800536:	8b 45 08             	mov    0x8(%ebp),%eax
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	ff 75 f4             	pushl  -0xc(%ebp)
  80053f:	50                   	push   %eax
  800540:	e8 6f ff ff ff       	call   8004b4 <vcprintf>
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054e:	c9                   	leave  
  80054f:	c3                   	ret    

00800550 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800556:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	c1 e0 08             	shl    $0x8,%eax
  800563:	a3 18 d1 81 00       	mov    %eax,0x81d118
	va_start(ap, fmt);
  800568:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056b:	83 c0 04             	add    $0x4,%eax
  80056e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800571:	8b 45 0c             	mov    0xc(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	50                   	push   %eax
  80057b:	e8 34 ff ff ff       	call   8004b4 <vcprintf>
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800586:	c7 05 18 d1 81 00 00 	movl   $0x700,0x81d118
  80058d:	07 00 00 

	return cnt;
  800590:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800593:	c9                   	leave  
  800594:	c3                   	ret    

00800595 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800595:	55                   	push   %ebp
  800596:	89 e5                	mov    %esp,%ebp
  800598:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80059b:	e8 df 1b 00 00       	call   80217f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005a0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8005af:	50                   	push   %eax
  8005b0:	e8 ff fe ff ff       	call   8004b4 <vcprintf>
  8005b5:	83 c4 10             	add    $0x10,%esp
  8005b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005bb:	e8 d9 1b 00 00       	call   802199 <sys_unlock_cons>
	return cnt;
  8005c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c3:	c9                   	leave  
  8005c4:	c3                   	ret    

008005c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c5:	55                   	push   %ebp
  8005c6:	89 e5                	mov    %esp,%ebp
  8005c8:	53                   	push   %ebx
  8005c9:	83 ec 14             	sub    $0x14,%esp
  8005cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d8:	8b 45 18             	mov    0x18(%ebp),%eax
  8005db:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e3:	77 55                	ja     80063a <printnum+0x75>
  8005e5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e8:	72 05                	jb     8005ef <printnum+0x2a>
  8005ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ed:	77 4b                	ja     80063a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ef:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fd:	52                   	push   %edx
  8005fe:	50                   	push   %eax
  8005ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800602:	ff 75 f0             	pushl  -0x10(%ebp)
  800605:	e8 1a 32 00 00       	call   803824 <__udivdi3>
  80060a:	83 c4 10             	add    $0x10,%esp
  80060d:	83 ec 04             	sub    $0x4,%esp
  800610:	ff 75 20             	pushl  0x20(%ebp)
  800613:	53                   	push   %ebx
  800614:	ff 75 18             	pushl  0x18(%ebp)
  800617:	52                   	push   %edx
  800618:	50                   	push   %eax
  800619:	ff 75 0c             	pushl  0xc(%ebp)
  80061c:	ff 75 08             	pushl  0x8(%ebp)
  80061f:	e8 a1 ff ff ff       	call   8005c5 <printnum>
  800624:	83 c4 20             	add    $0x20,%esp
  800627:	eb 1a                	jmp    800643 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800629:	83 ec 08             	sub    $0x8,%esp
  80062c:	ff 75 0c             	pushl  0xc(%ebp)
  80062f:	ff 75 20             	pushl  0x20(%ebp)
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	ff d0                	call   *%eax
  800637:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063a:	ff 4d 1c             	decl   0x1c(%ebp)
  80063d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800641:	7f e6                	jg     800629 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800643:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800646:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800651:	53                   	push   %ebx
  800652:	51                   	push   %ecx
  800653:	52                   	push   %edx
  800654:	50                   	push   %eax
  800655:	e8 da 32 00 00       	call   803934 <__umoddi3>
  80065a:	83 c4 10             	add    $0x10,%esp
  80065d:	05 54 3e 80 00       	add    $0x803e54,%eax
  800662:	8a 00                	mov    (%eax),%al
  800664:	0f be c0             	movsbl %al,%eax
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 0c             	pushl  0xc(%ebp)
  80066d:	50                   	push   %eax
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	ff d0                	call   *%eax
  800673:	83 c4 10             	add    $0x10,%esp
}
  800676:	90                   	nop
  800677:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067a:	c9                   	leave  
  80067b:	c3                   	ret    

0080067c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800683:	7e 1c                	jle    8006a1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	8d 50 08             	lea    0x8(%eax),%edx
  80068d:	8b 45 08             	mov    0x8(%ebp),%eax
  800690:	89 10                	mov    %edx,(%eax)
  800692:	8b 45 08             	mov    0x8(%ebp),%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	83 e8 08             	sub    $0x8,%eax
  80069a:	8b 50 04             	mov    0x4(%eax),%edx
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	eb 40                	jmp    8006e1 <getuint+0x65>
	else if (lflag)
  8006a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a5:	74 1e                	je     8006c5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	8d 50 04             	lea    0x4(%eax),%edx
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	89 10                	mov    %edx,(%eax)
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	83 e8 04             	sub    $0x4,%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c3:	eb 1c                	jmp    8006e1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	8d 50 04             	lea    0x4(%eax),%edx
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	89 10                	mov    %edx,(%eax)
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	83 e8 04             	sub    $0x4,%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e1:	5d                   	pop    %ebp
  8006e2:	c3                   	ret    

008006e3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ea:	7e 1c                	jle    800708 <getint+0x25>
		return va_arg(*ap, long long);
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	8d 50 08             	lea    0x8(%eax),%edx
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	89 10                	mov    %edx,(%eax)
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	83 e8 08             	sub    $0x8,%eax
  800701:	8b 50 04             	mov    0x4(%eax),%edx
  800704:	8b 00                	mov    (%eax),%eax
  800706:	eb 38                	jmp    800740 <getint+0x5d>
	else if (lflag)
  800708:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070c:	74 1a                	je     800728 <getint+0x45>
		return va_arg(*ap, long);
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	8b 00                	mov    (%eax),%eax
  800713:	8d 50 04             	lea    0x4(%eax),%edx
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	89 10                	mov    %edx,(%eax)
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	83 e8 04             	sub    $0x4,%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	99                   	cltd   
  800726:	eb 18                	jmp    800740 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	99                   	cltd   
}
  800740:	5d                   	pop    %ebp
  800741:	c3                   	ret    

00800742 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	56                   	push   %esi
  800746:	53                   	push   %ebx
  800747:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074a:	eb 17                	jmp    800763 <vprintfmt+0x21>
			if (ch == '\0')
  80074c:	85 db                	test   %ebx,%ebx
  80074e:	0f 84 c1 03 00 00    	je     800b15 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	53                   	push   %ebx
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	ff d0                	call   *%eax
  800760:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800763:	8b 45 10             	mov    0x10(%ebp),%eax
  800766:	8d 50 01             	lea    0x1(%eax),%edx
  800769:	89 55 10             	mov    %edx,0x10(%ebp)
  80076c:	8a 00                	mov    (%eax),%al
  80076e:	0f b6 d8             	movzbl %al,%ebx
  800771:	83 fb 25             	cmp    $0x25,%ebx
  800774:	75 d6                	jne    80074c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800776:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800781:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800788:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80078f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800796:	8b 45 10             	mov    0x10(%ebp),%eax
  800799:	8d 50 01             	lea    0x1(%eax),%edx
  80079c:	89 55 10             	mov    %edx,0x10(%ebp)
  80079f:	8a 00                	mov    (%eax),%al
  8007a1:	0f b6 d8             	movzbl %al,%ebx
  8007a4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a7:	83 f8 5b             	cmp    $0x5b,%eax
  8007aa:	0f 87 3d 03 00 00    	ja     800aed <vprintfmt+0x3ab>
  8007b0:	8b 04 85 78 3e 80 00 	mov    0x803e78(,%eax,4),%eax
  8007b7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bd:	eb d7                	jmp    800796 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bf:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c3:	eb d1                	jmp    800796 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007cf:	89 d0                	mov    %edx,%eax
  8007d1:	c1 e0 02             	shl    $0x2,%eax
  8007d4:	01 d0                	add    %edx,%eax
  8007d6:	01 c0                	add    %eax,%eax
  8007d8:	01 d8                	add    %ebx,%eax
  8007da:	83 e8 30             	sub    $0x30,%eax
  8007dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e3:	8a 00                	mov    (%eax),%al
  8007e5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e8:	83 fb 2f             	cmp    $0x2f,%ebx
  8007eb:	7e 3e                	jle    80082b <vprintfmt+0xe9>
  8007ed:	83 fb 39             	cmp    $0x39,%ebx
  8007f0:	7f 39                	jg     80082b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f5:	eb d5                	jmp    8007cc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 c0 04             	add    $0x4,%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 e8 04             	sub    $0x4,%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080b:	eb 1f                	jmp    80082c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800811:	79 83                	jns    800796 <vprintfmt+0x54>
				width = 0;
  800813:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081a:	e9 77 ff ff ff       	jmp    800796 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80081f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800826:	e9 6b ff ff ff       	jmp    800796 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800830:	0f 89 60 ff ff ff    	jns    800796 <vprintfmt+0x54>
				width = precision, precision = -1;
  800836:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800839:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800843:	e9 4e ff ff ff       	jmp    800796 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800848:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084b:	e9 46 ff ff ff       	jmp    800796 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	83 c0 04             	add    $0x4,%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 e8 04             	sub    $0x4,%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	50                   	push   %eax
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	ff d0                	call   *%eax
  80086d:	83 c4 10             	add    $0x10,%esp
			break;
  800870:	e9 9b 02 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800886:	85 db                	test   %ebx,%ebx
  800888:	79 02                	jns    80088c <vprintfmt+0x14a>
				err = -err;
  80088a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088c:	83 fb 64             	cmp    $0x64,%ebx
  80088f:	7f 0b                	jg     80089c <vprintfmt+0x15a>
  800891:	8b 34 9d c0 3c 80 00 	mov    0x803cc0(,%ebx,4),%esi
  800898:	85 f6                	test   %esi,%esi
  80089a:	75 19                	jne    8008b5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089c:	53                   	push   %ebx
  80089d:	68 65 3e 80 00       	push   $0x803e65
  8008a2:	ff 75 0c             	pushl  0xc(%ebp)
  8008a5:	ff 75 08             	pushl  0x8(%ebp)
  8008a8:	e8 70 02 00 00       	call   800b1d <printfmt>
  8008ad:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b0:	e9 5b 02 00 00       	jmp    800b10 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b5:	56                   	push   %esi
  8008b6:	68 6e 3e 80 00       	push   $0x803e6e
  8008bb:	ff 75 0c             	pushl  0xc(%ebp)
  8008be:	ff 75 08             	pushl  0x8(%ebp)
  8008c1:	e8 57 02 00 00       	call   800b1d <printfmt>
  8008c6:	83 c4 10             	add    $0x10,%esp
			break;
  8008c9:	e9 42 02 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	83 c0 04             	add    $0x4,%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 e8 04             	sub    $0x4,%eax
  8008dd:	8b 30                	mov    (%eax),%esi
  8008df:	85 f6                	test   %esi,%esi
  8008e1:	75 05                	jne    8008e8 <vprintfmt+0x1a6>
				p = "(null)";
  8008e3:	be 71 3e 80 00       	mov    $0x803e71,%esi
			if (width > 0 && padc != '-')
  8008e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ec:	7e 6d                	jle    80095b <vprintfmt+0x219>
  8008ee:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f2:	74 67                	je     80095b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	50                   	push   %eax
  8008fb:	56                   	push   %esi
  8008fc:	e8 1e 03 00 00       	call   800c1f <strnlen>
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800907:	eb 16                	jmp    80091f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800909:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	ff 75 0c             	pushl  0xc(%ebp)
  800913:	50                   	push   %eax
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	ff d0                	call   *%eax
  800919:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091c:	ff 4d e4             	decl   -0x1c(%ebp)
  80091f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800923:	7f e4                	jg     800909 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800925:	eb 34                	jmp    80095b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800927:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092b:	74 1c                	je     800949 <vprintfmt+0x207>
  80092d:	83 fb 1f             	cmp    $0x1f,%ebx
  800930:	7e 05                	jle    800937 <vprintfmt+0x1f5>
  800932:	83 fb 7e             	cmp    $0x7e,%ebx
  800935:	7e 12                	jle    800949 <vprintfmt+0x207>
					putch('?', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 3f                	push   $0x3f
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
  800947:	eb 0f                	jmp    800958 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800949:	83 ec 08             	sub    $0x8,%esp
  80094c:	ff 75 0c             	pushl  0xc(%ebp)
  80094f:	53                   	push   %ebx
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800958:	ff 4d e4             	decl   -0x1c(%ebp)
  80095b:	89 f0                	mov    %esi,%eax
  80095d:	8d 70 01             	lea    0x1(%eax),%esi
  800960:	8a 00                	mov    (%eax),%al
  800962:	0f be d8             	movsbl %al,%ebx
  800965:	85 db                	test   %ebx,%ebx
  800967:	74 24                	je     80098d <vprintfmt+0x24b>
  800969:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096d:	78 b8                	js     800927 <vprintfmt+0x1e5>
  80096f:	ff 4d e0             	decl   -0x20(%ebp)
  800972:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800976:	79 af                	jns    800927 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800978:	eb 13                	jmp    80098d <vprintfmt+0x24b>
				putch(' ', putdat);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	ff 75 0c             	pushl  0xc(%ebp)
  800980:	6a 20                	push   $0x20
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	ff d0                	call   *%eax
  800987:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098a:	ff 4d e4             	decl   -0x1c(%ebp)
  80098d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800991:	7f e7                	jg     80097a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800993:	e9 78 01 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 e8             	pushl  -0x18(%ebp)
  80099e:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a1:	50                   	push   %eax
  8009a2:	e8 3c fd ff ff       	call   8006e3 <getint>
  8009a7:	83 c4 10             	add    $0x10,%esp
  8009aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b6:	85 d2                	test   %edx,%edx
  8009b8:	79 23                	jns    8009dd <vprintfmt+0x29b>
				putch('-', putdat);
  8009ba:	83 ec 08             	sub    $0x8,%esp
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	6a 2d                	push   $0x2d
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d0:	f7 d8                	neg    %eax
  8009d2:	83 d2 00             	adc    $0x0,%edx
  8009d5:	f7 da                	neg    %edx
  8009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e4:	e9 bc 00 00 00       	jmp    800aa5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ef:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f2:	50                   	push   %eax
  8009f3:	e8 84 fc ff ff       	call   80067c <getuint>
  8009f8:	83 c4 10             	add    $0x10,%esp
  8009fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a01:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a08:	e9 98 00 00 00       	jmp    800aa5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 58                	push   $0x58
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 58                	push   $0x58
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 0c             	pushl  0xc(%ebp)
  800a33:	6a 58                	push   $0x58
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	ff d0                	call   *%eax
  800a3a:	83 c4 10             	add    $0x10,%esp
			break;
  800a3d:	e9 ce 00 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 30                	push   $0x30
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 78                	push   $0x78
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a62:	8b 45 14             	mov    0x14(%ebp),%eax
  800a65:	83 c0 04             	add    $0x4,%eax
  800a68:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	83 e8 04             	sub    $0x4,%eax
  800a71:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a84:	eb 1f                	jmp    800aa5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8f:	50                   	push   %eax
  800a90:	e8 e7 fb ff ff       	call   80067c <getuint>
  800a95:	83 c4 10             	add    $0x10,%esp
  800a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	52                   	push   %edx
  800ab0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab3:	50                   	push   %eax
  800ab4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab7:	ff 75 f0             	pushl  -0x10(%ebp)
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	ff 75 08             	pushl  0x8(%ebp)
  800ac0:	e8 00 fb ff ff       	call   8005c5 <printnum>
  800ac5:	83 c4 20             	add    $0x20,%esp
			break;
  800ac8:	eb 46                	jmp    800b10 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	ff 75 0c             	pushl  0xc(%ebp)
  800ad0:	53                   	push   %ebx
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	ff d0                	call   *%eax
  800ad6:	83 c4 10             	add    $0x10,%esp
			break;
  800ad9:	eb 35                	jmp    800b10 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800adb:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800ae2:	eb 2c                	jmp    800b10 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ae4:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800aeb:	eb 23                	jmp    800b10 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aed:	83 ec 08             	sub    $0x8,%esp
  800af0:	ff 75 0c             	pushl  0xc(%ebp)
  800af3:	6a 25                	push   $0x25
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	ff d0                	call   *%eax
  800afa:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800afd:	ff 4d 10             	decl   0x10(%ebp)
  800b00:	eb 03                	jmp    800b05 <vprintfmt+0x3c3>
  800b02:	ff 4d 10             	decl   0x10(%ebp)
  800b05:	8b 45 10             	mov    0x10(%ebp),%eax
  800b08:	48                   	dec    %eax
  800b09:	8a 00                	mov    (%eax),%al
  800b0b:	3c 25                	cmp    $0x25,%al
  800b0d:	75 f3                	jne    800b02 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b0f:	90                   	nop
		}
	}
  800b10:	e9 35 fc ff ff       	jmp    80074a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b15:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b19:	5b                   	pop    %ebx
  800b1a:	5e                   	pop    %esi
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b23:	8d 45 10             	lea    0x10(%ebp),%eax
  800b26:	83 c0 04             	add    $0x4,%eax
  800b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b32:	50                   	push   %eax
  800b33:	ff 75 0c             	pushl  0xc(%ebp)
  800b36:	ff 75 08             	pushl  0x8(%ebp)
  800b39:	e8 04 fc ff ff       	call   800742 <vprintfmt>
  800b3e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b41:	90                   	nop
  800b42:	c9                   	leave  
  800b43:	c3                   	ret    

00800b44 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8b 40 08             	mov    0x8(%eax),%eax
  800b4d:	8d 50 01             	lea    0x1(%eax),%edx
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	8b 10                	mov    (%eax),%edx
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	8b 40 04             	mov    0x4(%eax),%eax
  800b61:	39 c2                	cmp    %eax,%edx
  800b63:	73 12                	jae    800b77 <sprintputch+0x33>
		*b->buf++ = ch;
  800b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b68:	8b 00                	mov    (%eax),%eax
  800b6a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b70:	89 0a                	mov    %ecx,(%edx)
  800b72:	8b 55 08             	mov    0x8(%ebp),%edx
  800b75:	88 10                	mov    %dl,(%eax)
}
  800b77:	90                   	nop
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	01 d0                	add    %edx,%eax
  800b91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b9f:	74 06                	je     800ba7 <vsnprintf+0x2d>
  800ba1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba5:	7f 07                	jg     800bae <vsnprintf+0x34>
		return -E_INVAL;
  800ba7:	b8 03 00 00 00       	mov    $0x3,%eax
  800bac:	eb 20                	jmp    800bce <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bae:	ff 75 14             	pushl  0x14(%ebp)
  800bb1:	ff 75 10             	pushl  0x10(%ebp)
  800bb4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb7:	50                   	push   %eax
  800bb8:	68 44 0b 80 00       	push   $0x800b44
  800bbd:	e8 80 fb ff ff       	call   800742 <vprintfmt>
  800bc2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    

00800bd0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd9:	83 c0 04             	add    $0x4,%eax
  800bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800be2:	ff 75 f4             	pushl  -0xc(%ebp)
  800be5:	50                   	push   %eax
  800be6:	ff 75 0c             	pushl  0xc(%ebp)
  800be9:	ff 75 08             	pushl  0x8(%ebp)
  800bec:	e8 89 ff ff ff       	call   800b7a <vsnprintf>
  800bf1:	83 c4 10             	add    $0x10,%esp
  800bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c09:	eb 06                	jmp    800c11 <strlen+0x15>
		n++;
  800c0b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0e:	ff 45 08             	incl   0x8(%ebp)
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8a 00                	mov    (%eax),%al
  800c16:	84 c0                	test   %al,%al
  800c18:	75 f1                	jne    800c0b <strlen+0xf>
		n++;
	return n;
  800c1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2c:	eb 09                	jmp    800c37 <strnlen+0x18>
		n++;
  800c2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c31:	ff 45 08             	incl   0x8(%ebp)
  800c34:	ff 4d 0c             	decl   0xc(%ebp)
  800c37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3b:	74 09                	je     800c46 <strnlen+0x27>
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	84 c0                	test   %al,%al
  800c44:	75 e8                	jne    800c2e <strnlen+0xf>
		n++;
	return n;
  800c46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c57:	90                   	nop
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8d 50 01             	lea    0x1(%eax),%edx
  800c5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c67:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c6a:	8a 12                	mov    (%edx),%dl
  800c6c:	88 10                	mov    %dl,(%eax)
  800c6e:	8a 00                	mov    (%eax),%al
  800c70:	84 c0                	test   %al,%al
  800c72:	75 e4                	jne    800c58 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c77:	c9                   	leave  
  800c78:	c3                   	ret    

00800c79 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8c:	eb 1f                	jmp    800cad <strncpy+0x34>
		*dst++ = *src;
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8d 50 01             	lea    0x1(%eax),%edx
  800c94:	89 55 08             	mov    %edx,0x8(%ebp)
  800c97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9a:	8a 12                	mov    (%edx),%dl
  800c9c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	84 c0                	test   %al,%al
  800ca5:	74 03                	je     800caa <strncpy+0x31>
			src++;
  800ca7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800caa:	ff 45 fc             	incl   -0x4(%ebp)
  800cad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cb3:	72 d9                	jb     800c8e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cca:	74 30                	je     800cfc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ccc:	eb 16                	jmp    800ce4 <strlcpy+0x2a>
			*dst++ = *src++;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8d 50 01             	lea    0x1(%eax),%edx
  800cd4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cda:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cdd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce0:	8a 12                	mov    (%edx),%dl
  800ce2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ce4:	ff 4d 10             	decl   0x10(%ebp)
  800ce7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ceb:	74 09                	je     800cf6 <strlcpy+0x3c>
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	84 c0                	test   %al,%al
  800cf4:	75 d8                	jne    800cce <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d02:	29 c2                	sub    %eax,%edx
  800d04:	89 d0                	mov    %edx,%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d0b:	eb 06                	jmp    800d13 <strcmp+0xb>
		p++, q++;
  800d0d:	ff 45 08             	incl   0x8(%ebp)
  800d10:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	74 0e                	je     800d2a <strcmp+0x22>
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8a 10                	mov    (%eax),%dl
  800d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	38 c2                	cmp    %al,%dl
  800d28:	74 e3                	je     800d0d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8a 00                	mov    (%eax),%al
  800d2f:	0f b6 d0             	movzbl %al,%edx
  800d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	0f b6 c0             	movzbl %al,%eax
  800d3a:	29 c2                	sub    %eax,%edx
  800d3c:	89 d0                	mov    %edx,%eax
}
  800d3e:	5d                   	pop    %ebp
  800d3f:	c3                   	ret    

00800d40 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d43:	eb 09                	jmp    800d4e <strncmp+0xe>
		n--, p++, q++;
  800d45:	ff 4d 10             	decl   0x10(%ebp)
  800d48:	ff 45 08             	incl   0x8(%ebp)
  800d4b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d52:	74 17                	je     800d6b <strncmp+0x2b>
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	84 c0                	test   %al,%al
  800d5b:	74 0e                	je     800d6b <strncmp+0x2b>
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8a 10                	mov    (%eax),%dl
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	38 c2                	cmp    %al,%dl
  800d69:	74 da                	je     800d45 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6f:	75 07                	jne    800d78 <strncmp+0x38>
		return 0;
  800d71:	b8 00 00 00 00       	mov    $0x0,%eax
  800d76:	eb 14                	jmp    800d8c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	0f b6 d0             	movzbl %al,%edx
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	0f b6 c0             	movzbl %al,%eax
  800d88:	29 c2                	sub    %eax,%edx
  800d8a:	89 d0                	mov    %edx,%eax
}
  800d8c:	5d                   	pop    %ebp
  800d8d:	c3                   	ret    

00800d8e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	83 ec 04             	sub    $0x4,%esp
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d9a:	eb 12                	jmp    800dae <strchr+0x20>
		if (*s == c)
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	8a 00                	mov    (%eax),%al
  800da1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da4:	75 05                	jne    800dab <strchr+0x1d>
			return (char *) s;
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	eb 11                	jmp    800dbc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dab:	ff 45 08             	incl   0x8(%ebp)
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	84 c0                	test   %al,%al
  800db5:	75 e5                	jne    800d9c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800db7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbc:	c9                   	leave  
  800dbd:	c3                   	ret    

00800dbe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	83 ec 04             	sub    $0x4,%esp
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dca:	eb 0d                	jmp    800dd9 <strfind+0x1b>
		if (*s == c)
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dd4:	74 0e                	je     800de4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dd6:	ff 45 08             	incl   0x8(%ebp)
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	84 c0                	test   %al,%al
  800de0:	75 ea                	jne    800dcc <strfind+0xe>
  800de2:	eb 01                	jmp    800de5 <strfind+0x27>
		if (*s == c)
			break;
  800de4:	90                   	nop
	return (char *) s;
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de8:	c9                   	leave  
  800de9:	c3                   	ret    

00800dea <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800df6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dfa:	76 63                	jbe    800e5f <memset+0x75>
		uint64 data_block = c;
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	99                   	cltd   
  800e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e03:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e10:	c1 e0 08             	shl    $0x8,%eax
  800e13:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e16:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e1f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e23:	c1 e0 10             	shl    $0x10,%eax
  800e26:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e29:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e32:	89 c2                	mov    %eax,%edx
  800e34:	b8 00 00 00 00       	mov    $0x0,%eax
  800e39:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e3c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e3f:	eb 18                	jmp    800e59 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e41:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e44:	8d 41 08             	lea    0x8(%ecx),%eax
  800e47:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e50:	89 01                	mov    %eax,(%ecx)
  800e52:	89 51 04             	mov    %edx,0x4(%ecx)
  800e55:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e59:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e5d:	77 e2                	ja     800e41 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e63:	74 23                	je     800e88 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e68:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e6b:	eb 0e                	jmp    800e7b <memset+0x91>
			*p8++ = (uint8)c;
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	8d 50 01             	lea    0x1(%eax),%edx
  800e73:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e81:	89 55 10             	mov    %edx,0x10(%ebp)
  800e84:	85 c0                	test   %eax,%eax
  800e86:	75 e5                	jne    800e6d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e9f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea3:	76 24                	jbe    800ec9 <memcpy+0x3c>
		while(n >= 8){
  800ea5:	eb 1c                	jmp    800ec3 <memcpy+0x36>
			*d64 = *s64;
  800ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eaa:	8b 50 04             	mov    0x4(%eax),%edx
  800ead:	8b 00                	mov    (%eax),%eax
  800eaf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800eb2:	89 01                	mov    %eax,(%ecx)
  800eb4:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800eb7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ebb:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ebf:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ec3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ec7:	77 de                	ja     800ea7 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ec9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecd:	74 31                	je     800f00 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ed5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800edb:	eb 16                	jmp    800ef3 <memcpy+0x66>
			*d8++ = *s8++;
  800edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee0:	8d 50 01             	lea    0x1(%eax),%edx
  800ee3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ee6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eec:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800eef:	8a 12                	mov    (%edx),%dl
  800ef1:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ef3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef9:	89 55 10             	mov    %edx,0x10(%ebp)
  800efc:	85 c0                	test   %eax,%eax
  800efe:	75 dd                	jne    800edd <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f03:	c9                   	leave  
  800f04:	c3                   	ret    

00800f05 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1d:	73 50                	jae    800f6f <memmove+0x6a>
  800f1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f22:	8b 45 10             	mov    0x10(%ebp),%eax
  800f25:	01 d0                	add    %edx,%eax
  800f27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f2a:	76 43                	jbe    800f6f <memmove+0x6a>
		s += n;
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f32:	8b 45 10             	mov    0x10(%ebp),%eax
  800f35:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f38:	eb 10                	jmp    800f4a <memmove+0x45>
			*--d = *--s;
  800f3a:	ff 4d f8             	decl   -0x8(%ebp)
  800f3d:	ff 4d fc             	decl   -0x4(%ebp)
  800f40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f43:	8a 10                	mov    (%eax),%dl
  800f45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f48:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f50:	89 55 10             	mov    %edx,0x10(%ebp)
  800f53:	85 c0                	test   %eax,%eax
  800f55:	75 e3                	jne    800f3a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f57:	eb 23                	jmp    800f7c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5c:	8d 50 01             	lea    0x1(%eax),%edx
  800f5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f68:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6b:	8a 12                	mov    (%edx),%dl
  800f6d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f75:	89 55 10             	mov    %edx,0x10(%ebp)
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	75 dd                	jne    800f59 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f90:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f93:	eb 2a                	jmp    800fbf <memcmp+0x3e>
		if (*s1 != *s2)
  800f95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f98:	8a 10                	mov    (%eax),%dl
  800f9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	38 c2                	cmp    %al,%dl
  800fa1:	74 16                	je     800fb9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	0f b6 d0             	movzbl %al,%edx
  800fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	0f b6 c0             	movzbl %al,%eax
  800fb3:	29 c2                	sub    %eax,%edx
  800fb5:	89 d0                	mov    %edx,%eax
  800fb7:	eb 18                	jmp    800fd1 <memcmp+0x50>
		s1++, s2++;
  800fb9:	ff 45 fc             	incl   -0x4(%ebp)
  800fbc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	75 c9                	jne    800f95 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdf:	01 d0                	add    %edx,%eax
  800fe1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fe4:	eb 15                	jmp    800ffb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	0f b6 d0             	movzbl %al,%edx
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	0f b6 c0             	movzbl %al,%eax
  800ff4:	39 c2                	cmp    %eax,%edx
  800ff6:	74 0d                	je     801005 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ff8:	ff 45 08             	incl   0x8(%ebp)
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801001:	72 e3                	jb     800fe6 <memfind+0x13>
  801003:	eb 01                	jmp    801006 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801005:	90                   	nop
	return (void *) s;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801009:	c9                   	leave  
  80100a:	c3                   	ret    

0080100b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801011:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801018:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80101f:	eb 03                	jmp    801024 <strtol+0x19>
		s++;
  801021:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	3c 20                	cmp    $0x20,%al
  80102b:	74 f4                	je     801021 <strtol+0x16>
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 09                	cmp    $0x9,%al
  801034:	74 eb                	je     801021 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 2b                	cmp    $0x2b,%al
  80103d:	75 05                	jne    801044 <strtol+0x39>
		s++;
  80103f:	ff 45 08             	incl   0x8(%ebp)
  801042:	eb 13                	jmp    801057 <strtol+0x4c>
	else if (*s == '-')
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	3c 2d                	cmp    $0x2d,%al
  80104b:	75 0a                	jne    801057 <strtol+0x4c>
		s++, neg = 1;
  80104d:	ff 45 08             	incl   0x8(%ebp)
  801050:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801057:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105b:	74 06                	je     801063 <strtol+0x58>
  80105d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801061:	75 20                	jne    801083 <strtol+0x78>
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	3c 30                	cmp    $0x30,%al
  80106a:	75 17                	jne    801083 <strtol+0x78>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	40                   	inc    %eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 78                	cmp    $0x78,%al
  801074:	75 0d                	jne    801083 <strtol+0x78>
		s += 2, base = 16;
  801076:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80107a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801081:	eb 28                	jmp    8010ab <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801083:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801087:	75 15                	jne    80109e <strtol+0x93>
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8a 00                	mov    (%eax),%al
  80108e:	3c 30                	cmp    $0x30,%al
  801090:	75 0c                	jne    80109e <strtol+0x93>
		s++, base = 8;
  801092:	ff 45 08             	incl   0x8(%ebp)
  801095:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80109c:	eb 0d                	jmp    8010ab <strtol+0xa0>
	else if (base == 0)
  80109e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a2:	75 07                	jne    8010ab <strtol+0xa0>
		base = 10;
  8010a4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 2f                	cmp    $0x2f,%al
  8010b2:	7e 19                	jle    8010cd <strtol+0xc2>
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 39                	cmp    $0x39,%al
  8010bb:	7f 10                	jg     8010cd <strtol+0xc2>
			dig = *s - '0';
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	0f be c0             	movsbl %al,%eax
  8010c5:	83 e8 30             	sub    $0x30,%eax
  8010c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010cb:	eb 42                	jmp    80110f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	3c 60                	cmp    $0x60,%al
  8010d4:	7e 19                	jle    8010ef <strtol+0xe4>
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	3c 7a                	cmp    $0x7a,%al
  8010dd:	7f 10                	jg     8010ef <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	0f be c0             	movsbl %al,%eax
  8010e7:	83 e8 57             	sub    $0x57,%eax
  8010ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ed:	eb 20                	jmp    80110f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	3c 40                	cmp    $0x40,%al
  8010f6:	7e 39                	jle    801131 <strtol+0x126>
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 5a                	cmp    $0x5a,%al
  8010ff:	7f 30                	jg     801131 <strtol+0x126>
			dig = *s - 'A' + 10;
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	0f be c0             	movsbl %al,%eax
  801109:	83 e8 37             	sub    $0x37,%eax
  80110c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80110f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801112:	3b 45 10             	cmp    0x10(%ebp),%eax
  801115:	7d 19                	jge    801130 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801117:	ff 45 08             	incl   0x8(%ebp)
  80111a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801121:	89 c2                	mov    %eax,%edx
  801123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801126:	01 d0                	add    %edx,%eax
  801128:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80112b:	e9 7b ff ff ff       	jmp    8010ab <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801130:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801131:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801135:	74 08                	je     80113f <strtol+0x134>
		*endptr = (char *) s;
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80113f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801143:	74 07                	je     80114c <strtol+0x141>
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801148:	f7 d8                	neg    %eax
  80114a:	eb 03                	jmp    80114f <strtol+0x144>
  80114c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <ltostr>:

void
ltostr(long value, char *str)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80115e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801169:	79 13                	jns    80117e <ltostr+0x2d>
	{
		neg = 1;
  80116b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801178:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80117b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801186:	99                   	cltd   
  801187:	f7 f9                	idiv   %ecx
  801189:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80118c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118f:	8d 50 01             	lea    0x1(%eax),%edx
  801192:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801195:	89 c2                	mov    %eax,%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 d0                	add    %edx,%eax
  80119c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80119f:	83 c2 30             	add    $0x30,%edx
  8011a2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ac:	f7 e9                	imul   %ecx
  8011ae:	c1 fa 02             	sar    $0x2,%edx
  8011b1:	89 c8                	mov    %ecx,%eax
  8011b3:	c1 f8 1f             	sar    $0x1f,%eax
  8011b6:	29 c2                	sub    %eax,%edx
  8011b8:	89 d0                	mov    %edx,%eax
  8011ba:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c1:	75 bb                	jne    80117e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cd:	48                   	dec    %eax
  8011ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d5:	74 3d                	je     801214 <ltostr+0xc3>
		start = 1 ;
  8011d7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011de:	eb 34                	jmp    801214 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	01 d0                	add    %edx,%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	01 c2                	add    %eax,%edx
  8011f5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fb:	01 c8                	add    %ecx,%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801201:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 c2                	add    %eax,%edx
  801209:	8a 45 eb             	mov    -0x15(%ebp),%al
  80120c:	88 02                	mov    %al,(%edx)
		start++ ;
  80120e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801211:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801217:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80121a:	7c c4                	jl     8011e0 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80121c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80121f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801222:	01 d0                	add    %edx,%eax
  801224:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801227:	90                   	nop
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 c4 f9 ff ff       	call   800bfc <strlen>
  801238:	83 c4 04             	add    $0x4,%esp
  80123b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80123e:	ff 75 0c             	pushl  0xc(%ebp)
  801241:	e8 b6 f9 ff ff       	call   800bfc <strlen>
  801246:	83 c4 04             	add    $0x4,%esp
  801249:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80124c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801253:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80125a:	eb 17                	jmp    801273 <strcconcat+0x49>
		final[s] = str1[s] ;
  80125c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80125f:	8b 45 10             	mov    0x10(%ebp),%eax
  801262:	01 c2                	add    %eax,%edx
  801264:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	01 c8                	add    %ecx,%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801270:	ff 45 fc             	incl   -0x4(%ebp)
  801273:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801276:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801279:	7c e1                	jl     80125c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80127b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801282:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801289:	eb 1f                	jmp    8012aa <strcconcat+0x80>
		final[s++] = str2[i] ;
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	8d 50 01             	lea    0x1(%eax),%edx
  801291:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801294:	89 c2                	mov    %eax,%edx
  801296:	8b 45 10             	mov    0x10(%ebp),%eax
  801299:	01 c2                	add    %eax,%edx
  80129b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 c8                	add    %ecx,%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012a7:	ff 45 f8             	incl   -0x8(%ebp)
  8012aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b0:	7c d9                	jl     80128b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b8:	01 d0                	add    %edx,%eax
  8012ba:	c6 00 00             	movb   $0x0,(%eax)
}
  8012bd:	90                   	nop
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012cf:	8b 00                	mov    (%eax),%eax
  8012d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	01 d0                	add    %edx,%eax
  8012dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012e3:	eb 0c                	jmp    8012f1 <strsplit+0x31>
			*string++ = 0;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8d 50 01             	lea    0x1(%eax),%edx
  8012eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ee:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	84 c0                	test   %al,%al
  8012f8:	74 18                	je     801312 <strsplit+0x52>
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8a 00                	mov    (%eax),%al
  8012ff:	0f be c0             	movsbl %al,%eax
  801302:	50                   	push   %eax
  801303:	ff 75 0c             	pushl  0xc(%ebp)
  801306:	e8 83 fa ff ff       	call   800d8e <strchr>
  80130b:	83 c4 08             	add    $0x8,%esp
  80130e:	85 c0                	test   %eax,%eax
  801310:	75 d3                	jne    8012e5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	84 c0                	test   %al,%al
  801319:	74 5a                	je     801375 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80131b:	8b 45 14             	mov    0x14(%ebp),%eax
  80131e:	8b 00                	mov    (%eax),%eax
  801320:	83 f8 0f             	cmp    $0xf,%eax
  801323:	75 07                	jne    80132c <strsplit+0x6c>
		{
			return 0;
  801325:	b8 00 00 00 00       	mov    $0x0,%eax
  80132a:	eb 66                	jmp    801392 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80132c:	8b 45 14             	mov    0x14(%ebp),%eax
  80132f:	8b 00                	mov    (%eax),%eax
  801331:	8d 48 01             	lea    0x1(%eax),%ecx
  801334:	8b 55 14             	mov    0x14(%ebp),%edx
  801337:	89 0a                	mov    %ecx,(%edx)
  801339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	01 c2                	add    %eax,%edx
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80134a:	eb 03                	jmp    80134f <strsplit+0x8f>
			string++;
  80134c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
  801352:	8a 00                	mov    (%eax),%al
  801354:	84 c0                	test   %al,%al
  801356:	74 8b                	je     8012e3 <strsplit+0x23>
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	8a 00                	mov    (%eax),%al
  80135d:	0f be c0             	movsbl %al,%eax
  801360:	50                   	push   %eax
  801361:	ff 75 0c             	pushl  0xc(%ebp)
  801364:	e8 25 fa ff ff       	call   800d8e <strchr>
  801369:	83 c4 08             	add    $0x8,%esp
  80136c:	85 c0                	test   %eax,%eax
  80136e:	74 dc                	je     80134c <strsplit+0x8c>
			string++;
	}
  801370:	e9 6e ff ff ff       	jmp    8012e3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801375:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801376:	8b 45 14             	mov    0x14(%ebp),%eax
  801379:	8b 00                	mov    (%eax),%eax
  80137b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801382:	8b 45 10             	mov    0x10(%ebp),%eax
  801385:	01 d0                	add    %edx,%eax
  801387:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80138d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a7:	eb 4a                	jmp    8013f3 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	01 c2                	add    %eax,%edx
  8013b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	01 c8                	add    %ecx,%eax
  8013b9:	8a 00                	mov    (%eax),%al
  8013bb:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	8a 00                	mov    (%eax),%al
  8013c7:	3c 40                	cmp    $0x40,%al
  8013c9:	7e 25                	jle    8013f0 <str2lower+0x5c>
  8013cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d1:	01 d0                	add    %edx,%eax
  8013d3:	8a 00                	mov    (%eax),%al
  8013d5:	3c 5a                	cmp    $0x5a,%al
  8013d7:	7f 17                	jg     8013f0 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	01 d0                	add    %edx,%eax
  8013e1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e7:	01 ca                	add    %ecx,%edx
  8013e9:	8a 12                	mov    (%edx),%dl
  8013eb:	83 c2 20             	add    $0x20,%edx
  8013ee:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013f0:	ff 45 fc             	incl   -0x4(%ebp)
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	e8 01 f8 ff ff       	call   800bfc <strlen>
  8013fb:	83 c4 04             	add    $0x4,%esp
  8013fe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801401:	7f a6                	jg     8013a9 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801403:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  80140e:	83 ec 0c             	sub    $0xc,%esp
  801411:	6a 10                	push   $0x10
  801413:	e8 b2 15 00 00       	call   8029ca <alloc_block>
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  80141e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801422:	75 14                	jne    801438 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801424:	83 ec 04             	sub    $0x4,%esp
  801427:	68 e8 3f 80 00       	push   $0x803fe8
  80142c:	6a 14                	push   $0x14
  80142e:	68 11 40 80 00       	push   $0x804011
  801433:	e8 dd 21 00 00       	call   803615 <_panic>

	node->start = start;
  801438:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80143b:	8b 55 08             	mov    0x8(%ebp),%edx
  80143e:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801440:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801443:	8b 55 0c             	mov    0xc(%ebp),%edx
  801446:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801449:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801450:	a1 24 50 80 00       	mov    0x805024,%eax
  801455:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801458:	eb 18                	jmp    801472 <insert_page_alloc+0x6a>
		if (start < it->start)
  80145a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145d:	8b 00                	mov    (%eax),%eax
  80145f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801462:	77 37                	ja     80149b <insert_page_alloc+0x93>
			break;
		prev = it;
  801464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801467:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  80146a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80146f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801472:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801476:	74 08                	je     801480 <insert_page_alloc+0x78>
  801478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147b:	8b 40 08             	mov    0x8(%eax),%eax
  80147e:	eb 05                	jmp    801485 <insert_page_alloc+0x7d>
  801480:	b8 00 00 00 00       	mov    $0x0,%eax
  801485:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80148a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80148f:	85 c0                	test   %eax,%eax
  801491:	75 c7                	jne    80145a <insert_page_alloc+0x52>
  801493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801497:	75 c1                	jne    80145a <insert_page_alloc+0x52>
  801499:	eb 01                	jmp    80149c <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  80149b:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  80149c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014a0:	75 64                	jne    801506 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8014a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a6:	75 14                	jne    8014bc <insert_page_alloc+0xb4>
  8014a8:	83 ec 04             	sub    $0x4,%esp
  8014ab:	68 20 40 80 00       	push   $0x804020
  8014b0:	6a 21                	push   $0x21
  8014b2:	68 11 40 80 00       	push   $0x804011
  8014b7:	e8 59 21 00 00       	call   803615 <_panic>
  8014bc:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8014c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014c5:	89 50 08             	mov    %edx,0x8(%eax)
  8014c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014cb:	8b 40 08             	mov    0x8(%eax),%eax
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	74 0d                	je     8014df <insert_page_alloc+0xd7>
  8014d2:	a1 24 50 80 00       	mov    0x805024,%eax
  8014d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014da:	89 50 0c             	mov    %edx,0xc(%eax)
  8014dd:	eb 08                	jmp    8014e7 <insert_page_alloc+0xdf>
  8014df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e2:	a3 28 50 80 00       	mov    %eax,0x805028
  8014e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ea:	a3 24 50 80 00       	mov    %eax,0x805024
  8014ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8014f9:	a1 30 50 80 00       	mov    0x805030,%eax
  8014fe:	40                   	inc    %eax
  8014ff:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801504:	eb 71                	jmp    801577 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801506:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80150a:	74 06                	je     801512 <insert_page_alloc+0x10a>
  80150c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801510:	75 14                	jne    801526 <insert_page_alloc+0x11e>
  801512:	83 ec 04             	sub    $0x4,%esp
  801515:	68 44 40 80 00       	push   $0x804044
  80151a:	6a 23                	push   $0x23
  80151c:	68 11 40 80 00       	push   $0x804011
  801521:	e8 ef 20 00 00       	call   803615 <_panic>
  801526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801529:	8b 50 08             	mov    0x8(%eax),%edx
  80152c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152f:	89 50 08             	mov    %edx,0x8(%eax)
  801532:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801535:	8b 40 08             	mov    0x8(%eax),%eax
  801538:	85 c0                	test   %eax,%eax
  80153a:	74 0c                	je     801548 <insert_page_alloc+0x140>
  80153c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153f:	8b 40 08             	mov    0x8(%eax),%eax
  801542:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801545:	89 50 0c             	mov    %edx,0xc(%eax)
  801548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80154e:	89 50 08             	mov    %edx,0x8(%eax)
  801551:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801554:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801557:	89 50 0c             	mov    %edx,0xc(%eax)
  80155a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80155d:	8b 40 08             	mov    0x8(%eax),%eax
  801560:	85 c0                	test   %eax,%eax
  801562:	75 08                	jne    80156c <insert_page_alloc+0x164>
  801564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801567:	a3 28 50 80 00       	mov    %eax,0x805028
  80156c:	a1 30 50 80 00       	mov    0x805030,%eax
  801571:	40                   	inc    %eax
  801572:	a3 30 50 80 00       	mov    %eax,0x805030
}
  801577:	90                   	nop
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801580:	a1 24 50 80 00       	mov    0x805024,%eax
  801585:	85 c0                	test   %eax,%eax
  801587:	75 0c                	jne    801595 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801589:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80158e:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801593:	eb 67                	jmp    8015fc <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801595:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80159a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80159d:	a1 24 50 80 00       	mov    0x805024,%eax
  8015a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8015a5:	eb 26                	jmp    8015cd <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  8015a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015aa:	8b 10                	mov    (%eax),%edx
  8015ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015af:	8b 40 04             	mov    0x4(%eax),%eax
  8015b2:	01 d0                	add    %edx,%eax
  8015b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  8015b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015bd:	76 06                	jbe    8015c5 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  8015bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8015c5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8015ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8015cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015d1:	74 08                	je     8015db <recompute_page_alloc_break+0x61>
  8015d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d6:	8b 40 08             	mov    0x8(%eax),%eax
  8015d9:	eb 05                	jmp    8015e0 <recompute_page_alloc_break+0x66>
  8015db:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8015e5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	75 b9                	jne    8015a7 <recompute_page_alloc_break+0x2d>
  8015ee:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015f2:	75 b3                	jne    8015a7 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  8015f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f7:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801604:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80160b:	8b 55 08             	mov    0x8(%ebp),%edx
  80160e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801611:	01 d0                	add    %edx,%eax
  801613:	48                   	dec    %eax
  801614:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801617:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80161a:	ba 00 00 00 00       	mov    $0x0,%edx
  80161f:	f7 75 d8             	divl   -0x28(%ebp)
  801622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801625:	29 d0                	sub    %edx,%eax
  801627:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  80162a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80162e:	75 0a                	jne    80163a <alloc_pages_custom_fit+0x3c>
		return NULL;
  801630:	b8 00 00 00 00       	mov    $0x0,%eax
  801635:	e9 7e 01 00 00       	jmp    8017b8 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  80163a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801641:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801645:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  80164c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801653:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801658:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  80165b:	a1 24 50 80 00       	mov    0x805024,%eax
  801660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801663:	eb 69                	jmp    8016ce <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801665:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801668:	8b 00                	mov    (%eax),%eax
  80166a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80166d:	76 47                	jbe    8016b6 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  80166f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801672:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801675:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801678:	8b 00                	mov    (%eax),%eax
  80167a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80167d:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801680:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801683:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801686:	72 2e                	jb     8016b6 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801688:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80168c:	75 14                	jne    8016a2 <alloc_pages_custom_fit+0xa4>
  80168e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801691:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801694:	75 0c                	jne    8016a2 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801696:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801699:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  80169c:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8016a0:	eb 14                	jmp    8016b6 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  8016a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8016a5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8016a8:	76 0c                	jbe    8016b6 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  8016aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8016ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  8016b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8016b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  8016b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b9:	8b 10                	mov    (%eax),%edx
  8016bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016be:	8b 40 04             	mov    0x4(%eax),%eax
  8016c1:	01 d0                	add    %edx,%eax
  8016c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8016c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016d2:	74 08                	je     8016dc <alloc_pages_custom_fit+0xde>
  8016d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d7:	8b 40 08             	mov    0x8(%eax),%eax
  8016da:	eb 05                	jmp    8016e1 <alloc_pages_custom_fit+0xe3>
  8016dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8016e6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	0f 85 72 ff ff ff    	jne    801665 <alloc_pages_custom_fit+0x67>
  8016f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016f7:	0f 85 68 ff ff ff    	jne    801665 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  8016fd:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801702:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801705:	76 47                	jbe    80174e <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801707:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80170a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  80170d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801712:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801715:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801718:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80171b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80171e:	72 2e                	jb     80174e <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801720:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801724:	75 14                	jne    80173a <alloc_pages_custom_fit+0x13c>
  801726:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801729:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80172c:	75 0c                	jne    80173a <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  80172e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801731:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801734:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801738:	eb 14                	jmp    80174e <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  80173a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80173d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801740:	76 0c                	jbe    80174e <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801742:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801745:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801748:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80174b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  80174e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801755:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801759:	74 08                	je     801763 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  80175b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801761:	eb 40                	jmp    8017a3 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801763:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801767:	74 08                	je     801771 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801769:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80176f:	eb 32                	jmp    8017a3 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801771:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801776:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801779:	89 c2                	mov    %eax,%edx
  80177b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801780:	39 c2                	cmp    %eax,%edx
  801782:	73 07                	jae    80178b <alloc_pages_custom_fit+0x18d>
			return NULL;
  801784:	b8 00 00 00 00       	mov    $0x0,%eax
  801789:	eb 2d                	jmp    8017b8 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  80178b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801790:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801793:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801799:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80179c:	01 d0                	add    %edx,%eax
  80179e:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  8017a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017a6:	83 ec 08             	sub    $0x8,%esp
  8017a9:	ff 75 d0             	pushl  -0x30(%ebp)
  8017ac:	50                   	push   %eax
  8017ad:	e8 56 fc ff ff       	call   801408 <insert_page_alloc>
  8017b2:	83 c4 10             	add    $0x10,%esp

	return result;
  8017b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8017c6:	a1 24 50 80 00       	mov    0x805024,%eax
  8017cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8017ce:	eb 1a                	jmp    8017ea <find_allocated_size+0x30>
		if (it->start == va)
  8017d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d3:	8b 00                	mov    (%eax),%eax
  8017d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017d8:	75 08                	jne    8017e2 <find_allocated_size+0x28>
			return it->size;
  8017da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017dd:	8b 40 04             	mov    0x4(%eax),%eax
  8017e0:	eb 34                	jmp    801816 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8017e2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8017ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017ee:	74 08                	je     8017f8 <find_allocated_size+0x3e>
  8017f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f3:	8b 40 08             	mov    0x8(%eax),%eax
  8017f6:	eb 05                	jmp    8017fd <find_allocated_size+0x43>
  8017f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801802:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801807:	85 c0                	test   %eax,%eax
  801809:	75 c5                	jne    8017d0 <find_allocated_size+0x16>
  80180b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80180f:	75 bf                	jne    8017d0 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801811:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801824:	a1 24 50 80 00       	mov    0x805024,%eax
  801829:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182c:	e9 e1 01 00 00       	jmp    801a12 <free_pages+0x1fa>
		if (it->start == va) {
  801831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801834:	8b 00                	mov    (%eax),%eax
  801836:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801839:	0f 85 cb 01 00 00    	jne    801a0a <free_pages+0x1f2>

			uint32 start = it->start;
  80183f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801842:	8b 00                	mov    (%eax),%eax
  801844:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184a:	8b 40 04             	mov    0x4(%eax),%eax
  80184d:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801853:	f7 d0                	not    %eax
  801855:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801858:	73 1d                	jae    801877 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  80185a:	83 ec 0c             	sub    $0xc,%esp
  80185d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801860:	ff 75 e8             	pushl  -0x18(%ebp)
  801863:	68 78 40 80 00       	push   $0x804078
  801868:	68 a5 00 00 00       	push   $0xa5
  80186d:	68 11 40 80 00       	push   $0x804011
  801872:	e8 9e 1d 00 00       	call   803615 <_panic>
			}

			uint32 start_end = start + size;
  801877:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80187a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80187d:	01 d0                	add    %edx,%eax
  80187f:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801882:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801885:	85 c0                	test   %eax,%eax
  801887:	79 19                	jns    8018a2 <free_pages+0x8a>
  801889:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801890:	77 10                	ja     8018a2 <free_pages+0x8a>
  801892:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801899:	77 07                	ja     8018a2 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  80189b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	78 2c                	js     8018ce <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  8018a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018a5:	83 ec 0c             	sub    $0xc,%esp
  8018a8:	68 00 00 00 a0       	push   $0xa0000000
  8018ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8018b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8018b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018b9:	50                   	push   %eax
  8018ba:	68 bc 40 80 00       	push   $0x8040bc
  8018bf:	68 ad 00 00 00       	push   $0xad
  8018c4:	68 11 40 80 00       	push   $0x804011
  8018c9:	e8 47 1d 00 00       	call   803615 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8018ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018d4:	e9 88 00 00 00       	jmp    801961 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  8018d9:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  8018e0:	76 17                	jbe    8018f9 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  8018e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e5:	68 20 41 80 00       	push   $0x804120
  8018ea:	68 b4 00 00 00       	push   $0xb4
  8018ef:	68 11 40 80 00       	push   $0x804011
  8018f4:	e8 1c 1d 00 00       	call   803615 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  8018f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fc:	05 00 10 00 00       	add    $0x1000,%eax
  801901:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801907:	85 c0                	test   %eax,%eax
  801909:	79 2e                	jns    801939 <free_pages+0x121>
  80190b:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801912:	77 25                	ja     801939 <free_pages+0x121>
  801914:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  80191b:	77 1c                	ja     801939 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  80191d:	83 ec 08             	sub    $0x8,%esp
  801920:	68 00 10 00 00       	push   $0x1000
  801925:	ff 75 f0             	pushl  -0x10(%ebp)
  801928:	e8 38 0d 00 00       	call   802665 <sys_free_user_mem>
  80192d:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801930:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801937:	eb 28                	jmp    801961 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193c:	68 00 00 00 a0       	push   $0xa0000000
  801941:	ff 75 dc             	pushl  -0x24(%ebp)
  801944:	68 00 10 00 00       	push   $0x1000
  801949:	ff 75 f0             	pushl  -0x10(%ebp)
  80194c:	50                   	push   %eax
  80194d:	68 60 41 80 00       	push   $0x804160
  801952:	68 bd 00 00 00       	push   $0xbd
  801957:	68 11 40 80 00       	push   $0x804011
  80195c:	e8 b4 1c 00 00       	call   803615 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801964:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801967:	0f 82 6c ff ff ff    	jb     8018d9 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  80196d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801971:	75 17                	jne    80198a <free_pages+0x172>
  801973:	83 ec 04             	sub    $0x4,%esp
  801976:	68 c2 41 80 00       	push   $0x8041c2
  80197b:	68 c1 00 00 00       	push   $0xc1
  801980:	68 11 40 80 00       	push   $0x804011
  801985:	e8 8b 1c 00 00       	call   803615 <_panic>
  80198a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198d:	8b 40 08             	mov    0x8(%eax),%eax
  801990:	85 c0                	test   %eax,%eax
  801992:	74 11                	je     8019a5 <free_pages+0x18d>
  801994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801997:	8b 40 08             	mov    0x8(%eax),%eax
  80199a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80199d:	8b 52 0c             	mov    0xc(%edx),%edx
  8019a0:	89 50 0c             	mov    %edx,0xc(%eax)
  8019a3:	eb 0b                	jmp    8019b0 <free_pages+0x198>
  8019a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ab:	a3 28 50 80 00       	mov    %eax,0x805028
  8019b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	74 11                	je     8019cb <free_pages+0x1b3>
  8019ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c3:	8b 52 08             	mov    0x8(%edx),%edx
  8019c6:	89 50 08             	mov    %edx,0x8(%eax)
  8019c9:	eb 0b                	jmp    8019d6 <free_pages+0x1be>
  8019cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ce:	8b 40 08             	mov    0x8(%eax),%eax
  8019d1:	a3 24 50 80 00       	mov    %eax,0x805024
  8019d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8019e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8019ea:	a1 30 50 80 00       	mov    0x805030,%eax
  8019ef:	48                   	dec    %eax
  8019f0:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  8019f5:	83 ec 0c             	sub    $0xc,%esp
  8019f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8019fb:	e8 24 15 00 00       	call   802f24 <free_block>
  801a00:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801a03:	e8 72 fb ff ff       	call   80157a <recompute_page_alloc_break>

			return;
  801a08:	eb 37                	jmp    801a41 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a0a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a16:	74 08                	je     801a20 <free_pages+0x208>
  801a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1b:	8b 40 08             	mov    0x8(%eax),%eax
  801a1e:	eb 05                	jmp    801a25 <free_pages+0x20d>
  801a20:	b8 00 00 00 00       	mov    $0x0,%eax
  801a25:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801a2a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	0f 85 fa fd ff ff    	jne    801831 <free_pages+0x19>
  801a37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a3b:	0f 85 f0 fd ff ff    	jne    801831 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801a46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4b:	5d                   	pop    %ebp
  801a4c:	c3                   	ret    

00801a4d <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801a53:	a1 08 50 80 00       	mov    0x805008,%eax
  801a58:	85 c0                	test   %eax,%eax
  801a5a:	74 60                	je     801abc <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801a5c:	83 ec 08             	sub    $0x8,%esp
  801a5f:	68 00 00 00 82       	push   $0x82000000
  801a64:	68 00 00 00 80       	push   $0x80000000
  801a69:	e8 0d 0d 00 00       	call   80277b <initialize_dynamic_allocator>
  801a6e:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801a71:	e8 f3 0a 00 00       	call   802569 <sys_get_uheap_strategy>
  801a76:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801a7b:	a1 40 50 80 00       	mov    0x805040,%eax
  801a80:	05 00 10 00 00       	add    $0x1000,%eax
  801a85:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801a8a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801a8f:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801a94:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801a9b:	00 00 00 
  801a9e:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801aa5:	00 00 00 
  801aa8:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801aaf:	00 00 00 

		__firstTimeFlag = 0;
  801ab2:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801ab9:	00 00 00 
	}
}
  801abc:	90                   	nop
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ace:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ad3:	83 ec 08             	sub    $0x8,%esp
  801ad6:	68 06 04 00 00       	push   $0x406
  801adb:	50                   	push   %eax
  801adc:	e8 d2 06 00 00       	call   8021b3 <__sys_allocate_page>
  801ae1:	83 c4 10             	add    $0x10,%esp
  801ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801ae7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801aeb:	79 17                	jns    801b04 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801aed:	83 ec 04             	sub    $0x4,%esp
  801af0:	68 e0 41 80 00       	push   $0x8041e0
  801af5:	68 ea 00 00 00       	push   $0xea
  801afa:	68 11 40 80 00       	push   $0x804011
  801aff:	e8 11 1b 00 00       	call   803615 <_panic>
	return 0;
  801b04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b1f:	83 ec 0c             	sub    $0xc,%esp
  801b22:	50                   	push   %eax
  801b23:	e8 d2 06 00 00       	call   8021fa <__sys_unmap_frame>
  801b28:	83 c4 10             	add    $0x10,%esp
  801b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b32:	79 17                	jns    801b4b <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801b34:	83 ec 04             	sub    $0x4,%esp
  801b37:	68 1c 42 80 00       	push   $0x80421c
  801b3c:	68 f5 00 00 00       	push   $0xf5
  801b41:	68 11 40 80 00       	push   $0x804011
  801b46:	e8 ca 1a 00 00       	call   803615 <_panic>
}
  801b4b:	90                   	nop
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801b54:	e8 f4 fe ff ff       	call   801a4d <uheap_init>
	if (size == 0) return NULL ;
  801b59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b5d:	75 0a                	jne    801b69 <malloc+0x1b>
  801b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b64:	e9 67 01 00 00       	jmp    801cd0 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801b69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801b70:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801b77:	77 16                	ja     801b8f <malloc+0x41>
		result = alloc_block(size);
  801b79:	83 ec 0c             	sub    $0xc,%esp
  801b7c:	ff 75 08             	pushl  0x8(%ebp)
  801b7f:	e8 46 0e 00 00       	call   8029ca <alloc_block>
  801b84:	83 c4 10             	add    $0x10,%esp
  801b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b8a:	e9 3e 01 00 00       	jmp    801ccd <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801b8f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b96:	8b 55 08             	mov    0x8(%ebp),%edx
  801b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9c:	01 d0                	add    %edx,%eax
  801b9e:	48                   	dec    %eax
  801b9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba5:	ba 00 00 00 00       	mov    $0x0,%edx
  801baa:	f7 75 f0             	divl   -0x10(%ebp)
  801bad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb0:	29 d0                	sub    %edx,%eax
  801bb2:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801bb5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801bba:	85 c0                	test   %eax,%eax
  801bbc:	75 0a                	jne    801bc8 <malloc+0x7a>
			return NULL;
  801bbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc3:	e9 08 01 00 00       	jmp    801cd0 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801bc8:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801bcd:	85 c0                	test   %eax,%eax
  801bcf:	74 0f                	je     801be0 <malloc+0x92>
  801bd1:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801bd7:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801bdc:	39 c2                	cmp    %eax,%edx
  801bde:	73 0a                	jae    801bea <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801be0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801be5:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801bea:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801bef:	83 f8 05             	cmp    $0x5,%eax
  801bf2:	75 11                	jne    801c05 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801bf4:	83 ec 0c             	sub    $0xc,%esp
  801bf7:	ff 75 e8             	pushl  -0x18(%ebp)
  801bfa:	e8 ff f9 ff ff       	call   8015fe <alloc_pages_custom_fit>
  801bff:	83 c4 10             	add    $0x10,%esp
  801c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801c05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c09:	0f 84 be 00 00 00    	je     801ccd <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801c15:	83 ec 0c             	sub    $0xc,%esp
  801c18:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1b:	e8 9a fb ff ff       	call   8017ba <find_allocated_size>
  801c20:	83 c4 10             	add    $0x10,%esp
  801c23:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801c26:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c2a:	75 17                	jne    801c43 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801c2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2f:	68 5c 42 80 00       	push   $0x80425c
  801c34:	68 24 01 00 00       	push   $0x124
  801c39:	68 11 40 80 00       	push   $0x804011
  801c3e:	e8 d2 19 00 00       	call   803615 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801c43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c46:	f7 d0                	not    %eax
  801c48:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c4b:	73 1d                	jae    801c6a <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801c4d:	83 ec 0c             	sub    $0xc,%esp
  801c50:	ff 75 e0             	pushl  -0x20(%ebp)
  801c53:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c56:	68 a4 42 80 00       	push   $0x8042a4
  801c5b:	68 29 01 00 00       	push   $0x129
  801c60:	68 11 40 80 00       	push   $0x804011
  801c65:	e8 ab 19 00 00       	call   803615 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801c6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c70:	01 d0                	add    %edx,%eax
  801c72:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801c75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c78:	85 c0                	test   %eax,%eax
  801c7a:	79 2c                	jns    801ca8 <malloc+0x15a>
  801c7c:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801c83:	77 23                	ja     801ca8 <malloc+0x15a>
  801c85:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801c8c:	77 1a                	ja     801ca8 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801c8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c91:	85 c0                	test   %eax,%eax
  801c93:	79 13                	jns    801ca8 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801c95:	83 ec 08             	sub    $0x8,%esp
  801c98:	ff 75 e0             	pushl  -0x20(%ebp)
  801c9b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c9e:	e8 de 09 00 00       	call   802681 <sys_allocate_user_mem>
  801ca3:	83 c4 10             	add    $0x10,%esp
  801ca6:	eb 25                	jmp    801ccd <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801ca8:	68 00 00 00 a0       	push   $0xa0000000
  801cad:	ff 75 dc             	pushl  -0x24(%ebp)
  801cb0:	ff 75 e0             	pushl  -0x20(%ebp)
  801cb3:	ff 75 e4             	pushl  -0x1c(%ebp)
  801cb6:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb9:	68 e0 42 80 00       	push   $0x8042e0
  801cbe:	68 33 01 00 00       	push   $0x133
  801cc3:	68 11 40 80 00       	push   $0x804011
  801cc8:	e8 48 19 00 00       	call   803615 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801cd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cdc:	0f 84 26 01 00 00    	je     801e08 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ceb:	85 c0                	test   %eax,%eax
  801ced:	79 1c                	jns    801d0b <free+0x39>
  801cef:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801cf6:	77 13                	ja     801d0b <free+0x39>
		free_block(virtual_address);
  801cf8:	83 ec 0c             	sub    $0xc,%esp
  801cfb:	ff 75 08             	pushl  0x8(%ebp)
  801cfe:	e8 21 12 00 00       	call   802f24 <free_block>
  801d03:	83 c4 10             	add    $0x10,%esp
		return;
  801d06:	e9 01 01 00 00       	jmp    801e0c <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801d0b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d10:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801d13:	0f 82 d8 00 00 00    	jb     801df1 <free+0x11f>
  801d19:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801d20:	0f 87 cb 00 00 00    	ja     801df1 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d29:	25 ff 0f 00 00       	and    $0xfff,%eax
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	74 17                	je     801d49 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801d32:	ff 75 08             	pushl  0x8(%ebp)
  801d35:	68 50 43 80 00       	push   $0x804350
  801d3a:	68 57 01 00 00       	push   $0x157
  801d3f:	68 11 40 80 00       	push   $0x804011
  801d44:	e8 cc 18 00 00       	call   803615 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801d49:	83 ec 0c             	sub    $0xc,%esp
  801d4c:	ff 75 08             	pushl  0x8(%ebp)
  801d4f:	e8 66 fa ff ff       	call   8017ba <find_allocated_size>
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801d5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d5e:	0f 84 a7 00 00 00    	je     801e0b <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d67:	f7 d0                	not    %eax
  801d69:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d6c:	73 1d                	jae    801d8b <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801d6e:	83 ec 0c             	sub    $0xc,%esp
  801d71:	ff 75 f0             	pushl  -0x10(%ebp)
  801d74:	ff 75 f4             	pushl  -0xc(%ebp)
  801d77:	68 78 43 80 00       	push   $0x804378
  801d7c:	68 61 01 00 00       	push   $0x161
  801d81:	68 11 40 80 00       	push   $0x804011
  801d86:	e8 8a 18 00 00       	call   803615 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801d8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d91:	01 d0                	add    %edx,%eax
  801d93:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d99:	85 c0                	test   %eax,%eax
  801d9b:	79 19                	jns    801db6 <free+0xe4>
  801d9d:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801da4:	77 10                	ja     801db6 <free+0xe4>
  801da6:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801dad:	77 07                	ja     801db6 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801daf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db2:	85 c0                	test   %eax,%eax
  801db4:	78 2b                	js     801de1 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801db6:	83 ec 0c             	sub    $0xc,%esp
  801db9:	68 00 00 00 a0       	push   $0xa0000000
  801dbe:	ff 75 ec             	pushl  -0x14(%ebp)
  801dc1:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc7:	ff 75 f0             	pushl  -0x10(%ebp)
  801dca:	ff 75 08             	pushl  0x8(%ebp)
  801dcd:	68 b4 43 80 00       	push   $0x8043b4
  801dd2:	68 69 01 00 00       	push   $0x169
  801dd7:	68 11 40 80 00       	push   $0x804011
  801ddc:	e8 34 18 00 00       	call   803615 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  801de1:	83 ec 0c             	sub    $0xc,%esp
  801de4:	ff 75 08             	pushl  0x8(%ebp)
  801de7:	e8 2c fa ff ff       	call   801818 <free_pages>
  801dec:	83 c4 10             	add    $0x10,%esp
		return;
  801def:	eb 1b                	jmp    801e0c <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  801df1:	ff 75 08             	pushl  0x8(%ebp)
  801df4:	68 10 44 80 00       	push   $0x804410
  801df9:	68 70 01 00 00       	push   $0x170
  801dfe:	68 11 40 80 00       	push   $0x804011
  801e03:	e8 0d 18 00 00       	call   803615 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801e08:	90                   	nop
  801e09:	eb 01                	jmp    801e0c <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  801e0b:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	83 ec 38             	sub    $0x38,%esp
  801e14:	8b 45 10             	mov    0x10(%ebp),%eax
  801e17:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e1a:	e8 2e fc ff ff       	call   801a4d <uheap_init>
	if (size == 0) return NULL ;
  801e1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e23:	75 0a                	jne    801e2f <smalloc+0x21>
  801e25:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2a:	e9 3d 01 00 00       	jmp    801f6c <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  801e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  801e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e38:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  801e40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e44:	74 0e                	je     801e54 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  801e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e49:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801e4c:	05 00 10 00 00       	add    $0x1000,%eax
  801e51:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  801e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e57:	c1 e8 0c             	shr    $0xc,%eax
  801e5a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  801e5d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e62:	85 c0                	test   %eax,%eax
  801e64:	75 0a                	jne    801e70 <smalloc+0x62>
		return NULL;
  801e66:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6b:	e9 fc 00 00 00       	jmp    801f6c <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  801e70:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e75:	85 c0                	test   %eax,%eax
  801e77:	74 0f                	je     801e88 <smalloc+0x7a>
  801e79:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801e7f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e84:	39 c2                	cmp    %eax,%edx
  801e86:	73 0a                	jae    801e92 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  801e88:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e8d:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  801e92:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e97:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801e9c:	29 c2                	sub    %eax,%edx
  801e9e:	89 d0                	mov    %edx,%eax
  801ea0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  801ea3:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801ea9:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801eae:	29 c2                	sub    %eax,%edx
  801eb0:	89 d0                	mov    %edx,%eax
  801eb2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ebb:	77 13                	ja     801ed0 <smalloc+0xc2>
  801ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ec0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ec3:	77 0b                	ja     801ed0 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  801ec5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ec8:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801ecb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801ece:	73 0a                	jae    801eda <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  801ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed5:	e9 92 00 00 00       	jmp    801f6c <smalloc+0x15e>
	}

	void *va = NULL;
  801eda:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801ee1:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801ee6:	83 f8 05             	cmp    $0x5,%eax
  801ee9:	75 11                	jne    801efc <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  801eeb:	83 ec 0c             	sub    $0xc,%esp
  801eee:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef1:	e8 08 f7 ff ff       	call   8015fe <alloc_pages_custom_fit>
  801ef6:	83 c4 10             	add    $0x10,%esp
  801ef9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  801efc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f00:	75 27                	jne    801f29 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  801f02:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  801f09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f0c:	2b 45 f4             	sub    -0xc(%ebp),%eax
  801f0f:	89 c2                	mov    %eax,%edx
  801f11:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f16:	39 c2                	cmp    %eax,%edx
  801f18:	73 07                	jae    801f21 <smalloc+0x113>
			return NULL;}
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1f:	eb 4b                	jmp    801f6c <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  801f21:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f26:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  801f29:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801f2d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f30:	50                   	push   %eax
  801f31:	ff 75 0c             	pushl  0xc(%ebp)
  801f34:	ff 75 08             	pushl  0x8(%ebp)
  801f37:	e8 cb 03 00 00       	call   802307 <sys_create_shared_object>
  801f3c:	83 c4 10             	add    $0x10,%esp
  801f3f:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  801f42:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801f46:	79 07                	jns    801f4f <smalloc+0x141>
		return NULL;
  801f48:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4d:	eb 1d                	jmp    801f6c <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  801f4f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f54:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  801f57:	75 10                	jne    801f69 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  801f59:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f62:	01 d0                	add    %edx,%eax
  801f64:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  801f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f74:	e8 d4 fa ff ff       	call   801a4d <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  801f79:	83 ec 08             	sub    $0x8,%esp
  801f7c:	ff 75 0c             	pushl  0xc(%ebp)
  801f7f:	ff 75 08             	pushl  0x8(%ebp)
  801f82:	e8 aa 03 00 00       	call   802331 <sys_size_of_shared_object>
  801f87:	83 c4 10             	add    $0x10,%esp
  801f8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  801f8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f91:	7f 0a                	jg     801f9d <sget+0x2f>
		return NULL;
  801f93:	b8 00 00 00 00       	mov    $0x0,%eax
  801f98:	e9 32 01 00 00       	jmp    8020cf <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  801f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  801fa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa6:	25 ff 0f 00 00       	and    $0xfff,%eax
  801fab:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  801fae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801fb2:	74 0e                	je     801fc2 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  801fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  801fba:	05 00 10 00 00       	add    $0x1000,%eax
  801fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  801fc2:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801fc7:	85 c0                	test   %eax,%eax
  801fc9:	75 0a                	jne    801fd5 <sget+0x67>
		return NULL;
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd0:	e9 fa 00 00 00       	jmp    8020cf <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  801fd5:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	74 0f                	je     801fed <sget+0x7f>
  801fde:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801fe4:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801fe9:	39 c2                	cmp    %eax,%edx
  801feb:	73 0a                	jae    801ff7 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  801fed:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ff2:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  801ff7:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ffc:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802001:	29 c2                	sub    %eax,%edx
  802003:	89 d0                	mov    %edx,%eax
  802005:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802008:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80200e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802013:	29 c2                	sub    %eax,%edx
  802015:	89 d0                	mov    %edx,%eax
  802017:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802020:	77 13                	ja     802035 <sget+0xc7>
  802022:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802025:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802028:	77 0b                	ja     802035 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  80202a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80202d:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802030:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802033:	73 0a                	jae    80203f <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802035:	b8 00 00 00 00       	mov    $0x0,%eax
  80203a:	e9 90 00 00 00       	jmp    8020cf <sget+0x161>

	void *va = NULL;
  80203f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802046:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80204b:	83 f8 05             	cmp    $0x5,%eax
  80204e:	75 11                	jne    802061 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802050:	83 ec 0c             	sub    $0xc,%esp
  802053:	ff 75 f4             	pushl  -0xc(%ebp)
  802056:	e8 a3 f5 ff ff       	call   8015fe <alloc_pages_custom_fit>
  80205b:	83 c4 10             	add    $0x10,%esp
  80205e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  802061:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802065:	75 27                	jne    80208e <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802067:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  80206e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802071:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802074:	89 c2                	mov    %eax,%edx
  802076:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80207b:	39 c2                	cmp    %eax,%edx
  80207d:	73 07                	jae    802086 <sget+0x118>
			return NULL;
  80207f:	b8 00 00 00 00       	mov    $0x0,%eax
  802084:	eb 49                	jmp    8020cf <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802086:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80208b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  80208e:	83 ec 04             	sub    $0x4,%esp
  802091:	ff 75 f0             	pushl  -0x10(%ebp)
  802094:	ff 75 0c             	pushl  0xc(%ebp)
  802097:	ff 75 08             	pushl  0x8(%ebp)
  80209a:	e8 af 02 00 00       	call   80234e <sys_get_shared_object>
  80209f:	83 c4 10             	add    $0x10,%esp
  8020a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8020a5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8020a9:	79 07                	jns    8020b2 <sget+0x144>
		return NULL;
  8020ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b0:	eb 1d                	jmp    8020cf <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8020b2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020b7:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8020ba:	75 10                	jne    8020cc <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8020bc:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	01 d0                	add    %edx,%eax
  8020c7:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8020cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8020d7:	e8 71 f9 ff ff       	call   801a4d <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8020dc:	83 ec 04             	sub    $0x4,%esp
  8020df:	68 34 44 80 00       	push   $0x804434
  8020e4:	68 19 02 00 00       	push   $0x219
  8020e9:	68 11 40 80 00       	push   $0x804011
  8020ee:	e8 22 15 00 00       	call   803615 <_panic>

008020f3 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8020f9:	83 ec 04             	sub    $0x4,%esp
  8020fc:	68 5c 44 80 00       	push   $0x80445c
  802101:	68 2b 02 00 00       	push   $0x22b
  802106:	68 11 40 80 00       	push   $0x804011
  80210b:	e8 05 15 00 00       	call   803615 <_panic>

00802110 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	57                   	push   %edi
  802114:	56                   	push   %esi
  802115:	53                   	push   %ebx
  802116:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802122:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802125:	8b 7d 18             	mov    0x18(%ebp),%edi
  802128:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80212b:	cd 30                	int    $0x30
  80212d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802130:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802133:	83 c4 10             	add    $0x10,%esp
  802136:	5b                   	pop    %ebx
  802137:	5e                   	pop    %esi
  802138:	5f                   	pop    %edi
  802139:	5d                   	pop    %ebp
  80213a:	c3                   	ret    

0080213b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 04             	sub    $0x4,%esp
  802141:	8b 45 10             	mov    0x10(%ebp),%eax
  802144:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802147:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80214a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	6a 00                	push   $0x0
  802153:	51                   	push   %ecx
  802154:	52                   	push   %edx
  802155:	ff 75 0c             	pushl  0xc(%ebp)
  802158:	50                   	push   %eax
  802159:	6a 00                	push   $0x0
  80215b:	e8 b0 ff ff ff       	call   802110 <syscall>
  802160:	83 c4 18             	add    $0x18,%esp
}
  802163:	90                   	nop
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <sys_cgetc>:

int
sys_cgetc(void)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 02                	push   $0x2
  802175:	e8 96 ff ff ff       	call   802110 <syscall>
  80217a:	83 c4 18             	add    $0x18,%esp
}
  80217d:	c9                   	leave  
  80217e:	c3                   	ret    

0080217f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 03                	push   $0x3
  80218e:	e8 7d ff ff ff       	call   802110 <syscall>
  802193:	83 c4 18             	add    $0x18,%esp
}
  802196:	90                   	nop
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 04                	push   $0x4
  8021a8:	e8 63 ff ff ff       	call   802110 <syscall>
  8021ad:	83 c4 18             	add    $0x18,%esp
}
  8021b0:	90                   	nop
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8021b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	52                   	push   %edx
  8021c3:	50                   	push   %eax
  8021c4:	6a 08                	push   $0x8
  8021c6:	e8 45 ff ff ff       	call   802110 <syscall>
  8021cb:	83 c4 18             	add    $0x18,%esp
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	56                   	push   %esi
  8021d4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021d5:	8b 75 18             	mov    0x18(%ebp),%esi
  8021d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	56                   	push   %esi
  8021e5:	53                   	push   %ebx
  8021e6:	51                   	push   %ecx
  8021e7:	52                   	push   %edx
  8021e8:	50                   	push   %eax
  8021e9:	6a 09                	push   $0x9
  8021eb:	e8 20 ff ff ff       	call   802110 <syscall>
  8021f0:	83 c4 18             	add    $0x18,%esp
}
  8021f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f6:	5b                   	pop    %ebx
  8021f7:	5e                   	pop    %esi
  8021f8:	5d                   	pop    %ebp
  8021f9:	c3                   	ret    

008021fa <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	ff 75 08             	pushl  0x8(%ebp)
  802208:	6a 0a                	push   $0xa
  80220a:	e8 01 ff ff ff       	call   802110 <syscall>
  80220f:	83 c4 18             	add    $0x18,%esp
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	ff 75 0c             	pushl  0xc(%ebp)
  802220:	ff 75 08             	pushl  0x8(%ebp)
  802223:	6a 0b                	push   $0xb
  802225:	e8 e6 fe ff ff       	call   802110 <syscall>
  80222a:	83 c4 18             	add    $0x18,%esp
}
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 0c                	push   $0xc
  80223e:	e8 cd fe ff ff       	call   802110 <syscall>
  802243:	83 c4 18             	add    $0x18,%esp
}
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 0d                	push   $0xd
  802257:	e8 b4 fe ff ff       	call   802110 <syscall>
  80225c:	83 c4 18             	add    $0x18,%esp
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 0e                	push   $0xe
  802270:	e8 9b fe ff ff       	call   802110 <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
}
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 0f                	push   $0xf
  802289:	e8 82 fe ff ff       	call   802110 <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	ff 75 08             	pushl  0x8(%ebp)
  8022a1:	6a 10                	push   $0x10
  8022a3:	e8 68 fe ff ff       	call   802110 <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 11                	push   $0x11
  8022bc:	e8 4f fe ff ff       	call   802110 <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
}
  8022c4:	90                   	nop
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_cputc>:

void
sys_cputc(const char c)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
  8022ca:	83 ec 04             	sub    $0x4,%esp
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022d3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	50                   	push   %eax
  8022e0:	6a 01                	push   $0x1
  8022e2:	e8 29 fe ff ff       	call   802110 <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
}
  8022ea:	90                   	nop
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 14                	push   $0x14
  8022fc:	e8 0f fe ff ff       	call   802110 <syscall>
  802301:	83 c4 18             	add    $0x18,%esp
}
  802304:	90                   	nop
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	83 ec 04             	sub    $0x4,%esp
  80230d:	8b 45 10             	mov    0x10(%ebp),%eax
  802310:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802313:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802316:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	6a 00                	push   $0x0
  80231f:	51                   	push   %ecx
  802320:	52                   	push   %edx
  802321:	ff 75 0c             	pushl  0xc(%ebp)
  802324:	50                   	push   %eax
  802325:	6a 15                	push   $0x15
  802327:	e8 e4 fd ff ff       	call   802110 <syscall>
  80232c:	83 c4 18             	add    $0x18,%esp
}
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802334:	8b 55 0c             	mov    0xc(%ebp),%edx
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	52                   	push   %edx
  802341:	50                   	push   %eax
  802342:	6a 16                	push   $0x16
  802344:	e8 c7 fd ff ff       	call   802110 <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802351:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802354:	8b 55 0c             	mov    0xc(%ebp),%edx
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	51                   	push   %ecx
  80235f:	52                   	push   %edx
  802360:	50                   	push   %eax
  802361:	6a 17                	push   $0x17
  802363:	e8 a8 fd ff ff       	call   802110 <syscall>
  802368:	83 c4 18             	add    $0x18,%esp
}
  80236b:	c9                   	leave  
  80236c:	c3                   	ret    

0080236d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80236d:	55                   	push   %ebp
  80236e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802370:	8b 55 0c             	mov    0xc(%ebp),%edx
  802373:	8b 45 08             	mov    0x8(%ebp),%eax
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	52                   	push   %edx
  80237d:	50                   	push   %eax
  80237e:	6a 18                	push   $0x18
  802380:	e8 8b fd ff ff       	call   802110 <syscall>
  802385:	83 c4 18             	add    $0x18,%esp
}
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	6a 00                	push   $0x0
  802392:	ff 75 14             	pushl  0x14(%ebp)
  802395:	ff 75 10             	pushl  0x10(%ebp)
  802398:	ff 75 0c             	pushl  0xc(%ebp)
  80239b:	50                   	push   %eax
  80239c:	6a 19                	push   $0x19
  80239e:	e8 6d fd ff ff       	call   802110 <syscall>
  8023a3:	83 c4 18             	add    $0x18,%esp
}
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	50                   	push   %eax
  8023b7:	6a 1a                	push   $0x1a
  8023b9:	e8 52 fd ff ff       	call   802110 <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
}
  8023c1:	90                   	nop
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	50                   	push   %eax
  8023d3:	6a 1b                	push   $0x1b
  8023d5:	e8 36 fd ff ff       	call   802110 <syscall>
  8023da:	83 c4 18             	add    $0x18,%esp
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 05                	push   $0x5
  8023ee:	e8 1d fd ff ff       	call   802110 <syscall>
  8023f3:	83 c4 18             	add    $0x18,%esp
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 06                	push   $0x6
  802407:	e8 04 fd ff ff       	call   802110 <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 07                	push   $0x7
  802420:	e8 eb fc ff ff       	call   802110 <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
}
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <sys_exit_env>:


void sys_exit_env(void)
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 1c                	push   $0x1c
  802439:	e8 d2 fc ff ff       	call   802110 <syscall>
  80243e:	83 c4 18             	add    $0x18,%esp
}
  802441:	90                   	nop
  802442:	c9                   	leave  
  802443:	c3                   	ret    

00802444 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
  802447:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80244a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80244d:	8d 50 04             	lea    0x4(%eax),%edx
  802450:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	52                   	push   %edx
  80245a:	50                   	push   %eax
  80245b:	6a 1d                	push   $0x1d
  80245d:	e8 ae fc ff ff       	call   802110 <syscall>
  802462:	83 c4 18             	add    $0x18,%esp
	return result;
  802465:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802468:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80246b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80246e:	89 01                	mov    %eax,(%ecx)
  802470:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	c9                   	leave  
  802477:	c2 04 00             	ret    $0x4

0080247a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	ff 75 10             	pushl  0x10(%ebp)
  802484:	ff 75 0c             	pushl  0xc(%ebp)
  802487:	ff 75 08             	pushl  0x8(%ebp)
  80248a:	6a 13                	push   $0x13
  80248c:	e8 7f fc ff ff       	call   802110 <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
	return ;
  802494:	90                   	nop
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <sys_rcr2>:
uint32 sys_rcr2()
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 1e                	push   $0x1e
  8024a6:	e8 65 fc ff ff       	call   802110 <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
}
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	83 ec 04             	sub    $0x4,%esp
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024bc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	50                   	push   %eax
  8024c9:	6a 1f                	push   $0x1f
  8024cb:	e8 40 fc ff ff       	call   802110 <syscall>
  8024d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d3:	90                   	nop
}
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <rsttst>:
void rsttst()
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 21                	push   $0x21
  8024e5:	e8 26 fc ff ff       	call   802110 <syscall>
  8024ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ed:	90                   	nop
}
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
  8024f3:	83 ec 04             	sub    $0x4,%esp
  8024f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8024f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024fc:	8b 55 18             	mov    0x18(%ebp),%edx
  8024ff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802503:	52                   	push   %edx
  802504:	50                   	push   %eax
  802505:	ff 75 10             	pushl  0x10(%ebp)
  802508:	ff 75 0c             	pushl  0xc(%ebp)
  80250b:	ff 75 08             	pushl  0x8(%ebp)
  80250e:	6a 20                	push   $0x20
  802510:	e8 fb fb ff ff       	call   802110 <syscall>
  802515:	83 c4 18             	add    $0x18,%esp
	return ;
  802518:	90                   	nop
}
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <chktst>:
void chktst(uint32 n)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	ff 75 08             	pushl  0x8(%ebp)
  802529:	6a 22                	push   $0x22
  80252b:	e8 e0 fb ff ff       	call   802110 <syscall>
  802530:	83 c4 18             	add    $0x18,%esp
	return ;
  802533:	90                   	nop
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <inctst>:

void inctst()
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 23                	push   $0x23
  802545:	e8 c6 fb ff ff       	call   802110 <syscall>
  80254a:	83 c4 18             	add    $0x18,%esp
	return ;
  80254d:	90                   	nop
}
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <gettst>:
uint32 gettst()
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 24                	push   $0x24
  80255f:	e8 ac fb ff ff       	call   802110 <syscall>
  802564:	83 c4 18             	add    $0x18,%esp
}
  802567:	c9                   	leave  
  802568:	c3                   	ret    

00802569 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 25                	push   $0x25
  802578:	e8 93 fb ff ff       	call   802110 <syscall>
  80257d:	83 c4 18             	add    $0x18,%esp
  802580:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802585:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  80258a:	c9                   	leave  
  80258b:	c3                   	ret    

0080258c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80258f:	8b 45 08             	mov    0x8(%ebp),%eax
  802592:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	ff 75 08             	pushl  0x8(%ebp)
  8025a2:	6a 26                	push   $0x26
  8025a4:	e8 67 fb ff ff       	call   802110 <syscall>
  8025a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ac:	90                   	nop
}
  8025ad:	c9                   	leave  
  8025ae:	c3                   	ret    

008025af <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025b3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bf:	6a 00                	push   $0x0
  8025c1:	53                   	push   %ebx
  8025c2:	51                   	push   %ecx
  8025c3:	52                   	push   %edx
  8025c4:	50                   	push   %eax
  8025c5:	6a 27                	push   $0x27
  8025c7:	e8 44 fb ff ff       	call   802110 <syscall>
  8025cc:	83 c4 18             	add    $0x18,%esp
}
  8025cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025d2:	c9                   	leave  
  8025d3:	c3                   	ret    

008025d4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8025d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025da:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	52                   	push   %edx
  8025e4:	50                   	push   %eax
  8025e5:	6a 28                	push   $0x28
  8025e7:	e8 24 fb ff ff       	call   802110 <syscall>
  8025ec:	83 c4 18             	add    $0x18,%esp
}
  8025ef:	c9                   	leave  
  8025f0:	c3                   	ret    

008025f1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8025f1:	55                   	push   %ebp
  8025f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8025f4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8025f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	6a 00                	push   $0x0
  8025ff:	51                   	push   %ecx
  802600:	ff 75 10             	pushl  0x10(%ebp)
  802603:	52                   	push   %edx
  802604:	50                   	push   %eax
  802605:	6a 29                	push   $0x29
  802607:	e8 04 fb ff ff       	call   802110 <syscall>
  80260c:	83 c4 18             	add    $0x18,%esp
}
  80260f:	c9                   	leave  
  802610:	c3                   	ret    

00802611 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802611:	55                   	push   %ebp
  802612:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	ff 75 10             	pushl  0x10(%ebp)
  80261b:	ff 75 0c             	pushl  0xc(%ebp)
  80261e:	ff 75 08             	pushl  0x8(%ebp)
  802621:	6a 12                	push   $0x12
  802623:	e8 e8 fa ff ff       	call   802110 <syscall>
  802628:	83 c4 18             	add    $0x18,%esp
	return ;
  80262b:	90                   	nop
}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802631:	8b 55 0c             	mov    0xc(%ebp),%edx
  802634:	8b 45 08             	mov    0x8(%ebp),%eax
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	52                   	push   %edx
  80263e:	50                   	push   %eax
  80263f:	6a 2a                	push   $0x2a
  802641:	e8 ca fa ff ff       	call   802110 <syscall>
  802646:	83 c4 18             	add    $0x18,%esp
	return;
  802649:	90                   	nop
}
  80264a:	c9                   	leave  
  80264b:	c3                   	ret    

0080264c <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80264f:	6a 00                	push   $0x0
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 2b                	push   $0x2b
  80265b:	e8 b0 fa ff ff       	call   802110 <syscall>
  802660:	83 c4 18             	add    $0x18,%esp
}
  802663:	c9                   	leave  
  802664:	c3                   	ret    

00802665 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802668:	6a 00                	push   $0x0
  80266a:	6a 00                	push   $0x0
  80266c:	6a 00                	push   $0x0
  80266e:	ff 75 0c             	pushl  0xc(%ebp)
  802671:	ff 75 08             	pushl  0x8(%ebp)
  802674:	6a 2d                	push   $0x2d
  802676:	e8 95 fa ff ff       	call   802110 <syscall>
  80267b:	83 c4 18             	add    $0x18,%esp
	return;
  80267e:	90                   	nop
}
  80267f:	c9                   	leave  
  802680:	c3                   	ret    

00802681 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802681:	55                   	push   %ebp
  802682:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	ff 75 0c             	pushl  0xc(%ebp)
  80268d:	ff 75 08             	pushl  0x8(%ebp)
  802690:	6a 2c                	push   $0x2c
  802692:	e8 79 fa ff ff       	call   802110 <syscall>
  802697:	83 c4 18             	add    $0x18,%esp
	return ;
  80269a:	90                   	nop
}
  80269b:	c9                   	leave  
  80269c:	c3                   	ret    

0080269d <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80269d:	55                   	push   %ebp
  80269e:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8026a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 00                	push   $0x0
  8026ac:	52                   	push   %edx
  8026ad:	50                   	push   %eax
  8026ae:	6a 2e                	push   $0x2e
  8026b0:	e8 5b fa ff ff       	call   802110 <syscall>
  8026b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b8:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    

008026bb <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
  8026be:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8026c1:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  8026c8:	72 09                	jb     8026d3 <to_page_va+0x18>
  8026ca:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  8026d1:	72 14                	jb     8026e7 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8026d3:	83 ec 04             	sub    $0x4,%esp
  8026d6:	68 80 44 80 00       	push   $0x804480
  8026db:	6a 15                	push   $0x15
  8026dd:	68 ab 44 80 00       	push   $0x8044ab
  8026e2:	e8 2e 0f 00 00       	call   803615 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8026e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ea:	ba 60 50 80 00       	mov    $0x805060,%edx
  8026ef:	29 d0                	sub    %edx,%eax
  8026f1:	c1 f8 02             	sar    $0x2,%eax
  8026f4:	89 c2                	mov    %eax,%edx
  8026f6:	89 d0                	mov    %edx,%eax
  8026f8:	c1 e0 02             	shl    $0x2,%eax
  8026fb:	01 d0                	add    %edx,%eax
  8026fd:	c1 e0 02             	shl    $0x2,%eax
  802700:	01 d0                	add    %edx,%eax
  802702:	c1 e0 02             	shl    $0x2,%eax
  802705:	01 d0                	add    %edx,%eax
  802707:	89 c1                	mov    %eax,%ecx
  802709:	c1 e1 08             	shl    $0x8,%ecx
  80270c:	01 c8                	add    %ecx,%eax
  80270e:	89 c1                	mov    %eax,%ecx
  802710:	c1 e1 10             	shl    $0x10,%ecx
  802713:	01 c8                	add    %ecx,%eax
  802715:	01 c0                	add    %eax,%eax
  802717:	01 d0                	add    %edx,%eax
  802719:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	c1 e0 0c             	shl    $0xc,%eax
  802722:	89 c2                	mov    %eax,%edx
  802724:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802729:	01 d0                	add    %edx,%eax
}
  80272b:	c9                   	leave  
  80272c:	c3                   	ret    

0080272d <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80272d:	55                   	push   %ebp
  80272e:	89 e5                	mov    %esp,%ebp
  802730:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802733:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802738:	8b 55 08             	mov    0x8(%ebp),%edx
  80273b:	29 c2                	sub    %eax,%edx
  80273d:	89 d0                	mov    %edx,%eax
  80273f:	c1 e8 0c             	shr    $0xc,%eax
  802742:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802745:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802749:	78 09                	js     802754 <to_page_info+0x27>
  80274b:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802752:	7e 14                	jle    802768 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802754:	83 ec 04             	sub    $0x4,%esp
  802757:	68 c4 44 80 00       	push   $0x8044c4
  80275c:	6a 22                	push   $0x22
  80275e:	68 ab 44 80 00       	push   $0x8044ab
  802763:	e8 ad 0e 00 00       	call   803615 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802768:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276b:	89 d0                	mov    %edx,%eax
  80276d:	01 c0                	add    %eax,%eax
  80276f:	01 d0                	add    %edx,%eax
  802771:	c1 e0 02             	shl    $0x2,%eax
  802774:	05 60 50 80 00       	add    $0x805060,%eax
}
  802779:	c9                   	leave  
  80277a:	c3                   	ret    

0080277b <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80277b:	55                   	push   %ebp
  80277c:	89 e5                	mov    %esp,%ebp
  80277e:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802781:	8b 45 08             	mov    0x8(%ebp),%eax
  802784:	05 00 00 00 02       	add    $0x2000000,%eax
  802789:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80278c:	73 16                	jae    8027a4 <initialize_dynamic_allocator+0x29>
  80278e:	68 e8 44 80 00       	push   $0x8044e8
  802793:	68 0e 45 80 00       	push   $0x80450e
  802798:	6a 34                	push   $0x34
  80279a:	68 ab 44 80 00       	push   $0x8044ab
  80279f:	e8 71 0e 00 00       	call   803615 <_panic>
		is_initialized = 1;
  8027a4:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  8027ab:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  8027ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b1:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  8027b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b9:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  8027be:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  8027c5:	00 00 00 
  8027c8:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8027cf:	00 00 00 
  8027d2:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  8027d9:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  8027dc:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  8027e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8027ea:	eb 36                	jmp    802822 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	c1 e0 04             	shl    $0x4,%eax
  8027f2:	05 80 d0 81 00       	add    $0x81d080,%eax
  8027f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	c1 e0 04             	shl    $0x4,%eax
  802803:	05 84 d0 81 00       	add    $0x81d084,%eax
  802808:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	c1 e0 04             	shl    $0x4,%eax
  802814:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  80281f:	ff 45 f4             	incl   -0xc(%ebp)
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802828:	72 c2                	jb     8027ec <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  80282a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802830:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802835:	29 c2                	sub    %eax,%edx
  802837:	89 d0                	mov    %edx,%eax
  802839:	c1 e8 0c             	shr    $0xc,%eax
  80283c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  80283f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802846:	e9 c8 00 00 00       	jmp    802913 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  80284b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80284e:	89 d0                	mov    %edx,%eax
  802850:	01 c0                	add    %eax,%eax
  802852:	01 d0                	add    %edx,%eax
  802854:	c1 e0 02             	shl    $0x2,%eax
  802857:	05 68 50 80 00       	add    $0x805068,%eax
  80285c:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802861:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802864:	89 d0                	mov    %edx,%eax
  802866:	01 c0                	add    %eax,%eax
  802868:	01 d0                	add    %edx,%eax
  80286a:	c1 e0 02             	shl    $0x2,%eax
  80286d:	05 6a 50 80 00       	add    $0x80506a,%eax
  802872:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802877:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80287d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802880:	89 c8                	mov    %ecx,%eax
  802882:	01 c0                	add    %eax,%eax
  802884:	01 c8                	add    %ecx,%eax
  802886:	c1 e0 02             	shl    $0x2,%eax
  802889:	05 64 50 80 00       	add    $0x805064,%eax
  80288e:	89 10                	mov    %edx,(%eax)
  802890:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802893:	89 d0                	mov    %edx,%eax
  802895:	01 c0                	add    %eax,%eax
  802897:	01 d0                	add    %edx,%eax
  802899:	c1 e0 02             	shl    $0x2,%eax
  80289c:	05 64 50 80 00       	add    $0x805064,%eax
  8028a1:	8b 00                	mov    (%eax),%eax
  8028a3:	85 c0                	test   %eax,%eax
  8028a5:	74 1b                	je     8028c2 <initialize_dynamic_allocator+0x147>
  8028a7:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8028ad:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8028b0:	89 c8                	mov    %ecx,%eax
  8028b2:	01 c0                	add    %eax,%eax
  8028b4:	01 c8                	add    %ecx,%eax
  8028b6:	c1 e0 02             	shl    $0x2,%eax
  8028b9:	05 60 50 80 00       	add    $0x805060,%eax
  8028be:	89 02                	mov    %eax,(%edx)
  8028c0:	eb 16                	jmp    8028d8 <initialize_dynamic_allocator+0x15d>
  8028c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c5:	89 d0                	mov    %edx,%eax
  8028c7:	01 c0                	add    %eax,%eax
  8028c9:	01 d0                	add    %edx,%eax
  8028cb:	c1 e0 02             	shl    $0x2,%eax
  8028ce:	05 60 50 80 00       	add    $0x805060,%eax
  8028d3:	a3 48 50 80 00       	mov    %eax,0x805048
  8028d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028db:	89 d0                	mov    %edx,%eax
  8028dd:	01 c0                	add    %eax,%eax
  8028df:	01 d0                	add    %edx,%eax
  8028e1:	c1 e0 02             	shl    $0x2,%eax
  8028e4:	05 60 50 80 00       	add    $0x805060,%eax
  8028e9:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8028ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f1:	89 d0                	mov    %edx,%eax
  8028f3:	01 c0                	add    %eax,%eax
  8028f5:	01 d0                	add    %edx,%eax
  8028f7:	c1 e0 02             	shl    $0x2,%eax
  8028fa:	05 60 50 80 00       	add    $0x805060,%eax
  8028ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802905:	a1 54 50 80 00       	mov    0x805054,%eax
  80290a:	40                   	inc    %eax
  80290b:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802910:	ff 45 f0             	incl   -0x10(%ebp)
  802913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802916:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802919:	0f 82 2c ff ff ff    	jb     80284b <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  80291f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802922:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802925:	eb 2f                	jmp    802956 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802927:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80292a:	89 d0                	mov    %edx,%eax
  80292c:	01 c0                	add    %eax,%eax
  80292e:	01 d0                	add    %edx,%eax
  802930:	c1 e0 02             	shl    $0x2,%eax
  802933:	05 68 50 80 00       	add    $0x805068,%eax
  802938:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  80293d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802940:	89 d0                	mov    %edx,%eax
  802942:	01 c0                	add    %eax,%eax
  802944:	01 d0                	add    %edx,%eax
  802946:	c1 e0 02             	shl    $0x2,%eax
  802949:	05 6a 50 80 00       	add    $0x80506a,%eax
  80294e:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802953:	ff 45 ec             	incl   -0x14(%ebp)
  802956:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  80295d:	76 c8                	jbe    802927 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80295f:	90                   	nop
  802960:	c9                   	leave  
  802961:	c3                   	ret    

00802962 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802962:	55                   	push   %ebp
  802963:	89 e5                	mov    %esp,%ebp
  802965:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802968:	8b 55 08             	mov    0x8(%ebp),%edx
  80296b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802970:	29 c2                	sub    %eax,%edx
  802972:	89 d0                	mov    %edx,%eax
  802974:	c1 e8 0c             	shr    $0xc,%eax
  802977:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  80297a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80297d:	89 d0                	mov    %edx,%eax
  80297f:	01 c0                	add    %eax,%eax
  802981:	01 d0                	add    %edx,%eax
  802983:	c1 e0 02             	shl    $0x2,%eax
  802986:	05 68 50 80 00       	add    $0x805068,%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802990:	c9                   	leave  
  802991:	c3                   	ret    

00802992 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802992:	55                   	push   %ebp
  802993:	89 e5                	mov    %esp,%ebp
  802995:	83 ec 14             	sub    $0x14,%esp
  802998:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  80299b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80299f:	77 07                	ja     8029a8 <nearest_pow2_ceil.1513+0x16>
  8029a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8029a6:	eb 20                	jmp    8029c8 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  8029a8:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  8029af:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  8029b2:	eb 08                	jmp    8029bc <nearest_pow2_ceil.1513+0x2a>
  8029b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029b7:	01 c0                	add    %eax,%eax
  8029b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8029bc:	d1 6d 08             	shrl   0x8(%ebp)
  8029bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c3:	75 ef                	jne    8029b4 <nearest_pow2_ceil.1513+0x22>
        return power;
  8029c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8029c8:	c9                   	leave  
  8029c9:	c3                   	ret    

008029ca <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8029ca:	55                   	push   %ebp
  8029cb:	89 e5                	mov    %esp,%ebp
  8029cd:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8029d0:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8029d7:	76 16                	jbe    8029ef <alloc_block+0x25>
  8029d9:	68 24 45 80 00       	push   $0x804524
  8029de:	68 0e 45 80 00       	push   $0x80450e
  8029e3:	6a 72                	push   $0x72
  8029e5:	68 ab 44 80 00       	push   $0x8044ab
  8029ea:	e8 26 0c 00 00       	call   803615 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  8029ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f3:	75 0a                	jne    8029ff <alloc_block+0x35>
  8029f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fa:	e9 bd 04 00 00       	jmp    802ebc <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8029ff:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a0c:	73 06                	jae    802a14 <alloc_block+0x4a>
        size = min_block_size;
  802a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a11:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802a14:	83 ec 0c             	sub    $0xc,%esp
  802a17:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802a1a:	ff 75 08             	pushl  0x8(%ebp)
  802a1d:	89 c1                	mov    %eax,%ecx
  802a1f:	e8 6e ff ff ff       	call   802992 <nearest_pow2_ceil.1513>
  802a24:	83 c4 10             	add    $0x10,%esp
  802a27:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802a2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a2d:	83 ec 0c             	sub    $0xc,%esp
  802a30:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802a33:	52                   	push   %edx
  802a34:	89 c1                	mov    %eax,%ecx
  802a36:	e8 83 04 00 00       	call   802ebe <log2_ceil.1520>
  802a3b:	83 c4 10             	add    $0x10,%esp
  802a3e:	83 e8 03             	sub    $0x3,%eax
  802a41:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802a44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a47:	c1 e0 04             	shl    $0x4,%eax
  802a4a:	05 80 d0 81 00       	add    $0x81d080,%eax
  802a4f:	8b 00                	mov    (%eax),%eax
  802a51:	85 c0                	test   %eax,%eax
  802a53:	0f 84 d8 00 00 00    	je     802b31 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802a59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a5c:	c1 e0 04             	shl    $0x4,%eax
  802a5f:	05 80 d0 81 00       	add    $0x81d080,%eax
  802a64:	8b 00                	mov    (%eax),%eax
  802a66:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802a69:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a6d:	75 17                	jne    802a86 <alloc_block+0xbc>
  802a6f:	83 ec 04             	sub    $0x4,%esp
  802a72:	68 45 45 80 00       	push   $0x804545
  802a77:	68 98 00 00 00       	push   $0x98
  802a7c:	68 ab 44 80 00       	push   $0x8044ab
  802a81:	e8 8f 0b 00 00       	call   803615 <_panic>
  802a86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a89:	8b 00                	mov    (%eax),%eax
  802a8b:	85 c0                	test   %eax,%eax
  802a8d:	74 10                	je     802a9f <alloc_block+0xd5>
  802a8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a97:	8b 52 04             	mov    0x4(%edx),%edx
  802a9a:	89 50 04             	mov    %edx,0x4(%eax)
  802a9d:	eb 14                	jmp    802ab3 <alloc_block+0xe9>
  802a9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa2:	8b 40 04             	mov    0x4(%eax),%eax
  802aa5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802aa8:	c1 e2 04             	shl    $0x4,%edx
  802aab:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802ab1:	89 02                	mov    %eax,(%edx)
  802ab3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab6:	8b 40 04             	mov    0x4(%eax),%eax
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	74 0f                	je     802acc <alloc_block+0x102>
  802abd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac0:	8b 40 04             	mov    0x4(%eax),%eax
  802ac3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ac6:	8b 12                	mov    (%edx),%edx
  802ac8:	89 10                	mov    %edx,(%eax)
  802aca:	eb 13                	jmp    802adf <alloc_block+0x115>
  802acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ad4:	c1 e2 04             	shl    $0x4,%edx
  802ad7:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802add:	89 02                	mov    %eax,(%edx)
  802adf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aeb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af5:	c1 e0 04             	shl    $0x4,%eax
  802af8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802afd:	8b 00                	mov    (%eax),%eax
  802aff:	8d 50 ff             	lea    -0x1(%eax),%edx
  802b02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b05:	c1 e0 04             	shl    $0x4,%eax
  802b08:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802b0d:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802b0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b12:	83 ec 0c             	sub    $0xc,%esp
  802b15:	50                   	push   %eax
  802b16:	e8 12 fc ff ff       	call   80272d <to_page_info>
  802b1b:	83 c4 10             	add    $0x10,%esp
  802b1e:	89 c2                	mov    %eax,%edx
  802b20:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802b24:	48                   	dec    %eax
  802b25:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802b29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2c:	e9 8b 03 00 00       	jmp    802ebc <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802b31:	a1 48 50 80 00       	mov    0x805048,%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	0f 84 64 02 00 00    	je     802da2 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802b3e:	a1 48 50 80 00       	mov    0x805048,%eax
  802b43:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802b46:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b4a:	75 17                	jne    802b63 <alloc_block+0x199>
  802b4c:	83 ec 04             	sub    $0x4,%esp
  802b4f:	68 45 45 80 00       	push   $0x804545
  802b54:	68 a0 00 00 00       	push   $0xa0
  802b59:	68 ab 44 80 00       	push   $0x8044ab
  802b5e:	e8 b2 0a 00 00       	call   803615 <_panic>
  802b63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b66:	8b 00                	mov    (%eax),%eax
  802b68:	85 c0                	test   %eax,%eax
  802b6a:	74 10                	je     802b7c <alloc_block+0x1b2>
  802b6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b6f:	8b 00                	mov    (%eax),%eax
  802b71:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b74:	8b 52 04             	mov    0x4(%edx),%edx
  802b77:	89 50 04             	mov    %edx,0x4(%eax)
  802b7a:	eb 0b                	jmp    802b87 <alloc_block+0x1bd>
  802b7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b7f:	8b 40 04             	mov    0x4(%eax),%eax
  802b82:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802b87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b8a:	8b 40 04             	mov    0x4(%eax),%eax
  802b8d:	85 c0                	test   %eax,%eax
  802b8f:	74 0f                	je     802ba0 <alloc_block+0x1d6>
  802b91:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b94:	8b 40 04             	mov    0x4(%eax),%eax
  802b97:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b9a:	8b 12                	mov    (%edx),%edx
  802b9c:	89 10                	mov    %edx,(%eax)
  802b9e:	eb 0a                	jmp    802baa <alloc_block+0x1e0>
  802ba0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ba3:	8b 00                	mov    (%eax),%eax
  802ba5:	a3 48 50 80 00       	mov    %eax,0x805048
  802baa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbd:	a1 54 50 80 00       	mov    0x805054,%eax
  802bc2:	48                   	dec    %eax
  802bc3:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802bc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bcb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bce:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802bd2:	b8 00 10 00 00       	mov    $0x1000,%eax
  802bd7:	99                   	cltd   
  802bd8:	f7 7d e8             	idivl  -0x18(%ebp)
  802bdb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bde:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802be2:	83 ec 0c             	sub    $0xc,%esp
  802be5:	ff 75 dc             	pushl  -0x24(%ebp)
  802be8:	e8 ce fa ff ff       	call   8026bb <to_page_va>
  802bed:	83 c4 10             	add    $0x10,%esp
  802bf0:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802bf3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bf6:	83 ec 0c             	sub    $0xc,%esp
  802bf9:	50                   	push   %eax
  802bfa:	e8 c0 ee ff ff       	call   801abf <get_page>
  802bff:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802c02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c09:	e9 aa 00 00 00       	jmp    802cb8 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802c15:	89 c2                	mov    %eax,%edx
  802c17:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c1a:	01 d0                	add    %edx,%eax
  802c1c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802c1f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802c23:	75 17                	jne    802c3c <alloc_block+0x272>
  802c25:	83 ec 04             	sub    $0x4,%esp
  802c28:	68 64 45 80 00       	push   $0x804564
  802c2d:	68 aa 00 00 00       	push   $0xaa
  802c32:	68 ab 44 80 00       	push   $0x8044ab
  802c37:	e8 d9 09 00 00       	call   803615 <_panic>
  802c3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3f:	c1 e0 04             	shl    $0x4,%eax
  802c42:	05 84 d0 81 00       	add    $0x81d084,%eax
  802c47:	8b 10                	mov    (%eax),%edx
  802c49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c4c:	89 50 04             	mov    %edx,0x4(%eax)
  802c4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c52:	8b 40 04             	mov    0x4(%eax),%eax
  802c55:	85 c0                	test   %eax,%eax
  802c57:	74 14                	je     802c6d <alloc_block+0x2a3>
  802c59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5c:	c1 e0 04             	shl    $0x4,%eax
  802c5f:	05 84 d0 81 00       	add    $0x81d084,%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c69:	89 10                	mov    %edx,(%eax)
  802c6b:	eb 11                	jmp    802c7e <alloc_block+0x2b4>
  802c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c70:	c1 e0 04             	shl    $0x4,%eax
  802c73:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802c79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c7c:	89 02                	mov    %eax,(%edx)
  802c7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c81:	c1 e0 04             	shl    $0x4,%eax
  802c84:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802c8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c8d:	89 02                	mov    %eax,(%edx)
  802c8f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9b:	c1 e0 04             	shl    $0x4,%eax
  802c9e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802ca3:	8b 00                	mov    (%eax),%eax
  802ca5:	8d 50 01             	lea    0x1(%eax),%edx
  802ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cab:	c1 e0 04             	shl    $0x4,%eax
  802cae:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802cb3:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802cb5:	ff 45 f4             	incl   -0xc(%ebp)
  802cb8:	b8 00 10 00 00       	mov    $0x1000,%eax
  802cbd:	99                   	cltd   
  802cbe:	f7 7d e8             	idivl  -0x18(%ebp)
  802cc1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802cc4:	0f 8f 44 ff ff ff    	jg     802c0e <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802cca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ccd:	c1 e0 04             	shl    $0x4,%eax
  802cd0:	05 80 d0 81 00       	add    $0x81d080,%eax
  802cd5:	8b 00                	mov    (%eax),%eax
  802cd7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802cda:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802cde:	75 17                	jne    802cf7 <alloc_block+0x32d>
  802ce0:	83 ec 04             	sub    $0x4,%esp
  802ce3:	68 45 45 80 00       	push   $0x804545
  802ce8:	68 ae 00 00 00       	push   $0xae
  802ced:	68 ab 44 80 00       	push   $0x8044ab
  802cf2:	e8 1e 09 00 00       	call   803615 <_panic>
  802cf7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	85 c0                	test   %eax,%eax
  802cfe:	74 10                	je     802d10 <alloc_block+0x346>
  802d00:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d03:	8b 00                	mov    (%eax),%eax
  802d05:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802d08:	8b 52 04             	mov    0x4(%edx),%edx
  802d0b:	89 50 04             	mov    %edx,0x4(%eax)
  802d0e:	eb 14                	jmp    802d24 <alloc_block+0x35a>
  802d10:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d13:	8b 40 04             	mov    0x4(%eax),%eax
  802d16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d19:	c1 e2 04             	shl    $0x4,%edx
  802d1c:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802d22:	89 02                	mov    %eax,(%edx)
  802d24:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d27:	8b 40 04             	mov    0x4(%eax),%eax
  802d2a:	85 c0                	test   %eax,%eax
  802d2c:	74 0f                	je     802d3d <alloc_block+0x373>
  802d2e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d31:	8b 40 04             	mov    0x4(%eax),%eax
  802d34:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802d37:	8b 12                	mov    (%edx),%edx
  802d39:	89 10                	mov    %edx,(%eax)
  802d3b:	eb 13                	jmp    802d50 <alloc_block+0x386>
  802d3d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d40:	8b 00                	mov    (%eax),%eax
  802d42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d45:	c1 e2 04             	shl    $0x4,%edx
  802d48:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802d4e:	89 02                	mov    %eax,(%edx)
  802d50:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d59:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d66:	c1 e0 04             	shl    $0x4,%eax
  802d69:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d6e:	8b 00                	mov    (%eax),%eax
  802d70:	8d 50 ff             	lea    -0x1(%eax),%edx
  802d73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d76:	c1 e0 04             	shl    $0x4,%eax
  802d79:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d7e:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802d80:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d83:	83 ec 0c             	sub    $0xc,%esp
  802d86:	50                   	push   %eax
  802d87:	e8 a1 f9 ff ff       	call   80272d <to_page_info>
  802d8c:	83 c4 10             	add    $0x10,%esp
  802d8f:	89 c2                	mov    %eax,%edx
  802d91:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802d95:	48                   	dec    %eax
  802d96:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802d9a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d9d:	e9 1a 01 00 00       	jmp    802ebc <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802da2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da5:	40                   	inc    %eax
  802da6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802da9:	e9 ed 00 00 00       	jmp    802e9b <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db1:	c1 e0 04             	shl    $0x4,%eax
  802db4:	05 80 d0 81 00       	add    $0x81d080,%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	85 c0                	test   %eax,%eax
  802dbd:	0f 84 d5 00 00 00    	je     802e98 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc6:	c1 e0 04             	shl    $0x4,%eax
  802dc9:	05 80 d0 81 00       	add    $0x81d080,%eax
  802dce:	8b 00                	mov    (%eax),%eax
  802dd0:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  802dd3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802dd7:	75 17                	jne    802df0 <alloc_block+0x426>
  802dd9:	83 ec 04             	sub    $0x4,%esp
  802ddc:	68 45 45 80 00       	push   $0x804545
  802de1:	68 b8 00 00 00       	push   $0xb8
  802de6:	68 ab 44 80 00       	push   $0x8044ab
  802deb:	e8 25 08 00 00       	call   803615 <_panic>
  802df0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802df3:	8b 00                	mov    (%eax),%eax
  802df5:	85 c0                	test   %eax,%eax
  802df7:	74 10                	je     802e09 <alloc_block+0x43f>
  802df9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dfc:	8b 00                	mov    (%eax),%eax
  802dfe:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e01:	8b 52 04             	mov    0x4(%edx),%edx
  802e04:	89 50 04             	mov    %edx,0x4(%eax)
  802e07:	eb 14                	jmp    802e1d <alloc_block+0x453>
  802e09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e0c:	8b 40 04             	mov    0x4(%eax),%eax
  802e0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e12:	c1 e2 04             	shl    $0x4,%edx
  802e15:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802e1b:	89 02                	mov    %eax,(%edx)
  802e1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e20:	8b 40 04             	mov    0x4(%eax),%eax
  802e23:	85 c0                	test   %eax,%eax
  802e25:	74 0f                	je     802e36 <alloc_block+0x46c>
  802e27:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e2a:	8b 40 04             	mov    0x4(%eax),%eax
  802e2d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e30:	8b 12                	mov    (%edx),%edx
  802e32:	89 10                	mov    %edx,(%eax)
  802e34:	eb 13                	jmp    802e49 <alloc_block+0x47f>
  802e36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e39:	8b 00                	mov    (%eax),%eax
  802e3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e3e:	c1 e2 04             	shl    $0x4,%edx
  802e41:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802e47:	89 02                	mov    %eax,(%edx)
  802e49:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e52:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5f:	c1 e0 04             	shl    $0x4,%eax
  802e62:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e67:	8b 00                	mov    (%eax),%eax
  802e69:	8d 50 ff             	lea    -0x1(%eax),%edx
  802e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6f:	c1 e0 04             	shl    $0x4,%eax
  802e72:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e77:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  802e79:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e7c:	83 ec 0c             	sub    $0xc,%esp
  802e7f:	50                   	push   %eax
  802e80:	e8 a8 f8 ff ff       	call   80272d <to_page_info>
  802e85:	83 c4 10             	add    $0x10,%esp
  802e88:	89 c2                	mov    %eax,%edx
  802e8a:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802e8e:	48                   	dec    %eax
  802e8f:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  802e93:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e96:	eb 24                	jmp    802ebc <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802e98:	ff 45 f0             	incl   -0x10(%ebp)
  802e9b:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802e9f:	0f 8e 09 ff ff ff    	jle    802dae <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  802ea5:	83 ec 04             	sub    $0x4,%esp
  802ea8:	68 87 45 80 00       	push   $0x804587
  802ead:	68 bf 00 00 00       	push   $0xbf
  802eb2:	68 ab 44 80 00       	push   $0x8044ab
  802eb7:	e8 59 07 00 00       	call   803615 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  802ebc:	c9                   	leave  
  802ebd:	c3                   	ret    

00802ebe <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  802ebe:	55                   	push   %ebp
  802ebf:	89 e5                	mov    %esp,%ebp
  802ec1:	83 ec 14             	sub    $0x14,%esp
  802ec4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  802ec7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ecb:	75 07                	jne    802ed4 <log2_ceil.1520+0x16>
  802ecd:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed2:	eb 1b                	jmp    802eef <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  802ed4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  802edb:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  802ede:	eb 06                	jmp    802ee6 <log2_ceil.1520+0x28>
            x >>= 1;
  802ee0:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  802ee3:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  802ee6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eea:	75 f4                	jne    802ee0 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  802eec:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802eef:	c9                   	leave  
  802ef0:	c3                   	ret    

00802ef1 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  802ef1:	55                   	push   %ebp
  802ef2:	89 e5                	mov    %esp,%ebp
  802ef4:	83 ec 14             	sub    $0x14,%esp
  802ef7:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  802efa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802efe:	75 07                	jne    802f07 <log2_ceil.1547+0x16>
  802f00:	b8 00 00 00 00       	mov    $0x0,%eax
  802f05:	eb 1b                	jmp    802f22 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  802f07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  802f0e:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  802f11:	eb 06                	jmp    802f19 <log2_ceil.1547+0x28>
			x >>= 1;
  802f13:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  802f16:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  802f19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1d:	75 f4                	jne    802f13 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  802f1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  802f22:	c9                   	leave  
  802f23:	c3                   	ret    

00802f24 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802f24:	55                   	push   %ebp
  802f25:	89 e5                	mov    %esp,%ebp
  802f27:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802f32:	39 c2                	cmp    %eax,%edx
  802f34:	72 0c                	jb     802f42 <free_block+0x1e>
  802f36:	8b 55 08             	mov    0x8(%ebp),%edx
  802f39:	a1 40 50 80 00       	mov    0x805040,%eax
  802f3e:	39 c2                	cmp    %eax,%edx
  802f40:	72 19                	jb     802f5b <free_block+0x37>
  802f42:	68 8c 45 80 00       	push   $0x80458c
  802f47:	68 0e 45 80 00       	push   $0x80450e
  802f4c:	68 d0 00 00 00       	push   $0xd0
  802f51:	68 ab 44 80 00       	push   $0x8044ab
  802f56:	e8 ba 06 00 00       	call   803615 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  802f5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f5f:	0f 84 42 03 00 00    	je     8032a7 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  802f65:	8b 55 08             	mov    0x8(%ebp),%edx
  802f68:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802f6d:	39 c2                	cmp    %eax,%edx
  802f6f:	72 0c                	jb     802f7d <free_block+0x59>
  802f71:	8b 55 08             	mov    0x8(%ebp),%edx
  802f74:	a1 40 50 80 00       	mov    0x805040,%eax
  802f79:	39 c2                	cmp    %eax,%edx
  802f7b:	72 17                	jb     802f94 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  802f7d:	83 ec 04             	sub    $0x4,%esp
  802f80:	68 c4 45 80 00       	push   $0x8045c4
  802f85:	68 e6 00 00 00       	push   $0xe6
  802f8a:	68 ab 44 80 00       	push   $0x8044ab
  802f8f:	e8 81 06 00 00       	call   803615 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  802f94:	8b 55 08             	mov    0x8(%ebp),%edx
  802f97:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802f9c:	29 c2                	sub    %eax,%edx
  802f9e:	89 d0                	mov    %edx,%eax
  802fa0:	83 e0 07             	and    $0x7,%eax
  802fa3:	85 c0                	test   %eax,%eax
  802fa5:	74 17                	je     802fbe <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  802fa7:	83 ec 04             	sub    $0x4,%esp
  802faa:	68 f8 45 80 00       	push   $0x8045f8
  802faf:	68 ea 00 00 00       	push   $0xea
  802fb4:	68 ab 44 80 00       	push   $0x8044ab
  802fb9:	e8 57 06 00 00       	call   803615 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	83 ec 0c             	sub    $0xc,%esp
  802fc4:	50                   	push   %eax
  802fc5:	e8 63 f7 ff ff       	call   80272d <to_page_info>
  802fca:	83 c4 10             	add    $0x10,%esp
  802fcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  802fd0:	83 ec 0c             	sub    $0xc,%esp
  802fd3:	ff 75 08             	pushl  0x8(%ebp)
  802fd6:	e8 87 f9 ff ff       	call   802962 <get_block_size>
  802fdb:	83 c4 10             	add    $0x10,%esp
  802fde:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  802fe1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fe5:	75 17                	jne    802ffe <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  802fe7:	83 ec 04             	sub    $0x4,%esp
  802fea:	68 24 46 80 00       	push   $0x804624
  802fef:	68 f1 00 00 00       	push   $0xf1
  802ff4:	68 ab 44 80 00       	push   $0x8044ab
  802ff9:	e8 17 06 00 00       	call   803615 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  802ffe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803001:	83 ec 0c             	sub    $0xc,%esp
  803004:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803007:	52                   	push   %edx
  803008:	89 c1                	mov    %eax,%ecx
  80300a:	e8 e2 fe ff ff       	call   802ef1 <log2_ceil.1547>
  80300f:	83 c4 10             	add    $0x10,%esp
  803012:	83 e8 03             	sub    $0x3,%eax
  803015:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803018:	8b 45 08             	mov    0x8(%ebp),%eax
  80301b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  80301e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803022:	75 17                	jne    80303b <free_block+0x117>
  803024:	83 ec 04             	sub    $0x4,%esp
  803027:	68 70 46 80 00       	push   $0x804670
  80302c:	68 f6 00 00 00       	push   $0xf6
  803031:	68 ab 44 80 00       	push   $0x8044ab
  803036:	e8 da 05 00 00       	call   803615 <_panic>
  80303b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80303e:	c1 e0 04             	shl    $0x4,%eax
  803041:	05 80 d0 81 00       	add    $0x81d080,%eax
  803046:	8b 10                	mov    (%eax),%edx
  803048:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80304b:	89 10                	mov    %edx,(%eax)
  80304d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803050:	8b 00                	mov    (%eax),%eax
  803052:	85 c0                	test   %eax,%eax
  803054:	74 15                	je     80306b <free_block+0x147>
  803056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803059:	c1 e0 04             	shl    $0x4,%eax
  80305c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803061:	8b 00                	mov    (%eax),%eax
  803063:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803066:	89 50 04             	mov    %edx,0x4(%eax)
  803069:	eb 11                	jmp    80307c <free_block+0x158>
  80306b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306e:	c1 e0 04             	shl    $0x4,%eax
  803071:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803077:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80307a:	89 02                	mov    %eax,(%edx)
  80307c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80307f:	c1 e0 04             	shl    $0x4,%eax
  803082:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803088:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80308b:	89 02                	mov    %eax,(%edx)
  80308d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803090:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803097:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80309a:	c1 e0 04             	shl    $0x4,%eax
  80309d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030a2:	8b 00                	mov    (%eax),%eax
  8030a4:	8d 50 01             	lea    0x1(%eax),%edx
  8030a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030aa:	c1 e0 04             	shl    $0x4,%eax
  8030ad:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030b2:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8030b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8030bb:	40                   	inc    %eax
  8030bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030bf:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8030c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c6:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8030cb:	29 c2                	sub    %eax,%edx
  8030cd:	89 d0                	mov    %edx,%eax
  8030cf:	c1 e8 0c             	shr    $0xc,%eax
  8030d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8030d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d8:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8030dc:	0f b7 c8             	movzwl %ax,%ecx
  8030df:	b8 00 10 00 00       	mov    $0x1000,%eax
  8030e4:	99                   	cltd   
  8030e5:	f7 7d e8             	idivl  -0x18(%ebp)
  8030e8:	39 c1                	cmp    %eax,%ecx
  8030ea:	0f 85 b8 01 00 00    	jne    8032a8 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8030f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8030f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030fa:	c1 e0 04             	shl    $0x4,%eax
  8030fd:	05 80 d0 81 00       	add    $0x81d080,%eax
  803102:	8b 00                	mov    (%eax),%eax
  803104:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803107:	e9 d5 00 00 00       	jmp    8031e1 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  80310c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310f:	8b 00                	mov    (%eax),%eax
  803111:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803114:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803117:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80311c:	29 c2                	sub    %eax,%edx
  80311e:	89 d0                	mov    %edx,%eax
  803120:	c1 e8 0c             	shr    $0xc,%eax
  803123:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803126:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803129:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80312c:	0f 85 a9 00 00 00    	jne    8031db <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  803132:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803136:	75 17                	jne    80314f <free_block+0x22b>
  803138:	83 ec 04             	sub    $0x4,%esp
  80313b:	68 45 45 80 00       	push   $0x804545
  803140:	68 04 01 00 00       	push   $0x104
  803145:	68 ab 44 80 00       	push   $0x8044ab
  80314a:	e8 c6 04 00 00       	call   803615 <_panic>
  80314f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803152:	8b 00                	mov    (%eax),%eax
  803154:	85 c0                	test   %eax,%eax
  803156:	74 10                	je     803168 <free_block+0x244>
  803158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803160:	8b 52 04             	mov    0x4(%edx),%edx
  803163:	89 50 04             	mov    %edx,0x4(%eax)
  803166:	eb 14                	jmp    80317c <free_block+0x258>
  803168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316b:	8b 40 04             	mov    0x4(%eax),%eax
  80316e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803171:	c1 e2 04             	shl    $0x4,%edx
  803174:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80317a:	89 02                	mov    %eax,(%edx)
  80317c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317f:	8b 40 04             	mov    0x4(%eax),%eax
  803182:	85 c0                	test   %eax,%eax
  803184:	74 0f                	je     803195 <free_block+0x271>
  803186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803189:	8b 40 04             	mov    0x4(%eax),%eax
  80318c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80318f:	8b 12                	mov    (%edx),%edx
  803191:	89 10                	mov    %edx,(%eax)
  803193:	eb 13                	jmp    8031a8 <free_block+0x284>
  803195:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803198:	8b 00                	mov    (%eax),%eax
  80319a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80319d:	c1 e2 04             	shl    $0x4,%edx
  8031a0:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8031a6:	89 02                	mov    %eax,(%edx)
  8031a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031be:	c1 e0 04             	shl    $0x4,%eax
  8031c1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031c6:	8b 00                	mov    (%eax),%eax
  8031c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8031cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ce:	c1 e0 04             	shl    $0x4,%eax
  8031d1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031d6:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8031d8:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8031db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8031e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031e5:	0f 85 21 ff ff ff    	jne    80310c <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8031eb:	b8 00 10 00 00       	mov    $0x1000,%eax
  8031f0:	99                   	cltd   
  8031f1:	f7 7d e8             	idivl  -0x18(%ebp)
  8031f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8031f7:	74 17                	je     803210 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8031f9:	83 ec 04             	sub    $0x4,%esp
  8031fc:	68 94 46 80 00       	push   $0x804694
  803201:	68 0c 01 00 00       	push   $0x10c
  803206:	68 ab 44 80 00       	push   $0x8044ab
  80320b:	e8 05 04 00 00       	call   803615 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803210:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803213:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803219:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321c:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803222:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803226:	75 17                	jne    80323f <free_block+0x31b>
  803228:	83 ec 04             	sub    $0x4,%esp
  80322b:	68 64 45 80 00       	push   $0x804564
  803230:	68 11 01 00 00       	push   $0x111
  803235:	68 ab 44 80 00       	push   $0x8044ab
  80323a:	e8 d6 03 00 00       	call   803615 <_panic>
  80323f:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803245:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803248:	89 50 04             	mov    %edx,0x4(%eax)
  80324b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324e:	8b 40 04             	mov    0x4(%eax),%eax
  803251:	85 c0                	test   %eax,%eax
  803253:	74 0c                	je     803261 <free_block+0x33d>
  803255:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80325a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80325d:	89 10                	mov    %edx,(%eax)
  80325f:	eb 08                	jmp    803269 <free_block+0x345>
  803261:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803264:	a3 48 50 80 00       	mov    %eax,0x805048
  803269:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326c:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803271:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803274:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327a:	a1 54 50 80 00       	mov    0x805054,%eax
  80327f:	40                   	inc    %eax
  803280:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803285:	83 ec 0c             	sub    $0xc,%esp
  803288:	ff 75 ec             	pushl  -0x14(%ebp)
  80328b:	e8 2b f4 ff ff       	call   8026bb <to_page_va>
  803290:	83 c4 10             	add    $0x10,%esp
  803293:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803296:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803299:	83 ec 0c             	sub    $0xc,%esp
  80329c:	50                   	push   %eax
  80329d:	e8 69 e8 ff ff       	call   801b0b <return_page>
  8032a2:	83 c4 10             	add    $0x10,%esp
  8032a5:	eb 01                	jmp    8032a8 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8032a7:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8032a8:	c9                   	leave  
  8032a9:	c3                   	ret    

008032aa <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8032aa:	55                   	push   %ebp
  8032ab:	89 e5                	mov    %esp,%ebp
  8032ad:	83 ec 14             	sub    $0x14,%esp
  8032b0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8032b3:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8032b7:	77 07                	ja     8032c0 <nearest_pow2_ceil.1572+0x16>
      return 1;
  8032b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8032be:	eb 20                	jmp    8032e0 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8032c0:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8032c7:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8032ca:	eb 08                	jmp    8032d4 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8032cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032cf:	01 c0                	add    %eax,%eax
  8032d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8032d4:	d1 6d 08             	shrl   0x8(%ebp)
  8032d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032db:	75 ef                	jne    8032cc <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8032dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8032e0:	c9                   	leave  
  8032e1:	c3                   	ret    

008032e2 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8032e2:	55                   	push   %ebp
  8032e3:	89 e5                	mov    %esp,%ebp
  8032e5:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8032e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ec:	75 13                	jne    803301 <realloc_block+0x1f>
    return alloc_block(new_size);
  8032ee:	83 ec 0c             	sub    $0xc,%esp
  8032f1:	ff 75 0c             	pushl  0xc(%ebp)
  8032f4:	e8 d1 f6 ff ff       	call   8029ca <alloc_block>
  8032f9:	83 c4 10             	add    $0x10,%esp
  8032fc:	e9 d9 00 00 00       	jmp    8033da <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803301:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803305:	75 18                	jne    80331f <realloc_block+0x3d>
    free_block(va);
  803307:	83 ec 0c             	sub    $0xc,%esp
  80330a:	ff 75 08             	pushl  0x8(%ebp)
  80330d:	e8 12 fc ff ff       	call   802f24 <free_block>
  803312:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803315:	b8 00 00 00 00       	mov    $0x0,%eax
  80331a:	e9 bb 00 00 00       	jmp    8033da <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  80331f:	83 ec 0c             	sub    $0xc,%esp
  803322:	ff 75 08             	pushl  0x8(%ebp)
  803325:	e8 38 f6 ff ff       	call   802962 <get_block_size>
  80332a:	83 c4 10             	add    $0x10,%esp
  80332d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803330:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80333d:	73 06                	jae    803345 <realloc_block+0x63>
    new_size = min_block_size;
  80333f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803342:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803345:	83 ec 0c             	sub    $0xc,%esp
  803348:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80334b:	ff 75 0c             	pushl  0xc(%ebp)
  80334e:	89 c1                	mov    %eax,%ecx
  803350:	e8 55 ff ff ff       	call   8032aa <nearest_pow2_ceil.1572>
  803355:	83 c4 10             	add    $0x10,%esp
  803358:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  80335b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803361:	75 05                	jne    803368 <realloc_block+0x86>
    return va;
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	eb 72                	jmp    8033da <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803368:	83 ec 0c             	sub    $0xc,%esp
  80336b:	ff 75 0c             	pushl  0xc(%ebp)
  80336e:	e8 57 f6 ff ff       	call   8029ca <alloc_block>
  803373:	83 c4 10             	add    $0x10,%esp
  803376:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803379:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80337d:	75 07                	jne    803386 <realloc_block+0xa4>
    return NULL;
  80337f:	b8 00 00 00 00       	mov    $0x0,%eax
  803384:	eb 54                	jmp    8033da <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803386:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80338c:	39 d0                	cmp    %edx,%eax
  80338e:	76 02                	jbe    803392 <realloc_block+0xb0>
  803390:	89 d0                	mov    %edx,%eax
  803392:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803395:	8b 45 08             	mov    0x8(%ebp),%eax
  803398:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  80339b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80339e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8033a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8033a8:	eb 17                	jmp    8033c1 <realloc_block+0xdf>
    dst[i] = src[i];
  8033aa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b0:	01 c2                	add    %eax,%edx
  8033b2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8033b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b8:	01 c8                	add    %ecx,%eax
  8033ba:	8a 00                	mov    (%eax),%al
  8033bc:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  8033be:	ff 45 f4             	incl   -0xc(%ebp)
  8033c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8033c7:	72 e1                	jb     8033aa <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  8033c9:	83 ec 0c             	sub    $0xc,%esp
  8033cc:	ff 75 08             	pushl  0x8(%ebp)
  8033cf:	e8 50 fb ff ff       	call   802f24 <free_block>
  8033d4:	83 c4 10             	add    $0x10,%esp

  return new_va;
  8033d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8033da:	c9                   	leave  
  8033db:	c3                   	ret    

008033dc <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8033dc:	55                   	push   %ebp
  8033dd:	89 e5                	mov    %esp,%ebp
  8033df:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  8033e2:	83 ec 04             	sub    $0x4,%esp
  8033e5:	68 c8 46 80 00       	push   $0x8046c8
  8033ea:	6a 07                	push   $0x7
  8033ec:	68 f7 46 80 00       	push   $0x8046f7
  8033f1:	e8 1f 02 00 00       	call   803615 <_panic>

008033f6 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8033f6:	55                   	push   %ebp
  8033f7:	89 e5                	mov    %esp,%ebp
  8033f9:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  8033fc:	83 ec 04             	sub    $0x4,%esp
  8033ff:	68 08 47 80 00       	push   $0x804708
  803404:	6a 0b                	push   $0xb
  803406:	68 f7 46 80 00       	push   $0x8046f7
  80340b:	e8 05 02 00 00       	call   803615 <_panic>

00803410 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  803410:	55                   	push   %ebp
  803411:	89 e5                	mov    %esp,%ebp
  803413:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803416:	83 ec 04             	sub    $0x4,%esp
  803419:	68 34 47 80 00       	push   $0x804734
  80341e:	6a 10                	push   $0x10
  803420:	68 f7 46 80 00       	push   $0x8046f7
  803425:	e8 eb 01 00 00       	call   803615 <_panic>

0080342a <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  80342a:	55                   	push   %ebp
  80342b:	89 e5                	mov    %esp,%ebp
  80342d:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  803430:	83 ec 04             	sub    $0x4,%esp
  803433:	68 64 47 80 00       	push   $0x804764
  803438:	6a 15                	push   $0x15
  80343a:	68 f7 46 80 00       	push   $0x8046f7
  80343f:	e8 d1 01 00 00       	call   803615 <_panic>

00803444 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  803444:	55                   	push   %ebp
  803445:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803447:	8b 45 08             	mov    0x8(%ebp),%eax
  80344a:	8b 40 10             	mov    0x10(%eax),%eax
}
  80344d:	5d                   	pop    %ebp
  80344e:	c3                   	ret    

0080344f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80344f:	55                   	push   %ebp
  803450:	89 e5                	mov    %esp,%ebp
  803452:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803455:	8b 55 08             	mov    0x8(%ebp),%edx
  803458:	89 d0                	mov    %edx,%eax
  80345a:	c1 e0 02             	shl    $0x2,%eax
  80345d:	01 d0                	add    %edx,%eax
  80345f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803466:	01 d0                	add    %edx,%eax
  803468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80346f:	01 d0                	add    %edx,%eax
  803471:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803478:	01 d0                	add    %edx,%eax
  80347a:	c1 e0 04             	shl    $0x4,%eax
  80347d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  803480:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803487:	0f 31                	rdtsc  
  803489:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80348c:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  80348f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803492:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803495:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803498:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80349b:	eb 46                	jmp    8034e3 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80349d:	0f 31                	rdtsc  
  80349f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8034a2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8034a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8034ae:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8034b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b7:	29 c2                	sub    %eax,%edx
  8034b9:	89 d0                	mov    %edx,%eax
  8034bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8034be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c4:	89 d1                	mov    %edx,%ecx
  8034c6:	29 c1                	sub    %eax,%ecx
  8034c8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8034cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034ce:	39 c2                	cmp    %eax,%edx
  8034d0:	0f 97 c0             	seta   %al
  8034d3:	0f b6 c0             	movzbl %al,%eax
  8034d6:	29 c1                	sub    %eax,%ecx
  8034d8:	89 c8                	mov    %ecx,%eax
  8034da:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8034dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8034e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8034e9:	72 b2                	jb     80349d <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8034eb:	90                   	nop
  8034ec:	c9                   	leave  
  8034ed:	c3                   	ret    

008034ee <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8034ee:	55                   	push   %ebp
  8034ef:	89 e5                	mov    %esp,%ebp
  8034f1:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8034f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8034fb:	eb 03                	jmp    803500 <busy_wait+0x12>
  8034fd:	ff 45 fc             	incl   -0x4(%ebp)
  803500:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803503:	3b 45 08             	cmp    0x8(%ebp),%eax
  803506:	72 f5                	jb     8034fd <busy_wait+0xf>
	return i;
  803508:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80350b:	c9                   	leave  
  80350c:	c3                   	ret    

0080350d <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  80350d:	55                   	push   %ebp
  80350e:	89 e5                	mov    %esp,%ebp
  803510:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  803513:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803517:	74 1c                	je     803535 <init_uspinlock+0x28>
  803519:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  80351d:	74 16                	je     803535 <init_uspinlock+0x28>
  80351f:	68 94 47 80 00       	push   $0x804794
  803524:	68 b3 47 80 00       	push   $0x8047b3
  803529:	6a 10                	push   $0x10
  80352b:	68 c8 47 80 00       	push   $0x8047c8
  803530:	e8 e0 00 00 00       	call   803615 <_panic>
	strcpy(lk->name, name);
  803535:	8b 45 08             	mov    0x8(%ebp),%eax
  803538:	83 c0 04             	add    $0x4,%eax
  80353b:	83 ec 08             	sub    $0x8,%esp
  80353e:	ff 75 0c             	pushl  0xc(%ebp)
  803541:	50                   	push   %eax
  803542:	e8 04 d7 ff ff       	call   800c4b <strcpy>
  803547:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  80354a:	b8 01 00 00 00       	mov    $0x1,%eax
  80354f:	2b 45 10             	sub    0x10(%ebp),%eax
  803552:	89 c2                	mov    %eax,%edx
  803554:	8b 45 08             	mov    0x8(%ebp),%eax
  803557:	89 10                	mov    %edx,(%eax)
}
  803559:	90                   	nop
  80355a:	c9                   	leave  
  80355b:	c3                   	ret    

0080355c <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  80355c:	55                   	push   %ebp
  80355d:	89 e5                	mov    %esp,%ebp
  80355f:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  803562:	90                   	nop
  803563:	8b 45 08             	mov    0x8(%ebp),%eax
  803566:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803569:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803570:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803576:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803579:	f0 87 02             	lock xchg %eax,(%edx)
  80357c:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  80357f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803582:	85 c0                	test   %eax,%eax
  803584:	75 dd                	jne    803563 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803586:	8b 45 08             	mov    0x8(%ebp),%eax
  803589:	8d 48 04             	lea    0x4(%eax),%ecx
  80358c:	a1 20 50 80 00       	mov    0x805020,%eax
  803591:	8d 50 20             	lea    0x20(%eax),%edx
  803594:	a1 20 50 80 00       	mov    0x805020,%eax
  803599:	8b 40 10             	mov    0x10(%eax),%eax
  80359c:	51                   	push   %ecx
  80359d:	52                   	push   %edx
  80359e:	50                   	push   %eax
  80359f:	68 d8 47 80 00       	push   $0x8047d8
  8035a4:	e8 7a cf ff ff       	call   800523 <cprintf>
  8035a9:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  8035ac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  8035b1:	90                   	nop
  8035b2:	c9                   	leave  
  8035b3:	c3                   	ret    

008035b4 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  8035b4:	55                   	push   %ebp
  8035b5:	89 e5                	mov    %esp,%ebp
  8035b7:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  8035ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bd:	8b 00                	mov    (%eax),%eax
  8035bf:	85 c0                	test   %eax,%eax
  8035c1:	75 18                	jne    8035db <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  8035c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c6:	83 c0 04             	add    $0x4,%eax
  8035c9:	50                   	push   %eax
  8035ca:	68 fc 47 80 00       	push   $0x8047fc
  8035cf:	6a 2b                	push   $0x2b
  8035d1:	68 c8 47 80 00       	push   $0x8047c8
  8035d6:	e8 3a 00 00 00       	call   803615 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  8035db:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8035ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ef:	8d 48 04             	lea    0x4(%eax),%ecx
  8035f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8035f7:	8d 50 20             	lea    0x20(%eax),%edx
  8035fa:	a1 20 50 80 00       	mov    0x805020,%eax
  8035ff:	8b 40 10             	mov    0x10(%eax),%eax
  803602:	51                   	push   %ecx
  803603:	52                   	push   %edx
  803604:	50                   	push   %eax
  803605:	68 1c 48 80 00       	push   $0x80481c
  80360a:	e8 14 cf ff ff       	call   800523 <cprintf>
  80360f:	83 c4 10             	add    $0x10,%esp
}
  803612:	90                   	nop
  803613:	c9                   	leave  
  803614:	c3                   	ret    

00803615 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803615:	55                   	push   %ebp
  803616:	89 e5                	mov    %esp,%ebp
  803618:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80361b:	8d 45 10             	lea    0x10(%ebp),%eax
  80361e:	83 c0 04             	add    $0x4,%eax
  803621:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803624:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  803629:	85 c0                	test   %eax,%eax
  80362b:	74 16                	je     803643 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80362d:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  803632:	83 ec 08             	sub    $0x8,%esp
  803635:	50                   	push   %eax
  803636:	68 40 48 80 00       	push   $0x804840
  80363b:	e8 e3 ce ff ff       	call   800523 <cprintf>
  803640:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803643:	a1 04 50 80 00       	mov    0x805004,%eax
  803648:	83 ec 0c             	sub    $0xc,%esp
  80364b:	ff 75 0c             	pushl  0xc(%ebp)
  80364e:	ff 75 08             	pushl  0x8(%ebp)
  803651:	50                   	push   %eax
  803652:	68 48 48 80 00       	push   $0x804848
  803657:	6a 74                	push   $0x74
  803659:	e8 f2 ce ff ff       	call   800550 <cprintf_colored>
  80365e:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803661:	8b 45 10             	mov    0x10(%ebp),%eax
  803664:	83 ec 08             	sub    $0x8,%esp
  803667:	ff 75 f4             	pushl  -0xc(%ebp)
  80366a:	50                   	push   %eax
  80366b:	e8 44 ce ff ff       	call   8004b4 <vcprintf>
  803670:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803673:	83 ec 08             	sub    $0x8,%esp
  803676:	6a 00                	push   $0x0
  803678:	68 70 48 80 00       	push   $0x804870
  80367d:	e8 32 ce ff ff       	call   8004b4 <vcprintf>
  803682:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803685:	e8 ab cd ff ff       	call   800435 <exit>

	// should not return here
	while (1) ;
  80368a:	eb fe                	jmp    80368a <_panic+0x75>

0080368c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80368c:	55                   	push   %ebp
  80368d:	89 e5                	mov    %esp,%ebp
  80368f:	53                   	push   %ebx
  803690:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803693:	a1 20 50 80 00       	mov    0x805020,%eax
  803698:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80369e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036a1:	39 c2                	cmp    %eax,%edx
  8036a3:	74 14                	je     8036b9 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8036a5:	83 ec 04             	sub    $0x4,%esp
  8036a8:	68 74 48 80 00       	push   $0x804874
  8036ad:	6a 26                	push   $0x26
  8036af:	68 c0 48 80 00       	push   $0x8048c0
  8036b4:	e8 5c ff ff ff       	call   803615 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8036b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8036c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8036c7:	e9 d9 00 00 00       	jmp    8037a5 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8036cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d9:	01 d0                	add    %edx,%eax
  8036db:	8b 00                	mov    (%eax),%eax
  8036dd:	85 c0                	test   %eax,%eax
  8036df:	75 08                	jne    8036e9 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8036e1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8036e4:	e9 b9 00 00 00       	jmp    8037a2 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8036e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8036f7:	eb 79                	jmp    803772 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8036f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8036fe:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803704:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803707:	89 d0                	mov    %edx,%eax
  803709:	01 c0                	add    %eax,%eax
  80370b:	01 d0                	add    %edx,%eax
  80370d:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803714:	01 d8                	add    %ebx,%eax
  803716:	01 d0                	add    %edx,%eax
  803718:	01 c8                	add    %ecx,%eax
  80371a:	8a 40 04             	mov    0x4(%eax),%al
  80371d:	84 c0                	test   %al,%al
  80371f:	75 4e                	jne    80376f <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803721:	a1 20 50 80 00       	mov    0x805020,%eax
  803726:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80372c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80372f:	89 d0                	mov    %edx,%eax
  803731:	01 c0                	add    %eax,%eax
  803733:	01 d0                	add    %edx,%eax
  803735:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80373c:	01 d8                	add    %ebx,%eax
  80373e:	01 d0                	add    %edx,%eax
  803740:	01 c8                	add    %ecx,%eax
  803742:	8b 00                	mov    (%eax),%eax
  803744:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803747:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80374a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80374f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803754:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80375b:	8b 45 08             	mov    0x8(%ebp),%eax
  80375e:	01 c8                	add    %ecx,%eax
  803760:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803762:	39 c2                	cmp    %eax,%edx
  803764:	75 09                	jne    80376f <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  803766:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80376d:	eb 19                	jmp    803788 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80376f:	ff 45 e8             	incl   -0x18(%ebp)
  803772:	a1 20 50 80 00       	mov    0x805020,%eax
  803777:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80377d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803780:	39 c2                	cmp    %eax,%edx
  803782:	0f 87 71 ff ff ff    	ja     8036f9 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803788:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80378c:	75 14                	jne    8037a2 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80378e:	83 ec 04             	sub    $0x4,%esp
  803791:	68 cc 48 80 00       	push   $0x8048cc
  803796:	6a 3a                	push   $0x3a
  803798:	68 c0 48 80 00       	push   $0x8048c0
  80379d:	e8 73 fe ff ff       	call   803615 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8037a2:	ff 45 f0             	incl   -0x10(%ebp)
  8037a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8037ab:	0f 8c 1b ff ff ff    	jl     8036cc <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8037b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8037bf:	eb 2e                	jmp    8037ef <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8037c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8037c6:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8037cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037cf:	89 d0                	mov    %edx,%eax
  8037d1:	01 c0                	add    %eax,%eax
  8037d3:	01 d0                	add    %edx,%eax
  8037d5:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8037dc:	01 d8                	add    %ebx,%eax
  8037de:	01 d0                	add    %edx,%eax
  8037e0:	01 c8                	add    %ecx,%eax
  8037e2:	8a 40 04             	mov    0x4(%eax),%al
  8037e5:	3c 01                	cmp    $0x1,%al
  8037e7:	75 03                	jne    8037ec <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8037e9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037ec:	ff 45 e0             	incl   -0x20(%ebp)
  8037ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8037f4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8037fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037fd:	39 c2                	cmp    %eax,%edx
  8037ff:	77 c0                	ja     8037c1 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803804:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803807:	74 14                	je     80381d <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  803809:	83 ec 04             	sub    $0x4,%esp
  80380c:	68 20 49 80 00       	push   $0x804920
  803811:	6a 44                	push   $0x44
  803813:	68 c0 48 80 00       	push   $0x8048c0
  803818:	e8 f8 fd ff ff       	call   803615 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80381d:	90                   	nop
  80381e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803821:	c9                   	leave  
  803822:	c3                   	ret    
  803823:	90                   	nop

00803824 <__udivdi3>:
  803824:	55                   	push   %ebp
  803825:	57                   	push   %edi
  803826:	56                   	push   %esi
  803827:	53                   	push   %ebx
  803828:	83 ec 1c             	sub    $0x1c,%esp
  80382b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80382f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803833:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803837:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80383b:	89 ca                	mov    %ecx,%edx
  80383d:	89 f8                	mov    %edi,%eax
  80383f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803843:	85 f6                	test   %esi,%esi
  803845:	75 2d                	jne    803874 <__udivdi3+0x50>
  803847:	39 cf                	cmp    %ecx,%edi
  803849:	77 65                	ja     8038b0 <__udivdi3+0x8c>
  80384b:	89 fd                	mov    %edi,%ebp
  80384d:	85 ff                	test   %edi,%edi
  80384f:	75 0b                	jne    80385c <__udivdi3+0x38>
  803851:	b8 01 00 00 00       	mov    $0x1,%eax
  803856:	31 d2                	xor    %edx,%edx
  803858:	f7 f7                	div    %edi
  80385a:	89 c5                	mov    %eax,%ebp
  80385c:	31 d2                	xor    %edx,%edx
  80385e:	89 c8                	mov    %ecx,%eax
  803860:	f7 f5                	div    %ebp
  803862:	89 c1                	mov    %eax,%ecx
  803864:	89 d8                	mov    %ebx,%eax
  803866:	f7 f5                	div    %ebp
  803868:	89 cf                	mov    %ecx,%edi
  80386a:	89 fa                	mov    %edi,%edx
  80386c:	83 c4 1c             	add    $0x1c,%esp
  80386f:	5b                   	pop    %ebx
  803870:	5e                   	pop    %esi
  803871:	5f                   	pop    %edi
  803872:	5d                   	pop    %ebp
  803873:	c3                   	ret    
  803874:	39 ce                	cmp    %ecx,%esi
  803876:	77 28                	ja     8038a0 <__udivdi3+0x7c>
  803878:	0f bd fe             	bsr    %esi,%edi
  80387b:	83 f7 1f             	xor    $0x1f,%edi
  80387e:	75 40                	jne    8038c0 <__udivdi3+0x9c>
  803880:	39 ce                	cmp    %ecx,%esi
  803882:	72 0a                	jb     80388e <__udivdi3+0x6a>
  803884:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803888:	0f 87 9e 00 00 00    	ja     80392c <__udivdi3+0x108>
  80388e:	b8 01 00 00 00       	mov    $0x1,%eax
  803893:	89 fa                	mov    %edi,%edx
  803895:	83 c4 1c             	add    $0x1c,%esp
  803898:	5b                   	pop    %ebx
  803899:	5e                   	pop    %esi
  80389a:	5f                   	pop    %edi
  80389b:	5d                   	pop    %ebp
  80389c:	c3                   	ret    
  80389d:	8d 76 00             	lea    0x0(%esi),%esi
  8038a0:	31 ff                	xor    %edi,%edi
  8038a2:	31 c0                	xor    %eax,%eax
  8038a4:	89 fa                	mov    %edi,%edx
  8038a6:	83 c4 1c             	add    $0x1c,%esp
  8038a9:	5b                   	pop    %ebx
  8038aa:	5e                   	pop    %esi
  8038ab:	5f                   	pop    %edi
  8038ac:	5d                   	pop    %ebp
  8038ad:	c3                   	ret    
  8038ae:	66 90                	xchg   %ax,%ax
  8038b0:	89 d8                	mov    %ebx,%eax
  8038b2:	f7 f7                	div    %edi
  8038b4:	31 ff                	xor    %edi,%edi
  8038b6:	89 fa                	mov    %edi,%edx
  8038b8:	83 c4 1c             	add    $0x1c,%esp
  8038bb:	5b                   	pop    %ebx
  8038bc:	5e                   	pop    %esi
  8038bd:	5f                   	pop    %edi
  8038be:	5d                   	pop    %ebp
  8038bf:	c3                   	ret    
  8038c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038c5:	89 eb                	mov    %ebp,%ebx
  8038c7:	29 fb                	sub    %edi,%ebx
  8038c9:	89 f9                	mov    %edi,%ecx
  8038cb:	d3 e6                	shl    %cl,%esi
  8038cd:	89 c5                	mov    %eax,%ebp
  8038cf:	88 d9                	mov    %bl,%cl
  8038d1:	d3 ed                	shr    %cl,%ebp
  8038d3:	89 e9                	mov    %ebp,%ecx
  8038d5:	09 f1                	or     %esi,%ecx
  8038d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038db:	89 f9                	mov    %edi,%ecx
  8038dd:	d3 e0                	shl    %cl,%eax
  8038df:	89 c5                	mov    %eax,%ebp
  8038e1:	89 d6                	mov    %edx,%esi
  8038e3:	88 d9                	mov    %bl,%cl
  8038e5:	d3 ee                	shr    %cl,%esi
  8038e7:	89 f9                	mov    %edi,%ecx
  8038e9:	d3 e2                	shl    %cl,%edx
  8038eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038ef:	88 d9                	mov    %bl,%cl
  8038f1:	d3 e8                	shr    %cl,%eax
  8038f3:	09 c2                	or     %eax,%edx
  8038f5:	89 d0                	mov    %edx,%eax
  8038f7:	89 f2                	mov    %esi,%edx
  8038f9:	f7 74 24 0c          	divl   0xc(%esp)
  8038fd:	89 d6                	mov    %edx,%esi
  8038ff:	89 c3                	mov    %eax,%ebx
  803901:	f7 e5                	mul    %ebp
  803903:	39 d6                	cmp    %edx,%esi
  803905:	72 19                	jb     803920 <__udivdi3+0xfc>
  803907:	74 0b                	je     803914 <__udivdi3+0xf0>
  803909:	89 d8                	mov    %ebx,%eax
  80390b:	31 ff                	xor    %edi,%edi
  80390d:	e9 58 ff ff ff       	jmp    80386a <__udivdi3+0x46>
  803912:	66 90                	xchg   %ax,%ax
  803914:	8b 54 24 08          	mov    0x8(%esp),%edx
  803918:	89 f9                	mov    %edi,%ecx
  80391a:	d3 e2                	shl    %cl,%edx
  80391c:	39 c2                	cmp    %eax,%edx
  80391e:	73 e9                	jae    803909 <__udivdi3+0xe5>
  803920:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803923:	31 ff                	xor    %edi,%edi
  803925:	e9 40 ff ff ff       	jmp    80386a <__udivdi3+0x46>
  80392a:	66 90                	xchg   %ax,%ax
  80392c:	31 c0                	xor    %eax,%eax
  80392e:	e9 37 ff ff ff       	jmp    80386a <__udivdi3+0x46>
  803933:	90                   	nop

00803934 <__umoddi3>:
  803934:	55                   	push   %ebp
  803935:	57                   	push   %edi
  803936:	56                   	push   %esi
  803937:	53                   	push   %ebx
  803938:	83 ec 1c             	sub    $0x1c,%esp
  80393b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80393f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803943:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803947:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80394b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80394f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803953:	89 f3                	mov    %esi,%ebx
  803955:	89 fa                	mov    %edi,%edx
  803957:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80395b:	89 34 24             	mov    %esi,(%esp)
  80395e:	85 c0                	test   %eax,%eax
  803960:	75 1a                	jne    80397c <__umoddi3+0x48>
  803962:	39 f7                	cmp    %esi,%edi
  803964:	0f 86 a2 00 00 00    	jbe    803a0c <__umoddi3+0xd8>
  80396a:	89 c8                	mov    %ecx,%eax
  80396c:	89 f2                	mov    %esi,%edx
  80396e:	f7 f7                	div    %edi
  803970:	89 d0                	mov    %edx,%eax
  803972:	31 d2                	xor    %edx,%edx
  803974:	83 c4 1c             	add    $0x1c,%esp
  803977:	5b                   	pop    %ebx
  803978:	5e                   	pop    %esi
  803979:	5f                   	pop    %edi
  80397a:	5d                   	pop    %ebp
  80397b:	c3                   	ret    
  80397c:	39 f0                	cmp    %esi,%eax
  80397e:	0f 87 ac 00 00 00    	ja     803a30 <__umoddi3+0xfc>
  803984:	0f bd e8             	bsr    %eax,%ebp
  803987:	83 f5 1f             	xor    $0x1f,%ebp
  80398a:	0f 84 ac 00 00 00    	je     803a3c <__umoddi3+0x108>
  803990:	bf 20 00 00 00       	mov    $0x20,%edi
  803995:	29 ef                	sub    %ebp,%edi
  803997:	89 fe                	mov    %edi,%esi
  803999:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80399d:	89 e9                	mov    %ebp,%ecx
  80399f:	d3 e0                	shl    %cl,%eax
  8039a1:	89 d7                	mov    %edx,%edi
  8039a3:	89 f1                	mov    %esi,%ecx
  8039a5:	d3 ef                	shr    %cl,%edi
  8039a7:	09 c7                	or     %eax,%edi
  8039a9:	89 e9                	mov    %ebp,%ecx
  8039ab:	d3 e2                	shl    %cl,%edx
  8039ad:	89 14 24             	mov    %edx,(%esp)
  8039b0:	89 d8                	mov    %ebx,%eax
  8039b2:	d3 e0                	shl    %cl,%eax
  8039b4:	89 c2                	mov    %eax,%edx
  8039b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039ba:	d3 e0                	shl    %cl,%eax
  8039bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039c4:	89 f1                	mov    %esi,%ecx
  8039c6:	d3 e8                	shr    %cl,%eax
  8039c8:	09 d0                	or     %edx,%eax
  8039ca:	d3 eb                	shr    %cl,%ebx
  8039cc:	89 da                	mov    %ebx,%edx
  8039ce:	f7 f7                	div    %edi
  8039d0:	89 d3                	mov    %edx,%ebx
  8039d2:	f7 24 24             	mull   (%esp)
  8039d5:	89 c6                	mov    %eax,%esi
  8039d7:	89 d1                	mov    %edx,%ecx
  8039d9:	39 d3                	cmp    %edx,%ebx
  8039db:	0f 82 87 00 00 00    	jb     803a68 <__umoddi3+0x134>
  8039e1:	0f 84 91 00 00 00    	je     803a78 <__umoddi3+0x144>
  8039e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039eb:	29 f2                	sub    %esi,%edx
  8039ed:	19 cb                	sbb    %ecx,%ebx
  8039ef:	89 d8                	mov    %ebx,%eax
  8039f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039f5:	d3 e0                	shl    %cl,%eax
  8039f7:	89 e9                	mov    %ebp,%ecx
  8039f9:	d3 ea                	shr    %cl,%edx
  8039fb:	09 d0                	or     %edx,%eax
  8039fd:	89 e9                	mov    %ebp,%ecx
  8039ff:	d3 eb                	shr    %cl,%ebx
  803a01:	89 da                	mov    %ebx,%edx
  803a03:	83 c4 1c             	add    $0x1c,%esp
  803a06:	5b                   	pop    %ebx
  803a07:	5e                   	pop    %esi
  803a08:	5f                   	pop    %edi
  803a09:	5d                   	pop    %ebp
  803a0a:	c3                   	ret    
  803a0b:	90                   	nop
  803a0c:	89 fd                	mov    %edi,%ebp
  803a0e:	85 ff                	test   %edi,%edi
  803a10:	75 0b                	jne    803a1d <__umoddi3+0xe9>
  803a12:	b8 01 00 00 00       	mov    $0x1,%eax
  803a17:	31 d2                	xor    %edx,%edx
  803a19:	f7 f7                	div    %edi
  803a1b:	89 c5                	mov    %eax,%ebp
  803a1d:	89 f0                	mov    %esi,%eax
  803a1f:	31 d2                	xor    %edx,%edx
  803a21:	f7 f5                	div    %ebp
  803a23:	89 c8                	mov    %ecx,%eax
  803a25:	f7 f5                	div    %ebp
  803a27:	89 d0                	mov    %edx,%eax
  803a29:	e9 44 ff ff ff       	jmp    803972 <__umoddi3+0x3e>
  803a2e:	66 90                	xchg   %ax,%ax
  803a30:	89 c8                	mov    %ecx,%eax
  803a32:	89 f2                	mov    %esi,%edx
  803a34:	83 c4 1c             	add    $0x1c,%esp
  803a37:	5b                   	pop    %ebx
  803a38:	5e                   	pop    %esi
  803a39:	5f                   	pop    %edi
  803a3a:	5d                   	pop    %ebp
  803a3b:	c3                   	ret    
  803a3c:	3b 04 24             	cmp    (%esp),%eax
  803a3f:	72 06                	jb     803a47 <__umoddi3+0x113>
  803a41:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a45:	77 0f                	ja     803a56 <__umoddi3+0x122>
  803a47:	89 f2                	mov    %esi,%edx
  803a49:	29 f9                	sub    %edi,%ecx
  803a4b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a4f:	89 14 24             	mov    %edx,(%esp)
  803a52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a56:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a5a:	8b 14 24             	mov    (%esp),%edx
  803a5d:	83 c4 1c             	add    $0x1c,%esp
  803a60:	5b                   	pop    %ebx
  803a61:	5e                   	pop    %esi
  803a62:	5f                   	pop    %edi
  803a63:	5d                   	pop    %ebp
  803a64:	c3                   	ret    
  803a65:	8d 76 00             	lea    0x0(%esi),%esi
  803a68:	2b 04 24             	sub    (%esp),%eax
  803a6b:	19 fa                	sbb    %edi,%edx
  803a6d:	89 d1                	mov    %edx,%ecx
  803a6f:	89 c6                	mov    %eax,%esi
  803a71:	e9 71 ff ff ff       	jmp    8039e7 <__umoddi3+0xb3>
  803a76:	66 90                	xchg   %ax,%ax
  803a78:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a7c:	72 ea                	jb     803a68 <__umoddi3+0x134>
  803a7e:	89 d9                	mov    %ebx,%ecx
  803a80:	e9 62 ff ff ff       	jmp    8039e7 <__umoddi3+0xb3>
