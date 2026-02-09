
obj/user/MidTermEx_ProcessA:     file format elf32-i386


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
  800031:	e8 5e 02 00 00       	call   800294 <libmain>
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
  800048:	e8 c5 23 00 00       	call   802412 <sys_getparentenvid>
  80004d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	68 a0 3a 80 00       	push   $0x803aa0
  800058:	ff 75 ec             	pushl  -0x14(%ebp)
  80005b:	e8 0f 1f 00 00       	call   801f6f <sget>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int *protType = sget(parentenvID, "protType") ;
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	68 a2 3a 80 00       	push   $0x803aa2
  80006e:	ff 75 ec             	pushl  -0x14(%ebp)
  800071:	e8 f9 1e 00 00       	call   801f6f <sget>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	68 ab 3a 80 00       	push   $0x803aab
  800084:	ff 75 ec             	pushl  -0x14(%ebp)
  800087:	e8 e3 1e 00 00       	call   801f6f <sget>
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
  8000ab:	e8 47 33 00 00       	call   8033f7 <get_semaphore>
  8000b0:	83 c4 0c             	add    $0xc,%esp
		finished = get_semaphore(parentenvID, "finished");
  8000b3:	8d 45 b8             	lea    -0x48(%ebp),%eax
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	68 bb 3a 80 00       	push   $0x803abb
  8000be:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c1:	50                   	push   %eax
  8000c2:	e8 30 33 00 00       	call   8033f7 <get_semaphore>
  8000c7:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = get_semaphore(parentenvID, "finishedCountMutex");
  8000ca:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 c4 3a 80 00       	push   $0x803ac4
  8000d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d8:	50                   	push   %eax
  8000d9:	e8 19 33 00 00       	call   8033f7 <get_semaphore>
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
  8000f8:	e8 72 1e 00 00       	call   801f6f <sget>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 f4             	mov    %eax,-0xc(%ebp)
		sfinishedCountMutex = sget(parentenvID, "finishedCountMutex");
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	68 c4 3a 80 00       	push   $0x803ac4
  80010b:	ff 75 ec             	pushl  -0x14(%ebp)
  80010e:	e8 5c 1e 00 00       	call   801f6f <sget>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800119:	8d 45 c0             	lea    -0x40(%ebp),%eax
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	50                   	push   %eax
  800120:	e8 20 23 00 00       	call   802445 <sys_get_virtual_time>
  800125:	83 c4 0c             	add    $0xc,%esp
  800128:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80012b:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  800130:	ba 00 00 00 00       	mov    $0x0,%edx
  800135:	f7 f1                	div    %ecx
  800137:	89 d0                	mov    %edx,%eax
  800139:	05 d0 07 00 00       	add    $0x7d0,%eax
  80013e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  800141:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	50                   	push   %eax
  800148:	e8 03 33 00 00       	call   803450 <env_sleep>
  80014d:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	Y = (*X) * 2 ;
  800150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800153:	8b 00                	mov    (%eax),%eax
  800155:	01 c0                	add    %eax,%eax
  800157:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  80015a:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	50                   	push   %eax
  800161:	e8 df 22 00 00       	call   802445 <sys_get_virtual_time>
  800166:	83 c4 0c             	add    $0xc,%esp
  800169:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80016c:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  800171:	ba 00 00 00 00       	mov    $0x0,%edx
  800176:	f7 f1                	div    %ecx
  800178:	89 d0                	mov    %edx,%eax
  80017a:	05 d0 07 00 00       	add    $0x7d0,%eax
  80017f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  800182:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	50                   	push   %eax
  800189:	e8 c2 32 00 00       	call   803450 <env_sleep>
  80018e:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	(*X) = Y ;
  800191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800194:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800197:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800199:	8d 45 d0             	lea    -0x30(%ebp),%eax
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	50                   	push   %eax
  8001a0:	e8 a0 22 00 00       	call   802445 <sys_get_virtual_time>
  8001a5:	83 c4 0c             	add    $0xc,%esp
  8001a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001ab:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8001b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8001b5:	f7 f1                	div    %ecx
  8001b7:	89 d0                	mov    %edx,%eax
  8001b9:	05 d0 07 00 00       	add    $0x7d0,%eax
  8001be:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  8001c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	50                   	push   %eax
  8001c8:	e8 83 32 00 00       	call   803450 <env_sleep>
  8001cd:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	if (*protType == 1)
  8001d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	83 f8 01             	cmp    $0x1,%eax
  8001d8:	75 10                	jne    8001ea <_main+0x1b2>
	{
		signal_semaphore(T);
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8001e0:	e8 46 32 00 00       	call   80342b <signal_semaphore>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	eb 18                	jmp    800202 <_main+0x1ca>
	}
	else if (*protType == 2)
  8001ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ed:	8b 00                	mov    (%eax),%eax
  8001ef:	83 f8 02             	cmp    $0x2,%eax
  8001f2:	75 0e                	jne    800202 <_main+0x1ca>
	{
		release_uspinlock(sT);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001fa:	e8 b6 33 00 00       	call   8035b5 <release_uspinlock>
  8001ff:	83 c4 10             	add    $0x10,%esp
	}
	/*[3] DECLARE FINISHING*/
	if (*protType == 1)
  800202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800205:	8b 00                	mov    (%eax),%eax
  800207:	83 f8 01             	cmp    $0x1,%eax
  80020a:	75 39                	jne    800245 <_main+0x20d>
	{
		signal_semaphore(finished);
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	ff 75 b8             	pushl  -0x48(%ebp)
  800212:	e8 14 32 00 00       	call   80342b <signal_semaphore>
  800217:	83 c4 10             	add    $0x10,%esp

		wait_semaphore(finishedCountMutex);
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	ff 75 b4             	pushl  -0x4c(%ebp)
  800220:	e8 ec 31 00 00       	call   803411 <wait_semaphore>
  800225:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  800228:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022b:	8b 00                	mov    (%eax),%eax
  80022d:	8d 50 01             	lea    0x1(%eax),%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(finishedCountMutex);
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	ff 75 b4             	pushl  -0x4c(%ebp)
  80023b:	e8 eb 31 00 00       	call   80342b <signal_semaphore>
  800240:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
	}


}
  800243:	eb 4c                	jmp    800291 <_main+0x259>
		{
			(*finishedCount)++ ;
		}
		signal_semaphore(finishedCountMutex);
	}
	else if (*protType == 2)
  800245:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800248:	8b 00                	mov    (%eax),%eax
  80024a:	83 f8 02             	cmp    $0x2,%eax
  80024d:	75 2b                	jne    80027a <_main+0x242>
	{
		acquire_uspinlock(sfinishedCountMutex);
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 f0             	pushl  -0x10(%ebp)
  800255:	e8 03 33 00 00       	call   80355d <acquire_uspinlock>
  80025a:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  80025d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800260:	8b 00                	mov    (%eax),%eax
  800262:	8d 50 01             	lea    0x1(%eax),%edx
  800265:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800268:	89 10                	mov    %edx,(%eax)
		}
		release_uspinlock(sfinishedCountMutex);
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	ff 75 f0             	pushl  -0x10(%ebp)
  800270:	e8 40 33 00 00       	call   8035b5 <release_uspinlock>
  800275:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
	}


}
  800278:	eb 17                	jmp    800291 <_main+0x259>
		}
		release_uspinlock(sfinishedCountMutex);
	}
	else
	{
		sys_lock_cons();
  80027a:	e8 01 1f 00 00       	call   802180 <sys_lock_cons>
		{
			(*finishedCount)++ ;
  80027f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800282:	8b 00                	mov    (%eax),%eax
  800284:	8d 50 01             	lea    0x1(%eax),%edx
  800287:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028a:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80028c:	e8 09 1f 00 00       	call   80219a <sys_unlock_cons>
	}


}
  800291:	90                   	nop
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	57                   	push   %edi
  800298:	56                   	push   %esi
  800299:	53                   	push   %ebx
  80029a:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80029d:	e8 57 21 00 00       	call   8023f9 <sys_getenvindex>
  8002a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a8:	89 d0                	mov    %edx,%eax
  8002aa:	01 c0                	add    %eax,%eax
  8002ac:	01 d0                	add    %edx,%eax
  8002ae:	c1 e0 02             	shl    $0x2,%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	c1 e0 02             	shl    $0x2,%eax
  8002b6:	01 d0                	add    %edx,%eax
  8002b8:	c1 e0 03             	shl    $0x3,%eax
  8002bb:	01 d0                	add    %edx,%eax
  8002bd:	c1 e0 02             	shl    $0x2,%eax
  8002c0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002c5:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8002cf:	8a 40 20             	mov    0x20(%eax),%al
  8002d2:	84 c0                	test   %al,%al
  8002d4:	74 0d                	je     8002e3 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8002db:	83 c0 20             	add    $0x20,%eax
  8002de:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002e7:	7e 0a                	jle    8002f3 <libmain+0x5f>
		binaryname = argv[0];
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ec:	8b 00                	mov    (%eax),%eax
  8002ee:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8002f3:	83 ec 08             	sub    $0x8,%esp
  8002f6:	ff 75 0c             	pushl  0xc(%ebp)
  8002f9:	ff 75 08             	pushl  0x8(%ebp)
  8002fc:	e8 37 fd ff ff       	call   800038 <_main>
  800301:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800304:	a1 00 50 80 00       	mov    0x805000,%eax
  800309:	85 c0                	test   %eax,%eax
  80030b:	0f 84 01 01 00 00    	je     800412 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800311:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800317:	bb d0 3b 80 00       	mov    $0x803bd0,%ebx
  80031c:	ba 0e 00 00 00       	mov    $0xe,%edx
  800321:	89 c7                	mov    %eax,%edi
  800323:	89 de                	mov    %ebx,%esi
  800325:	89 d1                	mov    %edx,%ecx
  800327:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800329:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80032c:	b9 56 00 00 00       	mov    $0x56,%ecx
  800331:	b0 00                	mov    $0x0,%al
  800333:	89 d7                	mov    %edx,%edi
  800335:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800337:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80033e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	50                   	push   %eax
  800345:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80034b:	50                   	push   %eax
  80034c:	e8 de 22 00 00       	call   80262f <sys_utilities>
  800351:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800354:	e8 27 1e 00 00       	call   802180 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	68 f0 3a 80 00       	push   $0x803af0
  800361:	e8 be 01 00 00       	call   800524 <cprintf>
  800366:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800369:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036c:	85 c0                	test   %eax,%eax
  80036e:	74 18                	je     800388 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800370:	e8 d8 22 00 00       	call   80264d <sys_get_optimal_num_faults>
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	50                   	push   %eax
  800379:	68 18 3b 80 00       	push   $0x803b18
  80037e:	e8 a1 01 00 00       	call   800524 <cprintf>
  800383:	83 c4 10             	add    $0x10,%esp
  800386:	eb 59                	jmp    8003e1 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800388:	a1 20 50 80 00       	mov    0x805020,%eax
  80038d:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800393:	a1 20 50 80 00       	mov    0x805020,%eax
  800398:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80039e:	83 ec 04             	sub    $0x4,%esp
  8003a1:	52                   	push   %edx
  8003a2:	50                   	push   %eax
  8003a3:	68 3c 3b 80 00       	push   $0x803b3c
  8003a8:	e8 77 01 00 00       	call   800524 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b5:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8003bb:	a1 20 50 80 00       	mov    0x805020,%eax
  8003c0:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8003c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8003cb:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8003d1:	51                   	push   %ecx
  8003d2:	52                   	push   %edx
  8003d3:	50                   	push   %eax
  8003d4:	68 64 3b 80 00       	push   $0x803b64
  8003d9:	e8 46 01 00 00       	call   800524 <cprintf>
  8003de:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e6:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8003ec:	83 ec 08             	sub    $0x8,%esp
  8003ef:	50                   	push   %eax
  8003f0:	68 bc 3b 80 00       	push   $0x803bbc
  8003f5:	e8 2a 01 00 00       	call   800524 <cprintf>
  8003fa:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003fd:	83 ec 0c             	sub    $0xc,%esp
  800400:	68 f0 3a 80 00       	push   $0x803af0
  800405:	e8 1a 01 00 00       	call   800524 <cprintf>
  80040a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80040d:	e8 88 1d 00 00       	call   80219a <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800412:	e8 1f 00 00 00       	call   800436 <exit>
}
  800417:	90                   	nop
  800418:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80041b:	5b                   	pop    %ebx
  80041c:	5e                   	pop    %esi
  80041d:	5f                   	pop    %edi
  80041e:	5d                   	pop    %ebp
  80041f:	c3                   	ret    

00800420 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800426:	83 ec 0c             	sub    $0xc,%esp
  800429:	6a 00                	push   $0x0
  80042b:	e8 95 1f 00 00       	call   8023c5 <sys_destroy_env>
  800430:	83 c4 10             	add    $0x10,%esp
}
  800433:	90                   	nop
  800434:	c9                   	leave  
  800435:	c3                   	ret    

00800436 <exit>:

void
exit(void)
{
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80043c:	e8 ea 1f 00 00       	call   80242b <sys_exit_env>
}
  800441:	90                   	nop
  800442:	c9                   	leave  
  800443:	c3                   	ret    

00800444 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800444:	55                   	push   %ebp
  800445:	89 e5                	mov    %esp,%ebp
  800447:	53                   	push   %ebx
  800448:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80044b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	8d 48 01             	lea    0x1(%eax),%ecx
  800453:	8b 55 0c             	mov    0xc(%ebp),%edx
  800456:	89 0a                	mov    %ecx,(%edx)
  800458:	8b 55 08             	mov    0x8(%ebp),%edx
  80045b:	88 d1                	mov    %dl,%cl
  80045d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800460:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800464:	8b 45 0c             	mov    0xc(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	3d ff 00 00 00       	cmp    $0xff,%eax
  80046e:	75 30                	jne    8004a0 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800470:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  800476:	a0 44 50 80 00       	mov    0x805044,%al
  80047b:	0f b6 c0             	movzbl %al,%eax
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	8b 09                	mov    (%ecx),%ecx
  800483:	89 cb                	mov    %ecx,%ebx
  800485:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800488:	83 c1 08             	add    $0x8,%ecx
  80048b:	52                   	push   %edx
  80048c:	50                   	push   %eax
  80048d:	53                   	push   %ebx
  80048e:	51                   	push   %ecx
  80048f:	e8 a8 1c 00 00       	call   80213c <sys_cputs>
  800494:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a3:	8b 40 04             	mov    0x4(%eax),%eax
  8004a6:	8d 50 01             	lea    0x1(%eax),%edx
  8004a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ac:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004af:	90                   	nop
  8004b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b3:	c9                   	leave  
  8004b4:	c3                   	ret    

008004b5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
  8004b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c5:	00 00 00 
	b.cnt = 0;
  8004c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004cf:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004de:	50                   	push   %eax
  8004df:	68 44 04 80 00       	push   $0x800444
  8004e4:	e8 5a 02 00 00       	call   800743 <vprintfmt>
  8004e9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004ec:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  8004f2:	a0 44 50 80 00       	mov    0x805044,%al
  8004f7:	0f b6 c0             	movzbl %al,%eax
  8004fa:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800500:	52                   	push   %edx
  800501:	50                   	push   %eax
  800502:	51                   	push   %ecx
  800503:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800509:	83 c0 08             	add    $0x8,%eax
  80050c:	50                   	push   %eax
  80050d:	e8 2a 1c 00 00       	call   80213c <sys_cputs>
  800512:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800515:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  80051c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800522:	c9                   	leave  
  800523:	c3                   	ret    

00800524 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800524:	55                   	push   %ebp
  800525:	89 e5                	mov    %esp,%ebp
  800527:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80052a:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800531:	8d 45 0c             	lea    0xc(%ebp),%eax
  800534:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	ff 75 f4             	pushl  -0xc(%ebp)
  800540:	50                   	push   %eax
  800541:	e8 6f ff ff ff       	call   8004b5 <vcprintf>
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054f:	c9                   	leave  
  800550:	c3                   	ret    

00800551 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800551:	55                   	push   %ebp
  800552:	89 e5                	mov    %esp,%ebp
  800554:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800557:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	c1 e0 08             	shl    $0x8,%eax
  800564:	a3 18 d1 81 00       	mov    %eax,0x81d118
	va_start(ap, fmt);
  800569:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056c:	83 c0 04             	add    $0x4,%eax
  80056f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800572:	8b 45 0c             	mov    0xc(%ebp),%eax
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	ff 75 f4             	pushl  -0xc(%ebp)
  80057b:	50                   	push   %eax
  80057c:	e8 34 ff ff ff       	call   8004b5 <vcprintf>
  800581:	83 c4 10             	add    $0x10,%esp
  800584:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800587:	c7 05 18 d1 81 00 00 	movl   $0x700,0x81d118
  80058e:	07 00 00 

	return cnt;
  800591:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800594:	c9                   	leave  
  800595:	c3                   	ret    

00800596 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800596:	55                   	push   %ebp
  800597:	89 e5                	mov    %esp,%ebp
  800599:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80059c:	e8 df 1b 00 00       	call   802180 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005a1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b0:	50                   	push   %eax
  8005b1:	e8 ff fe ff ff       	call   8004b5 <vcprintf>
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005bc:	e8 d9 1b 00 00       	call   80219a <sys_unlock_cons>
	return cnt;
  8005c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c4:	c9                   	leave  
  8005c5:	c3                   	ret    

008005c6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c6:	55                   	push   %ebp
  8005c7:	89 e5                	mov    %esp,%ebp
  8005c9:	53                   	push   %ebx
  8005ca:	83 ec 14             	sub    $0x14,%esp
  8005cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d9:	8b 45 18             	mov    0x18(%ebp),%eax
  8005dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e4:	77 55                	ja     80063b <printnum+0x75>
  8005e6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e9:	72 05                	jb     8005f0 <printnum+0x2a>
  8005eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ee:	77 4b                	ja     80063b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fe:	52                   	push   %edx
  8005ff:	50                   	push   %eax
  800600:	ff 75 f4             	pushl  -0xc(%ebp)
  800603:	ff 75 f0             	pushl  -0x10(%ebp)
  800606:	e8 19 32 00 00       	call   803824 <__udivdi3>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	ff 75 20             	pushl  0x20(%ebp)
  800614:	53                   	push   %ebx
  800615:	ff 75 18             	pushl  0x18(%ebp)
  800618:	52                   	push   %edx
  800619:	50                   	push   %eax
  80061a:	ff 75 0c             	pushl  0xc(%ebp)
  80061d:	ff 75 08             	pushl  0x8(%ebp)
  800620:	e8 a1 ff ff ff       	call   8005c6 <printnum>
  800625:	83 c4 20             	add    $0x20,%esp
  800628:	eb 1a                	jmp    800644 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	ff 75 20             	pushl  0x20(%ebp)
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	ff d0                	call   *%eax
  800638:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063b:	ff 4d 1c             	decl   0x1c(%ebp)
  80063e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800642:	7f e6                	jg     80062a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800644:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800647:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800652:	53                   	push   %ebx
  800653:	51                   	push   %ecx
  800654:	52                   	push   %edx
  800655:	50                   	push   %eax
  800656:	e8 d9 32 00 00       	call   803934 <__umoddi3>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	05 54 3e 80 00       	add    $0x803e54,%eax
  800663:	8a 00                	mov    (%eax),%al
  800665:	0f be c0             	movsbl %al,%eax
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	ff 75 0c             	pushl  0xc(%ebp)
  80066e:	50                   	push   %eax
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	ff d0                	call   *%eax
  800674:	83 c4 10             	add    $0x10,%esp
}
  800677:	90                   	nop
  800678:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067b:	c9                   	leave  
  80067c:	c3                   	ret    

0080067d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800680:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800684:	7e 1c                	jle    8006a2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	8d 50 08             	lea    0x8(%eax),%edx
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	89 10                	mov    %edx,(%eax)
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	83 e8 08             	sub    $0x8,%eax
  80069b:	8b 50 04             	mov    0x4(%eax),%edx
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	eb 40                	jmp    8006e2 <getuint+0x65>
	else if (lflag)
  8006a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a6:	74 1e                	je     8006c6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	8d 50 04             	lea    0x4(%eax),%edx
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	89 10                	mov    %edx,(%eax)
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	83 e8 04             	sub    $0x4,%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c4:	eb 1c                	jmp    8006e2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	8d 50 04             	lea    0x4(%eax),%edx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	89 10                	mov    %edx,(%eax)
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	83 e8 04             	sub    $0x4,%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e2:	5d                   	pop    %ebp
  8006e3:	c3                   	ret    

008006e4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006eb:	7e 1c                	jle    800709 <getint+0x25>
		return va_arg(*ap, long long);
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	8d 50 08             	lea    0x8(%eax),%edx
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	89 10                	mov    %edx,(%eax)
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	83 e8 08             	sub    $0x8,%eax
  800702:	8b 50 04             	mov    0x4(%eax),%edx
  800705:	8b 00                	mov    (%eax),%eax
  800707:	eb 38                	jmp    800741 <getint+0x5d>
	else if (lflag)
  800709:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070d:	74 1a                	je     800729 <getint+0x45>
		return va_arg(*ap, long);
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	8d 50 04             	lea    0x4(%eax),%edx
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	89 10                	mov    %edx,(%eax)
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	83 e8 04             	sub    $0x4,%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	99                   	cltd   
  800727:	eb 18                	jmp    800741 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	8d 50 04             	lea    0x4(%eax),%edx
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	89 10                	mov    %edx,(%eax)
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	83 e8 04             	sub    $0x4,%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	99                   	cltd   
}
  800741:	5d                   	pop    %ebp
  800742:	c3                   	ret    

00800743 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	56                   	push   %esi
  800747:	53                   	push   %ebx
  800748:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074b:	eb 17                	jmp    800764 <vprintfmt+0x21>
			if (ch == '\0')
  80074d:	85 db                	test   %ebx,%ebx
  80074f:	0f 84 c1 03 00 00    	je     800b16 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	53                   	push   %ebx
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	ff d0                	call   *%eax
  800761:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800764:	8b 45 10             	mov    0x10(%ebp),%eax
  800767:	8d 50 01             	lea    0x1(%eax),%edx
  80076a:	89 55 10             	mov    %edx,0x10(%ebp)
  80076d:	8a 00                	mov    (%eax),%al
  80076f:	0f b6 d8             	movzbl %al,%ebx
  800772:	83 fb 25             	cmp    $0x25,%ebx
  800775:	75 d6                	jne    80074d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800777:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800782:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800789:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800790:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800797:	8b 45 10             	mov    0x10(%ebp),%eax
  80079a:	8d 50 01             	lea    0x1(%eax),%edx
  80079d:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a0:	8a 00                	mov    (%eax),%al
  8007a2:	0f b6 d8             	movzbl %al,%ebx
  8007a5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a8:	83 f8 5b             	cmp    $0x5b,%eax
  8007ab:	0f 87 3d 03 00 00    	ja     800aee <vprintfmt+0x3ab>
  8007b1:	8b 04 85 78 3e 80 00 	mov    0x803e78(,%eax,4),%eax
  8007b8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007be:	eb d7                	jmp    800797 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c4:	eb d1                	jmp    800797 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d0:	89 d0                	mov    %edx,%eax
  8007d2:	c1 e0 02             	shl    $0x2,%eax
  8007d5:	01 d0                	add    %edx,%eax
  8007d7:	01 c0                	add    %eax,%eax
  8007d9:	01 d8                	add    %ebx,%eax
  8007db:	83 e8 30             	sub    $0x30,%eax
  8007de:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e4:	8a 00                	mov    (%eax),%al
  8007e6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e9:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ec:	7e 3e                	jle    80082c <vprintfmt+0xe9>
  8007ee:	83 fb 39             	cmp    $0x39,%ebx
  8007f1:	7f 39                	jg     80082c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f6:	eb d5                	jmp    8007cd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	83 c0 04             	add    $0x4,%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	83 e8 04             	sub    $0x4,%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080c:	eb 1f                	jmp    80082d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800812:	79 83                	jns    800797 <vprintfmt+0x54>
				width = 0;
  800814:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081b:	e9 77 ff ff ff       	jmp    800797 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800820:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800827:	e9 6b ff ff ff       	jmp    800797 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800831:	0f 89 60 ff ff ff    	jns    800797 <vprintfmt+0x54>
				width = precision, precision = -1;
  800837:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800844:	e9 4e ff ff ff       	jmp    800797 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800849:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084c:	e9 46 ff ff ff       	jmp    800797 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	83 c0 04             	add    $0x4,%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	50                   	push   %eax
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	ff d0                	call   *%eax
  80086e:	83 c4 10             	add    $0x10,%esp
			break;
  800871:	e9 9b 02 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800887:	85 db                	test   %ebx,%ebx
  800889:	79 02                	jns    80088d <vprintfmt+0x14a>
				err = -err;
  80088b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088d:	83 fb 64             	cmp    $0x64,%ebx
  800890:	7f 0b                	jg     80089d <vprintfmt+0x15a>
  800892:	8b 34 9d c0 3c 80 00 	mov    0x803cc0(,%ebx,4),%esi
  800899:	85 f6                	test   %esi,%esi
  80089b:	75 19                	jne    8008b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089d:	53                   	push   %ebx
  80089e:	68 65 3e 80 00       	push   $0x803e65
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	ff 75 08             	pushl  0x8(%ebp)
  8008a9:	e8 70 02 00 00       	call   800b1e <printfmt>
  8008ae:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b1:	e9 5b 02 00 00       	jmp    800b11 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b6:	56                   	push   %esi
  8008b7:	68 6e 3e 80 00       	push   $0x803e6e
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 57 02 00 00       	call   800b1e <printfmt>
  8008c7:	83 c4 10             	add    $0x10,%esp
			break;
  8008ca:	e9 42 02 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	83 c0 04             	add    $0x4,%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 30                	mov    (%eax),%esi
  8008e0:	85 f6                	test   %esi,%esi
  8008e2:	75 05                	jne    8008e9 <vprintfmt+0x1a6>
				p = "(null)";
  8008e4:	be 71 3e 80 00       	mov    $0x803e71,%esi
			if (width > 0 && padc != '-')
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	7e 6d                	jle    80095c <vprintfmt+0x219>
  8008ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f3:	74 67                	je     80095c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	50                   	push   %eax
  8008fc:	56                   	push   %esi
  8008fd:	e8 1e 03 00 00       	call   800c20 <strnlen>
  800902:	83 c4 10             	add    $0x10,%esp
  800905:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800908:	eb 16                	jmp    800920 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80090a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	50                   	push   %eax
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091d:	ff 4d e4             	decl   -0x1c(%ebp)
  800920:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800924:	7f e4                	jg     80090a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800926:	eb 34                	jmp    80095c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800928:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092c:	74 1c                	je     80094a <vprintfmt+0x207>
  80092e:	83 fb 1f             	cmp    $0x1f,%ebx
  800931:	7e 05                	jle    800938 <vprintfmt+0x1f5>
  800933:	83 fb 7e             	cmp    $0x7e,%ebx
  800936:	7e 12                	jle    80094a <vprintfmt+0x207>
					putch('?', putdat);
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	ff 75 0c             	pushl  0xc(%ebp)
  80093e:	6a 3f                	push   $0x3f
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
  800948:	eb 0f                	jmp    800959 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	53                   	push   %ebx
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	ff d0                	call   *%eax
  800956:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800959:	ff 4d e4             	decl   -0x1c(%ebp)
  80095c:	89 f0                	mov    %esi,%eax
  80095e:	8d 70 01             	lea    0x1(%eax),%esi
  800961:	8a 00                	mov    (%eax),%al
  800963:	0f be d8             	movsbl %al,%ebx
  800966:	85 db                	test   %ebx,%ebx
  800968:	74 24                	je     80098e <vprintfmt+0x24b>
  80096a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096e:	78 b8                	js     800928 <vprintfmt+0x1e5>
  800970:	ff 4d e0             	decl   -0x20(%ebp)
  800973:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800977:	79 af                	jns    800928 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800979:	eb 13                	jmp    80098e <vprintfmt+0x24b>
				putch(' ', putdat);
  80097b:	83 ec 08             	sub    $0x8,%esp
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	6a 20                	push   $0x20
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	ff d0                	call   *%eax
  800988:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098b:	ff 4d e4             	decl   -0x1c(%ebp)
  80098e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800992:	7f e7                	jg     80097b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800994:	e9 78 01 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 e8             	pushl  -0x18(%ebp)
  80099f:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a2:	50                   	push   %eax
  8009a3:	e8 3c fd ff ff       	call   8006e4 <getint>
  8009a8:	83 c4 10             	add    $0x10,%esp
  8009ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b7:	85 d2                	test   %edx,%edx
  8009b9:	79 23                	jns    8009de <vprintfmt+0x29b>
				putch('-', putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	6a 2d                	push   $0x2d
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d1:	f7 d8                	neg    %eax
  8009d3:	83 d2 00             	adc    $0x0,%edx
  8009d6:	f7 da                	neg    %edx
  8009d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e5:	e9 bc 00 00 00       	jmp    800aa6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f3:	50                   	push   %eax
  8009f4:	e8 84 fc ff ff       	call   80067d <getuint>
  8009f9:	83 c4 10             	add    $0x10,%esp
  8009fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a02:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a09:	e9 98 00 00 00       	jmp    800aa6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	6a 58                	push   $0x58
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	ff d0                	call   *%eax
  800a1b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	6a 58                	push   $0x58
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 58                	push   $0x58
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			break;
  800a3e:	e9 ce 00 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	6a 30                	push   $0x30
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	ff d0                	call   *%eax
  800a50:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	6a 78                	push   $0x78
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a63:	8b 45 14             	mov    0x14(%ebp),%eax
  800a66:	83 c0 04             	add    $0x4,%eax
  800a69:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	83 e8 04             	sub    $0x4,%eax
  800a72:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a85:	eb 1f                	jmp    800aa6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a90:	50                   	push   %eax
  800a91:	e8 e7 fb ff ff       	call   80067d <getuint>
  800a96:	83 c4 10             	add    $0x10,%esp
  800a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aad:	83 ec 04             	sub    $0x4,%esp
  800ab0:	52                   	push   %edx
  800ab1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab4:	50                   	push   %eax
  800ab5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab8:	ff 75 f0             	pushl  -0x10(%ebp)
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	ff 75 08             	pushl  0x8(%ebp)
  800ac1:	e8 00 fb ff ff       	call   8005c6 <printnum>
  800ac6:	83 c4 20             	add    $0x20,%esp
			break;
  800ac9:	eb 46                	jmp    800b11 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	ff 75 0c             	pushl  0xc(%ebp)
  800ad1:	53                   	push   %ebx
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
			break;
  800ada:	eb 35                	jmp    800b11 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800adc:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800ae3:	eb 2c                	jmp    800b11 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ae5:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800aec:	eb 23                	jmp    800b11 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aee:	83 ec 08             	sub    $0x8,%esp
  800af1:	ff 75 0c             	pushl  0xc(%ebp)
  800af4:	6a 25                	push   $0x25
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	ff d0                	call   *%eax
  800afb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800afe:	ff 4d 10             	decl   0x10(%ebp)
  800b01:	eb 03                	jmp    800b06 <vprintfmt+0x3c3>
  800b03:	ff 4d 10             	decl   0x10(%ebp)
  800b06:	8b 45 10             	mov    0x10(%ebp),%eax
  800b09:	48                   	dec    %eax
  800b0a:	8a 00                	mov    (%eax),%al
  800b0c:	3c 25                	cmp    $0x25,%al
  800b0e:	75 f3                	jne    800b03 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b10:	90                   	nop
		}
	}
  800b11:	e9 35 fc ff ff       	jmp    80074b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b16:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b1a:	5b                   	pop    %ebx
  800b1b:	5e                   	pop    %esi
  800b1c:	5d                   	pop    %ebp
  800b1d:	c3                   	ret    

00800b1e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b24:	8d 45 10             	lea    0x10(%ebp),%eax
  800b27:	83 c0 04             	add    $0x4,%eax
  800b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b30:	ff 75 f4             	pushl  -0xc(%ebp)
  800b33:	50                   	push   %eax
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	ff 75 08             	pushl  0x8(%ebp)
  800b3a:	e8 04 fc ff ff       	call   800743 <vprintfmt>
  800b3f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b42:	90                   	nop
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	8b 40 08             	mov    0x8(%eax),%eax
  800b4e:	8d 50 01             	lea    0x1(%eax),%edx
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5a:	8b 10                	mov    (%eax),%edx
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8b 40 04             	mov    0x4(%eax),%eax
  800b62:	39 c2                	cmp    %eax,%edx
  800b64:	73 12                	jae    800b78 <sprintputch+0x33>
		*b->buf++ = ch;
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	8b 00                	mov    (%eax),%eax
  800b6b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b71:	89 0a                	mov    %ecx,(%edx)
  800b73:	8b 55 08             	mov    0x8(%ebp),%edx
  800b76:	88 10                	mov    %dl,(%eax)
}
  800b78:	90                   	nop
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	01 d0                	add    %edx,%eax
  800b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba0:	74 06                	je     800ba8 <vsnprintf+0x2d>
  800ba2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba6:	7f 07                	jg     800baf <vsnprintf+0x34>
		return -E_INVAL;
  800ba8:	b8 03 00 00 00       	mov    $0x3,%eax
  800bad:	eb 20                	jmp    800bcf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800baf:	ff 75 14             	pushl  0x14(%ebp)
  800bb2:	ff 75 10             	pushl  0x10(%ebp)
  800bb5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb8:	50                   	push   %eax
  800bb9:	68 45 0b 80 00       	push   $0x800b45
  800bbe:	e8 80 fb ff ff       	call   800743 <vprintfmt>
  800bc3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bda:	83 c0 04             	add    $0x4,%eax
  800bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800be0:	8b 45 10             	mov    0x10(%ebp),%eax
  800be3:	ff 75 f4             	pushl  -0xc(%ebp)
  800be6:	50                   	push   %eax
  800be7:	ff 75 0c             	pushl  0xc(%ebp)
  800bea:	ff 75 08             	pushl  0x8(%ebp)
  800bed:	e8 89 ff ff ff       	call   800b7b <vsnprintf>
  800bf2:	83 c4 10             	add    $0x10,%esp
  800bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bfb:	c9                   	leave  
  800bfc:	c3                   	ret    

00800bfd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c0a:	eb 06                	jmp    800c12 <strlen+0x15>
		n++;
  800c0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0f:	ff 45 08             	incl   0x8(%ebp)
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	84 c0                	test   %al,%al
  800c19:	75 f1                	jne    800c0c <strlen+0xf>
		n++;
	return n;
  800c1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2d:	eb 09                	jmp    800c38 <strnlen+0x18>
		n++;
  800c2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c32:	ff 45 08             	incl   0x8(%ebp)
  800c35:	ff 4d 0c             	decl   0xc(%ebp)
  800c38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3c:	74 09                	je     800c47 <strnlen+0x27>
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	8a 00                	mov    (%eax),%al
  800c43:	84 c0                	test   %al,%al
  800c45:	75 e8                	jne    800c2f <strnlen+0xf>
		n++;
	return n;
  800c47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c4a:	c9                   	leave  
  800c4b:	c3                   	ret    

00800c4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c58:	90                   	nop
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8d 50 01             	lea    0x1(%eax),%edx
  800c5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c6b:	8a 12                	mov    (%edx),%dl
  800c6d:	88 10                	mov    %dl,(%eax)
  800c6f:	8a 00                	mov    (%eax),%al
  800c71:	84 c0                	test   %al,%al
  800c73:	75 e4                	jne    800c59 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8d:	eb 1f                	jmp    800cae <strncpy+0x34>
		*dst++ = *src;
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8d 50 01             	lea    0x1(%eax),%edx
  800c95:	89 55 08             	mov    %edx,0x8(%ebp)
  800c98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9b:	8a 12                	mov    (%edx),%dl
  800c9d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	84 c0                	test   %al,%al
  800ca6:	74 03                	je     800cab <strncpy+0x31>
			src++;
  800ca8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cab:	ff 45 fc             	incl   -0x4(%ebp)
  800cae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cb4:	72 d9                	jb     800c8f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccb:	74 30                	je     800cfd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ccd:	eb 16                	jmp    800ce5 <strlcpy+0x2a>
			*dst++ = *src++;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8d 50 01             	lea    0x1(%eax),%edx
  800cd5:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cde:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce1:	8a 12                	mov    (%edx),%dl
  800ce3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ce5:	ff 4d 10             	decl   0x10(%ebp)
  800ce8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cec:	74 09                	je     800cf7 <strlcpy+0x3c>
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	84 c0                	test   %al,%al
  800cf5:	75 d8                	jne    800ccf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d03:	29 c2                	sub    %eax,%edx
  800d05:	89 d0                	mov    %edx,%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d0c:	eb 06                	jmp    800d14 <strcmp+0xb>
		p++, q++;
  800d0e:	ff 45 08             	incl   0x8(%ebp)
  800d11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	84 c0                	test   %al,%al
  800d1b:	74 0e                	je     800d2b <strcmp+0x22>
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8a 10                	mov    (%eax),%dl
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	38 c2                	cmp    %al,%dl
  800d29:	74 e3                	je     800d0e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f b6 d0             	movzbl %al,%edx
  800d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	0f b6 c0             	movzbl %al,%eax
  800d3b:	29 c2                	sub    %eax,%edx
  800d3d:	89 d0                	mov    %edx,%eax
}
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d44:	eb 09                	jmp    800d4f <strncmp+0xe>
		n--, p++, q++;
  800d46:	ff 4d 10             	decl   0x10(%ebp)
  800d49:	ff 45 08             	incl   0x8(%ebp)
  800d4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d53:	74 17                	je     800d6c <strncmp+0x2b>
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	84 c0                	test   %al,%al
  800d5c:	74 0e                	je     800d6c <strncmp+0x2b>
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 10                	mov    (%eax),%dl
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	38 c2                	cmp    %al,%dl
  800d6a:	74 da                	je     800d46 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d70:	75 07                	jne    800d79 <strncmp+0x38>
		return 0;
  800d72:	b8 00 00 00 00       	mov    $0x0,%eax
  800d77:	eb 14                	jmp    800d8d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	0f b6 d0             	movzbl %al,%edx
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	0f b6 c0             	movzbl %al,%eax
  800d89:	29 c2                	sub    %eax,%edx
  800d8b:	89 d0                	mov    %edx,%eax
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 04             	sub    $0x4,%esp
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d9b:	eb 12                	jmp    800daf <strchr+0x20>
		if (*s == c)
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da5:	75 05                	jne    800dac <strchr+0x1d>
			return (char *) s;
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	eb 11                	jmp    800dbd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dac:	ff 45 08             	incl   0x8(%ebp)
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	84 c0                	test   %al,%al
  800db6:	75 e5                	jne    800d9d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800db8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 04             	sub    $0x4,%esp
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dcb:	eb 0d                	jmp    800dda <strfind+0x1b>
		if (*s == c)
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8a 00                	mov    (%eax),%al
  800dd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dd5:	74 0e                	je     800de5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dd7:	ff 45 08             	incl   0x8(%ebp)
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	84 c0                	test   %al,%al
  800de1:	75 ea                	jne    800dcd <strfind+0xe>
  800de3:	eb 01                	jmp    800de6 <strfind+0x27>
		if (*s == c)
			break;
  800de5:	90                   	nop
	return (char *) s;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800df7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dfb:	76 63                	jbe    800e60 <memset+0x75>
		uint64 data_block = c;
  800dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e00:	99                   	cltd   
  800e01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e04:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e11:	c1 e0 08             	shl    $0x8,%eax
  800e14:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e17:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e20:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e24:	c1 e0 10             	shl    $0x10,%eax
  800e27:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e2a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e33:	89 c2                	mov    %eax,%edx
  800e35:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e3d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e40:	eb 18                	jmp    800e5a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e42:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e45:	8d 41 08             	lea    0x8(%ecx),%eax
  800e48:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e51:	89 01                	mov    %eax,(%ecx)
  800e53:	89 51 04             	mov    %edx,0x4(%ecx)
  800e56:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e5a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e5e:	77 e2                	ja     800e42 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e64:	74 23                	je     800e89 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e69:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e6c:	eb 0e                	jmp    800e7c <memset+0x91>
			*p8++ = (uint8)c;
  800e6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e71:	8d 50 01             	lea    0x1(%eax),%edx
  800e74:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e82:	89 55 10             	mov    %edx,0x10(%ebp)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	75 e5                	jne    800e6e <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ea0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea4:	76 24                	jbe    800eca <memcpy+0x3c>
		while(n >= 8){
  800ea6:	eb 1c                	jmp    800ec4 <memcpy+0x36>
			*d64 = *s64;
  800ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eab:	8b 50 04             	mov    0x4(%eax),%edx
  800eae:	8b 00                	mov    (%eax),%eax
  800eb0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800eb3:	89 01                	mov    %eax,(%ecx)
  800eb5:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800eb8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ebc:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ec0:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ec4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ec8:	77 de                	ja     800ea8 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800eca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ece:	74 31                	je     800f01 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800edc:	eb 16                	jmp    800ef4 <memcpy+0x66>
			*d8++ = *s8++;
  800ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ee7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eed:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800ef0:	8a 12                	mov    (%edx),%dl
  800ef2:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800efa:	89 55 10             	mov    %edx,0x10(%ebp)
  800efd:	85 c0                	test   %eax,%eax
  800eff:	75 dd                	jne    800ede <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f04:	c9                   	leave  
  800f05:	c3                   	ret    

00800f06 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1e:	73 50                	jae    800f70 <memmove+0x6a>
  800f20:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f23:	8b 45 10             	mov    0x10(%ebp),%eax
  800f26:	01 d0                	add    %edx,%eax
  800f28:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f2b:	76 43                	jbe    800f70 <memmove+0x6a>
		s += n;
  800f2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f30:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f33:	8b 45 10             	mov    0x10(%ebp),%eax
  800f36:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f39:	eb 10                	jmp    800f4b <memmove+0x45>
			*--d = *--s;
  800f3b:	ff 4d f8             	decl   -0x8(%ebp)
  800f3e:	ff 4d fc             	decl   -0x4(%ebp)
  800f41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f44:	8a 10                	mov    (%eax),%dl
  800f46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f49:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f51:	89 55 10             	mov    %edx,0x10(%ebp)
  800f54:	85 c0                	test   %eax,%eax
  800f56:	75 e3                	jne    800f3b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f58:	eb 23                	jmp    800f7d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	8d 50 01             	lea    0x1(%eax),%edx
  800f60:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f69:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6c:	8a 12                	mov    (%edx),%dl
  800f6e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f76:	89 55 10             	mov    %edx,0x10(%ebp)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	75 dd                	jne    800f5a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f80:	c9                   	leave  
  800f81:	c3                   	ret    

00800f82 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f94:	eb 2a                	jmp    800fc0 <memcmp+0x3e>
		if (*s1 != *s2)
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	8a 10                	mov    (%eax),%dl
  800f9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	38 c2                	cmp    %al,%dl
  800fa2:	74 16                	je     800fba <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 d0             	movzbl %al,%edx
  800fac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	29 c2                	sub    %eax,%edx
  800fb6:	89 d0                	mov    %edx,%eax
  800fb8:	eb 18                	jmp    800fd2 <memcmp+0x50>
		s1++, s2++;
  800fba:	ff 45 fc             	incl   -0x4(%ebp)
  800fbd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc6:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	75 c9                	jne    800f96 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd2:	c9                   	leave  
  800fd3:	c3                   	ret    

00800fd4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fda:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	01 d0                	add    %edx,%eax
  800fe2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fe5:	eb 15                	jmp    800ffc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	0f b6 d0             	movzbl %al,%edx
  800fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff2:	0f b6 c0             	movzbl %al,%eax
  800ff5:	39 c2                	cmp    %eax,%edx
  800ff7:	74 0d                	je     801006 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ff9:	ff 45 08             	incl   0x8(%ebp)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801002:	72 e3                	jb     800fe7 <memfind+0x13>
  801004:	eb 01                	jmp    801007 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801006:	90                   	nop
	return (void *) s;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801019:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801020:	eb 03                	jmp    801025 <strtol+0x19>
		s++;
  801022:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	3c 20                	cmp    $0x20,%al
  80102c:	74 f4                	je     801022 <strtol+0x16>
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	3c 09                	cmp    $0x9,%al
  801035:	74 eb                	je     801022 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	3c 2b                	cmp    $0x2b,%al
  80103e:	75 05                	jne    801045 <strtol+0x39>
		s++;
  801040:	ff 45 08             	incl   0x8(%ebp)
  801043:	eb 13                	jmp    801058 <strtol+0x4c>
	else if (*s == '-')
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	3c 2d                	cmp    $0x2d,%al
  80104c:	75 0a                	jne    801058 <strtol+0x4c>
		s++, neg = 1;
  80104e:	ff 45 08             	incl   0x8(%ebp)
  801051:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801058:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105c:	74 06                	je     801064 <strtol+0x58>
  80105e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801062:	75 20                	jne    801084 <strtol+0x78>
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	8a 00                	mov    (%eax),%al
  801069:	3c 30                	cmp    $0x30,%al
  80106b:	75 17                	jne    801084 <strtol+0x78>
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	40                   	inc    %eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	3c 78                	cmp    $0x78,%al
  801075:	75 0d                	jne    801084 <strtol+0x78>
		s += 2, base = 16;
  801077:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80107b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801082:	eb 28                	jmp    8010ac <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801084:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801088:	75 15                	jne    80109f <strtol+0x93>
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	3c 30                	cmp    $0x30,%al
  801091:	75 0c                	jne    80109f <strtol+0x93>
		s++, base = 8;
  801093:	ff 45 08             	incl   0x8(%ebp)
  801096:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80109d:	eb 0d                	jmp    8010ac <strtol+0xa0>
	else if (base == 0)
  80109f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a3:	75 07                	jne    8010ac <strtol+0xa0>
		base = 10;
  8010a5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	3c 2f                	cmp    $0x2f,%al
  8010b3:	7e 19                	jle    8010ce <strtol+0xc2>
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 39                	cmp    $0x39,%al
  8010bc:	7f 10                	jg     8010ce <strtol+0xc2>
			dig = *s - '0';
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	0f be c0             	movsbl %al,%eax
  8010c6:	83 e8 30             	sub    $0x30,%eax
  8010c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010cc:	eb 42                	jmp    801110 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	8a 00                	mov    (%eax),%al
  8010d3:	3c 60                	cmp    $0x60,%al
  8010d5:	7e 19                	jle    8010f0 <strtol+0xe4>
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	3c 7a                	cmp    $0x7a,%al
  8010de:	7f 10                	jg     8010f0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	0f be c0             	movsbl %al,%eax
  8010e8:	83 e8 57             	sub    $0x57,%eax
  8010eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ee:	eb 20                	jmp    801110 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	3c 40                	cmp    $0x40,%al
  8010f7:	7e 39                	jle    801132 <strtol+0x126>
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	3c 5a                	cmp    $0x5a,%al
  801100:	7f 30                	jg     801132 <strtol+0x126>
			dig = *s - 'A' + 10;
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	0f be c0             	movsbl %al,%eax
  80110a:	83 e8 37             	sub    $0x37,%eax
  80110d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801113:	3b 45 10             	cmp    0x10(%ebp),%eax
  801116:	7d 19                	jge    801131 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801118:	ff 45 08             	incl   0x8(%ebp)
  80111b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801122:	89 c2                	mov    %eax,%edx
  801124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801127:	01 d0                	add    %edx,%eax
  801129:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80112c:	e9 7b ff ff ff       	jmp    8010ac <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801131:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801132:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801136:	74 08                	je     801140 <strtol+0x134>
		*endptr = (char *) s;
  801138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113b:	8b 55 08             	mov    0x8(%ebp),%edx
  80113e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801140:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801144:	74 07                	je     80114d <strtol+0x141>
  801146:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801149:	f7 d8                	neg    %eax
  80114b:	eb 03                	jmp    801150 <strtol+0x144>
  80114d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <ltostr>:

void
ltostr(long value, char *str)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80115f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801166:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80116a:	79 13                	jns    80117f <ltostr+0x2d>
	{
		neg = 1;
  80116c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801179:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80117c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801187:	99                   	cltd   
  801188:	f7 f9                	idiv   %ecx
  80118a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80118d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801190:	8d 50 01             	lea    0x1(%eax),%edx
  801193:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801196:	89 c2                	mov    %eax,%edx
  801198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119b:	01 d0                	add    %edx,%eax
  80119d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011a0:	83 c2 30             	add    $0x30,%edx
  8011a3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ad:	f7 e9                	imul   %ecx
  8011af:	c1 fa 02             	sar    $0x2,%edx
  8011b2:	89 c8                	mov    %ecx,%eax
  8011b4:	c1 f8 1f             	sar    $0x1f,%eax
  8011b7:	29 c2                	sub    %eax,%edx
  8011b9:	89 d0                	mov    %edx,%eax
  8011bb:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c2:	75 bb                	jne    80117f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ce:	48                   	dec    %eax
  8011cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d6:	74 3d                	je     801215 <ltostr+0xc3>
		start = 1 ;
  8011d8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011df:	eb 34                	jmp    801215 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e7:	01 d0                	add    %edx,%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	01 c2                	add    %eax,%edx
  8011f6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	01 c8                	add    %ecx,%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801202:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 c2                	add    %eax,%edx
  80120a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80120d:	88 02                	mov    %al,(%edx)
		start++ ;
  80120f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801212:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801218:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80121b:	7c c4                	jl     8011e1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80121d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	01 d0                	add    %edx,%eax
  801225:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801228:	90                   	nop
  801229:	c9                   	leave  
  80122a:	c3                   	ret    

0080122b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801231:	ff 75 08             	pushl  0x8(%ebp)
  801234:	e8 c4 f9 ff ff       	call   800bfd <strlen>
  801239:	83 c4 04             	add    $0x4,%esp
  80123c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80123f:	ff 75 0c             	pushl  0xc(%ebp)
  801242:	e8 b6 f9 ff ff       	call   800bfd <strlen>
  801247:	83 c4 04             	add    $0x4,%esp
  80124a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80124d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801254:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80125b:	eb 17                	jmp    801274 <strcconcat+0x49>
		final[s] = str1[s] ;
  80125d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801260:	8b 45 10             	mov    0x10(%ebp),%eax
  801263:	01 c2                	add    %eax,%edx
  801265:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	01 c8                	add    %ecx,%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801271:	ff 45 fc             	incl   -0x4(%ebp)
  801274:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801277:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80127a:	7c e1                	jl     80125d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80127c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801283:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80128a:	eb 1f                	jmp    8012ab <strcconcat+0x80>
		final[s++] = str2[i] ;
  80128c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128f:	8d 50 01             	lea    0x1(%eax),%edx
  801292:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801295:	89 c2                	mov    %eax,%edx
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	01 c2                	add    %eax,%edx
  80129c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80129f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a2:	01 c8                	add    %ecx,%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012a8:	ff 45 f8             	incl   -0x8(%ebp)
  8012ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b1:	7c d9                	jl     80128c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b9:	01 d0                	add    %edx,%eax
  8012bb:	c6 00 00             	movb   $0x0,(%eax)
}
  8012be:	90                   	nop
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	8b 00                	mov    (%eax),%eax
  8012d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012dc:	01 d0                	add    %edx,%eax
  8012de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012e4:	eb 0c                	jmp    8012f2 <strsplit+0x31>
			*string++ = 0;
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	8d 50 01             	lea    0x1(%eax),%edx
  8012ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ef:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	84 c0                	test   %al,%al
  8012f9:	74 18                	je     801313 <strsplit+0x52>
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	0f be c0             	movsbl %al,%eax
  801303:	50                   	push   %eax
  801304:	ff 75 0c             	pushl  0xc(%ebp)
  801307:	e8 83 fa ff ff       	call   800d8f <strchr>
  80130c:	83 c4 08             	add    $0x8,%esp
  80130f:	85 c0                	test   %eax,%eax
  801311:	75 d3                	jne    8012e6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	84 c0                	test   %al,%al
  80131a:	74 5a                	je     801376 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80131c:	8b 45 14             	mov    0x14(%ebp),%eax
  80131f:	8b 00                	mov    (%eax),%eax
  801321:	83 f8 0f             	cmp    $0xf,%eax
  801324:	75 07                	jne    80132d <strsplit+0x6c>
		{
			return 0;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
  80132b:	eb 66                	jmp    801393 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80132d:	8b 45 14             	mov    0x14(%ebp),%eax
  801330:	8b 00                	mov    (%eax),%eax
  801332:	8d 48 01             	lea    0x1(%eax),%ecx
  801335:	8b 55 14             	mov    0x14(%ebp),%edx
  801338:	89 0a                	mov    %ecx,(%edx)
  80133a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	01 c2                	add    %eax,%edx
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80134b:	eb 03                	jmp    801350 <strsplit+0x8f>
			string++;
  80134d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	8a 00                	mov    (%eax),%al
  801355:	84 c0                	test   %al,%al
  801357:	74 8b                	je     8012e4 <strsplit+0x23>
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	0f be c0             	movsbl %al,%eax
  801361:	50                   	push   %eax
  801362:	ff 75 0c             	pushl  0xc(%ebp)
  801365:	e8 25 fa ff ff       	call   800d8f <strchr>
  80136a:	83 c4 08             	add    $0x8,%esp
  80136d:	85 c0                	test   %eax,%eax
  80136f:	74 dc                	je     80134d <strsplit+0x8c>
			string++;
	}
  801371:	e9 6e ff ff ff       	jmp    8012e4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801376:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801377:	8b 45 14             	mov    0x14(%ebp),%eax
  80137a:	8b 00                	mov    (%eax),%eax
  80137c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801383:	8b 45 10             	mov    0x10(%ebp),%eax
  801386:	01 d0                	add    %edx,%eax
  801388:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80138e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a8:	eb 4a                	jmp    8013f4 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	01 c2                	add    %eax,%edx
  8013b2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b8:	01 c8                	add    %ecx,%eax
  8013ba:	8a 00                	mov    (%eax),%al
  8013bc:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	01 d0                	add    %edx,%eax
  8013c6:	8a 00                	mov    (%eax),%al
  8013c8:	3c 40                	cmp    $0x40,%al
  8013ca:	7e 25                	jle    8013f1 <str2lower+0x5c>
  8013cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	3c 5a                	cmp    $0x5a,%al
  8013d8:	7f 17                	jg     8013f1 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	01 d0                	add    %edx,%eax
  8013e2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e8:	01 ca                	add    %ecx,%edx
  8013ea:	8a 12                	mov    (%edx),%dl
  8013ec:	83 c2 20             	add    $0x20,%edx
  8013ef:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013f1:	ff 45 fc             	incl   -0x4(%ebp)
  8013f4:	ff 75 0c             	pushl  0xc(%ebp)
  8013f7:	e8 01 f8 ff ff       	call   800bfd <strlen>
  8013fc:	83 c4 04             	add    $0x4,%esp
  8013ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801402:	7f a6                	jg     8013aa <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801404:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  80140f:	83 ec 0c             	sub    $0xc,%esp
  801412:	6a 10                	push   $0x10
  801414:	e8 b2 15 00 00       	call   8029cb <alloc_block>
  801419:	83 c4 10             	add    $0x10,%esp
  80141c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  80141f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801423:	75 14                	jne    801439 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801425:	83 ec 04             	sub    $0x4,%esp
  801428:	68 e8 3f 80 00       	push   $0x803fe8
  80142d:	6a 14                	push   $0x14
  80142f:	68 11 40 80 00       	push   $0x804011
  801434:	e8 dd 21 00 00       	call   803616 <_panic>

	node->start = start;
  801439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80143c:	8b 55 08             	mov    0x8(%ebp),%edx
  80143f:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801441:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801444:	8b 55 0c             	mov    0xc(%ebp),%edx
  801447:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  80144a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801451:	a1 24 50 80 00       	mov    0x805024,%eax
  801456:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801459:	eb 18                	jmp    801473 <insert_page_alloc+0x6a>
		if (start < it->start)
  80145b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145e:	8b 00                	mov    (%eax),%eax
  801460:	3b 45 08             	cmp    0x8(%ebp),%eax
  801463:	77 37                	ja     80149c <insert_page_alloc+0x93>
			break;
		prev = it;
  801465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801468:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  80146b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801470:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801473:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801477:	74 08                	je     801481 <insert_page_alloc+0x78>
  801479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147c:	8b 40 08             	mov    0x8(%eax),%eax
  80147f:	eb 05                	jmp    801486 <insert_page_alloc+0x7d>
  801481:	b8 00 00 00 00       	mov    $0x0,%eax
  801486:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80148b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801490:	85 c0                	test   %eax,%eax
  801492:	75 c7                	jne    80145b <insert_page_alloc+0x52>
  801494:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801498:	75 c1                	jne    80145b <insert_page_alloc+0x52>
  80149a:	eb 01                	jmp    80149d <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  80149c:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  80149d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014a1:	75 64                	jne    801507 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8014a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a7:	75 14                	jne    8014bd <insert_page_alloc+0xb4>
  8014a9:	83 ec 04             	sub    $0x4,%esp
  8014ac:	68 20 40 80 00       	push   $0x804020
  8014b1:	6a 21                	push   $0x21
  8014b3:	68 11 40 80 00       	push   $0x804011
  8014b8:	e8 59 21 00 00       	call   803616 <_panic>
  8014bd:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8014c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014c6:	89 50 08             	mov    %edx,0x8(%eax)
  8014c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014cc:	8b 40 08             	mov    0x8(%eax),%eax
  8014cf:	85 c0                	test   %eax,%eax
  8014d1:	74 0d                	je     8014e0 <insert_page_alloc+0xd7>
  8014d3:	a1 24 50 80 00       	mov    0x805024,%eax
  8014d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014db:	89 50 0c             	mov    %edx,0xc(%eax)
  8014de:	eb 08                	jmp    8014e8 <insert_page_alloc+0xdf>
  8014e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e3:	a3 28 50 80 00       	mov    %eax,0x805028
  8014e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014eb:	a3 24 50 80 00       	mov    %eax,0x805024
  8014f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8014fa:	a1 30 50 80 00       	mov    0x805030,%eax
  8014ff:	40                   	inc    %eax
  801500:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801505:	eb 71                	jmp    801578 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801507:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80150b:	74 06                	je     801513 <insert_page_alloc+0x10a>
  80150d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801511:	75 14                	jne    801527 <insert_page_alloc+0x11e>
  801513:	83 ec 04             	sub    $0x4,%esp
  801516:	68 44 40 80 00       	push   $0x804044
  80151b:	6a 23                	push   $0x23
  80151d:	68 11 40 80 00       	push   $0x804011
  801522:	e8 ef 20 00 00       	call   803616 <_panic>
  801527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152a:	8b 50 08             	mov    0x8(%eax),%edx
  80152d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801530:	89 50 08             	mov    %edx,0x8(%eax)
  801533:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801536:	8b 40 08             	mov    0x8(%eax),%eax
  801539:	85 c0                	test   %eax,%eax
  80153b:	74 0c                	je     801549 <insert_page_alloc+0x140>
  80153d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801540:	8b 40 08             	mov    0x8(%eax),%eax
  801543:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801546:	89 50 0c             	mov    %edx,0xc(%eax)
  801549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80154f:	89 50 08             	mov    %edx,0x8(%eax)
  801552:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801555:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801558:	89 50 0c             	mov    %edx,0xc(%eax)
  80155b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80155e:	8b 40 08             	mov    0x8(%eax),%eax
  801561:	85 c0                	test   %eax,%eax
  801563:	75 08                	jne    80156d <insert_page_alloc+0x164>
  801565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801568:	a3 28 50 80 00       	mov    %eax,0x805028
  80156d:	a1 30 50 80 00       	mov    0x805030,%eax
  801572:	40                   	inc    %eax
  801573:	a3 30 50 80 00       	mov    %eax,0x805030
}
  801578:	90                   	nop
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801581:	a1 24 50 80 00       	mov    0x805024,%eax
  801586:	85 c0                	test   %eax,%eax
  801588:	75 0c                	jne    801596 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  80158a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80158f:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801594:	eb 67                	jmp    8015fd <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801596:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80159b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80159e:	a1 24 50 80 00       	mov    0x805024,%eax
  8015a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8015a6:	eb 26                	jmp    8015ce <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  8015a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ab:	8b 10                	mov    (%eax),%edx
  8015ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b0:	8b 40 04             	mov    0x4(%eax),%eax
  8015b3:	01 d0                	add    %edx,%eax
  8015b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  8015b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015be:	76 06                	jbe    8015c6 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8015c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8015cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8015ce:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015d2:	74 08                	je     8015dc <recompute_page_alloc_break+0x61>
  8015d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d7:	8b 40 08             	mov    0x8(%eax),%eax
  8015da:	eb 05                	jmp    8015e1 <recompute_page_alloc_break+0x66>
  8015dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8015e6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8015eb:	85 c0                	test   %eax,%eax
  8015ed:	75 b9                	jne    8015a8 <recompute_page_alloc_break+0x2d>
  8015ef:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015f3:	75 b3                	jne    8015a8 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  8015f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f8:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801605:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80160c:	8b 55 08             	mov    0x8(%ebp),%edx
  80160f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801612:	01 d0                	add    %edx,%eax
  801614:	48                   	dec    %eax
  801615:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801618:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80161b:	ba 00 00 00 00       	mov    $0x0,%edx
  801620:	f7 75 d8             	divl   -0x28(%ebp)
  801623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801626:	29 d0                	sub    %edx,%eax
  801628:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  80162b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80162f:	75 0a                	jne    80163b <alloc_pages_custom_fit+0x3c>
		return NULL;
  801631:	b8 00 00 00 00       	mov    $0x0,%eax
  801636:	e9 7e 01 00 00       	jmp    8017b9 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  80163b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801642:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801646:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  80164d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801654:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801659:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  80165c:	a1 24 50 80 00       	mov    0x805024,%eax
  801661:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801664:	eb 69                	jmp    8016cf <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801666:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801669:	8b 00                	mov    (%eax),%eax
  80166b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80166e:	76 47                	jbe    8016b7 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801673:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801679:	8b 00                	mov    (%eax),%eax
  80167b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80167e:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801681:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801684:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801687:	72 2e                	jb     8016b7 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801689:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80168d:	75 14                	jne    8016a3 <alloc_pages_custom_fit+0xa4>
  80168f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801692:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801695:	75 0c                	jne    8016a3 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801697:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80169a:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  80169d:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8016a1:	eb 14                	jmp    8016b7 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  8016a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8016a6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8016a9:	76 0c                	jbe    8016b7 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  8016ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8016ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  8016b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8016b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  8016b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ba:	8b 10                	mov    (%eax),%edx
  8016bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016bf:	8b 40 04             	mov    0x4(%eax),%eax
  8016c2:	01 d0                	add    %edx,%eax
  8016c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8016c7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016d3:	74 08                	je     8016dd <alloc_pages_custom_fit+0xde>
  8016d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d8:	8b 40 08             	mov    0x8(%eax),%eax
  8016db:	eb 05                	jmp    8016e2 <alloc_pages_custom_fit+0xe3>
  8016dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8016e7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	0f 85 72 ff ff ff    	jne    801666 <alloc_pages_custom_fit+0x67>
  8016f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016f8:	0f 85 68 ff ff ff    	jne    801666 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  8016fe:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801703:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801706:	76 47                	jbe    80174f <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80170b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  80170e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801713:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801716:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801719:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80171c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80171f:	72 2e                	jb     80174f <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801721:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801725:	75 14                	jne    80173b <alloc_pages_custom_fit+0x13c>
  801727:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80172a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80172d:	75 0c                	jne    80173b <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  80172f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801732:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801735:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801739:	eb 14                	jmp    80174f <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  80173b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80173e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801741:	76 0c                	jbe    80174f <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801743:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801746:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801749:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80174c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  80174f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801756:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80175a:	74 08                	je     801764 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  80175c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801762:	eb 40                	jmp    8017a4 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801764:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801768:	74 08                	je     801772 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  80176a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801770:	eb 32                	jmp    8017a4 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801772:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801777:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80177a:	89 c2                	mov    %eax,%edx
  80177c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801781:	39 c2                	cmp    %eax,%edx
  801783:	73 07                	jae    80178c <alloc_pages_custom_fit+0x18d>
			return NULL;
  801785:	b8 00 00 00 00       	mov    $0x0,%eax
  80178a:	eb 2d                	jmp    8017b9 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  80178c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801791:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801794:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80179a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80179d:	01 d0                	add    %edx,%eax
  80179f:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  8017a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017a7:	83 ec 08             	sub    $0x8,%esp
  8017aa:	ff 75 d0             	pushl  -0x30(%ebp)
  8017ad:	50                   	push   %eax
  8017ae:	e8 56 fc ff ff       	call   801409 <insert_page_alloc>
  8017b3:	83 c4 10             	add    $0x10,%esp

	return result;
  8017b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8017c7:	a1 24 50 80 00       	mov    0x805024,%eax
  8017cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8017cf:	eb 1a                	jmp    8017eb <find_allocated_size+0x30>
		if (it->start == va)
  8017d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d4:	8b 00                	mov    (%eax),%eax
  8017d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017d9:	75 08                	jne    8017e3 <find_allocated_size+0x28>
			return it->size;
  8017db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017de:	8b 40 04             	mov    0x4(%eax),%eax
  8017e1:	eb 34                	jmp    801817 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8017e3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8017eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017ef:	74 08                	je     8017f9 <find_allocated_size+0x3e>
  8017f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f4:	8b 40 08             	mov    0x8(%eax),%eax
  8017f7:	eb 05                	jmp    8017fe <find_allocated_size+0x43>
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801803:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801808:	85 c0                	test   %eax,%eax
  80180a:	75 c5                	jne    8017d1 <find_allocated_size+0x16>
  80180c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801810:	75 bf                	jne    8017d1 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801812:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801825:	a1 24 50 80 00       	mov    0x805024,%eax
  80182a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182d:	e9 e1 01 00 00       	jmp    801a13 <free_pages+0x1fa>
		if (it->start == va) {
  801832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801835:	8b 00                	mov    (%eax),%eax
  801837:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80183a:	0f 85 cb 01 00 00    	jne    801a0b <free_pages+0x1f2>

			uint32 start = it->start;
  801840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801843:	8b 00                	mov    (%eax),%eax
  801845:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184b:	8b 40 04             	mov    0x4(%eax),%eax
  80184e:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801854:	f7 d0                	not    %eax
  801856:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801859:	73 1d                	jae    801878 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801861:	ff 75 e8             	pushl  -0x18(%ebp)
  801864:	68 78 40 80 00       	push   $0x804078
  801869:	68 a5 00 00 00       	push   $0xa5
  80186e:	68 11 40 80 00       	push   $0x804011
  801873:	e8 9e 1d 00 00       	call   803616 <_panic>
			}

			uint32 start_end = start + size;
  801878:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80187b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80187e:	01 d0                	add    %edx,%eax
  801880:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801883:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801886:	85 c0                	test   %eax,%eax
  801888:	79 19                	jns    8018a3 <free_pages+0x8a>
  80188a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801891:	77 10                	ja     8018a3 <free_pages+0x8a>
  801893:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  80189a:	77 07                	ja     8018a3 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  80189c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189f:	85 c0                	test   %eax,%eax
  8018a1:	78 2c                	js     8018cf <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  8018a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018a6:	83 ec 0c             	sub    $0xc,%esp
  8018a9:	68 00 00 00 a0       	push   $0xa0000000
  8018ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8018b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8018b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018ba:	50                   	push   %eax
  8018bb:	68 bc 40 80 00       	push   $0x8040bc
  8018c0:	68 ad 00 00 00       	push   $0xad
  8018c5:	68 11 40 80 00       	push   $0x804011
  8018ca:	e8 47 1d 00 00       	call   803616 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8018cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018d5:	e9 88 00 00 00       	jmp    801962 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  8018da:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  8018e1:	76 17                	jbe    8018fa <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  8018e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e6:	68 20 41 80 00       	push   $0x804120
  8018eb:	68 b4 00 00 00       	push   $0xb4
  8018f0:	68 11 40 80 00       	push   $0x804011
  8018f5:	e8 1c 1d 00 00       	call   803616 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  8018fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fd:	05 00 10 00 00       	add    $0x1000,%eax
  801902:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801908:	85 c0                	test   %eax,%eax
  80190a:	79 2e                	jns    80193a <free_pages+0x121>
  80190c:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801913:	77 25                	ja     80193a <free_pages+0x121>
  801915:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  80191c:	77 1c                	ja     80193a <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  80191e:	83 ec 08             	sub    $0x8,%esp
  801921:	68 00 10 00 00       	push   $0x1000
  801926:	ff 75 f0             	pushl  -0x10(%ebp)
  801929:	e8 38 0d 00 00       	call   802666 <sys_free_user_mem>
  80192e:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801931:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801938:	eb 28                	jmp    801962 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  80193a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193d:	68 00 00 00 a0       	push   $0xa0000000
  801942:	ff 75 dc             	pushl  -0x24(%ebp)
  801945:	68 00 10 00 00       	push   $0x1000
  80194a:	ff 75 f0             	pushl  -0x10(%ebp)
  80194d:	50                   	push   %eax
  80194e:	68 60 41 80 00       	push   $0x804160
  801953:	68 bd 00 00 00       	push   $0xbd
  801958:	68 11 40 80 00       	push   $0x804011
  80195d:	e8 b4 1c 00 00       	call   803616 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801965:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801968:	0f 82 6c ff ff ff    	jb     8018da <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  80196e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801972:	75 17                	jne    80198b <free_pages+0x172>
  801974:	83 ec 04             	sub    $0x4,%esp
  801977:	68 c2 41 80 00       	push   $0x8041c2
  80197c:	68 c1 00 00 00       	push   $0xc1
  801981:	68 11 40 80 00       	push   $0x804011
  801986:	e8 8b 1c 00 00       	call   803616 <_panic>
  80198b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198e:	8b 40 08             	mov    0x8(%eax),%eax
  801991:	85 c0                	test   %eax,%eax
  801993:	74 11                	je     8019a6 <free_pages+0x18d>
  801995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801998:	8b 40 08             	mov    0x8(%eax),%eax
  80199b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80199e:	8b 52 0c             	mov    0xc(%edx),%edx
  8019a1:	89 50 0c             	mov    %edx,0xc(%eax)
  8019a4:	eb 0b                	jmp    8019b1 <free_pages+0x198>
  8019a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ac:	a3 28 50 80 00       	mov    %eax,0x805028
  8019b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	74 11                	je     8019cc <free_pages+0x1b3>
  8019bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019be:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c4:	8b 52 08             	mov    0x8(%edx),%edx
  8019c7:	89 50 08             	mov    %edx,0x8(%eax)
  8019ca:	eb 0b                	jmp    8019d7 <free_pages+0x1be>
  8019cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cf:	8b 40 08             	mov    0x8(%eax),%eax
  8019d2:	a3 24 50 80 00       	mov    %eax,0x805024
  8019d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8019e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8019eb:	a1 30 50 80 00       	mov    0x805030,%eax
  8019f0:	48                   	dec    %eax
  8019f1:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  8019f6:	83 ec 0c             	sub    $0xc,%esp
  8019f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019fc:	e8 24 15 00 00       	call   802f25 <free_block>
  801a01:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801a04:	e8 72 fb ff ff       	call   80157b <recompute_page_alloc_break>

			return;
  801a09:	eb 37                	jmp    801a42 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a0b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a17:	74 08                	je     801a21 <free_pages+0x208>
  801a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1c:	8b 40 08             	mov    0x8(%eax),%eax
  801a1f:	eb 05                	jmp    801a26 <free_pages+0x20d>
  801a21:	b8 00 00 00 00       	mov    $0x0,%eax
  801a26:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801a2b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a30:	85 c0                	test   %eax,%eax
  801a32:	0f 85 fa fd ff ff    	jne    801832 <free_pages+0x19>
  801a38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a3c:	0f 85 f0 fd ff ff    	jne    801832 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801a47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4c:	5d                   	pop    %ebp
  801a4d:	c3                   	ret    

00801a4e <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801a54:	a1 08 50 80 00       	mov    0x805008,%eax
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	74 60                	je     801abd <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801a5d:	83 ec 08             	sub    $0x8,%esp
  801a60:	68 00 00 00 82       	push   $0x82000000
  801a65:	68 00 00 00 80       	push   $0x80000000
  801a6a:	e8 0d 0d 00 00       	call   80277c <initialize_dynamic_allocator>
  801a6f:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801a72:	e8 f3 0a 00 00       	call   80256a <sys_get_uheap_strategy>
  801a77:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801a7c:	a1 40 50 80 00       	mov    0x805040,%eax
  801a81:	05 00 10 00 00       	add    $0x1000,%eax
  801a86:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801a8b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801a90:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801a95:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801a9c:	00 00 00 
  801a9f:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801aa6:	00 00 00 
  801aa9:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801ab0:	00 00 00 

		__firstTimeFlag = 0;
  801ab3:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801aba:	00 00 00 
	}
}
  801abd:	90                   	nop
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ad4:	83 ec 08             	sub    $0x8,%esp
  801ad7:	68 06 04 00 00       	push   $0x406
  801adc:	50                   	push   %eax
  801add:	e8 d2 06 00 00       	call   8021b4 <__sys_allocate_page>
  801ae2:	83 c4 10             	add    $0x10,%esp
  801ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801ae8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801aec:	79 17                	jns    801b05 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801aee:	83 ec 04             	sub    $0x4,%esp
  801af1:	68 e0 41 80 00       	push   $0x8041e0
  801af6:	68 ea 00 00 00       	push   $0xea
  801afb:	68 11 40 80 00       	push   $0x804011
  801b00:	e8 11 1b 00 00       	call   803616 <_panic>
	return 0;
  801b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b20:	83 ec 0c             	sub    $0xc,%esp
  801b23:	50                   	push   %eax
  801b24:	e8 d2 06 00 00       	call   8021fb <__sys_unmap_frame>
  801b29:	83 c4 10             	add    $0x10,%esp
  801b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b33:	79 17                	jns    801b4c <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801b35:	83 ec 04             	sub    $0x4,%esp
  801b38:	68 1c 42 80 00       	push   $0x80421c
  801b3d:	68 f5 00 00 00       	push   $0xf5
  801b42:	68 11 40 80 00       	push   $0x804011
  801b47:	e8 ca 1a 00 00       	call   803616 <_panic>
}
  801b4c:	90                   	nop
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801b55:	e8 f4 fe ff ff       	call   801a4e <uheap_init>
	if (size == 0) return NULL ;
  801b5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b5e:	75 0a                	jne    801b6a <malloc+0x1b>
  801b60:	b8 00 00 00 00       	mov    $0x0,%eax
  801b65:	e9 67 01 00 00       	jmp    801cd1 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801b6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801b71:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801b78:	77 16                	ja     801b90 <malloc+0x41>
		result = alloc_block(size);
  801b7a:	83 ec 0c             	sub    $0xc,%esp
  801b7d:	ff 75 08             	pushl  0x8(%ebp)
  801b80:	e8 46 0e 00 00       	call   8029cb <alloc_block>
  801b85:	83 c4 10             	add    $0x10,%esp
  801b88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b8b:	e9 3e 01 00 00       	jmp    801cce <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801b90:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b97:	8b 55 08             	mov    0x8(%ebp),%edx
  801b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9d:	01 d0                	add    %edx,%eax
  801b9f:	48                   	dec    %eax
  801ba0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ba3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba6:	ba 00 00 00 00       	mov    $0x0,%edx
  801bab:	f7 75 f0             	divl   -0x10(%ebp)
  801bae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb1:	29 d0                	sub    %edx,%eax
  801bb3:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801bb6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	75 0a                	jne    801bc9 <malloc+0x7a>
			return NULL;
  801bbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc4:	e9 08 01 00 00       	jmp    801cd1 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801bc9:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801bce:	85 c0                	test   %eax,%eax
  801bd0:	74 0f                	je     801be1 <malloc+0x92>
  801bd2:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801bd8:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801bdd:	39 c2                	cmp    %eax,%edx
  801bdf:	73 0a                	jae    801beb <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801be1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801be6:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801beb:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801bf0:	83 f8 05             	cmp    $0x5,%eax
  801bf3:	75 11                	jne    801c06 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801bf5:	83 ec 0c             	sub    $0xc,%esp
  801bf8:	ff 75 e8             	pushl  -0x18(%ebp)
  801bfb:	e8 ff f9 ff ff       	call   8015ff <alloc_pages_custom_fit>
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801c06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c0a:	0f 84 be 00 00 00    	je     801cce <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801c16:	83 ec 0c             	sub    $0xc,%esp
  801c19:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1c:	e8 9a fb ff ff       	call   8017bb <find_allocated_size>
  801c21:	83 c4 10             	add    $0x10,%esp
  801c24:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801c27:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c2b:	75 17                	jne    801c44 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801c2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c30:	68 5c 42 80 00       	push   $0x80425c
  801c35:	68 24 01 00 00       	push   $0x124
  801c3a:	68 11 40 80 00       	push   $0x804011
  801c3f:	e8 d2 19 00 00       	call   803616 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801c44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c47:	f7 d0                	not    %eax
  801c49:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c4c:	73 1d                	jae    801c6b <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801c4e:	83 ec 0c             	sub    $0xc,%esp
  801c51:	ff 75 e0             	pushl  -0x20(%ebp)
  801c54:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c57:	68 a4 42 80 00       	push   $0x8042a4
  801c5c:	68 29 01 00 00       	push   $0x129
  801c61:	68 11 40 80 00       	push   $0x804011
  801c66:	e8 ab 19 00 00       	call   803616 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801c6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c71:	01 d0                	add    %edx,%eax
  801c73:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801c76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c79:	85 c0                	test   %eax,%eax
  801c7b:	79 2c                	jns    801ca9 <malloc+0x15a>
  801c7d:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801c84:	77 23                	ja     801ca9 <malloc+0x15a>
  801c86:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801c8d:	77 1a                	ja     801ca9 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801c8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c92:	85 c0                	test   %eax,%eax
  801c94:	79 13                	jns    801ca9 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801c96:	83 ec 08             	sub    $0x8,%esp
  801c99:	ff 75 e0             	pushl  -0x20(%ebp)
  801c9c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c9f:	e8 de 09 00 00       	call   802682 <sys_allocate_user_mem>
  801ca4:	83 c4 10             	add    $0x10,%esp
  801ca7:	eb 25                	jmp    801cce <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801ca9:	68 00 00 00 a0       	push   $0xa0000000
  801cae:	ff 75 dc             	pushl  -0x24(%ebp)
  801cb1:	ff 75 e0             	pushl  -0x20(%ebp)
  801cb4:	ff 75 e4             	pushl  -0x1c(%ebp)
  801cb7:	ff 75 f4             	pushl  -0xc(%ebp)
  801cba:	68 e0 42 80 00       	push   $0x8042e0
  801cbf:	68 33 01 00 00       	push   $0x133
  801cc4:	68 11 40 80 00       	push   $0x804011
  801cc9:	e8 48 19 00 00       	call   803616 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801cd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cdd:	0f 84 26 01 00 00    	je     801e09 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cec:	85 c0                	test   %eax,%eax
  801cee:	79 1c                	jns    801d0c <free+0x39>
  801cf0:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801cf7:	77 13                	ja     801d0c <free+0x39>
		free_block(virtual_address);
  801cf9:	83 ec 0c             	sub    $0xc,%esp
  801cfc:	ff 75 08             	pushl  0x8(%ebp)
  801cff:	e8 21 12 00 00       	call   802f25 <free_block>
  801d04:	83 c4 10             	add    $0x10,%esp
		return;
  801d07:	e9 01 01 00 00       	jmp    801e0d <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801d0c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d11:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801d14:	0f 82 d8 00 00 00    	jb     801df2 <free+0x11f>
  801d1a:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801d21:	0f 87 cb 00 00 00    	ja     801df2 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2a:	25 ff 0f 00 00       	and    $0xfff,%eax
  801d2f:	85 c0                	test   %eax,%eax
  801d31:	74 17                	je     801d4a <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801d33:	ff 75 08             	pushl  0x8(%ebp)
  801d36:	68 50 43 80 00       	push   $0x804350
  801d3b:	68 57 01 00 00       	push   $0x157
  801d40:	68 11 40 80 00       	push   $0x804011
  801d45:	e8 cc 18 00 00       	call   803616 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801d4a:	83 ec 0c             	sub    $0xc,%esp
  801d4d:	ff 75 08             	pushl  0x8(%ebp)
  801d50:	e8 66 fa ff ff       	call   8017bb <find_allocated_size>
  801d55:	83 c4 10             	add    $0x10,%esp
  801d58:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801d5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d5f:	0f 84 a7 00 00 00    	je     801e0c <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d68:	f7 d0                	not    %eax
  801d6a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d6d:	73 1d                	jae    801d8c <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801d6f:	83 ec 0c             	sub    $0xc,%esp
  801d72:	ff 75 f0             	pushl  -0x10(%ebp)
  801d75:	ff 75 f4             	pushl  -0xc(%ebp)
  801d78:	68 78 43 80 00       	push   $0x804378
  801d7d:	68 61 01 00 00       	push   $0x161
  801d82:	68 11 40 80 00       	push   $0x804011
  801d87:	e8 8a 18 00 00       	call   803616 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801d8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d92:	01 d0                	add    %edx,%eax
  801d94:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9a:	85 c0                	test   %eax,%eax
  801d9c:	79 19                	jns    801db7 <free+0xe4>
  801d9e:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801da5:	77 10                	ja     801db7 <free+0xe4>
  801da7:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801dae:	77 07                	ja     801db7 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801db0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db3:	85 c0                	test   %eax,%eax
  801db5:	78 2b                	js     801de2 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801db7:	83 ec 0c             	sub    $0xc,%esp
  801dba:	68 00 00 00 a0       	push   $0xa0000000
  801dbf:	ff 75 ec             	pushl  -0x14(%ebp)
  801dc2:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc5:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc8:	ff 75 f0             	pushl  -0x10(%ebp)
  801dcb:	ff 75 08             	pushl  0x8(%ebp)
  801dce:	68 b4 43 80 00       	push   $0x8043b4
  801dd3:	68 69 01 00 00       	push   $0x169
  801dd8:	68 11 40 80 00       	push   $0x804011
  801ddd:	e8 34 18 00 00       	call   803616 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  801de2:	83 ec 0c             	sub    $0xc,%esp
  801de5:	ff 75 08             	pushl  0x8(%ebp)
  801de8:	e8 2c fa ff ff       	call   801819 <free_pages>
  801ded:	83 c4 10             	add    $0x10,%esp
		return;
  801df0:	eb 1b                	jmp    801e0d <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  801df2:	ff 75 08             	pushl  0x8(%ebp)
  801df5:	68 10 44 80 00       	push   $0x804410
  801dfa:	68 70 01 00 00       	push   $0x170
  801dff:	68 11 40 80 00       	push   $0x804011
  801e04:	e8 0d 18 00 00       	call   803616 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801e09:	90                   	nop
  801e0a:	eb 01                	jmp    801e0d <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  801e0c:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	83 ec 38             	sub    $0x38,%esp
  801e15:	8b 45 10             	mov    0x10(%ebp),%eax
  801e18:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e1b:	e8 2e fc ff ff       	call   801a4e <uheap_init>
	if (size == 0) return NULL ;
  801e20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e24:	75 0a                	jne    801e30 <smalloc+0x21>
  801e26:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2b:	e9 3d 01 00 00       	jmp    801f6d <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  801e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  801e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e39:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  801e41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e45:	74 0e                	je     801e55 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  801e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4a:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801e4d:	05 00 10 00 00       	add    $0x1000,%eax
  801e52:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  801e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e58:	c1 e8 0c             	shr    $0xc,%eax
  801e5b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  801e5e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e63:	85 c0                	test   %eax,%eax
  801e65:	75 0a                	jne    801e71 <smalloc+0x62>
		return NULL;
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6c:	e9 fc 00 00 00       	jmp    801f6d <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  801e71:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e76:	85 c0                	test   %eax,%eax
  801e78:	74 0f                	je     801e89 <smalloc+0x7a>
  801e7a:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801e80:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e85:	39 c2                	cmp    %eax,%edx
  801e87:	73 0a                	jae    801e93 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  801e89:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e8e:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  801e93:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e98:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801e9d:	29 c2                	sub    %eax,%edx
  801e9f:	89 d0                	mov    %edx,%eax
  801ea1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  801ea4:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801eaa:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801eaf:	29 c2                	sub    %eax,%edx
  801eb1:	89 d0                	mov    %edx,%eax
  801eb3:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ebc:	77 13                	ja     801ed1 <smalloc+0xc2>
  801ebe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ec1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ec4:	77 0b                	ja     801ed1 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  801ec6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ec9:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801ecc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801ecf:	73 0a                	jae    801edb <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  801ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed6:	e9 92 00 00 00       	jmp    801f6d <smalloc+0x15e>
	}

	void *va = NULL;
  801edb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801ee2:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801ee7:	83 f8 05             	cmp    $0x5,%eax
  801eea:	75 11                	jne    801efd <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  801eec:	83 ec 0c             	sub    $0xc,%esp
  801eef:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef2:	e8 08 f7 ff ff       	call   8015ff <alloc_pages_custom_fit>
  801ef7:	83 c4 10             	add    $0x10,%esp
  801efa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  801efd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f01:	75 27                	jne    801f2a <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  801f03:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  801f0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f0d:	2b 45 f4             	sub    -0xc(%ebp),%eax
  801f10:	89 c2                	mov    %eax,%edx
  801f12:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f17:	39 c2                	cmp    %eax,%edx
  801f19:	73 07                	jae    801f22 <smalloc+0x113>
			return NULL;}
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f20:	eb 4b                	jmp    801f6d <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  801f22:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f27:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  801f2a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801f2e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f31:	50                   	push   %eax
  801f32:	ff 75 0c             	pushl  0xc(%ebp)
  801f35:	ff 75 08             	pushl  0x8(%ebp)
  801f38:	e8 cb 03 00 00       	call   802308 <sys_create_shared_object>
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  801f43:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801f47:	79 07                	jns    801f50 <smalloc+0x141>
		return NULL;
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4e:	eb 1d                	jmp    801f6d <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  801f50:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f55:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  801f58:	75 10                	jne    801f6a <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  801f5a:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f63:	01 d0                	add    %edx,%eax
  801f65:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  801f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f75:	e8 d4 fa ff ff       	call   801a4e <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  801f7a:	83 ec 08             	sub    $0x8,%esp
  801f7d:	ff 75 0c             	pushl  0xc(%ebp)
  801f80:	ff 75 08             	pushl  0x8(%ebp)
  801f83:	e8 aa 03 00 00       	call   802332 <sys_size_of_shared_object>
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  801f8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f92:	7f 0a                	jg     801f9e <sget+0x2f>
		return NULL;
  801f94:	b8 00 00 00 00       	mov    $0x0,%eax
  801f99:	e9 32 01 00 00       	jmp    8020d0 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  801f9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  801fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa7:	25 ff 0f 00 00       	and    $0xfff,%eax
  801fac:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  801faf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801fb3:	74 0e                	je     801fc3 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  801fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  801fbb:	05 00 10 00 00       	add    $0x1000,%eax
  801fc0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  801fc3:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	75 0a                	jne    801fd6 <sget+0x67>
		return NULL;
  801fcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd1:	e9 fa 00 00 00       	jmp    8020d0 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  801fd6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	74 0f                	je     801fee <sget+0x7f>
  801fdf:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801fe5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801fea:	39 c2                	cmp    %eax,%edx
  801fec:	73 0a                	jae    801ff8 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  801fee:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ff3:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  801ff8:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ffd:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802002:	29 c2                	sub    %eax,%edx
  802004:	89 d0                	mov    %edx,%eax
  802006:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802009:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80200f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802014:	29 c2                	sub    %eax,%edx
  802016:	89 d0                	mov    %edx,%eax
  802018:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80201b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802021:	77 13                	ja     802036 <sget+0xc7>
  802023:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802026:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802029:	77 0b                	ja     802036 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  80202b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80202e:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802031:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802034:	73 0a                	jae    802040 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802036:	b8 00 00 00 00       	mov    $0x0,%eax
  80203b:	e9 90 00 00 00       	jmp    8020d0 <sget+0x161>

	void *va = NULL;
  802040:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802047:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80204c:	83 f8 05             	cmp    $0x5,%eax
  80204f:	75 11                	jne    802062 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802051:	83 ec 0c             	sub    $0xc,%esp
  802054:	ff 75 f4             	pushl  -0xc(%ebp)
  802057:	e8 a3 f5 ff ff       	call   8015ff <alloc_pages_custom_fit>
  80205c:	83 c4 10             	add    $0x10,%esp
  80205f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  802062:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802066:	75 27                	jne    80208f <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802068:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  80206f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802072:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802075:	89 c2                	mov    %eax,%edx
  802077:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80207c:	39 c2                	cmp    %eax,%edx
  80207e:	73 07                	jae    802087 <sget+0x118>
			return NULL;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
  802085:	eb 49                	jmp    8020d0 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802087:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80208c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  80208f:	83 ec 04             	sub    $0x4,%esp
  802092:	ff 75 f0             	pushl  -0x10(%ebp)
  802095:	ff 75 0c             	pushl  0xc(%ebp)
  802098:	ff 75 08             	pushl  0x8(%ebp)
  80209b:	e8 af 02 00 00       	call   80234f <sys_get_shared_object>
  8020a0:	83 c4 10             	add    $0x10,%esp
  8020a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8020a6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8020aa:	79 07                	jns    8020b3 <sget+0x144>
		return NULL;
  8020ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b1:	eb 1d                	jmp    8020d0 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8020b3:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020b8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8020bb:	75 10                	jne    8020cd <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8020bd:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c6:	01 d0                	add    %edx,%eax
  8020c8:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8020cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8020d8:	e8 71 f9 ff ff       	call   801a4e <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8020dd:	83 ec 04             	sub    $0x4,%esp
  8020e0:	68 34 44 80 00       	push   $0x804434
  8020e5:	68 19 02 00 00       	push   $0x219
  8020ea:	68 11 40 80 00       	push   $0x804011
  8020ef:	e8 22 15 00 00       	call   803616 <_panic>

008020f4 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
  8020f7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8020fa:	83 ec 04             	sub    $0x4,%esp
  8020fd:	68 5c 44 80 00       	push   $0x80445c
  802102:	68 2b 02 00 00       	push   $0x22b
  802107:	68 11 40 80 00       	push   $0x804011
  80210c:	e8 05 15 00 00       	call   803616 <_panic>

00802111 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	57                   	push   %edi
  802115:	56                   	push   %esi
  802116:	53                   	push   %ebx
  802117:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802120:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802123:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802126:	8b 7d 18             	mov    0x18(%ebp),%edi
  802129:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80212c:	cd 30                	int    $0x30
  80212e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802131:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802134:	83 c4 10             	add    $0x10,%esp
  802137:	5b                   	pop    %ebx
  802138:	5e                   	pop    %esi
  802139:	5f                   	pop    %edi
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    

0080213c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	83 ec 04             	sub    $0x4,%esp
  802142:	8b 45 10             	mov    0x10(%ebp),%eax
  802145:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802148:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80214b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	6a 00                	push   $0x0
  802154:	51                   	push   %ecx
  802155:	52                   	push   %edx
  802156:	ff 75 0c             	pushl  0xc(%ebp)
  802159:	50                   	push   %eax
  80215a:	6a 00                	push   $0x0
  80215c:	e8 b0 ff ff ff       	call   802111 <syscall>
  802161:	83 c4 18             	add    $0x18,%esp
}
  802164:	90                   	nop
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <sys_cgetc>:

int
sys_cgetc(void)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 02                	push   $0x2
  802176:	e8 96 ff ff ff       	call   802111 <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 03                	push   $0x3
  80218f:	e8 7d ff ff ff       	call   802111 <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
}
  802197:	90                   	nop
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 04                	push   $0x4
  8021a9:	e8 63 ff ff ff       	call   802111 <syscall>
  8021ae:	83 c4 18             	add    $0x18,%esp
}
  8021b1:	90                   	nop
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8021b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	52                   	push   %edx
  8021c4:	50                   	push   %eax
  8021c5:	6a 08                	push   $0x8
  8021c7:	e8 45 ff ff ff       	call   802111 <syscall>
  8021cc:	83 c4 18             	add    $0x18,%esp
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	56                   	push   %esi
  8021d5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021d6:	8b 75 18             	mov    0x18(%ebp),%esi
  8021d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	56                   	push   %esi
  8021e6:	53                   	push   %ebx
  8021e7:	51                   	push   %ecx
  8021e8:	52                   	push   %edx
  8021e9:	50                   	push   %eax
  8021ea:	6a 09                	push   $0x9
  8021ec:	e8 20 ff ff ff       	call   802111 <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
}
  8021f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f7:	5b                   	pop    %ebx
  8021f8:	5e                   	pop    %esi
  8021f9:	5d                   	pop    %ebp
  8021fa:	c3                   	ret    

008021fb <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	ff 75 08             	pushl  0x8(%ebp)
  802209:	6a 0a                	push   $0xa
  80220b:	e8 01 ff ff ff       	call   802111 <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	ff 75 0c             	pushl  0xc(%ebp)
  802221:	ff 75 08             	pushl  0x8(%ebp)
  802224:	6a 0b                	push   $0xb
  802226:	e8 e6 fe ff ff       	call   802111 <syscall>
  80222b:	83 c4 18             	add    $0x18,%esp
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 0c                	push   $0xc
  80223f:	e8 cd fe ff ff       	call   802111 <syscall>
  802244:	83 c4 18             	add    $0x18,%esp
}
  802247:	c9                   	leave  
  802248:	c3                   	ret    

00802249 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 0d                	push   $0xd
  802258:	e8 b4 fe ff ff       	call   802111 <syscall>
  80225d:	83 c4 18             	add    $0x18,%esp
}
  802260:	c9                   	leave  
  802261:	c3                   	ret    

00802262 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 0e                	push   $0xe
  802271:	e8 9b fe ff ff       	call   802111 <syscall>
  802276:	83 c4 18             	add    $0x18,%esp
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 0f                	push   $0xf
  80228a:	e8 82 fe ff ff       	call   802111 <syscall>
  80228f:	83 c4 18             	add    $0x18,%esp
}
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	ff 75 08             	pushl  0x8(%ebp)
  8022a2:	6a 10                	push   $0x10
  8022a4:	e8 68 fe ff ff       	call   802111 <syscall>
  8022a9:	83 c4 18             	add    $0x18,%esp
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 11                	push   $0x11
  8022bd:	e8 4f fe ff ff       	call   802111 <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
}
  8022c5:	90                   	nop
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <sys_cputc>:

void
sys_cputc(const char c)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	83 ec 04             	sub    $0x4,%esp
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022d4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	50                   	push   %eax
  8022e1:	6a 01                	push   $0x1
  8022e3:	e8 29 fe ff ff       	call   802111 <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
}
  8022eb:	90                   	nop
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 14                	push   $0x14
  8022fd:	e8 0f fe ff ff       	call   802111 <syscall>
  802302:	83 c4 18             	add    $0x18,%esp
}
  802305:	90                   	nop
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
  80230b:	83 ec 04             	sub    $0x4,%esp
  80230e:	8b 45 10             	mov    0x10(%ebp),%eax
  802311:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802314:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802317:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	6a 00                	push   $0x0
  802320:	51                   	push   %ecx
  802321:	52                   	push   %edx
  802322:	ff 75 0c             	pushl  0xc(%ebp)
  802325:	50                   	push   %eax
  802326:	6a 15                	push   $0x15
  802328:	e8 e4 fd ff ff       	call   802111 <syscall>
  80232d:	83 c4 18             	add    $0x18,%esp
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802335:	8b 55 0c             	mov    0xc(%ebp),%edx
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	52                   	push   %edx
  802342:	50                   	push   %eax
  802343:	6a 16                	push   $0x16
  802345:	e8 c7 fd ff ff       	call   802111 <syscall>
  80234a:	83 c4 18             	add    $0x18,%esp
}
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802352:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802355:	8b 55 0c             	mov    0xc(%ebp),%edx
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	51                   	push   %ecx
  802360:	52                   	push   %edx
  802361:	50                   	push   %eax
  802362:	6a 17                	push   $0x17
  802364:	e8 a8 fd ff ff       	call   802111 <syscall>
  802369:	83 c4 18             	add    $0x18,%esp
}
  80236c:	c9                   	leave  
  80236d:	c3                   	ret    

0080236e <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802371:	8b 55 0c             	mov    0xc(%ebp),%edx
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	52                   	push   %edx
  80237e:	50                   	push   %eax
  80237f:	6a 18                	push   $0x18
  802381:	e8 8b fd ff ff       	call   802111 <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	6a 00                	push   $0x0
  802393:	ff 75 14             	pushl  0x14(%ebp)
  802396:	ff 75 10             	pushl  0x10(%ebp)
  802399:	ff 75 0c             	pushl  0xc(%ebp)
  80239c:	50                   	push   %eax
  80239d:	6a 19                	push   $0x19
  80239f:	e8 6d fd ff ff       	call   802111 <syscall>
  8023a4:	83 c4 18             	add    $0x18,%esp
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	50                   	push   %eax
  8023b8:	6a 1a                	push   $0x1a
  8023ba:	e8 52 fd ff ff       	call   802111 <syscall>
  8023bf:	83 c4 18             	add    $0x18,%esp
}
  8023c2:	90                   	nop
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	50                   	push   %eax
  8023d4:	6a 1b                	push   $0x1b
  8023d6:	e8 36 fd ff ff       	call   802111 <syscall>
  8023db:	83 c4 18             	add    $0x18,%esp
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 05                	push   $0x5
  8023ef:	e8 1d fd ff ff       	call   802111 <syscall>
  8023f4:	83 c4 18             	add    $0x18,%esp
}
  8023f7:	c9                   	leave  
  8023f8:	c3                   	ret    

008023f9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 06                	push   $0x6
  802408:	e8 04 fd ff ff       	call   802111 <syscall>
  80240d:	83 c4 18             	add    $0x18,%esp
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 07                	push   $0x7
  802421:	e8 eb fc ff ff       	call   802111 <syscall>
  802426:	83 c4 18             	add    $0x18,%esp
}
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <sys_exit_env>:


void sys_exit_env(void)
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 1c                	push   $0x1c
  80243a:	e8 d2 fc ff ff       	call   802111 <syscall>
  80243f:	83 c4 18             	add    $0x18,%esp
}
  802442:	90                   	nop
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
  802448:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80244b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80244e:	8d 50 04             	lea    0x4(%eax),%edx
  802451:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	52                   	push   %edx
  80245b:	50                   	push   %eax
  80245c:	6a 1d                	push   $0x1d
  80245e:	e8 ae fc ff ff       	call   802111 <syscall>
  802463:	83 c4 18             	add    $0x18,%esp
	return result;
  802466:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802469:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80246c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80246f:	89 01                	mov    %eax,(%ecx)
  802471:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802474:	8b 45 08             	mov    0x8(%ebp),%eax
  802477:	c9                   	leave  
  802478:	c2 04 00             	ret    $0x4

0080247b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	ff 75 10             	pushl  0x10(%ebp)
  802485:	ff 75 0c             	pushl  0xc(%ebp)
  802488:	ff 75 08             	pushl  0x8(%ebp)
  80248b:	6a 13                	push   $0x13
  80248d:	e8 7f fc ff ff       	call   802111 <syscall>
  802492:	83 c4 18             	add    $0x18,%esp
	return ;
  802495:	90                   	nop
}
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <sys_rcr2>:
uint32 sys_rcr2()
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 1e                	push   $0x1e
  8024a7:	e8 65 fc ff ff       	call   802111 <syscall>
  8024ac:	83 c4 18             	add    $0x18,%esp
}
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	83 ec 04             	sub    $0x4,%esp
  8024b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024bd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	50                   	push   %eax
  8024ca:	6a 1f                	push   $0x1f
  8024cc:	e8 40 fc ff ff       	call   802111 <syscall>
  8024d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d4:	90                   	nop
}
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <rsttst>:
void rsttst()
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 21                	push   $0x21
  8024e6:	e8 26 fc ff ff       	call   802111 <syscall>
  8024eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ee:	90                   	nop
}
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
  8024f4:	83 ec 04             	sub    $0x4,%esp
  8024f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8024fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024fd:	8b 55 18             	mov    0x18(%ebp),%edx
  802500:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802504:	52                   	push   %edx
  802505:	50                   	push   %eax
  802506:	ff 75 10             	pushl  0x10(%ebp)
  802509:	ff 75 0c             	pushl  0xc(%ebp)
  80250c:	ff 75 08             	pushl  0x8(%ebp)
  80250f:	6a 20                	push   $0x20
  802511:	e8 fb fb ff ff       	call   802111 <syscall>
  802516:	83 c4 18             	add    $0x18,%esp
	return ;
  802519:	90                   	nop
}
  80251a:	c9                   	leave  
  80251b:	c3                   	ret    

0080251c <chktst>:
void chktst(uint32 n)
{
  80251c:	55                   	push   %ebp
  80251d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	ff 75 08             	pushl  0x8(%ebp)
  80252a:	6a 22                	push   $0x22
  80252c:	e8 e0 fb ff ff       	call   802111 <syscall>
  802531:	83 c4 18             	add    $0x18,%esp
	return ;
  802534:	90                   	nop
}
  802535:	c9                   	leave  
  802536:	c3                   	ret    

00802537 <inctst>:

void inctst()
{
  802537:	55                   	push   %ebp
  802538:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 23                	push   $0x23
  802546:	e8 c6 fb ff ff       	call   802111 <syscall>
  80254b:	83 c4 18             	add    $0x18,%esp
	return ;
  80254e:	90                   	nop
}
  80254f:	c9                   	leave  
  802550:	c3                   	ret    

00802551 <gettst>:
uint32 gettst()
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	6a 24                	push   $0x24
  802560:	e8 ac fb ff ff       	call   802111 <syscall>
  802565:	83 c4 18             	add    $0x18,%esp
}
  802568:	c9                   	leave  
  802569:	c3                   	ret    

0080256a <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80256a:	55                   	push   %ebp
  80256b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80256d:	6a 00                	push   $0x0
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 25                	push   $0x25
  802579:	e8 93 fb ff ff       	call   802111 <syscall>
  80257e:	83 c4 18             	add    $0x18,%esp
  802581:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802586:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802590:	8b 45 08             	mov    0x8(%ebp),%eax
  802593:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	ff 75 08             	pushl  0x8(%ebp)
  8025a3:	6a 26                	push   $0x26
  8025a5:	e8 67 fb ff ff       	call   802111 <syscall>
  8025aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ad:	90                   	nop
}
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c0:	6a 00                	push   $0x0
  8025c2:	53                   	push   %ebx
  8025c3:	51                   	push   %ecx
  8025c4:	52                   	push   %edx
  8025c5:	50                   	push   %eax
  8025c6:	6a 27                	push   $0x27
  8025c8:	e8 44 fb ff ff       	call   802111 <syscall>
  8025cd:	83 c4 18             	add    $0x18,%esp
}
  8025d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025d3:	c9                   	leave  
  8025d4:	c3                   	ret    

008025d5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8025d5:	55                   	push   %ebp
  8025d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8025d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025db:	8b 45 08             	mov    0x8(%ebp),%eax
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	52                   	push   %edx
  8025e5:	50                   	push   %eax
  8025e6:	6a 28                	push   $0x28
  8025e8:	e8 24 fb ff ff       	call   802111 <syscall>
  8025ed:	83 c4 18             	add    $0x18,%esp
}
  8025f0:	c9                   	leave  
  8025f1:	c3                   	ret    

008025f2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8025f2:	55                   	push   %ebp
  8025f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8025f5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8025f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	6a 00                	push   $0x0
  802600:	51                   	push   %ecx
  802601:	ff 75 10             	pushl  0x10(%ebp)
  802604:	52                   	push   %edx
  802605:	50                   	push   %eax
  802606:	6a 29                	push   $0x29
  802608:	e8 04 fb ff ff       	call   802111 <syscall>
  80260d:	83 c4 18             	add    $0x18,%esp
}
  802610:	c9                   	leave  
  802611:	c3                   	ret    

00802612 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802612:	55                   	push   %ebp
  802613:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802615:	6a 00                	push   $0x0
  802617:	6a 00                	push   $0x0
  802619:	ff 75 10             	pushl  0x10(%ebp)
  80261c:	ff 75 0c             	pushl  0xc(%ebp)
  80261f:	ff 75 08             	pushl  0x8(%ebp)
  802622:	6a 12                	push   $0x12
  802624:	e8 e8 fa ff ff       	call   802111 <syscall>
  802629:	83 c4 18             	add    $0x18,%esp
	return ;
  80262c:	90                   	nop
}
  80262d:	c9                   	leave  
  80262e:	c3                   	ret    

0080262f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802632:	8b 55 0c             	mov    0xc(%ebp),%edx
  802635:	8b 45 08             	mov    0x8(%ebp),%eax
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	52                   	push   %edx
  80263f:	50                   	push   %eax
  802640:	6a 2a                	push   $0x2a
  802642:	e8 ca fa ff ff       	call   802111 <syscall>
  802647:	83 c4 18             	add    $0x18,%esp
	return;
  80264a:	90                   	nop
}
  80264b:	c9                   	leave  
  80264c:	c3                   	ret    

0080264d <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	6a 00                	push   $0x0
  802658:	6a 00                	push   $0x0
  80265a:	6a 2b                	push   $0x2b
  80265c:	e8 b0 fa ff ff       	call   802111 <syscall>
  802661:	83 c4 18             	add    $0x18,%esp
}
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	ff 75 0c             	pushl  0xc(%ebp)
  802672:	ff 75 08             	pushl  0x8(%ebp)
  802675:	6a 2d                	push   $0x2d
  802677:	e8 95 fa ff ff       	call   802111 <syscall>
  80267c:	83 c4 18             	add    $0x18,%esp
	return;
  80267f:	90                   	nop
}
  802680:	c9                   	leave  
  802681:	c3                   	ret    

00802682 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802682:	55                   	push   %ebp
  802683:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802685:	6a 00                	push   $0x0
  802687:	6a 00                	push   $0x0
  802689:	6a 00                	push   $0x0
  80268b:	ff 75 0c             	pushl  0xc(%ebp)
  80268e:	ff 75 08             	pushl  0x8(%ebp)
  802691:	6a 2c                	push   $0x2c
  802693:	e8 79 fa ff ff       	call   802111 <syscall>
  802698:	83 c4 18             	add    $0x18,%esp
	return ;
  80269b:	90                   	nop
}
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8026a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	52                   	push   %edx
  8026ae:	50                   	push   %eax
  8026af:	6a 2e                	push   $0x2e
  8026b1:	e8 5b fa ff ff       	call   802111 <syscall>
  8026b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b9:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  8026ba:	c9                   	leave  
  8026bb:	c3                   	ret    

008026bc <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8026bc:	55                   	push   %ebp
  8026bd:	89 e5                	mov    %esp,%ebp
  8026bf:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8026c2:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  8026c9:	72 09                	jb     8026d4 <to_page_va+0x18>
  8026cb:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  8026d2:	72 14                	jb     8026e8 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8026d4:	83 ec 04             	sub    $0x4,%esp
  8026d7:	68 80 44 80 00       	push   $0x804480
  8026dc:	6a 15                	push   $0x15
  8026de:	68 ab 44 80 00       	push   $0x8044ab
  8026e3:	e8 2e 0f 00 00       	call   803616 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8026e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026eb:	ba 60 50 80 00       	mov    $0x805060,%edx
  8026f0:	29 d0                	sub    %edx,%eax
  8026f2:	c1 f8 02             	sar    $0x2,%eax
  8026f5:	89 c2                	mov    %eax,%edx
  8026f7:	89 d0                	mov    %edx,%eax
  8026f9:	c1 e0 02             	shl    $0x2,%eax
  8026fc:	01 d0                	add    %edx,%eax
  8026fe:	c1 e0 02             	shl    $0x2,%eax
  802701:	01 d0                	add    %edx,%eax
  802703:	c1 e0 02             	shl    $0x2,%eax
  802706:	01 d0                	add    %edx,%eax
  802708:	89 c1                	mov    %eax,%ecx
  80270a:	c1 e1 08             	shl    $0x8,%ecx
  80270d:	01 c8                	add    %ecx,%eax
  80270f:	89 c1                	mov    %eax,%ecx
  802711:	c1 e1 10             	shl    $0x10,%ecx
  802714:	01 c8                	add    %ecx,%eax
  802716:	01 c0                	add    %eax,%eax
  802718:	01 d0                	add    %edx,%eax
  80271a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802720:	c1 e0 0c             	shl    $0xc,%eax
  802723:	89 c2                	mov    %eax,%edx
  802725:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80272a:	01 d0                	add    %edx,%eax
}
  80272c:	c9                   	leave  
  80272d:	c3                   	ret    

0080272e <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
  802731:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802734:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802739:	8b 55 08             	mov    0x8(%ebp),%edx
  80273c:	29 c2                	sub    %eax,%edx
  80273e:	89 d0                	mov    %edx,%eax
  802740:	c1 e8 0c             	shr    $0xc,%eax
  802743:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802746:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274a:	78 09                	js     802755 <to_page_info+0x27>
  80274c:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802753:	7e 14                	jle    802769 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802755:	83 ec 04             	sub    $0x4,%esp
  802758:	68 c4 44 80 00       	push   $0x8044c4
  80275d:	6a 22                	push   $0x22
  80275f:	68 ab 44 80 00       	push   $0x8044ab
  802764:	e8 ad 0e 00 00       	call   803616 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802769:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276c:	89 d0                	mov    %edx,%eax
  80276e:	01 c0                	add    %eax,%eax
  802770:	01 d0                	add    %edx,%eax
  802772:	c1 e0 02             	shl    $0x2,%eax
  802775:	05 60 50 80 00       	add    $0x805060,%eax
}
  80277a:	c9                   	leave  
  80277b:	c3                   	ret    

0080277c <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80277c:	55                   	push   %ebp
  80277d:	89 e5                	mov    %esp,%ebp
  80277f:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802782:	8b 45 08             	mov    0x8(%ebp),%eax
  802785:	05 00 00 00 02       	add    $0x2000000,%eax
  80278a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80278d:	73 16                	jae    8027a5 <initialize_dynamic_allocator+0x29>
  80278f:	68 e8 44 80 00       	push   $0x8044e8
  802794:	68 0e 45 80 00       	push   $0x80450e
  802799:	6a 34                	push   $0x34
  80279b:	68 ab 44 80 00       	push   $0x8044ab
  8027a0:	e8 71 0e 00 00       	call   803616 <_panic>
		is_initialized = 1;
  8027a5:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  8027ac:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  8027b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ba:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  8027bf:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  8027c6:	00 00 00 
  8027c9:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8027d0:	00 00 00 
  8027d3:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  8027da:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  8027dd:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  8027e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8027eb:	eb 36                	jmp    802823 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	c1 e0 04             	shl    $0x4,%eax
  8027f3:	05 80 d0 81 00       	add    $0x81d080,%eax
  8027f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	c1 e0 04             	shl    $0x4,%eax
  802804:	05 84 d0 81 00       	add    $0x81d084,%eax
  802809:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	c1 e0 04             	shl    $0x4,%eax
  802815:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80281a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802820:	ff 45 f4             	incl   -0xc(%ebp)
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802829:	72 c2                	jb     8027ed <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  80282b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802831:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802836:	29 c2                	sub    %eax,%edx
  802838:	89 d0                	mov    %edx,%eax
  80283a:	c1 e8 0c             	shr    $0xc,%eax
  80283d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802840:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802847:	e9 c8 00 00 00       	jmp    802914 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  80284c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80284f:	89 d0                	mov    %edx,%eax
  802851:	01 c0                	add    %eax,%eax
  802853:	01 d0                	add    %edx,%eax
  802855:	c1 e0 02             	shl    $0x2,%eax
  802858:	05 68 50 80 00       	add    $0x805068,%eax
  80285d:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802862:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802865:	89 d0                	mov    %edx,%eax
  802867:	01 c0                	add    %eax,%eax
  802869:	01 d0                	add    %edx,%eax
  80286b:	c1 e0 02             	shl    $0x2,%eax
  80286e:	05 6a 50 80 00       	add    $0x80506a,%eax
  802873:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802878:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80287e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802881:	89 c8                	mov    %ecx,%eax
  802883:	01 c0                	add    %eax,%eax
  802885:	01 c8                	add    %ecx,%eax
  802887:	c1 e0 02             	shl    $0x2,%eax
  80288a:	05 64 50 80 00       	add    $0x805064,%eax
  80288f:	89 10                	mov    %edx,(%eax)
  802891:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802894:	89 d0                	mov    %edx,%eax
  802896:	01 c0                	add    %eax,%eax
  802898:	01 d0                	add    %edx,%eax
  80289a:	c1 e0 02             	shl    $0x2,%eax
  80289d:	05 64 50 80 00       	add    $0x805064,%eax
  8028a2:	8b 00                	mov    (%eax),%eax
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	74 1b                	je     8028c3 <initialize_dynamic_allocator+0x147>
  8028a8:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8028ae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8028b1:	89 c8                	mov    %ecx,%eax
  8028b3:	01 c0                	add    %eax,%eax
  8028b5:	01 c8                	add    %ecx,%eax
  8028b7:	c1 e0 02             	shl    $0x2,%eax
  8028ba:	05 60 50 80 00       	add    $0x805060,%eax
  8028bf:	89 02                	mov    %eax,(%edx)
  8028c1:	eb 16                	jmp    8028d9 <initialize_dynamic_allocator+0x15d>
  8028c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c6:	89 d0                	mov    %edx,%eax
  8028c8:	01 c0                	add    %eax,%eax
  8028ca:	01 d0                	add    %edx,%eax
  8028cc:	c1 e0 02             	shl    $0x2,%eax
  8028cf:	05 60 50 80 00       	add    $0x805060,%eax
  8028d4:	a3 48 50 80 00       	mov    %eax,0x805048
  8028d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028dc:	89 d0                	mov    %edx,%eax
  8028de:	01 c0                	add    %eax,%eax
  8028e0:	01 d0                	add    %edx,%eax
  8028e2:	c1 e0 02             	shl    $0x2,%eax
  8028e5:	05 60 50 80 00       	add    $0x805060,%eax
  8028ea:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8028ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f2:	89 d0                	mov    %edx,%eax
  8028f4:	01 c0                	add    %eax,%eax
  8028f6:	01 d0                	add    %edx,%eax
  8028f8:	c1 e0 02             	shl    $0x2,%eax
  8028fb:	05 60 50 80 00       	add    $0x805060,%eax
  802900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802906:	a1 54 50 80 00       	mov    0x805054,%eax
  80290b:	40                   	inc    %eax
  80290c:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802911:	ff 45 f0             	incl   -0x10(%ebp)
  802914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802917:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80291a:	0f 82 2c ff ff ff    	jb     80284c <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802923:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802926:	eb 2f                	jmp    802957 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802928:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80292b:	89 d0                	mov    %edx,%eax
  80292d:	01 c0                	add    %eax,%eax
  80292f:	01 d0                	add    %edx,%eax
  802931:	c1 e0 02             	shl    $0x2,%eax
  802934:	05 68 50 80 00       	add    $0x805068,%eax
  802939:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  80293e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802941:	89 d0                	mov    %edx,%eax
  802943:	01 c0                	add    %eax,%eax
  802945:	01 d0                	add    %edx,%eax
  802947:	c1 e0 02             	shl    $0x2,%eax
  80294a:	05 6a 50 80 00       	add    $0x80506a,%eax
  80294f:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802954:	ff 45 ec             	incl   -0x14(%ebp)
  802957:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  80295e:	76 c8                	jbe    802928 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802960:	90                   	nop
  802961:	c9                   	leave  
  802962:	c3                   	ret    

00802963 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802963:	55                   	push   %ebp
  802964:	89 e5                	mov    %esp,%ebp
  802966:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802969:	8b 55 08             	mov    0x8(%ebp),%edx
  80296c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802971:	29 c2                	sub    %eax,%edx
  802973:	89 d0                	mov    %edx,%eax
  802975:	c1 e8 0c             	shr    $0xc,%eax
  802978:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  80297b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80297e:	89 d0                	mov    %edx,%eax
  802980:	01 c0                	add    %eax,%eax
  802982:	01 d0                	add    %edx,%eax
  802984:	c1 e0 02             	shl    $0x2,%eax
  802987:	05 68 50 80 00       	add    $0x805068,%eax
  80298c:	8b 00                	mov    (%eax),%eax
  80298e:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802991:	c9                   	leave  
  802992:	c3                   	ret    

00802993 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802993:	55                   	push   %ebp
  802994:	89 e5                	mov    %esp,%ebp
  802996:	83 ec 14             	sub    $0x14,%esp
  802999:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  80299c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8029a0:	77 07                	ja     8029a9 <nearest_pow2_ceil.1513+0x16>
  8029a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8029a7:	eb 20                	jmp    8029c9 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  8029a9:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  8029b0:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  8029b3:	eb 08                	jmp    8029bd <nearest_pow2_ceil.1513+0x2a>
  8029b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029b8:	01 c0                	add    %eax,%eax
  8029ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8029bd:	d1 6d 08             	shrl   0x8(%ebp)
  8029c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c4:	75 ef                	jne    8029b5 <nearest_pow2_ceil.1513+0x22>
        return power;
  8029c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8029c9:	c9                   	leave  
  8029ca:	c3                   	ret    

008029cb <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8029cb:	55                   	push   %ebp
  8029cc:	89 e5                	mov    %esp,%ebp
  8029ce:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8029d1:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8029d8:	76 16                	jbe    8029f0 <alloc_block+0x25>
  8029da:	68 24 45 80 00       	push   $0x804524
  8029df:	68 0e 45 80 00       	push   $0x80450e
  8029e4:	6a 72                	push   $0x72
  8029e6:	68 ab 44 80 00       	push   $0x8044ab
  8029eb:	e8 26 0c 00 00       	call   803616 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  8029f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f4:	75 0a                	jne    802a00 <alloc_block+0x35>
  8029f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fb:	e9 bd 04 00 00       	jmp    802ebd <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802a00:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802a07:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a0d:	73 06                	jae    802a15 <alloc_block+0x4a>
        size = min_block_size;
  802a0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a12:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802a15:	83 ec 0c             	sub    $0xc,%esp
  802a18:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802a1b:	ff 75 08             	pushl  0x8(%ebp)
  802a1e:	89 c1                	mov    %eax,%ecx
  802a20:	e8 6e ff ff ff       	call   802993 <nearest_pow2_ceil.1513>
  802a25:	83 c4 10             	add    $0x10,%esp
  802a28:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802a2b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a2e:	83 ec 0c             	sub    $0xc,%esp
  802a31:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802a34:	52                   	push   %edx
  802a35:	89 c1                	mov    %eax,%ecx
  802a37:	e8 83 04 00 00       	call   802ebf <log2_ceil.1520>
  802a3c:	83 c4 10             	add    $0x10,%esp
  802a3f:	83 e8 03             	sub    $0x3,%eax
  802a42:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802a45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a48:	c1 e0 04             	shl    $0x4,%eax
  802a4b:	05 80 d0 81 00       	add    $0x81d080,%eax
  802a50:	8b 00                	mov    (%eax),%eax
  802a52:	85 c0                	test   %eax,%eax
  802a54:	0f 84 d8 00 00 00    	je     802b32 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802a5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a5d:	c1 e0 04             	shl    $0x4,%eax
  802a60:	05 80 d0 81 00       	add    $0x81d080,%eax
  802a65:	8b 00                	mov    (%eax),%eax
  802a67:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802a6a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a6e:	75 17                	jne    802a87 <alloc_block+0xbc>
  802a70:	83 ec 04             	sub    $0x4,%esp
  802a73:	68 45 45 80 00       	push   $0x804545
  802a78:	68 98 00 00 00       	push   $0x98
  802a7d:	68 ab 44 80 00       	push   $0x8044ab
  802a82:	e8 8f 0b 00 00       	call   803616 <_panic>
  802a87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	85 c0                	test   %eax,%eax
  802a8e:	74 10                	je     802aa0 <alloc_block+0xd5>
  802a90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a93:	8b 00                	mov    (%eax),%eax
  802a95:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a98:	8b 52 04             	mov    0x4(%edx),%edx
  802a9b:	89 50 04             	mov    %edx,0x4(%eax)
  802a9e:	eb 14                	jmp    802ab4 <alloc_block+0xe9>
  802aa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa3:	8b 40 04             	mov    0x4(%eax),%eax
  802aa6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802aa9:	c1 e2 04             	shl    $0x4,%edx
  802aac:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802ab2:	89 02                	mov    %eax,(%edx)
  802ab4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab7:	8b 40 04             	mov    0x4(%eax),%eax
  802aba:	85 c0                	test   %eax,%eax
  802abc:	74 0f                	je     802acd <alloc_block+0x102>
  802abe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac1:	8b 40 04             	mov    0x4(%eax),%eax
  802ac4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ac7:	8b 12                	mov    (%edx),%edx
  802ac9:	89 10                	mov    %edx,(%eax)
  802acb:	eb 13                	jmp    802ae0 <alloc_block+0x115>
  802acd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad0:	8b 00                	mov    (%eax),%eax
  802ad2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ad5:	c1 e2 04             	shl    $0x4,%edx
  802ad8:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802ade:	89 02                	mov    %eax,(%edx)
  802ae0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af6:	c1 e0 04             	shl    $0x4,%eax
  802af9:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802afe:	8b 00                	mov    (%eax),%eax
  802b00:	8d 50 ff             	lea    -0x1(%eax),%edx
  802b03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b06:	c1 e0 04             	shl    $0x4,%eax
  802b09:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802b0e:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802b10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b13:	83 ec 0c             	sub    $0xc,%esp
  802b16:	50                   	push   %eax
  802b17:	e8 12 fc ff ff       	call   80272e <to_page_info>
  802b1c:	83 c4 10             	add    $0x10,%esp
  802b1f:	89 c2                	mov    %eax,%edx
  802b21:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802b25:	48                   	dec    %eax
  802b26:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802b2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2d:	e9 8b 03 00 00       	jmp    802ebd <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802b32:	a1 48 50 80 00       	mov    0x805048,%eax
  802b37:	85 c0                	test   %eax,%eax
  802b39:	0f 84 64 02 00 00    	je     802da3 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802b3f:	a1 48 50 80 00       	mov    0x805048,%eax
  802b44:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802b47:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b4b:	75 17                	jne    802b64 <alloc_block+0x199>
  802b4d:	83 ec 04             	sub    $0x4,%esp
  802b50:	68 45 45 80 00       	push   $0x804545
  802b55:	68 a0 00 00 00       	push   $0xa0
  802b5a:	68 ab 44 80 00       	push   $0x8044ab
  802b5f:	e8 b2 0a 00 00       	call   803616 <_panic>
  802b64:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b67:	8b 00                	mov    (%eax),%eax
  802b69:	85 c0                	test   %eax,%eax
  802b6b:	74 10                	je     802b7d <alloc_block+0x1b2>
  802b6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b70:	8b 00                	mov    (%eax),%eax
  802b72:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b75:	8b 52 04             	mov    0x4(%edx),%edx
  802b78:	89 50 04             	mov    %edx,0x4(%eax)
  802b7b:	eb 0b                	jmp    802b88 <alloc_block+0x1bd>
  802b7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b80:	8b 40 04             	mov    0x4(%eax),%eax
  802b83:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802b88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b8b:	8b 40 04             	mov    0x4(%eax),%eax
  802b8e:	85 c0                	test   %eax,%eax
  802b90:	74 0f                	je     802ba1 <alloc_block+0x1d6>
  802b92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b95:	8b 40 04             	mov    0x4(%eax),%eax
  802b98:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b9b:	8b 12                	mov    (%edx),%edx
  802b9d:	89 10                	mov    %edx,(%eax)
  802b9f:	eb 0a                	jmp    802bab <alloc_block+0x1e0>
  802ba1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ba4:	8b 00                	mov    (%eax),%eax
  802ba6:	a3 48 50 80 00       	mov    %eax,0x805048
  802bab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bb7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbe:	a1 54 50 80 00       	mov    0x805054,%eax
  802bc3:	48                   	dec    %eax
  802bc4:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802bc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bcf:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802bd3:	b8 00 10 00 00       	mov    $0x1000,%eax
  802bd8:	99                   	cltd   
  802bd9:	f7 7d e8             	idivl  -0x18(%ebp)
  802bdc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bdf:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802be3:	83 ec 0c             	sub    $0xc,%esp
  802be6:	ff 75 dc             	pushl  -0x24(%ebp)
  802be9:	e8 ce fa ff ff       	call   8026bc <to_page_va>
  802bee:	83 c4 10             	add    $0x10,%esp
  802bf1:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802bf4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bf7:	83 ec 0c             	sub    $0xc,%esp
  802bfa:	50                   	push   %eax
  802bfb:	e8 c0 ee ff ff       	call   801ac0 <get_page>
  802c00:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802c03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c0a:	e9 aa 00 00 00       	jmp    802cb9 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802c16:	89 c2                	mov    %eax,%edx
  802c18:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c1b:	01 d0                	add    %edx,%eax
  802c1d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802c20:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802c24:	75 17                	jne    802c3d <alloc_block+0x272>
  802c26:	83 ec 04             	sub    $0x4,%esp
  802c29:	68 64 45 80 00       	push   $0x804564
  802c2e:	68 aa 00 00 00       	push   $0xaa
  802c33:	68 ab 44 80 00       	push   $0x8044ab
  802c38:	e8 d9 09 00 00       	call   803616 <_panic>
  802c3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c40:	c1 e0 04             	shl    $0x4,%eax
  802c43:	05 84 d0 81 00       	add    $0x81d084,%eax
  802c48:	8b 10                	mov    (%eax),%edx
  802c4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c4d:	89 50 04             	mov    %edx,0x4(%eax)
  802c50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c53:	8b 40 04             	mov    0x4(%eax),%eax
  802c56:	85 c0                	test   %eax,%eax
  802c58:	74 14                	je     802c6e <alloc_block+0x2a3>
  802c5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5d:	c1 e0 04             	shl    $0x4,%eax
  802c60:	05 84 d0 81 00       	add    $0x81d084,%eax
  802c65:	8b 00                	mov    (%eax),%eax
  802c67:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c6a:	89 10                	mov    %edx,(%eax)
  802c6c:	eb 11                	jmp    802c7f <alloc_block+0x2b4>
  802c6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c71:	c1 e0 04             	shl    $0x4,%eax
  802c74:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802c7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c7d:	89 02                	mov    %eax,(%edx)
  802c7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c82:	c1 e0 04             	shl    $0x4,%eax
  802c85:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802c8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c8e:	89 02                	mov    %eax,(%edx)
  802c90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9c:	c1 e0 04             	shl    $0x4,%eax
  802c9f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802ca4:	8b 00                	mov    (%eax),%eax
  802ca6:	8d 50 01             	lea    0x1(%eax),%edx
  802ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cac:	c1 e0 04             	shl    $0x4,%eax
  802caf:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802cb4:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802cb6:	ff 45 f4             	incl   -0xc(%ebp)
  802cb9:	b8 00 10 00 00       	mov    $0x1000,%eax
  802cbe:	99                   	cltd   
  802cbf:	f7 7d e8             	idivl  -0x18(%ebp)
  802cc2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802cc5:	0f 8f 44 ff ff ff    	jg     802c0f <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802ccb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cce:	c1 e0 04             	shl    $0x4,%eax
  802cd1:	05 80 d0 81 00       	add    $0x81d080,%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802cdb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802cdf:	75 17                	jne    802cf8 <alloc_block+0x32d>
  802ce1:	83 ec 04             	sub    $0x4,%esp
  802ce4:	68 45 45 80 00       	push   $0x804545
  802ce9:	68 ae 00 00 00       	push   $0xae
  802cee:	68 ab 44 80 00       	push   $0x8044ab
  802cf3:	e8 1e 09 00 00       	call   803616 <_panic>
  802cf8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802cfb:	8b 00                	mov    (%eax),%eax
  802cfd:	85 c0                	test   %eax,%eax
  802cff:	74 10                	je     802d11 <alloc_block+0x346>
  802d01:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d04:	8b 00                	mov    (%eax),%eax
  802d06:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802d09:	8b 52 04             	mov    0x4(%edx),%edx
  802d0c:	89 50 04             	mov    %edx,0x4(%eax)
  802d0f:	eb 14                	jmp    802d25 <alloc_block+0x35a>
  802d11:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d14:	8b 40 04             	mov    0x4(%eax),%eax
  802d17:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d1a:	c1 e2 04             	shl    $0x4,%edx
  802d1d:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802d23:	89 02                	mov    %eax,(%edx)
  802d25:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d28:	8b 40 04             	mov    0x4(%eax),%eax
  802d2b:	85 c0                	test   %eax,%eax
  802d2d:	74 0f                	je     802d3e <alloc_block+0x373>
  802d2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d32:	8b 40 04             	mov    0x4(%eax),%eax
  802d35:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802d38:	8b 12                	mov    (%edx),%edx
  802d3a:	89 10                	mov    %edx,(%eax)
  802d3c:	eb 13                	jmp    802d51 <alloc_block+0x386>
  802d3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d41:	8b 00                	mov    (%eax),%eax
  802d43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d46:	c1 e2 04             	shl    $0x4,%edx
  802d49:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802d4f:	89 02                	mov    %eax,(%edx)
  802d51:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d67:	c1 e0 04             	shl    $0x4,%eax
  802d6a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d6f:	8b 00                	mov    (%eax),%eax
  802d71:	8d 50 ff             	lea    -0x1(%eax),%edx
  802d74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d77:	c1 e0 04             	shl    $0x4,%eax
  802d7a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d7f:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802d81:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d84:	83 ec 0c             	sub    $0xc,%esp
  802d87:	50                   	push   %eax
  802d88:	e8 a1 f9 ff ff       	call   80272e <to_page_info>
  802d8d:	83 c4 10             	add    $0x10,%esp
  802d90:	89 c2                	mov    %eax,%edx
  802d92:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802d96:	48                   	dec    %eax
  802d97:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802d9b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d9e:	e9 1a 01 00 00       	jmp    802ebd <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da6:	40                   	inc    %eax
  802da7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802daa:	e9 ed 00 00 00       	jmp    802e9c <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db2:	c1 e0 04             	shl    $0x4,%eax
  802db5:	05 80 d0 81 00       	add    $0x81d080,%eax
  802dba:	8b 00                	mov    (%eax),%eax
  802dbc:	85 c0                	test   %eax,%eax
  802dbe:	0f 84 d5 00 00 00    	je     802e99 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc7:	c1 e0 04             	shl    $0x4,%eax
  802dca:	05 80 d0 81 00       	add    $0x81d080,%eax
  802dcf:	8b 00                	mov    (%eax),%eax
  802dd1:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  802dd4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802dd8:	75 17                	jne    802df1 <alloc_block+0x426>
  802dda:	83 ec 04             	sub    $0x4,%esp
  802ddd:	68 45 45 80 00       	push   $0x804545
  802de2:	68 b8 00 00 00       	push   $0xb8
  802de7:	68 ab 44 80 00       	push   $0x8044ab
  802dec:	e8 25 08 00 00       	call   803616 <_panic>
  802df1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802df4:	8b 00                	mov    (%eax),%eax
  802df6:	85 c0                	test   %eax,%eax
  802df8:	74 10                	je     802e0a <alloc_block+0x43f>
  802dfa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dfd:	8b 00                	mov    (%eax),%eax
  802dff:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e02:	8b 52 04             	mov    0x4(%edx),%edx
  802e05:	89 50 04             	mov    %edx,0x4(%eax)
  802e08:	eb 14                	jmp    802e1e <alloc_block+0x453>
  802e0a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e0d:	8b 40 04             	mov    0x4(%eax),%eax
  802e10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e13:	c1 e2 04             	shl    $0x4,%edx
  802e16:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802e1c:	89 02                	mov    %eax,(%edx)
  802e1e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e21:	8b 40 04             	mov    0x4(%eax),%eax
  802e24:	85 c0                	test   %eax,%eax
  802e26:	74 0f                	je     802e37 <alloc_block+0x46c>
  802e28:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e2b:	8b 40 04             	mov    0x4(%eax),%eax
  802e2e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e31:	8b 12                	mov    (%edx),%edx
  802e33:	89 10                	mov    %edx,(%eax)
  802e35:	eb 13                	jmp    802e4a <alloc_block+0x47f>
  802e37:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e3a:	8b 00                	mov    (%eax),%eax
  802e3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e3f:	c1 e2 04             	shl    $0x4,%edx
  802e42:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802e48:	89 02                	mov    %eax,(%edx)
  802e4a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e53:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e60:	c1 e0 04             	shl    $0x4,%eax
  802e63:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e68:	8b 00                	mov    (%eax),%eax
  802e6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  802e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e70:	c1 e0 04             	shl    $0x4,%eax
  802e73:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e78:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  802e7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e7d:	83 ec 0c             	sub    $0xc,%esp
  802e80:	50                   	push   %eax
  802e81:	e8 a8 f8 ff ff       	call   80272e <to_page_info>
  802e86:	83 c4 10             	add    $0x10,%esp
  802e89:	89 c2                	mov    %eax,%edx
  802e8b:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802e8f:	48                   	dec    %eax
  802e90:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  802e94:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e97:	eb 24                	jmp    802ebd <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802e99:	ff 45 f0             	incl   -0x10(%ebp)
  802e9c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802ea0:	0f 8e 09 ff ff ff    	jle    802daf <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  802ea6:	83 ec 04             	sub    $0x4,%esp
  802ea9:	68 87 45 80 00       	push   $0x804587
  802eae:	68 bf 00 00 00       	push   $0xbf
  802eb3:	68 ab 44 80 00       	push   $0x8044ab
  802eb8:	e8 59 07 00 00       	call   803616 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  802ebd:	c9                   	leave  
  802ebe:	c3                   	ret    

00802ebf <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  802ebf:	55                   	push   %ebp
  802ec0:	89 e5                	mov    %esp,%ebp
  802ec2:	83 ec 14             	sub    $0x14,%esp
  802ec5:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  802ec8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ecc:	75 07                	jne    802ed5 <log2_ceil.1520+0x16>
  802ece:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed3:	eb 1b                	jmp    802ef0 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  802ed5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  802edc:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  802edf:	eb 06                	jmp    802ee7 <log2_ceil.1520+0x28>
            x >>= 1;
  802ee1:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  802ee4:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  802ee7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eeb:	75 f4                	jne    802ee1 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  802eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802ef0:	c9                   	leave  
  802ef1:	c3                   	ret    

00802ef2 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  802ef2:	55                   	push   %ebp
  802ef3:	89 e5                	mov    %esp,%ebp
  802ef5:	83 ec 14             	sub    $0x14,%esp
  802ef8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  802efb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eff:	75 07                	jne    802f08 <log2_ceil.1547+0x16>
  802f01:	b8 00 00 00 00       	mov    $0x0,%eax
  802f06:	eb 1b                	jmp    802f23 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  802f08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  802f0f:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  802f12:	eb 06                	jmp    802f1a <log2_ceil.1547+0x28>
			x >>= 1;
  802f14:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  802f17:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  802f1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1e:	75 f4                	jne    802f14 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  802f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  802f23:	c9                   	leave  
  802f24:	c3                   	ret    

00802f25 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802f25:	55                   	push   %ebp
  802f26:	89 e5                	mov    %esp,%ebp
  802f28:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2e:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802f33:	39 c2                	cmp    %eax,%edx
  802f35:	72 0c                	jb     802f43 <free_block+0x1e>
  802f37:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3a:	a1 40 50 80 00       	mov    0x805040,%eax
  802f3f:	39 c2                	cmp    %eax,%edx
  802f41:	72 19                	jb     802f5c <free_block+0x37>
  802f43:	68 8c 45 80 00       	push   $0x80458c
  802f48:	68 0e 45 80 00       	push   $0x80450e
  802f4d:	68 d0 00 00 00       	push   $0xd0
  802f52:	68 ab 44 80 00       	push   $0x8044ab
  802f57:	e8 ba 06 00 00       	call   803616 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  802f5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f60:	0f 84 42 03 00 00    	je     8032a8 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  802f66:	8b 55 08             	mov    0x8(%ebp),%edx
  802f69:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802f6e:	39 c2                	cmp    %eax,%edx
  802f70:	72 0c                	jb     802f7e <free_block+0x59>
  802f72:	8b 55 08             	mov    0x8(%ebp),%edx
  802f75:	a1 40 50 80 00       	mov    0x805040,%eax
  802f7a:	39 c2                	cmp    %eax,%edx
  802f7c:	72 17                	jb     802f95 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  802f7e:	83 ec 04             	sub    $0x4,%esp
  802f81:	68 c4 45 80 00       	push   $0x8045c4
  802f86:	68 e6 00 00 00       	push   $0xe6
  802f8b:	68 ab 44 80 00       	push   $0x8044ab
  802f90:	e8 81 06 00 00       	call   803616 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  802f95:	8b 55 08             	mov    0x8(%ebp),%edx
  802f98:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802f9d:	29 c2                	sub    %eax,%edx
  802f9f:	89 d0                	mov    %edx,%eax
  802fa1:	83 e0 07             	and    $0x7,%eax
  802fa4:	85 c0                	test   %eax,%eax
  802fa6:	74 17                	je     802fbf <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  802fa8:	83 ec 04             	sub    $0x4,%esp
  802fab:	68 f8 45 80 00       	push   $0x8045f8
  802fb0:	68 ea 00 00 00       	push   $0xea
  802fb5:	68 ab 44 80 00       	push   $0x8044ab
  802fba:	e8 57 06 00 00       	call   803616 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	83 ec 0c             	sub    $0xc,%esp
  802fc5:	50                   	push   %eax
  802fc6:	e8 63 f7 ff ff       	call   80272e <to_page_info>
  802fcb:	83 c4 10             	add    $0x10,%esp
  802fce:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  802fd1:	83 ec 0c             	sub    $0xc,%esp
  802fd4:	ff 75 08             	pushl  0x8(%ebp)
  802fd7:	e8 87 f9 ff ff       	call   802963 <get_block_size>
  802fdc:	83 c4 10             	add    $0x10,%esp
  802fdf:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  802fe2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fe6:	75 17                	jne    802fff <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  802fe8:	83 ec 04             	sub    $0x4,%esp
  802feb:	68 24 46 80 00       	push   $0x804624
  802ff0:	68 f1 00 00 00       	push   $0xf1
  802ff5:	68 ab 44 80 00       	push   $0x8044ab
  802ffa:	e8 17 06 00 00       	call   803616 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  802fff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803002:	83 ec 0c             	sub    $0xc,%esp
  803005:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803008:	52                   	push   %edx
  803009:	89 c1                	mov    %eax,%ecx
  80300b:	e8 e2 fe ff ff       	call   802ef2 <log2_ceil.1547>
  803010:	83 c4 10             	add    $0x10,%esp
  803013:	83 e8 03             	sub    $0x3,%eax
  803016:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803019:	8b 45 08             	mov    0x8(%ebp),%eax
  80301c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  80301f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803023:	75 17                	jne    80303c <free_block+0x117>
  803025:	83 ec 04             	sub    $0x4,%esp
  803028:	68 70 46 80 00       	push   $0x804670
  80302d:	68 f6 00 00 00       	push   $0xf6
  803032:	68 ab 44 80 00       	push   $0x8044ab
  803037:	e8 da 05 00 00       	call   803616 <_panic>
  80303c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80303f:	c1 e0 04             	shl    $0x4,%eax
  803042:	05 80 d0 81 00       	add    $0x81d080,%eax
  803047:	8b 10                	mov    (%eax),%edx
  803049:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80304c:	89 10                	mov    %edx,(%eax)
  80304e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	85 c0                	test   %eax,%eax
  803055:	74 15                	je     80306c <free_block+0x147>
  803057:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305a:	c1 e0 04             	shl    $0x4,%eax
  80305d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803062:	8b 00                	mov    (%eax),%eax
  803064:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803067:	89 50 04             	mov    %edx,0x4(%eax)
  80306a:	eb 11                	jmp    80307d <free_block+0x158>
  80306c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306f:	c1 e0 04             	shl    $0x4,%eax
  803072:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803078:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80307b:	89 02                	mov    %eax,(%edx)
  80307d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803080:	c1 e0 04             	shl    $0x4,%eax
  803083:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803089:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80308c:	89 02                	mov    %eax,(%edx)
  80308e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803091:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803098:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80309b:	c1 e0 04             	shl    $0x4,%eax
  80309e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	8d 50 01             	lea    0x1(%eax),%edx
  8030a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ab:	c1 e0 04             	shl    $0x4,%eax
  8030ae:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030b3:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8030b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b8:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8030bc:	40                   	inc    %eax
  8030bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030c0:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8030c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c7:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8030cc:	29 c2                	sub    %eax,%edx
  8030ce:	89 d0                	mov    %edx,%eax
  8030d0:	c1 e8 0c             	shr    $0xc,%eax
  8030d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8030d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8030dd:	0f b7 c8             	movzwl %ax,%ecx
  8030e0:	b8 00 10 00 00       	mov    $0x1000,%eax
  8030e5:	99                   	cltd   
  8030e6:	f7 7d e8             	idivl  -0x18(%ebp)
  8030e9:	39 c1                	cmp    %eax,%ecx
  8030eb:	0f 85 b8 01 00 00    	jne    8032a9 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8030f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8030f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030fb:	c1 e0 04             	shl    $0x4,%eax
  8030fe:	05 80 d0 81 00       	add    $0x81d080,%eax
  803103:	8b 00                	mov    (%eax),%eax
  803105:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803108:	e9 d5 00 00 00       	jmp    8031e2 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  80310d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803110:	8b 00                	mov    (%eax),%eax
  803112:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803115:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803118:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80311d:	29 c2                	sub    %eax,%edx
  80311f:	89 d0                	mov    %edx,%eax
  803121:	c1 e8 0c             	shr    $0xc,%eax
  803124:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803127:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80312a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80312d:	0f 85 a9 00 00 00    	jne    8031dc <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  803133:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803137:	75 17                	jne    803150 <free_block+0x22b>
  803139:	83 ec 04             	sub    $0x4,%esp
  80313c:	68 45 45 80 00       	push   $0x804545
  803141:	68 04 01 00 00       	push   $0x104
  803146:	68 ab 44 80 00       	push   $0x8044ab
  80314b:	e8 c6 04 00 00       	call   803616 <_panic>
  803150:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803153:	8b 00                	mov    (%eax),%eax
  803155:	85 c0                	test   %eax,%eax
  803157:	74 10                	je     803169 <free_block+0x244>
  803159:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315c:	8b 00                	mov    (%eax),%eax
  80315e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803161:	8b 52 04             	mov    0x4(%edx),%edx
  803164:	89 50 04             	mov    %edx,0x4(%eax)
  803167:	eb 14                	jmp    80317d <free_block+0x258>
  803169:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316c:	8b 40 04             	mov    0x4(%eax),%eax
  80316f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803172:	c1 e2 04             	shl    $0x4,%edx
  803175:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80317b:	89 02                	mov    %eax,(%edx)
  80317d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803180:	8b 40 04             	mov    0x4(%eax),%eax
  803183:	85 c0                	test   %eax,%eax
  803185:	74 0f                	je     803196 <free_block+0x271>
  803187:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318a:	8b 40 04             	mov    0x4(%eax),%eax
  80318d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803190:	8b 12                	mov    (%edx),%edx
  803192:	89 10                	mov    %edx,(%eax)
  803194:	eb 13                	jmp    8031a9 <free_block+0x284>
  803196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803199:	8b 00                	mov    (%eax),%eax
  80319b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80319e:	c1 e2 04             	shl    $0x4,%edx
  8031a1:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8031a7:	89 02                	mov    %eax,(%edx)
  8031a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031bf:	c1 e0 04             	shl    $0x4,%eax
  8031c2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031c7:	8b 00                	mov    (%eax),%eax
  8031c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8031cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031cf:	c1 e0 04             	shl    $0x4,%eax
  8031d2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031d7:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8031d9:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8031dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8031e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031e6:	0f 85 21 ff ff ff    	jne    80310d <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8031ec:	b8 00 10 00 00       	mov    $0x1000,%eax
  8031f1:	99                   	cltd   
  8031f2:	f7 7d e8             	idivl  -0x18(%ebp)
  8031f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8031f8:	74 17                	je     803211 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8031fa:	83 ec 04             	sub    $0x4,%esp
  8031fd:	68 94 46 80 00       	push   $0x804694
  803202:	68 0c 01 00 00       	push   $0x10c
  803207:	68 ab 44 80 00       	push   $0x8044ab
  80320c:	e8 05 04 00 00       	call   803616 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803211:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803214:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  80321a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321d:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803223:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803227:	75 17                	jne    803240 <free_block+0x31b>
  803229:	83 ec 04             	sub    $0x4,%esp
  80322c:	68 64 45 80 00       	push   $0x804564
  803231:	68 11 01 00 00       	push   $0x111
  803236:	68 ab 44 80 00       	push   $0x8044ab
  80323b:	e8 d6 03 00 00       	call   803616 <_panic>
  803240:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803246:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803249:	89 50 04             	mov    %edx,0x4(%eax)
  80324c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324f:	8b 40 04             	mov    0x4(%eax),%eax
  803252:	85 c0                	test   %eax,%eax
  803254:	74 0c                	je     803262 <free_block+0x33d>
  803256:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80325b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80325e:	89 10                	mov    %edx,(%eax)
  803260:	eb 08                	jmp    80326a <free_block+0x345>
  803262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803265:	a3 48 50 80 00       	mov    %eax,0x805048
  80326a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326d:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803272:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803275:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327b:	a1 54 50 80 00       	mov    0x805054,%eax
  803280:	40                   	inc    %eax
  803281:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803286:	83 ec 0c             	sub    $0xc,%esp
  803289:	ff 75 ec             	pushl  -0x14(%ebp)
  80328c:	e8 2b f4 ff ff       	call   8026bc <to_page_va>
  803291:	83 c4 10             	add    $0x10,%esp
  803294:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803297:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80329a:	83 ec 0c             	sub    $0xc,%esp
  80329d:	50                   	push   %eax
  80329e:	e8 69 e8 ff ff       	call   801b0c <return_page>
  8032a3:	83 c4 10             	add    $0x10,%esp
  8032a6:	eb 01                	jmp    8032a9 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8032a8:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8032a9:	c9                   	leave  
  8032aa:	c3                   	ret    

008032ab <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8032ab:	55                   	push   %ebp
  8032ac:	89 e5                	mov    %esp,%ebp
  8032ae:	83 ec 14             	sub    $0x14,%esp
  8032b1:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8032b4:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8032b8:	77 07                	ja     8032c1 <nearest_pow2_ceil.1572+0x16>
      return 1;
  8032ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8032bf:	eb 20                	jmp    8032e1 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8032c1:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8032c8:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8032cb:	eb 08                	jmp    8032d5 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8032cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032d0:	01 c0                	add    %eax,%eax
  8032d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8032d5:	d1 6d 08             	shrl   0x8(%ebp)
  8032d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032dc:	75 ef                	jne    8032cd <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8032de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8032e1:	c9                   	leave  
  8032e2:	c3                   	ret    

008032e3 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8032e3:	55                   	push   %ebp
  8032e4:	89 e5                	mov    %esp,%ebp
  8032e6:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8032e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ed:	75 13                	jne    803302 <realloc_block+0x1f>
    return alloc_block(new_size);
  8032ef:	83 ec 0c             	sub    $0xc,%esp
  8032f2:	ff 75 0c             	pushl  0xc(%ebp)
  8032f5:	e8 d1 f6 ff ff       	call   8029cb <alloc_block>
  8032fa:	83 c4 10             	add    $0x10,%esp
  8032fd:	e9 d9 00 00 00       	jmp    8033db <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803302:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803306:	75 18                	jne    803320 <realloc_block+0x3d>
    free_block(va);
  803308:	83 ec 0c             	sub    $0xc,%esp
  80330b:	ff 75 08             	pushl  0x8(%ebp)
  80330e:	e8 12 fc ff ff       	call   802f25 <free_block>
  803313:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803316:	b8 00 00 00 00       	mov    $0x0,%eax
  80331b:	e9 bb 00 00 00       	jmp    8033db <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803320:	83 ec 0c             	sub    $0xc,%esp
  803323:	ff 75 08             	pushl  0x8(%ebp)
  803326:	e8 38 f6 ff ff       	call   802963 <get_block_size>
  80332b:	83 c4 10             	add    $0x10,%esp
  80332e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803331:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803338:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80333e:	73 06                	jae    803346 <realloc_block+0x63>
    new_size = min_block_size;
  803340:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803343:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803346:	83 ec 0c             	sub    $0xc,%esp
  803349:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80334c:	ff 75 0c             	pushl  0xc(%ebp)
  80334f:	89 c1                	mov    %eax,%ecx
  803351:	e8 55 ff ff ff       	call   8032ab <nearest_pow2_ceil.1572>
  803356:	83 c4 10             	add    $0x10,%esp
  803359:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  80335c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803362:	75 05                	jne    803369 <realloc_block+0x86>
    return va;
  803364:	8b 45 08             	mov    0x8(%ebp),%eax
  803367:	eb 72                	jmp    8033db <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803369:	83 ec 0c             	sub    $0xc,%esp
  80336c:	ff 75 0c             	pushl  0xc(%ebp)
  80336f:	e8 57 f6 ff ff       	call   8029cb <alloc_block>
  803374:	83 c4 10             	add    $0x10,%esp
  803377:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  80337a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80337e:	75 07                	jne    803387 <realloc_block+0xa4>
    return NULL;
  803380:	b8 00 00 00 00       	mov    $0x0,%eax
  803385:	eb 54                	jmp    8033db <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803387:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80338a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80338d:	39 d0                	cmp    %edx,%eax
  80338f:	76 02                	jbe    803393 <realloc_block+0xb0>
  803391:	89 d0                	mov    %edx,%eax
  803393:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  80339c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80339f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8033a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8033a9:	eb 17                	jmp    8033c2 <realloc_block+0xdf>
    dst[i] = src[i];
  8033ab:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b1:	01 c2                	add    %eax,%edx
  8033b3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8033b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b9:	01 c8                	add    %ecx,%eax
  8033bb:	8a 00                	mov    (%eax),%al
  8033bd:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  8033bf:	ff 45 f4             	incl   -0xc(%ebp)
  8033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8033c8:	72 e1                	jb     8033ab <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  8033ca:	83 ec 0c             	sub    $0xc,%esp
  8033cd:	ff 75 08             	pushl  0x8(%ebp)
  8033d0:	e8 50 fb ff ff       	call   802f25 <free_block>
  8033d5:	83 c4 10             	add    $0x10,%esp

  return new_va;
  8033d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8033db:	c9                   	leave  
  8033dc:	c3                   	ret    

008033dd <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8033dd:	55                   	push   %ebp
  8033de:	89 e5                	mov    %esp,%ebp
  8033e0:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  8033e3:	83 ec 04             	sub    $0x4,%esp
  8033e6:	68 c8 46 80 00       	push   $0x8046c8
  8033eb:	6a 07                	push   $0x7
  8033ed:	68 f7 46 80 00       	push   $0x8046f7
  8033f2:	e8 1f 02 00 00       	call   803616 <_panic>

008033f7 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8033f7:	55                   	push   %ebp
  8033f8:	89 e5                	mov    %esp,%ebp
  8033fa:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  8033fd:	83 ec 04             	sub    $0x4,%esp
  803400:	68 08 47 80 00       	push   $0x804708
  803405:	6a 0b                	push   $0xb
  803407:	68 f7 46 80 00       	push   $0x8046f7
  80340c:	e8 05 02 00 00       	call   803616 <_panic>

00803411 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  803411:	55                   	push   %ebp
  803412:	89 e5                	mov    %esp,%ebp
  803414:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803417:	83 ec 04             	sub    $0x4,%esp
  80341a:	68 34 47 80 00       	push   $0x804734
  80341f:	6a 10                	push   $0x10
  803421:	68 f7 46 80 00       	push   $0x8046f7
  803426:	e8 eb 01 00 00       	call   803616 <_panic>

0080342b <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  80342b:	55                   	push   %ebp
  80342c:	89 e5                	mov    %esp,%ebp
  80342e:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  803431:	83 ec 04             	sub    $0x4,%esp
  803434:	68 64 47 80 00       	push   $0x804764
  803439:	6a 15                	push   $0x15
  80343b:	68 f7 46 80 00       	push   $0x8046f7
  803440:	e8 d1 01 00 00       	call   803616 <_panic>

00803445 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  803445:	55                   	push   %ebp
  803446:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803448:	8b 45 08             	mov    0x8(%ebp),%eax
  80344b:	8b 40 10             	mov    0x10(%eax),%eax
}
  80344e:	5d                   	pop    %ebp
  80344f:	c3                   	ret    

00803450 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803450:	55                   	push   %ebp
  803451:	89 e5                	mov    %esp,%ebp
  803453:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803456:	8b 55 08             	mov    0x8(%ebp),%edx
  803459:	89 d0                	mov    %edx,%eax
  80345b:	c1 e0 02             	shl    $0x2,%eax
  80345e:	01 d0                	add    %edx,%eax
  803460:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803467:	01 d0                	add    %edx,%eax
  803469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803470:	01 d0                	add    %edx,%eax
  803472:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803479:	01 d0                	add    %edx,%eax
  80347b:	c1 e0 04             	shl    $0x4,%eax
  80347e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  803481:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803488:	0f 31                	rdtsc  
  80348a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80348d:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803493:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803496:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803499:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80349c:	eb 46                	jmp    8034e4 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80349e:	0f 31                	rdtsc  
  8034a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8034a3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8034a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8034af:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8034b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b8:	29 c2                	sub    %eax,%edx
  8034ba:	89 d0                	mov    %edx,%eax
  8034bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8034bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c5:	89 d1                	mov    %edx,%ecx
  8034c7:	29 c1                	sub    %eax,%ecx
  8034c9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8034cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034cf:	39 c2                	cmp    %eax,%edx
  8034d1:	0f 97 c0             	seta   %al
  8034d4:	0f b6 c0             	movzbl %al,%eax
  8034d7:	29 c1                	sub    %eax,%ecx
  8034d9:	89 c8                	mov    %ecx,%eax
  8034db:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8034de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8034e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034e7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8034ea:	72 b2                	jb     80349e <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8034ec:	90                   	nop
  8034ed:	c9                   	leave  
  8034ee:	c3                   	ret    

008034ef <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8034ef:	55                   	push   %ebp
  8034f0:	89 e5                	mov    %esp,%ebp
  8034f2:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8034f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8034fc:	eb 03                	jmp    803501 <busy_wait+0x12>
  8034fe:	ff 45 fc             	incl   -0x4(%ebp)
  803501:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803504:	3b 45 08             	cmp    0x8(%ebp),%eax
  803507:	72 f5                	jb     8034fe <busy_wait+0xf>
	return i;
  803509:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80350c:	c9                   	leave  
  80350d:	c3                   	ret    

0080350e <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  80350e:	55                   	push   %ebp
  80350f:	89 e5                	mov    %esp,%ebp
  803511:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  803514:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803518:	74 1c                	je     803536 <init_uspinlock+0x28>
  80351a:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  80351e:	74 16                	je     803536 <init_uspinlock+0x28>
  803520:	68 94 47 80 00       	push   $0x804794
  803525:	68 b3 47 80 00       	push   $0x8047b3
  80352a:	6a 10                	push   $0x10
  80352c:	68 c8 47 80 00       	push   $0x8047c8
  803531:	e8 e0 00 00 00       	call   803616 <_panic>
	strcpy(lk->name, name);
  803536:	8b 45 08             	mov    0x8(%ebp),%eax
  803539:	83 c0 04             	add    $0x4,%eax
  80353c:	83 ec 08             	sub    $0x8,%esp
  80353f:	ff 75 0c             	pushl  0xc(%ebp)
  803542:	50                   	push   %eax
  803543:	e8 04 d7 ff ff       	call   800c4c <strcpy>
  803548:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  80354b:	b8 01 00 00 00       	mov    $0x1,%eax
  803550:	2b 45 10             	sub    0x10(%ebp),%eax
  803553:	89 c2                	mov    %eax,%edx
  803555:	8b 45 08             	mov    0x8(%ebp),%eax
  803558:	89 10                	mov    %edx,(%eax)
}
  80355a:	90                   	nop
  80355b:	c9                   	leave  
  80355c:	c3                   	ret    

0080355d <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  80355d:	55                   	push   %ebp
  80355e:	89 e5                	mov    %esp,%ebp
  803560:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  803563:	90                   	nop
  803564:	8b 45 08             	mov    0x8(%ebp),%eax
  803567:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80356a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803571:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803577:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80357a:	f0 87 02             	lock xchg %eax,(%edx)
  80357d:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  803580:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803583:	85 c0                	test   %eax,%eax
  803585:	75 dd                	jne    803564 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	8d 48 04             	lea    0x4(%eax),%ecx
  80358d:	a1 20 50 80 00       	mov    0x805020,%eax
  803592:	8d 50 20             	lea    0x20(%eax),%edx
  803595:	a1 20 50 80 00       	mov    0x805020,%eax
  80359a:	8b 40 10             	mov    0x10(%eax),%eax
  80359d:	51                   	push   %ecx
  80359e:	52                   	push   %edx
  80359f:	50                   	push   %eax
  8035a0:	68 d8 47 80 00       	push   $0x8047d8
  8035a5:	e8 7a cf ff ff       	call   800524 <cprintf>
  8035aa:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  8035ad:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  8035b2:	90                   	nop
  8035b3:	c9                   	leave  
  8035b4:	c3                   	ret    

008035b5 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  8035b5:	55                   	push   %ebp
  8035b6:	89 e5                	mov    %esp,%ebp
  8035b8:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  8035bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035be:	8b 00                	mov    (%eax),%eax
  8035c0:	85 c0                	test   %eax,%eax
  8035c2:	75 18                	jne    8035dc <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  8035c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c7:	83 c0 04             	add    $0x4,%eax
  8035ca:	50                   	push   %eax
  8035cb:	68 fc 47 80 00       	push   $0x8047fc
  8035d0:	6a 2b                	push   $0x2b
  8035d2:	68 c8 47 80 00       	push   $0x8047c8
  8035d7:	e8 3a 00 00 00       	call   803616 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  8035dc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  8035e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8035ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f0:	8d 48 04             	lea    0x4(%eax),%ecx
  8035f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8035f8:	8d 50 20             	lea    0x20(%eax),%edx
  8035fb:	a1 20 50 80 00       	mov    0x805020,%eax
  803600:	8b 40 10             	mov    0x10(%eax),%eax
  803603:	51                   	push   %ecx
  803604:	52                   	push   %edx
  803605:	50                   	push   %eax
  803606:	68 1c 48 80 00       	push   $0x80481c
  80360b:	e8 14 cf ff ff       	call   800524 <cprintf>
  803610:	83 c4 10             	add    $0x10,%esp
}
  803613:	90                   	nop
  803614:	c9                   	leave  
  803615:	c3                   	ret    

00803616 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803616:	55                   	push   %ebp
  803617:	89 e5                	mov    %esp,%ebp
  803619:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80361c:	8d 45 10             	lea    0x10(%ebp),%eax
  80361f:	83 c0 04             	add    $0x4,%eax
  803622:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803625:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  80362a:	85 c0                	test   %eax,%eax
  80362c:	74 16                	je     803644 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80362e:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  803633:	83 ec 08             	sub    $0x8,%esp
  803636:	50                   	push   %eax
  803637:	68 40 48 80 00       	push   $0x804840
  80363c:	e8 e3 ce ff ff       	call   800524 <cprintf>
  803641:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803644:	a1 04 50 80 00       	mov    0x805004,%eax
  803649:	83 ec 0c             	sub    $0xc,%esp
  80364c:	ff 75 0c             	pushl  0xc(%ebp)
  80364f:	ff 75 08             	pushl  0x8(%ebp)
  803652:	50                   	push   %eax
  803653:	68 48 48 80 00       	push   $0x804848
  803658:	6a 74                	push   $0x74
  80365a:	e8 f2 ce ff ff       	call   800551 <cprintf_colored>
  80365f:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803662:	8b 45 10             	mov    0x10(%ebp),%eax
  803665:	83 ec 08             	sub    $0x8,%esp
  803668:	ff 75 f4             	pushl  -0xc(%ebp)
  80366b:	50                   	push   %eax
  80366c:	e8 44 ce ff ff       	call   8004b5 <vcprintf>
  803671:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803674:	83 ec 08             	sub    $0x8,%esp
  803677:	6a 00                	push   $0x0
  803679:	68 70 48 80 00       	push   $0x804870
  80367e:	e8 32 ce ff ff       	call   8004b5 <vcprintf>
  803683:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803686:	e8 ab cd ff ff       	call   800436 <exit>

	// should not return here
	while (1) ;
  80368b:	eb fe                	jmp    80368b <_panic+0x75>

0080368d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80368d:	55                   	push   %ebp
  80368e:	89 e5                	mov    %esp,%ebp
  803690:	53                   	push   %ebx
  803691:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803694:	a1 20 50 80 00       	mov    0x805020,%eax
  803699:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80369f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036a2:	39 c2                	cmp    %eax,%edx
  8036a4:	74 14                	je     8036ba <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8036a6:	83 ec 04             	sub    $0x4,%esp
  8036a9:	68 74 48 80 00       	push   $0x804874
  8036ae:	6a 26                	push   $0x26
  8036b0:	68 c0 48 80 00       	push   $0x8048c0
  8036b5:	e8 5c ff ff ff       	call   803616 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8036ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8036c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8036c8:	e9 d9 00 00 00       	jmp    8037a6 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8036cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036da:	01 d0                	add    %edx,%eax
  8036dc:	8b 00                	mov    (%eax),%eax
  8036de:	85 c0                	test   %eax,%eax
  8036e0:	75 08                	jne    8036ea <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8036e2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8036e5:	e9 b9 00 00 00       	jmp    8037a3 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8036ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8036f8:	eb 79                	jmp    803773 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8036fa:	a1 20 50 80 00       	mov    0x805020,%eax
  8036ff:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803705:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803708:	89 d0                	mov    %edx,%eax
  80370a:	01 c0                	add    %eax,%eax
  80370c:	01 d0                	add    %edx,%eax
  80370e:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803715:	01 d8                	add    %ebx,%eax
  803717:	01 d0                	add    %edx,%eax
  803719:	01 c8                	add    %ecx,%eax
  80371b:	8a 40 04             	mov    0x4(%eax),%al
  80371e:	84 c0                	test   %al,%al
  803720:	75 4e                	jne    803770 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803722:	a1 20 50 80 00       	mov    0x805020,%eax
  803727:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80372d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803730:	89 d0                	mov    %edx,%eax
  803732:	01 c0                	add    %eax,%eax
  803734:	01 d0                	add    %edx,%eax
  803736:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80373d:	01 d8                	add    %ebx,%eax
  80373f:	01 d0                	add    %edx,%eax
  803741:	01 c8                	add    %ecx,%eax
  803743:	8b 00                	mov    (%eax),%eax
  803745:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803748:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80374b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803750:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803755:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80375c:	8b 45 08             	mov    0x8(%ebp),%eax
  80375f:	01 c8                	add    %ecx,%eax
  803761:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803763:	39 c2                	cmp    %eax,%edx
  803765:	75 09                	jne    803770 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  803767:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80376e:	eb 19                	jmp    803789 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803770:	ff 45 e8             	incl   -0x18(%ebp)
  803773:	a1 20 50 80 00       	mov    0x805020,%eax
  803778:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80377e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803781:	39 c2                	cmp    %eax,%edx
  803783:	0f 87 71 ff ff ff    	ja     8036fa <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803789:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80378d:	75 14                	jne    8037a3 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80378f:	83 ec 04             	sub    $0x4,%esp
  803792:	68 cc 48 80 00       	push   $0x8048cc
  803797:	6a 3a                	push   $0x3a
  803799:	68 c0 48 80 00       	push   $0x8048c0
  80379e:	e8 73 fe ff ff       	call   803616 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8037a3:	ff 45 f0             	incl   -0x10(%ebp)
  8037a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8037ac:	0f 8c 1b ff ff ff    	jl     8036cd <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8037b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8037c0:	eb 2e                	jmp    8037f0 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8037c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8037c7:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8037cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037d0:	89 d0                	mov    %edx,%eax
  8037d2:	01 c0                	add    %eax,%eax
  8037d4:	01 d0                	add    %edx,%eax
  8037d6:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8037dd:	01 d8                	add    %ebx,%eax
  8037df:	01 d0                	add    %edx,%eax
  8037e1:	01 c8                	add    %ecx,%eax
  8037e3:	8a 40 04             	mov    0x4(%eax),%al
  8037e6:	3c 01                	cmp    $0x1,%al
  8037e8:	75 03                	jne    8037ed <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8037ea:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037ed:	ff 45 e0             	incl   -0x20(%ebp)
  8037f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8037f5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8037fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037fe:	39 c2                	cmp    %eax,%edx
  803800:	77 c0                	ja     8037c2 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803805:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803808:	74 14                	je     80381e <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  80380a:	83 ec 04             	sub    $0x4,%esp
  80380d:	68 20 49 80 00       	push   $0x804920
  803812:	6a 44                	push   $0x44
  803814:	68 c0 48 80 00       	push   $0x8048c0
  803819:	e8 f8 fd ff ff       	call   803616 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80381e:	90                   	nop
  80381f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803822:	c9                   	leave  
  803823:	c3                   	ret    

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
