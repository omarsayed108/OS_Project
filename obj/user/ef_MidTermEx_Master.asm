
obj/user/ef_MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 8b 02 00 00       	call   8002c1 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 00 39 80 00       	push   $0x803900
  800050:	e8 f5 1f 00 00       	call   80204a <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*X = 5 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	//cprintf("Do you want to use semaphore (y/n)? ") ;
	//char select = getchar() ;
	char select = 'y';
  800064:	c6 45 e3 79          	movb   $0x79,-0x1d(%ebp)
	//cputchar(select);
	//cputchar('\n');

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	6a 04                	push   $0x4
  80006f:	68 02 39 80 00       	push   $0x803902
  800074:	e8 d1 1f 00 00       	call   80204a <smalloc>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	*useSem = 0 ;
  80007f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800082:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  800088:	80 7d e3 59          	cmpb   $0x59,-0x1d(%ebp)
  80008c:	74 06                	je     800094 <_main+0x5c>
  80008e:	80 7d e3 79          	cmpb   $0x79,-0x1d(%ebp)
  800092:	75 09                	jne    80009d <_main+0x65>
		*useSem = 1 ;
  800094:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800097:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	struct semaphore T, finished, finishedCountMutex ;
	int *numOfFinished ;
	//Create the check-finishing counter
	numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80009d:	83 ec 04             	sub    $0x4,%esp
  8000a0:	6a 01                	push   $0x1
  8000a2:	6a 04                	push   $0x4
  8000a4:	68 09 39 80 00       	push   $0x803909
  8000a9:	e8 9c 1f 00 00       	call   80204a <smalloc>
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
	*numOfFinished = 0 ;
  8000b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	if (*useSem == 1)
  8000bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000c0:	8b 00                	mov    (%eax),%eax
  8000c2:	83 f8 01             	cmp    $0x1,%eax
  8000c5:	75 42                	jne    800109 <_main+0xd1>
	{
		T = create_semaphore("T", 0);
  8000c7:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 00                	push   $0x0
  8000cf:	68 17 39 80 00       	push   $0x803917
  8000d4:	50                   	push   %eax
  8000d5:	e8 3e 35 00 00       	call   803618 <create_semaphore>
  8000da:	83 c4 0c             	add    $0xc,%esp
		finished = create_semaphore("finished", 0);
  8000dd:	8d 45 c0             	lea    -0x40(%ebp),%eax
  8000e0:	83 ec 04             	sub    $0x4,%esp
  8000e3:	6a 00                	push   $0x0
  8000e5:	68 19 39 80 00       	push   $0x803919
  8000ea:	50                   	push   %eax
  8000eb:	e8 28 35 00 00       	call   803618 <create_semaphore>
  8000f0:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = create_semaphore("finishedCountMutex", 1);
  8000f3:	8d 45 bc             	lea    -0x44(%ebp),%eax
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	6a 01                	push   $0x1
  8000fb:	68 22 39 80 00       	push   $0x803922
  800100:	50                   	push   %eax
  800101:	e8 12 35 00 00       	call   803618 <create_semaphore>
  800106:	83 c4 0c             	add    $0xc,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800109:	a1 20 50 80 00       	mov    0x805020,%eax
  80010e:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800114:	89 c2                	mov    %eax,%edx
  800116:	a1 20 50 80 00       	mov    0x805020,%eax
  80011b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800121:	6a 32                	push   $0x32
  800123:	52                   	push   %edx
  800124:	50                   	push   %eax
  800125:	68 35 39 80 00       	push   $0x803935
  80012a:	e8 97 24 00 00       	call   8025c6 <sys_create_env>
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800135:	a1 20 50 80 00       	mov    0x805020,%eax
  80013a:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800140:	89 c2                	mov    %eax,%edx
  800142:	a1 20 50 80 00       	mov    0x805020,%eax
  800147:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80014d:	6a 32                	push   $0x32
  80014f:	52                   	push   %edx
  800150:	50                   	push   %eax
  800151:	68 3f 39 80 00       	push   $0x80393f
  800156:	e8 6b 24 00 00       	call   8025c6 <sys_create_env>
  80015b:	83 c4 10             	add    $0x10,%esp
  80015e:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800161:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  800165:	74 06                	je     80016d <_main+0x135>
  800167:	83 7d d0 ef          	cmpl   $0xffffffef,-0x30(%ebp)
  80016b:	75 14                	jne    800181 <_main+0x149>
		panic("NO AVAILABLE ENVs...");
  80016d:	83 ec 04             	sub    $0x4,%esp
  800170:	68 49 39 80 00       	push   $0x803949
  800175:	6a 2b                	push   $0x2b
  800177:	68 5e 39 80 00       	push   $0x80395e
  80017c:	e8 f0 02 00 00       	call   800471 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	ff 75 d4             	pushl  -0x2c(%ebp)
  800187:	e8 58 24 00 00       	call   8025e4 <sys_run_env>
  80018c:	83 c4 10             	add    $0x10,%esp
	//env_sleep(10000);
	sys_run_env(envIdProcessB);
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	ff 75 d0             	pushl  -0x30(%ebp)
  800195:	e8 4a 24 00 00       	call   8025e4 <sys_run_env>
  80019a:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	if (*useSem == 1)
  80019d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001a0:	8b 00                	mov    (%eax),%eax
  8001a2:	83 f8 01             	cmp    $0x1,%eax
  8001a5:	75 1e                	jne    8001c5 <_main+0x18d>
	{
		wait_semaphore(finished);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 c0             	pushl  -0x40(%ebp)
  8001ad:	e8 9a 34 00 00       	call   80364c <wait_semaphore>
  8001b2:	83 c4 10             	add    $0x10,%esp
		wait_semaphore(finished);
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	ff 75 c0             	pushl  -0x40(%ebp)
  8001bb:	e8 8c 34 00 00       	call   80364c <wait_semaphore>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	eb 0b                	jmp    8001d0 <_main+0x198>
	}
	else
	{
		while (*numOfFinished != 2) ;
  8001c5:	90                   	nop
  8001c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001c9:	8b 00                	mov    (%eax),%eax
  8001cb:	83 f8 02             	cmp    $0x2,%eax
  8001ce:	75 f6                	jne    8001c6 <_main+0x18e>
	}

	/*[6] PRINT X*/
	atomic_cprintf("Final value of X = %d\n", *X);
  8001d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	83 ec 08             	sub    $0x8,%esp
  8001d8:	50                   	push   %eax
  8001d9:	68 79 39 80 00       	push   $0x803979
  8001de:	e8 ee 05 00 00       	call   8007d1 <atomic_cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp

	//ensure that X has the expected value (=11)
	if (*X != 11)
  8001e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	83 f8 0b             	cmp    $0xb,%eax
  8001ee:	74 14                	je     800204 <_main+0x1cc>
		panic("Final value of X is not correct. Semaphore and/or shared variables are not working correctly\n");
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	68 90 39 80 00       	push   $0x803990
  8001f8:	6a 42                	push   $0x42
  8001fa:	68 5e 39 80 00       	push   $0x80395e
  8001ff:	e8 6d 02 00 00       	call   800471 <_panic>

	int32 parentenvID = sys_getparentenvid();
  800204:	e8 44 24 00 00       	call   80264d <sys_getparentenvid>
  800209:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if(parentenvID > 0)
  80020c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800210:	0f 8e a2 00 00 00    	jle    8002b8 <_main+0x280>
	{
		//Get the check-finishing counter
		int *AllFinish = NULL;
  800216:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		AllFinish = sget(parentenvID, "finishedCount") ;
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	68 09 39 80 00       	push   $0x803909
  800225:	ff 75 cc             	pushl  -0x34(%ebp)
  800228:	e8 7d 1f 00 00       	call   8021aa <sget>
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	89 45 c8             	mov    %eax,-0x38(%ebp)

		//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
		//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
		//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
		//	2. changing the # free frames
		char changeIntCmd[100] = "__changeInterruptStatus__";
  800233:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800239:	bb ee 39 80 00       	mov    $0x8039ee,%ebx
  80023e:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800243:	89 c7                	mov    %eax,%edi
  800245:	89 de                	mov    %ebx,%esi
  800247:	89 d1                	mov    %edx,%ecx
  800249:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80024b:	8d 95 72 ff ff ff    	lea    -0x8e(%ebp),%edx
  800251:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800256:	b0 00                	mov    $0x0,%al
  800258:	89 d7                	mov    %edx,%edi
  80025a:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(changeIntCmd, 0);
  80025c:	83 ec 08             	sub    $0x8,%esp
  80025f:	6a 00                	push   $0x0
  800261:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800267:	50                   	push   %eax
  800268:	e8 fd 25 00 00       	call   80286a <sys_utilities>
  80026d:	83 c4 10             	add    $0x10,%esp
		{
			sys_destroy_env(envIdProcessA);
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	ff 75 d4             	pushl  -0x2c(%ebp)
  800276:	e8 85 23 00 00       	call   802600 <sys_destroy_env>
  80027b:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdProcessB);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 d0             	pushl  -0x30(%ebp)
  800284:	e8 77 23 00 00       	call   802600 <sys_destroy_env>
  800289:	83 c4 10             	add    $0x10,%esp
		}
		sys_utilities(changeIntCmd, 1);
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	6a 01                	push   $0x1
  800291:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800297:	50                   	push   %eax
  800298:	e8 cd 25 00 00       	call   80286a <sys_utilities>
  80029d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8002a0:	e8 16 21 00 00       	call   8023bb <sys_lock_cons>
		{
			(*AllFinish)++ ;
  8002a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002a8:	8b 00                	mov    (%eax),%eax
  8002aa:	8d 50 01             	lea    0x1(%eax),%edx
  8002ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002b0:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  8002b2:	e8 1e 21 00 00       	call   8023d5 <sys_unlock_cons>
	}

	return;
  8002b7:	90                   	nop
  8002b8:	90                   	nop
}
  8002b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bc:	5b                   	pop    %ebx
  8002bd:	5e                   	pop    %esi
  8002be:	5f                   	pop    %edi
  8002bf:	5d                   	pop    %ebp
  8002c0:	c3                   	ret    

008002c1 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	57                   	push   %edi
  8002c5:	56                   	push   %esi
  8002c6:	53                   	push   %ebx
  8002c7:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002ca:	e8 65 23 00 00       	call   802634 <sys_getenvindex>
  8002cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002d5:	89 d0                	mov    %edx,%eax
  8002d7:	01 c0                	add    %eax,%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c1 e0 02             	shl    $0x2,%eax
  8002de:	01 d0                	add    %edx,%eax
  8002e0:	c1 e0 02             	shl    $0x2,%eax
  8002e3:	01 d0                	add    %edx,%eax
  8002e5:	c1 e0 03             	shl    $0x3,%eax
  8002e8:	01 d0                	add    %edx,%eax
  8002ea:	c1 e0 02             	shl    $0x2,%eax
  8002ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f2:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002fc:	8a 40 20             	mov    0x20(%eax),%al
  8002ff:	84 c0                	test   %al,%al
  800301:	74 0d                	je     800310 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800303:	a1 20 50 80 00       	mov    0x805020,%eax
  800308:	83 c0 20             	add    $0x20,%eax
  80030b:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800310:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800314:	7e 0a                	jle    800320 <libmain+0x5f>
		binaryname = argv[0];
  800316:	8b 45 0c             	mov    0xc(%ebp),%eax
  800319:	8b 00                	mov    (%eax),%eax
  80031b:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	e8 0a fd ff ff       	call   800038 <_main>
  80032e:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800331:	a1 00 50 80 00       	mov    0x805000,%eax
  800336:	85 c0                	test   %eax,%eax
  800338:	0f 84 01 01 00 00    	je     80043f <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80033e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800344:	bb 4c 3b 80 00       	mov    $0x803b4c,%ebx
  800349:	ba 0e 00 00 00       	mov    $0xe,%edx
  80034e:	89 c7                	mov    %eax,%edi
  800350:	89 de                	mov    %ebx,%esi
  800352:	89 d1                	mov    %edx,%ecx
  800354:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800356:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800359:	b9 56 00 00 00       	mov    $0x56,%ecx
  80035e:	b0 00                	mov    $0x0,%al
  800360:	89 d7                	mov    %edx,%edi
  800362:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800364:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80036b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	50                   	push   %eax
  800372:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800378:	50                   	push   %eax
  800379:	e8 ec 24 00 00       	call   80286a <sys_utilities>
  80037e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800381:	e8 35 20 00 00       	call   8023bb <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 6c 3a 80 00       	push   $0x803a6c
  80038e:	e8 cc 03 00 00       	call   80075f <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800396:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800399:	85 c0                	test   %eax,%eax
  80039b:	74 18                	je     8003b5 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80039d:	e8 e6 24 00 00       	call   802888 <sys_get_optimal_num_faults>
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	50                   	push   %eax
  8003a6:	68 94 3a 80 00       	push   $0x803a94
  8003ab:	e8 af 03 00 00       	call   80075f <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
  8003b3:	eb 59                	jmp    80040e <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ba:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8003c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003c5:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	52                   	push   %edx
  8003cf:	50                   	push   %eax
  8003d0:	68 b8 3a 80 00       	push   $0x803ab8
  8003d5:	e8 85 03 00 00       	call   80075f <cprintf>
  8003da:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e2:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8003e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ed:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8003f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f8:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8003fe:	51                   	push   %ecx
  8003ff:	52                   	push   %edx
  800400:	50                   	push   %eax
  800401:	68 e0 3a 80 00       	push   $0x803ae0
  800406:	e8 54 03 00 00       	call   80075f <cprintf>
  80040b:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80040e:	a1 20 50 80 00       	mov    0x805020,%eax
  800413:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	50                   	push   %eax
  80041d:	68 38 3b 80 00       	push   $0x803b38
  800422:	e8 38 03 00 00       	call   80075f <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80042a:	83 ec 0c             	sub    $0xc,%esp
  80042d:	68 6c 3a 80 00       	push   $0x803a6c
  800432:	e8 28 03 00 00       	call   80075f <cprintf>
  800437:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80043a:	e8 96 1f 00 00       	call   8023d5 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80043f:	e8 1f 00 00 00       	call   800463 <exit>
}
  800444:	90                   	nop
  800445:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800448:	5b                   	pop    %ebx
  800449:	5e                   	pop    %esi
  80044a:	5f                   	pop    %edi
  80044b:	5d                   	pop    %ebp
  80044c:	c3                   	ret    

0080044d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	6a 00                	push   $0x0
  800458:	e8 a3 21 00 00       	call   802600 <sys_destroy_env>
  80045d:	83 c4 10             	add    $0x10,%esp
}
  800460:	90                   	nop
  800461:	c9                   	leave  
  800462:	c3                   	ret    

00800463 <exit>:

void
exit(void)
{
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800469:	e8 f8 21 00 00       	call   802666 <sys_exit_env>
}
  80046e:	90                   	nop
  80046f:	c9                   	leave  
  800470:	c3                   	ret    

00800471 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800477:	8d 45 10             	lea    0x10(%ebp),%eax
  80047a:	83 c0 04             	add    $0x4,%eax
  80047d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800480:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800485:	85 c0                	test   %eax,%eax
  800487:	74 16                	je     80049f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800489:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	50                   	push   %eax
  800492:	68 b0 3b 80 00       	push   $0x803bb0
  800497:	e8 c3 02 00 00       	call   80075f <cprintf>
  80049c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80049f:	a1 04 50 80 00       	mov    0x805004,%eax
  8004a4:	83 ec 0c             	sub    $0xc,%esp
  8004a7:	ff 75 0c             	pushl  0xc(%ebp)
  8004aa:	ff 75 08             	pushl  0x8(%ebp)
  8004ad:	50                   	push   %eax
  8004ae:	68 b8 3b 80 00       	push   $0x803bb8
  8004b3:	6a 74                	push   $0x74
  8004b5:	e8 d2 02 00 00       	call   80078c <cprintf_colored>
  8004ba:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8004c6:	50                   	push   %eax
  8004c7:	e8 24 02 00 00       	call   8006f0 <vcprintf>
  8004cc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	6a 00                	push   $0x0
  8004d4:	68 e0 3b 80 00       	push   $0x803be0
  8004d9:	e8 12 02 00 00       	call   8006f0 <vcprintf>
  8004de:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004e1:	e8 7d ff ff ff       	call   800463 <exit>

	// should not return here
	while (1) ;
  8004e6:	eb fe                	jmp    8004e6 <_panic+0x75>

008004e8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004e8:	55                   	push   %ebp
  8004e9:	89 e5                	mov    %esp,%ebp
  8004eb:	53                   	push   %ebx
  8004ec:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	39 c2                	cmp    %eax,%edx
  8004ff:	74 14                	je     800515 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800501:	83 ec 04             	sub    $0x4,%esp
  800504:	68 e4 3b 80 00       	push   $0x803be4
  800509:	6a 26                	push   $0x26
  80050b:	68 30 3c 80 00       	push   $0x803c30
  800510:	e8 5c ff ff ff       	call   800471 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800515:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80051c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800523:	e9 d9 00 00 00       	jmp    800601 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80052b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	01 d0                	add    %edx,%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	85 c0                	test   %eax,%eax
  80053b:	75 08                	jne    800545 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80053d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800540:	e9 b9 00 00 00       	jmp    8005fe <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800545:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80054c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800553:	eb 79                	jmp    8005ce <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800555:	a1 20 50 80 00       	mov    0x805020,%eax
  80055a:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800560:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800563:	89 d0                	mov    %edx,%eax
  800565:	01 c0                	add    %eax,%eax
  800567:	01 d0                	add    %edx,%eax
  800569:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800570:	01 d8                	add    %ebx,%eax
  800572:	01 d0                	add    %edx,%eax
  800574:	01 c8                	add    %ecx,%eax
  800576:	8a 40 04             	mov    0x4(%eax),%al
  800579:	84 c0                	test   %al,%al
  80057b:	75 4e                	jne    8005cb <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80057d:	a1 20 50 80 00       	mov    0x805020,%eax
  800582:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800588:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80058b:	89 d0                	mov    %edx,%eax
  80058d:	01 c0                	add    %eax,%eax
  80058f:	01 d0                	add    %edx,%eax
  800591:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800598:	01 d8                	add    %ebx,%eax
  80059a:	01 d0                	add    %edx,%eax
  80059c:	01 c8                	add    %ecx,%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ab:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005be:	39 c2                	cmp    %eax,%edx
  8005c0:	75 09                	jne    8005cb <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8005c2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005c9:	eb 19                	jmp    8005e4 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005cb:	ff 45 e8             	incl   -0x18(%ebp)
  8005ce:	a1 20 50 80 00       	mov    0x805020,%eax
  8005d3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005dc:	39 c2                	cmp    %eax,%edx
  8005de:	0f 87 71 ff ff ff    	ja     800555 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005e8:	75 14                	jne    8005fe <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8005ea:	83 ec 04             	sub    $0x4,%esp
  8005ed:	68 3c 3c 80 00       	push   $0x803c3c
  8005f2:	6a 3a                	push   $0x3a
  8005f4:	68 30 3c 80 00       	push   $0x803c30
  8005f9:	e8 73 fe ff ff       	call   800471 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005fe:	ff 45 f0             	incl   -0x10(%ebp)
  800601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800604:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800607:	0f 8c 1b ff ff ff    	jl     800528 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80060d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800614:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80061b:	eb 2e                	jmp    80064b <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80061d:	a1 20 50 80 00       	mov    0x805020,%eax
  800622:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800628:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062b:	89 d0                	mov    %edx,%eax
  80062d:	01 c0                	add    %eax,%eax
  80062f:	01 d0                	add    %edx,%eax
  800631:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800638:	01 d8                	add    %ebx,%eax
  80063a:	01 d0                	add    %edx,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8a 40 04             	mov    0x4(%eax),%al
  800641:	3c 01                	cmp    $0x1,%al
  800643:	75 03                	jne    800648 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800645:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800648:	ff 45 e0             	incl   -0x20(%ebp)
  80064b:	a1 20 50 80 00       	mov    0x805020,%eax
  800650:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800656:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800659:	39 c2                	cmp    %eax,%edx
  80065b:	77 c0                	ja     80061d <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80065d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800660:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800663:	74 14                	je     800679 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800665:	83 ec 04             	sub    $0x4,%esp
  800668:	68 90 3c 80 00       	push   $0x803c90
  80066d:	6a 44                	push   $0x44
  80066f:	68 30 3c 80 00       	push   $0x803c30
  800674:	e8 f8 fd ff ff       	call   800471 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800679:	90                   	nop
  80067a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067d:	c9                   	leave  
  80067e:	c3                   	ret    

0080067f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
  800682:	53                   	push   %ebx
  800683:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800686:	8b 45 0c             	mov    0xc(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	8d 48 01             	lea    0x1(%eax),%ecx
  80068e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800691:	89 0a                	mov    %ecx,(%edx)
  800693:	8b 55 08             	mov    0x8(%ebp),%edx
  800696:	88 d1                	mov    %dl,%cl
  800698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80069f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a9:	75 30                	jne    8006db <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006ab:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8006b1:	a0 44 50 80 00       	mov    0x805044,%al
  8006b6:	0f b6 c0             	movzbl %al,%eax
  8006b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006bc:	8b 09                	mov    (%ecx),%ecx
  8006be:	89 cb                	mov    %ecx,%ebx
  8006c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c3:	83 c1 08             	add    $0x8,%ecx
  8006c6:	52                   	push   %edx
  8006c7:	50                   	push   %eax
  8006c8:	53                   	push   %ebx
  8006c9:	51                   	push   %ecx
  8006ca:	e8 a8 1c 00 00       	call   802377 <sys_cputs>
  8006cf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006de:	8b 40 04             	mov    0x4(%eax),%eax
  8006e1:	8d 50 01             	lea    0x1(%eax),%edx
  8006e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ea:	90                   	nop
  8006eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ee:	c9                   	leave  
  8006ef:	c3                   	ret    

008006f0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800700:	00 00 00 
	b.cnt = 0;
  800703:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80070a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	ff 75 08             	pushl  0x8(%ebp)
  800713:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800719:	50                   	push   %eax
  80071a:	68 7f 06 80 00       	push   $0x80067f
  80071f:	e8 5a 02 00 00       	call   80097e <vprintfmt>
  800724:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800727:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  80072d:	a0 44 50 80 00       	mov    0x805044,%al
  800732:	0f b6 c0             	movzbl %al,%eax
  800735:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80073b:	52                   	push   %edx
  80073c:	50                   	push   %eax
  80073d:	51                   	push   %ecx
  80073e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800744:	83 c0 08             	add    $0x8,%eax
  800747:	50                   	push   %eax
  800748:	e8 2a 1c 00 00       	call   802377 <sys_cputs>
  80074d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800750:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800757:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80075d:	c9                   	leave  
  80075e:	c3                   	ret    

0080075f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800765:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  80076c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80076f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	ff 75 f4             	pushl  -0xc(%ebp)
  80077b:	50                   	push   %eax
  80077c:	e8 6f ff ff ff       	call   8006f0 <vcprintf>
  800781:	83 c4 10             	add    $0x10,%esp
  800784:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800787:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80078a:	c9                   	leave  
  80078b:	c3                   	ret    

0080078c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800792:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	c1 e0 08             	shl    $0x8,%eax
  80079f:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  8007a4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a7:	83 c0 04             	add    $0x4,%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b6:	50                   	push   %eax
  8007b7:	e8 34 ff ff ff       	call   8006f0 <vcprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007c2:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  8007c9:	07 00 00 

	return cnt;
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007cf:	c9                   	leave  
  8007d0:	c3                   	ret    

008007d1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007d7:	e8 df 1b 00 00       	call   8023bb <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007dc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007df:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007eb:	50                   	push   %eax
  8007ec:	e8 ff fe ff ff       	call   8006f0 <vcprintf>
  8007f1:	83 c4 10             	add    $0x10,%esp
  8007f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007f7:	e8 d9 1b 00 00       	call   8023d5 <sys_unlock_cons>
	return cnt;
  8007fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ff:	c9                   	leave  
  800800:	c3                   	ret    

00800801 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	53                   	push   %ebx
  800805:	83 ec 14             	sub    $0x14,%esp
  800808:	8b 45 10             	mov    0x10(%ebp),%eax
  80080b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080e:	8b 45 14             	mov    0x14(%ebp),%eax
  800811:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800814:	8b 45 18             	mov    0x18(%ebp),%eax
  800817:	ba 00 00 00 00       	mov    $0x0,%edx
  80081c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80081f:	77 55                	ja     800876 <printnum+0x75>
  800821:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800824:	72 05                	jb     80082b <printnum+0x2a>
  800826:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800829:	77 4b                	ja     800876 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80082b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80082e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800831:	8b 45 18             	mov    0x18(%ebp),%eax
  800834:	ba 00 00 00 00       	mov    $0x0,%edx
  800839:	52                   	push   %edx
  80083a:	50                   	push   %eax
  80083b:	ff 75 f4             	pushl  -0xc(%ebp)
  80083e:	ff 75 f0             	pushl  -0x10(%ebp)
  800841:	e8 46 2e 00 00       	call   80368c <__udivdi3>
  800846:	83 c4 10             	add    $0x10,%esp
  800849:	83 ec 04             	sub    $0x4,%esp
  80084c:	ff 75 20             	pushl  0x20(%ebp)
  80084f:	53                   	push   %ebx
  800850:	ff 75 18             	pushl  0x18(%ebp)
  800853:	52                   	push   %edx
  800854:	50                   	push   %eax
  800855:	ff 75 0c             	pushl  0xc(%ebp)
  800858:	ff 75 08             	pushl  0x8(%ebp)
  80085b:	e8 a1 ff ff ff       	call   800801 <printnum>
  800860:	83 c4 20             	add    $0x20,%esp
  800863:	eb 1a                	jmp    80087f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	ff 75 20             	pushl  0x20(%ebp)
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	ff d0                	call   *%eax
  800873:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800876:	ff 4d 1c             	decl   0x1c(%ebp)
  800879:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087d:	7f e6                	jg     800865 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80087f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800882:	bb 00 00 00 00       	mov    $0x0,%ebx
  800887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088d:	53                   	push   %ebx
  80088e:	51                   	push   %ecx
  80088f:	52                   	push   %edx
  800890:	50                   	push   %eax
  800891:	e8 06 2f 00 00       	call   80379c <__umoddi3>
  800896:	83 c4 10             	add    $0x10,%esp
  800899:	05 f4 3e 80 00       	add    $0x803ef4,%eax
  80089e:	8a 00                	mov    (%eax),%al
  8008a0:	0f be c0             	movsbl %al,%eax
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	ff 75 0c             	pushl  0xc(%ebp)
  8008a9:	50                   	push   %eax
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	ff d0                	call   *%eax
  8008af:	83 c4 10             	add    $0x10,%esp
}
  8008b2:	90                   	nop
  8008b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b6:	c9                   	leave  
  8008b7:	c3                   	ret    

008008b8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008bf:	7e 1c                	jle    8008dd <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	8d 50 08             	lea    0x8(%eax),%edx
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	89 10                	mov    %edx,(%eax)
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 e8 08             	sub    $0x8,%eax
  8008d6:	8b 50 04             	mov    0x4(%eax),%edx
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	eb 40                	jmp    80091d <getuint+0x65>
	else if (lflag)
  8008dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e1:	74 1e                	je     800901 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	8d 50 04             	lea    0x4(%eax),%edx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	89 10                	mov    %edx,(%eax)
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	83 e8 04             	sub    $0x4,%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ff:	eb 1c                	jmp    80091d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	8d 50 04             	lea    0x4(%eax),%edx
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	89 10                	mov    %edx,(%eax)
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	83 e8 04             	sub    $0x4,%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800922:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800926:	7e 1c                	jle    800944 <getint+0x25>
		return va_arg(*ap, long long);
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	8d 50 08             	lea    0x8(%eax),%edx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	89 10                	mov    %edx,(%eax)
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	83 e8 08             	sub    $0x8,%eax
  80093d:	8b 50 04             	mov    0x4(%eax),%edx
  800940:	8b 00                	mov    (%eax),%eax
  800942:	eb 38                	jmp    80097c <getint+0x5d>
	else if (lflag)
  800944:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800948:	74 1a                	je     800964 <getint+0x45>
		return va_arg(*ap, long);
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	8d 50 04             	lea    0x4(%eax),%edx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	89 10                	mov    %edx,(%eax)
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	83 e8 04             	sub    $0x4,%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	99                   	cltd   
  800962:	eb 18                	jmp    80097c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	8b 00                	mov    (%eax),%eax
  800969:	8d 50 04             	lea    0x4(%eax),%edx
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	89 10                	mov    %edx,(%eax)
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	8b 00                	mov    (%eax),%eax
  800976:	83 e8 04             	sub    $0x4,%eax
  800979:	8b 00                	mov    (%eax),%eax
  80097b:	99                   	cltd   
}
  80097c:	5d                   	pop    %ebp
  80097d:	c3                   	ret    

0080097e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	56                   	push   %esi
  800982:	53                   	push   %ebx
  800983:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800986:	eb 17                	jmp    80099f <vprintfmt+0x21>
			if (ch == '\0')
  800988:	85 db                	test   %ebx,%ebx
  80098a:	0f 84 c1 03 00 00    	je     800d51 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	ff 75 0c             	pushl  0xc(%ebp)
  800996:	53                   	push   %ebx
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	ff d0                	call   *%eax
  80099c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099f:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a2:	8d 50 01             	lea    0x1(%eax),%edx
  8009a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a8:	8a 00                	mov    (%eax),%al
  8009aa:	0f b6 d8             	movzbl %al,%ebx
  8009ad:	83 fb 25             	cmp    $0x25,%ebx
  8009b0:	75 d6                	jne    800988 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009cb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d5:	8d 50 01             	lea    0x1(%eax),%edx
  8009d8:	89 55 10             	mov    %edx,0x10(%ebp)
  8009db:	8a 00                	mov    (%eax),%al
  8009dd:	0f b6 d8             	movzbl %al,%ebx
  8009e0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e3:	83 f8 5b             	cmp    $0x5b,%eax
  8009e6:	0f 87 3d 03 00 00    	ja     800d29 <vprintfmt+0x3ab>
  8009ec:	8b 04 85 18 3f 80 00 	mov    0x803f18(,%eax,4),%eax
  8009f3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009f9:	eb d7                	jmp    8009d2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009fb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009ff:	eb d1                	jmp    8009d2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a01:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0b:	89 d0                	mov    %edx,%eax
  800a0d:	c1 e0 02             	shl    $0x2,%eax
  800a10:	01 d0                	add    %edx,%eax
  800a12:	01 c0                	add    %eax,%eax
  800a14:	01 d8                	add    %ebx,%eax
  800a16:	83 e8 30             	sub    $0x30,%eax
  800a19:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1f:	8a 00                	mov    (%eax),%al
  800a21:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a24:	83 fb 2f             	cmp    $0x2f,%ebx
  800a27:	7e 3e                	jle    800a67 <vprintfmt+0xe9>
  800a29:	83 fb 39             	cmp    $0x39,%ebx
  800a2c:	7f 39                	jg     800a67 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a2e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a31:	eb d5                	jmp    800a08 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a33:	8b 45 14             	mov    0x14(%ebp),%eax
  800a36:	83 c0 04             	add    $0x4,%eax
  800a39:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	83 e8 04             	sub    $0x4,%eax
  800a42:	8b 00                	mov    (%eax),%eax
  800a44:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a47:	eb 1f                	jmp    800a68 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4d:	79 83                	jns    8009d2 <vprintfmt+0x54>
				width = 0;
  800a4f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a56:	e9 77 ff ff ff       	jmp    8009d2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a5b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a62:	e9 6b ff ff ff       	jmp    8009d2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a67:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6c:	0f 89 60 ff ff ff    	jns    8009d2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a78:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a7f:	e9 4e ff ff ff       	jmp    8009d2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a84:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a87:	e9 46 ff ff ff       	jmp    8009d2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8f:	83 c0 04             	add    $0x4,%eax
  800a92:	89 45 14             	mov    %eax,0x14(%ebp)
  800a95:	8b 45 14             	mov    0x14(%ebp),%eax
  800a98:	83 e8 04             	sub    $0x4,%eax
  800a9b:	8b 00                	mov    (%eax),%eax
  800a9d:	83 ec 08             	sub    $0x8,%esp
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	50                   	push   %eax
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
			break;
  800aac:	e9 9b 02 00 00       	jmp    800d4c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab4:	83 c0 04             	add    $0x4,%eax
  800ab7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aba:	8b 45 14             	mov    0x14(%ebp),%eax
  800abd:	83 e8 04             	sub    $0x4,%eax
  800ac0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac2:	85 db                	test   %ebx,%ebx
  800ac4:	79 02                	jns    800ac8 <vprintfmt+0x14a>
				err = -err;
  800ac6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ac8:	83 fb 64             	cmp    $0x64,%ebx
  800acb:	7f 0b                	jg     800ad8 <vprintfmt+0x15a>
  800acd:	8b 34 9d 60 3d 80 00 	mov    0x803d60(,%ebx,4),%esi
  800ad4:	85 f6                	test   %esi,%esi
  800ad6:	75 19                	jne    800af1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ad8:	53                   	push   %ebx
  800ad9:	68 05 3f 80 00       	push   $0x803f05
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	ff 75 08             	pushl  0x8(%ebp)
  800ae4:	e8 70 02 00 00       	call   800d59 <printfmt>
  800ae9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aec:	e9 5b 02 00 00       	jmp    800d4c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af1:	56                   	push   %esi
  800af2:	68 0e 3f 80 00       	push   $0x803f0e
  800af7:	ff 75 0c             	pushl  0xc(%ebp)
  800afa:	ff 75 08             	pushl  0x8(%ebp)
  800afd:	e8 57 02 00 00       	call   800d59 <printfmt>
  800b02:	83 c4 10             	add    $0x10,%esp
			break;
  800b05:	e9 42 02 00 00       	jmp    800d4c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0d:	83 c0 04             	add    $0x4,%eax
  800b10:	89 45 14             	mov    %eax,0x14(%ebp)
  800b13:	8b 45 14             	mov    0x14(%ebp),%eax
  800b16:	83 e8 04             	sub    $0x4,%eax
  800b19:	8b 30                	mov    (%eax),%esi
  800b1b:	85 f6                	test   %esi,%esi
  800b1d:	75 05                	jne    800b24 <vprintfmt+0x1a6>
				p = "(null)";
  800b1f:	be 11 3f 80 00       	mov    $0x803f11,%esi
			if (width > 0 && padc != '-')
  800b24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b28:	7e 6d                	jle    800b97 <vprintfmt+0x219>
  800b2a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b2e:	74 67                	je     800b97 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	50                   	push   %eax
  800b37:	56                   	push   %esi
  800b38:	e8 1e 03 00 00       	call   800e5b <strnlen>
  800b3d:	83 c4 10             	add    $0x10,%esp
  800b40:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b43:	eb 16                	jmp    800b5b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b45:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	50                   	push   %eax
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b58:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b5f:	7f e4                	jg     800b45 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b61:	eb 34                	jmp    800b97 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b63:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b67:	74 1c                	je     800b85 <vprintfmt+0x207>
  800b69:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6c:	7e 05                	jle    800b73 <vprintfmt+0x1f5>
  800b6e:	83 fb 7e             	cmp    $0x7e,%ebx
  800b71:	7e 12                	jle    800b85 <vprintfmt+0x207>
					putch('?', putdat);
  800b73:	83 ec 08             	sub    $0x8,%esp
  800b76:	ff 75 0c             	pushl  0xc(%ebp)
  800b79:	6a 3f                	push   $0x3f
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	ff d0                	call   *%eax
  800b80:	83 c4 10             	add    $0x10,%esp
  800b83:	eb 0f                	jmp    800b94 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b85:	83 ec 08             	sub    $0x8,%esp
  800b88:	ff 75 0c             	pushl  0xc(%ebp)
  800b8b:	53                   	push   %ebx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	ff d0                	call   *%eax
  800b91:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b94:	ff 4d e4             	decl   -0x1c(%ebp)
  800b97:	89 f0                	mov    %esi,%eax
  800b99:	8d 70 01             	lea    0x1(%eax),%esi
  800b9c:	8a 00                	mov    (%eax),%al
  800b9e:	0f be d8             	movsbl %al,%ebx
  800ba1:	85 db                	test   %ebx,%ebx
  800ba3:	74 24                	je     800bc9 <vprintfmt+0x24b>
  800ba5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba9:	78 b8                	js     800b63 <vprintfmt+0x1e5>
  800bab:	ff 4d e0             	decl   -0x20(%ebp)
  800bae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb2:	79 af                	jns    800b63 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb4:	eb 13                	jmp    800bc9 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb6:	83 ec 08             	sub    $0x8,%esp
  800bb9:	ff 75 0c             	pushl  0xc(%ebp)
  800bbc:	6a 20                	push   $0x20
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	ff d0                	call   *%eax
  800bc3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc6:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcd:	7f e7                	jg     800bb6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bcf:	e9 78 01 00 00       	jmp    800d4c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd4:	83 ec 08             	sub    $0x8,%esp
  800bd7:	ff 75 e8             	pushl  -0x18(%ebp)
  800bda:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdd:	50                   	push   %eax
  800bde:	e8 3c fd ff ff       	call   80091f <getint>
  800be3:	83 c4 10             	add    $0x10,%esp
  800be6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf2:	85 d2                	test   %edx,%edx
  800bf4:	79 23                	jns    800c19 <vprintfmt+0x29b>
				putch('-', putdat);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	6a 2d                	push   $0x2d
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0c:	f7 d8                	neg    %eax
  800c0e:	83 d2 00             	adc    $0x0,%edx
  800c11:	f7 da                	neg    %edx
  800c13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c16:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c19:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c20:	e9 bc 00 00 00       	jmp    800ce1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c25:	83 ec 08             	sub    $0x8,%esp
  800c28:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2b:	8d 45 14             	lea    0x14(%ebp),%eax
  800c2e:	50                   	push   %eax
  800c2f:	e8 84 fc ff ff       	call   8008b8 <getuint>
  800c34:	83 c4 10             	add    $0x10,%esp
  800c37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c44:	e9 98 00 00 00       	jmp    800ce1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c49:	83 ec 08             	sub    $0x8,%esp
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	6a 58                	push   $0x58
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	ff d0                	call   *%eax
  800c56:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c59:	83 ec 08             	sub    $0x8,%esp
  800c5c:	ff 75 0c             	pushl  0xc(%ebp)
  800c5f:	6a 58                	push   $0x58
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	ff d0                	call   *%eax
  800c66:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c69:	83 ec 08             	sub    $0x8,%esp
  800c6c:	ff 75 0c             	pushl  0xc(%ebp)
  800c6f:	6a 58                	push   $0x58
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	ff d0                	call   *%eax
  800c76:	83 c4 10             	add    $0x10,%esp
			break;
  800c79:	e9 ce 00 00 00       	jmp    800d4c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	6a 30                	push   $0x30
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	ff d0                	call   *%eax
  800c8b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	6a 78                	push   $0x78
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	ff d0                	call   *%eax
  800c9b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca1:	83 c0 04             	add    $0x4,%eax
  800ca4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  800caa:	83 e8 04             	sub    $0x4,%eax
  800cad:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc0:	eb 1f                	jmp    800ce1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc2:	83 ec 08             	sub    $0x8,%esp
  800cc5:	ff 75 e8             	pushl  -0x18(%ebp)
  800cc8:	8d 45 14             	lea    0x14(%ebp),%eax
  800ccb:	50                   	push   %eax
  800ccc:	e8 e7 fb ff ff       	call   8008b8 <getuint>
  800cd1:	83 c4 10             	add    $0x10,%esp
  800cd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cda:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce8:	83 ec 04             	sub    $0x4,%esp
  800ceb:	52                   	push   %edx
  800cec:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cef:	50                   	push   %eax
  800cf0:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf3:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	ff 75 08             	pushl  0x8(%ebp)
  800cfc:	e8 00 fb ff ff       	call   800801 <printnum>
  800d01:	83 c4 20             	add    $0x20,%esp
			break;
  800d04:	eb 46                	jmp    800d4c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d06:	83 ec 08             	sub    $0x8,%esp
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	53                   	push   %ebx
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	ff d0                	call   *%eax
  800d12:	83 c4 10             	add    $0x10,%esp
			break;
  800d15:	eb 35                	jmp    800d4c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d17:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800d1e:	eb 2c                	jmp    800d4c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d20:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800d27:	eb 23                	jmp    800d4c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d29:	83 ec 08             	sub    $0x8,%esp
  800d2c:	ff 75 0c             	pushl  0xc(%ebp)
  800d2f:	6a 25                	push   $0x25
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	ff d0                	call   *%eax
  800d36:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d39:	ff 4d 10             	decl   0x10(%ebp)
  800d3c:	eb 03                	jmp    800d41 <vprintfmt+0x3c3>
  800d3e:	ff 4d 10             	decl   0x10(%ebp)
  800d41:	8b 45 10             	mov    0x10(%ebp),%eax
  800d44:	48                   	dec    %eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	3c 25                	cmp    $0x25,%al
  800d49:	75 f3                	jne    800d3e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d4b:	90                   	nop
		}
	}
  800d4c:	e9 35 fc ff ff       	jmp    800986 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d51:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d5f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d62:	83 c0 04             	add    $0x4,%eax
  800d65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d68:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d6e:	50                   	push   %eax
  800d6f:	ff 75 0c             	pushl  0xc(%ebp)
  800d72:	ff 75 08             	pushl  0x8(%ebp)
  800d75:	e8 04 fc ff ff       	call   80097e <vprintfmt>
  800d7a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d7d:	90                   	nop
  800d7e:	c9                   	leave  
  800d7f:	c3                   	ret    

00800d80 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	8b 40 08             	mov    0x8(%eax),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8b 10                	mov    (%eax),%edx
  800d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9a:	8b 40 04             	mov    0x4(%eax),%eax
  800d9d:	39 c2                	cmp    %eax,%edx
  800d9f:	73 12                	jae    800db3 <sprintputch+0x33>
		*b->buf++ = ch;
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	8b 00                	mov    (%eax),%eax
  800da6:	8d 48 01             	lea    0x1(%eax),%ecx
  800da9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dac:	89 0a                	mov    %ecx,(%edx)
  800dae:	8b 55 08             	mov    0x8(%ebp),%edx
  800db1:	88 10                	mov    %dl,(%eax)
}
  800db3:	90                   	nop
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    

00800db6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	01 d0                	add    %edx,%eax
  800dcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ddb:	74 06                	je     800de3 <vsnprintf+0x2d>
  800ddd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de1:	7f 07                	jg     800dea <vsnprintf+0x34>
		return -E_INVAL;
  800de3:	b8 03 00 00 00       	mov    $0x3,%eax
  800de8:	eb 20                	jmp    800e0a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dea:	ff 75 14             	pushl  0x14(%ebp)
  800ded:	ff 75 10             	pushl  0x10(%ebp)
  800df0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800df3:	50                   	push   %eax
  800df4:	68 80 0d 80 00       	push   $0x800d80
  800df9:	e8 80 fb ff ff       	call   80097e <vprintfmt>
  800dfe:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e04:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e12:	8d 45 10             	lea    0x10(%ebp),%eax
  800e15:	83 c0 04             	add    $0x4,%eax
  800e18:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e21:	50                   	push   %eax
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	ff 75 08             	pushl  0x8(%ebp)
  800e28:	e8 89 ff ff ff       	call   800db6 <vsnprintf>
  800e2d:	83 c4 10             	add    $0x10,%esp
  800e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e36:	c9                   	leave  
  800e37:	c3                   	ret    

00800e38 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e45:	eb 06                	jmp    800e4d <strlen+0x15>
		n++;
  800e47:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e4a:	ff 45 08             	incl   0x8(%ebp)
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	84 c0                	test   %al,%al
  800e54:	75 f1                	jne    800e47 <strlen+0xf>
		n++;
	return n;
  800e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e68:	eb 09                	jmp    800e73 <strnlen+0x18>
		n++;
  800e6a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6d:	ff 45 08             	incl   0x8(%ebp)
  800e70:	ff 4d 0c             	decl   0xc(%ebp)
  800e73:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e77:	74 09                	je     800e82 <strnlen+0x27>
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	8a 00                	mov    (%eax),%al
  800e7e:	84 c0                	test   %al,%al
  800e80:	75 e8                	jne    800e6a <strnlen+0xf>
		n++;
	return n;
  800e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e85:	c9                   	leave  
  800e86:	c3                   	ret    

00800e87 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e93:	90                   	nop
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8d 50 01             	lea    0x1(%eax),%edx
  800e9a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea6:	8a 12                	mov    (%edx),%dl
  800ea8:	88 10                	mov    %dl,(%eax)
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	84 c0                	test   %al,%al
  800eae:	75 e4                	jne    800e94 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb3:	c9                   	leave  
  800eb4:	c3                   	ret    

00800eb5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ec1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec8:	eb 1f                	jmp    800ee9 <strncpy+0x34>
		*dst++ = *src;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8d 50 01             	lea    0x1(%eax),%edx
  800ed0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed6:	8a 12                	mov    (%edx),%dl
  800ed8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	84 c0                	test   %al,%al
  800ee1:	74 03                	je     800ee6 <strncpy+0x31>
			src++;
  800ee3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ee6:	ff 45 fc             	incl   -0x4(%ebp)
  800ee9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eec:	3b 45 10             	cmp    0x10(%ebp),%eax
  800eef:	72 d9                	jb     800eca <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ef1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ef4:	c9                   	leave  
  800ef5:	c3                   	ret    

00800ef6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f06:	74 30                	je     800f38 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f08:	eb 16                	jmp    800f20 <strlcpy+0x2a>
			*dst++ = *src++;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8d 50 01             	lea    0x1(%eax),%edx
  800f10:	89 55 08             	mov    %edx,0x8(%ebp)
  800f13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f19:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f1c:	8a 12                	mov    (%edx),%dl
  800f1e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f20:	ff 4d 10             	decl   0x10(%ebp)
  800f23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f27:	74 09                	je     800f32 <strlcpy+0x3c>
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	84 c0                	test   %al,%al
  800f30:	75 d8                	jne    800f0a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f38:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3e:	29 c2                	sub    %eax,%edx
  800f40:	89 d0                	mov    %edx,%eax
}
  800f42:	c9                   	leave  
  800f43:	c3                   	ret    

00800f44 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f47:	eb 06                	jmp    800f4f <strcmp+0xb>
		p++, q++;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	84 c0                	test   %al,%al
  800f56:	74 0e                	je     800f66 <strcmp+0x22>
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	8a 10                	mov    (%eax),%dl
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	8a 00                	mov    (%eax),%al
  800f62:	38 c2                	cmp    %al,%dl
  800f64:	74 e3                	je     800f49 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	0f b6 d0             	movzbl %al,%edx
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	0f b6 c0             	movzbl %al,%eax
  800f76:	29 c2                	sub    %eax,%edx
  800f78:	89 d0                	mov    %edx,%eax
}
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f7f:	eb 09                	jmp    800f8a <strncmp+0xe>
		n--, p++, q++;
  800f81:	ff 4d 10             	decl   0x10(%ebp)
  800f84:	ff 45 08             	incl   0x8(%ebp)
  800f87:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8e:	74 17                	je     800fa7 <strncmp+0x2b>
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	84 c0                	test   %al,%al
  800f97:	74 0e                	je     800fa7 <strncmp+0x2b>
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8a 10                	mov    (%eax),%dl
  800f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	38 c2                	cmp    %al,%dl
  800fa5:	74 da                	je     800f81 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fa7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fab:	75 07                	jne    800fb4 <strncmp+0x38>
		return 0;
  800fad:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb2:	eb 14                	jmp    800fc8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f b6 d0             	movzbl %al,%edx
  800fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	0f b6 c0             	movzbl %al,%eax
  800fc4:	29 c2                	sub    %eax,%edx
  800fc6:	89 d0                	mov    %edx,%eax
}
  800fc8:	5d                   	pop    %ebp
  800fc9:	c3                   	ret    

00800fca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	83 ec 04             	sub    $0x4,%esp
  800fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd6:	eb 12                	jmp    800fea <strchr+0x20>
		if (*s == c)
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe0:	75 05                	jne    800fe7 <strchr+0x1d>
			return (char *) s;
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	eb 11                	jmp    800ff8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fe7:	ff 45 08             	incl   0x8(%ebp)
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	84 c0                	test   %al,%al
  800ff1:	75 e5                	jne    800fd8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ff3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff8:	c9                   	leave  
  800ff9:	c3                   	ret    

00800ffa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 04             	sub    $0x4,%esp
  801000:	8b 45 0c             	mov    0xc(%ebp),%eax
  801003:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801006:	eb 0d                	jmp    801015 <strfind+0x1b>
		if (*s == c)
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	8a 00                	mov    (%eax),%al
  80100d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801010:	74 0e                	je     801020 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801012:	ff 45 08             	incl   0x8(%ebp)
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	84 c0                	test   %al,%al
  80101c:	75 ea                	jne    801008 <strfind+0xe>
  80101e:	eb 01                	jmp    801021 <strfind+0x27>
		if (*s == c)
			break;
  801020:	90                   	nop
	return (char *) s;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801032:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801036:	76 63                	jbe    80109b <memset+0x75>
		uint64 data_block = c;
  801038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103b:	99                   	cltd   
  80103c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801045:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801048:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80104c:	c1 e0 08             	shl    $0x8,%eax
  80104f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801052:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801055:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801058:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80105f:	c1 e0 10             	shl    $0x10,%eax
  801062:	09 45 f0             	or     %eax,-0x10(%ebp)
  801065:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801068:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80106e:	89 c2                	mov    %eax,%edx
  801070:	b8 00 00 00 00       	mov    $0x0,%eax
  801075:	09 45 f0             	or     %eax,-0x10(%ebp)
  801078:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80107b:	eb 18                	jmp    801095 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80107d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801080:	8d 41 08             	lea    0x8(%ecx),%eax
  801083:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801086:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801089:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108c:	89 01                	mov    %eax,(%ecx)
  80108e:	89 51 04             	mov    %edx,0x4(%ecx)
  801091:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801095:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801099:	77 e2                	ja     80107d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80109b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109f:	74 23                	je     8010c4 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010a7:	eb 0e                	jmp    8010b7 <memset+0x91>
			*p8++ = (uint8)c;
  8010a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ac:	8d 50 01             	lea    0x1(%eax),%edx
  8010af:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b5:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ba:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c0:	85 c0                	test   %eax,%eax
  8010c2:	75 e5                	jne    8010a9 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c7:	c9                   	leave  
  8010c8:	c3                   	ret    

008010c9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010db:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010df:	76 24                	jbe    801105 <memcpy+0x3c>
		while(n >= 8){
  8010e1:	eb 1c                	jmp    8010ff <memcpy+0x36>
			*d64 = *s64;
  8010e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e6:	8b 50 04             	mov    0x4(%eax),%edx
  8010e9:	8b 00                	mov    (%eax),%eax
  8010eb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ee:	89 01                	mov    %eax,(%ecx)
  8010f0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010f3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010f7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010fb:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010ff:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801103:	77 de                	ja     8010e3 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801105:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801109:	74 31                	je     80113c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80110b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801111:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801114:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801117:	eb 16                	jmp    80112f <memcpy+0x66>
			*d8++ = *s8++;
  801119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111c:	8d 50 01             	lea    0x1(%eax),%edx
  80111f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801122:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801125:	8d 4a 01             	lea    0x1(%edx),%ecx
  801128:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80112b:	8a 12                	mov    (%edx),%dl
  80112d:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80112f:	8b 45 10             	mov    0x10(%ebp),%eax
  801132:	8d 50 ff             	lea    -0x1(%eax),%edx
  801135:	89 55 10             	mov    %edx,0x10(%ebp)
  801138:	85 c0                	test   %eax,%eax
  80113a:	75 dd                	jne    801119 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801153:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801156:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801159:	73 50                	jae    8011ab <memmove+0x6a>
  80115b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115e:	8b 45 10             	mov    0x10(%ebp),%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801166:	76 43                	jbe    8011ab <memmove+0x6a>
		s += n;
  801168:	8b 45 10             	mov    0x10(%ebp),%eax
  80116b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80116e:	8b 45 10             	mov    0x10(%ebp),%eax
  801171:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801174:	eb 10                	jmp    801186 <memmove+0x45>
			*--d = *--s;
  801176:	ff 4d f8             	decl   -0x8(%ebp)
  801179:	ff 4d fc             	decl   -0x4(%ebp)
  80117c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117f:	8a 10                	mov    (%eax),%dl
  801181:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801184:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801186:	8b 45 10             	mov    0x10(%ebp),%eax
  801189:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118c:	89 55 10             	mov    %edx,0x10(%ebp)
  80118f:	85 c0                	test   %eax,%eax
  801191:	75 e3                	jne    801176 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801193:	eb 23                	jmp    8011b8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801195:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801198:	8d 50 01             	lea    0x1(%eax),%edx
  80119b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a7:	8a 12                	mov    (%edx),%dl
  8011a9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	75 dd                	jne    801195 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011cf:	eb 2a                	jmp    8011fb <memcmp+0x3e>
		if (*s1 != *s2)
  8011d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d4:	8a 10                	mov    (%eax),%dl
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	38 c2                	cmp    %al,%dl
  8011dd:	74 16                	je     8011f5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e2:	8a 00                	mov    (%eax),%al
  8011e4:	0f b6 d0             	movzbl %al,%edx
  8011e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	0f b6 c0             	movzbl %al,%eax
  8011ef:	29 c2                	sub    %eax,%edx
  8011f1:	89 d0                	mov    %edx,%eax
  8011f3:	eb 18                	jmp    80120d <memcmp+0x50>
		s1++, s2++;
  8011f5:	ff 45 fc             	incl   -0x4(%ebp)
  8011f8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  801201:	89 55 10             	mov    %edx,0x10(%ebp)
  801204:	85 c0                	test   %eax,%eax
  801206:	75 c9                	jne    8011d1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801208:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120d:	c9                   	leave  
  80120e:	c3                   	ret    

0080120f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801215:	8b 55 08             	mov    0x8(%ebp),%edx
  801218:	8b 45 10             	mov    0x10(%ebp),%eax
  80121b:	01 d0                	add    %edx,%eax
  80121d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801220:	eb 15                	jmp    801237 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	0f b6 d0             	movzbl %al,%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	0f b6 c0             	movzbl %al,%eax
  801230:	39 c2                	cmp    %eax,%edx
  801232:	74 0d                	je     801241 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801234:	ff 45 08             	incl   0x8(%ebp)
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80123d:	72 e3                	jb     801222 <memfind+0x13>
  80123f:	eb 01                	jmp    801242 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801241:	90                   	nop
	return (void *) s;
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801245:	c9                   	leave  
  801246:	c3                   	ret    

00801247 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
  80124a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80124d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801254:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125b:	eb 03                	jmp    801260 <strtol+0x19>
		s++;
  80125d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	3c 20                	cmp    $0x20,%al
  801267:	74 f4                	je     80125d <strtol+0x16>
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	3c 09                	cmp    $0x9,%al
  801270:	74 eb                	je     80125d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	3c 2b                	cmp    $0x2b,%al
  801279:	75 05                	jne    801280 <strtol+0x39>
		s++;
  80127b:	ff 45 08             	incl   0x8(%ebp)
  80127e:	eb 13                	jmp    801293 <strtol+0x4c>
	else if (*s == '-')
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	3c 2d                	cmp    $0x2d,%al
  801287:	75 0a                	jne    801293 <strtol+0x4c>
		s++, neg = 1;
  801289:	ff 45 08             	incl   0x8(%ebp)
  80128c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801293:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801297:	74 06                	je     80129f <strtol+0x58>
  801299:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80129d:	75 20                	jne    8012bf <strtol+0x78>
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	3c 30                	cmp    $0x30,%al
  8012a6:	75 17                	jne    8012bf <strtol+0x78>
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	40                   	inc    %eax
  8012ac:	8a 00                	mov    (%eax),%al
  8012ae:	3c 78                	cmp    $0x78,%al
  8012b0:	75 0d                	jne    8012bf <strtol+0x78>
		s += 2, base = 16;
  8012b2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012b6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012bd:	eb 28                	jmp    8012e7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c3:	75 15                	jne    8012da <strtol+0x93>
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	8a 00                	mov    (%eax),%al
  8012ca:	3c 30                	cmp    $0x30,%al
  8012cc:	75 0c                	jne    8012da <strtol+0x93>
		s++, base = 8;
  8012ce:	ff 45 08             	incl   0x8(%ebp)
  8012d1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012d8:	eb 0d                	jmp    8012e7 <strtol+0xa0>
	else if (base == 0)
  8012da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012de:	75 07                	jne    8012e7 <strtol+0xa0>
		base = 10;
  8012e0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	3c 2f                	cmp    $0x2f,%al
  8012ee:	7e 19                	jle    801309 <strtol+0xc2>
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	8a 00                	mov    (%eax),%al
  8012f5:	3c 39                	cmp    $0x39,%al
  8012f7:	7f 10                	jg     801309 <strtol+0xc2>
			dig = *s - '0';
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	8a 00                	mov    (%eax),%al
  8012fe:	0f be c0             	movsbl %al,%eax
  801301:	83 e8 30             	sub    $0x30,%eax
  801304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801307:	eb 42                	jmp    80134b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	3c 60                	cmp    $0x60,%al
  801310:	7e 19                	jle    80132b <strtol+0xe4>
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	3c 7a                	cmp    $0x7a,%al
  801319:	7f 10                	jg     80132b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	8a 00                	mov    (%eax),%al
  801320:	0f be c0             	movsbl %al,%eax
  801323:	83 e8 57             	sub    $0x57,%eax
  801326:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801329:	eb 20                	jmp    80134b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8a 00                	mov    (%eax),%al
  801330:	3c 40                	cmp    $0x40,%al
  801332:	7e 39                	jle    80136d <strtol+0x126>
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	3c 5a                	cmp    $0x5a,%al
  80133b:	7f 30                	jg     80136d <strtol+0x126>
			dig = *s - 'A' + 10;
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	0f be c0             	movsbl %al,%eax
  801345:	83 e8 37             	sub    $0x37,%eax
  801348:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80134b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801351:	7d 19                	jge    80136c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801353:	ff 45 08             	incl   0x8(%ebp)
  801356:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801359:	0f af 45 10          	imul   0x10(%ebp),%eax
  80135d:	89 c2                	mov    %eax,%edx
  80135f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801362:	01 d0                	add    %edx,%eax
  801364:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801367:	e9 7b ff ff ff       	jmp    8012e7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80136c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80136d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801371:	74 08                	je     80137b <strtol+0x134>
		*endptr = (char *) s;
  801373:	8b 45 0c             	mov    0xc(%ebp),%eax
  801376:	8b 55 08             	mov    0x8(%ebp),%edx
  801379:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80137b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80137f:	74 07                	je     801388 <strtol+0x141>
  801381:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801384:	f7 d8                	neg    %eax
  801386:	eb 03                	jmp    80138b <strtol+0x144>
  801388:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    

0080138d <ltostr>:

void
ltostr(long value, char *str)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801393:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80139a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a5:	79 13                	jns    8013ba <ltostr+0x2d>
	{
		neg = 1;
  8013a7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013b4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013b7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013c2:	99                   	cltd   
  8013c3:	f7 f9                	idiv   %ecx
  8013c5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cb:	8d 50 01             	lea    0x1(%eax),%edx
  8013ce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013d1:	89 c2                	mov    %eax,%edx
  8013d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d6:	01 d0                	add    %edx,%eax
  8013d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013db:	83 c2 30             	add    $0x30,%edx
  8013de:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e8:	f7 e9                	imul   %ecx
  8013ea:	c1 fa 02             	sar    $0x2,%edx
  8013ed:	89 c8                	mov    %ecx,%eax
  8013ef:	c1 f8 1f             	sar    $0x1f,%eax
  8013f2:	29 c2                	sub    %eax,%edx
  8013f4:	89 d0                	mov    %edx,%eax
  8013f6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013fd:	75 bb                	jne    8013ba <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801406:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801409:	48                   	dec    %eax
  80140a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80140d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801411:	74 3d                	je     801450 <ltostr+0xc3>
		start = 1 ;
  801413:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80141a:	eb 34                	jmp    801450 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80141c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801422:	01 d0                	add    %edx,%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801429:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142f:	01 c2                	add    %eax,%edx
  801431:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801434:	8b 45 0c             	mov    0xc(%ebp),%eax
  801437:	01 c8                	add    %ecx,%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80143d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	01 c2                	add    %eax,%edx
  801445:	8a 45 eb             	mov    -0x15(%ebp),%al
  801448:	88 02                	mov    %al,(%edx)
		start++ ;
  80144a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80144d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801453:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801456:	7c c4                	jl     80141c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801458:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80145b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145e:	01 d0                	add    %edx,%eax
  801460:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801463:	90                   	nop
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80146c:	ff 75 08             	pushl  0x8(%ebp)
  80146f:	e8 c4 f9 ff ff       	call   800e38 <strlen>
  801474:	83 c4 04             	add    $0x4,%esp
  801477:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80147a:	ff 75 0c             	pushl  0xc(%ebp)
  80147d:	e8 b6 f9 ff ff       	call   800e38 <strlen>
  801482:	83 c4 04             	add    $0x4,%esp
  801485:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801488:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80148f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801496:	eb 17                	jmp    8014af <strcconcat+0x49>
		final[s] = str1[s] ;
  801498:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149b:	8b 45 10             	mov    0x10(%ebp),%eax
  80149e:	01 c2                	add    %eax,%edx
  8014a0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	01 c8                	add    %ecx,%eax
  8014a8:	8a 00                	mov    (%eax),%al
  8014aa:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014ac:	ff 45 fc             	incl   -0x4(%ebp)
  8014af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014b5:	7c e1                	jl     801498 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014c5:	eb 1f                	jmp    8014e6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ca:	8d 50 01             	lea    0x1(%eax),%edx
  8014cd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d0:	89 c2                	mov    %eax,%edx
  8014d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d5:	01 c2                	add    %eax,%edx
  8014d7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dd:	01 c8                	add    %ecx,%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014e3:	ff 45 f8             	incl   -0x8(%ebp)
  8014e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014ec:	7c d9                	jl     8014c7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f4:	01 d0                	add    %edx,%eax
  8014f6:	c6 00 00             	movb   $0x0,(%eax)
}
  8014f9:	90                   	nop
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801508:	8b 45 14             	mov    0x14(%ebp),%eax
  80150b:	8b 00                	mov    (%eax),%eax
  80150d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801514:	8b 45 10             	mov    0x10(%ebp),%eax
  801517:	01 d0                	add    %edx,%eax
  801519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80151f:	eb 0c                	jmp    80152d <strsplit+0x31>
			*string++ = 0;
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	8d 50 01             	lea    0x1(%eax),%edx
  801527:	89 55 08             	mov    %edx,0x8(%ebp)
  80152a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	84 c0                	test   %al,%al
  801534:	74 18                	je     80154e <strsplit+0x52>
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	0f be c0             	movsbl %al,%eax
  80153e:	50                   	push   %eax
  80153f:	ff 75 0c             	pushl  0xc(%ebp)
  801542:	e8 83 fa ff ff       	call   800fca <strchr>
  801547:	83 c4 08             	add    $0x8,%esp
  80154a:	85 c0                	test   %eax,%eax
  80154c:	75 d3                	jne    801521 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	8a 00                	mov    (%eax),%al
  801553:	84 c0                	test   %al,%al
  801555:	74 5a                	je     8015b1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801557:	8b 45 14             	mov    0x14(%ebp),%eax
  80155a:	8b 00                	mov    (%eax),%eax
  80155c:	83 f8 0f             	cmp    $0xf,%eax
  80155f:	75 07                	jne    801568 <strsplit+0x6c>
		{
			return 0;
  801561:	b8 00 00 00 00       	mov    $0x0,%eax
  801566:	eb 66                	jmp    8015ce <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801568:	8b 45 14             	mov    0x14(%ebp),%eax
  80156b:	8b 00                	mov    (%eax),%eax
  80156d:	8d 48 01             	lea    0x1(%eax),%ecx
  801570:	8b 55 14             	mov    0x14(%ebp),%edx
  801573:	89 0a                	mov    %ecx,(%edx)
  801575:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80157c:	8b 45 10             	mov    0x10(%ebp),%eax
  80157f:	01 c2                	add    %eax,%edx
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801586:	eb 03                	jmp    80158b <strsplit+0x8f>
			string++;
  801588:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	84 c0                	test   %al,%al
  801592:	74 8b                	je     80151f <strsplit+0x23>
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	8a 00                	mov    (%eax),%al
  801599:	0f be c0             	movsbl %al,%eax
  80159c:	50                   	push   %eax
  80159d:	ff 75 0c             	pushl  0xc(%ebp)
  8015a0:	e8 25 fa ff ff       	call   800fca <strchr>
  8015a5:	83 c4 08             	add    $0x8,%esp
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	74 dc                	je     801588 <strsplit+0x8c>
			string++;
	}
  8015ac:	e9 6e ff ff ff       	jmp    80151f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015b1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b5:	8b 00                	mov    (%eax),%eax
  8015b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015be:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c1:	01 d0                	add    %edx,%eax
  8015c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e3:	eb 4a                	jmp    80162f <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015eb:	01 c2                	add    %eax,%edx
  8015ed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f3:	01 c8                	add    %ecx,%eax
  8015f5:	8a 00                	mov    (%eax),%al
  8015f7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	01 d0                	add    %edx,%eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	3c 40                	cmp    $0x40,%al
  801605:	7e 25                	jle    80162c <str2lower+0x5c>
  801607:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160d:	01 d0                	add    %edx,%eax
  80160f:	8a 00                	mov    (%eax),%al
  801611:	3c 5a                	cmp    $0x5a,%al
  801613:	7f 17                	jg     80162c <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801615:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	01 d0                	add    %edx,%eax
  80161d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801620:	8b 55 08             	mov    0x8(%ebp),%edx
  801623:	01 ca                	add    %ecx,%edx
  801625:	8a 12                	mov    (%edx),%dl
  801627:	83 c2 20             	add    $0x20,%edx
  80162a:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80162c:	ff 45 fc             	incl   -0x4(%ebp)
  80162f:	ff 75 0c             	pushl  0xc(%ebp)
  801632:	e8 01 f8 ff ff       	call   800e38 <strlen>
  801637:	83 c4 04             	add    $0x4,%esp
  80163a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80163d:	7f a6                	jg     8015e5 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80163f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  80164a:	83 ec 0c             	sub    $0xc,%esp
  80164d:	6a 10                	push   $0x10
  80164f:	e8 b2 15 00 00       	call   802c06 <alloc_block>
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  80165a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80165e:	75 14                	jne    801674 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	68 88 40 80 00       	push   $0x804088
  801668:	6a 14                	push   $0x14
  80166a:	68 b1 40 80 00       	push   $0x8040b1
  80166f:	e8 fd ed ff ff       	call   800471 <_panic>

	node->start = start;
  801674:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801677:	8b 55 08             	mov    0x8(%ebp),%edx
  80167a:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  80167c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801682:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801685:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  80168c:	a1 24 50 80 00       	mov    0x805024,%eax
  801691:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801694:	eb 18                	jmp    8016ae <insert_page_alloc+0x6a>
		if (start < it->start)
  801696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801699:	8b 00                	mov    (%eax),%eax
  80169b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80169e:	77 37                	ja     8016d7 <insert_page_alloc+0x93>
			break;
		prev = it;
  8016a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a3:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  8016a6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016b2:	74 08                	je     8016bc <insert_page_alloc+0x78>
  8016b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b7:	8b 40 08             	mov    0x8(%eax),%eax
  8016ba:	eb 05                	jmp    8016c1 <insert_page_alloc+0x7d>
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8016c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	75 c7                	jne    801696 <insert_page_alloc+0x52>
  8016cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016d3:	75 c1                	jne    801696 <insert_page_alloc+0x52>
  8016d5:	eb 01                	jmp    8016d8 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8016d7:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8016d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016dc:	75 64                	jne    801742 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8016de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016e2:	75 14                	jne    8016f8 <insert_page_alloc+0xb4>
  8016e4:	83 ec 04             	sub    $0x4,%esp
  8016e7:	68 c0 40 80 00       	push   $0x8040c0
  8016ec:	6a 21                	push   $0x21
  8016ee:	68 b1 40 80 00       	push   $0x8040b1
  8016f3:	e8 79 ed ff ff       	call   800471 <_panic>
  8016f8:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8016fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801701:	89 50 08             	mov    %edx,0x8(%eax)
  801704:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801707:	8b 40 08             	mov    0x8(%eax),%eax
  80170a:	85 c0                	test   %eax,%eax
  80170c:	74 0d                	je     80171b <insert_page_alloc+0xd7>
  80170e:	a1 24 50 80 00       	mov    0x805024,%eax
  801713:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801716:	89 50 0c             	mov    %edx,0xc(%eax)
  801719:	eb 08                	jmp    801723 <insert_page_alloc+0xdf>
  80171b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171e:	a3 28 50 80 00       	mov    %eax,0x805028
  801723:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801726:	a3 24 50 80 00       	mov    %eax,0x805024
  80172b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801735:	a1 30 50 80 00       	mov    0x805030,%eax
  80173a:	40                   	inc    %eax
  80173b:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801740:	eb 71                	jmp    8017b3 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801742:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801746:	74 06                	je     80174e <insert_page_alloc+0x10a>
  801748:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80174c:	75 14                	jne    801762 <insert_page_alloc+0x11e>
  80174e:	83 ec 04             	sub    $0x4,%esp
  801751:	68 e4 40 80 00       	push   $0x8040e4
  801756:	6a 23                	push   $0x23
  801758:	68 b1 40 80 00       	push   $0x8040b1
  80175d:	e8 0f ed ff ff       	call   800471 <_panic>
  801762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801765:	8b 50 08             	mov    0x8(%eax),%edx
  801768:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176b:	89 50 08             	mov    %edx,0x8(%eax)
  80176e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801771:	8b 40 08             	mov    0x8(%eax),%eax
  801774:	85 c0                	test   %eax,%eax
  801776:	74 0c                	je     801784 <insert_page_alloc+0x140>
  801778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177b:	8b 40 08             	mov    0x8(%eax),%eax
  80177e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801781:	89 50 0c             	mov    %edx,0xc(%eax)
  801784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801787:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80178a:	89 50 08             	mov    %edx,0x8(%eax)
  80178d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801790:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801793:	89 50 0c             	mov    %edx,0xc(%eax)
  801796:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801799:	8b 40 08             	mov    0x8(%eax),%eax
  80179c:	85 c0                	test   %eax,%eax
  80179e:	75 08                	jne    8017a8 <insert_page_alloc+0x164>
  8017a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a3:	a3 28 50 80 00       	mov    %eax,0x805028
  8017a8:	a1 30 50 80 00       	mov    0x805030,%eax
  8017ad:	40                   	inc    %eax
  8017ae:	a3 30 50 80 00       	mov    %eax,0x805030
}
  8017b3:	90                   	nop
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  8017bc:	a1 24 50 80 00       	mov    0x805024,%eax
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	75 0c                	jne    8017d1 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  8017c5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8017ca:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  8017cf:	eb 67                	jmp    801838 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  8017d1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8017d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8017d9:	a1 24 50 80 00       	mov    0x805024,%eax
  8017de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8017e1:	eb 26                	jmp    801809 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  8017e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e6:	8b 10                	mov    (%eax),%edx
  8017e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017eb:	8b 40 04             	mov    0x4(%eax),%eax
  8017ee:	01 d0                	add    %edx,%eax
  8017f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  8017f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017f9:	76 06                	jbe    801801 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  8017fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801801:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801806:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801809:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80180d:	74 08                	je     801817 <recompute_page_alloc_break+0x61>
  80180f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801812:	8b 40 08             	mov    0x8(%eax),%eax
  801815:	eb 05                	jmp    80181c <recompute_page_alloc_break+0x66>
  801817:	b8 00 00 00 00       	mov    $0x0,%eax
  80181c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801821:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801826:	85 c0                	test   %eax,%eax
  801828:	75 b9                	jne    8017e3 <recompute_page_alloc_break+0x2d>
  80182a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80182e:	75 b3                	jne    8017e3 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801830:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801833:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801840:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801847:	8b 55 08             	mov    0x8(%ebp),%edx
  80184a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80184d:	01 d0                	add    %edx,%eax
  80184f:	48                   	dec    %eax
  801850:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801856:	ba 00 00 00 00       	mov    $0x0,%edx
  80185b:	f7 75 d8             	divl   -0x28(%ebp)
  80185e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801861:	29 d0                	sub    %edx,%eax
  801863:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801866:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80186a:	75 0a                	jne    801876 <alloc_pages_custom_fit+0x3c>
		return NULL;
  80186c:	b8 00 00 00 00       	mov    $0x0,%eax
  801871:	e9 7e 01 00 00       	jmp    8019f4 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801876:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  80187d:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801881:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801888:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  80188f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801897:	a1 24 50 80 00       	mov    0x805024,%eax
  80189c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80189f:	eb 69                	jmp    80190a <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  8018a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a4:	8b 00                	mov    (%eax),%eax
  8018a6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8018a9:	76 47                	jbe    8018f2 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  8018ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018ae:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  8018b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b4:	8b 00                	mov    (%eax),%eax
  8018b6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8018b9:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  8018bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018bf:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018c2:	72 2e                	jb     8018f2 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  8018c4:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8018c8:	75 14                	jne    8018de <alloc_pages_custom_fit+0xa4>
  8018ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018cd:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018d0:	75 0c                	jne    8018de <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  8018d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  8018d8:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8018dc:	eb 14                	jmp    8018f2 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  8018de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018e1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018e4:	76 0c                	jbe    8018f2 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  8018e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  8018ec:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  8018f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f5:	8b 10                	mov    (%eax),%edx
  8018f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018fa:	8b 40 04             	mov    0x4(%eax),%eax
  8018fd:	01 d0                	add    %edx,%eax
  8018ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801902:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801907:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80190a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80190e:	74 08                	je     801918 <alloc_pages_custom_fit+0xde>
  801910:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801913:	8b 40 08             	mov    0x8(%eax),%eax
  801916:	eb 05                	jmp    80191d <alloc_pages_custom_fit+0xe3>
  801918:	b8 00 00 00 00       	mov    $0x0,%eax
  80191d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801922:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801927:	85 c0                	test   %eax,%eax
  801929:	0f 85 72 ff ff ff    	jne    8018a1 <alloc_pages_custom_fit+0x67>
  80192f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801933:	0f 85 68 ff ff ff    	jne    8018a1 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801939:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80193e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801941:	76 47                	jbe    80198a <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801943:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801946:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801949:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80194e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801951:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801954:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801957:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80195a:	72 2e                	jb     80198a <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  80195c:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801960:	75 14                	jne    801976 <alloc_pages_custom_fit+0x13c>
  801962:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801965:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801968:	75 0c                	jne    801976 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  80196a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80196d:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801970:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801974:	eb 14                	jmp    80198a <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801976:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801979:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80197c:	76 0c                	jbe    80198a <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  80197e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801981:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801984:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801987:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  80198a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801991:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801995:	74 08                	je     80199f <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80199d:	eb 40                	jmp    8019df <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  80199f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019a3:	74 08                	je     8019ad <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  8019a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019ab:	eb 32                	jmp    8019df <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  8019ad:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8019b2:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8019b5:	89 c2                	mov    %eax,%edx
  8019b7:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8019bc:	39 c2                	cmp    %eax,%edx
  8019be:	73 07                	jae    8019c7 <alloc_pages_custom_fit+0x18d>
			return NULL;
  8019c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c5:	eb 2d                	jmp    8019f4 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  8019c7:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8019cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  8019cf:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8019d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019d8:	01 d0                	add    %edx,%eax
  8019da:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  8019df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019e2:	83 ec 08             	sub    $0x8,%esp
  8019e5:	ff 75 d0             	pushl  -0x30(%ebp)
  8019e8:	50                   	push   %eax
  8019e9:	e8 56 fc ff ff       	call   801644 <insert_page_alloc>
  8019ee:	83 c4 10             	add    $0x10,%esp

	return result;
  8019f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a02:	a1 24 50 80 00       	mov    0x805024,%eax
  801a07:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801a0a:	eb 1a                	jmp    801a26 <find_allocated_size+0x30>
		if (it->start == va)
  801a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a0f:	8b 00                	mov    (%eax),%eax
  801a11:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a14:	75 08                	jne    801a1e <find_allocated_size+0x28>
			return it->size;
  801a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a19:	8b 40 04             	mov    0x4(%eax),%eax
  801a1c:	eb 34                	jmp    801a52 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a1e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a23:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801a26:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a2a:	74 08                	je     801a34 <find_allocated_size+0x3e>
  801a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a2f:	8b 40 08             	mov    0x8(%eax),%eax
  801a32:	eb 05                	jmp    801a39 <find_allocated_size+0x43>
  801a34:	b8 00 00 00 00       	mov    $0x0,%eax
  801a39:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801a3e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a43:	85 c0                	test   %eax,%eax
  801a45:	75 c5                	jne    801a0c <find_allocated_size+0x16>
  801a47:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a4b:	75 bf                	jne    801a0c <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801a4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a60:	a1 24 50 80 00       	mov    0x805024,%eax
  801a65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a68:	e9 e1 01 00 00       	jmp    801c4e <free_pages+0x1fa>
		if (it->start == va) {
  801a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a70:	8b 00                	mov    (%eax),%eax
  801a72:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801a75:	0f 85 cb 01 00 00    	jne    801c46 <free_pages+0x1f2>

			uint32 start = it->start;
  801a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7e:	8b 00                	mov    (%eax),%eax
  801a80:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a86:	8b 40 04             	mov    0x4(%eax),%eax
  801a89:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801a8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a8f:	f7 d0                	not    %eax
  801a91:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a94:	73 1d                	jae    801ab3 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801a96:	83 ec 0c             	sub    $0xc,%esp
  801a99:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a9c:	ff 75 e8             	pushl  -0x18(%ebp)
  801a9f:	68 18 41 80 00       	push   $0x804118
  801aa4:	68 a5 00 00 00       	push   $0xa5
  801aa9:	68 b1 40 80 00       	push   $0x8040b1
  801aae:	e8 be e9 ff ff       	call   800471 <_panic>
			}

			uint32 start_end = start + size;
  801ab3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ab6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ab9:	01 d0                	add    %edx,%eax
  801abb:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ac1:	85 c0                	test   %eax,%eax
  801ac3:	79 19                	jns    801ade <free_pages+0x8a>
  801ac5:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801acc:	77 10                	ja     801ade <free_pages+0x8a>
  801ace:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801ad5:	77 07                	ja     801ade <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801ad7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ada:	85 c0                	test   %eax,%eax
  801adc:	78 2c                	js     801b0a <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ae1:	83 ec 0c             	sub    $0xc,%esp
  801ae4:	68 00 00 00 a0       	push   $0xa0000000
  801ae9:	ff 75 e0             	pushl  -0x20(%ebp)
  801aec:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aef:	ff 75 e8             	pushl  -0x18(%ebp)
  801af2:	ff 75 e4             	pushl  -0x1c(%ebp)
  801af5:	50                   	push   %eax
  801af6:	68 5c 41 80 00       	push   $0x80415c
  801afb:	68 ad 00 00 00       	push   $0xad
  801b00:	68 b1 40 80 00       	push   $0x8040b1
  801b05:	e8 67 e9 ff ff       	call   800471 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b10:	e9 88 00 00 00       	jmp    801b9d <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801b15:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801b1c:	76 17                	jbe    801b35 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801b1e:	ff 75 f0             	pushl  -0x10(%ebp)
  801b21:	68 c0 41 80 00       	push   $0x8041c0
  801b26:	68 b4 00 00 00       	push   $0xb4
  801b2b:	68 b1 40 80 00       	push   $0x8040b1
  801b30:	e8 3c e9 ff ff       	call   800471 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b38:	05 00 10 00 00       	add    $0x1000,%eax
  801b3d:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b43:	85 c0                	test   %eax,%eax
  801b45:	79 2e                	jns    801b75 <free_pages+0x121>
  801b47:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801b4e:	77 25                	ja     801b75 <free_pages+0x121>
  801b50:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801b57:	77 1c                	ja     801b75 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801b59:	83 ec 08             	sub    $0x8,%esp
  801b5c:	68 00 10 00 00       	push   $0x1000
  801b61:	ff 75 f0             	pushl  -0x10(%ebp)
  801b64:	e8 38 0d 00 00       	call   8028a1 <sys_free_user_mem>
  801b69:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b6c:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801b73:	eb 28                	jmp    801b9d <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b78:	68 00 00 00 a0       	push   $0xa0000000
  801b7d:	ff 75 dc             	pushl  -0x24(%ebp)
  801b80:	68 00 10 00 00       	push   $0x1000
  801b85:	ff 75 f0             	pushl  -0x10(%ebp)
  801b88:	50                   	push   %eax
  801b89:	68 00 42 80 00       	push   $0x804200
  801b8e:	68 bd 00 00 00       	push   $0xbd
  801b93:	68 b1 40 80 00       	push   $0x8040b1
  801b98:	e8 d4 e8 ff ff       	call   800471 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801ba3:	0f 82 6c ff ff ff    	jb     801b15 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801ba9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bad:	75 17                	jne    801bc6 <free_pages+0x172>
  801baf:	83 ec 04             	sub    $0x4,%esp
  801bb2:	68 62 42 80 00       	push   $0x804262
  801bb7:	68 c1 00 00 00       	push   $0xc1
  801bbc:	68 b1 40 80 00       	push   $0x8040b1
  801bc1:	e8 ab e8 ff ff       	call   800471 <_panic>
  801bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc9:	8b 40 08             	mov    0x8(%eax),%eax
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	74 11                	je     801be1 <free_pages+0x18d>
  801bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd3:	8b 40 08             	mov    0x8(%eax),%eax
  801bd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd9:	8b 52 0c             	mov    0xc(%edx),%edx
  801bdc:	89 50 0c             	mov    %edx,0xc(%eax)
  801bdf:	eb 0b                	jmp    801bec <free_pages+0x198>
  801be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be4:	8b 40 0c             	mov    0xc(%eax),%eax
  801be7:	a3 28 50 80 00       	mov    %eax,0x805028
  801bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bef:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf2:	85 c0                	test   %eax,%eax
  801bf4:	74 11                	je     801c07 <free_pages+0x1b3>
  801bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf9:	8b 40 0c             	mov    0xc(%eax),%eax
  801bfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bff:	8b 52 08             	mov    0x8(%edx),%edx
  801c02:	89 50 08             	mov    %edx,0x8(%eax)
  801c05:	eb 0b                	jmp    801c12 <free_pages+0x1be>
  801c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0a:	8b 40 08             	mov    0x8(%eax),%eax
  801c0d:	a3 24 50 80 00       	mov    %eax,0x805024
  801c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c15:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c26:	a1 30 50 80 00       	mov    0x805030,%eax
  801c2b:	48                   	dec    %eax
  801c2c:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801c31:	83 ec 0c             	sub    $0xc,%esp
  801c34:	ff 75 f4             	pushl  -0xc(%ebp)
  801c37:	e8 24 15 00 00       	call   803160 <free_block>
  801c3c:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801c3f:	e8 72 fb ff ff       	call   8017b6 <recompute_page_alloc_break>

			return;
  801c44:	eb 37                	jmp    801c7d <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801c46:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c52:	74 08                	je     801c5c <free_pages+0x208>
  801c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c57:	8b 40 08             	mov    0x8(%eax),%eax
  801c5a:	eb 05                	jmp    801c61 <free_pages+0x20d>
  801c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c61:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801c66:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c6b:	85 c0                	test   %eax,%eax
  801c6d:	0f 85 fa fd ff ff    	jne    801a6d <free_pages+0x19>
  801c73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c77:	0f 85 f0 fd ff ff    	jne    801a6d <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801c82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c87:	5d                   	pop    %ebp
  801c88:	c3                   	ret    

00801c89 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801c8f:	a1 08 50 80 00       	mov    0x805008,%eax
  801c94:	85 c0                	test   %eax,%eax
  801c96:	74 60                	je     801cf8 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801c98:	83 ec 08             	sub    $0x8,%esp
  801c9b:	68 00 00 00 82       	push   $0x82000000
  801ca0:	68 00 00 00 80       	push   $0x80000000
  801ca5:	e8 0d 0d 00 00       	call   8029b7 <initialize_dynamic_allocator>
  801caa:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801cad:	e8 f3 0a 00 00       	call   8027a5 <sys_get_uheap_strategy>
  801cb2:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801cb7:	a1 40 50 80 00       	mov    0x805040,%eax
  801cbc:	05 00 10 00 00       	add    $0x1000,%eax
  801cc1:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801cc6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ccb:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801cd0:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801cd7:	00 00 00 
  801cda:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801ce1:	00 00 00 
  801ce4:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801ceb:	00 00 00 

		__firstTimeFlag = 0;
  801cee:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801cf5:	00 00 00 
	}
}
  801cf8:	90                   	nop
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d0f:	83 ec 08             	sub    $0x8,%esp
  801d12:	68 06 04 00 00       	push   $0x406
  801d17:	50                   	push   %eax
  801d18:	e8 d2 06 00 00       	call   8023ef <__sys_allocate_page>
  801d1d:	83 c4 10             	add    $0x10,%esp
  801d20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d27:	79 17                	jns    801d40 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	68 80 42 80 00       	push   $0x804280
  801d31:	68 ea 00 00 00       	push   $0xea
  801d36:	68 b1 40 80 00       	push   $0x8040b1
  801d3b:	e8 31 e7 ff ff       	call   800471 <_panic>
	return 0;
  801d40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d56:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d5b:	83 ec 0c             	sub    $0xc,%esp
  801d5e:	50                   	push   %eax
  801d5f:	e8 d2 06 00 00       	call   802436 <__sys_unmap_frame>
  801d64:	83 c4 10             	add    $0x10,%esp
  801d67:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d6e:	79 17                	jns    801d87 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801d70:	83 ec 04             	sub    $0x4,%esp
  801d73:	68 bc 42 80 00       	push   $0x8042bc
  801d78:	68 f5 00 00 00       	push   $0xf5
  801d7d:	68 b1 40 80 00       	push   $0x8040b1
  801d82:	e8 ea e6 ff ff       	call   800471 <_panic>
}
  801d87:	90                   	nop
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d90:	e8 f4 fe ff ff       	call   801c89 <uheap_init>
	if (size == 0) return NULL ;
  801d95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d99:	75 0a                	jne    801da5 <malloc+0x1b>
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801da0:	e9 67 01 00 00       	jmp    801f0c <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801da5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801dac:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801db3:	77 16                	ja     801dcb <malloc+0x41>
		result = alloc_block(size);
  801db5:	83 ec 0c             	sub    $0xc,%esp
  801db8:	ff 75 08             	pushl  0x8(%ebp)
  801dbb:	e8 46 0e 00 00       	call   802c06 <alloc_block>
  801dc0:	83 c4 10             	add    $0x10,%esp
  801dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dc6:	e9 3e 01 00 00       	jmp    801f09 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801dcb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801dd2:	8b 55 08             	mov    0x8(%ebp),%edx
  801dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd8:	01 d0                	add    %edx,%eax
  801dda:	48                   	dec    %eax
  801ddb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de1:	ba 00 00 00 00       	mov    $0x0,%edx
  801de6:	f7 75 f0             	divl   -0x10(%ebp)
  801de9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dec:	29 d0                	sub    %edx,%eax
  801dee:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801df1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801df6:	85 c0                	test   %eax,%eax
  801df8:	75 0a                	jne    801e04 <malloc+0x7a>
			return NULL;
  801dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801dff:	e9 08 01 00 00       	jmp    801f0c <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801e04:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	74 0f                	je     801e1c <malloc+0x92>
  801e0d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801e13:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e18:	39 c2                	cmp    %eax,%edx
  801e1a:	73 0a                	jae    801e26 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801e1c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e21:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801e26:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801e2b:	83 f8 05             	cmp    $0x5,%eax
  801e2e:	75 11                	jne    801e41 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801e30:	83 ec 0c             	sub    $0xc,%esp
  801e33:	ff 75 e8             	pushl  -0x18(%ebp)
  801e36:	e8 ff f9 ff ff       	call   80183a <alloc_pages_custom_fit>
  801e3b:	83 c4 10             	add    $0x10,%esp
  801e3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801e41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e45:	0f 84 be 00 00 00    	je     801f09 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801e51:	83 ec 0c             	sub    $0xc,%esp
  801e54:	ff 75 f4             	pushl  -0xc(%ebp)
  801e57:	e8 9a fb ff ff       	call   8019f6 <find_allocated_size>
  801e5c:	83 c4 10             	add    $0x10,%esp
  801e5f:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801e62:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e66:	75 17                	jne    801e7f <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801e68:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6b:	68 fc 42 80 00       	push   $0x8042fc
  801e70:	68 24 01 00 00       	push   $0x124
  801e75:	68 b1 40 80 00       	push   $0x8040b1
  801e7a:	e8 f2 e5 ff ff       	call   800471 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801e7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e82:	f7 d0                	not    %eax
  801e84:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e87:	73 1d                	jae    801ea6 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801e89:	83 ec 0c             	sub    $0xc,%esp
  801e8c:	ff 75 e0             	pushl  -0x20(%ebp)
  801e8f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e92:	68 44 43 80 00       	push   $0x804344
  801e97:	68 29 01 00 00       	push   $0x129
  801e9c:	68 b1 40 80 00       	push   $0x8040b1
  801ea1:	e8 cb e5 ff ff       	call   800471 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801ea6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ea9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eac:	01 d0                	add    %edx,%eax
  801eae:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	79 2c                	jns    801ee4 <malloc+0x15a>
  801eb8:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801ebf:	77 23                	ja     801ee4 <malloc+0x15a>
  801ec1:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801ec8:	77 1a                	ja     801ee4 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801eca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	79 13                	jns    801ee4 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801ed1:	83 ec 08             	sub    $0x8,%esp
  801ed4:	ff 75 e0             	pushl  -0x20(%ebp)
  801ed7:	ff 75 e4             	pushl  -0x1c(%ebp)
  801eda:	e8 de 09 00 00       	call   8028bd <sys_allocate_user_mem>
  801edf:	83 c4 10             	add    $0x10,%esp
  801ee2:	eb 25                	jmp    801f09 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801ee4:	68 00 00 00 a0       	push   $0xa0000000
  801ee9:	ff 75 dc             	pushl  -0x24(%ebp)
  801eec:	ff 75 e0             	pushl  -0x20(%ebp)
  801eef:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ef2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef5:	68 80 43 80 00       	push   $0x804380
  801efa:	68 33 01 00 00       	push   $0x133
  801eff:	68 b1 40 80 00       	push   $0x8040b1
  801f04:	e8 68 e5 ff ff       	call   800471 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
  801f11:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801f14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f18:	0f 84 26 01 00 00    	je     802044 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f21:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f27:	85 c0                	test   %eax,%eax
  801f29:	79 1c                	jns    801f47 <free+0x39>
  801f2b:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801f32:	77 13                	ja     801f47 <free+0x39>
		free_block(virtual_address);
  801f34:	83 ec 0c             	sub    $0xc,%esp
  801f37:	ff 75 08             	pushl  0x8(%ebp)
  801f3a:	e8 21 12 00 00       	call   803160 <free_block>
  801f3f:	83 c4 10             	add    $0x10,%esp
		return;
  801f42:	e9 01 01 00 00       	jmp    802048 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801f47:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f4c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801f4f:	0f 82 d8 00 00 00    	jb     80202d <free+0x11f>
  801f55:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801f5c:	0f 87 cb 00 00 00    	ja     80202d <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f65:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	74 17                	je     801f85 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801f6e:	ff 75 08             	pushl  0x8(%ebp)
  801f71:	68 f0 43 80 00       	push   $0x8043f0
  801f76:	68 57 01 00 00       	push   $0x157
  801f7b:	68 b1 40 80 00       	push   $0x8040b1
  801f80:	e8 ec e4 ff ff       	call   800471 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801f85:	83 ec 0c             	sub    $0xc,%esp
  801f88:	ff 75 08             	pushl  0x8(%ebp)
  801f8b:	e8 66 fa ff ff       	call   8019f6 <find_allocated_size>
  801f90:	83 c4 10             	add    $0x10,%esp
  801f93:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801f96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f9a:	0f 84 a7 00 00 00    	je     802047 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa3:	f7 d0                	not    %eax
  801fa5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801fa8:	73 1d                	jae    801fc7 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801faa:	83 ec 0c             	sub    $0xc,%esp
  801fad:	ff 75 f0             	pushl  -0x10(%ebp)
  801fb0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb3:	68 18 44 80 00       	push   $0x804418
  801fb8:	68 61 01 00 00       	push   $0x161
  801fbd:	68 b1 40 80 00       	push   $0x8040b1
  801fc2:	e8 aa e4 ff ff       	call   800471 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801fc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcd:	01 d0                	add    %edx,%eax
  801fcf:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	79 19                	jns    801ff2 <free+0xe4>
  801fd9:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801fe0:	77 10                	ja     801ff2 <free+0xe4>
  801fe2:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801fe9:	77 07                	ja     801ff2 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801feb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fee:	85 c0                	test   %eax,%eax
  801ff0:	78 2b                	js     80201d <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801ff2:	83 ec 0c             	sub    $0xc,%esp
  801ff5:	68 00 00 00 a0       	push   $0xa0000000
  801ffa:	ff 75 ec             	pushl  -0x14(%ebp)
  801ffd:	ff 75 f0             	pushl  -0x10(%ebp)
  802000:	ff 75 f4             	pushl  -0xc(%ebp)
  802003:	ff 75 f0             	pushl  -0x10(%ebp)
  802006:	ff 75 08             	pushl  0x8(%ebp)
  802009:	68 54 44 80 00       	push   $0x804454
  80200e:	68 69 01 00 00       	push   $0x169
  802013:	68 b1 40 80 00       	push   $0x8040b1
  802018:	e8 54 e4 ff ff       	call   800471 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  80201d:	83 ec 0c             	sub    $0xc,%esp
  802020:	ff 75 08             	pushl  0x8(%ebp)
  802023:	e8 2c fa ff ff       	call   801a54 <free_pages>
  802028:	83 c4 10             	add    $0x10,%esp
		return;
  80202b:	eb 1b                	jmp    802048 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  80202d:	ff 75 08             	pushl  0x8(%ebp)
  802030:	68 b0 44 80 00       	push   $0x8044b0
  802035:	68 70 01 00 00       	push   $0x170
  80203a:	68 b1 40 80 00       	push   $0x8040b1
  80203f:	e8 2d e4 ff ff       	call   800471 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802044:	90                   	nop
  802045:	eb 01                	jmp    802048 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  802047:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	83 ec 38             	sub    $0x38,%esp
  802050:	8b 45 10             	mov    0x10(%ebp),%eax
  802053:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802056:	e8 2e fc ff ff       	call   801c89 <uheap_init>
	if (size == 0) return NULL ;
  80205b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80205f:	75 0a                	jne    80206b <smalloc+0x21>
  802061:	b8 00 00 00 00       	mov    $0x0,%eax
  802066:	e9 3d 01 00 00       	jmp    8021a8 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  80206b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  802071:	8b 45 0c             	mov    0xc(%ebp),%eax
  802074:	25 ff 0f 00 00       	and    $0xfff,%eax
  802079:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  80207c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802080:	74 0e                	je     802090 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  802082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802085:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802088:	05 00 10 00 00       	add    $0x1000,%eax
  80208d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  802090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802093:	c1 e8 0c             	shr    $0xc,%eax
  802096:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802099:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	75 0a                	jne    8020ac <smalloc+0x62>
		return NULL;
  8020a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a7:	e9 fc 00 00 00       	jmp    8021a8 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8020ac:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020b1:	85 c0                	test   %eax,%eax
  8020b3:	74 0f                	je     8020c4 <smalloc+0x7a>
  8020b5:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020bb:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020c0:	39 c2                	cmp    %eax,%edx
  8020c2:	73 0a                	jae    8020ce <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  8020c4:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020c9:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8020ce:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020d3:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8020d8:	29 c2                	sub    %eax,%edx
  8020da:	89 d0                	mov    %edx,%eax
  8020dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8020df:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020e5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020ea:	29 c2                	sub    %eax,%edx
  8020ec:	89 d0                	mov    %edx,%eax
  8020ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020f7:	77 13                	ja     80210c <smalloc+0xc2>
  8020f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020fc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020ff:	77 0b                	ja     80210c <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  802101:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802104:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802107:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80210a:	73 0a                	jae    802116 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  80210c:	b8 00 00 00 00       	mov    $0x0,%eax
  802111:	e9 92 00 00 00       	jmp    8021a8 <smalloc+0x15e>
	}

	void *va = NULL;
  802116:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  80211d:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802122:	83 f8 05             	cmp    $0x5,%eax
  802125:	75 11                	jne    802138 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  802127:	83 ec 0c             	sub    $0xc,%esp
  80212a:	ff 75 f4             	pushl  -0xc(%ebp)
  80212d:	e8 08 f7 ff ff       	call   80183a <alloc_pages_custom_fit>
  802132:	83 c4 10             	add    $0x10,%esp
  802135:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802138:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80213c:	75 27                	jne    802165 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80213e:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  802145:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802148:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80214b:	89 c2                	mov    %eax,%edx
  80214d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802152:	39 c2                	cmp    %eax,%edx
  802154:	73 07                	jae    80215d <smalloc+0x113>
			return NULL;}
  802156:	b8 00 00 00 00       	mov    $0x0,%eax
  80215b:	eb 4b                	jmp    8021a8 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  80215d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802162:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  802165:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802169:	ff 75 f0             	pushl  -0x10(%ebp)
  80216c:	50                   	push   %eax
  80216d:	ff 75 0c             	pushl  0xc(%ebp)
  802170:	ff 75 08             	pushl  0x8(%ebp)
  802173:	e8 cb 03 00 00       	call   802543 <sys_create_shared_object>
  802178:	83 c4 10             	add    $0x10,%esp
  80217b:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80217e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802182:	79 07                	jns    80218b <smalloc+0x141>
		return NULL;
  802184:	b8 00 00 00 00       	mov    $0x0,%eax
  802189:	eb 1d                	jmp    8021a8 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  80218b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802190:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802193:	75 10                	jne    8021a5 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802195:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219e:	01 d0                	add    %edx,%eax
  8021a0:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  8021a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021b0:	e8 d4 fa ff ff       	call   801c89 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8021b5:	83 ec 08             	sub    $0x8,%esp
  8021b8:	ff 75 0c             	pushl  0xc(%ebp)
  8021bb:	ff 75 08             	pushl  0x8(%ebp)
  8021be:	e8 aa 03 00 00       	call   80256d <sys_size_of_shared_object>
  8021c3:	83 c4 10             	add    $0x10,%esp
  8021c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8021c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021cd:	7f 0a                	jg     8021d9 <sget+0x2f>
		return NULL;
  8021cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d4:	e9 32 01 00 00       	jmp    80230b <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8021d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8021df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e2:	25 ff 0f 00 00       	and    $0xfff,%eax
  8021e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8021ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8021ee:	74 0e                	je     8021fe <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8021f6:	05 00 10 00 00       	add    $0x1000,%eax
  8021fb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8021fe:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802203:	85 c0                	test   %eax,%eax
  802205:	75 0a                	jne    802211 <sget+0x67>
		return NULL;
  802207:	b8 00 00 00 00       	mov    $0x0,%eax
  80220c:	e9 fa 00 00 00       	jmp    80230b <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802211:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802216:	85 c0                	test   %eax,%eax
  802218:	74 0f                	je     802229 <sget+0x7f>
  80221a:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802220:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802225:	39 c2                	cmp    %eax,%edx
  802227:	73 0a                	jae    802233 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  802229:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80222e:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802233:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802238:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80223d:	29 c2                	sub    %eax,%edx
  80223f:	89 d0                	mov    %edx,%eax
  802241:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802244:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80224a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80224f:	29 c2                	sub    %eax,%edx
  802251:	89 d0                	mov    %edx,%eax
  802253:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802259:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80225c:	77 13                	ja     802271 <sget+0xc7>
  80225e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802261:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802264:	77 0b                	ja     802271 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802266:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802269:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80226c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80226f:	73 0a                	jae    80227b <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802271:	b8 00 00 00 00       	mov    $0x0,%eax
  802276:	e9 90 00 00 00       	jmp    80230b <sget+0x161>

	void *va = NULL;
  80227b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802282:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802287:	83 f8 05             	cmp    $0x5,%eax
  80228a:	75 11                	jne    80229d <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80228c:	83 ec 0c             	sub    $0xc,%esp
  80228f:	ff 75 f4             	pushl  -0xc(%ebp)
  802292:	e8 a3 f5 ff ff       	call   80183a <alloc_pages_custom_fit>
  802297:	83 c4 10             	add    $0x10,%esp
  80229a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  80229d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022a1:	75 27                	jne    8022ca <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8022a3:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8022aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022ad:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8022b0:	89 c2                	mov    %eax,%edx
  8022b2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022b7:	39 c2                	cmp    %eax,%edx
  8022b9:	73 07                	jae    8022c2 <sget+0x118>
			return NULL;
  8022bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c0:	eb 49                	jmp    80230b <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8022c2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8022ca:	83 ec 04             	sub    $0x4,%esp
  8022cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8022d0:	ff 75 0c             	pushl  0xc(%ebp)
  8022d3:	ff 75 08             	pushl  0x8(%ebp)
  8022d6:	e8 af 02 00 00       	call   80258a <sys_get_shared_object>
  8022db:	83 c4 10             	add    $0x10,%esp
  8022de:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8022e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8022e5:	79 07                	jns    8022ee <sget+0x144>
		return NULL;
  8022e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ec:	eb 1d                	jmp    80230b <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8022ee:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022f3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8022f6:	75 10                	jne    802308 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8022f8:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8022fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802301:	01 d0                	add    %edx,%eax
  802303:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  802308:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802313:	e8 71 f9 ff ff       	call   801c89 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802318:	83 ec 04             	sub    $0x4,%esp
  80231b:	68 d4 44 80 00       	push   $0x8044d4
  802320:	68 19 02 00 00       	push   $0x219
  802325:	68 b1 40 80 00       	push   $0x8040b1
  80232a:	e8 42 e1 ff ff       	call   800471 <_panic>

0080232f <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802335:	83 ec 04             	sub    $0x4,%esp
  802338:	68 fc 44 80 00       	push   $0x8044fc
  80233d:	68 2b 02 00 00       	push   $0x22b
  802342:	68 b1 40 80 00       	push   $0x8040b1
  802347:	e8 25 e1 ff ff       	call   800471 <_panic>

0080234c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
  80234f:	57                   	push   %edi
  802350:	56                   	push   %esi
  802351:	53                   	push   %ebx
  802352:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80235e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802361:	8b 7d 18             	mov    0x18(%ebp),%edi
  802364:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802367:	cd 30                	int    $0x30
  802369:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80236c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80236f:	83 c4 10             	add    $0x10,%esp
  802372:	5b                   	pop    %ebx
  802373:	5e                   	pop    %esi
  802374:	5f                   	pop    %edi
  802375:	5d                   	pop    %ebp
  802376:	c3                   	ret    

00802377 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
  80237a:	83 ec 04             	sub    $0x4,%esp
  80237d:	8b 45 10             	mov    0x10(%ebp),%eax
  802380:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802383:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802386:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	6a 00                	push   $0x0
  80238f:	51                   	push   %ecx
  802390:	52                   	push   %edx
  802391:	ff 75 0c             	pushl  0xc(%ebp)
  802394:	50                   	push   %eax
  802395:	6a 00                	push   $0x0
  802397:	e8 b0 ff ff ff       	call   80234c <syscall>
  80239c:	83 c4 18             	add    $0x18,%esp
}
  80239f:	90                   	nop
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 02                	push   $0x2
  8023b1:	e8 96 ff ff ff       	call   80234c <syscall>
  8023b6:	83 c4 18             	add    $0x18,%esp
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <sys_lock_cons>:

void sys_lock_cons(void)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 03                	push   $0x3
  8023ca:	e8 7d ff ff ff       	call   80234c <syscall>
  8023cf:	83 c4 18             	add    $0x18,%esp
}
  8023d2:	90                   	nop
  8023d3:	c9                   	leave  
  8023d4:	c3                   	ret    

008023d5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8023d5:	55                   	push   %ebp
  8023d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 04                	push   $0x4
  8023e4:	e8 63 ff ff ff       	call   80234c <syscall>
  8023e9:	83 c4 18             	add    $0x18,%esp
}
  8023ec:	90                   	nop
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8023f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	52                   	push   %edx
  8023ff:	50                   	push   %eax
  802400:	6a 08                	push   $0x8
  802402:	e8 45 ff ff ff       	call   80234c <syscall>
  802407:	83 c4 18             	add    $0x18,%esp
}
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	56                   	push   %esi
  802410:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802411:	8b 75 18             	mov    0x18(%ebp),%esi
  802414:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802417:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80241a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	56                   	push   %esi
  802421:	53                   	push   %ebx
  802422:	51                   	push   %ecx
  802423:	52                   	push   %edx
  802424:	50                   	push   %eax
  802425:	6a 09                	push   $0x9
  802427:	e8 20 ff ff ff       	call   80234c <syscall>
  80242c:	83 c4 18             	add    $0x18,%esp
}
  80242f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802432:	5b                   	pop    %ebx
  802433:	5e                   	pop    %esi
  802434:	5d                   	pop    %ebp
  802435:	c3                   	ret    

00802436 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	ff 75 08             	pushl  0x8(%ebp)
  802444:	6a 0a                	push   $0xa
  802446:	e8 01 ff ff ff       	call   80234c <syscall>
  80244b:	83 c4 18             	add    $0x18,%esp
}
  80244e:	c9                   	leave  
  80244f:	c3                   	ret    

00802450 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	ff 75 0c             	pushl  0xc(%ebp)
  80245c:	ff 75 08             	pushl  0x8(%ebp)
  80245f:	6a 0b                	push   $0xb
  802461:	e8 e6 fe ff ff       	call   80234c <syscall>
  802466:	83 c4 18             	add    $0x18,%esp
}
  802469:	c9                   	leave  
  80246a:	c3                   	ret    

0080246b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 00                	push   $0x0
  802478:	6a 0c                	push   $0xc
  80247a:	e8 cd fe ff ff       	call   80234c <syscall>
  80247f:	83 c4 18             	add    $0x18,%esp
}
  802482:	c9                   	leave  
  802483:	c3                   	ret    

00802484 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 0d                	push   $0xd
  802493:	e8 b4 fe ff ff       	call   80234c <syscall>
  802498:	83 c4 18             	add    $0x18,%esp
}
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    

0080249d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 0e                	push   $0xe
  8024ac:	e8 9b fe ff ff       	call   80234c <syscall>
  8024b1:	83 c4 18             	add    $0x18,%esp
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 0f                	push   $0xf
  8024c5:	e8 82 fe ff ff       	call   80234c <syscall>
  8024ca:	83 c4 18             	add    $0x18,%esp
}
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	ff 75 08             	pushl  0x8(%ebp)
  8024dd:	6a 10                	push   $0x10
  8024df:	e8 68 fe ff ff       	call   80234c <syscall>
  8024e4:	83 c4 18             	add    $0x18,%esp
}
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 11                	push   $0x11
  8024f8:	e8 4f fe ff ff       	call   80234c <syscall>
  8024fd:	83 c4 18             	add    $0x18,%esp
}
  802500:	90                   	nop
  802501:	c9                   	leave  
  802502:	c3                   	ret    

00802503 <sys_cputc>:

void
sys_cputc(const char c)
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
  802506:	83 ec 04             	sub    $0x4,%esp
  802509:	8b 45 08             	mov    0x8(%ebp),%eax
  80250c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80250f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	50                   	push   %eax
  80251c:	6a 01                	push   $0x1
  80251e:	e8 29 fe ff ff       	call   80234c <syscall>
  802523:	83 c4 18             	add    $0x18,%esp
}
  802526:	90                   	nop
  802527:	c9                   	leave  
  802528:	c3                   	ret    

00802529 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 14                	push   $0x14
  802538:	e8 0f fe ff ff       	call   80234c <syscall>
  80253d:	83 c4 18             	add    $0x18,%esp
}
  802540:	90                   	nop
  802541:	c9                   	leave  
  802542:	c3                   	ret    

00802543 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802543:	55                   	push   %ebp
  802544:	89 e5                	mov    %esp,%ebp
  802546:	83 ec 04             	sub    $0x4,%esp
  802549:	8b 45 10             	mov    0x10(%ebp),%eax
  80254c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80254f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802552:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802556:	8b 45 08             	mov    0x8(%ebp),%eax
  802559:	6a 00                	push   $0x0
  80255b:	51                   	push   %ecx
  80255c:	52                   	push   %edx
  80255d:	ff 75 0c             	pushl  0xc(%ebp)
  802560:	50                   	push   %eax
  802561:	6a 15                	push   $0x15
  802563:	e8 e4 fd ff ff       	call   80234c <syscall>
  802568:	83 c4 18             	add    $0x18,%esp
}
  80256b:	c9                   	leave  
  80256c:	c3                   	ret    

0080256d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802570:	8b 55 0c             	mov    0xc(%ebp),%edx
  802573:	8b 45 08             	mov    0x8(%ebp),%eax
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	52                   	push   %edx
  80257d:	50                   	push   %eax
  80257e:	6a 16                	push   $0x16
  802580:	e8 c7 fd ff ff       	call   80234c <syscall>
  802585:	83 c4 18             	add    $0x18,%esp
}
  802588:	c9                   	leave  
  802589:	c3                   	ret    

0080258a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80258d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802590:	8b 55 0c             	mov    0xc(%ebp),%edx
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	51                   	push   %ecx
  80259b:	52                   	push   %edx
  80259c:	50                   	push   %eax
  80259d:	6a 17                	push   $0x17
  80259f:	e8 a8 fd ff ff       	call   80234c <syscall>
  8025a4:	83 c4 18             	add    $0x18,%esp
}
  8025a7:	c9                   	leave  
  8025a8:	c3                   	ret    

008025a9 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8025ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025af:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	52                   	push   %edx
  8025b9:	50                   	push   %eax
  8025ba:	6a 18                	push   $0x18
  8025bc:	e8 8b fd ff ff       	call   80234c <syscall>
  8025c1:	83 c4 18             	add    $0x18,%esp
}
  8025c4:	c9                   	leave  
  8025c5:	c3                   	ret    

008025c6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8025c6:	55                   	push   %ebp
  8025c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	6a 00                	push   $0x0
  8025ce:	ff 75 14             	pushl  0x14(%ebp)
  8025d1:	ff 75 10             	pushl  0x10(%ebp)
  8025d4:	ff 75 0c             	pushl  0xc(%ebp)
  8025d7:	50                   	push   %eax
  8025d8:	6a 19                	push   $0x19
  8025da:	e8 6d fd ff ff       	call   80234c <syscall>
  8025df:	83 c4 18             	add    $0x18,%esp
}
  8025e2:	c9                   	leave  
  8025e3:	c3                   	ret    

008025e4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8025e4:	55                   	push   %ebp
  8025e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	50                   	push   %eax
  8025f3:	6a 1a                	push   $0x1a
  8025f5:	e8 52 fd ff ff       	call   80234c <syscall>
  8025fa:	83 c4 18             	add    $0x18,%esp
}
  8025fd:	90                   	nop
  8025fe:	c9                   	leave  
  8025ff:	c3                   	ret    

00802600 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802603:	8b 45 08             	mov    0x8(%ebp),%eax
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	50                   	push   %eax
  80260f:	6a 1b                	push   $0x1b
  802611:	e8 36 fd ff ff       	call   80234c <syscall>
  802616:	83 c4 18             	add    $0x18,%esp
}
  802619:	c9                   	leave  
  80261a:	c3                   	ret    

0080261b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80261b:	55                   	push   %ebp
  80261c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	6a 05                	push   $0x5
  80262a:	e8 1d fd ff ff       	call   80234c <syscall>
  80262f:	83 c4 18             	add    $0x18,%esp
}
  802632:	c9                   	leave  
  802633:	c3                   	ret    

00802634 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802634:	55                   	push   %ebp
  802635:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 00                	push   $0x0
  80263f:	6a 00                	push   $0x0
  802641:	6a 06                	push   $0x6
  802643:	e8 04 fd ff ff       	call   80234c <syscall>
  802648:	83 c4 18             	add    $0x18,%esp
}
  80264b:	c9                   	leave  
  80264c:	c3                   	ret    

0080264d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	6a 00                	push   $0x0
  802658:	6a 00                	push   $0x0
  80265a:	6a 07                	push   $0x7
  80265c:	e8 eb fc ff ff       	call   80234c <syscall>
  802661:	83 c4 18             	add    $0x18,%esp
}
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <sys_exit_env>:


void sys_exit_env(void)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	6a 00                	push   $0x0
  802671:	6a 00                	push   $0x0
  802673:	6a 1c                	push   $0x1c
  802675:	e8 d2 fc ff ff       	call   80234c <syscall>
  80267a:	83 c4 18             	add    $0x18,%esp
}
  80267d:	90                   	nop
  80267e:	c9                   	leave  
  80267f:	c3                   	ret    

00802680 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802686:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802689:	8d 50 04             	lea    0x4(%eax),%edx
  80268c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	52                   	push   %edx
  802696:	50                   	push   %eax
  802697:	6a 1d                	push   $0x1d
  802699:	e8 ae fc ff ff       	call   80234c <syscall>
  80269e:	83 c4 18             	add    $0x18,%esp
	return result;
  8026a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026aa:	89 01                	mov    %eax,(%ecx)
  8026ac:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8026af:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b2:	c9                   	leave  
  8026b3:	c2 04 00             	ret    $0x4

008026b6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8026b6:	55                   	push   %ebp
  8026b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	ff 75 10             	pushl  0x10(%ebp)
  8026c0:	ff 75 0c             	pushl  0xc(%ebp)
  8026c3:	ff 75 08             	pushl  0x8(%ebp)
  8026c6:	6a 13                	push   $0x13
  8026c8:	e8 7f fc ff ff       	call   80234c <syscall>
  8026cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8026d0:	90                   	nop
}
  8026d1:	c9                   	leave  
  8026d2:	c3                   	ret    

008026d3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8026d3:	55                   	push   %ebp
  8026d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 1e                	push   $0x1e
  8026e2:	e8 65 fc ff ff       	call   80234c <syscall>
  8026e7:	83 c4 18             	add    $0x18,%esp
}
  8026ea:	c9                   	leave  
  8026eb:	c3                   	ret    

008026ec <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8026ec:	55                   	push   %ebp
  8026ed:	89 e5                	mov    %esp,%ebp
  8026ef:	83 ec 04             	sub    $0x4,%esp
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026f8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	50                   	push   %eax
  802705:	6a 1f                	push   $0x1f
  802707:	e8 40 fc ff ff       	call   80234c <syscall>
  80270c:	83 c4 18             	add    $0x18,%esp
	return ;
  80270f:	90                   	nop
}
  802710:	c9                   	leave  
  802711:	c3                   	ret    

00802712 <rsttst>:
void rsttst()
{
  802712:	55                   	push   %ebp
  802713:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802715:	6a 00                	push   $0x0
  802717:	6a 00                	push   $0x0
  802719:	6a 00                	push   $0x0
  80271b:	6a 00                	push   $0x0
  80271d:	6a 00                	push   $0x0
  80271f:	6a 21                	push   $0x21
  802721:	e8 26 fc ff ff       	call   80234c <syscall>
  802726:	83 c4 18             	add    $0x18,%esp
	return ;
  802729:	90                   	nop
}
  80272a:	c9                   	leave  
  80272b:	c3                   	ret    

0080272c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
  80272f:	83 ec 04             	sub    $0x4,%esp
  802732:	8b 45 14             	mov    0x14(%ebp),%eax
  802735:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802738:	8b 55 18             	mov    0x18(%ebp),%edx
  80273b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80273f:	52                   	push   %edx
  802740:	50                   	push   %eax
  802741:	ff 75 10             	pushl  0x10(%ebp)
  802744:	ff 75 0c             	pushl  0xc(%ebp)
  802747:	ff 75 08             	pushl  0x8(%ebp)
  80274a:	6a 20                	push   $0x20
  80274c:	e8 fb fb ff ff       	call   80234c <syscall>
  802751:	83 c4 18             	add    $0x18,%esp
	return ;
  802754:	90                   	nop
}
  802755:	c9                   	leave  
  802756:	c3                   	ret    

00802757 <chktst>:
void chktst(uint32 n)
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80275a:	6a 00                	push   $0x0
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	6a 00                	push   $0x0
  802762:	ff 75 08             	pushl  0x8(%ebp)
  802765:	6a 22                	push   $0x22
  802767:	e8 e0 fb ff ff       	call   80234c <syscall>
  80276c:	83 c4 18             	add    $0x18,%esp
	return ;
  80276f:	90                   	nop
}
  802770:	c9                   	leave  
  802771:	c3                   	ret    

00802772 <inctst>:

void inctst()
{
  802772:	55                   	push   %ebp
  802773:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802775:	6a 00                	push   $0x0
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 23                	push   $0x23
  802781:	e8 c6 fb ff ff       	call   80234c <syscall>
  802786:	83 c4 18             	add    $0x18,%esp
	return ;
  802789:	90                   	nop
}
  80278a:	c9                   	leave  
  80278b:	c3                   	ret    

0080278c <gettst>:
uint32 gettst()
{
  80278c:	55                   	push   %ebp
  80278d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80278f:	6a 00                	push   $0x0
  802791:	6a 00                	push   $0x0
  802793:	6a 00                	push   $0x0
  802795:	6a 00                	push   $0x0
  802797:	6a 00                	push   $0x0
  802799:	6a 24                	push   $0x24
  80279b:	e8 ac fb ff ff       	call   80234c <syscall>
  8027a0:	83 c4 18             	add    $0x18,%esp
}
  8027a3:	c9                   	leave  
  8027a4:	c3                   	ret    

008027a5 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8027a5:	55                   	push   %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027a8:	6a 00                	push   $0x0
  8027aa:	6a 00                	push   $0x0
  8027ac:	6a 00                	push   $0x0
  8027ae:	6a 00                	push   $0x0
  8027b0:	6a 00                	push   $0x0
  8027b2:	6a 25                	push   $0x25
  8027b4:	e8 93 fb ff ff       	call   80234c <syscall>
  8027b9:	83 c4 18             	add    $0x18,%esp
  8027bc:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  8027c1:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  8027c6:	c9                   	leave  
  8027c7:	c3                   	ret    

008027c8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027c8:	55                   	push   %ebp
  8027c9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8027cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ce:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 00                	push   $0x0
  8027db:	ff 75 08             	pushl  0x8(%ebp)
  8027de:	6a 26                	push   $0x26
  8027e0:	e8 67 fb ff ff       	call   80234c <syscall>
  8027e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8027e8:	90                   	nop
}
  8027e9:	c9                   	leave  
  8027ea:	c3                   	ret    

008027eb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027eb:	55                   	push   %ebp
  8027ec:	89 e5                	mov    %esp,%ebp
  8027ee:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8027ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fb:	6a 00                	push   $0x0
  8027fd:	53                   	push   %ebx
  8027fe:	51                   	push   %ecx
  8027ff:	52                   	push   %edx
  802800:	50                   	push   %eax
  802801:	6a 27                	push   $0x27
  802803:	e8 44 fb ff ff       	call   80234c <syscall>
  802808:	83 c4 18             	add    $0x18,%esp
}
  80280b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80280e:	c9                   	leave  
  80280f:	c3                   	ret    

00802810 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802813:	8b 55 0c             	mov    0xc(%ebp),%edx
  802816:	8b 45 08             	mov    0x8(%ebp),%eax
  802819:	6a 00                	push   $0x0
  80281b:	6a 00                	push   $0x0
  80281d:	6a 00                	push   $0x0
  80281f:	52                   	push   %edx
  802820:	50                   	push   %eax
  802821:	6a 28                	push   $0x28
  802823:	e8 24 fb ff ff       	call   80234c <syscall>
  802828:	83 c4 18             	add    $0x18,%esp
}
  80282b:	c9                   	leave  
  80282c:	c3                   	ret    

0080282d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80282d:	55                   	push   %ebp
  80282e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802830:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802833:	8b 55 0c             	mov    0xc(%ebp),%edx
  802836:	8b 45 08             	mov    0x8(%ebp),%eax
  802839:	6a 00                	push   $0x0
  80283b:	51                   	push   %ecx
  80283c:	ff 75 10             	pushl  0x10(%ebp)
  80283f:	52                   	push   %edx
  802840:	50                   	push   %eax
  802841:	6a 29                	push   $0x29
  802843:	e8 04 fb ff ff       	call   80234c <syscall>
  802848:	83 c4 18             	add    $0x18,%esp
}
  80284b:	c9                   	leave  
  80284c:	c3                   	ret    

0080284d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80284d:	55                   	push   %ebp
  80284e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802850:	6a 00                	push   $0x0
  802852:	6a 00                	push   $0x0
  802854:	ff 75 10             	pushl  0x10(%ebp)
  802857:	ff 75 0c             	pushl  0xc(%ebp)
  80285a:	ff 75 08             	pushl  0x8(%ebp)
  80285d:	6a 12                	push   $0x12
  80285f:	e8 e8 fa ff ff       	call   80234c <syscall>
  802864:	83 c4 18             	add    $0x18,%esp
	return ;
  802867:	90                   	nop
}
  802868:	c9                   	leave  
  802869:	c3                   	ret    

0080286a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80286a:	55                   	push   %ebp
  80286b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80286d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	6a 00                	push   $0x0
  802875:	6a 00                	push   $0x0
  802877:	6a 00                	push   $0x0
  802879:	52                   	push   %edx
  80287a:	50                   	push   %eax
  80287b:	6a 2a                	push   $0x2a
  80287d:	e8 ca fa ff ff       	call   80234c <syscall>
  802882:	83 c4 18             	add    $0x18,%esp
	return;
  802885:	90                   	nop
}
  802886:	c9                   	leave  
  802887:	c3                   	ret    

00802888 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802888:	55                   	push   %ebp
  802889:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80288b:	6a 00                	push   $0x0
  80288d:	6a 00                	push   $0x0
  80288f:	6a 00                	push   $0x0
  802891:	6a 00                	push   $0x0
  802893:	6a 00                	push   $0x0
  802895:	6a 2b                	push   $0x2b
  802897:	e8 b0 fa ff ff       	call   80234c <syscall>
  80289c:	83 c4 18             	add    $0x18,%esp
}
  80289f:	c9                   	leave  
  8028a0:	c3                   	ret    

008028a1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8028a1:	55                   	push   %ebp
  8028a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8028a4:	6a 00                	push   $0x0
  8028a6:	6a 00                	push   $0x0
  8028a8:	6a 00                	push   $0x0
  8028aa:	ff 75 0c             	pushl  0xc(%ebp)
  8028ad:	ff 75 08             	pushl  0x8(%ebp)
  8028b0:	6a 2d                	push   $0x2d
  8028b2:	e8 95 fa ff ff       	call   80234c <syscall>
  8028b7:	83 c4 18             	add    $0x18,%esp
	return;
  8028ba:	90                   	nop
}
  8028bb:	c9                   	leave  
  8028bc:	c3                   	ret    

008028bd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8028bd:	55                   	push   %ebp
  8028be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8028c0:	6a 00                	push   $0x0
  8028c2:	6a 00                	push   $0x0
  8028c4:	6a 00                	push   $0x0
  8028c6:	ff 75 0c             	pushl  0xc(%ebp)
  8028c9:	ff 75 08             	pushl  0x8(%ebp)
  8028cc:	6a 2c                	push   $0x2c
  8028ce:	e8 79 fa ff ff       	call   80234c <syscall>
  8028d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8028d6:	90                   	nop
}
  8028d7:	c9                   	leave  
  8028d8:	c3                   	ret    

008028d9 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8028d9:	55                   	push   %ebp
  8028da:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8028dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028df:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e2:	6a 00                	push   $0x0
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 00                	push   $0x0
  8028e8:	52                   	push   %edx
  8028e9:	50                   	push   %eax
  8028ea:	6a 2e                	push   $0x2e
  8028ec:	e8 5b fa ff ff       	call   80234c <syscall>
  8028f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8028f4:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  8028f5:	c9                   	leave  
  8028f6:	c3                   	ret    

008028f7 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8028f7:	55                   	push   %ebp
  8028f8:	89 e5                	mov    %esp,%ebp
  8028fa:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8028fd:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802904:	72 09                	jb     80290f <to_page_va+0x18>
  802906:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  80290d:	72 14                	jb     802923 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80290f:	83 ec 04             	sub    $0x4,%esp
  802912:	68 20 45 80 00       	push   $0x804520
  802917:	6a 15                	push   $0x15
  802919:	68 4b 45 80 00       	push   $0x80454b
  80291e:	e8 4e db ff ff       	call   800471 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	ba 60 50 80 00       	mov    $0x805060,%edx
  80292b:	29 d0                	sub    %edx,%eax
  80292d:	c1 f8 02             	sar    $0x2,%eax
  802930:	89 c2                	mov    %eax,%edx
  802932:	89 d0                	mov    %edx,%eax
  802934:	c1 e0 02             	shl    $0x2,%eax
  802937:	01 d0                	add    %edx,%eax
  802939:	c1 e0 02             	shl    $0x2,%eax
  80293c:	01 d0                	add    %edx,%eax
  80293e:	c1 e0 02             	shl    $0x2,%eax
  802941:	01 d0                	add    %edx,%eax
  802943:	89 c1                	mov    %eax,%ecx
  802945:	c1 e1 08             	shl    $0x8,%ecx
  802948:	01 c8                	add    %ecx,%eax
  80294a:	89 c1                	mov    %eax,%ecx
  80294c:	c1 e1 10             	shl    $0x10,%ecx
  80294f:	01 c8                	add    %ecx,%eax
  802951:	01 c0                	add    %eax,%eax
  802953:	01 d0                	add    %edx,%eax
  802955:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	c1 e0 0c             	shl    $0xc,%eax
  80295e:	89 c2                	mov    %eax,%edx
  802960:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802965:	01 d0                	add    %edx,%eax
}
  802967:	c9                   	leave  
  802968:	c3                   	ret    

00802969 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802969:	55                   	push   %ebp
  80296a:	89 e5                	mov    %esp,%ebp
  80296c:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80296f:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802974:	8b 55 08             	mov    0x8(%ebp),%edx
  802977:	29 c2                	sub    %eax,%edx
  802979:	89 d0                	mov    %edx,%eax
  80297b:	c1 e8 0c             	shr    $0xc,%eax
  80297e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802981:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802985:	78 09                	js     802990 <to_page_info+0x27>
  802987:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80298e:	7e 14                	jle    8029a4 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802990:	83 ec 04             	sub    $0x4,%esp
  802993:	68 64 45 80 00       	push   $0x804564
  802998:	6a 22                	push   $0x22
  80299a:	68 4b 45 80 00       	push   $0x80454b
  80299f:	e8 cd da ff ff       	call   800471 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8029a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a7:	89 d0                	mov    %edx,%eax
  8029a9:	01 c0                	add    %eax,%eax
  8029ab:	01 d0                	add    %edx,%eax
  8029ad:	c1 e0 02             	shl    $0x2,%eax
  8029b0:	05 60 50 80 00       	add    $0x805060,%eax
}
  8029b5:	c9                   	leave  
  8029b6:	c3                   	ret    

008029b7 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8029b7:	55                   	push   %ebp
  8029b8:	89 e5                	mov    %esp,%ebp
  8029ba:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c0:	05 00 00 00 02       	add    $0x2000000,%eax
  8029c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029c8:	73 16                	jae    8029e0 <initialize_dynamic_allocator+0x29>
  8029ca:	68 88 45 80 00       	push   $0x804588
  8029cf:	68 ae 45 80 00       	push   $0x8045ae
  8029d4:	6a 34                	push   $0x34
  8029d6:	68 4b 45 80 00       	push   $0x80454b
  8029db:	e8 91 da ff ff       	call   800471 <_panic>
		is_initialized = 1;
  8029e0:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  8029e7:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  8029ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ed:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  8029f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029f5:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  8029fa:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802a01:	00 00 00 
  802a04:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802a0b:	00 00 00 
  802a0e:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802a15:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802a18:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802a1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a26:	eb 36                	jmp    802a5e <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	c1 e0 04             	shl    $0x4,%eax
  802a2e:	05 80 d0 81 00       	add    $0x81d080,%eax
  802a33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	c1 e0 04             	shl    $0x4,%eax
  802a3f:	05 84 d0 81 00       	add    $0x81d084,%eax
  802a44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	c1 e0 04             	shl    $0x4,%eax
  802a50:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802a55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802a5b:	ff 45 f4             	incl   -0xc(%ebp)
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a64:	72 c2                	jb     802a28 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802a66:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a6c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a71:	29 c2                	sub    %eax,%edx
  802a73:	89 d0                	mov    %edx,%eax
  802a75:	c1 e8 0c             	shr    $0xc,%eax
  802a78:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802a7b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802a82:	e9 c8 00 00 00       	jmp    802b4f <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802a87:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a8a:	89 d0                	mov    %edx,%eax
  802a8c:	01 c0                	add    %eax,%eax
  802a8e:	01 d0                	add    %edx,%eax
  802a90:	c1 e0 02             	shl    $0x2,%eax
  802a93:	05 68 50 80 00       	add    $0x805068,%eax
  802a98:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802a9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa0:	89 d0                	mov    %edx,%eax
  802aa2:	01 c0                	add    %eax,%eax
  802aa4:	01 d0                	add    %edx,%eax
  802aa6:	c1 e0 02             	shl    $0x2,%eax
  802aa9:	05 6a 50 80 00       	add    $0x80506a,%eax
  802aae:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802ab3:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802ab9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802abc:	89 c8                	mov    %ecx,%eax
  802abe:	01 c0                	add    %eax,%eax
  802ac0:	01 c8                	add    %ecx,%eax
  802ac2:	c1 e0 02             	shl    $0x2,%eax
  802ac5:	05 64 50 80 00       	add    $0x805064,%eax
  802aca:	89 10                	mov    %edx,(%eax)
  802acc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802acf:	89 d0                	mov    %edx,%eax
  802ad1:	01 c0                	add    %eax,%eax
  802ad3:	01 d0                	add    %edx,%eax
  802ad5:	c1 e0 02             	shl    $0x2,%eax
  802ad8:	05 64 50 80 00       	add    $0x805064,%eax
  802add:	8b 00                	mov    (%eax),%eax
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	74 1b                	je     802afe <initialize_dynamic_allocator+0x147>
  802ae3:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802ae9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802aec:	89 c8                	mov    %ecx,%eax
  802aee:	01 c0                	add    %eax,%eax
  802af0:	01 c8                	add    %ecx,%eax
  802af2:	c1 e0 02             	shl    $0x2,%eax
  802af5:	05 60 50 80 00       	add    $0x805060,%eax
  802afa:	89 02                	mov    %eax,(%edx)
  802afc:	eb 16                	jmp    802b14 <initialize_dynamic_allocator+0x15d>
  802afe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b01:	89 d0                	mov    %edx,%eax
  802b03:	01 c0                	add    %eax,%eax
  802b05:	01 d0                	add    %edx,%eax
  802b07:	c1 e0 02             	shl    $0x2,%eax
  802b0a:	05 60 50 80 00       	add    $0x805060,%eax
  802b0f:	a3 48 50 80 00       	mov    %eax,0x805048
  802b14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b17:	89 d0                	mov    %edx,%eax
  802b19:	01 c0                	add    %eax,%eax
  802b1b:	01 d0                	add    %edx,%eax
  802b1d:	c1 e0 02             	shl    $0x2,%eax
  802b20:	05 60 50 80 00       	add    $0x805060,%eax
  802b25:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802b2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b2d:	89 d0                	mov    %edx,%eax
  802b2f:	01 c0                	add    %eax,%eax
  802b31:	01 d0                	add    %edx,%eax
  802b33:	c1 e0 02             	shl    $0x2,%eax
  802b36:	05 60 50 80 00       	add    $0x805060,%eax
  802b3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b41:	a1 54 50 80 00       	mov    0x805054,%eax
  802b46:	40                   	inc    %eax
  802b47:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802b4c:	ff 45 f0             	incl   -0x10(%ebp)
  802b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b52:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802b55:	0f 82 2c ff ff ff    	jb     802a87 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802b5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b61:	eb 2f                	jmp    802b92 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802b63:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b66:	89 d0                	mov    %edx,%eax
  802b68:	01 c0                	add    %eax,%eax
  802b6a:	01 d0                	add    %edx,%eax
  802b6c:	c1 e0 02             	shl    $0x2,%eax
  802b6f:	05 68 50 80 00       	add    $0x805068,%eax
  802b74:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802b79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b7c:	89 d0                	mov    %edx,%eax
  802b7e:	01 c0                	add    %eax,%eax
  802b80:	01 d0                	add    %edx,%eax
  802b82:	c1 e0 02             	shl    $0x2,%eax
  802b85:	05 6a 50 80 00       	add    $0x80506a,%eax
  802b8a:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802b8f:	ff 45 ec             	incl   -0x14(%ebp)
  802b92:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802b99:	76 c8                	jbe    802b63 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802b9b:	90                   	nop
  802b9c:	c9                   	leave  
  802b9d:	c3                   	ret    

00802b9e <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802b9e:	55                   	push   %ebp
  802b9f:	89 e5                	mov    %esp,%ebp
  802ba1:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802ba4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba7:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802bac:	29 c2                	sub    %eax,%edx
  802bae:	89 d0                	mov    %edx,%eax
  802bb0:	c1 e8 0c             	shr    $0xc,%eax
  802bb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802bb6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802bb9:	89 d0                	mov    %edx,%eax
  802bbb:	01 c0                	add    %eax,%eax
  802bbd:	01 d0                	add    %edx,%eax
  802bbf:	c1 e0 02             	shl    $0x2,%eax
  802bc2:	05 68 50 80 00       	add    $0x805068,%eax
  802bc7:	8b 00                	mov    (%eax),%eax
  802bc9:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802bcc:	c9                   	leave  
  802bcd:	c3                   	ret    

00802bce <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802bce:	55                   	push   %ebp
  802bcf:	89 e5                	mov    %esp,%ebp
  802bd1:	83 ec 14             	sub    $0x14,%esp
  802bd4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802bd7:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802bdb:	77 07                	ja     802be4 <nearest_pow2_ceil.1513+0x16>
  802bdd:	b8 01 00 00 00       	mov    $0x1,%eax
  802be2:	eb 20                	jmp    802c04 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802be4:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802beb:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802bee:	eb 08                	jmp    802bf8 <nearest_pow2_ceil.1513+0x2a>
  802bf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802bf3:	01 c0                	add    %eax,%eax
  802bf5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802bf8:	d1 6d 08             	shrl   0x8(%ebp)
  802bfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bff:	75 ef                	jne    802bf0 <nearest_pow2_ceil.1513+0x22>
        return power;
  802c01:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802c04:	c9                   	leave  
  802c05:	c3                   	ret    

00802c06 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802c06:	55                   	push   %ebp
  802c07:	89 e5                	mov    %esp,%ebp
  802c09:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802c0c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802c13:	76 16                	jbe    802c2b <alloc_block+0x25>
  802c15:	68 c4 45 80 00       	push   $0x8045c4
  802c1a:	68 ae 45 80 00       	push   $0x8045ae
  802c1f:	6a 72                	push   $0x72
  802c21:	68 4b 45 80 00       	push   $0x80454b
  802c26:	e8 46 d8 ff ff       	call   800471 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802c2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2f:	75 0a                	jne    802c3b <alloc_block+0x35>
  802c31:	b8 00 00 00 00       	mov    $0x0,%eax
  802c36:	e9 bd 04 00 00       	jmp    8030f8 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802c3b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802c48:	73 06                	jae    802c50 <alloc_block+0x4a>
        size = min_block_size;
  802c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4d:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802c50:	83 ec 0c             	sub    $0xc,%esp
  802c53:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802c56:	ff 75 08             	pushl  0x8(%ebp)
  802c59:	89 c1                	mov    %eax,%ecx
  802c5b:	e8 6e ff ff ff       	call   802bce <nearest_pow2_ceil.1513>
  802c60:	83 c4 10             	add    $0x10,%esp
  802c63:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802c66:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c69:	83 ec 0c             	sub    $0xc,%esp
  802c6c:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802c6f:	52                   	push   %edx
  802c70:	89 c1                	mov    %eax,%ecx
  802c72:	e8 83 04 00 00       	call   8030fa <log2_ceil.1520>
  802c77:	83 c4 10             	add    $0x10,%esp
  802c7a:	83 e8 03             	sub    $0x3,%eax
  802c7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802c80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c83:	c1 e0 04             	shl    $0x4,%eax
  802c86:	05 80 d0 81 00       	add    $0x81d080,%eax
  802c8b:	8b 00                	mov    (%eax),%eax
  802c8d:	85 c0                	test   %eax,%eax
  802c8f:	0f 84 d8 00 00 00    	je     802d6d <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802c95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c98:	c1 e0 04             	shl    $0x4,%eax
  802c9b:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ca0:	8b 00                	mov    (%eax),%eax
  802ca2:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802ca5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ca9:	75 17                	jne    802cc2 <alloc_block+0xbc>
  802cab:	83 ec 04             	sub    $0x4,%esp
  802cae:	68 e5 45 80 00       	push   $0x8045e5
  802cb3:	68 98 00 00 00       	push   $0x98
  802cb8:	68 4b 45 80 00       	push   $0x80454b
  802cbd:	e8 af d7 ff ff       	call   800471 <_panic>
  802cc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc5:	8b 00                	mov    (%eax),%eax
  802cc7:	85 c0                	test   %eax,%eax
  802cc9:	74 10                	je     802cdb <alloc_block+0xd5>
  802ccb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cd3:	8b 52 04             	mov    0x4(%edx),%edx
  802cd6:	89 50 04             	mov    %edx,0x4(%eax)
  802cd9:	eb 14                	jmp    802cef <alloc_block+0xe9>
  802cdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cde:	8b 40 04             	mov    0x4(%eax),%eax
  802ce1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ce4:	c1 e2 04             	shl    $0x4,%edx
  802ce7:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802ced:	89 02                	mov    %eax,(%edx)
  802cef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cf2:	8b 40 04             	mov    0x4(%eax),%eax
  802cf5:	85 c0                	test   %eax,%eax
  802cf7:	74 0f                	je     802d08 <alloc_block+0x102>
  802cf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cfc:	8b 40 04             	mov    0x4(%eax),%eax
  802cff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d02:	8b 12                	mov    (%edx),%edx
  802d04:	89 10                	mov    %edx,(%eax)
  802d06:	eb 13                	jmp    802d1b <alloc_block+0x115>
  802d08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d10:	c1 e2 04             	shl    $0x4,%edx
  802d13:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802d19:	89 02                	mov    %eax,(%edx)
  802d1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d31:	c1 e0 04             	shl    $0x4,%eax
  802d34:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d39:	8b 00                	mov    (%eax),%eax
  802d3b:	8d 50 ff             	lea    -0x1(%eax),%edx
  802d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d41:	c1 e0 04             	shl    $0x4,%eax
  802d44:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d49:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802d4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d4e:	83 ec 0c             	sub    $0xc,%esp
  802d51:	50                   	push   %eax
  802d52:	e8 12 fc ff ff       	call   802969 <to_page_info>
  802d57:	83 c4 10             	add    $0x10,%esp
  802d5a:	89 c2                	mov    %eax,%edx
  802d5c:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802d60:	48                   	dec    %eax
  802d61:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802d65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d68:	e9 8b 03 00 00       	jmp    8030f8 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802d6d:	a1 48 50 80 00       	mov    0x805048,%eax
  802d72:	85 c0                	test   %eax,%eax
  802d74:	0f 84 64 02 00 00    	je     802fde <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802d7a:	a1 48 50 80 00       	mov    0x805048,%eax
  802d7f:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802d82:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d86:	75 17                	jne    802d9f <alloc_block+0x199>
  802d88:	83 ec 04             	sub    $0x4,%esp
  802d8b:	68 e5 45 80 00       	push   $0x8045e5
  802d90:	68 a0 00 00 00       	push   $0xa0
  802d95:	68 4b 45 80 00       	push   $0x80454b
  802d9a:	e8 d2 d6 ff ff       	call   800471 <_panic>
  802d9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da2:	8b 00                	mov    (%eax),%eax
  802da4:	85 c0                	test   %eax,%eax
  802da6:	74 10                	je     802db8 <alloc_block+0x1b2>
  802da8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dab:	8b 00                	mov    (%eax),%eax
  802dad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802db0:	8b 52 04             	mov    0x4(%edx),%edx
  802db3:	89 50 04             	mov    %edx,0x4(%eax)
  802db6:	eb 0b                	jmp    802dc3 <alloc_block+0x1bd>
  802db8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dbb:	8b 40 04             	mov    0x4(%eax),%eax
  802dbe:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802dc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc6:	8b 40 04             	mov    0x4(%eax),%eax
  802dc9:	85 c0                	test   %eax,%eax
  802dcb:	74 0f                	je     802ddc <alloc_block+0x1d6>
  802dcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd0:	8b 40 04             	mov    0x4(%eax),%eax
  802dd3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dd6:	8b 12                	mov    (%edx),%edx
  802dd8:	89 10                	mov    %edx,(%eax)
  802dda:	eb 0a                	jmp    802de6 <alloc_block+0x1e0>
  802ddc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ddf:	8b 00                	mov    (%eax),%eax
  802de1:	a3 48 50 80 00       	mov    %eax,0x805048
  802de6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802def:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df9:	a1 54 50 80 00       	mov    0x805054,%eax
  802dfe:	48                   	dec    %eax
  802dff:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802e04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e07:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e0a:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802e0e:	b8 00 10 00 00       	mov    $0x1000,%eax
  802e13:	99                   	cltd   
  802e14:	f7 7d e8             	idivl  -0x18(%ebp)
  802e17:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e1a:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802e1e:	83 ec 0c             	sub    $0xc,%esp
  802e21:	ff 75 dc             	pushl  -0x24(%ebp)
  802e24:	e8 ce fa ff ff       	call   8028f7 <to_page_va>
  802e29:	83 c4 10             	add    $0x10,%esp
  802e2c:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802e2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e32:	83 ec 0c             	sub    $0xc,%esp
  802e35:	50                   	push   %eax
  802e36:	e8 c0 ee ff ff       	call   801cfb <get_page>
  802e3b:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802e3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e45:	e9 aa 00 00 00       	jmp    802ef4 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802e51:	89 c2                	mov    %eax,%edx
  802e53:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e56:	01 d0                	add    %edx,%eax
  802e58:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802e5b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802e5f:	75 17                	jne    802e78 <alloc_block+0x272>
  802e61:	83 ec 04             	sub    $0x4,%esp
  802e64:	68 04 46 80 00       	push   $0x804604
  802e69:	68 aa 00 00 00       	push   $0xaa
  802e6e:	68 4b 45 80 00       	push   $0x80454b
  802e73:	e8 f9 d5 ff ff       	call   800471 <_panic>
  802e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7b:	c1 e0 04             	shl    $0x4,%eax
  802e7e:	05 84 d0 81 00       	add    $0x81d084,%eax
  802e83:	8b 10                	mov    (%eax),%edx
  802e85:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e88:	89 50 04             	mov    %edx,0x4(%eax)
  802e8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e8e:	8b 40 04             	mov    0x4(%eax),%eax
  802e91:	85 c0                	test   %eax,%eax
  802e93:	74 14                	je     802ea9 <alloc_block+0x2a3>
  802e95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e98:	c1 e0 04             	shl    $0x4,%eax
  802e9b:	05 84 d0 81 00       	add    $0x81d084,%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ea5:	89 10                	mov    %edx,(%eax)
  802ea7:	eb 11                	jmp    802eba <alloc_block+0x2b4>
  802ea9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eac:	c1 e0 04             	shl    $0x4,%eax
  802eaf:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802eb5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802eb8:	89 02                	mov    %eax,(%edx)
  802eba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ebd:	c1 e0 04             	shl    $0x4,%eax
  802ec0:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802ec6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ec9:	89 02                	mov    %eax,(%edx)
  802ecb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ece:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed7:	c1 e0 04             	shl    $0x4,%eax
  802eda:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	8d 50 01             	lea    0x1(%eax),%edx
  802ee4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee7:	c1 e0 04             	shl    $0x4,%eax
  802eea:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802eef:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802ef1:	ff 45 f4             	incl   -0xc(%ebp)
  802ef4:	b8 00 10 00 00       	mov    $0x1000,%eax
  802ef9:	99                   	cltd   
  802efa:	f7 7d e8             	idivl  -0x18(%ebp)
  802efd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802f00:	0f 8f 44 ff ff ff    	jg     802e4a <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802f06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f09:	c1 e0 04             	shl    $0x4,%eax
  802f0c:	05 80 d0 81 00       	add    $0x81d080,%eax
  802f11:	8b 00                	mov    (%eax),%eax
  802f13:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802f16:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802f1a:	75 17                	jne    802f33 <alloc_block+0x32d>
  802f1c:	83 ec 04             	sub    $0x4,%esp
  802f1f:	68 e5 45 80 00       	push   $0x8045e5
  802f24:	68 ae 00 00 00       	push   $0xae
  802f29:	68 4b 45 80 00       	push   $0x80454b
  802f2e:	e8 3e d5 ff ff       	call   800471 <_panic>
  802f33:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	74 10                	je     802f4c <alloc_block+0x346>
  802f3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f3f:	8b 00                	mov    (%eax),%eax
  802f41:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f44:	8b 52 04             	mov    0x4(%edx),%edx
  802f47:	89 50 04             	mov    %edx,0x4(%eax)
  802f4a:	eb 14                	jmp    802f60 <alloc_block+0x35a>
  802f4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f4f:	8b 40 04             	mov    0x4(%eax),%eax
  802f52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f55:	c1 e2 04             	shl    $0x4,%edx
  802f58:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802f5e:	89 02                	mov    %eax,(%edx)
  802f60:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f63:	8b 40 04             	mov    0x4(%eax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	74 0f                	je     802f79 <alloc_block+0x373>
  802f6a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f6d:	8b 40 04             	mov    0x4(%eax),%eax
  802f70:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f73:	8b 12                	mov    (%edx),%edx
  802f75:	89 10                	mov    %edx,(%eax)
  802f77:	eb 13                	jmp    802f8c <alloc_block+0x386>
  802f79:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f7c:	8b 00                	mov    (%eax),%eax
  802f7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f81:	c1 e2 04             	shl    $0x4,%edx
  802f84:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802f8a:	89 02                	mov    %eax,(%edx)
  802f8c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f95:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa2:	c1 e0 04             	shl    $0x4,%eax
  802fa5:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802faa:	8b 00                	mov    (%eax),%eax
  802fac:	8d 50 ff             	lea    -0x1(%eax),%edx
  802faf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb2:	c1 e0 04             	shl    $0x4,%eax
  802fb5:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802fba:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802fbc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fbf:	83 ec 0c             	sub    $0xc,%esp
  802fc2:	50                   	push   %eax
  802fc3:	e8 a1 f9 ff ff       	call   802969 <to_page_info>
  802fc8:	83 c4 10             	add    $0x10,%esp
  802fcb:	89 c2                	mov    %eax,%edx
  802fcd:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802fd1:	48                   	dec    %eax
  802fd2:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802fd6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fd9:	e9 1a 01 00 00       	jmp    8030f8 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802fde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe1:	40                   	inc    %eax
  802fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802fe5:	e9 ed 00 00 00       	jmp    8030d7 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fed:	c1 e0 04             	shl    $0x4,%eax
  802ff0:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ff5:	8b 00                	mov    (%eax),%eax
  802ff7:	85 c0                	test   %eax,%eax
  802ff9:	0f 84 d5 00 00 00    	je     8030d4 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803002:	c1 e0 04             	shl    $0x4,%eax
  803005:	05 80 d0 81 00       	add    $0x81d080,%eax
  80300a:	8b 00                	mov    (%eax),%eax
  80300c:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  80300f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803013:	75 17                	jne    80302c <alloc_block+0x426>
  803015:	83 ec 04             	sub    $0x4,%esp
  803018:	68 e5 45 80 00       	push   $0x8045e5
  80301d:	68 b8 00 00 00       	push   $0xb8
  803022:	68 4b 45 80 00       	push   $0x80454b
  803027:	e8 45 d4 ff ff       	call   800471 <_panic>
  80302c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80302f:	8b 00                	mov    (%eax),%eax
  803031:	85 c0                	test   %eax,%eax
  803033:	74 10                	je     803045 <alloc_block+0x43f>
  803035:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803038:	8b 00                	mov    (%eax),%eax
  80303a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80303d:	8b 52 04             	mov    0x4(%edx),%edx
  803040:	89 50 04             	mov    %edx,0x4(%eax)
  803043:	eb 14                	jmp    803059 <alloc_block+0x453>
  803045:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803048:	8b 40 04             	mov    0x4(%eax),%eax
  80304b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80304e:	c1 e2 04             	shl    $0x4,%edx
  803051:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803057:	89 02                	mov    %eax,(%edx)
  803059:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80305c:	8b 40 04             	mov    0x4(%eax),%eax
  80305f:	85 c0                	test   %eax,%eax
  803061:	74 0f                	je     803072 <alloc_block+0x46c>
  803063:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803066:	8b 40 04             	mov    0x4(%eax),%eax
  803069:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80306c:	8b 12                	mov    (%edx),%edx
  80306e:	89 10                	mov    %edx,(%eax)
  803070:	eb 13                	jmp    803085 <alloc_block+0x47f>
  803072:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803075:	8b 00                	mov    (%eax),%eax
  803077:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80307a:	c1 e2 04             	shl    $0x4,%edx
  80307d:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803083:	89 02                	mov    %eax,(%edx)
  803085:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803088:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80308e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803091:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309b:	c1 e0 04             	shl    $0x4,%eax
  80309e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8030a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ab:	c1 e0 04             	shl    $0x4,%eax
  8030ae:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030b3:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8030b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b8:	83 ec 0c             	sub    $0xc,%esp
  8030bb:	50                   	push   %eax
  8030bc:	e8 a8 f8 ff ff       	call   802969 <to_page_info>
  8030c1:	83 c4 10             	add    $0x10,%esp
  8030c4:	89 c2                	mov    %eax,%edx
  8030c6:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8030ca:	48                   	dec    %eax
  8030cb:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  8030cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030d2:	eb 24                	jmp    8030f8 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8030d4:	ff 45 f0             	incl   -0x10(%ebp)
  8030d7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8030db:	0f 8e 09 ff ff ff    	jle    802fea <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8030e1:	83 ec 04             	sub    $0x4,%esp
  8030e4:	68 27 46 80 00       	push   $0x804627
  8030e9:	68 bf 00 00 00       	push   $0xbf
  8030ee:	68 4b 45 80 00       	push   $0x80454b
  8030f3:	e8 79 d3 ff ff       	call   800471 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8030f8:	c9                   	leave  
  8030f9:	c3                   	ret    

008030fa <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  8030fa:	55                   	push   %ebp
  8030fb:	89 e5                	mov    %esp,%ebp
  8030fd:	83 ec 14             	sub    $0x14,%esp
  803100:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  803103:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803107:	75 07                	jne    803110 <log2_ceil.1520+0x16>
  803109:	b8 00 00 00 00       	mov    $0x0,%eax
  80310e:	eb 1b                	jmp    80312b <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  803110:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  803117:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  80311a:	eb 06                	jmp    803122 <log2_ceil.1520+0x28>
            x >>= 1;
  80311c:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  80311f:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  803122:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803126:	75 f4                	jne    80311c <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  803128:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  80312b:	c9                   	leave  
  80312c:	c3                   	ret    

0080312d <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  80312d:	55                   	push   %ebp
  80312e:	89 e5                	mov    %esp,%ebp
  803130:	83 ec 14             	sub    $0x14,%esp
  803133:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803136:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313a:	75 07                	jne    803143 <log2_ceil.1547+0x16>
  80313c:	b8 00 00 00 00       	mov    $0x0,%eax
  803141:	eb 1b                	jmp    80315e <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  803143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  80314a:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  80314d:	eb 06                	jmp    803155 <log2_ceil.1547+0x28>
			x >>= 1;
  80314f:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  803152:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  803155:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803159:	75 f4                	jne    80314f <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  80315b:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80315e:	c9                   	leave  
  80315f:	c3                   	ret    

00803160 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803160:	55                   	push   %ebp
  803161:	89 e5                	mov    %esp,%ebp
  803163:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803166:	8b 55 08             	mov    0x8(%ebp),%edx
  803169:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80316e:	39 c2                	cmp    %eax,%edx
  803170:	72 0c                	jb     80317e <free_block+0x1e>
  803172:	8b 55 08             	mov    0x8(%ebp),%edx
  803175:	a1 40 50 80 00       	mov    0x805040,%eax
  80317a:	39 c2                	cmp    %eax,%edx
  80317c:	72 19                	jb     803197 <free_block+0x37>
  80317e:	68 2c 46 80 00       	push   $0x80462c
  803183:	68 ae 45 80 00       	push   $0x8045ae
  803188:	68 d0 00 00 00       	push   $0xd0
  80318d:	68 4b 45 80 00       	push   $0x80454b
  803192:	e8 da d2 ff ff       	call   800471 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803197:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80319b:	0f 84 42 03 00 00    	je     8034e3 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8031a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a4:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031a9:	39 c2                	cmp    %eax,%edx
  8031ab:	72 0c                	jb     8031b9 <free_block+0x59>
  8031ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b0:	a1 40 50 80 00       	mov    0x805040,%eax
  8031b5:	39 c2                	cmp    %eax,%edx
  8031b7:	72 17                	jb     8031d0 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8031b9:	83 ec 04             	sub    $0x4,%esp
  8031bc:	68 64 46 80 00       	push   $0x804664
  8031c1:	68 e6 00 00 00       	push   $0xe6
  8031c6:	68 4b 45 80 00       	push   $0x80454b
  8031cb:	e8 a1 d2 ff ff       	call   800471 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8031d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d3:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031d8:	29 c2                	sub    %eax,%edx
  8031da:	89 d0                	mov    %edx,%eax
  8031dc:	83 e0 07             	and    $0x7,%eax
  8031df:	85 c0                	test   %eax,%eax
  8031e1:	74 17                	je     8031fa <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8031e3:	83 ec 04             	sub    $0x4,%esp
  8031e6:	68 98 46 80 00       	push   $0x804698
  8031eb:	68 ea 00 00 00       	push   $0xea
  8031f0:	68 4b 45 80 00       	push   $0x80454b
  8031f5:	e8 77 d2 ff ff       	call   800471 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	83 ec 0c             	sub    $0xc,%esp
  803200:	50                   	push   %eax
  803201:	e8 63 f7 ff ff       	call   802969 <to_page_info>
  803206:	83 c4 10             	add    $0x10,%esp
  803209:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  80320c:	83 ec 0c             	sub    $0xc,%esp
  80320f:	ff 75 08             	pushl  0x8(%ebp)
  803212:	e8 87 f9 ff ff       	call   802b9e <get_block_size>
  803217:	83 c4 10             	add    $0x10,%esp
  80321a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  80321d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803221:	75 17                	jne    80323a <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  803223:	83 ec 04             	sub    $0x4,%esp
  803226:	68 c4 46 80 00       	push   $0x8046c4
  80322b:	68 f1 00 00 00       	push   $0xf1
  803230:	68 4b 45 80 00       	push   $0x80454b
  803235:	e8 37 d2 ff ff       	call   800471 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  80323a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80323d:	83 ec 0c             	sub    $0xc,%esp
  803240:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803243:	52                   	push   %edx
  803244:	89 c1                	mov    %eax,%ecx
  803246:	e8 e2 fe ff ff       	call   80312d <log2_ceil.1547>
  80324b:	83 c4 10             	add    $0x10,%esp
  80324e:	83 e8 03             	sub    $0x3,%eax
  803251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803254:	8b 45 08             	mov    0x8(%ebp),%eax
  803257:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  80325a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80325e:	75 17                	jne    803277 <free_block+0x117>
  803260:	83 ec 04             	sub    $0x4,%esp
  803263:	68 10 47 80 00       	push   $0x804710
  803268:	68 f6 00 00 00       	push   $0xf6
  80326d:	68 4b 45 80 00       	push   $0x80454b
  803272:	e8 fa d1 ff ff       	call   800471 <_panic>
  803277:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327a:	c1 e0 04             	shl    $0x4,%eax
  80327d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803282:	8b 10                	mov    (%eax),%edx
  803284:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803287:	89 10                	mov    %edx,(%eax)
  803289:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80328c:	8b 00                	mov    (%eax),%eax
  80328e:	85 c0                	test   %eax,%eax
  803290:	74 15                	je     8032a7 <free_block+0x147>
  803292:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803295:	c1 e0 04             	shl    $0x4,%eax
  803298:	05 80 d0 81 00       	add    $0x81d080,%eax
  80329d:	8b 00                	mov    (%eax),%eax
  80329f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032a2:	89 50 04             	mov    %edx,0x4(%eax)
  8032a5:	eb 11                	jmp    8032b8 <free_block+0x158>
  8032a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032aa:	c1 e0 04             	shl    $0x4,%eax
  8032ad:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  8032b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032b6:	89 02                	mov    %eax,(%edx)
  8032b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032bb:	c1 e0 04             	shl    $0x4,%eax
  8032be:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  8032c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c7:	89 02                	mov    %eax,(%edx)
  8032c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d6:	c1 e0 04             	shl    $0x4,%eax
  8032d9:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032de:	8b 00                	mov    (%eax),%eax
  8032e0:	8d 50 01             	lea    0x1(%eax),%edx
  8032e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e6:	c1 e0 04             	shl    $0x4,%eax
  8032e9:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032ee:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8032f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f3:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8032f7:	40                   	inc    %eax
  8032f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032fb:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8032ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803302:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803307:	29 c2                	sub    %eax,%edx
  803309:	89 d0                	mov    %edx,%eax
  80330b:	c1 e8 0c             	shr    $0xc,%eax
  80330e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  803311:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803314:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803318:	0f b7 c8             	movzwl %ax,%ecx
  80331b:	b8 00 10 00 00       	mov    $0x1000,%eax
  803320:	99                   	cltd   
  803321:	f7 7d e8             	idivl  -0x18(%ebp)
  803324:	39 c1                	cmp    %eax,%ecx
  803326:	0f 85 b8 01 00 00    	jne    8034e4 <free_block+0x384>
    	uint32 blocks_removed = 0;
  80332c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803336:	c1 e0 04             	shl    $0x4,%eax
  803339:	05 80 d0 81 00       	add    $0x81d080,%eax
  80333e:	8b 00                	mov    (%eax),%eax
  803340:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803343:	e9 d5 00 00 00       	jmp    80341d <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334b:	8b 00                	mov    (%eax),%eax
  80334d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803350:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803353:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803358:	29 c2                	sub    %eax,%edx
  80335a:	89 d0                	mov    %edx,%eax
  80335c:	c1 e8 0c             	shr    $0xc,%eax
  80335f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803362:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803365:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803368:	0f 85 a9 00 00 00    	jne    803417 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  80336e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803372:	75 17                	jne    80338b <free_block+0x22b>
  803374:	83 ec 04             	sub    $0x4,%esp
  803377:	68 e5 45 80 00       	push   $0x8045e5
  80337c:	68 04 01 00 00       	push   $0x104
  803381:	68 4b 45 80 00       	push   $0x80454b
  803386:	e8 e6 d0 ff ff       	call   800471 <_panic>
  80338b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338e:	8b 00                	mov    (%eax),%eax
  803390:	85 c0                	test   %eax,%eax
  803392:	74 10                	je     8033a4 <free_block+0x244>
  803394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803397:	8b 00                	mov    (%eax),%eax
  803399:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80339c:	8b 52 04             	mov    0x4(%edx),%edx
  80339f:	89 50 04             	mov    %edx,0x4(%eax)
  8033a2:	eb 14                	jmp    8033b8 <free_block+0x258>
  8033a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a7:	8b 40 04             	mov    0x4(%eax),%eax
  8033aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033ad:	c1 e2 04             	shl    $0x4,%edx
  8033b0:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8033b6:	89 02                	mov    %eax,(%edx)
  8033b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bb:	8b 40 04             	mov    0x4(%eax),%eax
  8033be:	85 c0                	test   %eax,%eax
  8033c0:	74 0f                	je     8033d1 <free_block+0x271>
  8033c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c5:	8b 40 04             	mov    0x4(%eax),%eax
  8033c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033cb:	8b 12                	mov    (%edx),%edx
  8033cd:	89 10                	mov    %edx,(%eax)
  8033cf:	eb 13                	jmp    8033e4 <free_block+0x284>
  8033d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d4:	8b 00                	mov    (%eax),%eax
  8033d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033d9:	c1 e2 04             	shl    $0x4,%edx
  8033dc:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8033e2:	89 02                	mov    %eax,(%edx)
  8033e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fa:	c1 e0 04             	shl    $0x4,%eax
  8033fd:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803402:	8b 00                	mov    (%eax),%eax
  803404:	8d 50 ff             	lea    -0x1(%eax),%edx
  803407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340a:	c1 e0 04             	shl    $0x4,%eax
  80340d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803412:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803414:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803417:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80341a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80341d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803421:	0f 85 21 ff ff ff    	jne    803348 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803427:	b8 00 10 00 00       	mov    $0x1000,%eax
  80342c:	99                   	cltd   
  80342d:	f7 7d e8             	idivl  -0x18(%ebp)
  803430:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803433:	74 17                	je     80344c <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803435:	83 ec 04             	sub    $0x4,%esp
  803438:	68 34 47 80 00       	push   $0x804734
  80343d:	68 0c 01 00 00       	push   $0x10c
  803442:	68 4b 45 80 00       	push   $0x80454b
  803447:	e8 25 d0 ff ff       	call   800471 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  80344c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80344f:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803455:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803458:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  80345e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803462:	75 17                	jne    80347b <free_block+0x31b>
  803464:	83 ec 04             	sub    $0x4,%esp
  803467:	68 04 46 80 00       	push   $0x804604
  80346c:	68 11 01 00 00       	push   $0x111
  803471:	68 4b 45 80 00       	push   $0x80454b
  803476:	e8 f6 cf ff ff       	call   800471 <_panic>
  80347b:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803481:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803484:	89 50 04             	mov    %edx,0x4(%eax)
  803487:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80348a:	8b 40 04             	mov    0x4(%eax),%eax
  80348d:	85 c0                	test   %eax,%eax
  80348f:	74 0c                	je     80349d <free_block+0x33d>
  803491:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803496:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803499:	89 10                	mov    %edx,(%eax)
  80349b:	eb 08                	jmp    8034a5 <free_block+0x345>
  80349d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a0:	a3 48 50 80 00       	mov    %eax,0x805048
  8034a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a8:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8034ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034b6:	a1 54 50 80 00       	mov    0x805054,%eax
  8034bb:	40                   	inc    %eax
  8034bc:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  8034c1:	83 ec 0c             	sub    $0xc,%esp
  8034c4:	ff 75 ec             	pushl  -0x14(%ebp)
  8034c7:	e8 2b f4 ff ff       	call   8028f7 <to_page_va>
  8034cc:	83 c4 10             	add    $0x10,%esp
  8034cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8034d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034d5:	83 ec 0c             	sub    $0xc,%esp
  8034d8:	50                   	push   %eax
  8034d9:	e8 69 e8 ff ff       	call   801d47 <return_page>
  8034de:	83 c4 10             	add    $0x10,%esp
  8034e1:	eb 01                	jmp    8034e4 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8034e3:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8034e4:	c9                   	leave  
  8034e5:	c3                   	ret    

008034e6 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8034e6:	55                   	push   %ebp
  8034e7:	89 e5                	mov    %esp,%ebp
  8034e9:	83 ec 14             	sub    $0x14,%esp
  8034ec:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8034ef:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8034f3:	77 07                	ja     8034fc <nearest_pow2_ceil.1572+0x16>
      return 1;
  8034f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8034fa:	eb 20                	jmp    80351c <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8034fc:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803503:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803506:	eb 08                	jmp    803510 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803508:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80350b:	01 c0                	add    %eax,%eax
  80350d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803510:	d1 6d 08             	shrl   0x8(%ebp)
  803513:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803517:	75 ef                	jne    803508 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803519:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  80351c:	c9                   	leave  
  80351d:	c3                   	ret    

0080351e <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  80351e:	55                   	push   %ebp
  80351f:	89 e5                	mov    %esp,%ebp
  803521:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803524:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803528:	75 13                	jne    80353d <realloc_block+0x1f>
    return alloc_block(new_size);
  80352a:	83 ec 0c             	sub    $0xc,%esp
  80352d:	ff 75 0c             	pushl  0xc(%ebp)
  803530:	e8 d1 f6 ff ff       	call   802c06 <alloc_block>
  803535:	83 c4 10             	add    $0x10,%esp
  803538:	e9 d9 00 00 00       	jmp    803616 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  80353d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803541:	75 18                	jne    80355b <realloc_block+0x3d>
    free_block(va);
  803543:	83 ec 0c             	sub    $0xc,%esp
  803546:	ff 75 08             	pushl  0x8(%ebp)
  803549:	e8 12 fc ff ff       	call   803160 <free_block>
  80354e:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803551:	b8 00 00 00 00       	mov    $0x0,%eax
  803556:	e9 bb 00 00 00       	jmp    803616 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  80355b:	83 ec 0c             	sub    $0xc,%esp
  80355e:	ff 75 08             	pushl  0x8(%ebp)
  803561:	e8 38 f6 ff ff       	call   802b9e <get_block_size>
  803566:	83 c4 10             	add    $0x10,%esp
  803569:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  80356c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803573:	8b 45 0c             	mov    0xc(%ebp),%eax
  803576:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803579:	73 06                	jae    803581 <realloc_block+0x63>
    new_size = min_block_size;
  80357b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80357e:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803581:	83 ec 0c             	sub    $0xc,%esp
  803584:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803587:	ff 75 0c             	pushl  0xc(%ebp)
  80358a:	89 c1                	mov    %eax,%ecx
  80358c:	e8 55 ff ff ff       	call   8034e6 <nearest_pow2_ceil.1572>
  803591:	83 c4 10             	add    $0x10,%esp
  803594:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80359a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80359d:	75 05                	jne    8035a4 <realloc_block+0x86>
    return va;
  80359f:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a2:	eb 72                	jmp    803616 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  8035a4:	83 ec 0c             	sub    $0xc,%esp
  8035a7:	ff 75 0c             	pushl  0xc(%ebp)
  8035aa:	e8 57 f6 ff ff       	call   802c06 <alloc_block>
  8035af:	83 c4 10             	add    $0x10,%esp
  8035b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8035b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035b9:	75 07                	jne    8035c2 <realloc_block+0xa4>
    return NULL;
  8035bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c0:	eb 54                	jmp    803616 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  8035c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c8:	39 d0                	cmp    %edx,%eax
  8035ca:	76 02                	jbe    8035ce <realloc_block+0xb0>
  8035cc:	89 d0                	mov    %edx,%eax
  8035ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  8035d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8035d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8035dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8035e4:	eb 17                	jmp    8035fd <realloc_block+0xdf>
    dst[i] = src[i];
  8035e6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ec:	01 c2                	add    %eax,%edx
  8035ee:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8035f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f4:	01 c8                	add    %ecx,%eax
  8035f6:	8a 00                	mov    (%eax),%al
  8035f8:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  8035fa:	ff 45 f4             	incl   -0xc(%ebp)
  8035fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803600:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803603:	72 e1                	jb     8035e6 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803605:	83 ec 0c             	sub    $0xc,%esp
  803608:	ff 75 08             	pushl  0x8(%ebp)
  80360b:	e8 50 fb ff ff       	call   803160 <free_block>
  803610:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803616:	c9                   	leave  
  803617:	c3                   	ret    

00803618 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803618:	55                   	push   %ebp
  803619:	89 e5                	mov    %esp,%ebp
  80361b:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  80361e:	83 ec 04             	sub    $0x4,%esp
  803621:	68 68 47 80 00       	push   $0x804768
  803626:	6a 07                	push   $0x7
  803628:	68 97 47 80 00       	push   $0x804797
  80362d:	e8 3f ce ff ff       	call   800471 <_panic>

00803632 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803632:	55                   	push   %ebp
  803633:	89 e5                	mov    %esp,%ebp
  803635:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  803638:	83 ec 04             	sub    $0x4,%esp
  80363b:	68 a8 47 80 00       	push   $0x8047a8
  803640:	6a 0b                	push   $0xb
  803642:	68 97 47 80 00       	push   $0x804797
  803647:	e8 25 ce ff ff       	call   800471 <_panic>

0080364c <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  80364c:	55                   	push   %ebp
  80364d:	89 e5                	mov    %esp,%ebp
  80364f:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803652:	83 ec 04             	sub    $0x4,%esp
  803655:	68 d4 47 80 00       	push   $0x8047d4
  80365a:	6a 10                	push   $0x10
  80365c:	68 97 47 80 00       	push   $0x804797
  803661:	e8 0b ce ff ff       	call   800471 <_panic>

00803666 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  803666:	55                   	push   %ebp
  803667:	89 e5                	mov    %esp,%ebp
  803669:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  80366c:	83 ec 04             	sub    $0x4,%esp
  80366f:	68 04 48 80 00       	push   $0x804804
  803674:	6a 15                	push   $0x15
  803676:	68 97 47 80 00       	push   $0x804797
  80367b:	e8 f1 cd ff ff       	call   800471 <_panic>

00803680 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  803680:	55                   	push   %ebp
  803681:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803683:	8b 45 08             	mov    0x8(%ebp),%eax
  803686:	8b 40 10             	mov    0x10(%eax),%eax
}
  803689:	5d                   	pop    %ebp
  80368a:	c3                   	ret    
  80368b:	90                   	nop

0080368c <__udivdi3>:
  80368c:	55                   	push   %ebp
  80368d:	57                   	push   %edi
  80368e:	56                   	push   %esi
  80368f:	53                   	push   %ebx
  803690:	83 ec 1c             	sub    $0x1c,%esp
  803693:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803697:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80369b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80369f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036a3:	89 ca                	mov    %ecx,%edx
  8036a5:	89 f8                	mov    %edi,%eax
  8036a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036ab:	85 f6                	test   %esi,%esi
  8036ad:	75 2d                	jne    8036dc <__udivdi3+0x50>
  8036af:	39 cf                	cmp    %ecx,%edi
  8036b1:	77 65                	ja     803718 <__udivdi3+0x8c>
  8036b3:	89 fd                	mov    %edi,%ebp
  8036b5:	85 ff                	test   %edi,%edi
  8036b7:	75 0b                	jne    8036c4 <__udivdi3+0x38>
  8036b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8036be:	31 d2                	xor    %edx,%edx
  8036c0:	f7 f7                	div    %edi
  8036c2:	89 c5                	mov    %eax,%ebp
  8036c4:	31 d2                	xor    %edx,%edx
  8036c6:	89 c8                	mov    %ecx,%eax
  8036c8:	f7 f5                	div    %ebp
  8036ca:	89 c1                	mov    %eax,%ecx
  8036cc:	89 d8                	mov    %ebx,%eax
  8036ce:	f7 f5                	div    %ebp
  8036d0:	89 cf                	mov    %ecx,%edi
  8036d2:	89 fa                	mov    %edi,%edx
  8036d4:	83 c4 1c             	add    $0x1c,%esp
  8036d7:	5b                   	pop    %ebx
  8036d8:	5e                   	pop    %esi
  8036d9:	5f                   	pop    %edi
  8036da:	5d                   	pop    %ebp
  8036db:	c3                   	ret    
  8036dc:	39 ce                	cmp    %ecx,%esi
  8036de:	77 28                	ja     803708 <__udivdi3+0x7c>
  8036e0:	0f bd fe             	bsr    %esi,%edi
  8036e3:	83 f7 1f             	xor    $0x1f,%edi
  8036e6:	75 40                	jne    803728 <__udivdi3+0x9c>
  8036e8:	39 ce                	cmp    %ecx,%esi
  8036ea:	72 0a                	jb     8036f6 <__udivdi3+0x6a>
  8036ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8036f0:	0f 87 9e 00 00 00    	ja     803794 <__udivdi3+0x108>
  8036f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8036fb:	89 fa                	mov    %edi,%edx
  8036fd:	83 c4 1c             	add    $0x1c,%esp
  803700:	5b                   	pop    %ebx
  803701:	5e                   	pop    %esi
  803702:	5f                   	pop    %edi
  803703:	5d                   	pop    %ebp
  803704:	c3                   	ret    
  803705:	8d 76 00             	lea    0x0(%esi),%esi
  803708:	31 ff                	xor    %edi,%edi
  80370a:	31 c0                	xor    %eax,%eax
  80370c:	89 fa                	mov    %edi,%edx
  80370e:	83 c4 1c             	add    $0x1c,%esp
  803711:	5b                   	pop    %ebx
  803712:	5e                   	pop    %esi
  803713:	5f                   	pop    %edi
  803714:	5d                   	pop    %ebp
  803715:	c3                   	ret    
  803716:	66 90                	xchg   %ax,%ax
  803718:	89 d8                	mov    %ebx,%eax
  80371a:	f7 f7                	div    %edi
  80371c:	31 ff                	xor    %edi,%edi
  80371e:	89 fa                	mov    %edi,%edx
  803720:	83 c4 1c             	add    $0x1c,%esp
  803723:	5b                   	pop    %ebx
  803724:	5e                   	pop    %esi
  803725:	5f                   	pop    %edi
  803726:	5d                   	pop    %ebp
  803727:	c3                   	ret    
  803728:	bd 20 00 00 00       	mov    $0x20,%ebp
  80372d:	89 eb                	mov    %ebp,%ebx
  80372f:	29 fb                	sub    %edi,%ebx
  803731:	89 f9                	mov    %edi,%ecx
  803733:	d3 e6                	shl    %cl,%esi
  803735:	89 c5                	mov    %eax,%ebp
  803737:	88 d9                	mov    %bl,%cl
  803739:	d3 ed                	shr    %cl,%ebp
  80373b:	89 e9                	mov    %ebp,%ecx
  80373d:	09 f1                	or     %esi,%ecx
  80373f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803743:	89 f9                	mov    %edi,%ecx
  803745:	d3 e0                	shl    %cl,%eax
  803747:	89 c5                	mov    %eax,%ebp
  803749:	89 d6                	mov    %edx,%esi
  80374b:	88 d9                	mov    %bl,%cl
  80374d:	d3 ee                	shr    %cl,%esi
  80374f:	89 f9                	mov    %edi,%ecx
  803751:	d3 e2                	shl    %cl,%edx
  803753:	8b 44 24 08          	mov    0x8(%esp),%eax
  803757:	88 d9                	mov    %bl,%cl
  803759:	d3 e8                	shr    %cl,%eax
  80375b:	09 c2                	or     %eax,%edx
  80375d:	89 d0                	mov    %edx,%eax
  80375f:	89 f2                	mov    %esi,%edx
  803761:	f7 74 24 0c          	divl   0xc(%esp)
  803765:	89 d6                	mov    %edx,%esi
  803767:	89 c3                	mov    %eax,%ebx
  803769:	f7 e5                	mul    %ebp
  80376b:	39 d6                	cmp    %edx,%esi
  80376d:	72 19                	jb     803788 <__udivdi3+0xfc>
  80376f:	74 0b                	je     80377c <__udivdi3+0xf0>
  803771:	89 d8                	mov    %ebx,%eax
  803773:	31 ff                	xor    %edi,%edi
  803775:	e9 58 ff ff ff       	jmp    8036d2 <__udivdi3+0x46>
  80377a:	66 90                	xchg   %ax,%ax
  80377c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803780:	89 f9                	mov    %edi,%ecx
  803782:	d3 e2                	shl    %cl,%edx
  803784:	39 c2                	cmp    %eax,%edx
  803786:	73 e9                	jae    803771 <__udivdi3+0xe5>
  803788:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80378b:	31 ff                	xor    %edi,%edi
  80378d:	e9 40 ff ff ff       	jmp    8036d2 <__udivdi3+0x46>
  803792:	66 90                	xchg   %ax,%ax
  803794:	31 c0                	xor    %eax,%eax
  803796:	e9 37 ff ff ff       	jmp    8036d2 <__udivdi3+0x46>
  80379b:	90                   	nop

0080379c <__umoddi3>:
  80379c:	55                   	push   %ebp
  80379d:	57                   	push   %edi
  80379e:	56                   	push   %esi
  80379f:	53                   	push   %ebx
  8037a0:	83 ec 1c             	sub    $0x1c,%esp
  8037a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037bb:	89 f3                	mov    %esi,%ebx
  8037bd:	89 fa                	mov    %edi,%edx
  8037bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037c3:	89 34 24             	mov    %esi,(%esp)
  8037c6:	85 c0                	test   %eax,%eax
  8037c8:	75 1a                	jne    8037e4 <__umoddi3+0x48>
  8037ca:	39 f7                	cmp    %esi,%edi
  8037cc:	0f 86 a2 00 00 00    	jbe    803874 <__umoddi3+0xd8>
  8037d2:	89 c8                	mov    %ecx,%eax
  8037d4:	89 f2                	mov    %esi,%edx
  8037d6:	f7 f7                	div    %edi
  8037d8:	89 d0                	mov    %edx,%eax
  8037da:	31 d2                	xor    %edx,%edx
  8037dc:	83 c4 1c             	add    $0x1c,%esp
  8037df:	5b                   	pop    %ebx
  8037e0:	5e                   	pop    %esi
  8037e1:	5f                   	pop    %edi
  8037e2:	5d                   	pop    %ebp
  8037e3:	c3                   	ret    
  8037e4:	39 f0                	cmp    %esi,%eax
  8037e6:	0f 87 ac 00 00 00    	ja     803898 <__umoddi3+0xfc>
  8037ec:	0f bd e8             	bsr    %eax,%ebp
  8037ef:	83 f5 1f             	xor    $0x1f,%ebp
  8037f2:	0f 84 ac 00 00 00    	je     8038a4 <__umoddi3+0x108>
  8037f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8037fd:	29 ef                	sub    %ebp,%edi
  8037ff:	89 fe                	mov    %edi,%esi
  803801:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803805:	89 e9                	mov    %ebp,%ecx
  803807:	d3 e0                	shl    %cl,%eax
  803809:	89 d7                	mov    %edx,%edi
  80380b:	89 f1                	mov    %esi,%ecx
  80380d:	d3 ef                	shr    %cl,%edi
  80380f:	09 c7                	or     %eax,%edi
  803811:	89 e9                	mov    %ebp,%ecx
  803813:	d3 e2                	shl    %cl,%edx
  803815:	89 14 24             	mov    %edx,(%esp)
  803818:	89 d8                	mov    %ebx,%eax
  80381a:	d3 e0                	shl    %cl,%eax
  80381c:	89 c2                	mov    %eax,%edx
  80381e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803822:	d3 e0                	shl    %cl,%eax
  803824:	89 44 24 04          	mov    %eax,0x4(%esp)
  803828:	8b 44 24 08          	mov    0x8(%esp),%eax
  80382c:	89 f1                	mov    %esi,%ecx
  80382e:	d3 e8                	shr    %cl,%eax
  803830:	09 d0                	or     %edx,%eax
  803832:	d3 eb                	shr    %cl,%ebx
  803834:	89 da                	mov    %ebx,%edx
  803836:	f7 f7                	div    %edi
  803838:	89 d3                	mov    %edx,%ebx
  80383a:	f7 24 24             	mull   (%esp)
  80383d:	89 c6                	mov    %eax,%esi
  80383f:	89 d1                	mov    %edx,%ecx
  803841:	39 d3                	cmp    %edx,%ebx
  803843:	0f 82 87 00 00 00    	jb     8038d0 <__umoddi3+0x134>
  803849:	0f 84 91 00 00 00    	je     8038e0 <__umoddi3+0x144>
  80384f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803853:	29 f2                	sub    %esi,%edx
  803855:	19 cb                	sbb    %ecx,%ebx
  803857:	89 d8                	mov    %ebx,%eax
  803859:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80385d:	d3 e0                	shl    %cl,%eax
  80385f:	89 e9                	mov    %ebp,%ecx
  803861:	d3 ea                	shr    %cl,%edx
  803863:	09 d0                	or     %edx,%eax
  803865:	89 e9                	mov    %ebp,%ecx
  803867:	d3 eb                	shr    %cl,%ebx
  803869:	89 da                	mov    %ebx,%edx
  80386b:	83 c4 1c             	add    $0x1c,%esp
  80386e:	5b                   	pop    %ebx
  80386f:	5e                   	pop    %esi
  803870:	5f                   	pop    %edi
  803871:	5d                   	pop    %ebp
  803872:	c3                   	ret    
  803873:	90                   	nop
  803874:	89 fd                	mov    %edi,%ebp
  803876:	85 ff                	test   %edi,%edi
  803878:	75 0b                	jne    803885 <__umoddi3+0xe9>
  80387a:	b8 01 00 00 00       	mov    $0x1,%eax
  80387f:	31 d2                	xor    %edx,%edx
  803881:	f7 f7                	div    %edi
  803883:	89 c5                	mov    %eax,%ebp
  803885:	89 f0                	mov    %esi,%eax
  803887:	31 d2                	xor    %edx,%edx
  803889:	f7 f5                	div    %ebp
  80388b:	89 c8                	mov    %ecx,%eax
  80388d:	f7 f5                	div    %ebp
  80388f:	89 d0                	mov    %edx,%eax
  803891:	e9 44 ff ff ff       	jmp    8037da <__umoddi3+0x3e>
  803896:	66 90                	xchg   %ax,%ax
  803898:	89 c8                	mov    %ecx,%eax
  80389a:	89 f2                	mov    %esi,%edx
  80389c:	83 c4 1c             	add    $0x1c,%esp
  80389f:	5b                   	pop    %ebx
  8038a0:	5e                   	pop    %esi
  8038a1:	5f                   	pop    %edi
  8038a2:	5d                   	pop    %ebp
  8038a3:	c3                   	ret    
  8038a4:	3b 04 24             	cmp    (%esp),%eax
  8038a7:	72 06                	jb     8038af <__umoddi3+0x113>
  8038a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038ad:	77 0f                	ja     8038be <__umoddi3+0x122>
  8038af:	89 f2                	mov    %esi,%edx
  8038b1:	29 f9                	sub    %edi,%ecx
  8038b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038b7:	89 14 24             	mov    %edx,(%esp)
  8038ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038c2:	8b 14 24             	mov    (%esp),%edx
  8038c5:	83 c4 1c             	add    $0x1c,%esp
  8038c8:	5b                   	pop    %ebx
  8038c9:	5e                   	pop    %esi
  8038ca:	5f                   	pop    %edi
  8038cb:	5d                   	pop    %ebp
  8038cc:	c3                   	ret    
  8038cd:	8d 76 00             	lea    0x0(%esi),%esi
  8038d0:	2b 04 24             	sub    (%esp),%eax
  8038d3:	19 fa                	sbb    %edi,%edx
  8038d5:	89 d1                	mov    %edx,%ecx
  8038d7:	89 c6                	mov    %eax,%esi
  8038d9:	e9 71 ff ff ff       	jmp    80384f <__umoddi3+0xb3>
  8038de:	66 90                	xchg   %ax,%ax
  8038e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8038e4:	72 ea                	jb     8038d0 <__umoddi3+0x134>
  8038e6:	89 d9                	mov    %ebx,%ecx
  8038e8:	e9 62 ff ff ff       	jmp    80384f <__umoddi3+0xb3>
