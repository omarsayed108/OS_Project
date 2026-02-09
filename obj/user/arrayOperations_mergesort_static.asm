
obj/user/arrayOperations_mergesort_static:     file format elf32-i386


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
  800031:	e8 91 04 00 00       	call   8004c7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 02 26 00 00       	call   802645 <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;

	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  800046:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	68 00 3b 80 00       	push   $0x803b00
  800051:	ff 75 f0             	pushl  -0x10(%ebp)
  800054:	50                   	push   %eax
  800055:	e8 d0 35 00 00       	call   80362a <get_semaphore>
  80005a:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  80005d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 06 3b 80 00       	push   $0x803b06
  800068:	ff 75 f0             	pushl  -0x10(%ebp)
  80006b:	50                   	push   %eax
  80006c:	e8 b9 35 00 00       	call   80362a <get_semaphore>
  800071:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	ff 75 dc             	pushl  -0x24(%ebp)
  80007a:	e8 c5 35 00 00       	call   803644 <wait_semaphore>
  80007f:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	68 0f 3b 80 00       	push   $0x803b0f
  80008a:	ff 75 f0             	pushl  -0x10(%ebp)
  80008d:	e8 10 21 00 00       	call   8021a2 <sget>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
  800098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009b:	8b 10                	mov    (%eax),%edx
  80009d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 22 3b 80 00       	push   $0x803b22
  8000a8:	52                   	push   %edx
  8000a9:	50                   	push   %eax
  8000aa:	e8 7b 35 00 00       	call   80362a <get_semaphore>
  8000af:	83 c4 0c             	add    $0xc,%esp

	//Get the shared array & its size
	int *numOfElements = NULL;
  8000b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  8000b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 30 3b 80 00       	push   $0x803b30
  8000c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000cb:	e8 d2 20 00 00       	call   8021a2 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	68 34 3b 80 00       	push   $0x803b34
  8000de:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e1:	e8 bc 20 00 00       	call   8021a2 <sget>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  8000ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000ef:	8b 00                	mov    (%eax),%eax
  8000f1:	c1 e0 02             	shl    $0x2,%eax
  8000f4:	83 ec 04             	sub    $0x4,%esp
  8000f7:	6a 00                	push   $0x0
  8000f9:	50                   	push   %eax
  8000fa:	68 3c 3b 80 00       	push   $0x803b3c
  8000ff:	e8 3e 1f 00 00       	call   802042 <smalloc>
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  80010a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800111:	eb 25                	jmp    800138 <_main+0x100>
	{
		sortedArray[i] = sharedArray[i];
  800113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800116:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80011d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800120:	01 c2                	add    %eax,%edx
  800122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800125:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80012c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012f:	01 c8                	add    %ecx,%eax
  800131:	8b 00                	mov    (%eax),%eax
  800133:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800135:	ff 45 f4             	incl   -0xc(%ebp)
  800138:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013b:	8b 00                	mov    (%eax),%eax
  80013d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800140:	7f d1                	jg     800113 <_main+0xdb>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  800142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800145:	8b 00                	mov    (%eax),%eax
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	50                   	push   %eax
  80014b:	6a 01                	push   $0x1
  80014d:	ff 75 e0             	pushl  -0x20(%ebp)
  800150:	e8 39 01 00 00       	call   80028e <MSort>
  800155:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(cons_mutex);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015e:	e8 e1 34 00 00       	call   803644 <wait_semaphore>
  800163:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Merge sort is Finished!!!!\n") ;
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	68 4b 3b 80 00       	push   $0x803b4b
  80016e:	e8 e4 05 00 00       	call   800757 <cprintf>
  800173:	83 c4 10             	add    $0x10,%esp
		cprintf("will notify the master now...\n");
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	68 68 3b 80 00       	push   $0x803b68
  80017e:	e8 d4 05 00 00       	call   800757 <cprintf>
  800183:	83 c4 10             	add    $0x10,%esp
		cprintf("Merge sort says GOOD BYE :)\n") ;
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	68 87 3b 80 00       	push   $0x803b87
  80018e:	e8 c4 05 00 00       	call   800757 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	ff 75 d4             	pushl  -0x2c(%ebp)
  80019c:	e8 bd 34 00 00       	call   80365e <signal_semaphore>
  8001a1:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  8001a4:	83 ec 0c             	sub    $0xc,%esp
  8001a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8001aa:	e8 af 34 00 00       	call   80365e <signal_semaphore>
  8001af:	83 c4 10             	add    $0x10,%esp
}
  8001b2:	90                   	nop
  8001b3:	c9                   	leave  
  8001b4:	c3                   	ret    

008001b5 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c8:	01 d0                	add    %edx,%eax
  8001ca:	8b 00                	mov    (%eax),%eax
  8001cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8001cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dc:	01 c2                	add    %eax,%edx
  8001de:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001eb:	01 c8                	add    %ecx,%eax
  8001ed:	8b 00                	mov    (%eax),%eax
  8001ef:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8001f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fe:	01 c2                	add    %eax,%edx
  800200:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800203:	89 02                	mov    %eax,(%edx)
}
  800205:	90                   	nop
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80020e:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800215:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021c:	eb 42                	jmp    800260 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80021e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800221:	99                   	cltd   
  800222:	f7 7d f0             	idivl  -0x10(%ebp)
  800225:	89 d0                	mov    %edx,%eax
  800227:	85 c0                	test   %eax,%eax
  800229:	75 10                	jne    80023b <PrintElements+0x33>
			cprintf("\n");
  80022b:	83 ec 0c             	sub    $0xc,%esp
  80022e:	68 a4 3b 80 00       	push   $0x803ba4
  800233:	e8 1f 05 00 00       	call   800757 <cprintf>
  800238:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800245:	8b 45 08             	mov    0x8(%ebp),%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8b 00                	mov    (%eax),%eax
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	50                   	push   %eax
  800250:	68 a6 3b 80 00       	push   $0x803ba6
  800255:	e8 fd 04 00 00       	call   800757 <cprintf>
  80025a:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80025d:	ff 45 f4             	incl   -0xc(%ebp)
  800260:	8b 45 0c             	mov    0xc(%ebp),%eax
  800263:	48                   	dec    %eax
  800264:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800267:	7f b5                	jg     80021e <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80026c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800273:	8b 45 08             	mov    0x8(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	8b 00                	mov    (%eax),%eax
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	50                   	push   %eax
  80027e:	68 ab 3b 80 00       	push   $0x803bab
  800283:	e8 cf 04 00 00       	call   800757 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp

}
  80028b:	90                   	nop
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    

0080028e <MSort>:


void MSort(int* A, int p, int r)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800294:	8b 45 0c             	mov    0xc(%ebp),%eax
  800297:	3b 45 10             	cmp    0x10(%ebp),%eax
  80029a:	7d 54                	jge    8002f0 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  80029c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029f:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a2:	01 d0                	add    %edx,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	c1 ea 1f             	shr    $0x1f,%edx
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	d1 f8                	sar    %eax
  8002ad:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b6:	ff 75 0c             	pushl  0xc(%ebp)
  8002b9:	ff 75 08             	pushl  0x8(%ebp)
  8002bc:	e8 cd ff ff ff       	call   80028e <MSort>
  8002c1:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  8002c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c7:	40                   	inc    %eax
  8002c8:	83 ec 04             	sub    $0x4,%esp
  8002cb:	ff 75 10             	pushl  0x10(%ebp)
  8002ce:	50                   	push   %eax
  8002cf:	ff 75 08             	pushl  0x8(%ebp)
  8002d2:	e8 b7 ff ff ff       	call   80028e <MSort>
  8002d7:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  8002da:	ff 75 10             	pushl  0x10(%ebp)
  8002dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e0:	ff 75 0c             	pushl  0xc(%ebp)
  8002e3:	ff 75 08             	pushl  0x8(%ebp)
  8002e6:	e8 08 00 00 00       	call   8002f3 <Merge>
  8002eb:	83 c4 10             	add    $0x10,%esp
  8002ee:	eb 01                	jmp    8002f1 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  8002f0:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  8002f1:	c9                   	leave  
  8002f2:	c3                   	ret    

008002f3 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	83 ec 30             	sub    $0x30,%esp
	int leftCapacity = q - p + 1;
  8002f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fc:	2b 45 0c             	sub    0xc(%ebp),%eax
  8002ff:	40                   	inc    %eax
  800300:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int rightCapacity = r - q;
  800303:	8b 45 14             	mov    0x14(%ebp),%eax
  800306:	2b 45 10             	sub    0x10(%ebp),%eax
  800309:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int leftIndex = 0;
  80030c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int rightIndex = 0;
  800313:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	//int* Left = malloc(sizeof(int) * leftCapacity);
	int* Left = __Left ;
  80031a:	c7 45 e0 60 50 80 00 	movl   $0x805060,-0x20(%ebp)
	int* Right = __Right;
  800321:	c7 45 dc c0 eb 87 00 	movl   $0x87ebc0,-0x24(%ebp)
	//int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80032f:	eb 2f                	jmp    800360 <Merge+0x6d>
	{
		Left[i] = A[p + i - 1];
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80033e:	01 c2                	add    %eax,%edx
  800340:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80034d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800354:	8b 45 08             	mov    0x8(%ebp),%eax
  800357:	01 c8                	add    %ecx,%eax
  800359:	8b 00                	mov    (%eax),%eax
  80035b:	89 02                	mov    %eax,(%edx)
	int* Left = __Left ;
	int* Right = __Right;
	//int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80035d:	ff 45 f4             	incl   -0xc(%ebp)
  800360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800363:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800366:	7c c9                	jl     800331 <Merge+0x3e>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800368:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036f:	eb 2a                	jmp    80039b <Merge+0xa8>
	{
		Right[j] = A[q + j];
  800371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800374:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80037b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80037e:	01 c2                	add    %eax,%edx
  800380:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800386:	01 c8                	add    %ecx,%eax
  800388:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	8b 00                	mov    (%eax),%eax
  800396:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800398:	ff 45 f0             	incl   -0x10(%ebp)
  80039b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003a1:	7c ce                	jl     800371 <Merge+0x7e>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8003a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8003a9:	e9 0a 01 00 00       	jmp    8004b8 <Merge+0x1c5>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8003b4:	0f 8d 95 00 00 00    	jge    80044f <Merge+0x15c>
  8003ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003bd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003c0:	0f 8d 89 00 00 00    	jge    80044f <Merge+0x15c>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d3:	01 d0                	add    %edx,%eax
  8003d5:	8b 10                	mov    (%eax),%edx
  8003d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003da:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e4:	01 c8                	add    %ecx,%eax
  8003e6:	8b 00                	mov    (%eax),%eax
  8003e8:	39 c2                	cmp    %eax,%edx
  8003ea:	7d 33                	jge    80041f <Merge+0x12c>
			{
				A[k - 1] = Left[leftIndex++];
  8003ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ef:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800401:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800404:	8d 50 01             	lea    0x1(%eax),%edx
  800407:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80040a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800411:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800414:	01 d0                	add    %edx,%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80041a:	e9 96 00 00 00       	jmp    8004b5 <Merge+0x1c2>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  80041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800422:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800427:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800434:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800437:	8d 50 01             	lea    0x1(%eax),%edx
  80043a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80043d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800444:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800447:	01 d0                	add    %edx,%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80044d:	eb 66                	jmp    8004b5 <Merge+0x1c2>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  80044f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800452:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800455:	7d 30                	jge    800487 <Merge+0x194>
		{
			A[k - 1] = Left[leftIndex++];
  800457:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80045a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80045f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80046c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80046f:	8d 50 01             	lea    0x1(%eax),%edx
  800472:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800475:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047f:	01 d0                	add    %edx,%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	89 01                	mov    %eax,(%ecx)
  800485:	eb 2e                	jmp    8004b5 <Merge+0x1c2>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800487:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80049c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80049f:	8d 50 01             	lea    0x1(%eax),%edx
  8004a2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8004a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004af:	01 d0                	add    %edx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8004b5:	ff 45 ec             	incl   -0x14(%ebp)
  8004b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004bb:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004be:	0f 8e ea fe ff ff    	jle    8003ae <Merge+0xbb>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8004c4:	90                   	nop
  8004c5:	c9                   	leave  
  8004c6:	c3                   	ret    

008004c7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8004c7:	55                   	push   %ebp
  8004c8:	89 e5                	mov    %esp,%ebp
  8004ca:	57                   	push   %edi
  8004cb:	56                   	push   %esi
  8004cc:	53                   	push   %ebx
  8004cd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8004d0:	e8 57 21 00 00       	call   80262c <sys_getenvindex>
  8004d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8004d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004db:	89 d0                	mov    %edx,%eax
  8004dd:	01 c0                	add    %eax,%eax
  8004df:	01 d0                	add    %edx,%eax
  8004e1:	c1 e0 02             	shl    $0x2,%eax
  8004e4:	01 d0                	add    %edx,%eax
  8004e6:	c1 e0 02             	shl    $0x2,%eax
  8004e9:	01 d0                	add    %edx,%eax
  8004eb:	c1 e0 03             	shl    $0x3,%eax
  8004ee:	01 d0                	add    %edx,%eax
  8004f0:	c1 e0 02             	shl    $0x2,%eax
  8004f3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004f8:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004fd:	a1 20 50 80 00       	mov    0x805020,%eax
  800502:	8a 40 20             	mov    0x20(%eax),%al
  800505:	84 c0                	test   %al,%al
  800507:	74 0d                	je     800516 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800509:	a1 20 50 80 00       	mov    0x805020,%eax
  80050e:	83 c0 20             	add    $0x20,%eax
  800511:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800516:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80051a:	7e 0a                	jle    800526 <libmain+0x5f>
		binaryname = argv[0];
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800526:	83 ec 08             	sub    $0x8,%esp
  800529:	ff 75 0c             	pushl  0xc(%ebp)
  80052c:	ff 75 08             	pushl  0x8(%ebp)
  80052f:	e8 04 fb ff ff       	call   800038 <_main>
  800534:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800537:	a1 00 50 80 00       	mov    0x805000,%eax
  80053c:	85 c0                	test   %eax,%eax
  80053e:	0f 84 01 01 00 00    	je     800645 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800544:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80054a:	bb a8 3c 80 00       	mov    $0x803ca8,%ebx
  80054f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800554:	89 c7                	mov    %eax,%edi
  800556:	89 de                	mov    %ebx,%esi
  800558:	89 d1                	mov    %edx,%ecx
  80055a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80055c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80055f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800564:	b0 00                	mov    $0x0,%al
  800566:	89 d7                	mov    %edx,%edi
  800568:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80056a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800571:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	50                   	push   %eax
  800578:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80057e:	50                   	push   %eax
  80057f:	e8 de 22 00 00       	call   802862 <sys_utilities>
  800584:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800587:	e8 27 1e 00 00       	call   8023b3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80058c:	83 ec 0c             	sub    $0xc,%esp
  80058f:	68 c8 3b 80 00       	push   $0x803bc8
  800594:	e8 be 01 00 00       	call   800757 <cprintf>
  800599:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80059c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80059f:	85 c0                	test   %eax,%eax
  8005a1:	74 18                	je     8005bb <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8005a3:	e8 d8 22 00 00       	call   802880 <sys_get_optimal_num_faults>
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	50                   	push   %eax
  8005ac:	68 f0 3b 80 00       	push   $0x803bf0
  8005b1:	e8 a1 01 00 00       	call   800757 <cprintf>
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	eb 59                	jmp    800614 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005bb:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c0:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8005c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8005cb:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8005d1:	83 ec 04             	sub    $0x4,%esp
  8005d4:	52                   	push   %edx
  8005d5:	50                   	push   %eax
  8005d6:	68 14 3c 80 00       	push   $0x803c14
  8005db:	e8 77 01 00 00       	call   800757 <cprintf>
  8005e0:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8005e8:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8005ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f3:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8005f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8005fe:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800604:	51                   	push   %ecx
  800605:	52                   	push   %edx
  800606:	50                   	push   %eax
  800607:	68 3c 3c 80 00       	push   $0x803c3c
  80060c:	e8 46 01 00 00       	call   800757 <cprintf>
  800611:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800614:	a1 20 50 80 00       	mov    0x805020,%eax
  800619:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	50                   	push   %eax
  800623:	68 94 3c 80 00       	push   $0x803c94
  800628:	e8 2a 01 00 00       	call   800757 <cprintf>
  80062d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	68 c8 3b 80 00       	push   $0x803bc8
  800638:	e8 1a 01 00 00       	call   800757 <cprintf>
  80063d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800640:	e8 88 1d 00 00       	call   8023cd <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800645:	e8 1f 00 00 00       	call   800669 <exit>
}
  80064a:	90                   	nop
  80064b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80064e:	5b                   	pop    %ebx
  80064f:	5e                   	pop    %esi
  800650:	5f                   	pop    %edi
  800651:	5d                   	pop    %ebp
  800652:	c3                   	ret    

00800653 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800653:	55                   	push   %ebp
  800654:	89 e5                	mov    %esp,%ebp
  800656:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800659:	83 ec 0c             	sub    $0xc,%esp
  80065c:	6a 00                	push   $0x0
  80065e:	e8 95 1f 00 00       	call   8025f8 <sys_destroy_env>
  800663:	83 c4 10             	add    $0x10,%esp
}
  800666:	90                   	nop
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <exit>:

void
exit(void)
{
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
  80066c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80066f:	e8 ea 1f 00 00       	call   80265e <sys_exit_env>
}
  800674:	90                   	nop
  800675:	c9                   	leave  
  800676:	c3                   	ret    

00800677 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800677:	55                   	push   %ebp
  800678:	89 e5                	mov    %esp,%ebp
  80067a:	53                   	push   %ebx
  80067b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80067e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	8d 48 01             	lea    0x1(%eax),%ecx
  800686:	8b 55 0c             	mov    0xc(%ebp),%edx
  800689:	89 0a                	mov    %ecx,(%edx)
  80068b:	8b 55 08             	mov    0x8(%ebp),%edx
  80068e:	88 d1                	mov    %dl,%cl
  800690:	8b 55 0c             	mov    0xc(%ebp),%edx
  800693:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800697:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a1:	75 30                	jne    8006d3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006a3:	8b 15 44 06 8e 00    	mov    0x8e0644,%edx
  8006a9:	a0 e0 6a 86 00       	mov    0x866ae0,%al
  8006ae:	0f b6 c0             	movzbl %al,%eax
  8006b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b4:	8b 09                	mov    (%ecx),%ecx
  8006b6:	89 cb                	mov    %ecx,%ebx
  8006b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006bb:	83 c1 08             	add    $0x8,%ecx
  8006be:	52                   	push   %edx
  8006bf:	50                   	push   %eax
  8006c0:	53                   	push   %ebx
  8006c1:	51                   	push   %ecx
  8006c2:	e8 a8 1c 00 00       	call   80236f <sys_cputs>
  8006c7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d6:	8b 40 04             	mov    0x4(%eax),%eax
  8006d9:	8d 50 01             	lea    0x1(%eax),%edx
  8006dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006df:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006e2:	90                   	nop
  8006e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e6:	c9                   	leave  
  8006e7:	c3                   	ret    

008006e8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f8:	00 00 00 
	b.cnt = 0;
  8006fb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800702:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800705:	ff 75 0c             	pushl  0xc(%ebp)
  800708:	ff 75 08             	pushl  0x8(%ebp)
  80070b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800711:	50                   	push   %eax
  800712:	68 77 06 80 00       	push   $0x800677
  800717:	e8 5a 02 00 00       	call   800976 <vprintfmt>
  80071c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80071f:	8b 15 44 06 8e 00    	mov    0x8e0644,%edx
  800725:	a0 e0 6a 86 00       	mov    0x866ae0,%al
  80072a:	0f b6 c0             	movzbl %al,%eax
  80072d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800733:	52                   	push   %edx
  800734:	50                   	push   %eax
  800735:	51                   	push   %ecx
  800736:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80073c:	83 c0 08             	add    $0x8,%eax
  80073f:	50                   	push   %eax
  800740:	e8 2a 1c 00 00       	call   80236f <sys_cputs>
  800745:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800748:	c6 05 e0 6a 86 00 00 	movb   $0x0,0x866ae0
	return b.cnt;
  80074f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800755:	c9                   	leave  
  800756:	c3                   	ret    

00800757 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80075d:	c6 05 e0 6a 86 00 01 	movb   $0x1,0x866ae0
	va_start(ap, fmt);
  800764:	8d 45 0c             	lea    0xc(%ebp),%eax
  800767:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	ff 75 f4             	pushl  -0xc(%ebp)
  800773:	50                   	push   %eax
  800774:	e8 6f ff ff ff       	call   8006e8 <vcprintf>
  800779:	83 c4 10             	add    $0x10,%esp
  80077c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80077f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800782:	c9                   	leave  
  800783:	c3                   	ret    

00800784 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80078a:	c6 05 e0 6a 86 00 01 	movb   $0x1,0x866ae0
	curTextClr = (textClr << 8) ; //set text color by the given value
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	c1 e0 08             	shl    $0x8,%eax
  800797:	a3 44 06 8e 00       	mov    %eax,0x8e0644
	va_start(ap, fmt);
  80079c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079f:	83 c0 04             	add    $0x4,%eax
  8007a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ae:	50                   	push   %eax
  8007af:	e8 34 ff ff ff       	call   8006e8 <vcprintf>
  8007b4:	83 c4 10             	add    $0x10,%esp
  8007b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007ba:	c7 05 44 06 8e 00 00 	movl   $0x700,0x8e0644
  8007c1:	07 00 00 

	return cnt;
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007cf:	e8 df 1b 00 00       	call   8023b3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007d4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e3:	50                   	push   %eax
  8007e4:	e8 ff fe ff ff       	call   8006e8 <vcprintf>
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007ef:	e8 d9 1b 00 00       	call   8023cd <sys_unlock_cons>
	return cnt;
  8007f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f7:	c9                   	leave  
  8007f8:	c3                   	ret    

008007f9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	53                   	push   %ebx
  8007fd:	83 ec 14             	sub    $0x14,%esp
  800800:	8b 45 10             	mov    0x10(%ebp),%eax
  800803:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80080c:	8b 45 18             	mov    0x18(%ebp),%eax
  80080f:	ba 00 00 00 00       	mov    $0x0,%edx
  800814:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800817:	77 55                	ja     80086e <printnum+0x75>
  800819:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80081c:	72 05                	jb     800823 <printnum+0x2a>
  80081e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800821:	77 4b                	ja     80086e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800823:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800826:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800829:	8b 45 18             	mov    0x18(%ebp),%eax
  80082c:	ba 00 00 00 00       	mov    $0x0,%edx
  800831:	52                   	push   %edx
  800832:	50                   	push   %eax
  800833:	ff 75 f4             	pushl  -0xc(%ebp)
  800836:	ff 75 f0             	pushl  -0x10(%ebp)
  800839:	e8 56 30 00 00       	call   803894 <__udivdi3>
  80083e:	83 c4 10             	add    $0x10,%esp
  800841:	83 ec 04             	sub    $0x4,%esp
  800844:	ff 75 20             	pushl  0x20(%ebp)
  800847:	53                   	push   %ebx
  800848:	ff 75 18             	pushl  0x18(%ebp)
  80084b:	52                   	push   %edx
  80084c:	50                   	push   %eax
  80084d:	ff 75 0c             	pushl  0xc(%ebp)
  800850:	ff 75 08             	pushl  0x8(%ebp)
  800853:	e8 a1 ff ff ff       	call   8007f9 <printnum>
  800858:	83 c4 20             	add    $0x20,%esp
  80085b:	eb 1a                	jmp    800877 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	ff 75 20             	pushl  0x20(%ebp)
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80086e:	ff 4d 1c             	decl   0x1c(%ebp)
  800871:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800875:	7f e6                	jg     80085d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800877:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80087a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80087f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800882:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800885:	53                   	push   %ebx
  800886:	51                   	push   %ecx
  800887:	52                   	push   %edx
  800888:	50                   	push   %eax
  800889:	e8 16 31 00 00       	call   8039a4 <__umoddi3>
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	05 34 3f 80 00       	add    $0x803f34,%eax
  800896:	8a 00                	mov    (%eax),%al
  800898:	0f be c0             	movsbl %al,%eax
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	ff 75 0c             	pushl  0xc(%ebp)
  8008a1:	50                   	push   %eax
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	ff d0                	call   *%eax
  8008a7:	83 c4 10             	add    $0x10,%esp
}
  8008aa:	90                   	nop
  8008ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ae:	c9                   	leave  
  8008af:	c3                   	ret    

008008b0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b7:	7e 1c                	jle    8008d5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	8d 50 08             	lea    0x8(%eax),%edx
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	89 10                	mov    %edx,(%eax)
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	83 e8 08             	sub    $0x8,%eax
  8008ce:	8b 50 04             	mov    0x4(%eax),%edx
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	eb 40                	jmp    800915 <getuint+0x65>
	else if (lflag)
  8008d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d9:	74 1e                	je     8008f9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	8d 50 04             	lea    0x4(%eax),%edx
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	89 10                	mov    %edx,(%eax)
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	8b 00                	mov    (%eax),%eax
  8008ed:	83 e8 04             	sub    $0x4,%eax
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f7:	eb 1c                	jmp    800915 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	8d 50 04             	lea    0x4(%eax),%edx
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	89 10                	mov    %edx,(%eax)
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	83 e8 04             	sub    $0x4,%eax
  80090e:	8b 00                	mov    (%eax),%eax
  800910:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80091a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80091e:	7e 1c                	jle    80093c <getint+0x25>
		return va_arg(*ap, long long);
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	8d 50 08             	lea    0x8(%eax),%edx
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	89 10                	mov    %edx,(%eax)
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	83 e8 08             	sub    $0x8,%eax
  800935:	8b 50 04             	mov    0x4(%eax),%edx
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	eb 38                	jmp    800974 <getint+0x5d>
	else if (lflag)
  80093c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800940:	74 1a                	je     80095c <getint+0x45>
		return va_arg(*ap, long);
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	8d 50 04             	lea    0x4(%eax),%edx
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	89 10                	mov    %edx,(%eax)
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	83 e8 04             	sub    $0x4,%eax
  800957:	8b 00                	mov    (%eax),%eax
  800959:	99                   	cltd   
  80095a:	eb 18                	jmp    800974 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	8d 50 04             	lea    0x4(%eax),%edx
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	89 10                	mov    %edx,(%eax)
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	8b 00                	mov    (%eax),%eax
  80096e:	83 e8 04             	sub    $0x4,%eax
  800971:	8b 00                	mov    (%eax),%eax
  800973:	99                   	cltd   
}
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	56                   	push   %esi
  80097a:	53                   	push   %ebx
  80097b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097e:	eb 17                	jmp    800997 <vprintfmt+0x21>
			if (ch == '\0')
  800980:	85 db                	test   %ebx,%ebx
  800982:	0f 84 c1 03 00 00    	je     800d49 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	53                   	push   %ebx
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	ff d0                	call   *%eax
  800994:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800997:	8b 45 10             	mov    0x10(%ebp),%eax
  80099a:	8d 50 01             	lea    0x1(%eax),%edx
  80099d:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a0:	8a 00                	mov    (%eax),%al
  8009a2:	0f b6 d8             	movzbl %al,%ebx
  8009a5:	83 fb 25             	cmp    $0x25,%ebx
  8009a8:	75 d6                	jne    800980 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009aa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009ae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009b5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009c3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cd:	8d 50 01             	lea    0x1(%eax),%edx
  8009d0:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d3:	8a 00                	mov    (%eax),%al
  8009d5:	0f b6 d8             	movzbl %al,%ebx
  8009d8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009db:	83 f8 5b             	cmp    $0x5b,%eax
  8009de:	0f 87 3d 03 00 00    	ja     800d21 <vprintfmt+0x3ab>
  8009e4:	8b 04 85 58 3f 80 00 	mov    0x803f58(,%eax,4),%eax
  8009eb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ed:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009f1:	eb d7                	jmp    8009ca <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009f3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009f7:	eb d1                	jmp    8009ca <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a03:	89 d0                	mov    %edx,%eax
  800a05:	c1 e0 02             	shl    $0x2,%eax
  800a08:	01 d0                	add    %edx,%eax
  800a0a:	01 c0                	add    %eax,%eax
  800a0c:	01 d8                	add    %ebx,%eax
  800a0e:	83 e8 30             	sub    $0x30,%eax
  800a11:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a14:	8b 45 10             	mov    0x10(%ebp),%eax
  800a17:	8a 00                	mov    (%eax),%al
  800a19:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a1c:	83 fb 2f             	cmp    $0x2f,%ebx
  800a1f:	7e 3e                	jle    800a5f <vprintfmt+0xe9>
  800a21:	83 fb 39             	cmp    $0x39,%ebx
  800a24:	7f 39                	jg     800a5f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a26:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a29:	eb d5                	jmp    800a00 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2e:	83 c0 04             	add    $0x4,%eax
  800a31:	89 45 14             	mov    %eax,0x14(%ebp)
  800a34:	8b 45 14             	mov    0x14(%ebp),%eax
  800a37:	83 e8 04             	sub    $0x4,%eax
  800a3a:	8b 00                	mov    (%eax),%eax
  800a3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a3f:	eb 1f                	jmp    800a60 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a45:	79 83                	jns    8009ca <vprintfmt+0x54>
				width = 0;
  800a47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a4e:	e9 77 ff ff ff       	jmp    8009ca <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a53:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a5a:	e9 6b ff ff ff       	jmp    8009ca <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a5f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a64:	0f 89 60 ff ff ff    	jns    8009ca <vprintfmt+0x54>
				width = precision, precision = -1;
  800a6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a70:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a77:	e9 4e ff ff ff       	jmp    8009ca <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a7c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a7f:	e9 46 ff ff ff       	jmp    8009ca <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a84:	8b 45 14             	mov    0x14(%ebp),%eax
  800a87:	83 c0 04             	add    $0x4,%eax
  800a8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	83 e8 04             	sub    $0x4,%eax
  800a93:	8b 00                	mov    (%eax),%eax
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	50                   	push   %eax
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			break;
  800aa4:	e9 9b 02 00 00       	jmp    800d44 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aac:	83 c0 04             	add    $0x4,%eax
  800aaf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab5:	83 e8 04             	sub    $0x4,%eax
  800ab8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aba:	85 db                	test   %ebx,%ebx
  800abc:	79 02                	jns    800ac0 <vprintfmt+0x14a>
				err = -err;
  800abe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ac0:	83 fb 64             	cmp    $0x64,%ebx
  800ac3:	7f 0b                	jg     800ad0 <vprintfmt+0x15a>
  800ac5:	8b 34 9d a0 3d 80 00 	mov    0x803da0(,%ebx,4),%esi
  800acc:	85 f6                	test   %esi,%esi
  800ace:	75 19                	jne    800ae9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ad0:	53                   	push   %ebx
  800ad1:	68 45 3f 80 00       	push   $0x803f45
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	ff 75 08             	pushl  0x8(%ebp)
  800adc:	e8 70 02 00 00       	call   800d51 <printfmt>
  800ae1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae4:	e9 5b 02 00 00       	jmp    800d44 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae9:	56                   	push   %esi
  800aea:	68 4e 3f 80 00       	push   $0x803f4e
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 57 02 00 00       	call   800d51 <printfmt>
  800afa:	83 c4 10             	add    $0x10,%esp
			break;
  800afd:	e9 42 02 00 00       	jmp    800d44 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b02:	8b 45 14             	mov    0x14(%ebp),%eax
  800b05:	83 c0 04             	add    $0x4,%eax
  800b08:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	83 e8 04             	sub    $0x4,%eax
  800b11:	8b 30                	mov    (%eax),%esi
  800b13:	85 f6                	test   %esi,%esi
  800b15:	75 05                	jne    800b1c <vprintfmt+0x1a6>
				p = "(null)";
  800b17:	be 51 3f 80 00       	mov    $0x803f51,%esi
			if (width > 0 && padc != '-')
  800b1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b20:	7e 6d                	jle    800b8f <vprintfmt+0x219>
  800b22:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b26:	74 67                	je     800b8f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	50                   	push   %eax
  800b2f:	56                   	push   %esi
  800b30:	e8 1e 03 00 00       	call   800e53 <strnlen>
  800b35:	83 c4 10             	add    $0x10,%esp
  800b38:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b3b:	eb 16                	jmp    800b53 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b3d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b41:	83 ec 08             	sub    $0x8,%esp
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	50                   	push   %eax
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	ff d0                	call   *%eax
  800b4d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b50:	ff 4d e4             	decl   -0x1c(%ebp)
  800b53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b57:	7f e4                	jg     800b3d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b59:	eb 34                	jmp    800b8f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b5f:	74 1c                	je     800b7d <vprintfmt+0x207>
  800b61:	83 fb 1f             	cmp    $0x1f,%ebx
  800b64:	7e 05                	jle    800b6b <vprintfmt+0x1f5>
  800b66:	83 fb 7e             	cmp    $0x7e,%ebx
  800b69:	7e 12                	jle    800b7d <vprintfmt+0x207>
					putch('?', putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	6a 3f                	push   $0x3f
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	ff d0                	call   *%eax
  800b78:	83 c4 10             	add    $0x10,%esp
  800b7b:	eb 0f                	jmp    800b8c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	53                   	push   %ebx
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	ff d0                	call   *%eax
  800b89:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b8f:	89 f0                	mov    %esi,%eax
  800b91:	8d 70 01             	lea    0x1(%eax),%esi
  800b94:	8a 00                	mov    (%eax),%al
  800b96:	0f be d8             	movsbl %al,%ebx
  800b99:	85 db                	test   %ebx,%ebx
  800b9b:	74 24                	je     800bc1 <vprintfmt+0x24b>
  800b9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba1:	78 b8                	js     800b5b <vprintfmt+0x1e5>
  800ba3:	ff 4d e0             	decl   -0x20(%ebp)
  800ba6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800baa:	79 af                	jns    800b5b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bac:	eb 13                	jmp    800bc1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	6a 20                	push   $0x20
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	ff d0                	call   *%eax
  800bbb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbe:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc5:	7f e7                	jg     800bae <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bc7:	e9 78 01 00 00       	jmp    800d44 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd2:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd5:	50                   	push   %eax
  800bd6:	e8 3c fd ff ff       	call   800917 <getint>
  800bdb:	83 c4 10             	add    $0x10,%esp
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bea:	85 d2                	test   %edx,%edx
  800bec:	79 23                	jns    800c11 <vprintfmt+0x29b>
				putch('-', putdat);
  800bee:	83 ec 08             	sub    $0x8,%esp
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	6a 2d                	push   $0x2d
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	ff d0                	call   *%eax
  800bfb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c04:	f7 d8                	neg    %eax
  800c06:	83 d2 00             	adc    $0x0,%edx
  800c09:	f7 da                	neg    %edx
  800c0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c11:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c18:	e9 bc 00 00 00       	jmp    800cd9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c1d:	83 ec 08             	sub    $0x8,%esp
  800c20:	ff 75 e8             	pushl  -0x18(%ebp)
  800c23:	8d 45 14             	lea    0x14(%ebp),%eax
  800c26:	50                   	push   %eax
  800c27:	e8 84 fc ff ff       	call   8008b0 <getuint>
  800c2c:	83 c4 10             	add    $0x10,%esp
  800c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c32:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c35:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c3c:	e9 98 00 00 00       	jmp    800cd9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c41:	83 ec 08             	sub    $0x8,%esp
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	6a 58                	push   $0x58
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	ff d0                	call   *%eax
  800c4e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c51:	83 ec 08             	sub    $0x8,%esp
  800c54:	ff 75 0c             	pushl  0xc(%ebp)
  800c57:	6a 58                	push   $0x58
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	ff d0                	call   *%eax
  800c5e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	ff 75 0c             	pushl  0xc(%ebp)
  800c67:	6a 58                	push   $0x58
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	ff d0                	call   *%eax
  800c6e:	83 c4 10             	add    $0x10,%esp
			break;
  800c71:	e9 ce 00 00 00       	jmp    800d44 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	6a 30                	push   $0x30
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	ff d0                	call   *%eax
  800c83:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c86:	83 ec 08             	sub    $0x8,%esp
  800c89:	ff 75 0c             	pushl  0xc(%ebp)
  800c8c:	6a 78                	push   $0x78
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	ff d0                	call   *%eax
  800c93:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c96:	8b 45 14             	mov    0x14(%ebp),%eax
  800c99:	83 c0 04             	add    $0x4,%eax
  800c9c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca2:	83 e8 04             	sub    $0x4,%eax
  800ca5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800caa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cb1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cb8:	eb 1f                	jmp    800cd9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cba:	83 ec 08             	sub    $0x8,%esp
  800cbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800cc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc3:	50                   	push   %eax
  800cc4:	e8 e7 fb ff ff       	call   8008b0 <getuint>
  800cc9:	83 c4 10             	add    $0x10,%esp
  800ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ccf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cd2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cd9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce0:	83 ec 04             	sub    $0x4,%esp
  800ce3:	52                   	push   %edx
  800ce4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ce7:	50                   	push   %eax
  800ce8:	ff 75 f4             	pushl  -0xc(%ebp)
  800ceb:	ff 75 f0             	pushl  -0x10(%ebp)
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	ff 75 08             	pushl  0x8(%ebp)
  800cf4:	e8 00 fb ff ff       	call   8007f9 <printnum>
  800cf9:	83 c4 20             	add    $0x20,%esp
			break;
  800cfc:	eb 46                	jmp    800d44 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cfe:	83 ec 08             	sub    $0x8,%esp
  800d01:	ff 75 0c             	pushl  0xc(%ebp)
  800d04:	53                   	push   %ebx
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	ff d0                	call   *%eax
  800d0a:	83 c4 10             	add    $0x10,%esp
			break;
  800d0d:	eb 35                	jmp    800d44 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d0f:	c6 05 e0 6a 86 00 00 	movb   $0x0,0x866ae0
			break;
  800d16:	eb 2c                	jmp    800d44 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d18:	c6 05 e0 6a 86 00 01 	movb   $0x1,0x866ae0
			break;
  800d1f:	eb 23                	jmp    800d44 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d21:	83 ec 08             	sub    $0x8,%esp
  800d24:	ff 75 0c             	pushl  0xc(%ebp)
  800d27:	6a 25                	push   $0x25
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	ff d0                	call   *%eax
  800d2e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d31:	ff 4d 10             	decl   0x10(%ebp)
  800d34:	eb 03                	jmp    800d39 <vprintfmt+0x3c3>
  800d36:	ff 4d 10             	decl   0x10(%ebp)
  800d39:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3c:	48                   	dec    %eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	3c 25                	cmp    $0x25,%al
  800d41:	75 f3                	jne    800d36 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d43:	90                   	nop
		}
	}
  800d44:	e9 35 fc ff ff       	jmp    80097e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d49:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    

00800d51 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d57:	8d 45 10             	lea    0x10(%ebp),%eax
  800d5a:	83 c0 04             	add    $0x4,%eax
  800d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d60:	8b 45 10             	mov    0x10(%ebp),%eax
  800d63:	ff 75 f4             	pushl  -0xc(%ebp)
  800d66:	50                   	push   %eax
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	ff 75 08             	pushl  0x8(%ebp)
  800d6d:	e8 04 fc ff ff       	call   800976 <vprintfmt>
  800d72:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d75:	90                   	nop
  800d76:	c9                   	leave  
  800d77:	c3                   	ret    

00800d78 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	8b 40 08             	mov    0x8(%eax),%eax
  800d81:	8d 50 01             	lea    0x1(%eax),%edx
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8b 10                	mov    (%eax),%edx
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	8b 40 04             	mov    0x4(%eax),%eax
  800d95:	39 c2                	cmp    %eax,%edx
  800d97:	73 12                	jae    800dab <sprintputch+0x33>
		*b->buf++ = ch;
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	8b 00                	mov    (%eax),%eax
  800d9e:	8d 48 01             	lea    0x1(%eax),%ecx
  800da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da4:	89 0a                	mov    %ecx,(%edx)
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
  800da9:	88 10                	mov    %dl,(%eax)
}
  800dab:	90                   	nop
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    

00800dae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	01 d0                	add    %edx,%eax
  800dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dcf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dd3:	74 06                	je     800ddb <vsnprintf+0x2d>
  800dd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd9:	7f 07                	jg     800de2 <vsnprintf+0x34>
		return -E_INVAL;
  800ddb:	b8 03 00 00 00       	mov    $0x3,%eax
  800de0:	eb 20                	jmp    800e02 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800de2:	ff 75 14             	pushl  0x14(%ebp)
  800de5:	ff 75 10             	pushl  0x10(%ebp)
  800de8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800deb:	50                   	push   %eax
  800dec:	68 78 0d 80 00       	push   $0x800d78
  800df1:	e8 80 fb ff ff       	call   800976 <vprintfmt>
  800df6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dfc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e0a:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0d:	83 c0 04             	add    $0x4,%eax
  800e10:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	ff 75 f4             	pushl  -0xc(%ebp)
  800e19:	50                   	push   %eax
  800e1a:	ff 75 0c             	pushl  0xc(%ebp)
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	e8 89 ff ff ff       	call   800dae <vsnprintf>
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e2e:	c9                   	leave  
  800e2f:	c3                   	ret    

00800e30 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3d:	eb 06                	jmp    800e45 <strlen+0x15>
		n++;
  800e3f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e42:	ff 45 08             	incl   0x8(%ebp)
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8a 00                	mov    (%eax),%al
  800e4a:	84 c0                	test   %al,%al
  800e4c:	75 f1                	jne    800e3f <strlen+0xf>
		n++;
	return n;
  800e4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e51:	c9                   	leave  
  800e52:	c3                   	ret    

00800e53 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e60:	eb 09                	jmp    800e6b <strnlen+0x18>
		n++;
  800e62:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e65:	ff 45 08             	incl   0x8(%ebp)
  800e68:	ff 4d 0c             	decl   0xc(%ebp)
  800e6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6f:	74 09                	je     800e7a <strnlen+0x27>
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	84 c0                	test   %al,%al
  800e78:	75 e8                	jne    800e62 <strnlen+0xf>
		n++;
	return n;
  800e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e7d:	c9                   	leave  
  800e7e:	c3                   	ret    

00800e7f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e8b:	90                   	nop
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8d 50 01             	lea    0x1(%eax),%edx
  800e92:	89 55 08             	mov    %edx,0x8(%ebp)
  800e95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e98:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e9e:	8a 12                	mov    (%edx),%dl
  800ea0:	88 10                	mov    %dl,(%eax)
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	84 c0                	test   %al,%al
  800ea6:	75 e4                	jne    800e8c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec0:	eb 1f                	jmp    800ee1 <strncpy+0x34>
		*dst++ = *src;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	8d 50 01             	lea    0x1(%eax),%edx
  800ec8:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ece:	8a 12                	mov    (%edx),%dl
  800ed0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	84 c0                	test   %al,%al
  800ed9:	74 03                	je     800ede <strncpy+0x31>
			src++;
  800edb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ede:	ff 45 fc             	incl   -0x4(%ebp)
  800ee1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee7:	72 d9                	jb     800ec2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800efa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efe:	74 30                	je     800f30 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f00:	eb 16                	jmp    800f18 <strlcpy+0x2a>
			*dst++ = *src++;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8d 50 01             	lea    0x1(%eax),%edx
  800f08:	89 55 08             	mov    %edx,0x8(%ebp)
  800f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f11:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f14:	8a 12                	mov    (%edx),%dl
  800f16:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1f:	74 09                	je     800f2a <strlcpy+0x3c>
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	84 c0                	test   %al,%al
  800f28:	75 d8                	jne    800f02 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f30:	8b 55 08             	mov    0x8(%ebp),%edx
  800f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f36:	29 c2                	sub    %eax,%edx
  800f38:	89 d0                	mov    %edx,%eax
}
  800f3a:	c9                   	leave  
  800f3b:	c3                   	ret    

00800f3c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f3f:	eb 06                	jmp    800f47 <strcmp+0xb>
		p++, q++;
  800f41:	ff 45 08             	incl   0x8(%ebp)
  800f44:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	84 c0                	test   %al,%al
  800f4e:	74 0e                	je     800f5e <strcmp+0x22>
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 10                	mov    (%eax),%dl
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	38 c2                	cmp    %al,%dl
  800f5c:	74 e3                	je     800f41 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 d0             	movzbl %al,%edx
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	0f b6 c0             	movzbl %al,%eax
  800f6e:	29 c2                	sub    %eax,%edx
  800f70:	89 d0                	mov    %edx,%eax
}
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f77:	eb 09                	jmp    800f82 <strncmp+0xe>
		n--, p++, q++;
  800f79:	ff 4d 10             	decl   0x10(%ebp)
  800f7c:	ff 45 08             	incl   0x8(%ebp)
  800f7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f86:	74 17                	je     800f9f <strncmp+0x2b>
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	84 c0                	test   %al,%al
  800f8f:	74 0e                	je     800f9f <strncmp+0x2b>
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 10                	mov    (%eax),%dl
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	38 c2                	cmp    %al,%dl
  800f9d:	74 da                	je     800f79 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa3:	75 07                	jne    800fac <strncmp+0x38>
		return 0;
  800fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800faa:	eb 14                	jmp    800fc0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 d0             	movzbl %al,%edx
  800fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f b6 c0             	movzbl %al,%eax
  800fbc:	29 c2                	sub    %eax,%edx
  800fbe:	89 d0                	mov    %edx,%eax
}
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    

00800fc2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 04             	sub    $0x4,%esp
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fce:	eb 12                	jmp    800fe2 <strchr+0x20>
		if (*s == c)
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd8:	75 05                	jne    800fdf <strchr+0x1d>
			return (char *) s;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	eb 11                	jmp    800ff0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fdf:	ff 45 08             	incl   0x8(%ebp)
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	84 c0                	test   %al,%al
  800fe9:	75 e5                	jne    800fd0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800feb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff0:	c9                   	leave  
  800ff1:	c3                   	ret    

00800ff2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 04             	sub    $0x4,%esp
  800ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ffe:	eb 0d                	jmp    80100d <strfind+0x1b>
		if (*s == c)
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801008:	74 0e                	je     801018 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80100a:	ff 45 08             	incl   0x8(%ebp)
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	84 c0                	test   %al,%al
  801014:	75 ea                	jne    801000 <strfind+0xe>
  801016:	eb 01                	jmp    801019 <strfind+0x27>
		if (*s == c)
			break;
  801018:	90                   	nop
	return (char *) s;
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101c:	c9                   	leave  
  80101d:	c3                   	ret    

0080101e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80102a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80102e:	76 63                	jbe    801093 <memset+0x75>
		uint64 data_block = c;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	99                   	cltd   
  801034:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801037:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80103a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801040:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801044:	c1 e0 08             	shl    $0x8,%eax
  801047:	09 45 f0             	or     %eax,-0x10(%ebp)
  80104a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80104d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801050:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801053:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801057:	c1 e0 10             	shl    $0x10,%eax
  80105a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80105d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801063:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801066:	89 c2                	mov    %eax,%edx
  801068:	b8 00 00 00 00       	mov    $0x0,%eax
  80106d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801070:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801073:	eb 18                	jmp    80108d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801075:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801078:	8d 41 08             	lea    0x8(%ecx),%eax
  80107b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80107e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801081:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801084:	89 01                	mov    %eax,(%ecx)
  801086:	89 51 04             	mov    %edx,0x4(%ecx)
  801089:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80108d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801091:	77 e2                	ja     801075 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801093:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801097:	74 23                	je     8010bc <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801099:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80109f:	eb 0e                	jmp    8010af <memset+0x91>
			*p8++ = (uint8)c;
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	8d 50 01             	lea    0x1(%eax),%edx
  8010a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ad:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	75 e5                	jne    8010a1 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    

008010c1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010d3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d7:	76 24                	jbe    8010fd <memcpy+0x3c>
		while(n >= 8){
  8010d9:	eb 1c                	jmp    8010f7 <memcpy+0x36>
			*d64 = *s64;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8b 50 04             	mov    0x4(%eax),%edx
  8010e1:	8b 00                	mov    (%eax),%eax
  8010e3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e6:	89 01                	mov    %eax,(%ecx)
  8010e8:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010eb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010ef:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010f3:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010f7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010fb:	77 de                	ja     8010db <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801101:	74 31                	je     801134 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801103:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801106:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801109:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80110f:	eb 16                	jmp    801127 <memcpy+0x66>
			*d8++ = *s8++;
  801111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801114:	8d 50 01             	lea    0x1(%eax),%edx
  801117:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80111a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801120:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801123:	8a 12                	mov    (%edx),%dl
  801125:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801127:	8b 45 10             	mov    0x10(%ebp),%eax
  80112a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80112d:	89 55 10             	mov    %edx,0x10(%ebp)
  801130:	85 c0                	test   %eax,%eax
  801132:	75 dd                	jne    801111 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801137:	c9                   	leave  
  801138:	c3                   	ret    

00801139 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80114b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801151:	73 50                	jae    8011a3 <memmove+0x6a>
  801153:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801156:	8b 45 10             	mov    0x10(%ebp),%eax
  801159:	01 d0                	add    %edx,%eax
  80115b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80115e:	76 43                	jbe    8011a3 <memmove+0x6a>
		s += n;
  801160:	8b 45 10             	mov    0x10(%ebp),%eax
  801163:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80116c:	eb 10                	jmp    80117e <memmove+0x45>
			*--d = *--s;
  80116e:	ff 4d f8             	decl   -0x8(%ebp)
  801171:	ff 4d fc             	decl   -0x4(%ebp)
  801174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801177:	8a 10                	mov    (%eax),%dl
  801179:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80117e:	8b 45 10             	mov    0x10(%ebp),%eax
  801181:	8d 50 ff             	lea    -0x1(%eax),%edx
  801184:	89 55 10             	mov    %edx,0x10(%ebp)
  801187:	85 c0                	test   %eax,%eax
  801189:	75 e3                	jne    80116e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80118b:	eb 23                	jmp    8011b0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80118d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801190:	8d 50 01             	lea    0x1(%eax),%edx
  801193:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801196:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801199:	8d 4a 01             	lea    0x1(%edx),%ecx
  80119c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80119f:	8a 12                	mov    (%edx),%dl
  8011a1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	75 dd                	jne    80118d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b3:	c9                   	leave  
  8011b4:	c3                   	ret    

008011b5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011c7:	eb 2a                	jmp    8011f3 <memcmp+0x3e>
		if (*s1 != *s2)
  8011c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011cc:	8a 10                	mov    (%eax),%dl
  8011ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	38 c2                	cmp    %al,%dl
  8011d5:	74 16                	je     8011ed <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011da:	8a 00                	mov    (%eax),%al
  8011dc:	0f b6 d0             	movzbl %al,%edx
  8011df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e2:	8a 00                	mov    (%eax),%al
  8011e4:	0f b6 c0             	movzbl %al,%eax
  8011e7:	29 c2                	sub    %eax,%edx
  8011e9:	89 d0                	mov    %edx,%eax
  8011eb:	eb 18                	jmp    801205 <memcmp+0x50>
		s1++, s2++;
  8011ed:	ff 45 fc             	incl   -0x4(%ebp)
  8011f0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	75 c9                	jne    8011c9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801200:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801205:	c9                   	leave  
  801206:	c3                   	ret    

00801207 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80120d:	8b 55 08             	mov    0x8(%ebp),%edx
  801210:	8b 45 10             	mov    0x10(%ebp),%eax
  801213:	01 d0                	add    %edx,%eax
  801215:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801218:	eb 15                	jmp    80122f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	0f b6 d0             	movzbl %al,%edx
  801222:	8b 45 0c             	mov    0xc(%ebp),%eax
  801225:	0f b6 c0             	movzbl %al,%eax
  801228:	39 c2                	cmp    %eax,%edx
  80122a:	74 0d                	je     801239 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80122c:	ff 45 08             	incl   0x8(%ebp)
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801235:	72 e3                	jb     80121a <memfind+0x13>
  801237:	eb 01                	jmp    80123a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801239:	90                   	nop
	return (void *) s;
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    

0080123f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
  801242:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801245:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80124c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801253:	eb 03                	jmp    801258 <strtol+0x19>
		s++;
  801255:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	3c 20                	cmp    $0x20,%al
  80125f:	74 f4                	je     801255 <strtol+0x16>
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	3c 09                	cmp    $0x9,%al
  801268:	74 eb                	je     801255 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	3c 2b                	cmp    $0x2b,%al
  801271:	75 05                	jne    801278 <strtol+0x39>
		s++;
  801273:	ff 45 08             	incl   0x8(%ebp)
  801276:	eb 13                	jmp    80128b <strtol+0x4c>
	else if (*s == '-')
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	3c 2d                	cmp    $0x2d,%al
  80127f:	75 0a                	jne    80128b <strtol+0x4c>
		s++, neg = 1;
  801281:	ff 45 08             	incl   0x8(%ebp)
  801284:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80128b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128f:	74 06                	je     801297 <strtol+0x58>
  801291:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801295:	75 20                	jne    8012b7 <strtol+0x78>
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	3c 30                	cmp    $0x30,%al
  80129e:	75 17                	jne    8012b7 <strtol+0x78>
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	40                   	inc    %eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3c 78                	cmp    $0x78,%al
  8012a8:	75 0d                	jne    8012b7 <strtol+0x78>
		s += 2, base = 16;
  8012aa:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012ae:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012b5:	eb 28                	jmp    8012df <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012bb:	75 15                	jne    8012d2 <strtol+0x93>
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	3c 30                	cmp    $0x30,%al
  8012c4:	75 0c                	jne    8012d2 <strtol+0x93>
		s++, base = 8;
  8012c6:	ff 45 08             	incl   0x8(%ebp)
  8012c9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012d0:	eb 0d                	jmp    8012df <strtol+0xa0>
	else if (base == 0)
  8012d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d6:	75 07                	jne    8012df <strtol+0xa0>
		base = 10;
  8012d8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	8a 00                	mov    (%eax),%al
  8012e4:	3c 2f                	cmp    $0x2f,%al
  8012e6:	7e 19                	jle    801301 <strtol+0xc2>
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	8a 00                	mov    (%eax),%al
  8012ed:	3c 39                	cmp    $0x39,%al
  8012ef:	7f 10                	jg     801301 <strtol+0xc2>
			dig = *s - '0';
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	0f be c0             	movsbl %al,%eax
  8012f9:	83 e8 30             	sub    $0x30,%eax
  8012fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ff:	eb 42                	jmp    801343 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	8a 00                	mov    (%eax),%al
  801306:	3c 60                	cmp    $0x60,%al
  801308:	7e 19                	jle    801323 <strtol+0xe4>
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	3c 7a                	cmp    $0x7a,%al
  801311:	7f 10                	jg     801323 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f be c0             	movsbl %al,%eax
  80131b:	83 e8 57             	sub    $0x57,%eax
  80131e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801321:	eb 20                	jmp    801343 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	8a 00                	mov    (%eax),%al
  801328:	3c 40                	cmp    $0x40,%al
  80132a:	7e 39                	jle    801365 <strtol+0x126>
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	3c 5a                	cmp    $0x5a,%al
  801333:	7f 30                	jg     801365 <strtol+0x126>
			dig = *s - 'A' + 10;
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	8a 00                	mov    (%eax),%al
  80133a:	0f be c0             	movsbl %al,%eax
  80133d:	83 e8 37             	sub    $0x37,%eax
  801340:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801346:	3b 45 10             	cmp    0x10(%ebp),%eax
  801349:	7d 19                	jge    801364 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80134b:	ff 45 08             	incl   0x8(%ebp)
  80134e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801351:	0f af 45 10          	imul   0x10(%ebp),%eax
  801355:	89 c2                	mov    %eax,%edx
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	01 d0                	add    %edx,%eax
  80135c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80135f:	e9 7b ff ff ff       	jmp    8012df <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801364:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801365:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801369:	74 08                	je     801373 <strtol+0x134>
		*endptr = (char *) s;
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	8b 55 08             	mov    0x8(%ebp),%edx
  801371:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801373:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801377:	74 07                	je     801380 <strtol+0x141>
  801379:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137c:	f7 d8                	neg    %eax
  80137e:	eb 03                	jmp    801383 <strtol+0x144>
  801380:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801383:	c9                   	leave  
  801384:	c3                   	ret    

00801385 <ltostr>:

void
ltostr(long value, char *str)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80138b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801392:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801399:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80139d:	79 13                	jns    8013b2 <ltostr+0x2d>
	{
		neg = 1;
  80139f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013ac:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013af:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013ba:	99                   	cltd   
  8013bb:	f7 f9                	idiv   %ecx
  8013bd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c3:	8d 50 01             	lea    0x1(%eax),%edx
  8013c6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c9:	89 c2                	mov    %eax,%edx
  8013cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ce:	01 d0                	add    %edx,%eax
  8013d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d3:	83 c2 30             	add    $0x30,%edx
  8013d6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e0:	f7 e9                	imul   %ecx
  8013e2:	c1 fa 02             	sar    $0x2,%edx
  8013e5:	89 c8                	mov    %ecx,%eax
  8013e7:	c1 f8 1f             	sar    $0x1f,%eax
  8013ea:	29 c2                	sub    %eax,%edx
  8013ec:	89 d0                	mov    %edx,%eax
  8013ee:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013f5:	75 bb                	jne    8013b2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801401:	48                   	dec    %eax
  801402:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801405:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801409:	74 3d                	je     801448 <ltostr+0xc3>
		start = 1 ;
  80140b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801412:	eb 34                	jmp    801448 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801414:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141a:	01 d0                	add    %edx,%eax
  80141c:	8a 00                	mov    (%eax),%al
  80141e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801421:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801424:	8b 45 0c             	mov    0xc(%ebp),%eax
  801427:	01 c2                	add    %eax,%edx
  801429:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80142c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142f:	01 c8                	add    %ecx,%eax
  801431:	8a 00                	mov    (%eax),%al
  801433:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801435:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143b:	01 c2                	add    %eax,%edx
  80143d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801440:	88 02                	mov    %al,(%edx)
		start++ ;
  801442:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801445:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144e:	7c c4                	jl     801414 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801450:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	01 d0                	add    %edx,%eax
  801458:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80145b:	90                   	nop
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801464:	ff 75 08             	pushl  0x8(%ebp)
  801467:	e8 c4 f9 ff ff       	call   800e30 <strlen>
  80146c:	83 c4 04             	add    $0x4,%esp
  80146f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	e8 b6 f9 ff ff       	call   800e30 <strlen>
  80147a:	83 c4 04             	add    $0x4,%esp
  80147d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801480:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801487:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80148e:	eb 17                	jmp    8014a7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801490:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801493:	8b 45 10             	mov    0x10(%ebp),%eax
  801496:	01 c2                	add    %eax,%edx
  801498:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	01 c8                	add    %ecx,%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014a4:	ff 45 fc             	incl   -0x4(%ebp)
  8014a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014ad:	7c e1                	jl     801490 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014bd:	eb 1f                	jmp    8014de <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c2:	8d 50 01             	lea    0x1(%eax),%edx
  8014c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c8:	89 c2                	mov    %eax,%edx
  8014ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cd:	01 c2                	add    %eax,%edx
  8014cf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d5:	01 c8                	add    %ecx,%eax
  8014d7:	8a 00                	mov    (%eax),%al
  8014d9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014db:	ff 45 f8             	incl   -0x8(%ebp)
  8014de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014e4:	7c d9                	jl     8014bf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	01 d0                	add    %edx,%eax
  8014ee:	c6 00 00             	movb   $0x0,(%eax)
}
  8014f1:	90                   	nop
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801500:	8b 45 14             	mov    0x14(%ebp),%eax
  801503:	8b 00                	mov    (%eax),%eax
  801505:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80150c:	8b 45 10             	mov    0x10(%ebp),%eax
  80150f:	01 d0                	add    %edx,%eax
  801511:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801517:	eb 0c                	jmp    801525 <strsplit+0x31>
			*string++ = 0;
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8d 50 01             	lea    0x1(%eax),%edx
  80151f:	89 55 08             	mov    %edx,0x8(%ebp)
  801522:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	8a 00                	mov    (%eax),%al
  80152a:	84 c0                	test   %al,%al
  80152c:	74 18                	je     801546 <strsplit+0x52>
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	0f be c0             	movsbl %al,%eax
  801536:	50                   	push   %eax
  801537:	ff 75 0c             	pushl  0xc(%ebp)
  80153a:	e8 83 fa ff ff       	call   800fc2 <strchr>
  80153f:	83 c4 08             	add    $0x8,%esp
  801542:	85 c0                	test   %eax,%eax
  801544:	75 d3                	jne    801519 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8a 00                	mov    (%eax),%al
  80154b:	84 c0                	test   %al,%al
  80154d:	74 5a                	je     8015a9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80154f:	8b 45 14             	mov    0x14(%ebp),%eax
  801552:	8b 00                	mov    (%eax),%eax
  801554:	83 f8 0f             	cmp    $0xf,%eax
  801557:	75 07                	jne    801560 <strsplit+0x6c>
		{
			return 0;
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
  80155e:	eb 66                	jmp    8015c6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801560:	8b 45 14             	mov    0x14(%ebp),%eax
  801563:	8b 00                	mov    (%eax),%eax
  801565:	8d 48 01             	lea    0x1(%eax),%ecx
  801568:	8b 55 14             	mov    0x14(%ebp),%edx
  80156b:	89 0a                	mov    %ecx,(%edx)
  80156d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801574:	8b 45 10             	mov    0x10(%ebp),%eax
  801577:	01 c2                	add    %eax,%edx
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80157e:	eb 03                	jmp    801583 <strsplit+0x8f>
			string++;
  801580:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	8a 00                	mov    (%eax),%al
  801588:	84 c0                	test   %al,%al
  80158a:	74 8b                	je     801517 <strsplit+0x23>
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	0f be c0             	movsbl %al,%eax
  801594:	50                   	push   %eax
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	e8 25 fa ff ff       	call   800fc2 <strchr>
  80159d:	83 c4 08             	add    $0x8,%esp
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	74 dc                	je     801580 <strsplit+0x8c>
			string++;
	}
  8015a4:	e9 6e ff ff ff       	jmp    801517 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015a9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ad:	8b 00                	mov    (%eax),%eax
  8015af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b9:	01 d0                	add    %edx,%eax
  8015bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015db:	eb 4a                	jmp    801627 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	01 c2                	add    %eax,%edx
  8015e5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	01 c8                	add    %ecx,%eax
  8015ed:	8a 00                	mov    (%eax),%al
  8015ef:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f7:	01 d0                	add    %edx,%eax
  8015f9:	8a 00                	mov    (%eax),%al
  8015fb:	3c 40                	cmp    $0x40,%al
  8015fd:	7e 25                	jle    801624 <str2lower+0x5c>
  8015ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801602:	8b 45 0c             	mov    0xc(%ebp),%eax
  801605:	01 d0                	add    %edx,%eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	3c 5a                	cmp    $0x5a,%al
  80160b:	7f 17                	jg     801624 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80160d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	01 d0                	add    %edx,%eax
  801615:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801618:	8b 55 08             	mov    0x8(%ebp),%edx
  80161b:	01 ca                	add    %ecx,%edx
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	83 c2 20             	add    $0x20,%edx
  801622:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801624:	ff 45 fc             	incl   -0x4(%ebp)
  801627:	ff 75 0c             	pushl  0xc(%ebp)
  80162a:	e8 01 f8 ff ff       	call   800e30 <strlen>
  80162f:	83 c4 04             	add    $0x4,%esp
  801632:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801635:	7f a6                	jg     8015dd <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801637:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801642:	83 ec 0c             	sub    $0xc,%esp
  801645:	6a 10                	push   $0x10
  801647:	e8 b2 15 00 00       	call   802bfe <alloc_block>
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801652:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801656:	75 14                	jne    80166c <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	68 c8 40 80 00       	push   $0x8040c8
  801660:	6a 14                	push   $0x14
  801662:	68 f1 40 80 00       	push   $0x8040f1
  801667:	e8 17 20 00 00       	call   803683 <_panic>

	node->start = start;
  80166c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166f:	8b 55 08             	mov    0x8(%ebp),%edx
  801672:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801674:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167a:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  80167d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801684:	a1 24 50 80 00       	mov    0x805024,%eax
  801689:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80168c:	eb 18                	jmp    8016a6 <insert_page_alloc+0x6a>
		if (start < it->start)
  80168e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801691:	8b 00                	mov    (%eax),%eax
  801693:	3b 45 08             	cmp    0x8(%ebp),%eax
  801696:	77 37                	ja     8016cf <insert_page_alloc+0x93>
			break;
		prev = it;
  801698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  80169e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016aa:	74 08                	je     8016b4 <insert_page_alloc+0x78>
  8016ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016af:	8b 40 08             	mov    0x8(%eax),%eax
  8016b2:	eb 05                	jmp    8016b9 <insert_page_alloc+0x7d>
  8016b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8016be:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	75 c7                	jne    80168e <insert_page_alloc+0x52>
  8016c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016cb:	75 c1                	jne    80168e <insert_page_alloc+0x52>
  8016cd:	eb 01                	jmp    8016d0 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8016cf:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8016d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016d4:	75 64                	jne    80173a <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8016d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016da:	75 14                	jne    8016f0 <insert_page_alloc+0xb4>
  8016dc:	83 ec 04             	sub    $0x4,%esp
  8016df:	68 00 41 80 00       	push   $0x804100
  8016e4:	6a 21                	push   $0x21
  8016e6:	68 f1 40 80 00       	push   $0x8040f1
  8016eb:	e8 93 1f 00 00       	call   803683 <_panic>
  8016f0:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8016f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f9:	89 50 08             	mov    %edx,0x8(%eax)
  8016fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ff:	8b 40 08             	mov    0x8(%eax),%eax
  801702:	85 c0                	test   %eax,%eax
  801704:	74 0d                	je     801713 <insert_page_alloc+0xd7>
  801706:	a1 24 50 80 00       	mov    0x805024,%eax
  80170b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80170e:	89 50 0c             	mov    %edx,0xc(%eax)
  801711:	eb 08                	jmp    80171b <insert_page_alloc+0xdf>
  801713:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801716:	a3 28 50 80 00       	mov    %eax,0x805028
  80171b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171e:	a3 24 50 80 00       	mov    %eax,0x805024
  801723:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801726:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80172d:	a1 30 50 80 00       	mov    0x805030,%eax
  801732:	40                   	inc    %eax
  801733:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801738:	eb 71                	jmp    8017ab <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  80173a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80173e:	74 06                	je     801746 <insert_page_alloc+0x10a>
  801740:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801744:	75 14                	jne    80175a <insert_page_alloc+0x11e>
  801746:	83 ec 04             	sub    $0x4,%esp
  801749:	68 24 41 80 00       	push   $0x804124
  80174e:	6a 23                	push   $0x23
  801750:	68 f1 40 80 00       	push   $0x8040f1
  801755:	e8 29 1f 00 00       	call   803683 <_panic>
  80175a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175d:	8b 50 08             	mov    0x8(%eax),%edx
  801760:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801763:	89 50 08             	mov    %edx,0x8(%eax)
  801766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801769:	8b 40 08             	mov    0x8(%eax),%eax
  80176c:	85 c0                	test   %eax,%eax
  80176e:	74 0c                	je     80177c <insert_page_alloc+0x140>
  801770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801773:	8b 40 08             	mov    0x8(%eax),%eax
  801776:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801779:	89 50 0c             	mov    %edx,0xc(%eax)
  80177c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801782:	89 50 08             	mov    %edx,0x8(%eax)
  801785:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801788:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80178b:	89 50 0c             	mov    %edx,0xc(%eax)
  80178e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801791:	8b 40 08             	mov    0x8(%eax),%eax
  801794:	85 c0                	test   %eax,%eax
  801796:	75 08                	jne    8017a0 <insert_page_alloc+0x164>
  801798:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179b:	a3 28 50 80 00       	mov    %eax,0x805028
  8017a0:	a1 30 50 80 00       	mov    0x805030,%eax
  8017a5:	40                   	inc    %eax
  8017a6:	a3 30 50 80 00       	mov    %eax,0x805030
}
  8017ab:	90                   	nop
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  8017b4:	a1 24 50 80 00       	mov    0x805024,%eax
  8017b9:	85 c0                	test   %eax,%eax
  8017bb:	75 0c                	jne    8017c9 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  8017bd:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  8017c2:	a3 08 eb 87 00       	mov    %eax,0x87eb08
		return;
  8017c7:	eb 67                	jmp    801830 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  8017c9:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  8017ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8017d1:	a1 24 50 80 00       	mov    0x805024,%eax
  8017d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8017d9:	eb 26                	jmp    801801 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  8017db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017de:	8b 10                	mov    (%eax),%edx
  8017e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e3:	8b 40 04             	mov    0x4(%eax),%eax
  8017e6:	01 d0                	add    %edx,%eax
  8017e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  8017eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017f1:	76 06                	jbe    8017f9 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  8017f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8017f9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801801:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801805:	74 08                	je     80180f <recompute_page_alloc_break+0x61>
  801807:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180a:	8b 40 08             	mov    0x8(%eax),%eax
  80180d:	eb 05                	jmp    801814 <recompute_page_alloc_break+0x66>
  80180f:	b8 00 00 00 00       	mov    $0x0,%eax
  801814:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801819:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80181e:	85 c0                	test   %eax,%eax
  801820:	75 b9                	jne    8017db <recompute_page_alloc_break+0x2d>
  801822:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801826:	75 b3                	jne    8017db <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801828:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182b:	a3 08 eb 87 00       	mov    %eax,0x87eb08
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801838:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80183f:	8b 55 08             	mov    0x8(%ebp),%edx
  801842:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801845:	01 d0                	add    %edx,%eax
  801847:	48                   	dec    %eax
  801848:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80184b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80184e:	ba 00 00 00 00       	mov    $0x0,%edx
  801853:	f7 75 d8             	divl   -0x28(%ebp)
  801856:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801859:	29 d0                	sub    %edx,%eax
  80185b:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  80185e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801862:	75 0a                	jne    80186e <alloc_pages_custom_fit+0x3c>
		return NULL;
  801864:	b8 00 00 00 00       	mov    $0x0,%eax
  801869:	e9 7e 01 00 00       	jmp    8019ec <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  80186e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801875:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801879:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801880:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801887:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  80188c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  80188f:	a1 24 50 80 00       	mov    0x805024,%eax
  801894:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801897:	eb 69                	jmp    801902 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801899:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189c:	8b 00                	mov    (%eax),%eax
  80189e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8018a1:	76 47                	jbe    8018ea <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  8018a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018a6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  8018a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ac:	8b 00                	mov    (%eax),%eax
  8018ae:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8018b1:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  8018b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018b7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018ba:	72 2e                	jb     8018ea <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  8018bc:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8018c0:	75 14                	jne    8018d6 <alloc_pages_custom_fit+0xa4>
  8018c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018c5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018c8:	75 0c                	jne    8018d6 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  8018ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  8018d0:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8018d4:	eb 14                	jmp    8018ea <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  8018d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018d9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018dc:	76 0c                	jbe    8018ea <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  8018de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  8018e4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  8018ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ed:	8b 10                	mov    (%eax),%edx
  8018ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f2:	8b 40 04             	mov    0x4(%eax),%eax
  8018f5:	01 d0                	add    %edx,%eax
  8018f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8018fa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801902:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801906:	74 08                	je     801910 <alloc_pages_custom_fit+0xde>
  801908:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80190b:	8b 40 08             	mov    0x8(%eax),%eax
  80190e:	eb 05                	jmp    801915 <alloc_pages_custom_fit+0xe3>
  801910:	b8 00 00 00 00       	mov    $0x0,%eax
  801915:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80191a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80191f:	85 c0                	test   %eax,%eax
  801921:	0f 85 72 ff ff ff    	jne    801899 <alloc_pages_custom_fit+0x67>
  801927:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80192b:	0f 85 68 ff ff ff    	jne    801899 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801931:	a1 08 eb 87 00       	mov    0x87eb08,%eax
  801936:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801939:	76 47                	jbe    801982 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  80193b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80193e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801941:	a1 08 eb 87 00       	mov    0x87eb08,%eax
  801946:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801949:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  80194c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80194f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801952:	72 2e                	jb     801982 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801954:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801958:	75 14                	jne    80196e <alloc_pages_custom_fit+0x13c>
  80195a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80195d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801960:	75 0c                	jne    80196e <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801962:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801965:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801968:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  80196c:	eb 14                	jmp    801982 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  80196e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801971:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801974:	76 0c                	jbe    801982 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801976:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801979:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  80197c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80197f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801982:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801989:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80198d:	74 08                	je     801997 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  80198f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801992:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801995:	eb 40                	jmp    8019d7 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801997:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80199b:	74 08                	je     8019a5 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  80199d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019a3:	eb 32                	jmp    8019d7 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  8019a5:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8019aa:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8019ad:	89 c2                	mov    %eax,%edx
  8019af:	a1 08 eb 87 00       	mov    0x87eb08,%eax
  8019b4:	39 c2                	cmp    %eax,%edx
  8019b6:	73 07                	jae    8019bf <alloc_pages_custom_fit+0x18d>
			return NULL;
  8019b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bd:	eb 2d                	jmp    8019ec <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  8019bf:	a1 08 eb 87 00       	mov    0x87eb08,%eax
  8019c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  8019c7:	8b 15 08 eb 87 00    	mov    0x87eb08,%edx
  8019cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019d0:	01 d0                	add    %edx,%eax
  8019d2:	a3 08 eb 87 00       	mov    %eax,0x87eb08
	}


	insert_page_alloc((uint32)result, required_size);
  8019d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019da:	83 ec 08             	sub    $0x8,%esp
  8019dd:	ff 75 d0             	pushl  -0x30(%ebp)
  8019e0:	50                   	push   %eax
  8019e1:	e8 56 fc ff ff       	call   80163c <insert_page_alloc>
  8019e6:	83 c4 10             	add    $0x10,%esp

	return result;
  8019e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8019fa:	a1 24 50 80 00       	mov    0x805024,%eax
  8019ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801a02:	eb 1a                	jmp    801a1e <find_allocated_size+0x30>
		if (it->start == va)
  801a04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a07:	8b 00                	mov    (%eax),%eax
  801a09:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a0c:	75 08                	jne    801a16 <find_allocated_size+0x28>
			return it->size;
  801a0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a11:	8b 40 04             	mov    0x4(%eax),%eax
  801a14:	eb 34                	jmp    801a4a <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a16:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801a1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a22:	74 08                	je     801a2c <find_allocated_size+0x3e>
  801a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a27:	8b 40 08             	mov    0x8(%eax),%eax
  801a2a:	eb 05                	jmp    801a31 <find_allocated_size+0x43>
  801a2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a31:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801a36:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	75 c5                	jne    801a04 <find_allocated_size+0x16>
  801a3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a43:	75 bf                	jne    801a04 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801a45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a58:	a1 24 50 80 00       	mov    0x805024,%eax
  801a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a60:	e9 e1 01 00 00       	jmp    801c46 <free_pages+0x1fa>
		if (it->start == va) {
  801a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a68:	8b 00                	mov    (%eax),%eax
  801a6a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801a6d:	0f 85 cb 01 00 00    	jne    801c3e <free_pages+0x1f2>

			uint32 start = it->start;
  801a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a76:	8b 00                	mov    (%eax),%eax
  801a78:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7e:	8b 40 04             	mov    0x4(%eax),%eax
  801a81:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801a84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a87:	f7 d0                	not    %eax
  801a89:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a8c:	73 1d                	jae    801aab <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801a8e:	83 ec 0c             	sub    $0xc,%esp
  801a91:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a94:	ff 75 e8             	pushl  -0x18(%ebp)
  801a97:	68 58 41 80 00       	push   $0x804158
  801a9c:	68 a5 00 00 00       	push   $0xa5
  801aa1:	68 f1 40 80 00       	push   $0x8040f1
  801aa6:	e8 d8 1b 00 00       	call   803683 <_panic>
			}

			uint32 start_end = start + size;
  801aab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801aae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ab1:	01 d0                	add    %edx,%eax
  801ab3:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801ab6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	79 19                	jns    801ad6 <free_pages+0x8a>
  801abd:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801ac4:	77 10                	ja     801ad6 <free_pages+0x8a>
  801ac6:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801acd:	77 07                	ja     801ad6 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801acf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	78 2c                	js     801b02 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801ad6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ad9:	83 ec 0c             	sub    $0xc,%esp
  801adc:	68 00 00 00 a0       	push   $0xa0000000
  801ae1:	ff 75 e0             	pushl  -0x20(%ebp)
  801ae4:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ae7:	ff 75 e8             	pushl  -0x18(%ebp)
  801aea:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aed:	50                   	push   %eax
  801aee:	68 9c 41 80 00       	push   $0x80419c
  801af3:	68 ad 00 00 00       	push   $0xad
  801af8:	68 f1 40 80 00       	push   $0x8040f1
  801afd:	e8 81 1b 00 00       	call   803683 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b08:	e9 88 00 00 00       	jmp    801b95 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801b0d:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801b14:	76 17                	jbe    801b2d <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801b16:	ff 75 f0             	pushl  -0x10(%ebp)
  801b19:	68 00 42 80 00       	push   $0x804200
  801b1e:	68 b4 00 00 00       	push   $0xb4
  801b23:	68 f1 40 80 00       	push   $0x8040f1
  801b28:	e8 56 1b 00 00       	call   803683 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b30:	05 00 10 00 00       	add    $0x1000,%eax
  801b35:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	79 2e                	jns    801b6d <free_pages+0x121>
  801b3f:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801b46:	77 25                	ja     801b6d <free_pages+0x121>
  801b48:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801b4f:	77 1c                	ja     801b6d <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801b51:	83 ec 08             	sub    $0x8,%esp
  801b54:	68 00 10 00 00       	push   $0x1000
  801b59:	ff 75 f0             	pushl  -0x10(%ebp)
  801b5c:	e8 38 0d 00 00       	call   802899 <sys_free_user_mem>
  801b61:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b64:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801b6b:	eb 28                	jmp    801b95 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b70:	68 00 00 00 a0       	push   $0xa0000000
  801b75:	ff 75 dc             	pushl  -0x24(%ebp)
  801b78:	68 00 10 00 00       	push   $0x1000
  801b7d:	ff 75 f0             	pushl  -0x10(%ebp)
  801b80:	50                   	push   %eax
  801b81:	68 40 42 80 00       	push   $0x804240
  801b86:	68 bd 00 00 00       	push   $0xbd
  801b8b:	68 f1 40 80 00       	push   $0x8040f1
  801b90:	e8 ee 1a 00 00       	call   803683 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b98:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801b9b:	0f 82 6c ff ff ff    	jb     801b0d <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801ba1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ba5:	75 17                	jne    801bbe <free_pages+0x172>
  801ba7:	83 ec 04             	sub    $0x4,%esp
  801baa:	68 a2 42 80 00       	push   $0x8042a2
  801baf:	68 c1 00 00 00       	push   $0xc1
  801bb4:	68 f1 40 80 00       	push   $0x8040f1
  801bb9:	e8 c5 1a 00 00       	call   803683 <_panic>
  801bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc1:	8b 40 08             	mov    0x8(%eax),%eax
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	74 11                	je     801bd9 <free_pages+0x18d>
  801bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bcb:	8b 40 08             	mov    0x8(%eax),%eax
  801bce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd1:	8b 52 0c             	mov    0xc(%edx),%edx
  801bd4:	89 50 0c             	mov    %edx,0xc(%eax)
  801bd7:	eb 0b                	jmp    801be4 <free_pages+0x198>
  801bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdc:	8b 40 0c             	mov    0xc(%eax),%eax
  801bdf:	a3 28 50 80 00       	mov    %eax,0x805028
  801be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be7:	8b 40 0c             	mov    0xc(%eax),%eax
  801bea:	85 c0                	test   %eax,%eax
  801bec:	74 11                	je     801bff <free_pages+0x1b3>
  801bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf1:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bf7:	8b 52 08             	mov    0x8(%edx),%edx
  801bfa:	89 50 08             	mov    %edx,0x8(%eax)
  801bfd:	eb 0b                	jmp    801c0a <free_pages+0x1be>
  801bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c02:	8b 40 08             	mov    0x8(%eax),%eax
  801c05:	a3 24 50 80 00       	mov    %eax,0x805024
  801c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c1e:	a1 30 50 80 00       	mov    0x805030,%eax
  801c23:	48                   	dec    %eax
  801c24:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801c29:	83 ec 0c             	sub    $0xc,%esp
  801c2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2f:	e8 24 15 00 00       	call   803158 <free_block>
  801c34:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801c37:	e8 72 fb ff ff       	call   8017ae <recompute_page_alloc_break>

			return;
  801c3c:	eb 37                	jmp    801c75 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801c3e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c4a:	74 08                	je     801c54 <free_pages+0x208>
  801c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4f:	8b 40 08             	mov    0x8(%eax),%eax
  801c52:	eb 05                	jmp    801c59 <free_pages+0x20d>
  801c54:	b8 00 00 00 00       	mov    $0x0,%eax
  801c59:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801c5e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c63:	85 c0                	test   %eax,%eax
  801c65:	0f 85 fa fd ff ff    	jne    801a65 <free_pages+0x19>
  801c6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c6f:	0f 85 f0 fd ff ff    	jne    801a65 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7f:	5d                   	pop    %ebp
  801c80:	c3                   	ret    

00801c81 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801c87:	a1 08 50 80 00       	mov    0x805008,%eax
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	74 60                	je     801cf0 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801c90:	83 ec 08             	sub    $0x8,%esp
  801c93:	68 00 00 00 82       	push   $0x82000000
  801c98:	68 00 00 00 80       	push   $0x80000000
  801c9d:	e8 0d 0d 00 00       	call   8029af <initialize_dynamic_allocator>
  801ca2:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801ca5:	e8 f3 0a 00 00       	call   80279d <sys_get_uheap_strategy>
  801caa:	a3 00 eb 87 00       	mov    %eax,0x87eb00
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801caf:	a1 40 50 80 00       	mov    0x805040,%eax
  801cb4:	05 00 10 00 00       	add    $0x1000,%eax
  801cb9:	a3 b0 eb 87 00       	mov    %eax,0x87ebb0
		uheapPageAllocBreak = uheapPageAllocStart;
  801cbe:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  801cc3:	a3 08 eb 87 00       	mov    %eax,0x87eb08

		LIST_INIT(&page_alloc_list);
  801cc8:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801ccf:	00 00 00 
  801cd2:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801cd9:	00 00 00 
  801cdc:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801ce3:	00 00 00 

		__firstTimeFlag = 0;
  801ce6:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801ced:	00 00 00 
	}
}
  801cf0:	90                   	nop
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d07:	83 ec 08             	sub    $0x8,%esp
  801d0a:	68 06 04 00 00       	push   $0x406
  801d0f:	50                   	push   %eax
  801d10:	e8 d2 06 00 00       	call   8023e7 <__sys_allocate_page>
  801d15:	83 c4 10             	add    $0x10,%esp
  801d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d1f:	79 17                	jns    801d38 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801d21:	83 ec 04             	sub    $0x4,%esp
  801d24:	68 c0 42 80 00       	push   $0x8042c0
  801d29:	68 ea 00 00 00       	push   $0xea
  801d2e:	68 f1 40 80 00       	push   $0x8040f1
  801d33:	e8 4b 19 00 00       	call   803683 <_panic>
	return 0;
  801d38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d53:	83 ec 0c             	sub    $0xc,%esp
  801d56:	50                   	push   %eax
  801d57:	e8 d2 06 00 00       	call   80242e <__sys_unmap_frame>
  801d5c:	83 c4 10             	add    $0x10,%esp
  801d5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d66:	79 17                	jns    801d7f <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801d68:	83 ec 04             	sub    $0x4,%esp
  801d6b:	68 fc 42 80 00       	push   $0x8042fc
  801d70:	68 f5 00 00 00       	push   $0xf5
  801d75:	68 f1 40 80 00       	push   $0x8040f1
  801d7a:	e8 04 19 00 00       	call   803683 <_panic>
}
  801d7f:	90                   	nop
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d88:	e8 f4 fe ff ff       	call   801c81 <uheap_init>
	if (size == 0) return NULL ;
  801d8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d91:	75 0a                	jne    801d9d <malloc+0x1b>
  801d93:	b8 00 00 00 00       	mov    $0x0,%eax
  801d98:	e9 67 01 00 00       	jmp    801f04 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801d9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801da4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801dab:	77 16                	ja     801dc3 <malloc+0x41>
		result = alloc_block(size);
  801dad:	83 ec 0c             	sub    $0xc,%esp
  801db0:	ff 75 08             	pushl  0x8(%ebp)
  801db3:	e8 46 0e 00 00       	call   802bfe <alloc_block>
  801db8:	83 c4 10             	add    $0x10,%esp
  801dbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dbe:	e9 3e 01 00 00       	jmp    801f01 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801dc3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801dca:	8b 55 08             	mov    0x8(%ebp),%edx
  801dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd0:	01 d0                	add    %edx,%eax
  801dd2:	48                   	dec    %eax
  801dd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801dd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dd9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dde:	f7 75 f0             	divl   -0x10(%ebp)
  801de1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de4:	29 d0                	sub    %edx,%eax
  801de6:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801de9:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  801dee:	85 c0                	test   %eax,%eax
  801df0:	75 0a                	jne    801dfc <malloc+0x7a>
			return NULL;
  801df2:	b8 00 00 00 00       	mov    $0x0,%eax
  801df7:	e9 08 01 00 00       	jmp    801f04 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801dfc:	a1 08 eb 87 00       	mov    0x87eb08,%eax
  801e01:	85 c0                	test   %eax,%eax
  801e03:	74 0f                	je     801e14 <malloc+0x92>
  801e05:	8b 15 08 eb 87 00    	mov    0x87eb08,%edx
  801e0b:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  801e10:	39 c2                	cmp    %eax,%edx
  801e12:	73 0a                	jae    801e1e <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801e14:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  801e19:	a3 08 eb 87 00       	mov    %eax,0x87eb08
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801e1e:	a1 00 eb 87 00       	mov    0x87eb00,%eax
  801e23:	83 f8 05             	cmp    $0x5,%eax
  801e26:	75 11                	jne    801e39 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801e28:	83 ec 0c             	sub    $0xc,%esp
  801e2b:	ff 75 e8             	pushl  -0x18(%ebp)
  801e2e:	e8 ff f9 ff ff       	call   801832 <alloc_pages_custom_fit>
  801e33:	83 c4 10             	add    $0x10,%esp
  801e36:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801e39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e3d:	0f 84 be 00 00 00    	je     801f01 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801e49:	83 ec 0c             	sub    $0xc,%esp
  801e4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4f:	e8 9a fb ff ff       	call   8019ee <find_allocated_size>
  801e54:	83 c4 10             	add    $0x10,%esp
  801e57:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801e5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e5e:	75 17                	jne    801e77 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801e60:	ff 75 f4             	pushl  -0xc(%ebp)
  801e63:	68 3c 43 80 00       	push   $0x80433c
  801e68:	68 24 01 00 00       	push   $0x124
  801e6d:	68 f1 40 80 00       	push   $0x8040f1
  801e72:	e8 0c 18 00 00       	call   803683 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801e77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e7a:	f7 d0                	not    %eax
  801e7c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e7f:	73 1d                	jae    801e9e <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801e81:	83 ec 0c             	sub    $0xc,%esp
  801e84:	ff 75 e0             	pushl  -0x20(%ebp)
  801e87:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e8a:	68 84 43 80 00       	push   $0x804384
  801e8f:	68 29 01 00 00       	push   $0x129
  801e94:	68 f1 40 80 00       	push   $0x8040f1
  801e99:	e8 e5 17 00 00       	call   803683 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801e9e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ea1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea4:	01 d0                	add    %edx,%eax
  801ea6:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801ea9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eac:	85 c0                	test   %eax,%eax
  801eae:	79 2c                	jns    801edc <malloc+0x15a>
  801eb0:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801eb7:	77 23                	ja     801edc <malloc+0x15a>
  801eb9:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801ec0:	77 1a                	ja     801edc <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801ec2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ec5:	85 c0                	test   %eax,%eax
  801ec7:	79 13                	jns    801edc <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801ec9:	83 ec 08             	sub    $0x8,%esp
  801ecc:	ff 75 e0             	pushl  -0x20(%ebp)
  801ecf:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ed2:	e8 de 09 00 00       	call   8028b5 <sys_allocate_user_mem>
  801ed7:	83 c4 10             	add    $0x10,%esp
  801eda:	eb 25                	jmp    801f01 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801edc:	68 00 00 00 a0       	push   $0xa0000000
  801ee1:	ff 75 dc             	pushl  -0x24(%ebp)
  801ee4:	ff 75 e0             	pushl  -0x20(%ebp)
  801ee7:	ff 75 e4             	pushl  -0x1c(%ebp)
  801eea:	ff 75 f4             	pushl  -0xc(%ebp)
  801eed:	68 c0 43 80 00       	push   $0x8043c0
  801ef2:	68 33 01 00 00       	push   $0x133
  801ef7:	68 f1 40 80 00       	push   $0x8040f1
  801efc:	e8 82 17 00 00       	call   803683 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801f0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f10:	0f 84 26 01 00 00    	je     80203c <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801f16:	8b 45 08             	mov    0x8(%ebp),%eax
  801f19:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	79 1c                	jns    801f3f <free+0x39>
  801f23:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801f2a:	77 13                	ja     801f3f <free+0x39>
		free_block(virtual_address);
  801f2c:	83 ec 0c             	sub    $0xc,%esp
  801f2f:	ff 75 08             	pushl  0x8(%ebp)
  801f32:	e8 21 12 00 00       	call   803158 <free_block>
  801f37:	83 c4 10             	add    $0x10,%esp
		return;
  801f3a:	e9 01 01 00 00       	jmp    802040 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801f3f:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  801f44:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801f47:	0f 82 d8 00 00 00    	jb     802025 <free+0x11f>
  801f4d:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801f54:	0f 87 cb 00 00 00    	ja     802025 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5d:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f62:	85 c0                	test   %eax,%eax
  801f64:	74 17                	je     801f7d <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801f66:	ff 75 08             	pushl  0x8(%ebp)
  801f69:	68 30 44 80 00       	push   $0x804430
  801f6e:	68 57 01 00 00       	push   $0x157
  801f73:	68 f1 40 80 00       	push   $0x8040f1
  801f78:	e8 06 17 00 00       	call   803683 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801f7d:	83 ec 0c             	sub    $0xc,%esp
  801f80:	ff 75 08             	pushl  0x8(%ebp)
  801f83:	e8 66 fa ff ff       	call   8019ee <find_allocated_size>
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801f8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f92:	0f 84 a7 00 00 00    	je     80203f <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9b:	f7 d0                	not    %eax
  801f9d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801fa0:	73 1d                	jae    801fbf <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801fa2:	83 ec 0c             	sub    $0xc,%esp
  801fa5:	ff 75 f0             	pushl  -0x10(%ebp)
  801fa8:	ff 75 f4             	pushl  -0xc(%ebp)
  801fab:	68 58 44 80 00       	push   $0x804458
  801fb0:	68 61 01 00 00       	push   $0x161
  801fb5:	68 f1 40 80 00       	push   $0x8040f1
  801fba:	e8 c4 16 00 00       	call   803683 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801fbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc5:	01 d0                	add    %edx,%eax
  801fc7:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	79 19                	jns    801fea <free+0xe4>
  801fd1:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801fd8:	77 10                	ja     801fea <free+0xe4>
  801fda:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801fe1:	77 07                	ja     801fea <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801fe3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	78 2b                	js     802015 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801fea:	83 ec 0c             	sub    $0xc,%esp
  801fed:	68 00 00 00 a0       	push   $0xa0000000
  801ff2:	ff 75 ec             	pushl  -0x14(%ebp)
  801ff5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ff8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ffb:	ff 75 f0             	pushl  -0x10(%ebp)
  801ffe:	ff 75 08             	pushl  0x8(%ebp)
  802001:	68 94 44 80 00       	push   $0x804494
  802006:	68 69 01 00 00       	push   $0x169
  80200b:	68 f1 40 80 00       	push   $0x8040f1
  802010:	e8 6e 16 00 00       	call   803683 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  802015:	83 ec 0c             	sub    $0xc,%esp
  802018:	ff 75 08             	pushl  0x8(%ebp)
  80201b:	e8 2c fa ff ff       	call   801a4c <free_pages>
  802020:	83 c4 10             	add    $0x10,%esp
		return;
  802023:	eb 1b                	jmp    802040 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  802025:	ff 75 08             	pushl  0x8(%ebp)
  802028:	68 f0 44 80 00       	push   $0x8044f0
  80202d:	68 70 01 00 00       	push   $0x170
  802032:	68 f1 40 80 00       	push   $0x8040f1
  802037:	e8 47 16 00 00       	call   803683 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  80203c:	90                   	nop
  80203d:	eb 01                	jmp    802040 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  80203f:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	83 ec 38             	sub    $0x38,%esp
  802048:	8b 45 10             	mov    0x10(%ebp),%eax
  80204b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80204e:	e8 2e fc ff ff       	call   801c81 <uheap_init>
	if (size == 0) return NULL ;
  802053:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802057:	75 0a                	jne    802063 <smalloc+0x21>
  802059:	b8 00 00 00 00       	mov    $0x0,%eax
  80205e:	e9 3d 01 00 00       	jmp    8021a0 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  802063:	8b 45 0c             	mov    0xc(%ebp),%eax
  802066:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  802069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206c:	25 ff 0f 00 00       	and    $0xfff,%eax
  802071:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  802074:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802078:	74 0e                	je     802088 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802080:	05 00 10 00 00       	add    $0x1000,%eax
  802085:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  802088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208b:	c1 e8 0c             	shr    $0xc,%eax
  80208e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802091:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  802096:	85 c0                	test   %eax,%eax
  802098:	75 0a                	jne    8020a4 <smalloc+0x62>
		return NULL;
  80209a:	b8 00 00 00 00       	mov    $0x0,%eax
  80209f:	e9 fc 00 00 00       	jmp    8021a0 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8020a4:	a1 08 eb 87 00       	mov    0x87eb08,%eax
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	74 0f                	je     8020bc <smalloc+0x7a>
  8020ad:	8b 15 08 eb 87 00    	mov    0x87eb08,%edx
  8020b3:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  8020b8:	39 c2                	cmp    %eax,%edx
  8020ba:	73 0a                	jae    8020c6 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  8020bc:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  8020c1:	a3 08 eb 87 00       	mov    %eax,0x87eb08

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8020c6:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  8020cb:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8020d0:	29 c2                	sub    %eax,%edx
  8020d2:	89 d0                	mov    %edx,%eax
  8020d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8020d7:	8b 15 08 eb 87 00    	mov    0x87eb08,%edx
  8020dd:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  8020e2:	29 c2                	sub    %eax,%edx
  8020e4:	89 d0                	mov    %edx,%eax
  8020e6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020ef:	77 13                	ja     802104 <smalloc+0xc2>
  8020f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020f4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020f7:	77 0b                	ja     802104 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  8020f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020fc:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020ff:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802102:	73 0a                	jae    80210e <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  802104:	b8 00 00 00 00       	mov    $0x0,%eax
  802109:	e9 92 00 00 00       	jmp    8021a0 <smalloc+0x15e>
	}

	void *va = NULL;
  80210e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802115:	a1 00 eb 87 00       	mov    0x87eb00,%eax
  80211a:	83 f8 05             	cmp    $0x5,%eax
  80211d:	75 11                	jne    802130 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  80211f:	83 ec 0c             	sub    $0xc,%esp
  802122:	ff 75 f4             	pushl  -0xc(%ebp)
  802125:	e8 08 f7 ff ff       	call   801832 <alloc_pages_custom_fit>
  80212a:	83 c4 10             	add    $0x10,%esp
  80212d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802130:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802134:	75 27                	jne    80215d <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802136:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  80213d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802140:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802143:	89 c2                	mov    %eax,%edx
  802145:	a1 08 eb 87 00       	mov    0x87eb08,%eax
  80214a:	39 c2                	cmp    %eax,%edx
  80214c:	73 07                	jae    802155 <smalloc+0x113>
			return NULL;}
  80214e:	b8 00 00 00 00       	mov    $0x0,%eax
  802153:	eb 4b                	jmp    8021a0 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  802155:	a1 08 eb 87 00       	mov    0x87eb08,%eax
  80215a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  80215d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802161:	ff 75 f0             	pushl  -0x10(%ebp)
  802164:	50                   	push   %eax
  802165:	ff 75 0c             	pushl  0xc(%ebp)
  802168:	ff 75 08             	pushl  0x8(%ebp)
  80216b:	e8 cb 03 00 00       	call   80253b <sys_create_shared_object>
  802170:	83 c4 10             	add    $0x10,%esp
  802173:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  802176:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80217a:	79 07                	jns    802183 <smalloc+0x141>
		return NULL;
  80217c:	b8 00 00 00 00       	mov    $0x0,%eax
  802181:	eb 1d                	jmp    8021a0 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802183:	a1 08 eb 87 00       	mov    0x87eb08,%eax
  802188:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80218b:	75 10                	jne    80219d <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  80218d:	8b 15 08 eb 87 00    	mov    0x87eb08,%edx
  802193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802196:	01 d0                	add    %edx,%eax
  802198:	a3 08 eb 87 00       	mov    %eax,0x87eb08
	}

	return va;
  80219d:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021a8:	e8 d4 fa ff ff       	call   801c81 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8021ad:	83 ec 08             	sub    $0x8,%esp
  8021b0:	ff 75 0c             	pushl  0xc(%ebp)
  8021b3:	ff 75 08             	pushl  0x8(%ebp)
  8021b6:	e8 aa 03 00 00       	call   802565 <sys_size_of_shared_object>
  8021bb:	83 c4 10             	add    $0x10,%esp
  8021be:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8021c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021c5:	7f 0a                	jg     8021d1 <sget+0x2f>
		return NULL;
  8021c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cc:	e9 32 01 00 00       	jmp    802303 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8021d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8021d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021da:	25 ff 0f 00 00       	and    $0xfff,%eax
  8021df:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8021e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8021e6:	74 0e                	je     8021f6 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8021e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021eb:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8021ee:	05 00 10 00 00       	add    $0x1000,%eax
  8021f3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8021f6:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	75 0a                	jne    802209 <sget+0x67>
		return NULL;
  8021ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802204:	e9 fa 00 00 00       	jmp    802303 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802209:	a1 08 eb 87 00       	mov    0x87eb08,%eax
  80220e:	85 c0                	test   %eax,%eax
  802210:	74 0f                	je     802221 <sget+0x7f>
  802212:	8b 15 08 eb 87 00    	mov    0x87eb08,%edx
  802218:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  80221d:	39 c2                	cmp    %eax,%edx
  80221f:	73 0a                	jae    80222b <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  802221:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  802226:	a3 08 eb 87 00       	mov    %eax,0x87eb08

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80222b:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  802230:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802235:	29 c2                	sub    %eax,%edx
  802237:	89 d0                	mov    %edx,%eax
  802239:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80223c:	8b 15 08 eb 87 00    	mov    0x87eb08,%edx
  802242:	a1 b0 eb 87 00       	mov    0x87ebb0,%eax
  802247:	29 c2                	sub    %eax,%edx
  802249:	89 d0                	mov    %edx,%eax
  80224b:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80224e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802251:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802254:	77 13                	ja     802269 <sget+0xc7>
  802256:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802259:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80225c:	77 0b                	ja     802269 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  80225e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802261:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802264:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802267:	73 0a                	jae    802273 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802269:	b8 00 00 00 00       	mov    $0x0,%eax
  80226e:	e9 90 00 00 00       	jmp    802303 <sget+0x161>

	void *va = NULL;
  802273:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  80227a:	a1 00 eb 87 00       	mov    0x87eb00,%eax
  80227f:	83 f8 05             	cmp    $0x5,%eax
  802282:	75 11                	jne    802295 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802284:	83 ec 0c             	sub    $0xc,%esp
  802287:	ff 75 f4             	pushl  -0xc(%ebp)
  80228a:	e8 a3 f5 ff ff       	call   801832 <alloc_pages_custom_fit>
  80228f:	83 c4 10             	add    $0x10,%esp
  802292:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  802295:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802299:	75 27                	jne    8022c2 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80229b:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8022a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022a5:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8022a8:	89 c2                	mov    %eax,%edx
  8022aa:	a1 08 eb 87 00       	mov    0x87eb08,%eax
  8022af:	39 c2                	cmp    %eax,%edx
  8022b1:	73 07                	jae    8022ba <sget+0x118>
			return NULL;
  8022b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b8:	eb 49                	jmp    802303 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8022ba:	a1 08 eb 87 00       	mov    0x87eb08,%eax
  8022bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8022c2:	83 ec 04             	sub    $0x4,%esp
  8022c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8022c8:	ff 75 0c             	pushl  0xc(%ebp)
  8022cb:	ff 75 08             	pushl  0x8(%ebp)
  8022ce:	e8 af 02 00 00       	call   802582 <sys_get_shared_object>
  8022d3:	83 c4 10             	add    $0x10,%esp
  8022d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8022d9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8022dd:	79 07                	jns    8022e6 <sget+0x144>
		return NULL;
  8022df:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e4:	eb 1d                	jmp    802303 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8022e6:	a1 08 eb 87 00       	mov    0x87eb08,%eax
  8022eb:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8022ee:	75 10                	jne    802300 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8022f0:	8b 15 08 eb 87 00    	mov    0x87eb08,%edx
  8022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f9:	01 d0                	add    %edx,%eax
  8022fb:	a3 08 eb 87 00       	mov    %eax,0x87eb08

	return va;
  802300:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80230b:	e8 71 f9 ff ff       	call   801c81 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802310:	83 ec 04             	sub    $0x4,%esp
  802313:	68 14 45 80 00       	push   $0x804514
  802318:	68 19 02 00 00       	push   $0x219
  80231d:	68 f1 40 80 00       	push   $0x8040f1
  802322:	e8 5c 13 00 00       	call   803683 <_panic>

00802327 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80232d:	83 ec 04             	sub    $0x4,%esp
  802330:	68 3c 45 80 00       	push   $0x80453c
  802335:	68 2b 02 00 00       	push   $0x22b
  80233a:	68 f1 40 80 00       	push   $0x8040f1
  80233f:	e8 3f 13 00 00       	call   803683 <_panic>

00802344 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	57                   	push   %edi
  802348:	56                   	push   %esi
  802349:	53                   	push   %ebx
  80234a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	8b 55 0c             	mov    0xc(%ebp),%edx
  802353:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802356:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802359:	8b 7d 18             	mov    0x18(%ebp),%edi
  80235c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80235f:	cd 30                	int    $0x30
  802361:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802364:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802367:	83 c4 10             	add    $0x10,%esp
  80236a:	5b                   	pop    %ebx
  80236b:	5e                   	pop    %esi
  80236c:	5f                   	pop    %edi
  80236d:	5d                   	pop    %ebp
  80236e:	c3                   	ret    

0080236f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
  802372:	83 ec 04             	sub    $0x4,%esp
  802375:	8b 45 10             	mov    0x10(%ebp),%eax
  802378:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80237b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80237e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	6a 00                	push   $0x0
  802387:	51                   	push   %ecx
  802388:	52                   	push   %edx
  802389:	ff 75 0c             	pushl  0xc(%ebp)
  80238c:	50                   	push   %eax
  80238d:	6a 00                	push   $0x0
  80238f:	e8 b0 ff ff ff       	call   802344 <syscall>
  802394:	83 c4 18             	add    $0x18,%esp
}
  802397:	90                   	nop
  802398:	c9                   	leave  
  802399:	c3                   	ret    

0080239a <sys_cgetc>:

int
sys_cgetc(void)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 02                	push   $0x2
  8023a9:	e8 96 ff ff ff       	call   802344 <syscall>
  8023ae:	83 c4 18             	add    $0x18,%esp
}
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 03                	push   $0x3
  8023c2:	e8 7d ff ff ff       	call   802344 <syscall>
  8023c7:	83 c4 18             	add    $0x18,%esp
}
  8023ca:	90                   	nop
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 04                	push   $0x4
  8023dc:	e8 63 ff ff ff       	call   802344 <syscall>
  8023e1:	83 c4 18             	add    $0x18,%esp
}
  8023e4:	90                   	nop
  8023e5:	c9                   	leave  
  8023e6:	c3                   	ret    

008023e7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8023ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	52                   	push   %edx
  8023f7:	50                   	push   %eax
  8023f8:	6a 08                	push   $0x8
  8023fa:	e8 45 ff ff ff       	call   802344 <syscall>
  8023ff:	83 c4 18             	add    $0x18,%esp
}
  802402:	c9                   	leave  
  802403:	c3                   	ret    

00802404 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
  802407:	56                   	push   %esi
  802408:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802409:	8b 75 18             	mov    0x18(%ebp),%esi
  80240c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80240f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802412:	8b 55 0c             	mov    0xc(%ebp),%edx
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	56                   	push   %esi
  802419:	53                   	push   %ebx
  80241a:	51                   	push   %ecx
  80241b:	52                   	push   %edx
  80241c:	50                   	push   %eax
  80241d:	6a 09                	push   $0x9
  80241f:	e8 20 ff ff ff       	call   802344 <syscall>
  802424:	83 c4 18             	add    $0x18,%esp
}
  802427:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80242a:	5b                   	pop    %ebx
  80242b:	5e                   	pop    %esi
  80242c:	5d                   	pop    %ebp
  80242d:	c3                   	ret    

0080242e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80242e:	55                   	push   %ebp
  80242f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	ff 75 08             	pushl  0x8(%ebp)
  80243c:	6a 0a                	push   $0xa
  80243e:	e8 01 ff ff ff       	call   802344 <syscall>
  802443:	83 c4 18             	add    $0x18,%esp
}
  802446:	c9                   	leave  
  802447:	c3                   	ret    

00802448 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802448:	55                   	push   %ebp
  802449:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	ff 75 0c             	pushl  0xc(%ebp)
  802454:	ff 75 08             	pushl  0x8(%ebp)
  802457:	6a 0b                	push   $0xb
  802459:	e8 e6 fe ff ff       	call   802344 <syscall>
  80245e:	83 c4 18             	add    $0x18,%esp
}
  802461:	c9                   	leave  
  802462:	c3                   	ret    

00802463 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 0c                	push   $0xc
  802472:	e8 cd fe ff ff       	call   802344 <syscall>
  802477:	83 c4 18             	add    $0x18,%esp
}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 0d                	push   $0xd
  80248b:	e8 b4 fe ff ff       	call   802344 <syscall>
  802490:	83 c4 18             	add    $0x18,%esp
}
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 0e                	push   $0xe
  8024a4:	e8 9b fe ff ff       	call   802344 <syscall>
  8024a9:	83 c4 18             	add    $0x18,%esp
}
  8024ac:	c9                   	leave  
  8024ad:	c3                   	ret    

008024ae <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 0f                	push   $0xf
  8024bd:	e8 82 fe ff ff       	call   802344 <syscall>
  8024c2:	83 c4 18             	add    $0x18,%esp
}
  8024c5:	c9                   	leave  
  8024c6:	c3                   	ret    

008024c7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	ff 75 08             	pushl  0x8(%ebp)
  8024d5:	6a 10                	push   $0x10
  8024d7:	e8 68 fe ff ff       	call   802344 <syscall>
  8024dc:	83 c4 18             	add    $0x18,%esp
}
  8024df:	c9                   	leave  
  8024e0:	c3                   	ret    

008024e1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 11                	push   $0x11
  8024f0:	e8 4f fe ff ff       	call   802344 <syscall>
  8024f5:	83 c4 18             	add    $0x18,%esp
}
  8024f8:	90                   	nop
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <sys_cputc>:

void
sys_cputc(const char c)
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
  8024fe:	83 ec 04             	sub    $0x4,%esp
  802501:	8b 45 08             	mov    0x8(%ebp),%eax
  802504:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802507:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80250b:	6a 00                	push   $0x0
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	50                   	push   %eax
  802514:	6a 01                	push   $0x1
  802516:	e8 29 fe ff ff       	call   802344 <syscall>
  80251b:	83 c4 18             	add    $0x18,%esp
}
  80251e:	90                   	nop
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 14                	push   $0x14
  802530:	e8 0f fe ff ff       	call   802344 <syscall>
  802535:	83 c4 18             	add    $0x18,%esp
}
  802538:	90                   	nop
  802539:	c9                   	leave  
  80253a:	c3                   	ret    

0080253b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
  80253e:	83 ec 04             	sub    $0x4,%esp
  802541:	8b 45 10             	mov    0x10(%ebp),%eax
  802544:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802547:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80254a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80254e:	8b 45 08             	mov    0x8(%ebp),%eax
  802551:	6a 00                	push   $0x0
  802553:	51                   	push   %ecx
  802554:	52                   	push   %edx
  802555:	ff 75 0c             	pushl  0xc(%ebp)
  802558:	50                   	push   %eax
  802559:	6a 15                	push   $0x15
  80255b:	e8 e4 fd ff ff       	call   802344 <syscall>
  802560:	83 c4 18             	add    $0x18,%esp
}
  802563:	c9                   	leave  
  802564:	c3                   	ret    

00802565 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80256b:	8b 45 08             	mov    0x8(%ebp),%eax
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	52                   	push   %edx
  802575:	50                   	push   %eax
  802576:	6a 16                	push   $0x16
  802578:	e8 c7 fd ff ff       	call   802344 <syscall>
  80257d:	83 c4 18             	add    $0x18,%esp
}
  802580:	c9                   	leave  
  802581:	c3                   	ret    

00802582 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802582:	55                   	push   %ebp
  802583:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802585:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	51                   	push   %ecx
  802593:	52                   	push   %edx
  802594:	50                   	push   %eax
  802595:	6a 17                	push   $0x17
  802597:	e8 a8 fd ff ff       	call   802344 <syscall>
  80259c:	83 c4 18             	add    $0x18,%esp
}
  80259f:	c9                   	leave  
  8025a0:	c3                   	ret    

008025a1 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8025a1:	55                   	push   %ebp
  8025a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8025a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	52                   	push   %edx
  8025b1:	50                   	push   %eax
  8025b2:	6a 18                	push   $0x18
  8025b4:	e8 8b fd ff ff       	call   802344 <syscall>
  8025b9:	83 c4 18             	add    $0x18,%esp
}
  8025bc:	c9                   	leave  
  8025bd:	c3                   	ret    

008025be <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8025be:	55                   	push   %ebp
  8025bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	6a 00                	push   $0x0
  8025c6:	ff 75 14             	pushl  0x14(%ebp)
  8025c9:	ff 75 10             	pushl  0x10(%ebp)
  8025cc:	ff 75 0c             	pushl  0xc(%ebp)
  8025cf:	50                   	push   %eax
  8025d0:	6a 19                	push   $0x19
  8025d2:	e8 6d fd ff ff       	call   802344 <syscall>
  8025d7:	83 c4 18             	add    $0x18,%esp
}
  8025da:	c9                   	leave  
  8025db:	c3                   	ret    

008025dc <sys_run_env>:

void sys_run_env(int32 envId)
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025df:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	50                   	push   %eax
  8025eb:	6a 1a                	push   $0x1a
  8025ed:	e8 52 fd ff ff       	call   802344 <syscall>
  8025f2:	83 c4 18             	add    $0x18,%esp
}
  8025f5:	90                   	nop
  8025f6:	c9                   	leave  
  8025f7:	c3                   	ret    

008025f8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	50                   	push   %eax
  802607:	6a 1b                	push   $0x1b
  802609:	e8 36 fd ff ff       	call   802344 <syscall>
  80260e:	83 c4 18             	add    $0x18,%esp
}
  802611:	c9                   	leave  
  802612:	c3                   	ret    

00802613 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 05                	push   $0x5
  802622:	e8 1d fd ff ff       	call   802344 <syscall>
  802627:	83 c4 18             	add    $0x18,%esp
}
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80262f:	6a 00                	push   $0x0
  802631:	6a 00                	push   $0x0
  802633:	6a 00                	push   $0x0
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 06                	push   $0x6
  80263b:	e8 04 fd ff ff       	call   802344 <syscall>
  802640:	83 c4 18             	add    $0x18,%esp
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 07                	push   $0x7
  802654:	e8 eb fc ff ff       	call   802344 <syscall>
  802659:	83 c4 18             	add    $0x18,%esp
}
  80265c:	c9                   	leave  
  80265d:	c3                   	ret    

0080265e <sys_exit_env>:


void sys_exit_env(void)
{
  80265e:	55                   	push   %ebp
  80265f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 1c                	push   $0x1c
  80266d:	e8 d2 fc ff ff       	call   802344 <syscall>
  802672:	83 c4 18             	add    $0x18,%esp
}
  802675:	90                   	nop
  802676:	c9                   	leave  
  802677:	c3                   	ret    

00802678 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
  80267b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80267e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802681:	8d 50 04             	lea    0x4(%eax),%edx
  802684:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802687:	6a 00                	push   $0x0
  802689:	6a 00                	push   $0x0
  80268b:	6a 00                	push   $0x0
  80268d:	52                   	push   %edx
  80268e:	50                   	push   %eax
  80268f:	6a 1d                	push   $0x1d
  802691:	e8 ae fc ff ff       	call   802344 <syscall>
  802696:	83 c4 18             	add    $0x18,%esp
	return result;
  802699:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80269c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80269f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026a2:	89 01                	mov    %eax,(%ecx)
  8026a4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8026a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026aa:	c9                   	leave  
  8026ab:	c2 04 00             	ret    $0x4

008026ae <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8026ae:	55                   	push   %ebp
  8026af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	ff 75 10             	pushl  0x10(%ebp)
  8026b8:	ff 75 0c             	pushl  0xc(%ebp)
  8026bb:	ff 75 08             	pushl  0x8(%ebp)
  8026be:	6a 13                	push   $0x13
  8026c0:	e8 7f fc ff ff       	call   802344 <syscall>
  8026c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8026c8:	90                   	nop
}
  8026c9:	c9                   	leave  
  8026ca:	c3                   	ret    

008026cb <sys_rcr2>:
uint32 sys_rcr2()
{
  8026cb:	55                   	push   %ebp
  8026cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8026ce:	6a 00                	push   $0x0
  8026d0:	6a 00                	push   $0x0
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 1e                	push   $0x1e
  8026da:	e8 65 fc ff ff       	call   802344 <syscall>
  8026df:	83 c4 18             	add    $0x18,%esp
}
  8026e2:	c9                   	leave  
  8026e3:	c3                   	ret    

008026e4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
  8026e7:	83 ec 04             	sub    $0x4,%esp
  8026ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026f0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	6a 00                	push   $0x0
  8026fa:	6a 00                	push   $0x0
  8026fc:	50                   	push   %eax
  8026fd:	6a 1f                	push   $0x1f
  8026ff:	e8 40 fc ff ff       	call   802344 <syscall>
  802704:	83 c4 18             	add    $0x18,%esp
	return ;
  802707:	90                   	nop
}
  802708:	c9                   	leave  
  802709:	c3                   	ret    

0080270a <rsttst>:
void rsttst()
{
  80270a:	55                   	push   %ebp
  80270b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	6a 00                	push   $0x0
  802715:	6a 00                	push   $0x0
  802717:	6a 21                	push   $0x21
  802719:	e8 26 fc ff ff       	call   802344 <syscall>
  80271e:	83 c4 18             	add    $0x18,%esp
	return ;
  802721:	90                   	nop
}
  802722:	c9                   	leave  
  802723:	c3                   	ret    

00802724 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
  802727:	83 ec 04             	sub    $0x4,%esp
  80272a:	8b 45 14             	mov    0x14(%ebp),%eax
  80272d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802730:	8b 55 18             	mov    0x18(%ebp),%edx
  802733:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802737:	52                   	push   %edx
  802738:	50                   	push   %eax
  802739:	ff 75 10             	pushl  0x10(%ebp)
  80273c:	ff 75 0c             	pushl  0xc(%ebp)
  80273f:	ff 75 08             	pushl  0x8(%ebp)
  802742:	6a 20                	push   $0x20
  802744:	e8 fb fb ff ff       	call   802344 <syscall>
  802749:	83 c4 18             	add    $0x18,%esp
	return ;
  80274c:	90                   	nop
}
  80274d:	c9                   	leave  
  80274e:	c3                   	ret    

0080274f <chktst>:
void chktst(uint32 n)
{
  80274f:	55                   	push   %ebp
  802750:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	ff 75 08             	pushl  0x8(%ebp)
  80275d:	6a 22                	push   $0x22
  80275f:	e8 e0 fb ff ff       	call   802344 <syscall>
  802764:	83 c4 18             	add    $0x18,%esp
	return ;
  802767:	90                   	nop
}
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <inctst>:

void inctst()
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	6a 00                	push   $0x0
  802777:	6a 23                	push   $0x23
  802779:	e8 c6 fb ff ff       	call   802344 <syscall>
  80277e:	83 c4 18             	add    $0x18,%esp
	return ;
  802781:	90                   	nop
}
  802782:	c9                   	leave  
  802783:	c3                   	ret    

00802784 <gettst>:
uint32 gettst()
{
  802784:	55                   	push   %ebp
  802785:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	6a 24                	push   $0x24
  802793:	e8 ac fb ff ff       	call   802344 <syscall>
  802798:	83 c4 18             	add    $0x18,%esp
}
  80279b:	c9                   	leave  
  80279c:	c3                   	ret    

0080279d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80279d:	55                   	push   %ebp
  80279e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 00                	push   $0x0
  8027a8:	6a 00                	push   $0x0
  8027aa:	6a 25                	push   $0x25
  8027ac:	e8 93 fb ff ff       	call   802344 <syscall>
  8027b1:	83 c4 18             	add    $0x18,%esp
  8027b4:	a3 00 eb 87 00       	mov    %eax,0x87eb00
	return uheapPlaceStrategy ;
  8027b9:	a1 00 eb 87 00       	mov    0x87eb00,%eax
}
  8027be:	c9                   	leave  
  8027bf:	c3                   	ret    

008027c0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8027c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c6:	a3 00 eb 87 00       	mov    %eax,0x87eb00
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027cb:	6a 00                	push   $0x0
  8027cd:	6a 00                	push   $0x0
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 00                	push   $0x0
  8027d3:	ff 75 08             	pushl  0x8(%ebp)
  8027d6:	6a 26                	push   $0x26
  8027d8:	e8 67 fb ff ff       	call   802344 <syscall>
  8027dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8027e0:	90                   	nop
}
  8027e1:	c9                   	leave  
  8027e2:	c3                   	ret    

008027e3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027e3:	55                   	push   %ebp
  8027e4:	89 e5                	mov    %esp,%ebp
  8027e6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8027e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f3:	6a 00                	push   $0x0
  8027f5:	53                   	push   %ebx
  8027f6:	51                   	push   %ecx
  8027f7:	52                   	push   %edx
  8027f8:	50                   	push   %eax
  8027f9:	6a 27                	push   $0x27
  8027fb:	e8 44 fb ff ff       	call   802344 <syscall>
  802800:	83 c4 18             	add    $0x18,%esp
}
  802803:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802806:	c9                   	leave  
  802807:	c3                   	ret    

00802808 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802808:	55                   	push   %ebp
  802809:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80280b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80280e:	8b 45 08             	mov    0x8(%ebp),%eax
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	52                   	push   %edx
  802818:	50                   	push   %eax
  802819:	6a 28                	push   $0x28
  80281b:	e8 24 fb ff ff       	call   802344 <syscall>
  802820:	83 c4 18             	add    $0x18,%esp
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802828:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80282b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80282e:	8b 45 08             	mov    0x8(%ebp),%eax
  802831:	6a 00                	push   $0x0
  802833:	51                   	push   %ecx
  802834:	ff 75 10             	pushl  0x10(%ebp)
  802837:	52                   	push   %edx
  802838:	50                   	push   %eax
  802839:	6a 29                	push   $0x29
  80283b:	e8 04 fb ff ff       	call   802344 <syscall>
  802840:	83 c4 18             	add    $0x18,%esp
}
  802843:	c9                   	leave  
  802844:	c3                   	ret    

00802845 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802845:	55                   	push   %ebp
  802846:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802848:	6a 00                	push   $0x0
  80284a:	6a 00                	push   $0x0
  80284c:	ff 75 10             	pushl  0x10(%ebp)
  80284f:	ff 75 0c             	pushl  0xc(%ebp)
  802852:	ff 75 08             	pushl  0x8(%ebp)
  802855:	6a 12                	push   $0x12
  802857:	e8 e8 fa ff ff       	call   802344 <syscall>
  80285c:	83 c4 18             	add    $0x18,%esp
	return ;
  80285f:	90                   	nop
}
  802860:	c9                   	leave  
  802861:	c3                   	ret    

00802862 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802865:	8b 55 0c             	mov    0xc(%ebp),%edx
  802868:	8b 45 08             	mov    0x8(%ebp),%eax
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	52                   	push   %edx
  802872:	50                   	push   %eax
  802873:	6a 2a                	push   $0x2a
  802875:	e8 ca fa ff ff       	call   802344 <syscall>
  80287a:	83 c4 18             	add    $0x18,%esp
	return;
  80287d:	90                   	nop
}
  80287e:	c9                   	leave  
  80287f:	c3                   	ret    

00802880 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802883:	6a 00                	push   $0x0
  802885:	6a 00                	push   $0x0
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	6a 2b                	push   $0x2b
  80288f:	e8 b0 fa ff ff       	call   802344 <syscall>
  802894:	83 c4 18             	add    $0x18,%esp
}
  802897:	c9                   	leave  
  802898:	c3                   	ret    

00802899 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802899:	55                   	push   %ebp
  80289a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	ff 75 0c             	pushl  0xc(%ebp)
  8028a5:	ff 75 08             	pushl  0x8(%ebp)
  8028a8:	6a 2d                	push   $0x2d
  8028aa:	e8 95 fa ff ff       	call   802344 <syscall>
  8028af:	83 c4 18             	add    $0x18,%esp
	return;
  8028b2:	90                   	nop
}
  8028b3:	c9                   	leave  
  8028b4:	c3                   	ret    

008028b5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8028b5:	55                   	push   %ebp
  8028b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	ff 75 0c             	pushl  0xc(%ebp)
  8028c1:	ff 75 08             	pushl  0x8(%ebp)
  8028c4:	6a 2c                	push   $0x2c
  8028c6:	e8 79 fa ff ff       	call   802344 <syscall>
  8028cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8028ce:	90                   	nop
}
  8028cf:	c9                   	leave  
  8028d0:	c3                   	ret    

008028d1 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8028d1:	55                   	push   %ebp
  8028d2:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8028d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028da:	6a 00                	push   $0x0
  8028dc:	6a 00                	push   $0x0
  8028de:	6a 00                	push   $0x0
  8028e0:	52                   	push   %edx
  8028e1:	50                   	push   %eax
  8028e2:	6a 2e                	push   $0x2e
  8028e4:	e8 5b fa ff ff       	call   802344 <syscall>
  8028e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8028ec:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  8028ed:	c9                   	leave  
  8028ee:	c3                   	ret    

008028ef <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8028ef:	55                   	push   %ebp
  8028f0:	89 e5                	mov    %esp,%ebp
  8028f2:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8028f5:	81 7d 08 00 6b 86 00 	cmpl   $0x866b00,0x8(%ebp)
  8028fc:	72 09                	jb     802907 <to_page_va+0x18>
  8028fe:	81 7d 08 00 eb 87 00 	cmpl   $0x87eb00,0x8(%ebp)
  802905:	72 14                	jb     80291b <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802907:	83 ec 04             	sub    $0x4,%esp
  80290a:	68 60 45 80 00       	push   $0x804560
  80290f:	6a 15                	push   $0x15
  802911:	68 8b 45 80 00       	push   $0x80458b
  802916:	e8 68 0d 00 00       	call   803683 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	ba 00 6b 86 00       	mov    $0x866b00,%edx
  802923:	29 d0                	sub    %edx,%eax
  802925:	c1 f8 02             	sar    $0x2,%eax
  802928:	89 c2                	mov    %eax,%edx
  80292a:	89 d0                	mov    %edx,%eax
  80292c:	c1 e0 02             	shl    $0x2,%eax
  80292f:	01 d0                	add    %edx,%eax
  802931:	c1 e0 02             	shl    $0x2,%eax
  802934:	01 d0                	add    %edx,%eax
  802936:	c1 e0 02             	shl    $0x2,%eax
  802939:	01 d0                	add    %edx,%eax
  80293b:	89 c1                	mov    %eax,%ecx
  80293d:	c1 e1 08             	shl    $0x8,%ecx
  802940:	01 c8                	add    %ecx,%eax
  802942:	89 c1                	mov    %eax,%ecx
  802944:	c1 e1 10             	shl    $0x10,%ecx
  802947:	01 c8                	add    %ecx,%eax
  802949:	01 c0                	add    %eax,%eax
  80294b:	01 d0                	add    %edx,%eax
  80294d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	c1 e0 0c             	shl    $0xc,%eax
  802956:	89 c2                	mov    %eax,%edx
  802958:	a1 04 eb 87 00       	mov    0x87eb04,%eax
  80295d:	01 d0                	add    %edx,%eax
}
  80295f:	c9                   	leave  
  802960:	c3                   	ret    

00802961 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802961:	55                   	push   %ebp
  802962:	89 e5                	mov    %esp,%ebp
  802964:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802967:	a1 04 eb 87 00       	mov    0x87eb04,%eax
  80296c:	8b 55 08             	mov    0x8(%ebp),%edx
  80296f:	29 c2                	sub    %eax,%edx
  802971:	89 d0                	mov    %edx,%eax
  802973:	c1 e8 0c             	shr    $0xc,%eax
  802976:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802979:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297d:	78 09                	js     802988 <to_page_info+0x27>
  80297f:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802986:	7e 14                	jle    80299c <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802988:	83 ec 04             	sub    $0x4,%esp
  80298b:	68 a4 45 80 00       	push   $0x8045a4
  802990:	6a 22                	push   $0x22
  802992:	68 8b 45 80 00       	push   $0x80458b
  802997:	e8 e7 0c 00 00       	call   803683 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80299c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80299f:	89 d0                	mov    %edx,%eax
  8029a1:	01 c0                	add    %eax,%eax
  8029a3:	01 d0                	add    %edx,%eax
  8029a5:	c1 e0 02             	shl    $0x2,%eax
  8029a8:	05 00 6b 86 00       	add    $0x866b00,%eax
}
  8029ad:	c9                   	leave  
  8029ae:	c3                   	ret    

008029af <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8029af:	55                   	push   %ebp
  8029b0:	89 e5                	mov    %esp,%ebp
  8029b2:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8029b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b8:	05 00 00 00 02       	add    $0x2000000,%eax
  8029bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029c0:	73 16                	jae    8029d8 <initialize_dynamic_allocator+0x29>
  8029c2:	68 c8 45 80 00       	push   $0x8045c8
  8029c7:	68 ee 45 80 00       	push   $0x8045ee
  8029cc:	6a 34                	push   $0x34
  8029ce:	68 8b 45 80 00       	push   $0x80458b
  8029d3:	e8 ab 0c 00 00       	call   803683 <_panic>
		is_initialized = 1;
  8029d8:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  8029df:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	a3 04 eb 87 00       	mov    %eax,0x87eb04
	dynAllocEnd = daEnd;
  8029ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029ed:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  8029f2:	c7 05 e4 6a 86 00 00 	movl   $0x0,0x866ae4
  8029f9:	00 00 00 
  8029fc:	c7 05 e8 6a 86 00 00 	movl   $0x0,0x866ae8
  802a03:	00 00 00 
  802a06:	c7 05 f0 6a 86 00 00 	movl   $0x0,0x866af0
  802a0d:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802a10:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802a17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a1e:	eb 36                	jmp    802a56 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	c1 e0 04             	shl    $0x4,%eax
  802a26:	05 20 eb 87 00       	add    $0x87eb20,%eax
  802a2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	c1 e0 04             	shl    $0x4,%eax
  802a37:	05 24 eb 87 00       	add    $0x87eb24,%eax
  802a3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	c1 e0 04             	shl    $0x4,%eax
  802a48:	05 2c eb 87 00       	add    $0x87eb2c,%eax
  802a4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802a53:	ff 45 f4             	incl   -0xc(%ebp)
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a5c:	72 c2                	jb     802a20 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802a5e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a64:	a1 04 eb 87 00       	mov    0x87eb04,%eax
  802a69:	29 c2                	sub    %eax,%edx
  802a6b:	89 d0                	mov    %edx,%eax
  802a6d:	c1 e8 0c             	shr    $0xc,%eax
  802a70:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802a73:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802a7a:	e9 c8 00 00 00       	jmp    802b47 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802a7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a82:	89 d0                	mov    %edx,%eax
  802a84:	01 c0                	add    %eax,%eax
  802a86:	01 d0                	add    %edx,%eax
  802a88:	c1 e0 02             	shl    $0x2,%eax
  802a8b:	05 08 6b 86 00       	add    $0x866b08,%eax
  802a90:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802a95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a98:	89 d0                	mov    %edx,%eax
  802a9a:	01 c0                	add    %eax,%eax
  802a9c:	01 d0                	add    %edx,%eax
  802a9e:	c1 e0 02             	shl    $0x2,%eax
  802aa1:	05 0a 6b 86 00       	add    $0x866b0a,%eax
  802aa6:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802aab:	8b 15 e8 6a 86 00    	mov    0x866ae8,%edx
  802ab1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ab4:	89 c8                	mov    %ecx,%eax
  802ab6:	01 c0                	add    %eax,%eax
  802ab8:	01 c8                	add    %ecx,%eax
  802aba:	c1 e0 02             	shl    $0x2,%eax
  802abd:	05 04 6b 86 00       	add    $0x866b04,%eax
  802ac2:	89 10                	mov    %edx,(%eax)
  802ac4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ac7:	89 d0                	mov    %edx,%eax
  802ac9:	01 c0                	add    %eax,%eax
  802acb:	01 d0                	add    %edx,%eax
  802acd:	c1 e0 02             	shl    $0x2,%eax
  802ad0:	05 04 6b 86 00       	add    $0x866b04,%eax
  802ad5:	8b 00                	mov    (%eax),%eax
  802ad7:	85 c0                	test   %eax,%eax
  802ad9:	74 1b                	je     802af6 <initialize_dynamic_allocator+0x147>
  802adb:	8b 15 e8 6a 86 00    	mov    0x866ae8,%edx
  802ae1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ae4:	89 c8                	mov    %ecx,%eax
  802ae6:	01 c0                	add    %eax,%eax
  802ae8:	01 c8                	add    %ecx,%eax
  802aea:	c1 e0 02             	shl    $0x2,%eax
  802aed:	05 00 6b 86 00       	add    $0x866b00,%eax
  802af2:	89 02                	mov    %eax,(%edx)
  802af4:	eb 16                	jmp    802b0c <initialize_dynamic_allocator+0x15d>
  802af6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af9:	89 d0                	mov    %edx,%eax
  802afb:	01 c0                	add    %eax,%eax
  802afd:	01 d0                	add    %edx,%eax
  802aff:	c1 e0 02             	shl    $0x2,%eax
  802b02:	05 00 6b 86 00       	add    $0x866b00,%eax
  802b07:	a3 e4 6a 86 00       	mov    %eax,0x866ae4
  802b0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b0f:	89 d0                	mov    %edx,%eax
  802b11:	01 c0                	add    %eax,%eax
  802b13:	01 d0                	add    %edx,%eax
  802b15:	c1 e0 02             	shl    $0x2,%eax
  802b18:	05 00 6b 86 00       	add    $0x866b00,%eax
  802b1d:	a3 e8 6a 86 00       	mov    %eax,0x866ae8
  802b22:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b25:	89 d0                	mov    %edx,%eax
  802b27:	01 c0                	add    %eax,%eax
  802b29:	01 d0                	add    %edx,%eax
  802b2b:	c1 e0 02             	shl    $0x2,%eax
  802b2e:	05 00 6b 86 00       	add    $0x866b00,%eax
  802b33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b39:	a1 f0 6a 86 00       	mov    0x866af0,%eax
  802b3e:	40                   	inc    %eax
  802b3f:	a3 f0 6a 86 00       	mov    %eax,0x866af0
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802b44:	ff 45 f0             	incl   -0x10(%ebp)
  802b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802b4d:	0f 82 2c ff ff ff    	jb     802a7f <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802b53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b59:	eb 2f                	jmp    802b8a <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802b5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b5e:	89 d0                	mov    %edx,%eax
  802b60:	01 c0                	add    %eax,%eax
  802b62:	01 d0                	add    %edx,%eax
  802b64:	c1 e0 02             	shl    $0x2,%eax
  802b67:	05 08 6b 86 00       	add    $0x866b08,%eax
  802b6c:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802b71:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b74:	89 d0                	mov    %edx,%eax
  802b76:	01 c0                	add    %eax,%eax
  802b78:	01 d0                	add    %edx,%eax
  802b7a:	c1 e0 02             	shl    $0x2,%eax
  802b7d:	05 0a 6b 86 00       	add    $0x866b0a,%eax
  802b82:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802b87:	ff 45 ec             	incl   -0x14(%ebp)
  802b8a:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802b91:	76 c8                	jbe    802b5b <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802b93:	90                   	nop
  802b94:	c9                   	leave  
  802b95:	c3                   	ret    

00802b96 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802b96:	55                   	push   %ebp
  802b97:	89 e5                	mov    %esp,%ebp
  802b99:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802b9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9f:	a1 04 eb 87 00       	mov    0x87eb04,%eax
  802ba4:	29 c2                	sub    %eax,%edx
  802ba6:	89 d0                	mov    %edx,%eax
  802ba8:	c1 e8 0c             	shr    $0xc,%eax
  802bab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802bae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802bb1:	89 d0                	mov    %edx,%eax
  802bb3:	01 c0                	add    %eax,%eax
  802bb5:	01 d0                	add    %edx,%eax
  802bb7:	c1 e0 02             	shl    $0x2,%eax
  802bba:	05 08 6b 86 00       	add    $0x866b08,%eax
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802bc4:	c9                   	leave  
  802bc5:	c3                   	ret    

00802bc6 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802bc6:	55                   	push   %ebp
  802bc7:	89 e5                	mov    %esp,%ebp
  802bc9:	83 ec 14             	sub    $0x14,%esp
  802bcc:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802bcf:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802bd3:	77 07                	ja     802bdc <nearest_pow2_ceil.1513+0x16>
  802bd5:	b8 01 00 00 00       	mov    $0x1,%eax
  802bda:	eb 20                	jmp    802bfc <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802bdc:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802be3:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802be6:	eb 08                	jmp    802bf0 <nearest_pow2_ceil.1513+0x2a>
  802be8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802beb:	01 c0                	add    %eax,%eax
  802bed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802bf0:	d1 6d 08             	shrl   0x8(%ebp)
  802bf3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf7:	75 ef                	jne    802be8 <nearest_pow2_ceil.1513+0x22>
        return power;
  802bf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802bfc:	c9                   	leave  
  802bfd:	c3                   	ret    

00802bfe <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802bfe:	55                   	push   %ebp
  802bff:	89 e5                	mov    %esp,%ebp
  802c01:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802c04:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802c0b:	76 16                	jbe    802c23 <alloc_block+0x25>
  802c0d:	68 04 46 80 00       	push   $0x804604
  802c12:	68 ee 45 80 00       	push   $0x8045ee
  802c17:	6a 72                	push   $0x72
  802c19:	68 8b 45 80 00       	push   $0x80458b
  802c1e:	e8 60 0a 00 00       	call   803683 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802c23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c27:	75 0a                	jne    802c33 <alloc_block+0x35>
  802c29:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2e:	e9 bd 04 00 00       	jmp    8030f0 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802c33:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802c40:	73 06                	jae    802c48 <alloc_block+0x4a>
        size = min_block_size;
  802c42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c45:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802c48:	83 ec 0c             	sub    $0xc,%esp
  802c4b:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802c4e:	ff 75 08             	pushl  0x8(%ebp)
  802c51:	89 c1                	mov    %eax,%ecx
  802c53:	e8 6e ff ff ff       	call   802bc6 <nearest_pow2_ceil.1513>
  802c58:	83 c4 10             	add    $0x10,%esp
  802c5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802c5e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c61:	83 ec 0c             	sub    $0xc,%esp
  802c64:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802c67:	52                   	push   %edx
  802c68:	89 c1                	mov    %eax,%ecx
  802c6a:	e8 83 04 00 00       	call   8030f2 <log2_ceil.1520>
  802c6f:	83 c4 10             	add    $0x10,%esp
  802c72:	83 e8 03             	sub    $0x3,%eax
  802c75:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802c78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7b:	c1 e0 04             	shl    $0x4,%eax
  802c7e:	05 20 eb 87 00       	add    $0x87eb20,%eax
  802c83:	8b 00                	mov    (%eax),%eax
  802c85:	85 c0                	test   %eax,%eax
  802c87:	0f 84 d8 00 00 00    	je     802d65 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c90:	c1 e0 04             	shl    $0x4,%eax
  802c93:	05 20 eb 87 00       	add    $0x87eb20,%eax
  802c98:	8b 00                	mov    (%eax),%eax
  802c9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802c9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ca1:	75 17                	jne    802cba <alloc_block+0xbc>
  802ca3:	83 ec 04             	sub    $0x4,%esp
  802ca6:	68 25 46 80 00       	push   $0x804625
  802cab:	68 98 00 00 00       	push   $0x98
  802cb0:	68 8b 45 80 00       	push   $0x80458b
  802cb5:	e8 c9 09 00 00       	call   803683 <_panic>
  802cba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cbd:	8b 00                	mov    (%eax),%eax
  802cbf:	85 c0                	test   %eax,%eax
  802cc1:	74 10                	je     802cd3 <alloc_block+0xd5>
  802cc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc6:	8b 00                	mov    (%eax),%eax
  802cc8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ccb:	8b 52 04             	mov    0x4(%edx),%edx
  802cce:	89 50 04             	mov    %edx,0x4(%eax)
  802cd1:	eb 14                	jmp    802ce7 <alloc_block+0xe9>
  802cd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd6:	8b 40 04             	mov    0x4(%eax),%eax
  802cd9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cdc:	c1 e2 04             	shl    $0x4,%edx
  802cdf:	81 c2 24 eb 87 00    	add    $0x87eb24,%edx
  802ce5:	89 02                	mov    %eax,(%edx)
  802ce7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cea:	8b 40 04             	mov    0x4(%eax),%eax
  802ced:	85 c0                	test   %eax,%eax
  802cef:	74 0f                	je     802d00 <alloc_block+0x102>
  802cf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cf4:	8b 40 04             	mov    0x4(%eax),%eax
  802cf7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cfa:	8b 12                	mov    (%edx),%edx
  802cfc:	89 10                	mov    %edx,(%eax)
  802cfe:	eb 13                	jmp    802d13 <alloc_block+0x115>
  802d00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d03:	8b 00                	mov    (%eax),%eax
  802d05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d08:	c1 e2 04             	shl    $0x4,%edx
  802d0b:	81 c2 20 eb 87 00    	add    $0x87eb20,%edx
  802d11:	89 02                	mov    %eax,(%edx)
  802d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d29:	c1 e0 04             	shl    $0x4,%eax
  802d2c:	05 2c eb 87 00       	add    $0x87eb2c,%eax
  802d31:	8b 00                	mov    (%eax),%eax
  802d33:	8d 50 ff             	lea    -0x1(%eax),%edx
  802d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d39:	c1 e0 04             	shl    $0x4,%eax
  802d3c:	05 2c eb 87 00       	add    $0x87eb2c,%eax
  802d41:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802d43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d46:	83 ec 0c             	sub    $0xc,%esp
  802d49:	50                   	push   %eax
  802d4a:	e8 12 fc ff ff       	call   802961 <to_page_info>
  802d4f:	83 c4 10             	add    $0x10,%esp
  802d52:	89 c2                	mov    %eax,%edx
  802d54:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802d58:	48                   	dec    %eax
  802d59:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802d5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d60:	e9 8b 03 00 00       	jmp    8030f0 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802d65:	a1 e4 6a 86 00       	mov    0x866ae4,%eax
  802d6a:	85 c0                	test   %eax,%eax
  802d6c:	0f 84 64 02 00 00    	je     802fd6 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802d72:	a1 e4 6a 86 00       	mov    0x866ae4,%eax
  802d77:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802d7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d7e:	75 17                	jne    802d97 <alloc_block+0x199>
  802d80:	83 ec 04             	sub    $0x4,%esp
  802d83:	68 25 46 80 00       	push   $0x804625
  802d88:	68 a0 00 00 00       	push   $0xa0
  802d8d:	68 8b 45 80 00       	push   $0x80458b
  802d92:	e8 ec 08 00 00       	call   803683 <_panic>
  802d97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d9a:	8b 00                	mov    (%eax),%eax
  802d9c:	85 c0                	test   %eax,%eax
  802d9e:	74 10                	je     802db0 <alloc_block+0x1b2>
  802da0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da3:	8b 00                	mov    (%eax),%eax
  802da5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802da8:	8b 52 04             	mov    0x4(%edx),%edx
  802dab:	89 50 04             	mov    %edx,0x4(%eax)
  802dae:	eb 0b                	jmp    802dbb <alloc_block+0x1bd>
  802db0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db3:	8b 40 04             	mov    0x4(%eax),%eax
  802db6:	a3 e8 6a 86 00       	mov    %eax,0x866ae8
  802dbb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dbe:	8b 40 04             	mov    0x4(%eax),%eax
  802dc1:	85 c0                	test   %eax,%eax
  802dc3:	74 0f                	je     802dd4 <alloc_block+0x1d6>
  802dc5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc8:	8b 40 04             	mov    0x4(%eax),%eax
  802dcb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dce:	8b 12                	mov    (%edx),%edx
  802dd0:	89 10                	mov    %edx,(%eax)
  802dd2:	eb 0a                	jmp    802dde <alloc_block+0x1e0>
  802dd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd7:	8b 00                	mov    (%eax),%eax
  802dd9:	a3 e4 6a 86 00       	mov    %eax,0x866ae4
  802dde:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df1:	a1 f0 6a 86 00       	mov    0x866af0,%eax
  802df6:	48                   	dec    %eax
  802df7:	a3 f0 6a 86 00       	mov    %eax,0x866af0

        page_info_e->block_size = pow;
  802dfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e02:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802e06:	b8 00 10 00 00       	mov    $0x1000,%eax
  802e0b:	99                   	cltd   
  802e0c:	f7 7d e8             	idivl  -0x18(%ebp)
  802e0f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e12:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802e16:	83 ec 0c             	sub    $0xc,%esp
  802e19:	ff 75 dc             	pushl  -0x24(%ebp)
  802e1c:	e8 ce fa ff ff       	call   8028ef <to_page_va>
  802e21:	83 c4 10             	add    $0x10,%esp
  802e24:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802e27:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e2a:	83 ec 0c             	sub    $0xc,%esp
  802e2d:	50                   	push   %eax
  802e2e:	e8 c0 ee ff ff       	call   801cf3 <get_page>
  802e33:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802e36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e3d:	e9 aa 00 00 00       	jmp    802eec <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802e49:	89 c2                	mov    %eax,%edx
  802e4b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e4e:	01 d0                	add    %edx,%eax
  802e50:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802e53:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802e57:	75 17                	jne    802e70 <alloc_block+0x272>
  802e59:	83 ec 04             	sub    $0x4,%esp
  802e5c:	68 44 46 80 00       	push   $0x804644
  802e61:	68 aa 00 00 00       	push   $0xaa
  802e66:	68 8b 45 80 00       	push   $0x80458b
  802e6b:	e8 13 08 00 00       	call   803683 <_panic>
  802e70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e73:	c1 e0 04             	shl    $0x4,%eax
  802e76:	05 24 eb 87 00       	add    $0x87eb24,%eax
  802e7b:	8b 10                	mov    (%eax),%edx
  802e7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e80:	89 50 04             	mov    %edx,0x4(%eax)
  802e83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e86:	8b 40 04             	mov    0x4(%eax),%eax
  802e89:	85 c0                	test   %eax,%eax
  802e8b:	74 14                	je     802ea1 <alloc_block+0x2a3>
  802e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e90:	c1 e0 04             	shl    $0x4,%eax
  802e93:	05 24 eb 87 00       	add    $0x87eb24,%eax
  802e98:	8b 00                	mov    (%eax),%eax
  802e9a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e9d:	89 10                	mov    %edx,(%eax)
  802e9f:	eb 11                	jmp    802eb2 <alloc_block+0x2b4>
  802ea1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea4:	c1 e0 04             	shl    $0x4,%eax
  802ea7:	8d 90 20 eb 87 00    	lea    0x87eb20(%eax),%edx
  802ead:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802eb0:	89 02                	mov    %eax,(%edx)
  802eb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb5:	c1 e0 04             	shl    $0x4,%eax
  802eb8:	8d 90 24 eb 87 00    	lea    0x87eb24(%eax),%edx
  802ebe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ec1:	89 02                	mov    %eax,(%edx)
  802ec3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ec6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ecc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ecf:	c1 e0 04             	shl    $0x4,%eax
  802ed2:	05 2c eb 87 00       	add    $0x87eb2c,%eax
  802ed7:	8b 00                	mov    (%eax),%eax
  802ed9:	8d 50 01             	lea    0x1(%eax),%edx
  802edc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802edf:	c1 e0 04             	shl    $0x4,%eax
  802ee2:	05 2c eb 87 00       	add    $0x87eb2c,%eax
  802ee7:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802ee9:	ff 45 f4             	incl   -0xc(%ebp)
  802eec:	b8 00 10 00 00       	mov    $0x1000,%eax
  802ef1:	99                   	cltd   
  802ef2:	f7 7d e8             	idivl  -0x18(%ebp)
  802ef5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802ef8:	0f 8f 44 ff ff ff    	jg     802e42 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802efe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f01:	c1 e0 04             	shl    $0x4,%eax
  802f04:	05 20 eb 87 00       	add    $0x87eb20,%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802f0e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802f12:	75 17                	jne    802f2b <alloc_block+0x32d>
  802f14:	83 ec 04             	sub    $0x4,%esp
  802f17:	68 25 46 80 00       	push   $0x804625
  802f1c:	68 ae 00 00 00       	push   $0xae
  802f21:	68 8b 45 80 00       	push   $0x80458b
  802f26:	e8 58 07 00 00       	call   803683 <_panic>
  802f2b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	85 c0                	test   %eax,%eax
  802f32:	74 10                	je     802f44 <alloc_block+0x346>
  802f34:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f37:	8b 00                	mov    (%eax),%eax
  802f39:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f3c:	8b 52 04             	mov    0x4(%edx),%edx
  802f3f:	89 50 04             	mov    %edx,0x4(%eax)
  802f42:	eb 14                	jmp    802f58 <alloc_block+0x35a>
  802f44:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f47:	8b 40 04             	mov    0x4(%eax),%eax
  802f4a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f4d:	c1 e2 04             	shl    $0x4,%edx
  802f50:	81 c2 24 eb 87 00    	add    $0x87eb24,%edx
  802f56:	89 02                	mov    %eax,(%edx)
  802f58:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f5b:	8b 40 04             	mov    0x4(%eax),%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	74 0f                	je     802f71 <alloc_block+0x373>
  802f62:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f65:	8b 40 04             	mov    0x4(%eax),%eax
  802f68:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f6b:	8b 12                	mov    (%edx),%edx
  802f6d:	89 10                	mov    %edx,(%eax)
  802f6f:	eb 13                	jmp    802f84 <alloc_block+0x386>
  802f71:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f74:	8b 00                	mov    (%eax),%eax
  802f76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f79:	c1 e2 04             	shl    $0x4,%edx
  802f7c:	81 c2 20 eb 87 00    	add    $0x87eb20,%edx
  802f82:	89 02                	mov    %eax,(%edx)
  802f84:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9a:	c1 e0 04             	shl    $0x4,%eax
  802f9d:	05 2c eb 87 00       	add    $0x87eb2c,%eax
  802fa2:	8b 00                	mov    (%eax),%eax
  802fa4:	8d 50 ff             	lea    -0x1(%eax),%edx
  802fa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802faa:	c1 e0 04             	shl    $0x4,%eax
  802fad:	05 2c eb 87 00       	add    $0x87eb2c,%eax
  802fb2:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802fb4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fb7:	83 ec 0c             	sub    $0xc,%esp
  802fba:	50                   	push   %eax
  802fbb:	e8 a1 f9 ff ff       	call   802961 <to_page_info>
  802fc0:	83 c4 10             	add    $0x10,%esp
  802fc3:	89 c2                	mov    %eax,%edx
  802fc5:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802fc9:	48                   	dec    %eax
  802fca:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802fce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fd1:	e9 1a 01 00 00       	jmp    8030f0 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802fd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd9:	40                   	inc    %eax
  802fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802fdd:	e9 ed 00 00 00       	jmp    8030cf <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe5:	c1 e0 04             	shl    $0x4,%eax
  802fe8:	05 20 eb 87 00       	add    $0x87eb20,%eax
  802fed:	8b 00                	mov    (%eax),%eax
  802fef:	85 c0                	test   %eax,%eax
  802ff1:	0f 84 d5 00 00 00    	je     8030cc <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffa:	c1 e0 04             	shl    $0x4,%eax
  802ffd:	05 20 eb 87 00       	add    $0x87eb20,%eax
  803002:	8b 00                	mov    (%eax),%eax
  803004:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  803007:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80300b:	75 17                	jne    803024 <alloc_block+0x426>
  80300d:	83 ec 04             	sub    $0x4,%esp
  803010:	68 25 46 80 00       	push   $0x804625
  803015:	68 b8 00 00 00       	push   $0xb8
  80301a:	68 8b 45 80 00       	push   $0x80458b
  80301f:	e8 5f 06 00 00       	call   803683 <_panic>
  803024:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803027:	8b 00                	mov    (%eax),%eax
  803029:	85 c0                	test   %eax,%eax
  80302b:	74 10                	je     80303d <alloc_block+0x43f>
  80302d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803030:	8b 00                	mov    (%eax),%eax
  803032:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803035:	8b 52 04             	mov    0x4(%edx),%edx
  803038:	89 50 04             	mov    %edx,0x4(%eax)
  80303b:	eb 14                	jmp    803051 <alloc_block+0x453>
  80303d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803040:	8b 40 04             	mov    0x4(%eax),%eax
  803043:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803046:	c1 e2 04             	shl    $0x4,%edx
  803049:	81 c2 24 eb 87 00    	add    $0x87eb24,%edx
  80304f:	89 02                	mov    %eax,(%edx)
  803051:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803054:	8b 40 04             	mov    0x4(%eax),%eax
  803057:	85 c0                	test   %eax,%eax
  803059:	74 0f                	je     80306a <alloc_block+0x46c>
  80305b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80305e:	8b 40 04             	mov    0x4(%eax),%eax
  803061:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803064:	8b 12                	mov    (%edx),%edx
  803066:	89 10                	mov    %edx,(%eax)
  803068:	eb 13                	jmp    80307d <alloc_block+0x47f>
  80306a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803072:	c1 e2 04             	shl    $0x4,%edx
  803075:	81 c2 20 eb 87 00    	add    $0x87eb20,%edx
  80307b:	89 02                	mov    %eax,(%edx)
  80307d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803080:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803086:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803089:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803093:	c1 e0 04             	shl    $0x4,%eax
  803096:	05 2c eb 87 00       	add    $0x87eb2c,%eax
  80309b:	8b 00                	mov    (%eax),%eax
  80309d:	8d 50 ff             	lea    -0x1(%eax),%edx
  8030a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a3:	c1 e0 04             	shl    $0x4,%eax
  8030a6:	05 2c eb 87 00       	add    $0x87eb2c,%eax
  8030ab:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8030ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b0:	83 ec 0c             	sub    $0xc,%esp
  8030b3:	50                   	push   %eax
  8030b4:	e8 a8 f8 ff ff       	call   802961 <to_page_info>
  8030b9:	83 c4 10             	add    $0x10,%esp
  8030bc:	89 c2                	mov    %eax,%edx
  8030be:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8030c2:	48                   	dec    %eax
  8030c3:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  8030c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030ca:	eb 24                	jmp    8030f0 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8030cc:	ff 45 f0             	incl   -0x10(%ebp)
  8030cf:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8030d3:	0f 8e 09 ff ff ff    	jle    802fe2 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8030d9:	83 ec 04             	sub    $0x4,%esp
  8030dc:	68 67 46 80 00       	push   $0x804667
  8030e1:	68 bf 00 00 00       	push   $0xbf
  8030e6:	68 8b 45 80 00       	push   $0x80458b
  8030eb:	e8 93 05 00 00       	call   803683 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8030f0:	c9                   	leave  
  8030f1:	c3                   	ret    

008030f2 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  8030f2:	55                   	push   %ebp
  8030f3:	89 e5                	mov    %esp,%ebp
  8030f5:	83 ec 14             	sub    $0x14,%esp
  8030f8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  8030fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ff:	75 07                	jne    803108 <log2_ceil.1520+0x16>
  803101:	b8 00 00 00 00       	mov    $0x0,%eax
  803106:	eb 1b                	jmp    803123 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  803108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  80310f:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  803112:	eb 06                	jmp    80311a <log2_ceil.1520+0x28>
            x >>= 1;
  803114:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  803117:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  80311a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80311e:	75 f4                	jne    803114 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  803120:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803123:	c9                   	leave  
  803124:	c3                   	ret    

00803125 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  803125:	55                   	push   %ebp
  803126:	89 e5                	mov    %esp,%ebp
  803128:	83 ec 14             	sub    $0x14,%esp
  80312b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  80312e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803132:	75 07                	jne    80313b <log2_ceil.1547+0x16>
  803134:	b8 00 00 00 00       	mov    $0x0,%eax
  803139:	eb 1b                	jmp    803156 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  80313b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803142:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  803145:	eb 06                	jmp    80314d <log2_ceil.1547+0x28>
			x >>= 1;
  803147:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  80314a:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  80314d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803151:	75 f4                	jne    803147 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  803153:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803156:	c9                   	leave  
  803157:	c3                   	ret    

00803158 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803158:	55                   	push   %ebp
  803159:	89 e5                	mov    %esp,%ebp
  80315b:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80315e:	8b 55 08             	mov    0x8(%ebp),%edx
  803161:	a1 04 eb 87 00       	mov    0x87eb04,%eax
  803166:	39 c2                	cmp    %eax,%edx
  803168:	72 0c                	jb     803176 <free_block+0x1e>
  80316a:	8b 55 08             	mov    0x8(%ebp),%edx
  80316d:	a1 40 50 80 00       	mov    0x805040,%eax
  803172:	39 c2                	cmp    %eax,%edx
  803174:	72 19                	jb     80318f <free_block+0x37>
  803176:	68 6c 46 80 00       	push   $0x80466c
  80317b:	68 ee 45 80 00       	push   $0x8045ee
  803180:	68 d0 00 00 00       	push   $0xd0
  803185:	68 8b 45 80 00       	push   $0x80458b
  80318a:	e8 f4 04 00 00       	call   803683 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80318f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803193:	0f 84 42 03 00 00    	je     8034db <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  803199:	8b 55 08             	mov    0x8(%ebp),%edx
  80319c:	a1 04 eb 87 00       	mov    0x87eb04,%eax
  8031a1:	39 c2                	cmp    %eax,%edx
  8031a3:	72 0c                	jb     8031b1 <free_block+0x59>
  8031a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a8:	a1 40 50 80 00       	mov    0x805040,%eax
  8031ad:	39 c2                	cmp    %eax,%edx
  8031af:	72 17                	jb     8031c8 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8031b1:	83 ec 04             	sub    $0x4,%esp
  8031b4:	68 a4 46 80 00       	push   $0x8046a4
  8031b9:	68 e6 00 00 00       	push   $0xe6
  8031be:	68 8b 45 80 00       	push   $0x80458b
  8031c3:	e8 bb 04 00 00       	call   803683 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8031c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8031cb:	a1 04 eb 87 00       	mov    0x87eb04,%eax
  8031d0:	29 c2                	sub    %eax,%edx
  8031d2:	89 d0                	mov    %edx,%eax
  8031d4:	83 e0 07             	and    $0x7,%eax
  8031d7:	85 c0                	test   %eax,%eax
  8031d9:	74 17                	je     8031f2 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8031db:	83 ec 04             	sub    $0x4,%esp
  8031de:	68 d8 46 80 00       	push   $0x8046d8
  8031e3:	68 ea 00 00 00       	push   $0xea
  8031e8:	68 8b 45 80 00       	push   $0x80458b
  8031ed:	e8 91 04 00 00       	call   803683 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f5:	83 ec 0c             	sub    $0xc,%esp
  8031f8:	50                   	push   %eax
  8031f9:	e8 63 f7 ff ff       	call   802961 <to_page_info>
  8031fe:	83 c4 10             	add    $0x10,%esp
  803201:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  803204:	83 ec 0c             	sub    $0xc,%esp
  803207:	ff 75 08             	pushl  0x8(%ebp)
  80320a:	e8 87 f9 ff ff       	call   802b96 <get_block_size>
  80320f:	83 c4 10             	add    $0x10,%esp
  803212:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  803215:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803219:	75 17                	jne    803232 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  80321b:	83 ec 04             	sub    $0x4,%esp
  80321e:	68 04 47 80 00       	push   $0x804704
  803223:	68 f1 00 00 00       	push   $0xf1
  803228:	68 8b 45 80 00       	push   $0x80458b
  80322d:	e8 51 04 00 00       	call   803683 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  803232:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803235:	83 ec 0c             	sub    $0xc,%esp
  803238:	8d 45 d0             	lea    -0x30(%ebp),%eax
  80323b:	52                   	push   %edx
  80323c:	89 c1                	mov    %eax,%ecx
  80323e:	e8 e2 fe ff ff       	call   803125 <log2_ceil.1547>
  803243:	83 c4 10             	add    $0x10,%esp
  803246:	83 e8 03             	sub    $0x3,%eax
  803249:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  803252:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803256:	75 17                	jne    80326f <free_block+0x117>
  803258:	83 ec 04             	sub    $0x4,%esp
  80325b:	68 50 47 80 00       	push   $0x804750
  803260:	68 f6 00 00 00       	push   $0xf6
  803265:	68 8b 45 80 00       	push   $0x80458b
  80326a:	e8 14 04 00 00       	call   803683 <_panic>
  80326f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803272:	c1 e0 04             	shl    $0x4,%eax
  803275:	05 20 eb 87 00       	add    $0x87eb20,%eax
  80327a:	8b 10                	mov    (%eax),%edx
  80327c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80327f:	89 10                	mov    %edx,(%eax)
  803281:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803284:	8b 00                	mov    (%eax),%eax
  803286:	85 c0                	test   %eax,%eax
  803288:	74 15                	je     80329f <free_block+0x147>
  80328a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80328d:	c1 e0 04             	shl    $0x4,%eax
  803290:	05 20 eb 87 00       	add    $0x87eb20,%eax
  803295:	8b 00                	mov    (%eax),%eax
  803297:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80329a:	89 50 04             	mov    %edx,0x4(%eax)
  80329d:	eb 11                	jmp    8032b0 <free_block+0x158>
  80329f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a2:	c1 e0 04             	shl    $0x4,%eax
  8032a5:	8d 90 24 eb 87 00    	lea    0x87eb24(%eax),%edx
  8032ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ae:	89 02                	mov    %eax,(%edx)
  8032b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b3:	c1 e0 04             	shl    $0x4,%eax
  8032b6:	8d 90 20 eb 87 00    	lea    0x87eb20(%eax),%edx
  8032bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032bf:	89 02                	mov    %eax,(%edx)
  8032c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ce:	c1 e0 04             	shl    $0x4,%eax
  8032d1:	05 2c eb 87 00       	add    $0x87eb2c,%eax
  8032d6:	8b 00                	mov    (%eax),%eax
  8032d8:	8d 50 01             	lea    0x1(%eax),%edx
  8032db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032de:	c1 e0 04             	shl    $0x4,%eax
  8032e1:	05 2c eb 87 00       	add    $0x87eb2c,%eax
  8032e6:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8032e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032eb:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8032ef:	40                   	inc    %eax
  8032f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032f3:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8032f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032fa:	a1 04 eb 87 00       	mov    0x87eb04,%eax
  8032ff:	29 c2                	sub    %eax,%edx
  803301:	89 d0                	mov    %edx,%eax
  803303:	c1 e8 0c             	shr    $0xc,%eax
  803306:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  803309:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803310:	0f b7 c8             	movzwl %ax,%ecx
  803313:	b8 00 10 00 00       	mov    $0x1000,%eax
  803318:	99                   	cltd   
  803319:	f7 7d e8             	idivl  -0x18(%ebp)
  80331c:	39 c1                	cmp    %eax,%ecx
  80331e:	0f 85 b8 01 00 00    	jne    8034dc <free_block+0x384>
    	uint32 blocks_removed = 0;
  803324:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  80332b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332e:	c1 e0 04             	shl    $0x4,%eax
  803331:	05 20 eb 87 00       	add    $0x87eb20,%eax
  803336:	8b 00                	mov    (%eax),%eax
  803338:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80333b:	e9 d5 00 00 00       	jmp    803415 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803343:	8b 00                	mov    (%eax),%eax
  803345:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803348:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80334b:	a1 04 eb 87 00       	mov    0x87eb04,%eax
  803350:	29 c2                	sub    %eax,%edx
  803352:	89 d0                	mov    %edx,%eax
  803354:	c1 e8 0c             	shr    $0xc,%eax
  803357:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  80335a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80335d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803360:	0f 85 a9 00 00 00    	jne    80340f <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  803366:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80336a:	75 17                	jne    803383 <free_block+0x22b>
  80336c:	83 ec 04             	sub    $0x4,%esp
  80336f:	68 25 46 80 00       	push   $0x804625
  803374:	68 04 01 00 00       	push   $0x104
  803379:	68 8b 45 80 00       	push   $0x80458b
  80337e:	e8 00 03 00 00       	call   803683 <_panic>
  803383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803386:	8b 00                	mov    (%eax),%eax
  803388:	85 c0                	test   %eax,%eax
  80338a:	74 10                	je     80339c <free_block+0x244>
  80338c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338f:	8b 00                	mov    (%eax),%eax
  803391:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803394:	8b 52 04             	mov    0x4(%edx),%edx
  803397:	89 50 04             	mov    %edx,0x4(%eax)
  80339a:	eb 14                	jmp    8033b0 <free_block+0x258>
  80339c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339f:	8b 40 04             	mov    0x4(%eax),%eax
  8033a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033a5:	c1 e2 04             	shl    $0x4,%edx
  8033a8:	81 c2 24 eb 87 00    	add    $0x87eb24,%edx
  8033ae:	89 02                	mov    %eax,(%edx)
  8033b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b3:	8b 40 04             	mov    0x4(%eax),%eax
  8033b6:	85 c0                	test   %eax,%eax
  8033b8:	74 0f                	je     8033c9 <free_block+0x271>
  8033ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bd:	8b 40 04             	mov    0x4(%eax),%eax
  8033c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033c3:	8b 12                	mov    (%edx),%edx
  8033c5:	89 10                	mov    %edx,(%eax)
  8033c7:	eb 13                	jmp    8033dc <free_block+0x284>
  8033c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033cc:	8b 00                	mov    (%eax),%eax
  8033ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033d1:	c1 e2 04             	shl    $0x4,%edx
  8033d4:	81 c2 20 eb 87 00    	add    $0x87eb20,%edx
  8033da:	89 02                	mov    %eax,(%edx)
  8033dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f2:	c1 e0 04             	shl    $0x4,%eax
  8033f5:	05 2c eb 87 00       	add    $0x87eb2c,%eax
  8033fa:	8b 00                	mov    (%eax),%eax
  8033fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8033ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803402:	c1 e0 04             	shl    $0x4,%eax
  803405:	05 2c eb 87 00       	add    $0x87eb2c,%eax
  80340a:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  80340c:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  80340f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803412:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803415:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803419:	0f 85 21 ff ff ff    	jne    803340 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  80341f:	b8 00 10 00 00       	mov    $0x1000,%eax
  803424:	99                   	cltd   
  803425:	f7 7d e8             	idivl  -0x18(%ebp)
  803428:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80342b:	74 17                	je     803444 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  80342d:	83 ec 04             	sub    $0x4,%esp
  803430:	68 74 47 80 00       	push   $0x804774
  803435:	68 0c 01 00 00       	push   $0x10c
  80343a:	68 8b 45 80 00       	push   $0x80458b
  80343f:	e8 3f 02 00 00       	call   803683 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803444:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803447:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  80344d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803450:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803456:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80345a:	75 17                	jne    803473 <free_block+0x31b>
  80345c:	83 ec 04             	sub    $0x4,%esp
  80345f:	68 44 46 80 00       	push   $0x804644
  803464:	68 11 01 00 00       	push   $0x111
  803469:	68 8b 45 80 00       	push   $0x80458b
  80346e:	e8 10 02 00 00       	call   803683 <_panic>
  803473:	8b 15 e8 6a 86 00    	mov    0x866ae8,%edx
  803479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80347c:	89 50 04             	mov    %edx,0x4(%eax)
  80347f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803482:	8b 40 04             	mov    0x4(%eax),%eax
  803485:	85 c0                	test   %eax,%eax
  803487:	74 0c                	je     803495 <free_block+0x33d>
  803489:	a1 e8 6a 86 00       	mov    0x866ae8,%eax
  80348e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803491:	89 10                	mov    %edx,(%eax)
  803493:	eb 08                	jmp    80349d <free_block+0x345>
  803495:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803498:	a3 e4 6a 86 00       	mov    %eax,0x866ae4
  80349d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a0:	a3 e8 6a 86 00       	mov    %eax,0x866ae8
  8034a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ae:	a1 f0 6a 86 00       	mov    0x866af0,%eax
  8034b3:	40                   	inc    %eax
  8034b4:	a3 f0 6a 86 00       	mov    %eax,0x866af0

        uint32 pp = to_page_va(page_info_e);
  8034b9:	83 ec 0c             	sub    $0xc,%esp
  8034bc:	ff 75 ec             	pushl  -0x14(%ebp)
  8034bf:	e8 2b f4 ff ff       	call   8028ef <to_page_va>
  8034c4:	83 c4 10             	add    $0x10,%esp
  8034c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8034ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034cd:	83 ec 0c             	sub    $0xc,%esp
  8034d0:	50                   	push   %eax
  8034d1:	e8 69 e8 ff ff       	call   801d3f <return_page>
  8034d6:	83 c4 10             	add    $0x10,%esp
  8034d9:	eb 01                	jmp    8034dc <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8034db:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8034dc:	c9                   	leave  
  8034dd:	c3                   	ret    

008034de <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8034de:	55                   	push   %ebp
  8034df:	89 e5                	mov    %esp,%ebp
  8034e1:	83 ec 14             	sub    $0x14,%esp
  8034e4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8034e7:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8034eb:	77 07                	ja     8034f4 <nearest_pow2_ceil.1572+0x16>
      return 1;
  8034ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8034f2:	eb 20                	jmp    803514 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8034f4:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8034fb:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8034fe:	eb 08                	jmp    803508 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803500:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803503:	01 c0                	add    %eax,%eax
  803505:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803508:	d1 6d 08             	shrl   0x8(%ebp)
  80350b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80350f:	75 ef                	jne    803500 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803511:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803514:	c9                   	leave  
  803515:	c3                   	ret    

00803516 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803516:	55                   	push   %ebp
  803517:	89 e5                	mov    %esp,%ebp
  803519:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  80351c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803520:	75 13                	jne    803535 <realloc_block+0x1f>
    return alloc_block(new_size);
  803522:	83 ec 0c             	sub    $0xc,%esp
  803525:	ff 75 0c             	pushl  0xc(%ebp)
  803528:	e8 d1 f6 ff ff       	call   802bfe <alloc_block>
  80352d:	83 c4 10             	add    $0x10,%esp
  803530:	e9 d9 00 00 00       	jmp    80360e <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803535:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803539:	75 18                	jne    803553 <realloc_block+0x3d>
    free_block(va);
  80353b:	83 ec 0c             	sub    $0xc,%esp
  80353e:	ff 75 08             	pushl  0x8(%ebp)
  803541:	e8 12 fc ff ff       	call   803158 <free_block>
  803546:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803549:	b8 00 00 00 00       	mov    $0x0,%eax
  80354e:	e9 bb 00 00 00       	jmp    80360e <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803553:	83 ec 0c             	sub    $0xc,%esp
  803556:	ff 75 08             	pushl  0x8(%ebp)
  803559:	e8 38 f6 ff ff       	call   802b96 <get_block_size>
  80355e:	83 c4 10             	add    $0x10,%esp
  803561:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803564:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  80356b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80356e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803571:	73 06                	jae    803579 <realloc_block+0x63>
    new_size = min_block_size;
  803573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803576:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803579:	83 ec 0c             	sub    $0xc,%esp
  80357c:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80357f:	ff 75 0c             	pushl  0xc(%ebp)
  803582:	89 c1                	mov    %eax,%ecx
  803584:	e8 55 ff ff ff       	call   8034de <nearest_pow2_ceil.1572>
  803589:	83 c4 10             	add    $0x10,%esp
  80358c:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  80358f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803592:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803595:	75 05                	jne    80359c <realloc_block+0x86>
    return va;
  803597:	8b 45 08             	mov    0x8(%ebp),%eax
  80359a:	eb 72                	jmp    80360e <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  80359c:	83 ec 0c             	sub    $0xc,%esp
  80359f:	ff 75 0c             	pushl  0xc(%ebp)
  8035a2:	e8 57 f6 ff ff       	call   802bfe <alloc_block>
  8035a7:	83 c4 10             	add    $0x10,%esp
  8035aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8035ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035b1:	75 07                	jne    8035ba <realloc_block+0xa4>
    return NULL;
  8035b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b8:	eb 54                	jmp    80360e <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  8035ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c0:	39 d0                	cmp    %edx,%eax
  8035c2:	76 02                	jbe    8035c6 <realloc_block+0xb0>
  8035c4:	89 d0                	mov    %edx,%eax
  8035c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  8035c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8035cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8035d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8035dc:	eb 17                	jmp    8035f5 <realloc_block+0xdf>
    dst[i] = src[i];
  8035de:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e4:	01 c2                	add    %eax,%edx
  8035e6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8035e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ec:	01 c8                	add    %ecx,%eax
  8035ee:	8a 00                	mov    (%eax),%al
  8035f0:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  8035f2:	ff 45 f4             	incl   -0xc(%ebp)
  8035f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035fb:	72 e1                	jb     8035de <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  8035fd:	83 ec 0c             	sub    $0xc,%esp
  803600:	ff 75 08             	pushl  0x8(%ebp)
  803603:	e8 50 fb ff ff       	call   803158 <free_block>
  803608:	83 c4 10             	add    $0x10,%esp

  return new_va;
  80360b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80360e:	c9                   	leave  
  80360f:	c3                   	ret    

00803610 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803610:	55                   	push   %ebp
  803611:	89 e5                	mov    %esp,%ebp
  803613:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  803616:	83 ec 04             	sub    $0x4,%esp
  803619:	68 a8 47 80 00       	push   $0x8047a8
  80361e:	6a 07                	push   $0x7
  803620:	68 d7 47 80 00       	push   $0x8047d7
  803625:	e8 59 00 00 00       	call   803683 <_panic>

0080362a <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80362a:	55                   	push   %ebp
  80362b:	89 e5                	mov    %esp,%ebp
  80362d:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  803630:	83 ec 04             	sub    $0x4,%esp
  803633:	68 e8 47 80 00       	push   $0x8047e8
  803638:	6a 0b                	push   $0xb
  80363a:	68 d7 47 80 00       	push   $0x8047d7
  80363f:	e8 3f 00 00 00       	call   803683 <_panic>

00803644 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  803644:	55                   	push   %ebp
  803645:	89 e5                	mov    %esp,%ebp
  803647:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  80364a:	83 ec 04             	sub    $0x4,%esp
  80364d:	68 14 48 80 00       	push   $0x804814
  803652:	6a 10                	push   $0x10
  803654:	68 d7 47 80 00       	push   $0x8047d7
  803659:	e8 25 00 00 00       	call   803683 <_panic>

0080365e <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  80365e:	55                   	push   %ebp
  80365f:	89 e5                	mov    %esp,%ebp
  803661:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  803664:	83 ec 04             	sub    $0x4,%esp
  803667:	68 44 48 80 00       	push   $0x804844
  80366c:	6a 15                	push   $0x15
  80366e:	68 d7 47 80 00       	push   $0x8047d7
  803673:	e8 0b 00 00 00       	call   803683 <_panic>

00803678 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  803678:	55                   	push   %ebp
  803679:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80367b:	8b 45 08             	mov    0x8(%ebp),%eax
  80367e:	8b 40 10             	mov    0x10(%eax),%eax
}
  803681:	5d                   	pop    %ebp
  803682:	c3                   	ret    

00803683 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803683:	55                   	push   %ebp
  803684:	89 e5                	mov    %esp,%ebp
  803686:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803689:	8d 45 10             	lea    0x10(%ebp),%eax
  80368c:	83 c0 04             	add    $0x4,%eax
  80368f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803692:	a1 48 06 8e 00       	mov    0x8e0648,%eax
  803697:	85 c0                	test   %eax,%eax
  803699:	74 16                	je     8036b1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80369b:	a1 48 06 8e 00       	mov    0x8e0648,%eax
  8036a0:	83 ec 08             	sub    $0x8,%esp
  8036a3:	50                   	push   %eax
  8036a4:	68 74 48 80 00       	push   $0x804874
  8036a9:	e8 a9 d0 ff ff       	call   800757 <cprintf>
  8036ae:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8036b1:	a1 04 50 80 00       	mov    0x805004,%eax
  8036b6:	83 ec 0c             	sub    $0xc,%esp
  8036b9:	ff 75 0c             	pushl  0xc(%ebp)
  8036bc:	ff 75 08             	pushl  0x8(%ebp)
  8036bf:	50                   	push   %eax
  8036c0:	68 7c 48 80 00       	push   $0x80487c
  8036c5:	6a 74                	push   $0x74
  8036c7:	e8 b8 d0 ff ff       	call   800784 <cprintf_colored>
  8036cc:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8036cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8036d2:	83 ec 08             	sub    $0x8,%esp
  8036d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8036d8:	50                   	push   %eax
  8036d9:	e8 0a d0 ff ff       	call   8006e8 <vcprintf>
  8036de:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8036e1:	83 ec 08             	sub    $0x8,%esp
  8036e4:	6a 00                	push   $0x0
  8036e6:	68 a4 48 80 00       	push   $0x8048a4
  8036eb:	e8 f8 cf ff ff       	call   8006e8 <vcprintf>
  8036f0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8036f3:	e8 71 cf ff ff       	call   800669 <exit>

	// should not return here
	while (1) ;
  8036f8:	eb fe                	jmp    8036f8 <_panic+0x75>

008036fa <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8036fa:	55                   	push   %ebp
  8036fb:	89 e5                	mov    %esp,%ebp
  8036fd:	53                   	push   %ebx
  8036fe:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803701:	a1 20 50 80 00       	mov    0x805020,%eax
  803706:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80370c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80370f:	39 c2                	cmp    %eax,%edx
  803711:	74 14                	je     803727 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803713:	83 ec 04             	sub    $0x4,%esp
  803716:	68 a8 48 80 00       	push   $0x8048a8
  80371b:	6a 26                	push   $0x26
  80371d:	68 f4 48 80 00       	push   $0x8048f4
  803722:	e8 5c ff ff ff       	call   803683 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803727:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80372e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803735:	e9 d9 00 00 00       	jmp    803813 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  80373a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803744:	8b 45 08             	mov    0x8(%ebp),%eax
  803747:	01 d0                	add    %edx,%eax
  803749:	8b 00                	mov    (%eax),%eax
  80374b:	85 c0                	test   %eax,%eax
  80374d:	75 08                	jne    803757 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80374f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803752:	e9 b9 00 00 00       	jmp    803810 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  803757:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80375e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803765:	eb 79                	jmp    8037e0 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803767:	a1 20 50 80 00       	mov    0x805020,%eax
  80376c:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803772:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803775:	89 d0                	mov    %edx,%eax
  803777:	01 c0                	add    %eax,%eax
  803779:	01 d0                	add    %edx,%eax
  80377b:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803782:	01 d8                	add    %ebx,%eax
  803784:	01 d0                	add    %edx,%eax
  803786:	01 c8                	add    %ecx,%eax
  803788:	8a 40 04             	mov    0x4(%eax),%al
  80378b:	84 c0                	test   %al,%al
  80378d:	75 4e                	jne    8037dd <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80378f:	a1 20 50 80 00       	mov    0x805020,%eax
  803794:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80379a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80379d:	89 d0                	mov    %edx,%eax
  80379f:	01 c0                	add    %eax,%eax
  8037a1:	01 d0                	add    %edx,%eax
  8037a3:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8037aa:	01 d8                	add    %ebx,%eax
  8037ac:	01 d0                	add    %edx,%eax
  8037ae:	01 c8                	add    %ecx,%eax
  8037b0:	8b 00                	mov    (%eax),%eax
  8037b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8037b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8037bd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8037bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8037c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cc:	01 c8                	add    %ecx,%eax
  8037ce:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8037d0:	39 c2                	cmp    %eax,%edx
  8037d2:	75 09                	jne    8037dd <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8037d4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8037db:	eb 19                	jmp    8037f6 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037dd:	ff 45 e8             	incl   -0x18(%ebp)
  8037e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8037e5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8037eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ee:	39 c2                	cmp    %eax,%edx
  8037f0:	0f 87 71 ff ff ff    	ja     803767 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8037f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037fa:	75 14                	jne    803810 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8037fc:	83 ec 04             	sub    $0x4,%esp
  8037ff:	68 00 49 80 00       	push   $0x804900
  803804:	6a 3a                	push   $0x3a
  803806:	68 f4 48 80 00       	push   $0x8048f4
  80380b:	e8 73 fe ff ff       	call   803683 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803810:	ff 45 f0             	incl   -0x10(%ebp)
  803813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803816:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803819:	0f 8c 1b ff ff ff    	jl     80373a <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80381f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803826:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80382d:	eb 2e                	jmp    80385d <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80382f:	a1 20 50 80 00       	mov    0x805020,%eax
  803834:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80383a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80383d:	89 d0                	mov    %edx,%eax
  80383f:	01 c0                	add    %eax,%eax
  803841:	01 d0                	add    %edx,%eax
  803843:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80384a:	01 d8                	add    %ebx,%eax
  80384c:	01 d0                	add    %edx,%eax
  80384e:	01 c8                	add    %ecx,%eax
  803850:	8a 40 04             	mov    0x4(%eax),%al
  803853:	3c 01                	cmp    $0x1,%al
  803855:	75 03                	jne    80385a <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  803857:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80385a:	ff 45 e0             	incl   -0x20(%ebp)
  80385d:	a1 20 50 80 00       	mov    0x805020,%eax
  803862:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803868:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80386b:	39 c2                	cmp    %eax,%edx
  80386d:	77 c0                	ja     80382f <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80386f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803872:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803875:	74 14                	je     80388b <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  803877:	83 ec 04             	sub    $0x4,%esp
  80387a:	68 54 49 80 00       	push   $0x804954
  80387f:	6a 44                	push   $0x44
  803881:	68 f4 48 80 00       	push   $0x8048f4
  803886:	e8 f8 fd ff ff       	call   803683 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80388b:	90                   	nop
  80388c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80388f:	c9                   	leave  
  803890:	c3                   	ret    
  803891:	66 90                	xchg   %ax,%ax
  803893:	90                   	nop

00803894 <__udivdi3>:
  803894:	55                   	push   %ebp
  803895:	57                   	push   %edi
  803896:	56                   	push   %esi
  803897:	53                   	push   %ebx
  803898:	83 ec 1c             	sub    $0x1c,%esp
  80389b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80389f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038ab:	89 ca                	mov    %ecx,%edx
  8038ad:	89 f8                	mov    %edi,%eax
  8038af:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038b3:	85 f6                	test   %esi,%esi
  8038b5:	75 2d                	jne    8038e4 <__udivdi3+0x50>
  8038b7:	39 cf                	cmp    %ecx,%edi
  8038b9:	77 65                	ja     803920 <__udivdi3+0x8c>
  8038bb:	89 fd                	mov    %edi,%ebp
  8038bd:	85 ff                	test   %edi,%edi
  8038bf:	75 0b                	jne    8038cc <__udivdi3+0x38>
  8038c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8038c6:	31 d2                	xor    %edx,%edx
  8038c8:	f7 f7                	div    %edi
  8038ca:	89 c5                	mov    %eax,%ebp
  8038cc:	31 d2                	xor    %edx,%edx
  8038ce:	89 c8                	mov    %ecx,%eax
  8038d0:	f7 f5                	div    %ebp
  8038d2:	89 c1                	mov    %eax,%ecx
  8038d4:	89 d8                	mov    %ebx,%eax
  8038d6:	f7 f5                	div    %ebp
  8038d8:	89 cf                	mov    %ecx,%edi
  8038da:	89 fa                	mov    %edi,%edx
  8038dc:	83 c4 1c             	add    $0x1c,%esp
  8038df:	5b                   	pop    %ebx
  8038e0:	5e                   	pop    %esi
  8038e1:	5f                   	pop    %edi
  8038e2:	5d                   	pop    %ebp
  8038e3:	c3                   	ret    
  8038e4:	39 ce                	cmp    %ecx,%esi
  8038e6:	77 28                	ja     803910 <__udivdi3+0x7c>
  8038e8:	0f bd fe             	bsr    %esi,%edi
  8038eb:	83 f7 1f             	xor    $0x1f,%edi
  8038ee:	75 40                	jne    803930 <__udivdi3+0x9c>
  8038f0:	39 ce                	cmp    %ecx,%esi
  8038f2:	72 0a                	jb     8038fe <__udivdi3+0x6a>
  8038f4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038f8:	0f 87 9e 00 00 00    	ja     80399c <__udivdi3+0x108>
  8038fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803903:	89 fa                	mov    %edi,%edx
  803905:	83 c4 1c             	add    $0x1c,%esp
  803908:	5b                   	pop    %ebx
  803909:	5e                   	pop    %esi
  80390a:	5f                   	pop    %edi
  80390b:	5d                   	pop    %ebp
  80390c:	c3                   	ret    
  80390d:	8d 76 00             	lea    0x0(%esi),%esi
  803910:	31 ff                	xor    %edi,%edi
  803912:	31 c0                	xor    %eax,%eax
  803914:	89 fa                	mov    %edi,%edx
  803916:	83 c4 1c             	add    $0x1c,%esp
  803919:	5b                   	pop    %ebx
  80391a:	5e                   	pop    %esi
  80391b:	5f                   	pop    %edi
  80391c:	5d                   	pop    %ebp
  80391d:	c3                   	ret    
  80391e:	66 90                	xchg   %ax,%ax
  803920:	89 d8                	mov    %ebx,%eax
  803922:	f7 f7                	div    %edi
  803924:	31 ff                	xor    %edi,%edi
  803926:	89 fa                	mov    %edi,%edx
  803928:	83 c4 1c             	add    $0x1c,%esp
  80392b:	5b                   	pop    %ebx
  80392c:	5e                   	pop    %esi
  80392d:	5f                   	pop    %edi
  80392e:	5d                   	pop    %ebp
  80392f:	c3                   	ret    
  803930:	bd 20 00 00 00       	mov    $0x20,%ebp
  803935:	89 eb                	mov    %ebp,%ebx
  803937:	29 fb                	sub    %edi,%ebx
  803939:	89 f9                	mov    %edi,%ecx
  80393b:	d3 e6                	shl    %cl,%esi
  80393d:	89 c5                	mov    %eax,%ebp
  80393f:	88 d9                	mov    %bl,%cl
  803941:	d3 ed                	shr    %cl,%ebp
  803943:	89 e9                	mov    %ebp,%ecx
  803945:	09 f1                	or     %esi,%ecx
  803947:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80394b:	89 f9                	mov    %edi,%ecx
  80394d:	d3 e0                	shl    %cl,%eax
  80394f:	89 c5                	mov    %eax,%ebp
  803951:	89 d6                	mov    %edx,%esi
  803953:	88 d9                	mov    %bl,%cl
  803955:	d3 ee                	shr    %cl,%esi
  803957:	89 f9                	mov    %edi,%ecx
  803959:	d3 e2                	shl    %cl,%edx
  80395b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80395f:	88 d9                	mov    %bl,%cl
  803961:	d3 e8                	shr    %cl,%eax
  803963:	09 c2                	or     %eax,%edx
  803965:	89 d0                	mov    %edx,%eax
  803967:	89 f2                	mov    %esi,%edx
  803969:	f7 74 24 0c          	divl   0xc(%esp)
  80396d:	89 d6                	mov    %edx,%esi
  80396f:	89 c3                	mov    %eax,%ebx
  803971:	f7 e5                	mul    %ebp
  803973:	39 d6                	cmp    %edx,%esi
  803975:	72 19                	jb     803990 <__udivdi3+0xfc>
  803977:	74 0b                	je     803984 <__udivdi3+0xf0>
  803979:	89 d8                	mov    %ebx,%eax
  80397b:	31 ff                	xor    %edi,%edi
  80397d:	e9 58 ff ff ff       	jmp    8038da <__udivdi3+0x46>
  803982:	66 90                	xchg   %ax,%ax
  803984:	8b 54 24 08          	mov    0x8(%esp),%edx
  803988:	89 f9                	mov    %edi,%ecx
  80398a:	d3 e2                	shl    %cl,%edx
  80398c:	39 c2                	cmp    %eax,%edx
  80398e:	73 e9                	jae    803979 <__udivdi3+0xe5>
  803990:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803993:	31 ff                	xor    %edi,%edi
  803995:	e9 40 ff ff ff       	jmp    8038da <__udivdi3+0x46>
  80399a:	66 90                	xchg   %ax,%ax
  80399c:	31 c0                	xor    %eax,%eax
  80399e:	e9 37 ff ff ff       	jmp    8038da <__udivdi3+0x46>
  8039a3:	90                   	nop

008039a4 <__umoddi3>:
  8039a4:	55                   	push   %ebp
  8039a5:	57                   	push   %edi
  8039a6:	56                   	push   %esi
  8039a7:	53                   	push   %ebx
  8039a8:	83 ec 1c             	sub    $0x1c,%esp
  8039ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039b7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039c3:	89 f3                	mov    %esi,%ebx
  8039c5:	89 fa                	mov    %edi,%edx
  8039c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039cb:	89 34 24             	mov    %esi,(%esp)
  8039ce:	85 c0                	test   %eax,%eax
  8039d0:	75 1a                	jne    8039ec <__umoddi3+0x48>
  8039d2:	39 f7                	cmp    %esi,%edi
  8039d4:	0f 86 a2 00 00 00    	jbe    803a7c <__umoddi3+0xd8>
  8039da:	89 c8                	mov    %ecx,%eax
  8039dc:	89 f2                	mov    %esi,%edx
  8039de:	f7 f7                	div    %edi
  8039e0:	89 d0                	mov    %edx,%eax
  8039e2:	31 d2                	xor    %edx,%edx
  8039e4:	83 c4 1c             	add    $0x1c,%esp
  8039e7:	5b                   	pop    %ebx
  8039e8:	5e                   	pop    %esi
  8039e9:	5f                   	pop    %edi
  8039ea:	5d                   	pop    %ebp
  8039eb:	c3                   	ret    
  8039ec:	39 f0                	cmp    %esi,%eax
  8039ee:	0f 87 ac 00 00 00    	ja     803aa0 <__umoddi3+0xfc>
  8039f4:	0f bd e8             	bsr    %eax,%ebp
  8039f7:	83 f5 1f             	xor    $0x1f,%ebp
  8039fa:	0f 84 ac 00 00 00    	je     803aac <__umoddi3+0x108>
  803a00:	bf 20 00 00 00       	mov    $0x20,%edi
  803a05:	29 ef                	sub    %ebp,%edi
  803a07:	89 fe                	mov    %edi,%esi
  803a09:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a0d:	89 e9                	mov    %ebp,%ecx
  803a0f:	d3 e0                	shl    %cl,%eax
  803a11:	89 d7                	mov    %edx,%edi
  803a13:	89 f1                	mov    %esi,%ecx
  803a15:	d3 ef                	shr    %cl,%edi
  803a17:	09 c7                	or     %eax,%edi
  803a19:	89 e9                	mov    %ebp,%ecx
  803a1b:	d3 e2                	shl    %cl,%edx
  803a1d:	89 14 24             	mov    %edx,(%esp)
  803a20:	89 d8                	mov    %ebx,%eax
  803a22:	d3 e0                	shl    %cl,%eax
  803a24:	89 c2                	mov    %eax,%edx
  803a26:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a2a:	d3 e0                	shl    %cl,%eax
  803a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a30:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a34:	89 f1                	mov    %esi,%ecx
  803a36:	d3 e8                	shr    %cl,%eax
  803a38:	09 d0                	or     %edx,%eax
  803a3a:	d3 eb                	shr    %cl,%ebx
  803a3c:	89 da                	mov    %ebx,%edx
  803a3e:	f7 f7                	div    %edi
  803a40:	89 d3                	mov    %edx,%ebx
  803a42:	f7 24 24             	mull   (%esp)
  803a45:	89 c6                	mov    %eax,%esi
  803a47:	89 d1                	mov    %edx,%ecx
  803a49:	39 d3                	cmp    %edx,%ebx
  803a4b:	0f 82 87 00 00 00    	jb     803ad8 <__umoddi3+0x134>
  803a51:	0f 84 91 00 00 00    	je     803ae8 <__umoddi3+0x144>
  803a57:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a5b:	29 f2                	sub    %esi,%edx
  803a5d:	19 cb                	sbb    %ecx,%ebx
  803a5f:	89 d8                	mov    %ebx,%eax
  803a61:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a65:	d3 e0                	shl    %cl,%eax
  803a67:	89 e9                	mov    %ebp,%ecx
  803a69:	d3 ea                	shr    %cl,%edx
  803a6b:	09 d0                	or     %edx,%eax
  803a6d:	89 e9                	mov    %ebp,%ecx
  803a6f:	d3 eb                	shr    %cl,%ebx
  803a71:	89 da                	mov    %ebx,%edx
  803a73:	83 c4 1c             	add    $0x1c,%esp
  803a76:	5b                   	pop    %ebx
  803a77:	5e                   	pop    %esi
  803a78:	5f                   	pop    %edi
  803a79:	5d                   	pop    %ebp
  803a7a:	c3                   	ret    
  803a7b:	90                   	nop
  803a7c:	89 fd                	mov    %edi,%ebp
  803a7e:	85 ff                	test   %edi,%edi
  803a80:	75 0b                	jne    803a8d <__umoddi3+0xe9>
  803a82:	b8 01 00 00 00       	mov    $0x1,%eax
  803a87:	31 d2                	xor    %edx,%edx
  803a89:	f7 f7                	div    %edi
  803a8b:	89 c5                	mov    %eax,%ebp
  803a8d:	89 f0                	mov    %esi,%eax
  803a8f:	31 d2                	xor    %edx,%edx
  803a91:	f7 f5                	div    %ebp
  803a93:	89 c8                	mov    %ecx,%eax
  803a95:	f7 f5                	div    %ebp
  803a97:	89 d0                	mov    %edx,%eax
  803a99:	e9 44 ff ff ff       	jmp    8039e2 <__umoddi3+0x3e>
  803a9e:	66 90                	xchg   %ax,%ax
  803aa0:	89 c8                	mov    %ecx,%eax
  803aa2:	89 f2                	mov    %esi,%edx
  803aa4:	83 c4 1c             	add    $0x1c,%esp
  803aa7:	5b                   	pop    %ebx
  803aa8:	5e                   	pop    %esi
  803aa9:	5f                   	pop    %edi
  803aaa:	5d                   	pop    %ebp
  803aab:	c3                   	ret    
  803aac:	3b 04 24             	cmp    (%esp),%eax
  803aaf:	72 06                	jb     803ab7 <__umoddi3+0x113>
  803ab1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ab5:	77 0f                	ja     803ac6 <__umoddi3+0x122>
  803ab7:	89 f2                	mov    %esi,%edx
  803ab9:	29 f9                	sub    %edi,%ecx
  803abb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803abf:	89 14 24             	mov    %edx,(%esp)
  803ac2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ac6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803aca:	8b 14 24             	mov    (%esp),%edx
  803acd:	83 c4 1c             	add    $0x1c,%esp
  803ad0:	5b                   	pop    %ebx
  803ad1:	5e                   	pop    %esi
  803ad2:	5f                   	pop    %edi
  803ad3:	5d                   	pop    %ebp
  803ad4:	c3                   	ret    
  803ad5:	8d 76 00             	lea    0x0(%esi),%esi
  803ad8:	2b 04 24             	sub    (%esp),%eax
  803adb:	19 fa                	sbb    %edi,%edx
  803add:	89 d1                	mov    %edx,%ecx
  803adf:	89 c6                	mov    %eax,%esi
  803ae1:	e9 71 ff ff ff       	jmp    803a57 <__umoddi3+0xb3>
  803ae6:	66 90                	xchg   %ax,%ax
  803ae8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803aec:	72 ea                	jb     803ad8 <__umoddi3+0x134>
  803aee:	89 d9                	mov    %ebx,%ecx
  803af0:	e9 62 ff ff ff       	jmp    803a57 <__umoddi3+0xb3>
