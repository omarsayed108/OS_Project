
obj/user/arrayOperations_quicksort:     file format elf32-i386


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
  800031:	e8 22 04 00 00       	call   800458 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <Swap>:
//Functions Declarations
void Swap(int *Elements, int First, int Second);
void PrintElements(int *Elements, int NumOfElements);

void Swap(int *Elements, int First, int Second)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80003e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800041:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800048:	8b 45 08             	mov    0x8(%ebp),%eax
  80004b:	01 d0                	add    %edx,%eax
  80004d:	8b 00                	mov    (%eax),%eax
  80004f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800052:	8b 45 0c             	mov    0xc(%ebp),%eax
  800055:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80005c:	8b 45 08             	mov    0x8(%ebp),%eax
  80005f:	01 c2                	add    %eax,%edx
  800061:	8b 45 10             	mov    0x10(%ebp),%eax
  800064:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80006b:	8b 45 08             	mov    0x8(%ebp),%eax
  80006e:	01 c8                	add    %ecx,%eax
  800070:	8b 00                	mov    (%eax),%eax
  800072:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800074:	8b 45 10             	mov    0x10(%ebp),%eax
  800077:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80007e:	8b 45 08             	mov    0x8(%ebp),%eax
  800081:	01 c2                	add    %eax,%edx
  800083:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800086:	89 02                	mov    %eax,(%edx)
}
  800088:	90                   	nop
  800089:	c9                   	leave  
  80008a:	c3                   	ret    

0080008b <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80008b:	55                   	push   %ebp
  80008c:	89 e5                	mov    %esp,%ebp
  80008e:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800091:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800098:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80009f:	eb 42                	jmp    8000e3 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8000a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a4:	99                   	cltd   
  8000a5:	f7 7d f0             	idivl  -0x10(%ebp)
  8000a8:	89 d0                	mov    %edx,%eax
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	75 10                	jne    8000be <PrintElements+0x33>
			cprintf("\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 20 3a 80 00       	push   $0x803a20
  8000b6:	e8 2d 06 00 00       	call   8006e8 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8000be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	8b 00                	mov    (%eax),%eax
  8000cf:	83 ec 08             	sub    $0x8,%esp
  8000d2:	50                   	push   %eax
  8000d3:	68 22 3a 80 00       	push   $0x803a22
  8000d8:	e8 0b 06 00 00       	call   8006e8 <cprintf>
  8000dd:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8000e0:	ff 45 f4             	incl   -0xc(%ebp)
  8000e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000e6:	48                   	dec    %eax
  8000e7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ea:	7f b5                	jg     8000a1 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8000ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8000f9:	01 d0                	add    %edx,%eax
  8000fb:	8b 00                	mov    (%eax),%eax
  8000fd:	83 ec 08             	sub    $0x8,%esp
  800100:	50                   	push   %eax
  800101:	68 27 3a 80 00       	push   $0x803a27
  800106:	e8 dd 05 00 00       	call   8006e8 <cprintf>
  80010b:	83 c4 10             	add    $0x10,%esp

}
  80010e:	90                   	nop
  80010f:	c9                   	leave  
  800110:	c3                   	ret    

00800111 <_main>:

void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);

void _main(void)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	57                   	push   %edi
  800115:	56                   	push   %esi
  800116:	53                   	push   %ebx
  800117:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
	int32 envID = sys_getenvid();
  80011d:	e8 82 24 00 00       	call   8025a4 <sys_getenvid>
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800125:	e8 ac 24 00 00       	call   8025d6 <sys_getparentenvid>
  80012a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
#endif

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
#if USE_KERN_SEMAPHORE
	char waitCmd1[64] = "__KSem@0@Wait";
  80012d:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800130:	bb b4 3a 80 00       	mov    $0x803ab4,%ebx
  800135:	ba 0e 00 00 00       	mov    $0xe,%edx
  80013a:	89 c7                	mov    %eax,%edi
  80013c:	89 de                	mov    %ebx,%esi
  80013e:	89 d1                	mov    %edx,%ecx
  800140:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800142:	8d 55 9a             	lea    -0x66(%ebp),%edx
  800145:	b9 32 00 00 00       	mov    $0x32,%ecx
  80014a:	b0 00                	mov    $0x0,%al
  80014c:	89 d7                	mov    %edx,%edi
  80014e:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd1, 0);
  800150:	83 ec 08             	sub    $0x8,%esp
  800153:	6a 00                	push   $0x0
  800155:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800158:	50                   	push   %eax
  800159:	e8 95 26 00 00       	call   8027f3 <sys_utilities>
  80015e:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(ready);
#endif

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  800161:	83 ec 08             	sub    $0x8,%esp
  800164:	68 2b 3a 80 00       	push   $0x803a2b
  800169:	ff 75 dc             	pushl  -0x24(%ebp)
  80016c:	e8 c2 1f 00 00       	call   802133 <sget>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 d8             	mov    %eax,-0x28(%ebp)
#else
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
#endif

	//Get the shared array & its size
	int *numOfElements = NULL;
  800177:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	int *sharedArray = NULL;
  80017e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	68 3e 3a 80 00       	push   $0x803a3e
  80018d:	ff 75 dc             	pushl  -0x24(%ebp)
  800190:	e8 9e 1f 00 00       	call   802133 <sget>
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	89 45 d0             	mov    %eax,-0x30(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	68 42 3a 80 00       	push   $0x803a42
  8001a3:	ff 75 dc             	pushl  -0x24(%ebp)
  8001a6:	e8 88 1f 00 00       	call   802133 <sget>
  8001ab:	83 c4 10             	add    $0x10,%esp
  8001ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
  8001b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001b4:	8b 00                	mov    (%eax),%eax
  8001b6:	c1 e0 02             	shl    $0x2,%eax
  8001b9:	83 ec 04             	sub    $0x4,%esp
  8001bc:	6a 00                	push   $0x0
  8001be:	50                   	push   %eax
  8001bf:	68 4a 3a 80 00       	push   $0x803a4a
  8001c4:	e8 0a 1e 00 00       	call   801fd3 <smalloc>
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8001cf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001d6:	eb 25                	jmp    8001fd <_main+0xec>
	{
		sortedArray[i] = sharedArray[i];
  8001d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001e5:	01 c2                	add    %eax,%edx
  8001e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ea:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001f4:	01 c8                	add    %ecx,%eax
  8001f6:	8b 00                	mov    (%eax),%eax
  8001f8:	89 02                	mov    %eax,(%edx)
	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8001fa:	ff 45 e4             	incl   -0x1c(%ebp)
  8001fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800200:	8b 00                	mov    (%eax),%eax
  800202:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800205:	7f d1                	jg     8001d8 <_main+0xc7>
	{
		sortedArray[i] = sharedArray[i];
	}
	QuickSort(sortedArray, *numOfElements);
  800207:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80020a:	8b 00                	mov    (%eax),%eax
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	50                   	push   %eax
  800210:	ff 75 cc             	pushl  -0x34(%ebp)
  800213:	e8 f9 00 00 00       	call   800311 <QuickSort>
  800218:	83 c4 10             	add    $0x10,%esp

#if USE_KERN_SEMAPHORE
	char waitCmd2[64] = "__KSem@2@Wait";
  80021b:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800221:	bb f4 3a 80 00       	mov    $0x803af4,%ebx
  800226:	ba 0e 00 00 00       	mov    $0xe,%edx
  80022b:	89 c7                	mov    %eax,%edi
  80022d:	89 de                	mov    %ebx,%esi
  80022f:	89 d1                	mov    %edx,%ecx
  800231:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800233:	8d 95 5a ff ff ff    	lea    -0xa6(%ebp),%edx
  800239:	b9 32 00 00 00       	mov    $0x32,%ecx
  80023e:	b0 00                	mov    $0x0,%al
  800240:	89 d7                	mov    %edx,%edi
  800242:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd2, 0);
  800244:	83 ec 08             	sub    $0x8,%esp
  800247:	6a 00                	push   $0x0
  800249:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80024f:	50                   	push   %eax
  800250:	e8 9e 25 00 00       	call   8027f3 <sys_utilities>
  800255:	83 c4 10             	add    $0x10,%esp
#else
	wait_semaphore(cons_mutex);
#endif
	{
		cprintf("Quick sort is Finished!!!!\n") ;
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	68 59 3a 80 00       	push   $0x803a59
  800260:	e8 83 04 00 00       	call   8006e8 <cprintf>
  800265:	83 c4 10             	add    $0x10,%esp
		cprintf("will notify the master now...\n");
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 78 3a 80 00       	push   $0x803a78
  800270:	e8 73 04 00 00       	call   8006e8 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
		cprintf("Quick sort says GOOD BYE :)\n") ;
  800278:	83 ec 0c             	sub    $0xc,%esp
  80027b:	68 97 3a 80 00       	push   $0x803a97
  800280:	e8 63 04 00 00       	call   8006e8 <cprintf>
  800285:	83 c4 10             	add    $0x10,%esp
	}
#if USE_KERN_SEMAPHORE
	char signalCmd1[64] = "__KSem@2@Signal";
  800288:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
  80028e:	bb 34 3b 80 00       	mov    $0x803b34,%ebx
  800293:	ba 04 00 00 00       	mov    $0x4,%edx
  800298:	89 c7                	mov    %eax,%edi
  80029a:	89 de                	mov    %ebx,%esi
  80029c:	89 d1                	mov    %edx,%ecx
  80029e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8002a0:	8d 95 1c ff ff ff    	lea    -0xe4(%ebp),%edx
  8002a6:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8002ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b0:	89 d7                	mov    %edx,%edi
  8002b2:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd1, 0);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	6a 00                	push   $0x0
  8002b9:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
  8002bf:	50                   	push   %eax
  8002c0:	e8 2e 25 00 00       	call   8027f3 <sys_utilities>
  8002c5:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(cons_mutex);
#endif

	/*[5] DECLARE FINISHING*/
#if USE_KERN_SEMAPHORE
	char signalCmd2[64] = "__KSem@1@Signal";
  8002c8:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  8002ce:	bb 74 3b 80 00       	mov    $0x803b74,%ebx
  8002d3:	ba 04 00 00 00       	mov    $0x4,%edx
  8002d8:	89 c7                	mov    %eax,%edi
  8002da:	89 de                	mov    %ebx,%esi
  8002dc:	89 d1                	mov    %edx,%ecx
  8002de:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8002e0:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  8002e6:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8002eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f0:	89 d7                	mov    %edx,%edi
  8002f2:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd2, 0);
  8002f4:	83 ec 08             	sub    $0x8,%esp
  8002f7:	6a 00                	push   $0x0
  8002f9:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  8002ff:	50                   	push   %eax
  800300:	e8 ee 24 00 00       	call   8027f3 <sys_utilities>
  800305:	83 c4 10             	add    $0x10,%esp
#else
	signal_semaphore(finished);
#endif
}
  800308:	90                   	nop
  800309:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030c:	5b                   	pop    %ebx
  80030d:	5e                   	pop    %esi
  80030e:	5f                   	pop    %edi
  80030f:	5d                   	pop    %ebp
  800310:	c3                   	ret    

00800311 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031a:	48                   	dec    %eax
  80031b:	50                   	push   %eax
  80031c:	6a 00                	push   $0x0
  80031e:	ff 75 0c             	pushl  0xc(%ebp)
  800321:	ff 75 08             	pushl  0x8(%ebp)
  800324:	e8 06 00 00 00       	call   80032f <QSort>
  800329:	83 c4 10             	add    $0x10,%esp
}
  80032c:	90                   	nop
  80032d:	c9                   	leave  
  80032e:	c3                   	ret    

0080032f <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return;
  800335:	8b 45 10             	mov    0x10(%ebp),%eax
  800338:	3b 45 14             	cmp    0x14(%ebp),%eax
  80033b:	0f 8d 14 01 00 00    	jge    800455 <QSort+0x126>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  800341:	0f 31                	rdtsc  
  800343:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800346:	89 55 e0             	mov    %edx,-0x20(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  800349:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80034c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80034f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800352:	89 55 e8             	mov    %edx,-0x18(%ebp)
	int pvtIndex = RANDU(startIndex, finalIndex) ;
  800355:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800358:	8b 55 14             	mov    0x14(%ebp),%edx
  80035b:	2b 55 10             	sub    0x10(%ebp),%edx
  80035e:	89 d1                	mov    %edx,%ecx
  800360:	ba 00 00 00 00       	mov    $0x0,%edx
  800365:	f7 f1                	div    %ecx
  800367:	8b 45 10             	mov    0x10(%ebp),%eax
  80036a:	01 d0                	add    %edx,%eax
  80036c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  80036f:	ff 75 ec             	pushl  -0x14(%ebp)
  800372:	ff 75 10             	pushl  0x10(%ebp)
  800375:	ff 75 08             	pushl  0x8(%ebp)
  800378:	e8 bb fc ff ff       	call   800038 <Swap>
  80037d:	83 c4 0c             	add    $0xc,%esp

	int i = startIndex+1, j = finalIndex;
  800380:	8b 45 10             	mov    0x10(%ebp),%eax
  800383:	40                   	inc    %eax
  800384:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800387:	8b 45 14             	mov    0x14(%ebp),%eax
  80038a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80038d:	eb 7d                	jmp    80040c <QSort+0xdd>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80038f:	ff 45 f4             	incl   -0xc(%ebp)
  800392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800395:	3b 45 14             	cmp    0x14(%ebp),%eax
  800398:	7f 2b                	jg     8003c5 <QSort+0x96>
  80039a:	8b 45 10             	mov    0x10(%ebp),%eax
  80039d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	01 d0                	add    %edx,%eax
  8003a9:	8b 10                	mov    (%eax),%edx
  8003ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ae:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b8:	01 c8                	add    %ecx,%eax
  8003ba:	8b 00                	mov    (%eax),%eax
  8003bc:	39 c2                	cmp    %eax,%edx
  8003be:	7d cf                	jge    80038f <QSort+0x60>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8003c0:	eb 03                	jmp    8003c5 <QSort+0x96>
  8003c2:	ff 4d f0             	decl   -0x10(%ebp)
  8003c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8003cb:	7e 26                	jle    8003f3 <QSort+0xc4>
  8003cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	01 d0                	add    %edx,%eax
  8003dc:	8b 10                	mov    (%eax),%edx
  8003de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003eb:	01 c8                	add    %ecx,%eax
  8003ed:	8b 00                	mov    (%eax),%eax
  8003ef:	39 c2                	cmp    %eax,%edx
  8003f1:	7e cf                	jle    8003c2 <QSort+0x93>

		if (i <= j)
  8003f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003f9:	7f 11                	jg     80040c <QSort+0xdd>
		{
			Swap(Elements, i, j);
  8003fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8003fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800401:	ff 75 08             	pushl  0x8(%ebp)
  800404:	e8 2f fc ff ff       	call   800038 <Swap>
  800409:	83 c4 0c             	add    $0xc,%esp
	int pvtIndex = RANDU(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  80040c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80040f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800412:	0f 8e 7a ff ff ff    	jle    800392 <QSort+0x63>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800418:	ff 75 f0             	pushl  -0x10(%ebp)
  80041b:	ff 75 10             	pushl  0x10(%ebp)
  80041e:	ff 75 08             	pushl  0x8(%ebp)
  800421:	e8 12 fc ff ff       	call   800038 <Swap>
  800426:	83 c4 0c             	add    $0xc,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042c:	48                   	dec    %eax
  80042d:	50                   	push   %eax
  80042e:	ff 75 10             	pushl  0x10(%ebp)
  800431:	ff 75 0c             	pushl  0xc(%ebp)
  800434:	ff 75 08             	pushl  0x8(%ebp)
  800437:	e8 f3 fe ff ff       	call   80032f <QSort>
  80043c:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80043f:	ff 75 14             	pushl  0x14(%ebp)
  800442:	ff 75 f4             	pushl  -0xc(%ebp)
  800445:	ff 75 0c             	pushl  0xc(%ebp)
  800448:	ff 75 08             	pushl  0x8(%ebp)
  80044b:	e8 df fe ff ff       	call   80032f <QSort>
  800450:	83 c4 10             	add    $0x10,%esp
  800453:	eb 01                	jmp    800456 <QSort+0x127>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800455:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  800456:	c9                   	leave  
  800457:	c3                   	ret    

00800458 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800458:	55                   	push   %ebp
  800459:	89 e5                	mov    %esp,%ebp
  80045b:	57                   	push   %edi
  80045c:	56                   	push   %esi
  80045d:	53                   	push   %ebx
  80045e:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800461:	e8 57 21 00 00       	call   8025bd <sys_getenvindex>
  800466:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800469:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80046c:	89 d0                	mov    %edx,%eax
  80046e:	01 c0                	add    %eax,%eax
  800470:	01 d0                	add    %edx,%eax
  800472:	c1 e0 02             	shl    $0x2,%eax
  800475:	01 d0                	add    %edx,%eax
  800477:	c1 e0 02             	shl    $0x2,%eax
  80047a:	01 d0                	add    %edx,%eax
  80047c:	c1 e0 03             	shl    $0x3,%eax
  80047f:	01 d0                	add    %edx,%eax
  800481:	c1 e0 02             	shl    $0x2,%eax
  800484:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800489:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80048e:	a1 20 50 80 00       	mov    0x805020,%eax
  800493:	8a 40 20             	mov    0x20(%eax),%al
  800496:	84 c0                	test   %al,%al
  800498:	74 0d                	je     8004a7 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80049a:	a1 20 50 80 00       	mov    0x805020,%eax
  80049f:	83 c0 20             	add    $0x20,%eax
  8004a2:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004ab:	7e 0a                	jle    8004b7 <libmain+0x5f>
		binaryname = argv[0];
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	ff 75 0c             	pushl  0xc(%ebp)
  8004bd:	ff 75 08             	pushl  0x8(%ebp)
  8004c0:	e8 4c fc ff ff       	call   800111 <_main>
  8004c5:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8004c8:	a1 00 50 80 00       	mov    0x805000,%eax
  8004cd:	85 c0                	test   %eax,%eax
  8004cf:	0f 84 01 01 00 00    	je     8005d6 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8004d5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8004db:	bb ac 3c 80 00       	mov    $0x803cac,%ebx
  8004e0:	ba 0e 00 00 00       	mov    $0xe,%edx
  8004e5:	89 c7                	mov    %eax,%edi
  8004e7:	89 de                	mov    %ebx,%esi
  8004e9:	89 d1                	mov    %edx,%ecx
  8004eb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8004ed:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8004f0:	b9 56 00 00 00       	mov    $0x56,%ecx
  8004f5:	b0 00                	mov    $0x0,%al
  8004f7:	89 d7                	mov    %edx,%edi
  8004f9:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8004fb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800502:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	50                   	push   %eax
  800509:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80050f:	50                   	push   %eax
  800510:	e8 de 22 00 00       	call   8027f3 <sys_utilities>
  800515:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800518:	e8 27 1e 00 00       	call   802344 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80051d:	83 ec 0c             	sub    $0xc,%esp
  800520:	68 cc 3b 80 00       	push   $0x803bcc
  800525:	e8 be 01 00 00       	call   8006e8 <cprintf>
  80052a:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80052d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800530:	85 c0                	test   %eax,%eax
  800532:	74 18                	je     80054c <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800534:	e8 d8 22 00 00       	call   802811 <sys_get_optimal_num_faults>
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	50                   	push   %eax
  80053d:	68 f4 3b 80 00       	push   $0x803bf4
  800542:	e8 a1 01 00 00       	call   8006e8 <cprintf>
  800547:	83 c4 10             	add    $0x10,%esp
  80054a:	eb 59                	jmp    8005a5 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80054c:	a1 20 50 80 00       	mov    0x805020,%eax
  800551:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800557:	a1 20 50 80 00       	mov    0x805020,%eax
  80055c:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800562:	83 ec 04             	sub    $0x4,%esp
  800565:	52                   	push   %edx
  800566:	50                   	push   %eax
  800567:	68 18 3c 80 00       	push   $0x803c18
  80056c:	e8 77 01 00 00       	call   8006e8 <cprintf>
  800571:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800574:	a1 20 50 80 00       	mov    0x805020,%eax
  800579:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  80057f:	a1 20 50 80 00       	mov    0x805020,%eax
  800584:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80058a:	a1 20 50 80 00       	mov    0x805020,%eax
  80058f:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800595:	51                   	push   %ecx
  800596:	52                   	push   %edx
  800597:	50                   	push   %eax
  800598:	68 40 3c 80 00       	push   $0x803c40
  80059d:	e8 46 01 00 00       	call   8006e8 <cprintf>
  8005a2:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8005a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8005aa:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8005b0:	83 ec 08             	sub    $0x8,%esp
  8005b3:	50                   	push   %eax
  8005b4:	68 98 3c 80 00       	push   $0x803c98
  8005b9:	e8 2a 01 00 00       	call   8006e8 <cprintf>
  8005be:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8005c1:	83 ec 0c             	sub    $0xc,%esp
  8005c4:	68 cc 3b 80 00       	push   $0x803bcc
  8005c9:	e8 1a 01 00 00       	call   8006e8 <cprintf>
  8005ce:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8005d1:	e8 88 1d 00 00       	call   80235e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8005d6:	e8 1f 00 00 00       	call   8005fa <exit>
}
  8005db:	90                   	nop
  8005dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005df:	5b                   	pop    %ebx
  8005e0:	5e                   	pop    %esi
  8005e1:	5f                   	pop    %edi
  8005e2:	5d                   	pop    %ebp
  8005e3:	c3                   	ret    

008005e4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8005e4:	55                   	push   %ebp
  8005e5:	89 e5                	mov    %esp,%ebp
  8005e7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8005ea:	83 ec 0c             	sub    $0xc,%esp
  8005ed:	6a 00                	push   $0x0
  8005ef:	e8 95 1f 00 00       	call   802589 <sys_destroy_env>
  8005f4:	83 c4 10             	add    $0x10,%esp
}
  8005f7:	90                   	nop
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <exit>:

void
exit(void)
{
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800600:	e8 ea 1f 00 00       	call   8025ef <sys_exit_env>
}
  800605:	90                   	nop
  800606:	c9                   	leave  
  800607:	c3                   	ret    

00800608 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800608:	55                   	push   %ebp
  800609:	89 e5                	mov    %esp,%ebp
  80060b:	53                   	push   %ebx
  80060c:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80060f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800612:	8b 00                	mov    (%eax),%eax
  800614:	8d 48 01             	lea    0x1(%eax),%ecx
  800617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061a:	89 0a                	mov    %ecx,(%edx)
  80061c:	8b 55 08             	mov    0x8(%ebp),%edx
  80061f:	88 d1                	mov    %dl,%cl
  800621:	8b 55 0c             	mov    0xc(%ebp),%edx
  800624:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800632:	75 30                	jne    800664 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800634:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  80063a:	a0 44 50 80 00       	mov    0x805044,%al
  80063f:	0f b6 c0             	movzbl %al,%eax
  800642:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800645:	8b 09                	mov    (%ecx),%ecx
  800647:	89 cb                	mov    %ecx,%ebx
  800649:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80064c:	83 c1 08             	add    $0x8,%ecx
  80064f:	52                   	push   %edx
  800650:	50                   	push   %eax
  800651:	53                   	push   %ebx
  800652:	51                   	push   %ecx
  800653:	e8 a8 1c 00 00       	call   802300 <sys_cputs>
  800658:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80065b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800664:	8b 45 0c             	mov    0xc(%ebp),%eax
  800667:	8b 40 04             	mov    0x4(%eax),%eax
  80066a:	8d 50 01             	lea    0x1(%eax),%edx
  80066d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800670:	89 50 04             	mov    %edx,0x4(%eax)
}
  800673:	90                   	nop
  800674:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800677:	c9                   	leave  
  800678:	c3                   	ret    

00800679 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800679:	55                   	push   %ebp
  80067a:	89 e5                	mov    %esp,%ebp
  80067c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800682:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800689:	00 00 00 
	b.cnt = 0;
  80068c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800693:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800696:	ff 75 0c             	pushl  0xc(%ebp)
  800699:	ff 75 08             	pushl  0x8(%ebp)
  80069c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006a2:	50                   	push   %eax
  8006a3:	68 08 06 80 00       	push   $0x800608
  8006a8:	e8 5a 02 00 00       	call   800907 <vprintfmt>
  8006ad:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006b0:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  8006b6:	a0 44 50 80 00       	mov    0x805044,%al
  8006bb:	0f b6 c0             	movzbl %al,%eax
  8006be:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006c4:	52                   	push   %edx
  8006c5:	50                   	push   %eax
  8006c6:	51                   	push   %ecx
  8006c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006cd:	83 c0 08             	add    $0x8,%eax
  8006d0:	50                   	push   %eax
  8006d1:	e8 2a 1c 00 00       	call   802300 <sys_cputs>
  8006d6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006d9:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8006e0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006e6:	c9                   	leave  
  8006e7:	c3                   	ret    

008006e8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ee:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  8006f5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	ff 75 f4             	pushl  -0xc(%ebp)
  800704:	50                   	push   %eax
  800705:	e8 6f ff ff ff       	call   800679 <vcprintf>
  80070a:	83 c4 10             	add    $0x10,%esp
  80070d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800710:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800713:	c9                   	leave  
  800714:	c3                   	ret    

00800715 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800715:	55                   	push   %ebp
  800716:	89 e5                	mov    %esp,%ebp
  800718:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80071b:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	c1 e0 08             	shl    $0x8,%eax
  800728:	a3 18 d1 81 00       	mov    %eax,0x81d118
	va_start(ap, fmt);
  80072d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800730:	83 c0 04             	add    $0x4,%eax
  800733:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800736:	8b 45 0c             	mov    0xc(%ebp),%eax
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	ff 75 f4             	pushl  -0xc(%ebp)
  80073f:	50                   	push   %eax
  800740:	e8 34 ff ff ff       	call   800679 <vcprintf>
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80074b:	c7 05 18 d1 81 00 00 	movl   $0x700,0x81d118
  800752:	07 00 00 

	return cnt;
  800755:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800758:	c9                   	leave  
  800759:	c3                   	ret    

0080075a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80075a:	55                   	push   %ebp
  80075b:	89 e5                	mov    %esp,%ebp
  80075d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800760:	e8 df 1b 00 00       	call   802344 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800765:	8d 45 0c             	lea    0xc(%ebp),%eax
  800768:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 f4             	pushl  -0xc(%ebp)
  800774:	50                   	push   %eax
  800775:	e8 ff fe ff ff       	call   800679 <vcprintf>
  80077a:	83 c4 10             	add    $0x10,%esp
  80077d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800780:	e8 d9 1b 00 00       	call   80235e <sys_unlock_cons>
	return cnt;
  800785:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	53                   	push   %ebx
  80078e:	83 ec 14             	sub    $0x14,%esp
  800791:	8b 45 10             	mov    0x10(%ebp),%eax
  800794:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80079d:	8b 45 18             	mov    0x18(%ebp),%eax
  8007a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007a8:	77 55                	ja     8007ff <printnum+0x75>
  8007aa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ad:	72 05                	jb     8007b4 <printnum+0x2a>
  8007af:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007b2:	77 4b                	ja     8007ff <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007b4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007b7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007ba:	8b 45 18             	mov    0x18(%ebp),%eax
  8007bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c2:	52                   	push   %edx
  8007c3:	50                   	push   %eax
  8007c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007ca:	e8 e1 2f 00 00       	call   8037b0 <__udivdi3>
  8007cf:	83 c4 10             	add    $0x10,%esp
  8007d2:	83 ec 04             	sub    $0x4,%esp
  8007d5:	ff 75 20             	pushl  0x20(%ebp)
  8007d8:	53                   	push   %ebx
  8007d9:	ff 75 18             	pushl  0x18(%ebp)
  8007dc:	52                   	push   %edx
  8007dd:	50                   	push   %eax
  8007de:	ff 75 0c             	pushl  0xc(%ebp)
  8007e1:	ff 75 08             	pushl  0x8(%ebp)
  8007e4:	e8 a1 ff ff ff       	call   80078a <printnum>
  8007e9:	83 c4 20             	add    $0x20,%esp
  8007ec:	eb 1a                	jmp    800808 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	ff 75 20             	pushl  0x20(%ebp)
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	ff d0                	call   *%eax
  8007fc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007ff:	ff 4d 1c             	decl   0x1c(%ebp)
  800802:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800806:	7f e6                	jg     8007ee <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800808:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80080b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800813:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800816:	53                   	push   %ebx
  800817:	51                   	push   %ecx
  800818:	52                   	push   %edx
  800819:	50                   	push   %eax
  80081a:	e8 a1 30 00 00       	call   8038c0 <__umoddi3>
  80081f:	83 c4 10             	add    $0x10,%esp
  800822:	05 34 3f 80 00       	add    $0x803f34,%eax
  800827:	8a 00                	mov    (%eax),%al
  800829:	0f be c0             	movsbl %al,%eax
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	50                   	push   %eax
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	ff d0                	call   *%eax
  800838:	83 c4 10             	add    $0x10,%esp
}
  80083b:	90                   	nop
  80083c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80083f:	c9                   	leave  
  800840:	c3                   	ret    

00800841 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800841:	55                   	push   %ebp
  800842:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800844:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800848:	7e 1c                	jle    800866 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	8d 50 08             	lea    0x8(%eax),%edx
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	89 10                	mov    %edx,(%eax)
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	8b 00                	mov    (%eax),%eax
  80085c:	83 e8 08             	sub    $0x8,%eax
  80085f:	8b 50 04             	mov    0x4(%eax),%edx
  800862:	8b 00                	mov    (%eax),%eax
  800864:	eb 40                	jmp    8008a6 <getuint+0x65>
	else if (lflag)
  800866:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80086a:	74 1e                	je     80088a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80086c:	8b 45 08             	mov    0x8(%ebp),%eax
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	8d 50 04             	lea    0x4(%eax),%edx
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	89 10                	mov    %edx,(%eax)
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	8b 00                	mov    (%eax),%eax
  80087e:	83 e8 04             	sub    $0x4,%eax
  800881:	8b 00                	mov    (%eax),%eax
  800883:	ba 00 00 00 00       	mov    $0x0,%edx
  800888:	eb 1c                	jmp    8008a6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	8b 00                	mov    (%eax),%eax
  80088f:	8d 50 04             	lea    0x4(%eax),%edx
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	89 10                	mov    %edx,(%eax)
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	8b 00                	mov    (%eax),%eax
  80089c:	83 e8 04             	sub    $0x4,%eax
  80089f:	8b 00                	mov    (%eax),%eax
  8008a1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ab:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008af:	7e 1c                	jle    8008cd <getint+0x25>
		return va_arg(*ap, long long);
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	8d 50 08             	lea    0x8(%eax),%edx
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	89 10                	mov    %edx,(%eax)
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	83 e8 08             	sub    $0x8,%eax
  8008c6:	8b 50 04             	mov    0x4(%eax),%edx
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	eb 38                	jmp    800905 <getint+0x5d>
	else if (lflag)
  8008cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d1:	74 1a                	je     8008ed <getint+0x45>
		return va_arg(*ap, long);
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	8b 00                	mov    (%eax),%eax
  8008d8:	8d 50 04             	lea    0x4(%eax),%edx
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	89 10                	mov    %edx,(%eax)
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	83 e8 04             	sub    $0x4,%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	99                   	cltd   
  8008eb:	eb 18                	jmp    800905 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	8d 50 04             	lea    0x4(%eax),%edx
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	89 10                	mov    %edx,(%eax)
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	83 e8 04             	sub    $0x4,%eax
  800902:	8b 00                	mov    (%eax),%eax
  800904:	99                   	cltd   
}
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	56                   	push   %esi
  80090b:	53                   	push   %ebx
  80090c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80090f:	eb 17                	jmp    800928 <vprintfmt+0x21>
			if (ch == '\0')
  800911:	85 db                	test   %ebx,%ebx
  800913:	0f 84 c1 03 00 00    	je     800cda <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	53                   	push   %ebx
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	ff d0                	call   *%eax
  800925:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800928:	8b 45 10             	mov    0x10(%ebp),%eax
  80092b:	8d 50 01             	lea    0x1(%eax),%edx
  80092e:	89 55 10             	mov    %edx,0x10(%ebp)
  800931:	8a 00                	mov    (%eax),%al
  800933:	0f b6 d8             	movzbl %al,%ebx
  800936:	83 fb 25             	cmp    $0x25,%ebx
  800939:	75 d6                	jne    800911 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80093b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80093f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800946:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80094d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800954:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80095b:	8b 45 10             	mov    0x10(%ebp),%eax
  80095e:	8d 50 01             	lea    0x1(%eax),%edx
  800961:	89 55 10             	mov    %edx,0x10(%ebp)
  800964:	8a 00                	mov    (%eax),%al
  800966:	0f b6 d8             	movzbl %al,%ebx
  800969:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80096c:	83 f8 5b             	cmp    $0x5b,%eax
  80096f:	0f 87 3d 03 00 00    	ja     800cb2 <vprintfmt+0x3ab>
  800975:	8b 04 85 58 3f 80 00 	mov    0x803f58(,%eax,4),%eax
  80097c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80097e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800982:	eb d7                	jmp    80095b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800984:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800988:	eb d1                	jmp    80095b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80098a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800991:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800994:	89 d0                	mov    %edx,%eax
  800996:	c1 e0 02             	shl    $0x2,%eax
  800999:	01 d0                	add    %edx,%eax
  80099b:	01 c0                	add    %eax,%eax
  80099d:	01 d8                	add    %ebx,%eax
  80099f:	83 e8 30             	sub    $0x30,%eax
  8009a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a8:	8a 00                	mov    (%eax),%al
  8009aa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009ad:	83 fb 2f             	cmp    $0x2f,%ebx
  8009b0:	7e 3e                	jle    8009f0 <vprintfmt+0xe9>
  8009b2:	83 fb 39             	cmp    $0x39,%ebx
  8009b5:	7f 39                	jg     8009f0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ba:	eb d5                	jmp    800991 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bf:	83 c0 04             	add    $0x4,%eax
  8009c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c8:	83 e8 04             	sub    $0x4,%eax
  8009cb:	8b 00                	mov    (%eax),%eax
  8009cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009d0:	eb 1f                	jmp    8009f1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d6:	79 83                	jns    80095b <vprintfmt+0x54>
				width = 0;
  8009d8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009df:	e9 77 ff ff ff       	jmp    80095b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009e4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009eb:	e9 6b ff ff ff       	jmp    80095b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009f0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f5:	0f 89 60 ff ff ff    	jns    80095b <vprintfmt+0x54>
				width = precision, precision = -1;
  8009fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a01:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a08:	e9 4e ff ff ff       	jmp    80095b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a0d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a10:	e9 46 ff ff ff       	jmp    80095b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a15:	8b 45 14             	mov    0x14(%ebp),%eax
  800a18:	83 c0 04             	add    $0x4,%eax
  800a1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a21:	83 e8 04             	sub    $0x4,%eax
  800a24:	8b 00                	mov    (%eax),%eax
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 0c             	pushl  0xc(%ebp)
  800a2c:	50                   	push   %eax
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	ff d0                	call   *%eax
  800a32:	83 c4 10             	add    $0x10,%esp
			break;
  800a35:	e9 9b 02 00 00       	jmp    800cd5 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3d:	83 c0 04             	add    $0x4,%eax
  800a40:	89 45 14             	mov    %eax,0x14(%ebp)
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	83 e8 04             	sub    $0x4,%eax
  800a49:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a4b:	85 db                	test   %ebx,%ebx
  800a4d:	79 02                	jns    800a51 <vprintfmt+0x14a>
				err = -err;
  800a4f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a51:	83 fb 64             	cmp    $0x64,%ebx
  800a54:	7f 0b                	jg     800a61 <vprintfmt+0x15a>
  800a56:	8b 34 9d a0 3d 80 00 	mov    0x803da0(,%ebx,4),%esi
  800a5d:	85 f6                	test   %esi,%esi
  800a5f:	75 19                	jne    800a7a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a61:	53                   	push   %ebx
  800a62:	68 45 3f 80 00       	push   $0x803f45
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	ff 75 08             	pushl  0x8(%ebp)
  800a6d:	e8 70 02 00 00       	call   800ce2 <printfmt>
  800a72:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a75:	e9 5b 02 00 00       	jmp    800cd5 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a7a:	56                   	push   %esi
  800a7b:	68 4e 3f 80 00       	push   $0x803f4e
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	ff 75 08             	pushl  0x8(%ebp)
  800a86:	e8 57 02 00 00       	call   800ce2 <printfmt>
  800a8b:	83 c4 10             	add    $0x10,%esp
			break;
  800a8e:	e9 42 02 00 00       	jmp    800cd5 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a93:	8b 45 14             	mov    0x14(%ebp),%eax
  800a96:	83 c0 04             	add    $0x4,%eax
  800a99:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9f:	83 e8 04             	sub    $0x4,%eax
  800aa2:	8b 30                	mov    (%eax),%esi
  800aa4:	85 f6                	test   %esi,%esi
  800aa6:	75 05                	jne    800aad <vprintfmt+0x1a6>
				p = "(null)";
  800aa8:	be 51 3f 80 00       	mov    $0x803f51,%esi
			if (width > 0 && padc != '-')
  800aad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab1:	7e 6d                	jle    800b20 <vprintfmt+0x219>
  800ab3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ab7:	74 67                	je     800b20 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ab9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800abc:	83 ec 08             	sub    $0x8,%esp
  800abf:	50                   	push   %eax
  800ac0:	56                   	push   %esi
  800ac1:	e8 1e 03 00 00       	call   800de4 <strnlen>
  800ac6:	83 c4 10             	add    $0x10,%esp
  800ac9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800acc:	eb 16                	jmp    800ae4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ace:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	ff 75 0c             	pushl  0xc(%ebp)
  800ad8:	50                   	push   %eax
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	ff d0                	call   *%eax
  800ade:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae1:	ff 4d e4             	decl   -0x1c(%ebp)
  800ae4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae8:	7f e4                	jg     800ace <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aea:	eb 34                	jmp    800b20 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800aec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800af0:	74 1c                	je     800b0e <vprintfmt+0x207>
  800af2:	83 fb 1f             	cmp    $0x1f,%ebx
  800af5:	7e 05                	jle    800afc <vprintfmt+0x1f5>
  800af7:	83 fb 7e             	cmp    $0x7e,%ebx
  800afa:	7e 12                	jle    800b0e <vprintfmt+0x207>
					putch('?', putdat);
  800afc:	83 ec 08             	sub    $0x8,%esp
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	6a 3f                	push   $0x3f
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	ff d0                	call   *%eax
  800b09:	83 c4 10             	add    $0x10,%esp
  800b0c:	eb 0f                	jmp    800b1d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	ff 75 0c             	pushl  0xc(%ebp)
  800b14:	53                   	push   %ebx
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	ff d0                	call   *%eax
  800b1a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b1d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b20:	89 f0                	mov    %esi,%eax
  800b22:	8d 70 01             	lea    0x1(%eax),%esi
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	0f be d8             	movsbl %al,%ebx
  800b2a:	85 db                	test   %ebx,%ebx
  800b2c:	74 24                	je     800b52 <vprintfmt+0x24b>
  800b2e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b32:	78 b8                	js     800aec <vprintfmt+0x1e5>
  800b34:	ff 4d e0             	decl   -0x20(%ebp)
  800b37:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b3b:	79 af                	jns    800aec <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b3d:	eb 13                	jmp    800b52 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	ff 75 0c             	pushl  0xc(%ebp)
  800b45:	6a 20                	push   $0x20
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	ff d0                	call   *%eax
  800b4c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b56:	7f e7                	jg     800b3f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b58:	e9 78 01 00 00       	jmp    800cd5 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 e8             	pushl  -0x18(%ebp)
  800b63:	8d 45 14             	lea    0x14(%ebp),%eax
  800b66:	50                   	push   %eax
  800b67:	e8 3c fd ff ff       	call   8008a8 <getint>
  800b6c:	83 c4 10             	add    $0x10,%esp
  800b6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b72:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b7b:	85 d2                	test   %edx,%edx
  800b7d:	79 23                	jns    800ba2 <vprintfmt+0x29b>
				putch('-', putdat);
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	6a 2d                	push   $0x2d
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	ff d0                	call   *%eax
  800b8c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b95:	f7 d8                	neg    %eax
  800b97:	83 d2 00             	adc    $0x0,%edx
  800b9a:	f7 da                	neg    %edx
  800b9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ba2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ba9:	e9 bc 00 00 00       	jmp    800c6a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bb4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bb7:	50                   	push   %eax
  800bb8:	e8 84 fc ff ff       	call   800841 <getuint>
  800bbd:	83 c4 10             	add    $0x10,%esp
  800bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bc6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bcd:	e9 98 00 00 00       	jmp    800c6a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bd2:	83 ec 08             	sub    $0x8,%esp
  800bd5:	ff 75 0c             	pushl  0xc(%ebp)
  800bd8:	6a 58                	push   $0x58
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	ff d0                	call   *%eax
  800bdf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	6a 58                	push   $0x58
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	ff d0                	call   *%eax
  800bef:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	6a 58                	push   $0x58
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	ff d0                	call   *%eax
  800bff:	83 c4 10             	add    $0x10,%esp
			break;
  800c02:	e9 ce 00 00 00       	jmp    800cd5 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c07:	83 ec 08             	sub    $0x8,%esp
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	6a 30                	push   $0x30
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	ff d0                	call   *%eax
  800c14:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	6a 78                	push   $0x78
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	ff d0                	call   *%eax
  800c24:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c27:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2a:	83 c0 04             	add    $0x4,%eax
  800c2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c30:	8b 45 14             	mov    0x14(%ebp),%eax
  800c33:	83 e8 04             	sub    $0x4,%eax
  800c36:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c42:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c49:	eb 1f                	jmp    800c6a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c51:	8d 45 14             	lea    0x14(%ebp),%eax
  800c54:	50                   	push   %eax
  800c55:	e8 e7 fb ff ff       	call   800841 <getuint>
  800c5a:	83 c4 10             	add    $0x10,%esp
  800c5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c60:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c63:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c6a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c71:	83 ec 04             	sub    $0x4,%esp
  800c74:	52                   	push   %edx
  800c75:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c78:	50                   	push   %eax
  800c79:	ff 75 f4             	pushl  -0xc(%ebp)
  800c7c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	ff 75 08             	pushl  0x8(%ebp)
  800c85:	e8 00 fb ff ff       	call   80078a <printnum>
  800c8a:	83 c4 20             	add    $0x20,%esp
			break;
  800c8d:	eb 46                	jmp    800cd5 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c8f:	83 ec 08             	sub    $0x8,%esp
  800c92:	ff 75 0c             	pushl  0xc(%ebp)
  800c95:	53                   	push   %ebx
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	ff d0                	call   *%eax
  800c9b:	83 c4 10             	add    $0x10,%esp
			break;
  800c9e:	eb 35                	jmp    800cd5 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ca0:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800ca7:	eb 2c                	jmp    800cd5 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ca9:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800cb0:	eb 23                	jmp    800cd5 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cb2:	83 ec 08             	sub    $0x8,%esp
  800cb5:	ff 75 0c             	pushl  0xc(%ebp)
  800cb8:	6a 25                	push   $0x25
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	ff d0                	call   *%eax
  800cbf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc2:	ff 4d 10             	decl   0x10(%ebp)
  800cc5:	eb 03                	jmp    800cca <vprintfmt+0x3c3>
  800cc7:	ff 4d 10             	decl   0x10(%ebp)
  800cca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccd:	48                   	dec    %eax
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	3c 25                	cmp    $0x25,%al
  800cd2:	75 f3                	jne    800cc7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cd4:	90                   	nop
		}
	}
  800cd5:	e9 35 fc ff ff       	jmp    80090f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cda:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cdb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    

00800ce2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ce8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ceb:	83 c0 04             	add    $0x4,%eax
  800cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf7:	50                   	push   %eax
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	ff 75 08             	pushl  0x8(%ebp)
  800cfe:	e8 04 fc ff ff       	call   800907 <vprintfmt>
  800d03:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d06:	90                   	nop
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0f:	8b 40 08             	mov    0x8(%eax),%eax
  800d12:	8d 50 01             	lea    0x1(%eax),%edx
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	8b 10                	mov    (%eax),%edx
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	8b 40 04             	mov    0x4(%eax),%eax
  800d26:	39 c2                	cmp    %eax,%edx
  800d28:	73 12                	jae    800d3c <sprintputch+0x33>
		*b->buf++ = ch;
  800d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2d:	8b 00                	mov    (%eax),%eax
  800d2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d35:	89 0a                	mov    %ecx,(%edx)
  800d37:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3a:	88 10                	mov    %dl,(%eax)
}
  800d3c:	90                   	nop
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	01 d0                	add    %edx,%eax
  800d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d64:	74 06                	je     800d6c <vsnprintf+0x2d>
  800d66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6a:	7f 07                	jg     800d73 <vsnprintf+0x34>
		return -E_INVAL;
  800d6c:	b8 03 00 00 00       	mov    $0x3,%eax
  800d71:	eb 20                	jmp    800d93 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d73:	ff 75 14             	pushl  0x14(%ebp)
  800d76:	ff 75 10             	pushl  0x10(%ebp)
  800d79:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d7c:	50                   	push   %eax
  800d7d:	68 09 0d 80 00       	push   $0x800d09
  800d82:	e8 80 fb ff ff       	call   800907 <vprintfmt>
  800d87:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d8d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d9b:	8d 45 10             	lea    0x10(%ebp),%eax
  800d9e:	83 c0 04             	add    $0x4,%eax
  800da1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800da4:	8b 45 10             	mov    0x10(%ebp),%eax
  800da7:	ff 75 f4             	pushl  -0xc(%ebp)
  800daa:	50                   	push   %eax
  800dab:	ff 75 0c             	pushl  0xc(%ebp)
  800dae:	ff 75 08             	pushl  0x8(%ebp)
  800db1:	e8 89 ff ff ff       	call   800d3f <vsnprintf>
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dbf:	c9                   	leave  
  800dc0:	c3                   	ret    

00800dc1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dce:	eb 06                	jmp    800dd6 <strlen+0x15>
		n++;
  800dd0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd3:	ff 45 08             	incl   0x8(%ebp)
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	84 c0                	test   %al,%al
  800ddd:	75 f1                	jne    800dd0 <strlen+0xf>
		n++;
	return n;
  800ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800df1:	eb 09                	jmp    800dfc <strnlen+0x18>
		n++;
  800df3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df6:	ff 45 08             	incl   0x8(%ebp)
  800df9:	ff 4d 0c             	decl   0xc(%ebp)
  800dfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e00:	74 09                	je     800e0b <strnlen+0x27>
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	84 c0                	test   %al,%al
  800e09:	75 e8                	jne    800df3 <strnlen+0xf>
		n++;
	return n;
  800e0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e0e:	c9                   	leave  
  800e0f:	c3                   	ret    

00800e10 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e1c:	90                   	nop
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8d 50 01             	lea    0x1(%eax),%edx
  800e23:	89 55 08             	mov    %edx,0x8(%ebp)
  800e26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2f:	8a 12                	mov    (%edx),%dl
  800e31:	88 10                	mov    %dl,(%eax)
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	84 c0                	test   %al,%al
  800e37:	75 e4                	jne    800e1d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e39:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    

00800e3e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e51:	eb 1f                	jmp    800e72 <strncpy+0x34>
		*dst++ = *src;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8d 50 01             	lea    0x1(%eax),%edx
  800e59:	89 55 08             	mov    %edx,0x8(%ebp)
  800e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5f:	8a 12                	mov    (%edx),%dl
  800e61:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	84 c0                	test   %al,%al
  800e6a:	74 03                	je     800e6f <strncpy+0x31>
			src++;
  800e6c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e6f:	ff 45 fc             	incl   -0x4(%ebp)
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e75:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e78:	72 d9                	jb     800e53 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e7d:	c9                   	leave  
  800e7e:	c3                   	ret    

00800e7f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8f:	74 30                	je     800ec1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e91:	eb 16                	jmp    800ea9 <strlcpy+0x2a>
			*dst++ = *src++;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8d 50 01             	lea    0x1(%eax),%edx
  800e99:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea5:	8a 12                	mov    (%edx),%dl
  800ea7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ea9:	ff 4d 10             	decl   0x10(%ebp)
  800eac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb0:	74 09                	je     800ebb <strlcpy+0x3c>
  800eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	84 c0                	test   %al,%al
  800eb9:	75 d8                	jne    800e93 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec7:	29 c2                	sub    %eax,%edx
  800ec9:	89 d0                	mov    %edx,%eax
}
  800ecb:	c9                   	leave  
  800ecc:	c3                   	ret    

00800ecd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ed0:	eb 06                	jmp    800ed8 <strcmp+0xb>
		p++, q++;
  800ed2:	ff 45 08             	incl   0x8(%ebp)
  800ed5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	8a 00                	mov    (%eax),%al
  800edd:	84 c0                	test   %al,%al
  800edf:	74 0e                	je     800eef <strcmp+0x22>
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8a 10                	mov    (%eax),%dl
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	38 c2                	cmp    %al,%dl
  800eed:	74 e3                	je     800ed2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	0f b6 d0             	movzbl %al,%edx
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	0f b6 c0             	movzbl %al,%eax
  800eff:	29 c2                	sub    %eax,%edx
  800f01:	89 d0                	mov    %edx,%eax
}
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    

00800f05 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f08:	eb 09                	jmp    800f13 <strncmp+0xe>
		n--, p++, q++;
  800f0a:	ff 4d 10             	decl   0x10(%ebp)
  800f0d:	ff 45 08             	incl   0x8(%ebp)
  800f10:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 17                	je     800f30 <strncmp+0x2b>
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	84 c0                	test   %al,%al
  800f20:	74 0e                	je     800f30 <strncmp+0x2b>
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	8a 10                	mov    (%eax),%dl
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	38 c2                	cmp    %al,%dl
  800f2e:	74 da                	je     800f0a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f34:	75 07                	jne    800f3d <strncmp+0x38>
		return 0;
  800f36:	b8 00 00 00 00       	mov    $0x0,%eax
  800f3b:	eb 14                	jmp    800f51 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	8a 00                	mov    (%eax),%al
  800f42:	0f b6 d0             	movzbl %al,%edx
  800f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	0f b6 c0             	movzbl %al,%eax
  800f4d:	29 c2                	sub    %eax,%edx
  800f4f:	89 d0                	mov    %edx,%eax
}
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 04             	sub    $0x4,%esp
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f5f:	eb 12                	jmp    800f73 <strchr+0x20>
		if (*s == c)
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f69:	75 05                	jne    800f70 <strchr+0x1d>
			return (char *) s;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	eb 11                	jmp    800f81 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f70:	ff 45 08             	incl   0x8(%ebp)
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	84 c0                	test   %al,%al
  800f7a:	75 e5                	jne    800f61 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f81:	c9                   	leave  
  800f82:	c3                   	ret    

00800f83 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 04             	sub    $0x4,%esp
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8f:	eb 0d                	jmp    800f9e <strfind+0x1b>
		if (*s == c)
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f99:	74 0e                	je     800fa9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f9b:	ff 45 08             	incl   0x8(%ebp)
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	84 c0                	test   %al,%al
  800fa5:	75 ea                	jne    800f91 <strfind+0xe>
  800fa7:	eb 01                	jmp    800faa <strfind+0x27>
		if (*s == c)
			break;
  800fa9:	90                   	nop
	return (char *) s;
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fad:	c9                   	leave  
  800fae:	c3                   	ret    

00800faf <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fbb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fbf:	76 63                	jbe    801024 <memset+0x75>
		uint64 data_block = c;
  800fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc4:	99                   	cltd   
  800fc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd1:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fd5:	c1 e0 08             	shl    $0x8,%eax
  800fd8:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fdb:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe4:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800fe8:	c1 e0 10             	shl    $0x10,%eax
  800feb:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fee:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff7:	89 c2                	mov    %eax,%edx
  800ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffe:	09 45 f0             	or     %eax,-0x10(%ebp)
  801001:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801004:	eb 18                	jmp    80101e <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801006:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801009:	8d 41 08             	lea    0x8(%ecx),%eax
  80100c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80100f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801012:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801015:	89 01                	mov    %eax,(%ecx)
  801017:	89 51 04             	mov    %edx,0x4(%ecx)
  80101a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80101e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801022:	77 e2                	ja     801006 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801024:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801028:	74 23                	je     80104d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801030:	eb 0e                	jmp    801040 <memset+0x91>
			*p8++ = (uint8)c;
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801035:	8d 50 01             	lea    0x1(%eax),%edx
  801038:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80103b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	8d 50 ff             	lea    -0x1(%eax),%edx
  801046:	89 55 10             	mov    %edx,0x10(%ebp)
  801049:	85 c0                	test   %eax,%eax
  80104b:	75 e5                	jne    801032 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801064:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801068:	76 24                	jbe    80108e <memcpy+0x3c>
		while(n >= 8){
  80106a:	eb 1c                	jmp    801088 <memcpy+0x36>
			*d64 = *s64;
  80106c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106f:	8b 50 04             	mov    0x4(%eax),%edx
  801072:	8b 00                	mov    (%eax),%eax
  801074:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801077:	89 01                	mov    %eax,(%ecx)
  801079:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80107c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801080:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801084:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801088:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80108c:	77 de                	ja     80106c <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80108e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801092:	74 31                	je     8010c5 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80109a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010a0:	eb 16                	jmp    8010b8 <memcpy+0x66>
			*d8++ = *s8++;
  8010a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a5:	8d 50 01             	lea    0x1(%eax),%edx
  8010a8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b1:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010b4:	8a 12                	mov    (%edx),%dl
  8010b6:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010be:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	75 dd                	jne    8010a2 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c8:	c9                   	leave  
  8010c9:	c3                   	ret    

008010ca <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010e2:	73 50                	jae    801134 <memmove+0x6a>
  8010e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ea:	01 d0                	add    %edx,%eax
  8010ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ef:	76 43                	jbe    801134 <memmove+0x6a>
		s += n;
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fa:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010fd:	eb 10                	jmp    80110f <memmove+0x45>
			*--d = *--s;
  8010ff:	ff 4d f8             	decl   -0x8(%ebp)
  801102:	ff 4d fc             	decl   -0x4(%ebp)
  801105:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801108:	8a 10                	mov    (%eax),%dl
  80110a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80110f:	8b 45 10             	mov    0x10(%ebp),%eax
  801112:	8d 50 ff             	lea    -0x1(%eax),%edx
  801115:	89 55 10             	mov    %edx,0x10(%ebp)
  801118:	85 c0                	test   %eax,%eax
  80111a:	75 e3                	jne    8010ff <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80111c:	eb 23                	jmp    801141 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80111e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801121:	8d 50 01             	lea    0x1(%eax),%edx
  801124:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801127:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80112a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80112d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801130:	8a 12                	mov    (%edx),%dl
  801132:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801134:	8b 45 10             	mov    0x10(%ebp),%eax
  801137:	8d 50 ff             	lea    -0x1(%eax),%edx
  80113a:	89 55 10             	mov    %edx,0x10(%ebp)
  80113d:	85 c0                	test   %eax,%eax
  80113f:	75 dd                	jne    80111e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801158:	eb 2a                	jmp    801184 <memcmp+0x3e>
		if (*s1 != *s2)
  80115a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115d:	8a 10                	mov    (%eax),%dl
  80115f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	38 c2                	cmp    %al,%dl
  801166:	74 16                	je     80117e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801168:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	0f b6 d0             	movzbl %al,%edx
  801170:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	0f b6 c0             	movzbl %al,%eax
  801178:	29 c2                	sub    %eax,%edx
  80117a:	89 d0                	mov    %edx,%eax
  80117c:	eb 18                	jmp    801196 <memcmp+0x50>
		s1++, s2++;
  80117e:	ff 45 fc             	incl   -0x4(%ebp)
  801181:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801184:	8b 45 10             	mov    0x10(%ebp),%eax
  801187:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118a:	89 55 10             	mov    %edx,0x10(%ebp)
  80118d:	85 c0                	test   %eax,%eax
  80118f:	75 c9                	jne    80115a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801191:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801196:	c9                   	leave  
  801197:	c3                   	ret    

00801198 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80119e:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a4:	01 d0                	add    %edx,%eax
  8011a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011a9:	eb 15                	jmp    8011c0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	0f b6 d0             	movzbl %al,%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	0f b6 c0             	movzbl %al,%eax
  8011b9:	39 c2                	cmp    %eax,%edx
  8011bb:	74 0d                	je     8011ca <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011bd:	ff 45 08             	incl   0x8(%ebp)
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011c6:	72 e3                	jb     8011ab <memfind+0x13>
  8011c8:	eb 01                	jmp    8011cb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011ca:	90                   	nop
	return (void *) s;
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011e4:	eb 03                	jmp    8011e9 <strtol+0x19>
		s++;
  8011e6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	3c 20                	cmp    $0x20,%al
  8011f0:	74 f4                	je     8011e6 <strtol+0x16>
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	3c 09                	cmp    $0x9,%al
  8011f9:	74 eb                	je     8011e6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	3c 2b                	cmp    $0x2b,%al
  801202:	75 05                	jne    801209 <strtol+0x39>
		s++;
  801204:	ff 45 08             	incl   0x8(%ebp)
  801207:	eb 13                	jmp    80121c <strtol+0x4c>
	else if (*s == '-')
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	3c 2d                	cmp    $0x2d,%al
  801210:	75 0a                	jne    80121c <strtol+0x4c>
		s++, neg = 1;
  801212:	ff 45 08             	incl   0x8(%ebp)
  801215:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80121c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801220:	74 06                	je     801228 <strtol+0x58>
  801222:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801226:	75 20                	jne    801248 <strtol+0x78>
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 30                	cmp    $0x30,%al
  80122f:	75 17                	jne    801248 <strtol+0x78>
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	40                   	inc    %eax
  801235:	8a 00                	mov    (%eax),%al
  801237:	3c 78                	cmp    $0x78,%al
  801239:	75 0d                	jne    801248 <strtol+0x78>
		s += 2, base = 16;
  80123b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80123f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801246:	eb 28                	jmp    801270 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801248:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80124c:	75 15                	jne    801263 <strtol+0x93>
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	3c 30                	cmp    $0x30,%al
  801255:	75 0c                	jne    801263 <strtol+0x93>
		s++, base = 8;
  801257:	ff 45 08             	incl   0x8(%ebp)
  80125a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801261:	eb 0d                	jmp    801270 <strtol+0xa0>
	else if (base == 0)
  801263:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801267:	75 07                	jne    801270 <strtol+0xa0>
		base = 10;
  801269:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 2f                	cmp    $0x2f,%al
  801277:	7e 19                	jle    801292 <strtol+0xc2>
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	3c 39                	cmp    $0x39,%al
  801280:	7f 10                	jg     801292 <strtol+0xc2>
			dig = *s - '0';
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	0f be c0             	movsbl %al,%eax
  80128a:	83 e8 30             	sub    $0x30,%eax
  80128d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801290:	eb 42                	jmp    8012d4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	3c 60                	cmp    $0x60,%al
  801299:	7e 19                	jle    8012b4 <strtol+0xe4>
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	8a 00                	mov    (%eax),%al
  8012a0:	3c 7a                	cmp    $0x7a,%al
  8012a2:	7f 10                	jg     8012b4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	0f be c0             	movsbl %al,%eax
  8012ac:	83 e8 57             	sub    $0x57,%eax
  8012af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012b2:	eb 20                	jmp    8012d4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	3c 40                	cmp    $0x40,%al
  8012bb:	7e 39                	jle    8012f6 <strtol+0x126>
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	3c 5a                	cmp    $0x5a,%al
  8012c4:	7f 30                	jg     8012f6 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	0f be c0             	movsbl %al,%eax
  8012ce:	83 e8 37             	sub    $0x37,%eax
  8012d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012da:	7d 19                	jge    8012f5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012dc:	ff 45 08             	incl   0x8(%ebp)
  8012df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012e6:	89 c2                	mov    %eax,%edx
  8012e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012eb:	01 d0                	add    %edx,%eax
  8012ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012f0:	e9 7b ff ff ff       	jmp    801270 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012f5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012fa:	74 08                	je     801304 <strtol+0x134>
		*endptr = (char *) s;
  8012fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801302:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801304:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801308:	74 07                	je     801311 <strtol+0x141>
  80130a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130d:	f7 d8                	neg    %eax
  80130f:	eb 03                	jmp    801314 <strtol+0x144>
  801311:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <ltostr>:

void
ltostr(long value, char *str)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80131c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801323:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80132a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80132e:	79 13                	jns    801343 <ltostr+0x2d>
	{
		neg = 1;
  801330:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80133d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801340:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80134b:	99                   	cltd   
  80134c:	f7 f9                	idiv   %ecx
  80134e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801351:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801354:	8d 50 01             	lea    0x1(%eax),%edx
  801357:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80135a:	89 c2                	mov    %eax,%edx
  80135c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135f:	01 d0                	add    %edx,%eax
  801361:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801364:	83 c2 30             	add    $0x30,%edx
  801367:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801369:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80136c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801371:	f7 e9                	imul   %ecx
  801373:	c1 fa 02             	sar    $0x2,%edx
  801376:	89 c8                	mov    %ecx,%eax
  801378:	c1 f8 1f             	sar    $0x1f,%eax
  80137b:	29 c2                	sub    %eax,%edx
  80137d:	89 d0                	mov    %edx,%eax
  80137f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801382:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801386:	75 bb                	jne    801343 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801388:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80138f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801392:	48                   	dec    %eax
  801393:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801396:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80139a:	74 3d                	je     8013d9 <ltostr+0xc3>
		start = 1 ;
  80139c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013a3:	eb 34                	jmp    8013d9 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	01 d0                	add    %edx,%eax
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b8:	01 c2                	add    %eax,%edx
  8013ba:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c0:	01 c8                	add    %ecx,%eax
  8013c2:	8a 00                	mov    (%eax),%al
  8013c4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cc:	01 c2                	add    %eax,%edx
  8013ce:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013d1:	88 02                	mov    %al,(%edx)
		start++ ;
  8013d3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013d6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013df:	7c c4                	jl     8013a5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	01 d0                	add    %edx,%eax
  8013e9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013ec:	90                   	nop
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013f5:	ff 75 08             	pushl  0x8(%ebp)
  8013f8:	e8 c4 f9 ff ff       	call   800dc1 <strlen>
  8013fd:	83 c4 04             	add    $0x4,%esp
  801400:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801403:	ff 75 0c             	pushl  0xc(%ebp)
  801406:	e8 b6 f9 ff ff       	call   800dc1 <strlen>
  80140b:	83 c4 04             	add    $0x4,%esp
  80140e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801411:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141f:	eb 17                	jmp    801438 <strcconcat+0x49>
		final[s] = str1[s] ;
  801421:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801424:	8b 45 10             	mov    0x10(%ebp),%eax
  801427:	01 c2                	add    %eax,%edx
  801429:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	01 c8                	add    %ecx,%eax
  801431:	8a 00                	mov    (%eax),%al
  801433:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801435:	ff 45 fc             	incl   -0x4(%ebp)
  801438:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80143b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80143e:	7c e1                	jl     801421 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801440:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801447:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80144e:	eb 1f                	jmp    80146f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801450:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801453:	8d 50 01             	lea    0x1(%eax),%edx
  801456:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801459:	89 c2                	mov    %eax,%edx
  80145b:	8b 45 10             	mov    0x10(%ebp),%eax
  80145e:	01 c2                	add    %eax,%edx
  801460:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801463:	8b 45 0c             	mov    0xc(%ebp),%eax
  801466:	01 c8                	add    %ecx,%eax
  801468:	8a 00                	mov    (%eax),%al
  80146a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80146c:	ff 45 f8             	incl   -0x8(%ebp)
  80146f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801472:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801475:	7c d9                	jl     801450 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801477:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147a:	8b 45 10             	mov    0x10(%ebp),%eax
  80147d:	01 d0                	add    %edx,%eax
  80147f:	c6 00 00             	movb   $0x0,(%eax)
}
  801482:	90                   	nop
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801488:	8b 45 14             	mov    0x14(%ebp),%eax
  80148b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801491:	8b 45 14             	mov    0x14(%ebp),%eax
  801494:	8b 00                	mov    (%eax),%eax
  801496:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80149d:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a0:	01 d0                	add    %edx,%eax
  8014a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014a8:	eb 0c                	jmp    8014b6 <strsplit+0x31>
			*string++ = 0;
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8d 50 01             	lea    0x1(%eax),%edx
  8014b0:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	8a 00                	mov    (%eax),%al
  8014bb:	84 c0                	test   %al,%al
  8014bd:	74 18                	je     8014d7 <strsplit+0x52>
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	8a 00                	mov    (%eax),%al
  8014c4:	0f be c0             	movsbl %al,%eax
  8014c7:	50                   	push   %eax
  8014c8:	ff 75 0c             	pushl  0xc(%ebp)
  8014cb:	e8 83 fa ff ff       	call   800f53 <strchr>
  8014d0:	83 c4 08             	add    $0x8,%esp
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	75 d3                	jne    8014aa <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	8a 00                	mov    (%eax),%al
  8014dc:	84 c0                	test   %al,%al
  8014de:	74 5a                	je     80153a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e3:	8b 00                	mov    (%eax),%eax
  8014e5:	83 f8 0f             	cmp    $0xf,%eax
  8014e8:	75 07                	jne    8014f1 <strsplit+0x6c>
		{
			return 0;
  8014ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ef:	eb 66                	jmp    801557 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f4:	8b 00                	mov    (%eax),%eax
  8014f6:	8d 48 01             	lea    0x1(%eax),%ecx
  8014f9:	8b 55 14             	mov    0x14(%ebp),%edx
  8014fc:	89 0a                	mov    %ecx,(%edx)
  8014fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801505:	8b 45 10             	mov    0x10(%ebp),%eax
  801508:	01 c2                	add    %eax,%edx
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80150f:	eb 03                	jmp    801514 <strsplit+0x8f>
			string++;
  801511:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	8a 00                	mov    (%eax),%al
  801519:	84 c0                	test   %al,%al
  80151b:	74 8b                	je     8014a8 <strsplit+0x23>
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	0f be c0             	movsbl %al,%eax
  801525:	50                   	push   %eax
  801526:	ff 75 0c             	pushl  0xc(%ebp)
  801529:	e8 25 fa ff ff       	call   800f53 <strchr>
  80152e:	83 c4 08             	add    $0x8,%esp
  801531:	85 c0                	test   %eax,%eax
  801533:	74 dc                	je     801511 <strsplit+0x8c>
			string++;
	}
  801535:	e9 6e ff ff ff       	jmp    8014a8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80153a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80153b:	8b 45 14             	mov    0x14(%ebp),%eax
  80153e:	8b 00                	mov    (%eax),%eax
  801540:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801547:	8b 45 10             	mov    0x10(%ebp),%eax
  80154a:	01 d0                	add    %edx,%eax
  80154c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801552:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
  801562:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801565:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80156c:	eb 4a                	jmp    8015b8 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80156e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	01 c2                	add    %eax,%edx
  801576:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157c:	01 c8                	add    %ecx,%eax
  80157e:	8a 00                	mov    (%eax),%al
  801580:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801582:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801585:	8b 45 0c             	mov    0xc(%ebp),%eax
  801588:	01 d0                	add    %edx,%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	3c 40                	cmp    $0x40,%al
  80158e:	7e 25                	jle    8015b5 <str2lower+0x5c>
  801590:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801593:	8b 45 0c             	mov    0xc(%ebp),%eax
  801596:	01 d0                	add    %edx,%eax
  801598:	8a 00                	mov    (%eax),%al
  80159a:	3c 5a                	cmp    $0x5a,%al
  80159c:	7f 17                	jg     8015b5 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80159e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	01 d0                	add    %edx,%eax
  8015a6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ac:	01 ca                	add    %ecx,%edx
  8015ae:	8a 12                	mov    (%edx),%dl
  8015b0:	83 c2 20             	add    $0x20,%edx
  8015b3:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015b5:	ff 45 fc             	incl   -0x4(%ebp)
  8015b8:	ff 75 0c             	pushl  0xc(%ebp)
  8015bb:	e8 01 f8 ff ff       	call   800dc1 <strlen>
  8015c0:	83 c4 04             	add    $0x4,%esp
  8015c3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015c6:	7f a6                	jg     80156e <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  8015d3:	83 ec 0c             	sub    $0xc,%esp
  8015d6:	6a 10                	push   $0x10
  8015d8:	e8 b2 15 00 00       	call   802b8f <alloc_block>
  8015dd:	83 c4 10             	add    $0x10,%esp
  8015e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  8015e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015e7:	75 14                	jne    8015fd <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	68 c8 40 80 00       	push   $0x8040c8
  8015f1:	6a 14                	push   $0x14
  8015f3:	68 f1 40 80 00       	push   $0x8040f1
  8015f8:	e8 a4 1f 00 00       	call   8035a1 <_panic>

	node->start = start;
  8015fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801600:	8b 55 08             	mov    0x8(%ebp),%edx
  801603:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801605:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801608:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160b:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  80160e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801615:	a1 24 50 80 00       	mov    0x805024,%eax
  80161a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80161d:	eb 18                	jmp    801637 <insert_page_alloc+0x6a>
		if (start < it->start)
  80161f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801622:	8b 00                	mov    (%eax),%eax
  801624:	3b 45 08             	cmp    0x8(%ebp),%eax
  801627:	77 37                	ja     801660 <insert_page_alloc+0x93>
			break;
		prev = it;
  801629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162c:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  80162f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801634:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801637:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80163b:	74 08                	je     801645 <insert_page_alloc+0x78>
  80163d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801640:	8b 40 08             	mov    0x8(%eax),%eax
  801643:	eb 05                	jmp    80164a <insert_page_alloc+0x7d>
  801645:	b8 00 00 00 00       	mov    $0x0,%eax
  80164a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80164f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801654:	85 c0                	test   %eax,%eax
  801656:	75 c7                	jne    80161f <insert_page_alloc+0x52>
  801658:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80165c:	75 c1                	jne    80161f <insert_page_alloc+0x52>
  80165e:	eb 01                	jmp    801661 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801660:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801661:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801665:	75 64                	jne    8016cb <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801667:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80166b:	75 14                	jne    801681 <insert_page_alloc+0xb4>
  80166d:	83 ec 04             	sub    $0x4,%esp
  801670:	68 00 41 80 00       	push   $0x804100
  801675:	6a 21                	push   $0x21
  801677:	68 f1 40 80 00       	push   $0x8040f1
  80167c:	e8 20 1f 00 00       	call   8035a1 <_panic>
  801681:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801687:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168a:	89 50 08             	mov    %edx,0x8(%eax)
  80168d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801690:	8b 40 08             	mov    0x8(%eax),%eax
  801693:	85 c0                	test   %eax,%eax
  801695:	74 0d                	je     8016a4 <insert_page_alloc+0xd7>
  801697:	a1 24 50 80 00       	mov    0x805024,%eax
  80169c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80169f:	89 50 0c             	mov    %edx,0xc(%eax)
  8016a2:	eb 08                	jmp    8016ac <insert_page_alloc+0xdf>
  8016a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a7:	a3 28 50 80 00       	mov    %eax,0x805028
  8016ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016af:	a3 24 50 80 00       	mov    %eax,0x805024
  8016b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8016be:	a1 30 50 80 00       	mov    0x805030,%eax
  8016c3:	40                   	inc    %eax
  8016c4:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  8016c9:	eb 71                	jmp    80173c <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  8016cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016cf:	74 06                	je     8016d7 <insert_page_alloc+0x10a>
  8016d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016d5:	75 14                	jne    8016eb <insert_page_alloc+0x11e>
  8016d7:	83 ec 04             	sub    $0x4,%esp
  8016da:	68 24 41 80 00       	push   $0x804124
  8016df:	6a 23                	push   $0x23
  8016e1:	68 f1 40 80 00       	push   $0x8040f1
  8016e6:	e8 b6 1e 00 00       	call   8035a1 <_panic>
  8016eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ee:	8b 50 08             	mov    0x8(%eax),%edx
  8016f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f4:	89 50 08             	mov    %edx,0x8(%eax)
  8016f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fa:	8b 40 08             	mov    0x8(%eax),%eax
  8016fd:	85 c0                	test   %eax,%eax
  8016ff:	74 0c                	je     80170d <insert_page_alloc+0x140>
  801701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801704:	8b 40 08             	mov    0x8(%eax),%eax
  801707:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80170a:	89 50 0c             	mov    %edx,0xc(%eax)
  80170d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801710:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801713:	89 50 08             	mov    %edx,0x8(%eax)
  801716:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801719:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80171c:	89 50 0c             	mov    %edx,0xc(%eax)
  80171f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801722:	8b 40 08             	mov    0x8(%eax),%eax
  801725:	85 c0                	test   %eax,%eax
  801727:	75 08                	jne    801731 <insert_page_alloc+0x164>
  801729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172c:	a3 28 50 80 00       	mov    %eax,0x805028
  801731:	a1 30 50 80 00       	mov    0x805030,%eax
  801736:	40                   	inc    %eax
  801737:	a3 30 50 80 00       	mov    %eax,0x805030
}
  80173c:	90                   	nop
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801745:	a1 24 50 80 00       	mov    0x805024,%eax
  80174a:	85 c0                	test   %eax,%eax
  80174c:	75 0c                	jne    80175a <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  80174e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801753:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801758:	eb 67                	jmp    8017c1 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  80175a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80175f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801762:	a1 24 50 80 00       	mov    0x805024,%eax
  801767:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80176a:	eb 26                	jmp    801792 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  80176c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176f:	8b 10                	mov    (%eax),%edx
  801771:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801774:	8b 40 04             	mov    0x4(%eax),%eax
  801777:	01 d0                	add    %edx,%eax
  801779:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  80177c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801782:	76 06                	jbe    80178a <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801787:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80178a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80178f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801792:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801796:	74 08                	je     8017a0 <recompute_page_alloc_break+0x61>
  801798:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80179b:	8b 40 08             	mov    0x8(%eax),%eax
  80179e:	eb 05                	jmp    8017a5 <recompute_page_alloc_break+0x66>
  8017a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8017aa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	75 b9                	jne    80176c <recompute_page_alloc_break+0x2d>
  8017b3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017b7:	75 b3                	jne    80176c <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  8017b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017bc:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  8017c9:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8017d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017d6:	01 d0                	add    %edx,%eax
  8017d8:	48                   	dec    %eax
  8017d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8017dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017df:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e4:	f7 75 d8             	divl   -0x28(%ebp)
  8017e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017ea:	29 d0                	sub    %edx,%eax
  8017ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  8017ef:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8017f3:	75 0a                	jne    8017ff <alloc_pages_custom_fit+0x3c>
		return NULL;
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fa:	e9 7e 01 00 00       	jmp    80197d <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  8017ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801806:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  80180a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801811:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801818:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80181d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801820:	a1 24 50 80 00       	mov    0x805024,%eax
  801825:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801828:	eb 69                	jmp    801893 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  80182a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182d:	8b 00                	mov    (%eax),%eax
  80182f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801832:	76 47                	jbe    80187b <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801837:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  80183a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80183d:	8b 00                	mov    (%eax),%eax
  80183f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801842:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801845:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801848:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80184b:	72 2e                	jb     80187b <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  80184d:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801851:	75 14                	jne    801867 <alloc_pages_custom_fit+0xa4>
  801853:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801856:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801859:	75 0c                	jne    801867 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  80185b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80185e:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801861:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801865:	eb 14                	jmp    80187b <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801867:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80186a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80186d:	76 0c                	jbe    80187b <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  80186f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801872:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801875:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801878:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  80187b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80187e:	8b 10                	mov    (%eax),%edx
  801880:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801883:	8b 40 04             	mov    0x4(%eax),%eax
  801886:	01 d0                	add    %edx,%eax
  801888:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  80188b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801890:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801893:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801897:	74 08                	je     8018a1 <alloc_pages_custom_fit+0xde>
  801899:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189c:	8b 40 08             	mov    0x8(%eax),%eax
  80189f:	eb 05                	jmp    8018a6 <alloc_pages_custom_fit+0xe3>
  8018a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8018ab:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	0f 85 72 ff ff ff    	jne    80182a <alloc_pages_custom_fit+0x67>
  8018b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018bc:	0f 85 68 ff ff ff    	jne    80182a <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  8018c2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8018c7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8018ca:	76 47                	jbe    801913 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  8018cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  8018d2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8018d7:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8018da:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  8018dd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018e0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018e3:	72 2e                	jb     801913 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  8018e5:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8018e9:	75 14                	jne    8018ff <alloc_pages_custom_fit+0x13c>
  8018eb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018ee:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018f1:	75 0c                	jne    8018ff <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  8018f3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  8018f9:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8018fd:	eb 14                	jmp    801913 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  8018ff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801902:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801905:	76 0c                	jbe    801913 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801907:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80190a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  80190d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801910:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801913:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  80191a:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80191e:	74 08                	je     801928 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801923:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801926:	eb 40                	jmp    801968 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801928:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80192c:	74 08                	je     801936 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  80192e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801931:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801934:	eb 32                	jmp    801968 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801936:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80193b:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80193e:	89 c2                	mov    %eax,%edx
  801940:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801945:	39 c2                	cmp    %eax,%edx
  801947:	73 07                	jae    801950 <alloc_pages_custom_fit+0x18d>
			return NULL;
  801949:	b8 00 00 00 00       	mov    $0x0,%eax
  80194e:	eb 2d                	jmp    80197d <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801950:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801955:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801958:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80195e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801961:	01 d0                	add    %edx,%eax
  801963:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801968:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80196b:	83 ec 08             	sub    $0x8,%esp
  80196e:	ff 75 d0             	pushl  -0x30(%ebp)
  801971:	50                   	push   %eax
  801972:	e8 56 fc ff ff       	call   8015cd <insert_page_alloc>
  801977:	83 c4 10             	add    $0x10,%esp

	return result;
  80197a:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80198b:	a1 24 50 80 00       	mov    0x805024,%eax
  801990:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801993:	eb 1a                	jmp    8019af <find_allocated_size+0x30>
		if (it->start == va)
  801995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801998:	8b 00                	mov    (%eax),%eax
  80199a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80199d:	75 08                	jne    8019a7 <find_allocated_size+0x28>
			return it->size;
  80199f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a2:	8b 40 04             	mov    0x4(%eax),%eax
  8019a5:	eb 34                	jmp    8019db <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8019a7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8019ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8019af:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019b3:	74 08                	je     8019bd <find_allocated_size+0x3e>
  8019b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019b8:	8b 40 08             	mov    0x8(%eax),%eax
  8019bb:	eb 05                	jmp    8019c2 <find_allocated_size+0x43>
  8019bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8019c7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8019cc:	85 c0                	test   %eax,%eax
  8019ce:	75 c5                	jne    801995 <find_allocated_size+0x16>
  8019d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019d4:	75 bf                	jne    801995 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  8019d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8019e9:	a1 24 50 80 00       	mov    0x805024,%eax
  8019ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019f1:	e9 e1 01 00 00       	jmp    801bd7 <free_pages+0x1fa>
		if (it->start == va) {
  8019f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f9:	8b 00                	mov    (%eax),%eax
  8019fb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8019fe:	0f 85 cb 01 00 00    	jne    801bcf <free_pages+0x1f2>

			uint32 start = it->start;
  801a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a07:	8b 00                	mov    (%eax),%eax
  801a09:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0f:	8b 40 04             	mov    0x4(%eax),%eax
  801a12:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a18:	f7 d0                	not    %eax
  801a1a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a1d:	73 1d                	jae    801a3c <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801a1f:	83 ec 0c             	sub    $0xc,%esp
  801a22:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a25:	ff 75 e8             	pushl  -0x18(%ebp)
  801a28:	68 58 41 80 00       	push   $0x804158
  801a2d:	68 a5 00 00 00       	push   $0xa5
  801a32:	68 f1 40 80 00       	push   $0x8040f1
  801a37:	e8 65 1b 00 00       	call   8035a1 <_panic>
			}

			uint32 start_end = start + size;
  801a3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a42:	01 d0                	add    %edx,%eax
  801a44:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801a47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	79 19                	jns    801a67 <free_pages+0x8a>
  801a4e:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801a55:	77 10                	ja     801a67 <free_pages+0x8a>
  801a57:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801a5e:	77 07                	ja     801a67 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801a60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a63:	85 c0                	test   %eax,%eax
  801a65:	78 2c                	js     801a93 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801a67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a6a:	83 ec 0c             	sub    $0xc,%esp
  801a6d:	68 00 00 00 a0       	push   $0xa0000000
  801a72:	ff 75 e0             	pushl  -0x20(%ebp)
  801a75:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a78:	ff 75 e8             	pushl  -0x18(%ebp)
  801a7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a7e:	50                   	push   %eax
  801a7f:	68 9c 41 80 00       	push   $0x80419c
  801a84:	68 ad 00 00 00       	push   $0xad
  801a89:	68 f1 40 80 00       	push   $0x8040f1
  801a8e:	e8 0e 1b 00 00       	call   8035a1 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801a93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a99:	e9 88 00 00 00       	jmp    801b26 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801a9e:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801aa5:	76 17                	jbe    801abe <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801aa7:	ff 75 f0             	pushl  -0x10(%ebp)
  801aaa:	68 00 42 80 00       	push   $0x804200
  801aaf:	68 b4 00 00 00       	push   $0xb4
  801ab4:	68 f1 40 80 00       	push   $0x8040f1
  801ab9:	e8 e3 1a 00 00       	call   8035a1 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac1:	05 00 10 00 00       	add    $0x1000,%eax
  801ac6:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801acc:	85 c0                	test   %eax,%eax
  801ace:	79 2e                	jns    801afe <free_pages+0x121>
  801ad0:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801ad7:	77 25                	ja     801afe <free_pages+0x121>
  801ad9:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801ae0:	77 1c                	ja     801afe <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801ae2:	83 ec 08             	sub    $0x8,%esp
  801ae5:	68 00 10 00 00       	push   $0x1000
  801aea:	ff 75 f0             	pushl  -0x10(%ebp)
  801aed:	e8 38 0d 00 00       	call   80282a <sys_free_user_mem>
  801af2:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801af5:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801afc:	eb 28                	jmp    801b26 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b01:	68 00 00 00 a0       	push   $0xa0000000
  801b06:	ff 75 dc             	pushl  -0x24(%ebp)
  801b09:	68 00 10 00 00       	push   $0x1000
  801b0e:	ff 75 f0             	pushl  -0x10(%ebp)
  801b11:	50                   	push   %eax
  801b12:	68 40 42 80 00       	push   $0x804240
  801b17:	68 bd 00 00 00       	push   $0xbd
  801b1c:	68 f1 40 80 00       	push   $0x8040f1
  801b21:	e8 7b 1a 00 00       	call   8035a1 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b29:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801b2c:	0f 82 6c ff ff ff    	jb     801a9e <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801b32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b36:	75 17                	jne    801b4f <free_pages+0x172>
  801b38:	83 ec 04             	sub    $0x4,%esp
  801b3b:	68 a2 42 80 00       	push   $0x8042a2
  801b40:	68 c1 00 00 00       	push   $0xc1
  801b45:	68 f1 40 80 00       	push   $0x8040f1
  801b4a:	e8 52 1a 00 00       	call   8035a1 <_panic>
  801b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b52:	8b 40 08             	mov    0x8(%eax),%eax
  801b55:	85 c0                	test   %eax,%eax
  801b57:	74 11                	je     801b6a <free_pages+0x18d>
  801b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5c:	8b 40 08             	mov    0x8(%eax),%eax
  801b5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b62:	8b 52 0c             	mov    0xc(%edx),%edx
  801b65:	89 50 0c             	mov    %edx,0xc(%eax)
  801b68:	eb 0b                	jmp    801b75 <free_pages+0x198>
  801b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6d:	8b 40 0c             	mov    0xc(%eax),%eax
  801b70:	a3 28 50 80 00       	mov    %eax,0x805028
  801b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b78:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	74 11                	je     801b90 <free_pages+0x1b3>
  801b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b82:	8b 40 0c             	mov    0xc(%eax),%eax
  801b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b88:	8b 52 08             	mov    0x8(%edx),%edx
  801b8b:	89 50 08             	mov    %edx,0x8(%eax)
  801b8e:	eb 0b                	jmp    801b9b <free_pages+0x1be>
  801b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b93:	8b 40 08             	mov    0x8(%eax),%eax
  801b96:	a3 24 50 80 00       	mov    %eax,0x805024
  801b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801baf:	a1 30 50 80 00       	mov    0x805030,%eax
  801bb4:	48                   	dec    %eax
  801bb5:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801bba:	83 ec 0c             	sub    $0xc,%esp
  801bbd:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc0:	e8 24 15 00 00       	call   8030e9 <free_block>
  801bc5:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801bc8:	e8 72 fb ff ff       	call   80173f <recompute_page_alloc_break>

			return;
  801bcd:	eb 37                	jmp    801c06 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801bcf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801bd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bdb:	74 08                	je     801be5 <free_pages+0x208>
  801bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be0:	8b 40 08             	mov    0x8(%eax),%eax
  801be3:	eb 05                	jmp    801bea <free_pages+0x20d>
  801be5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801bef:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	0f 85 fa fd ff ff    	jne    8019f6 <free_pages+0x19>
  801bfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c00:	0f 85 f0 fd ff ff    	jne    8019f6 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c10:	5d                   	pop    %ebp
  801c11:	c3                   	ret    

00801c12 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801c18:	a1 08 50 80 00       	mov    0x805008,%eax
  801c1d:	85 c0                	test   %eax,%eax
  801c1f:	74 60                	je     801c81 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801c21:	83 ec 08             	sub    $0x8,%esp
  801c24:	68 00 00 00 82       	push   $0x82000000
  801c29:	68 00 00 00 80       	push   $0x80000000
  801c2e:	e8 0d 0d 00 00       	call   802940 <initialize_dynamic_allocator>
  801c33:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801c36:	e8 f3 0a 00 00       	call   80272e <sys_get_uheap_strategy>
  801c3b:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801c40:	a1 40 50 80 00       	mov    0x805040,%eax
  801c45:	05 00 10 00 00       	add    $0x1000,%eax
  801c4a:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801c4f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c54:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801c59:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801c60:	00 00 00 
  801c63:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801c6a:	00 00 00 
  801c6d:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801c74:	00 00 00 

		__firstTimeFlag = 0;
  801c77:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801c7e:	00 00 00 
	}
}
  801c81:	90                   	nop
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c98:	83 ec 08             	sub    $0x8,%esp
  801c9b:	68 06 04 00 00       	push   $0x406
  801ca0:	50                   	push   %eax
  801ca1:	e8 d2 06 00 00       	call   802378 <__sys_allocate_page>
  801ca6:	83 c4 10             	add    $0x10,%esp
  801ca9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801cac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cb0:	79 17                	jns    801cc9 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801cb2:	83 ec 04             	sub    $0x4,%esp
  801cb5:	68 c0 42 80 00       	push   $0x8042c0
  801cba:	68 ea 00 00 00       	push   $0xea
  801cbf:	68 f1 40 80 00       	push   $0x8040f1
  801cc4:	e8 d8 18 00 00       	call   8035a1 <_panic>
	return 0;
  801cc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cdf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ce4:	83 ec 0c             	sub    $0xc,%esp
  801ce7:	50                   	push   %eax
  801ce8:	e8 d2 06 00 00       	call   8023bf <__sys_unmap_frame>
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801cf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cf7:	79 17                	jns    801d10 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801cf9:	83 ec 04             	sub    $0x4,%esp
  801cfc:	68 fc 42 80 00       	push   $0x8042fc
  801d01:	68 f5 00 00 00       	push   $0xf5
  801d06:	68 f1 40 80 00       	push   $0x8040f1
  801d0b:	e8 91 18 00 00       	call   8035a1 <_panic>
}
  801d10:	90                   	nop
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d19:	e8 f4 fe ff ff       	call   801c12 <uheap_init>
	if (size == 0) return NULL ;
  801d1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d22:	75 0a                	jne    801d2e <malloc+0x1b>
  801d24:	b8 00 00 00 00       	mov    $0x0,%eax
  801d29:	e9 67 01 00 00       	jmp    801e95 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801d2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801d35:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801d3c:	77 16                	ja     801d54 <malloc+0x41>
		result = alloc_block(size);
  801d3e:	83 ec 0c             	sub    $0xc,%esp
  801d41:	ff 75 08             	pushl  0x8(%ebp)
  801d44:	e8 46 0e 00 00       	call   802b8f <alloc_block>
  801d49:	83 c4 10             	add    $0x10,%esp
  801d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d4f:	e9 3e 01 00 00       	jmp    801e92 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801d54:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  801d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d61:	01 d0                	add    %edx,%eax
  801d63:	48                   	dec    %eax
  801d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6f:	f7 75 f0             	divl   -0x10(%ebp)
  801d72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d75:	29 d0                	sub    %edx,%eax
  801d77:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801d7a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d7f:	85 c0                	test   %eax,%eax
  801d81:	75 0a                	jne    801d8d <malloc+0x7a>
			return NULL;
  801d83:	b8 00 00 00 00       	mov    $0x0,%eax
  801d88:	e9 08 01 00 00       	jmp    801e95 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801d8d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801d92:	85 c0                	test   %eax,%eax
  801d94:	74 0f                	je     801da5 <malloc+0x92>
  801d96:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801d9c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801da1:	39 c2                	cmp    %eax,%edx
  801da3:	73 0a                	jae    801daf <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801da5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801daa:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801daf:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801db4:	83 f8 05             	cmp    $0x5,%eax
  801db7:	75 11                	jne    801dca <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801db9:	83 ec 0c             	sub    $0xc,%esp
  801dbc:	ff 75 e8             	pushl  -0x18(%ebp)
  801dbf:	e8 ff f9 ff ff       	call   8017c3 <alloc_pages_custom_fit>
  801dc4:	83 c4 10             	add    $0x10,%esp
  801dc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801dca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dce:	0f 84 be 00 00 00    	je     801e92 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801dda:	83 ec 0c             	sub    $0xc,%esp
  801ddd:	ff 75 f4             	pushl  -0xc(%ebp)
  801de0:	e8 9a fb ff ff       	call   80197f <find_allocated_size>
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801deb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801def:	75 17                	jne    801e08 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801df1:	ff 75 f4             	pushl  -0xc(%ebp)
  801df4:	68 3c 43 80 00       	push   $0x80433c
  801df9:	68 24 01 00 00       	push   $0x124
  801dfe:	68 f1 40 80 00       	push   $0x8040f1
  801e03:	e8 99 17 00 00       	call   8035a1 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801e08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e0b:	f7 d0                	not    %eax
  801e0d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e10:	73 1d                	jae    801e2f <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801e12:	83 ec 0c             	sub    $0xc,%esp
  801e15:	ff 75 e0             	pushl  -0x20(%ebp)
  801e18:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e1b:	68 84 43 80 00       	push   $0x804384
  801e20:	68 29 01 00 00       	push   $0x129
  801e25:	68 f1 40 80 00       	push   $0x8040f1
  801e2a:	e8 72 17 00 00       	call   8035a1 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801e2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e35:	01 d0                	add    %edx,%eax
  801e37:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801e3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	79 2c                	jns    801e6d <malloc+0x15a>
  801e41:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801e48:	77 23                	ja     801e6d <malloc+0x15a>
  801e4a:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801e51:	77 1a                	ja     801e6d <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801e53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e56:	85 c0                	test   %eax,%eax
  801e58:	79 13                	jns    801e6d <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801e5a:	83 ec 08             	sub    $0x8,%esp
  801e5d:	ff 75 e0             	pushl  -0x20(%ebp)
  801e60:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e63:	e8 de 09 00 00       	call   802846 <sys_allocate_user_mem>
  801e68:	83 c4 10             	add    $0x10,%esp
  801e6b:	eb 25                	jmp    801e92 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801e6d:	68 00 00 00 a0       	push   $0xa0000000
  801e72:	ff 75 dc             	pushl  -0x24(%ebp)
  801e75:	ff 75 e0             	pushl  -0x20(%ebp)
  801e78:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7e:	68 c0 43 80 00       	push   $0x8043c0
  801e83:	68 33 01 00 00       	push   $0x133
  801e88:	68 f1 40 80 00       	push   $0x8040f1
  801e8d:	e8 0f 17 00 00       	call   8035a1 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801e9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ea1:	0f 84 26 01 00 00    	je     801fcd <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb0:	85 c0                	test   %eax,%eax
  801eb2:	79 1c                	jns    801ed0 <free+0x39>
  801eb4:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801ebb:	77 13                	ja     801ed0 <free+0x39>
		free_block(virtual_address);
  801ebd:	83 ec 0c             	sub    $0xc,%esp
  801ec0:	ff 75 08             	pushl  0x8(%ebp)
  801ec3:	e8 21 12 00 00       	call   8030e9 <free_block>
  801ec8:	83 c4 10             	add    $0x10,%esp
		return;
  801ecb:	e9 01 01 00 00       	jmp    801fd1 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801ed0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ed5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801ed8:	0f 82 d8 00 00 00    	jb     801fb6 <free+0x11f>
  801ede:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801ee5:	0f 87 cb 00 00 00    	ja     801fb6 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eee:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	74 17                	je     801f0e <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801ef7:	ff 75 08             	pushl  0x8(%ebp)
  801efa:	68 30 44 80 00       	push   $0x804430
  801eff:	68 57 01 00 00       	push   $0x157
  801f04:	68 f1 40 80 00       	push   $0x8040f1
  801f09:	e8 93 16 00 00       	call   8035a1 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801f0e:	83 ec 0c             	sub    $0xc,%esp
  801f11:	ff 75 08             	pushl  0x8(%ebp)
  801f14:	e8 66 fa ff ff       	call   80197f <find_allocated_size>
  801f19:	83 c4 10             	add    $0x10,%esp
  801f1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801f1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f23:	0f 84 a7 00 00 00    	je     801fd0 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2c:	f7 d0                	not    %eax
  801f2e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f31:	73 1d                	jae    801f50 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801f33:	83 ec 0c             	sub    $0xc,%esp
  801f36:	ff 75 f0             	pushl  -0x10(%ebp)
  801f39:	ff 75 f4             	pushl  -0xc(%ebp)
  801f3c:	68 58 44 80 00       	push   $0x804458
  801f41:	68 61 01 00 00       	push   $0x161
  801f46:	68 f1 40 80 00       	push   $0x8040f1
  801f4b:	e8 51 16 00 00       	call   8035a1 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801f50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f56:	01 d0                	add    %edx,%eax
  801f58:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	79 19                	jns    801f7b <free+0xe4>
  801f62:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801f69:	77 10                	ja     801f7b <free+0xe4>
  801f6b:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801f72:	77 07                	ja     801f7b <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801f74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f77:	85 c0                	test   %eax,%eax
  801f79:	78 2b                	js     801fa6 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801f7b:	83 ec 0c             	sub    $0xc,%esp
  801f7e:	68 00 00 00 a0       	push   $0xa0000000
  801f83:	ff 75 ec             	pushl  -0x14(%ebp)
  801f86:	ff 75 f0             	pushl  -0x10(%ebp)
  801f89:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f8f:	ff 75 08             	pushl  0x8(%ebp)
  801f92:	68 94 44 80 00       	push   $0x804494
  801f97:	68 69 01 00 00       	push   $0x169
  801f9c:	68 f1 40 80 00       	push   $0x8040f1
  801fa1:	e8 fb 15 00 00       	call   8035a1 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  801fa6:	83 ec 0c             	sub    $0xc,%esp
  801fa9:	ff 75 08             	pushl  0x8(%ebp)
  801fac:	e8 2c fa ff ff       	call   8019dd <free_pages>
  801fb1:	83 c4 10             	add    $0x10,%esp
		return;
  801fb4:	eb 1b                	jmp    801fd1 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  801fb6:	ff 75 08             	pushl  0x8(%ebp)
  801fb9:	68 f0 44 80 00       	push   $0x8044f0
  801fbe:	68 70 01 00 00       	push   $0x170
  801fc3:	68 f1 40 80 00       	push   $0x8040f1
  801fc8:	e8 d4 15 00 00       	call   8035a1 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801fcd:	90                   	nop
  801fce:	eb 01                	jmp    801fd1 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  801fd0:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 38             	sub    $0x38,%esp
  801fd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdc:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801fdf:	e8 2e fc ff ff       	call   801c12 <uheap_init>
	if (size == 0) return NULL ;
  801fe4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fe8:	75 0a                	jne    801ff4 <smalloc+0x21>
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
  801fef:	e9 3d 01 00 00       	jmp    802131 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  801ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  801ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffd:	25 ff 0f 00 00       	and    $0xfff,%eax
  802002:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  802005:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802009:	74 0e                	je     802019 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  80200b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200e:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802011:	05 00 10 00 00       	add    $0x1000,%eax
  802016:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  802019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201c:	c1 e8 0c             	shr    $0xc,%eax
  80201f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802022:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802027:	85 c0                	test   %eax,%eax
  802029:	75 0a                	jne    802035 <smalloc+0x62>
		return NULL;
  80202b:	b8 00 00 00 00       	mov    $0x0,%eax
  802030:	e9 fc 00 00 00       	jmp    802131 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802035:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80203a:	85 c0                	test   %eax,%eax
  80203c:	74 0f                	je     80204d <smalloc+0x7a>
  80203e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802044:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802049:	39 c2                	cmp    %eax,%edx
  80204b:	73 0a                	jae    802057 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  80204d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802052:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802057:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80205c:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802061:	29 c2                	sub    %eax,%edx
  802063:	89 d0                	mov    %edx,%eax
  802065:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802068:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80206e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802073:	29 c2                	sub    %eax,%edx
  802075:	89 d0                	mov    %edx,%eax
  802077:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802080:	77 13                	ja     802095 <smalloc+0xc2>
  802082:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802085:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802088:	77 0b                	ja     802095 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  80208a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80208d:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802090:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802093:	73 0a                	jae    80209f <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  802095:	b8 00 00 00 00       	mov    $0x0,%eax
  80209a:	e9 92 00 00 00       	jmp    802131 <smalloc+0x15e>
	}

	void *va = NULL;
  80209f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8020a6:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8020ab:	83 f8 05             	cmp    $0x5,%eax
  8020ae:	75 11                	jne    8020c1 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  8020b0:	83 ec 0c             	sub    $0xc,%esp
  8020b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b6:	e8 08 f7 ff ff       	call   8017c3 <alloc_pages_custom_fit>
  8020bb:	83 c4 10             	add    $0x10,%esp
  8020be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  8020c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c5:	75 27                	jne    8020ee <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8020c7:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  8020ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020d1:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8020d4:	89 c2                	mov    %eax,%edx
  8020d6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020db:	39 c2                	cmp    %eax,%edx
  8020dd:	73 07                	jae    8020e6 <smalloc+0x113>
			return NULL;}
  8020df:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e4:	eb 4b                	jmp    802131 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  8020e6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  8020ee:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8020f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8020f5:	50                   	push   %eax
  8020f6:	ff 75 0c             	pushl  0xc(%ebp)
  8020f9:	ff 75 08             	pushl  0x8(%ebp)
  8020fc:	e8 cb 03 00 00       	call   8024cc <sys_create_shared_object>
  802101:	83 c4 10             	add    $0x10,%esp
  802104:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  802107:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80210b:	79 07                	jns    802114 <smalloc+0x141>
		return NULL;
  80210d:	b8 00 00 00 00       	mov    $0x0,%eax
  802112:	eb 1d                	jmp    802131 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802114:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802119:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80211c:	75 10                	jne    80212e <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  80211e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	01 d0                	add    %edx,%eax
  802129:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  80212e:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802139:	e8 d4 fa ff ff       	call   801c12 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80213e:	83 ec 08             	sub    $0x8,%esp
  802141:	ff 75 0c             	pushl  0xc(%ebp)
  802144:	ff 75 08             	pushl  0x8(%ebp)
  802147:	e8 aa 03 00 00       	call   8024f6 <sys_size_of_shared_object>
  80214c:	83 c4 10             	add    $0x10,%esp
  80214f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802152:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802156:	7f 0a                	jg     802162 <sget+0x2f>
		return NULL;
  802158:	b8 00 00 00 00       	mov    $0x0,%eax
  80215d:	e9 32 01 00 00       	jmp    802294 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  802162:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802165:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  802168:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216b:	25 ff 0f 00 00       	and    $0xfff,%eax
  802170:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  802173:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802177:	74 0e                	je     802187 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80217f:	05 00 10 00 00       	add    $0x1000,%eax
  802184:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  802187:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80218c:	85 c0                	test   %eax,%eax
  80218e:	75 0a                	jne    80219a <sget+0x67>
		return NULL;
  802190:	b8 00 00 00 00       	mov    $0x0,%eax
  802195:	e9 fa 00 00 00       	jmp    802294 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80219a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	74 0f                	je     8021b2 <sget+0x7f>
  8021a3:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8021a9:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021ae:	39 c2                	cmp    %eax,%edx
  8021b0:	73 0a                	jae    8021bc <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8021b2:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021b7:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8021bc:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021c1:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8021c6:	29 c2                	sub    %eax,%edx
  8021c8:	89 d0                	mov    %edx,%eax
  8021ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8021cd:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8021d3:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021d8:	29 c2                	sub    %eax,%edx
  8021da:	89 d0                	mov    %edx,%eax
  8021dc:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8021df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8021e5:	77 13                	ja     8021fa <sget+0xc7>
  8021e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8021ed:	77 0b                	ja     8021fa <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8021ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021f2:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8021f5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8021f8:	73 0a                	jae    802204 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8021fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ff:	e9 90 00 00 00       	jmp    802294 <sget+0x161>

	void *va = NULL;
  802204:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  80220b:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802210:	83 f8 05             	cmp    $0x5,%eax
  802213:	75 11                	jne    802226 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802215:	83 ec 0c             	sub    $0xc,%esp
  802218:	ff 75 f4             	pushl  -0xc(%ebp)
  80221b:	e8 a3 f5 ff ff       	call   8017c3 <alloc_pages_custom_fit>
  802220:	83 c4 10             	add    $0x10,%esp
  802223:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  802226:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80222a:	75 27                	jne    802253 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80222c:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802233:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802236:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802239:	89 c2                	mov    %eax,%edx
  80223b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802240:	39 c2                	cmp    %eax,%edx
  802242:	73 07                	jae    80224b <sget+0x118>
			return NULL;
  802244:	b8 00 00 00 00       	mov    $0x0,%eax
  802249:	eb 49                	jmp    802294 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  80224b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802250:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802253:	83 ec 04             	sub    $0x4,%esp
  802256:	ff 75 f0             	pushl  -0x10(%ebp)
  802259:	ff 75 0c             	pushl  0xc(%ebp)
  80225c:	ff 75 08             	pushl  0x8(%ebp)
  80225f:	e8 af 02 00 00       	call   802513 <sys_get_shared_object>
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  80226a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80226e:	79 07                	jns    802277 <sget+0x144>
		return NULL;
  802270:	b8 00 00 00 00       	mov    $0x0,%eax
  802275:	eb 1d                	jmp    802294 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  802277:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80227c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80227f:	75 10                	jne    802291 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802281:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228a:	01 d0                	add    %edx,%eax
  80228c:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  802291:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80229c:	e8 71 f9 ff ff       	call   801c12 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8022a1:	83 ec 04             	sub    $0x4,%esp
  8022a4:	68 14 45 80 00       	push   $0x804514
  8022a9:	68 19 02 00 00       	push   $0x219
  8022ae:	68 f1 40 80 00       	push   $0x8040f1
  8022b3:	e8 e9 12 00 00       	call   8035a1 <_panic>

008022b8 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8022be:	83 ec 04             	sub    $0x4,%esp
  8022c1:	68 3c 45 80 00       	push   $0x80453c
  8022c6:	68 2b 02 00 00       	push   $0x22b
  8022cb:	68 f1 40 80 00       	push   $0x8040f1
  8022d0:	e8 cc 12 00 00       	call   8035a1 <_panic>

008022d5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
  8022d8:	57                   	push   %edi
  8022d9:	56                   	push   %esi
  8022da:	53                   	push   %ebx
  8022db:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022ea:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022ed:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022f0:	cd 30                	int    $0x30
  8022f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8022f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022f8:	83 c4 10             	add    $0x10,%esp
  8022fb:	5b                   	pop    %ebx
  8022fc:	5e                   	pop    %esi
  8022fd:	5f                   	pop    %edi
  8022fe:	5d                   	pop    %ebp
  8022ff:	c3                   	ret    

00802300 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	83 ec 04             	sub    $0x4,%esp
  802306:	8b 45 10             	mov    0x10(%ebp),%eax
  802309:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80230c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80230f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	6a 00                	push   $0x0
  802318:	51                   	push   %ecx
  802319:	52                   	push   %edx
  80231a:	ff 75 0c             	pushl  0xc(%ebp)
  80231d:	50                   	push   %eax
  80231e:	6a 00                	push   $0x0
  802320:	e8 b0 ff ff ff       	call   8022d5 <syscall>
  802325:	83 c4 18             	add    $0x18,%esp
}
  802328:	90                   	nop
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <sys_cgetc>:

int
sys_cgetc(void)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 02                	push   $0x2
  80233a:	e8 96 ff ff ff       	call   8022d5 <syscall>
  80233f:	83 c4 18             	add    $0x18,%esp
}
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 03                	push   $0x3
  802353:	e8 7d ff ff ff       	call   8022d5 <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
}
  80235b:	90                   	nop
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    

0080235e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 04                	push   $0x4
  80236d:	e8 63 ff ff ff       	call   8022d5 <syscall>
  802372:	83 c4 18             	add    $0x18,%esp
}
  802375:	90                   	nop
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80237b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	52                   	push   %edx
  802388:	50                   	push   %eax
  802389:	6a 08                	push   $0x8
  80238b:	e8 45 ff ff ff       	call   8022d5 <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	56                   	push   %esi
  802399:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80239a:	8b 75 18             	mov    0x18(%ebp),%esi
  80239d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	56                   	push   %esi
  8023aa:	53                   	push   %ebx
  8023ab:	51                   	push   %ecx
  8023ac:	52                   	push   %edx
  8023ad:	50                   	push   %eax
  8023ae:	6a 09                	push   $0x9
  8023b0:	e8 20 ff ff ff       	call   8022d5 <syscall>
  8023b5:	83 c4 18             	add    $0x18,%esp
}
  8023b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023bb:	5b                   	pop    %ebx
  8023bc:	5e                   	pop    %esi
  8023bd:	5d                   	pop    %ebp
  8023be:	c3                   	ret    

008023bf <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	ff 75 08             	pushl  0x8(%ebp)
  8023cd:	6a 0a                	push   $0xa
  8023cf:	e8 01 ff ff ff       	call   8022d5 <syscall>
  8023d4:	83 c4 18             	add    $0x18,%esp
}
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	ff 75 0c             	pushl  0xc(%ebp)
  8023e5:	ff 75 08             	pushl  0x8(%ebp)
  8023e8:	6a 0b                	push   $0xb
  8023ea:	e8 e6 fe ff ff       	call   8022d5 <syscall>
  8023ef:	83 c4 18             	add    $0x18,%esp
}
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 0c                	push   $0xc
  802403:	e8 cd fe ff ff       	call   8022d5 <syscall>
  802408:	83 c4 18             	add    $0x18,%esp
}
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 0d                	push   $0xd
  80241c:	e8 b4 fe ff ff       	call   8022d5 <syscall>
  802421:	83 c4 18             	add    $0x18,%esp
}
  802424:	c9                   	leave  
  802425:	c3                   	ret    

00802426 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 0e                	push   $0xe
  802435:	e8 9b fe ff ff       	call   8022d5 <syscall>
  80243a:	83 c4 18             	add    $0x18,%esp
}
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 0f                	push   $0xf
  80244e:	e8 82 fe ff ff       	call   8022d5 <syscall>
  802453:	83 c4 18             	add    $0x18,%esp
}
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	ff 75 08             	pushl  0x8(%ebp)
  802466:	6a 10                	push   $0x10
  802468:	e8 68 fe ff ff       	call   8022d5 <syscall>
  80246d:	83 c4 18             	add    $0x18,%esp
}
  802470:	c9                   	leave  
  802471:	c3                   	ret    

00802472 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 11                	push   $0x11
  802481:	e8 4f fe ff ff       	call   8022d5 <syscall>
  802486:	83 c4 18             	add    $0x18,%esp
}
  802489:	90                   	nop
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <sys_cputc>:

void
sys_cputc(const char c)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	83 ec 04             	sub    $0x4,%esp
  802492:	8b 45 08             	mov    0x8(%ebp),%eax
  802495:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802498:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	50                   	push   %eax
  8024a5:	6a 01                	push   $0x1
  8024a7:	e8 29 fe ff ff       	call   8022d5 <syscall>
  8024ac:	83 c4 18             	add    $0x18,%esp
}
  8024af:	90                   	nop
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 14                	push   $0x14
  8024c1:	e8 0f fe ff ff       	call   8022d5 <syscall>
  8024c6:	83 c4 18             	add    $0x18,%esp
}
  8024c9:	90                   	nop
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	83 ec 04             	sub    $0x4,%esp
  8024d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024d8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024db:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024df:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e2:	6a 00                	push   $0x0
  8024e4:	51                   	push   %ecx
  8024e5:	52                   	push   %edx
  8024e6:	ff 75 0c             	pushl  0xc(%ebp)
  8024e9:	50                   	push   %eax
  8024ea:	6a 15                	push   $0x15
  8024ec:	e8 e4 fd ff ff       	call   8022d5 <syscall>
  8024f1:	83 c4 18             	add    $0x18,%esp
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8024f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	52                   	push   %edx
  802506:	50                   	push   %eax
  802507:	6a 16                	push   $0x16
  802509:	e8 c7 fd ff ff       	call   8022d5 <syscall>
  80250e:	83 c4 18             	add    $0x18,%esp
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802516:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802519:	8b 55 0c             	mov    0xc(%ebp),%edx
  80251c:	8b 45 08             	mov    0x8(%ebp),%eax
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	51                   	push   %ecx
  802524:	52                   	push   %edx
  802525:	50                   	push   %eax
  802526:	6a 17                	push   $0x17
  802528:	e8 a8 fd ff ff       	call   8022d5 <syscall>
  80252d:	83 c4 18             	add    $0x18,%esp
}
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802535:	8b 55 0c             	mov    0xc(%ebp),%edx
  802538:	8b 45 08             	mov    0x8(%ebp),%eax
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	52                   	push   %edx
  802542:	50                   	push   %eax
  802543:	6a 18                	push   $0x18
  802545:	e8 8b fd ff ff       	call   8022d5 <syscall>
  80254a:	83 c4 18             	add    $0x18,%esp
}
  80254d:	c9                   	leave  
  80254e:	c3                   	ret    

0080254f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80254f:	55                   	push   %ebp
  802550:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802552:	8b 45 08             	mov    0x8(%ebp),%eax
  802555:	6a 00                	push   $0x0
  802557:	ff 75 14             	pushl  0x14(%ebp)
  80255a:	ff 75 10             	pushl  0x10(%ebp)
  80255d:	ff 75 0c             	pushl  0xc(%ebp)
  802560:	50                   	push   %eax
  802561:	6a 19                	push   $0x19
  802563:	e8 6d fd ff ff       	call   8022d5 <syscall>
  802568:	83 c4 18             	add    $0x18,%esp
}
  80256b:	c9                   	leave  
  80256c:	c3                   	ret    

0080256d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802570:	8b 45 08             	mov    0x8(%ebp),%eax
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	50                   	push   %eax
  80257c:	6a 1a                	push   $0x1a
  80257e:	e8 52 fd ff ff       	call   8022d5 <syscall>
  802583:	83 c4 18             	add    $0x18,%esp
}
  802586:	90                   	nop
  802587:	c9                   	leave  
  802588:	c3                   	ret    

00802589 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	50                   	push   %eax
  802598:	6a 1b                	push   $0x1b
  80259a:	e8 36 fd ff ff       	call   8022d5 <syscall>
  80259f:	83 c4 18             	add    $0x18,%esp
}
  8025a2:	c9                   	leave  
  8025a3:	c3                   	ret    

008025a4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025a4:	55                   	push   %ebp
  8025a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 05                	push   $0x5
  8025b3:	e8 1d fd ff ff       	call   8022d5 <syscall>
  8025b8:	83 c4 18             	add    $0x18,%esp
}
  8025bb:	c9                   	leave  
  8025bc:	c3                   	ret    

008025bd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 06                	push   $0x6
  8025cc:	e8 04 fd ff ff       	call   8022d5 <syscall>
  8025d1:	83 c4 18             	add    $0x18,%esp
}
  8025d4:	c9                   	leave  
  8025d5:	c3                   	ret    

008025d6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025d6:	55                   	push   %ebp
  8025d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 07                	push   $0x7
  8025e5:	e8 eb fc ff ff       	call   8022d5 <syscall>
  8025ea:	83 c4 18             	add    $0x18,%esp
}
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <sys_exit_env>:


void sys_exit_env(void)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 1c                	push   $0x1c
  8025fe:	e8 d2 fc ff ff       	call   8022d5 <syscall>
  802603:	83 c4 18             	add    $0x18,%esp
}
  802606:	90                   	nop
  802607:	c9                   	leave  
  802608:	c3                   	ret    

00802609 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
  80260c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80260f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802612:	8d 50 04             	lea    0x4(%eax),%edx
  802615:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	52                   	push   %edx
  80261f:	50                   	push   %eax
  802620:	6a 1d                	push   $0x1d
  802622:	e8 ae fc ff ff       	call   8022d5 <syscall>
  802627:	83 c4 18             	add    $0x18,%esp
	return result;
  80262a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80262d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802630:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802633:	89 01                	mov    %eax,(%ecx)
  802635:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802638:	8b 45 08             	mov    0x8(%ebp),%eax
  80263b:	c9                   	leave  
  80263c:	c2 04 00             	ret    $0x4

0080263f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	ff 75 10             	pushl  0x10(%ebp)
  802649:	ff 75 0c             	pushl  0xc(%ebp)
  80264c:	ff 75 08             	pushl  0x8(%ebp)
  80264f:	6a 13                	push   $0x13
  802651:	e8 7f fc ff ff       	call   8022d5 <syscall>
  802656:	83 c4 18             	add    $0x18,%esp
	return ;
  802659:	90                   	nop
}
  80265a:	c9                   	leave  
  80265b:	c3                   	ret    

0080265c <sys_rcr2>:
uint32 sys_rcr2()
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 1e                	push   $0x1e
  80266b:	e8 65 fc ff ff       	call   8022d5 <syscall>
  802670:	83 c4 18             	add    $0x18,%esp
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
  802678:	83 ec 04             	sub    $0x4,%esp
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802681:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802685:	6a 00                	push   $0x0
  802687:	6a 00                	push   $0x0
  802689:	6a 00                	push   $0x0
  80268b:	6a 00                	push   $0x0
  80268d:	50                   	push   %eax
  80268e:	6a 1f                	push   $0x1f
  802690:	e8 40 fc ff ff       	call   8022d5 <syscall>
  802695:	83 c4 18             	add    $0x18,%esp
	return ;
  802698:	90                   	nop
}
  802699:	c9                   	leave  
  80269a:	c3                   	ret    

0080269b <rsttst>:
void rsttst()
{
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 00                	push   $0x0
  8026a4:	6a 00                	push   $0x0
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 21                	push   $0x21
  8026aa:	e8 26 fc ff ff       	call   8022d5 <syscall>
  8026af:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b2:	90                   	nop
}
  8026b3:	c9                   	leave  
  8026b4:	c3                   	ret    

008026b5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
  8026b8:	83 ec 04             	sub    $0x4,%esp
  8026bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8026be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026c1:	8b 55 18             	mov    0x18(%ebp),%edx
  8026c4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026c8:	52                   	push   %edx
  8026c9:	50                   	push   %eax
  8026ca:	ff 75 10             	pushl  0x10(%ebp)
  8026cd:	ff 75 0c             	pushl  0xc(%ebp)
  8026d0:	ff 75 08             	pushl  0x8(%ebp)
  8026d3:	6a 20                	push   $0x20
  8026d5:	e8 fb fb ff ff       	call   8022d5 <syscall>
  8026da:	83 c4 18             	add    $0x18,%esp
	return ;
  8026dd:	90                   	nop
}
  8026de:	c9                   	leave  
  8026df:	c3                   	ret    

008026e0 <chktst>:
void chktst(uint32 n)
{
  8026e0:	55                   	push   %ebp
  8026e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026e3:	6a 00                	push   $0x0
  8026e5:	6a 00                	push   $0x0
  8026e7:	6a 00                	push   $0x0
  8026e9:	6a 00                	push   $0x0
  8026eb:	ff 75 08             	pushl  0x8(%ebp)
  8026ee:	6a 22                	push   $0x22
  8026f0:	e8 e0 fb ff ff       	call   8022d5 <syscall>
  8026f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f8:	90                   	nop
}
  8026f9:	c9                   	leave  
  8026fa:	c3                   	ret    

008026fb <inctst>:

void inctst()
{
  8026fb:	55                   	push   %ebp
  8026fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	6a 23                	push   $0x23
  80270a:	e8 c6 fb ff ff       	call   8022d5 <syscall>
  80270f:	83 c4 18             	add    $0x18,%esp
	return ;
  802712:	90                   	nop
}
  802713:	c9                   	leave  
  802714:	c3                   	ret    

00802715 <gettst>:
uint32 gettst()
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 24                	push   $0x24
  802724:	e8 ac fb ff ff       	call   8022d5 <syscall>
  802729:	83 c4 18             	add    $0x18,%esp
}
  80272c:	c9                   	leave  
  80272d:	c3                   	ret    

0080272e <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802731:	6a 00                	push   $0x0
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 25                	push   $0x25
  80273d:	e8 93 fb ff ff       	call   8022d5 <syscall>
  802742:	83 c4 18             	add    $0x18,%esp
  802745:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  80274a:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  80274f:	c9                   	leave  
  802750:	c3                   	ret    

00802751 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802751:	55                   	push   %ebp
  802752:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	6a 00                	push   $0x0
  802762:	6a 00                	push   $0x0
  802764:	ff 75 08             	pushl  0x8(%ebp)
  802767:	6a 26                	push   $0x26
  802769:	e8 67 fb ff ff       	call   8022d5 <syscall>
  80276e:	83 c4 18             	add    $0x18,%esp
	return ;
  802771:	90                   	nop
}
  802772:	c9                   	leave  
  802773:	c3                   	ret    

00802774 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
  802777:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802778:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80277b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80277e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802781:	8b 45 08             	mov    0x8(%ebp),%eax
  802784:	6a 00                	push   $0x0
  802786:	53                   	push   %ebx
  802787:	51                   	push   %ecx
  802788:	52                   	push   %edx
  802789:	50                   	push   %eax
  80278a:	6a 27                	push   $0x27
  80278c:	e8 44 fb ff ff       	call   8022d5 <syscall>
  802791:	83 c4 18             	add    $0x18,%esp
}
  802794:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802797:	c9                   	leave  
  802798:	c3                   	ret    

00802799 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80279c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 00                	push   $0x0
  8027a8:	52                   	push   %edx
  8027a9:	50                   	push   %eax
  8027aa:	6a 28                	push   $0x28
  8027ac:	e8 24 fb ff ff       	call   8022d5 <syscall>
  8027b1:	83 c4 18             	add    $0x18,%esp
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8027b9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8027bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c2:	6a 00                	push   $0x0
  8027c4:	51                   	push   %ecx
  8027c5:	ff 75 10             	pushl  0x10(%ebp)
  8027c8:	52                   	push   %edx
  8027c9:	50                   	push   %eax
  8027ca:	6a 29                	push   $0x29
  8027cc:	e8 04 fb ff ff       	call   8022d5 <syscall>
  8027d1:	83 c4 18             	add    $0x18,%esp
}
  8027d4:	c9                   	leave  
  8027d5:	c3                   	ret    

008027d6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8027d6:	55                   	push   %ebp
  8027d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 00                	push   $0x0
  8027dd:	ff 75 10             	pushl  0x10(%ebp)
  8027e0:	ff 75 0c             	pushl  0xc(%ebp)
  8027e3:	ff 75 08             	pushl  0x8(%ebp)
  8027e6:	6a 12                	push   $0x12
  8027e8:	e8 e8 fa ff ff       	call   8022d5 <syscall>
  8027ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8027f0:	90                   	nop
}
  8027f1:	c9                   	leave  
  8027f2:	c3                   	ret    

008027f3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8027f3:	55                   	push   %ebp
  8027f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8027f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	6a 00                	push   $0x0
  802802:	52                   	push   %edx
  802803:	50                   	push   %eax
  802804:	6a 2a                	push   $0x2a
  802806:	e8 ca fa ff ff       	call   8022d5 <syscall>
  80280b:	83 c4 18             	add    $0x18,%esp
	return;
  80280e:	90                   	nop
}
  80280f:	c9                   	leave  
  802810:	c3                   	ret    

00802811 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802811:	55                   	push   %ebp
  802812:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802814:	6a 00                	push   $0x0
  802816:	6a 00                	push   $0x0
  802818:	6a 00                	push   $0x0
  80281a:	6a 00                	push   $0x0
  80281c:	6a 00                	push   $0x0
  80281e:	6a 2b                	push   $0x2b
  802820:	e8 b0 fa ff ff       	call   8022d5 <syscall>
  802825:	83 c4 18             	add    $0x18,%esp
}
  802828:	c9                   	leave  
  802829:	c3                   	ret    

0080282a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80282d:	6a 00                	push   $0x0
  80282f:	6a 00                	push   $0x0
  802831:	6a 00                	push   $0x0
  802833:	ff 75 0c             	pushl  0xc(%ebp)
  802836:	ff 75 08             	pushl  0x8(%ebp)
  802839:	6a 2d                	push   $0x2d
  80283b:	e8 95 fa ff ff       	call   8022d5 <syscall>
  802840:	83 c4 18             	add    $0x18,%esp
	return;
  802843:	90                   	nop
}
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802849:	6a 00                	push   $0x0
  80284b:	6a 00                	push   $0x0
  80284d:	6a 00                	push   $0x0
  80284f:	ff 75 0c             	pushl  0xc(%ebp)
  802852:	ff 75 08             	pushl  0x8(%ebp)
  802855:	6a 2c                	push   $0x2c
  802857:	e8 79 fa ff ff       	call   8022d5 <syscall>
  80285c:	83 c4 18             	add    $0x18,%esp
	return ;
  80285f:	90                   	nop
}
  802860:	c9                   	leave  
  802861:	c3                   	ret    

00802862 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802865:	8b 55 0c             	mov    0xc(%ebp),%edx
  802868:	8b 45 08             	mov    0x8(%ebp),%eax
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	52                   	push   %edx
  802872:	50                   	push   %eax
  802873:	6a 2e                	push   $0x2e
  802875:	e8 5b fa ff ff       	call   8022d5 <syscall>
  80287a:	83 c4 18             	add    $0x18,%esp
	return ;
  80287d:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  80287e:	c9                   	leave  
  80287f:	c3                   	ret    

00802880 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
  802883:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802886:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  80288d:	72 09                	jb     802898 <to_page_va+0x18>
  80288f:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802896:	72 14                	jb     8028ac <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802898:	83 ec 04             	sub    $0x4,%esp
  80289b:	68 60 45 80 00       	push   $0x804560
  8028a0:	6a 15                	push   $0x15
  8028a2:	68 8b 45 80 00       	push   $0x80458b
  8028a7:	e8 f5 0c 00 00       	call   8035a1 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	ba 60 50 80 00       	mov    $0x805060,%edx
  8028b4:	29 d0                	sub    %edx,%eax
  8028b6:	c1 f8 02             	sar    $0x2,%eax
  8028b9:	89 c2                	mov    %eax,%edx
  8028bb:	89 d0                	mov    %edx,%eax
  8028bd:	c1 e0 02             	shl    $0x2,%eax
  8028c0:	01 d0                	add    %edx,%eax
  8028c2:	c1 e0 02             	shl    $0x2,%eax
  8028c5:	01 d0                	add    %edx,%eax
  8028c7:	c1 e0 02             	shl    $0x2,%eax
  8028ca:	01 d0                	add    %edx,%eax
  8028cc:	89 c1                	mov    %eax,%ecx
  8028ce:	c1 e1 08             	shl    $0x8,%ecx
  8028d1:	01 c8                	add    %ecx,%eax
  8028d3:	89 c1                	mov    %eax,%ecx
  8028d5:	c1 e1 10             	shl    $0x10,%ecx
  8028d8:	01 c8                	add    %ecx,%eax
  8028da:	01 c0                	add    %eax,%eax
  8028dc:	01 d0                	add    %edx,%eax
  8028de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	c1 e0 0c             	shl    $0xc,%eax
  8028e7:	89 c2                	mov    %eax,%edx
  8028e9:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8028ee:	01 d0                	add    %edx,%eax
}
  8028f0:	c9                   	leave  
  8028f1:	c3                   	ret    

008028f2 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8028f2:	55                   	push   %ebp
  8028f3:	89 e5                	mov    %esp,%ebp
  8028f5:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8028f8:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8028fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802900:	29 c2                	sub    %eax,%edx
  802902:	89 d0                	mov    %edx,%eax
  802904:	c1 e8 0c             	shr    $0xc,%eax
  802907:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80290a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290e:	78 09                	js     802919 <to_page_info+0x27>
  802910:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802917:	7e 14                	jle    80292d <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802919:	83 ec 04             	sub    $0x4,%esp
  80291c:	68 a4 45 80 00       	push   $0x8045a4
  802921:	6a 22                	push   $0x22
  802923:	68 8b 45 80 00       	push   $0x80458b
  802928:	e8 74 0c 00 00       	call   8035a1 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80292d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802930:	89 d0                	mov    %edx,%eax
  802932:	01 c0                	add    %eax,%eax
  802934:	01 d0                	add    %edx,%eax
  802936:	c1 e0 02             	shl    $0x2,%eax
  802939:	05 60 50 80 00       	add    $0x805060,%eax
}
  80293e:	c9                   	leave  
  80293f:	c3                   	ret    

00802940 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
  802943:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	05 00 00 00 02       	add    $0x2000000,%eax
  80294e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802951:	73 16                	jae    802969 <initialize_dynamic_allocator+0x29>
  802953:	68 c8 45 80 00       	push   $0x8045c8
  802958:	68 ee 45 80 00       	push   $0x8045ee
  80295d:	6a 34                	push   $0x34
  80295f:	68 8b 45 80 00       	push   $0x80458b
  802964:	e8 38 0c 00 00       	call   8035a1 <_panic>
		is_initialized = 1;
  802969:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  802970:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  80297b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80297e:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802983:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  80298a:	00 00 00 
  80298d:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802994:	00 00 00 
  802997:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  80299e:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  8029a1:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  8029a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029af:	eb 36                	jmp    8029e7 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	c1 e0 04             	shl    $0x4,%eax
  8029b7:	05 80 d0 81 00       	add    $0x81d080,%eax
  8029bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	c1 e0 04             	shl    $0x4,%eax
  8029c8:	05 84 d0 81 00       	add    $0x81d084,%eax
  8029cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	c1 e0 04             	shl    $0x4,%eax
  8029d9:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8029de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  8029e4:	ff 45 f4             	incl   -0xc(%ebp)
  8029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ea:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8029ed:	72 c2                	jb     8029b1 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  8029ef:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029f5:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8029fa:	29 c2                	sub    %eax,%edx
  8029fc:	89 d0                	mov    %edx,%eax
  8029fe:	c1 e8 0c             	shr    $0xc,%eax
  802a01:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802a04:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802a0b:	e9 c8 00 00 00       	jmp    802ad8 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802a10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a13:	89 d0                	mov    %edx,%eax
  802a15:	01 c0                	add    %eax,%eax
  802a17:	01 d0                	add    %edx,%eax
  802a19:	c1 e0 02             	shl    $0x2,%eax
  802a1c:	05 68 50 80 00       	add    $0x805068,%eax
  802a21:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802a26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a29:	89 d0                	mov    %edx,%eax
  802a2b:	01 c0                	add    %eax,%eax
  802a2d:	01 d0                	add    %edx,%eax
  802a2f:	c1 e0 02             	shl    $0x2,%eax
  802a32:	05 6a 50 80 00       	add    $0x80506a,%eax
  802a37:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802a3c:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802a42:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802a45:	89 c8                	mov    %ecx,%eax
  802a47:	01 c0                	add    %eax,%eax
  802a49:	01 c8                	add    %ecx,%eax
  802a4b:	c1 e0 02             	shl    $0x2,%eax
  802a4e:	05 64 50 80 00       	add    $0x805064,%eax
  802a53:	89 10                	mov    %edx,(%eax)
  802a55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a58:	89 d0                	mov    %edx,%eax
  802a5a:	01 c0                	add    %eax,%eax
  802a5c:	01 d0                	add    %edx,%eax
  802a5e:	c1 e0 02             	shl    $0x2,%eax
  802a61:	05 64 50 80 00       	add    $0x805064,%eax
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	74 1b                	je     802a87 <initialize_dynamic_allocator+0x147>
  802a6c:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802a72:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802a75:	89 c8                	mov    %ecx,%eax
  802a77:	01 c0                	add    %eax,%eax
  802a79:	01 c8                	add    %ecx,%eax
  802a7b:	c1 e0 02             	shl    $0x2,%eax
  802a7e:	05 60 50 80 00       	add    $0x805060,%eax
  802a83:	89 02                	mov    %eax,(%edx)
  802a85:	eb 16                	jmp    802a9d <initialize_dynamic_allocator+0x15d>
  802a87:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a8a:	89 d0                	mov    %edx,%eax
  802a8c:	01 c0                	add    %eax,%eax
  802a8e:	01 d0                	add    %edx,%eax
  802a90:	c1 e0 02             	shl    $0x2,%eax
  802a93:	05 60 50 80 00       	add    $0x805060,%eax
  802a98:	a3 48 50 80 00       	mov    %eax,0x805048
  802a9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa0:	89 d0                	mov    %edx,%eax
  802aa2:	01 c0                	add    %eax,%eax
  802aa4:	01 d0                	add    %edx,%eax
  802aa6:	c1 e0 02             	shl    $0x2,%eax
  802aa9:	05 60 50 80 00       	add    $0x805060,%eax
  802aae:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802ab3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab6:	89 d0                	mov    %edx,%eax
  802ab8:	01 c0                	add    %eax,%eax
  802aba:	01 d0                	add    %edx,%eax
  802abc:	c1 e0 02             	shl    $0x2,%eax
  802abf:	05 60 50 80 00       	add    $0x805060,%eax
  802ac4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aca:	a1 54 50 80 00       	mov    0x805054,%eax
  802acf:	40                   	inc    %eax
  802ad0:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802ad5:	ff 45 f0             	incl   -0x10(%ebp)
  802ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ade:	0f 82 2c ff ff ff    	jb     802a10 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802ae4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802aea:	eb 2f                	jmp    802b1b <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802aec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aef:	89 d0                	mov    %edx,%eax
  802af1:	01 c0                	add    %eax,%eax
  802af3:	01 d0                	add    %edx,%eax
  802af5:	c1 e0 02             	shl    $0x2,%eax
  802af8:	05 68 50 80 00       	add    $0x805068,%eax
  802afd:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802b02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b05:	89 d0                	mov    %edx,%eax
  802b07:	01 c0                	add    %eax,%eax
  802b09:	01 d0                	add    %edx,%eax
  802b0b:	c1 e0 02             	shl    $0x2,%eax
  802b0e:	05 6a 50 80 00       	add    $0x80506a,%eax
  802b13:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802b18:	ff 45 ec             	incl   -0x14(%ebp)
  802b1b:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802b22:	76 c8                	jbe    802aec <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802b24:	90                   	nop
  802b25:	c9                   	leave  
  802b26:	c3                   	ret    

00802b27 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802b27:	55                   	push   %ebp
  802b28:	89 e5                	mov    %esp,%ebp
  802b2a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802b2d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b30:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802b35:	29 c2                	sub    %eax,%edx
  802b37:	89 d0                	mov    %edx,%eax
  802b39:	c1 e8 0c             	shr    $0xc,%eax
  802b3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802b3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802b42:	89 d0                	mov    %edx,%eax
  802b44:	01 c0                	add    %eax,%eax
  802b46:	01 d0                	add    %edx,%eax
  802b48:	c1 e0 02             	shl    $0x2,%eax
  802b4b:	05 68 50 80 00       	add    $0x805068,%eax
  802b50:	8b 00                	mov    (%eax),%eax
  802b52:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802b55:	c9                   	leave  
  802b56:	c3                   	ret    

00802b57 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802b57:	55                   	push   %ebp
  802b58:	89 e5                	mov    %esp,%ebp
  802b5a:	83 ec 14             	sub    $0x14,%esp
  802b5d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802b60:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802b64:	77 07                	ja     802b6d <nearest_pow2_ceil.1513+0x16>
  802b66:	b8 01 00 00 00       	mov    $0x1,%eax
  802b6b:	eb 20                	jmp    802b8d <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802b6d:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802b74:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802b77:	eb 08                	jmp    802b81 <nearest_pow2_ceil.1513+0x2a>
  802b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b7c:	01 c0                	add    %eax,%eax
  802b7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b81:	d1 6d 08             	shrl   0x8(%ebp)
  802b84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b88:	75 ef                	jne    802b79 <nearest_pow2_ceil.1513+0x22>
        return power;
  802b8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802b8d:	c9                   	leave  
  802b8e:	c3                   	ret    

00802b8f <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802b8f:	55                   	push   %ebp
  802b90:	89 e5                	mov    %esp,%ebp
  802b92:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802b95:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802b9c:	76 16                	jbe    802bb4 <alloc_block+0x25>
  802b9e:	68 04 46 80 00       	push   $0x804604
  802ba3:	68 ee 45 80 00       	push   $0x8045ee
  802ba8:	6a 72                	push   $0x72
  802baa:	68 8b 45 80 00       	push   $0x80458b
  802baf:	e8 ed 09 00 00       	call   8035a1 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802bb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bb8:	75 0a                	jne    802bc4 <alloc_block+0x35>
  802bba:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbf:	e9 bd 04 00 00       	jmp    803081 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802bc4:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802bd1:	73 06                	jae    802bd9 <alloc_block+0x4a>
        size = min_block_size;
  802bd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd6:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802bd9:	83 ec 0c             	sub    $0xc,%esp
  802bdc:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802bdf:	ff 75 08             	pushl  0x8(%ebp)
  802be2:	89 c1                	mov    %eax,%ecx
  802be4:	e8 6e ff ff ff       	call   802b57 <nearest_pow2_ceil.1513>
  802be9:	83 c4 10             	add    $0x10,%esp
  802bec:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802bef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bf2:	83 ec 0c             	sub    $0xc,%esp
  802bf5:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802bf8:	52                   	push   %edx
  802bf9:	89 c1                	mov    %eax,%ecx
  802bfb:	e8 83 04 00 00       	call   803083 <log2_ceil.1520>
  802c00:	83 c4 10             	add    $0x10,%esp
  802c03:	83 e8 03             	sub    $0x3,%eax
  802c06:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802c09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0c:	c1 e0 04             	shl    $0x4,%eax
  802c0f:	05 80 d0 81 00       	add    $0x81d080,%eax
  802c14:	8b 00                	mov    (%eax),%eax
  802c16:	85 c0                	test   %eax,%eax
  802c18:	0f 84 d8 00 00 00    	je     802cf6 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c21:	c1 e0 04             	shl    $0x4,%eax
  802c24:	05 80 d0 81 00       	add    $0x81d080,%eax
  802c29:	8b 00                	mov    (%eax),%eax
  802c2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802c2e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c32:	75 17                	jne    802c4b <alloc_block+0xbc>
  802c34:	83 ec 04             	sub    $0x4,%esp
  802c37:	68 25 46 80 00       	push   $0x804625
  802c3c:	68 98 00 00 00       	push   $0x98
  802c41:	68 8b 45 80 00       	push   $0x80458b
  802c46:	e8 56 09 00 00       	call   8035a1 <_panic>
  802c4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c4e:	8b 00                	mov    (%eax),%eax
  802c50:	85 c0                	test   %eax,%eax
  802c52:	74 10                	je     802c64 <alloc_block+0xd5>
  802c54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c57:	8b 00                	mov    (%eax),%eax
  802c59:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c5c:	8b 52 04             	mov    0x4(%edx),%edx
  802c5f:	89 50 04             	mov    %edx,0x4(%eax)
  802c62:	eb 14                	jmp    802c78 <alloc_block+0xe9>
  802c64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c67:	8b 40 04             	mov    0x4(%eax),%eax
  802c6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c6d:	c1 e2 04             	shl    $0x4,%edx
  802c70:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802c76:	89 02                	mov    %eax,(%edx)
  802c78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7b:	8b 40 04             	mov    0x4(%eax),%eax
  802c7e:	85 c0                	test   %eax,%eax
  802c80:	74 0f                	je     802c91 <alloc_block+0x102>
  802c82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c85:	8b 40 04             	mov    0x4(%eax),%eax
  802c88:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c8b:	8b 12                	mov    (%edx),%edx
  802c8d:	89 10                	mov    %edx,(%eax)
  802c8f:	eb 13                	jmp    802ca4 <alloc_block+0x115>
  802c91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c94:	8b 00                	mov    (%eax),%eax
  802c96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c99:	c1 e2 04             	shl    $0x4,%edx
  802c9c:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802ca2:	89 02                	mov    %eax,(%edx)
  802ca4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cba:	c1 e0 04             	shl    $0x4,%eax
  802cbd:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802cc2:	8b 00                	mov    (%eax),%eax
  802cc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  802cc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cca:	c1 e0 04             	shl    $0x4,%eax
  802ccd:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802cd2:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802cd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd7:	83 ec 0c             	sub    $0xc,%esp
  802cda:	50                   	push   %eax
  802cdb:	e8 12 fc ff ff       	call   8028f2 <to_page_info>
  802ce0:	83 c4 10             	add    $0x10,%esp
  802ce3:	89 c2                	mov    %eax,%edx
  802ce5:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802ce9:	48                   	dec    %eax
  802cea:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802cee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cf1:	e9 8b 03 00 00       	jmp    803081 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802cf6:	a1 48 50 80 00       	mov    0x805048,%eax
  802cfb:	85 c0                	test   %eax,%eax
  802cfd:	0f 84 64 02 00 00    	je     802f67 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802d03:	a1 48 50 80 00       	mov    0x805048,%eax
  802d08:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802d0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d0f:	75 17                	jne    802d28 <alloc_block+0x199>
  802d11:	83 ec 04             	sub    $0x4,%esp
  802d14:	68 25 46 80 00       	push   $0x804625
  802d19:	68 a0 00 00 00       	push   $0xa0
  802d1e:	68 8b 45 80 00       	push   $0x80458b
  802d23:	e8 79 08 00 00       	call   8035a1 <_panic>
  802d28:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d2b:	8b 00                	mov    (%eax),%eax
  802d2d:	85 c0                	test   %eax,%eax
  802d2f:	74 10                	je     802d41 <alloc_block+0x1b2>
  802d31:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d34:	8b 00                	mov    (%eax),%eax
  802d36:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d39:	8b 52 04             	mov    0x4(%edx),%edx
  802d3c:	89 50 04             	mov    %edx,0x4(%eax)
  802d3f:	eb 0b                	jmp    802d4c <alloc_block+0x1bd>
  802d41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d44:	8b 40 04             	mov    0x4(%eax),%eax
  802d47:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802d4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d4f:	8b 40 04             	mov    0x4(%eax),%eax
  802d52:	85 c0                	test   %eax,%eax
  802d54:	74 0f                	je     802d65 <alloc_block+0x1d6>
  802d56:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d59:	8b 40 04             	mov    0x4(%eax),%eax
  802d5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d5f:	8b 12                	mov    (%edx),%edx
  802d61:	89 10                	mov    %edx,(%eax)
  802d63:	eb 0a                	jmp    802d6f <alloc_block+0x1e0>
  802d65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d68:	8b 00                	mov    (%eax),%eax
  802d6a:	a3 48 50 80 00       	mov    %eax,0x805048
  802d6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d82:	a1 54 50 80 00       	mov    0x805054,%eax
  802d87:	48                   	dec    %eax
  802d88:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802d8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d93:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802d97:	b8 00 10 00 00       	mov    $0x1000,%eax
  802d9c:	99                   	cltd   
  802d9d:	f7 7d e8             	idivl  -0x18(%ebp)
  802da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802da3:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802da7:	83 ec 0c             	sub    $0xc,%esp
  802daa:	ff 75 dc             	pushl  -0x24(%ebp)
  802dad:	e8 ce fa ff ff       	call   802880 <to_page_va>
  802db2:	83 c4 10             	add    $0x10,%esp
  802db5:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802db8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802dbb:	83 ec 0c             	sub    $0xc,%esp
  802dbe:	50                   	push   %eax
  802dbf:	e8 c0 ee ff ff       	call   801c84 <get_page>
  802dc4:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802dc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802dce:	e9 aa 00 00 00       	jmp    802e7d <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd6:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802dda:	89 c2                	mov    %eax,%edx
  802ddc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ddf:	01 d0                	add    %edx,%eax
  802de1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802de4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802de8:	75 17                	jne    802e01 <alloc_block+0x272>
  802dea:	83 ec 04             	sub    $0x4,%esp
  802ded:	68 44 46 80 00       	push   $0x804644
  802df2:	68 aa 00 00 00       	push   $0xaa
  802df7:	68 8b 45 80 00       	push   $0x80458b
  802dfc:	e8 a0 07 00 00       	call   8035a1 <_panic>
  802e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e04:	c1 e0 04             	shl    $0x4,%eax
  802e07:	05 84 d0 81 00       	add    $0x81d084,%eax
  802e0c:	8b 10                	mov    (%eax),%edx
  802e0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e11:	89 50 04             	mov    %edx,0x4(%eax)
  802e14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e17:	8b 40 04             	mov    0x4(%eax),%eax
  802e1a:	85 c0                	test   %eax,%eax
  802e1c:	74 14                	je     802e32 <alloc_block+0x2a3>
  802e1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e21:	c1 e0 04             	shl    $0x4,%eax
  802e24:	05 84 d0 81 00       	add    $0x81d084,%eax
  802e29:	8b 00                	mov    (%eax),%eax
  802e2b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e2e:	89 10                	mov    %edx,(%eax)
  802e30:	eb 11                	jmp    802e43 <alloc_block+0x2b4>
  802e32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e35:	c1 e0 04             	shl    $0x4,%eax
  802e38:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802e3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e41:	89 02                	mov    %eax,(%edx)
  802e43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e46:	c1 e0 04             	shl    $0x4,%eax
  802e49:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802e4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e52:	89 02                	mov    %eax,(%edx)
  802e54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e60:	c1 e0 04             	shl    $0x4,%eax
  802e63:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e68:	8b 00                	mov    (%eax),%eax
  802e6a:	8d 50 01             	lea    0x1(%eax),%edx
  802e6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e70:	c1 e0 04             	shl    $0x4,%eax
  802e73:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e78:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802e7a:	ff 45 f4             	incl   -0xc(%ebp)
  802e7d:	b8 00 10 00 00       	mov    $0x1000,%eax
  802e82:	99                   	cltd   
  802e83:	f7 7d e8             	idivl  -0x18(%ebp)
  802e86:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802e89:	0f 8f 44 ff ff ff    	jg     802dd3 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802e8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e92:	c1 e0 04             	shl    $0x4,%eax
  802e95:	05 80 d0 81 00       	add    $0x81d080,%eax
  802e9a:	8b 00                	mov    (%eax),%eax
  802e9c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802e9f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802ea3:	75 17                	jne    802ebc <alloc_block+0x32d>
  802ea5:	83 ec 04             	sub    $0x4,%esp
  802ea8:	68 25 46 80 00       	push   $0x804625
  802ead:	68 ae 00 00 00       	push   $0xae
  802eb2:	68 8b 45 80 00       	push   $0x80458b
  802eb7:	e8 e5 06 00 00       	call   8035a1 <_panic>
  802ebc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ebf:	8b 00                	mov    (%eax),%eax
  802ec1:	85 c0                	test   %eax,%eax
  802ec3:	74 10                	je     802ed5 <alloc_block+0x346>
  802ec5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ec8:	8b 00                	mov    (%eax),%eax
  802eca:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802ecd:	8b 52 04             	mov    0x4(%edx),%edx
  802ed0:	89 50 04             	mov    %edx,0x4(%eax)
  802ed3:	eb 14                	jmp    802ee9 <alloc_block+0x35a>
  802ed5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ed8:	8b 40 04             	mov    0x4(%eax),%eax
  802edb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ede:	c1 e2 04             	shl    $0x4,%edx
  802ee1:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802ee7:	89 02                	mov    %eax,(%edx)
  802ee9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802eec:	8b 40 04             	mov    0x4(%eax),%eax
  802eef:	85 c0                	test   %eax,%eax
  802ef1:	74 0f                	je     802f02 <alloc_block+0x373>
  802ef3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ef6:	8b 40 04             	mov    0x4(%eax),%eax
  802ef9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802efc:	8b 12                	mov    (%edx),%edx
  802efe:	89 10                	mov    %edx,(%eax)
  802f00:	eb 13                	jmp    802f15 <alloc_block+0x386>
  802f02:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f05:	8b 00                	mov    (%eax),%eax
  802f07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f0a:	c1 e2 04             	shl    $0x4,%edx
  802f0d:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802f13:	89 02                	mov    %eax,(%edx)
  802f15:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f2b:	c1 e0 04             	shl    $0x4,%eax
  802f2e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f33:	8b 00                	mov    (%eax),%eax
  802f35:	8d 50 ff             	lea    -0x1(%eax),%edx
  802f38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f3b:	c1 e0 04             	shl    $0x4,%eax
  802f3e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f43:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802f45:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f48:	83 ec 0c             	sub    $0xc,%esp
  802f4b:	50                   	push   %eax
  802f4c:	e8 a1 f9 ff ff       	call   8028f2 <to_page_info>
  802f51:	83 c4 10             	add    $0x10,%esp
  802f54:	89 c2                	mov    %eax,%edx
  802f56:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802f5a:	48                   	dec    %eax
  802f5b:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802f5f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f62:	e9 1a 01 00 00       	jmp    803081 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802f67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f6a:	40                   	inc    %eax
  802f6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802f6e:	e9 ed 00 00 00       	jmp    803060 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f76:	c1 e0 04             	shl    $0x4,%eax
  802f79:	05 80 d0 81 00       	add    $0x81d080,%eax
  802f7e:	8b 00                	mov    (%eax),%eax
  802f80:	85 c0                	test   %eax,%eax
  802f82:	0f 84 d5 00 00 00    	je     80305d <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802f88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8b:	c1 e0 04             	shl    $0x4,%eax
  802f8e:	05 80 d0 81 00       	add    $0x81d080,%eax
  802f93:	8b 00                	mov    (%eax),%eax
  802f95:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  802f98:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f9c:	75 17                	jne    802fb5 <alloc_block+0x426>
  802f9e:	83 ec 04             	sub    $0x4,%esp
  802fa1:	68 25 46 80 00       	push   $0x804625
  802fa6:	68 b8 00 00 00       	push   $0xb8
  802fab:	68 8b 45 80 00       	push   $0x80458b
  802fb0:	e8 ec 05 00 00       	call   8035a1 <_panic>
  802fb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fb8:	8b 00                	mov    (%eax),%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	74 10                	je     802fce <alloc_block+0x43f>
  802fbe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fc6:	8b 52 04             	mov    0x4(%edx),%edx
  802fc9:	89 50 04             	mov    %edx,0x4(%eax)
  802fcc:	eb 14                	jmp    802fe2 <alloc_block+0x453>
  802fce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fd1:	8b 40 04             	mov    0x4(%eax),%eax
  802fd4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fd7:	c1 e2 04             	shl    $0x4,%edx
  802fda:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802fe0:	89 02                	mov    %eax,(%edx)
  802fe2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fe5:	8b 40 04             	mov    0x4(%eax),%eax
  802fe8:	85 c0                	test   %eax,%eax
  802fea:	74 0f                	je     802ffb <alloc_block+0x46c>
  802fec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fef:	8b 40 04             	mov    0x4(%eax),%eax
  802ff2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ff5:	8b 12                	mov    (%edx),%edx
  802ff7:	89 10                	mov    %edx,(%eax)
  802ff9:	eb 13                	jmp    80300e <alloc_block+0x47f>
  802ffb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ffe:	8b 00                	mov    (%eax),%eax
  803000:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803003:	c1 e2 04             	shl    $0x4,%edx
  803006:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80300c:	89 02                	mov    %eax,(%edx)
  80300e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803011:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803017:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80301a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803024:	c1 e0 04             	shl    $0x4,%eax
  803027:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80302c:	8b 00                	mov    (%eax),%eax
  80302e:	8d 50 ff             	lea    -0x1(%eax),%edx
  803031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803034:	c1 e0 04             	shl    $0x4,%eax
  803037:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80303c:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  80303e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803041:	83 ec 0c             	sub    $0xc,%esp
  803044:	50                   	push   %eax
  803045:	e8 a8 f8 ff ff       	call   8028f2 <to_page_info>
  80304a:	83 c4 10             	add    $0x10,%esp
  80304d:	89 c2                	mov    %eax,%edx
  80304f:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803053:	48                   	dec    %eax
  803054:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  803058:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80305b:	eb 24                	jmp    803081 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  80305d:	ff 45 f0             	incl   -0x10(%ebp)
  803060:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803064:	0f 8e 09 ff ff ff    	jle    802f73 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  80306a:	83 ec 04             	sub    $0x4,%esp
  80306d:	68 67 46 80 00       	push   $0x804667
  803072:	68 bf 00 00 00       	push   $0xbf
  803077:	68 8b 45 80 00       	push   $0x80458b
  80307c:	e8 20 05 00 00       	call   8035a1 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803081:	c9                   	leave  
  803082:	c3                   	ret    

00803083 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  803083:	55                   	push   %ebp
  803084:	89 e5                	mov    %esp,%ebp
  803086:	83 ec 14             	sub    $0x14,%esp
  803089:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  80308c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803090:	75 07                	jne    803099 <log2_ceil.1520+0x16>
  803092:	b8 00 00 00 00       	mov    $0x0,%eax
  803097:	eb 1b                	jmp    8030b4 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  803099:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  8030a0:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  8030a3:	eb 06                	jmp    8030ab <log2_ceil.1520+0x28>
            x >>= 1;
  8030a5:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  8030a8:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8030ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030af:	75 f4                	jne    8030a5 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  8030b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8030b4:	c9                   	leave  
  8030b5:	c3                   	ret    

008030b6 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  8030b6:	55                   	push   %ebp
  8030b7:	89 e5                	mov    %esp,%ebp
  8030b9:	83 ec 14             	sub    $0x14,%esp
  8030bc:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  8030bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c3:	75 07                	jne    8030cc <log2_ceil.1547+0x16>
  8030c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ca:	eb 1b                	jmp    8030e7 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  8030cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  8030d3:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  8030d6:	eb 06                	jmp    8030de <log2_ceil.1547+0x28>
			x >>= 1;
  8030d8:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  8030db:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  8030de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e2:	75 f4                	jne    8030d8 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8030e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8030e7:	c9                   	leave  
  8030e8:	c3                   	ret    

008030e9 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8030e9:	55                   	push   %ebp
  8030ea:	89 e5                	mov    %esp,%ebp
  8030ec:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8030ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f2:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8030f7:	39 c2                	cmp    %eax,%edx
  8030f9:	72 0c                	jb     803107 <free_block+0x1e>
  8030fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fe:	a1 40 50 80 00       	mov    0x805040,%eax
  803103:	39 c2                	cmp    %eax,%edx
  803105:	72 19                	jb     803120 <free_block+0x37>
  803107:	68 6c 46 80 00       	push   $0x80466c
  80310c:	68 ee 45 80 00       	push   $0x8045ee
  803111:	68 d0 00 00 00       	push   $0xd0
  803116:	68 8b 45 80 00       	push   $0x80458b
  80311b:	e8 81 04 00 00       	call   8035a1 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803120:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803124:	0f 84 42 03 00 00    	je     80346c <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  80312a:	8b 55 08             	mov    0x8(%ebp),%edx
  80312d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803132:	39 c2                	cmp    %eax,%edx
  803134:	72 0c                	jb     803142 <free_block+0x59>
  803136:	8b 55 08             	mov    0x8(%ebp),%edx
  803139:	a1 40 50 80 00       	mov    0x805040,%eax
  80313e:	39 c2                	cmp    %eax,%edx
  803140:	72 17                	jb     803159 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803142:	83 ec 04             	sub    $0x4,%esp
  803145:	68 a4 46 80 00       	push   $0x8046a4
  80314a:	68 e6 00 00 00       	push   $0xe6
  80314f:	68 8b 45 80 00       	push   $0x80458b
  803154:	e8 48 04 00 00       	call   8035a1 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  803159:	8b 55 08             	mov    0x8(%ebp),%edx
  80315c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803161:	29 c2                	sub    %eax,%edx
  803163:	89 d0                	mov    %edx,%eax
  803165:	83 e0 07             	and    $0x7,%eax
  803168:	85 c0                	test   %eax,%eax
  80316a:	74 17                	je     803183 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  80316c:	83 ec 04             	sub    $0x4,%esp
  80316f:	68 d8 46 80 00       	push   $0x8046d8
  803174:	68 ea 00 00 00       	push   $0xea
  803179:	68 8b 45 80 00       	push   $0x80458b
  80317e:	e8 1e 04 00 00       	call   8035a1 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  803183:	8b 45 08             	mov    0x8(%ebp),%eax
  803186:	83 ec 0c             	sub    $0xc,%esp
  803189:	50                   	push   %eax
  80318a:	e8 63 f7 ff ff       	call   8028f2 <to_page_info>
  80318f:	83 c4 10             	add    $0x10,%esp
  803192:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  803195:	83 ec 0c             	sub    $0xc,%esp
  803198:	ff 75 08             	pushl  0x8(%ebp)
  80319b:	e8 87 f9 ff ff       	call   802b27 <get_block_size>
  8031a0:	83 c4 10             	add    $0x10,%esp
  8031a3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8031a6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031aa:	75 17                	jne    8031c3 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8031ac:	83 ec 04             	sub    $0x4,%esp
  8031af:	68 04 47 80 00       	push   $0x804704
  8031b4:	68 f1 00 00 00       	push   $0xf1
  8031b9:	68 8b 45 80 00       	push   $0x80458b
  8031be:	e8 de 03 00 00       	call   8035a1 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8031c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c6:	83 ec 0c             	sub    $0xc,%esp
  8031c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8031cc:	52                   	push   %edx
  8031cd:	89 c1                	mov    %eax,%ecx
  8031cf:	e8 e2 fe ff ff       	call   8030b6 <log2_ceil.1547>
  8031d4:	83 c4 10             	add    $0x10,%esp
  8031d7:	83 e8 03             	sub    $0x3,%eax
  8031da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8031e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031e7:	75 17                	jne    803200 <free_block+0x117>
  8031e9:	83 ec 04             	sub    $0x4,%esp
  8031ec:	68 50 47 80 00       	push   $0x804750
  8031f1:	68 f6 00 00 00       	push   $0xf6
  8031f6:	68 8b 45 80 00       	push   $0x80458b
  8031fb:	e8 a1 03 00 00       	call   8035a1 <_panic>
  803200:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803203:	c1 e0 04             	shl    $0x4,%eax
  803206:	05 80 d0 81 00       	add    $0x81d080,%eax
  80320b:	8b 10                	mov    (%eax),%edx
  80320d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803210:	89 10                	mov    %edx,(%eax)
  803212:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803215:	8b 00                	mov    (%eax),%eax
  803217:	85 c0                	test   %eax,%eax
  803219:	74 15                	je     803230 <free_block+0x147>
  80321b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80321e:	c1 e0 04             	shl    $0x4,%eax
  803221:	05 80 d0 81 00       	add    $0x81d080,%eax
  803226:	8b 00                	mov    (%eax),%eax
  803228:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80322b:	89 50 04             	mov    %edx,0x4(%eax)
  80322e:	eb 11                	jmp    803241 <free_block+0x158>
  803230:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803233:	c1 e0 04             	shl    $0x4,%eax
  803236:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  80323c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80323f:	89 02                	mov    %eax,(%edx)
  803241:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803244:	c1 e0 04             	shl    $0x4,%eax
  803247:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  80324d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803250:	89 02                	mov    %eax,(%edx)
  803252:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803255:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80325f:	c1 e0 04             	shl    $0x4,%eax
  803262:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803267:	8b 00                	mov    (%eax),%eax
  803269:	8d 50 01             	lea    0x1(%eax),%edx
  80326c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80326f:	c1 e0 04             	shl    $0x4,%eax
  803272:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803277:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  803279:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803280:	40                   	inc    %eax
  803281:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803284:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  803288:	8b 55 08             	mov    0x8(%ebp),%edx
  80328b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803290:	29 c2                	sub    %eax,%edx
  803292:	89 d0                	mov    %edx,%eax
  803294:	c1 e8 0c             	shr    $0xc,%eax
  803297:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  80329a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80329d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8032a1:	0f b7 c8             	movzwl %ax,%ecx
  8032a4:	b8 00 10 00 00       	mov    $0x1000,%eax
  8032a9:	99                   	cltd   
  8032aa:	f7 7d e8             	idivl  -0x18(%ebp)
  8032ad:	39 c1                	cmp    %eax,%ecx
  8032af:	0f 85 b8 01 00 00    	jne    80346d <free_block+0x384>
    	uint32 blocks_removed = 0;
  8032b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8032bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032bf:	c1 e0 04             	shl    $0x4,%eax
  8032c2:	05 80 d0 81 00       	add    $0x81d080,%eax
  8032c7:	8b 00                	mov    (%eax),%eax
  8032c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8032cc:	e9 d5 00 00 00       	jmp    8033a6 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  8032d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d4:	8b 00                	mov    (%eax),%eax
  8032d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  8032d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032dc:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8032e1:	29 c2                	sub    %eax,%edx
  8032e3:	89 d0                	mov    %edx,%eax
  8032e5:	c1 e8 0c             	shr    $0xc,%eax
  8032e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  8032eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032ee:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8032f1:	0f 85 a9 00 00 00    	jne    8033a0 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  8032f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032fb:	75 17                	jne    803314 <free_block+0x22b>
  8032fd:	83 ec 04             	sub    $0x4,%esp
  803300:	68 25 46 80 00       	push   $0x804625
  803305:	68 04 01 00 00       	push   $0x104
  80330a:	68 8b 45 80 00       	push   $0x80458b
  80330f:	e8 8d 02 00 00       	call   8035a1 <_panic>
  803314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803317:	8b 00                	mov    (%eax),%eax
  803319:	85 c0                	test   %eax,%eax
  80331b:	74 10                	je     80332d <free_block+0x244>
  80331d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803320:	8b 00                	mov    (%eax),%eax
  803322:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803325:	8b 52 04             	mov    0x4(%edx),%edx
  803328:	89 50 04             	mov    %edx,0x4(%eax)
  80332b:	eb 14                	jmp    803341 <free_block+0x258>
  80332d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803330:	8b 40 04             	mov    0x4(%eax),%eax
  803333:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803336:	c1 e2 04             	shl    $0x4,%edx
  803339:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80333f:	89 02                	mov    %eax,(%edx)
  803341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803344:	8b 40 04             	mov    0x4(%eax),%eax
  803347:	85 c0                	test   %eax,%eax
  803349:	74 0f                	je     80335a <free_block+0x271>
  80334b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334e:	8b 40 04             	mov    0x4(%eax),%eax
  803351:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803354:	8b 12                	mov    (%edx),%edx
  803356:	89 10                	mov    %edx,(%eax)
  803358:	eb 13                	jmp    80336d <free_block+0x284>
  80335a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335d:	8b 00                	mov    (%eax),%eax
  80335f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803362:	c1 e2 04             	shl    $0x4,%edx
  803365:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80336b:	89 02                	mov    %eax,(%edx)
  80336d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803370:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803379:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803380:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803383:	c1 e0 04             	shl    $0x4,%eax
  803386:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80338b:	8b 00                	mov    (%eax),%eax
  80338d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803390:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803393:	c1 e0 04             	shl    $0x4,%eax
  803396:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80339b:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  80339d:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8033a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8033a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033aa:	0f 85 21 ff ff ff    	jne    8032d1 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8033b0:	b8 00 10 00 00       	mov    $0x1000,%eax
  8033b5:	99                   	cltd   
  8033b6:	f7 7d e8             	idivl  -0x18(%ebp)
  8033b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8033bc:	74 17                	je     8033d5 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8033be:	83 ec 04             	sub    $0x4,%esp
  8033c1:	68 74 47 80 00       	push   $0x804774
  8033c6:	68 0c 01 00 00       	push   $0x10c
  8033cb:	68 8b 45 80 00       	push   $0x80458b
  8033d0:	e8 cc 01 00 00       	call   8035a1 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  8033d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d8:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  8033de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e1:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8033e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033eb:	75 17                	jne    803404 <free_block+0x31b>
  8033ed:	83 ec 04             	sub    $0x4,%esp
  8033f0:	68 44 46 80 00       	push   $0x804644
  8033f5:	68 11 01 00 00       	push   $0x111
  8033fa:	68 8b 45 80 00       	push   $0x80458b
  8033ff:	e8 9d 01 00 00       	call   8035a1 <_panic>
  803404:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80340a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80340d:	89 50 04             	mov    %edx,0x4(%eax)
  803410:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803413:	8b 40 04             	mov    0x4(%eax),%eax
  803416:	85 c0                	test   %eax,%eax
  803418:	74 0c                	je     803426 <free_block+0x33d>
  80341a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80341f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803422:	89 10                	mov    %edx,(%eax)
  803424:	eb 08                	jmp    80342e <free_block+0x345>
  803426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803429:	a3 48 50 80 00       	mov    %eax,0x805048
  80342e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803431:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803436:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803439:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80343f:	a1 54 50 80 00       	mov    0x805054,%eax
  803444:	40                   	inc    %eax
  803445:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  80344a:	83 ec 0c             	sub    $0xc,%esp
  80344d:	ff 75 ec             	pushl  -0x14(%ebp)
  803450:	e8 2b f4 ff ff       	call   802880 <to_page_va>
  803455:	83 c4 10             	add    $0x10,%esp
  803458:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  80345b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80345e:	83 ec 0c             	sub    $0xc,%esp
  803461:	50                   	push   %eax
  803462:	e8 69 e8 ff ff       	call   801cd0 <return_page>
  803467:	83 c4 10             	add    $0x10,%esp
  80346a:	eb 01                	jmp    80346d <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80346c:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  80346d:	c9                   	leave  
  80346e:	c3                   	ret    

0080346f <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  80346f:	55                   	push   %ebp
  803470:	89 e5                	mov    %esp,%ebp
  803472:	83 ec 14             	sub    $0x14,%esp
  803475:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803478:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80347c:	77 07                	ja     803485 <nearest_pow2_ceil.1572+0x16>
      return 1;
  80347e:	b8 01 00 00 00       	mov    $0x1,%eax
  803483:	eb 20                	jmp    8034a5 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803485:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  80348c:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  80348f:	eb 08                	jmp    803499 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803491:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803494:	01 c0                	add    %eax,%eax
  803496:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803499:	d1 6d 08             	shrl   0x8(%ebp)
  80349c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034a0:	75 ef                	jne    803491 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8034a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8034a5:	c9                   	leave  
  8034a6:	c3                   	ret    

008034a7 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8034a7:	55                   	push   %ebp
  8034a8:	89 e5                	mov    %esp,%ebp
  8034aa:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8034ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b1:	75 13                	jne    8034c6 <realloc_block+0x1f>
    return alloc_block(new_size);
  8034b3:	83 ec 0c             	sub    $0xc,%esp
  8034b6:	ff 75 0c             	pushl  0xc(%ebp)
  8034b9:	e8 d1 f6 ff ff       	call   802b8f <alloc_block>
  8034be:	83 c4 10             	add    $0x10,%esp
  8034c1:	e9 d9 00 00 00       	jmp    80359f <realloc_block+0xf8>
  }

  if (new_size == 0) {
  8034c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034ca:	75 18                	jne    8034e4 <realloc_block+0x3d>
    free_block(va);
  8034cc:	83 ec 0c             	sub    $0xc,%esp
  8034cf:	ff 75 08             	pushl  0x8(%ebp)
  8034d2:	e8 12 fc ff ff       	call   8030e9 <free_block>
  8034d7:	83 c4 10             	add    $0x10,%esp
    return NULL;
  8034da:	b8 00 00 00 00       	mov    $0x0,%eax
  8034df:	e9 bb 00 00 00       	jmp    80359f <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  8034e4:	83 ec 0c             	sub    $0xc,%esp
  8034e7:	ff 75 08             	pushl  0x8(%ebp)
  8034ea:	e8 38 f6 ff ff       	call   802b27 <get_block_size>
  8034ef:	83 c4 10             	add    $0x10,%esp
  8034f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8034f5:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  8034fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803502:	73 06                	jae    80350a <realloc_block+0x63>
    new_size = min_block_size;
  803504:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803507:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  80350a:	83 ec 0c             	sub    $0xc,%esp
  80350d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803510:	ff 75 0c             	pushl  0xc(%ebp)
  803513:	89 c1                	mov    %eax,%ecx
  803515:	e8 55 ff ff ff       	call   80346f <nearest_pow2_ceil.1572>
  80351a:	83 c4 10             	add    $0x10,%esp
  80351d:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803520:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803523:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803526:	75 05                	jne    80352d <realloc_block+0x86>
    return va;
  803528:	8b 45 08             	mov    0x8(%ebp),%eax
  80352b:	eb 72                	jmp    80359f <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  80352d:	83 ec 0c             	sub    $0xc,%esp
  803530:	ff 75 0c             	pushl  0xc(%ebp)
  803533:	e8 57 f6 ff ff       	call   802b8f <alloc_block>
  803538:	83 c4 10             	add    $0x10,%esp
  80353b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  80353e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803542:	75 07                	jne    80354b <realloc_block+0xa4>
    return NULL;
  803544:	b8 00 00 00 00       	mov    $0x0,%eax
  803549:	eb 54                	jmp    80359f <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  80354b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80354e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803551:	39 d0                	cmp    %edx,%eax
  803553:	76 02                	jbe    803557 <realloc_block+0xb0>
  803555:	89 d0                	mov    %edx,%eax
  803557:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803560:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803563:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803566:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80356d:	eb 17                	jmp    803586 <realloc_block+0xdf>
    dst[i] = src[i];
  80356f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803575:	01 c2                	add    %eax,%edx
  803577:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80357a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357d:	01 c8                	add    %ecx,%eax
  80357f:	8a 00                	mov    (%eax),%al
  803581:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803583:	ff 45 f4             	incl   -0xc(%ebp)
  803586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803589:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80358c:	72 e1                	jb     80356f <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  80358e:	83 ec 0c             	sub    $0xc,%esp
  803591:	ff 75 08             	pushl  0x8(%ebp)
  803594:	e8 50 fb ff ff       	call   8030e9 <free_block>
  803599:	83 c4 10             	add    $0x10,%esp

  return new_va;
  80359c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80359f:	c9                   	leave  
  8035a0:	c3                   	ret    

008035a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8035a1:	55                   	push   %ebp
  8035a2:	89 e5                	mov    %esp,%ebp
  8035a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8035a7:	8d 45 10             	lea    0x10(%ebp),%eax
  8035aa:	83 c0 04             	add    $0x4,%eax
  8035ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8035b0:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  8035b5:	85 c0                	test   %eax,%eax
  8035b7:	74 16                	je     8035cf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8035b9:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  8035be:	83 ec 08             	sub    $0x8,%esp
  8035c1:	50                   	push   %eax
  8035c2:	68 a8 47 80 00       	push   $0x8047a8
  8035c7:	e8 1c d1 ff ff       	call   8006e8 <cprintf>
  8035cc:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8035cf:	a1 04 50 80 00       	mov    0x805004,%eax
  8035d4:	83 ec 0c             	sub    $0xc,%esp
  8035d7:	ff 75 0c             	pushl  0xc(%ebp)
  8035da:	ff 75 08             	pushl  0x8(%ebp)
  8035dd:	50                   	push   %eax
  8035de:	68 b0 47 80 00       	push   $0x8047b0
  8035e3:	6a 74                	push   $0x74
  8035e5:	e8 2b d1 ff ff       	call   800715 <cprintf_colored>
  8035ea:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8035ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8035f0:	83 ec 08             	sub    $0x8,%esp
  8035f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8035f6:	50                   	push   %eax
  8035f7:	e8 7d d0 ff ff       	call   800679 <vcprintf>
  8035fc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8035ff:	83 ec 08             	sub    $0x8,%esp
  803602:	6a 00                	push   $0x0
  803604:	68 d8 47 80 00       	push   $0x8047d8
  803609:	e8 6b d0 ff ff       	call   800679 <vcprintf>
  80360e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803611:	e8 e4 cf ff ff       	call   8005fa <exit>

	// should not return here
	while (1) ;
  803616:	eb fe                	jmp    803616 <_panic+0x75>

00803618 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803618:	55                   	push   %ebp
  803619:	89 e5                	mov    %esp,%ebp
  80361b:	53                   	push   %ebx
  80361c:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80361f:	a1 20 50 80 00       	mov    0x805020,%eax
  803624:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80362a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362d:	39 c2                	cmp    %eax,%edx
  80362f:	74 14                	je     803645 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803631:	83 ec 04             	sub    $0x4,%esp
  803634:	68 dc 47 80 00       	push   $0x8047dc
  803639:	6a 26                	push   $0x26
  80363b:	68 28 48 80 00       	push   $0x804828
  803640:	e8 5c ff ff ff       	call   8035a1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803645:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80364c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803653:	e9 d9 00 00 00       	jmp    803731 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  803658:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80365b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803662:	8b 45 08             	mov    0x8(%ebp),%eax
  803665:	01 d0                	add    %edx,%eax
  803667:	8b 00                	mov    (%eax),%eax
  803669:	85 c0                	test   %eax,%eax
  80366b:	75 08                	jne    803675 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80366d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803670:	e9 b9 00 00 00       	jmp    80372e <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  803675:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80367c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803683:	eb 79                	jmp    8036fe <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803685:	a1 20 50 80 00       	mov    0x805020,%eax
  80368a:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803690:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803693:	89 d0                	mov    %edx,%eax
  803695:	01 c0                	add    %eax,%eax
  803697:	01 d0                	add    %edx,%eax
  803699:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8036a0:	01 d8                	add    %ebx,%eax
  8036a2:	01 d0                	add    %edx,%eax
  8036a4:	01 c8                	add    %ecx,%eax
  8036a6:	8a 40 04             	mov    0x4(%eax),%al
  8036a9:	84 c0                	test   %al,%al
  8036ab:	75 4e                	jne    8036fb <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8036ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8036b2:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8036b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036bb:	89 d0                	mov    %edx,%eax
  8036bd:	01 c0                	add    %eax,%eax
  8036bf:	01 d0                	add    %edx,%eax
  8036c1:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8036c8:	01 d8                	add    %ebx,%eax
  8036ca:	01 d0                	add    %edx,%eax
  8036cc:	01 c8                	add    %ecx,%eax
  8036ce:	8b 00                	mov    (%eax),%eax
  8036d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8036d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8036db:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8036dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8036e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ea:	01 c8                	add    %ecx,%eax
  8036ec:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8036ee:	39 c2                	cmp    %eax,%edx
  8036f0:	75 09                	jne    8036fb <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8036f2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8036f9:	eb 19                	jmp    803714 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036fb:	ff 45 e8             	incl   -0x18(%ebp)
  8036fe:	a1 20 50 80 00       	mov    0x805020,%eax
  803703:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803709:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370c:	39 c2                	cmp    %eax,%edx
  80370e:	0f 87 71 ff ff ff    	ja     803685 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803714:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803718:	75 14                	jne    80372e <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80371a:	83 ec 04             	sub    $0x4,%esp
  80371d:	68 34 48 80 00       	push   $0x804834
  803722:	6a 3a                	push   $0x3a
  803724:	68 28 48 80 00       	push   $0x804828
  803729:	e8 73 fe ff ff       	call   8035a1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80372e:	ff 45 f0             	incl   -0x10(%ebp)
  803731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803734:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803737:	0f 8c 1b ff ff ff    	jl     803658 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80373d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803744:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80374b:	eb 2e                	jmp    80377b <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80374d:	a1 20 50 80 00       	mov    0x805020,%eax
  803752:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803758:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80375b:	89 d0                	mov    %edx,%eax
  80375d:	01 c0                	add    %eax,%eax
  80375f:	01 d0                	add    %edx,%eax
  803761:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803768:	01 d8                	add    %ebx,%eax
  80376a:	01 d0                	add    %edx,%eax
  80376c:	01 c8                	add    %ecx,%eax
  80376e:	8a 40 04             	mov    0x4(%eax),%al
  803771:	3c 01                	cmp    $0x1,%al
  803773:	75 03                	jne    803778 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  803775:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803778:	ff 45 e0             	incl   -0x20(%ebp)
  80377b:	a1 20 50 80 00       	mov    0x805020,%eax
  803780:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803786:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803789:	39 c2                	cmp    %eax,%edx
  80378b:	77 c0                	ja     80374d <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80378d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803790:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803793:	74 14                	je     8037a9 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  803795:	83 ec 04             	sub    $0x4,%esp
  803798:	68 88 48 80 00       	push   $0x804888
  80379d:	6a 44                	push   $0x44
  80379f:	68 28 48 80 00       	push   $0x804828
  8037a4:	e8 f8 fd ff ff       	call   8035a1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8037a9:	90                   	nop
  8037aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8037ad:	c9                   	leave  
  8037ae:	c3                   	ret    
  8037af:	90                   	nop

008037b0 <__udivdi3>:
  8037b0:	55                   	push   %ebp
  8037b1:	57                   	push   %edi
  8037b2:	56                   	push   %esi
  8037b3:	53                   	push   %ebx
  8037b4:	83 ec 1c             	sub    $0x1c,%esp
  8037b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037c7:	89 ca                	mov    %ecx,%edx
  8037c9:	89 f8                	mov    %edi,%eax
  8037cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037cf:	85 f6                	test   %esi,%esi
  8037d1:	75 2d                	jne    803800 <__udivdi3+0x50>
  8037d3:	39 cf                	cmp    %ecx,%edi
  8037d5:	77 65                	ja     80383c <__udivdi3+0x8c>
  8037d7:	89 fd                	mov    %edi,%ebp
  8037d9:	85 ff                	test   %edi,%edi
  8037db:	75 0b                	jne    8037e8 <__udivdi3+0x38>
  8037dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8037e2:	31 d2                	xor    %edx,%edx
  8037e4:	f7 f7                	div    %edi
  8037e6:	89 c5                	mov    %eax,%ebp
  8037e8:	31 d2                	xor    %edx,%edx
  8037ea:	89 c8                	mov    %ecx,%eax
  8037ec:	f7 f5                	div    %ebp
  8037ee:	89 c1                	mov    %eax,%ecx
  8037f0:	89 d8                	mov    %ebx,%eax
  8037f2:	f7 f5                	div    %ebp
  8037f4:	89 cf                	mov    %ecx,%edi
  8037f6:	89 fa                	mov    %edi,%edx
  8037f8:	83 c4 1c             	add    $0x1c,%esp
  8037fb:	5b                   	pop    %ebx
  8037fc:	5e                   	pop    %esi
  8037fd:	5f                   	pop    %edi
  8037fe:	5d                   	pop    %ebp
  8037ff:	c3                   	ret    
  803800:	39 ce                	cmp    %ecx,%esi
  803802:	77 28                	ja     80382c <__udivdi3+0x7c>
  803804:	0f bd fe             	bsr    %esi,%edi
  803807:	83 f7 1f             	xor    $0x1f,%edi
  80380a:	75 40                	jne    80384c <__udivdi3+0x9c>
  80380c:	39 ce                	cmp    %ecx,%esi
  80380e:	72 0a                	jb     80381a <__udivdi3+0x6a>
  803810:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803814:	0f 87 9e 00 00 00    	ja     8038b8 <__udivdi3+0x108>
  80381a:	b8 01 00 00 00       	mov    $0x1,%eax
  80381f:	89 fa                	mov    %edi,%edx
  803821:	83 c4 1c             	add    $0x1c,%esp
  803824:	5b                   	pop    %ebx
  803825:	5e                   	pop    %esi
  803826:	5f                   	pop    %edi
  803827:	5d                   	pop    %ebp
  803828:	c3                   	ret    
  803829:	8d 76 00             	lea    0x0(%esi),%esi
  80382c:	31 ff                	xor    %edi,%edi
  80382e:	31 c0                	xor    %eax,%eax
  803830:	89 fa                	mov    %edi,%edx
  803832:	83 c4 1c             	add    $0x1c,%esp
  803835:	5b                   	pop    %ebx
  803836:	5e                   	pop    %esi
  803837:	5f                   	pop    %edi
  803838:	5d                   	pop    %ebp
  803839:	c3                   	ret    
  80383a:	66 90                	xchg   %ax,%ax
  80383c:	89 d8                	mov    %ebx,%eax
  80383e:	f7 f7                	div    %edi
  803840:	31 ff                	xor    %edi,%edi
  803842:	89 fa                	mov    %edi,%edx
  803844:	83 c4 1c             	add    $0x1c,%esp
  803847:	5b                   	pop    %ebx
  803848:	5e                   	pop    %esi
  803849:	5f                   	pop    %edi
  80384a:	5d                   	pop    %ebp
  80384b:	c3                   	ret    
  80384c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803851:	89 eb                	mov    %ebp,%ebx
  803853:	29 fb                	sub    %edi,%ebx
  803855:	89 f9                	mov    %edi,%ecx
  803857:	d3 e6                	shl    %cl,%esi
  803859:	89 c5                	mov    %eax,%ebp
  80385b:	88 d9                	mov    %bl,%cl
  80385d:	d3 ed                	shr    %cl,%ebp
  80385f:	89 e9                	mov    %ebp,%ecx
  803861:	09 f1                	or     %esi,%ecx
  803863:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803867:	89 f9                	mov    %edi,%ecx
  803869:	d3 e0                	shl    %cl,%eax
  80386b:	89 c5                	mov    %eax,%ebp
  80386d:	89 d6                	mov    %edx,%esi
  80386f:	88 d9                	mov    %bl,%cl
  803871:	d3 ee                	shr    %cl,%esi
  803873:	89 f9                	mov    %edi,%ecx
  803875:	d3 e2                	shl    %cl,%edx
  803877:	8b 44 24 08          	mov    0x8(%esp),%eax
  80387b:	88 d9                	mov    %bl,%cl
  80387d:	d3 e8                	shr    %cl,%eax
  80387f:	09 c2                	or     %eax,%edx
  803881:	89 d0                	mov    %edx,%eax
  803883:	89 f2                	mov    %esi,%edx
  803885:	f7 74 24 0c          	divl   0xc(%esp)
  803889:	89 d6                	mov    %edx,%esi
  80388b:	89 c3                	mov    %eax,%ebx
  80388d:	f7 e5                	mul    %ebp
  80388f:	39 d6                	cmp    %edx,%esi
  803891:	72 19                	jb     8038ac <__udivdi3+0xfc>
  803893:	74 0b                	je     8038a0 <__udivdi3+0xf0>
  803895:	89 d8                	mov    %ebx,%eax
  803897:	31 ff                	xor    %edi,%edi
  803899:	e9 58 ff ff ff       	jmp    8037f6 <__udivdi3+0x46>
  80389e:	66 90                	xchg   %ax,%ax
  8038a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038a4:	89 f9                	mov    %edi,%ecx
  8038a6:	d3 e2                	shl    %cl,%edx
  8038a8:	39 c2                	cmp    %eax,%edx
  8038aa:	73 e9                	jae    803895 <__udivdi3+0xe5>
  8038ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038af:	31 ff                	xor    %edi,%edi
  8038b1:	e9 40 ff ff ff       	jmp    8037f6 <__udivdi3+0x46>
  8038b6:	66 90                	xchg   %ax,%ax
  8038b8:	31 c0                	xor    %eax,%eax
  8038ba:	e9 37 ff ff ff       	jmp    8037f6 <__udivdi3+0x46>
  8038bf:	90                   	nop

008038c0 <__umoddi3>:
  8038c0:	55                   	push   %ebp
  8038c1:	57                   	push   %edi
  8038c2:	56                   	push   %esi
  8038c3:	53                   	push   %ebx
  8038c4:	83 ec 1c             	sub    $0x1c,%esp
  8038c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038df:	89 f3                	mov    %esi,%ebx
  8038e1:	89 fa                	mov    %edi,%edx
  8038e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038e7:	89 34 24             	mov    %esi,(%esp)
  8038ea:	85 c0                	test   %eax,%eax
  8038ec:	75 1a                	jne    803908 <__umoddi3+0x48>
  8038ee:	39 f7                	cmp    %esi,%edi
  8038f0:	0f 86 a2 00 00 00    	jbe    803998 <__umoddi3+0xd8>
  8038f6:	89 c8                	mov    %ecx,%eax
  8038f8:	89 f2                	mov    %esi,%edx
  8038fa:	f7 f7                	div    %edi
  8038fc:	89 d0                	mov    %edx,%eax
  8038fe:	31 d2                	xor    %edx,%edx
  803900:	83 c4 1c             	add    $0x1c,%esp
  803903:	5b                   	pop    %ebx
  803904:	5e                   	pop    %esi
  803905:	5f                   	pop    %edi
  803906:	5d                   	pop    %ebp
  803907:	c3                   	ret    
  803908:	39 f0                	cmp    %esi,%eax
  80390a:	0f 87 ac 00 00 00    	ja     8039bc <__umoddi3+0xfc>
  803910:	0f bd e8             	bsr    %eax,%ebp
  803913:	83 f5 1f             	xor    $0x1f,%ebp
  803916:	0f 84 ac 00 00 00    	je     8039c8 <__umoddi3+0x108>
  80391c:	bf 20 00 00 00       	mov    $0x20,%edi
  803921:	29 ef                	sub    %ebp,%edi
  803923:	89 fe                	mov    %edi,%esi
  803925:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803929:	89 e9                	mov    %ebp,%ecx
  80392b:	d3 e0                	shl    %cl,%eax
  80392d:	89 d7                	mov    %edx,%edi
  80392f:	89 f1                	mov    %esi,%ecx
  803931:	d3 ef                	shr    %cl,%edi
  803933:	09 c7                	or     %eax,%edi
  803935:	89 e9                	mov    %ebp,%ecx
  803937:	d3 e2                	shl    %cl,%edx
  803939:	89 14 24             	mov    %edx,(%esp)
  80393c:	89 d8                	mov    %ebx,%eax
  80393e:	d3 e0                	shl    %cl,%eax
  803940:	89 c2                	mov    %eax,%edx
  803942:	8b 44 24 08          	mov    0x8(%esp),%eax
  803946:	d3 e0                	shl    %cl,%eax
  803948:	89 44 24 04          	mov    %eax,0x4(%esp)
  80394c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803950:	89 f1                	mov    %esi,%ecx
  803952:	d3 e8                	shr    %cl,%eax
  803954:	09 d0                	or     %edx,%eax
  803956:	d3 eb                	shr    %cl,%ebx
  803958:	89 da                	mov    %ebx,%edx
  80395a:	f7 f7                	div    %edi
  80395c:	89 d3                	mov    %edx,%ebx
  80395e:	f7 24 24             	mull   (%esp)
  803961:	89 c6                	mov    %eax,%esi
  803963:	89 d1                	mov    %edx,%ecx
  803965:	39 d3                	cmp    %edx,%ebx
  803967:	0f 82 87 00 00 00    	jb     8039f4 <__umoddi3+0x134>
  80396d:	0f 84 91 00 00 00    	je     803a04 <__umoddi3+0x144>
  803973:	8b 54 24 04          	mov    0x4(%esp),%edx
  803977:	29 f2                	sub    %esi,%edx
  803979:	19 cb                	sbb    %ecx,%ebx
  80397b:	89 d8                	mov    %ebx,%eax
  80397d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803981:	d3 e0                	shl    %cl,%eax
  803983:	89 e9                	mov    %ebp,%ecx
  803985:	d3 ea                	shr    %cl,%edx
  803987:	09 d0                	or     %edx,%eax
  803989:	89 e9                	mov    %ebp,%ecx
  80398b:	d3 eb                	shr    %cl,%ebx
  80398d:	89 da                	mov    %ebx,%edx
  80398f:	83 c4 1c             	add    $0x1c,%esp
  803992:	5b                   	pop    %ebx
  803993:	5e                   	pop    %esi
  803994:	5f                   	pop    %edi
  803995:	5d                   	pop    %ebp
  803996:	c3                   	ret    
  803997:	90                   	nop
  803998:	89 fd                	mov    %edi,%ebp
  80399a:	85 ff                	test   %edi,%edi
  80399c:	75 0b                	jne    8039a9 <__umoddi3+0xe9>
  80399e:	b8 01 00 00 00       	mov    $0x1,%eax
  8039a3:	31 d2                	xor    %edx,%edx
  8039a5:	f7 f7                	div    %edi
  8039a7:	89 c5                	mov    %eax,%ebp
  8039a9:	89 f0                	mov    %esi,%eax
  8039ab:	31 d2                	xor    %edx,%edx
  8039ad:	f7 f5                	div    %ebp
  8039af:	89 c8                	mov    %ecx,%eax
  8039b1:	f7 f5                	div    %ebp
  8039b3:	89 d0                	mov    %edx,%eax
  8039b5:	e9 44 ff ff ff       	jmp    8038fe <__umoddi3+0x3e>
  8039ba:	66 90                	xchg   %ax,%ax
  8039bc:	89 c8                	mov    %ecx,%eax
  8039be:	89 f2                	mov    %esi,%edx
  8039c0:	83 c4 1c             	add    $0x1c,%esp
  8039c3:	5b                   	pop    %ebx
  8039c4:	5e                   	pop    %esi
  8039c5:	5f                   	pop    %edi
  8039c6:	5d                   	pop    %ebp
  8039c7:	c3                   	ret    
  8039c8:	3b 04 24             	cmp    (%esp),%eax
  8039cb:	72 06                	jb     8039d3 <__umoddi3+0x113>
  8039cd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039d1:	77 0f                	ja     8039e2 <__umoddi3+0x122>
  8039d3:	89 f2                	mov    %esi,%edx
  8039d5:	29 f9                	sub    %edi,%ecx
  8039d7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039db:	89 14 24             	mov    %edx,(%esp)
  8039de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039e2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039e6:	8b 14 24             	mov    (%esp),%edx
  8039e9:	83 c4 1c             	add    $0x1c,%esp
  8039ec:	5b                   	pop    %ebx
  8039ed:	5e                   	pop    %esi
  8039ee:	5f                   	pop    %edi
  8039ef:	5d                   	pop    %ebp
  8039f0:	c3                   	ret    
  8039f1:	8d 76 00             	lea    0x0(%esi),%esi
  8039f4:	2b 04 24             	sub    (%esp),%eax
  8039f7:	19 fa                	sbb    %edi,%edx
  8039f9:	89 d1                	mov    %edx,%ecx
  8039fb:	89 c6                	mov    %eax,%esi
  8039fd:	e9 71 ff ff ff       	jmp    803973 <__umoddi3+0xb3>
  803a02:	66 90                	xchg   %ax,%ax
  803a04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a08:	72 ea                	jb     8039f4 <__umoddi3+0x134>
  803a0a:	89 d9                	mov    %ebx,%ecx
  803a0c:	e9 62 ff ff ff       	jmp    803973 <__umoddi3+0xb3>
