
obj/user/ef_tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 eb 01 00 00       	call   800221 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int envID = sys_getenvid();
  80003e:	e8 30 18 00 00       	call   801873 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct semaphore cs1 = create_semaphore("cs1", 1);
  800046:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 01                	push   $0x1
  80004e:	68 40 1e 80 00       	push   $0x801e40
  800053:	50                   	push   %eax
  800054:	e8 f6 1a 00 00       	call   801b4f <create_semaphore>
  800059:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80005c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 00                	push   $0x0
  800064:	68 44 1e 80 00       	push   $0x801e44
  800069:	50                   	push   %eax
  80006a:	e8 e0 1a 00 00       	call   801b4f <create_semaphore>
  80006f:	83 c4 0c             	add    $0xc,%esp

	int id1, id2, id3;
	id1 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800072:	a1 20 30 80 00       	mov    0x803020,%eax
  800077:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  80007d:	89 c2                	mov    %eax,%edx
  80007f:	a1 20 30 80 00       	mov    0x803020,%eax
  800084:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80008a:	6a 32                	push   $0x32
  80008c:	52                   	push   %edx
  80008d:	50                   	push   %eax
  80008e:	68 4c 1e 80 00       	push   $0x801e4c
  800093:	e8 86 17 00 00       	call   80181e <sys_create_env>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80009e:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a3:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8000a9:	89 c2                	mov    %eax,%edx
  8000ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b0:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000b6:	6a 32                	push   $0x32
  8000b8:	52                   	push   %edx
  8000b9:	50                   	push   %eax
  8000ba:	68 4c 1e 80 00       	push   $0x801e4c
  8000bf:	e8 5a 17 00 00       	call   80181e <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8000cf:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8000d5:	89 c2                	mov    %eax,%edx
  8000d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000dc:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e2:	6a 32                	push   $0x32
  8000e4:	52                   	push   %edx
  8000e5:	50                   	push   %eax
  8000e6:	68 4c 1e 80 00       	push   $0x801e4c
  8000eb:	e8 2e 17 00 00       	call   80181e <sys_create_env>
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR || id3 == E_ENV_CREATION_ERROR)
  8000f6:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000fa:	74 0c                	je     800108 <_main+0xd0>
  8000fc:	83 7d ec ef          	cmpl   $0xffffffef,-0x14(%ebp)
  800100:	74 06                	je     800108 <_main+0xd0>
  800102:	83 7d e8 ef          	cmpl   $0xffffffef,-0x18(%ebp)
  800106:	75 14                	jne    80011c <_main+0xe4>
		panic("NO AVAILABLE ENVs...");
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	68 59 1e 80 00       	push   $0x801e59
  800110:	6a 12                	push   $0x12
  800112:	68 70 1e 80 00       	push   $0x801e70
  800117:	e8 b5 02 00 00       	call   8003d1 <_panic>

	sys_run_env(id1);
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	ff 75 f0             	pushl  -0x10(%ebp)
  800122:	e8 15 17 00 00       	call   80183c <sys_run_env>
  800127:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80012a:	83 ec 0c             	sub    $0xc,%esp
  80012d:	ff 75 ec             	pushl  -0x14(%ebp)
  800130:	e8 07 17 00 00       	call   80183c <sys_run_env>
  800135:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800138:	83 ec 0c             	sub    $0xc,%esp
  80013b:	ff 75 e8             	pushl  -0x18(%ebp)
  80013e:	e8 f9 16 00 00       	call   80183c <sys_run_env>
  800143:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(depend1) ;
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 d4             	pushl  -0x2c(%ebp)
  80014c:	e8 32 1a 00 00       	call   801b83 <wait_semaphore>
  800151:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1) ;
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015a:	e8 24 1a 00 00       	call   801b83 <wait_semaphore>
  80015f:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1) ;
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	ff 75 d4             	pushl  -0x2c(%ebp)
  800168:	e8 16 1a 00 00       	call   801b83 <wait_semaphore>
  80016d:	83 c4 10             	add    $0x10,%esp

	int sem1val = semaphore_count(cs1);
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	ff 75 d8             	pushl  -0x28(%ebp)
  800176:	e8 3c 1a 00 00       	call   801bb7 <semaphore_count>
  80017b:	83 c4 10             	add    $0x10,%esp
  80017e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = semaphore_count(depend1);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	ff 75 d4             	pushl  -0x2c(%ebp)
  800187:	e8 2b 1a 00 00       	call   801bb7 <semaphore_count>
  80018c:	83 c4 10             	add    $0x10,%esp
  80018f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  800192:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800196:	75 18                	jne    8001b0 <_main+0x178>
  800198:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  80019c:	75 12                	jne    8001b0 <_main+0x178>
		cprintf("Test of Semaphores is finished!!\n\n\n");
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	68 90 1e 80 00       	push   $0x801e90
  8001a6:	e8 14 05 00 00       	call   8006bf <cprintf>
  8001ab:	83 c4 10             	add    $0x10,%esp
  8001ae:	eb 10                	jmp    8001c0 <_main+0x188>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b0:	83 ec 0c             	sub    $0xc,%esp
  8001b3:	68 b4 1e 80 00       	push   $0x801eb4
  8001b8:	e8 02 05 00 00       	call   8006bf <cprintf>
  8001bd:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c0:	e8 e0 16 00 00       	call   8018a5 <sys_getparentenvid>
  8001c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  8001c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001cc:	7e 50                	jle    80021e <_main+0x1e6>
	{
		sys_destroy_env(id1);
  8001ce:	83 ec 0c             	sub    $0xc,%esp
  8001d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8001d4:	e8 7f 16 00 00       	call   801858 <sys_destroy_env>
  8001d9:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e2:	e8 71 16 00 00       	call   801858 <sys_destroy_env>
  8001e7:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f0:	e8 63 16 00 00       	call   801858 <sys_destroy_env>
  8001f5:	83 c4 10             	add    $0x10,%esp
		struct semaphore depend0 = get_semaphore(parentenvID, "depend0");
  8001f8:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8001fb:	83 ec 04             	sub    $0x4,%esp
  8001fe:	68 ff 1e 80 00       	push   $0x801eff
  800203:	ff 75 dc             	pushl  -0x24(%ebp)
  800206:	50                   	push   %eax
  800207:	e8 5d 19 00 00       	call   801b69 <get_semaphore>
  80020c:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(depend0);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 d0             	pushl  -0x30(%ebp)
  800215:	e8 83 19 00 00       	call   801b9d <signal_semaphore>
  80021a:	83 c4 10             	add    $0x10,%esp
//		int *finishedCount = NULL;
//		finishedCount = sget(parentenvID, "finishedCount") ;
//		(*finishedCount)++ ;
	}

	return;
  80021d:	90                   	nop
  80021e:	90                   	nop
}
  80021f:	c9                   	leave  
  800220:	c3                   	ret    

00800221 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	57                   	push   %edi
  800225:	56                   	push   %esi
  800226:	53                   	push   %ebx
  800227:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80022a:	e8 5d 16 00 00       	call   80188c <sys_getenvindex>
  80022f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	01 c0                	add    %eax,%eax
  800239:	01 d0                	add    %edx,%eax
  80023b:	c1 e0 02             	shl    $0x2,%eax
  80023e:	01 d0                	add    %edx,%eax
  800240:	c1 e0 02             	shl    $0x2,%eax
  800243:	01 d0                	add    %edx,%eax
  800245:	c1 e0 03             	shl    $0x3,%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	c1 e0 02             	shl    $0x2,%eax
  80024d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800252:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800257:	a1 20 30 80 00       	mov    0x803020,%eax
  80025c:	8a 40 20             	mov    0x20(%eax),%al
  80025f:	84 c0                	test   %al,%al
  800261:	74 0d                	je     800270 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800263:	a1 20 30 80 00       	mov    0x803020,%eax
  800268:	83 c0 20             	add    $0x20,%eax
  80026b:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800270:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800274:	7e 0a                	jle    800280 <libmain+0x5f>
		binaryname = argv[0];
  800276:	8b 45 0c             	mov    0xc(%ebp),%eax
  800279:	8b 00                	mov    (%eax),%eax
  80027b:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800280:	83 ec 08             	sub    $0x8,%esp
  800283:	ff 75 0c             	pushl  0xc(%ebp)
  800286:	ff 75 08             	pushl  0x8(%ebp)
  800289:	e8 aa fd ff ff       	call   800038 <_main>
  80028e:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800291:	a1 00 30 80 00       	mov    0x803000,%eax
  800296:	85 c0                	test   %eax,%eax
  800298:	0f 84 01 01 00 00    	je     80039f <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80029e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002a4:	bb 00 20 80 00       	mov    $0x802000,%ebx
  8002a9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002ae:	89 c7                	mov    %eax,%edi
  8002b0:	89 de                	mov    %ebx,%esi
  8002b2:	89 d1                	mov    %edx,%ecx
  8002b4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002b6:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002b9:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002be:	b0 00                	mov    $0x0,%al
  8002c0:	89 d7                	mov    %edx,%edi
  8002c2:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8002cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002ce:	83 ec 08             	sub    $0x8,%esp
  8002d1:	50                   	push   %eax
  8002d2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002d8:	50                   	push   %eax
  8002d9:	e8 e4 17 00 00       	call   801ac2 <sys_utilities>
  8002de:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8002e1:	e8 2d 13 00 00       	call   801613 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8002e6:	83 ec 0c             	sub    $0xc,%esp
  8002e9:	68 20 1f 80 00       	push   $0x801f20
  8002ee:	e8 cc 03 00 00       	call   8006bf <cprintf>
  8002f3:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8002f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f9:	85 c0                	test   %eax,%eax
  8002fb:	74 18                	je     800315 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8002fd:	e8 de 17 00 00       	call   801ae0 <sys_get_optimal_num_faults>
  800302:	83 ec 08             	sub    $0x8,%esp
  800305:	50                   	push   %eax
  800306:	68 48 1f 80 00       	push   $0x801f48
  80030b:	e8 af 03 00 00       	call   8006bf <cprintf>
  800310:	83 c4 10             	add    $0x10,%esp
  800313:	eb 59                	jmp    80036e <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800315:	a1 20 30 80 00       	mov    0x803020,%eax
  80031a:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800320:	a1 20 30 80 00       	mov    0x803020,%eax
  800325:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80032b:	83 ec 04             	sub    $0x4,%esp
  80032e:	52                   	push   %edx
  80032f:	50                   	push   %eax
  800330:	68 6c 1f 80 00       	push   $0x801f6c
  800335:	e8 85 03 00 00       	call   8006bf <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80033d:	a1 20 30 80 00       	mov    0x803020,%eax
  800342:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800348:	a1 20 30 80 00       	mov    0x803020,%eax
  80034d:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800353:	a1 20 30 80 00       	mov    0x803020,%eax
  800358:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80035e:	51                   	push   %ecx
  80035f:	52                   	push   %edx
  800360:	50                   	push   %eax
  800361:	68 94 1f 80 00       	push   $0x801f94
  800366:	e8 54 03 00 00       	call   8006bf <cprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80036e:	a1 20 30 80 00       	mov    0x803020,%eax
  800373:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800379:	83 ec 08             	sub    $0x8,%esp
  80037c:	50                   	push   %eax
  80037d:	68 ec 1f 80 00       	push   $0x801fec
  800382:	e8 38 03 00 00       	call   8006bf <cprintf>
  800387:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80038a:	83 ec 0c             	sub    $0xc,%esp
  80038d:	68 20 1f 80 00       	push   $0x801f20
  800392:	e8 28 03 00 00       	call   8006bf <cprintf>
  800397:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80039a:	e8 8e 12 00 00       	call   80162d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80039f:	e8 1f 00 00 00       	call   8003c3 <exit>
}
  8003a4:	90                   	nop
  8003a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003a8:	5b                   	pop    %ebx
  8003a9:	5e                   	pop    %esi
  8003aa:	5f                   	pop    %edi
  8003ab:	5d                   	pop    %ebp
  8003ac:	c3                   	ret    

008003ad <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	6a 00                	push   $0x0
  8003b8:	e8 9b 14 00 00       	call   801858 <sys_destroy_env>
  8003bd:	83 c4 10             	add    $0x10,%esp
}
  8003c0:	90                   	nop
  8003c1:	c9                   	leave  
  8003c2:	c3                   	ret    

008003c3 <exit>:

void
exit(void)
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003c9:	e8 f0 14 00 00       	call   8018be <sys_exit_env>
}
  8003ce:	90                   	nop
  8003cf:	c9                   	leave  
  8003d0:	c3                   	ret    

008003d1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
  8003d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8003da:	83 c0 04             	add    $0x4,%eax
  8003dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003e0:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003e5:	85 c0                	test   %eax,%eax
  8003e7:	74 16                	je     8003ff <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003e9:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003ee:	83 ec 08             	sub    $0x8,%esp
  8003f1:	50                   	push   %eax
  8003f2:	68 64 20 80 00       	push   $0x802064
  8003f7:	e8 c3 02 00 00       	call   8006bf <cprintf>
  8003fc:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8003ff:	a1 04 30 80 00       	mov    0x803004,%eax
  800404:	83 ec 0c             	sub    $0xc,%esp
  800407:	ff 75 0c             	pushl  0xc(%ebp)
  80040a:	ff 75 08             	pushl  0x8(%ebp)
  80040d:	50                   	push   %eax
  80040e:	68 6c 20 80 00       	push   $0x80206c
  800413:	6a 74                	push   $0x74
  800415:	e8 d2 02 00 00       	call   8006ec <cprintf_colored>
  80041a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80041d:	8b 45 10             	mov    0x10(%ebp),%eax
  800420:	83 ec 08             	sub    $0x8,%esp
  800423:	ff 75 f4             	pushl  -0xc(%ebp)
  800426:	50                   	push   %eax
  800427:	e8 24 02 00 00       	call   800650 <vcprintf>
  80042c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80042f:	83 ec 08             	sub    $0x8,%esp
  800432:	6a 00                	push   $0x0
  800434:	68 94 20 80 00       	push   $0x802094
  800439:	e8 12 02 00 00       	call   800650 <vcprintf>
  80043e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800441:	e8 7d ff ff ff       	call   8003c3 <exit>

	// should not return here
	while (1) ;
  800446:	eb fe                	jmp    800446 <_panic+0x75>

00800448 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	53                   	push   %ebx
  80044c:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80044f:	a1 20 30 80 00       	mov    0x803020,%eax
  800454:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80045a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045d:	39 c2                	cmp    %eax,%edx
  80045f:	74 14                	je     800475 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800461:	83 ec 04             	sub    $0x4,%esp
  800464:	68 98 20 80 00       	push   $0x802098
  800469:	6a 26                	push   $0x26
  80046b:	68 e4 20 80 00       	push   $0x8020e4
  800470:	e8 5c ff ff ff       	call   8003d1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800475:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80047c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800483:	e9 d9 00 00 00       	jmp    800561 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	01 d0                	add    %edx,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	85 c0                	test   %eax,%eax
  80049b:	75 08                	jne    8004a5 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80049d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004a0:	e9 b9 00 00 00       	jmp    80055e <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8004a5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004b3:	eb 79                	jmp    80052e <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ba:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8004c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004c3:	89 d0                	mov    %edx,%eax
  8004c5:	01 c0                	add    %eax,%eax
  8004c7:	01 d0                	add    %edx,%eax
  8004c9:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004d0:	01 d8                	add    %ebx,%eax
  8004d2:	01 d0                	add    %edx,%eax
  8004d4:	01 c8                	add    %ecx,%eax
  8004d6:	8a 40 04             	mov    0x4(%eax),%al
  8004d9:	84 c0                	test   %al,%al
  8004db:	75 4e                	jne    80052b <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e2:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8004e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004eb:	89 d0                	mov    %edx,%eax
  8004ed:	01 c0                	add    %eax,%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004f8:	01 d8                	add    %ebx,%eax
  8004fa:	01 d0                	add    %edx,%eax
  8004fc:	01 c8                	add    %ecx,%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800503:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800506:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80050b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80050d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800510:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800517:	8b 45 08             	mov    0x8(%ebp),%eax
  80051a:	01 c8                	add    %ecx,%eax
  80051c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80051e:	39 c2                	cmp    %eax,%edx
  800520:	75 09                	jne    80052b <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800522:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800529:	eb 19                	jmp    800544 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052b:	ff 45 e8             	incl   -0x18(%ebp)
  80052e:	a1 20 30 80 00       	mov    0x803020,%eax
  800533:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800539:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80053c:	39 c2                	cmp    %eax,%edx
  80053e:	0f 87 71 ff ff ff    	ja     8004b5 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800544:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800548:	75 14                	jne    80055e <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80054a:	83 ec 04             	sub    $0x4,%esp
  80054d:	68 f0 20 80 00       	push   $0x8020f0
  800552:	6a 3a                	push   $0x3a
  800554:	68 e4 20 80 00       	push   $0x8020e4
  800559:	e8 73 fe ff ff       	call   8003d1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80055e:	ff 45 f0             	incl   -0x10(%ebp)
  800561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800564:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800567:	0f 8c 1b ff ff ff    	jl     800488 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80056d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800574:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80057b:	eb 2e                	jmp    8005ab <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80057d:	a1 20 30 80 00       	mov    0x803020,%eax
  800582:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800588:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058b:	89 d0                	mov    %edx,%eax
  80058d:	01 c0                	add    %eax,%eax
  80058f:	01 d0                	add    %edx,%eax
  800591:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800598:	01 d8                	add    %ebx,%eax
  80059a:	01 d0                	add    %edx,%eax
  80059c:	01 c8                	add    %ecx,%eax
  80059e:	8a 40 04             	mov    0x4(%eax),%al
  8005a1:	3c 01                	cmp    $0x1,%al
  8005a3:	75 03                	jne    8005a8 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8005a5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a8:	ff 45 e0             	incl   -0x20(%ebp)
  8005ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b9:	39 c2                	cmp    %eax,%edx
  8005bb:	77 c0                	ja     80057d <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005c0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c3:	74 14                	je     8005d9 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8005c5:	83 ec 04             	sub    $0x4,%esp
  8005c8:	68 44 21 80 00       	push   $0x802144
  8005cd:	6a 44                	push   $0x44
  8005cf:	68 e4 20 80 00       	push   $0x8020e4
  8005d4:	e8 f8 fd ff ff       	call   8003d1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d9:	90                   	nop
  8005da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	53                   	push   %ebx
  8005e3:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e9:	8b 00                	mov    (%eax),%eax
  8005eb:	8d 48 01             	lea    0x1(%eax),%ecx
  8005ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f1:	89 0a                	mov    %ecx,(%edx)
  8005f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8005f6:	88 d1                	mov    %dl,%cl
  8005f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005fb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	3d ff 00 00 00       	cmp    $0xff,%eax
  800609:	75 30                	jne    80063b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80060b:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800611:	a0 44 30 80 00       	mov    0x803044,%al
  800616:	0f b6 c0             	movzbl %al,%eax
  800619:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80061c:	8b 09                	mov    (%ecx),%ecx
  80061e:	89 cb                	mov    %ecx,%ebx
  800620:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800623:	83 c1 08             	add    $0x8,%ecx
  800626:	52                   	push   %edx
  800627:	50                   	push   %eax
  800628:	53                   	push   %ebx
  800629:	51                   	push   %ecx
  80062a:	e8 a0 0f 00 00       	call   8015cf <sys_cputs>
  80062f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800632:	8b 45 0c             	mov    0xc(%ebp),%eax
  800635:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80063b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063e:	8b 40 04             	mov    0x4(%eax),%eax
  800641:	8d 50 01             	lea    0x1(%eax),%edx
  800644:	8b 45 0c             	mov    0xc(%ebp),%eax
  800647:	89 50 04             	mov    %edx,0x4(%eax)
}
  80064a:	90                   	nop
  80064b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80064e:	c9                   	leave  
  80064f:	c3                   	ret    

00800650 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800650:	55                   	push   %ebp
  800651:	89 e5                	mov    %esp,%ebp
  800653:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800659:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800660:	00 00 00 
	b.cnt = 0;
  800663:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80066a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80066d:	ff 75 0c             	pushl  0xc(%ebp)
  800670:	ff 75 08             	pushl  0x8(%ebp)
  800673:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800679:	50                   	push   %eax
  80067a:	68 df 05 80 00       	push   $0x8005df
  80067f:	e8 5a 02 00 00       	call   8008de <vprintfmt>
  800684:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800687:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80068d:	a0 44 30 80 00       	mov    0x803044,%al
  800692:	0f b6 c0             	movzbl %al,%eax
  800695:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80069b:	52                   	push   %edx
  80069c:	50                   	push   %eax
  80069d:	51                   	push   %ecx
  80069e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006a4:	83 c0 08             	add    $0x8,%eax
  8006a7:	50                   	push   %eax
  8006a8:	e8 22 0f 00 00       	call   8015cf <sys_cputs>
  8006ad:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006b0:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8006b7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006bd:	c9                   	leave  
  8006be:	c3                   	ret    

008006bf <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006c5:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8006cc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006db:	50                   	push   %eax
  8006dc:	e8 6f ff ff ff       	call   800650 <vcprintf>
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ea:	c9                   	leave  
  8006eb:	c3                   	ret    

008006ec <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
  8006ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006f2:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	c1 e0 08             	shl    $0x8,%eax
  8006ff:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800704:	8d 45 0c             	lea    0xc(%ebp),%eax
  800707:	83 c0 04             	add    $0x4,%eax
  80070a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80070d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	ff 75 f4             	pushl  -0xc(%ebp)
  800716:	50                   	push   %eax
  800717:	e8 34 ff ff ff       	call   800650 <vcprintf>
  80071c:	83 c4 10             	add    $0x10,%esp
  80071f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800722:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800729:	07 00 00 

	return cnt;
  80072c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80072f:	c9                   	leave  
  800730:	c3                   	ret    

00800731 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800731:	55                   	push   %ebp
  800732:	89 e5                	mov    %esp,%ebp
  800734:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800737:	e8 d7 0e 00 00       	call   801613 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80073c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80073f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	ff 75 f4             	pushl  -0xc(%ebp)
  80074b:	50                   	push   %eax
  80074c:	e8 ff fe ff ff       	call   800650 <vcprintf>
  800751:	83 c4 10             	add    $0x10,%esp
  800754:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800757:	e8 d1 0e 00 00       	call   80162d <sys_unlock_cons>
	return cnt;
  80075c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80075f:	c9                   	leave  
  800760:	c3                   	ret    

00800761 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	53                   	push   %ebx
  800765:	83 ec 14             	sub    $0x14,%esp
  800768:	8b 45 10             	mov    0x10(%ebp),%eax
  80076b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800774:	8b 45 18             	mov    0x18(%ebp),%eax
  800777:	ba 00 00 00 00       	mov    $0x0,%edx
  80077c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80077f:	77 55                	ja     8007d6 <printnum+0x75>
  800781:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800784:	72 05                	jb     80078b <printnum+0x2a>
  800786:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800789:	77 4b                	ja     8007d6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80078b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80078e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800791:	8b 45 18             	mov    0x18(%ebp),%eax
  800794:	ba 00 00 00 00       	mov    $0x0,%edx
  800799:	52                   	push   %edx
  80079a:	50                   	push   %eax
  80079b:	ff 75 f4             	pushl  -0xc(%ebp)
  80079e:	ff 75 f0             	pushl  -0x10(%ebp)
  8007a1:	e8 1e 14 00 00       	call   801bc4 <__udivdi3>
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	83 ec 04             	sub    $0x4,%esp
  8007ac:	ff 75 20             	pushl  0x20(%ebp)
  8007af:	53                   	push   %ebx
  8007b0:	ff 75 18             	pushl  0x18(%ebp)
  8007b3:	52                   	push   %edx
  8007b4:	50                   	push   %eax
  8007b5:	ff 75 0c             	pushl  0xc(%ebp)
  8007b8:	ff 75 08             	pushl  0x8(%ebp)
  8007bb:	e8 a1 ff ff ff       	call   800761 <printnum>
  8007c0:	83 c4 20             	add    $0x20,%esp
  8007c3:	eb 1a                	jmp    8007df <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	ff 75 0c             	pushl  0xc(%ebp)
  8007cb:	ff 75 20             	pushl  0x20(%ebp)
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	ff d0                	call   *%eax
  8007d3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007d6:	ff 4d 1c             	decl   0x1c(%ebp)
  8007d9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007dd:	7f e6                	jg     8007c5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007df:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ed:	53                   	push   %ebx
  8007ee:	51                   	push   %ecx
  8007ef:	52                   	push   %edx
  8007f0:	50                   	push   %eax
  8007f1:	e8 de 14 00 00       	call   801cd4 <__umoddi3>
  8007f6:	83 c4 10             	add    $0x10,%esp
  8007f9:	05 b4 23 80 00       	add    $0x8023b4,%eax
  8007fe:	8a 00                	mov    (%eax),%al
  800800:	0f be c0             	movsbl %al,%eax
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	ff 75 0c             	pushl  0xc(%ebp)
  800809:	50                   	push   %eax
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	ff d0                	call   *%eax
  80080f:	83 c4 10             	add    $0x10,%esp
}
  800812:	90                   	nop
  800813:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800816:	c9                   	leave  
  800817:	c3                   	ret    

00800818 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80081b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80081f:	7e 1c                	jle    80083d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800821:	8b 45 08             	mov    0x8(%ebp),%eax
  800824:	8b 00                	mov    (%eax),%eax
  800826:	8d 50 08             	lea    0x8(%eax),%edx
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	89 10                	mov    %edx,(%eax)
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	8b 00                	mov    (%eax),%eax
  800833:	83 e8 08             	sub    $0x8,%eax
  800836:	8b 50 04             	mov    0x4(%eax),%edx
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	eb 40                	jmp    80087d <getuint+0x65>
	else if (lflag)
  80083d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800841:	74 1e                	je     800861 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	8b 00                	mov    (%eax),%eax
  800848:	8d 50 04             	lea    0x4(%eax),%edx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	89 10                	mov    %edx,(%eax)
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	83 e8 04             	sub    $0x4,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	ba 00 00 00 00       	mov    $0x0,%edx
  80085f:	eb 1c                	jmp    80087d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	8b 00                	mov    (%eax),%eax
  800866:	8d 50 04             	lea    0x4(%eax),%edx
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	89 10                	mov    %edx,(%eax)
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	8b 00                	mov    (%eax),%eax
  800873:	83 e8 04             	sub    $0x4,%eax
  800876:	8b 00                	mov    (%eax),%eax
  800878:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80087d:	5d                   	pop    %ebp
  80087e:	c3                   	ret    

0080087f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800882:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800886:	7e 1c                	jle    8008a4 <getint+0x25>
		return va_arg(*ap, long long);
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	8b 00                	mov    (%eax),%eax
  80088d:	8d 50 08             	lea    0x8(%eax),%edx
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	89 10                	mov    %edx,(%eax)
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	8b 00                	mov    (%eax),%eax
  80089a:	83 e8 08             	sub    $0x8,%eax
  80089d:	8b 50 04             	mov    0x4(%eax),%edx
  8008a0:	8b 00                	mov    (%eax),%eax
  8008a2:	eb 38                	jmp    8008dc <getint+0x5d>
	else if (lflag)
  8008a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008a8:	74 1a                	je     8008c4 <getint+0x45>
		return va_arg(*ap, long);
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8d 50 04             	lea    0x4(%eax),%edx
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	89 10                	mov    %edx,(%eax)
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	83 e8 04             	sub    $0x4,%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	99                   	cltd   
  8008c2:	eb 18                	jmp    8008dc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	8b 00                	mov    (%eax),%eax
  8008c9:	8d 50 04             	lea    0x4(%eax),%edx
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	89 10                	mov    %edx,(%eax)
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	83 e8 04             	sub    $0x4,%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	99                   	cltd   
}
  8008dc:	5d                   	pop    %ebp
  8008dd:	c3                   	ret    

008008de <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	56                   	push   %esi
  8008e2:	53                   	push   %ebx
  8008e3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e6:	eb 17                	jmp    8008ff <vprintfmt+0x21>
			if (ch == '\0')
  8008e8:	85 db                	test   %ebx,%ebx
  8008ea:	0f 84 c1 03 00 00    	je     800cb1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	53                   	push   %ebx
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800902:	8d 50 01             	lea    0x1(%eax),%edx
  800905:	89 55 10             	mov    %edx,0x10(%ebp)
  800908:	8a 00                	mov    (%eax),%al
  80090a:	0f b6 d8             	movzbl %al,%ebx
  80090d:	83 fb 25             	cmp    $0x25,%ebx
  800910:	75 d6                	jne    8008e8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800912:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800916:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80091d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800924:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80092b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800932:	8b 45 10             	mov    0x10(%ebp),%eax
  800935:	8d 50 01             	lea    0x1(%eax),%edx
  800938:	89 55 10             	mov    %edx,0x10(%ebp)
  80093b:	8a 00                	mov    (%eax),%al
  80093d:	0f b6 d8             	movzbl %al,%ebx
  800940:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800943:	83 f8 5b             	cmp    $0x5b,%eax
  800946:	0f 87 3d 03 00 00    	ja     800c89 <vprintfmt+0x3ab>
  80094c:	8b 04 85 d8 23 80 00 	mov    0x8023d8(,%eax,4),%eax
  800953:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800955:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800959:	eb d7                	jmp    800932 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80095b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80095f:	eb d1                	jmp    800932 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800961:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800968:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80096b:	89 d0                	mov    %edx,%eax
  80096d:	c1 e0 02             	shl    $0x2,%eax
  800970:	01 d0                	add    %edx,%eax
  800972:	01 c0                	add    %eax,%eax
  800974:	01 d8                	add    %ebx,%eax
  800976:	83 e8 30             	sub    $0x30,%eax
  800979:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80097c:	8b 45 10             	mov    0x10(%ebp),%eax
  80097f:	8a 00                	mov    (%eax),%al
  800981:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800984:	83 fb 2f             	cmp    $0x2f,%ebx
  800987:	7e 3e                	jle    8009c7 <vprintfmt+0xe9>
  800989:	83 fb 39             	cmp    $0x39,%ebx
  80098c:	7f 39                	jg     8009c7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80098e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800991:	eb d5                	jmp    800968 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800993:	8b 45 14             	mov    0x14(%ebp),%eax
  800996:	83 c0 04             	add    $0x4,%eax
  800999:	89 45 14             	mov    %eax,0x14(%ebp)
  80099c:	8b 45 14             	mov    0x14(%ebp),%eax
  80099f:	83 e8 04             	sub    $0x4,%eax
  8009a2:	8b 00                	mov    (%eax),%eax
  8009a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009a7:	eb 1f                	jmp    8009c8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ad:	79 83                	jns    800932 <vprintfmt+0x54>
				width = 0;
  8009af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009b6:	e9 77 ff ff ff       	jmp    800932 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009bb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009c2:	e9 6b ff ff ff       	jmp    800932 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009c7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009cc:	0f 89 60 ff ff ff    	jns    800932 <vprintfmt+0x54>
				width = precision, precision = -1;
  8009d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009d8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009df:	e9 4e ff ff ff       	jmp    800932 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009e4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009e7:	e9 46 ff ff ff       	jmp    800932 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ef:	83 c0 04             	add    $0x4,%eax
  8009f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f8:	83 e8 04             	sub    $0x4,%eax
  8009fb:	8b 00                	mov    (%eax),%eax
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	ff 75 0c             	pushl  0xc(%ebp)
  800a03:	50                   	push   %eax
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	ff d0                	call   *%eax
  800a09:	83 c4 10             	add    $0x10,%esp
			break;
  800a0c:	e9 9b 02 00 00       	jmp    800cac <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a11:	8b 45 14             	mov    0x14(%ebp),%eax
  800a14:	83 c0 04             	add    $0x4,%eax
  800a17:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1d:	83 e8 04             	sub    $0x4,%eax
  800a20:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a22:	85 db                	test   %ebx,%ebx
  800a24:	79 02                	jns    800a28 <vprintfmt+0x14a>
				err = -err;
  800a26:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a28:	83 fb 64             	cmp    $0x64,%ebx
  800a2b:	7f 0b                	jg     800a38 <vprintfmt+0x15a>
  800a2d:	8b 34 9d 20 22 80 00 	mov    0x802220(,%ebx,4),%esi
  800a34:	85 f6                	test   %esi,%esi
  800a36:	75 19                	jne    800a51 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a38:	53                   	push   %ebx
  800a39:	68 c5 23 80 00       	push   $0x8023c5
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	ff 75 08             	pushl  0x8(%ebp)
  800a44:	e8 70 02 00 00       	call   800cb9 <printfmt>
  800a49:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a4c:	e9 5b 02 00 00       	jmp    800cac <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a51:	56                   	push   %esi
  800a52:	68 ce 23 80 00       	push   $0x8023ce
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	ff 75 08             	pushl  0x8(%ebp)
  800a5d:	e8 57 02 00 00       	call   800cb9 <printfmt>
  800a62:	83 c4 10             	add    $0x10,%esp
			break;
  800a65:	e9 42 02 00 00       	jmp    800cac <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6d:	83 c0 04             	add    $0x4,%eax
  800a70:	89 45 14             	mov    %eax,0x14(%ebp)
  800a73:	8b 45 14             	mov    0x14(%ebp),%eax
  800a76:	83 e8 04             	sub    $0x4,%eax
  800a79:	8b 30                	mov    (%eax),%esi
  800a7b:	85 f6                	test   %esi,%esi
  800a7d:	75 05                	jne    800a84 <vprintfmt+0x1a6>
				p = "(null)";
  800a7f:	be d1 23 80 00       	mov    $0x8023d1,%esi
			if (width > 0 && padc != '-')
  800a84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a88:	7e 6d                	jle    800af7 <vprintfmt+0x219>
  800a8a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a8e:	74 67                	je     800af7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	50                   	push   %eax
  800a97:	56                   	push   %esi
  800a98:	e8 1e 03 00 00       	call   800dbb <strnlen>
  800a9d:	83 c4 10             	add    $0x10,%esp
  800aa0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800aa3:	eb 16                	jmp    800abb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800aa5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	50                   	push   %eax
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	ff d0                	call   *%eax
  800ab5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ab8:	ff 4d e4             	decl   -0x1c(%ebp)
  800abb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800abf:	7f e4                	jg     800aa5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ac1:	eb 34                	jmp    800af7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ac3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ac7:	74 1c                	je     800ae5 <vprintfmt+0x207>
  800ac9:	83 fb 1f             	cmp    $0x1f,%ebx
  800acc:	7e 05                	jle    800ad3 <vprintfmt+0x1f5>
  800ace:	83 fb 7e             	cmp    $0x7e,%ebx
  800ad1:	7e 12                	jle    800ae5 <vprintfmt+0x207>
					putch('?', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 3f                	push   $0x3f
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
  800ae3:	eb 0f                	jmp    800af4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	53                   	push   %ebx
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	ff d0                	call   *%eax
  800af1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800af4:	ff 4d e4             	decl   -0x1c(%ebp)
  800af7:	89 f0                	mov    %esi,%eax
  800af9:	8d 70 01             	lea    0x1(%eax),%esi
  800afc:	8a 00                	mov    (%eax),%al
  800afe:	0f be d8             	movsbl %al,%ebx
  800b01:	85 db                	test   %ebx,%ebx
  800b03:	74 24                	je     800b29 <vprintfmt+0x24b>
  800b05:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b09:	78 b8                	js     800ac3 <vprintfmt+0x1e5>
  800b0b:	ff 4d e0             	decl   -0x20(%ebp)
  800b0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b12:	79 af                	jns    800ac3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b14:	eb 13                	jmp    800b29 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b16:	83 ec 08             	sub    $0x8,%esp
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	6a 20                	push   $0x20
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	ff d0                	call   *%eax
  800b23:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b26:	ff 4d e4             	decl   -0x1c(%ebp)
  800b29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2d:	7f e7                	jg     800b16 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b2f:	e9 78 01 00 00       	jmp    800cac <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	ff 75 e8             	pushl  -0x18(%ebp)
  800b3a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3d:	50                   	push   %eax
  800b3e:	e8 3c fd ff ff       	call   80087f <getint>
  800b43:	83 c4 10             	add    $0x10,%esp
  800b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b49:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b52:	85 d2                	test   %edx,%edx
  800b54:	79 23                	jns    800b79 <vprintfmt+0x29b>
				putch('-', putdat);
  800b56:	83 ec 08             	sub    $0x8,%esp
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	6a 2d                	push   $0x2d
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	ff d0                	call   *%eax
  800b63:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b6c:	f7 d8                	neg    %eax
  800b6e:	83 d2 00             	adc    $0x0,%edx
  800b71:	f7 da                	neg    %edx
  800b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b76:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b79:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b80:	e9 bc 00 00 00       	jmp    800c41 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b85:	83 ec 08             	sub    $0x8,%esp
  800b88:	ff 75 e8             	pushl  -0x18(%ebp)
  800b8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b8e:	50                   	push   %eax
  800b8f:	e8 84 fc ff ff       	call   800818 <getuint>
  800b94:	83 c4 10             	add    $0x10,%esp
  800b97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b9d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ba4:	e9 98 00 00 00       	jmp    800c41 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ba9:	83 ec 08             	sub    $0x8,%esp
  800bac:	ff 75 0c             	pushl  0xc(%ebp)
  800baf:	6a 58                	push   $0x58
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	ff d0                	call   *%eax
  800bb6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bb9:	83 ec 08             	sub    $0x8,%esp
  800bbc:	ff 75 0c             	pushl  0xc(%ebp)
  800bbf:	6a 58                	push   $0x58
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	ff d0                	call   *%eax
  800bc6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bc9:	83 ec 08             	sub    $0x8,%esp
  800bcc:	ff 75 0c             	pushl  0xc(%ebp)
  800bcf:	6a 58                	push   $0x58
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	ff d0                	call   *%eax
  800bd6:	83 c4 10             	add    $0x10,%esp
			break;
  800bd9:	e9 ce 00 00 00       	jmp    800cac <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bde:	83 ec 08             	sub    $0x8,%esp
  800be1:	ff 75 0c             	pushl  0xc(%ebp)
  800be4:	6a 30                	push   $0x30
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	ff d0                	call   *%eax
  800beb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bee:	83 ec 08             	sub    $0x8,%esp
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	6a 78                	push   $0x78
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	ff d0                	call   *%eax
  800bfb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800c01:	83 c0 04             	add    $0x4,%eax
  800c04:	89 45 14             	mov    %eax,0x14(%ebp)
  800c07:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0a:	83 e8 04             	sub    $0x4,%eax
  800c0d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c19:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c20:	eb 1f                	jmp    800c41 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c22:	83 ec 08             	sub    $0x8,%esp
  800c25:	ff 75 e8             	pushl  -0x18(%ebp)
  800c28:	8d 45 14             	lea    0x14(%ebp),%eax
  800c2b:	50                   	push   %eax
  800c2c:	e8 e7 fb ff ff       	call   800818 <getuint>
  800c31:	83 c4 10             	add    $0x10,%esp
  800c34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c37:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c41:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c48:	83 ec 04             	sub    $0x4,%esp
  800c4b:	52                   	push   %edx
  800c4c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c4f:	50                   	push   %eax
  800c50:	ff 75 f4             	pushl  -0xc(%ebp)
  800c53:	ff 75 f0             	pushl  -0x10(%ebp)
  800c56:	ff 75 0c             	pushl  0xc(%ebp)
  800c59:	ff 75 08             	pushl  0x8(%ebp)
  800c5c:	e8 00 fb ff ff       	call   800761 <printnum>
  800c61:	83 c4 20             	add    $0x20,%esp
			break;
  800c64:	eb 46                	jmp    800cac <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c66:	83 ec 08             	sub    $0x8,%esp
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	53                   	push   %ebx
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	ff d0                	call   *%eax
  800c72:	83 c4 10             	add    $0x10,%esp
			break;
  800c75:	eb 35                	jmp    800cac <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c77:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800c7e:	eb 2c                	jmp    800cac <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c80:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800c87:	eb 23                	jmp    800cac <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c89:	83 ec 08             	sub    $0x8,%esp
  800c8c:	ff 75 0c             	pushl  0xc(%ebp)
  800c8f:	6a 25                	push   $0x25
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	ff d0                	call   *%eax
  800c96:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c99:	ff 4d 10             	decl   0x10(%ebp)
  800c9c:	eb 03                	jmp    800ca1 <vprintfmt+0x3c3>
  800c9e:	ff 4d 10             	decl   0x10(%ebp)
  800ca1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca4:	48                   	dec    %eax
  800ca5:	8a 00                	mov    (%eax),%al
  800ca7:	3c 25                	cmp    $0x25,%al
  800ca9:	75 f3                	jne    800c9e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cab:	90                   	nop
		}
	}
  800cac:	e9 35 fc ff ff       	jmp    8008e6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cb1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cb5:	5b                   	pop    %ebx
  800cb6:	5e                   	pop    %esi
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    

00800cb9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cbf:	8d 45 10             	lea    0x10(%ebp),%eax
  800cc2:	83 c0 04             	add    $0x4,%eax
  800cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cce:	50                   	push   %eax
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	ff 75 08             	pushl  0x8(%ebp)
  800cd5:	e8 04 fc ff ff       	call   8008de <vprintfmt>
  800cda:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cdd:	90                   	nop
  800cde:	c9                   	leave  
  800cdf:	c3                   	ret    

00800ce0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	8b 40 08             	mov    0x8(%eax),%eax
  800ce9:	8d 50 01             	lea    0x1(%eax),%edx
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf5:	8b 10                	mov    (%eax),%edx
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	8b 40 04             	mov    0x4(%eax),%eax
  800cfd:	39 c2                	cmp    %eax,%edx
  800cff:	73 12                	jae    800d13 <sprintputch+0x33>
		*b->buf++ = ch;
  800d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	8d 48 01             	lea    0x1(%eax),%ecx
  800d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0c:	89 0a                	mov    %ecx,(%edx)
  800d0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d11:	88 10                	mov    %dl,(%eax)
}
  800d13:	90                   	nop
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    

00800d16 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	01 d0                	add    %edx,%eax
  800d2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d3b:	74 06                	je     800d43 <vsnprintf+0x2d>
  800d3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d41:	7f 07                	jg     800d4a <vsnprintf+0x34>
		return -E_INVAL;
  800d43:	b8 03 00 00 00       	mov    $0x3,%eax
  800d48:	eb 20                	jmp    800d6a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d4a:	ff 75 14             	pushl  0x14(%ebp)
  800d4d:	ff 75 10             	pushl  0x10(%ebp)
  800d50:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d53:	50                   	push   %eax
  800d54:	68 e0 0c 80 00       	push   $0x800ce0
  800d59:	e8 80 fb ff ff       	call   8008de <vprintfmt>
  800d5e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d64:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d6a:	c9                   	leave  
  800d6b:	c3                   	ret    

00800d6c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d72:	8d 45 10             	lea    0x10(%ebp),%eax
  800d75:	83 c0 04             	add    $0x4,%eax
  800d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d81:	50                   	push   %eax
  800d82:	ff 75 0c             	pushl  0xc(%ebp)
  800d85:	ff 75 08             	pushl  0x8(%ebp)
  800d88:	e8 89 ff ff ff       	call   800d16 <vsnprintf>
  800d8d:	83 c4 10             	add    $0x10,%esp
  800d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d96:	c9                   	leave  
  800d97:	c3                   	ret    

00800d98 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800da5:	eb 06                	jmp    800dad <strlen+0x15>
		n++;
  800da7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800daa:	ff 45 08             	incl   0x8(%ebp)
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	8a 00                	mov    (%eax),%al
  800db2:	84 c0                	test   %al,%al
  800db4:	75 f1                	jne    800da7 <strlen+0xf>
		n++;
	return n;
  800db6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800db9:	c9                   	leave  
  800dba:	c3                   	ret    

00800dbb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc8:	eb 09                	jmp    800dd3 <strnlen+0x18>
		n++;
  800dca:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dcd:	ff 45 08             	incl   0x8(%ebp)
  800dd0:	ff 4d 0c             	decl   0xc(%ebp)
  800dd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd7:	74 09                	je     800de2 <strnlen+0x27>
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	84 c0                	test   %al,%al
  800de0:	75 e8                	jne    800dca <strnlen+0xf>
		n++;
	return n;
  800de2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de5:	c9                   	leave  
  800de6:	c3                   	ret    

00800de7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800df3:	90                   	nop
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8d 50 01             	lea    0x1(%eax),%edx
  800dfa:	89 55 08             	mov    %edx,0x8(%ebp)
  800dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e00:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e03:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e06:	8a 12                	mov    (%edx),%dl
  800e08:	88 10                	mov    %dl,(%eax)
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	84 c0                	test   %al,%al
  800e0e:	75 e4                	jne    800df4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e13:	c9                   	leave  
  800e14:	c3                   	ret    

00800e15 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e28:	eb 1f                	jmp    800e49 <strncpy+0x34>
		*dst++ = *src;
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8d 50 01             	lea    0x1(%eax),%edx
  800e30:	89 55 08             	mov    %edx,0x8(%ebp)
  800e33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e36:	8a 12                	mov    (%edx),%dl
  800e38:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	84 c0                	test   %al,%al
  800e41:	74 03                	je     800e46 <strncpy+0x31>
			src++;
  800e43:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e46:	ff 45 fc             	incl   -0x4(%ebp)
  800e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e4f:	72 d9                	jb     800e2a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e54:	c9                   	leave  
  800e55:	c3                   	ret    

00800e56 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e66:	74 30                	je     800e98 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e68:	eb 16                	jmp    800e80 <strlcpy+0x2a>
			*dst++ = *src++;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8d 50 01             	lea    0x1(%eax),%edx
  800e70:	89 55 08             	mov    %edx,0x8(%ebp)
  800e73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e76:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e79:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e7c:	8a 12                	mov    (%edx),%dl
  800e7e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e80:	ff 4d 10             	decl   0x10(%ebp)
  800e83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e87:	74 09                	je     800e92 <strlcpy+0x3c>
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	84 c0                	test   %al,%al
  800e90:	75 d8                	jne    800e6a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e98:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9e:	29 c2                	sub    %eax,%edx
  800ea0:	89 d0                	mov    %edx,%eax
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ea7:	eb 06                	jmp    800eaf <strcmp+0xb>
		p++, q++;
  800ea9:	ff 45 08             	incl   0x8(%ebp)
  800eac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	84 c0                	test   %al,%al
  800eb6:	74 0e                	je     800ec6 <strcmp+0x22>
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	8a 10                	mov    (%eax),%dl
  800ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	38 c2                	cmp    %al,%dl
  800ec4:	74 e3                	je     800ea9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	0f b6 d0             	movzbl %al,%edx
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	0f b6 c0             	movzbl %al,%eax
  800ed6:	29 c2                	sub    %eax,%edx
  800ed8:	89 d0                	mov    %edx,%eax
}
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    

00800edc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800edf:	eb 09                	jmp    800eea <strncmp+0xe>
		n--, p++, q++;
  800ee1:	ff 4d 10             	decl   0x10(%ebp)
  800ee4:	ff 45 08             	incl   0x8(%ebp)
  800ee7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800eea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eee:	74 17                	je     800f07 <strncmp+0x2b>
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	84 c0                	test   %al,%al
  800ef7:	74 0e                	je     800f07 <strncmp+0x2b>
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8a 10                	mov    (%eax),%dl
  800efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	38 c2                	cmp    %al,%dl
  800f05:	74 da                	je     800ee1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0b:	75 07                	jne    800f14 <strncmp+0x38>
		return 0;
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f12:	eb 14                	jmp    800f28 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	8a 00                	mov    (%eax),%al
  800f19:	0f b6 d0             	movzbl %al,%edx
  800f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	0f b6 c0             	movzbl %al,%eax
  800f24:	29 c2                	sub    %eax,%edx
  800f26:	89 d0                	mov    %edx,%eax
}
  800f28:	5d                   	pop    %ebp
  800f29:	c3                   	ret    

00800f2a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	83 ec 04             	sub    $0x4,%esp
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f36:	eb 12                	jmp    800f4a <strchr+0x20>
		if (*s == c)
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f40:	75 05                	jne    800f47 <strchr+0x1d>
			return (char *) s;
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	eb 11                	jmp    800f58 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f47:	ff 45 08             	incl   0x8(%ebp)
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	8a 00                	mov    (%eax),%al
  800f4f:	84 c0                	test   %al,%al
  800f51:	75 e5                	jne    800f38 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    

00800f5a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 04             	sub    $0x4,%esp
  800f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f63:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f66:	eb 0d                	jmp    800f75 <strfind+0x1b>
		if (*s == c)
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f70:	74 0e                	je     800f80 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f72:	ff 45 08             	incl   0x8(%ebp)
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	84 c0                	test   %al,%al
  800f7c:	75 ea                	jne    800f68 <strfind+0xe>
  800f7e:	eb 01                	jmp    800f81 <strfind+0x27>
		if (*s == c)
			break;
  800f80:	90                   	nop
	return (char *) s;
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f84:	c9                   	leave  
  800f85:	c3                   	ret    

00800f86 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f92:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f96:	76 63                	jbe    800ffb <memset+0x75>
		uint64 data_block = c;
  800f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9b:	99                   	cltd   
  800f9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa8:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fac:	c1 e0 08             	shl    $0x8,%eax
  800faf:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fb2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fbb:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800fbf:	c1 e0 10             	shl    $0x10,%eax
  800fc2:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fc5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fce:	89 c2                	mov    %eax,%edx
  800fd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd5:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fd8:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800fdb:	eb 18                	jmp    800ff5 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800fdd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fe0:	8d 41 08             	lea    0x8(%ecx),%eax
  800fe3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fec:	89 01                	mov    %eax,(%ecx)
  800fee:	89 51 04             	mov    %edx,0x4(%ecx)
  800ff1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ff5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ff9:	77 e2                	ja     800fdd <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ffb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fff:	74 23                	je     801024 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801001:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801004:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801007:	eb 0e                	jmp    801017 <memset+0x91>
			*p8++ = (uint8)c;
  801009:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100c:	8d 50 01             	lea    0x1(%eax),%edx
  80100f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801012:	8b 55 0c             	mov    0xc(%ebp),%edx
  801015:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801017:	8b 45 10             	mov    0x10(%ebp),%eax
  80101a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101d:	89 55 10             	mov    %edx,0x10(%ebp)
  801020:	85 c0                	test   %eax,%eax
  801022:	75 e5                	jne    801009 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80103b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80103f:	76 24                	jbe    801065 <memcpy+0x3c>
		while(n >= 8){
  801041:	eb 1c                	jmp    80105f <memcpy+0x36>
			*d64 = *s64;
  801043:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801046:	8b 50 04             	mov    0x4(%eax),%edx
  801049:	8b 00                	mov    (%eax),%eax
  80104b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80104e:	89 01                	mov    %eax,(%ecx)
  801050:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801053:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801057:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80105b:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80105f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801063:	77 de                	ja     801043 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801065:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801069:	74 31                	je     80109c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80106b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801074:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801077:	eb 16                	jmp    80108f <memcpy+0x66>
			*d8++ = *s8++;
  801079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107c:	8d 50 01             	lea    0x1(%eax),%edx
  80107f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801082:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801085:	8d 4a 01             	lea    0x1(%edx),%ecx
  801088:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80108b:	8a 12                	mov    (%edx),%dl
  80108d:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80108f:	8b 45 10             	mov    0x10(%ebp),%eax
  801092:	8d 50 ff             	lea    -0x1(%eax),%edx
  801095:	89 55 10             	mov    %edx,0x10(%ebp)
  801098:	85 c0                	test   %eax,%eax
  80109a:	75 dd                	jne    801079 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109f:	c9                   	leave  
  8010a0:	c3                   	ret    

008010a1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010b9:	73 50                	jae    80110b <memmove+0x6a>
  8010bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010be:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c1:	01 d0                	add    %edx,%eax
  8010c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010c6:	76 43                	jbe    80110b <memmove+0x6a>
		s += n;
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010d4:	eb 10                	jmp    8010e6 <memmove+0x45>
			*--d = *--s;
  8010d6:	ff 4d f8             	decl   -0x8(%ebp)
  8010d9:	ff 4d fc             	decl   -0x4(%ebp)
  8010dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010df:	8a 10                	mov    (%eax),%dl
  8010e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ec:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ef:	85 c0                	test   %eax,%eax
  8010f1:	75 e3                	jne    8010d6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010f3:	eb 23                	jmp    801118 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f8:	8d 50 01             	lea    0x1(%eax),%edx
  8010fb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801101:	8d 4a 01             	lea    0x1(%edx),%ecx
  801104:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801107:	8a 12                	mov    (%edx),%dl
  801109:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801111:	89 55 10             	mov    %edx,0x10(%ebp)
  801114:	85 c0                	test   %eax,%eax
  801116:	75 dd                	jne    8010f5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111b:	c9                   	leave  
  80111c:	c3                   	ret    

0080111d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
  801120:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80112f:	eb 2a                	jmp    80115b <memcmp+0x3e>
		if (*s1 != *s2)
  801131:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801134:	8a 10                	mov    (%eax),%dl
  801136:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	38 c2                	cmp    %al,%dl
  80113d:	74 16                	je     801155 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80113f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	0f b6 d0             	movzbl %al,%edx
  801147:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f b6 c0             	movzbl %al,%eax
  80114f:	29 c2                	sub    %eax,%edx
  801151:	89 d0                	mov    %edx,%eax
  801153:	eb 18                	jmp    80116d <memcmp+0x50>
		s1++, s2++;
  801155:	ff 45 fc             	incl   -0x4(%ebp)
  801158:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80115b:	8b 45 10             	mov    0x10(%ebp),%eax
  80115e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801161:	89 55 10             	mov    %edx,0x10(%ebp)
  801164:	85 c0                	test   %eax,%eax
  801166:	75 c9                	jne    801131 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801168:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801175:	8b 55 08             	mov    0x8(%ebp),%edx
  801178:	8b 45 10             	mov    0x10(%ebp),%eax
  80117b:	01 d0                	add    %edx,%eax
  80117d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801180:	eb 15                	jmp    801197 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	0f b6 d0             	movzbl %al,%edx
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	0f b6 c0             	movzbl %al,%eax
  801190:	39 c2                	cmp    %eax,%edx
  801192:	74 0d                	je     8011a1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801194:	ff 45 08             	incl   0x8(%ebp)
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80119d:	72 e3                	jb     801182 <memfind+0x13>
  80119f:	eb 01                	jmp    8011a2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011a1:	90                   	nop
	return (void *) s;
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    

008011a7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011bb:	eb 03                	jmp    8011c0 <strtol+0x19>
		s++;
  8011bd:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	3c 20                	cmp    $0x20,%al
  8011c7:	74 f4                	je     8011bd <strtol+0x16>
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	3c 09                	cmp    $0x9,%al
  8011d0:	74 eb                	je     8011bd <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	8a 00                	mov    (%eax),%al
  8011d7:	3c 2b                	cmp    $0x2b,%al
  8011d9:	75 05                	jne    8011e0 <strtol+0x39>
		s++;
  8011db:	ff 45 08             	incl   0x8(%ebp)
  8011de:	eb 13                	jmp    8011f3 <strtol+0x4c>
	else if (*s == '-')
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 2d                	cmp    $0x2d,%al
  8011e7:	75 0a                	jne    8011f3 <strtol+0x4c>
		s++, neg = 1;
  8011e9:	ff 45 08             	incl   0x8(%ebp)
  8011ec:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f7:	74 06                	je     8011ff <strtol+0x58>
  8011f9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011fd:	75 20                	jne    80121f <strtol+0x78>
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 30                	cmp    $0x30,%al
  801206:	75 17                	jne    80121f <strtol+0x78>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	40                   	inc    %eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	3c 78                	cmp    $0x78,%al
  801210:	75 0d                	jne    80121f <strtol+0x78>
		s += 2, base = 16;
  801212:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801216:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80121d:	eb 28                	jmp    801247 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80121f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801223:	75 15                	jne    80123a <strtol+0x93>
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	3c 30                	cmp    $0x30,%al
  80122c:	75 0c                	jne    80123a <strtol+0x93>
		s++, base = 8;
  80122e:	ff 45 08             	incl   0x8(%ebp)
  801231:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801238:	eb 0d                	jmp    801247 <strtol+0xa0>
	else if (base == 0)
  80123a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80123e:	75 07                	jne    801247 <strtol+0xa0>
		base = 10;
  801240:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	3c 2f                	cmp    $0x2f,%al
  80124e:	7e 19                	jle    801269 <strtol+0xc2>
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 39                	cmp    $0x39,%al
  801257:	7f 10                	jg     801269 <strtol+0xc2>
			dig = *s - '0';
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	0f be c0             	movsbl %al,%eax
  801261:	83 e8 30             	sub    $0x30,%eax
  801264:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801267:	eb 42                	jmp    8012ab <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	3c 60                	cmp    $0x60,%al
  801270:	7e 19                	jle    80128b <strtol+0xe4>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	3c 7a                	cmp    $0x7a,%al
  801279:	7f 10                	jg     80128b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	0f be c0             	movsbl %al,%eax
  801283:	83 e8 57             	sub    $0x57,%eax
  801286:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801289:	eb 20                	jmp    8012ab <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	3c 40                	cmp    $0x40,%al
  801292:	7e 39                	jle    8012cd <strtol+0x126>
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	3c 5a                	cmp    $0x5a,%al
  80129b:	7f 30                	jg     8012cd <strtol+0x126>
			dig = *s - 'A' + 10;
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	0f be c0             	movsbl %al,%eax
  8012a5:	83 e8 37             	sub    $0x37,%eax
  8012a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ae:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012b1:	7d 19                	jge    8012cc <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012b3:	ff 45 08             	incl   0x8(%ebp)
  8012b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012bd:	89 c2                	mov    %eax,%edx
  8012bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c2:	01 d0                	add    %edx,%eax
  8012c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012c7:	e9 7b ff ff ff       	jmp    801247 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012cc:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012d1:	74 08                	je     8012db <strtol+0x134>
		*endptr = (char *) s;
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012db:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012df:	74 07                	je     8012e8 <strtol+0x141>
  8012e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e4:	f7 d8                	neg    %eax
  8012e6:	eb 03                	jmp    8012eb <strtol+0x144>
  8012e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <ltostr>:

void
ltostr(long value, char *str)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801301:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801305:	79 13                	jns    80131a <ltostr+0x2d>
	{
		neg = 1;
  801307:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80130e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801311:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801314:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801317:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801322:	99                   	cltd   
  801323:	f7 f9                	idiv   %ecx
  801325:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801328:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132b:	8d 50 01             	lea    0x1(%eax),%edx
  80132e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801331:	89 c2                	mov    %eax,%edx
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	01 d0                	add    %edx,%eax
  801338:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80133b:	83 c2 30             	add    $0x30,%edx
  80133e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801340:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801343:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801348:	f7 e9                	imul   %ecx
  80134a:	c1 fa 02             	sar    $0x2,%edx
  80134d:	89 c8                	mov    %ecx,%eax
  80134f:	c1 f8 1f             	sar    $0x1f,%eax
  801352:	29 c2                	sub    %eax,%edx
  801354:	89 d0                	mov    %edx,%eax
  801356:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801359:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80135d:	75 bb                	jne    80131a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80135f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801366:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801369:	48                   	dec    %eax
  80136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80136d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801371:	74 3d                	je     8013b0 <ltostr+0xc3>
		start = 1 ;
  801373:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80137a:	eb 34                	jmp    8013b0 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	01 d0                	add    %edx,%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	01 c2                	add    %eax,%edx
  801391:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	01 c8                	add    %ecx,%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80139d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	01 c2                	add    %eax,%edx
  8013a5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013a8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013aa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013ad:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b6:	7c c4                	jl     80137c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	01 d0                	add    %edx,%eax
  8013c0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013c3:	90                   	nop
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013cc:	ff 75 08             	pushl  0x8(%ebp)
  8013cf:	e8 c4 f9 ff ff       	call   800d98 <strlen>
  8013d4:	83 c4 04             	add    $0x4,%esp
  8013d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 b6 f9 ff ff       	call   800d98 <strlen>
  8013e2:	83 c4 04             	add    $0x4,%esp
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f6:	eb 17                	jmp    80140f <strcconcat+0x49>
		final[s] = str1[s] ;
  8013f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80140c:	ff 45 fc             	incl   -0x4(%ebp)
  80140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801412:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801415:	7c e1                	jl     8013f8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801417:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80141e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801425:	eb 1f                	jmp    801446 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	8d 50 01             	lea    0x1(%eax),%edx
  80142d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801430:	89 c2                	mov    %eax,%edx
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
  801435:	01 c2                	add    %eax,%edx
  801437:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c8                	add    %ecx,%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801443:	ff 45 f8             	incl   -0x8(%ebp)
  801446:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144c:	7c d9                	jl     801427 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80144e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801451:	8b 45 10             	mov    0x10(%ebp),%eax
  801454:	01 d0                	add    %edx,%eax
  801456:	c6 00 00             	movb   $0x0,(%eax)
}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	01 d0                	add    %edx,%eax
  801479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80147f:	eb 0c                	jmp    80148d <strsplit+0x31>
			*string++ = 0;
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8d 50 01             	lea    0x1(%eax),%edx
  801487:	89 55 08             	mov    %edx,0x8(%ebp)
  80148a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 18                	je     8014ae <strsplit+0x52>
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	0f be c0             	movsbl %al,%eax
  80149e:	50                   	push   %eax
  80149f:	ff 75 0c             	pushl  0xc(%ebp)
  8014a2:	e8 83 fa ff ff       	call   800f2a <strchr>
  8014a7:	83 c4 08             	add    $0x8,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	75 d3                	jne    801481 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	84 c0                	test   %al,%al
  8014b5:	74 5a                	je     801511 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	83 f8 0f             	cmp    $0xf,%eax
  8014bf:	75 07                	jne    8014c8 <strsplit+0x6c>
		{
			return 0;
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c6:	eb 66                	jmp    80152e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cb:	8b 00                	mov    (%eax),%eax
  8014cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8014d3:	89 0a                	mov    %ecx,(%edx)
  8014d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014df:	01 c2                	add    %eax,%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e6:	eb 03                	jmp    8014eb <strsplit+0x8f>
			string++;
  8014e8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	84 c0                	test   %al,%al
  8014f2:	74 8b                	je     80147f <strsplit+0x23>
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	0f be c0             	movsbl %al,%eax
  8014fc:	50                   	push   %eax
  8014fd:	ff 75 0c             	pushl  0xc(%ebp)
  801500:	e8 25 fa ff ff       	call   800f2a <strchr>
  801505:	83 c4 08             	add    $0x8,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	74 dc                	je     8014e8 <strsplit+0x8c>
			string++;
	}
  80150c:	e9 6e ff ff ff       	jmp    80147f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801511:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801512:	8b 45 14             	mov    0x14(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151e:	8b 45 10             	mov    0x10(%ebp),%eax
  801521:	01 d0                	add    %edx,%eax
  801523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801529:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80153c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801543:	eb 4a                	jmp    80158f <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801545:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	01 c2                	add    %eax,%edx
  80154d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801550:	8b 45 0c             	mov    0xc(%ebp),%eax
  801553:	01 c8                	add    %ecx,%eax
  801555:	8a 00                	mov    (%eax),%al
  801557:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801559:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80155c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155f:	01 d0                	add    %edx,%eax
  801561:	8a 00                	mov    (%eax),%al
  801563:	3c 40                	cmp    $0x40,%al
  801565:	7e 25                	jle    80158c <str2lower+0x5c>
  801567:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	01 d0                	add    %edx,%eax
  80156f:	8a 00                	mov    (%eax),%al
  801571:	3c 5a                	cmp    $0x5a,%al
  801573:	7f 17                	jg     80158c <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801575:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	01 d0                	add    %edx,%eax
  80157d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801580:	8b 55 08             	mov    0x8(%ebp),%edx
  801583:	01 ca                	add    %ecx,%edx
  801585:	8a 12                	mov    (%edx),%dl
  801587:	83 c2 20             	add    $0x20,%edx
  80158a:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80158c:	ff 45 fc             	incl   -0x4(%ebp)
  80158f:	ff 75 0c             	pushl  0xc(%ebp)
  801592:	e8 01 f8 ff ff       	call   800d98 <strlen>
  801597:	83 c4 04             	add    $0x4,%esp
  80159a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80159d:	7f a6                	jg     801545 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80159f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    

008015a4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	57                   	push   %edi
  8015a8:	56                   	push   %esi
  8015a9:	53                   	push   %ebx
  8015aa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015b9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015bc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015bf:	cd 30                	int    $0x30
  8015c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8015c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015c7:	83 c4 10             	add    $0x10,%esp
  8015ca:	5b                   	pop    %ebx
  8015cb:	5e                   	pop    %esi
  8015cc:	5f                   	pop    %edi
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8015db:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015de:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	6a 00                	push   $0x0
  8015e7:	51                   	push   %ecx
  8015e8:	52                   	push   %edx
  8015e9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ec:	50                   	push   %eax
  8015ed:	6a 00                	push   $0x0
  8015ef:	e8 b0 ff ff ff       	call   8015a4 <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
}
  8015f7:	90                   	nop
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <sys_cgetc>:

int
sys_cgetc(void)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 02                	push   $0x2
  801609:	e8 96 ff ff ff       	call   8015a4 <syscall>
  80160e:	83 c4 18             	add    $0x18,%esp
}
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 03                	push   $0x3
  801622:	e8 7d ff ff ff       	call   8015a4 <syscall>
  801627:	83 c4 18             	add    $0x18,%esp
}
  80162a:	90                   	nop
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 04                	push   $0x4
  80163c:	e8 63 ff ff ff       	call   8015a4 <syscall>
  801641:	83 c4 18             	add    $0x18,%esp
}
  801644:	90                   	nop
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80164a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	52                   	push   %edx
  801657:	50                   	push   %eax
  801658:	6a 08                	push   $0x8
  80165a:	e8 45 ff ff ff       	call   8015a4 <syscall>
  80165f:	83 c4 18             	add    $0x18,%esp
}
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	56                   	push   %esi
  801668:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801669:	8b 75 18             	mov    0x18(%ebp),%esi
  80166c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80166f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801672:	8b 55 0c             	mov    0xc(%ebp),%edx
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	56                   	push   %esi
  801679:	53                   	push   %ebx
  80167a:	51                   	push   %ecx
  80167b:	52                   	push   %edx
  80167c:	50                   	push   %eax
  80167d:	6a 09                	push   $0x9
  80167f:	e8 20 ff ff ff       	call   8015a4 <syscall>
  801684:	83 c4 18             	add    $0x18,%esp
}
  801687:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80168a:	5b                   	pop    %ebx
  80168b:	5e                   	pop    %esi
  80168c:	5d                   	pop    %ebp
  80168d:	c3                   	ret    

0080168e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	ff 75 08             	pushl  0x8(%ebp)
  80169c:	6a 0a                	push   $0xa
  80169e:	e8 01 ff ff ff       	call   8015a4 <syscall>
  8016a3:	83 c4 18             	add    $0x18,%esp
}
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	ff 75 0c             	pushl  0xc(%ebp)
  8016b4:	ff 75 08             	pushl  0x8(%ebp)
  8016b7:	6a 0b                	push   $0xb
  8016b9:	e8 e6 fe ff ff       	call   8015a4 <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 0c                	push   $0xc
  8016d2:	e8 cd fe ff ff       	call   8015a4 <syscall>
  8016d7:	83 c4 18             	add    $0x18,%esp
}
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 0d                	push   $0xd
  8016eb:	e8 b4 fe ff ff       	call   8015a4 <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 0e                	push   $0xe
  801704:	e8 9b fe ff ff       	call   8015a4 <syscall>
  801709:	83 c4 18             	add    $0x18,%esp
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 0f                	push   $0xf
  80171d:	e8 82 fe ff ff       	call   8015a4 <syscall>
  801722:	83 c4 18             	add    $0x18,%esp
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	6a 10                	push   $0x10
  801737:	e8 68 fe ff ff       	call   8015a4 <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 11                	push   $0x11
  801750:	e8 4f fe ff ff       	call   8015a4 <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
}
  801758:	90                   	nop
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <sys_cputc>:

void
sys_cputc(const char c)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	83 ec 04             	sub    $0x4,%esp
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801767:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	50                   	push   %eax
  801774:	6a 01                	push   $0x1
  801776:	e8 29 fe ff ff       	call   8015a4 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	90                   	nop
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 14                	push   $0x14
  801790:	e8 0f fe ff ff       	call   8015a4 <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
}
  801798:	90                   	nop
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	83 ec 04             	sub    $0x4,%esp
  8017a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017a7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017aa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b1:	6a 00                	push   $0x0
  8017b3:	51                   	push   %ecx
  8017b4:	52                   	push   %edx
  8017b5:	ff 75 0c             	pushl  0xc(%ebp)
  8017b8:	50                   	push   %eax
  8017b9:	6a 15                	push   $0x15
  8017bb:	e8 e4 fd ff ff       	call   8015a4 <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	52                   	push   %edx
  8017d5:	50                   	push   %eax
  8017d6:	6a 16                	push   $0x16
  8017d8:	e8 c7 fd ff ff       	call   8015a4 <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	51                   	push   %ecx
  8017f3:	52                   	push   %edx
  8017f4:	50                   	push   %eax
  8017f5:	6a 17                	push   $0x17
  8017f7:	e8 a8 fd ff ff       	call   8015a4 <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801804:	8b 55 0c             	mov    0xc(%ebp),%edx
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	52                   	push   %edx
  801811:	50                   	push   %eax
  801812:	6a 18                	push   $0x18
  801814:	e8 8b fd ff ff       	call   8015a4 <syscall>
  801819:	83 c4 18             	add    $0x18,%esp
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	6a 00                	push   $0x0
  801826:	ff 75 14             	pushl  0x14(%ebp)
  801829:	ff 75 10             	pushl  0x10(%ebp)
  80182c:	ff 75 0c             	pushl  0xc(%ebp)
  80182f:	50                   	push   %eax
  801830:	6a 19                	push   $0x19
  801832:	e8 6d fd ff ff       	call   8015a4 <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	50                   	push   %eax
  80184b:	6a 1a                	push   $0x1a
  80184d:	e8 52 fd ff ff       	call   8015a4 <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	90                   	nop
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	50                   	push   %eax
  801867:	6a 1b                	push   $0x1b
  801869:	e8 36 fd ff ff       	call   8015a4 <syscall>
  80186e:	83 c4 18             	add    $0x18,%esp
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 05                	push   $0x5
  801882:	e8 1d fd ff ff       	call   8015a4 <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 06                	push   $0x6
  80189b:	e8 04 fd ff ff       	call   8015a4 <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 07                	push   $0x7
  8018b4:	e8 eb fc ff ff       	call   8015a4 <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_exit_env>:


void sys_exit_env(void)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 1c                	push   $0x1c
  8018cd:	e8 d2 fc ff ff       	call   8015a4 <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	90                   	nop
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018de:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018e1:	8d 50 04             	lea    0x4(%eax),%edx
  8018e4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	52                   	push   %edx
  8018ee:	50                   	push   %eax
  8018ef:	6a 1d                	push   $0x1d
  8018f1:	e8 ae fc ff ff       	call   8015a4 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
	return result;
  8018f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801902:	89 01                	mov    %eax,(%ecx)
  801904:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	c9                   	leave  
  80190b:	c2 04 00             	ret    $0x4

0080190e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	ff 75 10             	pushl  0x10(%ebp)
  801918:	ff 75 0c             	pushl  0xc(%ebp)
  80191b:	ff 75 08             	pushl  0x8(%ebp)
  80191e:	6a 13                	push   $0x13
  801920:	e8 7f fc ff ff       	call   8015a4 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
	return ;
  801928:	90                   	nop
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_rcr2>:
uint32 sys_rcr2()
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 1e                	push   $0x1e
  80193a:	e8 65 fc ff ff       	call   8015a4 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	83 ec 04             	sub    $0x4,%esp
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801950:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	50                   	push   %eax
  80195d:	6a 1f                	push   $0x1f
  80195f:	e8 40 fc ff ff       	call   8015a4 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
	return ;
  801967:	90                   	nop
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <rsttst>:
void rsttst()
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 21                	push   $0x21
  801979:	e8 26 fc ff ff       	call   8015a4 <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
	return ;
  801981:	90                   	nop
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 04             	sub    $0x4,%esp
  80198a:	8b 45 14             	mov    0x14(%ebp),%eax
  80198d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801990:	8b 55 18             	mov    0x18(%ebp),%edx
  801993:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801997:	52                   	push   %edx
  801998:	50                   	push   %eax
  801999:	ff 75 10             	pushl  0x10(%ebp)
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	ff 75 08             	pushl  0x8(%ebp)
  8019a2:	6a 20                	push   $0x20
  8019a4:	e8 fb fb ff ff       	call   8015a4 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ac:	90                   	nop
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <chktst>:
void chktst(uint32 n)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	ff 75 08             	pushl  0x8(%ebp)
  8019bd:	6a 22                	push   $0x22
  8019bf:	e8 e0 fb ff ff       	call   8015a4 <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c7:	90                   	nop
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <inctst>:

void inctst()
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 23                	push   $0x23
  8019d9:	e8 c6 fb ff ff       	call   8015a4 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e1:	90                   	nop
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <gettst>:
uint32 gettst()
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 24                	push   $0x24
  8019f3:	e8 ac fb ff ff       	call   8015a4 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 25                	push   $0x25
  801a0c:	e8 93 fb ff ff       	call   8015a4 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
  801a14:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801a19:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	6a 26                	push   $0x26
  801a38:	e8 67 fb ff ff       	call   8015a4 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a40:	90                   	nop
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a47:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	6a 00                	push   $0x0
  801a55:	53                   	push   %ebx
  801a56:	51                   	push   %ecx
  801a57:	52                   	push   %edx
  801a58:	50                   	push   %eax
  801a59:	6a 27                	push   $0x27
  801a5b:	e8 44 fb ff ff       	call   8015a4 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	52                   	push   %edx
  801a78:	50                   	push   %eax
  801a79:	6a 28                	push   $0x28
  801a7b:	e8 24 fb ff ff       	call   8015a4 <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a88:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	6a 00                	push   $0x0
  801a93:	51                   	push   %ecx
  801a94:	ff 75 10             	pushl  0x10(%ebp)
  801a97:	52                   	push   %edx
  801a98:	50                   	push   %eax
  801a99:	6a 29                	push   $0x29
  801a9b:	e8 04 fb ff ff       	call   8015a4 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	ff 75 10             	pushl  0x10(%ebp)
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	ff 75 08             	pushl  0x8(%ebp)
  801ab5:	6a 12                	push   $0x12
  801ab7:	e8 e8 fa ff ff       	call   8015a4 <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
	return ;
  801abf:	90                   	nop
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	52                   	push   %edx
  801ad2:	50                   	push   %eax
  801ad3:	6a 2a                	push   $0x2a
  801ad5:	e8 ca fa ff ff       	call   8015a4 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
	return;
  801add:	90                   	nop
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 2b                	push   $0x2b
  801aef:	e8 b0 fa ff ff       	call   8015a4 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	ff 75 0c             	pushl  0xc(%ebp)
  801b05:	ff 75 08             	pushl  0x8(%ebp)
  801b08:	6a 2d                	push   $0x2d
  801b0a:	e8 95 fa ff ff       	call   8015a4 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
	return;
  801b12:	90                   	nop
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	ff 75 0c             	pushl  0xc(%ebp)
  801b21:	ff 75 08             	pushl  0x8(%ebp)
  801b24:	6a 2c                	push   $0x2c
  801b26:	e8 79 fa ff ff       	call   8015a4 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2e:	90                   	nop
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	52                   	push   %edx
  801b41:	50                   	push   %eax
  801b42:	6a 2e                	push   $0x2e
  801b44:	e8 5b fa ff ff       	call   8015a4 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4c:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  801b55:	83 ec 04             	sub    $0x4,%esp
  801b58:	68 48 25 80 00       	push   $0x802548
  801b5d:	6a 07                	push   $0x7
  801b5f:	68 77 25 80 00       	push   $0x802577
  801b64:	e8 68 e8 ff ff       	call   8003d1 <_panic>

00801b69 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  801b6f:	83 ec 04             	sub    $0x4,%esp
  801b72:	68 88 25 80 00       	push   $0x802588
  801b77:	6a 0b                	push   $0xb
  801b79:	68 77 25 80 00       	push   $0x802577
  801b7e:	e8 4e e8 ff ff       	call   8003d1 <_panic>

00801b83 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  801b89:	83 ec 04             	sub    $0x4,%esp
  801b8c:	68 b4 25 80 00       	push   $0x8025b4
  801b91:	6a 10                	push   $0x10
  801b93:	68 77 25 80 00       	push   $0x802577
  801b98:	e8 34 e8 ff ff       	call   8003d1 <_panic>

00801b9d <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  801ba3:	83 ec 04             	sub    $0x4,%esp
  801ba6:	68 e4 25 80 00       	push   $0x8025e4
  801bab:	6a 15                	push   $0x15
  801bad:	68 77 25 80 00       	push   $0x802577
  801bb2:	e8 1a e8 ff ff       	call   8003d1 <_panic>

00801bb7 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	8b 40 10             	mov    0x10(%eax),%eax
}
  801bc0:	5d                   	pop    %ebp
  801bc1:	c3                   	ret    
  801bc2:	66 90                	xchg   %ax,%ax

00801bc4 <__udivdi3>:
  801bc4:	55                   	push   %ebp
  801bc5:	57                   	push   %edi
  801bc6:	56                   	push   %esi
  801bc7:	53                   	push   %ebx
  801bc8:	83 ec 1c             	sub    $0x1c,%esp
  801bcb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bcf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bd3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bd7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bdb:	89 ca                	mov    %ecx,%edx
  801bdd:	89 f8                	mov    %edi,%eax
  801bdf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801be3:	85 f6                	test   %esi,%esi
  801be5:	75 2d                	jne    801c14 <__udivdi3+0x50>
  801be7:	39 cf                	cmp    %ecx,%edi
  801be9:	77 65                	ja     801c50 <__udivdi3+0x8c>
  801beb:	89 fd                	mov    %edi,%ebp
  801bed:	85 ff                	test   %edi,%edi
  801bef:	75 0b                	jne    801bfc <__udivdi3+0x38>
  801bf1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf6:	31 d2                	xor    %edx,%edx
  801bf8:	f7 f7                	div    %edi
  801bfa:	89 c5                	mov    %eax,%ebp
  801bfc:	31 d2                	xor    %edx,%edx
  801bfe:	89 c8                	mov    %ecx,%eax
  801c00:	f7 f5                	div    %ebp
  801c02:	89 c1                	mov    %eax,%ecx
  801c04:	89 d8                	mov    %ebx,%eax
  801c06:	f7 f5                	div    %ebp
  801c08:	89 cf                	mov    %ecx,%edi
  801c0a:	89 fa                	mov    %edi,%edx
  801c0c:	83 c4 1c             	add    $0x1c,%esp
  801c0f:	5b                   	pop    %ebx
  801c10:	5e                   	pop    %esi
  801c11:	5f                   	pop    %edi
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    
  801c14:	39 ce                	cmp    %ecx,%esi
  801c16:	77 28                	ja     801c40 <__udivdi3+0x7c>
  801c18:	0f bd fe             	bsr    %esi,%edi
  801c1b:	83 f7 1f             	xor    $0x1f,%edi
  801c1e:	75 40                	jne    801c60 <__udivdi3+0x9c>
  801c20:	39 ce                	cmp    %ecx,%esi
  801c22:	72 0a                	jb     801c2e <__udivdi3+0x6a>
  801c24:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c28:	0f 87 9e 00 00 00    	ja     801ccc <__udivdi3+0x108>
  801c2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c33:	89 fa                	mov    %edi,%edx
  801c35:	83 c4 1c             	add    $0x1c,%esp
  801c38:	5b                   	pop    %ebx
  801c39:	5e                   	pop    %esi
  801c3a:	5f                   	pop    %edi
  801c3b:	5d                   	pop    %ebp
  801c3c:	c3                   	ret    
  801c3d:	8d 76 00             	lea    0x0(%esi),%esi
  801c40:	31 ff                	xor    %edi,%edi
  801c42:	31 c0                	xor    %eax,%eax
  801c44:	89 fa                	mov    %edi,%edx
  801c46:	83 c4 1c             	add    $0x1c,%esp
  801c49:	5b                   	pop    %ebx
  801c4a:	5e                   	pop    %esi
  801c4b:	5f                   	pop    %edi
  801c4c:	5d                   	pop    %ebp
  801c4d:	c3                   	ret    
  801c4e:	66 90                	xchg   %ax,%ax
  801c50:	89 d8                	mov    %ebx,%eax
  801c52:	f7 f7                	div    %edi
  801c54:	31 ff                	xor    %edi,%edi
  801c56:	89 fa                	mov    %edi,%edx
  801c58:	83 c4 1c             	add    $0x1c,%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5f                   	pop    %edi
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    
  801c60:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c65:	89 eb                	mov    %ebp,%ebx
  801c67:	29 fb                	sub    %edi,%ebx
  801c69:	89 f9                	mov    %edi,%ecx
  801c6b:	d3 e6                	shl    %cl,%esi
  801c6d:	89 c5                	mov    %eax,%ebp
  801c6f:	88 d9                	mov    %bl,%cl
  801c71:	d3 ed                	shr    %cl,%ebp
  801c73:	89 e9                	mov    %ebp,%ecx
  801c75:	09 f1                	or     %esi,%ecx
  801c77:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c7b:	89 f9                	mov    %edi,%ecx
  801c7d:	d3 e0                	shl    %cl,%eax
  801c7f:	89 c5                	mov    %eax,%ebp
  801c81:	89 d6                	mov    %edx,%esi
  801c83:	88 d9                	mov    %bl,%cl
  801c85:	d3 ee                	shr    %cl,%esi
  801c87:	89 f9                	mov    %edi,%ecx
  801c89:	d3 e2                	shl    %cl,%edx
  801c8b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c8f:	88 d9                	mov    %bl,%cl
  801c91:	d3 e8                	shr    %cl,%eax
  801c93:	09 c2                	or     %eax,%edx
  801c95:	89 d0                	mov    %edx,%eax
  801c97:	89 f2                	mov    %esi,%edx
  801c99:	f7 74 24 0c          	divl   0xc(%esp)
  801c9d:	89 d6                	mov    %edx,%esi
  801c9f:	89 c3                	mov    %eax,%ebx
  801ca1:	f7 e5                	mul    %ebp
  801ca3:	39 d6                	cmp    %edx,%esi
  801ca5:	72 19                	jb     801cc0 <__udivdi3+0xfc>
  801ca7:	74 0b                	je     801cb4 <__udivdi3+0xf0>
  801ca9:	89 d8                	mov    %ebx,%eax
  801cab:	31 ff                	xor    %edi,%edi
  801cad:	e9 58 ff ff ff       	jmp    801c0a <__udivdi3+0x46>
  801cb2:	66 90                	xchg   %ax,%ax
  801cb4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cb8:	89 f9                	mov    %edi,%ecx
  801cba:	d3 e2                	shl    %cl,%edx
  801cbc:	39 c2                	cmp    %eax,%edx
  801cbe:	73 e9                	jae    801ca9 <__udivdi3+0xe5>
  801cc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cc3:	31 ff                	xor    %edi,%edi
  801cc5:	e9 40 ff ff ff       	jmp    801c0a <__udivdi3+0x46>
  801cca:	66 90                	xchg   %ax,%ax
  801ccc:	31 c0                	xor    %eax,%eax
  801cce:	e9 37 ff ff ff       	jmp    801c0a <__udivdi3+0x46>
  801cd3:	90                   	nop

00801cd4 <__umoddi3>:
  801cd4:	55                   	push   %ebp
  801cd5:	57                   	push   %edi
  801cd6:	56                   	push   %esi
  801cd7:	53                   	push   %ebx
  801cd8:	83 ec 1c             	sub    $0x1c,%esp
  801cdb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cdf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ce3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ce7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ceb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cf3:	89 f3                	mov    %esi,%ebx
  801cf5:	89 fa                	mov    %edi,%edx
  801cf7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cfb:	89 34 24             	mov    %esi,(%esp)
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	75 1a                	jne    801d1c <__umoddi3+0x48>
  801d02:	39 f7                	cmp    %esi,%edi
  801d04:	0f 86 a2 00 00 00    	jbe    801dac <__umoddi3+0xd8>
  801d0a:	89 c8                	mov    %ecx,%eax
  801d0c:	89 f2                	mov    %esi,%edx
  801d0e:	f7 f7                	div    %edi
  801d10:	89 d0                	mov    %edx,%eax
  801d12:	31 d2                	xor    %edx,%edx
  801d14:	83 c4 1c             	add    $0x1c,%esp
  801d17:	5b                   	pop    %ebx
  801d18:	5e                   	pop    %esi
  801d19:	5f                   	pop    %edi
  801d1a:	5d                   	pop    %ebp
  801d1b:	c3                   	ret    
  801d1c:	39 f0                	cmp    %esi,%eax
  801d1e:	0f 87 ac 00 00 00    	ja     801dd0 <__umoddi3+0xfc>
  801d24:	0f bd e8             	bsr    %eax,%ebp
  801d27:	83 f5 1f             	xor    $0x1f,%ebp
  801d2a:	0f 84 ac 00 00 00    	je     801ddc <__umoddi3+0x108>
  801d30:	bf 20 00 00 00       	mov    $0x20,%edi
  801d35:	29 ef                	sub    %ebp,%edi
  801d37:	89 fe                	mov    %edi,%esi
  801d39:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d3d:	89 e9                	mov    %ebp,%ecx
  801d3f:	d3 e0                	shl    %cl,%eax
  801d41:	89 d7                	mov    %edx,%edi
  801d43:	89 f1                	mov    %esi,%ecx
  801d45:	d3 ef                	shr    %cl,%edi
  801d47:	09 c7                	or     %eax,%edi
  801d49:	89 e9                	mov    %ebp,%ecx
  801d4b:	d3 e2                	shl    %cl,%edx
  801d4d:	89 14 24             	mov    %edx,(%esp)
  801d50:	89 d8                	mov    %ebx,%eax
  801d52:	d3 e0                	shl    %cl,%eax
  801d54:	89 c2                	mov    %eax,%edx
  801d56:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d5a:	d3 e0                	shl    %cl,%eax
  801d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d60:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d64:	89 f1                	mov    %esi,%ecx
  801d66:	d3 e8                	shr    %cl,%eax
  801d68:	09 d0                	or     %edx,%eax
  801d6a:	d3 eb                	shr    %cl,%ebx
  801d6c:	89 da                	mov    %ebx,%edx
  801d6e:	f7 f7                	div    %edi
  801d70:	89 d3                	mov    %edx,%ebx
  801d72:	f7 24 24             	mull   (%esp)
  801d75:	89 c6                	mov    %eax,%esi
  801d77:	89 d1                	mov    %edx,%ecx
  801d79:	39 d3                	cmp    %edx,%ebx
  801d7b:	0f 82 87 00 00 00    	jb     801e08 <__umoddi3+0x134>
  801d81:	0f 84 91 00 00 00    	je     801e18 <__umoddi3+0x144>
  801d87:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d8b:	29 f2                	sub    %esi,%edx
  801d8d:	19 cb                	sbb    %ecx,%ebx
  801d8f:	89 d8                	mov    %ebx,%eax
  801d91:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d95:	d3 e0                	shl    %cl,%eax
  801d97:	89 e9                	mov    %ebp,%ecx
  801d99:	d3 ea                	shr    %cl,%edx
  801d9b:	09 d0                	or     %edx,%eax
  801d9d:	89 e9                	mov    %ebp,%ecx
  801d9f:	d3 eb                	shr    %cl,%ebx
  801da1:	89 da                	mov    %ebx,%edx
  801da3:	83 c4 1c             	add    $0x1c,%esp
  801da6:	5b                   	pop    %ebx
  801da7:	5e                   	pop    %esi
  801da8:	5f                   	pop    %edi
  801da9:	5d                   	pop    %ebp
  801daa:	c3                   	ret    
  801dab:	90                   	nop
  801dac:	89 fd                	mov    %edi,%ebp
  801dae:	85 ff                	test   %edi,%edi
  801db0:	75 0b                	jne    801dbd <__umoddi3+0xe9>
  801db2:	b8 01 00 00 00       	mov    $0x1,%eax
  801db7:	31 d2                	xor    %edx,%edx
  801db9:	f7 f7                	div    %edi
  801dbb:	89 c5                	mov    %eax,%ebp
  801dbd:	89 f0                	mov    %esi,%eax
  801dbf:	31 d2                	xor    %edx,%edx
  801dc1:	f7 f5                	div    %ebp
  801dc3:	89 c8                	mov    %ecx,%eax
  801dc5:	f7 f5                	div    %ebp
  801dc7:	89 d0                	mov    %edx,%eax
  801dc9:	e9 44 ff ff ff       	jmp    801d12 <__umoddi3+0x3e>
  801dce:	66 90                	xchg   %ax,%ax
  801dd0:	89 c8                	mov    %ecx,%eax
  801dd2:	89 f2                	mov    %esi,%edx
  801dd4:	83 c4 1c             	add    $0x1c,%esp
  801dd7:	5b                   	pop    %ebx
  801dd8:	5e                   	pop    %esi
  801dd9:	5f                   	pop    %edi
  801dda:	5d                   	pop    %ebp
  801ddb:	c3                   	ret    
  801ddc:	3b 04 24             	cmp    (%esp),%eax
  801ddf:	72 06                	jb     801de7 <__umoddi3+0x113>
  801de1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801de5:	77 0f                	ja     801df6 <__umoddi3+0x122>
  801de7:	89 f2                	mov    %esi,%edx
  801de9:	29 f9                	sub    %edi,%ecx
  801deb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801def:	89 14 24             	mov    %edx,(%esp)
  801df2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801df6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dfa:	8b 14 24             	mov    (%esp),%edx
  801dfd:	83 c4 1c             	add    $0x1c,%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5e                   	pop    %esi
  801e02:	5f                   	pop    %edi
  801e03:	5d                   	pop    %ebp
  801e04:	c3                   	ret    
  801e05:	8d 76 00             	lea    0x0(%esi),%esi
  801e08:	2b 04 24             	sub    (%esp),%eax
  801e0b:	19 fa                	sbb    %edi,%edx
  801e0d:	89 d1                	mov    %edx,%ecx
  801e0f:	89 c6                	mov    %eax,%esi
  801e11:	e9 71 ff ff ff       	jmp    801d87 <__umoddi3+0xb3>
  801e16:	66 90                	xchg   %ax,%ax
  801e18:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e1c:	72 ea                	jb     801e08 <__umoddi3+0x134>
  801e1e:	89 d9                	mov    %ebx,%ecx
  801e20:	e9 62 ff ff ff       	jmp    801d87 <__umoddi3+0xb3>
