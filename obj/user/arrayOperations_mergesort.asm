
obj/user/arrayOperations_mergesort:     file format elf32-i386


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
  800031:	e8 46 05 00 00       	call   80057c <libmain>
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
  8000b1:	68 40 3b 80 00       	push   $0x803b40
  8000b6:	e8 51 07 00 00       	call   80080c <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8000be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	8b 00                	mov    (%eax),%eax
  8000cf:	83 ec 08             	sub    $0x8,%esp
  8000d2:	50                   	push   %eax
  8000d3:	68 42 3b 80 00       	push   $0x803b42
  8000d8:	e8 2f 07 00 00       	call   80080c <cprintf>
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
  800101:	68 47 3b 80 00       	push   $0x803b47
  800106:	e8 01 07 00 00       	call   80080c <cprintf>
  80010b:	83 c4 10             	add    $0x10,%esp

}
  80010e:	90                   	nop
  80010f:	c9                   	leave  
  800110:	c3                   	ret    

00800111 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	57                   	push   %edi
  800115:	56                   	push   %esi
  800116:	53                   	push   %ebx
  800117:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
	int32 parentenvID = sys_getparentenvid();
  80011d:	e8 d8 25 00 00       	call   8026fa <sys_getparentenvid>
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
#endif

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
#if USE_KERN_SEMAPHORE
	char waitCmd1[64] = "__KSem@0@Wait";
  800125:	8d 45 90             	lea    -0x70(%ebp),%eax
  800128:	bb d4 3b 80 00       	mov    $0x803bd4,%ebx
  80012d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800132:	89 c7                	mov    %eax,%edi
  800134:	89 de                	mov    %ebx,%esi
  800136:	89 d1                	mov    %edx,%ecx
  800138:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80013a:	8d 55 9e             	lea    -0x62(%ebp),%edx
  80013d:	b9 32 00 00 00       	mov    $0x32,%ecx
  800142:	b0 00                	mov    $0x0,%al
  800144:	89 d7                	mov    %edx,%edi
  800146:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd1, 0);
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	6a 00                	push   $0x0
  80014d:	8d 45 90             	lea    -0x70(%ebp),%eax
  800150:	50                   	push   %eax
  800151:	e8 c1 27 00 00       	call   802917 <sys_utilities>
  800156:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(ready);
#endif

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  800159:	83 ec 08             	sub    $0x8,%esp
  80015c:	68 4b 3b 80 00       	push   $0x803b4b
  800161:	ff 75 e0             	pushl  -0x20(%ebp)
  800164:	e8 ee 20 00 00       	call   802257 <sget>
  800169:	83 c4 10             	add    $0x10,%esp
  80016c:	89 45 dc             	mov    %eax,-0x24(%ebp)
#else
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
#endif

	//Get the shared array & its size
	int *numOfElements = NULL;
  80016f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	int *sharedArray = NULL;
  800176:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  80017d:	83 ec 08             	sub    $0x8,%esp
  800180:	68 5e 3b 80 00       	push   $0x803b5e
  800185:	ff 75 e0             	pushl  -0x20(%ebp)
  800188:	e8 ca 20 00 00       	call   802257 <sget>
  80018d:	83 c4 10             	add    $0x10,%esp
  800190:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  800193:	83 ec 08             	sub    $0x8,%esp
  800196:	68 62 3b 80 00       	push   $0x803b62
  80019b:	ff 75 e0             	pushl  -0x20(%ebp)
  80019e:	e8 b4 20 00 00       	call   802257 <sget>
  8001a3:	83 c4 10             	add    $0x10,%esp
  8001a6:	89 45 d8             	mov    %eax,-0x28(%ebp)

	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  8001a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001ac:	8b 00                	mov    (%eax),%eax
  8001ae:	c1 e0 02             	shl    $0x2,%eax
  8001b1:	83 ec 04             	sub    $0x4,%esp
  8001b4:	6a 00                	push   $0x0
  8001b6:	50                   	push   %eax
  8001b7:	68 6a 3b 80 00       	push   $0x803b6a
  8001bc:	e8 36 1f 00 00       	call   8020f7 <smalloc>
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8001c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001ce:	eb 25                	jmp    8001f5 <_main+0xe4>
	{
		sortedArray[i] = sharedArray[i];
  8001d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001dd:	01 c2                	add    %eax,%edx
  8001df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001e2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001ec:	01 c8                	add    %ecx,%eax
  8001ee:	8b 00                	mov    (%eax),%eax
  8001f0:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8001f2:	ff 45 e4             	incl   -0x1c(%ebp)
  8001f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001f8:	8b 00                	mov    (%eax),%eax
  8001fa:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001fd:	7f d1                	jg     8001d0 <_main+0xbf>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  8001ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800202:	8b 00                	mov    (%eax),%eax
  800204:	83 ec 04             	sub    $0x4,%esp
  800207:	50                   	push   %eax
  800208:	6a 01                	push   $0x1
  80020a:	ff 75 d0             	pushl  -0x30(%ebp)
  80020d:	e8 f9 00 00 00       	call   80030b <MSort>
  800212:	83 c4 10             	add    $0x10,%esp

#if USE_KERN_SEMAPHORE
	char waitCmd2[64] = "__KSem@2@Wait";
  800215:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80021b:	bb 14 3c 80 00       	mov    $0x803c14,%ebx
  800220:	ba 0e 00 00 00       	mov    $0xe,%edx
  800225:	89 c7                	mov    %eax,%edi
  800227:	89 de                	mov    %ebx,%esi
  800229:	89 d1                	mov    %edx,%ecx
  80022b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80022d:	8d 95 5e ff ff ff    	lea    -0xa2(%ebp),%edx
  800233:	b9 32 00 00 00       	mov    $0x32,%ecx
  800238:	b0 00                	mov    $0x0,%al
  80023a:	89 d7                	mov    %edx,%edi
  80023c:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd2, 0);
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	6a 00                	push   $0x0
  800243:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  800249:	50                   	push   %eax
  80024a:	e8 c8 26 00 00       	call   802917 <sys_utilities>
  80024f:	83 c4 10             	add    $0x10,%esp
#else
	wait_semaphore(cons_mutex);
#endif
	{
		cprintf("Merge sort is Finished!!!!\n") ;
  800252:	83 ec 0c             	sub    $0xc,%esp
  800255:	68 79 3b 80 00       	push   $0x803b79
  80025a:	e8 ad 05 00 00       	call   80080c <cprintf>
  80025f:	83 c4 10             	add    $0x10,%esp
		cprintf("will notify the master now...\n");
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 98 3b 80 00       	push   $0x803b98
  80026a:	e8 9d 05 00 00       	call   80080c <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
		cprintf("Merge sort says GOOD BYE :)\n") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 b7 3b 80 00       	push   $0x803bb7
  80027a:	e8 8d 05 00 00       	call   80080c <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
	}
#if USE_KERN_SEMAPHORE
	char signalCmd1[64] = "__KSem@2@Signal";
  800282:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
  800288:	bb 54 3c 80 00       	mov    $0x803c54,%ebx
  80028d:	ba 04 00 00 00       	mov    $0x4,%edx
  800292:	89 c7                	mov    %eax,%edi
  800294:	89 de                	mov    %ebx,%esi
  800296:	89 d1                	mov    %edx,%ecx
  800298:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80029a:	8d 95 20 ff ff ff    	lea    -0xe0(%ebp),%edx
  8002a0:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8002a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002aa:	89 d7                	mov    %edx,%edi
  8002ac:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd1, 0);
  8002ae:	83 ec 08             	sub    $0x8,%esp
  8002b1:	6a 00                	push   $0x0
  8002b3:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
  8002b9:	50                   	push   %eax
  8002ba:	e8 58 26 00 00       	call   802917 <sys_utilities>
  8002bf:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(cons_mutex);
#endif

	/*[5] DECLARE FINISHING*/
#if USE_KERN_SEMAPHORE
	char signalCmd2[64] = "__KSem@1@Signal";
  8002c2:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  8002c8:	bb 94 3c 80 00       	mov    $0x803c94,%ebx
  8002cd:	ba 04 00 00 00       	mov    $0x4,%edx
  8002d2:	89 c7                	mov    %eax,%edi
  8002d4:	89 de                	mov    %ebx,%esi
  8002d6:	89 d1                	mov    %edx,%ecx
  8002d8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8002da:	8d 95 e0 fe ff ff    	lea    -0x120(%ebp),%edx
  8002e0:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8002e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ea:	89 d7                	mov    %edx,%edi
  8002ec:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd2, 0);
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	6a 00                	push   $0x0
  8002f3:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  8002f9:	50                   	push   %eax
  8002fa:	e8 18 26 00 00       	call   802917 <sys_utilities>
  8002ff:	83 c4 10             	add    $0x10,%esp
#else
	signal_semaphore(finished);
#endif
}
  800302:	90                   	nop
  800303:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800306:	5b                   	pop    %ebx
  800307:	5e                   	pop    %esi
  800308:	5f                   	pop    %edi
  800309:	5d                   	pop    %ebp
  80030a:	c3                   	ret    

0080030b <MSort>:


void MSort(int* A, int p, int r)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	3b 45 10             	cmp    0x10(%ebp),%eax
  800317:	7d 54                	jge    80036d <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  800319:	8b 55 0c             	mov    0xc(%ebp),%edx
  80031c:	8b 45 10             	mov    0x10(%ebp),%eax
  80031f:	01 d0                	add    %edx,%eax
  800321:	89 c2                	mov    %eax,%edx
  800323:	c1 ea 1f             	shr    $0x1f,%edx
  800326:	01 d0                	add    %edx,%eax
  800328:	d1 f8                	sar    %eax
  80032a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  80032d:	83 ec 04             	sub    $0x4,%esp
  800330:	ff 75 f4             	pushl  -0xc(%ebp)
  800333:	ff 75 0c             	pushl  0xc(%ebp)
  800336:	ff 75 08             	pushl  0x8(%ebp)
  800339:	e8 cd ff ff ff       	call   80030b <MSort>
  80033e:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  800341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800344:	40                   	inc    %eax
  800345:	83 ec 04             	sub    $0x4,%esp
  800348:	ff 75 10             	pushl  0x10(%ebp)
  80034b:	50                   	push   %eax
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 b7 ff ff ff       	call   80030b <MSort>
  800354:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  800357:	ff 75 10             	pushl  0x10(%ebp)
  80035a:	ff 75 f4             	pushl  -0xc(%ebp)
  80035d:	ff 75 0c             	pushl  0xc(%ebp)
  800360:	ff 75 08             	pushl  0x8(%ebp)
  800363:	e8 08 00 00 00       	call   800370 <Merge>
  800368:	83 c4 10             	add    $0x10,%esp
  80036b:	eb 01                	jmp    80036e <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80036d:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800376:	8b 45 10             	mov    0x10(%ebp),%eax
  800379:	2b 45 0c             	sub    0xc(%ebp),%eax
  80037c:	40                   	inc    %eax
  80037d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800380:	8b 45 14             	mov    0x14(%ebp),%eax
  800383:	2b 45 10             	sub    0x10(%ebp),%eax
  800386:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800389:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800390:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800397:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80039a:	c1 e0 02             	shl    $0x2,%eax
  80039d:	83 ec 0c             	sub    $0xc,%esp
  8003a0:	50                   	push   %eax
  8003a1:	e8 91 1a 00 00       	call   801e37 <malloc>
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  8003ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003af:	c1 e0 02             	shl    $0x2,%eax
  8003b2:	83 ec 0c             	sub    $0xc,%esp
  8003b5:	50                   	push   %eax
  8003b6:	e8 7c 1a 00 00       	call   801e37 <malloc>
  8003bb:	83 c4 10             	add    $0x10,%esp
  8003be:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8003c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8003c8:	eb 2f                	jmp    8003f9 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8003ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d7:	01 c2                	add    %eax,%edx
  8003d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003df:	01 c8                	add    %ecx,%eax
  8003e1:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003e6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 c8                	add    %ecx,%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8003f6:	ff 45 ec             	incl   -0x14(%ebp)
  8003f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003fc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003ff:	7c c9                	jl     8003ca <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800401:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800408:	eb 2a                	jmp    800434 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  80040a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80040d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800414:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800417:	01 c2                	add    %eax,%edx
  800419:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80041c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80041f:	01 c8                	add    %ecx,%eax
  800421:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800428:	8b 45 08             	mov    0x8(%ebp),%eax
  80042b:	01 c8                	add    %ecx,%eax
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800431:	ff 45 e8             	incl   -0x18(%ebp)
  800434:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800437:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80043a:	7c ce                	jl     80040a <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80043c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800442:	e9 0a 01 00 00       	jmp    800551 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  800447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80044a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80044d:	0f 8d 95 00 00 00    	jge    8004e8 <Merge+0x178>
  800453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800456:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800459:	0f 8d 89 00 00 00    	jge    8004e8 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80045f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800462:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800469:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80046c:	01 d0                	add    %edx,%eax
  80046e:	8b 10                	mov    (%eax),%edx
  800470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800473:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80047a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80047d:	01 c8                	add    %ecx,%eax
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	39 c2                	cmp    %eax,%edx
  800483:	7d 33                	jge    8004b8 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800485:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800488:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80048d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80049a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80049d:	8d 50 01             	lea    0x1(%eax),%edx
  8004a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8004a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004ad:	01 d0                	add    %edx,%eax
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8004b3:	e9 96 00 00 00       	jmp    80054e <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  8004b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004bb:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004d0:	8d 50 01             	lea    0x1(%eax),%edx
  8004d3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8004d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004e0:	01 d0                	add    %edx,%eax
  8004e2:	8b 00                	mov    (%eax),%eax
  8004e4:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8004e6:	eb 66                	jmp    80054e <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8004e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004eb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004ee:	7d 30                	jge    800520 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8004f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004f3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8004f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800508:	8d 50 01             	lea    0x1(%eax),%edx
  80050b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80050e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800515:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800518:	01 d0                	add    %edx,%eax
  80051a:	8b 00                	mov    (%eax),%eax
  80051c:	89 01                	mov    %eax,(%ecx)
  80051e:	eb 2e                	jmp    80054e <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800520:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800523:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800528:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800538:	8d 50 01             	lea    0x1(%eax),%edx
  80053b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80053e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800545:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800548:	01 d0                	add    %edx,%eax
  80054a:	8b 00                	mov    (%eax),%eax
  80054c:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80054e:	ff 45 e4             	incl   -0x1c(%ebp)
  800551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800554:	3b 45 14             	cmp    0x14(%ebp),%eax
  800557:	0f 8e ea fe ff ff    	jle    800447 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  80055d:	83 ec 0c             	sub    $0xc,%esp
  800560:	ff 75 d8             	pushl  -0x28(%ebp)
  800563:	e8 53 1a 00 00       	call   801fbb <free>
  800568:	83 c4 10             	add    $0x10,%esp
	free(Right);
  80056b:	83 ec 0c             	sub    $0xc,%esp
  80056e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800571:	e8 45 1a 00 00       	call   801fbb <free>
  800576:	83 c4 10             	add    $0x10,%esp

}
  800579:	90                   	nop
  80057a:	c9                   	leave  
  80057b:	c3                   	ret    

0080057c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
  80057f:	57                   	push   %edi
  800580:	56                   	push   %esi
  800581:	53                   	push   %ebx
  800582:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800585:	e8 57 21 00 00       	call   8026e1 <sys_getenvindex>
  80058a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80058d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800590:	89 d0                	mov    %edx,%eax
  800592:	01 c0                	add    %eax,%eax
  800594:	01 d0                	add    %edx,%eax
  800596:	c1 e0 02             	shl    $0x2,%eax
  800599:	01 d0                	add    %edx,%eax
  80059b:	c1 e0 02             	shl    $0x2,%eax
  80059e:	01 d0                	add    %edx,%eax
  8005a0:	c1 e0 03             	shl    $0x3,%eax
  8005a3:	01 d0                	add    %edx,%eax
  8005a5:	c1 e0 02             	shl    $0x2,%eax
  8005a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005ad:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b7:	8a 40 20             	mov    0x20(%eax),%al
  8005ba:	84 c0                	test   %al,%al
  8005bc:	74 0d                	je     8005cb <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8005be:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c3:	83 c0 20             	add    $0x20,%eax
  8005c6:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005cf:	7e 0a                	jle    8005db <libmain+0x5f>
		binaryname = argv[0];
  8005d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8005db:	83 ec 08             	sub    $0x8,%esp
  8005de:	ff 75 0c             	pushl  0xc(%ebp)
  8005e1:	ff 75 08             	pushl  0x8(%ebp)
  8005e4:	e8 28 fb ff ff       	call   800111 <_main>
  8005e9:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8005ec:	a1 00 50 80 00       	mov    0x805000,%eax
  8005f1:	85 c0                	test   %eax,%eax
  8005f3:	0f 84 01 01 00 00    	je     8006fa <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8005f9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8005ff:	bb cc 3d 80 00       	mov    $0x803dcc,%ebx
  800604:	ba 0e 00 00 00       	mov    $0xe,%edx
  800609:	89 c7                	mov    %eax,%edi
  80060b:	89 de                	mov    %ebx,%esi
  80060d:	89 d1                	mov    %edx,%ecx
  80060f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800611:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800614:	b9 56 00 00 00       	mov    $0x56,%ecx
  800619:	b0 00                	mov    $0x0,%al
  80061b:	89 d7                	mov    %edx,%edi
  80061d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80061f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800626:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800629:	83 ec 08             	sub    $0x8,%esp
  80062c:	50                   	push   %eax
  80062d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800633:	50                   	push   %eax
  800634:	e8 de 22 00 00       	call   802917 <sys_utilities>
  800639:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80063c:	e8 27 1e 00 00       	call   802468 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800641:	83 ec 0c             	sub    $0xc,%esp
  800644:	68 ec 3c 80 00       	push   $0x803cec
  800649:	e8 be 01 00 00       	call   80080c <cprintf>
  80064e:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800651:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800654:	85 c0                	test   %eax,%eax
  800656:	74 18                	je     800670 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800658:	e8 d8 22 00 00       	call   802935 <sys_get_optimal_num_faults>
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	50                   	push   %eax
  800661:	68 14 3d 80 00       	push   $0x803d14
  800666:	e8 a1 01 00 00       	call   80080c <cprintf>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	eb 59                	jmp    8006c9 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800670:	a1 20 50 80 00       	mov    0x805020,%eax
  800675:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80067b:	a1 20 50 80 00       	mov    0x805020,%eax
  800680:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	68 38 3d 80 00       	push   $0x803d38
  800690:	e8 77 01 00 00       	call   80080c <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800698:	a1 20 50 80 00       	mov    0x805020,%eax
  80069d:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8006a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a8:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8006ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b3:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8006b9:	51                   	push   %ecx
  8006ba:	52                   	push   %edx
  8006bb:	50                   	push   %eax
  8006bc:	68 60 3d 80 00       	push   $0x803d60
  8006c1:	e8 46 01 00 00       	call   80080c <cprintf>
  8006c6:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8006ce:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	50                   	push   %eax
  8006d8:	68 b8 3d 80 00       	push   $0x803db8
  8006dd:	e8 2a 01 00 00       	call   80080c <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8006e5:	83 ec 0c             	sub    $0xc,%esp
  8006e8:	68 ec 3c 80 00       	push   $0x803cec
  8006ed:	e8 1a 01 00 00       	call   80080c <cprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8006f5:	e8 88 1d 00 00       	call   802482 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8006fa:	e8 1f 00 00 00       	call   80071e <exit>
}
  8006ff:	90                   	nop
  800700:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800703:	5b                   	pop    %ebx
  800704:	5e                   	pop    %esi
  800705:	5f                   	pop    %edi
  800706:	5d                   	pop    %ebp
  800707:	c3                   	ret    

00800708 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800708:	55                   	push   %ebp
  800709:	89 e5                	mov    %esp,%ebp
  80070b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80070e:	83 ec 0c             	sub    $0xc,%esp
  800711:	6a 00                	push   $0x0
  800713:	e8 95 1f 00 00       	call   8026ad <sys_destroy_env>
  800718:	83 c4 10             	add    $0x10,%esp
}
  80071b:	90                   	nop
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <exit>:

void
exit(void)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800724:	e8 ea 1f 00 00       	call   802713 <sys_exit_env>
}
  800729:	90                   	nop
  80072a:	c9                   	leave  
  80072b:	c3                   	ret    

0080072c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80072c:	55                   	push   %ebp
  80072d:	89 e5                	mov    %esp,%ebp
  80072f:	53                   	push   %ebx
  800730:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800733:	8b 45 0c             	mov    0xc(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	8d 48 01             	lea    0x1(%eax),%ecx
  80073b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073e:	89 0a                	mov    %ecx,(%edx)
  800740:	8b 55 08             	mov    0x8(%ebp),%edx
  800743:	88 d1                	mov    %dl,%cl
  800745:	8b 55 0c             	mov    0xc(%ebp),%edx
  800748:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80074c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	3d ff 00 00 00       	cmp    $0xff,%eax
  800756:	75 30                	jne    800788 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800758:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  80075e:	a0 44 50 80 00       	mov    0x805044,%al
  800763:	0f b6 c0             	movzbl %al,%eax
  800766:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800769:	8b 09                	mov    (%ecx),%ecx
  80076b:	89 cb                	mov    %ecx,%ebx
  80076d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800770:	83 c1 08             	add    $0x8,%ecx
  800773:	52                   	push   %edx
  800774:	50                   	push   %eax
  800775:	53                   	push   %ebx
  800776:	51                   	push   %ecx
  800777:	e8 a8 1c 00 00       	call   802424 <sys_cputs>
  80077c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80077f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800782:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078b:	8b 40 04             	mov    0x4(%eax),%eax
  80078e:	8d 50 01             	lea    0x1(%eax),%edx
  800791:	8b 45 0c             	mov    0xc(%ebp),%eax
  800794:	89 50 04             	mov    %edx,0x4(%eax)
}
  800797:	90                   	nop
  800798:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80079b:	c9                   	leave  
  80079c:	c3                   	ret    

0080079d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007a6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007ad:	00 00 00 
	b.cnt = 0;
  8007b0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007b7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007ba:	ff 75 0c             	pushl  0xc(%ebp)
  8007bd:	ff 75 08             	pushl  0x8(%ebp)
  8007c0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007c6:	50                   	push   %eax
  8007c7:	68 2c 07 80 00       	push   $0x80072c
  8007cc:	e8 5a 02 00 00       	call   800a2b <vprintfmt>
  8007d1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8007d4:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  8007da:	a0 44 50 80 00       	mov    0x805044,%al
  8007df:	0f b6 c0             	movzbl %al,%eax
  8007e2:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8007e8:	52                   	push   %edx
  8007e9:	50                   	push   %eax
  8007ea:	51                   	push   %ecx
  8007eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007f1:	83 c0 08             	add    $0x8,%eax
  8007f4:	50                   	push   %eax
  8007f5:	e8 2a 1c 00 00       	call   802424 <sys_cputs>
  8007fa:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007fd:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800804:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80080a:	c9                   	leave  
  80080b:	c3                   	ret    

0080080c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800812:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800819:	8d 45 0c             	lea    0xc(%ebp),%eax
  80081c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 f4             	pushl  -0xc(%ebp)
  800828:	50                   	push   %eax
  800829:	e8 6f ff ff ff       	call   80079d <vcprintf>
  80082e:	83 c4 10             	add    $0x10,%esp
  800831:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800834:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800837:	c9                   	leave  
  800838:	c3                   	ret    

00800839 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80083f:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	c1 e0 08             	shl    $0x8,%eax
  80084c:	a3 18 d1 81 00       	mov    %eax,0x81d118
	va_start(ap, fmt);
  800851:	8d 45 0c             	lea    0xc(%ebp),%eax
  800854:	83 c0 04             	add    $0x4,%eax
  800857:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80085a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	ff 75 f4             	pushl  -0xc(%ebp)
  800863:	50                   	push   %eax
  800864:	e8 34 ff ff ff       	call   80079d <vcprintf>
  800869:	83 c4 10             	add    $0x10,%esp
  80086c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80086f:	c7 05 18 d1 81 00 00 	movl   $0x700,0x81d118
  800876:	07 00 00 

	return cnt;
  800879:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80087c:	c9                   	leave  
  80087d:	c3                   	ret    

0080087e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800884:	e8 df 1b 00 00       	call   802468 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800889:	8d 45 0c             	lea    0xc(%ebp),%eax
  80088c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	83 ec 08             	sub    $0x8,%esp
  800895:	ff 75 f4             	pushl  -0xc(%ebp)
  800898:	50                   	push   %eax
  800899:	e8 ff fe ff ff       	call   80079d <vcprintf>
  80089e:	83 c4 10             	add    $0x10,%esp
  8008a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8008a4:	e8 d9 1b 00 00       	call   802482 <sys_unlock_cons>
	return cnt;
  8008a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008ac:	c9                   	leave  
  8008ad:	c3                   	ret    

008008ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	53                   	push   %ebx
  8008b2:	83 ec 14             	sub    $0x14,%esp
  8008b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8008c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008cc:	77 55                	ja     800923 <printnum+0x75>
  8008ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008d1:	72 05                	jb     8008d8 <printnum+0x2a>
  8008d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008d6:	77 4b                	ja     800923 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008de:	8b 45 18             	mov    0x18(%ebp),%eax
  8008e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e6:	52                   	push   %edx
  8008e7:	50                   	push   %eax
  8008e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8008eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ee:	e8 e1 2f 00 00       	call   8038d4 <__udivdi3>
  8008f3:	83 c4 10             	add    $0x10,%esp
  8008f6:	83 ec 04             	sub    $0x4,%esp
  8008f9:	ff 75 20             	pushl  0x20(%ebp)
  8008fc:	53                   	push   %ebx
  8008fd:	ff 75 18             	pushl  0x18(%ebp)
  800900:	52                   	push   %edx
  800901:	50                   	push   %eax
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	ff 75 08             	pushl  0x8(%ebp)
  800908:	e8 a1 ff ff ff       	call   8008ae <printnum>
  80090d:	83 c4 20             	add    $0x20,%esp
  800910:	eb 1a                	jmp    80092c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	ff 75 20             	pushl  0x20(%ebp)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800923:	ff 4d 1c             	decl   0x1c(%ebp)
  800926:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80092a:	7f e6                	jg     800912 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80092c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80092f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800937:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80093a:	53                   	push   %ebx
  80093b:	51                   	push   %ecx
  80093c:	52                   	push   %edx
  80093d:	50                   	push   %eax
  80093e:	e8 a1 30 00 00       	call   8039e4 <__umoddi3>
  800943:	83 c4 10             	add    $0x10,%esp
  800946:	05 54 40 80 00       	add    $0x804054,%eax
  80094b:	8a 00                	mov    (%eax),%al
  80094d:	0f be c0             	movsbl %al,%eax
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	ff 75 0c             	pushl  0xc(%ebp)
  800956:	50                   	push   %eax
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	ff d0                	call   *%eax
  80095c:	83 c4 10             	add    $0x10,%esp
}
  80095f:	90                   	nop
  800960:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800963:	c9                   	leave  
  800964:	c3                   	ret    

00800965 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800968:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80096c:	7e 1c                	jle    80098a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	8b 00                	mov    (%eax),%eax
  800973:	8d 50 08             	lea    0x8(%eax),%edx
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	89 10                	mov    %edx,(%eax)
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	8b 00                	mov    (%eax),%eax
  800980:	83 e8 08             	sub    $0x8,%eax
  800983:	8b 50 04             	mov    0x4(%eax),%edx
  800986:	8b 00                	mov    (%eax),%eax
  800988:	eb 40                	jmp    8009ca <getuint+0x65>
	else if (lflag)
  80098a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80098e:	74 1e                	je     8009ae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	8d 50 04             	lea    0x4(%eax),%edx
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	89 10                	mov    %edx,(%eax)
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	8b 00                	mov    (%eax),%eax
  8009a2:	83 e8 04             	sub    $0x4,%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ac:	eb 1c                	jmp    8009ca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	8b 00                	mov    (%eax),%eax
  8009b3:	8d 50 04             	lea    0x4(%eax),%edx
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	89 10                	mov    %edx,(%eax)
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	83 e8 04             	sub    $0x4,%eax
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009d3:	7e 1c                	jle    8009f1 <getint+0x25>
		return va_arg(*ap, long long);
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	8b 00                	mov    (%eax),%eax
  8009da:	8d 50 08             	lea    0x8(%eax),%edx
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	89 10                	mov    %edx,(%eax)
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	8b 00                	mov    (%eax),%eax
  8009e7:	83 e8 08             	sub    $0x8,%eax
  8009ea:	8b 50 04             	mov    0x4(%eax),%edx
  8009ed:	8b 00                	mov    (%eax),%eax
  8009ef:	eb 38                	jmp    800a29 <getint+0x5d>
	else if (lflag)
  8009f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009f5:	74 1a                	je     800a11 <getint+0x45>
		return va_arg(*ap, long);
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	8b 00                	mov    (%eax),%eax
  8009fc:	8d 50 04             	lea    0x4(%eax),%edx
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	89 10                	mov    %edx,(%eax)
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	8b 00                	mov    (%eax),%eax
  800a09:	83 e8 04             	sub    $0x4,%eax
  800a0c:	8b 00                	mov    (%eax),%eax
  800a0e:	99                   	cltd   
  800a0f:	eb 18                	jmp    800a29 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8b 00                	mov    (%eax),%eax
  800a16:	8d 50 04             	lea    0x4(%eax),%edx
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	89 10                	mov    %edx,(%eax)
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	8b 00                	mov    (%eax),%eax
  800a23:	83 e8 04             	sub    $0x4,%eax
  800a26:	8b 00                	mov    (%eax),%eax
  800a28:	99                   	cltd   
}
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	56                   	push   %esi
  800a2f:	53                   	push   %ebx
  800a30:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a33:	eb 17                	jmp    800a4c <vprintfmt+0x21>
			if (ch == '\0')
  800a35:	85 db                	test   %ebx,%ebx
  800a37:	0f 84 c1 03 00 00    	je     800dfe <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a3d:	83 ec 08             	sub    $0x8,%esp
  800a40:	ff 75 0c             	pushl  0xc(%ebp)
  800a43:	53                   	push   %ebx
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	ff d0                	call   *%eax
  800a49:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4f:	8d 50 01             	lea    0x1(%eax),%edx
  800a52:	89 55 10             	mov    %edx,0x10(%ebp)
  800a55:	8a 00                	mov    (%eax),%al
  800a57:	0f b6 d8             	movzbl %al,%ebx
  800a5a:	83 fb 25             	cmp    $0x25,%ebx
  800a5d:	75 d6                	jne    800a35 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a5f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a63:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a6a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a71:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a78:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a82:	8d 50 01             	lea    0x1(%eax),%edx
  800a85:	89 55 10             	mov    %edx,0x10(%ebp)
  800a88:	8a 00                	mov    (%eax),%al
  800a8a:	0f b6 d8             	movzbl %al,%ebx
  800a8d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a90:	83 f8 5b             	cmp    $0x5b,%eax
  800a93:	0f 87 3d 03 00 00    	ja     800dd6 <vprintfmt+0x3ab>
  800a99:	8b 04 85 78 40 80 00 	mov    0x804078(,%eax,4),%eax
  800aa0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800aa2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800aa6:	eb d7                	jmp    800a7f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aa8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800aac:	eb d1                	jmp    800a7f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ab5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ab8:	89 d0                	mov    %edx,%eax
  800aba:	c1 e0 02             	shl    $0x2,%eax
  800abd:	01 d0                	add    %edx,%eax
  800abf:	01 c0                	add    %eax,%eax
  800ac1:	01 d8                	add    %ebx,%eax
  800ac3:	83 e8 30             	sub    $0x30,%eax
  800ac6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ac9:	8b 45 10             	mov    0x10(%ebp),%eax
  800acc:	8a 00                	mov    (%eax),%al
  800ace:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ad1:	83 fb 2f             	cmp    $0x2f,%ebx
  800ad4:	7e 3e                	jle    800b14 <vprintfmt+0xe9>
  800ad6:	83 fb 39             	cmp    $0x39,%ebx
  800ad9:	7f 39                	jg     800b14 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800adb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ade:	eb d5                	jmp    800ab5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ae0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae3:	83 c0 04             	add    $0x4,%eax
  800ae6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aec:	83 e8 04             	sub    $0x4,%eax
  800aef:	8b 00                	mov    (%eax),%eax
  800af1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800af4:	eb 1f                	jmp    800b15 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800af6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800afa:	79 83                	jns    800a7f <vprintfmt+0x54>
				width = 0;
  800afc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b03:	e9 77 ff ff ff       	jmp    800a7f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b08:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b0f:	e9 6b ff ff ff       	jmp    800a7f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b14:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b19:	0f 89 60 ff ff ff    	jns    800a7f <vprintfmt+0x54>
				width = precision, precision = -1;
  800b1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b25:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b2c:	e9 4e ff ff ff       	jmp    800a7f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b31:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b34:	e9 46 ff ff ff       	jmp    800a7f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b39:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3c:	83 c0 04             	add    $0x4,%eax
  800b3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b42:	8b 45 14             	mov    0x14(%ebp),%eax
  800b45:	83 e8 04             	sub    $0x4,%eax
  800b48:	8b 00                	mov    (%eax),%eax
  800b4a:	83 ec 08             	sub    $0x8,%esp
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	50                   	push   %eax
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	ff d0                	call   *%eax
  800b56:	83 c4 10             	add    $0x10,%esp
			break;
  800b59:	e9 9b 02 00 00       	jmp    800df9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b61:	83 c0 04             	add    $0x4,%eax
  800b64:	89 45 14             	mov    %eax,0x14(%ebp)
  800b67:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6a:	83 e8 04             	sub    $0x4,%eax
  800b6d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b6f:	85 db                	test   %ebx,%ebx
  800b71:	79 02                	jns    800b75 <vprintfmt+0x14a>
				err = -err;
  800b73:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b75:	83 fb 64             	cmp    $0x64,%ebx
  800b78:	7f 0b                	jg     800b85 <vprintfmt+0x15a>
  800b7a:	8b 34 9d c0 3e 80 00 	mov    0x803ec0(,%ebx,4),%esi
  800b81:	85 f6                	test   %esi,%esi
  800b83:	75 19                	jne    800b9e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b85:	53                   	push   %ebx
  800b86:	68 65 40 80 00       	push   $0x804065
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	ff 75 08             	pushl  0x8(%ebp)
  800b91:	e8 70 02 00 00       	call   800e06 <printfmt>
  800b96:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b99:	e9 5b 02 00 00       	jmp    800df9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b9e:	56                   	push   %esi
  800b9f:	68 6e 40 80 00       	push   $0x80406e
  800ba4:	ff 75 0c             	pushl  0xc(%ebp)
  800ba7:	ff 75 08             	pushl  0x8(%ebp)
  800baa:	e8 57 02 00 00       	call   800e06 <printfmt>
  800baf:	83 c4 10             	add    $0x10,%esp
			break;
  800bb2:	e9 42 02 00 00       	jmp    800df9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bba:	83 c0 04             	add    $0x4,%eax
  800bbd:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc3:	83 e8 04             	sub    $0x4,%eax
  800bc6:	8b 30                	mov    (%eax),%esi
  800bc8:	85 f6                	test   %esi,%esi
  800bca:	75 05                	jne    800bd1 <vprintfmt+0x1a6>
				p = "(null)";
  800bcc:	be 71 40 80 00       	mov    $0x804071,%esi
			if (width > 0 && padc != '-')
  800bd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd5:	7e 6d                	jle    800c44 <vprintfmt+0x219>
  800bd7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bdb:	74 67                	je     800c44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800be0:	83 ec 08             	sub    $0x8,%esp
  800be3:	50                   	push   %eax
  800be4:	56                   	push   %esi
  800be5:	e8 1e 03 00 00       	call   800f08 <strnlen>
  800bea:	83 c4 10             	add    $0x10,%esp
  800bed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bf0:	eb 16                	jmp    800c08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bf2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	ff d0                	call   *%eax
  800c02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c05:	ff 4d e4             	decl   -0x1c(%ebp)
  800c08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c0c:	7f e4                	jg     800bf2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c0e:	eb 34                	jmp    800c44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c14:	74 1c                	je     800c32 <vprintfmt+0x207>
  800c16:	83 fb 1f             	cmp    $0x1f,%ebx
  800c19:	7e 05                	jle    800c20 <vprintfmt+0x1f5>
  800c1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800c1e:	7e 12                	jle    800c32 <vprintfmt+0x207>
					putch('?', putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	6a 3f                	push   $0x3f
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	ff d0                	call   *%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
  800c30:	eb 0f                	jmp    800c41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	53                   	push   %ebx
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	ff d0                	call   *%eax
  800c3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c41:	ff 4d e4             	decl   -0x1c(%ebp)
  800c44:	89 f0                	mov    %esi,%eax
  800c46:	8d 70 01             	lea    0x1(%eax),%esi
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	0f be d8             	movsbl %al,%ebx
  800c4e:	85 db                	test   %ebx,%ebx
  800c50:	74 24                	je     800c76 <vprintfmt+0x24b>
  800c52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c56:	78 b8                	js     800c10 <vprintfmt+0x1e5>
  800c58:	ff 4d e0             	decl   -0x20(%ebp)
  800c5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c5f:	79 af                	jns    800c10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c61:	eb 13                	jmp    800c76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c63:	83 ec 08             	sub    $0x8,%esp
  800c66:	ff 75 0c             	pushl  0xc(%ebp)
  800c69:	6a 20                	push   $0x20
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	ff d0                	call   *%eax
  800c70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c73:	ff 4d e4             	decl   -0x1c(%ebp)
  800c76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7a:	7f e7                	jg     800c63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c7c:	e9 78 01 00 00       	jmp    800df9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c81:	83 ec 08             	sub    $0x8,%esp
  800c84:	ff 75 e8             	pushl  -0x18(%ebp)
  800c87:	8d 45 14             	lea    0x14(%ebp),%eax
  800c8a:	50                   	push   %eax
  800c8b:	e8 3c fd ff ff       	call   8009cc <getint>
  800c90:	83 c4 10             	add    $0x10,%esp
  800c93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c9f:	85 d2                	test   %edx,%edx
  800ca1:	79 23                	jns    800cc6 <vprintfmt+0x29b>
				putch('-', putdat);
  800ca3:	83 ec 08             	sub    $0x8,%esp
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	6a 2d                	push   $0x2d
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	ff d0                	call   *%eax
  800cb0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb9:	f7 d8                	neg    %eax
  800cbb:	83 d2 00             	adc    $0x0,%edx
  800cbe:	f7 da                	neg    %edx
  800cc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cc6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ccd:	e9 bc 00 00 00       	jmp    800d8e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800cd2:	83 ec 08             	sub    $0x8,%esp
  800cd5:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd8:	8d 45 14             	lea    0x14(%ebp),%eax
  800cdb:	50                   	push   %eax
  800cdc:	e8 84 fc ff ff       	call   800965 <getuint>
  800ce1:	83 c4 10             	add    $0x10,%esp
  800ce4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cf1:	e9 98 00 00 00       	jmp    800d8e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cf6:	83 ec 08             	sub    $0x8,%esp
  800cf9:	ff 75 0c             	pushl  0xc(%ebp)
  800cfc:	6a 58                	push   $0x58
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	ff d0                	call   *%eax
  800d03:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d06:	83 ec 08             	sub    $0x8,%esp
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	6a 58                	push   $0x58
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	ff d0                	call   *%eax
  800d13:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d16:	83 ec 08             	sub    $0x8,%esp
  800d19:	ff 75 0c             	pushl  0xc(%ebp)
  800d1c:	6a 58                	push   $0x58
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	ff d0                	call   *%eax
  800d23:	83 c4 10             	add    $0x10,%esp
			break;
  800d26:	e9 ce 00 00 00       	jmp    800df9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d2b:	83 ec 08             	sub    $0x8,%esp
  800d2e:	ff 75 0c             	pushl  0xc(%ebp)
  800d31:	6a 30                	push   $0x30
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	ff d0                	call   *%eax
  800d38:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d3b:	83 ec 08             	sub    $0x8,%esp
  800d3e:	ff 75 0c             	pushl  0xc(%ebp)
  800d41:	6a 78                	push   $0x78
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	ff d0                	call   *%eax
  800d48:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4e:	83 c0 04             	add    $0x4,%eax
  800d51:	89 45 14             	mov    %eax,0x14(%ebp)
  800d54:	8b 45 14             	mov    0x14(%ebp),%eax
  800d57:	83 e8 04             	sub    $0x4,%eax
  800d5a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d66:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d6d:	eb 1f                	jmp    800d8e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d6f:	83 ec 08             	sub    $0x8,%esp
  800d72:	ff 75 e8             	pushl  -0x18(%ebp)
  800d75:	8d 45 14             	lea    0x14(%ebp),%eax
  800d78:	50                   	push   %eax
  800d79:	e8 e7 fb ff ff       	call   800965 <getuint>
  800d7e:	83 c4 10             	add    $0x10,%esp
  800d81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d87:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d8e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d95:	83 ec 04             	sub    $0x4,%esp
  800d98:	52                   	push   %edx
  800d99:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d9c:	50                   	push   %eax
  800d9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800da0:	ff 75 f0             	pushl  -0x10(%ebp)
  800da3:	ff 75 0c             	pushl  0xc(%ebp)
  800da6:	ff 75 08             	pushl  0x8(%ebp)
  800da9:	e8 00 fb ff ff       	call   8008ae <printnum>
  800dae:	83 c4 20             	add    $0x20,%esp
			break;
  800db1:	eb 46                	jmp    800df9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 0c             	pushl  0xc(%ebp)
  800db9:	53                   	push   %ebx
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	ff d0                	call   *%eax
  800dbf:	83 c4 10             	add    $0x10,%esp
			break;
  800dc2:	eb 35                	jmp    800df9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800dc4:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800dcb:	eb 2c                	jmp    800df9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800dcd:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800dd4:	eb 23                	jmp    800df9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dd6:	83 ec 08             	sub    $0x8,%esp
  800dd9:	ff 75 0c             	pushl  0xc(%ebp)
  800ddc:	6a 25                	push   $0x25
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	ff d0                	call   *%eax
  800de3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800de6:	ff 4d 10             	decl   0x10(%ebp)
  800de9:	eb 03                	jmp    800dee <vprintfmt+0x3c3>
  800deb:	ff 4d 10             	decl   0x10(%ebp)
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	48                   	dec    %eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3c 25                	cmp    $0x25,%al
  800df6:	75 f3                	jne    800deb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800df8:	90                   	nop
		}
	}
  800df9:	e9 35 fc ff ff       	jmp    800a33 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dfe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0f:	83 c0 04             	add    $0x4,%eax
  800e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	ff 75 08             	pushl  0x8(%ebp)
  800e22:	e8 04 fc ff ff       	call   800a2b <vprintfmt>
  800e27:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e2a:	90                   	nop
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	8b 40 08             	mov    0x8(%eax),%eax
  800e36:	8d 50 01             	lea    0x1(%eax),%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	8b 10                	mov    (%eax),%edx
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8b 40 04             	mov    0x4(%eax),%eax
  800e4a:	39 c2                	cmp    %eax,%edx
  800e4c:	73 12                	jae    800e60 <sprintputch+0x33>
		*b->buf++ = ch;
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	8b 00                	mov    (%eax),%eax
  800e53:	8d 48 01             	lea    0x1(%eax),%ecx
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	89 0a                	mov    %ecx,(%edx)
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	88 10                	mov    %dl,(%eax)
}
  800e60:	90                   	nop
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e88:	74 06                	je     800e90 <vsnprintf+0x2d>
  800e8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8e:	7f 07                	jg     800e97 <vsnprintf+0x34>
		return -E_INVAL;
  800e90:	b8 03 00 00 00       	mov    $0x3,%eax
  800e95:	eb 20                	jmp    800eb7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e97:	ff 75 14             	pushl  0x14(%ebp)
  800e9a:	ff 75 10             	pushl  0x10(%ebp)
  800e9d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ea0:	50                   	push   %eax
  800ea1:	68 2d 0e 80 00       	push   $0x800e2d
  800ea6:	e8 80 fb ff ff       	call   800a2b <vprintfmt>
  800eab:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eb1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ebf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ec2:	83 c0 04             	add    $0x4,%eax
  800ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	ff 75 0c             	pushl  0xc(%ebp)
  800ed2:	ff 75 08             	pushl  0x8(%ebp)
  800ed5:	e8 89 ff ff ff       	call   800e63 <vsnprintf>
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ee3:	c9                   	leave  
  800ee4:	c3                   	ret    

00800ee5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800eeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef2:	eb 06                	jmp    800efa <strlen+0x15>
		n++;
  800ef4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	84 c0                	test   %al,%al
  800f01:	75 f1                	jne    800ef4 <strlen+0xf>
		n++;
	return n;
  800f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f15:	eb 09                	jmp    800f20 <strnlen+0x18>
		n++;
  800f17:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	ff 4d 0c             	decl   0xc(%ebp)
  800f20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f24:	74 09                	je     800f2f <strnlen+0x27>
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	84 c0                	test   %al,%al
  800f2d:	75 e8                	jne    800f17 <strnlen+0xf>
		n++;
	return n;
  800f2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f40:	90                   	nop
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8d 50 01             	lea    0x1(%eax),%edx
  800f47:	89 55 08             	mov    %edx,0x8(%ebp)
  800f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f50:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f53:	8a 12                	mov    (%edx),%dl
  800f55:	88 10                	mov    %dl,(%eax)
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	84 c0                	test   %al,%al
  800f5b:	75 e4                	jne    800f41 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f75:	eb 1f                	jmp    800f96 <strncpy+0x34>
		*dst++ = *src;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8d 50 01             	lea    0x1(%eax),%edx
  800f7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f83:	8a 12                	mov    (%edx),%dl
  800f85:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	84 c0                	test   %al,%al
  800f8e:	74 03                	je     800f93 <strncpy+0x31>
			src++;
  800f90:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f93:	ff 45 fc             	incl   -0x4(%ebp)
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f9c:	72 d9                	jb     800f77 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa1:	c9                   	leave  
  800fa2:	c3                   	ret    

00800fa3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800faf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb3:	74 30                	je     800fe5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fb5:	eb 16                	jmp    800fcd <strlcpy+0x2a>
			*dst++ = *src++;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8d 50 01             	lea    0x1(%eax),%edx
  800fbd:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fc9:	8a 12                	mov    (%edx),%dl
  800fcb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fcd:	ff 4d 10             	decl   0x10(%ebp)
  800fd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd4:	74 09                	je     800fdf <strlcpy+0x3c>
  800fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	84 c0                	test   %al,%al
  800fdd:	75 d8                	jne    800fb7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800feb:	29 c2                	sub    %eax,%edx
  800fed:	89 d0                	mov    %edx,%eax
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ff4:	eb 06                	jmp    800ffc <strcmp+0xb>
		p++, q++;
  800ff6:	ff 45 08             	incl   0x8(%ebp)
  800ff9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	84 c0                	test   %al,%al
  801003:	74 0e                	je     801013 <strcmp+0x22>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 10                	mov    (%eax),%dl
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	38 c2                	cmp    %al,%dl
  801011:	74 e3                	je     800ff6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	0f b6 d0             	movzbl %al,%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	0f b6 c0             	movzbl %al,%eax
  801023:	29 c2                	sub    %eax,%edx
  801025:	89 d0                	mov    %edx,%eax
}
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80102c:	eb 09                	jmp    801037 <strncmp+0xe>
		n--, p++, q++;
  80102e:	ff 4d 10             	decl   0x10(%ebp)
  801031:	ff 45 08             	incl   0x8(%ebp)
  801034:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801037:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103b:	74 17                	je     801054 <strncmp+0x2b>
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	84 c0                	test   %al,%al
  801044:	74 0e                	je     801054 <strncmp+0x2b>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 10                	mov    (%eax),%dl
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	38 c2                	cmp    %al,%dl
  801052:	74 da                	je     80102e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801054:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801058:	75 07                	jne    801061 <strncmp+0x38>
		return 0;
  80105a:	b8 00 00 00 00       	mov    $0x0,%eax
  80105f:	eb 14                	jmp    801075 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	0f b6 d0             	movzbl %al,%edx
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	0f b6 c0             	movzbl %al,%eax
  801071:	29 c2                	sub    %eax,%edx
  801073:	89 d0                	mov    %edx,%eax
}
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 04             	sub    $0x4,%esp
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801083:	eb 12                	jmp    801097 <strchr+0x20>
		if (*s == c)
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80108d:	75 05                	jne    801094 <strchr+0x1d>
			return (char *) s;
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	eb 11                	jmp    8010a5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801094:	ff 45 08             	incl   0x8(%ebp)
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	84 c0                	test   %al,%al
  80109e:	75 e5                	jne    801085 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 04             	sub    $0x4,%esp
  8010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010b3:	eb 0d                	jmp    8010c2 <strfind+0x1b>
		if (*s == c)
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010bd:	74 0e                	je     8010cd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010bf:	ff 45 08             	incl   0x8(%ebp)
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	84 c0                	test   %al,%al
  8010c9:	75 ea                	jne    8010b5 <strfind+0xe>
  8010cb:	eb 01                	jmp    8010ce <strfind+0x27>
		if (*s == c)
			break;
  8010cd:	90                   	nop
	return (char *) s;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8010df:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010e3:	76 63                	jbe    801148 <memset+0x75>
		uint64 data_block = c;
  8010e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e8:	99                   	cltd   
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8010ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f5:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8010f9:	c1 e0 08             	shl    $0x8,%eax
  8010fc:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010ff:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801102:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801105:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801108:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80110c:	c1 e0 10             	shl    $0x10,%eax
  80110f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801112:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801115:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801118:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111b:	89 c2                	mov    %eax,%edx
  80111d:	b8 00 00 00 00       	mov    $0x0,%eax
  801122:	09 45 f0             	or     %eax,-0x10(%ebp)
  801125:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801128:	eb 18                	jmp    801142 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80112a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80112d:	8d 41 08             	lea    0x8(%ecx),%eax
  801130:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801136:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801139:	89 01                	mov    %eax,(%ecx)
  80113b:	89 51 04             	mov    %edx,0x4(%ecx)
  80113e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801142:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801146:	77 e2                	ja     80112a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801148:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114c:	74 23                	je     801171 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80114e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801151:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801154:	eb 0e                	jmp    801164 <memset+0x91>
			*p8++ = (uint8)c;
  801156:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801159:	8d 50 01             	lea    0x1(%eax),%edx
  80115c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80115f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801162:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116a:	89 55 10             	mov    %edx,0x10(%ebp)
  80116d:	85 c0                	test   %eax,%eax
  80116f:	75 e5                	jne    801156 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801188:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80118c:	76 24                	jbe    8011b2 <memcpy+0x3c>
		while(n >= 8){
  80118e:	eb 1c                	jmp    8011ac <memcpy+0x36>
			*d64 = *s64;
  801190:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801193:	8b 50 04             	mov    0x4(%eax),%edx
  801196:	8b 00                	mov    (%eax),%eax
  801198:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80119b:	89 01                	mov    %eax,(%ecx)
  80119d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8011a0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8011a4:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8011a8:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8011ac:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011b0:	77 de                	ja     801190 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8011b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b6:	74 31                	je     8011e9 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8011b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8011be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8011c4:	eb 16                	jmp    8011dc <memcpy+0x66>
			*d8++ = *s8++;
  8011c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c9:	8d 50 01             	lea    0x1(%eax),%edx
  8011cc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8011cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011d5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8011d8:	8a 12                	mov    (%edx),%dl
  8011da:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8011dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	75 dd                	jne    8011c6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801200:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801203:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801206:	73 50                	jae    801258 <memmove+0x6a>
  801208:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80120b:	8b 45 10             	mov    0x10(%ebp),%eax
  80120e:	01 d0                	add    %edx,%eax
  801210:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801213:	76 43                	jbe    801258 <memmove+0x6a>
		s += n;
  801215:	8b 45 10             	mov    0x10(%ebp),%eax
  801218:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80121b:	8b 45 10             	mov    0x10(%ebp),%eax
  80121e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801221:	eb 10                	jmp    801233 <memmove+0x45>
			*--d = *--s;
  801223:	ff 4d f8             	decl   -0x8(%ebp)
  801226:	ff 4d fc             	decl   -0x4(%ebp)
  801229:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122c:	8a 10                	mov    (%eax),%dl
  80122e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801231:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801233:	8b 45 10             	mov    0x10(%ebp),%eax
  801236:	8d 50 ff             	lea    -0x1(%eax),%edx
  801239:	89 55 10             	mov    %edx,0x10(%ebp)
  80123c:	85 c0                	test   %eax,%eax
  80123e:	75 e3                	jne    801223 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801240:	eb 23                	jmp    801265 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801242:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801245:	8d 50 01             	lea    0x1(%eax),%edx
  801248:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80124b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80124e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801251:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801254:	8a 12                	mov    (%edx),%dl
  801256:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801258:	8b 45 10             	mov    0x10(%ebp),%eax
  80125b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80125e:	89 55 10             	mov    %edx,0x10(%ebp)
  801261:	85 c0                	test   %eax,%eax
  801263:	75 dd                	jne    801242 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801268:	c9                   	leave  
  801269:	c3                   	ret    

0080126a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80127c:	eb 2a                	jmp    8012a8 <memcmp+0x3e>
		if (*s1 != *s2)
  80127e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801281:	8a 10                	mov    (%eax),%dl
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	38 c2                	cmp    %al,%dl
  80128a:	74 16                	je     8012a2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80128c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	0f b6 d0             	movzbl %al,%edx
  801294:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	0f b6 c0             	movzbl %al,%eax
  80129c:	29 c2                	sub    %eax,%edx
  80129e:	89 d0                	mov    %edx,%eax
  8012a0:	eb 18                	jmp    8012ba <memcmp+0x50>
		s1++, s2++;
  8012a2:	ff 45 fc             	incl   -0x4(%ebp)
  8012a5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b1:	85 c0                	test   %eax,%eax
  8012b3:	75 c9                	jne    80127e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8012c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c8:	01 d0                	add    %edx,%eax
  8012ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8012cd:	eb 15                	jmp    8012e4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	0f b6 d0             	movzbl %al,%edx
  8012d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012da:	0f b6 c0             	movzbl %al,%eax
  8012dd:	39 c2                	cmp    %eax,%edx
  8012df:	74 0d                	je     8012ee <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8012e1:	ff 45 08             	incl   0x8(%ebp)
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012ea:	72 e3                	jb     8012cf <memfind+0x13>
  8012ec:	eb 01                	jmp    8012ef <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8012ee:	90                   	nop
	return (void *) s;
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8012fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801301:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801308:	eb 03                	jmp    80130d <strtol+0x19>
		s++;
  80130a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	3c 20                	cmp    $0x20,%al
  801314:	74 f4                	je     80130a <strtol+0x16>
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	3c 09                	cmp    $0x9,%al
  80131d:	74 eb                	je     80130a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	3c 2b                	cmp    $0x2b,%al
  801326:	75 05                	jne    80132d <strtol+0x39>
		s++;
  801328:	ff 45 08             	incl   0x8(%ebp)
  80132b:	eb 13                	jmp    801340 <strtol+0x4c>
	else if (*s == '-')
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	3c 2d                	cmp    $0x2d,%al
  801334:	75 0a                	jne    801340 <strtol+0x4c>
		s++, neg = 1;
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801340:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801344:	74 06                	je     80134c <strtol+0x58>
  801346:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80134a:	75 20                	jne    80136c <strtol+0x78>
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	3c 30                	cmp    $0x30,%al
  801353:	75 17                	jne    80136c <strtol+0x78>
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	40                   	inc    %eax
  801359:	8a 00                	mov    (%eax),%al
  80135b:	3c 78                	cmp    $0x78,%al
  80135d:	75 0d                	jne    80136c <strtol+0x78>
		s += 2, base = 16;
  80135f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801363:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80136a:	eb 28                	jmp    801394 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80136c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801370:	75 15                	jne    801387 <strtol+0x93>
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	3c 30                	cmp    $0x30,%al
  801379:	75 0c                	jne    801387 <strtol+0x93>
		s++, base = 8;
  80137b:	ff 45 08             	incl   0x8(%ebp)
  80137e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801385:	eb 0d                	jmp    801394 <strtol+0xa0>
	else if (base == 0)
  801387:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138b:	75 07                	jne    801394 <strtol+0xa0>
		base = 10;
  80138d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	8a 00                	mov    (%eax),%al
  801399:	3c 2f                	cmp    $0x2f,%al
  80139b:	7e 19                	jle    8013b6 <strtol+0xc2>
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	8a 00                	mov    (%eax),%al
  8013a2:	3c 39                	cmp    $0x39,%al
  8013a4:	7f 10                	jg     8013b6 <strtol+0xc2>
			dig = *s - '0';
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a9:	8a 00                	mov    (%eax),%al
  8013ab:	0f be c0             	movsbl %al,%eax
  8013ae:	83 e8 30             	sub    $0x30,%eax
  8013b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013b4:	eb 42                	jmp    8013f8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	8a 00                	mov    (%eax),%al
  8013bb:	3c 60                	cmp    $0x60,%al
  8013bd:	7e 19                	jle    8013d8 <strtol+0xe4>
  8013bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c2:	8a 00                	mov    (%eax),%al
  8013c4:	3c 7a                	cmp    $0x7a,%al
  8013c6:	7f 10                	jg     8013d8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	0f be c0             	movsbl %al,%eax
  8013d0:	83 e8 57             	sub    $0x57,%eax
  8013d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013d6:	eb 20                	jmp    8013f8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	8a 00                	mov    (%eax),%al
  8013dd:	3c 40                	cmp    $0x40,%al
  8013df:	7e 39                	jle    80141a <strtol+0x126>
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	3c 5a                	cmp    $0x5a,%al
  8013e8:	7f 30                	jg     80141a <strtol+0x126>
			dig = *s - 'A' + 10;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f be c0             	movsbl %al,%eax
  8013f2:	83 e8 37             	sub    $0x37,%eax
  8013f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8013f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013fe:	7d 19                	jge    801419 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801400:	ff 45 08             	incl   0x8(%ebp)
  801403:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801406:	0f af 45 10          	imul   0x10(%ebp),%eax
  80140a:	89 c2                	mov    %eax,%edx
  80140c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140f:	01 d0                	add    %edx,%eax
  801411:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801414:	e9 7b ff ff ff       	jmp    801394 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801419:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80141a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80141e:	74 08                	je     801428 <strtol+0x134>
		*endptr = (char *) s;
  801420:	8b 45 0c             	mov    0xc(%ebp),%eax
  801423:	8b 55 08             	mov    0x8(%ebp),%edx
  801426:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801428:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80142c:	74 07                	je     801435 <strtol+0x141>
  80142e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801431:	f7 d8                	neg    %eax
  801433:	eb 03                	jmp    801438 <strtol+0x144>
  801435:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <ltostr>:

void
ltostr(long value, char *str)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801447:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80144e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801452:	79 13                	jns    801467 <ltostr+0x2d>
	{
		neg = 1;
  801454:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80145b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801461:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801464:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80146f:	99                   	cltd   
  801470:	f7 f9                	idiv   %ecx
  801472:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801475:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801478:	8d 50 01             	lea    0x1(%eax),%edx
  80147b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80147e:	89 c2                	mov    %eax,%edx
  801480:	8b 45 0c             	mov    0xc(%ebp),%eax
  801483:	01 d0                	add    %edx,%eax
  801485:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801488:	83 c2 30             	add    $0x30,%edx
  80148b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80148d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801490:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801495:	f7 e9                	imul   %ecx
  801497:	c1 fa 02             	sar    $0x2,%edx
  80149a:	89 c8                	mov    %ecx,%eax
  80149c:	c1 f8 1f             	sar    $0x1f,%eax
  80149f:	29 c2                	sub    %eax,%edx
  8014a1:	89 d0                	mov    %edx,%eax
  8014a3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8014a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014aa:	75 bb                	jne    801467 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8014ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8014b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b6:	48                   	dec    %eax
  8014b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8014ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014be:	74 3d                	je     8014fd <ltostr+0xc3>
		start = 1 ;
  8014c0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8014c7:	eb 34                	jmp    8014fd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8014c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	8a 00                	mov    (%eax),%al
  8014d3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8014d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dc:	01 c2                	add    %eax,%edx
  8014de:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	01 c8                	add    %ecx,%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8014ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f0:	01 c2                	add    %eax,%edx
  8014f2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8014f5:	88 02                	mov    %al,(%edx)
		start++ ;
  8014f7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8014fa:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8014fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801500:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801503:	7c c4                	jl     8014c9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801505:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	01 d0                	add    %edx,%eax
  80150d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801510:	90                   	nop
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801519:	ff 75 08             	pushl  0x8(%ebp)
  80151c:	e8 c4 f9 ff ff       	call   800ee5 <strlen>
  801521:	83 c4 04             	add    $0x4,%esp
  801524:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801527:	ff 75 0c             	pushl  0xc(%ebp)
  80152a:	e8 b6 f9 ff ff       	call   800ee5 <strlen>
  80152f:	83 c4 04             	add    $0x4,%esp
  801532:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801535:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80153c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801543:	eb 17                	jmp    80155c <strcconcat+0x49>
		final[s] = str1[s] ;
  801545:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801548:	8b 45 10             	mov    0x10(%ebp),%eax
  80154b:	01 c2                	add    %eax,%edx
  80154d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	01 c8                	add    %ecx,%eax
  801555:	8a 00                	mov    (%eax),%al
  801557:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801559:	ff 45 fc             	incl   -0x4(%ebp)
  80155c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801562:	7c e1                	jl     801545 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801564:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80156b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801572:	eb 1f                	jmp    801593 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801574:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801577:	8d 50 01             	lea    0x1(%eax),%edx
  80157a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80157d:	89 c2                	mov    %eax,%edx
  80157f:	8b 45 10             	mov    0x10(%ebp),%eax
  801582:	01 c2                	add    %eax,%edx
  801584:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158a:	01 c8                	add    %ecx,%eax
  80158c:	8a 00                	mov    (%eax),%al
  80158e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801590:	ff 45 f8             	incl   -0x8(%ebp)
  801593:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801596:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801599:	7c d9                	jl     801574 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80159b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159e:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a1:	01 d0                	add    %edx,%eax
  8015a3:	c6 00 00             	movb   $0x0,(%eax)
}
  8015a6:	90                   	nop
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8015ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8015af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8015b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b8:	8b 00                	mov    (%eax),%eax
  8015ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c4:	01 d0                	add    %edx,%eax
  8015c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015cc:	eb 0c                	jmp    8015da <strsplit+0x31>
			*string++ = 0;
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	8d 50 01             	lea    0x1(%eax),%edx
  8015d4:	89 55 08             	mov    %edx,0x8(%ebp)
  8015d7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	8a 00                	mov    (%eax),%al
  8015df:	84 c0                	test   %al,%al
  8015e1:	74 18                	je     8015fb <strsplit+0x52>
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	8a 00                	mov    (%eax),%al
  8015e8:	0f be c0             	movsbl %al,%eax
  8015eb:	50                   	push   %eax
  8015ec:	ff 75 0c             	pushl  0xc(%ebp)
  8015ef:	e8 83 fa ff ff       	call   801077 <strchr>
  8015f4:	83 c4 08             	add    $0x8,%esp
  8015f7:	85 c0                	test   %eax,%eax
  8015f9:	75 d3                	jne    8015ce <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	8a 00                	mov    (%eax),%al
  801600:	84 c0                	test   %al,%al
  801602:	74 5a                	je     80165e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801604:	8b 45 14             	mov    0x14(%ebp),%eax
  801607:	8b 00                	mov    (%eax),%eax
  801609:	83 f8 0f             	cmp    $0xf,%eax
  80160c:	75 07                	jne    801615 <strsplit+0x6c>
		{
			return 0;
  80160e:	b8 00 00 00 00       	mov    $0x0,%eax
  801613:	eb 66                	jmp    80167b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801615:	8b 45 14             	mov    0x14(%ebp),%eax
  801618:	8b 00                	mov    (%eax),%eax
  80161a:	8d 48 01             	lea    0x1(%eax),%ecx
  80161d:	8b 55 14             	mov    0x14(%ebp),%edx
  801620:	89 0a                	mov    %ecx,(%edx)
  801622:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801629:	8b 45 10             	mov    0x10(%ebp),%eax
  80162c:	01 c2                	add    %eax,%edx
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
  801631:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801633:	eb 03                	jmp    801638 <strsplit+0x8f>
			string++;
  801635:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	8a 00                	mov    (%eax),%al
  80163d:	84 c0                	test   %al,%al
  80163f:	74 8b                	je     8015cc <strsplit+0x23>
  801641:	8b 45 08             	mov    0x8(%ebp),%eax
  801644:	8a 00                	mov    (%eax),%al
  801646:	0f be c0             	movsbl %al,%eax
  801649:	50                   	push   %eax
  80164a:	ff 75 0c             	pushl  0xc(%ebp)
  80164d:	e8 25 fa ff ff       	call   801077 <strchr>
  801652:	83 c4 08             	add    $0x8,%esp
  801655:	85 c0                	test   %eax,%eax
  801657:	74 dc                	je     801635 <strsplit+0x8c>
			string++;
	}
  801659:	e9 6e ff ff ff       	jmp    8015cc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80165e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80165f:	8b 45 14             	mov    0x14(%ebp),%eax
  801662:	8b 00                	mov    (%eax),%eax
  801664:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80166b:	8b 45 10             	mov    0x10(%ebp),%eax
  80166e:	01 d0                	add    %edx,%eax
  801670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801676:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801689:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801690:	eb 4a                	jmp    8016dc <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801692:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	01 c2                	add    %eax,%edx
  80169a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80169d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a0:	01 c8                	add    %ecx,%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8016a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ac:	01 d0                	add    %edx,%eax
  8016ae:	8a 00                	mov    (%eax),%al
  8016b0:	3c 40                	cmp    $0x40,%al
  8016b2:	7e 25                	jle    8016d9 <str2lower+0x5c>
  8016b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ba:	01 d0                	add    %edx,%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	3c 5a                	cmp    $0x5a,%al
  8016c0:	7f 17                	jg     8016d9 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8016c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	01 d0                	add    %edx,%eax
  8016ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d0:	01 ca                	add    %ecx,%edx
  8016d2:	8a 12                	mov    (%edx),%dl
  8016d4:	83 c2 20             	add    $0x20,%edx
  8016d7:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8016d9:	ff 45 fc             	incl   -0x4(%ebp)
  8016dc:	ff 75 0c             	pushl  0xc(%ebp)
  8016df:	e8 01 f8 ff ff       	call   800ee5 <strlen>
  8016e4:	83 c4 04             	add    $0x4,%esp
  8016e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016ea:	7f a6                	jg     801692 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8016ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  8016f7:	83 ec 0c             	sub    $0xc,%esp
  8016fa:	6a 10                	push   $0x10
  8016fc:	e8 b2 15 00 00       	call   802cb3 <alloc_block>
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801707:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80170b:	75 14                	jne    801721 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  80170d:	83 ec 04             	sub    $0x4,%esp
  801710:	68 e8 41 80 00       	push   $0x8041e8
  801715:	6a 14                	push   $0x14
  801717:	68 11 42 80 00       	push   $0x804211
  80171c:	e8 a4 1f 00 00       	call   8036c5 <_panic>

	node->start = start;
  801721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801724:	8b 55 08             	mov    0x8(%ebp),%edx
  801727:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172f:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801732:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801739:	a1 24 50 80 00       	mov    0x805024,%eax
  80173e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801741:	eb 18                	jmp    80175b <insert_page_alloc+0x6a>
		if (start < it->start)
  801743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801746:	8b 00                	mov    (%eax),%eax
  801748:	3b 45 08             	cmp    0x8(%ebp),%eax
  80174b:	77 37                	ja     801784 <insert_page_alloc+0x93>
			break;
		prev = it;
  80174d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801750:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801753:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801758:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80175b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80175f:	74 08                	je     801769 <insert_page_alloc+0x78>
  801761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801764:	8b 40 08             	mov    0x8(%eax),%eax
  801767:	eb 05                	jmp    80176e <insert_page_alloc+0x7d>
  801769:	b8 00 00 00 00       	mov    $0x0,%eax
  80176e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801773:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801778:	85 c0                	test   %eax,%eax
  80177a:	75 c7                	jne    801743 <insert_page_alloc+0x52>
  80177c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801780:	75 c1                	jne    801743 <insert_page_alloc+0x52>
  801782:	eb 01                	jmp    801785 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801784:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801785:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801789:	75 64                	jne    8017ef <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  80178b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80178f:	75 14                	jne    8017a5 <insert_page_alloc+0xb4>
  801791:	83 ec 04             	sub    $0x4,%esp
  801794:	68 20 42 80 00       	push   $0x804220
  801799:	6a 21                	push   $0x21
  80179b:	68 11 42 80 00       	push   $0x804211
  8017a0:	e8 20 1f 00 00       	call   8036c5 <_panic>
  8017a5:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8017ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ae:	89 50 08             	mov    %edx,0x8(%eax)
  8017b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b4:	8b 40 08             	mov    0x8(%eax),%eax
  8017b7:	85 c0                	test   %eax,%eax
  8017b9:	74 0d                	je     8017c8 <insert_page_alloc+0xd7>
  8017bb:	a1 24 50 80 00       	mov    0x805024,%eax
  8017c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017c3:	89 50 0c             	mov    %edx,0xc(%eax)
  8017c6:	eb 08                	jmp    8017d0 <insert_page_alloc+0xdf>
  8017c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017cb:	a3 28 50 80 00       	mov    %eax,0x805028
  8017d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d3:	a3 24 50 80 00       	mov    %eax,0x805024
  8017d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017db:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8017e2:	a1 30 50 80 00       	mov    0x805030,%eax
  8017e7:	40                   	inc    %eax
  8017e8:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  8017ed:	eb 71                	jmp    801860 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  8017ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017f3:	74 06                	je     8017fb <insert_page_alloc+0x10a>
  8017f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017f9:	75 14                	jne    80180f <insert_page_alloc+0x11e>
  8017fb:	83 ec 04             	sub    $0x4,%esp
  8017fe:	68 44 42 80 00       	push   $0x804244
  801803:	6a 23                	push   $0x23
  801805:	68 11 42 80 00       	push   $0x804211
  80180a:	e8 b6 1e 00 00       	call   8036c5 <_panic>
  80180f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801812:	8b 50 08             	mov    0x8(%eax),%edx
  801815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801818:	89 50 08             	mov    %edx,0x8(%eax)
  80181b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80181e:	8b 40 08             	mov    0x8(%eax),%eax
  801821:	85 c0                	test   %eax,%eax
  801823:	74 0c                	je     801831 <insert_page_alloc+0x140>
  801825:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801828:	8b 40 08             	mov    0x8(%eax),%eax
  80182b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80182e:	89 50 0c             	mov    %edx,0xc(%eax)
  801831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801834:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801837:	89 50 08             	mov    %edx,0x8(%eax)
  80183a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80183d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801840:	89 50 0c             	mov    %edx,0xc(%eax)
  801843:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801846:	8b 40 08             	mov    0x8(%eax),%eax
  801849:	85 c0                	test   %eax,%eax
  80184b:	75 08                	jne    801855 <insert_page_alloc+0x164>
  80184d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801850:	a3 28 50 80 00       	mov    %eax,0x805028
  801855:	a1 30 50 80 00       	mov    0x805030,%eax
  80185a:	40                   	inc    %eax
  80185b:	a3 30 50 80 00       	mov    %eax,0x805030
}
  801860:	90                   	nop
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801869:	a1 24 50 80 00       	mov    0x805024,%eax
  80186e:	85 c0                	test   %eax,%eax
  801870:	75 0c                	jne    80187e <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801872:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801877:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  80187c:	eb 67                	jmp    8018e5 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  80187e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801883:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801886:	a1 24 50 80 00       	mov    0x805024,%eax
  80188b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80188e:	eb 26                	jmp    8018b6 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801890:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801893:	8b 10                	mov    (%eax),%edx
  801895:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801898:	8b 40 04             	mov    0x4(%eax),%eax
  80189b:	01 d0                	add    %edx,%eax
  80189d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  8018a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018a6:	76 06                	jbe    8018ae <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  8018a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8018ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8018b6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8018ba:	74 08                	je     8018c4 <recompute_page_alloc_break+0x61>
  8018bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018bf:	8b 40 08             	mov    0x8(%eax),%eax
  8018c2:	eb 05                	jmp    8018c9 <recompute_page_alloc_break+0x66>
  8018c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8018ce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	75 b9                	jne    801890 <recompute_page_alloc_break+0x2d>
  8018d7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8018db:	75 b3                	jne    801890 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  8018dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018e0:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  8018ed:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8018f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8018f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018fa:	01 d0                	add    %edx,%eax
  8018fc:	48                   	dec    %eax
  8018fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801900:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801903:	ba 00 00 00 00       	mov    $0x0,%edx
  801908:	f7 75 d8             	divl   -0x28(%ebp)
  80190b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80190e:	29 d0                	sub    %edx,%eax
  801910:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801913:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801917:	75 0a                	jne    801923 <alloc_pages_custom_fit+0x3c>
		return NULL;
  801919:	b8 00 00 00 00       	mov    $0x0,%eax
  80191e:	e9 7e 01 00 00       	jmp    801aa1 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801923:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  80192a:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  80192e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801935:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  80193c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801941:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801944:	a1 24 50 80 00       	mov    0x805024,%eax
  801949:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80194c:	eb 69                	jmp    8019b7 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  80194e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801951:	8b 00                	mov    (%eax),%eax
  801953:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801956:	76 47                	jbe    80199f <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801958:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80195b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  80195e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801961:	8b 00                	mov    (%eax),%eax
  801963:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801966:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801969:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80196c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80196f:	72 2e                	jb     80199f <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801971:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801975:	75 14                	jne    80198b <alloc_pages_custom_fit+0xa4>
  801977:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80197a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80197d:	75 0c                	jne    80198b <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  80197f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801982:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801985:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801989:	eb 14                	jmp    80199f <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  80198b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80198e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801991:	76 0c                	jbe    80199f <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801993:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801996:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801999:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80199c:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  80199f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a2:	8b 10                	mov    (%eax),%edx
  8019a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a7:	8b 40 04             	mov    0x4(%eax),%eax
  8019aa:	01 d0                	add    %edx,%eax
  8019ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8019af:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8019b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019bb:	74 08                	je     8019c5 <alloc_pages_custom_fit+0xde>
  8019bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019c0:	8b 40 08             	mov    0x8(%eax),%eax
  8019c3:	eb 05                	jmp    8019ca <alloc_pages_custom_fit+0xe3>
  8019c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ca:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8019cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8019d4:	85 c0                	test   %eax,%eax
  8019d6:	0f 85 72 ff ff ff    	jne    80194e <alloc_pages_custom_fit+0x67>
  8019dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019e0:	0f 85 68 ff ff ff    	jne    80194e <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  8019e6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8019eb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019ee:	76 47                	jbe    801a37 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  8019f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019f3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  8019f6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8019fb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8019fe:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801a01:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a04:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801a07:	72 2e                	jb     801a37 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801a09:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801a0d:	75 14                	jne    801a23 <alloc_pages_custom_fit+0x13c>
  801a0f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a12:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801a15:	75 0c                	jne    801a23 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801a17:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801a1d:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801a21:	eb 14                	jmp    801a37 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801a23:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a26:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a29:	76 0c                	jbe    801a37 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801a2b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801a31:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a34:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801a37:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801a3e:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801a42:	74 08                	je     801a4c <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a47:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a4a:	eb 40                	jmp    801a8c <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801a4c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a50:	74 08                	je     801a5a <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801a52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a55:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a58:	eb 32                	jmp    801a8c <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801a5a:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801a5f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801a62:	89 c2                	mov    %eax,%edx
  801a64:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801a69:	39 c2                	cmp    %eax,%edx
  801a6b:	73 07                	jae    801a74 <alloc_pages_custom_fit+0x18d>
			return NULL;
  801a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a72:	eb 2d                	jmp    801aa1 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801a74:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801a79:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801a7c:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801a82:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a85:	01 d0                	add    %edx,%eax
  801a87:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801a8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a8f:	83 ec 08             	sub    $0x8,%esp
  801a92:	ff 75 d0             	pushl  -0x30(%ebp)
  801a95:	50                   	push   %eax
  801a96:	e8 56 fc ff ff       	call   8016f1 <insert_page_alloc>
  801a9b:	83 c4 10             	add    $0x10,%esp

	return result;
  801a9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801aaf:	a1 24 50 80 00       	mov    0x805024,%eax
  801ab4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ab7:	eb 1a                	jmp    801ad3 <find_allocated_size+0x30>
		if (it->start == va)
  801ab9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801abc:	8b 00                	mov    (%eax),%eax
  801abe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801ac1:	75 08                	jne    801acb <find_allocated_size+0x28>
			return it->size;
  801ac3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ac6:	8b 40 04             	mov    0x4(%eax),%eax
  801ac9:	eb 34                	jmp    801aff <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801acb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ad0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ad3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ad7:	74 08                	je     801ae1 <find_allocated_size+0x3e>
  801ad9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801adc:	8b 40 08             	mov    0x8(%eax),%eax
  801adf:	eb 05                	jmp    801ae6 <find_allocated_size+0x43>
  801ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801aeb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801af0:	85 c0                	test   %eax,%eax
  801af2:	75 c5                	jne    801ab9 <find_allocated_size+0x16>
  801af4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801af8:	75 bf                	jne    801ab9 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801afa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801b0d:	a1 24 50 80 00       	mov    0x805024,%eax
  801b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b15:	e9 e1 01 00 00       	jmp    801cfb <free_pages+0x1fa>
		if (it->start == va) {
  801b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1d:	8b 00                	mov    (%eax),%eax
  801b1f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801b22:	0f 85 cb 01 00 00    	jne    801cf3 <free_pages+0x1f2>

			uint32 start = it->start;
  801b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2b:	8b 00                	mov    (%eax),%eax
  801b2d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b33:	8b 40 04             	mov    0x4(%eax),%eax
  801b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801b39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b3c:	f7 d0                	not    %eax
  801b3e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b41:	73 1d                	jae    801b60 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801b43:	83 ec 0c             	sub    $0xc,%esp
  801b46:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b49:	ff 75 e8             	pushl  -0x18(%ebp)
  801b4c:	68 78 42 80 00       	push   $0x804278
  801b51:	68 a5 00 00 00       	push   $0xa5
  801b56:	68 11 42 80 00       	push   $0x804211
  801b5b:	e8 65 1b 00 00       	call   8036c5 <_panic>
			}

			uint32 start_end = start + size;
  801b60:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b66:	01 d0                	add    %edx,%eax
  801b68:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801b6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b6e:	85 c0                	test   %eax,%eax
  801b70:	79 19                	jns    801b8b <free_pages+0x8a>
  801b72:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801b79:	77 10                	ja     801b8b <free_pages+0x8a>
  801b7b:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801b82:	77 07                	ja     801b8b <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801b84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b87:	85 c0                	test   %eax,%eax
  801b89:	78 2c                	js     801bb7 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801b8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b8e:	83 ec 0c             	sub    $0xc,%esp
  801b91:	68 00 00 00 a0       	push   $0xa0000000
  801b96:	ff 75 e0             	pushl  -0x20(%ebp)
  801b99:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b9c:	ff 75 e8             	pushl  -0x18(%ebp)
  801b9f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ba2:	50                   	push   %eax
  801ba3:	68 bc 42 80 00       	push   $0x8042bc
  801ba8:	68 ad 00 00 00       	push   $0xad
  801bad:	68 11 42 80 00       	push   $0x804211
  801bb2:	e8 0e 1b 00 00       	call   8036c5 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801bb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bbd:	e9 88 00 00 00       	jmp    801c4a <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801bc2:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801bc9:	76 17                	jbe    801be2 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801bcb:	ff 75 f0             	pushl  -0x10(%ebp)
  801bce:	68 20 43 80 00       	push   $0x804320
  801bd3:	68 b4 00 00 00       	push   $0xb4
  801bd8:	68 11 42 80 00       	push   $0x804211
  801bdd:	e8 e3 1a 00 00       	call   8036c5 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be5:	05 00 10 00 00       	add    $0x1000,%eax
  801bea:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf0:	85 c0                	test   %eax,%eax
  801bf2:	79 2e                	jns    801c22 <free_pages+0x121>
  801bf4:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801bfb:	77 25                	ja     801c22 <free_pages+0x121>
  801bfd:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801c04:	77 1c                	ja     801c22 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801c06:	83 ec 08             	sub    $0x8,%esp
  801c09:	68 00 10 00 00       	push   $0x1000
  801c0e:	ff 75 f0             	pushl  -0x10(%ebp)
  801c11:	e8 38 0d 00 00       	call   80294e <sys_free_user_mem>
  801c16:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801c19:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801c20:	eb 28                	jmp    801c4a <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c25:	68 00 00 00 a0       	push   $0xa0000000
  801c2a:	ff 75 dc             	pushl  -0x24(%ebp)
  801c2d:	68 00 10 00 00       	push   $0x1000
  801c32:	ff 75 f0             	pushl  -0x10(%ebp)
  801c35:	50                   	push   %eax
  801c36:	68 60 43 80 00       	push   $0x804360
  801c3b:	68 bd 00 00 00       	push   $0xbd
  801c40:	68 11 42 80 00       	push   $0x804211
  801c45:	e8 7b 1a 00 00       	call   8036c5 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801c50:	0f 82 6c ff ff ff    	jb     801bc2 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801c56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c5a:	75 17                	jne    801c73 <free_pages+0x172>
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	68 c2 43 80 00       	push   $0x8043c2
  801c64:	68 c1 00 00 00       	push   $0xc1
  801c69:	68 11 42 80 00       	push   $0x804211
  801c6e:	e8 52 1a 00 00       	call   8036c5 <_panic>
  801c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c76:	8b 40 08             	mov    0x8(%eax),%eax
  801c79:	85 c0                	test   %eax,%eax
  801c7b:	74 11                	je     801c8e <free_pages+0x18d>
  801c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c80:	8b 40 08             	mov    0x8(%eax),%eax
  801c83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c86:	8b 52 0c             	mov    0xc(%edx),%edx
  801c89:	89 50 0c             	mov    %edx,0xc(%eax)
  801c8c:	eb 0b                	jmp    801c99 <free_pages+0x198>
  801c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c91:	8b 40 0c             	mov    0xc(%eax),%eax
  801c94:	a3 28 50 80 00       	mov    %eax,0x805028
  801c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	74 11                	je     801cb4 <free_pages+0x1b3>
  801ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cac:	8b 52 08             	mov    0x8(%edx),%edx
  801caf:	89 50 08             	mov    %edx,0x8(%eax)
  801cb2:	eb 0b                	jmp    801cbf <free_pages+0x1be>
  801cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb7:	8b 40 08             	mov    0x8(%eax),%eax
  801cba:	a3 24 50 80 00       	mov    %eax,0x805024
  801cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801cd3:	a1 30 50 80 00       	mov    0x805030,%eax
  801cd8:	48                   	dec    %eax
  801cd9:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801cde:	83 ec 0c             	sub    $0xc,%esp
  801ce1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce4:	e8 24 15 00 00       	call   80320d <free_block>
  801ce9:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801cec:	e8 72 fb ff ff       	call   801863 <recompute_page_alloc_break>

			return;
  801cf1:	eb 37                	jmp    801d2a <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801cf3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cff:	74 08                	je     801d09 <free_pages+0x208>
  801d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d04:	8b 40 08             	mov    0x8(%eax),%eax
  801d07:	eb 05                	jmp    801d0e <free_pages+0x20d>
  801d09:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801d13:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	0f 85 fa fd ff ff    	jne    801b1a <free_pages+0x19>
  801d20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d24:	0f 85 f0 fd ff ff    	jne    801b1a <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801d2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d34:	5d                   	pop    %ebp
  801d35:	c3                   	ret    

00801d36 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801d3c:	a1 08 50 80 00       	mov    0x805008,%eax
  801d41:	85 c0                	test   %eax,%eax
  801d43:	74 60                	je     801da5 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801d45:	83 ec 08             	sub    $0x8,%esp
  801d48:	68 00 00 00 82       	push   $0x82000000
  801d4d:	68 00 00 00 80       	push   $0x80000000
  801d52:	e8 0d 0d 00 00       	call   802a64 <initialize_dynamic_allocator>
  801d57:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801d5a:	e8 f3 0a 00 00       	call   802852 <sys_get_uheap_strategy>
  801d5f:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801d64:	a1 40 50 80 00       	mov    0x805040,%eax
  801d69:	05 00 10 00 00       	add    $0x1000,%eax
  801d6e:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801d73:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d78:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801d7d:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801d84:	00 00 00 
  801d87:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801d8e:	00 00 00 
  801d91:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801d98:	00 00 00 

		__firstTimeFlag = 0;
  801d9b:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801da2:	00 00 00 
	}
}
  801da5:	90                   	nop
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801dae:	8b 45 08             	mov    0x8(%ebp),%eax
  801db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dbc:	83 ec 08             	sub    $0x8,%esp
  801dbf:	68 06 04 00 00       	push   $0x406
  801dc4:	50                   	push   %eax
  801dc5:	e8 d2 06 00 00       	call   80249c <__sys_allocate_page>
  801dca:	83 c4 10             	add    $0x10,%esp
  801dcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801dd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dd4:	79 17                	jns    801ded <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801dd6:	83 ec 04             	sub    $0x4,%esp
  801dd9:	68 e0 43 80 00       	push   $0x8043e0
  801dde:	68 ea 00 00 00       	push   $0xea
  801de3:	68 11 42 80 00       	push   $0x804211
  801de8:	e8 d8 18 00 00       	call   8036c5 <_panic>
	return 0;
  801ded:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e03:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e08:	83 ec 0c             	sub    $0xc,%esp
  801e0b:	50                   	push   %eax
  801e0c:	e8 d2 06 00 00       	call   8024e3 <__sys_unmap_frame>
  801e11:	83 c4 10             	add    $0x10,%esp
  801e14:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e1b:	79 17                	jns    801e34 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801e1d:	83 ec 04             	sub    $0x4,%esp
  801e20:	68 1c 44 80 00       	push   $0x80441c
  801e25:	68 f5 00 00 00       	push   $0xf5
  801e2a:	68 11 42 80 00       	push   $0x804211
  801e2f:	e8 91 18 00 00       	call   8036c5 <_panic>
}
  801e34:	90                   	nop
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e3d:	e8 f4 fe ff ff       	call   801d36 <uheap_init>
	if (size == 0) return NULL ;
  801e42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e46:	75 0a                	jne    801e52 <malloc+0x1b>
  801e48:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4d:	e9 67 01 00 00       	jmp    801fb9 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801e52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801e59:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801e60:	77 16                	ja     801e78 <malloc+0x41>
		result = alloc_block(size);
  801e62:	83 ec 0c             	sub    $0xc,%esp
  801e65:	ff 75 08             	pushl  0x8(%ebp)
  801e68:	e8 46 0e 00 00       	call   802cb3 <alloc_block>
  801e6d:	83 c4 10             	add    $0x10,%esp
  801e70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e73:	e9 3e 01 00 00       	jmp    801fb6 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801e78:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  801e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e85:	01 d0                	add    %edx,%eax
  801e87:	48                   	dec    %eax
  801e88:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e93:	f7 75 f0             	divl   -0x10(%ebp)
  801e96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e99:	29 d0                	sub    %edx,%eax
  801e9b:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801e9e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	75 0a                	jne    801eb1 <malloc+0x7a>
			return NULL;
  801ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eac:	e9 08 01 00 00       	jmp    801fb9 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801eb1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	74 0f                	je     801ec9 <malloc+0x92>
  801eba:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801ec0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ec5:	39 c2                	cmp    %eax,%edx
  801ec7:	73 0a                	jae    801ed3 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801ec9:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ece:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801ed3:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801ed8:	83 f8 05             	cmp    $0x5,%eax
  801edb:	75 11                	jne    801eee <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801edd:	83 ec 0c             	sub    $0xc,%esp
  801ee0:	ff 75 e8             	pushl  -0x18(%ebp)
  801ee3:	e8 ff f9 ff ff       	call   8018e7 <alloc_pages_custom_fit>
  801ee8:	83 c4 10             	add    $0x10,%esp
  801eeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801eee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef2:	0f 84 be 00 00 00    	je     801fb6 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801efe:	83 ec 0c             	sub    $0xc,%esp
  801f01:	ff 75 f4             	pushl  -0xc(%ebp)
  801f04:	e8 9a fb ff ff       	call   801aa3 <find_allocated_size>
  801f09:	83 c4 10             	add    $0x10,%esp
  801f0c:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801f0f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f13:	75 17                	jne    801f2c <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801f15:	ff 75 f4             	pushl  -0xc(%ebp)
  801f18:	68 5c 44 80 00       	push   $0x80445c
  801f1d:	68 24 01 00 00       	push   $0x124
  801f22:	68 11 42 80 00       	push   $0x804211
  801f27:	e8 99 17 00 00       	call   8036c5 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801f2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f2f:	f7 d0                	not    %eax
  801f31:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f34:	73 1d                	jae    801f53 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801f36:	83 ec 0c             	sub    $0xc,%esp
  801f39:	ff 75 e0             	pushl  -0x20(%ebp)
  801f3c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f3f:	68 a4 44 80 00       	push   $0x8044a4
  801f44:	68 29 01 00 00       	push   $0x129
  801f49:	68 11 42 80 00       	push   $0x804211
  801f4e:	e8 72 17 00 00       	call   8036c5 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801f53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f59:	01 d0                	add    %edx,%eax
  801f5b:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801f5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f61:	85 c0                	test   %eax,%eax
  801f63:	79 2c                	jns    801f91 <malloc+0x15a>
  801f65:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801f6c:	77 23                	ja     801f91 <malloc+0x15a>
  801f6e:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801f75:	77 1a                	ja     801f91 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801f77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	79 13                	jns    801f91 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801f7e:	83 ec 08             	sub    $0x8,%esp
  801f81:	ff 75 e0             	pushl  -0x20(%ebp)
  801f84:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f87:	e8 de 09 00 00       	call   80296a <sys_allocate_user_mem>
  801f8c:	83 c4 10             	add    $0x10,%esp
  801f8f:	eb 25                	jmp    801fb6 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801f91:	68 00 00 00 a0       	push   $0xa0000000
  801f96:	ff 75 dc             	pushl  -0x24(%ebp)
  801f99:	ff 75 e0             	pushl  -0x20(%ebp)
  801f9c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f9f:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa2:	68 e0 44 80 00       	push   $0x8044e0
  801fa7:	68 33 01 00 00       	push   $0x133
  801fac:	68 11 42 80 00       	push   $0x804211
  801fb1:	e8 0f 17 00 00       	call   8036c5 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801fc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fc5:	0f 84 26 01 00 00    	je     8020f1 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd4:	85 c0                	test   %eax,%eax
  801fd6:	79 1c                	jns    801ff4 <free+0x39>
  801fd8:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801fdf:	77 13                	ja     801ff4 <free+0x39>
		free_block(virtual_address);
  801fe1:	83 ec 0c             	sub    $0xc,%esp
  801fe4:	ff 75 08             	pushl  0x8(%ebp)
  801fe7:	e8 21 12 00 00       	call   80320d <free_block>
  801fec:	83 c4 10             	add    $0x10,%esp
		return;
  801fef:	e9 01 01 00 00       	jmp    8020f5 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801ff4:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ff9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801ffc:	0f 82 d8 00 00 00    	jb     8020da <free+0x11f>
  802002:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  802009:	0f 87 cb 00 00 00    	ja     8020da <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  80200f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802012:	25 ff 0f 00 00       	and    $0xfff,%eax
  802017:	85 c0                	test   %eax,%eax
  802019:	74 17                	je     802032 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  80201b:	ff 75 08             	pushl  0x8(%ebp)
  80201e:	68 50 45 80 00       	push   $0x804550
  802023:	68 57 01 00 00       	push   $0x157
  802028:	68 11 42 80 00       	push   $0x804211
  80202d:	e8 93 16 00 00       	call   8036c5 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  802032:	83 ec 0c             	sub    $0xc,%esp
  802035:	ff 75 08             	pushl  0x8(%ebp)
  802038:	e8 66 fa ff ff       	call   801aa3 <find_allocated_size>
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  802043:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802047:	0f 84 a7 00 00 00    	je     8020f4 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  80204d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802050:	f7 d0                	not    %eax
  802052:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802055:	73 1d                	jae    802074 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  802057:	83 ec 0c             	sub    $0xc,%esp
  80205a:	ff 75 f0             	pushl  -0x10(%ebp)
  80205d:	ff 75 f4             	pushl  -0xc(%ebp)
  802060:	68 78 45 80 00       	push   $0x804578
  802065:	68 61 01 00 00       	push   $0x161
  80206a:	68 11 42 80 00       	push   $0x804211
  80206f:	e8 51 16 00 00       	call   8036c5 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  802074:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207a:	01 d0                	add    %edx,%eax
  80207c:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  80207f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802082:	85 c0                	test   %eax,%eax
  802084:	79 19                	jns    80209f <free+0xe4>
  802086:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  80208d:	77 10                	ja     80209f <free+0xe4>
  80208f:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  802096:	77 07                	ja     80209f <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  802098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209b:	85 c0                	test   %eax,%eax
  80209d:	78 2b                	js     8020ca <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  80209f:	83 ec 0c             	sub    $0xc,%esp
  8020a2:	68 00 00 00 a0       	push   $0xa0000000
  8020a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8020aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8020ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8020b3:	ff 75 08             	pushl  0x8(%ebp)
  8020b6:	68 b4 45 80 00       	push   $0x8045b4
  8020bb:	68 69 01 00 00       	push   $0x169
  8020c0:	68 11 42 80 00       	push   $0x804211
  8020c5:	e8 fb 15 00 00       	call   8036c5 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  8020ca:	83 ec 0c             	sub    $0xc,%esp
  8020cd:	ff 75 08             	pushl  0x8(%ebp)
  8020d0:	e8 2c fa ff ff       	call   801b01 <free_pages>
  8020d5:	83 c4 10             	add    $0x10,%esp
		return;
  8020d8:	eb 1b                	jmp    8020f5 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  8020da:	ff 75 08             	pushl  0x8(%ebp)
  8020dd:	68 10 46 80 00       	push   $0x804610
  8020e2:	68 70 01 00 00       	push   $0x170
  8020e7:	68 11 42 80 00       	push   $0x804211
  8020ec:	e8 d4 15 00 00       	call   8036c5 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8020f1:	90                   	nop
  8020f2:	eb 01                	jmp    8020f5 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  8020f4:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	83 ec 38             	sub    $0x38,%esp
  8020fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802100:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802103:	e8 2e fc ff ff       	call   801d36 <uheap_init>
	if (size == 0) return NULL ;
  802108:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80210c:	75 0a                	jne    802118 <smalloc+0x21>
  80210e:	b8 00 00 00 00       	mov    $0x0,%eax
  802113:	e9 3d 01 00 00       	jmp    802255 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  802118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  80211e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802121:	25 ff 0f 00 00       	and    $0xfff,%eax
  802126:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  802129:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80212d:	74 0e                	je     80213d <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802135:	05 00 10 00 00       	add    $0x1000,%eax
  80213a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  80213d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802140:	c1 e8 0c             	shr    $0xc,%eax
  802143:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802146:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80214b:	85 c0                	test   %eax,%eax
  80214d:	75 0a                	jne    802159 <smalloc+0x62>
		return NULL;
  80214f:	b8 00 00 00 00       	mov    $0x0,%eax
  802154:	e9 fc 00 00 00       	jmp    802255 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802159:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80215e:	85 c0                	test   %eax,%eax
  802160:	74 0f                	je     802171 <smalloc+0x7a>
  802162:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802168:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80216d:	39 c2                	cmp    %eax,%edx
  80216f:	73 0a                	jae    80217b <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  802171:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802176:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80217b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802180:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802185:	29 c2                	sub    %eax,%edx
  802187:	89 d0                	mov    %edx,%eax
  802189:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80218c:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802192:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802197:	29 c2                	sub    %eax,%edx
  802199:	89 d0                	mov    %edx,%eax
  80219b:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80219e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8021a4:	77 13                	ja     8021b9 <smalloc+0xc2>
  8021a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021a9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8021ac:	77 0b                	ja     8021b9 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  8021ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021b1:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8021b4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8021b7:	73 0a                	jae    8021c3 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  8021b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021be:	e9 92 00 00 00       	jmp    802255 <smalloc+0x15e>
	}

	void *va = NULL;
  8021c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8021ca:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8021cf:	83 f8 05             	cmp    $0x5,%eax
  8021d2:	75 11                	jne    8021e5 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  8021d4:	83 ec 0c             	sub    $0xc,%esp
  8021d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8021da:	e8 08 f7 ff ff       	call   8018e7 <alloc_pages_custom_fit>
  8021df:	83 c4 10             	add    $0x10,%esp
  8021e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  8021e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021e9:	75 27                	jne    802212 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8021eb:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  8021f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021f5:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8021f8:	89 c2                	mov    %eax,%edx
  8021fa:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8021ff:	39 c2                	cmp    %eax,%edx
  802201:	73 07                	jae    80220a <smalloc+0x113>
			return NULL;}
  802203:	b8 00 00 00 00       	mov    $0x0,%eax
  802208:	eb 4b                	jmp    802255 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  80220a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80220f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  802212:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802216:	ff 75 f0             	pushl  -0x10(%ebp)
  802219:	50                   	push   %eax
  80221a:	ff 75 0c             	pushl  0xc(%ebp)
  80221d:	ff 75 08             	pushl  0x8(%ebp)
  802220:	e8 cb 03 00 00       	call   8025f0 <sys_create_shared_object>
  802225:	83 c4 10             	add    $0x10,%esp
  802228:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80222b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80222f:	79 07                	jns    802238 <smalloc+0x141>
		return NULL;
  802231:	b8 00 00 00 00       	mov    $0x0,%eax
  802236:	eb 1d                	jmp    802255 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802238:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80223d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802240:	75 10                	jne    802252 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802242:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224b:	01 d0                	add    %edx,%eax
  80224d:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  802252:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
  80225a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80225d:	e8 d4 fa ff ff       	call   801d36 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802262:	83 ec 08             	sub    $0x8,%esp
  802265:	ff 75 0c             	pushl  0xc(%ebp)
  802268:	ff 75 08             	pushl  0x8(%ebp)
  80226b:	e8 aa 03 00 00       	call   80261a <sys_size_of_shared_object>
  802270:	83 c4 10             	add    $0x10,%esp
  802273:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802276:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80227a:	7f 0a                	jg     802286 <sget+0x2f>
		return NULL;
  80227c:	b8 00 00 00 00       	mov    $0x0,%eax
  802281:	e9 32 01 00 00       	jmp    8023b8 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  802286:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802289:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  80228c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228f:	25 ff 0f 00 00       	and    $0xfff,%eax
  802294:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  802297:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80229b:	74 0e                	je     8022ab <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  80229d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a0:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8022a3:	05 00 10 00 00       	add    $0x1000,%eax
  8022a8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8022ab:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	75 0a                	jne    8022be <sget+0x67>
		return NULL;
  8022b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b9:	e9 fa 00 00 00       	jmp    8023b8 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8022be:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	74 0f                	je     8022d6 <sget+0x7f>
  8022c7:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8022cd:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022d2:	39 c2                	cmp    %eax,%edx
  8022d4:	73 0a                	jae    8022e0 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8022d6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022db:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8022e0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022e5:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8022ea:	29 c2                	sub    %eax,%edx
  8022ec:	89 d0                	mov    %edx,%eax
  8022ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8022f1:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8022f7:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022fc:	29 c2                	sub    %eax,%edx
  8022fe:	89 d0                	mov    %edx,%eax
  802300:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802309:	77 13                	ja     80231e <sget+0xc7>
  80230b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80230e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802311:	77 0b                	ja     80231e <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802313:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802316:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802319:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80231c:	73 0a                	jae    802328 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  80231e:	b8 00 00 00 00       	mov    $0x0,%eax
  802323:	e9 90 00 00 00       	jmp    8023b8 <sget+0x161>

	void *va = NULL;
  802328:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  80232f:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802334:	83 f8 05             	cmp    $0x5,%eax
  802337:	75 11                	jne    80234a <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802339:	83 ec 0c             	sub    $0xc,%esp
  80233c:	ff 75 f4             	pushl  -0xc(%ebp)
  80233f:	e8 a3 f5 ff ff       	call   8018e7 <alloc_pages_custom_fit>
  802344:	83 c4 10             	add    $0x10,%esp
  802347:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  80234a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80234e:	75 27                	jne    802377 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802350:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802357:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80235a:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80235d:	89 c2                	mov    %eax,%edx
  80235f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802364:	39 c2                	cmp    %eax,%edx
  802366:	73 07                	jae    80236f <sget+0x118>
			return NULL;
  802368:	b8 00 00 00 00       	mov    $0x0,%eax
  80236d:	eb 49                	jmp    8023b8 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  80236f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802374:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802377:	83 ec 04             	sub    $0x4,%esp
  80237a:	ff 75 f0             	pushl  -0x10(%ebp)
  80237d:	ff 75 0c             	pushl  0xc(%ebp)
  802380:	ff 75 08             	pushl  0x8(%ebp)
  802383:	e8 af 02 00 00       	call   802637 <sys_get_shared_object>
  802388:	83 c4 10             	add    $0x10,%esp
  80238b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  80238e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802392:	79 07                	jns    80239b <sget+0x144>
		return NULL;
  802394:	b8 00 00 00 00       	mov    $0x0,%eax
  802399:	eb 1d                	jmp    8023b8 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  80239b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8023a0:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8023a3:	75 10                	jne    8023b5 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8023a5:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	01 d0                	add    %edx,%eax
  8023b0:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8023b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
  8023bd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8023c0:	e8 71 f9 ff ff       	call   801d36 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8023c5:	83 ec 04             	sub    $0x4,%esp
  8023c8:	68 34 46 80 00       	push   $0x804634
  8023cd:	68 19 02 00 00       	push   $0x219
  8023d2:	68 11 42 80 00       	push   $0x804211
  8023d7:	e8 e9 12 00 00       	call   8036c5 <_panic>

008023dc <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
  8023df:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8023e2:	83 ec 04             	sub    $0x4,%esp
  8023e5:	68 5c 46 80 00       	push   $0x80465c
  8023ea:	68 2b 02 00 00       	push   $0x22b
  8023ef:	68 11 42 80 00       	push   $0x804211
  8023f4:	e8 cc 12 00 00       	call   8036c5 <_panic>

008023f9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
  8023fc:	57                   	push   %edi
  8023fd:	56                   	push   %esi
  8023fe:	53                   	push   %ebx
  8023ff:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	8b 55 0c             	mov    0xc(%ebp),%edx
  802408:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80240b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80240e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802411:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802414:	cd 30                	int    $0x30
  802416:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802419:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80241c:	83 c4 10             	add    $0x10,%esp
  80241f:	5b                   	pop    %ebx
  802420:	5e                   	pop    %esi
  802421:	5f                   	pop    %edi
  802422:	5d                   	pop    %ebp
  802423:	c3                   	ret    

00802424 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
  802427:	83 ec 04             	sub    $0x4,%esp
  80242a:	8b 45 10             	mov    0x10(%ebp),%eax
  80242d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802430:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802433:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802437:	8b 45 08             	mov    0x8(%ebp),%eax
  80243a:	6a 00                	push   $0x0
  80243c:	51                   	push   %ecx
  80243d:	52                   	push   %edx
  80243e:	ff 75 0c             	pushl  0xc(%ebp)
  802441:	50                   	push   %eax
  802442:	6a 00                	push   $0x0
  802444:	e8 b0 ff ff ff       	call   8023f9 <syscall>
  802449:	83 c4 18             	add    $0x18,%esp
}
  80244c:	90                   	nop
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <sys_cgetc>:

int
sys_cgetc(void)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 02                	push   $0x2
  80245e:	e8 96 ff ff ff       	call   8023f9 <syscall>
  802463:	83 c4 18             	add    $0x18,%esp
}
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 03                	push   $0x3
  802477:	e8 7d ff ff ff       	call   8023f9 <syscall>
  80247c:	83 c4 18             	add    $0x18,%esp
}
  80247f:	90                   	nop
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 04                	push   $0x4
  802491:	e8 63 ff ff ff       	call   8023f9 <syscall>
  802496:	83 c4 18             	add    $0x18,%esp
}
  802499:	90                   	nop
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80249f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	52                   	push   %edx
  8024ac:	50                   	push   %eax
  8024ad:	6a 08                	push   $0x8
  8024af:	e8 45 ff ff ff       	call   8023f9 <syscall>
  8024b4:	83 c4 18             	add    $0x18,%esp
}
  8024b7:	c9                   	leave  
  8024b8:	c3                   	ret    

008024b9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
  8024bc:	56                   	push   %esi
  8024bd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8024be:	8b 75 18             	mov    0x18(%ebp),%esi
  8024c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	56                   	push   %esi
  8024ce:	53                   	push   %ebx
  8024cf:	51                   	push   %ecx
  8024d0:	52                   	push   %edx
  8024d1:	50                   	push   %eax
  8024d2:	6a 09                	push   $0x9
  8024d4:	e8 20 ff ff ff       	call   8023f9 <syscall>
  8024d9:	83 c4 18             	add    $0x18,%esp
}
  8024dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024df:	5b                   	pop    %ebx
  8024e0:	5e                   	pop    %esi
  8024e1:	5d                   	pop    %ebp
  8024e2:	c3                   	ret    

008024e3 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8024e3:	55                   	push   %ebp
  8024e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	ff 75 08             	pushl  0x8(%ebp)
  8024f1:	6a 0a                	push   $0xa
  8024f3:	e8 01 ff ff ff       	call   8023f9 <syscall>
  8024f8:	83 c4 18             	add    $0x18,%esp
}
  8024fb:	c9                   	leave  
  8024fc:	c3                   	ret    

008024fd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8024fd:	55                   	push   %ebp
  8024fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	ff 75 0c             	pushl  0xc(%ebp)
  802509:	ff 75 08             	pushl  0x8(%ebp)
  80250c:	6a 0b                	push   $0xb
  80250e:	e8 e6 fe ff ff       	call   8023f9 <syscall>
  802513:	83 c4 18             	add    $0x18,%esp
}
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 00                	push   $0x0
  802525:	6a 0c                	push   $0xc
  802527:	e8 cd fe ff ff       	call   8023f9 <syscall>
  80252c:	83 c4 18             	add    $0x18,%esp
}
  80252f:	c9                   	leave  
  802530:	c3                   	ret    

00802531 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	6a 0d                	push   $0xd
  802540:	e8 b4 fe ff ff       	call   8023f9 <syscall>
  802545:	83 c4 18             	add    $0x18,%esp
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 0e                	push   $0xe
  802559:	e8 9b fe ff ff       	call   8023f9 <syscall>
  80255e:	83 c4 18             	add    $0x18,%esp
}
  802561:	c9                   	leave  
  802562:	c3                   	ret    

00802563 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 0f                	push   $0xf
  802572:	e8 82 fe ff ff       	call   8023f9 <syscall>
  802577:	83 c4 18             	add    $0x18,%esp
}
  80257a:	c9                   	leave  
  80257b:	c3                   	ret    

0080257c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80257c:	55                   	push   %ebp
  80257d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	ff 75 08             	pushl  0x8(%ebp)
  80258a:	6a 10                	push   $0x10
  80258c:	e8 68 fe ff ff       	call   8023f9 <syscall>
  802591:	83 c4 18             	add    $0x18,%esp
}
  802594:	c9                   	leave  
  802595:	c3                   	ret    

00802596 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 11                	push   $0x11
  8025a5:	e8 4f fe ff ff       	call   8023f9 <syscall>
  8025aa:	83 c4 18             	add    $0x18,%esp
}
  8025ad:	90                   	nop
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <sys_cputc>:

void
sys_cputc(const char c)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	83 ec 04             	sub    $0x4,%esp
  8025b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8025bc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	50                   	push   %eax
  8025c9:	6a 01                	push   $0x1
  8025cb:	e8 29 fe ff ff       	call   8023f9 <syscall>
  8025d0:	83 c4 18             	add    $0x18,%esp
}
  8025d3:	90                   	nop
  8025d4:	c9                   	leave  
  8025d5:	c3                   	ret    

008025d6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8025d6:	55                   	push   %ebp
  8025d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 14                	push   $0x14
  8025e5:	e8 0f fe ff ff       	call   8023f9 <syscall>
  8025ea:	83 c4 18             	add    $0x18,%esp
}
  8025ed:	90                   	nop
  8025ee:	c9                   	leave  
  8025ef:	c3                   	ret    

008025f0 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
  8025f3:	83 ec 04             	sub    $0x4,%esp
  8025f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8025fc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8025ff:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802603:	8b 45 08             	mov    0x8(%ebp),%eax
  802606:	6a 00                	push   $0x0
  802608:	51                   	push   %ecx
  802609:	52                   	push   %edx
  80260a:	ff 75 0c             	pushl  0xc(%ebp)
  80260d:	50                   	push   %eax
  80260e:	6a 15                	push   $0x15
  802610:	e8 e4 fd ff ff       	call   8023f9 <syscall>
  802615:	83 c4 18             	add    $0x18,%esp
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80261d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802620:	8b 45 08             	mov    0x8(%ebp),%eax
  802623:	6a 00                	push   $0x0
  802625:	6a 00                	push   $0x0
  802627:	6a 00                	push   $0x0
  802629:	52                   	push   %edx
  80262a:	50                   	push   %eax
  80262b:	6a 16                	push   $0x16
  80262d:	e8 c7 fd ff ff       	call   8023f9 <syscall>
  802632:	83 c4 18             	add    $0x18,%esp
}
  802635:	c9                   	leave  
  802636:	c3                   	ret    

00802637 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802637:	55                   	push   %ebp
  802638:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80263a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80263d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802640:	8b 45 08             	mov    0x8(%ebp),%eax
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	51                   	push   %ecx
  802648:	52                   	push   %edx
  802649:	50                   	push   %eax
  80264a:	6a 17                	push   $0x17
  80264c:	e8 a8 fd ff ff       	call   8023f9 <syscall>
  802651:	83 c4 18             	add    $0x18,%esp
}
  802654:	c9                   	leave  
  802655:	c3                   	ret    

00802656 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802659:	8b 55 0c             	mov    0xc(%ebp),%edx
  80265c:	8b 45 08             	mov    0x8(%ebp),%eax
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	52                   	push   %edx
  802666:	50                   	push   %eax
  802667:	6a 18                	push   $0x18
  802669:	e8 8b fd ff ff       	call   8023f9 <syscall>
  80266e:	83 c4 18             	add    $0x18,%esp
}
  802671:	c9                   	leave  
  802672:	c3                   	ret    

00802673 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802676:	8b 45 08             	mov    0x8(%ebp),%eax
  802679:	6a 00                	push   $0x0
  80267b:	ff 75 14             	pushl  0x14(%ebp)
  80267e:	ff 75 10             	pushl  0x10(%ebp)
  802681:	ff 75 0c             	pushl  0xc(%ebp)
  802684:	50                   	push   %eax
  802685:	6a 19                	push   $0x19
  802687:	e8 6d fd ff ff       	call   8023f9 <syscall>
  80268c:	83 c4 18             	add    $0x18,%esp
}
  80268f:	c9                   	leave  
  802690:	c3                   	ret    

00802691 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	6a 00                	push   $0x0
  802699:	6a 00                	push   $0x0
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	50                   	push   %eax
  8026a0:	6a 1a                	push   $0x1a
  8026a2:	e8 52 fd ff ff       	call   8023f9 <syscall>
  8026a7:	83 c4 18             	add    $0x18,%esp
}
  8026aa:	90                   	nop
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8026b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	50                   	push   %eax
  8026bc:	6a 1b                	push   $0x1b
  8026be:	e8 36 fd ff ff       	call   8023f9 <syscall>
  8026c3:	83 c4 18             	add    $0x18,%esp
}
  8026c6:	c9                   	leave  
  8026c7:	c3                   	ret    

008026c8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 05                	push   $0x5
  8026d7:	e8 1d fd ff ff       	call   8023f9 <syscall>
  8026dc:	83 c4 18             	add    $0x18,%esp
}
  8026df:	c9                   	leave  
  8026e0:	c3                   	ret    

008026e1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 06                	push   $0x6
  8026f0:	e8 04 fd ff ff       	call   8023f9 <syscall>
  8026f5:	83 c4 18             	add    $0x18,%esp
}
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 07                	push   $0x7
  802709:	e8 eb fc ff ff       	call   8023f9 <syscall>
  80270e:	83 c4 18             	add    $0x18,%esp
}
  802711:	c9                   	leave  
  802712:	c3                   	ret    

00802713 <sys_exit_env>:


void sys_exit_env(void)
{
  802713:	55                   	push   %ebp
  802714:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 1c                	push   $0x1c
  802722:	e8 d2 fc ff ff       	call   8023f9 <syscall>
  802727:	83 c4 18             	add    $0x18,%esp
}
  80272a:	90                   	nop
  80272b:	c9                   	leave  
  80272c:	c3                   	ret    

0080272d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80272d:	55                   	push   %ebp
  80272e:	89 e5                	mov    %esp,%ebp
  802730:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802733:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802736:	8d 50 04             	lea    0x4(%eax),%edx
  802739:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	52                   	push   %edx
  802743:	50                   	push   %eax
  802744:	6a 1d                	push   $0x1d
  802746:	e8 ae fc ff ff       	call   8023f9 <syscall>
  80274b:	83 c4 18             	add    $0x18,%esp
	return result;
  80274e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802751:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802754:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802757:	89 01                	mov    %eax,(%ecx)
  802759:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80275c:	8b 45 08             	mov    0x8(%ebp),%eax
  80275f:	c9                   	leave  
  802760:	c2 04 00             	ret    $0x4

00802763 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802763:	55                   	push   %ebp
  802764:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802766:	6a 00                	push   $0x0
  802768:	6a 00                	push   $0x0
  80276a:	ff 75 10             	pushl  0x10(%ebp)
  80276d:	ff 75 0c             	pushl  0xc(%ebp)
  802770:	ff 75 08             	pushl  0x8(%ebp)
  802773:	6a 13                	push   $0x13
  802775:	e8 7f fc ff ff       	call   8023f9 <syscall>
  80277a:	83 c4 18             	add    $0x18,%esp
	return ;
  80277d:	90                   	nop
}
  80277e:	c9                   	leave  
  80277f:	c3                   	ret    

00802780 <sys_rcr2>:
uint32 sys_rcr2()
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802783:	6a 00                	push   $0x0
  802785:	6a 00                	push   $0x0
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	6a 1e                	push   $0x1e
  80278f:	e8 65 fc ff ff       	call   8023f9 <syscall>
  802794:	83 c4 18             	add    $0x18,%esp
}
  802797:	c9                   	leave  
  802798:	c3                   	ret    

00802799 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
  80279c:	83 ec 04             	sub    $0x4,%esp
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027a5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 00                	push   $0x0
  8027b1:	50                   	push   %eax
  8027b2:	6a 1f                	push   $0x1f
  8027b4:	e8 40 fc ff ff       	call   8023f9 <syscall>
  8027b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8027bc:	90                   	nop
}
  8027bd:	c9                   	leave  
  8027be:	c3                   	ret    

008027bf <rsttst>:
void rsttst()
{
  8027bf:	55                   	push   %ebp
  8027c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 00                	push   $0x0
  8027ca:	6a 00                	push   $0x0
  8027cc:	6a 21                	push   $0x21
  8027ce:	e8 26 fc ff ff       	call   8023f9 <syscall>
  8027d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8027d6:	90                   	nop
}
  8027d7:	c9                   	leave  
  8027d8:	c3                   	ret    

008027d9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8027d9:	55                   	push   %ebp
  8027da:	89 e5                	mov    %esp,%ebp
  8027dc:	83 ec 04             	sub    $0x4,%esp
  8027df:	8b 45 14             	mov    0x14(%ebp),%eax
  8027e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8027e5:	8b 55 18             	mov    0x18(%ebp),%edx
  8027e8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027ec:	52                   	push   %edx
  8027ed:	50                   	push   %eax
  8027ee:	ff 75 10             	pushl  0x10(%ebp)
  8027f1:	ff 75 0c             	pushl  0xc(%ebp)
  8027f4:	ff 75 08             	pushl  0x8(%ebp)
  8027f7:	6a 20                	push   $0x20
  8027f9:	e8 fb fb ff ff       	call   8023f9 <syscall>
  8027fe:	83 c4 18             	add    $0x18,%esp
	return ;
  802801:	90                   	nop
}
  802802:	c9                   	leave  
  802803:	c3                   	ret    

00802804 <chktst>:
void chktst(uint32 n)
{
  802804:	55                   	push   %ebp
  802805:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802807:	6a 00                	push   $0x0
  802809:	6a 00                	push   $0x0
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	ff 75 08             	pushl  0x8(%ebp)
  802812:	6a 22                	push   $0x22
  802814:	e8 e0 fb ff ff       	call   8023f9 <syscall>
  802819:	83 c4 18             	add    $0x18,%esp
	return ;
  80281c:	90                   	nop
}
  80281d:	c9                   	leave  
  80281e:	c3                   	ret    

0080281f <inctst>:

void inctst()
{
  80281f:	55                   	push   %ebp
  802820:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 23                	push   $0x23
  80282e:	e8 c6 fb ff ff       	call   8023f9 <syscall>
  802833:	83 c4 18             	add    $0x18,%esp
	return ;
  802836:	90                   	nop
}
  802837:	c9                   	leave  
  802838:	c3                   	ret    

00802839 <gettst>:
uint32 gettst()
{
  802839:	55                   	push   %ebp
  80283a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80283c:	6a 00                	push   $0x0
  80283e:	6a 00                	push   $0x0
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	6a 00                	push   $0x0
  802846:	6a 24                	push   $0x24
  802848:	e8 ac fb ff ff       	call   8023f9 <syscall>
  80284d:	83 c4 18             	add    $0x18,%esp
}
  802850:	c9                   	leave  
  802851:	c3                   	ret    

00802852 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802852:	55                   	push   %ebp
  802853:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802855:	6a 00                	push   $0x0
  802857:	6a 00                	push   $0x0
  802859:	6a 00                	push   $0x0
  80285b:	6a 00                	push   $0x0
  80285d:	6a 00                	push   $0x0
  80285f:	6a 25                	push   $0x25
  802861:	e8 93 fb ff ff       	call   8023f9 <syscall>
  802866:	83 c4 18             	add    $0x18,%esp
  802869:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  80286e:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802873:	c9                   	leave  
  802874:	c3                   	ret    

00802875 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802875:	55                   	push   %ebp
  802876:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802878:	8b 45 08             	mov    0x8(%ebp),%eax
  80287b:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802880:	6a 00                	push   $0x0
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	ff 75 08             	pushl  0x8(%ebp)
  80288b:	6a 26                	push   $0x26
  80288d:	e8 67 fb ff ff       	call   8023f9 <syscall>
  802892:	83 c4 18             	add    $0x18,%esp
	return ;
  802895:	90                   	nop
}
  802896:	c9                   	leave  
  802897:	c3                   	ret    

00802898 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802898:	55                   	push   %ebp
  802899:	89 e5                	mov    %esp,%ebp
  80289b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80289c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80289f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a8:	6a 00                	push   $0x0
  8028aa:	53                   	push   %ebx
  8028ab:	51                   	push   %ecx
  8028ac:	52                   	push   %edx
  8028ad:	50                   	push   %eax
  8028ae:	6a 27                	push   $0x27
  8028b0:	e8 44 fb ff ff       	call   8023f9 <syscall>
  8028b5:	83 c4 18             	add    $0x18,%esp
}
  8028b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028bb:	c9                   	leave  
  8028bc:	c3                   	ret    

008028bd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8028bd:	55                   	push   %ebp
  8028be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8028c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c6:	6a 00                	push   $0x0
  8028c8:	6a 00                	push   $0x0
  8028ca:	6a 00                	push   $0x0
  8028cc:	52                   	push   %edx
  8028cd:	50                   	push   %eax
  8028ce:	6a 28                	push   $0x28
  8028d0:	e8 24 fb ff ff       	call   8023f9 <syscall>
  8028d5:	83 c4 18             	add    $0x18,%esp
}
  8028d8:	c9                   	leave  
  8028d9:	c3                   	ret    

008028da <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8028dd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8028e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	6a 00                	push   $0x0
  8028e8:	51                   	push   %ecx
  8028e9:	ff 75 10             	pushl  0x10(%ebp)
  8028ec:	52                   	push   %edx
  8028ed:	50                   	push   %eax
  8028ee:	6a 29                	push   $0x29
  8028f0:	e8 04 fb ff ff       	call   8023f9 <syscall>
  8028f5:	83 c4 18             	add    $0x18,%esp
}
  8028f8:	c9                   	leave  
  8028f9:	c3                   	ret    

008028fa <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8028fa:	55                   	push   %ebp
  8028fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8028fd:	6a 00                	push   $0x0
  8028ff:	6a 00                	push   $0x0
  802901:	ff 75 10             	pushl  0x10(%ebp)
  802904:	ff 75 0c             	pushl  0xc(%ebp)
  802907:	ff 75 08             	pushl  0x8(%ebp)
  80290a:	6a 12                	push   $0x12
  80290c:	e8 e8 fa ff ff       	call   8023f9 <syscall>
  802911:	83 c4 18             	add    $0x18,%esp
	return ;
  802914:	90                   	nop
}
  802915:	c9                   	leave  
  802916:	c3                   	ret    

00802917 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802917:	55                   	push   %ebp
  802918:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80291a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80291d:	8b 45 08             	mov    0x8(%ebp),%eax
  802920:	6a 00                	push   $0x0
  802922:	6a 00                	push   $0x0
  802924:	6a 00                	push   $0x0
  802926:	52                   	push   %edx
  802927:	50                   	push   %eax
  802928:	6a 2a                	push   $0x2a
  80292a:	e8 ca fa ff ff       	call   8023f9 <syscall>
  80292f:	83 c4 18             	add    $0x18,%esp
	return;
  802932:	90                   	nop
}
  802933:	c9                   	leave  
  802934:	c3                   	ret    

00802935 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802938:	6a 00                	push   $0x0
  80293a:	6a 00                	push   $0x0
  80293c:	6a 00                	push   $0x0
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 2b                	push   $0x2b
  802944:	e8 b0 fa ff ff       	call   8023f9 <syscall>
  802949:	83 c4 18             	add    $0x18,%esp
}
  80294c:	c9                   	leave  
  80294d:	c3                   	ret    

0080294e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802951:	6a 00                	push   $0x0
  802953:	6a 00                	push   $0x0
  802955:	6a 00                	push   $0x0
  802957:	ff 75 0c             	pushl  0xc(%ebp)
  80295a:	ff 75 08             	pushl  0x8(%ebp)
  80295d:	6a 2d                	push   $0x2d
  80295f:	e8 95 fa ff ff       	call   8023f9 <syscall>
  802964:	83 c4 18             	add    $0x18,%esp
	return;
  802967:	90                   	nop
}
  802968:	c9                   	leave  
  802969:	c3                   	ret    

0080296a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80296a:	55                   	push   %ebp
  80296b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80296d:	6a 00                	push   $0x0
  80296f:	6a 00                	push   $0x0
  802971:	6a 00                	push   $0x0
  802973:	ff 75 0c             	pushl  0xc(%ebp)
  802976:	ff 75 08             	pushl  0x8(%ebp)
  802979:	6a 2c                	push   $0x2c
  80297b:	e8 79 fa ff ff       	call   8023f9 <syscall>
  802980:	83 c4 18             	add    $0x18,%esp
	return ;
  802983:	90                   	nop
}
  802984:	c9                   	leave  
  802985:	c3                   	ret    

00802986 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802986:	55                   	push   %ebp
  802987:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80298c:	8b 45 08             	mov    0x8(%ebp),%eax
  80298f:	6a 00                	push   $0x0
  802991:	6a 00                	push   $0x0
  802993:	6a 00                	push   $0x0
  802995:	52                   	push   %edx
  802996:	50                   	push   %eax
  802997:	6a 2e                	push   $0x2e
  802999:	e8 5b fa ff ff       	call   8023f9 <syscall>
  80299e:	83 c4 18             	add    $0x18,%esp
	return ;
  8029a1:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  8029a2:	c9                   	leave  
  8029a3:	c3                   	ret    

008029a4 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8029a4:	55                   	push   %ebp
  8029a5:	89 e5                	mov    %esp,%ebp
  8029a7:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8029aa:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  8029b1:	72 09                	jb     8029bc <to_page_va+0x18>
  8029b3:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  8029ba:	72 14                	jb     8029d0 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8029bc:	83 ec 04             	sub    $0x4,%esp
  8029bf:	68 80 46 80 00       	push   $0x804680
  8029c4:	6a 15                	push   $0x15
  8029c6:	68 ab 46 80 00       	push   $0x8046ab
  8029cb:	e8 f5 0c 00 00       	call   8036c5 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8029d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d3:	ba 60 50 80 00       	mov    $0x805060,%edx
  8029d8:	29 d0                	sub    %edx,%eax
  8029da:	c1 f8 02             	sar    $0x2,%eax
  8029dd:	89 c2                	mov    %eax,%edx
  8029df:	89 d0                	mov    %edx,%eax
  8029e1:	c1 e0 02             	shl    $0x2,%eax
  8029e4:	01 d0                	add    %edx,%eax
  8029e6:	c1 e0 02             	shl    $0x2,%eax
  8029e9:	01 d0                	add    %edx,%eax
  8029eb:	c1 e0 02             	shl    $0x2,%eax
  8029ee:	01 d0                	add    %edx,%eax
  8029f0:	89 c1                	mov    %eax,%ecx
  8029f2:	c1 e1 08             	shl    $0x8,%ecx
  8029f5:	01 c8                	add    %ecx,%eax
  8029f7:	89 c1                	mov    %eax,%ecx
  8029f9:	c1 e1 10             	shl    $0x10,%ecx
  8029fc:	01 c8                	add    %ecx,%eax
  8029fe:	01 c0                	add    %eax,%eax
  802a00:	01 d0                	add    %edx,%eax
  802a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	c1 e0 0c             	shl    $0xc,%eax
  802a0b:	89 c2                	mov    %eax,%edx
  802a0d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a12:	01 d0                	add    %edx,%eax
}
  802a14:	c9                   	leave  
  802a15:	c3                   	ret    

00802a16 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802a16:	55                   	push   %ebp
  802a17:	89 e5                	mov    %esp,%ebp
  802a19:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802a1c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a21:	8b 55 08             	mov    0x8(%ebp),%edx
  802a24:	29 c2                	sub    %eax,%edx
  802a26:	89 d0                	mov    %edx,%eax
  802a28:	c1 e8 0c             	shr    $0xc,%eax
  802a2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802a2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a32:	78 09                	js     802a3d <to_page_info+0x27>
  802a34:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802a3b:	7e 14                	jle    802a51 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802a3d:	83 ec 04             	sub    $0x4,%esp
  802a40:	68 c4 46 80 00       	push   $0x8046c4
  802a45:	6a 22                	push   $0x22
  802a47:	68 ab 46 80 00       	push   $0x8046ab
  802a4c:	e8 74 0c 00 00       	call   8036c5 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802a51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a54:	89 d0                	mov    %edx,%eax
  802a56:	01 c0                	add    %eax,%eax
  802a58:	01 d0                	add    %edx,%eax
  802a5a:	c1 e0 02             	shl    $0x2,%eax
  802a5d:	05 60 50 80 00       	add    $0x805060,%eax
}
  802a62:	c9                   	leave  
  802a63:	c3                   	ret    

00802a64 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802a64:	55                   	push   %ebp
  802a65:	89 e5                	mov    %esp,%ebp
  802a67:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	05 00 00 00 02       	add    $0x2000000,%eax
  802a72:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a75:	73 16                	jae    802a8d <initialize_dynamic_allocator+0x29>
  802a77:	68 e8 46 80 00       	push   $0x8046e8
  802a7c:	68 0e 47 80 00       	push   $0x80470e
  802a81:	6a 34                	push   $0x34
  802a83:	68 ab 46 80 00       	push   $0x8046ab
  802a88:	e8 38 0c 00 00       	call   8036c5 <_panic>
		is_initialized = 1;
  802a8d:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  802a94:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aa2:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802aa7:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802aae:	00 00 00 
  802ab1:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802ab8:	00 00 00 
  802abb:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802ac2:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802ac5:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802acc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ad3:	eb 36                	jmp    802b0b <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	c1 e0 04             	shl    $0x4,%eax
  802adb:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ae0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	c1 e0 04             	shl    $0x4,%eax
  802aec:	05 84 d0 81 00       	add    $0x81d084,%eax
  802af1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	c1 e0 04             	shl    $0x4,%eax
  802afd:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802b02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802b08:	ff 45 f4             	incl   -0xc(%ebp)
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b11:	72 c2                	jb     802ad5 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802b13:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b19:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802b1e:	29 c2                	sub    %eax,%edx
  802b20:	89 d0                	mov    %edx,%eax
  802b22:	c1 e8 0c             	shr    $0xc,%eax
  802b25:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802b28:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802b2f:	e9 c8 00 00 00       	jmp    802bfc <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802b34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b37:	89 d0                	mov    %edx,%eax
  802b39:	01 c0                	add    %eax,%eax
  802b3b:	01 d0                	add    %edx,%eax
  802b3d:	c1 e0 02             	shl    $0x2,%eax
  802b40:	05 68 50 80 00       	add    $0x805068,%eax
  802b45:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802b4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b4d:	89 d0                	mov    %edx,%eax
  802b4f:	01 c0                	add    %eax,%eax
  802b51:	01 d0                	add    %edx,%eax
  802b53:	c1 e0 02             	shl    $0x2,%eax
  802b56:	05 6a 50 80 00       	add    $0x80506a,%eax
  802b5b:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802b60:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802b66:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b69:	89 c8                	mov    %ecx,%eax
  802b6b:	01 c0                	add    %eax,%eax
  802b6d:	01 c8                	add    %ecx,%eax
  802b6f:	c1 e0 02             	shl    $0x2,%eax
  802b72:	05 64 50 80 00       	add    $0x805064,%eax
  802b77:	89 10                	mov    %edx,(%eax)
  802b79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7c:	89 d0                	mov    %edx,%eax
  802b7e:	01 c0                	add    %eax,%eax
  802b80:	01 d0                	add    %edx,%eax
  802b82:	c1 e0 02             	shl    $0x2,%eax
  802b85:	05 64 50 80 00       	add    $0x805064,%eax
  802b8a:	8b 00                	mov    (%eax),%eax
  802b8c:	85 c0                	test   %eax,%eax
  802b8e:	74 1b                	je     802bab <initialize_dynamic_allocator+0x147>
  802b90:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802b96:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b99:	89 c8                	mov    %ecx,%eax
  802b9b:	01 c0                	add    %eax,%eax
  802b9d:	01 c8                	add    %ecx,%eax
  802b9f:	c1 e0 02             	shl    $0x2,%eax
  802ba2:	05 60 50 80 00       	add    $0x805060,%eax
  802ba7:	89 02                	mov    %eax,(%edx)
  802ba9:	eb 16                	jmp    802bc1 <initialize_dynamic_allocator+0x15d>
  802bab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bae:	89 d0                	mov    %edx,%eax
  802bb0:	01 c0                	add    %eax,%eax
  802bb2:	01 d0                	add    %edx,%eax
  802bb4:	c1 e0 02             	shl    $0x2,%eax
  802bb7:	05 60 50 80 00       	add    $0x805060,%eax
  802bbc:	a3 48 50 80 00       	mov    %eax,0x805048
  802bc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc4:	89 d0                	mov    %edx,%eax
  802bc6:	01 c0                	add    %eax,%eax
  802bc8:	01 d0                	add    %edx,%eax
  802bca:	c1 e0 02             	shl    $0x2,%eax
  802bcd:	05 60 50 80 00       	add    $0x805060,%eax
  802bd2:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802bd7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bda:	89 d0                	mov    %edx,%eax
  802bdc:	01 c0                	add    %eax,%eax
  802bde:	01 d0                	add    %edx,%eax
  802be0:	c1 e0 02             	shl    $0x2,%eax
  802be3:	05 60 50 80 00       	add    $0x805060,%eax
  802be8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bee:	a1 54 50 80 00       	mov    0x805054,%eax
  802bf3:	40                   	inc    %eax
  802bf4:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802bf9:	ff 45 f0             	incl   -0x10(%ebp)
  802bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bff:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c02:	0f 82 2c ff ff ff    	jb     802b34 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802c08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c0e:	eb 2f                	jmp    802c3f <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802c10:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c13:	89 d0                	mov    %edx,%eax
  802c15:	01 c0                	add    %eax,%eax
  802c17:	01 d0                	add    %edx,%eax
  802c19:	c1 e0 02             	shl    $0x2,%eax
  802c1c:	05 68 50 80 00       	add    $0x805068,%eax
  802c21:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802c26:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c29:	89 d0                	mov    %edx,%eax
  802c2b:	01 c0                	add    %eax,%eax
  802c2d:	01 d0                	add    %edx,%eax
  802c2f:	c1 e0 02             	shl    $0x2,%eax
  802c32:	05 6a 50 80 00       	add    $0x80506a,%eax
  802c37:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802c3c:	ff 45 ec             	incl   -0x14(%ebp)
  802c3f:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802c46:	76 c8                	jbe    802c10 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802c48:	90                   	nop
  802c49:	c9                   	leave  
  802c4a:	c3                   	ret    

00802c4b <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802c4b:	55                   	push   %ebp
  802c4c:	89 e5                	mov    %esp,%ebp
  802c4e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802c51:	8b 55 08             	mov    0x8(%ebp),%edx
  802c54:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802c59:	29 c2                	sub    %eax,%edx
  802c5b:	89 d0                	mov    %edx,%eax
  802c5d:	c1 e8 0c             	shr    $0xc,%eax
  802c60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802c63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c66:	89 d0                	mov    %edx,%eax
  802c68:	01 c0                	add    %eax,%eax
  802c6a:	01 d0                	add    %edx,%eax
  802c6c:	c1 e0 02             	shl    $0x2,%eax
  802c6f:	05 68 50 80 00       	add    $0x805068,%eax
  802c74:	8b 00                	mov    (%eax),%eax
  802c76:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802c79:	c9                   	leave  
  802c7a:	c3                   	ret    

00802c7b <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802c7b:	55                   	push   %ebp
  802c7c:	89 e5                	mov    %esp,%ebp
  802c7e:	83 ec 14             	sub    $0x14,%esp
  802c81:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802c84:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802c88:	77 07                	ja     802c91 <nearest_pow2_ceil.1513+0x16>
  802c8a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c8f:	eb 20                	jmp    802cb1 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802c91:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802c98:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802c9b:	eb 08                	jmp    802ca5 <nearest_pow2_ceil.1513+0x2a>
  802c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ca0:	01 c0                	add    %eax,%eax
  802ca2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ca5:	d1 6d 08             	shrl   0x8(%ebp)
  802ca8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cac:	75 ef                	jne    802c9d <nearest_pow2_ceil.1513+0x22>
        return power;
  802cae:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802cb1:	c9                   	leave  
  802cb2:	c3                   	ret    

00802cb3 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802cb3:	55                   	push   %ebp
  802cb4:	89 e5                	mov    %esp,%ebp
  802cb6:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802cb9:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802cc0:	76 16                	jbe    802cd8 <alloc_block+0x25>
  802cc2:	68 24 47 80 00       	push   $0x804724
  802cc7:	68 0e 47 80 00       	push   $0x80470e
  802ccc:	6a 72                	push   $0x72
  802cce:	68 ab 46 80 00       	push   $0x8046ab
  802cd3:	e8 ed 09 00 00       	call   8036c5 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802cd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cdc:	75 0a                	jne    802ce8 <alloc_block+0x35>
  802cde:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce3:	e9 bd 04 00 00       	jmp    8031a5 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802ce8:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802cf5:	73 06                	jae    802cfd <alloc_block+0x4a>
        size = min_block_size;
  802cf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfa:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802cfd:	83 ec 0c             	sub    $0xc,%esp
  802d00:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802d03:	ff 75 08             	pushl  0x8(%ebp)
  802d06:	89 c1                	mov    %eax,%ecx
  802d08:	e8 6e ff ff ff       	call   802c7b <nearest_pow2_ceil.1513>
  802d0d:	83 c4 10             	add    $0x10,%esp
  802d10:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802d13:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d16:	83 ec 0c             	sub    $0xc,%esp
  802d19:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802d1c:	52                   	push   %edx
  802d1d:	89 c1                	mov    %eax,%ecx
  802d1f:	e8 83 04 00 00       	call   8031a7 <log2_ceil.1520>
  802d24:	83 c4 10             	add    $0x10,%esp
  802d27:	83 e8 03             	sub    $0x3,%eax
  802d2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802d2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d30:	c1 e0 04             	shl    $0x4,%eax
  802d33:	05 80 d0 81 00       	add    $0x81d080,%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	0f 84 d8 00 00 00    	je     802e1a <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802d42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d45:	c1 e0 04             	shl    $0x4,%eax
  802d48:	05 80 d0 81 00       	add    $0x81d080,%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802d52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d56:	75 17                	jne    802d6f <alloc_block+0xbc>
  802d58:	83 ec 04             	sub    $0x4,%esp
  802d5b:	68 45 47 80 00       	push   $0x804745
  802d60:	68 98 00 00 00       	push   $0x98
  802d65:	68 ab 46 80 00       	push   $0x8046ab
  802d6a:	e8 56 09 00 00       	call   8036c5 <_panic>
  802d6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d72:	8b 00                	mov    (%eax),%eax
  802d74:	85 c0                	test   %eax,%eax
  802d76:	74 10                	je     802d88 <alloc_block+0xd5>
  802d78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d7b:	8b 00                	mov    (%eax),%eax
  802d7d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d80:	8b 52 04             	mov    0x4(%edx),%edx
  802d83:	89 50 04             	mov    %edx,0x4(%eax)
  802d86:	eb 14                	jmp    802d9c <alloc_block+0xe9>
  802d88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d8b:	8b 40 04             	mov    0x4(%eax),%eax
  802d8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d91:	c1 e2 04             	shl    $0x4,%edx
  802d94:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802d9a:	89 02                	mov    %eax,(%edx)
  802d9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d9f:	8b 40 04             	mov    0x4(%eax),%eax
  802da2:	85 c0                	test   %eax,%eax
  802da4:	74 0f                	je     802db5 <alloc_block+0x102>
  802da6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da9:	8b 40 04             	mov    0x4(%eax),%eax
  802dac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802daf:	8b 12                	mov    (%edx),%edx
  802db1:	89 10                	mov    %edx,(%eax)
  802db3:	eb 13                	jmp    802dc8 <alloc_block+0x115>
  802db5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db8:	8b 00                	mov    (%eax),%eax
  802dba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dbd:	c1 e2 04             	shl    $0x4,%edx
  802dc0:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802dc6:	89 02                	mov    %eax,(%edx)
  802dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dde:	c1 e0 04             	shl    $0x4,%eax
  802de1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802de6:	8b 00                	mov    (%eax),%eax
  802de8:	8d 50 ff             	lea    -0x1(%eax),%edx
  802deb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dee:	c1 e0 04             	shl    $0x4,%eax
  802df1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802df6:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802df8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dfb:	83 ec 0c             	sub    $0xc,%esp
  802dfe:	50                   	push   %eax
  802dff:	e8 12 fc ff ff       	call   802a16 <to_page_info>
  802e04:	83 c4 10             	add    $0x10,%esp
  802e07:	89 c2                	mov    %eax,%edx
  802e09:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802e0d:	48                   	dec    %eax
  802e0e:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802e12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e15:	e9 8b 03 00 00       	jmp    8031a5 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802e1a:	a1 48 50 80 00       	mov    0x805048,%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	0f 84 64 02 00 00    	je     80308b <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802e27:	a1 48 50 80 00       	mov    0x805048,%eax
  802e2c:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802e2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e33:	75 17                	jne    802e4c <alloc_block+0x199>
  802e35:	83 ec 04             	sub    $0x4,%esp
  802e38:	68 45 47 80 00       	push   $0x804745
  802e3d:	68 a0 00 00 00       	push   $0xa0
  802e42:	68 ab 46 80 00       	push   $0x8046ab
  802e47:	e8 79 08 00 00       	call   8036c5 <_panic>
  802e4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e4f:	8b 00                	mov    (%eax),%eax
  802e51:	85 c0                	test   %eax,%eax
  802e53:	74 10                	je     802e65 <alloc_block+0x1b2>
  802e55:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e58:	8b 00                	mov    (%eax),%eax
  802e5a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e5d:	8b 52 04             	mov    0x4(%edx),%edx
  802e60:	89 50 04             	mov    %edx,0x4(%eax)
  802e63:	eb 0b                	jmp    802e70 <alloc_block+0x1bd>
  802e65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e68:	8b 40 04             	mov    0x4(%eax),%eax
  802e6b:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802e70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e73:	8b 40 04             	mov    0x4(%eax),%eax
  802e76:	85 c0                	test   %eax,%eax
  802e78:	74 0f                	je     802e89 <alloc_block+0x1d6>
  802e7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e7d:	8b 40 04             	mov    0x4(%eax),%eax
  802e80:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e83:	8b 12                	mov    (%edx),%edx
  802e85:	89 10                	mov    %edx,(%eax)
  802e87:	eb 0a                	jmp    802e93 <alloc_block+0x1e0>
  802e89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e8c:	8b 00                	mov    (%eax),%eax
  802e8e:	a3 48 50 80 00       	mov    %eax,0x805048
  802e93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea6:	a1 54 50 80 00       	mov    0x805054,%eax
  802eab:	48                   	dec    %eax
  802eac:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802eb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802eb7:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802ebb:	b8 00 10 00 00       	mov    $0x1000,%eax
  802ec0:	99                   	cltd   
  802ec1:	f7 7d e8             	idivl  -0x18(%ebp)
  802ec4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ec7:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802ecb:	83 ec 0c             	sub    $0xc,%esp
  802ece:	ff 75 dc             	pushl  -0x24(%ebp)
  802ed1:	e8 ce fa ff ff       	call   8029a4 <to_page_va>
  802ed6:	83 c4 10             	add    $0x10,%esp
  802ed9:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802edc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802edf:	83 ec 0c             	sub    $0xc,%esp
  802ee2:	50                   	push   %eax
  802ee3:	e8 c0 ee ff ff       	call   801da8 <get_page>
  802ee8:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802eeb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ef2:	e9 aa 00 00 00       	jmp    802fa1 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802efe:	89 c2                	mov    %eax,%edx
  802f00:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f03:	01 d0                	add    %edx,%eax
  802f05:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802f08:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802f0c:	75 17                	jne    802f25 <alloc_block+0x272>
  802f0e:	83 ec 04             	sub    $0x4,%esp
  802f11:	68 64 47 80 00       	push   $0x804764
  802f16:	68 aa 00 00 00       	push   $0xaa
  802f1b:	68 ab 46 80 00       	push   $0x8046ab
  802f20:	e8 a0 07 00 00       	call   8036c5 <_panic>
  802f25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f28:	c1 e0 04             	shl    $0x4,%eax
  802f2b:	05 84 d0 81 00       	add    $0x81d084,%eax
  802f30:	8b 10                	mov    (%eax),%edx
  802f32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f35:	89 50 04             	mov    %edx,0x4(%eax)
  802f38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f3b:	8b 40 04             	mov    0x4(%eax),%eax
  802f3e:	85 c0                	test   %eax,%eax
  802f40:	74 14                	je     802f56 <alloc_block+0x2a3>
  802f42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f45:	c1 e0 04             	shl    $0x4,%eax
  802f48:	05 84 d0 81 00       	add    $0x81d084,%eax
  802f4d:	8b 00                	mov    (%eax),%eax
  802f4f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f52:	89 10                	mov    %edx,(%eax)
  802f54:	eb 11                	jmp    802f67 <alloc_block+0x2b4>
  802f56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f59:	c1 e0 04             	shl    $0x4,%eax
  802f5c:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802f62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f65:	89 02                	mov    %eax,(%edx)
  802f67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f6a:	c1 e0 04             	shl    $0x4,%eax
  802f6d:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802f73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f76:	89 02                	mov    %eax,(%edx)
  802f78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f84:	c1 e0 04             	shl    $0x4,%eax
  802f87:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f8c:	8b 00                	mov    (%eax),%eax
  802f8e:	8d 50 01             	lea    0x1(%eax),%edx
  802f91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f94:	c1 e0 04             	shl    $0x4,%eax
  802f97:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f9c:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802f9e:	ff 45 f4             	incl   -0xc(%ebp)
  802fa1:	b8 00 10 00 00       	mov    $0x1000,%eax
  802fa6:	99                   	cltd   
  802fa7:	f7 7d e8             	idivl  -0x18(%ebp)
  802faa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802fad:	0f 8f 44 ff ff ff    	jg     802ef7 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802fb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb6:	c1 e0 04             	shl    $0x4,%eax
  802fb9:	05 80 d0 81 00       	add    $0x81d080,%eax
  802fbe:	8b 00                	mov    (%eax),%eax
  802fc0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802fc3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802fc7:	75 17                	jne    802fe0 <alloc_block+0x32d>
  802fc9:	83 ec 04             	sub    $0x4,%esp
  802fcc:	68 45 47 80 00       	push   $0x804745
  802fd1:	68 ae 00 00 00       	push   $0xae
  802fd6:	68 ab 46 80 00       	push   $0x8046ab
  802fdb:	e8 e5 06 00 00       	call   8036c5 <_panic>
  802fe0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fe3:	8b 00                	mov    (%eax),%eax
  802fe5:	85 c0                	test   %eax,%eax
  802fe7:	74 10                	je     802ff9 <alloc_block+0x346>
  802fe9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fec:	8b 00                	mov    (%eax),%eax
  802fee:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802ff1:	8b 52 04             	mov    0x4(%edx),%edx
  802ff4:	89 50 04             	mov    %edx,0x4(%eax)
  802ff7:	eb 14                	jmp    80300d <alloc_block+0x35a>
  802ff9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ffc:	8b 40 04             	mov    0x4(%eax),%eax
  802fff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803002:	c1 e2 04             	shl    $0x4,%edx
  803005:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80300b:	89 02                	mov    %eax,(%edx)
  80300d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803010:	8b 40 04             	mov    0x4(%eax),%eax
  803013:	85 c0                	test   %eax,%eax
  803015:	74 0f                	je     803026 <alloc_block+0x373>
  803017:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80301a:	8b 40 04             	mov    0x4(%eax),%eax
  80301d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803020:	8b 12                	mov    (%edx),%edx
  803022:	89 10                	mov    %edx,(%eax)
  803024:	eb 13                	jmp    803039 <alloc_block+0x386>
  803026:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803029:	8b 00                	mov    (%eax),%eax
  80302b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80302e:	c1 e2 04             	shl    $0x4,%edx
  803031:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803037:	89 02                	mov    %eax,(%edx)
  803039:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80303c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803042:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803045:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80304f:	c1 e0 04             	shl    $0x4,%eax
  803052:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803057:	8b 00                	mov    (%eax),%eax
  803059:	8d 50 ff             	lea    -0x1(%eax),%edx
  80305c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305f:	c1 e0 04             	shl    $0x4,%eax
  803062:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803067:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803069:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80306c:	83 ec 0c             	sub    $0xc,%esp
  80306f:	50                   	push   %eax
  803070:	e8 a1 f9 ff ff       	call   802a16 <to_page_info>
  803075:	83 c4 10             	add    $0x10,%esp
  803078:	89 c2                	mov    %eax,%edx
  80307a:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80307e:	48                   	dec    %eax
  80307f:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  803083:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803086:	e9 1a 01 00 00       	jmp    8031a5 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  80308b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80308e:	40                   	inc    %eax
  80308f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803092:	e9 ed 00 00 00       	jmp    803184 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  803097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309a:	c1 e0 04             	shl    $0x4,%eax
  80309d:	05 80 d0 81 00       	add    $0x81d080,%eax
  8030a2:	8b 00                	mov    (%eax),%eax
  8030a4:	85 c0                	test   %eax,%eax
  8030a6:	0f 84 d5 00 00 00    	je     803181 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  8030ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030af:	c1 e0 04             	shl    $0x4,%eax
  8030b2:	05 80 d0 81 00       	add    $0x81d080,%eax
  8030b7:	8b 00                	mov    (%eax),%eax
  8030b9:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  8030bc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030c0:	75 17                	jne    8030d9 <alloc_block+0x426>
  8030c2:	83 ec 04             	sub    $0x4,%esp
  8030c5:	68 45 47 80 00       	push   $0x804745
  8030ca:	68 b8 00 00 00       	push   $0xb8
  8030cf:	68 ab 46 80 00       	push   $0x8046ab
  8030d4:	e8 ec 05 00 00       	call   8036c5 <_panic>
  8030d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030dc:	8b 00                	mov    (%eax),%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	74 10                	je     8030f2 <alloc_block+0x43f>
  8030e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030e5:	8b 00                	mov    (%eax),%eax
  8030e7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030ea:	8b 52 04             	mov    0x4(%edx),%edx
  8030ed:	89 50 04             	mov    %edx,0x4(%eax)
  8030f0:	eb 14                	jmp    803106 <alloc_block+0x453>
  8030f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030f5:	8b 40 04             	mov    0x4(%eax),%eax
  8030f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030fb:	c1 e2 04             	shl    $0x4,%edx
  8030fe:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803104:	89 02                	mov    %eax,(%edx)
  803106:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803109:	8b 40 04             	mov    0x4(%eax),%eax
  80310c:	85 c0                	test   %eax,%eax
  80310e:	74 0f                	je     80311f <alloc_block+0x46c>
  803110:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803113:	8b 40 04             	mov    0x4(%eax),%eax
  803116:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803119:	8b 12                	mov    (%edx),%edx
  80311b:	89 10                	mov    %edx,(%eax)
  80311d:	eb 13                	jmp    803132 <alloc_block+0x47f>
  80311f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803122:	8b 00                	mov    (%eax),%eax
  803124:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803127:	c1 e2 04             	shl    $0x4,%edx
  80312a:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803130:	89 02                	mov    %eax,(%edx)
  803132:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803135:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80313e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803145:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803148:	c1 e0 04             	shl    $0x4,%eax
  80314b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803150:	8b 00                	mov    (%eax),%eax
  803152:	8d 50 ff             	lea    -0x1(%eax),%edx
  803155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803158:	c1 e0 04             	shl    $0x4,%eax
  80315b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803160:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  803162:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803165:	83 ec 0c             	sub    $0xc,%esp
  803168:	50                   	push   %eax
  803169:	e8 a8 f8 ff ff       	call   802a16 <to_page_info>
  80316e:	83 c4 10             	add    $0x10,%esp
  803171:	89 c2                	mov    %eax,%edx
  803173:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803177:	48                   	dec    %eax
  803178:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  80317c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80317f:	eb 24                	jmp    8031a5 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803181:	ff 45 f0             	incl   -0x10(%ebp)
  803184:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803188:	0f 8e 09 ff ff ff    	jle    803097 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  80318e:	83 ec 04             	sub    $0x4,%esp
  803191:	68 87 47 80 00       	push   $0x804787
  803196:	68 bf 00 00 00       	push   $0xbf
  80319b:	68 ab 46 80 00       	push   $0x8046ab
  8031a0:	e8 20 05 00 00       	call   8036c5 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8031a5:	c9                   	leave  
  8031a6:	c3                   	ret    

008031a7 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  8031a7:	55                   	push   %ebp
  8031a8:	89 e5                	mov    %esp,%ebp
  8031aa:	83 ec 14             	sub    $0x14,%esp
  8031ad:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  8031b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b4:	75 07                	jne    8031bd <log2_ceil.1520+0x16>
  8031b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8031bb:	eb 1b                	jmp    8031d8 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  8031bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  8031c4:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  8031c7:	eb 06                	jmp    8031cf <log2_ceil.1520+0x28>
            x >>= 1;
  8031c9:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  8031cc:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8031cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d3:	75 f4                	jne    8031c9 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  8031d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8031d8:	c9                   	leave  
  8031d9:	c3                   	ret    

008031da <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  8031da:	55                   	push   %ebp
  8031db:	89 e5                	mov    %esp,%ebp
  8031dd:	83 ec 14             	sub    $0x14,%esp
  8031e0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  8031e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e7:	75 07                	jne    8031f0 <log2_ceil.1547+0x16>
  8031e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ee:	eb 1b                	jmp    80320b <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  8031f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  8031f7:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  8031fa:	eb 06                	jmp    803202 <log2_ceil.1547+0x28>
			x >>= 1;
  8031fc:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  8031ff:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  803202:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803206:	75 f4                	jne    8031fc <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  803208:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80320b:	c9                   	leave  
  80320c:	c3                   	ret    

0080320d <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80320d:	55                   	push   %ebp
  80320e:	89 e5                	mov    %esp,%ebp
  803210:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803213:	8b 55 08             	mov    0x8(%ebp),%edx
  803216:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80321b:	39 c2                	cmp    %eax,%edx
  80321d:	72 0c                	jb     80322b <free_block+0x1e>
  80321f:	8b 55 08             	mov    0x8(%ebp),%edx
  803222:	a1 40 50 80 00       	mov    0x805040,%eax
  803227:	39 c2                	cmp    %eax,%edx
  803229:	72 19                	jb     803244 <free_block+0x37>
  80322b:	68 8c 47 80 00       	push   $0x80478c
  803230:	68 0e 47 80 00       	push   $0x80470e
  803235:	68 d0 00 00 00       	push   $0xd0
  80323a:	68 ab 46 80 00       	push   $0x8046ab
  80323f:	e8 81 04 00 00       	call   8036c5 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803244:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803248:	0f 84 42 03 00 00    	je     803590 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  80324e:	8b 55 08             	mov    0x8(%ebp),%edx
  803251:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803256:	39 c2                	cmp    %eax,%edx
  803258:	72 0c                	jb     803266 <free_block+0x59>
  80325a:	8b 55 08             	mov    0x8(%ebp),%edx
  80325d:	a1 40 50 80 00       	mov    0x805040,%eax
  803262:	39 c2                	cmp    %eax,%edx
  803264:	72 17                	jb     80327d <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803266:	83 ec 04             	sub    $0x4,%esp
  803269:	68 c4 47 80 00       	push   $0x8047c4
  80326e:	68 e6 00 00 00       	push   $0xe6
  803273:	68 ab 46 80 00       	push   $0x8046ab
  803278:	e8 48 04 00 00       	call   8036c5 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  80327d:	8b 55 08             	mov    0x8(%ebp),%edx
  803280:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803285:	29 c2                	sub    %eax,%edx
  803287:	89 d0                	mov    %edx,%eax
  803289:	83 e0 07             	and    $0x7,%eax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	74 17                	je     8032a7 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803290:	83 ec 04             	sub    $0x4,%esp
  803293:	68 f8 47 80 00       	push   $0x8047f8
  803298:	68 ea 00 00 00       	push   $0xea
  80329d:	68 ab 46 80 00       	push   $0x8046ab
  8032a2:	e8 1e 04 00 00       	call   8036c5 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8032a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032aa:	83 ec 0c             	sub    $0xc,%esp
  8032ad:	50                   	push   %eax
  8032ae:	e8 63 f7 ff ff       	call   802a16 <to_page_info>
  8032b3:	83 c4 10             	add    $0x10,%esp
  8032b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8032b9:	83 ec 0c             	sub    $0xc,%esp
  8032bc:	ff 75 08             	pushl  0x8(%ebp)
  8032bf:	e8 87 f9 ff ff       	call   802c4b <get_block_size>
  8032c4:	83 c4 10             	add    $0x10,%esp
  8032c7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8032ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ce:	75 17                	jne    8032e7 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8032d0:	83 ec 04             	sub    $0x4,%esp
  8032d3:	68 24 48 80 00       	push   $0x804824
  8032d8:	68 f1 00 00 00       	push   $0xf1
  8032dd:	68 ab 46 80 00       	push   $0x8046ab
  8032e2:	e8 de 03 00 00       	call   8036c5 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8032e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ea:	83 ec 0c             	sub    $0xc,%esp
  8032ed:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8032f0:	52                   	push   %edx
  8032f1:	89 c1                	mov    %eax,%ecx
  8032f3:	e8 e2 fe ff ff       	call   8031da <log2_ceil.1547>
  8032f8:	83 c4 10             	add    $0x10,%esp
  8032fb:	83 e8 03             	sub    $0x3,%eax
  8032fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803301:	8b 45 08             	mov    0x8(%ebp),%eax
  803304:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  803307:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80330b:	75 17                	jne    803324 <free_block+0x117>
  80330d:	83 ec 04             	sub    $0x4,%esp
  803310:	68 70 48 80 00       	push   $0x804870
  803315:	68 f6 00 00 00       	push   $0xf6
  80331a:	68 ab 46 80 00       	push   $0x8046ab
  80331f:	e8 a1 03 00 00       	call   8036c5 <_panic>
  803324:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803327:	c1 e0 04             	shl    $0x4,%eax
  80332a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80332f:	8b 10                	mov    (%eax),%edx
  803331:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803334:	89 10                	mov    %edx,(%eax)
  803336:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	85 c0                	test   %eax,%eax
  80333d:	74 15                	je     803354 <free_block+0x147>
  80333f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803342:	c1 e0 04             	shl    $0x4,%eax
  803345:	05 80 d0 81 00       	add    $0x81d080,%eax
  80334a:	8b 00                	mov    (%eax),%eax
  80334c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80334f:	89 50 04             	mov    %edx,0x4(%eax)
  803352:	eb 11                	jmp    803365 <free_block+0x158>
  803354:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803357:	c1 e0 04             	shl    $0x4,%eax
  80335a:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803360:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803363:	89 02                	mov    %eax,(%edx)
  803365:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803368:	c1 e0 04             	shl    $0x4,%eax
  80336b:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803371:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803374:	89 02                	mov    %eax,(%edx)
  803376:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803379:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803380:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803383:	c1 e0 04             	shl    $0x4,%eax
  803386:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80338b:	8b 00                	mov    (%eax),%eax
  80338d:	8d 50 01             	lea    0x1(%eax),%edx
  803390:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803393:	c1 e0 04             	shl    $0x4,%eax
  803396:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80339b:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  80339d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8033a4:	40                   	inc    %eax
  8033a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033a8:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8033ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8033af:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8033b4:	29 c2                	sub    %eax,%edx
  8033b6:	89 d0                	mov    %edx,%eax
  8033b8:	c1 e8 0c             	shr    $0xc,%eax
  8033bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8033be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c1:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8033c5:	0f b7 c8             	movzwl %ax,%ecx
  8033c8:	b8 00 10 00 00       	mov    $0x1000,%eax
  8033cd:	99                   	cltd   
  8033ce:	f7 7d e8             	idivl  -0x18(%ebp)
  8033d1:	39 c1                	cmp    %eax,%ecx
  8033d3:	0f 85 b8 01 00 00    	jne    803591 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8033d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8033e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e3:	c1 e0 04             	shl    $0x4,%eax
  8033e6:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033eb:	8b 00                	mov    (%eax),%eax
  8033ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8033f0:	e9 d5 00 00 00       	jmp    8034ca <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  8033f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f8:	8b 00                	mov    (%eax),%eax
  8033fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  8033fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803400:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803405:	29 c2                	sub    %eax,%edx
  803407:	89 d0                	mov    %edx,%eax
  803409:	c1 e8 0c             	shr    $0xc,%eax
  80340c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  80340f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803412:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803415:	0f 85 a9 00 00 00    	jne    8034c4 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  80341b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80341f:	75 17                	jne    803438 <free_block+0x22b>
  803421:	83 ec 04             	sub    $0x4,%esp
  803424:	68 45 47 80 00       	push   $0x804745
  803429:	68 04 01 00 00       	push   $0x104
  80342e:	68 ab 46 80 00       	push   $0x8046ab
  803433:	e8 8d 02 00 00       	call   8036c5 <_panic>
  803438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343b:	8b 00                	mov    (%eax),%eax
  80343d:	85 c0                	test   %eax,%eax
  80343f:	74 10                	je     803451 <free_block+0x244>
  803441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803444:	8b 00                	mov    (%eax),%eax
  803446:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803449:	8b 52 04             	mov    0x4(%edx),%edx
  80344c:	89 50 04             	mov    %edx,0x4(%eax)
  80344f:	eb 14                	jmp    803465 <free_block+0x258>
  803451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803454:	8b 40 04             	mov    0x4(%eax),%eax
  803457:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80345a:	c1 e2 04             	shl    $0x4,%edx
  80345d:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803463:	89 02                	mov    %eax,(%edx)
  803465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803468:	8b 40 04             	mov    0x4(%eax),%eax
  80346b:	85 c0                	test   %eax,%eax
  80346d:	74 0f                	je     80347e <free_block+0x271>
  80346f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803472:	8b 40 04             	mov    0x4(%eax),%eax
  803475:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803478:	8b 12                	mov    (%edx),%edx
  80347a:	89 10                	mov    %edx,(%eax)
  80347c:	eb 13                	jmp    803491 <free_block+0x284>
  80347e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803481:	8b 00                	mov    (%eax),%eax
  803483:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803486:	c1 e2 04             	shl    $0x4,%edx
  803489:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80348f:	89 02                	mov    %eax,(%edx)
  803491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803494:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80349a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a7:	c1 e0 04             	shl    $0x4,%eax
  8034aa:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8034af:	8b 00                	mov    (%eax),%eax
  8034b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8034b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b7:	c1 e0 04             	shl    $0x4,%eax
  8034ba:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8034bf:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8034c1:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8034c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8034ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034ce:	0f 85 21 ff ff ff    	jne    8033f5 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8034d4:	b8 00 10 00 00       	mov    $0x1000,%eax
  8034d9:	99                   	cltd   
  8034da:	f7 7d e8             	idivl  -0x18(%ebp)
  8034dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8034e0:	74 17                	je     8034f9 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8034e2:	83 ec 04             	sub    $0x4,%esp
  8034e5:	68 94 48 80 00       	push   $0x804894
  8034ea:	68 0c 01 00 00       	push   $0x10c
  8034ef:	68 ab 46 80 00       	push   $0x8046ab
  8034f4:	e8 cc 01 00 00       	call   8036c5 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  8034f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034fc:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803505:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  80350b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80350f:	75 17                	jne    803528 <free_block+0x31b>
  803511:	83 ec 04             	sub    $0x4,%esp
  803514:	68 64 47 80 00       	push   $0x804764
  803519:	68 11 01 00 00       	push   $0x111
  80351e:	68 ab 46 80 00       	push   $0x8046ab
  803523:	e8 9d 01 00 00       	call   8036c5 <_panic>
  803528:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80352e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803531:	89 50 04             	mov    %edx,0x4(%eax)
  803534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803537:	8b 40 04             	mov    0x4(%eax),%eax
  80353a:	85 c0                	test   %eax,%eax
  80353c:	74 0c                	je     80354a <free_block+0x33d>
  80353e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803543:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803546:	89 10                	mov    %edx,(%eax)
  803548:	eb 08                	jmp    803552 <free_block+0x345>
  80354a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80354d:	a3 48 50 80 00       	mov    %eax,0x805048
  803552:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803555:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80355a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803563:	a1 54 50 80 00       	mov    0x805054,%eax
  803568:	40                   	inc    %eax
  803569:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  80356e:	83 ec 0c             	sub    $0xc,%esp
  803571:	ff 75 ec             	pushl  -0x14(%ebp)
  803574:	e8 2b f4 ff ff       	call   8029a4 <to_page_va>
  803579:	83 c4 10             	add    $0x10,%esp
  80357c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  80357f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803582:	83 ec 0c             	sub    $0xc,%esp
  803585:	50                   	push   %eax
  803586:	e8 69 e8 ff ff       	call   801df4 <return_page>
  80358b:	83 c4 10             	add    $0x10,%esp
  80358e:	eb 01                	jmp    803591 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803590:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803591:	c9                   	leave  
  803592:	c3                   	ret    

00803593 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803593:	55                   	push   %ebp
  803594:	89 e5                	mov    %esp,%ebp
  803596:	83 ec 14             	sub    $0x14,%esp
  803599:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  80359c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8035a0:	77 07                	ja     8035a9 <nearest_pow2_ceil.1572+0x16>
      return 1;
  8035a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035a7:	eb 20                	jmp    8035c9 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8035a9:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8035b0:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8035b3:	eb 08                	jmp    8035bd <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8035b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8035b8:	01 c0                	add    %eax,%eax
  8035ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8035bd:	d1 6d 08             	shrl   0x8(%ebp)
  8035c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035c4:	75 ef                	jne    8035b5 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8035c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8035c9:	c9                   	leave  
  8035ca:	c3                   	ret    

008035cb <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8035cb:	55                   	push   %ebp
  8035cc:	89 e5                	mov    %esp,%ebp
  8035ce:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8035d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035d5:	75 13                	jne    8035ea <realloc_block+0x1f>
    return alloc_block(new_size);
  8035d7:	83 ec 0c             	sub    $0xc,%esp
  8035da:	ff 75 0c             	pushl  0xc(%ebp)
  8035dd:	e8 d1 f6 ff ff       	call   802cb3 <alloc_block>
  8035e2:	83 c4 10             	add    $0x10,%esp
  8035e5:	e9 d9 00 00 00       	jmp    8036c3 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  8035ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035ee:	75 18                	jne    803608 <realloc_block+0x3d>
    free_block(va);
  8035f0:	83 ec 0c             	sub    $0xc,%esp
  8035f3:	ff 75 08             	pushl  0x8(%ebp)
  8035f6:	e8 12 fc ff ff       	call   80320d <free_block>
  8035fb:	83 c4 10             	add    $0x10,%esp
    return NULL;
  8035fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803603:	e9 bb 00 00 00       	jmp    8036c3 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803608:	83 ec 0c             	sub    $0xc,%esp
  80360b:	ff 75 08             	pushl  0x8(%ebp)
  80360e:	e8 38 f6 ff ff       	call   802c4b <get_block_size>
  803613:	83 c4 10             	add    $0x10,%esp
  803616:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803619:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803620:	8b 45 0c             	mov    0xc(%ebp),%eax
  803623:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803626:	73 06                	jae    80362e <realloc_block+0x63>
    new_size = min_block_size;
  803628:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80362b:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  80362e:	83 ec 0c             	sub    $0xc,%esp
  803631:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803634:	ff 75 0c             	pushl  0xc(%ebp)
  803637:	89 c1                	mov    %eax,%ecx
  803639:	e8 55 ff ff ff       	call   803593 <nearest_pow2_ceil.1572>
  80363e:	83 c4 10             	add    $0x10,%esp
  803641:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803647:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80364a:	75 05                	jne    803651 <realloc_block+0x86>
    return va;
  80364c:	8b 45 08             	mov    0x8(%ebp),%eax
  80364f:	eb 72                	jmp    8036c3 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803651:	83 ec 0c             	sub    $0xc,%esp
  803654:	ff 75 0c             	pushl  0xc(%ebp)
  803657:	e8 57 f6 ff ff       	call   802cb3 <alloc_block>
  80365c:	83 c4 10             	add    $0x10,%esp
  80365f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803662:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803666:	75 07                	jne    80366f <realloc_block+0xa4>
    return NULL;
  803668:	b8 00 00 00 00       	mov    $0x0,%eax
  80366d:	eb 54                	jmp    8036c3 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  80366f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803672:	8b 45 0c             	mov    0xc(%ebp),%eax
  803675:	39 d0                	cmp    %edx,%eax
  803677:	76 02                	jbe    80367b <realloc_block+0xb0>
  803679:	89 d0                	mov    %edx,%eax
  80367b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  80367e:	8b 45 08             	mov    0x8(%ebp),%eax
  803681:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803687:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  80368a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803691:	eb 17                	jmp    8036aa <realloc_block+0xdf>
    dst[i] = src[i];
  803693:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803699:	01 c2                	add    %eax,%edx
  80369b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80369e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a1:	01 c8                	add    %ecx,%eax
  8036a3:	8a 00                	mov    (%eax),%al
  8036a5:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  8036a7:	ff 45 f4             	incl   -0xc(%ebp)
  8036aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ad:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036b0:	72 e1                	jb     803693 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  8036b2:	83 ec 0c             	sub    $0xc,%esp
  8036b5:	ff 75 08             	pushl  0x8(%ebp)
  8036b8:	e8 50 fb ff ff       	call   80320d <free_block>
  8036bd:	83 c4 10             	add    $0x10,%esp

  return new_va;
  8036c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8036c3:	c9                   	leave  
  8036c4:	c3                   	ret    

008036c5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8036c5:	55                   	push   %ebp
  8036c6:	89 e5                	mov    %esp,%ebp
  8036c8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8036cb:	8d 45 10             	lea    0x10(%ebp),%eax
  8036ce:	83 c0 04             	add    $0x4,%eax
  8036d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8036d4:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  8036d9:	85 c0                	test   %eax,%eax
  8036db:	74 16                	je     8036f3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8036dd:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  8036e2:	83 ec 08             	sub    $0x8,%esp
  8036e5:	50                   	push   %eax
  8036e6:	68 c8 48 80 00       	push   $0x8048c8
  8036eb:	e8 1c d1 ff ff       	call   80080c <cprintf>
  8036f0:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8036f3:	a1 04 50 80 00       	mov    0x805004,%eax
  8036f8:	83 ec 0c             	sub    $0xc,%esp
  8036fb:	ff 75 0c             	pushl  0xc(%ebp)
  8036fe:	ff 75 08             	pushl  0x8(%ebp)
  803701:	50                   	push   %eax
  803702:	68 d0 48 80 00       	push   $0x8048d0
  803707:	6a 74                	push   $0x74
  803709:	e8 2b d1 ff ff       	call   800839 <cprintf_colored>
  80370e:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803711:	8b 45 10             	mov    0x10(%ebp),%eax
  803714:	83 ec 08             	sub    $0x8,%esp
  803717:	ff 75 f4             	pushl  -0xc(%ebp)
  80371a:	50                   	push   %eax
  80371b:	e8 7d d0 ff ff       	call   80079d <vcprintf>
  803720:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803723:	83 ec 08             	sub    $0x8,%esp
  803726:	6a 00                	push   $0x0
  803728:	68 f8 48 80 00       	push   $0x8048f8
  80372d:	e8 6b d0 ff ff       	call   80079d <vcprintf>
  803732:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803735:	e8 e4 cf ff ff       	call   80071e <exit>

	// should not return here
	while (1) ;
  80373a:	eb fe                	jmp    80373a <_panic+0x75>

0080373c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80373c:	55                   	push   %ebp
  80373d:	89 e5                	mov    %esp,%ebp
  80373f:	53                   	push   %ebx
  803740:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803743:	a1 20 50 80 00       	mov    0x805020,%eax
  803748:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80374e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803751:	39 c2                	cmp    %eax,%edx
  803753:	74 14                	je     803769 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803755:	83 ec 04             	sub    $0x4,%esp
  803758:	68 fc 48 80 00       	push   $0x8048fc
  80375d:	6a 26                	push   $0x26
  80375f:	68 48 49 80 00       	push   $0x804948
  803764:	e8 5c ff ff ff       	call   8036c5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803769:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803770:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803777:	e9 d9 00 00 00       	jmp    803855 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  80377c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80377f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803786:	8b 45 08             	mov    0x8(%ebp),%eax
  803789:	01 d0                	add    %edx,%eax
  80378b:	8b 00                	mov    (%eax),%eax
  80378d:	85 c0                	test   %eax,%eax
  80378f:	75 08                	jne    803799 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  803791:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803794:	e9 b9 00 00 00       	jmp    803852 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  803799:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8037a7:	eb 79                	jmp    803822 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8037a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8037ae:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8037b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037b7:	89 d0                	mov    %edx,%eax
  8037b9:	01 c0                	add    %eax,%eax
  8037bb:	01 d0                	add    %edx,%eax
  8037bd:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8037c4:	01 d8                	add    %ebx,%eax
  8037c6:	01 d0                	add    %edx,%eax
  8037c8:	01 c8                	add    %ecx,%eax
  8037ca:	8a 40 04             	mov    0x4(%eax),%al
  8037cd:	84 c0                	test   %al,%al
  8037cf:	75 4e                	jne    80381f <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8037d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8037d6:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8037dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037df:	89 d0                	mov    %edx,%eax
  8037e1:	01 c0                	add    %eax,%eax
  8037e3:	01 d0                	add    %edx,%eax
  8037e5:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8037ec:	01 d8                	add    %ebx,%eax
  8037ee:	01 d0                	add    %edx,%eax
  8037f0:	01 c8                	add    %ecx,%eax
  8037f2:	8b 00                	mov    (%eax),%eax
  8037f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8037f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8037ff:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803804:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80380b:	8b 45 08             	mov    0x8(%ebp),%eax
  80380e:	01 c8                	add    %ecx,%eax
  803810:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803812:	39 c2                	cmp    %eax,%edx
  803814:	75 09                	jne    80381f <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  803816:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80381d:	eb 19                	jmp    803838 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80381f:	ff 45 e8             	incl   -0x18(%ebp)
  803822:	a1 20 50 80 00       	mov    0x805020,%eax
  803827:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80382d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803830:	39 c2                	cmp    %eax,%edx
  803832:	0f 87 71 ff ff ff    	ja     8037a9 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803838:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80383c:	75 14                	jne    803852 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80383e:	83 ec 04             	sub    $0x4,%esp
  803841:	68 54 49 80 00       	push   $0x804954
  803846:	6a 3a                	push   $0x3a
  803848:	68 48 49 80 00       	push   $0x804948
  80384d:	e8 73 fe ff ff       	call   8036c5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803852:	ff 45 f0             	incl   -0x10(%ebp)
  803855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803858:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80385b:	0f 8c 1b ff ff ff    	jl     80377c <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803861:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803868:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80386f:	eb 2e                	jmp    80389f <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803871:	a1 20 50 80 00       	mov    0x805020,%eax
  803876:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80387c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80387f:	89 d0                	mov    %edx,%eax
  803881:	01 c0                	add    %eax,%eax
  803883:	01 d0                	add    %edx,%eax
  803885:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80388c:	01 d8                	add    %ebx,%eax
  80388e:	01 d0                	add    %edx,%eax
  803890:	01 c8                	add    %ecx,%eax
  803892:	8a 40 04             	mov    0x4(%eax),%al
  803895:	3c 01                	cmp    $0x1,%al
  803897:	75 03                	jne    80389c <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  803899:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80389c:	ff 45 e0             	incl   -0x20(%ebp)
  80389f:	a1 20 50 80 00       	mov    0x805020,%eax
  8038a4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8038aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038ad:	39 c2                	cmp    %eax,%edx
  8038af:	77 c0                	ja     803871 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8038b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8038b7:	74 14                	je     8038cd <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8038b9:	83 ec 04             	sub    $0x4,%esp
  8038bc:	68 a8 49 80 00       	push   $0x8049a8
  8038c1:	6a 44                	push   $0x44
  8038c3:	68 48 49 80 00       	push   $0x804948
  8038c8:	e8 f8 fd ff ff       	call   8036c5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8038cd:	90                   	nop
  8038ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8038d1:	c9                   	leave  
  8038d2:	c3                   	ret    
  8038d3:	90                   	nop

008038d4 <__udivdi3>:
  8038d4:	55                   	push   %ebp
  8038d5:	57                   	push   %edi
  8038d6:	56                   	push   %esi
  8038d7:	53                   	push   %ebx
  8038d8:	83 ec 1c             	sub    $0x1c,%esp
  8038db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038eb:	89 ca                	mov    %ecx,%edx
  8038ed:	89 f8                	mov    %edi,%eax
  8038ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038f3:	85 f6                	test   %esi,%esi
  8038f5:	75 2d                	jne    803924 <__udivdi3+0x50>
  8038f7:	39 cf                	cmp    %ecx,%edi
  8038f9:	77 65                	ja     803960 <__udivdi3+0x8c>
  8038fb:	89 fd                	mov    %edi,%ebp
  8038fd:	85 ff                	test   %edi,%edi
  8038ff:	75 0b                	jne    80390c <__udivdi3+0x38>
  803901:	b8 01 00 00 00       	mov    $0x1,%eax
  803906:	31 d2                	xor    %edx,%edx
  803908:	f7 f7                	div    %edi
  80390a:	89 c5                	mov    %eax,%ebp
  80390c:	31 d2                	xor    %edx,%edx
  80390e:	89 c8                	mov    %ecx,%eax
  803910:	f7 f5                	div    %ebp
  803912:	89 c1                	mov    %eax,%ecx
  803914:	89 d8                	mov    %ebx,%eax
  803916:	f7 f5                	div    %ebp
  803918:	89 cf                	mov    %ecx,%edi
  80391a:	89 fa                	mov    %edi,%edx
  80391c:	83 c4 1c             	add    $0x1c,%esp
  80391f:	5b                   	pop    %ebx
  803920:	5e                   	pop    %esi
  803921:	5f                   	pop    %edi
  803922:	5d                   	pop    %ebp
  803923:	c3                   	ret    
  803924:	39 ce                	cmp    %ecx,%esi
  803926:	77 28                	ja     803950 <__udivdi3+0x7c>
  803928:	0f bd fe             	bsr    %esi,%edi
  80392b:	83 f7 1f             	xor    $0x1f,%edi
  80392e:	75 40                	jne    803970 <__udivdi3+0x9c>
  803930:	39 ce                	cmp    %ecx,%esi
  803932:	72 0a                	jb     80393e <__udivdi3+0x6a>
  803934:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803938:	0f 87 9e 00 00 00    	ja     8039dc <__udivdi3+0x108>
  80393e:	b8 01 00 00 00       	mov    $0x1,%eax
  803943:	89 fa                	mov    %edi,%edx
  803945:	83 c4 1c             	add    $0x1c,%esp
  803948:	5b                   	pop    %ebx
  803949:	5e                   	pop    %esi
  80394a:	5f                   	pop    %edi
  80394b:	5d                   	pop    %ebp
  80394c:	c3                   	ret    
  80394d:	8d 76 00             	lea    0x0(%esi),%esi
  803950:	31 ff                	xor    %edi,%edi
  803952:	31 c0                	xor    %eax,%eax
  803954:	89 fa                	mov    %edi,%edx
  803956:	83 c4 1c             	add    $0x1c,%esp
  803959:	5b                   	pop    %ebx
  80395a:	5e                   	pop    %esi
  80395b:	5f                   	pop    %edi
  80395c:	5d                   	pop    %ebp
  80395d:	c3                   	ret    
  80395e:	66 90                	xchg   %ax,%ax
  803960:	89 d8                	mov    %ebx,%eax
  803962:	f7 f7                	div    %edi
  803964:	31 ff                	xor    %edi,%edi
  803966:	89 fa                	mov    %edi,%edx
  803968:	83 c4 1c             	add    $0x1c,%esp
  80396b:	5b                   	pop    %ebx
  80396c:	5e                   	pop    %esi
  80396d:	5f                   	pop    %edi
  80396e:	5d                   	pop    %ebp
  80396f:	c3                   	ret    
  803970:	bd 20 00 00 00       	mov    $0x20,%ebp
  803975:	89 eb                	mov    %ebp,%ebx
  803977:	29 fb                	sub    %edi,%ebx
  803979:	89 f9                	mov    %edi,%ecx
  80397b:	d3 e6                	shl    %cl,%esi
  80397d:	89 c5                	mov    %eax,%ebp
  80397f:	88 d9                	mov    %bl,%cl
  803981:	d3 ed                	shr    %cl,%ebp
  803983:	89 e9                	mov    %ebp,%ecx
  803985:	09 f1                	or     %esi,%ecx
  803987:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80398b:	89 f9                	mov    %edi,%ecx
  80398d:	d3 e0                	shl    %cl,%eax
  80398f:	89 c5                	mov    %eax,%ebp
  803991:	89 d6                	mov    %edx,%esi
  803993:	88 d9                	mov    %bl,%cl
  803995:	d3 ee                	shr    %cl,%esi
  803997:	89 f9                	mov    %edi,%ecx
  803999:	d3 e2                	shl    %cl,%edx
  80399b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80399f:	88 d9                	mov    %bl,%cl
  8039a1:	d3 e8                	shr    %cl,%eax
  8039a3:	09 c2                	or     %eax,%edx
  8039a5:	89 d0                	mov    %edx,%eax
  8039a7:	89 f2                	mov    %esi,%edx
  8039a9:	f7 74 24 0c          	divl   0xc(%esp)
  8039ad:	89 d6                	mov    %edx,%esi
  8039af:	89 c3                	mov    %eax,%ebx
  8039b1:	f7 e5                	mul    %ebp
  8039b3:	39 d6                	cmp    %edx,%esi
  8039b5:	72 19                	jb     8039d0 <__udivdi3+0xfc>
  8039b7:	74 0b                	je     8039c4 <__udivdi3+0xf0>
  8039b9:	89 d8                	mov    %ebx,%eax
  8039bb:	31 ff                	xor    %edi,%edi
  8039bd:	e9 58 ff ff ff       	jmp    80391a <__udivdi3+0x46>
  8039c2:	66 90                	xchg   %ax,%ax
  8039c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039c8:	89 f9                	mov    %edi,%ecx
  8039ca:	d3 e2                	shl    %cl,%edx
  8039cc:	39 c2                	cmp    %eax,%edx
  8039ce:	73 e9                	jae    8039b9 <__udivdi3+0xe5>
  8039d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039d3:	31 ff                	xor    %edi,%edi
  8039d5:	e9 40 ff ff ff       	jmp    80391a <__udivdi3+0x46>
  8039da:	66 90                	xchg   %ax,%ax
  8039dc:	31 c0                	xor    %eax,%eax
  8039de:	e9 37 ff ff ff       	jmp    80391a <__udivdi3+0x46>
  8039e3:	90                   	nop

008039e4 <__umoddi3>:
  8039e4:	55                   	push   %ebp
  8039e5:	57                   	push   %edi
  8039e6:	56                   	push   %esi
  8039e7:	53                   	push   %ebx
  8039e8:	83 ec 1c             	sub    $0x1c,%esp
  8039eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a03:	89 f3                	mov    %esi,%ebx
  803a05:	89 fa                	mov    %edi,%edx
  803a07:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a0b:	89 34 24             	mov    %esi,(%esp)
  803a0e:	85 c0                	test   %eax,%eax
  803a10:	75 1a                	jne    803a2c <__umoddi3+0x48>
  803a12:	39 f7                	cmp    %esi,%edi
  803a14:	0f 86 a2 00 00 00    	jbe    803abc <__umoddi3+0xd8>
  803a1a:	89 c8                	mov    %ecx,%eax
  803a1c:	89 f2                	mov    %esi,%edx
  803a1e:	f7 f7                	div    %edi
  803a20:	89 d0                	mov    %edx,%eax
  803a22:	31 d2                	xor    %edx,%edx
  803a24:	83 c4 1c             	add    $0x1c,%esp
  803a27:	5b                   	pop    %ebx
  803a28:	5e                   	pop    %esi
  803a29:	5f                   	pop    %edi
  803a2a:	5d                   	pop    %ebp
  803a2b:	c3                   	ret    
  803a2c:	39 f0                	cmp    %esi,%eax
  803a2e:	0f 87 ac 00 00 00    	ja     803ae0 <__umoddi3+0xfc>
  803a34:	0f bd e8             	bsr    %eax,%ebp
  803a37:	83 f5 1f             	xor    $0x1f,%ebp
  803a3a:	0f 84 ac 00 00 00    	je     803aec <__umoddi3+0x108>
  803a40:	bf 20 00 00 00       	mov    $0x20,%edi
  803a45:	29 ef                	sub    %ebp,%edi
  803a47:	89 fe                	mov    %edi,%esi
  803a49:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a4d:	89 e9                	mov    %ebp,%ecx
  803a4f:	d3 e0                	shl    %cl,%eax
  803a51:	89 d7                	mov    %edx,%edi
  803a53:	89 f1                	mov    %esi,%ecx
  803a55:	d3 ef                	shr    %cl,%edi
  803a57:	09 c7                	or     %eax,%edi
  803a59:	89 e9                	mov    %ebp,%ecx
  803a5b:	d3 e2                	shl    %cl,%edx
  803a5d:	89 14 24             	mov    %edx,(%esp)
  803a60:	89 d8                	mov    %ebx,%eax
  803a62:	d3 e0                	shl    %cl,%eax
  803a64:	89 c2                	mov    %eax,%edx
  803a66:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a6a:	d3 e0                	shl    %cl,%eax
  803a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a70:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a74:	89 f1                	mov    %esi,%ecx
  803a76:	d3 e8                	shr    %cl,%eax
  803a78:	09 d0                	or     %edx,%eax
  803a7a:	d3 eb                	shr    %cl,%ebx
  803a7c:	89 da                	mov    %ebx,%edx
  803a7e:	f7 f7                	div    %edi
  803a80:	89 d3                	mov    %edx,%ebx
  803a82:	f7 24 24             	mull   (%esp)
  803a85:	89 c6                	mov    %eax,%esi
  803a87:	89 d1                	mov    %edx,%ecx
  803a89:	39 d3                	cmp    %edx,%ebx
  803a8b:	0f 82 87 00 00 00    	jb     803b18 <__umoddi3+0x134>
  803a91:	0f 84 91 00 00 00    	je     803b28 <__umoddi3+0x144>
  803a97:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a9b:	29 f2                	sub    %esi,%edx
  803a9d:	19 cb                	sbb    %ecx,%ebx
  803a9f:	89 d8                	mov    %ebx,%eax
  803aa1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803aa5:	d3 e0                	shl    %cl,%eax
  803aa7:	89 e9                	mov    %ebp,%ecx
  803aa9:	d3 ea                	shr    %cl,%edx
  803aab:	09 d0                	or     %edx,%eax
  803aad:	89 e9                	mov    %ebp,%ecx
  803aaf:	d3 eb                	shr    %cl,%ebx
  803ab1:	89 da                	mov    %ebx,%edx
  803ab3:	83 c4 1c             	add    $0x1c,%esp
  803ab6:	5b                   	pop    %ebx
  803ab7:	5e                   	pop    %esi
  803ab8:	5f                   	pop    %edi
  803ab9:	5d                   	pop    %ebp
  803aba:	c3                   	ret    
  803abb:	90                   	nop
  803abc:	89 fd                	mov    %edi,%ebp
  803abe:	85 ff                	test   %edi,%edi
  803ac0:	75 0b                	jne    803acd <__umoddi3+0xe9>
  803ac2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ac7:	31 d2                	xor    %edx,%edx
  803ac9:	f7 f7                	div    %edi
  803acb:	89 c5                	mov    %eax,%ebp
  803acd:	89 f0                	mov    %esi,%eax
  803acf:	31 d2                	xor    %edx,%edx
  803ad1:	f7 f5                	div    %ebp
  803ad3:	89 c8                	mov    %ecx,%eax
  803ad5:	f7 f5                	div    %ebp
  803ad7:	89 d0                	mov    %edx,%eax
  803ad9:	e9 44 ff ff ff       	jmp    803a22 <__umoddi3+0x3e>
  803ade:	66 90                	xchg   %ax,%ax
  803ae0:	89 c8                	mov    %ecx,%eax
  803ae2:	89 f2                	mov    %esi,%edx
  803ae4:	83 c4 1c             	add    $0x1c,%esp
  803ae7:	5b                   	pop    %ebx
  803ae8:	5e                   	pop    %esi
  803ae9:	5f                   	pop    %edi
  803aea:	5d                   	pop    %ebp
  803aeb:	c3                   	ret    
  803aec:	3b 04 24             	cmp    (%esp),%eax
  803aef:	72 06                	jb     803af7 <__umoddi3+0x113>
  803af1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803af5:	77 0f                	ja     803b06 <__umoddi3+0x122>
  803af7:	89 f2                	mov    %esi,%edx
  803af9:	29 f9                	sub    %edi,%ecx
  803afb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803aff:	89 14 24             	mov    %edx,(%esp)
  803b02:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b06:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b0a:	8b 14 24             	mov    (%esp),%edx
  803b0d:	83 c4 1c             	add    $0x1c,%esp
  803b10:	5b                   	pop    %ebx
  803b11:	5e                   	pop    %esi
  803b12:	5f                   	pop    %edi
  803b13:	5d                   	pop    %ebp
  803b14:	c3                   	ret    
  803b15:	8d 76 00             	lea    0x0(%esi),%esi
  803b18:	2b 04 24             	sub    (%esp),%eax
  803b1b:	19 fa                	sbb    %edi,%edx
  803b1d:	89 d1                	mov    %edx,%ecx
  803b1f:	89 c6                	mov    %eax,%esi
  803b21:	e9 71 ff ff ff       	jmp    803a97 <__umoddi3+0xb3>
  803b26:	66 90                	xchg   %ax,%ax
  803b28:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b2c:	72 ea                	jb     803b18 <__umoddi3+0x134>
  803b2e:	89 d9                	mov    %ebx,%ecx
  803b30:	e9 62 ff ff ff       	jmp    803a97 <__umoddi3+0xb3>
