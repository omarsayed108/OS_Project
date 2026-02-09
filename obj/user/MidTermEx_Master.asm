
obj/user/MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 dc 02 00 00       	call   800312 <libmain>
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
  80003b:	83 ec 38             	sub    $0x38,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 60 3a 80 00       	push   $0x803a60
  80004a:	e8 3e 1e 00 00       	call   801e8d <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	char select;
	sys_lock_cons();
  80005e:	e8 9b 21 00 00       	call   8021fe <sys_lock_cons>
	{
		cprintf("%~Which type of concurrency protection do you want to use? \n") ;
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 64 3a 80 00       	push   $0x803a64
  80006b:	e8 32 05 00 00       	call   8005a2 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("%~0) Nothing\n") ;
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 a1 3a 80 00       	push   $0x803aa1
  80007b:	e8 22 05 00 00       	call   8005a2 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("%~1) Semaphores\n") ;
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 af 3a 80 00       	push   $0x803aaf
  80008b:	e8 12 05 00 00       	call   8005a2 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("%~2) SpinLock\n") ;
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 c0 3a 80 00       	push   $0x803ac0
  80009b:	e8 02 05 00 00       	call   8005a2 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("%~your choice (0, 1, 2): ") ;
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 cf 3a 80 00       	push   $0x803acf
  8000ab:	e8 f2 04 00 00       	call   8005a2 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp
		select = getchar() ;
  8000b3:	e8 3d 02 00 00       	call   8002f5 <getchar>
  8000b8:	88 45 f3             	mov    %al,-0xd(%ebp)
		cputchar(select);
  8000bb:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  8000bf:	83 ec 0c             	sub    $0xc,%esp
  8000c2:	50                   	push   %eax
  8000c3:	e8 0e 02 00 00       	call   8002d6 <cputchar>
  8000c8:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	6a 0a                	push   $0xa
  8000d0:	e8 01 02 00 00       	call   8002d6 <cputchar>
  8000d5:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8000d8:	e8 3b 21 00 00       	call   802218 <sys_unlock_cons>

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *protType = smalloc("protType", sizeof(int) , 0) ;
  8000dd:	83 ec 04             	sub    $0x4,%esp
  8000e0:	6a 00                	push   $0x0
  8000e2:	6a 04                	push   $0x4
  8000e4:	68 e9 3a 80 00       	push   $0x803ae9
  8000e9:	e8 9f 1d 00 00       	call   801e8d <smalloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*protType = 0 ;
  8000f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == '1') 		*protType = 1 ;
  8000fd:	80 7d f3 31          	cmpb   $0x31,-0xd(%ebp)
  800101:	75 0b                	jne    80010e <_main+0xd6>
  800103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800106:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  80010c:	eb 0f                	jmp    80011d <_main+0xe5>
	else if (select == '2') *protType = 2 ;
  80010e:	80 7d f3 32          	cmpb   $0x32,-0xd(%ebp)
  800112:	75 09                	jne    80011d <_main+0xe5>
  800114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800117:	c7 00 02 00 00 00    	movl   $0x2,(%eax)

	struct semaphore T, finished, finishedCountMutex;
	struct uspinlock *sT, *sfinishedCountMutex;
	int *numOfFinished ;
	if (*protType == 1)
  80011d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800120:	8b 00                	mov    (%eax),%eax
  800122:	83 f8 01             	cmp    $0x1,%eax
  800125:	75 44                	jne    80016b <_main+0x133>
	{
		T = create_semaphore("T", 0);
  800127:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  80012a:	83 ec 04             	sub    $0x4,%esp
  80012d:	6a 00                	push   $0x0
  80012f:	68 f2 3a 80 00       	push   $0x803af2
  800134:	50                   	push   %eax
  800135:	e8 21 33 00 00       	call   80345b <create_semaphore>
  80013a:	83 c4 0c             	add    $0xc,%esp
		finished = create_semaphore("finished", 0);
  80013d:	8d 45 d0             	lea    -0x30(%ebp),%eax
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 00                	push   $0x0
  800145:	68 f4 3a 80 00       	push   $0x803af4
  80014a:	50                   	push   %eax
  80014b:	e8 0b 33 00 00       	call   80345b <create_semaphore>
  800150:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = create_semaphore("finishedCountMutex", 1);
  800153:	8d 45 cc             	lea    -0x34(%ebp),%eax
  800156:	83 ec 04             	sub    $0x4,%esp
  800159:	6a 01                	push   $0x1
  80015b:	68 fd 3a 80 00       	push   $0x803afd
  800160:	50                   	push   %eax
  800161:	e8 f5 32 00 00       	call   80345b <create_semaphore>
  800166:	83 c4 0c             	add    $0xc,%esp
  800169:	eb 62                	jmp    8001cd <_main+0x195>
	}
	else if (*protType == 2)
  80016b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016e:	8b 00                	mov    (%eax),%eax
  800170:	83 f8 02             	cmp    $0x2,%eax
  800173:	75 58                	jne    8001cd <_main+0x195>
	{
		sT = smalloc("T", sizeof(struct uspinlock), 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 44                	push   $0x44
  80017c:	68 f2 3a 80 00       	push   $0x803af2
  800181:	e8 07 1d 00 00       	call   801e8d <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e8             	mov    %eax,-0x18(%ebp)
		init_uspinlock(sT, "T", 0);
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	6a 00                	push   $0x0
  800191:	68 f2 3a 80 00       	push   $0x803af2
  800196:	ff 75 e8             	pushl  -0x18(%ebp)
  800199:	e8 30 33 00 00       	call   8034ce <init_uspinlock>
  80019e:	83 c4 10             	add    $0x10,%esp
		sfinishedCountMutex = smalloc("finishedCountMutex", sizeof(struct uspinlock), 1);
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	6a 01                	push   $0x1
  8001a6:	6a 44                	push   $0x44
  8001a8:	68 fd 3a 80 00       	push   $0x803afd
  8001ad:	e8 db 1c 00 00       	call   801e8d <smalloc>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		init_uspinlock(sfinishedCountMutex, "finishedCountMutex", 1);
  8001b8:	83 ec 04             	sub    $0x4,%esp
  8001bb:	6a 01                	push   $0x1
  8001bd:	68 fd 3a 80 00       	push   $0x803afd
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 04 33 00 00       	call   8034ce <init_uspinlock>
  8001ca:	83 c4 10             	add    $0x10,%esp
	}
	//Create the check-finishing counter
	numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001cd:	83 ec 04             	sub    $0x4,%esp
  8001d0:	6a 01                	push   $0x1
  8001d2:	6a 04                	push   $0x4
  8001d4:	68 10 3b 80 00       	push   $0x803b10
  8001d9:	e8 af 1c 00 00       	call   801e8d <smalloc>
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  8001e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f2:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  8001f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8001fd:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800203:	89 c1                	mov    %eax,%ecx
  800205:	a1 20 50 80 00       	mov    0x805020,%eax
  80020a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800210:	52                   	push   %edx
  800211:	51                   	push   %ecx
  800212:	50                   	push   %eax
  800213:	68 1e 3b 80 00       	push   $0x803b1e
  800218:	e8 ec 21 00 00       	call   802409 <sys_create_env>
  80021d:	83 c4 10             	add    $0x10,%esp
  800220:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800223:	a1 20 50 80 00       	mov    0x805020,%eax
  800228:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  80022e:	a1 20 50 80 00       	mov    0x805020,%eax
  800233:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800239:	89 c1                	mov    %eax,%ecx
  80023b:	a1 20 50 80 00       	mov    0x805020,%eax
  800240:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800246:	52                   	push   %edx
  800247:	51                   	push   %ecx
  800248:	50                   	push   %eax
  800249:	68 28 3b 80 00       	push   $0x803b28
  80024e:	e8 b6 21 00 00       	call   802409 <sys_create_env>
  800253:	83 c4 10             	add    $0x10,%esp
  800256:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 dc             	pushl  -0x24(%ebp)
  80025f:	e8 c3 21 00 00       	call   802427 <sys_run_env>
  800264:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	ff 75 d8             	pushl  -0x28(%ebp)
  80026d:	e8 b5 21 00 00       	call   802427 <sys_run_env>
  800272:	83 c4 10             	add    $0x10,%esp

	/*[5] WAIT TILL FINISHING BOTH PROCESSES*/
	if (*protType == 1)
  800275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800278:	8b 00                	mov    (%eax),%eax
  80027a:	83 f8 01             	cmp    $0x1,%eax
  80027d:	75 1c                	jne    80029b <_main+0x263>
	{
		wait_semaphore(finished);
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	ff 75 d0             	pushl  -0x30(%ebp)
  800285:	e8 05 32 00 00       	call   80348f <wait_semaphore>
  80028a:	83 c4 10             	add    $0x10,%esp
		wait_semaphore(finished);
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	ff 75 d0             	pushl  -0x30(%ebp)
  800293:	e8 f7 31 00 00       	call   80348f <wait_semaphore>
  800298:	83 c4 10             	add    $0x10,%esp
	}
	if (*protType == 2)
  80029b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80029e:	8b 00                	mov    (%eax),%eax
  8002a0:	83 f8 02             	cmp    $0x2,%eax
  8002a3:	75 0d                	jne    8002b2 <_main+0x27a>
	{
		while (*numOfFinished != 2) ;
  8002a5:	90                   	nop
  8002a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a9:	8b 00                	mov    (%eax),%eax
  8002ab:	83 f8 02             	cmp    $0x2,%eax
  8002ae:	75 f6                	jne    8002a6 <_main+0x26e>
  8002b0:	eb 0b                	jmp    8002bd <_main+0x285>
	}
	else
	{
		while (*numOfFinished != 2) ;
  8002b2:	90                   	nop
  8002b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b6:	8b 00                	mov    (%eax),%eax
  8002b8:	83 f8 02             	cmp    $0x2,%eax
  8002bb:	75 f6                	jne    8002b3 <_main+0x27b>
	}

	/*[6] PRINT X*/
	atomic_cprintf("%~Final value of X = %d\n", *X);
  8002bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c0:	8b 00                	mov    (%eax),%eax
  8002c2:	83 ec 08             	sub    $0x8,%esp
  8002c5:	50                   	push   %eax
  8002c6:	68 32 3b 80 00       	push   $0x803b32
  8002cb:	e8 44 03 00 00       	call   800614 <atomic_cprintf>
  8002d0:	83 c4 10             	add    $0x10,%esp

	return;
  8002d3:	90                   	nop
}
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8002dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002df:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8002e2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002e6:	83 ec 0c             	sub    $0xc,%esp
  8002e9:	50                   	push   %eax
  8002ea:	e8 57 20 00 00       	call   802346 <sys_cputc>
  8002ef:	83 c4 10             	add    $0x10,%esp
}
  8002f2:	90                   	nop
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <getchar>:


int
getchar(void)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8002fb:	e8 e5 1e 00 00       	call   8021e5 <sys_cgetc>
  800300:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <iscons>:

int iscons(int fdnum)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80030b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800310:	5d                   	pop    %ebp
  800311:	c3                   	ret    

00800312 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	57                   	push   %edi
  800316:	56                   	push   %esi
  800317:	53                   	push   %ebx
  800318:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80031b:	e8 57 21 00 00       	call   802477 <sys_getenvindex>
  800320:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800323:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800326:	89 d0                	mov    %edx,%eax
  800328:	01 c0                	add    %eax,%eax
  80032a:	01 d0                	add    %edx,%eax
  80032c:	c1 e0 02             	shl    $0x2,%eax
  80032f:	01 d0                	add    %edx,%eax
  800331:	c1 e0 02             	shl    $0x2,%eax
  800334:	01 d0                	add    %edx,%eax
  800336:	c1 e0 03             	shl    $0x3,%eax
  800339:	01 d0                	add    %edx,%eax
  80033b:	c1 e0 02             	shl    $0x2,%eax
  80033e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800343:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800348:	a1 20 50 80 00       	mov    0x805020,%eax
  80034d:	8a 40 20             	mov    0x20(%eax),%al
  800350:	84 c0                	test   %al,%al
  800352:	74 0d                	je     800361 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800354:	a1 20 50 80 00       	mov    0x805020,%eax
  800359:	83 c0 20             	add    $0x20,%eax
  80035c:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800361:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800365:	7e 0a                	jle    800371 <libmain+0x5f>
		binaryname = argv[0];
  800367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036a:	8b 00                	mov    (%eax),%eax
  80036c:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800371:	83 ec 08             	sub    $0x8,%esp
  800374:	ff 75 0c             	pushl  0xc(%ebp)
  800377:	ff 75 08             	pushl  0x8(%ebp)
  80037a:	e8 b9 fc ff ff       	call   800038 <_main>
  80037f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800382:	a1 00 50 80 00       	mov    0x805000,%eax
  800387:	85 c0                	test   %eax,%eax
  800389:	0f 84 01 01 00 00    	je     800490 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80038f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800395:	bb 44 3c 80 00       	mov    $0x803c44,%ebx
  80039a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80039f:	89 c7                	mov    %eax,%edi
  8003a1:	89 de                	mov    %ebx,%esi
  8003a3:	89 d1                	mov    %edx,%ecx
  8003a5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003a7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8003aa:	b9 56 00 00 00       	mov    $0x56,%ecx
  8003af:	b0 00                	mov    $0x0,%al
  8003b1:	89 d7                	mov    %edx,%edi
  8003b3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8003b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	50                   	push   %eax
  8003c3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003c9:	50                   	push   %eax
  8003ca:	e8 de 22 00 00       	call   8026ad <sys_utilities>
  8003cf:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003d2:	e8 27 1e 00 00       	call   8021fe <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003d7:	83 ec 0c             	sub    $0xc,%esp
  8003da:	68 64 3b 80 00       	push   $0x803b64
  8003df:	e8 be 01 00 00       	call   8005a2 <cprintf>
  8003e4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ea:	85 c0                	test   %eax,%eax
  8003ec:	74 18                	je     800406 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003ee:	e8 d8 22 00 00       	call   8026cb <sys_get_optimal_num_faults>
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	50                   	push   %eax
  8003f7:	68 8c 3b 80 00       	push   $0x803b8c
  8003fc:	e8 a1 01 00 00       	call   8005a2 <cprintf>
  800401:	83 c4 10             	add    $0x10,%esp
  800404:	eb 59                	jmp    80045f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800406:	a1 20 50 80 00       	mov    0x805020,%eax
  80040b:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800411:	a1 20 50 80 00       	mov    0x805020,%eax
  800416:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80041c:	83 ec 04             	sub    $0x4,%esp
  80041f:	52                   	push   %edx
  800420:	50                   	push   %eax
  800421:	68 b0 3b 80 00       	push   $0x803bb0
  800426:	e8 77 01 00 00       	call   8005a2 <cprintf>
  80042b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80042e:	a1 20 50 80 00       	mov    0x805020,%eax
  800433:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800439:	a1 20 50 80 00       	mov    0x805020,%eax
  80043e:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800444:	a1 20 50 80 00       	mov    0x805020,%eax
  800449:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80044f:	51                   	push   %ecx
  800450:	52                   	push   %edx
  800451:	50                   	push   %eax
  800452:	68 d8 3b 80 00       	push   $0x803bd8
  800457:	e8 46 01 00 00       	call   8005a2 <cprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045f:	a1 20 50 80 00       	mov    0x805020,%eax
  800464:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	50                   	push   %eax
  80046e:	68 30 3c 80 00       	push   $0x803c30
  800473:	e8 2a 01 00 00       	call   8005a2 <cprintf>
  800478:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80047b:	83 ec 0c             	sub    $0xc,%esp
  80047e:	68 64 3b 80 00       	push   $0x803b64
  800483:	e8 1a 01 00 00       	call   8005a2 <cprintf>
  800488:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80048b:	e8 88 1d 00 00       	call   802218 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800490:	e8 1f 00 00 00       	call   8004b4 <exit>
}
  800495:	90                   	nop
  800496:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800499:	5b                   	pop    %ebx
  80049a:	5e                   	pop    %esi
  80049b:	5f                   	pop    %edi
  80049c:	5d                   	pop    %ebp
  80049d:	c3                   	ret    

0080049e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004a4:	83 ec 0c             	sub    $0xc,%esp
  8004a7:	6a 00                	push   $0x0
  8004a9:	e8 95 1f 00 00       	call   802443 <sys_destroy_env>
  8004ae:	83 c4 10             	add    $0x10,%esp
}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <exit>:

void
exit(void)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ba:	e8 ea 1f 00 00       	call   8024a9 <sys_exit_env>
}
  8004bf:	90                   	nop
  8004c0:	c9                   	leave  
  8004c1:	c3                   	ret    

008004c2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004c2:	55                   	push   %ebp
  8004c3:	89 e5                	mov    %esp,%ebp
  8004c5:	53                   	push   %ebx
  8004c6:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8004d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d4:	89 0a                	mov    %ecx,(%edx)
  8004d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8004d9:	88 d1                	mov    %dl,%cl
  8004db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004de:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004ec:	75 30                	jne    80051e <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004ee:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  8004f4:	a0 44 50 80 00       	mov    0x805044,%al
  8004f9:	0f b6 c0             	movzbl %al,%eax
  8004fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ff:	8b 09                	mov    (%ecx),%ecx
  800501:	89 cb                	mov    %ecx,%ebx
  800503:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800506:	83 c1 08             	add    $0x8,%ecx
  800509:	52                   	push   %edx
  80050a:	50                   	push   %eax
  80050b:	53                   	push   %ebx
  80050c:	51                   	push   %ecx
  80050d:	e8 a8 1c 00 00       	call   8021ba <sys_cputs>
  800512:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800515:	8b 45 0c             	mov    0xc(%ebp),%eax
  800518:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80051e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800521:	8b 40 04             	mov    0x4(%eax),%eax
  800524:	8d 50 01             	lea    0x1(%eax),%edx
  800527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80052d:	90                   	nop
  80052e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80053c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800543:	00 00 00 
	b.cnt = 0;
  800546:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80054d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800550:	ff 75 0c             	pushl  0xc(%ebp)
  800553:	ff 75 08             	pushl  0x8(%ebp)
  800556:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055c:	50                   	push   %eax
  80055d:	68 c2 04 80 00       	push   $0x8004c2
  800562:	e8 5a 02 00 00       	call   8007c1 <vprintfmt>
  800567:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80056a:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  800570:	a0 44 50 80 00       	mov    0x805044,%al
  800575:	0f b6 c0             	movzbl %al,%eax
  800578:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80057e:	52                   	push   %edx
  80057f:	50                   	push   %eax
  800580:	51                   	push   %ecx
  800581:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800587:	83 c0 08             	add    $0x8,%eax
  80058a:	50                   	push   %eax
  80058b:	e8 2a 1c 00 00       	call   8021ba <sys_cputs>
  800590:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800593:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  80059a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005a0:	c9                   	leave  
  8005a1:	c3                   	ret    

008005a2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
  8005a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a8:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  8005af:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8005be:	50                   	push   %eax
  8005bf:	e8 6f ff ff ff       	call   800533 <vcprintf>
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    

008005cf <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005cf:	55                   	push   %ebp
  8005d0:	89 e5                	mov    %esp,%ebp
  8005d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d5:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005df:	c1 e0 08             	shl    $0x8,%eax
  8005e2:	a3 18 d1 81 00       	mov    %eax,0x81d118
	va_start(ap, fmt);
  8005e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ea:	83 c0 04             	add    $0x4,%eax
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f9:	50                   	push   %eax
  8005fa:	e8 34 ff ff ff       	call   800533 <vcprintf>
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800605:	c7 05 18 d1 81 00 00 	movl   $0x700,0x81d118
  80060c:	07 00 00 

	return cnt;
  80060f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800612:	c9                   	leave  
  800613:	c3                   	ret    

00800614 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
  800617:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80061a:	e8 df 1b 00 00       	call   8021fe <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80061f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800622:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	ff 75 f4             	pushl  -0xc(%ebp)
  80062e:	50                   	push   %eax
  80062f:	e8 ff fe ff ff       	call   800533 <vcprintf>
  800634:	83 c4 10             	add    $0x10,%esp
  800637:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80063a:	e8 d9 1b 00 00       	call   802218 <sys_unlock_cons>
	return cnt;
  80063f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800642:	c9                   	leave  
  800643:	c3                   	ret    

00800644 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	53                   	push   %ebx
  800648:	83 ec 14             	sub    $0x14,%esp
  80064b:	8b 45 10             	mov    0x10(%ebp),%eax
  80064e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800657:	8b 45 18             	mov    0x18(%ebp),%eax
  80065a:	ba 00 00 00 00       	mov    $0x0,%edx
  80065f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800662:	77 55                	ja     8006b9 <printnum+0x75>
  800664:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800667:	72 05                	jb     80066e <printnum+0x2a>
  800669:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80066c:	77 4b                	ja     8006b9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80066e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800671:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800674:	8b 45 18             	mov    0x18(%ebp),%eax
  800677:	ba 00 00 00 00       	mov    $0x0,%edx
  80067c:	52                   	push   %edx
  80067d:	50                   	push   %eax
  80067e:	ff 75 f4             	pushl  -0xc(%ebp)
  800681:	ff 75 f0             	pushl  -0x10(%ebp)
  800684:	e8 5b 31 00 00       	call   8037e4 <__udivdi3>
  800689:	83 c4 10             	add    $0x10,%esp
  80068c:	83 ec 04             	sub    $0x4,%esp
  80068f:	ff 75 20             	pushl  0x20(%ebp)
  800692:	53                   	push   %ebx
  800693:	ff 75 18             	pushl  0x18(%ebp)
  800696:	52                   	push   %edx
  800697:	50                   	push   %eax
  800698:	ff 75 0c             	pushl  0xc(%ebp)
  80069b:	ff 75 08             	pushl  0x8(%ebp)
  80069e:	e8 a1 ff ff ff       	call   800644 <printnum>
  8006a3:	83 c4 20             	add    $0x20,%esp
  8006a6:	eb 1a                	jmp    8006c2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	ff 75 0c             	pushl  0xc(%ebp)
  8006ae:	ff 75 20             	pushl  0x20(%ebp)
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	ff d0                	call   *%eax
  8006b6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006b9:	ff 4d 1c             	decl   0x1c(%ebp)
  8006bc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006c0:	7f e6                	jg     8006a8 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006c2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d0:	53                   	push   %ebx
  8006d1:	51                   	push   %ecx
  8006d2:	52                   	push   %edx
  8006d3:	50                   	push   %eax
  8006d4:	e8 1b 32 00 00       	call   8038f4 <__umoddi3>
  8006d9:	83 c4 10             	add    $0x10,%esp
  8006dc:	05 d4 3e 80 00       	add    $0x803ed4,%eax
  8006e1:	8a 00                	mov    (%eax),%al
  8006e3:	0f be c0             	movsbl %al,%eax
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	ff d0                	call   *%eax
  8006f2:	83 c4 10             	add    $0x10,%esp
}
  8006f5:	90                   	nop
  8006f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006fe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800702:	7e 1c                	jle    800720 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8d 50 08             	lea    0x8(%eax),%edx
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 10                	mov    %edx,(%eax)
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	83 e8 08             	sub    $0x8,%eax
  800719:	8b 50 04             	mov    0x4(%eax),%edx
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	eb 40                	jmp    800760 <getuint+0x65>
	else if (lflag)
  800720:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800724:	74 1e                	je     800744 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	ba 00 00 00 00       	mov    $0x0,%edx
  800742:	eb 1c                	jmp    800760 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	8d 50 04             	lea    0x4(%eax),%edx
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	89 10                	mov    %edx,(%eax)
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	83 e8 04             	sub    $0x4,%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800760:	5d                   	pop    %ebp
  800761:	c3                   	ret    

00800762 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800765:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800769:	7e 1c                	jle    800787 <getint+0x25>
		return va_arg(*ap, long long);
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	8d 50 08             	lea    0x8(%eax),%edx
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	89 10                	mov    %edx,(%eax)
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	83 e8 08             	sub    $0x8,%eax
  800780:	8b 50 04             	mov    0x4(%eax),%edx
  800783:	8b 00                	mov    (%eax),%eax
  800785:	eb 38                	jmp    8007bf <getint+0x5d>
	else if (lflag)
  800787:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078b:	74 1a                	je     8007a7 <getint+0x45>
		return va_arg(*ap, long);
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	8d 50 04             	lea    0x4(%eax),%edx
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	89 10                	mov    %edx,(%eax)
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	83 e8 04             	sub    $0x4,%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	99                   	cltd   
  8007a5:	eb 18                	jmp    8007bf <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	8d 50 04             	lea    0x4(%eax),%edx
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	89 10                	mov    %edx,(%eax)
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	83 e8 04             	sub    $0x4,%eax
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	99                   	cltd   
}
  8007bf:	5d                   	pop    %ebp
  8007c0:	c3                   	ret    

008007c1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	56                   	push   %esi
  8007c5:	53                   	push   %ebx
  8007c6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c9:	eb 17                	jmp    8007e2 <vprintfmt+0x21>
			if (ch == '\0')
  8007cb:	85 db                	test   %ebx,%ebx
  8007cd:	0f 84 c1 03 00 00    	je     800b94 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	ff 75 0c             	pushl  0xc(%ebp)
  8007d9:	53                   	push   %ebx
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	ff d0                	call   *%eax
  8007df:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	8d 50 01             	lea    0x1(%eax),%edx
  8007e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8007eb:	8a 00                	mov    (%eax),%al
  8007ed:	0f b6 d8             	movzbl %al,%ebx
  8007f0:	83 fb 25             	cmp    $0x25,%ebx
  8007f3:	75 d6                	jne    8007cb <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007f5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007f9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800800:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800807:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80080e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
  800818:	8d 50 01             	lea    0x1(%eax),%edx
  80081b:	89 55 10             	mov    %edx,0x10(%ebp)
  80081e:	8a 00                	mov    (%eax),%al
  800820:	0f b6 d8             	movzbl %al,%ebx
  800823:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800826:	83 f8 5b             	cmp    $0x5b,%eax
  800829:	0f 87 3d 03 00 00    	ja     800b6c <vprintfmt+0x3ab>
  80082f:	8b 04 85 f8 3e 80 00 	mov    0x803ef8(,%eax,4),%eax
  800836:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800838:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80083c:	eb d7                	jmp    800815 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80083e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800842:	eb d1                	jmp    800815 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800844:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80084b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80084e:	89 d0                	mov    %edx,%eax
  800850:	c1 e0 02             	shl    $0x2,%eax
  800853:	01 d0                	add    %edx,%eax
  800855:	01 c0                	add    %eax,%eax
  800857:	01 d8                	add    %ebx,%eax
  800859:	83 e8 30             	sub    $0x30,%eax
  80085c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80085f:	8b 45 10             	mov    0x10(%ebp),%eax
  800862:	8a 00                	mov    (%eax),%al
  800864:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800867:	83 fb 2f             	cmp    $0x2f,%ebx
  80086a:	7e 3e                	jle    8008aa <vprintfmt+0xe9>
  80086c:	83 fb 39             	cmp    $0x39,%ebx
  80086f:	7f 39                	jg     8008aa <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800871:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800874:	eb d5                	jmp    80084b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80088a:	eb 1f                	jmp    8008ab <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80088c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800890:	79 83                	jns    800815 <vprintfmt+0x54>
				width = 0;
  800892:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800899:	e9 77 ff ff ff       	jmp    800815 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80089e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008a5:	e9 6b ff ff ff       	jmp    800815 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008aa:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	0f 89 60 ff ff ff    	jns    800815 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008c2:	e9 4e ff ff ff       	jmp    800815 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ca:	e9 46 ff ff ff       	jmp    800815 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	83 c0 04             	add    $0x4,%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	83 ec 08             	sub    $0x8,%esp
  8008e3:	ff 75 0c             	pushl  0xc(%ebp)
  8008e6:	50                   	push   %eax
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	ff d0                	call   *%eax
  8008ec:	83 c4 10             	add    $0x10,%esp
			break;
  8008ef:	e9 9b 02 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	83 c0 04             	add    $0x4,%eax
  8008fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	83 e8 04             	sub    $0x4,%eax
  800903:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800905:	85 db                	test   %ebx,%ebx
  800907:	79 02                	jns    80090b <vprintfmt+0x14a>
				err = -err;
  800909:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80090b:	83 fb 64             	cmp    $0x64,%ebx
  80090e:	7f 0b                	jg     80091b <vprintfmt+0x15a>
  800910:	8b 34 9d 40 3d 80 00 	mov    0x803d40(,%ebx,4),%esi
  800917:	85 f6                	test   %esi,%esi
  800919:	75 19                	jne    800934 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091b:	53                   	push   %ebx
  80091c:	68 e5 3e 80 00       	push   $0x803ee5
  800921:	ff 75 0c             	pushl  0xc(%ebp)
  800924:	ff 75 08             	pushl  0x8(%ebp)
  800927:	e8 70 02 00 00       	call   800b9c <printfmt>
  80092c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80092f:	e9 5b 02 00 00       	jmp    800b8f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800934:	56                   	push   %esi
  800935:	68 ee 3e 80 00       	push   $0x803eee
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	ff 75 08             	pushl  0x8(%ebp)
  800940:	e8 57 02 00 00       	call   800b9c <printfmt>
  800945:	83 c4 10             	add    $0x10,%esp
			break;
  800948:	e9 42 02 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	83 c0 04             	add    $0x4,%eax
  800953:	89 45 14             	mov    %eax,0x14(%ebp)
  800956:	8b 45 14             	mov    0x14(%ebp),%eax
  800959:	83 e8 04             	sub    $0x4,%eax
  80095c:	8b 30                	mov    (%eax),%esi
  80095e:	85 f6                	test   %esi,%esi
  800960:	75 05                	jne    800967 <vprintfmt+0x1a6>
				p = "(null)";
  800962:	be f1 3e 80 00       	mov    $0x803ef1,%esi
			if (width > 0 && padc != '-')
  800967:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096b:	7e 6d                	jle    8009da <vprintfmt+0x219>
  80096d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800971:	74 67                	je     8009da <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800973:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	50                   	push   %eax
  80097a:	56                   	push   %esi
  80097b:	e8 1e 03 00 00       	call   800c9e <strnlen>
  800980:	83 c4 10             	add    $0x10,%esp
  800983:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800986:	eb 16                	jmp    80099e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800988:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	ff 75 0c             	pushl  0xc(%ebp)
  800992:	50                   	push   %eax
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	ff d0                	call   *%eax
  800998:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80099b:	ff 4d e4             	decl   -0x1c(%ebp)
  80099e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a2:	7f e4                	jg     800988 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a4:	eb 34                	jmp    8009da <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009aa:	74 1c                	je     8009c8 <vprintfmt+0x207>
  8009ac:	83 fb 1f             	cmp    $0x1f,%ebx
  8009af:	7e 05                	jle    8009b6 <vprintfmt+0x1f5>
  8009b1:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b4:	7e 12                	jle    8009c8 <vprintfmt+0x207>
					putch('?', putdat);
  8009b6:	83 ec 08             	sub    $0x8,%esp
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	6a 3f                	push   $0x3f
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	ff d0                	call   *%eax
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	eb 0f                	jmp    8009d7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009c8:	83 ec 08             	sub    $0x8,%esp
  8009cb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ce:	53                   	push   %ebx
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	ff d0                	call   *%eax
  8009d4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009da:	89 f0                	mov    %esi,%eax
  8009dc:	8d 70 01             	lea    0x1(%eax),%esi
  8009df:	8a 00                	mov    (%eax),%al
  8009e1:	0f be d8             	movsbl %al,%ebx
  8009e4:	85 db                	test   %ebx,%ebx
  8009e6:	74 24                	je     800a0c <vprintfmt+0x24b>
  8009e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ec:	78 b8                	js     8009a6 <vprintfmt+0x1e5>
  8009ee:	ff 4d e0             	decl   -0x20(%ebp)
  8009f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f5:	79 af                	jns    8009a6 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f7:	eb 13                	jmp    800a0c <vprintfmt+0x24b>
				putch(' ', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 20                	push   $0x20
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a09:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a10:	7f e7                	jg     8009f9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a12:	e9 78 01 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a1d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a20:	50                   	push   %eax
  800a21:	e8 3c fd ff ff       	call   800762 <getint>
  800a26:	83 c4 10             	add    $0x10,%esp
  800a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a35:	85 d2                	test   %edx,%edx
  800a37:	79 23                	jns    800a5c <vprintfmt+0x29b>
				putch('-', putdat);
  800a39:	83 ec 08             	sub    $0x8,%esp
  800a3c:	ff 75 0c             	pushl  0xc(%ebp)
  800a3f:	6a 2d                	push   $0x2d
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	ff d0                	call   *%eax
  800a46:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a4f:	f7 d8                	neg    %eax
  800a51:	83 d2 00             	adc    $0x0,%edx
  800a54:	f7 da                	neg    %edx
  800a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a59:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a5c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a63:	e9 bc 00 00 00       	jmp    800b24 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a6e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a71:	50                   	push   %eax
  800a72:	e8 84 fc ff ff       	call   8006fb <getuint>
  800a77:	83 c4 10             	add    $0x10,%esp
  800a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a80:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a87:	e9 98 00 00 00       	jmp    800b24 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a8c:	83 ec 08             	sub    $0x8,%esp
  800a8f:	ff 75 0c             	pushl  0xc(%ebp)
  800a92:	6a 58                	push   $0x58
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	ff d0                	call   *%eax
  800a99:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	6a 58                	push   $0x58
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	6a 58                	push   $0x58
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	ff d0                	call   *%eax
  800ab9:	83 c4 10             	add    $0x10,%esp
			break;
  800abc:	e9 ce 00 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	6a 30                	push   $0x30
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	ff d0                	call   *%eax
  800ace:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	6a 78                	push   $0x78
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	ff d0                	call   *%eax
  800ade:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ae1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae4:	83 c0 04             	add    $0x4,%eax
  800ae7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aea:	8b 45 14             	mov    0x14(%ebp),%eax
  800aed:	83 e8 04             	sub    $0x4,%eax
  800af0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800afc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b03:	eb 1f                	jmp    800b24 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b0e:	50                   	push   %eax
  800b0f:	e8 e7 fb ff ff       	call   8006fb <getuint>
  800b14:	83 c4 10             	add    $0x10,%esp
  800b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b1d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b24:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2b:	83 ec 04             	sub    $0x4,%esp
  800b2e:	52                   	push   %edx
  800b2f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b32:	50                   	push   %eax
  800b33:	ff 75 f4             	pushl  -0xc(%ebp)
  800b36:	ff 75 f0             	pushl  -0x10(%ebp)
  800b39:	ff 75 0c             	pushl  0xc(%ebp)
  800b3c:	ff 75 08             	pushl  0x8(%ebp)
  800b3f:	e8 00 fb ff ff       	call   800644 <printnum>
  800b44:	83 c4 20             	add    $0x20,%esp
			break;
  800b47:	eb 46                	jmp    800b8f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	53                   	push   %ebx
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
			break;
  800b58:	eb 35                	jmp    800b8f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b5a:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800b61:	eb 2c                	jmp    800b8f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b63:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800b6a:	eb 23                	jmp    800b8f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 0c             	pushl  0xc(%ebp)
  800b72:	6a 25                	push   $0x25
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	ff d0                	call   *%eax
  800b79:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b7c:	ff 4d 10             	decl   0x10(%ebp)
  800b7f:	eb 03                	jmp    800b84 <vprintfmt+0x3c3>
  800b81:	ff 4d 10             	decl   0x10(%ebp)
  800b84:	8b 45 10             	mov    0x10(%ebp),%eax
  800b87:	48                   	dec    %eax
  800b88:	8a 00                	mov    (%eax),%al
  800b8a:	3c 25                	cmp    $0x25,%al
  800b8c:	75 f3                	jne    800b81 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b8e:	90                   	nop
		}
	}
  800b8f:	e9 35 fc ff ff       	jmp    8007c9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b94:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b98:	5b                   	pop    %ebx
  800b99:	5e                   	pop    %esi
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ba2:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba5:	83 c0 04             	add    $0x4,%eax
  800ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bab:	8b 45 10             	mov    0x10(%ebp),%eax
  800bae:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb1:	50                   	push   %eax
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	ff 75 08             	pushl  0x8(%ebp)
  800bb8:	e8 04 fc ff ff       	call   8007c1 <vprintfmt>
  800bbd:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bc0:	90                   	nop
  800bc1:	c9                   	leave  
  800bc2:	c3                   	ret    

00800bc3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	8b 40 08             	mov    0x8(%eax),%eax
  800bcc:	8d 50 01             	lea    0x1(%eax),%edx
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	8b 10                	mov    (%eax),%edx
  800bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdd:	8b 40 04             	mov    0x4(%eax),%eax
  800be0:	39 c2                	cmp    %eax,%edx
  800be2:	73 12                	jae    800bf6 <sprintputch+0x33>
		*b->buf++ = ch;
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	8b 00                	mov    (%eax),%eax
  800be9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bef:	89 0a                	mov    %ecx,(%edx)
  800bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf4:	88 10                	mov    %dl,(%eax)
}
  800bf6:	90                   	nop
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    

00800bf9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c08:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	01 d0                	add    %edx,%eax
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c1e:	74 06                	je     800c26 <vsnprintf+0x2d>
  800c20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c24:	7f 07                	jg     800c2d <vsnprintf+0x34>
		return -E_INVAL;
  800c26:	b8 03 00 00 00       	mov    $0x3,%eax
  800c2b:	eb 20                	jmp    800c4d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c2d:	ff 75 14             	pushl  0x14(%ebp)
  800c30:	ff 75 10             	pushl  0x10(%ebp)
  800c33:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c36:	50                   	push   %eax
  800c37:	68 c3 0b 80 00       	push   $0x800bc3
  800c3c:	e8 80 fb ff ff       	call   8007c1 <vprintfmt>
  800c41:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c47:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c55:	8d 45 10             	lea    0x10(%ebp),%eax
  800c58:	83 c0 04             	add    $0x4,%eax
  800c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c61:	ff 75 f4             	pushl  -0xc(%ebp)
  800c64:	50                   	push   %eax
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	ff 75 08             	pushl  0x8(%ebp)
  800c6b:	e8 89 ff ff ff       	call   800bf9 <vsnprintf>
  800c70:	83 c4 10             	add    $0x10,%esp
  800c73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c88:	eb 06                	jmp    800c90 <strlen+0x15>
		n++;
  800c8a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c8d:	ff 45 08             	incl   0x8(%ebp)
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	84 c0                	test   %al,%al
  800c97:	75 f1                	jne    800c8a <strlen+0xf>
		n++;
	return n;
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cab:	eb 09                	jmp    800cb6 <strnlen+0x18>
		n++;
  800cad:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb0:	ff 45 08             	incl   0x8(%ebp)
  800cb3:	ff 4d 0c             	decl   0xc(%ebp)
  800cb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cba:	74 09                	je     800cc5 <strnlen+0x27>
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	84 c0                	test   %al,%al
  800cc3:	75 e8                	jne    800cad <strnlen+0xf>
		n++;
	return n;
  800cc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cd6:	90                   	nop
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8d 50 01             	lea    0x1(%eax),%edx
  800cdd:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce9:	8a 12                	mov    (%edx),%dl
  800ceb:	88 10                	mov    %dl,(%eax)
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	84 c0                	test   %al,%al
  800cf1:	75 e4                	jne    800cd7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d0b:	eb 1f                	jmp    800d2c <strncpy+0x34>
		*dst++ = *src;
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8d 50 01             	lea    0x1(%eax),%edx
  800d13:	89 55 08             	mov    %edx,0x8(%ebp)
  800d16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d19:	8a 12                	mov    (%edx),%dl
  800d1b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	84 c0                	test   %al,%al
  800d24:	74 03                	je     800d29 <strncpy+0x31>
			src++;
  800d26:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d29:	ff 45 fc             	incl   -0x4(%ebp)
  800d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d32:	72 d9                	jb     800d0d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d34:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d49:	74 30                	je     800d7b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d4b:	eb 16                	jmp    800d63 <strlcpy+0x2a>
			*dst++ = *src++;
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8d 50 01             	lea    0x1(%eax),%edx
  800d53:	89 55 08             	mov    %edx,0x8(%ebp)
  800d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d59:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d5c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d5f:	8a 12                	mov    (%edx),%dl
  800d61:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d63:	ff 4d 10             	decl   0x10(%ebp)
  800d66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6a:	74 09                	je     800d75 <strlcpy+0x3c>
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	84 c0                	test   %al,%al
  800d73:	75 d8                	jne    800d4d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d81:	29 c2                	sub    %eax,%edx
  800d83:	89 d0                	mov    %edx,%eax
}
  800d85:	c9                   	leave  
  800d86:	c3                   	ret    

00800d87 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d8a:	eb 06                	jmp    800d92 <strcmp+0xb>
		p++, q++;
  800d8c:	ff 45 08             	incl   0x8(%ebp)
  800d8f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	84 c0                	test   %al,%al
  800d99:	74 0e                	je     800da9 <strcmp+0x22>
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 10                	mov    (%eax),%dl
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	38 c2                	cmp    %al,%dl
  800da7:	74 e3                	je     800d8c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	8a 00                	mov    (%eax),%al
  800dae:	0f b6 d0             	movzbl %al,%edx
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	0f b6 c0             	movzbl %al,%eax
  800db9:	29 c2                	sub    %eax,%edx
  800dbb:	89 d0                	mov    %edx,%eax
}
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    

00800dbf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dc2:	eb 09                	jmp    800dcd <strncmp+0xe>
		n--, p++, q++;
  800dc4:	ff 4d 10             	decl   0x10(%ebp)
  800dc7:	ff 45 08             	incl   0x8(%ebp)
  800dca:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd1:	74 17                	je     800dea <strncmp+0x2b>
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	84 c0                	test   %al,%al
  800dda:	74 0e                	je     800dea <strncmp+0x2b>
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 10                	mov    (%eax),%dl
  800de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	38 c2                	cmp    %al,%dl
  800de8:	74 da                	je     800dc4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dee:	75 07                	jne    800df7 <strncmp+0x38>
		return 0;
  800df0:	b8 00 00 00 00       	mov    $0x0,%eax
  800df5:	eb 14                	jmp    800e0b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	0f b6 d0             	movzbl %al,%edx
  800dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	0f b6 c0             	movzbl %al,%eax
  800e07:	29 c2                	sub    %eax,%edx
  800e09:	89 d0                	mov    %edx,%eax
}
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e19:	eb 12                	jmp    800e2d <strchr+0x20>
		if (*s == c)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e23:	75 05                	jne    800e2a <strchr+0x1d>
			return (char *) s;
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	eb 11                	jmp    800e3b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e2a:	ff 45 08             	incl   0x8(%ebp)
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	84 c0                	test   %al,%al
  800e34:	75 e5                	jne    800e1b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 04             	sub    $0x4,%esp
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e49:	eb 0d                	jmp    800e58 <strfind+0x1b>
		if (*s == c)
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e53:	74 0e                	je     800e63 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e55:	ff 45 08             	incl   0x8(%ebp)
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	84 c0                	test   %al,%al
  800e5f:	75 ea                	jne    800e4b <strfind+0xe>
  800e61:	eb 01                	jmp    800e64 <strfind+0x27>
		if (*s == c)
			break;
  800e63:	90                   	nop
	return (char *) s;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e75:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e79:	76 63                	jbe    800ede <memset+0x75>
		uint64 data_block = c;
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	99                   	cltd   
  800e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e82:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e8f:	c1 e0 08             	shl    $0x8,%eax
  800e92:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e95:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ea2:	c1 e0 10             	shl    $0x10,%eax
  800ea5:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb1:	89 c2                	mov    %eax,%edx
  800eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb8:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ebb:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ebe:	eb 18                	jmp    800ed8 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ec0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ec3:	8d 41 08             	lea    0x8(%ecx),%eax
  800ec6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ecf:	89 01                	mov    %eax,(%ecx)
  800ed1:	89 51 04             	mov    %edx,0x4(%ecx)
  800ed4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ed8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800edc:	77 e2                	ja     800ec0 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ede:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee2:	74 23                	je     800f07 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eea:	eb 0e                	jmp    800efa <memset+0x91>
			*p8++ = (uint8)c;
  800eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eef:	8d 50 01             	lea    0x1(%eax),%edx
  800ef2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ef5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef8:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800efa:	8b 45 10             	mov    0x10(%ebp),%eax
  800efd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f00:	89 55 10             	mov    %edx,0x10(%ebp)
  800f03:	85 c0                	test   %eax,%eax
  800f05:	75 e5                	jne    800eec <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0a:	c9                   	leave  
  800f0b:	c3                   	ret    

00800f0c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f1e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f22:	76 24                	jbe    800f48 <memcpy+0x3c>
		while(n >= 8){
  800f24:	eb 1c                	jmp    800f42 <memcpy+0x36>
			*d64 = *s64;
  800f26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f29:	8b 50 04             	mov    0x4(%eax),%edx
  800f2c:	8b 00                	mov    (%eax),%eax
  800f2e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f31:	89 01                	mov    %eax,(%ecx)
  800f33:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f36:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f3a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f3e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f42:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f46:	77 de                	ja     800f26 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4c:	74 31                	je     800f7f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f5a:	eb 16                	jmp    800f72 <memcpy+0x66>
			*d8++ = *s8++;
  800f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f6e:	8a 12                	mov    (%edx),%dl
  800f70:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 dd                	jne    800f5c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9c:	73 50                	jae    800fee <memmove+0x6a>
  800f9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa9:	76 43                	jbe    800fee <memmove+0x6a>
		s += n;
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb7:	eb 10                	jmp    800fc9 <memmove+0x45>
			*--d = *--s;
  800fb9:	ff 4d f8             	decl   -0x8(%ebp)
  800fbc:	ff 4d fc             	decl   -0x4(%ebp)
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	8a 10                	mov    (%eax),%dl
  800fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 e3                	jne    800fb9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd6:	eb 23                	jmp    800ffb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	8d 50 01             	lea    0x1(%eax),%edx
  800fde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fea:	8a 12                	mov    (%edx),%dl
  800fec:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	75 dd                	jne    800fd8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801012:	eb 2a                	jmp    80103e <memcmp+0x3e>
		if (*s1 != *s2)
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801017:	8a 10                	mov    (%eax),%dl
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	38 c2                	cmp    %al,%dl
  801020:	74 16                	je     801038 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801022:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f b6 d0             	movzbl %al,%edx
  80102a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 c0             	movzbl %al,%eax
  801032:	29 c2                	sub    %eax,%edx
  801034:	89 d0                	mov    %edx,%eax
  801036:	eb 18                	jmp    801050 <memcmp+0x50>
		s1++, s2++;
  801038:	ff 45 fc             	incl   -0x4(%ebp)
  80103b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80103e:	8b 45 10             	mov    0x10(%ebp),%eax
  801041:	8d 50 ff             	lea    -0x1(%eax),%edx
  801044:	89 55 10             	mov    %edx,0x10(%ebp)
  801047:	85 c0                	test   %eax,%eax
  801049:	75 c9                	jne    801014 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801058:	8b 55 08             	mov    0x8(%ebp),%edx
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	01 d0                	add    %edx,%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801063:	eb 15                	jmp    80107a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	0f b6 d0             	movzbl %al,%edx
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	0f b6 c0             	movzbl %al,%eax
  801073:	39 c2                	cmp    %eax,%edx
  801075:	74 0d                	je     801084 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801077:	ff 45 08             	incl   0x8(%ebp)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801080:	72 e3                	jb     801065 <memfind+0x13>
  801082:	eb 01                	jmp    801085 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801084:	90                   	nop
	return (void *) s;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801097:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109e:	eb 03                	jmp    8010a3 <strtol+0x19>
		s++;
  8010a0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 20                	cmp    $0x20,%al
  8010aa:	74 f4                	je     8010a0 <strtol+0x16>
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	3c 09                	cmp    $0x9,%al
  8010b3:	74 eb                	je     8010a0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 2b                	cmp    $0x2b,%al
  8010bc:	75 05                	jne    8010c3 <strtol+0x39>
		s++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
  8010c1:	eb 13                	jmp    8010d6 <strtol+0x4c>
	else if (*s == '-')
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 2d                	cmp    $0x2d,%al
  8010ca:	75 0a                	jne    8010d6 <strtol+0x4c>
		s++, neg = 1;
  8010cc:	ff 45 08             	incl   0x8(%ebp)
  8010cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010da:	74 06                	je     8010e2 <strtol+0x58>
  8010dc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e0:	75 20                	jne    801102 <strtol+0x78>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 30                	cmp    $0x30,%al
  8010e9:	75 17                	jne    801102 <strtol+0x78>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	40                   	inc    %eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 78                	cmp    $0x78,%al
  8010f3:	75 0d                	jne    801102 <strtol+0x78>
		s += 2, base = 16;
  8010f5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801100:	eb 28                	jmp    80112a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	75 15                	jne    80111d <strtol+0x93>
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	3c 30                	cmp    $0x30,%al
  80110f:	75 0c                	jne    80111d <strtol+0x93>
		s++, base = 8;
  801111:	ff 45 08             	incl   0x8(%ebp)
  801114:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80111b:	eb 0d                	jmp    80112a <strtol+0xa0>
	else if (base == 0)
  80111d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801121:	75 07                	jne    80112a <strtol+0xa0>
		base = 10;
  801123:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 2f                	cmp    $0x2f,%al
  801131:	7e 19                	jle    80114c <strtol+0xc2>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 39                	cmp    $0x39,%al
  80113a:	7f 10                	jg     80114c <strtol+0xc2>
			dig = *s - '0';
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f be c0             	movsbl %al,%eax
  801144:	83 e8 30             	sub    $0x30,%eax
  801147:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80114a:	eb 42                	jmp    80118e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 60                	cmp    $0x60,%al
  801153:	7e 19                	jle    80116e <strtol+0xe4>
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 7a                	cmp    $0x7a,%al
  80115c:	7f 10                	jg     80116e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be c0             	movsbl %al,%eax
  801166:	83 e8 57             	sub    $0x57,%eax
  801169:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116c:	eb 20                	jmp    80118e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 40                	cmp    $0x40,%al
  801175:	7e 39                	jle    8011b0 <strtol+0x126>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 5a                	cmp    $0x5a,%al
  80117e:	7f 30                	jg     8011b0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f be c0             	movsbl %al,%eax
  801188:	83 e8 37             	sub    $0x37,%eax
  80118b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80118e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801191:	3b 45 10             	cmp    0x10(%ebp),%eax
  801194:	7d 19                	jge    8011af <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801196:	ff 45 08             	incl   0x8(%ebp)
  801199:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119c:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a0:	89 c2                	mov    %eax,%edx
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011aa:	e9 7b ff ff ff       	jmp    80112a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011af:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b4:	74 08                	je     8011be <strtol+0x134>
		*endptr = (char *) s;
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c2:	74 07                	je     8011cb <strtol+0x141>
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	f7 d8                	neg    %eax
  8011c9:	eb 03                	jmp    8011ce <strtol+0x144>
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e8:	79 13                	jns    8011fd <ltostr+0x2d>
	{
		neg = 1;
  8011ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011f7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011fa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801205:	99                   	cltd   
  801206:	f7 f9                	idiv   %ecx
  801208:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	8d 50 01             	lea    0x1(%eax),%edx
  801211:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801214:	89 c2                	mov    %eax,%edx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121e:	83 c2 30             	add    $0x30,%edx
  801221:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801226:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80122b:	f7 e9                	imul   %ecx
  80122d:	c1 fa 02             	sar    $0x2,%edx
  801230:	89 c8                	mov    %ecx,%eax
  801232:	c1 f8 1f             	sar    $0x1f,%eax
  801235:	29 c2                	sub    %eax,%edx
  801237:	89 d0                	mov    %edx,%eax
  801239:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80123c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801240:	75 bb                	jne    8011fd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801242:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	48                   	dec    %eax
  80124d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801250:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801254:	74 3d                	je     801293 <ltostr+0xc3>
		start = 1 ;
  801256:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80125d:	eb 34                	jmp    801293 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80125f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	01 d0                	add    %edx,%eax
  801267:	8a 00                	mov    (%eax),%al
  801269:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80126c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	01 c2                	add    %eax,%edx
  801274:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	01 c8                	add    %ecx,%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801280:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	01 c2                	add    %eax,%edx
  801288:	8a 45 eb             	mov    -0x15(%ebp),%al
  80128b:	88 02                	mov    %al,(%edx)
		start++ ;
  80128d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801290:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801296:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801299:	7c c4                	jl     80125f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80129b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 d0                	add    %edx,%eax
  8012a3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012a6:	90                   	nop
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012af:	ff 75 08             	pushl  0x8(%ebp)
  8012b2:	e8 c4 f9 ff ff       	call   800c7b <strlen>
  8012b7:	83 c4 04             	add    $0x4,%esp
  8012ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012bd:	ff 75 0c             	pushl  0xc(%ebp)
  8012c0:	e8 b6 f9 ff ff       	call   800c7b <strlen>
  8012c5:	83 c4 04             	add    $0x4,%esp
  8012c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d9:	eb 17                	jmp    8012f2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	01 c2                	add    %eax,%edx
  8012e3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	01 c8                	add    %ecx,%eax
  8012eb:	8a 00                	mov    (%eax),%al
  8012ed:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012ef:	ff 45 fc             	incl   -0x4(%ebp)
  8012f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012f8:	7c e1                	jl     8012db <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801301:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801308:	eb 1f                	jmp    801329 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80130a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130d:	8d 50 01             	lea    0x1(%eax),%edx
  801310:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801313:	89 c2                	mov    %eax,%edx
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 c2                	add    %eax,%edx
  80131a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80131d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801320:	01 c8                	add    %ecx,%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801326:	ff 45 f8             	incl   -0x8(%ebp)
  801329:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80132f:	7c d9                	jl     80130a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801331:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	c6 00 00             	movb   $0x0,(%eax)
}
  80133c:	90                   	nop
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801342:	8b 45 14             	mov    0x14(%ebp),%eax
  801345:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80134b:	8b 45 14             	mov    0x14(%ebp),%eax
  80134e:	8b 00                	mov    (%eax),%eax
  801350:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801357:	8b 45 10             	mov    0x10(%ebp),%eax
  80135a:	01 d0                	add    %edx,%eax
  80135c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801362:	eb 0c                	jmp    801370 <strsplit+0x31>
			*string++ = 0;
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	8d 50 01             	lea    0x1(%eax),%edx
  80136a:	89 55 08             	mov    %edx,0x8(%ebp)
  80136d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	84 c0                	test   %al,%al
  801377:	74 18                	je     801391 <strsplit+0x52>
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	0f be c0             	movsbl %al,%eax
  801381:	50                   	push   %eax
  801382:	ff 75 0c             	pushl  0xc(%ebp)
  801385:	e8 83 fa ff ff       	call   800e0d <strchr>
  80138a:	83 c4 08             	add    $0x8,%esp
  80138d:	85 c0                	test   %eax,%eax
  80138f:	75 d3                	jne    801364 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	84 c0                	test   %al,%al
  801398:	74 5a                	je     8013f4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80139a:	8b 45 14             	mov    0x14(%ebp),%eax
  80139d:	8b 00                	mov    (%eax),%eax
  80139f:	83 f8 0f             	cmp    $0xf,%eax
  8013a2:	75 07                	jne    8013ab <strsplit+0x6c>
		{
			return 0;
  8013a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a9:	eb 66                	jmp    801411 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ae:	8b 00                	mov    (%eax),%eax
  8013b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8013b3:	8b 55 14             	mov    0x14(%ebp),%edx
  8013b6:	89 0a                	mov    %ecx,(%edx)
  8013b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c2:	01 c2                	add    %eax,%edx
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c9:	eb 03                	jmp    8013ce <strsplit+0x8f>
			string++;
  8013cb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	84 c0                	test   %al,%al
  8013d5:	74 8b                	je     801362 <strsplit+0x23>
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	0f be c0             	movsbl %al,%eax
  8013df:	50                   	push   %eax
  8013e0:	ff 75 0c             	pushl  0xc(%ebp)
  8013e3:	e8 25 fa ff ff       	call   800e0d <strchr>
  8013e8:	83 c4 08             	add    $0x8,%esp
  8013eb:	85 c0                	test   %eax,%eax
  8013ed:	74 dc                	je     8013cb <strsplit+0x8c>
			string++;
	}
  8013ef:	e9 6e ff ff ff       	jmp    801362 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013f4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f8:	8b 00                	mov    (%eax),%eax
  8013fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801401:	8b 45 10             	mov    0x10(%ebp),%eax
  801404:	01 d0                	add    %edx,%eax
  801406:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80140c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80141f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801426:	eb 4a                	jmp    801472 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801428:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	01 c2                	add    %eax,%edx
  801430:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	01 c8                	add    %ecx,%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80143c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	01 d0                	add    %edx,%eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	3c 40                	cmp    $0x40,%al
  801448:	7e 25                	jle    80146f <str2lower+0x5c>
  80144a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	01 d0                	add    %edx,%eax
  801452:	8a 00                	mov    (%eax),%al
  801454:	3c 5a                	cmp    $0x5a,%al
  801456:	7f 17                	jg     80146f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801458:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	01 d0                	add    %edx,%eax
  801460:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801463:	8b 55 08             	mov    0x8(%ebp),%edx
  801466:	01 ca                	add    %ecx,%edx
  801468:	8a 12                	mov    (%edx),%dl
  80146a:	83 c2 20             	add    $0x20,%edx
  80146d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80146f:	ff 45 fc             	incl   -0x4(%ebp)
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	e8 01 f8 ff ff       	call   800c7b <strlen>
  80147a:	83 c4 04             	add    $0x4,%esp
  80147d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801480:	7f a6                	jg     801428 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801482:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  80148d:	83 ec 0c             	sub    $0xc,%esp
  801490:	6a 10                	push   $0x10
  801492:	e8 b2 15 00 00       	call   802a49 <alloc_block>
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  80149d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a1:	75 14                	jne    8014b7 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  8014a3:	83 ec 04             	sub    $0x4,%esp
  8014a6:	68 68 40 80 00       	push   $0x804068
  8014ab:	6a 14                	push   $0x14
  8014ad:	68 91 40 80 00       	push   $0x804091
  8014b2:	e8 1f 21 00 00       	call   8035d6 <_panic>

	node->start = start;
  8014b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8014bd:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  8014bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c5:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  8014c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  8014cf:	a1 24 50 80 00       	mov    0x805024,%eax
  8014d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d7:	eb 18                	jmp    8014f1 <insert_page_alloc+0x6a>
		if (start < it->start)
  8014d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014dc:	8b 00                	mov    (%eax),%eax
  8014de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8014e1:	77 37                	ja     80151a <insert_page_alloc+0x93>
			break;
		prev = it;
  8014e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  8014e9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8014ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014f5:	74 08                	je     8014ff <insert_page_alloc+0x78>
  8014f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fa:	8b 40 08             	mov    0x8(%eax),%eax
  8014fd:	eb 05                	jmp    801504 <insert_page_alloc+0x7d>
  8014ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801504:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801509:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80150e:	85 c0                	test   %eax,%eax
  801510:	75 c7                	jne    8014d9 <insert_page_alloc+0x52>
  801512:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801516:	75 c1                	jne    8014d9 <insert_page_alloc+0x52>
  801518:	eb 01                	jmp    80151b <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  80151a:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  80151b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80151f:	75 64                	jne    801585 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801521:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801525:	75 14                	jne    80153b <insert_page_alloc+0xb4>
  801527:	83 ec 04             	sub    $0x4,%esp
  80152a:	68 a0 40 80 00       	push   $0x8040a0
  80152f:	6a 21                	push   $0x21
  801531:	68 91 40 80 00       	push   $0x804091
  801536:	e8 9b 20 00 00       	call   8035d6 <_panic>
  80153b:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801541:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801544:	89 50 08             	mov    %edx,0x8(%eax)
  801547:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80154a:	8b 40 08             	mov    0x8(%eax),%eax
  80154d:	85 c0                	test   %eax,%eax
  80154f:	74 0d                	je     80155e <insert_page_alloc+0xd7>
  801551:	a1 24 50 80 00       	mov    0x805024,%eax
  801556:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801559:	89 50 0c             	mov    %edx,0xc(%eax)
  80155c:	eb 08                	jmp    801566 <insert_page_alloc+0xdf>
  80155e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801561:	a3 28 50 80 00       	mov    %eax,0x805028
  801566:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801569:	a3 24 50 80 00       	mov    %eax,0x805024
  80156e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801571:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801578:	a1 30 50 80 00       	mov    0x805030,%eax
  80157d:	40                   	inc    %eax
  80157e:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801583:	eb 71                	jmp    8015f6 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801585:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801589:	74 06                	je     801591 <insert_page_alloc+0x10a>
  80158b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80158f:	75 14                	jne    8015a5 <insert_page_alloc+0x11e>
  801591:	83 ec 04             	sub    $0x4,%esp
  801594:	68 c4 40 80 00       	push   $0x8040c4
  801599:	6a 23                	push   $0x23
  80159b:	68 91 40 80 00       	push   $0x804091
  8015a0:	e8 31 20 00 00       	call   8035d6 <_panic>
  8015a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a8:	8b 50 08             	mov    0x8(%eax),%edx
  8015ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ae:	89 50 08             	mov    %edx,0x8(%eax)
  8015b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b4:	8b 40 08             	mov    0x8(%eax),%eax
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	74 0c                	je     8015c7 <insert_page_alloc+0x140>
  8015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015be:	8b 40 08             	mov    0x8(%eax),%eax
  8015c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015c4:	89 50 0c             	mov    %edx,0xc(%eax)
  8015c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015cd:	89 50 08             	mov    %edx,0x8(%eax)
  8015d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d6:	89 50 0c             	mov    %edx,0xc(%eax)
  8015d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015dc:	8b 40 08             	mov    0x8(%eax),%eax
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	75 08                	jne    8015eb <insert_page_alloc+0x164>
  8015e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e6:	a3 28 50 80 00       	mov    %eax,0x805028
  8015eb:	a1 30 50 80 00       	mov    0x805030,%eax
  8015f0:	40                   	inc    %eax
  8015f1:	a3 30 50 80 00       	mov    %eax,0x805030
}
  8015f6:	90                   	nop
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  8015ff:	a1 24 50 80 00       	mov    0x805024,%eax
  801604:	85 c0                	test   %eax,%eax
  801606:	75 0c                	jne    801614 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801608:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80160d:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801612:	eb 67                	jmp    80167b <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801614:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801619:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80161c:	a1 24 50 80 00       	mov    0x805024,%eax
  801621:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801624:	eb 26                	jmp    80164c <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801626:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801629:	8b 10                	mov    (%eax),%edx
  80162b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80162e:	8b 40 04             	mov    0x4(%eax),%eax
  801631:	01 d0                	add    %edx,%eax
  801633:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801639:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80163c:	76 06                	jbe    801644 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  80163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801641:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801644:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801649:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80164c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801650:	74 08                	je     80165a <recompute_page_alloc_break+0x61>
  801652:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801655:	8b 40 08             	mov    0x8(%eax),%eax
  801658:	eb 05                	jmp    80165f <recompute_page_alloc_break+0x66>
  80165a:	b8 00 00 00 00       	mov    $0x0,%eax
  80165f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801664:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801669:	85 c0                	test   %eax,%eax
  80166b:	75 b9                	jne    801626 <recompute_page_alloc_break+0x2d>
  80166d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801671:	75 b3                	jne    801626 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801673:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801676:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801683:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80168a:	8b 55 08             	mov    0x8(%ebp),%edx
  80168d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801690:	01 d0                	add    %edx,%eax
  801692:	48                   	dec    %eax
  801693:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801696:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801699:	ba 00 00 00 00       	mov    $0x0,%edx
  80169e:	f7 75 d8             	divl   -0x28(%ebp)
  8016a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016a4:	29 d0                	sub    %edx,%eax
  8016a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  8016a9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8016ad:	75 0a                	jne    8016b9 <alloc_pages_custom_fit+0x3c>
		return NULL;
  8016af:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b4:	e9 7e 01 00 00       	jmp    801837 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  8016b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  8016c0:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  8016c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  8016cb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  8016d2:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8016d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8016da:	a1 24 50 80 00       	mov    0x805024,%eax
  8016df:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016e2:	eb 69                	jmp    80174d <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  8016e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e7:	8b 00                	mov    (%eax),%eax
  8016e9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8016ec:	76 47                	jbe    801735 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  8016ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016f1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  8016f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016f7:	8b 00                	mov    (%eax),%eax
  8016f9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8016fc:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  8016ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801702:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801705:	72 2e                	jb     801735 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801707:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80170b:	75 14                	jne    801721 <alloc_pages_custom_fit+0xa4>
  80170d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801710:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801713:	75 0c                	jne    801721 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801715:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801718:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  80171b:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  80171f:	eb 14                	jmp    801735 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801721:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801724:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801727:	76 0c                	jbe    801735 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801729:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80172c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  80172f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801732:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801735:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801738:	8b 10                	mov    (%eax),%edx
  80173a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80173d:	8b 40 04             	mov    0x4(%eax),%eax
  801740:	01 d0                	add    %edx,%eax
  801742:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801745:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80174a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80174d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801751:	74 08                	je     80175b <alloc_pages_custom_fit+0xde>
  801753:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801756:	8b 40 08             	mov    0x8(%eax),%eax
  801759:	eb 05                	jmp    801760 <alloc_pages_custom_fit+0xe3>
  80175b:	b8 00 00 00 00       	mov    $0x0,%eax
  801760:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801765:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80176a:	85 c0                	test   %eax,%eax
  80176c:	0f 85 72 ff ff ff    	jne    8016e4 <alloc_pages_custom_fit+0x67>
  801772:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801776:	0f 85 68 ff ff ff    	jne    8016e4 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  80177c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801781:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801784:	76 47                	jbe    8017cd <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801789:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  80178c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801791:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801794:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801797:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80179a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80179d:	72 2e                	jb     8017cd <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  80179f:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8017a3:	75 14                	jne    8017b9 <alloc_pages_custom_fit+0x13c>
  8017a5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017a8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017ab:	75 0c                	jne    8017b9 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  8017ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  8017b3:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8017b7:	eb 14                	jmp    8017cd <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  8017b9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017bc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8017bf:	76 0c                	jbe    8017cd <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  8017c1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  8017c7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  8017cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  8017d4:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8017d8:	74 08                	je     8017e2 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  8017da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017e0:	eb 40                	jmp    801822 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  8017e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017e6:	74 08                	je     8017f0 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  8017e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017ee:	eb 32                	jmp    801822 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  8017f0:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8017f5:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8017f8:	89 c2                	mov    %eax,%edx
  8017fa:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8017ff:	39 c2                	cmp    %eax,%edx
  801801:	73 07                	jae    80180a <alloc_pages_custom_fit+0x18d>
			return NULL;
  801803:	b8 00 00 00 00       	mov    $0x0,%eax
  801808:	eb 2d                	jmp    801837 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  80180a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80180f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801812:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801818:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80181b:	01 d0                	add    %edx,%eax
  80181d:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801822:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801825:	83 ec 08             	sub    $0x8,%esp
  801828:	ff 75 d0             	pushl  -0x30(%ebp)
  80182b:	50                   	push   %eax
  80182c:	e8 56 fc ff ff       	call   801487 <insert_page_alloc>
  801831:	83 c4 10             	add    $0x10,%esp

	return result;
  801834:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801845:	a1 24 50 80 00       	mov    0x805024,%eax
  80184a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80184d:	eb 1a                	jmp    801869 <find_allocated_size+0x30>
		if (it->start == va)
  80184f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801852:	8b 00                	mov    (%eax),%eax
  801854:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801857:	75 08                	jne    801861 <find_allocated_size+0x28>
			return it->size;
  801859:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80185c:	8b 40 04             	mov    0x4(%eax),%eax
  80185f:	eb 34                	jmp    801895 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801861:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801866:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801869:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80186d:	74 08                	je     801877 <find_allocated_size+0x3e>
  80186f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801872:	8b 40 08             	mov    0x8(%eax),%eax
  801875:	eb 05                	jmp    80187c <find_allocated_size+0x43>
  801877:	b8 00 00 00 00       	mov    $0x0,%eax
  80187c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801881:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801886:	85 c0                	test   %eax,%eax
  801888:	75 c5                	jne    80184f <find_allocated_size+0x16>
  80188a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80188e:	75 bf                	jne    80184f <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801890:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8018a3:	a1 24 50 80 00       	mov    0x805024,%eax
  8018a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018ab:	e9 e1 01 00 00       	jmp    801a91 <free_pages+0x1fa>
		if (it->start == va) {
  8018b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b3:	8b 00                	mov    (%eax),%eax
  8018b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8018b8:	0f 85 cb 01 00 00    	jne    801a89 <free_pages+0x1f2>

			uint32 start = it->start;
  8018be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c1:	8b 00                	mov    (%eax),%eax
  8018c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  8018c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c9:	8b 40 04             	mov    0x4(%eax),%eax
  8018cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  8018cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018d2:	f7 d0                	not    %eax
  8018d4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018d7:	73 1d                	jae    8018f6 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  8018d9:	83 ec 0c             	sub    $0xc,%esp
  8018dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018df:	ff 75 e8             	pushl  -0x18(%ebp)
  8018e2:	68 f8 40 80 00       	push   $0x8040f8
  8018e7:	68 a5 00 00 00       	push   $0xa5
  8018ec:	68 91 40 80 00       	push   $0x804091
  8018f1:	e8 e0 1c 00 00       	call   8035d6 <_panic>
			}

			uint32 start_end = start + size;
  8018f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018fc:	01 d0                	add    %edx,%eax
  8018fe:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801901:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801904:	85 c0                	test   %eax,%eax
  801906:	79 19                	jns    801921 <free_pages+0x8a>
  801908:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80190f:	77 10                	ja     801921 <free_pages+0x8a>
  801911:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801918:	77 07                	ja     801921 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  80191a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191d:	85 c0                	test   %eax,%eax
  80191f:	78 2c                	js     80194d <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801921:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801924:	83 ec 0c             	sub    $0xc,%esp
  801927:	68 00 00 00 a0       	push   $0xa0000000
  80192c:	ff 75 e0             	pushl  -0x20(%ebp)
  80192f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801932:	ff 75 e8             	pushl  -0x18(%ebp)
  801935:	ff 75 e4             	pushl  -0x1c(%ebp)
  801938:	50                   	push   %eax
  801939:	68 3c 41 80 00       	push   $0x80413c
  80193e:	68 ad 00 00 00       	push   $0xad
  801943:	68 91 40 80 00       	push   $0x804091
  801948:	e8 89 1c 00 00       	call   8035d6 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  80194d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801950:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801953:	e9 88 00 00 00       	jmp    8019e0 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801958:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  80195f:	76 17                	jbe    801978 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801961:	ff 75 f0             	pushl  -0x10(%ebp)
  801964:	68 a0 41 80 00       	push   $0x8041a0
  801969:	68 b4 00 00 00       	push   $0xb4
  80196e:	68 91 40 80 00       	push   $0x804091
  801973:	e8 5e 1c 00 00       	call   8035d6 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801978:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197b:	05 00 10 00 00       	add    $0x1000,%eax
  801980:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801986:	85 c0                	test   %eax,%eax
  801988:	79 2e                	jns    8019b8 <free_pages+0x121>
  80198a:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801991:	77 25                	ja     8019b8 <free_pages+0x121>
  801993:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  80199a:	77 1c                	ja     8019b8 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  80199c:	83 ec 08             	sub    $0x8,%esp
  80199f:	68 00 10 00 00       	push   $0x1000
  8019a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8019a7:	e8 38 0d 00 00       	call   8026e4 <sys_free_user_mem>
  8019ac:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8019af:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8019b6:	eb 28                	jmp    8019e0 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  8019b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bb:	68 00 00 00 a0       	push   $0xa0000000
  8019c0:	ff 75 dc             	pushl  -0x24(%ebp)
  8019c3:	68 00 10 00 00       	push   $0x1000
  8019c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8019cb:	50                   	push   %eax
  8019cc:	68 e0 41 80 00       	push   $0x8041e0
  8019d1:	68 bd 00 00 00       	push   $0xbd
  8019d6:	68 91 40 80 00       	push   $0x804091
  8019db:	e8 f6 1b 00 00       	call   8035d6 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8019e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8019e6:	0f 82 6c ff ff ff    	jb     801958 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  8019ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019f0:	75 17                	jne    801a09 <free_pages+0x172>
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	68 42 42 80 00       	push   $0x804242
  8019fa:	68 c1 00 00 00       	push   $0xc1
  8019ff:	68 91 40 80 00       	push   $0x804091
  801a04:	e8 cd 1b 00 00       	call   8035d6 <_panic>
  801a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0c:	8b 40 08             	mov    0x8(%eax),%eax
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	74 11                	je     801a24 <free_pages+0x18d>
  801a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a16:	8b 40 08             	mov    0x8(%eax),%eax
  801a19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a1c:	8b 52 0c             	mov    0xc(%edx),%edx
  801a1f:	89 50 0c             	mov    %edx,0xc(%eax)
  801a22:	eb 0b                	jmp    801a2f <free_pages+0x198>
  801a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a27:	8b 40 0c             	mov    0xc(%eax),%eax
  801a2a:	a3 28 50 80 00       	mov    %eax,0x805028
  801a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a32:	8b 40 0c             	mov    0xc(%eax),%eax
  801a35:	85 c0                	test   %eax,%eax
  801a37:	74 11                	je     801a4a <free_pages+0x1b3>
  801a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a42:	8b 52 08             	mov    0x8(%edx),%edx
  801a45:	89 50 08             	mov    %edx,0x8(%eax)
  801a48:	eb 0b                	jmp    801a55 <free_pages+0x1be>
  801a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4d:	8b 40 08             	mov    0x8(%eax),%eax
  801a50:	a3 24 50 80 00       	mov    %eax,0x805024
  801a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a58:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a62:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801a69:	a1 30 50 80 00       	mov    0x805030,%eax
  801a6e:	48                   	dec    %eax
  801a6f:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801a74:	83 ec 0c             	sub    $0xc,%esp
  801a77:	ff 75 f4             	pushl  -0xc(%ebp)
  801a7a:	e8 24 15 00 00       	call   802fa3 <free_block>
  801a7f:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801a82:	e8 72 fb ff ff       	call   8015f9 <recompute_page_alloc_break>

			return;
  801a87:	eb 37                	jmp    801ac0 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a89:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a95:	74 08                	je     801a9f <free_pages+0x208>
  801a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9a:	8b 40 08             	mov    0x8(%eax),%eax
  801a9d:	eb 05                	jmp    801aa4 <free_pages+0x20d>
  801a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801aa9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	0f 85 fa fd ff ff    	jne    8018b0 <free_pages+0x19>
  801ab6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aba:	0f 85 f0 fd ff ff    	jne    8018b0 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801ac5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    

00801acc <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801ad2:	a1 08 50 80 00       	mov    0x805008,%eax
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	74 60                	je     801b3b <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801adb:	83 ec 08             	sub    $0x8,%esp
  801ade:	68 00 00 00 82       	push   $0x82000000
  801ae3:	68 00 00 00 80       	push   $0x80000000
  801ae8:	e8 0d 0d 00 00       	call   8027fa <initialize_dynamic_allocator>
  801aed:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801af0:	e8 f3 0a 00 00       	call   8025e8 <sys_get_uheap_strategy>
  801af5:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801afa:	a1 40 50 80 00       	mov    0x805040,%eax
  801aff:	05 00 10 00 00       	add    $0x1000,%eax
  801b04:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b09:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801b0e:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801b13:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801b1a:	00 00 00 
  801b1d:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801b24:	00 00 00 
  801b27:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801b2e:	00 00 00 

		__firstTimeFlag = 0;
  801b31:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801b38:	00 00 00 
	}
}
  801b3b:	90                   	nop
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b52:	83 ec 08             	sub    $0x8,%esp
  801b55:	68 06 04 00 00       	push   $0x406
  801b5a:	50                   	push   %eax
  801b5b:	e8 d2 06 00 00       	call   802232 <__sys_allocate_page>
  801b60:	83 c4 10             	add    $0x10,%esp
  801b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b6a:	79 17                	jns    801b83 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801b6c:	83 ec 04             	sub    $0x4,%esp
  801b6f:	68 60 42 80 00       	push   $0x804260
  801b74:	68 ea 00 00 00       	push   $0xea
  801b79:	68 91 40 80 00       	push   $0x804091
  801b7e:	e8 53 1a 00 00       	call   8035d6 <_panic>
	return 0;
  801b83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b99:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b9e:	83 ec 0c             	sub    $0xc,%esp
  801ba1:	50                   	push   %eax
  801ba2:	e8 d2 06 00 00       	call   802279 <__sys_unmap_frame>
  801ba7:	83 c4 10             	add    $0x10,%esp
  801baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bb1:	79 17                	jns    801bca <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801bb3:	83 ec 04             	sub    $0x4,%esp
  801bb6:	68 9c 42 80 00       	push   $0x80429c
  801bbb:	68 f5 00 00 00       	push   $0xf5
  801bc0:	68 91 40 80 00       	push   $0x804091
  801bc5:	e8 0c 1a 00 00       	call   8035d6 <_panic>
}
  801bca:	90                   	nop
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801bd3:	e8 f4 fe ff ff       	call   801acc <uheap_init>
	if (size == 0) return NULL ;
  801bd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bdc:	75 0a                	jne    801be8 <malloc+0x1b>
  801bde:	b8 00 00 00 00       	mov    $0x0,%eax
  801be3:	e9 67 01 00 00       	jmp    801d4f <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801be8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801bef:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801bf6:	77 16                	ja     801c0e <malloc+0x41>
		result = alloc_block(size);
  801bf8:	83 ec 0c             	sub    $0xc,%esp
  801bfb:	ff 75 08             	pushl  0x8(%ebp)
  801bfe:	e8 46 0e 00 00       	call   802a49 <alloc_block>
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c09:	e9 3e 01 00 00       	jmp    801d4c <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801c0e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c15:	8b 55 08             	mov    0x8(%ebp),%edx
  801c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1b:	01 d0                	add    %edx,%eax
  801c1d:	48                   	dec    %eax
  801c1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c24:	ba 00 00 00 00       	mov    $0x0,%edx
  801c29:	f7 75 f0             	divl   -0x10(%ebp)
  801c2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c2f:	29 d0                	sub    %edx,%eax
  801c31:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801c34:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c39:	85 c0                	test   %eax,%eax
  801c3b:	75 0a                	jne    801c47 <malloc+0x7a>
			return NULL;
  801c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c42:	e9 08 01 00 00       	jmp    801d4f <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801c47:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801c4c:	85 c0                	test   %eax,%eax
  801c4e:	74 0f                	je     801c5f <malloc+0x92>
  801c50:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801c56:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c5b:	39 c2                	cmp    %eax,%edx
  801c5d:	73 0a                	jae    801c69 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801c5f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c64:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801c69:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801c6e:	83 f8 05             	cmp    $0x5,%eax
  801c71:	75 11                	jne    801c84 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801c73:	83 ec 0c             	sub    $0xc,%esp
  801c76:	ff 75 e8             	pushl  -0x18(%ebp)
  801c79:	e8 ff f9 ff ff       	call   80167d <alloc_pages_custom_fit>
  801c7e:	83 c4 10             	add    $0x10,%esp
  801c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801c84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c88:	0f 84 be 00 00 00    	je     801d4c <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801c94:	83 ec 0c             	sub    $0xc,%esp
  801c97:	ff 75 f4             	pushl  -0xc(%ebp)
  801c9a:	e8 9a fb ff ff       	call   801839 <find_allocated_size>
  801c9f:	83 c4 10             	add    $0x10,%esp
  801ca2:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801ca5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ca9:	75 17                	jne    801cc2 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801cab:	ff 75 f4             	pushl  -0xc(%ebp)
  801cae:	68 dc 42 80 00       	push   $0x8042dc
  801cb3:	68 24 01 00 00       	push   $0x124
  801cb8:	68 91 40 80 00       	push   $0x804091
  801cbd:	e8 14 19 00 00       	call   8035d6 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801cc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cc5:	f7 d0                	not    %eax
  801cc7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801cca:	73 1d                	jae    801ce9 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801ccc:	83 ec 0c             	sub    $0xc,%esp
  801ccf:	ff 75 e0             	pushl  -0x20(%ebp)
  801cd2:	ff 75 e4             	pushl  -0x1c(%ebp)
  801cd5:	68 24 43 80 00       	push   $0x804324
  801cda:	68 29 01 00 00       	push   $0x129
  801cdf:	68 91 40 80 00       	push   $0x804091
  801ce4:	e8 ed 18 00 00       	call   8035d6 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801ce9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801cec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cef:	01 d0                	add    %edx,%eax
  801cf1:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801cf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cf7:	85 c0                	test   %eax,%eax
  801cf9:	79 2c                	jns    801d27 <malloc+0x15a>
  801cfb:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801d02:	77 23                	ja     801d27 <malloc+0x15a>
  801d04:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801d0b:	77 1a                	ja     801d27 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801d0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d10:	85 c0                	test   %eax,%eax
  801d12:	79 13                	jns    801d27 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801d14:	83 ec 08             	sub    $0x8,%esp
  801d17:	ff 75 e0             	pushl  -0x20(%ebp)
  801d1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d1d:	e8 de 09 00 00       	call   802700 <sys_allocate_user_mem>
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	eb 25                	jmp    801d4c <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801d27:	68 00 00 00 a0       	push   $0xa0000000
  801d2c:	ff 75 dc             	pushl  -0x24(%ebp)
  801d2f:	ff 75 e0             	pushl  -0x20(%ebp)
  801d32:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d35:	ff 75 f4             	pushl  -0xc(%ebp)
  801d38:	68 60 43 80 00       	push   $0x804360
  801d3d:	68 33 01 00 00       	push   $0x133
  801d42:	68 91 40 80 00       	push   $0x804091
  801d47:	e8 8a 18 00 00       	call   8035d6 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801d57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d5b:	0f 84 26 01 00 00    	je     801e87 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	79 1c                	jns    801d8a <free+0x39>
  801d6e:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801d75:	77 13                	ja     801d8a <free+0x39>
		free_block(virtual_address);
  801d77:	83 ec 0c             	sub    $0xc,%esp
  801d7a:	ff 75 08             	pushl  0x8(%ebp)
  801d7d:	e8 21 12 00 00       	call   802fa3 <free_block>
  801d82:	83 c4 10             	add    $0x10,%esp
		return;
  801d85:	e9 01 01 00 00       	jmp    801e8b <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801d8a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d8f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801d92:	0f 82 d8 00 00 00    	jb     801e70 <free+0x11f>
  801d98:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801d9f:	0f 87 cb 00 00 00    	ja     801e70 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da8:	25 ff 0f 00 00       	and    $0xfff,%eax
  801dad:	85 c0                	test   %eax,%eax
  801daf:	74 17                	je     801dc8 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801db1:	ff 75 08             	pushl  0x8(%ebp)
  801db4:	68 d0 43 80 00       	push   $0x8043d0
  801db9:	68 57 01 00 00       	push   $0x157
  801dbe:	68 91 40 80 00       	push   $0x804091
  801dc3:	e8 0e 18 00 00       	call   8035d6 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801dc8:	83 ec 0c             	sub    $0xc,%esp
  801dcb:	ff 75 08             	pushl  0x8(%ebp)
  801dce:	e8 66 fa ff ff       	call   801839 <find_allocated_size>
  801dd3:	83 c4 10             	add    $0x10,%esp
  801dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801dd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ddd:	0f 84 a7 00 00 00    	je     801e8a <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de6:	f7 d0                	not    %eax
  801de8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801deb:	73 1d                	jae    801e0a <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801ded:	83 ec 0c             	sub    $0xc,%esp
  801df0:	ff 75 f0             	pushl  -0x10(%ebp)
  801df3:	ff 75 f4             	pushl  -0xc(%ebp)
  801df6:	68 f8 43 80 00       	push   $0x8043f8
  801dfb:	68 61 01 00 00       	push   $0x161
  801e00:	68 91 40 80 00       	push   $0x804091
  801e05:	e8 cc 17 00 00       	call   8035d6 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801e0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e10:	01 d0                	add    %edx,%eax
  801e12:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	79 19                	jns    801e35 <free+0xe4>
  801e1c:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801e23:	77 10                	ja     801e35 <free+0xe4>
  801e25:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801e2c:	77 07                	ja     801e35 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801e2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e31:	85 c0                	test   %eax,%eax
  801e33:	78 2b                	js     801e60 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801e35:	83 ec 0c             	sub    $0xc,%esp
  801e38:	68 00 00 00 a0       	push   $0xa0000000
  801e3d:	ff 75 ec             	pushl  -0x14(%ebp)
  801e40:	ff 75 f0             	pushl  -0x10(%ebp)
  801e43:	ff 75 f4             	pushl  -0xc(%ebp)
  801e46:	ff 75 f0             	pushl  -0x10(%ebp)
  801e49:	ff 75 08             	pushl  0x8(%ebp)
  801e4c:	68 34 44 80 00       	push   $0x804434
  801e51:	68 69 01 00 00       	push   $0x169
  801e56:	68 91 40 80 00       	push   $0x804091
  801e5b:	e8 76 17 00 00       	call   8035d6 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  801e60:	83 ec 0c             	sub    $0xc,%esp
  801e63:	ff 75 08             	pushl  0x8(%ebp)
  801e66:	e8 2c fa ff ff       	call   801897 <free_pages>
  801e6b:	83 c4 10             	add    $0x10,%esp
		return;
  801e6e:	eb 1b                	jmp    801e8b <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  801e70:	ff 75 08             	pushl  0x8(%ebp)
  801e73:	68 90 44 80 00       	push   $0x804490
  801e78:	68 70 01 00 00       	push   $0x170
  801e7d:	68 91 40 80 00       	push   $0x804091
  801e82:	e8 4f 17 00 00       	call   8035d6 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801e87:	90                   	nop
  801e88:	eb 01                	jmp    801e8b <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  801e8a:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 38             	sub    $0x38,%esp
  801e93:	8b 45 10             	mov    0x10(%ebp),%eax
  801e96:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e99:	e8 2e fc ff ff       	call   801acc <uheap_init>
	if (size == 0) return NULL ;
  801e9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ea2:	75 0a                	jne    801eae <smalloc+0x21>
  801ea4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea9:	e9 3d 01 00 00       	jmp    801feb <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  801eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  801eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb7:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ebc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  801ebf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ec3:	74 0e                	je     801ed3 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  801ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801ecb:	05 00 10 00 00       	add    $0x1000,%eax
  801ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed6:	c1 e8 0c             	shr    $0xc,%eax
  801ed9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  801edc:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	75 0a                	jne    801eef <smalloc+0x62>
		return NULL;
  801ee5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eea:	e9 fc 00 00 00       	jmp    801feb <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  801eef:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801ef4:	85 c0                	test   %eax,%eax
  801ef6:	74 0f                	je     801f07 <smalloc+0x7a>
  801ef8:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801efe:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f03:	39 c2                	cmp    %eax,%edx
  801f05:	73 0a                	jae    801f11 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  801f07:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f0c:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  801f11:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f16:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801f1b:	29 c2                	sub    %eax,%edx
  801f1d:	89 d0                	mov    %edx,%eax
  801f1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  801f22:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f28:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f2d:	29 c2                	sub    %eax,%edx
  801f2f:	89 d0                	mov    %edx,%eax
  801f31:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f37:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f3a:	77 13                	ja     801f4f <smalloc+0xc2>
  801f3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f3f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f42:	77 0b                	ja     801f4f <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  801f44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f47:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  801f4a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801f4d:	73 0a                	jae    801f59 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  801f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f54:	e9 92 00 00 00       	jmp    801feb <smalloc+0x15e>
	}

	void *va = NULL;
  801f59:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801f60:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801f65:	83 f8 05             	cmp    $0x5,%eax
  801f68:	75 11                	jne    801f7b <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  801f6a:	83 ec 0c             	sub    $0xc,%esp
  801f6d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f70:	e8 08 f7 ff ff       	call   80167d <alloc_pages_custom_fit>
  801f75:	83 c4 10             	add    $0x10,%esp
  801f78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  801f7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f7f:	75 27                	jne    801fa8 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  801f81:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  801f88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f8b:	2b 45 f4             	sub    -0xc(%ebp),%eax
  801f8e:	89 c2                	mov    %eax,%edx
  801f90:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f95:	39 c2                	cmp    %eax,%edx
  801f97:	73 07                	jae    801fa0 <smalloc+0x113>
			return NULL;}
  801f99:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9e:	eb 4b                	jmp    801feb <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  801fa0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  801fa8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801fac:	ff 75 f0             	pushl  -0x10(%ebp)
  801faf:	50                   	push   %eax
  801fb0:	ff 75 0c             	pushl  0xc(%ebp)
  801fb3:	ff 75 08             	pushl  0x8(%ebp)
  801fb6:	e8 cb 03 00 00       	call   802386 <sys_create_shared_object>
  801fbb:	83 c4 10             	add    $0x10,%esp
  801fbe:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  801fc1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801fc5:	79 07                	jns    801fce <smalloc+0x141>
		return NULL;
  801fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcc:	eb 1d                	jmp    801feb <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  801fce:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fd3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  801fd6:	75 10                	jne    801fe8 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  801fd8:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	01 d0                	add    %edx,%eax
  801fe3:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  801fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ff3:	e8 d4 fa ff ff       	call   801acc <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  801ff8:	83 ec 08             	sub    $0x8,%esp
  801ffb:	ff 75 0c             	pushl  0xc(%ebp)
  801ffe:	ff 75 08             	pushl  0x8(%ebp)
  802001:	e8 aa 03 00 00       	call   8023b0 <sys_size_of_shared_object>
  802006:	83 c4 10             	add    $0x10,%esp
  802009:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  80200c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802010:	7f 0a                	jg     80201c <sget+0x2f>
		return NULL;
  802012:	b8 00 00 00 00       	mov    $0x0,%eax
  802017:	e9 32 01 00 00       	jmp    80214e <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  80201c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80201f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  802022:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802025:	25 ff 0f 00 00       	and    $0xfff,%eax
  80202a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  80202d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802031:	74 0e                	je     802041 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  802033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802036:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802039:	05 00 10 00 00       	add    $0x1000,%eax
  80203e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  802041:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802046:	85 c0                	test   %eax,%eax
  802048:	75 0a                	jne    802054 <sget+0x67>
		return NULL;
  80204a:	b8 00 00 00 00       	mov    $0x0,%eax
  80204f:	e9 fa 00 00 00       	jmp    80214e <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802054:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802059:	85 c0                	test   %eax,%eax
  80205b:	74 0f                	je     80206c <sget+0x7f>
  80205d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802063:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802068:	39 c2                	cmp    %eax,%edx
  80206a:	73 0a                	jae    802076 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  80206c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802071:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802076:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80207b:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802080:	29 c2                	sub    %eax,%edx
  802082:	89 d0                	mov    %edx,%eax
  802084:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802087:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80208d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802092:	29 c2                	sub    %eax,%edx
  802094:	89 d0                	mov    %edx,%eax
  802096:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80209f:	77 13                	ja     8020b4 <sget+0xc7>
  8020a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020a4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020a7:	77 0b                	ja     8020b4 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8020a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ac:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020af:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8020b2:	73 0a                	jae    8020be <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8020b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b9:	e9 90 00 00 00       	jmp    80214e <sget+0x161>

	void *va = NULL;
  8020be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  8020c5:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8020ca:	83 f8 05             	cmp    $0x5,%eax
  8020cd:	75 11                	jne    8020e0 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  8020cf:	83 ec 0c             	sub    $0xc,%esp
  8020d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d5:	e8 a3 f5 ff ff       	call   80167d <alloc_pages_custom_fit>
  8020da:	83 c4 10             	add    $0x10,%esp
  8020dd:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8020e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020e4:	75 27                	jne    80210d <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8020e6:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8020ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020f0:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8020f3:	89 c2                	mov    %eax,%edx
  8020f5:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020fa:	39 c2                	cmp    %eax,%edx
  8020fc:	73 07                	jae    802105 <sget+0x118>
			return NULL;
  8020fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802103:	eb 49                	jmp    80214e <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802105:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80210a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  80210d:	83 ec 04             	sub    $0x4,%esp
  802110:	ff 75 f0             	pushl  -0x10(%ebp)
  802113:	ff 75 0c             	pushl  0xc(%ebp)
  802116:	ff 75 08             	pushl  0x8(%ebp)
  802119:	e8 af 02 00 00       	call   8023cd <sys_get_shared_object>
  80211e:	83 c4 10             	add    $0x10,%esp
  802121:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  802124:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802128:	79 07                	jns    802131 <sget+0x144>
		return NULL;
  80212a:	b8 00 00 00 00       	mov    $0x0,%eax
  80212f:	eb 1d                	jmp    80214e <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  802131:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802136:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802139:	75 10                	jne    80214b <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  80213b:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802144:	01 d0                	add    %edx,%eax
  802146:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  80214b:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802156:	e8 71 f9 ff ff       	call   801acc <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80215b:	83 ec 04             	sub    $0x4,%esp
  80215e:	68 b4 44 80 00       	push   $0x8044b4
  802163:	68 19 02 00 00       	push   $0x219
  802168:	68 91 40 80 00       	push   $0x804091
  80216d:	e8 64 14 00 00       	call   8035d6 <_panic>

00802172 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
  802175:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802178:	83 ec 04             	sub    $0x4,%esp
  80217b:	68 dc 44 80 00       	push   $0x8044dc
  802180:	68 2b 02 00 00       	push   $0x22b
  802185:	68 91 40 80 00       	push   $0x804091
  80218a:	e8 47 14 00 00       	call   8035d6 <_panic>

0080218f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	57                   	push   %edi
  802193:	56                   	push   %esi
  802194:	53                   	push   %ebx
  802195:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021a4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021a7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021aa:	cd 30                	int    $0x30
  8021ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8021af:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021b2:	83 c4 10             	add    $0x10,%esp
  8021b5:	5b                   	pop    %ebx
  8021b6:	5e                   	pop    %esi
  8021b7:	5f                   	pop    %edi
  8021b8:	5d                   	pop    %ebp
  8021b9:	c3                   	ret    

008021ba <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	83 ec 04             	sub    $0x4,%esp
  8021c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8021c6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021c9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	6a 00                	push   $0x0
  8021d2:	51                   	push   %ecx
  8021d3:	52                   	push   %edx
  8021d4:	ff 75 0c             	pushl  0xc(%ebp)
  8021d7:	50                   	push   %eax
  8021d8:	6a 00                	push   $0x0
  8021da:	e8 b0 ff ff ff       	call   80218f <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
}
  8021e2:	90                   	nop
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 02                	push   $0x2
  8021f4:	e8 96 ff ff ff       	call   80218f <syscall>
  8021f9:	83 c4 18             	add    $0x18,%esp
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <sys_lock_cons>:

void sys_lock_cons(void)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 03                	push   $0x3
  80220d:	e8 7d ff ff ff       	call   80218f <syscall>
  802212:	83 c4 18             	add    $0x18,%esp
}
  802215:	90                   	nop
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 04                	push   $0x4
  802227:	e8 63 ff ff ff       	call   80218f <syscall>
  80222c:	83 c4 18             	add    $0x18,%esp
}
  80222f:	90                   	nop
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802235:	8b 55 0c             	mov    0xc(%ebp),%edx
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	52                   	push   %edx
  802242:	50                   	push   %eax
  802243:	6a 08                	push   $0x8
  802245:	e8 45 ff ff ff       	call   80218f <syscall>
  80224a:	83 c4 18             	add    $0x18,%esp
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	56                   	push   %esi
  802253:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802254:	8b 75 18             	mov    0x18(%ebp),%esi
  802257:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80225a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80225d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	56                   	push   %esi
  802264:	53                   	push   %ebx
  802265:	51                   	push   %ecx
  802266:	52                   	push   %edx
  802267:	50                   	push   %eax
  802268:	6a 09                	push   $0x9
  80226a:	e8 20 ff ff ff       	call   80218f <syscall>
  80226f:	83 c4 18             	add    $0x18,%esp
}
  802272:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802275:	5b                   	pop    %ebx
  802276:	5e                   	pop    %esi
  802277:	5d                   	pop    %ebp
  802278:	c3                   	ret    

00802279 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	ff 75 08             	pushl  0x8(%ebp)
  802287:	6a 0a                	push   $0xa
  802289:	e8 01 ff ff ff       	call   80218f <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	ff 75 0c             	pushl  0xc(%ebp)
  80229f:	ff 75 08             	pushl  0x8(%ebp)
  8022a2:	6a 0b                	push   $0xb
  8022a4:	e8 e6 fe ff ff       	call   80218f <syscall>
  8022a9:	83 c4 18             	add    $0x18,%esp
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 0c                	push   $0xc
  8022bd:	e8 cd fe ff ff       	call   80218f <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 0d                	push   $0xd
  8022d6:	e8 b4 fe ff ff       	call   80218f <syscall>
  8022db:	83 c4 18             	add    $0x18,%esp
}
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    

008022e0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 0e                	push   $0xe
  8022ef:	e8 9b fe ff ff       	call   80218f <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
}
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 0f                	push   $0xf
  802308:	e8 82 fe ff ff       	call   80218f <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	ff 75 08             	pushl  0x8(%ebp)
  802320:	6a 10                	push   $0x10
  802322:	e8 68 fe ff ff       	call   80218f <syscall>
  802327:	83 c4 18             	add    $0x18,%esp
}
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 11                	push   $0x11
  80233b:	e8 4f fe ff ff       	call   80218f <syscall>
  802340:	83 c4 18             	add    $0x18,%esp
}
  802343:	90                   	nop
  802344:	c9                   	leave  
  802345:	c3                   	ret    

00802346 <sys_cputc>:

void
sys_cputc(const char c)
{
  802346:	55                   	push   %ebp
  802347:	89 e5                	mov    %esp,%ebp
  802349:	83 ec 04             	sub    $0x4,%esp
  80234c:	8b 45 08             	mov    0x8(%ebp),%eax
  80234f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802352:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	50                   	push   %eax
  80235f:	6a 01                	push   $0x1
  802361:	e8 29 fe ff ff       	call   80218f <syscall>
  802366:	83 c4 18             	add    $0x18,%esp
}
  802369:	90                   	nop
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    

0080236c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 14                	push   $0x14
  80237b:	e8 0f fe ff ff       	call   80218f <syscall>
  802380:	83 c4 18             	add    $0x18,%esp
}
  802383:	90                   	nop
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	83 ec 04             	sub    $0x4,%esp
  80238c:	8b 45 10             	mov    0x10(%ebp),%eax
  80238f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802392:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802395:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	6a 00                	push   $0x0
  80239e:	51                   	push   %ecx
  80239f:	52                   	push   %edx
  8023a0:	ff 75 0c             	pushl  0xc(%ebp)
  8023a3:	50                   	push   %eax
  8023a4:	6a 15                	push   $0x15
  8023a6:	e8 e4 fd ff ff       	call   80218f <syscall>
  8023ab:	83 c4 18             	add    $0x18,%esp
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	52                   	push   %edx
  8023c0:	50                   	push   %eax
  8023c1:	6a 16                	push   $0x16
  8023c3:	e8 c7 fd ff ff       	call   80218f <syscall>
  8023c8:	83 c4 18             	add    $0x18,%esp
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	51                   	push   %ecx
  8023de:	52                   	push   %edx
  8023df:	50                   	push   %eax
  8023e0:	6a 17                	push   $0x17
  8023e2:	e8 a8 fd ff ff       	call   80218f <syscall>
  8023e7:	83 c4 18             	add    $0x18,%esp
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	52                   	push   %edx
  8023fc:	50                   	push   %eax
  8023fd:	6a 18                	push   $0x18
  8023ff:	e8 8b fd ff ff       	call   80218f <syscall>
  802404:	83 c4 18             	add    $0x18,%esp
}
  802407:	c9                   	leave  
  802408:	c3                   	ret    

00802409 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	6a 00                	push   $0x0
  802411:	ff 75 14             	pushl  0x14(%ebp)
  802414:	ff 75 10             	pushl  0x10(%ebp)
  802417:	ff 75 0c             	pushl  0xc(%ebp)
  80241a:	50                   	push   %eax
  80241b:	6a 19                	push   $0x19
  80241d:	e8 6d fd ff ff       	call   80218f <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
}
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	50                   	push   %eax
  802436:	6a 1a                	push   $0x1a
  802438:	e8 52 fd ff ff       	call   80218f <syscall>
  80243d:	83 c4 18             	add    $0x18,%esp
}
  802440:	90                   	nop
  802441:	c9                   	leave  
  802442:	c3                   	ret    

00802443 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802443:	55                   	push   %ebp
  802444:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	50                   	push   %eax
  802452:	6a 1b                	push   $0x1b
  802454:	e8 36 fd ff ff       	call   80218f <syscall>
  802459:	83 c4 18             	add    $0x18,%esp
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 05                	push   $0x5
  80246d:	e8 1d fd ff ff       	call   80218f <syscall>
  802472:	83 c4 18             	add    $0x18,%esp
}
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 06                	push   $0x6
  802486:	e8 04 fd ff ff       	call   80218f <syscall>
  80248b:	83 c4 18             	add    $0x18,%esp
}
  80248e:	c9                   	leave  
  80248f:	c3                   	ret    

00802490 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 07                	push   $0x7
  80249f:	e8 eb fc ff ff       	call   80218f <syscall>
  8024a4:	83 c4 18             	add    $0x18,%esp
}
  8024a7:	c9                   	leave  
  8024a8:	c3                   	ret    

008024a9 <sys_exit_env>:


void sys_exit_env(void)
{
  8024a9:	55                   	push   %ebp
  8024aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 1c                	push   $0x1c
  8024b8:	e8 d2 fc ff ff       	call   80218f <syscall>
  8024bd:	83 c4 18             	add    $0x18,%esp
}
  8024c0:	90                   	nop
  8024c1:	c9                   	leave  
  8024c2:	c3                   	ret    

008024c3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024c9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024cc:	8d 50 04             	lea    0x4(%eax),%edx
  8024cf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	52                   	push   %edx
  8024d9:	50                   	push   %eax
  8024da:	6a 1d                	push   $0x1d
  8024dc:	e8 ae fc ff ff       	call   80218f <syscall>
  8024e1:	83 c4 18             	add    $0x18,%esp
	return result;
  8024e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024ed:	89 01                	mov    %eax,(%ecx)
  8024ef:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	c9                   	leave  
  8024f6:	c2 04 00             	ret    $0x4

008024f9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	ff 75 10             	pushl  0x10(%ebp)
  802503:	ff 75 0c             	pushl  0xc(%ebp)
  802506:	ff 75 08             	pushl  0x8(%ebp)
  802509:	6a 13                	push   $0x13
  80250b:	e8 7f fc ff ff       	call   80218f <syscall>
  802510:	83 c4 18             	add    $0x18,%esp
	return ;
  802513:	90                   	nop
}
  802514:	c9                   	leave  
  802515:	c3                   	ret    

00802516 <sys_rcr2>:
uint32 sys_rcr2()
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 1e                	push   $0x1e
  802525:	e8 65 fc ff ff       	call   80218f <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
  802532:	83 ec 04             	sub    $0x4,%esp
  802535:	8b 45 08             	mov    0x8(%ebp),%eax
  802538:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80253b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	50                   	push   %eax
  802548:	6a 1f                	push   $0x1f
  80254a:	e8 40 fc ff ff       	call   80218f <syscall>
  80254f:	83 c4 18             	add    $0x18,%esp
	return ;
  802552:	90                   	nop
}
  802553:	c9                   	leave  
  802554:	c3                   	ret    

00802555 <rsttst>:
void rsttst()
{
  802555:	55                   	push   %ebp
  802556:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802558:	6a 00                	push   $0x0
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 21                	push   $0x21
  802564:	e8 26 fc ff ff       	call   80218f <syscall>
  802569:	83 c4 18             	add    $0x18,%esp
	return ;
  80256c:	90                   	nop
}
  80256d:	c9                   	leave  
  80256e:	c3                   	ret    

0080256f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80256f:	55                   	push   %ebp
  802570:	89 e5                	mov    %esp,%ebp
  802572:	83 ec 04             	sub    $0x4,%esp
  802575:	8b 45 14             	mov    0x14(%ebp),%eax
  802578:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80257b:	8b 55 18             	mov    0x18(%ebp),%edx
  80257e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802582:	52                   	push   %edx
  802583:	50                   	push   %eax
  802584:	ff 75 10             	pushl  0x10(%ebp)
  802587:	ff 75 0c             	pushl  0xc(%ebp)
  80258a:	ff 75 08             	pushl  0x8(%ebp)
  80258d:	6a 20                	push   $0x20
  80258f:	e8 fb fb ff ff       	call   80218f <syscall>
  802594:	83 c4 18             	add    $0x18,%esp
	return ;
  802597:	90                   	nop
}
  802598:	c9                   	leave  
  802599:	c3                   	ret    

0080259a <chktst>:
void chktst(uint32 n)
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	ff 75 08             	pushl  0x8(%ebp)
  8025a8:	6a 22                	push   $0x22
  8025aa:	e8 e0 fb ff ff       	call   80218f <syscall>
  8025af:	83 c4 18             	add    $0x18,%esp
	return ;
  8025b2:	90                   	nop
}
  8025b3:	c9                   	leave  
  8025b4:	c3                   	ret    

008025b5 <inctst>:

void inctst()
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 23                	push   $0x23
  8025c4:	e8 c6 fb ff ff       	call   80218f <syscall>
  8025c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8025cc:	90                   	nop
}
  8025cd:	c9                   	leave  
  8025ce:	c3                   	ret    

008025cf <gettst>:
uint32 gettst()
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 24                	push   $0x24
  8025de:	e8 ac fb ff ff       	call   80218f <syscall>
  8025e3:	83 c4 18             	add    $0x18,%esp
}
  8025e6:	c9                   	leave  
  8025e7:	c3                   	ret    

008025e8 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 25                	push   $0x25
  8025f7:	e8 93 fb ff ff       	call   80218f <syscall>
  8025fc:	83 c4 18             	add    $0x18,%esp
  8025ff:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802604:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802609:	c9                   	leave  
  80260a:	c3                   	ret    

0080260b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80260b:	55                   	push   %ebp
  80260c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80260e:	8b 45 08             	mov    0x8(%ebp),%eax
  802611:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	ff 75 08             	pushl  0x8(%ebp)
  802621:	6a 26                	push   $0x26
  802623:	e8 67 fb ff ff       	call   80218f <syscall>
  802628:	83 c4 18             	add    $0x18,%esp
	return ;
  80262b:	90                   	nop
}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
  802631:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802632:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802635:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802638:	8b 55 0c             	mov    0xc(%ebp),%edx
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	6a 00                	push   $0x0
  802640:	53                   	push   %ebx
  802641:	51                   	push   %ecx
  802642:	52                   	push   %edx
  802643:	50                   	push   %eax
  802644:	6a 27                	push   $0x27
  802646:	e8 44 fb ff ff       	call   80218f <syscall>
  80264b:	83 c4 18             	add    $0x18,%esp
}
  80264e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802651:	c9                   	leave  
  802652:	c3                   	ret    

00802653 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802656:	8b 55 0c             	mov    0xc(%ebp),%edx
  802659:	8b 45 08             	mov    0x8(%ebp),%eax
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	52                   	push   %edx
  802663:	50                   	push   %eax
  802664:	6a 28                	push   $0x28
  802666:	e8 24 fb ff ff       	call   80218f <syscall>
  80266b:	83 c4 18             	add    $0x18,%esp
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802673:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802676:	8b 55 0c             	mov    0xc(%ebp),%edx
  802679:	8b 45 08             	mov    0x8(%ebp),%eax
  80267c:	6a 00                	push   $0x0
  80267e:	51                   	push   %ecx
  80267f:	ff 75 10             	pushl  0x10(%ebp)
  802682:	52                   	push   %edx
  802683:	50                   	push   %eax
  802684:	6a 29                	push   $0x29
  802686:	e8 04 fb ff ff       	call   80218f <syscall>
  80268b:	83 c4 18             	add    $0x18,%esp
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	ff 75 10             	pushl  0x10(%ebp)
  80269a:	ff 75 0c             	pushl  0xc(%ebp)
  80269d:	ff 75 08             	pushl  0x8(%ebp)
  8026a0:	6a 12                	push   $0x12
  8026a2:	e8 e8 fa ff ff       	call   80218f <syscall>
  8026a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8026aa:	90                   	nop
}
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8026b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	52                   	push   %edx
  8026bd:	50                   	push   %eax
  8026be:	6a 2a                	push   $0x2a
  8026c0:	e8 ca fa ff ff       	call   80218f <syscall>
  8026c5:	83 c4 18             	add    $0x18,%esp
	return;
  8026c8:	90                   	nop
}
  8026c9:	c9                   	leave  
  8026ca:	c3                   	ret    

008026cb <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8026cb:	55                   	push   %ebp
  8026cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8026ce:	6a 00                	push   $0x0
  8026d0:	6a 00                	push   $0x0
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 2b                	push   $0x2b
  8026da:	e8 b0 fa ff ff       	call   80218f <syscall>
  8026df:	83 c4 18             	add    $0x18,%esp
}
  8026e2:	c9                   	leave  
  8026e3:	c3                   	ret    

008026e4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8026e7:	6a 00                	push   $0x0
  8026e9:	6a 00                	push   $0x0
  8026eb:	6a 00                	push   $0x0
  8026ed:	ff 75 0c             	pushl  0xc(%ebp)
  8026f0:	ff 75 08             	pushl  0x8(%ebp)
  8026f3:	6a 2d                	push   $0x2d
  8026f5:	e8 95 fa ff ff       	call   80218f <syscall>
  8026fa:	83 c4 18             	add    $0x18,%esp
	return;
  8026fd:	90                   	nop
}
  8026fe:	c9                   	leave  
  8026ff:	c3                   	ret    

00802700 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802700:	55                   	push   %ebp
  802701:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	ff 75 0c             	pushl  0xc(%ebp)
  80270c:	ff 75 08             	pushl  0x8(%ebp)
  80270f:	6a 2c                	push   $0x2c
  802711:	e8 79 fa ff ff       	call   80218f <syscall>
  802716:	83 c4 18             	add    $0x18,%esp
	return ;
  802719:	90                   	nop
}
  80271a:	c9                   	leave  
  80271b:	c3                   	ret    

0080271c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80271c:	55                   	push   %ebp
  80271d:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80271f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802722:	8b 45 08             	mov    0x8(%ebp),%eax
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	52                   	push   %edx
  80272c:	50                   	push   %eax
  80272d:	6a 2e                	push   $0x2e
  80272f:	e8 5b fa ff ff       	call   80218f <syscall>
  802734:	83 c4 18             	add    $0x18,%esp
	return ;
  802737:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802738:	c9                   	leave  
  802739:	c3                   	ret    

0080273a <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80273a:	55                   	push   %ebp
  80273b:	89 e5                	mov    %esp,%ebp
  80273d:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802740:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802747:	72 09                	jb     802752 <to_page_va+0x18>
  802749:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802750:	72 14                	jb     802766 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802752:	83 ec 04             	sub    $0x4,%esp
  802755:	68 00 45 80 00       	push   $0x804500
  80275a:	6a 15                	push   $0x15
  80275c:	68 2b 45 80 00       	push   $0x80452b
  802761:	e8 70 0e 00 00       	call   8035d6 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802766:	8b 45 08             	mov    0x8(%ebp),%eax
  802769:	ba 60 50 80 00       	mov    $0x805060,%edx
  80276e:	29 d0                	sub    %edx,%eax
  802770:	c1 f8 02             	sar    $0x2,%eax
  802773:	89 c2                	mov    %eax,%edx
  802775:	89 d0                	mov    %edx,%eax
  802777:	c1 e0 02             	shl    $0x2,%eax
  80277a:	01 d0                	add    %edx,%eax
  80277c:	c1 e0 02             	shl    $0x2,%eax
  80277f:	01 d0                	add    %edx,%eax
  802781:	c1 e0 02             	shl    $0x2,%eax
  802784:	01 d0                	add    %edx,%eax
  802786:	89 c1                	mov    %eax,%ecx
  802788:	c1 e1 08             	shl    $0x8,%ecx
  80278b:	01 c8                	add    %ecx,%eax
  80278d:	89 c1                	mov    %eax,%ecx
  80278f:	c1 e1 10             	shl    $0x10,%ecx
  802792:	01 c8                	add    %ecx,%eax
  802794:	01 c0                	add    %eax,%eax
  802796:	01 d0                	add    %edx,%eax
  802798:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	c1 e0 0c             	shl    $0xc,%eax
  8027a1:	89 c2                	mov    %eax,%edx
  8027a3:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8027a8:	01 d0                	add    %edx,%eax
}
  8027aa:	c9                   	leave  
  8027ab:	c3                   	ret    

008027ac <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8027ac:	55                   	push   %ebp
  8027ad:	89 e5                	mov    %esp,%ebp
  8027af:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8027b2:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8027b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ba:	29 c2                	sub    %eax,%edx
  8027bc:	89 d0                	mov    %edx,%eax
  8027be:	c1 e8 0c             	shr    $0xc,%eax
  8027c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8027c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c8:	78 09                	js     8027d3 <to_page_info+0x27>
  8027ca:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8027d1:	7e 14                	jle    8027e7 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  8027d3:	83 ec 04             	sub    $0x4,%esp
  8027d6:	68 44 45 80 00       	push   $0x804544
  8027db:	6a 22                	push   $0x22
  8027dd:	68 2b 45 80 00       	push   $0x80452b
  8027e2:	e8 ef 0d 00 00       	call   8035d6 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8027e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ea:	89 d0                	mov    %edx,%eax
  8027ec:	01 c0                	add    %eax,%eax
  8027ee:	01 d0                	add    %edx,%eax
  8027f0:	c1 e0 02             	shl    $0x2,%eax
  8027f3:	05 60 50 80 00       	add    $0x805060,%eax
}
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
  8027fd:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802800:	8b 45 08             	mov    0x8(%ebp),%eax
  802803:	05 00 00 00 02       	add    $0x2000000,%eax
  802808:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80280b:	73 16                	jae    802823 <initialize_dynamic_allocator+0x29>
  80280d:	68 68 45 80 00       	push   $0x804568
  802812:	68 8e 45 80 00       	push   $0x80458e
  802817:	6a 34                	push   $0x34
  802819:	68 2b 45 80 00       	push   $0x80452b
  80281e:	e8 b3 0d 00 00       	call   8035d6 <_panic>
		is_initialized = 1;
  802823:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  80282a:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  80282d:	8b 45 08             	mov    0x8(%ebp),%eax
  802830:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802835:	8b 45 0c             	mov    0xc(%ebp),%eax
  802838:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  80283d:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802844:	00 00 00 
  802847:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80284e:	00 00 00 
  802851:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802858:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  80285b:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802862:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802869:	eb 36                	jmp    8028a1 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	c1 e0 04             	shl    $0x4,%eax
  802871:	05 80 d0 81 00       	add    $0x81d080,%eax
  802876:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	c1 e0 04             	shl    $0x4,%eax
  802882:	05 84 d0 81 00       	add    $0x81d084,%eax
  802887:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	c1 e0 04             	shl    $0x4,%eax
  802893:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802898:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  80289e:	ff 45 f4             	incl   -0xc(%ebp)
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8028a7:	72 c2                	jb     80286b <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  8028a9:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028af:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8028b4:	29 c2                	sub    %eax,%edx
  8028b6:	89 d0                	mov    %edx,%eax
  8028b8:	c1 e8 0c             	shr    $0xc,%eax
  8028bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  8028be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8028c5:	e9 c8 00 00 00       	jmp    802992 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  8028ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028cd:	89 d0                	mov    %edx,%eax
  8028cf:	01 c0                	add    %eax,%eax
  8028d1:	01 d0                	add    %edx,%eax
  8028d3:	c1 e0 02             	shl    $0x2,%eax
  8028d6:	05 68 50 80 00       	add    $0x805068,%eax
  8028db:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  8028e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e3:	89 d0                	mov    %edx,%eax
  8028e5:	01 c0                	add    %eax,%eax
  8028e7:	01 d0                	add    %edx,%eax
  8028e9:	c1 e0 02             	shl    $0x2,%eax
  8028ec:	05 6a 50 80 00       	add    $0x80506a,%eax
  8028f1:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8028f6:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8028fc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8028ff:	89 c8                	mov    %ecx,%eax
  802901:	01 c0                	add    %eax,%eax
  802903:	01 c8                	add    %ecx,%eax
  802905:	c1 e0 02             	shl    $0x2,%eax
  802908:	05 64 50 80 00       	add    $0x805064,%eax
  80290d:	89 10                	mov    %edx,(%eax)
  80290f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802912:	89 d0                	mov    %edx,%eax
  802914:	01 c0                	add    %eax,%eax
  802916:	01 d0                	add    %edx,%eax
  802918:	c1 e0 02             	shl    $0x2,%eax
  80291b:	05 64 50 80 00       	add    $0x805064,%eax
  802920:	8b 00                	mov    (%eax),%eax
  802922:	85 c0                	test   %eax,%eax
  802924:	74 1b                	je     802941 <initialize_dynamic_allocator+0x147>
  802926:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80292c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80292f:	89 c8                	mov    %ecx,%eax
  802931:	01 c0                	add    %eax,%eax
  802933:	01 c8                	add    %ecx,%eax
  802935:	c1 e0 02             	shl    $0x2,%eax
  802938:	05 60 50 80 00       	add    $0x805060,%eax
  80293d:	89 02                	mov    %eax,(%edx)
  80293f:	eb 16                	jmp    802957 <initialize_dynamic_allocator+0x15d>
  802941:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802944:	89 d0                	mov    %edx,%eax
  802946:	01 c0                	add    %eax,%eax
  802948:	01 d0                	add    %edx,%eax
  80294a:	c1 e0 02             	shl    $0x2,%eax
  80294d:	05 60 50 80 00       	add    $0x805060,%eax
  802952:	a3 48 50 80 00       	mov    %eax,0x805048
  802957:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80295a:	89 d0                	mov    %edx,%eax
  80295c:	01 c0                	add    %eax,%eax
  80295e:	01 d0                	add    %edx,%eax
  802960:	c1 e0 02             	shl    $0x2,%eax
  802963:	05 60 50 80 00       	add    $0x805060,%eax
  802968:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80296d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802970:	89 d0                	mov    %edx,%eax
  802972:	01 c0                	add    %eax,%eax
  802974:	01 d0                	add    %edx,%eax
  802976:	c1 e0 02             	shl    $0x2,%eax
  802979:	05 60 50 80 00       	add    $0x805060,%eax
  80297e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802984:	a1 54 50 80 00       	mov    0x805054,%eax
  802989:	40                   	inc    %eax
  80298a:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  80298f:	ff 45 f0             	incl   -0x10(%ebp)
  802992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802995:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802998:	0f 82 2c ff ff ff    	jb     8028ca <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  80299e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029a4:	eb 2f                	jmp    8029d5 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  8029a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029a9:	89 d0                	mov    %edx,%eax
  8029ab:	01 c0                	add    %eax,%eax
  8029ad:	01 d0                	add    %edx,%eax
  8029af:	c1 e0 02             	shl    $0x2,%eax
  8029b2:	05 68 50 80 00       	add    $0x805068,%eax
  8029b7:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  8029bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029bf:	89 d0                	mov    %edx,%eax
  8029c1:	01 c0                	add    %eax,%eax
  8029c3:	01 d0                	add    %edx,%eax
  8029c5:	c1 e0 02             	shl    $0x2,%eax
  8029c8:	05 6a 50 80 00       	add    $0x80506a,%eax
  8029cd:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8029d2:	ff 45 ec             	incl   -0x14(%ebp)
  8029d5:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  8029dc:	76 c8                	jbe    8029a6 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8029de:	90                   	nop
  8029df:	c9                   	leave  
  8029e0:	c3                   	ret    

008029e1 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8029e1:	55                   	push   %ebp
  8029e2:	89 e5                	mov    %esp,%ebp
  8029e4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  8029e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ea:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8029ef:	29 c2                	sub    %eax,%edx
  8029f1:	89 d0                	mov    %edx,%eax
  8029f3:	c1 e8 0c             	shr    $0xc,%eax
  8029f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  8029f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029fc:	89 d0                	mov    %edx,%eax
  8029fe:	01 c0                	add    %eax,%eax
  802a00:	01 d0                	add    %edx,%eax
  802a02:	c1 e0 02             	shl    $0x2,%eax
  802a05:	05 68 50 80 00       	add    $0x805068,%eax
  802a0a:	8b 00                	mov    (%eax),%eax
  802a0c:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802a0f:	c9                   	leave  
  802a10:	c3                   	ret    

00802a11 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802a11:	55                   	push   %ebp
  802a12:	89 e5                	mov    %esp,%ebp
  802a14:	83 ec 14             	sub    $0x14,%esp
  802a17:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802a1a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802a1e:	77 07                	ja     802a27 <nearest_pow2_ceil.1513+0x16>
  802a20:	b8 01 00 00 00       	mov    $0x1,%eax
  802a25:	eb 20                	jmp    802a47 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802a27:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802a2e:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802a31:	eb 08                	jmp    802a3b <nearest_pow2_ceil.1513+0x2a>
  802a33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a36:	01 c0                	add    %eax,%eax
  802a38:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a3b:	d1 6d 08             	shrl   0x8(%ebp)
  802a3e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a42:	75 ef                	jne    802a33 <nearest_pow2_ceil.1513+0x22>
        return power;
  802a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802a47:	c9                   	leave  
  802a48:	c3                   	ret    

00802a49 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802a49:	55                   	push   %ebp
  802a4a:	89 e5                	mov    %esp,%ebp
  802a4c:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802a4f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802a56:	76 16                	jbe    802a6e <alloc_block+0x25>
  802a58:	68 a4 45 80 00       	push   $0x8045a4
  802a5d:	68 8e 45 80 00       	push   $0x80458e
  802a62:	6a 72                	push   $0x72
  802a64:	68 2b 45 80 00       	push   $0x80452b
  802a69:	e8 68 0b 00 00       	call   8035d6 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802a6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a72:	75 0a                	jne    802a7e <alloc_block+0x35>
  802a74:	b8 00 00 00 00       	mov    $0x0,%eax
  802a79:	e9 bd 04 00 00       	jmp    802f3b <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802a7e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802a85:	8b 45 08             	mov    0x8(%ebp),%eax
  802a88:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a8b:	73 06                	jae    802a93 <alloc_block+0x4a>
        size = min_block_size;
  802a8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a90:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802a93:	83 ec 0c             	sub    $0xc,%esp
  802a96:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802a99:	ff 75 08             	pushl  0x8(%ebp)
  802a9c:	89 c1                	mov    %eax,%ecx
  802a9e:	e8 6e ff ff ff       	call   802a11 <nearest_pow2_ceil.1513>
  802aa3:	83 c4 10             	add    $0x10,%esp
  802aa6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802aa9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aac:	83 ec 0c             	sub    $0xc,%esp
  802aaf:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802ab2:	52                   	push   %edx
  802ab3:	89 c1                	mov    %eax,%ecx
  802ab5:	e8 83 04 00 00       	call   802f3d <log2_ceil.1520>
  802aba:	83 c4 10             	add    $0x10,%esp
  802abd:	83 e8 03             	sub    $0x3,%eax
  802ac0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802ac3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac6:	c1 e0 04             	shl    $0x4,%eax
  802ac9:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	85 c0                	test   %eax,%eax
  802ad2:	0f 84 d8 00 00 00    	je     802bb0 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802ad8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802adb:	c1 e0 04             	shl    $0x4,%eax
  802ade:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ae3:	8b 00                	mov    (%eax),%eax
  802ae5:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802ae8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802aec:	75 17                	jne    802b05 <alloc_block+0xbc>
  802aee:	83 ec 04             	sub    $0x4,%esp
  802af1:	68 c5 45 80 00       	push   $0x8045c5
  802af6:	68 98 00 00 00       	push   $0x98
  802afb:	68 2b 45 80 00       	push   $0x80452b
  802b00:	e8 d1 0a 00 00       	call   8035d6 <_panic>
  802b05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b08:	8b 00                	mov    (%eax),%eax
  802b0a:	85 c0                	test   %eax,%eax
  802b0c:	74 10                	je     802b1e <alloc_block+0xd5>
  802b0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b11:	8b 00                	mov    (%eax),%eax
  802b13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b16:	8b 52 04             	mov    0x4(%edx),%edx
  802b19:	89 50 04             	mov    %edx,0x4(%eax)
  802b1c:	eb 14                	jmp    802b32 <alloc_block+0xe9>
  802b1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b21:	8b 40 04             	mov    0x4(%eax),%eax
  802b24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b27:	c1 e2 04             	shl    $0x4,%edx
  802b2a:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802b30:	89 02                	mov    %eax,(%edx)
  802b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b35:	8b 40 04             	mov    0x4(%eax),%eax
  802b38:	85 c0                	test   %eax,%eax
  802b3a:	74 0f                	je     802b4b <alloc_block+0x102>
  802b3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b3f:	8b 40 04             	mov    0x4(%eax),%eax
  802b42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b45:	8b 12                	mov    (%edx),%edx
  802b47:	89 10                	mov    %edx,(%eax)
  802b49:	eb 13                	jmp    802b5e <alloc_block+0x115>
  802b4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b4e:	8b 00                	mov    (%eax),%eax
  802b50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b53:	c1 e2 04             	shl    $0x4,%edx
  802b56:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802b5c:	89 02                	mov    %eax,(%edx)
  802b5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b74:	c1 e0 04             	shl    $0x4,%eax
  802b77:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802b81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b84:	c1 e0 04             	shl    $0x4,%eax
  802b87:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802b8c:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802b8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b91:	83 ec 0c             	sub    $0xc,%esp
  802b94:	50                   	push   %eax
  802b95:	e8 12 fc ff ff       	call   8027ac <to_page_info>
  802b9a:	83 c4 10             	add    $0x10,%esp
  802b9d:	89 c2                	mov    %eax,%edx
  802b9f:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802ba3:	48                   	dec    %eax
  802ba4:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802ba8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bab:	e9 8b 03 00 00       	jmp    802f3b <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802bb0:	a1 48 50 80 00       	mov    0x805048,%eax
  802bb5:	85 c0                	test   %eax,%eax
  802bb7:	0f 84 64 02 00 00    	je     802e21 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802bbd:	a1 48 50 80 00       	mov    0x805048,%eax
  802bc2:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802bc5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802bc9:	75 17                	jne    802be2 <alloc_block+0x199>
  802bcb:	83 ec 04             	sub    $0x4,%esp
  802bce:	68 c5 45 80 00       	push   $0x8045c5
  802bd3:	68 a0 00 00 00       	push   $0xa0
  802bd8:	68 2b 45 80 00       	push   $0x80452b
  802bdd:	e8 f4 09 00 00       	call   8035d6 <_panic>
  802be2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802be5:	8b 00                	mov    (%eax),%eax
  802be7:	85 c0                	test   %eax,%eax
  802be9:	74 10                	je     802bfb <alloc_block+0x1b2>
  802beb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bee:	8b 00                	mov    (%eax),%eax
  802bf0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bf3:	8b 52 04             	mov    0x4(%edx),%edx
  802bf6:	89 50 04             	mov    %edx,0x4(%eax)
  802bf9:	eb 0b                	jmp    802c06 <alloc_block+0x1bd>
  802bfb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bfe:	8b 40 04             	mov    0x4(%eax),%eax
  802c01:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802c06:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c09:	8b 40 04             	mov    0x4(%eax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	74 0f                	je     802c1f <alloc_block+0x1d6>
  802c10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c13:	8b 40 04             	mov    0x4(%eax),%eax
  802c16:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c19:	8b 12                	mov    (%edx),%edx
  802c1b:	89 10                	mov    %edx,(%eax)
  802c1d:	eb 0a                	jmp    802c29 <alloc_block+0x1e0>
  802c1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	a3 48 50 80 00       	mov    %eax,0x805048
  802c29:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3c:	a1 54 50 80 00       	mov    0x805054,%eax
  802c41:	48                   	dec    %eax
  802c42:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802c47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c4d:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802c51:	b8 00 10 00 00       	mov    $0x1000,%eax
  802c56:	99                   	cltd   
  802c57:	f7 7d e8             	idivl  -0x18(%ebp)
  802c5a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c5d:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802c61:	83 ec 0c             	sub    $0xc,%esp
  802c64:	ff 75 dc             	pushl  -0x24(%ebp)
  802c67:	e8 ce fa ff ff       	call   80273a <to_page_va>
  802c6c:	83 c4 10             	add    $0x10,%esp
  802c6f:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802c72:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c75:	83 ec 0c             	sub    $0xc,%esp
  802c78:	50                   	push   %eax
  802c79:	e8 c0 ee ff ff       	call   801b3e <get_page>
  802c7e:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802c81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c88:	e9 aa 00 00 00       	jmp    802d37 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802c94:	89 c2                	mov    %eax,%edx
  802c96:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c99:	01 d0                	add    %edx,%eax
  802c9b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802c9e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802ca2:	75 17                	jne    802cbb <alloc_block+0x272>
  802ca4:	83 ec 04             	sub    $0x4,%esp
  802ca7:	68 e4 45 80 00       	push   $0x8045e4
  802cac:	68 aa 00 00 00       	push   $0xaa
  802cb1:	68 2b 45 80 00       	push   $0x80452b
  802cb6:	e8 1b 09 00 00       	call   8035d6 <_panic>
  802cbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cbe:	c1 e0 04             	shl    $0x4,%eax
  802cc1:	05 84 d0 81 00       	add    $0x81d084,%eax
  802cc6:	8b 10                	mov    (%eax),%edx
  802cc8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ccb:	89 50 04             	mov    %edx,0x4(%eax)
  802cce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cd1:	8b 40 04             	mov    0x4(%eax),%eax
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	74 14                	je     802cec <alloc_block+0x2a3>
  802cd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cdb:	c1 e0 04             	shl    $0x4,%eax
  802cde:	05 84 d0 81 00       	add    $0x81d084,%eax
  802ce3:	8b 00                	mov    (%eax),%eax
  802ce5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ce8:	89 10                	mov    %edx,(%eax)
  802cea:	eb 11                	jmp    802cfd <alloc_block+0x2b4>
  802cec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cef:	c1 e0 04             	shl    $0x4,%eax
  802cf2:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802cf8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cfb:	89 02                	mov    %eax,(%edx)
  802cfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d00:	c1 e0 04             	shl    $0x4,%eax
  802d03:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802d09:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d0c:	89 02                	mov    %eax,(%edx)
  802d0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d1a:	c1 e0 04             	shl    $0x4,%eax
  802d1d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d22:	8b 00                	mov    (%eax),%eax
  802d24:	8d 50 01             	lea    0x1(%eax),%edx
  802d27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d2a:	c1 e0 04             	shl    $0x4,%eax
  802d2d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d32:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802d34:	ff 45 f4             	incl   -0xc(%ebp)
  802d37:	b8 00 10 00 00       	mov    $0x1000,%eax
  802d3c:	99                   	cltd   
  802d3d:	f7 7d e8             	idivl  -0x18(%ebp)
  802d40:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d43:	0f 8f 44 ff ff ff    	jg     802c8d <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802d49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4c:	c1 e0 04             	shl    $0x4,%eax
  802d4f:	05 80 d0 81 00       	add    $0x81d080,%eax
  802d54:	8b 00                	mov    (%eax),%eax
  802d56:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802d59:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802d5d:	75 17                	jne    802d76 <alloc_block+0x32d>
  802d5f:	83 ec 04             	sub    $0x4,%esp
  802d62:	68 c5 45 80 00       	push   $0x8045c5
  802d67:	68 ae 00 00 00       	push   $0xae
  802d6c:	68 2b 45 80 00       	push   $0x80452b
  802d71:	e8 60 08 00 00       	call   8035d6 <_panic>
  802d76:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d79:	8b 00                	mov    (%eax),%eax
  802d7b:	85 c0                	test   %eax,%eax
  802d7d:	74 10                	je     802d8f <alloc_block+0x346>
  802d7f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d82:	8b 00                	mov    (%eax),%eax
  802d84:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802d87:	8b 52 04             	mov    0x4(%edx),%edx
  802d8a:	89 50 04             	mov    %edx,0x4(%eax)
  802d8d:	eb 14                	jmp    802da3 <alloc_block+0x35a>
  802d8f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d92:	8b 40 04             	mov    0x4(%eax),%eax
  802d95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d98:	c1 e2 04             	shl    $0x4,%edx
  802d9b:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802da1:	89 02                	mov    %eax,(%edx)
  802da3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802da6:	8b 40 04             	mov    0x4(%eax),%eax
  802da9:	85 c0                	test   %eax,%eax
  802dab:	74 0f                	je     802dbc <alloc_block+0x373>
  802dad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802db0:	8b 40 04             	mov    0x4(%eax),%eax
  802db3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802db6:	8b 12                	mov    (%edx),%edx
  802db8:	89 10                	mov    %edx,(%eax)
  802dba:	eb 13                	jmp    802dcf <alloc_block+0x386>
  802dbc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dbf:	8b 00                	mov    (%eax),%eax
  802dc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dc4:	c1 e2 04             	shl    $0x4,%edx
  802dc7:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802dcd:	89 02                	mov    %eax,(%edx)
  802dcf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ddb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de5:	c1 e0 04             	shl    $0x4,%eax
  802de8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	8d 50 ff             	lea    -0x1(%eax),%edx
  802df2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df5:	c1 e0 04             	shl    $0x4,%eax
  802df8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802dfd:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802dff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e02:	83 ec 0c             	sub    $0xc,%esp
  802e05:	50                   	push   %eax
  802e06:	e8 a1 f9 ff ff       	call   8027ac <to_page_info>
  802e0b:	83 c4 10             	add    $0x10,%esp
  802e0e:	89 c2                	mov    %eax,%edx
  802e10:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802e14:	48                   	dec    %eax
  802e15:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802e19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e1c:	e9 1a 01 00 00       	jmp    802f3b <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802e21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e24:	40                   	inc    %eax
  802e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e28:	e9 ed 00 00 00       	jmp    802f1a <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e30:	c1 e0 04             	shl    $0x4,%eax
  802e33:	05 80 d0 81 00       	add    $0x81d080,%eax
  802e38:	8b 00                	mov    (%eax),%eax
  802e3a:	85 c0                	test   %eax,%eax
  802e3c:	0f 84 d5 00 00 00    	je     802f17 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e45:	c1 e0 04             	shl    $0x4,%eax
  802e48:	05 80 d0 81 00       	add    $0x81d080,%eax
  802e4d:	8b 00                	mov    (%eax),%eax
  802e4f:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  802e52:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e56:	75 17                	jne    802e6f <alloc_block+0x426>
  802e58:	83 ec 04             	sub    $0x4,%esp
  802e5b:	68 c5 45 80 00       	push   $0x8045c5
  802e60:	68 b8 00 00 00       	push   $0xb8
  802e65:	68 2b 45 80 00       	push   $0x80452b
  802e6a:	e8 67 07 00 00       	call   8035d6 <_panic>
  802e6f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e72:	8b 00                	mov    (%eax),%eax
  802e74:	85 c0                	test   %eax,%eax
  802e76:	74 10                	je     802e88 <alloc_block+0x43f>
  802e78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e7b:	8b 00                	mov    (%eax),%eax
  802e7d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e80:	8b 52 04             	mov    0x4(%edx),%edx
  802e83:	89 50 04             	mov    %edx,0x4(%eax)
  802e86:	eb 14                	jmp    802e9c <alloc_block+0x453>
  802e88:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e8b:	8b 40 04             	mov    0x4(%eax),%eax
  802e8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e91:	c1 e2 04             	shl    $0x4,%edx
  802e94:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802e9a:	89 02                	mov    %eax,(%edx)
  802e9c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ea2:	85 c0                	test   %eax,%eax
  802ea4:	74 0f                	je     802eb5 <alloc_block+0x46c>
  802ea6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ea9:	8b 40 04             	mov    0x4(%eax),%eax
  802eac:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802eaf:	8b 12                	mov    (%edx),%edx
  802eb1:	89 10                	mov    %edx,(%eax)
  802eb3:	eb 13                	jmp    802ec8 <alloc_block+0x47f>
  802eb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eb8:	8b 00                	mov    (%eax),%eax
  802eba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ebd:	c1 e2 04             	shl    $0x4,%edx
  802ec0:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802ec6:	89 02                	mov    %eax,(%edx)
  802ec8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ecb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ed4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ede:	c1 e0 04             	shl    $0x4,%eax
  802ee1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802ee6:	8b 00                	mov    (%eax),%eax
  802ee8:	8d 50 ff             	lea    -0x1(%eax),%edx
  802eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eee:	c1 e0 04             	shl    $0x4,%eax
  802ef1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802ef6:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  802ef8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802efb:	83 ec 0c             	sub    $0xc,%esp
  802efe:	50                   	push   %eax
  802eff:	e8 a8 f8 ff ff       	call   8027ac <to_page_info>
  802f04:	83 c4 10             	add    $0x10,%esp
  802f07:	89 c2                	mov    %eax,%edx
  802f09:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802f0d:	48                   	dec    %eax
  802f0e:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  802f12:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f15:	eb 24                	jmp    802f3b <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802f17:	ff 45 f0             	incl   -0x10(%ebp)
  802f1a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802f1e:	0f 8e 09 ff ff ff    	jle    802e2d <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  802f24:	83 ec 04             	sub    $0x4,%esp
  802f27:	68 07 46 80 00       	push   $0x804607
  802f2c:	68 bf 00 00 00       	push   $0xbf
  802f31:	68 2b 45 80 00       	push   $0x80452b
  802f36:	e8 9b 06 00 00       	call   8035d6 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  802f3b:	c9                   	leave  
  802f3c:	c3                   	ret    

00802f3d <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  802f3d:	55                   	push   %ebp
  802f3e:	89 e5                	mov    %esp,%ebp
  802f40:	83 ec 14             	sub    $0x14,%esp
  802f43:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  802f46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f4a:	75 07                	jne    802f53 <log2_ceil.1520+0x16>
  802f4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f51:	eb 1b                	jmp    802f6e <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  802f53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  802f5a:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  802f5d:	eb 06                	jmp    802f65 <log2_ceil.1520+0x28>
            x >>= 1;
  802f5f:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  802f62:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  802f65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f69:	75 f4                	jne    802f5f <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  802f6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802f6e:	c9                   	leave  
  802f6f:	c3                   	ret    

00802f70 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  802f70:	55                   	push   %ebp
  802f71:	89 e5                	mov    %esp,%ebp
  802f73:	83 ec 14             	sub    $0x14,%esp
  802f76:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  802f79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f7d:	75 07                	jne    802f86 <log2_ceil.1547+0x16>
  802f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f84:	eb 1b                	jmp    802fa1 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  802f86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  802f8d:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  802f90:	eb 06                	jmp    802f98 <log2_ceil.1547+0x28>
			x >>= 1;
  802f92:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  802f95:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  802f98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f9c:	75 f4                	jne    802f92 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  802f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  802fa1:	c9                   	leave  
  802fa2:	c3                   	ret    

00802fa3 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802fa3:	55                   	push   %ebp
  802fa4:	89 e5                	mov    %esp,%ebp
  802fa6:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fac:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802fb1:	39 c2                	cmp    %eax,%edx
  802fb3:	72 0c                	jb     802fc1 <free_block+0x1e>
  802fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb8:	a1 40 50 80 00       	mov    0x805040,%eax
  802fbd:	39 c2                	cmp    %eax,%edx
  802fbf:	72 19                	jb     802fda <free_block+0x37>
  802fc1:	68 0c 46 80 00       	push   $0x80460c
  802fc6:	68 8e 45 80 00       	push   $0x80458e
  802fcb:	68 d0 00 00 00       	push   $0xd0
  802fd0:	68 2b 45 80 00       	push   $0x80452b
  802fd5:	e8 fc 05 00 00       	call   8035d6 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  802fda:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fde:	0f 84 42 03 00 00    	je     803326 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  802fe4:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe7:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802fec:	39 c2                	cmp    %eax,%edx
  802fee:	72 0c                	jb     802ffc <free_block+0x59>
  802ff0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff3:	a1 40 50 80 00       	mov    0x805040,%eax
  802ff8:	39 c2                	cmp    %eax,%edx
  802ffa:	72 17                	jb     803013 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  802ffc:	83 ec 04             	sub    $0x4,%esp
  802fff:	68 44 46 80 00       	push   $0x804644
  803004:	68 e6 00 00 00       	push   $0xe6
  803009:	68 2b 45 80 00       	push   $0x80452b
  80300e:	e8 c3 05 00 00       	call   8035d6 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  803013:	8b 55 08             	mov    0x8(%ebp),%edx
  803016:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80301b:	29 c2                	sub    %eax,%edx
  80301d:	89 d0                	mov    %edx,%eax
  80301f:	83 e0 07             	and    $0x7,%eax
  803022:	85 c0                	test   %eax,%eax
  803024:	74 17                	je     80303d <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803026:	83 ec 04             	sub    $0x4,%esp
  803029:	68 78 46 80 00       	push   $0x804678
  80302e:	68 ea 00 00 00       	push   $0xea
  803033:	68 2b 45 80 00       	push   $0x80452b
  803038:	e8 99 05 00 00       	call   8035d6 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  80303d:	8b 45 08             	mov    0x8(%ebp),%eax
  803040:	83 ec 0c             	sub    $0xc,%esp
  803043:	50                   	push   %eax
  803044:	e8 63 f7 ff ff       	call   8027ac <to_page_info>
  803049:	83 c4 10             	add    $0x10,%esp
  80304c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  80304f:	83 ec 0c             	sub    $0xc,%esp
  803052:	ff 75 08             	pushl  0x8(%ebp)
  803055:	e8 87 f9 ff ff       	call   8029e1 <get_block_size>
  80305a:	83 c4 10             	add    $0x10,%esp
  80305d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  803060:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803064:	75 17                	jne    80307d <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  803066:	83 ec 04             	sub    $0x4,%esp
  803069:	68 a4 46 80 00       	push   $0x8046a4
  80306e:	68 f1 00 00 00       	push   $0xf1
  803073:	68 2b 45 80 00       	push   $0x80452b
  803078:	e8 59 05 00 00       	call   8035d6 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  80307d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803080:	83 ec 0c             	sub    $0xc,%esp
  803083:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803086:	52                   	push   %edx
  803087:	89 c1                	mov    %eax,%ecx
  803089:	e8 e2 fe ff ff       	call   802f70 <log2_ceil.1547>
  80308e:	83 c4 10             	add    $0x10,%esp
  803091:	83 e8 03             	sub    $0x3,%eax
  803094:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803097:	8b 45 08             	mov    0x8(%ebp),%eax
  80309a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  80309d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030a1:	75 17                	jne    8030ba <free_block+0x117>
  8030a3:	83 ec 04             	sub    $0x4,%esp
  8030a6:	68 f0 46 80 00       	push   $0x8046f0
  8030ab:	68 f6 00 00 00       	push   $0xf6
  8030b0:	68 2b 45 80 00       	push   $0x80452b
  8030b5:	e8 1c 05 00 00       	call   8035d6 <_panic>
  8030ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030bd:	c1 e0 04             	shl    $0x4,%eax
  8030c0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8030c5:	8b 10                	mov    (%eax),%edx
  8030c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ca:	89 10                	mov    %edx,(%eax)
  8030cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030cf:	8b 00                	mov    (%eax),%eax
  8030d1:	85 c0                	test   %eax,%eax
  8030d3:	74 15                	je     8030ea <free_block+0x147>
  8030d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d8:	c1 e0 04             	shl    $0x4,%eax
  8030db:	05 80 d0 81 00       	add    $0x81d080,%eax
  8030e0:	8b 00                	mov    (%eax),%eax
  8030e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030e5:	89 50 04             	mov    %edx,0x4(%eax)
  8030e8:	eb 11                	jmp    8030fb <free_block+0x158>
  8030ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ed:	c1 e0 04             	shl    $0x4,%eax
  8030f0:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  8030f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f9:	89 02                	mov    %eax,(%edx)
  8030fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030fe:	c1 e0 04             	shl    $0x4,%eax
  803101:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803107:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80310a:	89 02                	mov    %eax,(%edx)
  80310c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80310f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803116:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803119:	c1 e0 04             	shl    $0x4,%eax
  80311c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803121:	8b 00                	mov    (%eax),%eax
  803123:	8d 50 01             	lea    0x1(%eax),%edx
  803126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803129:	c1 e0 04             	shl    $0x4,%eax
  80312c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803131:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  803133:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803136:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80313a:	40                   	inc    %eax
  80313b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80313e:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  803142:	8b 55 08             	mov    0x8(%ebp),%edx
  803145:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80314a:	29 c2                	sub    %eax,%edx
  80314c:	89 d0                	mov    %edx,%eax
  80314e:	c1 e8 0c             	shr    $0xc,%eax
  803151:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  803154:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803157:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80315b:	0f b7 c8             	movzwl %ax,%ecx
  80315e:	b8 00 10 00 00       	mov    $0x1000,%eax
  803163:	99                   	cltd   
  803164:	f7 7d e8             	idivl  -0x18(%ebp)
  803167:	39 c1                	cmp    %eax,%ecx
  803169:	0f 85 b8 01 00 00    	jne    803327 <free_block+0x384>
    	uint32 blocks_removed = 0;
  80316f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803176:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803179:	c1 e0 04             	shl    $0x4,%eax
  80317c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803181:	8b 00                	mov    (%eax),%eax
  803183:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803186:	e9 d5 00 00 00       	jmp    803260 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  80318b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318e:	8b 00                	mov    (%eax),%eax
  803190:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803193:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803196:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80319b:	29 c2                	sub    %eax,%edx
  80319d:	89 d0                	mov    %edx,%eax
  80319f:	c1 e8 0c             	shr    $0xc,%eax
  8031a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  8031a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031a8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8031ab:	0f 85 a9 00 00 00    	jne    80325a <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  8031b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031b5:	75 17                	jne    8031ce <free_block+0x22b>
  8031b7:	83 ec 04             	sub    $0x4,%esp
  8031ba:	68 c5 45 80 00       	push   $0x8045c5
  8031bf:	68 04 01 00 00       	push   $0x104
  8031c4:	68 2b 45 80 00       	push   $0x80452b
  8031c9:	e8 08 04 00 00       	call   8035d6 <_panic>
  8031ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d1:	8b 00                	mov    (%eax),%eax
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	74 10                	je     8031e7 <free_block+0x244>
  8031d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031da:	8b 00                	mov    (%eax),%eax
  8031dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031df:	8b 52 04             	mov    0x4(%edx),%edx
  8031e2:	89 50 04             	mov    %edx,0x4(%eax)
  8031e5:	eb 14                	jmp    8031fb <free_block+0x258>
  8031e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ea:	8b 40 04             	mov    0x4(%eax),%eax
  8031ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031f0:	c1 e2 04             	shl    $0x4,%edx
  8031f3:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8031f9:	89 02                	mov    %eax,(%edx)
  8031fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fe:	8b 40 04             	mov    0x4(%eax),%eax
  803201:	85 c0                	test   %eax,%eax
  803203:	74 0f                	je     803214 <free_block+0x271>
  803205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803208:	8b 40 04             	mov    0x4(%eax),%eax
  80320b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80320e:	8b 12                	mov    (%edx),%edx
  803210:	89 10                	mov    %edx,(%eax)
  803212:	eb 13                	jmp    803227 <free_block+0x284>
  803214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803217:	8b 00                	mov    (%eax),%eax
  803219:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80321c:	c1 e2 04             	shl    $0x4,%edx
  80321f:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803225:	89 02                	mov    %eax,(%edx)
  803227:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803233:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323d:	c1 e0 04             	shl    $0x4,%eax
  803240:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803245:	8b 00                	mov    (%eax),%eax
  803247:	8d 50 ff             	lea    -0x1(%eax),%edx
  80324a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324d:	c1 e0 04             	shl    $0x4,%eax
  803250:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803255:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803257:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  80325a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80325d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803260:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803264:	0f 85 21 ff ff ff    	jne    80318b <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  80326a:	b8 00 10 00 00       	mov    $0x1000,%eax
  80326f:	99                   	cltd   
  803270:	f7 7d e8             	idivl  -0x18(%ebp)
  803273:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803276:	74 17                	je     80328f <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803278:	83 ec 04             	sub    $0x4,%esp
  80327b:	68 14 47 80 00       	push   $0x804714
  803280:	68 0c 01 00 00       	push   $0x10c
  803285:	68 2b 45 80 00       	push   $0x80452b
  80328a:	e8 47 03 00 00       	call   8035d6 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  80328f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803292:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803298:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80329b:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8032a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032a5:	75 17                	jne    8032be <free_block+0x31b>
  8032a7:	83 ec 04             	sub    $0x4,%esp
  8032aa:	68 e4 45 80 00       	push   $0x8045e4
  8032af:	68 11 01 00 00       	push   $0x111
  8032b4:	68 2b 45 80 00       	push   $0x80452b
  8032b9:	e8 18 03 00 00       	call   8035d6 <_panic>
  8032be:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8032c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032cd:	8b 40 04             	mov    0x4(%eax),%eax
  8032d0:	85 c0                	test   %eax,%eax
  8032d2:	74 0c                	je     8032e0 <free_block+0x33d>
  8032d4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8032d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032dc:	89 10                	mov    %edx,(%eax)
  8032de:	eb 08                	jmp    8032e8 <free_block+0x345>
  8032e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e3:	a3 48 50 80 00       	mov    %eax,0x805048
  8032e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032eb:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8032f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f9:	a1 54 50 80 00       	mov    0x805054,%eax
  8032fe:	40                   	inc    %eax
  8032ff:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803304:	83 ec 0c             	sub    $0xc,%esp
  803307:	ff 75 ec             	pushl  -0x14(%ebp)
  80330a:	e8 2b f4 ff ff       	call   80273a <to_page_va>
  80330f:	83 c4 10             	add    $0x10,%esp
  803312:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803315:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803318:	83 ec 0c             	sub    $0xc,%esp
  80331b:	50                   	push   %eax
  80331c:	e8 69 e8 ff ff       	call   801b8a <return_page>
  803321:	83 c4 10             	add    $0x10,%esp
  803324:	eb 01                	jmp    803327 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803326:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803327:	c9                   	leave  
  803328:	c3                   	ret    

00803329 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803329:	55                   	push   %ebp
  80332a:	89 e5                	mov    %esp,%ebp
  80332c:	83 ec 14             	sub    $0x14,%esp
  80332f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803332:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803336:	77 07                	ja     80333f <nearest_pow2_ceil.1572+0x16>
      return 1;
  803338:	b8 01 00 00 00       	mov    $0x1,%eax
  80333d:	eb 20                	jmp    80335f <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  80333f:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803346:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803349:	eb 08                	jmp    803353 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  80334b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80334e:	01 c0                	add    %eax,%eax
  803350:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803353:	d1 6d 08             	shrl   0x8(%ebp)
  803356:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80335a:	75 ef                	jne    80334b <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  80335c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  80335f:	c9                   	leave  
  803360:	c3                   	ret    

00803361 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803361:	55                   	push   %ebp
  803362:	89 e5                	mov    %esp,%ebp
  803364:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803367:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80336b:	75 13                	jne    803380 <realloc_block+0x1f>
    return alloc_block(new_size);
  80336d:	83 ec 0c             	sub    $0xc,%esp
  803370:	ff 75 0c             	pushl  0xc(%ebp)
  803373:	e8 d1 f6 ff ff       	call   802a49 <alloc_block>
  803378:	83 c4 10             	add    $0x10,%esp
  80337b:	e9 d9 00 00 00       	jmp    803459 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803380:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803384:	75 18                	jne    80339e <realloc_block+0x3d>
    free_block(va);
  803386:	83 ec 0c             	sub    $0xc,%esp
  803389:	ff 75 08             	pushl  0x8(%ebp)
  80338c:	e8 12 fc ff ff       	call   802fa3 <free_block>
  803391:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803394:	b8 00 00 00 00       	mov    $0x0,%eax
  803399:	e9 bb 00 00 00       	jmp    803459 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  80339e:	83 ec 0c             	sub    $0xc,%esp
  8033a1:	ff 75 08             	pushl  0x8(%ebp)
  8033a4:	e8 38 f6 ff ff       	call   8029e1 <get_block_size>
  8033a9:	83 c4 10             	add    $0x10,%esp
  8033ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8033af:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  8033b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8033bc:	73 06                	jae    8033c4 <realloc_block+0x63>
    new_size = min_block_size;
  8033be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c1:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  8033c4:	83 ec 0c             	sub    $0xc,%esp
  8033c7:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8033ca:	ff 75 0c             	pushl  0xc(%ebp)
  8033cd:	89 c1                	mov    %eax,%ecx
  8033cf:	e8 55 ff ff ff       	call   803329 <nearest_pow2_ceil.1572>
  8033d4:	83 c4 10             	add    $0x10,%esp
  8033d7:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  8033da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033e0:	75 05                	jne    8033e7 <realloc_block+0x86>
    return va;
  8033e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e5:	eb 72                	jmp    803459 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  8033e7:	83 ec 0c             	sub    $0xc,%esp
  8033ea:	ff 75 0c             	pushl  0xc(%ebp)
  8033ed:	e8 57 f6 ff ff       	call   802a49 <alloc_block>
  8033f2:	83 c4 10             	add    $0x10,%esp
  8033f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8033f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033fc:	75 07                	jne    803405 <realloc_block+0xa4>
    return NULL;
  8033fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803403:	eb 54                	jmp    803459 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803405:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80340b:	39 d0                	cmp    %edx,%eax
  80340d:	76 02                	jbe    803411 <realloc_block+0xb0>
  80340f:	89 d0                	mov    %edx,%eax
  803411:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  80341a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803420:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803427:	eb 17                	jmp    803440 <realloc_block+0xdf>
    dst[i] = src[i];
  803429:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80342c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342f:	01 c2                	add    %eax,%edx
  803431:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803437:	01 c8                	add    %ecx,%eax
  803439:	8a 00                	mov    (%eax),%al
  80343b:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  80343d:	ff 45 f4             	incl   -0xc(%ebp)
  803440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803443:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803446:	72 e1                	jb     803429 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803448:	83 ec 0c             	sub    $0xc,%esp
  80344b:	ff 75 08             	pushl  0x8(%ebp)
  80344e:	e8 50 fb ff ff       	call   802fa3 <free_block>
  803453:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803456:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803459:	c9                   	leave  
  80345a:	c3                   	ret    

0080345b <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80345b:	55                   	push   %ebp
  80345c:	89 e5                	mov    %esp,%ebp
  80345e:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  803461:	83 ec 04             	sub    $0x4,%esp
  803464:	68 48 47 80 00       	push   $0x804748
  803469:	6a 07                	push   $0x7
  80346b:	68 77 47 80 00       	push   $0x804777
  803470:	e8 61 01 00 00       	call   8035d6 <_panic>

00803475 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803475:	55                   	push   %ebp
  803476:	89 e5                	mov    %esp,%ebp
  803478:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  80347b:	83 ec 04             	sub    $0x4,%esp
  80347e:	68 88 47 80 00       	push   $0x804788
  803483:	6a 0b                	push   $0xb
  803485:	68 77 47 80 00       	push   $0x804777
  80348a:	e8 47 01 00 00       	call   8035d6 <_panic>

0080348f <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  80348f:	55                   	push   %ebp
  803490:	89 e5                	mov    %esp,%ebp
  803492:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803495:	83 ec 04             	sub    $0x4,%esp
  803498:	68 b4 47 80 00       	push   $0x8047b4
  80349d:	6a 10                	push   $0x10
  80349f:	68 77 47 80 00       	push   $0x804777
  8034a4:	e8 2d 01 00 00       	call   8035d6 <_panic>

008034a9 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8034a9:	55                   	push   %ebp
  8034aa:	89 e5                	mov    %esp,%ebp
  8034ac:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8034af:	83 ec 04             	sub    $0x4,%esp
  8034b2:	68 e4 47 80 00       	push   $0x8047e4
  8034b7:	6a 15                	push   $0x15
  8034b9:	68 77 47 80 00       	push   $0x804777
  8034be:	e8 13 01 00 00       	call   8035d6 <_panic>

008034c3 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8034c3:	55                   	push   %ebp
  8034c4:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8034c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c9:	8b 40 10             	mov    0x10(%eax),%eax
}
  8034cc:	5d                   	pop    %ebp
  8034cd:	c3                   	ret    

008034ce <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  8034ce:	55                   	push   %ebp
  8034cf:	89 e5                	mov    %esp,%ebp
  8034d1:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  8034d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8034d8:	74 1c                	je     8034f6 <init_uspinlock+0x28>
  8034da:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  8034de:	74 16                	je     8034f6 <init_uspinlock+0x28>
  8034e0:	68 14 48 80 00       	push   $0x804814
  8034e5:	68 33 48 80 00       	push   $0x804833
  8034ea:	6a 10                	push   $0x10
  8034ec:	68 48 48 80 00       	push   $0x804848
  8034f1:	e8 e0 00 00 00       	call   8035d6 <_panic>
	strcpy(lk->name, name);
  8034f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f9:	83 c0 04             	add    $0x4,%eax
  8034fc:	83 ec 08             	sub    $0x8,%esp
  8034ff:	ff 75 0c             	pushl  0xc(%ebp)
  803502:	50                   	push   %eax
  803503:	e8 c2 d7 ff ff       	call   800cca <strcpy>
  803508:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  80350b:	b8 01 00 00 00       	mov    $0x1,%eax
  803510:	2b 45 10             	sub    0x10(%ebp),%eax
  803513:	89 c2                	mov    %eax,%edx
  803515:	8b 45 08             	mov    0x8(%ebp),%eax
  803518:	89 10                	mov    %edx,(%eax)
}
  80351a:	90                   	nop
  80351b:	c9                   	leave  
  80351c:	c3                   	ret    

0080351d <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  80351d:	55                   	push   %ebp
  80351e:	89 e5                	mov    %esp,%ebp
  803520:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  803523:	90                   	nop
  803524:	8b 45 08             	mov    0x8(%ebp),%eax
  803527:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80352a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803531:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803534:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803537:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80353a:	f0 87 02             	lock xchg %eax,(%edx)
  80353d:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  803540:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803543:	85 c0                	test   %eax,%eax
  803545:	75 dd                	jne    803524 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803547:	8b 45 08             	mov    0x8(%ebp),%eax
  80354a:	8d 48 04             	lea    0x4(%eax),%ecx
  80354d:	a1 20 50 80 00       	mov    0x805020,%eax
  803552:	8d 50 20             	lea    0x20(%eax),%edx
  803555:	a1 20 50 80 00       	mov    0x805020,%eax
  80355a:	8b 40 10             	mov    0x10(%eax),%eax
  80355d:	51                   	push   %ecx
  80355e:	52                   	push   %edx
  80355f:	50                   	push   %eax
  803560:	68 58 48 80 00       	push   $0x804858
  803565:	e8 38 d0 ff ff       	call   8005a2 <cprintf>
  80356a:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  80356d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  803572:	90                   	nop
  803573:	c9                   	leave  
  803574:	c3                   	ret    

00803575 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  803575:	55                   	push   %ebp
  803576:	89 e5                	mov    %esp,%ebp
  803578:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  80357b:	8b 45 08             	mov    0x8(%ebp),%eax
  80357e:	8b 00                	mov    (%eax),%eax
  803580:	85 c0                	test   %eax,%eax
  803582:	75 18                	jne    80359c <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  803584:	8b 45 08             	mov    0x8(%ebp),%eax
  803587:	83 c0 04             	add    $0x4,%eax
  80358a:	50                   	push   %eax
  80358b:	68 7c 48 80 00       	push   $0x80487c
  803590:	6a 2b                	push   $0x2b
  803592:	68 48 48 80 00       	push   $0x804848
  803597:	e8 3a 00 00 00       	call   8035d6 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  80359c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  8035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8035a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	8d 48 04             	lea    0x4(%eax),%ecx
  8035b3:	a1 20 50 80 00       	mov    0x805020,%eax
  8035b8:	8d 50 20             	lea    0x20(%eax),%edx
  8035bb:	a1 20 50 80 00       	mov    0x805020,%eax
  8035c0:	8b 40 10             	mov    0x10(%eax),%eax
  8035c3:	51                   	push   %ecx
  8035c4:	52                   	push   %edx
  8035c5:	50                   	push   %eax
  8035c6:	68 9c 48 80 00       	push   $0x80489c
  8035cb:	e8 d2 cf ff ff       	call   8005a2 <cprintf>
  8035d0:	83 c4 10             	add    $0x10,%esp
}
  8035d3:	90                   	nop
  8035d4:	c9                   	leave  
  8035d5:	c3                   	ret    

008035d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8035d6:	55                   	push   %ebp
  8035d7:	89 e5                	mov    %esp,%ebp
  8035d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8035dc:	8d 45 10             	lea    0x10(%ebp),%eax
  8035df:	83 c0 04             	add    $0x4,%eax
  8035e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8035e5:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  8035ea:	85 c0                	test   %eax,%eax
  8035ec:	74 16                	je     803604 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8035ee:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  8035f3:	83 ec 08             	sub    $0x8,%esp
  8035f6:	50                   	push   %eax
  8035f7:	68 c0 48 80 00       	push   $0x8048c0
  8035fc:	e8 a1 cf ff ff       	call   8005a2 <cprintf>
  803601:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803604:	a1 04 50 80 00       	mov    0x805004,%eax
  803609:	83 ec 0c             	sub    $0xc,%esp
  80360c:	ff 75 0c             	pushl  0xc(%ebp)
  80360f:	ff 75 08             	pushl  0x8(%ebp)
  803612:	50                   	push   %eax
  803613:	68 c8 48 80 00       	push   $0x8048c8
  803618:	6a 74                	push   $0x74
  80361a:	e8 b0 cf ff ff       	call   8005cf <cprintf_colored>
  80361f:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803622:	8b 45 10             	mov    0x10(%ebp),%eax
  803625:	83 ec 08             	sub    $0x8,%esp
  803628:	ff 75 f4             	pushl  -0xc(%ebp)
  80362b:	50                   	push   %eax
  80362c:	e8 02 cf ff ff       	call   800533 <vcprintf>
  803631:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803634:	83 ec 08             	sub    $0x8,%esp
  803637:	6a 00                	push   $0x0
  803639:	68 f0 48 80 00       	push   $0x8048f0
  80363e:	e8 f0 ce ff ff       	call   800533 <vcprintf>
  803643:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803646:	e8 69 ce ff ff       	call   8004b4 <exit>

	// should not return here
	while (1) ;
  80364b:	eb fe                	jmp    80364b <_panic+0x75>

0080364d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80364d:	55                   	push   %ebp
  80364e:	89 e5                	mov    %esp,%ebp
  803650:	53                   	push   %ebx
  803651:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803654:	a1 20 50 80 00       	mov    0x805020,%eax
  803659:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80365f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803662:	39 c2                	cmp    %eax,%edx
  803664:	74 14                	je     80367a <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803666:	83 ec 04             	sub    $0x4,%esp
  803669:	68 f4 48 80 00       	push   $0x8048f4
  80366e:	6a 26                	push   $0x26
  803670:	68 40 49 80 00       	push   $0x804940
  803675:	e8 5c ff ff ff       	call   8035d6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80367a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803681:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803688:	e9 d9 00 00 00       	jmp    803766 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  80368d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803690:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803697:	8b 45 08             	mov    0x8(%ebp),%eax
  80369a:	01 d0                	add    %edx,%eax
  80369c:	8b 00                	mov    (%eax),%eax
  80369e:	85 c0                	test   %eax,%eax
  8036a0:	75 08                	jne    8036aa <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8036a2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8036a5:	e9 b9 00 00 00       	jmp    803763 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8036aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036b1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8036b8:	eb 79                	jmp    803733 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8036ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8036bf:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8036c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036c8:	89 d0                	mov    %edx,%eax
  8036ca:	01 c0                	add    %eax,%eax
  8036cc:	01 d0                	add    %edx,%eax
  8036ce:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8036d5:	01 d8                	add    %ebx,%eax
  8036d7:	01 d0                	add    %edx,%eax
  8036d9:	01 c8                	add    %ecx,%eax
  8036db:	8a 40 04             	mov    0x4(%eax),%al
  8036de:	84 c0                	test   %al,%al
  8036e0:	75 4e                	jne    803730 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8036e2:	a1 20 50 80 00       	mov    0x805020,%eax
  8036e7:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8036ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036f0:	89 d0                	mov    %edx,%eax
  8036f2:	01 c0                	add    %eax,%eax
  8036f4:	01 d0                	add    %edx,%eax
  8036f6:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8036fd:	01 d8                	add    %ebx,%eax
  8036ff:	01 d0                	add    %edx,%eax
  803701:	01 c8                	add    %ecx,%eax
  803703:	8b 00                	mov    (%eax),%eax
  803705:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803708:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80370b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803710:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803715:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80371c:	8b 45 08             	mov    0x8(%ebp),%eax
  80371f:	01 c8                	add    %ecx,%eax
  803721:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803723:	39 c2                	cmp    %eax,%edx
  803725:	75 09                	jne    803730 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  803727:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80372e:	eb 19                	jmp    803749 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803730:	ff 45 e8             	incl   -0x18(%ebp)
  803733:	a1 20 50 80 00       	mov    0x805020,%eax
  803738:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80373e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803741:	39 c2                	cmp    %eax,%edx
  803743:	0f 87 71 ff ff ff    	ja     8036ba <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803749:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80374d:	75 14                	jne    803763 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80374f:	83 ec 04             	sub    $0x4,%esp
  803752:	68 4c 49 80 00       	push   $0x80494c
  803757:	6a 3a                	push   $0x3a
  803759:	68 40 49 80 00       	push   $0x804940
  80375e:	e8 73 fe ff ff       	call   8035d6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803763:	ff 45 f0             	incl   -0x10(%ebp)
  803766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803769:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80376c:	0f 8c 1b ff ff ff    	jl     80368d <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803772:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803779:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803780:	eb 2e                	jmp    8037b0 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803782:	a1 20 50 80 00       	mov    0x805020,%eax
  803787:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80378d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803790:	89 d0                	mov    %edx,%eax
  803792:	01 c0                	add    %eax,%eax
  803794:	01 d0                	add    %edx,%eax
  803796:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80379d:	01 d8                	add    %ebx,%eax
  80379f:	01 d0                	add    %edx,%eax
  8037a1:	01 c8                	add    %ecx,%eax
  8037a3:	8a 40 04             	mov    0x4(%eax),%al
  8037a6:	3c 01                	cmp    $0x1,%al
  8037a8:	75 03                	jne    8037ad <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8037aa:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037ad:	ff 45 e0             	incl   -0x20(%ebp)
  8037b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8037b5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8037bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037be:	39 c2                	cmp    %eax,%edx
  8037c0:	77 c0                	ja     803782 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8037c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8037c8:	74 14                	je     8037de <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8037ca:	83 ec 04             	sub    $0x4,%esp
  8037cd:	68 a0 49 80 00       	push   $0x8049a0
  8037d2:	6a 44                	push   $0x44
  8037d4:	68 40 49 80 00       	push   $0x804940
  8037d9:	e8 f8 fd ff ff       	call   8035d6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8037de:	90                   	nop
  8037df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8037e2:	c9                   	leave  
  8037e3:	c3                   	ret    

008037e4 <__udivdi3>:
  8037e4:	55                   	push   %ebp
  8037e5:	57                   	push   %edi
  8037e6:	56                   	push   %esi
  8037e7:	53                   	push   %ebx
  8037e8:	83 ec 1c             	sub    $0x1c,%esp
  8037eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037fb:	89 ca                	mov    %ecx,%edx
  8037fd:	89 f8                	mov    %edi,%eax
  8037ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803803:	85 f6                	test   %esi,%esi
  803805:	75 2d                	jne    803834 <__udivdi3+0x50>
  803807:	39 cf                	cmp    %ecx,%edi
  803809:	77 65                	ja     803870 <__udivdi3+0x8c>
  80380b:	89 fd                	mov    %edi,%ebp
  80380d:	85 ff                	test   %edi,%edi
  80380f:	75 0b                	jne    80381c <__udivdi3+0x38>
  803811:	b8 01 00 00 00       	mov    $0x1,%eax
  803816:	31 d2                	xor    %edx,%edx
  803818:	f7 f7                	div    %edi
  80381a:	89 c5                	mov    %eax,%ebp
  80381c:	31 d2                	xor    %edx,%edx
  80381e:	89 c8                	mov    %ecx,%eax
  803820:	f7 f5                	div    %ebp
  803822:	89 c1                	mov    %eax,%ecx
  803824:	89 d8                	mov    %ebx,%eax
  803826:	f7 f5                	div    %ebp
  803828:	89 cf                	mov    %ecx,%edi
  80382a:	89 fa                	mov    %edi,%edx
  80382c:	83 c4 1c             	add    $0x1c,%esp
  80382f:	5b                   	pop    %ebx
  803830:	5e                   	pop    %esi
  803831:	5f                   	pop    %edi
  803832:	5d                   	pop    %ebp
  803833:	c3                   	ret    
  803834:	39 ce                	cmp    %ecx,%esi
  803836:	77 28                	ja     803860 <__udivdi3+0x7c>
  803838:	0f bd fe             	bsr    %esi,%edi
  80383b:	83 f7 1f             	xor    $0x1f,%edi
  80383e:	75 40                	jne    803880 <__udivdi3+0x9c>
  803840:	39 ce                	cmp    %ecx,%esi
  803842:	72 0a                	jb     80384e <__udivdi3+0x6a>
  803844:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803848:	0f 87 9e 00 00 00    	ja     8038ec <__udivdi3+0x108>
  80384e:	b8 01 00 00 00       	mov    $0x1,%eax
  803853:	89 fa                	mov    %edi,%edx
  803855:	83 c4 1c             	add    $0x1c,%esp
  803858:	5b                   	pop    %ebx
  803859:	5e                   	pop    %esi
  80385a:	5f                   	pop    %edi
  80385b:	5d                   	pop    %ebp
  80385c:	c3                   	ret    
  80385d:	8d 76 00             	lea    0x0(%esi),%esi
  803860:	31 ff                	xor    %edi,%edi
  803862:	31 c0                	xor    %eax,%eax
  803864:	89 fa                	mov    %edi,%edx
  803866:	83 c4 1c             	add    $0x1c,%esp
  803869:	5b                   	pop    %ebx
  80386a:	5e                   	pop    %esi
  80386b:	5f                   	pop    %edi
  80386c:	5d                   	pop    %ebp
  80386d:	c3                   	ret    
  80386e:	66 90                	xchg   %ax,%ax
  803870:	89 d8                	mov    %ebx,%eax
  803872:	f7 f7                	div    %edi
  803874:	31 ff                	xor    %edi,%edi
  803876:	89 fa                	mov    %edi,%edx
  803878:	83 c4 1c             	add    $0x1c,%esp
  80387b:	5b                   	pop    %ebx
  80387c:	5e                   	pop    %esi
  80387d:	5f                   	pop    %edi
  80387e:	5d                   	pop    %ebp
  80387f:	c3                   	ret    
  803880:	bd 20 00 00 00       	mov    $0x20,%ebp
  803885:	89 eb                	mov    %ebp,%ebx
  803887:	29 fb                	sub    %edi,%ebx
  803889:	89 f9                	mov    %edi,%ecx
  80388b:	d3 e6                	shl    %cl,%esi
  80388d:	89 c5                	mov    %eax,%ebp
  80388f:	88 d9                	mov    %bl,%cl
  803891:	d3 ed                	shr    %cl,%ebp
  803893:	89 e9                	mov    %ebp,%ecx
  803895:	09 f1                	or     %esi,%ecx
  803897:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80389b:	89 f9                	mov    %edi,%ecx
  80389d:	d3 e0                	shl    %cl,%eax
  80389f:	89 c5                	mov    %eax,%ebp
  8038a1:	89 d6                	mov    %edx,%esi
  8038a3:	88 d9                	mov    %bl,%cl
  8038a5:	d3 ee                	shr    %cl,%esi
  8038a7:	89 f9                	mov    %edi,%ecx
  8038a9:	d3 e2                	shl    %cl,%edx
  8038ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038af:	88 d9                	mov    %bl,%cl
  8038b1:	d3 e8                	shr    %cl,%eax
  8038b3:	09 c2                	or     %eax,%edx
  8038b5:	89 d0                	mov    %edx,%eax
  8038b7:	89 f2                	mov    %esi,%edx
  8038b9:	f7 74 24 0c          	divl   0xc(%esp)
  8038bd:	89 d6                	mov    %edx,%esi
  8038bf:	89 c3                	mov    %eax,%ebx
  8038c1:	f7 e5                	mul    %ebp
  8038c3:	39 d6                	cmp    %edx,%esi
  8038c5:	72 19                	jb     8038e0 <__udivdi3+0xfc>
  8038c7:	74 0b                	je     8038d4 <__udivdi3+0xf0>
  8038c9:	89 d8                	mov    %ebx,%eax
  8038cb:	31 ff                	xor    %edi,%edi
  8038cd:	e9 58 ff ff ff       	jmp    80382a <__udivdi3+0x46>
  8038d2:	66 90                	xchg   %ax,%ax
  8038d4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038d8:	89 f9                	mov    %edi,%ecx
  8038da:	d3 e2                	shl    %cl,%edx
  8038dc:	39 c2                	cmp    %eax,%edx
  8038de:	73 e9                	jae    8038c9 <__udivdi3+0xe5>
  8038e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038e3:	31 ff                	xor    %edi,%edi
  8038e5:	e9 40 ff ff ff       	jmp    80382a <__udivdi3+0x46>
  8038ea:	66 90                	xchg   %ax,%ax
  8038ec:	31 c0                	xor    %eax,%eax
  8038ee:	e9 37 ff ff ff       	jmp    80382a <__udivdi3+0x46>
  8038f3:	90                   	nop

008038f4 <__umoddi3>:
  8038f4:	55                   	push   %ebp
  8038f5:	57                   	push   %edi
  8038f6:	56                   	push   %esi
  8038f7:	53                   	push   %ebx
  8038f8:	83 ec 1c             	sub    $0x1c,%esp
  8038fb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803903:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803907:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80390b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80390f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803913:	89 f3                	mov    %esi,%ebx
  803915:	89 fa                	mov    %edi,%edx
  803917:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80391b:	89 34 24             	mov    %esi,(%esp)
  80391e:	85 c0                	test   %eax,%eax
  803920:	75 1a                	jne    80393c <__umoddi3+0x48>
  803922:	39 f7                	cmp    %esi,%edi
  803924:	0f 86 a2 00 00 00    	jbe    8039cc <__umoddi3+0xd8>
  80392a:	89 c8                	mov    %ecx,%eax
  80392c:	89 f2                	mov    %esi,%edx
  80392e:	f7 f7                	div    %edi
  803930:	89 d0                	mov    %edx,%eax
  803932:	31 d2                	xor    %edx,%edx
  803934:	83 c4 1c             	add    $0x1c,%esp
  803937:	5b                   	pop    %ebx
  803938:	5e                   	pop    %esi
  803939:	5f                   	pop    %edi
  80393a:	5d                   	pop    %ebp
  80393b:	c3                   	ret    
  80393c:	39 f0                	cmp    %esi,%eax
  80393e:	0f 87 ac 00 00 00    	ja     8039f0 <__umoddi3+0xfc>
  803944:	0f bd e8             	bsr    %eax,%ebp
  803947:	83 f5 1f             	xor    $0x1f,%ebp
  80394a:	0f 84 ac 00 00 00    	je     8039fc <__umoddi3+0x108>
  803950:	bf 20 00 00 00       	mov    $0x20,%edi
  803955:	29 ef                	sub    %ebp,%edi
  803957:	89 fe                	mov    %edi,%esi
  803959:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80395d:	89 e9                	mov    %ebp,%ecx
  80395f:	d3 e0                	shl    %cl,%eax
  803961:	89 d7                	mov    %edx,%edi
  803963:	89 f1                	mov    %esi,%ecx
  803965:	d3 ef                	shr    %cl,%edi
  803967:	09 c7                	or     %eax,%edi
  803969:	89 e9                	mov    %ebp,%ecx
  80396b:	d3 e2                	shl    %cl,%edx
  80396d:	89 14 24             	mov    %edx,(%esp)
  803970:	89 d8                	mov    %ebx,%eax
  803972:	d3 e0                	shl    %cl,%eax
  803974:	89 c2                	mov    %eax,%edx
  803976:	8b 44 24 08          	mov    0x8(%esp),%eax
  80397a:	d3 e0                	shl    %cl,%eax
  80397c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803980:	8b 44 24 08          	mov    0x8(%esp),%eax
  803984:	89 f1                	mov    %esi,%ecx
  803986:	d3 e8                	shr    %cl,%eax
  803988:	09 d0                	or     %edx,%eax
  80398a:	d3 eb                	shr    %cl,%ebx
  80398c:	89 da                	mov    %ebx,%edx
  80398e:	f7 f7                	div    %edi
  803990:	89 d3                	mov    %edx,%ebx
  803992:	f7 24 24             	mull   (%esp)
  803995:	89 c6                	mov    %eax,%esi
  803997:	89 d1                	mov    %edx,%ecx
  803999:	39 d3                	cmp    %edx,%ebx
  80399b:	0f 82 87 00 00 00    	jb     803a28 <__umoddi3+0x134>
  8039a1:	0f 84 91 00 00 00    	je     803a38 <__umoddi3+0x144>
  8039a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039ab:	29 f2                	sub    %esi,%edx
  8039ad:	19 cb                	sbb    %ecx,%ebx
  8039af:	89 d8                	mov    %ebx,%eax
  8039b1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039b5:	d3 e0                	shl    %cl,%eax
  8039b7:	89 e9                	mov    %ebp,%ecx
  8039b9:	d3 ea                	shr    %cl,%edx
  8039bb:	09 d0                	or     %edx,%eax
  8039bd:	89 e9                	mov    %ebp,%ecx
  8039bf:	d3 eb                	shr    %cl,%ebx
  8039c1:	89 da                	mov    %ebx,%edx
  8039c3:	83 c4 1c             	add    $0x1c,%esp
  8039c6:	5b                   	pop    %ebx
  8039c7:	5e                   	pop    %esi
  8039c8:	5f                   	pop    %edi
  8039c9:	5d                   	pop    %ebp
  8039ca:	c3                   	ret    
  8039cb:	90                   	nop
  8039cc:	89 fd                	mov    %edi,%ebp
  8039ce:	85 ff                	test   %edi,%edi
  8039d0:	75 0b                	jne    8039dd <__umoddi3+0xe9>
  8039d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8039d7:	31 d2                	xor    %edx,%edx
  8039d9:	f7 f7                	div    %edi
  8039db:	89 c5                	mov    %eax,%ebp
  8039dd:	89 f0                	mov    %esi,%eax
  8039df:	31 d2                	xor    %edx,%edx
  8039e1:	f7 f5                	div    %ebp
  8039e3:	89 c8                	mov    %ecx,%eax
  8039e5:	f7 f5                	div    %ebp
  8039e7:	89 d0                	mov    %edx,%eax
  8039e9:	e9 44 ff ff ff       	jmp    803932 <__umoddi3+0x3e>
  8039ee:	66 90                	xchg   %ax,%ax
  8039f0:	89 c8                	mov    %ecx,%eax
  8039f2:	89 f2                	mov    %esi,%edx
  8039f4:	83 c4 1c             	add    $0x1c,%esp
  8039f7:	5b                   	pop    %ebx
  8039f8:	5e                   	pop    %esi
  8039f9:	5f                   	pop    %edi
  8039fa:	5d                   	pop    %ebp
  8039fb:	c3                   	ret    
  8039fc:	3b 04 24             	cmp    (%esp),%eax
  8039ff:	72 06                	jb     803a07 <__umoddi3+0x113>
  803a01:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a05:	77 0f                	ja     803a16 <__umoddi3+0x122>
  803a07:	89 f2                	mov    %esi,%edx
  803a09:	29 f9                	sub    %edi,%ecx
  803a0b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a0f:	89 14 24             	mov    %edx,(%esp)
  803a12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a16:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a1a:	8b 14 24             	mov    (%esp),%edx
  803a1d:	83 c4 1c             	add    $0x1c,%esp
  803a20:	5b                   	pop    %ebx
  803a21:	5e                   	pop    %esi
  803a22:	5f                   	pop    %edi
  803a23:	5d                   	pop    %ebp
  803a24:	c3                   	ret    
  803a25:	8d 76 00             	lea    0x0(%esi),%esi
  803a28:	2b 04 24             	sub    (%esp),%eax
  803a2b:	19 fa                	sbb    %edi,%edx
  803a2d:	89 d1                	mov    %edx,%ecx
  803a2f:	89 c6                	mov    %eax,%esi
  803a31:	e9 71 ff ff ff       	jmp    8039a7 <__umoddi3+0xb3>
  803a36:	66 90                	xchg   %ax,%ax
  803a38:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a3c:	72 ea                	jb     803a28 <__umoddi3+0x134>
  803a3e:	89 d9                	mov    %ebx,%ecx
  803a40:	e9 62 ff ff ff       	jmp    8039a7 <__umoddi3+0xb3>
