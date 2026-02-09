
obj/user/quicksort_freeheap:     file format elf32-i386


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
  800031:	e8 5d 05 00 00       	call   800593 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 f7 28 00 00       	call   802945 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 09 29 00 00       	call   80295e <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

		//	sys_lock_cons();

		readline("Enter the number of elements: ", Line);
  80005d:	83 ec 08             	sub    $0x8,%esp
  800060:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	68 60 3d 80 00       	push   $0x803d60
  80006c:	e8 99 10 00 00       	call   80110a <readline>
  800071:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800074:	83 ec 04             	sub    $0x4,%esp
  800077:	6a 0a                	push   $0xa
  800079:	6a 00                	push   $0x0
  80007b:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800081:	50                   	push   %eax
  800082:	e8 9a 16 00 00       	call   801721 <strtol>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  80008d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	e8 c8 21 00 00       	call   802264 <malloc>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Choose the initialization method:\n") ;
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 80 3d 80 00       	push   $0x803d80
  8000aa:	e8 82 09 00 00       	call   800a31 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 a3 3d 80 00       	push   $0x803da3
  8000ba:	e8 72 09 00 00       	call   800a31 <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 b1 3d 80 00       	push   $0x803db1
  8000ca:	e8 62 09 00 00       	call   800a31 <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 c0 3d 80 00       	push   $0x803dc0
  8000da:	e8 52 09 00 00       	call   800a31 <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 d0 3d 80 00       	push   $0x803dd0
  8000ea:	e8 42 09 00 00       	call   800a31 <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8000f2:	e8 7f 04 00 00       	call   800576 <getchar>
  8000f7:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8000fa:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	50                   	push   %eax
  800102:	e8 50 04 00 00       	call   800557 <cputchar>
  800107:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	6a 0a                	push   $0xa
  80010f:	e8 43 04 00 00       	call   800557 <cputchar>
  800114:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800117:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  80011b:	74 0c                	je     800129 <_main+0xf1>
  80011d:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800121:	74 06                	je     800129 <_main+0xf1>
  800123:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  800127:	75 b9                	jne    8000e2 <_main+0xaa>
		//sys_unlock_cons();
		int  i ;
		switch (Chose)
  800129:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80012d:	83 f8 62             	cmp    $0x62,%eax
  800130:	74 1d                	je     80014f <_main+0x117>
  800132:	83 f8 63             	cmp    $0x63,%eax
  800135:	74 2b                	je     800162 <_main+0x12a>
  800137:	83 f8 61             	cmp    $0x61,%eax
  80013a:	75 39                	jne    800175 <_main+0x13d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	ff 75 ec             	pushl  -0x14(%ebp)
  800142:	ff 75 e8             	pushl  -0x18(%ebp)
  800145:	e8 c8 02 00 00       	call   800412 <InitializeAscending>
  80014a:	83 c4 10             	add    $0x10,%esp
			break ;
  80014d:	eb 37                	jmp    800186 <_main+0x14e>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	ff 75 ec             	pushl  -0x14(%ebp)
  800155:	ff 75 e8             	pushl  -0x18(%ebp)
  800158:	e8 e6 02 00 00       	call   800443 <InitializeIdentical>
  80015d:	83 c4 10             	add    $0x10,%esp
			break ;
  800160:	eb 24                	jmp    800186 <_main+0x14e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 75 ec             	pushl  -0x14(%ebp)
  800168:	ff 75 e8             	pushl  -0x18(%ebp)
  80016b:	e8 08 03 00 00       	call   800478 <InitializeSemiRandom>
  800170:	83 c4 10             	add    $0x10,%esp
			break ;
  800173:	eb 11                	jmp    800186 <_main+0x14e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 75 ec             	pushl  -0x14(%ebp)
  80017b:	ff 75 e8             	pushl  -0x18(%ebp)
  80017e:	e8 f5 02 00 00       	call   800478 <InitializeSemiRandom>
  800183:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	ff 75 e8             	pushl  -0x18(%ebp)
  80018f:	e8 c3 00 00 00       	call   800257 <QuickSort>
  800194:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 ec             	pushl  -0x14(%ebp)
  80019d:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a0:	e8 c3 01 00 00       	call   800368 <CheckSorted>
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001af:	75 14                	jne    8001c5 <_main+0x18d>
  8001b1:	83 ec 04             	sub    $0x4,%esp
  8001b4:	68 dc 3d 80 00       	push   $0x803ddc
  8001b9:	6a 45                	push   $0x45
  8001bb:	68 fe 3d 80 00       	push   $0x803dfe
  8001c0:	e8 7e 05 00 00       	call   800743 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 18 3e 80 00       	push   $0x803e18
  8001cd:	e8 5f 08 00 00       	call   800a31 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 4c 3e 80 00       	push   $0x803e4c
  8001dd:	e8 4f 08 00 00       	call   800a31 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 80 3e 80 00       	push   $0x803e80
  8001ed:	e8 3f 08 00 00       	call   800a31 <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 b2 3e 80 00       	push   $0x803eb2
  8001fd:	e8 2f 08 00 00       	call   800a31 <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
		//sys_lock_cons();
		cprintf("Do you want to repeat (y/n): ") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 c8 3e 80 00       	push   $0x803ec8
  80020d:	e8 1f 08 00 00       	call   800a31 <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  800215:	e8 5c 03 00 00       	call   800576 <getchar>
  80021a:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  80021d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 2d 03 00 00       	call   800557 <cputchar>
  80022a:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 0a                	push   $0xa
  800232:	e8 20 03 00 00       	call   800557 <cputchar>
  800237:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	6a 0a                	push   $0xa
  80023f:	e8 13 03 00 00       	call   800557 <cputchar>
  800244:	83 c4 10             	add    $0x10,%esp
		//sys_unlock_cons();

	} while (Chose == 'y');
  800247:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  80024b:	0f 84 f8 fd ff ff    	je     800049 <_main+0x11>

}
  800251:	90                   	nop
  800252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  80025d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800260:	48                   	dec    %eax
  800261:	50                   	push   %eax
  800262:	6a 00                	push   $0x0
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 06 00 00 00       	call   800275 <QSort>
  80026f:	83 c4 10             	add    $0x10,%esp
}
  800272:	90                   	nop
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80027b:	8b 45 10             	mov    0x10(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	0f 8d de 00 00 00    	jge    800365 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800287:	8b 45 10             	mov    0x10(%ebp),%eax
  80028a:	40                   	inc    %eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80028e:	8b 45 14             	mov    0x14(%ebp),%eax
  800291:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800294:	e9 80 00 00 00       	jmp    800319 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800299:	ff 45 f4             	incl   -0xc(%ebp)
  80029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80029f:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a2:	7f 2b                	jg     8002cf <QSort+0x5a>
  8002a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	01 c8                	add    %ecx,%eax
  8002c4:	8b 00                	mov    (%eax),%eax
  8002c6:	39 c2                	cmp    %eax,%edx
  8002c8:	7d cf                	jge    800299 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002ca:	eb 03                	jmp    8002cf <QSort+0x5a>
  8002cc:	ff 4d f0             	decl   -0x10(%ebp)
  8002cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002d5:	7e 26                	jle    8002fd <QSort+0x88>
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	01 d0                	add    %edx,%eax
  8002e6:	8b 10                	mov    (%eax),%edx
  8002e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 c8                	add    %ecx,%eax
  8002f7:	8b 00                	mov    (%eax),%eax
  8002f9:	39 c2                	cmp    %eax,%edx
  8002fb:	7e cf                	jle    8002cc <QSort+0x57>

		if (i <= j)
  8002fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800303:	7f 14                	jg     800319 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	ff 75 f0             	pushl  -0x10(%ebp)
  80030b:	ff 75 f4             	pushl  -0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 a9 00 00 00       	call   8003bf <Swap>
  800316:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80031c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031f:	0f 8e 77 ff ff ff    	jle    80029c <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 f0             	pushl  -0x10(%ebp)
  80032b:	ff 75 10             	pushl  0x10(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	e8 89 00 00 00       	call   8003bf <Swap>
  800336:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	48                   	dec    %eax
  80033d:	50                   	push   %eax
  80033e:	ff 75 10             	pushl  0x10(%ebp)
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	e8 29 ff ff ff       	call   800275 <QSort>
  80034c:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80034f:	ff 75 14             	pushl  0x14(%ebp)
  800352:	ff 75 f4             	pushl  -0xc(%ebp)
  800355:	ff 75 0c             	pushl  0xc(%ebp)
  800358:	ff 75 08             	pushl  0x8(%ebp)
  80035b:	e8 15 ff ff ff       	call   800275 <QSort>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	eb 01                	jmp    800366 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800365:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80036e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800375:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80037c:	eb 33                	jmp    8003b1 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80037e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	8b 10                	mov    (%eax),%edx
  80038f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800392:	40                   	inc    %eax
  800393:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	01 c8                	add    %ecx,%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	39 c2                	cmp    %eax,%edx
  8003a3:	7e 09                	jle    8003ae <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003ac:	eb 0c                	jmp    8003ba <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ae:	ff 45 f8             	incl   -0x8(%ebp)
  8003b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b4:	48                   	dec    %eax
  8003b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003b8:	7f c4                	jg     80037e <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c2                	add    %eax,%edx
  8003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c8                	add    %ecx,%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c2                	add    %eax,%edx
  80040a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040d:	89 02                	mov    %eax,(%edx)
}
  80040f:	90                   	nop
  800410:	c9                   	leave  
  800411:	c3                   	ret    

00800412 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80041f:	eb 17                	jmp    800438 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800421:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	01 c2                	add    %eax,%edx
  800430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800433:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	ff 45 fc             	incl   -0x4(%ebp)
  800438:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043e:	7c e1                	jl     800421 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800450:	eb 1b                	jmp    80046d <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800467:	48                   	dec    %eax
  800468:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80046a:	ff 45 fc             	incl   -0x4(%ebp)
  80046d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800470:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800473:	7c dd                	jl     800452 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800475:	90                   	nop
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800486:	f7 e9                	imul   %ecx
  800488:	c1 f9 1f             	sar    $0x1f,%ecx
  80048b:	89 d0                	mov    %edx,%eax
  80048d:	29 c8                	sub    %ecx,%eax
  80048f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  800492:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800496:	75 07                	jne    80049f <InitializeSemiRandom+0x27>
			Repetition = 3;
  800498:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80049f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004a6:	eb 1e                	jmp    8004c6 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  8004a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004bb:	99                   	cltd   
  8004bc:	f7 7d f8             	idivl  -0x8(%ebp)
  8004bf:	89 d0                	mov    %edx,%eax
  8004c1:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c3:	ff 45 fc             	incl   -0x4(%ebp)
  8004c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004cc:	7c da                	jl     8004a8 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004ce:	90                   	nop
  8004cf:	c9                   	leave  
  8004d0:	c3                   	ret    

008004d1 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004d1:	55                   	push   %ebp
  8004d2:	89 e5                	mov    %esp,%ebp
  8004d4:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8004d7:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004e5:	eb 42                	jmp    800529 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8004e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ea:	99                   	cltd   
  8004eb:	f7 7d f0             	idivl  -0x10(%ebp)
  8004ee:	89 d0                	mov    %edx,%eax
  8004f0:	85 c0                	test   %eax,%eax
  8004f2:	75 10                	jne    800504 <PrintElements+0x33>
			cprintf("\n");
  8004f4:	83 ec 0c             	sub    $0xc,%esp
  8004f7:	68 e6 3e 80 00       	push   $0x803ee6
  8004fc:	e8 30 05 00 00       	call   800a31 <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800507:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050e:	8b 45 08             	mov    0x8(%ebp),%eax
  800511:	01 d0                	add    %edx,%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	50                   	push   %eax
  800519:	68 e8 3e 80 00       	push   $0x803ee8
  80051e:	e8 0e 05 00 00       	call   800a31 <cprintf>
  800523:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800526:	ff 45 f4             	incl   -0xc(%ebp)
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	48                   	dec    %eax
  80052d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800530:	7f b5                	jg     8004e7 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800535:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	01 d0                	add    %edx,%eax
  800541:	8b 00                	mov    (%eax),%eax
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	50                   	push   %eax
  800547:	68 ed 3e 80 00       	push   $0x803eed
  80054c:	e8 e0 04 00 00       	call   800a31 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp
}
  800554:	90                   	nop
  800555:	c9                   	leave  
  800556:	c3                   	ret    

00800557 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800557:	55                   	push   %ebp
  800558:	89 e5                	mov    %esp,%ebp
  80055a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800563:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800567:	83 ec 0c             	sub    $0xc,%esp
  80056a:	50                   	push   %eax
  80056b:	e8 6d 24 00 00       	call   8029dd <sys_cputc>
  800570:	83 c4 10             	add    $0x10,%esp
}
  800573:	90                   	nop
  800574:	c9                   	leave  
  800575:	c3                   	ret    

00800576 <getchar>:


int
getchar(void)
{
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
  800579:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80057c:	e8 fb 22 00 00       	call   80287c <sys_cgetc>
  800581:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800584:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800587:	c9                   	leave  
  800588:	c3                   	ret    

00800589 <iscons>:

int iscons(int fdnum)
{
  800589:	55                   	push   %ebp
  80058a:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80058c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800591:	5d                   	pop    %ebp
  800592:	c3                   	ret    

00800593 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	57                   	push   %edi
  800597:	56                   	push   %esi
  800598:	53                   	push   %ebx
  800599:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80059c:	e8 6d 25 00 00       	call   802b0e <sys_getenvindex>
  8005a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8005a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005a7:	89 d0                	mov    %edx,%eax
  8005a9:	01 c0                	add    %eax,%eax
  8005ab:	01 d0                	add    %edx,%eax
  8005ad:	c1 e0 02             	shl    $0x2,%eax
  8005b0:	01 d0                	add    %edx,%eax
  8005b2:	c1 e0 02             	shl    $0x2,%eax
  8005b5:	01 d0                	add    %edx,%eax
  8005b7:	c1 e0 03             	shl    $0x3,%eax
  8005ba:	01 d0                	add    %edx,%eax
  8005bc:	c1 e0 02             	shl    $0x2,%eax
  8005bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005c4:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005c9:	a1 24 50 80 00       	mov    0x805024,%eax
  8005ce:	8a 40 20             	mov    0x20(%eax),%al
  8005d1:	84 c0                	test   %al,%al
  8005d3:	74 0d                	je     8005e2 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8005d5:	a1 24 50 80 00       	mov    0x805024,%eax
  8005da:	83 c0 20             	add    $0x20,%eax
  8005dd:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005e6:	7e 0a                	jle    8005f2 <libmain+0x5f>
		binaryname = argv[0];
  8005e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	ff 75 08             	pushl  0x8(%ebp)
  8005fb:	e8 38 fa ff ff       	call   800038 <_main>
  800600:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800603:	a1 00 50 80 00       	mov    0x805000,%eax
  800608:	85 c0                	test   %eax,%eax
  80060a:	0f 84 01 01 00 00    	je     800711 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800610:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800616:	bb ec 3f 80 00       	mov    $0x803fec,%ebx
  80061b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800620:	89 c7                	mov    %eax,%edi
  800622:	89 de                	mov    %ebx,%esi
  800624:	89 d1                	mov    %edx,%ecx
  800626:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800628:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80062b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800630:	b0 00                	mov    $0x0,%al
  800632:	89 d7                	mov    %edx,%edi
  800634:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800636:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80063d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800640:	83 ec 08             	sub    $0x8,%esp
  800643:	50                   	push   %eax
  800644:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80064a:	50                   	push   %eax
  80064b:	e8 f4 26 00 00       	call   802d44 <sys_utilities>
  800650:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800653:	e8 3d 22 00 00       	call   802895 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 0c 3f 80 00       	push   $0x803f0c
  800660:	e8 cc 03 00 00       	call   800a31 <cprintf>
  800665:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800668:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066b:	85 c0                	test   %eax,%eax
  80066d:	74 18                	je     800687 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80066f:	e8 ee 26 00 00       	call   802d62 <sys_get_optimal_num_faults>
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	50                   	push   %eax
  800678:	68 34 3f 80 00       	push   $0x803f34
  80067d:	e8 af 03 00 00       	call   800a31 <cprintf>
  800682:	83 c4 10             	add    $0x10,%esp
  800685:	eb 59                	jmp    8006e0 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800687:	a1 24 50 80 00       	mov    0x805024,%eax
  80068c:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800692:	a1 24 50 80 00       	mov    0x805024,%eax
  800697:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80069d:	83 ec 04             	sub    $0x4,%esp
  8006a0:	52                   	push   %edx
  8006a1:	50                   	push   %eax
  8006a2:	68 58 3f 80 00       	push   $0x803f58
  8006a7:	e8 85 03 00 00       	call   800a31 <cprintf>
  8006ac:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006af:	a1 24 50 80 00       	mov    0x805024,%eax
  8006b4:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8006ba:	a1 24 50 80 00       	mov    0x805024,%eax
  8006bf:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8006c5:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ca:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8006d0:	51                   	push   %ecx
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	68 80 3f 80 00       	push   $0x803f80
  8006d8:	e8 54 03 00 00       	call   800a31 <cprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006e0:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e5:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	50                   	push   %eax
  8006ef:	68 d8 3f 80 00       	push   $0x803fd8
  8006f4:	e8 38 03 00 00       	call   800a31 <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	68 0c 3f 80 00       	push   $0x803f0c
  800704:	e8 28 03 00 00       	call   800a31 <cprintf>
  800709:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80070c:	e8 9e 21 00 00       	call   8028af <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800711:	e8 1f 00 00 00       	call   800735 <exit>
}
  800716:	90                   	nop
  800717:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80071a:	5b                   	pop    %ebx
  80071b:	5e                   	pop    %esi
  80071c:	5f                   	pop    %edi
  80071d:	5d                   	pop    %ebp
  80071e:	c3                   	ret    

0080071f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	6a 00                	push   $0x0
  80072a:	e8 ab 23 00 00       	call   802ada <sys_destroy_env>
  80072f:	83 c4 10             	add    $0x10,%esp
}
  800732:	90                   	nop
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <exit>:

void
exit(void)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80073b:	e8 00 24 00 00       	call   802b40 <sys_exit_env>
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800749:	8d 45 10             	lea    0x10(%ebp),%eax
  80074c:	83 c0 04             	add    $0x4,%eax
  80074f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800752:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800757:	85 c0                	test   %eax,%eax
  800759:	74 16                	je     800771 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80075b:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	50                   	push   %eax
  800764:	68 50 40 80 00       	push   $0x804050
  800769:	e8 c3 02 00 00       	call   800a31 <cprintf>
  80076e:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800771:	a1 04 50 80 00       	mov    0x805004,%eax
  800776:	83 ec 0c             	sub    $0xc,%esp
  800779:	ff 75 0c             	pushl  0xc(%ebp)
  80077c:	ff 75 08             	pushl  0x8(%ebp)
  80077f:	50                   	push   %eax
  800780:	68 58 40 80 00       	push   $0x804058
  800785:	6a 74                	push   $0x74
  800787:	e8 d2 02 00 00       	call   800a5e <cprintf_colored>
  80078c:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80078f:	8b 45 10             	mov    0x10(%ebp),%eax
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	ff 75 f4             	pushl  -0xc(%ebp)
  800798:	50                   	push   %eax
  800799:	e8 24 02 00 00       	call   8009c2 <vcprintf>
  80079e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	6a 00                	push   $0x0
  8007a6:	68 80 40 80 00       	push   $0x804080
  8007ab:	e8 12 02 00 00       	call   8009c2 <vcprintf>
  8007b0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007b3:	e8 7d ff ff ff       	call   800735 <exit>

	// should not return here
	while (1) ;
  8007b8:	eb fe                	jmp    8007b8 <_panic+0x75>

008007ba <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	53                   	push   %ebx
  8007be:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007c1:	a1 24 50 80 00       	mov    0x805024,%eax
  8007c6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8007cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cf:	39 c2                	cmp    %eax,%edx
  8007d1:	74 14                	je     8007e7 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007d3:	83 ec 04             	sub    $0x4,%esp
  8007d6:	68 84 40 80 00       	push   $0x804084
  8007db:	6a 26                	push   $0x26
  8007dd:	68 d0 40 80 00       	push   $0x8040d0
  8007e2:	e8 5c ff ff ff       	call   800743 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007f5:	e9 d9 00 00 00       	jmp    8008d3 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8007fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	01 d0                	add    %edx,%eax
  800809:	8b 00                	mov    (%eax),%eax
  80080b:	85 c0                	test   %eax,%eax
  80080d:	75 08                	jne    800817 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80080f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800812:	e9 b9 00 00 00       	jmp    8008d0 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800817:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80081e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800825:	eb 79                	jmp    8008a0 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800827:	a1 24 50 80 00       	mov    0x805024,%eax
  80082c:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800832:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800835:	89 d0                	mov    %edx,%eax
  800837:	01 c0                	add    %eax,%eax
  800839:	01 d0                	add    %edx,%eax
  80083b:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800842:	01 d8                	add    %ebx,%eax
  800844:	01 d0                	add    %edx,%eax
  800846:	01 c8                	add    %ecx,%eax
  800848:	8a 40 04             	mov    0x4(%eax),%al
  80084b:	84 c0                	test   %al,%al
  80084d:	75 4e                	jne    80089d <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80084f:	a1 24 50 80 00       	mov    0x805024,%eax
  800854:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80085a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80085d:	89 d0                	mov    %edx,%eax
  80085f:	01 c0                	add    %eax,%eax
  800861:	01 d0                	add    %edx,%eax
  800863:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80086a:	01 d8                	add    %ebx,%eax
  80086c:	01 d0                	add    %edx,%eax
  80086e:	01 c8                	add    %ecx,%eax
  800870:	8b 00                	mov    (%eax),%eax
  800872:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800875:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800878:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80087f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800882:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	01 c8                	add    %ecx,%eax
  80088e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800890:	39 c2                	cmp    %eax,%edx
  800892:	75 09                	jne    80089d <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800894:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80089b:	eb 19                	jmp    8008b6 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089d:	ff 45 e8             	incl   -0x18(%ebp)
  8008a0:	a1 24 50 80 00       	mov    0x805024,%eax
  8008a5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008ae:	39 c2                	cmp    %eax,%edx
  8008b0:	0f 87 71 ff ff ff    	ja     800827 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008ba:	75 14                	jne    8008d0 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8008bc:	83 ec 04             	sub    $0x4,%esp
  8008bf:	68 dc 40 80 00       	push   $0x8040dc
  8008c4:	6a 3a                	push   $0x3a
  8008c6:	68 d0 40 80 00       	push   $0x8040d0
  8008cb:	e8 73 fe ff ff       	call   800743 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008d0:	ff 45 f0             	incl   -0x10(%ebp)
  8008d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008d9:	0f 8c 1b ff ff ff    	jl     8007fa <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008e6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008ed:	eb 2e                	jmp    80091d <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008ef:	a1 24 50 80 00       	mov    0x805024,%eax
  8008f4:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8008fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008fd:	89 d0                	mov    %edx,%eax
  8008ff:	01 c0                	add    %eax,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80090a:	01 d8                	add    %ebx,%eax
  80090c:	01 d0                	add    %edx,%eax
  80090e:	01 c8                	add    %ecx,%eax
  800910:	8a 40 04             	mov    0x4(%eax),%al
  800913:	3c 01                	cmp    $0x1,%al
  800915:	75 03                	jne    80091a <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800917:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80091a:	ff 45 e0             	incl   -0x20(%ebp)
  80091d:	a1 24 50 80 00       	mov    0x805024,%eax
  800922:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800928:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092b:	39 c2                	cmp    %eax,%edx
  80092d:	77 c0                	ja     8008ef <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80092f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800932:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800935:	74 14                	je     80094b <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800937:	83 ec 04             	sub    $0x4,%esp
  80093a:	68 30 41 80 00       	push   $0x804130
  80093f:	6a 44                	push   $0x44
  800941:	68 d0 40 80 00       	push   $0x8040d0
  800946:	e8 f8 fd ff ff       	call   800743 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80094b:	90                   	nop
  80094c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80094f:	c9                   	leave  
  800950:	c3                   	ret    

00800951 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	53                   	push   %ebx
  800955:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	8d 48 01             	lea    0x1(%eax),%ecx
  800960:	8b 55 0c             	mov    0xc(%ebp),%edx
  800963:	89 0a                	mov    %ecx,(%edx)
  800965:	8b 55 08             	mov    0x8(%ebp),%edx
  800968:	88 d1                	mov    %dl,%cl
  80096a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800971:	8b 45 0c             	mov    0xc(%ebp),%eax
  800974:	8b 00                	mov    (%eax),%eax
  800976:	3d ff 00 00 00       	cmp    $0xff,%eax
  80097b:	75 30                	jne    8009ad <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80097d:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800983:	a0 44 50 80 00       	mov    0x805044,%al
  800988:	0f b6 c0             	movzbl %al,%eax
  80098b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098e:	8b 09                	mov    (%ecx),%ecx
  800990:	89 cb                	mov    %ecx,%ebx
  800992:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800995:	83 c1 08             	add    $0x8,%ecx
  800998:	52                   	push   %edx
  800999:	50                   	push   %eax
  80099a:	53                   	push   %ebx
  80099b:	51                   	push   %ecx
  80099c:	e8 b0 1e 00 00       	call   802851 <sys_cputs>
  8009a1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b0:	8b 40 04             	mov    0x4(%eax),%eax
  8009b3:	8d 50 01             	lea    0x1(%eax),%edx
  8009b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009bc:	90                   	nop
  8009bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009c0:	c9                   	leave  
  8009c1:	c3                   	ret    

008009c2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009cb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009d2:	00 00 00 
	b.cnt = 0;
  8009d5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009dc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	ff 75 08             	pushl  0x8(%ebp)
  8009e5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009eb:	50                   	push   %eax
  8009ec:	68 51 09 80 00       	push   $0x800951
  8009f1:	e8 5a 02 00 00       	call   800c50 <vprintfmt>
  8009f6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8009f9:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8009ff:	a0 44 50 80 00       	mov    0x805044,%al
  800a04:	0f b6 c0             	movzbl %al,%eax
  800a07:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a0d:	52                   	push   %edx
  800a0e:	50                   	push   %eax
  800a0f:	51                   	push   %ecx
  800a10:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a16:	83 c0 08             	add    $0x8,%eax
  800a19:	50                   	push   %eax
  800a1a:	e8 32 1e 00 00       	call   802851 <sys_cputs>
  800a1f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a22:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800a29:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a2f:	c9                   	leave  
  800a30:	c3                   	ret    

00800a31 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a37:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800a3e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a41:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a4d:	50                   	push   %eax
  800a4e:	e8 6f ff ff ff       	call   8009c2 <vcprintf>
  800a53:	83 c4 10             	add    $0x10,%esp
  800a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a5c:	c9                   	leave  
  800a5d:	c3                   	ret    

00800a5e <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
  800a61:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a64:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	c1 e0 08             	shl    $0x8,%eax
  800a71:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800a76:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a79:	83 c0 04             	add    $0x4,%eax
  800a7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 f4             	pushl  -0xc(%ebp)
  800a88:	50                   	push   %eax
  800a89:	e8 34 ff ff ff       	call   8009c2 <vcprintf>
  800a8e:	83 c4 10             	add    $0x10,%esp
  800a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800a94:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800a9b:	07 00 00 

	return cnt;
  800a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa1:	c9                   	leave  
  800aa2:	c3                   	ret    

00800aa3 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800aa9:	e8 e7 1d 00 00       	call   802895 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800aae:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ab1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 f4             	pushl  -0xc(%ebp)
  800abd:	50                   	push   %eax
  800abe:	e8 ff fe ff ff       	call   8009c2 <vcprintf>
  800ac3:	83 c4 10             	add    $0x10,%esp
  800ac6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800ac9:	e8 e1 1d 00 00       	call   8028af <sys_unlock_cons>
	return cnt;
  800ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    

00800ad3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	53                   	push   %ebx
  800ad7:	83 ec 14             	sub    $0x14,%esp
  800ada:	8b 45 10             	mov    0x10(%ebp),%eax
  800add:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ae6:	8b 45 18             	mov    0x18(%ebp),%eax
  800ae9:	ba 00 00 00 00       	mov    $0x0,%edx
  800aee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800af1:	77 55                	ja     800b48 <printnum+0x75>
  800af3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800af6:	72 05                	jb     800afd <printnum+0x2a>
  800af8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800afb:	77 4b                	ja     800b48 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800afd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b00:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b03:	8b 45 18             	mov    0x18(%ebp),%eax
  800b06:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0b:	52                   	push   %edx
  800b0c:	50                   	push   %eax
  800b0d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b10:	ff 75 f0             	pushl  -0x10(%ebp)
  800b13:	e8 dc 2f 00 00       	call   803af4 <__udivdi3>
  800b18:	83 c4 10             	add    $0x10,%esp
  800b1b:	83 ec 04             	sub    $0x4,%esp
  800b1e:	ff 75 20             	pushl  0x20(%ebp)
  800b21:	53                   	push   %ebx
  800b22:	ff 75 18             	pushl  0x18(%ebp)
  800b25:	52                   	push   %edx
  800b26:	50                   	push   %eax
  800b27:	ff 75 0c             	pushl  0xc(%ebp)
  800b2a:	ff 75 08             	pushl  0x8(%ebp)
  800b2d:	e8 a1 ff ff ff       	call   800ad3 <printnum>
  800b32:	83 c4 20             	add    $0x20,%esp
  800b35:	eb 1a                	jmp    800b51 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	ff 75 0c             	pushl  0xc(%ebp)
  800b3d:	ff 75 20             	pushl  0x20(%ebp)
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	ff d0                	call   *%eax
  800b45:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b48:	ff 4d 1c             	decl   0x1c(%ebp)
  800b4b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b4f:	7f e6                	jg     800b37 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b51:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5f:	53                   	push   %ebx
  800b60:	51                   	push   %ecx
  800b61:	52                   	push   %edx
  800b62:	50                   	push   %eax
  800b63:	e8 9c 30 00 00       	call   803c04 <__umoddi3>
  800b68:	83 c4 10             	add    $0x10,%esp
  800b6b:	05 94 43 80 00       	add    $0x804394,%eax
  800b70:	8a 00                	mov    (%eax),%al
  800b72:	0f be c0             	movsbl %al,%eax
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	50                   	push   %eax
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	ff d0                	call   *%eax
  800b81:	83 c4 10             	add    $0x10,%esp
}
  800b84:	90                   	nop
  800b85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b88:	c9                   	leave  
  800b89:	c3                   	ret    

00800b8a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b8d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b91:	7e 1c                	jle    800baf <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	8b 00                	mov    (%eax),%eax
  800b98:	8d 50 08             	lea    0x8(%eax),%edx
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	89 10                	mov    %edx,(%eax)
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	8b 00                	mov    (%eax),%eax
  800ba5:	83 e8 08             	sub    $0x8,%eax
  800ba8:	8b 50 04             	mov    0x4(%eax),%edx
  800bab:	8b 00                	mov    (%eax),%eax
  800bad:	eb 40                	jmp    800bef <getuint+0x65>
	else if (lflag)
  800baf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb3:	74 1e                	je     800bd3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	8b 00                	mov    (%eax),%eax
  800bba:	8d 50 04             	lea    0x4(%eax),%edx
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	89 10                	mov    %edx,(%eax)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8b 00                	mov    (%eax),%eax
  800bc7:	83 e8 04             	sub    $0x4,%eax
  800bca:	8b 00                	mov    (%eax),%eax
  800bcc:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd1:	eb 1c                	jmp    800bef <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8b 00                	mov    (%eax),%eax
  800bd8:	8d 50 04             	lea    0x4(%eax),%edx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	89 10                	mov    %edx,(%eax)
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	83 e8 04             	sub    $0x4,%eax
  800be8:	8b 00                	mov    (%eax),%eax
  800bea:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    

00800bf1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bf4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bf8:	7e 1c                	jle    800c16 <getint+0x25>
		return va_arg(*ap, long long);
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	8b 00                	mov    (%eax),%eax
  800bff:	8d 50 08             	lea    0x8(%eax),%edx
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	89 10                	mov    %edx,(%eax)
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8b 00                	mov    (%eax),%eax
  800c0c:	83 e8 08             	sub    $0x8,%eax
  800c0f:	8b 50 04             	mov    0x4(%eax),%edx
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	eb 38                	jmp    800c4e <getint+0x5d>
	else if (lflag)
  800c16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1a:	74 1a                	je     800c36 <getint+0x45>
		return va_arg(*ap, long);
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8b 00                	mov    (%eax),%eax
  800c21:	8d 50 04             	lea    0x4(%eax),%edx
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	89 10                	mov    %edx,(%eax)
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8b 00                	mov    (%eax),%eax
  800c2e:	83 e8 04             	sub    $0x4,%eax
  800c31:	8b 00                	mov    (%eax),%eax
  800c33:	99                   	cltd   
  800c34:	eb 18                	jmp    800c4e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	8b 00                	mov    (%eax),%eax
  800c3b:	8d 50 04             	lea    0x4(%eax),%edx
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	89 10                	mov    %edx,(%eax)
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	8b 00                	mov    (%eax),%eax
  800c48:	83 e8 04             	sub    $0x4,%eax
  800c4b:	8b 00                	mov    (%eax),%eax
  800c4d:	99                   	cltd   
}
  800c4e:	5d                   	pop    %ebp
  800c4f:	c3                   	ret    

00800c50 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
  800c55:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c58:	eb 17                	jmp    800c71 <vprintfmt+0x21>
			if (ch == '\0')
  800c5a:	85 db                	test   %ebx,%ebx
  800c5c:	0f 84 c1 03 00 00    	je     801023 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c62:	83 ec 08             	sub    $0x8,%esp
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	53                   	push   %ebx
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	ff d0                	call   *%eax
  800c6e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c71:	8b 45 10             	mov    0x10(%ebp),%eax
  800c74:	8d 50 01             	lea    0x1(%eax),%edx
  800c77:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7a:	8a 00                	mov    (%eax),%al
  800c7c:	0f b6 d8             	movzbl %al,%ebx
  800c7f:	83 fb 25             	cmp    $0x25,%ebx
  800c82:	75 d6                	jne    800c5a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c84:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c88:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c8f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c96:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c9d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ca4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca7:	8d 50 01             	lea    0x1(%eax),%edx
  800caa:	89 55 10             	mov    %edx,0x10(%ebp)
  800cad:	8a 00                	mov    (%eax),%al
  800caf:	0f b6 d8             	movzbl %al,%ebx
  800cb2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cb5:	83 f8 5b             	cmp    $0x5b,%eax
  800cb8:	0f 87 3d 03 00 00    	ja     800ffb <vprintfmt+0x3ab>
  800cbe:	8b 04 85 b8 43 80 00 	mov    0x8043b8(,%eax,4),%eax
  800cc5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cc7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ccb:	eb d7                	jmp    800ca4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ccd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cd1:	eb d1                	jmp    800ca4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cd3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cda:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cdd:	89 d0                	mov    %edx,%eax
  800cdf:	c1 e0 02             	shl    $0x2,%eax
  800ce2:	01 d0                	add    %edx,%eax
  800ce4:	01 c0                	add    %eax,%eax
  800ce6:	01 d8                	add    %ebx,%eax
  800ce8:	83 e8 30             	sub    $0x30,%eax
  800ceb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cee:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cf6:	83 fb 2f             	cmp    $0x2f,%ebx
  800cf9:	7e 3e                	jle    800d39 <vprintfmt+0xe9>
  800cfb:	83 fb 39             	cmp    $0x39,%ebx
  800cfe:	7f 39                	jg     800d39 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d00:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d03:	eb d5                	jmp    800cda <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d05:	8b 45 14             	mov    0x14(%ebp),%eax
  800d08:	83 c0 04             	add    $0x4,%eax
  800d0b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d11:	83 e8 04             	sub    $0x4,%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d19:	eb 1f                	jmp    800d3a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d1f:	79 83                	jns    800ca4 <vprintfmt+0x54>
				width = 0;
  800d21:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d28:	e9 77 ff ff ff       	jmp    800ca4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d2d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d34:	e9 6b ff ff ff       	jmp    800ca4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d39:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d3e:	0f 89 60 ff ff ff    	jns    800ca4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d4a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d51:	e9 4e ff ff ff       	jmp    800ca4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d56:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d59:	e9 46 ff ff ff       	jmp    800ca4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d61:	83 c0 04             	add    $0x4,%eax
  800d64:	89 45 14             	mov    %eax,0x14(%ebp)
  800d67:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6a:	83 e8 04             	sub    $0x4,%eax
  800d6d:	8b 00                	mov    (%eax),%eax
  800d6f:	83 ec 08             	sub    $0x8,%esp
  800d72:	ff 75 0c             	pushl  0xc(%ebp)
  800d75:	50                   	push   %eax
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	ff d0                	call   *%eax
  800d7b:	83 c4 10             	add    $0x10,%esp
			break;
  800d7e:	e9 9b 02 00 00       	jmp    80101e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d83:	8b 45 14             	mov    0x14(%ebp),%eax
  800d86:	83 c0 04             	add    $0x4,%eax
  800d89:	89 45 14             	mov    %eax,0x14(%ebp)
  800d8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8f:	83 e8 04             	sub    $0x4,%eax
  800d92:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d94:	85 db                	test   %ebx,%ebx
  800d96:	79 02                	jns    800d9a <vprintfmt+0x14a>
				err = -err;
  800d98:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d9a:	83 fb 64             	cmp    $0x64,%ebx
  800d9d:	7f 0b                	jg     800daa <vprintfmt+0x15a>
  800d9f:	8b 34 9d 00 42 80 00 	mov    0x804200(,%ebx,4),%esi
  800da6:	85 f6                	test   %esi,%esi
  800da8:	75 19                	jne    800dc3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800daa:	53                   	push   %ebx
  800dab:	68 a5 43 80 00       	push   $0x8043a5
  800db0:	ff 75 0c             	pushl  0xc(%ebp)
  800db3:	ff 75 08             	pushl  0x8(%ebp)
  800db6:	e8 70 02 00 00       	call   80102b <printfmt>
  800dbb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dbe:	e9 5b 02 00 00       	jmp    80101e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dc3:	56                   	push   %esi
  800dc4:	68 ae 43 80 00       	push   $0x8043ae
  800dc9:	ff 75 0c             	pushl  0xc(%ebp)
  800dcc:	ff 75 08             	pushl  0x8(%ebp)
  800dcf:	e8 57 02 00 00       	call   80102b <printfmt>
  800dd4:	83 c4 10             	add    $0x10,%esp
			break;
  800dd7:	e9 42 02 00 00       	jmp    80101e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ddc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddf:	83 c0 04             	add    $0x4,%eax
  800de2:	89 45 14             	mov    %eax,0x14(%ebp)
  800de5:	8b 45 14             	mov    0x14(%ebp),%eax
  800de8:	83 e8 04             	sub    $0x4,%eax
  800deb:	8b 30                	mov    (%eax),%esi
  800ded:	85 f6                	test   %esi,%esi
  800def:	75 05                	jne    800df6 <vprintfmt+0x1a6>
				p = "(null)";
  800df1:	be b1 43 80 00       	mov    $0x8043b1,%esi
			if (width > 0 && padc != '-')
  800df6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfa:	7e 6d                	jle    800e69 <vprintfmt+0x219>
  800dfc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e00:	74 67                	je     800e69 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e05:	83 ec 08             	sub    $0x8,%esp
  800e08:	50                   	push   %eax
  800e09:	56                   	push   %esi
  800e0a:	e8 26 05 00 00       	call   801335 <strnlen>
  800e0f:	83 c4 10             	add    $0x10,%esp
  800e12:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e15:	eb 16                	jmp    800e2d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e17:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e1b:	83 ec 08             	sub    $0x8,%esp
  800e1e:	ff 75 0c             	pushl  0xc(%ebp)
  800e21:	50                   	push   %eax
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	ff d0                	call   *%eax
  800e27:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e2a:	ff 4d e4             	decl   -0x1c(%ebp)
  800e2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e31:	7f e4                	jg     800e17 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e33:	eb 34                	jmp    800e69 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e35:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e39:	74 1c                	je     800e57 <vprintfmt+0x207>
  800e3b:	83 fb 1f             	cmp    $0x1f,%ebx
  800e3e:	7e 05                	jle    800e45 <vprintfmt+0x1f5>
  800e40:	83 fb 7e             	cmp    $0x7e,%ebx
  800e43:	7e 12                	jle    800e57 <vprintfmt+0x207>
					putch('?', putdat);
  800e45:	83 ec 08             	sub    $0x8,%esp
  800e48:	ff 75 0c             	pushl  0xc(%ebp)
  800e4b:	6a 3f                	push   $0x3f
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	ff d0                	call   *%eax
  800e52:	83 c4 10             	add    $0x10,%esp
  800e55:	eb 0f                	jmp    800e66 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e57:	83 ec 08             	sub    $0x8,%esp
  800e5a:	ff 75 0c             	pushl  0xc(%ebp)
  800e5d:	53                   	push   %ebx
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	ff d0                	call   *%eax
  800e63:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e66:	ff 4d e4             	decl   -0x1c(%ebp)
  800e69:	89 f0                	mov    %esi,%eax
  800e6b:	8d 70 01             	lea    0x1(%eax),%esi
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	0f be d8             	movsbl %al,%ebx
  800e73:	85 db                	test   %ebx,%ebx
  800e75:	74 24                	je     800e9b <vprintfmt+0x24b>
  800e77:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e7b:	78 b8                	js     800e35 <vprintfmt+0x1e5>
  800e7d:	ff 4d e0             	decl   -0x20(%ebp)
  800e80:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e84:	79 af                	jns    800e35 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e86:	eb 13                	jmp    800e9b <vprintfmt+0x24b>
				putch(' ', putdat);
  800e88:	83 ec 08             	sub    $0x8,%esp
  800e8b:	ff 75 0c             	pushl  0xc(%ebp)
  800e8e:	6a 20                	push   $0x20
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	ff d0                	call   *%eax
  800e95:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e98:	ff 4d e4             	decl   -0x1c(%ebp)
  800e9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e9f:	7f e7                	jg     800e88 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ea1:	e9 78 01 00 00       	jmp    80101e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ea6:	83 ec 08             	sub    $0x8,%esp
  800ea9:	ff 75 e8             	pushl  -0x18(%ebp)
  800eac:	8d 45 14             	lea    0x14(%ebp),%eax
  800eaf:	50                   	push   %eax
  800eb0:	e8 3c fd ff ff       	call   800bf1 <getint>
  800eb5:	83 c4 10             	add    $0x10,%esp
  800eb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ebb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec4:	85 d2                	test   %edx,%edx
  800ec6:	79 23                	jns    800eeb <vprintfmt+0x29b>
				putch('-', putdat);
  800ec8:	83 ec 08             	sub    $0x8,%esp
  800ecb:	ff 75 0c             	pushl  0xc(%ebp)
  800ece:	6a 2d                	push   $0x2d
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	ff d0                	call   *%eax
  800ed5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800edb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ede:	f7 d8                	neg    %eax
  800ee0:	83 d2 00             	adc    $0x0,%edx
  800ee3:	f7 da                	neg    %edx
  800ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800eeb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ef2:	e9 bc 00 00 00       	jmp    800fb3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 e8             	pushl  -0x18(%ebp)
  800efd:	8d 45 14             	lea    0x14(%ebp),%eax
  800f00:	50                   	push   %eax
  800f01:	e8 84 fc ff ff       	call   800b8a <getuint>
  800f06:	83 c4 10             	add    $0x10,%esp
  800f09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f0f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f16:	e9 98 00 00 00       	jmp    800fb3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f1b:	83 ec 08             	sub    $0x8,%esp
  800f1e:	ff 75 0c             	pushl  0xc(%ebp)
  800f21:	6a 58                	push   $0x58
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	ff d0                	call   *%eax
  800f28:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	ff 75 0c             	pushl  0xc(%ebp)
  800f31:	6a 58                	push   $0x58
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	ff d0                	call   *%eax
  800f38:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f3b:	83 ec 08             	sub    $0x8,%esp
  800f3e:	ff 75 0c             	pushl  0xc(%ebp)
  800f41:	6a 58                	push   $0x58
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	ff d0                	call   *%eax
  800f48:	83 c4 10             	add    $0x10,%esp
			break;
  800f4b:	e9 ce 00 00 00       	jmp    80101e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f50:	83 ec 08             	sub    $0x8,%esp
  800f53:	ff 75 0c             	pushl  0xc(%ebp)
  800f56:	6a 30                	push   $0x30
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	ff d0                	call   *%eax
  800f5d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f60:	83 ec 08             	sub    $0x8,%esp
  800f63:	ff 75 0c             	pushl  0xc(%ebp)
  800f66:	6a 78                	push   $0x78
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	ff d0                	call   *%eax
  800f6d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f70:	8b 45 14             	mov    0x14(%ebp),%eax
  800f73:	83 c0 04             	add    $0x4,%eax
  800f76:	89 45 14             	mov    %eax,0x14(%ebp)
  800f79:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7c:	83 e8 04             	sub    $0x4,%eax
  800f7f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f8b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f92:	eb 1f                	jmp    800fb3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f94:	83 ec 08             	sub    $0x8,%esp
  800f97:	ff 75 e8             	pushl  -0x18(%ebp)
  800f9a:	8d 45 14             	lea    0x14(%ebp),%eax
  800f9d:	50                   	push   %eax
  800f9e:	e8 e7 fb ff ff       	call   800b8a <getuint>
  800fa3:	83 c4 10             	add    $0x10,%esp
  800fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fac:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fb3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fba:	83 ec 04             	sub    $0x4,%esp
  800fbd:	52                   	push   %edx
  800fbe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fc1:	50                   	push   %eax
  800fc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc5:	ff 75 f0             	pushl  -0x10(%ebp)
  800fc8:	ff 75 0c             	pushl  0xc(%ebp)
  800fcb:	ff 75 08             	pushl  0x8(%ebp)
  800fce:	e8 00 fb ff ff       	call   800ad3 <printnum>
  800fd3:	83 c4 20             	add    $0x20,%esp
			break;
  800fd6:	eb 46                	jmp    80101e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fd8:	83 ec 08             	sub    $0x8,%esp
  800fdb:	ff 75 0c             	pushl  0xc(%ebp)
  800fde:	53                   	push   %ebx
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	ff d0                	call   *%eax
  800fe4:	83 c4 10             	add    $0x10,%esp
			break;
  800fe7:	eb 35                	jmp    80101e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800fe9:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800ff0:	eb 2c                	jmp    80101e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ff2:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800ff9:	eb 23                	jmp    80101e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ffb:	83 ec 08             	sub    $0x8,%esp
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	6a 25                	push   $0x25
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	ff d0                	call   *%eax
  801008:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80100b:	ff 4d 10             	decl   0x10(%ebp)
  80100e:	eb 03                	jmp    801013 <vprintfmt+0x3c3>
  801010:	ff 4d 10             	decl   0x10(%ebp)
  801013:	8b 45 10             	mov    0x10(%ebp),%eax
  801016:	48                   	dec    %eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	3c 25                	cmp    $0x25,%al
  80101b:	75 f3                	jne    801010 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80101d:	90                   	nop
		}
	}
  80101e:	e9 35 fc ff ff       	jmp    800c58 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801023:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801024:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801027:	5b                   	pop    %ebx
  801028:	5e                   	pop    %esi
  801029:	5d                   	pop    %ebp
  80102a:	c3                   	ret    

0080102b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801031:	8d 45 10             	lea    0x10(%ebp),%eax
  801034:	83 c0 04             	add    $0x4,%eax
  801037:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80103a:	8b 45 10             	mov    0x10(%ebp),%eax
  80103d:	ff 75 f4             	pushl  -0xc(%ebp)
  801040:	50                   	push   %eax
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	ff 75 08             	pushl  0x8(%ebp)
  801047:	e8 04 fc ff ff       	call   800c50 <vprintfmt>
  80104c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80104f:	90                   	nop
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801055:	8b 45 0c             	mov    0xc(%ebp),%eax
  801058:	8b 40 08             	mov    0x8(%eax),%eax
  80105b:	8d 50 01             	lea    0x1(%eax),%edx
  80105e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801061:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801064:	8b 45 0c             	mov    0xc(%ebp),%eax
  801067:	8b 10                	mov    (%eax),%edx
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	8b 40 04             	mov    0x4(%eax),%eax
  80106f:	39 c2                	cmp    %eax,%edx
  801071:	73 12                	jae    801085 <sprintputch+0x33>
		*b->buf++ = ch;
  801073:	8b 45 0c             	mov    0xc(%ebp),%eax
  801076:	8b 00                	mov    (%eax),%eax
  801078:	8d 48 01             	lea    0x1(%eax),%ecx
  80107b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107e:	89 0a                	mov    %ecx,(%edx)
  801080:	8b 55 08             	mov    0x8(%ebp),%edx
  801083:	88 10                	mov    %dl,(%eax)
}
  801085:	90                   	nop
  801086:	5d                   	pop    %ebp
  801087:	c3                   	ret    

00801088 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801094:	8b 45 0c             	mov    0xc(%ebp),%eax
  801097:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	01 d0                	add    %edx,%eax
  80109f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ad:	74 06                	je     8010b5 <vsnprintf+0x2d>
  8010af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010b3:	7f 07                	jg     8010bc <vsnprintf+0x34>
		return -E_INVAL;
  8010b5:	b8 03 00 00 00       	mov    $0x3,%eax
  8010ba:	eb 20                	jmp    8010dc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010bc:	ff 75 14             	pushl  0x14(%ebp)
  8010bf:	ff 75 10             	pushl  0x10(%ebp)
  8010c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010c5:	50                   	push   %eax
  8010c6:	68 52 10 80 00       	push   $0x801052
  8010cb:	e8 80 fb ff ff       	call   800c50 <vprintfmt>
  8010d0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010d6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

008010de <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010e4:	8d 45 10             	lea    0x10(%ebp),%eax
  8010e7:	83 c0 04             	add    $0x4,%eax
  8010ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f3:	50                   	push   %eax
  8010f4:	ff 75 0c             	pushl  0xc(%ebp)
  8010f7:	ff 75 08             	pushl  0x8(%ebp)
  8010fa:	e8 89 ff ff ff       	call   801088 <vsnprintf>
  8010ff:	83 c4 10             	add    $0x10,%esp
  801102:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801105:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801108:	c9                   	leave  
  801109:	c3                   	ret    

0080110a <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801110:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801114:	74 13                	je     801129 <readline+0x1f>
		cprintf("%s", prompt);
  801116:	83 ec 08             	sub    $0x8,%esp
  801119:	ff 75 08             	pushl  0x8(%ebp)
  80111c:	68 28 45 80 00       	push   $0x804528
  801121:	e8 0b f9 ff ff       	call   800a31 <cprintf>
  801126:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801129:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801130:	83 ec 0c             	sub    $0xc,%esp
  801133:	6a 00                	push   $0x0
  801135:	e8 4f f4 ff ff       	call   800589 <iscons>
  80113a:	83 c4 10             	add    $0x10,%esp
  80113d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801140:	e8 31 f4 ff ff       	call   800576 <getchar>
  801145:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801148:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80114c:	79 22                	jns    801170 <readline+0x66>
			if (c != -E_EOF)
  80114e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801152:	0f 84 ad 00 00 00    	je     801205 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801158:	83 ec 08             	sub    $0x8,%esp
  80115b:	ff 75 ec             	pushl  -0x14(%ebp)
  80115e:	68 2b 45 80 00       	push   $0x80452b
  801163:	e8 c9 f8 ff ff       	call   800a31 <cprintf>
  801168:	83 c4 10             	add    $0x10,%esp
			break;
  80116b:	e9 95 00 00 00       	jmp    801205 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801170:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801174:	7e 34                	jle    8011aa <readline+0xa0>
  801176:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80117d:	7f 2b                	jg     8011aa <readline+0xa0>
			if (echoing)
  80117f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801183:	74 0e                	je     801193 <readline+0x89>
				cputchar(c);
  801185:	83 ec 0c             	sub    $0xc,%esp
  801188:	ff 75 ec             	pushl  -0x14(%ebp)
  80118b:	e8 c7 f3 ff ff       	call   800557 <cputchar>
  801190:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801196:	8d 50 01             	lea    0x1(%eax),%edx
  801199:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80119c:	89 c2                	mov    %eax,%edx
  80119e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a1:	01 d0                	add    %edx,%eax
  8011a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011a6:	88 10                	mov    %dl,(%eax)
  8011a8:	eb 56                	jmp    801200 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8011aa:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8011ae:	75 1f                	jne    8011cf <readline+0xc5>
  8011b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011b4:	7e 19                	jle    8011cf <readline+0xc5>
			if (echoing)
  8011b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011ba:	74 0e                	je     8011ca <readline+0xc0>
				cputchar(c);
  8011bc:	83 ec 0c             	sub    $0xc,%esp
  8011bf:	ff 75 ec             	pushl  -0x14(%ebp)
  8011c2:	e8 90 f3 ff ff       	call   800557 <cputchar>
  8011c7:	83 c4 10             	add    $0x10,%esp

			i--;
  8011ca:	ff 4d f4             	decl   -0xc(%ebp)
  8011cd:	eb 31                	jmp    801200 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8011cf:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8011d3:	74 0a                	je     8011df <readline+0xd5>
  8011d5:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8011d9:	0f 85 61 ff ff ff    	jne    801140 <readline+0x36>
			if (echoing)
  8011df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011e3:	74 0e                	je     8011f3 <readline+0xe9>
				cputchar(c);
  8011e5:	83 ec 0c             	sub    $0xc,%esp
  8011e8:	ff 75 ec             	pushl  -0x14(%ebp)
  8011eb:	e8 67 f3 ff ff       	call   800557 <cputchar>
  8011f0:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f9:	01 d0                	add    %edx,%eax
  8011fb:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8011fe:	eb 06                	jmp    801206 <readline+0xfc>
		}
	}
  801200:	e9 3b ff ff ff       	jmp    801140 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801205:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801206:	90                   	nop
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  80120f:	e8 81 16 00 00       	call   802895 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801214:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801218:	74 13                	je     80122d <atomic_readline+0x24>
			cprintf("%s", prompt);
  80121a:	83 ec 08             	sub    $0x8,%esp
  80121d:	ff 75 08             	pushl  0x8(%ebp)
  801220:	68 28 45 80 00       	push   $0x804528
  801225:	e8 07 f8 ff ff       	call   800a31 <cprintf>
  80122a:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80122d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801234:	83 ec 0c             	sub    $0xc,%esp
  801237:	6a 00                	push   $0x0
  801239:	e8 4b f3 ff ff       	call   800589 <iscons>
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801244:	e8 2d f3 ff ff       	call   800576 <getchar>
  801249:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80124c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801250:	79 22                	jns    801274 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801252:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801256:	0f 84 ad 00 00 00    	je     801309 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  80125c:	83 ec 08             	sub    $0x8,%esp
  80125f:	ff 75 ec             	pushl  -0x14(%ebp)
  801262:	68 2b 45 80 00       	push   $0x80452b
  801267:	e8 c5 f7 ff ff       	call   800a31 <cprintf>
  80126c:	83 c4 10             	add    $0x10,%esp
				break;
  80126f:	e9 95 00 00 00       	jmp    801309 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801274:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801278:	7e 34                	jle    8012ae <atomic_readline+0xa5>
  80127a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801281:	7f 2b                	jg     8012ae <atomic_readline+0xa5>
				if (echoing)
  801283:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801287:	74 0e                	je     801297 <atomic_readline+0x8e>
					cputchar(c);
  801289:	83 ec 0c             	sub    $0xc,%esp
  80128c:	ff 75 ec             	pushl  -0x14(%ebp)
  80128f:	e8 c3 f2 ff ff       	call   800557 <cputchar>
  801294:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80129a:	8d 50 01             	lea    0x1(%eax),%edx
  80129d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012a0:	89 c2                	mov    %eax,%edx
  8012a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a5:	01 d0                	add    %edx,%eax
  8012a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012aa:	88 10                	mov    %dl,(%eax)
  8012ac:	eb 56                	jmp    801304 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  8012ae:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012b2:	75 1f                	jne    8012d3 <atomic_readline+0xca>
  8012b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012b8:	7e 19                	jle    8012d3 <atomic_readline+0xca>
				if (echoing)
  8012ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012be:	74 0e                	je     8012ce <atomic_readline+0xc5>
					cputchar(c);
  8012c0:	83 ec 0c             	sub    $0xc,%esp
  8012c3:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c6:	e8 8c f2 ff ff       	call   800557 <cputchar>
  8012cb:	83 c4 10             	add    $0x10,%esp
				i--;
  8012ce:	ff 4d f4             	decl   -0xc(%ebp)
  8012d1:	eb 31                	jmp    801304 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8012d3:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012d7:	74 0a                	je     8012e3 <atomic_readline+0xda>
  8012d9:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012dd:	0f 85 61 ff ff ff    	jne    801244 <atomic_readline+0x3b>
				if (echoing)
  8012e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e7:	74 0e                	je     8012f7 <atomic_readline+0xee>
					cputchar(c);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ef:	e8 63 f2 ff ff       	call   800557 <cputchar>
  8012f4:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8012f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fd:	01 d0                	add    %edx,%eax
  8012ff:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801302:	eb 06                	jmp    80130a <atomic_readline+0x101>
			}
		}
  801304:	e9 3b ff ff ff       	jmp    801244 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801309:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80130a:	e8 a0 15 00 00       	call   8028af <sys_unlock_cons>
}
  80130f:	90                   	nop
  801310:	c9                   	leave  
  801311:	c3                   	ret    

00801312 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801318:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80131f:	eb 06                	jmp    801327 <strlen+0x15>
		n++;
  801321:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801324:	ff 45 08             	incl   0x8(%ebp)
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	84 c0                	test   %al,%al
  80132e:	75 f1                	jne    801321 <strlen+0xf>
		n++;
	return n;
  801330:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80133b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801342:	eb 09                	jmp    80134d <strnlen+0x18>
		n++;
  801344:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801347:	ff 45 08             	incl   0x8(%ebp)
  80134a:	ff 4d 0c             	decl   0xc(%ebp)
  80134d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801351:	74 09                	je     80135c <strnlen+0x27>
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	84 c0                	test   %al,%al
  80135a:	75 e8                	jne    801344 <strnlen+0xf>
		n++;
	return n;
  80135c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80136d:	90                   	nop
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	8d 50 01             	lea    0x1(%eax),%edx
  801374:	89 55 08             	mov    %edx,0x8(%ebp)
  801377:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80137d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801380:	8a 12                	mov    (%edx),%dl
  801382:	88 10                	mov    %dl,(%eax)
  801384:	8a 00                	mov    (%eax),%al
  801386:	84 c0                	test   %al,%al
  801388:	75 e4                	jne    80136e <strcpy+0xd>
		/* do nothing */;
	return ret;
  80138a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80139b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a2:	eb 1f                	jmp    8013c3 <strncpy+0x34>
		*dst++ = *src;
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	8d 50 01             	lea    0x1(%eax),%edx
  8013aa:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b0:	8a 12                	mov    (%edx),%dl
  8013b2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	8a 00                	mov    (%eax),%al
  8013b9:	84 c0                	test   %al,%al
  8013bb:	74 03                	je     8013c0 <strncpy+0x31>
			src++;
  8013bd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013c0:	ff 45 fc             	incl   -0x4(%ebp)
  8013c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013c9:	72 d9                	jb     8013a4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e0:	74 30                	je     801412 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013e2:	eb 16                	jmp    8013fa <strlcpy+0x2a>
			*dst++ = *src++;
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ea:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013f3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013f6:	8a 12                	mov    (%edx),%dl
  8013f8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013fa:	ff 4d 10             	decl   0x10(%ebp)
  8013fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801401:	74 09                	je     80140c <strlcpy+0x3c>
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	84 c0                	test   %al,%al
  80140a:	75 d8                	jne    8013e4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801412:	8b 55 08             	mov    0x8(%ebp),%edx
  801415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801418:	29 c2                	sub    %eax,%edx
  80141a:	89 d0                	mov    %edx,%eax
}
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801421:	eb 06                	jmp    801429 <strcmp+0xb>
		p++, q++;
  801423:	ff 45 08             	incl   0x8(%ebp)
  801426:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	84 c0                	test   %al,%al
  801430:	74 0e                	je     801440 <strcmp+0x22>
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 10                	mov    (%eax),%dl
  801437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	38 c2                	cmp    %al,%dl
  80143e:	74 e3                	je     801423 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	0f b6 d0             	movzbl %al,%edx
  801448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	0f b6 c0             	movzbl %al,%eax
  801450:	29 c2                	sub    %eax,%edx
  801452:	89 d0                	mov    %edx,%eax
}
  801454:	5d                   	pop    %ebp
  801455:	c3                   	ret    

00801456 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801459:	eb 09                	jmp    801464 <strncmp+0xe>
		n--, p++, q++;
  80145b:	ff 4d 10             	decl   0x10(%ebp)
  80145e:	ff 45 08             	incl   0x8(%ebp)
  801461:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801464:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801468:	74 17                	je     801481 <strncmp+0x2b>
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	84 c0                	test   %al,%al
  801471:	74 0e                	je     801481 <strncmp+0x2b>
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	8a 10                	mov    (%eax),%dl
  801478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147b:	8a 00                	mov    (%eax),%al
  80147d:	38 c2                	cmp    %al,%dl
  80147f:	74 da                	je     80145b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801481:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801485:	75 07                	jne    80148e <strncmp+0x38>
		return 0;
  801487:	b8 00 00 00 00       	mov    $0x0,%eax
  80148c:	eb 14                	jmp    8014a2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8a 00                	mov    (%eax),%al
  801493:	0f b6 d0             	movzbl %al,%edx
  801496:	8b 45 0c             	mov    0xc(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	0f b6 c0             	movzbl %al,%eax
  80149e:	29 c2                	sub    %eax,%edx
  8014a0:	89 d0                	mov    %edx,%eax
}
  8014a2:	5d                   	pop    %ebp
  8014a3:	c3                   	ret    

008014a4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	83 ec 04             	sub    $0x4,%esp
  8014aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014b0:	eb 12                	jmp    8014c4 <strchr+0x20>
		if (*s == c)
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	8a 00                	mov    (%eax),%al
  8014b7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014ba:	75 05                	jne    8014c1 <strchr+0x1d>
			return (char *) s;
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	eb 11                	jmp    8014d2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014c1:	ff 45 08             	incl   0x8(%ebp)
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	8a 00                	mov    (%eax),%al
  8014c9:	84 c0                	test   %al,%al
  8014cb:	75 e5                	jne    8014b2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    

008014d4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	83 ec 04             	sub    $0x4,%esp
  8014da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014e0:	eb 0d                	jmp    8014ef <strfind+0x1b>
		if (*s == c)
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	8a 00                	mov    (%eax),%al
  8014e7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014ea:	74 0e                	je     8014fa <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014ec:	ff 45 08             	incl   0x8(%ebp)
  8014ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f2:	8a 00                	mov    (%eax),%al
  8014f4:	84 c0                	test   %al,%al
  8014f6:	75 ea                	jne    8014e2 <strfind+0xe>
  8014f8:	eb 01                	jmp    8014fb <strfind+0x27>
		if (*s == c)
			break;
  8014fa:	90                   	nop
	return (char *) s;
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80150c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801510:	76 63                	jbe    801575 <memset+0x75>
		uint64 data_block = c;
  801512:	8b 45 0c             	mov    0xc(%ebp),%eax
  801515:	99                   	cltd   
  801516:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801519:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80151c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801522:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801526:	c1 e0 08             	shl    $0x8,%eax
  801529:	09 45 f0             	or     %eax,-0x10(%ebp)
  80152c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80152f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801535:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801539:	c1 e0 10             	shl    $0x10,%eax
  80153c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80153f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801545:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801548:	89 c2                	mov    %eax,%edx
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
  80154f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801552:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801555:	eb 18                	jmp    80156f <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801557:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80155a:	8d 41 08             	lea    0x8(%ecx),%eax
  80155d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801566:	89 01                	mov    %eax,(%ecx)
  801568:	89 51 04             	mov    %edx,0x4(%ecx)
  80156b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80156f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801573:	77 e2                	ja     801557 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801575:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801579:	74 23                	je     80159e <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80157b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80157e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801581:	eb 0e                	jmp    801591 <memset+0x91>
			*p8++ = (uint8)c;
  801583:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801586:	8d 50 01             	lea    0x1(%eax),%edx
  801589:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80158c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158f:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801591:	8b 45 10             	mov    0x10(%ebp),%eax
  801594:	8d 50 ff             	lea    -0x1(%eax),%edx
  801597:	89 55 10             	mov    %edx,0x10(%ebp)
  80159a:	85 c0                	test   %eax,%eax
  80159c:	75 e5                	jne    801583 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8015b5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015b9:	76 24                	jbe    8015df <memcpy+0x3c>
		while(n >= 8){
  8015bb:	eb 1c                	jmp    8015d9 <memcpy+0x36>
			*d64 = *s64;
  8015bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c0:	8b 50 04             	mov    0x4(%eax),%edx
  8015c3:	8b 00                	mov    (%eax),%eax
  8015c5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015c8:	89 01                	mov    %eax,(%ecx)
  8015ca:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8015cd:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8015d1:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8015d5:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8015d9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015dd:	77 de                	ja     8015bd <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015e3:	74 31                	je     801616 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015f1:	eb 16                	jmp    801609 <memcpy+0x66>
			*d8++ = *s8++;
  8015f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f6:	8d 50 01             	lea    0x1(%eax),%edx
  8015f9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  801602:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801605:	8a 12                	mov    (%edx),%dl
  801607:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801609:	8b 45 10             	mov    0x10(%ebp),%eax
  80160c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80160f:	89 55 10             	mov    %edx,0x10(%ebp)
  801612:	85 c0                	test   %eax,%eax
  801614:	75 dd                	jne    8015f3 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801621:	8b 45 0c             	mov    0xc(%ebp),%eax
  801624:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80162d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801630:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801633:	73 50                	jae    801685 <memmove+0x6a>
  801635:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801638:	8b 45 10             	mov    0x10(%ebp),%eax
  80163b:	01 d0                	add    %edx,%eax
  80163d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801640:	76 43                	jbe    801685 <memmove+0x6a>
		s += n;
  801642:	8b 45 10             	mov    0x10(%ebp),%eax
  801645:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801648:	8b 45 10             	mov    0x10(%ebp),%eax
  80164b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80164e:	eb 10                	jmp    801660 <memmove+0x45>
			*--d = *--s;
  801650:	ff 4d f8             	decl   -0x8(%ebp)
  801653:	ff 4d fc             	decl   -0x4(%ebp)
  801656:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801659:	8a 10                	mov    (%eax),%dl
  80165b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801660:	8b 45 10             	mov    0x10(%ebp),%eax
  801663:	8d 50 ff             	lea    -0x1(%eax),%edx
  801666:	89 55 10             	mov    %edx,0x10(%ebp)
  801669:	85 c0                	test   %eax,%eax
  80166b:	75 e3                	jne    801650 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80166d:	eb 23                	jmp    801692 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801672:	8d 50 01             	lea    0x1(%eax),%edx
  801675:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801678:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801681:	8a 12                	mov    (%edx),%dl
  801683:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801685:	8b 45 10             	mov    0x10(%ebp),%eax
  801688:	8d 50 ff             	lea    -0x1(%eax),%edx
  80168b:	89 55 10             	mov    %edx,0x10(%ebp)
  80168e:	85 c0                	test   %eax,%eax
  801690:	75 dd                	jne    80166f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016a9:	eb 2a                	jmp    8016d5 <memcmp+0x3e>
		if (*s1 != *s2)
  8016ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ae:	8a 10                	mov    (%eax),%dl
  8016b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b3:	8a 00                	mov    (%eax),%al
  8016b5:	38 c2                	cmp    %al,%dl
  8016b7:	74 16                	je     8016cf <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	0f b6 d0             	movzbl %al,%edx
  8016c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c4:	8a 00                	mov    (%eax),%al
  8016c6:	0f b6 c0             	movzbl %al,%eax
  8016c9:	29 c2                	sub    %eax,%edx
  8016cb:	89 d0                	mov    %edx,%eax
  8016cd:	eb 18                	jmp    8016e7 <memcmp+0x50>
		s1++, s2++;
  8016cf:	ff 45 fc             	incl   -0x4(%ebp)
  8016d2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016db:	89 55 10             	mov    %edx,0x10(%ebp)
  8016de:	85 c0                	test   %eax,%eax
  8016e0:	75 c9                	jne    8016ab <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f5:	01 d0                	add    %edx,%eax
  8016f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016fa:	eb 15                	jmp    801711 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	8a 00                	mov    (%eax),%al
  801701:	0f b6 d0             	movzbl %al,%edx
  801704:	8b 45 0c             	mov    0xc(%ebp),%eax
  801707:	0f b6 c0             	movzbl %al,%eax
  80170a:	39 c2                	cmp    %eax,%edx
  80170c:	74 0d                	je     80171b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80170e:	ff 45 08             	incl   0x8(%ebp)
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801717:	72 e3                	jb     8016fc <memfind+0x13>
  801719:	eb 01                	jmp    80171c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80171b:	90                   	nop
	return (void *) s;
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
  801724:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801727:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80172e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801735:	eb 03                	jmp    80173a <strtol+0x19>
		s++;
  801737:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8a 00                	mov    (%eax),%al
  80173f:	3c 20                	cmp    $0x20,%al
  801741:	74 f4                	je     801737 <strtol+0x16>
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	8a 00                	mov    (%eax),%al
  801748:	3c 09                	cmp    $0x9,%al
  80174a:	74 eb                	je     801737 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	8a 00                	mov    (%eax),%al
  801751:	3c 2b                	cmp    $0x2b,%al
  801753:	75 05                	jne    80175a <strtol+0x39>
		s++;
  801755:	ff 45 08             	incl   0x8(%ebp)
  801758:	eb 13                	jmp    80176d <strtol+0x4c>
	else if (*s == '-')
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	8a 00                	mov    (%eax),%al
  80175f:	3c 2d                	cmp    $0x2d,%al
  801761:	75 0a                	jne    80176d <strtol+0x4c>
		s++, neg = 1;
  801763:	ff 45 08             	incl   0x8(%ebp)
  801766:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80176d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801771:	74 06                	je     801779 <strtol+0x58>
  801773:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801777:	75 20                	jne    801799 <strtol+0x78>
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	8a 00                	mov    (%eax),%al
  80177e:	3c 30                	cmp    $0x30,%al
  801780:	75 17                	jne    801799 <strtol+0x78>
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	40                   	inc    %eax
  801786:	8a 00                	mov    (%eax),%al
  801788:	3c 78                	cmp    $0x78,%al
  80178a:	75 0d                	jne    801799 <strtol+0x78>
		s += 2, base = 16;
  80178c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801790:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801797:	eb 28                	jmp    8017c1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801799:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80179d:	75 15                	jne    8017b4 <strtol+0x93>
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	3c 30                	cmp    $0x30,%al
  8017a6:	75 0c                	jne    8017b4 <strtol+0x93>
		s++, base = 8;
  8017a8:	ff 45 08             	incl   0x8(%ebp)
  8017ab:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017b2:	eb 0d                	jmp    8017c1 <strtol+0xa0>
	else if (base == 0)
  8017b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b8:	75 07                	jne    8017c1 <strtol+0xa0>
		base = 10;
  8017ba:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8a 00                	mov    (%eax),%al
  8017c6:	3c 2f                	cmp    $0x2f,%al
  8017c8:	7e 19                	jle    8017e3 <strtol+0xc2>
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	8a 00                	mov    (%eax),%al
  8017cf:	3c 39                	cmp    $0x39,%al
  8017d1:	7f 10                	jg     8017e3 <strtol+0xc2>
			dig = *s - '0';
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	8a 00                	mov    (%eax),%al
  8017d8:	0f be c0             	movsbl %al,%eax
  8017db:	83 e8 30             	sub    $0x30,%eax
  8017de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017e1:	eb 42                	jmp    801825 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	8a 00                	mov    (%eax),%al
  8017e8:	3c 60                	cmp    $0x60,%al
  8017ea:	7e 19                	jle    801805 <strtol+0xe4>
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	8a 00                	mov    (%eax),%al
  8017f1:	3c 7a                	cmp    $0x7a,%al
  8017f3:	7f 10                	jg     801805 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8a 00                	mov    (%eax),%al
  8017fa:	0f be c0             	movsbl %al,%eax
  8017fd:	83 e8 57             	sub    $0x57,%eax
  801800:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801803:	eb 20                	jmp    801825 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	8a 00                	mov    (%eax),%al
  80180a:	3c 40                	cmp    $0x40,%al
  80180c:	7e 39                	jle    801847 <strtol+0x126>
  80180e:	8b 45 08             	mov    0x8(%ebp),%eax
  801811:	8a 00                	mov    (%eax),%al
  801813:	3c 5a                	cmp    $0x5a,%al
  801815:	7f 30                	jg     801847 <strtol+0x126>
			dig = *s - 'A' + 10;
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	8a 00                	mov    (%eax),%al
  80181c:	0f be c0             	movsbl %al,%eax
  80181f:	83 e8 37             	sub    $0x37,%eax
  801822:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801828:	3b 45 10             	cmp    0x10(%ebp),%eax
  80182b:	7d 19                	jge    801846 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80182d:	ff 45 08             	incl   0x8(%ebp)
  801830:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801833:	0f af 45 10          	imul   0x10(%ebp),%eax
  801837:	89 c2                	mov    %eax,%edx
  801839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183c:	01 d0                	add    %edx,%eax
  80183e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801841:	e9 7b ff ff ff       	jmp    8017c1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801846:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801847:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80184b:	74 08                	je     801855 <strtol+0x134>
		*endptr = (char *) s;
  80184d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801850:	8b 55 08             	mov    0x8(%ebp),%edx
  801853:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801855:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801859:	74 07                	je     801862 <strtol+0x141>
  80185b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185e:	f7 d8                	neg    %eax
  801860:	eb 03                	jmp    801865 <strtol+0x144>
  801862:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <ltostr>:

void
ltostr(long value, char *str)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80186d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801874:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80187b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80187f:	79 13                	jns    801894 <ltostr+0x2d>
	{
		neg = 1;
  801881:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80188e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801891:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80189c:	99                   	cltd   
  80189d:	f7 f9                	idiv   %ecx
  80189f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a5:	8d 50 01             	lea    0x1(%eax),%edx
  8018a8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018ab:	89 c2                	mov    %eax,%edx
  8018ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b0:	01 d0                	add    %edx,%eax
  8018b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018b5:	83 c2 30             	add    $0x30,%edx
  8018b8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018bd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018c2:	f7 e9                	imul   %ecx
  8018c4:	c1 fa 02             	sar    $0x2,%edx
  8018c7:	89 c8                	mov    %ecx,%eax
  8018c9:	c1 f8 1f             	sar    $0x1f,%eax
  8018cc:	29 c2                	sub    %eax,%edx
  8018ce:	89 d0                	mov    %edx,%eax
  8018d0:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d7:	75 bb                	jne    801894 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e3:	48                   	dec    %eax
  8018e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018eb:	74 3d                	je     80192a <ltostr+0xc3>
		start = 1 ;
  8018ed:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018f4:	eb 34                	jmp    80192a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fc:	01 d0                	add    %edx,%eax
  8018fe:	8a 00                	mov    (%eax),%al
  801900:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801903:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801906:	8b 45 0c             	mov    0xc(%ebp),%eax
  801909:	01 c2                	add    %eax,%edx
  80190b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80190e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801911:	01 c8                	add    %ecx,%eax
  801913:	8a 00                	mov    (%eax),%al
  801915:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801917:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80191a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191d:	01 c2                	add    %eax,%edx
  80191f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801922:	88 02                	mov    %al,(%edx)
		start++ ;
  801924:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801927:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80192a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801930:	7c c4                	jl     8018f6 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801932:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801935:	8b 45 0c             	mov    0xc(%ebp),%eax
  801938:	01 d0                	add    %edx,%eax
  80193a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80193d:	90                   	nop
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801946:	ff 75 08             	pushl  0x8(%ebp)
  801949:	e8 c4 f9 ff ff       	call   801312 <strlen>
  80194e:	83 c4 04             	add    $0x4,%esp
  801951:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801954:	ff 75 0c             	pushl  0xc(%ebp)
  801957:	e8 b6 f9 ff ff       	call   801312 <strlen>
  80195c:	83 c4 04             	add    $0x4,%esp
  80195f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801962:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801969:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801970:	eb 17                	jmp    801989 <strcconcat+0x49>
		final[s] = str1[s] ;
  801972:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801975:	8b 45 10             	mov    0x10(%ebp),%eax
  801978:	01 c2                	add    %eax,%edx
  80197a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	01 c8                	add    %ecx,%eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801986:	ff 45 fc             	incl   -0x4(%ebp)
  801989:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80198c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80198f:	7c e1                	jl     801972 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801991:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801998:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80199f:	eb 1f                	jmp    8019c0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a4:	8d 50 01             	lea    0x1(%eax),%edx
  8019a7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019aa:	89 c2                	mov    %eax,%edx
  8019ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8019af:	01 c2                	add    %eax,%edx
  8019b1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b7:	01 c8                	add    %ecx,%eax
  8019b9:	8a 00                	mov    (%eax),%al
  8019bb:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019bd:	ff 45 f8             	incl   -0x8(%ebp)
  8019c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019c6:	7c d9                	jl     8019a1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ce:	01 d0                	add    %edx,%eax
  8019d0:	c6 00 00             	movb   $0x0,(%eax)
}
  8019d3:	90                   	nop
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e5:	8b 00                	mov    (%eax),%eax
  8019e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f1:	01 d0                	add    %edx,%eax
  8019f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019f9:	eb 0c                	jmp    801a07 <strsplit+0x31>
			*string++ = 0;
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	8d 50 01             	lea    0x1(%eax),%edx
  801a01:	89 55 08             	mov    %edx,0x8(%ebp)
  801a04:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	8a 00                	mov    (%eax),%al
  801a0c:	84 c0                	test   %al,%al
  801a0e:	74 18                	je     801a28 <strsplit+0x52>
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	8a 00                	mov    (%eax),%al
  801a15:	0f be c0             	movsbl %al,%eax
  801a18:	50                   	push   %eax
  801a19:	ff 75 0c             	pushl  0xc(%ebp)
  801a1c:	e8 83 fa ff ff       	call   8014a4 <strchr>
  801a21:	83 c4 08             	add    $0x8,%esp
  801a24:	85 c0                	test   %eax,%eax
  801a26:	75 d3                	jne    8019fb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	8a 00                	mov    (%eax),%al
  801a2d:	84 c0                	test   %al,%al
  801a2f:	74 5a                	je     801a8b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a31:	8b 45 14             	mov    0x14(%ebp),%eax
  801a34:	8b 00                	mov    (%eax),%eax
  801a36:	83 f8 0f             	cmp    $0xf,%eax
  801a39:	75 07                	jne    801a42 <strsplit+0x6c>
		{
			return 0;
  801a3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a40:	eb 66                	jmp    801aa8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a42:	8b 45 14             	mov    0x14(%ebp),%eax
  801a45:	8b 00                	mov    (%eax),%eax
  801a47:	8d 48 01             	lea    0x1(%eax),%ecx
  801a4a:	8b 55 14             	mov    0x14(%ebp),%edx
  801a4d:	89 0a                	mov    %ecx,(%edx)
  801a4f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a56:	8b 45 10             	mov    0x10(%ebp),%eax
  801a59:	01 c2                	add    %eax,%edx
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a60:	eb 03                	jmp    801a65 <strsplit+0x8f>
			string++;
  801a62:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	8a 00                	mov    (%eax),%al
  801a6a:	84 c0                	test   %al,%al
  801a6c:	74 8b                	je     8019f9 <strsplit+0x23>
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	8a 00                	mov    (%eax),%al
  801a73:	0f be c0             	movsbl %al,%eax
  801a76:	50                   	push   %eax
  801a77:	ff 75 0c             	pushl  0xc(%ebp)
  801a7a:	e8 25 fa ff ff       	call   8014a4 <strchr>
  801a7f:	83 c4 08             	add    $0x8,%esp
  801a82:	85 c0                	test   %eax,%eax
  801a84:	74 dc                	je     801a62 <strsplit+0x8c>
			string++;
	}
  801a86:	e9 6e ff ff ff       	jmp    8019f9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a8b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a8c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8f:	8b 00                	mov    (%eax),%eax
  801a91:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a98:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9b:	01 d0                	add    %edx,%eax
  801a9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801aa3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801ab6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801abd:	eb 4a                	jmp    801b09 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801abf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	01 c2                	add    %eax,%edx
  801ac7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acd:	01 c8                	add    %ecx,%eax
  801acf:	8a 00                	mov    (%eax),%al
  801ad1:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801ad3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad9:	01 d0                	add    %edx,%eax
  801adb:	8a 00                	mov    (%eax),%al
  801add:	3c 40                	cmp    $0x40,%al
  801adf:	7e 25                	jle    801b06 <str2lower+0x5c>
  801ae1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae7:	01 d0                	add    %edx,%eax
  801ae9:	8a 00                	mov    (%eax),%al
  801aeb:	3c 5a                	cmp    $0x5a,%al
  801aed:	7f 17                	jg     801b06 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801aef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	01 d0                	add    %edx,%eax
  801af7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801afa:	8b 55 08             	mov    0x8(%ebp),%edx
  801afd:	01 ca                	add    %ecx,%edx
  801aff:	8a 12                	mov    (%edx),%dl
  801b01:	83 c2 20             	add    $0x20,%edx
  801b04:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801b06:	ff 45 fc             	incl   -0x4(%ebp)
  801b09:	ff 75 0c             	pushl  0xc(%ebp)
  801b0c:	e8 01 f8 ff ff       	call   801312 <strlen>
  801b11:	83 c4 04             	add    $0x4,%esp
  801b14:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b17:	7f a6                	jg     801abf <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b19:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801b24:	83 ec 0c             	sub    $0xc,%esp
  801b27:	6a 10                	push   $0x10
  801b29:	e8 b2 15 00 00       	call   8030e0 <alloc_block>
  801b2e:	83 c4 10             	add    $0x10,%esp
  801b31:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801b34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b38:	75 14                	jne    801b4e <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801b3a:	83 ec 04             	sub    $0x4,%esp
  801b3d:	68 3c 45 80 00       	push   $0x80453c
  801b42:	6a 14                	push   $0x14
  801b44:	68 65 45 80 00       	push   $0x804565
  801b49:	e8 f5 eb ff ff       	call   800743 <_panic>

	node->start = start;
  801b4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b51:	8b 55 08             	mov    0x8(%ebp),%edx
  801b54:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5c:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801b5f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801b66:	a1 28 50 80 00       	mov    0x805028,%eax
  801b6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b6e:	eb 18                	jmp    801b88 <insert_page_alloc+0x6a>
		if (start < it->start)
  801b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b73:	8b 00                	mov    (%eax),%eax
  801b75:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b78:	77 37                	ja     801bb1 <insert_page_alloc+0x93>
			break;
		prev = it;
  801b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801b80:	a1 30 50 80 00       	mov    0x805030,%eax
  801b85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b8c:	74 08                	je     801b96 <insert_page_alloc+0x78>
  801b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b91:	8b 40 08             	mov    0x8(%eax),%eax
  801b94:	eb 05                	jmp    801b9b <insert_page_alloc+0x7d>
  801b96:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9b:	a3 30 50 80 00       	mov    %eax,0x805030
  801ba0:	a1 30 50 80 00       	mov    0x805030,%eax
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	75 c7                	jne    801b70 <insert_page_alloc+0x52>
  801ba9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bad:	75 c1                	jne    801b70 <insert_page_alloc+0x52>
  801baf:	eb 01                	jmp    801bb2 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801bb1:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801bb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bb6:	75 64                	jne    801c1c <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801bb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bbc:	75 14                	jne    801bd2 <insert_page_alloc+0xb4>
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	68 74 45 80 00       	push   $0x804574
  801bc6:	6a 21                	push   $0x21
  801bc8:	68 65 45 80 00       	push   $0x804565
  801bcd:	e8 71 eb ff ff       	call   800743 <_panic>
  801bd2:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bdb:	89 50 08             	mov    %edx,0x8(%eax)
  801bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be1:	8b 40 08             	mov    0x8(%eax),%eax
  801be4:	85 c0                	test   %eax,%eax
  801be6:	74 0d                	je     801bf5 <insert_page_alloc+0xd7>
  801be8:	a1 28 50 80 00       	mov    0x805028,%eax
  801bed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bf0:	89 50 0c             	mov    %edx,0xc(%eax)
  801bf3:	eb 08                	jmp    801bfd <insert_page_alloc+0xdf>
  801bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c00:	a3 28 50 80 00       	mov    %eax,0x805028
  801c05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c08:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c0f:	a1 34 50 80 00       	mov    0x805034,%eax
  801c14:	40                   	inc    %eax
  801c15:	a3 34 50 80 00       	mov    %eax,0x805034
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801c1a:	eb 71                	jmp    801c8d <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801c1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c20:	74 06                	je     801c28 <insert_page_alloc+0x10a>
  801c22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c26:	75 14                	jne    801c3c <insert_page_alloc+0x11e>
  801c28:	83 ec 04             	sub    $0x4,%esp
  801c2b:	68 98 45 80 00       	push   $0x804598
  801c30:	6a 23                	push   $0x23
  801c32:	68 65 45 80 00       	push   $0x804565
  801c37:	e8 07 eb ff ff       	call   800743 <_panic>
  801c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3f:	8b 50 08             	mov    0x8(%eax),%edx
  801c42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c45:	89 50 08             	mov    %edx,0x8(%eax)
  801c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c4b:	8b 40 08             	mov    0x8(%eax),%eax
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	74 0c                	je     801c5e <insert_page_alloc+0x140>
  801c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c55:	8b 40 08             	mov    0x8(%eax),%eax
  801c58:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c5b:	89 50 0c             	mov    %edx,0xc(%eax)
  801c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c61:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c64:	89 50 08             	mov    %edx,0x8(%eax)
  801c67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c6d:	89 50 0c             	mov    %edx,0xc(%eax)
  801c70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c73:	8b 40 08             	mov    0x8(%eax),%eax
  801c76:	85 c0                	test   %eax,%eax
  801c78:	75 08                	jne    801c82 <insert_page_alloc+0x164>
  801c7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c7d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801c82:	a1 34 50 80 00       	mov    0x805034,%eax
  801c87:	40                   	inc    %eax
  801c88:	a3 34 50 80 00       	mov    %eax,0x805034
}
  801c8d:	90                   	nop
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801c96:	a1 28 50 80 00       	mov    0x805028,%eax
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	75 0c                	jne    801cab <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801c9f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ca4:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801ca9:	eb 67                	jmp    801d12 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801cab:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801cb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801cb3:	a1 28 50 80 00       	mov    0x805028,%eax
  801cb8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801cbb:	eb 26                	jmp    801ce3 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801cbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cc0:	8b 10                	mov    (%eax),%edx
  801cc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cc5:	8b 40 04             	mov    0x4(%eax),%eax
  801cc8:	01 d0                	add    %edx,%eax
  801cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801cd3:	76 06                	jbe    801cdb <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801cdb:	a1 30 50 80 00       	mov    0x805030,%eax
  801ce0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801ce3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ce7:	74 08                	je     801cf1 <recompute_page_alloc_break+0x61>
  801ce9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cec:	8b 40 08             	mov    0x8(%eax),%eax
  801cef:	eb 05                	jmp    801cf6 <recompute_page_alloc_break+0x66>
  801cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf6:	a3 30 50 80 00       	mov    %eax,0x805030
  801cfb:	a1 30 50 80 00       	mov    0x805030,%eax
  801d00:	85 c0                	test   %eax,%eax
  801d02:	75 b9                	jne    801cbd <recompute_page_alloc_break+0x2d>
  801d04:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801d08:	75 b3                	jne    801cbd <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d0d:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801d1a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801d21:	8b 55 08             	mov    0x8(%ebp),%edx
  801d24:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d27:	01 d0                	add    %edx,%eax
  801d29:	48                   	dec    %eax
  801d2a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801d2d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d30:	ba 00 00 00 00       	mov    $0x0,%edx
  801d35:	f7 75 d8             	divl   -0x28(%ebp)
  801d38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d3b:	29 d0                	sub    %edx,%eax
  801d3d:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801d40:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801d44:	75 0a                	jne    801d50 <alloc_pages_custom_fit+0x3c>
		return NULL;
  801d46:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4b:	e9 7e 01 00 00       	jmp    801ece <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801d50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801d57:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801d5b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801d62:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801d69:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801d71:	a1 28 50 80 00       	mov    0x805028,%eax
  801d76:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d79:	eb 69                	jmp    801de4 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801d7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d7e:	8b 00                	mov    (%eax),%eax
  801d80:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d83:	76 47                	jbe    801dcc <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d88:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801d8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d8e:	8b 00                	mov    (%eax),%eax
  801d90:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801d93:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801d96:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d99:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801d9c:	72 2e                	jb     801dcc <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801d9e:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801da2:	75 14                	jne    801db8 <alloc_pages_custom_fit+0xa4>
  801da4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801da7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801daa:	75 0c                	jne    801db8 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801dac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801db2:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801db6:	eb 14                	jmp    801dcc <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801db8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801dbb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801dbe:	76 0c                	jbe    801dcc <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801dc0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801dc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801dc6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801dc9:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801dcc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dcf:	8b 10                	mov    (%eax),%edx
  801dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dd4:	8b 40 04             	mov    0x4(%eax),%eax
  801dd7:	01 d0                	add    %edx,%eax
  801dd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801ddc:	a1 30 50 80 00       	mov    0x805030,%eax
  801de1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801de4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801de8:	74 08                	je     801df2 <alloc_pages_custom_fit+0xde>
  801dea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ded:	8b 40 08             	mov    0x8(%eax),%eax
  801df0:	eb 05                	jmp    801df7 <alloc_pages_custom_fit+0xe3>
  801df2:	b8 00 00 00 00       	mov    $0x0,%eax
  801df7:	a3 30 50 80 00       	mov    %eax,0x805030
  801dfc:	a1 30 50 80 00       	mov    0x805030,%eax
  801e01:	85 c0                	test   %eax,%eax
  801e03:	0f 85 72 ff ff ff    	jne    801d7b <alloc_pages_custom_fit+0x67>
  801e09:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e0d:	0f 85 68 ff ff ff    	jne    801d7b <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801e13:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e18:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e1b:	76 47                	jbe    801e64 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e20:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801e23:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e28:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801e2b:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801e2e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e31:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e34:	72 2e                	jb     801e64 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801e36:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801e3a:	75 14                	jne    801e50 <alloc_pages_custom_fit+0x13c>
  801e3c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e3f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e42:	75 0c                	jne    801e50 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801e44:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801e4a:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801e4e:	eb 14                	jmp    801e64 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801e50:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e53:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e56:	76 0c                	jbe    801e64 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801e58:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801e5e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e61:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801e64:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801e6b:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801e6f:	74 08                	je     801e79 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e74:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e77:	eb 40                	jmp    801eb9 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801e79:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e7d:	74 08                	je     801e87 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801e7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e82:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e85:	eb 32                	jmp    801eb9 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801e87:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801e8c:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801e8f:	89 c2                	mov    %eax,%edx
  801e91:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e96:	39 c2                	cmp    %eax,%edx
  801e98:	73 07                	jae    801ea1 <alloc_pages_custom_fit+0x18d>
			return NULL;
  801e9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9f:	eb 2d                	jmp    801ece <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801ea1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801ea6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801ea9:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801eaf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801eb2:	01 d0                	add    %edx,%eax
  801eb4:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801eb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ebc:	83 ec 08             	sub    $0x8,%esp
  801ebf:	ff 75 d0             	pushl  -0x30(%ebp)
  801ec2:	50                   	push   %eax
  801ec3:	e8 56 fc ff ff       	call   801b1e <insert_page_alloc>
  801ec8:	83 c4 10             	add    $0x10,%esp

	return result;
  801ecb:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801edc:	a1 28 50 80 00       	mov    0x805028,%eax
  801ee1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ee4:	eb 1a                	jmp    801f00 <find_allocated_size+0x30>
		if (it->start == va)
  801ee6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ee9:	8b 00                	mov    (%eax),%eax
  801eeb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801eee:	75 08                	jne    801ef8 <find_allocated_size+0x28>
			return it->size;
  801ef0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ef3:	8b 40 04             	mov    0x4(%eax),%eax
  801ef6:	eb 34                	jmp    801f2c <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801ef8:	a1 30 50 80 00       	mov    0x805030,%eax
  801efd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f00:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f04:	74 08                	je     801f0e <find_allocated_size+0x3e>
  801f06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f09:	8b 40 08             	mov    0x8(%eax),%eax
  801f0c:	eb 05                	jmp    801f13 <find_allocated_size+0x43>
  801f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f13:	a3 30 50 80 00       	mov    %eax,0x805030
  801f18:	a1 30 50 80 00       	mov    0x805030,%eax
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	75 c5                	jne    801ee6 <find_allocated_size+0x16>
  801f21:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f25:	75 bf                	jne    801ee6 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f3a:	a1 28 50 80 00       	mov    0x805028,%eax
  801f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f42:	e9 e1 01 00 00       	jmp    802128 <free_pages+0x1fa>
		if (it->start == va) {
  801f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4a:	8b 00                	mov    (%eax),%eax
  801f4c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f4f:	0f 85 cb 01 00 00    	jne    802120 <free_pages+0x1f2>

			uint32 start = it->start;
  801f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f58:	8b 00                	mov    (%eax),%eax
  801f5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f60:	8b 40 04             	mov    0x4(%eax),%eax
  801f63:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801f66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f69:	f7 d0                	not    %eax
  801f6b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f6e:	73 1d                	jae    801f8d <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f76:	ff 75 e8             	pushl  -0x18(%ebp)
  801f79:	68 cc 45 80 00       	push   $0x8045cc
  801f7e:	68 a5 00 00 00       	push   $0xa5
  801f83:	68 65 45 80 00       	push   $0x804565
  801f88:	e8 b6 e7 ff ff       	call   800743 <_panic>
			}

			uint32 start_end = start + size;
  801f8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f93:	01 d0                	add    %edx,%eax
  801f95:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801f98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f9b:	85 c0                	test   %eax,%eax
  801f9d:	79 19                	jns    801fb8 <free_pages+0x8a>
  801f9f:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801fa6:	77 10                	ja     801fb8 <free_pages+0x8a>
  801fa8:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801faf:	77 07                	ja     801fb8 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801fb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fb4:	85 c0                	test   %eax,%eax
  801fb6:	78 2c                	js     801fe4 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801fb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fbb:	83 ec 0c             	sub    $0xc,%esp
  801fbe:	68 00 00 00 a0       	push   $0xa0000000
  801fc3:	ff 75 e0             	pushl  -0x20(%ebp)
  801fc6:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fc9:	ff 75 e8             	pushl  -0x18(%ebp)
  801fcc:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fcf:	50                   	push   %eax
  801fd0:	68 10 46 80 00       	push   $0x804610
  801fd5:	68 ad 00 00 00       	push   $0xad
  801fda:	68 65 45 80 00       	push   $0x804565
  801fdf:	e8 5f e7 ff ff       	call   800743 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801fe4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fe7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fea:	e9 88 00 00 00       	jmp    802077 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801fef:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801ff6:	76 17                	jbe    80200f <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801ff8:	ff 75 f0             	pushl  -0x10(%ebp)
  801ffb:	68 74 46 80 00       	push   $0x804674
  802000:	68 b4 00 00 00       	push   $0xb4
  802005:	68 65 45 80 00       	push   $0x804565
  80200a:	e8 34 e7 ff ff       	call   800743 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  80200f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802012:	05 00 10 00 00       	add    $0x1000,%eax
  802017:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  80201a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201d:	85 c0                	test   %eax,%eax
  80201f:	79 2e                	jns    80204f <free_pages+0x121>
  802021:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802028:	77 25                	ja     80204f <free_pages+0x121>
  80202a:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802031:	77 1c                	ja     80204f <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  802033:	83 ec 08             	sub    $0x8,%esp
  802036:	68 00 10 00 00       	push   $0x1000
  80203b:	ff 75 f0             	pushl  -0x10(%ebp)
  80203e:	e8 38 0d 00 00       	call   802d7b <sys_free_user_mem>
  802043:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802046:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80204d:	eb 28                	jmp    802077 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  80204f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802052:	68 00 00 00 a0       	push   $0xa0000000
  802057:	ff 75 dc             	pushl  -0x24(%ebp)
  80205a:	68 00 10 00 00       	push   $0x1000
  80205f:	ff 75 f0             	pushl  -0x10(%ebp)
  802062:	50                   	push   %eax
  802063:	68 b4 46 80 00       	push   $0x8046b4
  802068:	68 bd 00 00 00       	push   $0xbd
  80206d:	68 65 45 80 00       	push   $0x804565
  802072:	e8 cc e6 ff ff       	call   800743 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80207d:	0f 82 6c ff ff ff    	jb     801fef <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802083:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802087:	75 17                	jne    8020a0 <free_pages+0x172>
  802089:	83 ec 04             	sub    $0x4,%esp
  80208c:	68 16 47 80 00       	push   $0x804716
  802091:	68 c1 00 00 00       	push   $0xc1
  802096:	68 65 45 80 00       	push   $0x804565
  80209b:	e8 a3 e6 ff ff       	call   800743 <_panic>
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	8b 40 08             	mov    0x8(%eax),%eax
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	74 11                	je     8020bb <free_pages+0x18d>
  8020aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ad:	8b 40 08             	mov    0x8(%eax),%eax
  8020b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b3:	8b 52 0c             	mov    0xc(%edx),%edx
  8020b6:	89 50 0c             	mov    %edx,0xc(%eax)
  8020b9:	eb 0b                	jmp    8020c6 <free_pages+0x198>
  8020bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020be:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8020cc:	85 c0                	test   %eax,%eax
  8020ce:	74 11                	je     8020e1 <free_pages+0x1b3>
  8020d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d9:	8b 52 08             	mov    0x8(%edx),%edx
  8020dc:	89 50 08             	mov    %edx,0x8(%eax)
  8020df:	eb 0b                	jmp    8020ec <free_pages+0x1be>
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	8b 40 08             	mov    0x8(%eax),%eax
  8020e7:	a3 28 50 80 00       	mov    %eax,0x805028
  8020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802100:	a1 34 50 80 00       	mov    0x805034,%eax
  802105:	48                   	dec    %eax
  802106:	a3 34 50 80 00       	mov    %eax,0x805034
			free_block(it);
  80210b:	83 ec 0c             	sub    $0xc,%esp
  80210e:	ff 75 f4             	pushl  -0xc(%ebp)
  802111:	e8 24 15 00 00       	call   80363a <free_block>
  802116:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  802119:	e8 72 fb ff ff       	call   801c90 <recompute_page_alloc_break>

			return;
  80211e:	eb 37                	jmp    802157 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802120:	a1 30 50 80 00       	mov    0x805030,%eax
  802125:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802128:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212c:	74 08                	je     802136 <free_pages+0x208>
  80212e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802131:	8b 40 08             	mov    0x8(%eax),%eax
  802134:	eb 05                	jmp    80213b <free_pages+0x20d>
  802136:	b8 00 00 00 00       	mov    $0x0,%eax
  80213b:	a3 30 50 80 00       	mov    %eax,0x805030
  802140:	a1 30 50 80 00       	mov    0x805030,%eax
  802145:	85 c0                	test   %eax,%eax
  802147:	0f 85 fa fd ff ff    	jne    801f47 <free_pages+0x19>
  80214d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802151:	0f 85 f0 fd ff ff    	jne    801f47 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  80215c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802161:	5d                   	pop    %ebp
  802162:	c3                   	ret    

00802163 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
  802166:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802169:	a1 08 50 80 00       	mov    0x805008,%eax
  80216e:	85 c0                	test   %eax,%eax
  802170:	74 60                	je     8021d2 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802172:	83 ec 08             	sub    $0x8,%esp
  802175:	68 00 00 00 82       	push   $0x82000000
  80217a:	68 00 00 00 80       	push   $0x80000000
  80217f:	e8 0d 0d 00 00       	call   802e91 <initialize_dynamic_allocator>
  802184:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802187:	e8 f3 0a 00 00       	call   802c7f <sys_get_uheap_strategy>
  80218c:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802191:	a1 40 50 80 00       	mov    0x805040,%eax
  802196:	05 00 10 00 00       	add    $0x1000,%eax
  80219b:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  8021a0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021a5:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  8021aa:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  8021b1:	00 00 00 
  8021b4:	c7 05 2c 50 80 00 00 	movl   $0x0,0x80502c
  8021bb:	00 00 00 
  8021be:	c7 05 34 50 80 00 00 	movl   $0x0,0x805034
  8021c5:	00 00 00 

		__firstTimeFlag = 0;
  8021c8:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8021cf:	00 00 00 
	}
}
  8021d2:	90                   	nop
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8021e9:	83 ec 08             	sub    $0x8,%esp
  8021ec:	68 06 04 00 00       	push   $0x406
  8021f1:	50                   	push   %eax
  8021f2:	e8 d2 06 00 00       	call   8028c9 <__sys_allocate_page>
  8021f7:	83 c4 10             	add    $0x10,%esp
  8021fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8021fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802201:	79 17                	jns    80221a <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  802203:	83 ec 04             	sub    $0x4,%esp
  802206:	68 34 47 80 00       	push   $0x804734
  80220b:	68 ea 00 00 00       	push   $0xea
  802210:	68 65 45 80 00       	push   $0x804565
  802215:	e8 29 e5 ff ff       	call   800743 <_panic>
	return 0;
  80221a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80222d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802230:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802235:	83 ec 0c             	sub    $0xc,%esp
  802238:	50                   	push   %eax
  802239:	e8 d2 06 00 00       	call   802910 <__sys_unmap_frame>
  80223e:	83 c4 10             	add    $0x10,%esp
  802241:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802244:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802248:	79 17                	jns    802261 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  80224a:	83 ec 04             	sub    $0x4,%esp
  80224d:	68 70 47 80 00       	push   $0x804770
  802252:	68 f5 00 00 00       	push   $0xf5
  802257:	68 65 45 80 00       	push   $0x804565
  80225c:	e8 e2 e4 ff ff       	call   800743 <_panic>
}
  802261:	90                   	nop
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
  802267:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80226a:	e8 f4 fe ff ff       	call   802163 <uheap_init>
	if (size == 0) return NULL ;
  80226f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802273:	75 0a                	jne    80227f <malloc+0x1b>
  802275:	b8 00 00 00 00       	mov    $0x0,%eax
  80227a:	e9 67 01 00 00       	jmp    8023e6 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  80227f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  802286:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80228d:	77 16                	ja     8022a5 <malloc+0x41>
		result = alloc_block(size);
  80228f:	83 ec 0c             	sub    $0xc,%esp
  802292:	ff 75 08             	pushl  0x8(%ebp)
  802295:	e8 46 0e 00 00       	call   8030e0 <alloc_block>
  80229a:	83 c4 10             	add    $0x10,%esp
  80229d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a0:	e9 3e 01 00 00       	jmp    8023e3 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  8022a5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8022ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8022af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b2:	01 d0                	add    %edx,%eax
  8022b4:	48                   	dec    %eax
  8022b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8022b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8022c0:	f7 75 f0             	divl   -0x10(%ebp)
  8022c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c6:	29 d0                	sub    %edx,%eax
  8022c8:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  8022cb:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022d0:	85 c0                	test   %eax,%eax
  8022d2:	75 0a                	jne    8022de <malloc+0x7a>
			return NULL;
  8022d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d9:	e9 08 01 00 00       	jmp    8023e6 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  8022de:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022e3:	85 c0                	test   %eax,%eax
  8022e5:	74 0f                	je     8022f6 <malloc+0x92>
  8022e7:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8022ed:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022f2:	39 c2                	cmp    %eax,%edx
  8022f4:	73 0a                	jae    802300 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  8022f6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022fb:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802300:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802305:	83 f8 05             	cmp    $0x5,%eax
  802308:	75 11                	jne    80231b <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  80230a:	83 ec 0c             	sub    $0xc,%esp
  80230d:	ff 75 e8             	pushl  -0x18(%ebp)
  802310:	e8 ff f9 ff ff       	call   801d14 <alloc_pages_custom_fit>
  802315:	83 c4 10             	add    $0x10,%esp
  802318:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  80231b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231f:	0f 84 be 00 00 00    	je     8023e3 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802328:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  80232b:	83 ec 0c             	sub    $0xc,%esp
  80232e:	ff 75 f4             	pushl  -0xc(%ebp)
  802331:	e8 9a fb ff ff       	call   801ed0 <find_allocated_size>
  802336:	83 c4 10             	add    $0x10,%esp
  802339:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  80233c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802340:	75 17                	jne    802359 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802342:	ff 75 f4             	pushl  -0xc(%ebp)
  802345:	68 b0 47 80 00       	push   $0x8047b0
  80234a:	68 24 01 00 00       	push   $0x124
  80234f:	68 65 45 80 00       	push   $0x804565
  802354:	e8 ea e3 ff ff       	call   800743 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  802359:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80235c:	f7 d0                	not    %eax
  80235e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802361:	73 1d                	jae    802380 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  802363:	83 ec 0c             	sub    $0xc,%esp
  802366:	ff 75 e0             	pushl  -0x20(%ebp)
  802369:	ff 75 e4             	pushl  -0x1c(%ebp)
  80236c:	68 f8 47 80 00       	push   $0x8047f8
  802371:	68 29 01 00 00       	push   $0x129
  802376:	68 65 45 80 00       	push   $0x804565
  80237b:	e8 c3 e3 ff ff       	call   800743 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  802380:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802383:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802386:	01 d0                	add    %edx,%eax
  802388:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  80238b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80238e:	85 c0                	test   %eax,%eax
  802390:	79 2c                	jns    8023be <malloc+0x15a>
  802392:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802399:	77 23                	ja     8023be <malloc+0x15a>
  80239b:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8023a2:	77 1a                	ja     8023be <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  8023a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023a7:	85 c0                	test   %eax,%eax
  8023a9:	79 13                	jns    8023be <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  8023ab:	83 ec 08             	sub    $0x8,%esp
  8023ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8023b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023b4:	e8 de 09 00 00       	call   802d97 <sys_allocate_user_mem>
  8023b9:	83 c4 10             	add    $0x10,%esp
  8023bc:	eb 25                	jmp    8023e3 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  8023be:	68 00 00 00 a0       	push   $0xa0000000
  8023c3:	ff 75 dc             	pushl  -0x24(%ebp)
  8023c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8023c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8023cf:	68 34 48 80 00       	push   $0x804834
  8023d4:	68 33 01 00 00       	push   $0x133
  8023d9:	68 65 45 80 00       	push   $0x804565
  8023de:	e8 60 e3 ff ff       	call   800743 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
  8023eb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8023ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023f2:	0f 84 26 01 00 00    	je     80251e <free+0x136>

	uint32 addr = (uint32)virtual_address;
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	85 c0                	test   %eax,%eax
  802403:	79 1c                	jns    802421 <free+0x39>
  802405:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  80240c:	77 13                	ja     802421 <free+0x39>
		free_block(virtual_address);
  80240e:	83 ec 0c             	sub    $0xc,%esp
  802411:	ff 75 08             	pushl  0x8(%ebp)
  802414:	e8 21 12 00 00       	call   80363a <free_block>
  802419:	83 c4 10             	add    $0x10,%esp
		return;
  80241c:	e9 01 01 00 00       	jmp    802522 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  802421:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802426:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802429:	0f 82 d8 00 00 00    	jb     802507 <free+0x11f>
  80242f:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  802436:	0f 87 cb 00 00 00    	ja     802507 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	25 ff 0f 00 00       	and    $0xfff,%eax
  802444:	85 c0                	test   %eax,%eax
  802446:	74 17                	je     80245f <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  802448:	ff 75 08             	pushl  0x8(%ebp)
  80244b:	68 a4 48 80 00       	push   $0x8048a4
  802450:	68 57 01 00 00       	push   $0x157
  802455:	68 65 45 80 00       	push   $0x804565
  80245a:	e8 e4 e2 ff ff       	call   800743 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  80245f:	83 ec 0c             	sub    $0xc,%esp
  802462:	ff 75 08             	pushl  0x8(%ebp)
  802465:	e8 66 fa ff ff       	call   801ed0 <find_allocated_size>
  80246a:	83 c4 10             	add    $0x10,%esp
  80246d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  802470:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802474:	0f 84 a7 00 00 00    	je     802521 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  80247a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247d:	f7 d0                	not    %eax
  80247f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802482:	73 1d                	jae    8024a1 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  802484:	83 ec 0c             	sub    $0xc,%esp
  802487:	ff 75 f0             	pushl  -0x10(%ebp)
  80248a:	ff 75 f4             	pushl  -0xc(%ebp)
  80248d:	68 cc 48 80 00       	push   $0x8048cc
  802492:	68 61 01 00 00       	push   $0x161
  802497:	68 65 45 80 00       	push   $0x804565
  80249c:	e8 a2 e2 ff ff       	call   800743 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  8024a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a7:	01 d0                	add    %edx,%eax
  8024a9:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	85 c0                	test   %eax,%eax
  8024b1:	79 19                	jns    8024cc <free+0xe4>
  8024b3:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  8024ba:	77 10                	ja     8024cc <free+0xe4>
  8024bc:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  8024c3:	77 07                	ja     8024cc <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  8024c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	78 2b                	js     8024f7 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  8024cc:	83 ec 0c             	sub    $0xc,%esp
  8024cf:	68 00 00 00 a0       	push   $0xa0000000
  8024d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8024d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8024da:	ff 75 f4             	pushl  -0xc(%ebp)
  8024dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8024e0:	ff 75 08             	pushl  0x8(%ebp)
  8024e3:	68 08 49 80 00       	push   $0x804908
  8024e8:	68 69 01 00 00       	push   $0x169
  8024ed:	68 65 45 80 00       	push   $0x804565
  8024f2:	e8 4c e2 ff ff       	call   800743 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  8024f7:	83 ec 0c             	sub    $0xc,%esp
  8024fa:	ff 75 08             	pushl  0x8(%ebp)
  8024fd:	e8 2c fa ff ff       	call   801f2e <free_pages>
  802502:	83 c4 10             	add    $0x10,%esp
		return;
  802505:	eb 1b                	jmp    802522 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  802507:	ff 75 08             	pushl  0x8(%ebp)
  80250a:	68 64 49 80 00       	push   $0x804964
  80250f:	68 70 01 00 00       	push   $0x170
  802514:	68 65 45 80 00       	push   $0x804565
  802519:	e8 25 e2 ff ff       	call   800743 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  80251e:	90                   	nop
  80251f:	eb 01                	jmp    802522 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  802521:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
  802527:	83 ec 38             	sub    $0x38,%esp
  80252a:	8b 45 10             	mov    0x10(%ebp),%eax
  80252d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802530:	e8 2e fc ff ff       	call   802163 <uheap_init>
	if (size == 0) return NULL ;
  802535:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802539:	75 0a                	jne    802545 <smalloc+0x21>
  80253b:	b8 00 00 00 00       	mov    $0x0,%eax
  802540:	e9 3d 01 00 00       	jmp    802682 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  802545:	8b 45 0c             	mov    0xc(%ebp),%eax
  802548:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  80254b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254e:	25 ff 0f 00 00       	and    $0xfff,%eax
  802553:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  802556:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80255a:	74 0e                	je     80256a <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802562:	05 00 10 00 00       	add    $0x1000,%eax
  802567:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	c1 e8 0c             	shr    $0xc,%eax
  802570:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802573:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802578:	85 c0                	test   %eax,%eax
  80257a:	75 0a                	jne    802586 <smalloc+0x62>
		return NULL;
  80257c:	b8 00 00 00 00       	mov    $0x0,%eax
  802581:	e9 fc 00 00 00       	jmp    802682 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802586:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80258b:	85 c0                	test   %eax,%eax
  80258d:	74 0f                	je     80259e <smalloc+0x7a>
  80258f:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802595:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80259a:	39 c2                	cmp    %eax,%edx
  80259c:	73 0a                	jae    8025a8 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  80259e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025a3:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8025a8:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025ad:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8025b2:	29 c2                	sub    %eax,%edx
  8025b4:	89 d0                	mov    %edx,%eax
  8025b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8025b9:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8025bf:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025c4:	29 c2                	sub    %eax,%edx
  8025c6:	89 d0                	mov    %edx,%eax
  8025c8:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8025d1:	77 13                	ja     8025e6 <smalloc+0xc2>
  8025d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8025d9:	77 0b                	ja     8025e6 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  8025db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025de:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8025e1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8025e4:	73 0a                	jae    8025f0 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  8025e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025eb:	e9 92 00 00 00       	jmp    802682 <smalloc+0x15e>
	}

	void *va = NULL;
  8025f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8025f7:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8025fc:	83 f8 05             	cmp    $0x5,%eax
  8025ff:	75 11                	jne    802612 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  802601:	83 ec 0c             	sub    $0xc,%esp
  802604:	ff 75 f4             	pushl  -0xc(%ebp)
  802607:	e8 08 f7 ff ff       	call   801d14 <alloc_pages_custom_fit>
  80260c:	83 c4 10             	add    $0x10,%esp
  80260f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802612:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802616:	75 27                	jne    80263f <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802618:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  80261f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802622:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802625:	89 c2                	mov    %eax,%edx
  802627:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80262c:	39 c2                	cmp    %eax,%edx
  80262e:	73 07                	jae    802637 <smalloc+0x113>
			return NULL;}
  802630:	b8 00 00 00 00       	mov    $0x0,%eax
  802635:	eb 4b                	jmp    802682 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  802637:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80263c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  80263f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802643:	ff 75 f0             	pushl  -0x10(%ebp)
  802646:	50                   	push   %eax
  802647:	ff 75 0c             	pushl  0xc(%ebp)
  80264a:	ff 75 08             	pushl  0x8(%ebp)
  80264d:	e8 cb 03 00 00       	call   802a1d <sys_create_shared_object>
  802652:	83 c4 10             	add    $0x10,%esp
  802655:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  802658:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80265c:	79 07                	jns    802665 <smalloc+0x141>
		return NULL;
  80265e:	b8 00 00 00 00       	mov    $0x0,%eax
  802663:	eb 1d                	jmp    802682 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802665:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80266a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80266d:	75 10                	jne    80267f <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  80266f:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	01 d0                	add    %edx,%eax
  80267a:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  80267f:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802682:	c9                   	leave  
  802683:	c3                   	ret    

00802684 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
  802687:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80268a:	e8 d4 fa ff ff       	call   802163 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80268f:	83 ec 08             	sub    $0x8,%esp
  802692:	ff 75 0c             	pushl  0xc(%ebp)
  802695:	ff 75 08             	pushl  0x8(%ebp)
  802698:	e8 aa 03 00 00       	call   802a47 <sys_size_of_shared_object>
  80269d:	83 c4 10             	add    $0x10,%esp
  8026a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8026a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026a7:	7f 0a                	jg     8026b3 <sget+0x2f>
		return NULL;
  8026a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ae:	e9 32 01 00 00       	jmp    8027e5 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8026b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8026b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bc:	25 ff 0f 00 00       	and    $0xfff,%eax
  8026c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8026c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026c8:	74 0e                	je     8026d8 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8026d0:	05 00 10 00 00       	add    $0x1000,%eax
  8026d5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8026d8:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026dd:	85 c0                	test   %eax,%eax
  8026df:	75 0a                	jne    8026eb <sget+0x67>
		return NULL;
  8026e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e6:	e9 fa 00 00 00       	jmp    8027e5 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8026eb:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8026f0:	85 c0                	test   %eax,%eax
  8026f2:	74 0f                	je     802703 <sget+0x7f>
  8026f4:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8026fa:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026ff:	39 c2                	cmp    %eax,%edx
  802701:	73 0a                	jae    80270d <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  802703:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802708:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80270d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802712:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802717:	29 c2                	sub    %eax,%edx
  802719:	89 d0                	mov    %edx,%eax
  80271b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80271e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802724:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802729:	29 c2                	sub    %eax,%edx
  80272b:	89 d0                	mov    %edx,%eax
  80272d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802736:	77 13                	ja     80274b <sget+0xc7>
  802738:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80273b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80273e:	77 0b                	ja     80274b <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802743:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802746:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802749:	73 0a                	jae    802755 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  80274b:	b8 00 00 00 00       	mov    $0x0,%eax
  802750:	e9 90 00 00 00       	jmp    8027e5 <sget+0x161>

	void *va = NULL;
  802755:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  80275c:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802761:	83 f8 05             	cmp    $0x5,%eax
  802764:	75 11                	jne    802777 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802766:	83 ec 0c             	sub    $0xc,%esp
  802769:	ff 75 f4             	pushl  -0xc(%ebp)
  80276c:	e8 a3 f5 ff ff       	call   801d14 <alloc_pages_custom_fit>
  802771:	83 c4 10             	add    $0x10,%esp
  802774:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  802777:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80277b:	75 27                	jne    8027a4 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80277d:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802784:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802787:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80278a:	89 c2                	mov    %eax,%edx
  80278c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802791:	39 c2                	cmp    %eax,%edx
  802793:	73 07                	jae    80279c <sget+0x118>
			return NULL;
  802795:	b8 00 00 00 00       	mov    $0x0,%eax
  80279a:	eb 49                	jmp    8027e5 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  80279c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8027a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8027a4:	83 ec 04             	sub    $0x4,%esp
  8027a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8027aa:	ff 75 0c             	pushl  0xc(%ebp)
  8027ad:	ff 75 08             	pushl  0x8(%ebp)
  8027b0:	e8 af 02 00 00       	call   802a64 <sys_get_shared_object>
  8027b5:	83 c4 10             	add    $0x10,%esp
  8027b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8027bb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8027bf:	79 07                	jns    8027c8 <sget+0x144>
		return NULL;
  8027c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c6:	eb 1d                	jmp    8027e5 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8027c8:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8027cd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8027d0:	75 10                	jne    8027e2 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8027d2:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	01 d0                	add    %edx,%eax
  8027dd:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8027e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8027e5:	c9                   	leave  
  8027e6:	c3                   	ret    

008027e7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8027e7:	55                   	push   %ebp
  8027e8:	89 e5                	mov    %esp,%ebp
  8027ea:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8027ed:	e8 71 f9 ff ff       	call   802163 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8027f2:	83 ec 04             	sub    $0x4,%esp
  8027f5:	68 88 49 80 00       	push   $0x804988
  8027fa:	68 19 02 00 00       	push   $0x219
  8027ff:	68 65 45 80 00       	push   $0x804565
  802804:	e8 3a df ff ff       	call   800743 <_panic>

00802809 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802809:	55                   	push   %ebp
  80280a:	89 e5                	mov    %esp,%ebp
  80280c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80280f:	83 ec 04             	sub    $0x4,%esp
  802812:	68 b0 49 80 00       	push   $0x8049b0
  802817:	68 2b 02 00 00       	push   $0x22b
  80281c:	68 65 45 80 00       	push   $0x804565
  802821:	e8 1d df ff ff       	call   800743 <_panic>

00802826 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802826:	55                   	push   %ebp
  802827:	89 e5                	mov    %esp,%ebp
  802829:	57                   	push   %edi
  80282a:	56                   	push   %esi
  80282b:	53                   	push   %ebx
  80282c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80282f:	8b 45 08             	mov    0x8(%ebp),%eax
  802832:	8b 55 0c             	mov    0xc(%ebp),%edx
  802835:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802838:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80283b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80283e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802841:	cd 30                	int    $0x30
  802843:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802846:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802849:	83 c4 10             	add    $0x10,%esp
  80284c:	5b                   	pop    %ebx
  80284d:	5e                   	pop    %esi
  80284e:	5f                   	pop    %edi
  80284f:	5d                   	pop    %ebp
  802850:	c3                   	ret    

00802851 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
  802854:	83 ec 04             	sub    $0x4,%esp
  802857:	8b 45 10             	mov    0x10(%ebp),%eax
  80285a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80285d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802860:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	6a 00                	push   $0x0
  802869:	51                   	push   %ecx
  80286a:	52                   	push   %edx
  80286b:	ff 75 0c             	pushl  0xc(%ebp)
  80286e:	50                   	push   %eax
  80286f:	6a 00                	push   $0x0
  802871:	e8 b0 ff ff ff       	call   802826 <syscall>
  802876:	83 c4 18             	add    $0x18,%esp
}
  802879:	90                   	nop
  80287a:	c9                   	leave  
  80287b:	c3                   	ret    

0080287c <sys_cgetc>:

int
sys_cgetc(void)
{
  80287c:	55                   	push   %ebp
  80287d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80287f:	6a 00                	push   $0x0
  802881:	6a 00                	push   $0x0
  802883:	6a 00                	push   $0x0
  802885:	6a 00                	push   $0x0
  802887:	6a 00                	push   $0x0
  802889:	6a 02                	push   $0x2
  80288b:	e8 96 ff ff ff       	call   802826 <syscall>
  802890:	83 c4 18             	add    $0x18,%esp
}
  802893:	c9                   	leave  
  802894:	c3                   	ret    

00802895 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802895:	55                   	push   %ebp
  802896:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802898:	6a 00                	push   $0x0
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 03                	push   $0x3
  8028a4:	e8 7d ff ff ff       	call   802826 <syscall>
  8028a9:	83 c4 18             	add    $0x18,%esp
}
  8028ac:	90                   	nop
  8028ad:	c9                   	leave  
  8028ae:	c3                   	ret    

008028af <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8028af:	55                   	push   %ebp
  8028b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8028b2:	6a 00                	push   $0x0
  8028b4:	6a 00                	push   $0x0
  8028b6:	6a 00                	push   $0x0
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 04                	push   $0x4
  8028be:	e8 63 ff ff ff       	call   802826 <syscall>
  8028c3:	83 c4 18             	add    $0x18,%esp
}
  8028c6:	90                   	nop
  8028c7:	c9                   	leave  
  8028c8:	c3                   	ret    

008028c9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8028c9:	55                   	push   %ebp
  8028ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8028cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 00                	push   $0x0
  8028d8:	52                   	push   %edx
  8028d9:	50                   	push   %eax
  8028da:	6a 08                	push   $0x8
  8028dc:	e8 45 ff ff ff       	call   802826 <syscall>
  8028e1:	83 c4 18             	add    $0x18,%esp
}
  8028e4:	c9                   	leave  
  8028e5:	c3                   	ret    

008028e6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8028e6:	55                   	push   %ebp
  8028e7:	89 e5                	mov    %esp,%ebp
  8028e9:	56                   	push   %esi
  8028ea:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8028eb:	8b 75 18             	mov    0x18(%ebp),%esi
  8028ee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fa:	56                   	push   %esi
  8028fb:	53                   	push   %ebx
  8028fc:	51                   	push   %ecx
  8028fd:	52                   	push   %edx
  8028fe:	50                   	push   %eax
  8028ff:	6a 09                	push   $0x9
  802901:	e8 20 ff ff ff       	call   802826 <syscall>
  802906:	83 c4 18             	add    $0x18,%esp
}
  802909:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80290c:	5b                   	pop    %ebx
  80290d:	5e                   	pop    %esi
  80290e:	5d                   	pop    %ebp
  80290f:	c3                   	ret    

00802910 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802910:	55                   	push   %ebp
  802911:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802913:	6a 00                	push   $0x0
  802915:	6a 00                	push   $0x0
  802917:	6a 00                	push   $0x0
  802919:	6a 00                	push   $0x0
  80291b:	ff 75 08             	pushl  0x8(%ebp)
  80291e:	6a 0a                	push   $0xa
  802920:	e8 01 ff ff ff       	call   802826 <syscall>
  802925:	83 c4 18             	add    $0x18,%esp
}
  802928:	c9                   	leave  
  802929:	c3                   	ret    

0080292a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80292a:	55                   	push   %ebp
  80292b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80292d:	6a 00                	push   $0x0
  80292f:	6a 00                	push   $0x0
  802931:	6a 00                	push   $0x0
  802933:	ff 75 0c             	pushl  0xc(%ebp)
  802936:	ff 75 08             	pushl  0x8(%ebp)
  802939:	6a 0b                	push   $0xb
  80293b:	e8 e6 fe ff ff       	call   802826 <syscall>
  802940:	83 c4 18             	add    $0x18,%esp
}
  802943:	c9                   	leave  
  802944:	c3                   	ret    

00802945 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802945:	55                   	push   %ebp
  802946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802948:	6a 00                	push   $0x0
  80294a:	6a 00                	push   $0x0
  80294c:	6a 00                	push   $0x0
  80294e:	6a 00                	push   $0x0
  802950:	6a 00                	push   $0x0
  802952:	6a 0c                	push   $0xc
  802954:	e8 cd fe ff ff       	call   802826 <syscall>
  802959:	83 c4 18             	add    $0x18,%esp
}
  80295c:	c9                   	leave  
  80295d:	c3                   	ret    

0080295e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80295e:	55                   	push   %ebp
  80295f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802961:	6a 00                	push   $0x0
  802963:	6a 00                	push   $0x0
  802965:	6a 00                	push   $0x0
  802967:	6a 00                	push   $0x0
  802969:	6a 00                	push   $0x0
  80296b:	6a 0d                	push   $0xd
  80296d:	e8 b4 fe ff ff       	call   802826 <syscall>
  802972:	83 c4 18             	add    $0x18,%esp
}
  802975:	c9                   	leave  
  802976:	c3                   	ret    

00802977 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802977:	55                   	push   %ebp
  802978:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80297a:	6a 00                	push   $0x0
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	6a 00                	push   $0x0
  802982:	6a 00                	push   $0x0
  802984:	6a 0e                	push   $0xe
  802986:	e8 9b fe ff ff       	call   802826 <syscall>
  80298b:	83 c4 18             	add    $0x18,%esp
}
  80298e:	c9                   	leave  
  80298f:	c3                   	ret    

00802990 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802993:	6a 00                	push   $0x0
  802995:	6a 00                	push   $0x0
  802997:	6a 00                	push   $0x0
  802999:	6a 00                	push   $0x0
  80299b:	6a 00                	push   $0x0
  80299d:	6a 0f                	push   $0xf
  80299f:	e8 82 fe ff ff       	call   802826 <syscall>
  8029a4:	83 c4 18             	add    $0x18,%esp
}
  8029a7:	c9                   	leave  
  8029a8:	c3                   	ret    

008029a9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8029a9:	55                   	push   %ebp
  8029aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8029ac:	6a 00                	push   $0x0
  8029ae:	6a 00                	push   $0x0
  8029b0:	6a 00                	push   $0x0
  8029b2:	6a 00                	push   $0x0
  8029b4:	ff 75 08             	pushl  0x8(%ebp)
  8029b7:	6a 10                	push   $0x10
  8029b9:	e8 68 fe ff ff       	call   802826 <syscall>
  8029be:	83 c4 18             	add    $0x18,%esp
}
  8029c1:	c9                   	leave  
  8029c2:	c3                   	ret    

008029c3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8029c3:	55                   	push   %ebp
  8029c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8029c6:	6a 00                	push   $0x0
  8029c8:	6a 00                	push   $0x0
  8029ca:	6a 00                	push   $0x0
  8029cc:	6a 00                	push   $0x0
  8029ce:	6a 00                	push   $0x0
  8029d0:	6a 11                	push   $0x11
  8029d2:	e8 4f fe ff ff       	call   802826 <syscall>
  8029d7:	83 c4 18             	add    $0x18,%esp
}
  8029da:	90                   	nop
  8029db:	c9                   	leave  
  8029dc:	c3                   	ret    

008029dd <sys_cputc>:

void
sys_cputc(const char c)
{
  8029dd:	55                   	push   %ebp
  8029de:	89 e5                	mov    %esp,%ebp
  8029e0:	83 ec 04             	sub    $0x4,%esp
  8029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8029e9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029ed:	6a 00                	push   $0x0
  8029ef:	6a 00                	push   $0x0
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 00                	push   $0x0
  8029f5:	50                   	push   %eax
  8029f6:	6a 01                	push   $0x1
  8029f8:	e8 29 fe ff ff       	call   802826 <syscall>
  8029fd:	83 c4 18             	add    $0x18,%esp
}
  802a00:	90                   	nop
  802a01:	c9                   	leave  
  802a02:	c3                   	ret    

00802a03 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802a03:	55                   	push   %ebp
  802a04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802a06:	6a 00                	push   $0x0
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 00                	push   $0x0
  802a0e:	6a 00                	push   $0x0
  802a10:	6a 14                	push   $0x14
  802a12:	e8 0f fe ff ff       	call   802826 <syscall>
  802a17:	83 c4 18             	add    $0x18,%esp
}
  802a1a:	90                   	nop
  802a1b:	c9                   	leave  
  802a1c:	c3                   	ret    

00802a1d <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802a1d:	55                   	push   %ebp
  802a1e:	89 e5                	mov    %esp,%ebp
  802a20:	83 ec 04             	sub    $0x4,%esp
  802a23:	8b 45 10             	mov    0x10(%ebp),%eax
  802a26:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802a29:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a2c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	6a 00                	push   $0x0
  802a35:	51                   	push   %ecx
  802a36:	52                   	push   %edx
  802a37:	ff 75 0c             	pushl  0xc(%ebp)
  802a3a:	50                   	push   %eax
  802a3b:	6a 15                	push   $0x15
  802a3d:	e8 e4 fd ff ff       	call   802826 <syscall>
  802a42:	83 c4 18             	add    $0x18,%esp
}
  802a45:	c9                   	leave  
  802a46:	c3                   	ret    

00802a47 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802a47:	55                   	push   %ebp
  802a48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	6a 00                	push   $0x0
  802a52:	6a 00                	push   $0x0
  802a54:	6a 00                	push   $0x0
  802a56:	52                   	push   %edx
  802a57:	50                   	push   %eax
  802a58:	6a 16                	push   $0x16
  802a5a:	e8 c7 fd ff ff       	call   802826 <syscall>
  802a5f:	83 c4 18             	add    $0x18,%esp
}
  802a62:	c9                   	leave  
  802a63:	c3                   	ret    

00802a64 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802a64:	55                   	push   %ebp
  802a65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802a67:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	6a 00                	push   $0x0
  802a72:	6a 00                	push   $0x0
  802a74:	51                   	push   %ecx
  802a75:	52                   	push   %edx
  802a76:	50                   	push   %eax
  802a77:	6a 17                	push   $0x17
  802a79:	e8 a8 fd ff ff       	call   802826 <syscall>
  802a7e:	83 c4 18             	add    $0x18,%esp
}
  802a81:	c9                   	leave  
  802a82:	c3                   	ret    

00802a83 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802a83:	55                   	push   %ebp
  802a84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	6a 00                	push   $0x0
  802a8e:	6a 00                	push   $0x0
  802a90:	6a 00                	push   $0x0
  802a92:	52                   	push   %edx
  802a93:	50                   	push   %eax
  802a94:	6a 18                	push   $0x18
  802a96:	e8 8b fd ff ff       	call   802826 <syscall>
  802a9b:	83 c4 18             	add    $0x18,%esp
}
  802a9e:	c9                   	leave  
  802a9f:	c3                   	ret    

00802aa0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802aa0:	55                   	push   %ebp
  802aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	6a 00                	push   $0x0
  802aa8:	ff 75 14             	pushl  0x14(%ebp)
  802aab:	ff 75 10             	pushl  0x10(%ebp)
  802aae:	ff 75 0c             	pushl  0xc(%ebp)
  802ab1:	50                   	push   %eax
  802ab2:	6a 19                	push   $0x19
  802ab4:	e8 6d fd ff ff       	call   802826 <syscall>
  802ab9:	83 c4 18             	add    $0x18,%esp
}
  802abc:	c9                   	leave  
  802abd:	c3                   	ret    

00802abe <sys_run_env>:

void sys_run_env(int32 envId)
{
  802abe:	55                   	push   %ebp
  802abf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	6a 00                	push   $0x0
  802ac6:	6a 00                	push   $0x0
  802ac8:	6a 00                	push   $0x0
  802aca:	6a 00                	push   $0x0
  802acc:	50                   	push   %eax
  802acd:	6a 1a                	push   $0x1a
  802acf:	e8 52 fd ff ff       	call   802826 <syscall>
  802ad4:	83 c4 18             	add    $0x18,%esp
}
  802ad7:	90                   	nop
  802ad8:	c9                   	leave  
  802ad9:	c3                   	ret    

00802ada <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802ada:	55                   	push   %ebp
  802adb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802add:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae0:	6a 00                	push   $0x0
  802ae2:	6a 00                	push   $0x0
  802ae4:	6a 00                	push   $0x0
  802ae6:	6a 00                	push   $0x0
  802ae8:	50                   	push   %eax
  802ae9:	6a 1b                	push   $0x1b
  802aeb:	e8 36 fd ff ff       	call   802826 <syscall>
  802af0:	83 c4 18             	add    $0x18,%esp
}
  802af3:	c9                   	leave  
  802af4:	c3                   	ret    

00802af5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802af5:	55                   	push   %ebp
  802af6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802af8:	6a 00                	push   $0x0
  802afa:	6a 00                	push   $0x0
  802afc:	6a 00                	push   $0x0
  802afe:	6a 00                	push   $0x0
  802b00:	6a 00                	push   $0x0
  802b02:	6a 05                	push   $0x5
  802b04:	e8 1d fd ff ff       	call   802826 <syscall>
  802b09:	83 c4 18             	add    $0x18,%esp
}
  802b0c:	c9                   	leave  
  802b0d:	c3                   	ret    

00802b0e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802b0e:	55                   	push   %ebp
  802b0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802b11:	6a 00                	push   $0x0
  802b13:	6a 00                	push   $0x0
  802b15:	6a 00                	push   $0x0
  802b17:	6a 00                	push   $0x0
  802b19:	6a 00                	push   $0x0
  802b1b:	6a 06                	push   $0x6
  802b1d:	e8 04 fd ff ff       	call   802826 <syscall>
  802b22:	83 c4 18             	add    $0x18,%esp
}
  802b25:	c9                   	leave  
  802b26:	c3                   	ret    

00802b27 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802b27:	55                   	push   %ebp
  802b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802b2a:	6a 00                	push   $0x0
  802b2c:	6a 00                	push   $0x0
  802b2e:	6a 00                	push   $0x0
  802b30:	6a 00                	push   $0x0
  802b32:	6a 00                	push   $0x0
  802b34:	6a 07                	push   $0x7
  802b36:	e8 eb fc ff ff       	call   802826 <syscall>
  802b3b:	83 c4 18             	add    $0x18,%esp
}
  802b3e:	c9                   	leave  
  802b3f:	c3                   	ret    

00802b40 <sys_exit_env>:


void sys_exit_env(void)
{
  802b40:	55                   	push   %ebp
  802b41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802b43:	6a 00                	push   $0x0
  802b45:	6a 00                	push   $0x0
  802b47:	6a 00                	push   $0x0
  802b49:	6a 00                	push   $0x0
  802b4b:	6a 00                	push   $0x0
  802b4d:	6a 1c                	push   $0x1c
  802b4f:	e8 d2 fc ff ff       	call   802826 <syscall>
  802b54:	83 c4 18             	add    $0x18,%esp
}
  802b57:	90                   	nop
  802b58:	c9                   	leave  
  802b59:	c3                   	ret    

00802b5a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802b5a:	55                   	push   %ebp
  802b5b:	89 e5                	mov    %esp,%ebp
  802b5d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802b60:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b63:	8d 50 04             	lea    0x4(%eax),%edx
  802b66:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b69:	6a 00                	push   $0x0
  802b6b:	6a 00                	push   $0x0
  802b6d:	6a 00                	push   $0x0
  802b6f:	52                   	push   %edx
  802b70:	50                   	push   %eax
  802b71:	6a 1d                	push   $0x1d
  802b73:	e8 ae fc ff ff       	call   802826 <syscall>
  802b78:	83 c4 18             	add    $0x18,%esp
	return result;
  802b7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802b84:	89 01                	mov    %eax,(%ecx)
  802b86:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	c9                   	leave  
  802b8d:	c2 04 00             	ret    $0x4

00802b90 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802b90:	55                   	push   %ebp
  802b91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802b93:	6a 00                	push   $0x0
  802b95:	6a 00                	push   $0x0
  802b97:	ff 75 10             	pushl  0x10(%ebp)
  802b9a:	ff 75 0c             	pushl  0xc(%ebp)
  802b9d:	ff 75 08             	pushl  0x8(%ebp)
  802ba0:	6a 13                	push   $0x13
  802ba2:	e8 7f fc ff ff       	call   802826 <syscall>
  802ba7:	83 c4 18             	add    $0x18,%esp
	return ;
  802baa:	90                   	nop
}
  802bab:	c9                   	leave  
  802bac:	c3                   	ret    

00802bad <sys_rcr2>:
uint32 sys_rcr2()
{
  802bad:	55                   	push   %ebp
  802bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802bb0:	6a 00                	push   $0x0
  802bb2:	6a 00                	push   $0x0
  802bb4:	6a 00                	push   $0x0
  802bb6:	6a 00                	push   $0x0
  802bb8:	6a 00                	push   $0x0
  802bba:	6a 1e                	push   $0x1e
  802bbc:	e8 65 fc ff ff       	call   802826 <syscall>
  802bc1:	83 c4 18             	add    $0x18,%esp
}
  802bc4:	c9                   	leave  
  802bc5:	c3                   	ret    

00802bc6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802bc6:	55                   	push   %ebp
  802bc7:	89 e5                	mov    %esp,%ebp
  802bc9:	83 ec 04             	sub    $0x4,%esp
  802bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802bd2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802bd6:	6a 00                	push   $0x0
  802bd8:	6a 00                	push   $0x0
  802bda:	6a 00                	push   $0x0
  802bdc:	6a 00                	push   $0x0
  802bde:	50                   	push   %eax
  802bdf:	6a 1f                	push   $0x1f
  802be1:	e8 40 fc ff ff       	call   802826 <syscall>
  802be6:	83 c4 18             	add    $0x18,%esp
	return ;
  802be9:	90                   	nop
}
  802bea:	c9                   	leave  
  802beb:	c3                   	ret    

00802bec <rsttst>:
void rsttst()
{
  802bec:	55                   	push   %ebp
  802bed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802bef:	6a 00                	push   $0x0
  802bf1:	6a 00                	push   $0x0
  802bf3:	6a 00                	push   $0x0
  802bf5:	6a 00                	push   $0x0
  802bf7:	6a 00                	push   $0x0
  802bf9:	6a 21                	push   $0x21
  802bfb:	e8 26 fc ff ff       	call   802826 <syscall>
  802c00:	83 c4 18             	add    $0x18,%esp
	return ;
  802c03:	90                   	nop
}
  802c04:	c9                   	leave  
  802c05:	c3                   	ret    

00802c06 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802c06:	55                   	push   %ebp
  802c07:	89 e5                	mov    %esp,%ebp
  802c09:	83 ec 04             	sub    $0x4,%esp
  802c0c:	8b 45 14             	mov    0x14(%ebp),%eax
  802c0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802c12:	8b 55 18             	mov    0x18(%ebp),%edx
  802c15:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c19:	52                   	push   %edx
  802c1a:	50                   	push   %eax
  802c1b:	ff 75 10             	pushl  0x10(%ebp)
  802c1e:	ff 75 0c             	pushl  0xc(%ebp)
  802c21:	ff 75 08             	pushl  0x8(%ebp)
  802c24:	6a 20                	push   $0x20
  802c26:	e8 fb fb ff ff       	call   802826 <syscall>
  802c2b:	83 c4 18             	add    $0x18,%esp
	return ;
  802c2e:	90                   	nop
}
  802c2f:	c9                   	leave  
  802c30:	c3                   	ret    

00802c31 <chktst>:
void chktst(uint32 n)
{
  802c31:	55                   	push   %ebp
  802c32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802c34:	6a 00                	push   $0x0
  802c36:	6a 00                	push   $0x0
  802c38:	6a 00                	push   $0x0
  802c3a:	6a 00                	push   $0x0
  802c3c:	ff 75 08             	pushl  0x8(%ebp)
  802c3f:	6a 22                	push   $0x22
  802c41:	e8 e0 fb ff ff       	call   802826 <syscall>
  802c46:	83 c4 18             	add    $0x18,%esp
	return ;
  802c49:	90                   	nop
}
  802c4a:	c9                   	leave  
  802c4b:	c3                   	ret    

00802c4c <inctst>:

void inctst()
{
  802c4c:	55                   	push   %ebp
  802c4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802c4f:	6a 00                	push   $0x0
  802c51:	6a 00                	push   $0x0
  802c53:	6a 00                	push   $0x0
  802c55:	6a 00                	push   $0x0
  802c57:	6a 00                	push   $0x0
  802c59:	6a 23                	push   $0x23
  802c5b:	e8 c6 fb ff ff       	call   802826 <syscall>
  802c60:	83 c4 18             	add    $0x18,%esp
	return ;
  802c63:	90                   	nop
}
  802c64:	c9                   	leave  
  802c65:	c3                   	ret    

00802c66 <gettst>:
uint32 gettst()
{
  802c66:	55                   	push   %ebp
  802c67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802c69:	6a 00                	push   $0x0
  802c6b:	6a 00                	push   $0x0
  802c6d:	6a 00                	push   $0x0
  802c6f:	6a 00                	push   $0x0
  802c71:	6a 00                	push   $0x0
  802c73:	6a 24                	push   $0x24
  802c75:	e8 ac fb ff ff       	call   802826 <syscall>
  802c7a:	83 c4 18             	add    $0x18,%esp
}
  802c7d:	c9                   	leave  
  802c7e:	c3                   	ret    

00802c7f <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802c7f:	55                   	push   %ebp
  802c80:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c82:	6a 00                	push   $0x0
  802c84:	6a 00                	push   $0x0
  802c86:	6a 00                	push   $0x0
  802c88:	6a 00                	push   $0x0
  802c8a:	6a 00                	push   $0x0
  802c8c:	6a 25                	push   $0x25
  802c8e:	e8 93 fb ff ff       	call   802826 <syscall>
  802c93:	83 c4 18             	add    $0x18,%esp
  802c96:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802c9b:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802ca0:	c9                   	leave  
  802ca1:	c3                   	ret    

00802ca2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ca2:	55                   	push   %ebp
  802ca3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802cad:	6a 00                	push   $0x0
  802caf:	6a 00                	push   $0x0
  802cb1:	6a 00                	push   $0x0
  802cb3:	6a 00                	push   $0x0
  802cb5:	ff 75 08             	pushl  0x8(%ebp)
  802cb8:	6a 26                	push   $0x26
  802cba:	e8 67 fb ff ff       	call   802826 <syscall>
  802cbf:	83 c4 18             	add    $0x18,%esp
	return ;
  802cc2:	90                   	nop
}
  802cc3:	c9                   	leave  
  802cc4:	c3                   	ret    

00802cc5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802cc5:	55                   	push   %ebp
  802cc6:	89 e5                	mov    %esp,%ebp
  802cc8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802cc9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ccc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	6a 00                	push   $0x0
  802cd7:	53                   	push   %ebx
  802cd8:	51                   	push   %ecx
  802cd9:	52                   	push   %edx
  802cda:	50                   	push   %eax
  802cdb:	6a 27                	push   $0x27
  802cdd:	e8 44 fb ff ff       	call   802826 <syscall>
  802ce2:	83 c4 18             	add    $0x18,%esp
}
  802ce5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ce8:	c9                   	leave  
  802ce9:	c3                   	ret    

00802cea <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802cea:	55                   	push   %ebp
  802ceb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802ced:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	6a 00                	push   $0x0
  802cf5:	6a 00                	push   $0x0
  802cf7:	6a 00                	push   $0x0
  802cf9:	52                   	push   %edx
  802cfa:	50                   	push   %eax
  802cfb:	6a 28                	push   $0x28
  802cfd:	e8 24 fb ff ff       	call   802826 <syscall>
  802d02:	83 c4 18             	add    $0x18,%esp
}
  802d05:	c9                   	leave  
  802d06:	c3                   	ret    

00802d07 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802d07:	55                   	push   %ebp
  802d08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802d0a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	6a 00                	push   $0x0
  802d15:	51                   	push   %ecx
  802d16:	ff 75 10             	pushl  0x10(%ebp)
  802d19:	52                   	push   %edx
  802d1a:	50                   	push   %eax
  802d1b:	6a 29                	push   $0x29
  802d1d:	e8 04 fb ff ff       	call   802826 <syscall>
  802d22:	83 c4 18             	add    $0x18,%esp
}
  802d25:	c9                   	leave  
  802d26:	c3                   	ret    

00802d27 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802d27:	55                   	push   %ebp
  802d28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802d2a:	6a 00                	push   $0x0
  802d2c:	6a 00                	push   $0x0
  802d2e:	ff 75 10             	pushl  0x10(%ebp)
  802d31:	ff 75 0c             	pushl  0xc(%ebp)
  802d34:	ff 75 08             	pushl  0x8(%ebp)
  802d37:	6a 12                	push   $0x12
  802d39:	e8 e8 fa ff ff       	call   802826 <syscall>
  802d3e:	83 c4 18             	add    $0x18,%esp
	return ;
  802d41:	90                   	nop
}
  802d42:	c9                   	leave  
  802d43:	c3                   	ret    

00802d44 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802d44:	55                   	push   %ebp
  802d45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802d47:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	6a 00                	push   $0x0
  802d4f:	6a 00                	push   $0x0
  802d51:	6a 00                	push   $0x0
  802d53:	52                   	push   %edx
  802d54:	50                   	push   %eax
  802d55:	6a 2a                	push   $0x2a
  802d57:	e8 ca fa ff ff       	call   802826 <syscall>
  802d5c:	83 c4 18             	add    $0x18,%esp
	return;
  802d5f:	90                   	nop
}
  802d60:	c9                   	leave  
  802d61:	c3                   	ret    

00802d62 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802d62:	55                   	push   %ebp
  802d63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802d65:	6a 00                	push   $0x0
  802d67:	6a 00                	push   $0x0
  802d69:	6a 00                	push   $0x0
  802d6b:	6a 00                	push   $0x0
  802d6d:	6a 00                	push   $0x0
  802d6f:	6a 2b                	push   $0x2b
  802d71:	e8 b0 fa ff ff       	call   802826 <syscall>
  802d76:	83 c4 18             	add    $0x18,%esp
}
  802d79:	c9                   	leave  
  802d7a:	c3                   	ret    

00802d7b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802d7b:	55                   	push   %ebp
  802d7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802d7e:	6a 00                	push   $0x0
  802d80:	6a 00                	push   $0x0
  802d82:	6a 00                	push   $0x0
  802d84:	ff 75 0c             	pushl  0xc(%ebp)
  802d87:	ff 75 08             	pushl  0x8(%ebp)
  802d8a:	6a 2d                	push   $0x2d
  802d8c:	e8 95 fa ff ff       	call   802826 <syscall>
  802d91:	83 c4 18             	add    $0x18,%esp
	return;
  802d94:	90                   	nop
}
  802d95:	c9                   	leave  
  802d96:	c3                   	ret    

00802d97 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802d97:	55                   	push   %ebp
  802d98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802d9a:	6a 00                	push   $0x0
  802d9c:	6a 00                	push   $0x0
  802d9e:	6a 00                	push   $0x0
  802da0:	ff 75 0c             	pushl  0xc(%ebp)
  802da3:	ff 75 08             	pushl  0x8(%ebp)
  802da6:	6a 2c                	push   $0x2c
  802da8:	e8 79 fa ff ff       	call   802826 <syscall>
  802dad:	83 c4 18             	add    $0x18,%esp
	return ;
  802db0:	90                   	nop
}
  802db1:	c9                   	leave  
  802db2:	c3                   	ret    

00802db3 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802db3:	55                   	push   %ebp
  802db4:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802db6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	6a 00                	push   $0x0
  802dbe:	6a 00                	push   $0x0
  802dc0:	6a 00                	push   $0x0
  802dc2:	52                   	push   %edx
  802dc3:	50                   	push   %eax
  802dc4:	6a 2e                	push   $0x2e
  802dc6:	e8 5b fa ff ff       	call   802826 <syscall>
  802dcb:	83 c4 18             	add    $0x18,%esp
	return ;
  802dce:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802dcf:	c9                   	leave  
  802dd0:	c3                   	ret    

00802dd1 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802dd1:	55                   	push   %ebp
  802dd2:	89 e5                	mov    %esp,%ebp
  802dd4:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802dd7:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802dde:	72 09                	jb     802de9 <to_page_va+0x18>
  802de0:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802de7:	72 14                	jb     802dfd <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802de9:	83 ec 04             	sub    $0x4,%esp
  802dec:	68 d4 49 80 00       	push   $0x8049d4
  802df1:	6a 15                	push   $0x15
  802df3:	68 ff 49 80 00       	push   $0x8049ff
  802df8:	e8 46 d9 ff ff       	call   800743 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802e00:	ba 60 50 80 00       	mov    $0x805060,%edx
  802e05:	29 d0                	sub    %edx,%eax
  802e07:	c1 f8 02             	sar    $0x2,%eax
  802e0a:	89 c2                	mov    %eax,%edx
  802e0c:	89 d0                	mov    %edx,%eax
  802e0e:	c1 e0 02             	shl    $0x2,%eax
  802e11:	01 d0                	add    %edx,%eax
  802e13:	c1 e0 02             	shl    $0x2,%eax
  802e16:	01 d0                	add    %edx,%eax
  802e18:	c1 e0 02             	shl    $0x2,%eax
  802e1b:	01 d0                	add    %edx,%eax
  802e1d:	89 c1                	mov    %eax,%ecx
  802e1f:	c1 e1 08             	shl    $0x8,%ecx
  802e22:	01 c8                	add    %ecx,%eax
  802e24:	89 c1                	mov    %eax,%ecx
  802e26:	c1 e1 10             	shl    $0x10,%ecx
  802e29:	01 c8                	add    %ecx,%eax
  802e2b:	01 c0                	add    %eax,%eax
  802e2d:	01 d0                	add    %edx,%eax
  802e2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	c1 e0 0c             	shl    $0xc,%eax
  802e38:	89 c2                	mov    %eax,%edx
  802e3a:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802e3f:	01 d0                	add    %edx,%eax
}
  802e41:	c9                   	leave  
  802e42:	c3                   	ret    

00802e43 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802e43:	55                   	push   %ebp
  802e44:	89 e5                	mov    %esp,%ebp
  802e46:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802e49:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802e4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e51:	29 c2                	sub    %eax,%edx
  802e53:	89 d0                	mov    %edx,%eax
  802e55:	c1 e8 0c             	shr    $0xc,%eax
  802e58:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802e5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5f:	78 09                	js     802e6a <to_page_info+0x27>
  802e61:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802e68:	7e 14                	jle    802e7e <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802e6a:	83 ec 04             	sub    $0x4,%esp
  802e6d:	68 18 4a 80 00       	push   $0x804a18
  802e72:	6a 22                	push   $0x22
  802e74:	68 ff 49 80 00       	push   $0x8049ff
  802e79:	e8 c5 d8 ff ff       	call   800743 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802e7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e81:	89 d0                	mov    %edx,%eax
  802e83:	01 c0                	add    %eax,%eax
  802e85:	01 d0                	add    %edx,%eax
  802e87:	c1 e0 02             	shl    $0x2,%eax
  802e8a:	05 60 50 80 00       	add    $0x805060,%eax
}
  802e8f:	c9                   	leave  
  802e90:	c3                   	ret    

00802e91 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802e91:	55                   	push   %ebp
  802e92:	89 e5                	mov    %esp,%ebp
  802e94:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	05 00 00 00 02       	add    $0x2000000,%eax
  802e9f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ea2:	73 16                	jae    802eba <initialize_dynamic_allocator+0x29>
  802ea4:	68 3c 4a 80 00       	push   $0x804a3c
  802ea9:	68 62 4a 80 00       	push   $0x804a62
  802eae:	6a 34                	push   $0x34
  802eb0:	68 ff 49 80 00       	push   $0x8049ff
  802eb5:	e8 89 d8 ff ff       	call   800743 <_panic>
		is_initialized = 1;
  802eba:	c7 05 38 50 80 00 01 	movl   $0x1,0x805038
  802ec1:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ecf:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802ed4:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802edb:	00 00 00 
  802ede:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802ee5:	00 00 00 
  802ee8:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802eef:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802ef2:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802ef9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f00:	eb 36                	jmp    802f38 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	c1 e0 04             	shl    $0x4,%eax
  802f08:	05 80 d0 81 00       	add    $0x81d080,%eax
  802f0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f16:	c1 e0 04             	shl    $0x4,%eax
  802f19:	05 84 d0 81 00       	add    $0x81d084,%eax
  802f1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	c1 e0 04             	shl    $0x4,%eax
  802f2a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802f35:	ff 45 f4             	incl   -0xc(%ebp)
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802f3e:	72 c2                	jb     802f02 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802f40:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802f46:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802f4b:	29 c2                	sub    %eax,%edx
  802f4d:	89 d0                	mov    %edx,%eax
  802f4f:	c1 e8 0c             	shr    $0xc,%eax
  802f52:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802f55:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802f5c:	e9 c8 00 00 00       	jmp    803029 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802f61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f64:	89 d0                	mov    %edx,%eax
  802f66:	01 c0                	add    %eax,%eax
  802f68:	01 d0                	add    %edx,%eax
  802f6a:	c1 e0 02             	shl    $0x2,%eax
  802f6d:	05 68 50 80 00       	add    $0x805068,%eax
  802f72:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802f77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f7a:	89 d0                	mov    %edx,%eax
  802f7c:	01 c0                	add    %eax,%eax
  802f7e:	01 d0                	add    %edx,%eax
  802f80:	c1 e0 02             	shl    $0x2,%eax
  802f83:	05 6a 50 80 00       	add    $0x80506a,%eax
  802f88:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802f8d:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802f93:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802f96:	89 c8                	mov    %ecx,%eax
  802f98:	01 c0                	add    %eax,%eax
  802f9a:	01 c8                	add    %ecx,%eax
  802f9c:	c1 e0 02             	shl    $0x2,%eax
  802f9f:	05 64 50 80 00       	add    $0x805064,%eax
  802fa4:	89 10                	mov    %edx,(%eax)
  802fa6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa9:	89 d0                	mov    %edx,%eax
  802fab:	01 c0                	add    %eax,%eax
  802fad:	01 d0                	add    %edx,%eax
  802faf:	c1 e0 02             	shl    $0x2,%eax
  802fb2:	05 64 50 80 00       	add    $0x805064,%eax
  802fb7:	8b 00                	mov    (%eax),%eax
  802fb9:	85 c0                	test   %eax,%eax
  802fbb:	74 1b                	je     802fd8 <initialize_dynamic_allocator+0x147>
  802fbd:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802fc3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802fc6:	89 c8                	mov    %ecx,%eax
  802fc8:	01 c0                	add    %eax,%eax
  802fca:	01 c8                	add    %ecx,%eax
  802fcc:	c1 e0 02             	shl    $0x2,%eax
  802fcf:	05 60 50 80 00       	add    $0x805060,%eax
  802fd4:	89 02                	mov    %eax,(%edx)
  802fd6:	eb 16                	jmp    802fee <initialize_dynamic_allocator+0x15d>
  802fd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fdb:	89 d0                	mov    %edx,%eax
  802fdd:	01 c0                	add    %eax,%eax
  802fdf:	01 d0                	add    %edx,%eax
  802fe1:	c1 e0 02             	shl    $0x2,%eax
  802fe4:	05 60 50 80 00       	add    $0x805060,%eax
  802fe9:	a3 48 50 80 00       	mov    %eax,0x805048
  802fee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ff1:	89 d0                	mov    %edx,%eax
  802ff3:	01 c0                	add    %eax,%eax
  802ff5:	01 d0                	add    %edx,%eax
  802ff7:	c1 e0 02             	shl    $0x2,%eax
  802ffa:	05 60 50 80 00       	add    $0x805060,%eax
  802fff:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803004:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803007:	89 d0                	mov    %edx,%eax
  803009:	01 c0                	add    %eax,%eax
  80300b:	01 d0                	add    %edx,%eax
  80300d:	c1 e0 02             	shl    $0x2,%eax
  803010:	05 60 50 80 00       	add    $0x805060,%eax
  803015:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301b:	a1 54 50 80 00       	mov    0x805054,%eax
  803020:	40                   	inc    %eax
  803021:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803026:	ff 45 f0             	incl   -0x10(%ebp)
  803029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80302f:	0f 82 2c ff ff ff    	jb     802f61 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803035:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803038:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80303b:	eb 2f                	jmp    80306c <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  80303d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803040:	89 d0                	mov    %edx,%eax
  803042:	01 c0                	add    %eax,%eax
  803044:	01 d0                	add    %edx,%eax
  803046:	c1 e0 02             	shl    $0x2,%eax
  803049:	05 68 50 80 00       	add    $0x805068,%eax
  80304e:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803053:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803056:	89 d0                	mov    %edx,%eax
  803058:	01 c0                	add    %eax,%eax
  80305a:	01 d0                	add    %edx,%eax
  80305c:	c1 e0 02             	shl    $0x2,%eax
  80305f:	05 6a 50 80 00       	add    $0x80506a,%eax
  803064:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803069:	ff 45 ec             	incl   -0x14(%ebp)
  80306c:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803073:	76 c8                	jbe    80303d <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803075:	90                   	nop
  803076:	c9                   	leave  
  803077:	c3                   	ret    

00803078 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803078:	55                   	push   %ebp
  803079:	89 e5                	mov    %esp,%ebp
  80307b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  80307e:	8b 55 08             	mov    0x8(%ebp),%edx
  803081:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803086:	29 c2                	sub    %eax,%edx
  803088:	89 d0                	mov    %edx,%eax
  80308a:	c1 e8 0c             	shr    $0xc,%eax
  80308d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803090:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803093:	89 d0                	mov    %edx,%eax
  803095:	01 c0                	add    %eax,%eax
  803097:	01 d0                	add    %edx,%eax
  803099:	c1 e0 02             	shl    $0x2,%eax
  80309c:	05 68 50 80 00       	add    $0x805068,%eax
  8030a1:	8b 00                	mov    (%eax),%eax
  8030a3:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8030a6:	c9                   	leave  
  8030a7:	c3                   	ret    

008030a8 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8030a8:	55                   	push   %ebp
  8030a9:	89 e5                	mov    %esp,%ebp
  8030ab:	83 ec 14             	sub    $0x14,%esp
  8030ae:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  8030b1:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8030b5:	77 07                	ja     8030be <nearest_pow2_ceil.1513+0x16>
  8030b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8030bc:	eb 20                	jmp    8030de <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  8030be:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  8030c5:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  8030c8:	eb 08                	jmp    8030d2 <nearest_pow2_ceil.1513+0x2a>
  8030ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030cd:	01 c0                	add    %eax,%eax
  8030cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8030d2:	d1 6d 08             	shrl   0x8(%ebp)
  8030d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d9:	75 ef                	jne    8030ca <nearest_pow2_ceil.1513+0x22>
        return power;
  8030db:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8030de:	c9                   	leave  
  8030df:	c3                   	ret    

008030e0 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8030e0:	55                   	push   %ebp
  8030e1:	89 e5                	mov    %esp,%ebp
  8030e3:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8030e6:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8030ed:	76 16                	jbe    803105 <alloc_block+0x25>
  8030ef:	68 78 4a 80 00       	push   $0x804a78
  8030f4:	68 62 4a 80 00       	push   $0x804a62
  8030f9:	6a 72                	push   $0x72
  8030fb:	68 ff 49 80 00       	push   $0x8049ff
  803100:	e8 3e d6 ff ff       	call   800743 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  803105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803109:	75 0a                	jne    803115 <alloc_block+0x35>
  80310b:	b8 00 00 00 00       	mov    $0x0,%eax
  803110:	e9 bd 04 00 00       	jmp    8035d2 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803115:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  80311c:	8b 45 08             	mov    0x8(%ebp),%eax
  80311f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803122:	73 06                	jae    80312a <alloc_block+0x4a>
        size = min_block_size;
  803124:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803127:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  80312a:	83 ec 0c             	sub    $0xc,%esp
  80312d:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803130:	ff 75 08             	pushl  0x8(%ebp)
  803133:	89 c1                	mov    %eax,%ecx
  803135:	e8 6e ff ff ff       	call   8030a8 <nearest_pow2_ceil.1513>
  80313a:	83 c4 10             	add    $0x10,%esp
  80313d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  803140:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803143:	83 ec 0c             	sub    $0xc,%esp
  803146:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803149:	52                   	push   %edx
  80314a:	89 c1                	mov    %eax,%ecx
  80314c:	e8 83 04 00 00       	call   8035d4 <log2_ceil.1520>
  803151:	83 c4 10             	add    $0x10,%esp
  803154:	83 e8 03             	sub    $0x3,%eax
  803157:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  80315a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315d:	c1 e0 04             	shl    $0x4,%eax
  803160:	05 80 d0 81 00       	add    $0x81d080,%eax
  803165:	8b 00                	mov    (%eax),%eax
  803167:	85 c0                	test   %eax,%eax
  803169:	0f 84 d8 00 00 00    	je     803247 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  80316f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803172:	c1 e0 04             	shl    $0x4,%eax
  803175:	05 80 d0 81 00       	add    $0x81d080,%eax
  80317a:	8b 00                	mov    (%eax),%eax
  80317c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  80317f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803183:	75 17                	jne    80319c <alloc_block+0xbc>
  803185:	83 ec 04             	sub    $0x4,%esp
  803188:	68 99 4a 80 00       	push   $0x804a99
  80318d:	68 98 00 00 00       	push   $0x98
  803192:	68 ff 49 80 00       	push   $0x8049ff
  803197:	e8 a7 d5 ff ff       	call   800743 <_panic>
  80319c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80319f:	8b 00                	mov    (%eax),%eax
  8031a1:	85 c0                	test   %eax,%eax
  8031a3:	74 10                	je     8031b5 <alloc_block+0xd5>
  8031a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031a8:	8b 00                	mov    (%eax),%eax
  8031aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031ad:	8b 52 04             	mov    0x4(%edx),%edx
  8031b0:	89 50 04             	mov    %edx,0x4(%eax)
  8031b3:	eb 14                	jmp    8031c9 <alloc_block+0xe9>
  8031b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031b8:	8b 40 04             	mov    0x4(%eax),%eax
  8031bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031be:	c1 e2 04             	shl    $0x4,%edx
  8031c1:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8031c7:	89 02                	mov    %eax,(%edx)
  8031c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031cc:	8b 40 04             	mov    0x4(%eax),%eax
  8031cf:	85 c0                	test   %eax,%eax
  8031d1:	74 0f                	je     8031e2 <alloc_block+0x102>
  8031d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031d6:	8b 40 04             	mov    0x4(%eax),%eax
  8031d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031dc:	8b 12                	mov    (%edx),%edx
  8031de:	89 10                	mov    %edx,(%eax)
  8031e0:	eb 13                	jmp    8031f5 <alloc_block+0x115>
  8031e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e5:	8b 00                	mov    (%eax),%eax
  8031e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031ea:	c1 e2 04             	shl    $0x4,%edx
  8031ed:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8031f3:	89 02                	mov    %eax,(%edx)
  8031f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803201:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803208:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80320b:	c1 e0 04             	shl    $0x4,%eax
  80320e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	8d 50 ff             	lea    -0x1(%eax),%edx
  803218:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80321b:	c1 e0 04             	shl    $0x4,%eax
  80321e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803223:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803225:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803228:	83 ec 0c             	sub    $0xc,%esp
  80322b:	50                   	push   %eax
  80322c:	e8 12 fc ff ff       	call   802e43 <to_page_info>
  803231:	83 c4 10             	add    $0x10,%esp
  803234:	89 c2                	mov    %eax,%edx
  803236:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80323a:	48                   	dec    %eax
  80323b:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  80323f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803242:	e9 8b 03 00 00       	jmp    8035d2 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  803247:	a1 48 50 80 00       	mov    0x805048,%eax
  80324c:	85 c0                	test   %eax,%eax
  80324e:	0f 84 64 02 00 00    	je     8034b8 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803254:	a1 48 50 80 00       	mov    0x805048,%eax
  803259:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  80325c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803260:	75 17                	jne    803279 <alloc_block+0x199>
  803262:	83 ec 04             	sub    $0x4,%esp
  803265:	68 99 4a 80 00       	push   $0x804a99
  80326a:	68 a0 00 00 00       	push   $0xa0
  80326f:	68 ff 49 80 00       	push   $0x8049ff
  803274:	e8 ca d4 ff ff       	call   800743 <_panic>
  803279:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	85 c0                	test   %eax,%eax
  803280:	74 10                	je     803292 <alloc_block+0x1b2>
  803282:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803285:	8b 00                	mov    (%eax),%eax
  803287:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80328a:	8b 52 04             	mov    0x4(%edx),%edx
  80328d:	89 50 04             	mov    %edx,0x4(%eax)
  803290:	eb 0b                	jmp    80329d <alloc_block+0x1bd>
  803292:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803295:	8b 40 04             	mov    0x4(%eax),%eax
  803298:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80329d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a0:	8b 40 04             	mov    0x4(%eax),%eax
  8032a3:	85 c0                	test   %eax,%eax
  8032a5:	74 0f                	je     8032b6 <alloc_block+0x1d6>
  8032a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032aa:	8b 40 04             	mov    0x4(%eax),%eax
  8032ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032b0:	8b 12                	mov    (%edx),%edx
  8032b2:	89 10                	mov    %edx,(%eax)
  8032b4:	eb 0a                	jmp    8032c0 <alloc_block+0x1e0>
  8032b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b9:	8b 00                	mov    (%eax),%eax
  8032bb:	a3 48 50 80 00       	mov    %eax,0x805048
  8032c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d3:	a1 54 50 80 00       	mov    0x805054,%eax
  8032d8:	48                   	dec    %eax
  8032d9:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  8032de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032e4:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  8032e8:	b8 00 10 00 00       	mov    $0x1000,%eax
  8032ed:	99                   	cltd   
  8032ee:	f7 7d e8             	idivl  -0x18(%ebp)
  8032f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032f4:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  8032f8:	83 ec 0c             	sub    $0xc,%esp
  8032fb:	ff 75 dc             	pushl  -0x24(%ebp)
  8032fe:	e8 ce fa ff ff       	call   802dd1 <to_page_va>
  803303:	83 c4 10             	add    $0x10,%esp
  803306:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  803309:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80330c:	83 ec 0c             	sub    $0xc,%esp
  80330f:	50                   	push   %eax
  803310:	e8 c0 ee ff ff       	call   8021d5 <get_page>
  803315:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803318:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80331f:	e9 aa 00 00 00       	jmp    8033ce <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803327:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  80332b:	89 c2                	mov    %eax,%edx
  80332d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803330:	01 d0                	add    %edx,%eax
  803332:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  803335:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803339:	75 17                	jne    803352 <alloc_block+0x272>
  80333b:	83 ec 04             	sub    $0x4,%esp
  80333e:	68 b8 4a 80 00       	push   $0x804ab8
  803343:	68 aa 00 00 00       	push   $0xaa
  803348:	68 ff 49 80 00       	push   $0x8049ff
  80334d:	e8 f1 d3 ff ff       	call   800743 <_panic>
  803352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803355:	c1 e0 04             	shl    $0x4,%eax
  803358:	05 84 d0 81 00       	add    $0x81d084,%eax
  80335d:	8b 10                	mov    (%eax),%edx
  80335f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803362:	89 50 04             	mov    %edx,0x4(%eax)
  803365:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803368:	8b 40 04             	mov    0x4(%eax),%eax
  80336b:	85 c0                	test   %eax,%eax
  80336d:	74 14                	je     803383 <alloc_block+0x2a3>
  80336f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803372:	c1 e0 04             	shl    $0x4,%eax
  803375:	05 84 d0 81 00       	add    $0x81d084,%eax
  80337a:	8b 00                	mov    (%eax),%eax
  80337c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80337f:	89 10                	mov    %edx,(%eax)
  803381:	eb 11                	jmp    803394 <alloc_block+0x2b4>
  803383:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803386:	c1 e0 04             	shl    $0x4,%eax
  803389:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  80338f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803392:	89 02                	mov    %eax,(%edx)
  803394:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803397:	c1 e0 04             	shl    $0x4,%eax
  80339a:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  8033a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033a3:	89 02                	mov    %eax,(%edx)
  8033a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b1:	c1 e0 04             	shl    $0x4,%eax
  8033b4:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033b9:	8b 00                	mov    (%eax),%eax
  8033bb:	8d 50 01             	lea    0x1(%eax),%edx
  8033be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c1:	c1 e0 04             	shl    $0x4,%eax
  8033c4:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033c9:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8033cb:	ff 45 f4             	incl   -0xc(%ebp)
  8033ce:	b8 00 10 00 00       	mov    $0x1000,%eax
  8033d3:	99                   	cltd   
  8033d4:	f7 7d e8             	idivl  -0x18(%ebp)
  8033d7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8033da:	0f 8f 44 ff ff ff    	jg     803324 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8033e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e3:	c1 e0 04             	shl    $0x4,%eax
  8033e6:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033eb:	8b 00                	mov    (%eax),%eax
  8033ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  8033f0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033f4:	75 17                	jne    80340d <alloc_block+0x32d>
  8033f6:	83 ec 04             	sub    $0x4,%esp
  8033f9:	68 99 4a 80 00       	push   $0x804a99
  8033fe:	68 ae 00 00 00       	push   $0xae
  803403:	68 ff 49 80 00       	push   $0x8049ff
  803408:	e8 36 d3 ff ff       	call   800743 <_panic>
  80340d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803410:	8b 00                	mov    (%eax),%eax
  803412:	85 c0                	test   %eax,%eax
  803414:	74 10                	je     803426 <alloc_block+0x346>
  803416:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80341e:	8b 52 04             	mov    0x4(%edx),%edx
  803421:	89 50 04             	mov    %edx,0x4(%eax)
  803424:	eb 14                	jmp    80343a <alloc_block+0x35a>
  803426:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803429:	8b 40 04             	mov    0x4(%eax),%eax
  80342c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80342f:	c1 e2 04             	shl    $0x4,%edx
  803432:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803438:	89 02                	mov    %eax,(%edx)
  80343a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80343d:	8b 40 04             	mov    0x4(%eax),%eax
  803440:	85 c0                	test   %eax,%eax
  803442:	74 0f                	je     803453 <alloc_block+0x373>
  803444:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803447:	8b 40 04             	mov    0x4(%eax),%eax
  80344a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80344d:	8b 12                	mov    (%edx),%edx
  80344f:	89 10                	mov    %edx,(%eax)
  803451:	eb 13                	jmp    803466 <alloc_block+0x386>
  803453:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803456:	8b 00                	mov    (%eax),%eax
  803458:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80345b:	c1 e2 04             	shl    $0x4,%edx
  80345e:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803464:	89 02                	mov    %eax,(%edx)
  803466:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80346f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803472:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347c:	c1 e0 04             	shl    $0x4,%eax
  80347f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803484:	8b 00                	mov    (%eax),%eax
  803486:	8d 50 ff             	lea    -0x1(%eax),%edx
  803489:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348c:	c1 e0 04             	shl    $0x4,%eax
  80348f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803494:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803496:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803499:	83 ec 0c             	sub    $0xc,%esp
  80349c:	50                   	push   %eax
  80349d:	e8 a1 f9 ff ff       	call   802e43 <to_page_info>
  8034a2:	83 c4 10             	add    $0x10,%esp
  8034a5:	89 c2                	mov    %eax,%edx
  8034a7:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8034ab:	48                   	dec    %eax
  8034ac:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  8034b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034b3:	e9 1a 01 00 00       	jmp    8035d2 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8034b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034bb:	40                   	inc    %eax
  8034bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8034bf:	e9 ed 00 00 00       	jmp    8035b1 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  8034c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c7:	c1 e0 04             	shl    $0x4,%eax
  8034ca:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034cf:	8b 00                	mov    (%eax),%eax
  8034d1:	85 c0                	test   %eax,%eax
  8034d3:	0f 84 d5 00 00 00    	je     8035ae <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  8034d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034dc:	c1 e0 04             	shl    $0x4,%eax
  8034df:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034e4:	8b 00                	mov    (%eax),%eax
  8034e6:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  8034e9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8034ed:	75 17                	jne    803506 <alloc_block+0x426>
  8034ef:	83 ec 04             	sub    $0x4,%esp
  8034f2:	68 99 4a 80 00       	push   $0x804a99
  8034f7:	68 b8 00 00 00       	push   $0xb8
  8034fc:	68 ff 49 80 00       	push   $0x8049ff
  803501:	e8 3d d2 ff ff       	call   800743 <_panic>
  803506:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803509:	8b 00                	mov    (%eax),%eax
  80350b:	85 c0                	test   %eax,%eax
  80350d:	74 10                	je     80351f <alloc_block+0x43f>
  80350f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803512:	8b 00                	mov    (%eax),%eax
  803514:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803517:	8b 52 04             	mov    0x4(%edx),%edx
  80351a:	89 50 04             	mov    %edx,0x4(%eax)
  80351d:	eb 14                	jmp    803533 <alloc_block+0x453>
  80351f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803522:	8b 40 04             	mov    0x4(%eax),%eax
  803525:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803528:	c1 e2 04             	shl    $0x4,%edx
  80352b:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803531:	89 02                	mov    %eax,(%edx)
  803533:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803536:	8b 40 04             	mov    0x4(%eax),%eax
  803539:	85 c0                	test   %eax,%eax
  80353b:	74 0f                	je     80354c <alloc_block+0x46c>
  80353d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803540:	8b 40 04             	mov    0x4(%eax),%eax
  803543:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803546:	8b 12                	mov    (%edx),%edx
  803548:	89 10                	mov    %edx,(%eax)
  80354a:	eb 13                	jmp    80355f <alloc_block+0x47f>
  80354c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80354f:	8b 00                	mov    (%eax),%eax
  803551:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803554:	c1 e2 04             	shl    $0x4,%edx
  803557:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80355d:	89 02                	mov    %eax,(%edx)
  80355f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803562:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803568:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80356b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803575:	c1 e0 04             	shl    $0x4,%eax
  803578:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80357d:	8b 00                	mov    (%eax),%eax
  80357f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803585:	c1 e0 04             	shl    $0x4,%eax
  803588:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80358d:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  80358f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803592:	83 ec 0c             	sub    $0xc,%esp
  803595:	50                   	push   %eax
  803596:	e8 a8 f8 ff ff       	call   802e43 <to_page_info>
  80359b:	83 c4 10             	add    $0x10,%esp
  80359e:	89 c2                	mov    %eax,%edx
  8035a0:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8035a4:	48                   	dec    %eax
  8035a5:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  8035a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035ac:	eb 24                	jmp    8035d2 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8035ae:	ff 45 f0             	incl   -0x10(%ebp)
  8035b1:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8035b5:	0f 8e 09 ff ff ff    	jle    8034c4 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8035bb:	83 ec 04             	sub    $0x4,%esp
  8035be:	68 db 4a 80 00       	push   $0x804adb
  8035c3:	68 bf 00 00 00       	push   $0xbf
  8035c8:	68 ff 49 80 00       	push   $0x8049ff
  8035cd:	e8 71 d1 ff ff       	call   800743 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8035d2:	c9                   	leave  
  8035d3:	c3                   	ret    

008035d4 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  8035d4:	55                   	push   %ebp
  8035d5:	89 e5                	mov    %esp,%ebp
  8035d7:	83 ec 14             	sub    $0x14,%esp
  8035da:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  8035dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e1:	75 07                	jne    8035ea <log2_ceil.1520+0x16>
  8035e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e8:	eb 1b                	jmp    803605 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  8035ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  8035f1:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  8035f4:	eb 06                	jmp    8035fc <log2_ceil.1520+0x28>
            x >>= 1;
  8035f6:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  8035f9:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8035fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803600:	75 f4                	jne    8035f6 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  803602:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803605:	c9                   	leave  
  803606:	c3                   	ret    

00803607 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  803607:	55                   	push   %ebp
  803608:	89 e5                	mov    %esp,%ebp
  80360a:	83 ec 14             	sub    $0x14,%esp
  80360d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803610:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803614:	75 07                	jne    80361d <log2_ceil.1547+0x16>
  803616:	b8 00 00 00 00       	mov    $0x0,%eax
  80361b:	eb 1b                	jmp    803638 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  80361d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803624:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  803627:	eb 06                	jmp    80362f <log2_ceil.1547+0x28>
			x >>= 1;
  803629:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  80362c:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  80362f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803633:	75 f4                	jne    803629 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  803635:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803638:	c9                   	leave  
  803639:	c3                   	ret    

0080363a <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80363a:	55                   	push   %ebp
  80363b:	89 e5                	mov    %esp,%ebp
  80363d:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803640:	8b 55 08             	mov    0x8(%ebp),%edx
  803643:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803648:	39 c2                	cmp    %eax,%edx
  80364a:	72 0c                	jb     803658 <free_block+0x1e>
  80364c:	8b 55 08             	mov    0x8(%ebp),%edx
  80364f:	a1 40 50 80 00       	mov    0x805040,%eax
  803654:	39 c2                	cmp    %eax,%edx
  803656:	72 19                	jb     803671 <free_block+0x37>
  803658:	68 e0 4a 80 00       	push   $0x804ae0
  80365d:	68 62 4a 80 00       	push   $0x804a62
  803662:	68 d0 00 00 00       	push   $0xd0
  803667:	68 ff 49 80 00       	push   $0x8049ff
  80366c:	e8 d2 d0 ff ff       	call   800743 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803671:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803675:	0f 84 42 03 00 00    	je     8039bd <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  80367b:	8b 55 08             	mov    0x8(%ebp),%edx
  80367e:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803683:	39 c2                	cmp    %eax,%edx
  803685:	72 0c                	jb     803693 <free_block+0x59>
  803687:	8b 55 08             	mov    0x8(%ebp),%edx
  80368a:	a1 40 50 80 00       	mov    0x805040,%eax
  80368f:	39 c2                	cmp    %eax,%edx
  803691:	72 17                	jb     8036aa <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803693:	83 ec 04             	sub    $0x4,%esp
  803696:	68 18 4b 80 00       	push   $0x804b18
  80369b:	68 e6 00 00 00       	push   $0xe6
  8036a0:	68 ff 49 80 00       	push   $0x8049ff
  8036a5:	e8 99 d0 ff ff       	call   800743 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8036aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ad:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8036b2:	29 c2                	sub    %eax,%edx
  8036b4:	89 d0                	mov    %edx,%eax
  8036b6:	83 e0 07             	and    $0x7,%eax
  8036b9:	85 c0                	test   %eax,%eax
  8036bb:	74 17                	je     8036d4 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8036bd:	83 ec 04             	sub    $0x4,%esp
  8036c0:	68 4c 4b 80 00       	push   $0x804b4c
  8036c5:	68 ea 00 00 00       	push   $0xea
  8036ca:	68 ff 49 80 00       	push   $0x8049ff
  8036cf:	e8 6f d0 ff ff       	call   800743 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8036d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d7:	83 ec 0c             	sub    $0xc,%esp
  8036da:	50                   	push   %eax
  8036db:	e8 63 f7 ff ff       	call   802e43 <to_page_info>
  8036e0:	83 c4 10             	add    $0x10,%esp
  8036e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8036e6:	83 ec 0c             	sub    $0xc,%esp
  8036e9:	ff 75 08             	pushl  0x8(%ebp)
  8036ec:	e8 87 f9 ff ff       	call   803078 <get_block_size>
  8036f1:	83 c4 10             	add    $0x10,%esp
  8036f4:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8036f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036fb:	75 17                	jne    803714 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8036fd:	83 ec 04             	sub    $0x4,%esp
  803700:	68 78 4b 80 00       	push   $0x804b78
  803705:	68 f1 00 00 00       	push   $0xf1
  80370a:	68 ff 49 80 00       	push   $0x8049ff
  80370f:	e8 2f d0 ff ff       	call   800743 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  803714:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803717:	83 ec 0c             	sub    $0xc,%esp
  80371a:	8d 45 d0             	lea    -0x30(%ebp),%eax
  80371d:	52                   	push   %edx
  80371e:	89 c1                	mov    %eax,%ecx
  803720:	e8 e2 fe ff ff       	call   803607 <log2_ceil.1547>
  803725:	83 c4 10             	add    $0x10,%esp
  803728:	83 e8 03             	sub    $0x3,%eax
  80372b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  80372e:	8b 45 08             	mov    0x8(%ebp),%eax
  803731:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  803734:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803738:	75 17                	jne    803751 <free_block+0x117>
  80373a:	83 ec 04             	sub    $0x4,%esp
  80373d:	68 c4 4b 80 00       	push   $0x804bc4
  803742:	68 f6 00 00 00       	push   $0xf6
  803747:	68 ff 49 80 00       	push   $0x8049ff
  80374c:	e8 f2 cf ff ff       	call   800743 <_panic>
  803751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803754:	c1 e0 04             	shl    $0x4,%eax
  803757:	05 80 d0 81 00       	add    $0x81d080,%eax
  80375c:	8b 10                	mov    (%eax),%edx
  80375e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803761:	89 10                	mov    %edx,(%eax)
  803763:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803766:	8b 00                	mov    (%eax),%eax
  803768:	85 c0                	test   %eax,%eax
  80376a:	74 15                	je     803781 <free_block+0x147>
  80376c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80376f:	c1 e0 04             	shl    $0x4,%eax
  803772:	05 80 d0 81 00       	add    $0x81d080,%eax
  803777:	8b 00                	mov    (%eax),%eax
  803779:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80377c:	89 50 04             	mov    %edx,0x4(%eax)
  80377f:	eb 11                	jmp    803792 <free_block+0x158>
  803781:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803784:	c1 e0 04             	shl    $0x4,%eax
  803787:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  80378d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803790:	89 02                	mov    %eax,(%edx)
  803792:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803795:	c1 e0 04             	shl    $0x4,%eax
  803798:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  80379e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037a1:	89 02                	mov    %eax,(%edx)
  8037a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b0:	c1 e0 04             	shl    $0x4,%eax
  8037b3:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8037b8:	8b 00                	mov    (%eax),%eax
  8037ba:	8d 50 01             	lea    0x1(%eax),%edx
  8037bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c0:	c1 e0 04             	shl    $0x4,%eax
  8037c3:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8037c8:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8037ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037cd:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8037d1:	40                   	inc    %eax
  8037d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037d5:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8037d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8037dc:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8037e1:	29 c2                	sub    %eax,%edx
  8037e3:	89 d0                	mov    %edx,%eax
  8037e5:	c1 e8 0c             	shr    $0xc,%eax
  8037e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8037eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ee:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8037f2:	0f b7 c8             	movzwl %ax,%ecx
  8037f5:	b8 00 10 00 00       	mov    $0x1000,%eax
  8037fa:	99                   	cltd   
  8037fb:	f7 7d e8             	idivl  -0x18(%ebp)
  8037fe:	39 c1                	cmp    %eax,%ecx
  803800:	0f 85 b8 01 00 00    	jne    8039be <free_block+0x384>
    	uint32 blocks_removed = 0;
  803806:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  80380d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803810:	c1 e0 04             	shl    $0x4,%eax
  803813:	05 80 d0 81 00       	add    $0x81d080,%eax
  803818:	8b 00                	mov    (%eax),%eax
  80381a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80381d:	e9 d5 00 00 00       	jmp    8038f7 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803825:	8b 00                	mov    (%eax),%eax
  803827:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  80382a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80382d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803832:	29 c2                	sub    %eax,%edx
  803834:	89 d0                	mov    %edx,%eax
  803836:	c1 e8 0c             	shr    $0xc,%eax
  803839:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  80383c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803842:	0f 85 a9 00 00 00    	jne    8038f1 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  803848:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80384c:	75 17                	jne    803865 <free_block+0x22b>
  80384e:	83 ec 04             	sub    $0x4,%esp
  803851:	68 99 4a 80 00       	push   $0x804a99
  803856:	68 04 01 00 00       	push   $0x104
  80385b:	68 ff 49 80 00       	push   $0x8049ff
  803860:	e8 de ce ff ff       	call   800743 <_panic>
  803865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803868:	8b 00                	mov    (%eax),%eax
  80386a:	85 c0                	test   %eax,%eax
  80386c:	74 10                	je     80387e <free_block+0x244>
  80386e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803871:	8b 00                	mov    (%eax),%eax
  803873:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803876:	8b 52 04             	mov    0x4(%edx),%edx
  803879:	89 50 04             	mov    %edx,0x4(%eax)
  80387c:	eb 14                	jmp    803892 <free_block+0x258>
  80387e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803881:	8b 40 04             	mov    0x4(%eax),%eax
  803884:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803887:	c1 e2 04             	shl    $0x4,%edx
  80388a:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803890:	89 02                	mov    %eax,(%edx)
  803892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803895:	8b 40 04             	mov    0x4(%eax),%eax
  803898:	85 c0                	test   %eax,%eax
  80389a:	74 0f                	je     8038ab <free_block+0x271>
  80389c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80389f:	8b 40 04             	mov    0x4(%eax),%eax
  8038a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038a5:	8b 12                	mov    (%edx),%edx
  8038a7:	89 10                	mov    %edx,(%eax)
  8038a9:	eb 13                	jmp    8038be <free_block+0x284>
  8038ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ae:	8b 00                	mov    (%eax),%eax
  8038b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038b3:	c1 e2 04             	shl    $0x4,%edx
  8038b6:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8038bc:	89 02                	mov    %eax,(%edx)
  8038be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d4:	c1 e0 04             	shl    $0x4,%eax
  8038d7:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8038dc:	8b 00                	mov    (%eax),%eax
  8038de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e4:	c1 e0 04             	shl    $0x4,%eax
  8038e7:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8038ec:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8038ee:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8038f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8038f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038fb:	0f 85 21 ff ff ff    	jne    803822 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803901:	b8 00 10 00 00       	mov    $0x1000,%eax
  803906:	99                   	cltd   
  803907:	f7 7d e8             	idivl  -0x18(%ebp)
  80390a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80390d:	74 17                	je     803926 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  80390f:	83 ec 04             	sub    $0x4,%esp
  803912:	68 e8 4b 80 00       	push   $0x804be8
  803917:	68 0c 01 00 00       	push   $0x10c
  80391c:	68 ff 49 80 00       	push   $0x8049ff
  803921:	e8 1d ce ff ff       	call   800743 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803926:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803929:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  80392f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803932:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803938:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80393c:	75 17                	jne    803955 <free_block+0x31b>
  80393e:	83 ec 04             	sub    $0x4,%esp
  803941:	68 b8 4a 80 00       	push   $0x804ab8
  803946:	68 11 01 00 00       	push   $0x111
  80394b:	68 ff 49 80 00       	push   $0x8049ff
  803950:	e8 ee cd ff ff       	call   800743 <_panic>
  803955:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80395b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80395e:	89 50 04             	mov    %edx,0x4(%eax)
  803961:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803964:	8b 40 04             	mov    0x4(%eax),%eax
  803967:	85 c0                	test   %eax,%eax
  803969:	74 0c                	je     803977 <free_block+0x33d>
  80396b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803970:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803973:	89 10                	mov    %edx,(%eax)
  803975:	eb 08                	jmp    80397f <free_block+0x345>
  803977:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80397a:	a3 48 50 80 00       	mov    %eax,0x805048
  80397f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803982:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80398a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803990:	a1 54 50 80 00       	mov    0x805054,%eax
  803995:	40                   	inc    %eax
  803996:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  80399b:	83 ec 0c             	sub    $0xc,%esp
  80399e:	ff 75 ec             	pushl  -0x14(%ebp)
  8039a1:	e8 2b f4 ff ff       	call   802dd1 <to_page_va>
  8039a6:	83 c4 10             	add    $0x10,%esp
  8039a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8039ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039af:	83 ec 0c             	sub    $0xc,%esp
  8039b2:	50                   	push   %eax
  8039b3:	e8 69 e8 ff ff       	call   802221 <return_page>
  8039b8:	83 c4 10             	add    $0x10,%esp
  8039bb:	eb 01                	jmp    8039be <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8039bd:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8039be:	c9                   	leave  
  8039bf:	c3                   	ret    

008039c0 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8039c0:	55                   	push   %ebp
  8039c1:	89 e5                	mov    %esp,%ebp
  8039c3:	83 ec 14             	sub    $0x14,%esp
  8039c6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8039c9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8039cd:	77 07                	ja     8039d6 <nearest_pow2_ceil.1572+0x16>
      return 1;
  8039cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8039d4:	eb 20                	jmp    8039f6 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8039d6:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8039dd:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8039e0:	eb 08                	jmp    8039ea <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8039e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8039e5:	01 c0                	add    %eax,%eax
  8039e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8039ea:	d1 6d 08             	shrl   0x8(%ebp)
  8039ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039f1:	75 ef                	jne    8039e2 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8039f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8039f6:	c9                   	leave  
  8039f7:	c3                   	ret    

008039f8 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8039f8:	55                   	push   %ebp
  8039f9:	89 e5                	mov    %esp,%ebp
  8039fb:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8039fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a02:	75 13                	jne    803a17 <realloc_block+0x1f>
    return alloc_block(new_size);
  803a04:	83 ec 0c             	sub    $0xc,%esp
  803a07:	ff 75 0c             	pushl  0xc(%ebp)
  803a0a:	e8 d1 f6 ff ff       	call   8030e0 <alloc_block>
  803a0f:	83 c4 10             	add    $0x10,%esp
  803a12:	e9 d9 00 00 00       	jmp    803af0 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803a17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a1b:	75 18                	jne    803a35 <realloc_block+0x3d>
    free_block(va);
  803a1d:	83 ec 0c             	sub    $0xc,%esp
  803a20:	ff 75 08             	pushl  0x8(%ebp)
  803a23:	e8 12 fc ff ff       	call   80363a <free_block>
  803a28:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803a2b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a30:	e9 bb 00 00 00       	jmp    803af0 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803a35:	83 ec 0c             	sub    $0xc,%esp
  803a38:	ff 75 08             	pushl  0x8(%ebp)
  803a3b:	e8 38 f6 ff ff       	call   803078 <get_block_size>
  803a40:	83 c4 10             	add    $0x10,%esp
  803a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803a46:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a50:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803a53:	73 06                	jae    803a5b <realloc_block+0x63>
    new_size = min_block_size;
  803a55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a58:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803a5b:	83 ec 0c             	sub    $0xc,%esp
  803a5e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803a61:	ff 75 0c             	pushl  0xc(%ebp)
  803a64:	89 c1                	mov    %eax,%ecx
  803a66:	e8 55 ff ff ff       	call   8039c0 <nearest_pow2_ceil.1572>
  803a6b:	83 c4 10             	add    $0x10,%esp
  803a6e:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803a71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a74:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803a77:	75 05                	jne    803a7e <realloc_block+0x86>
    return va;
  803a79:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7c:	eb 72                	jmp    803af0 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803a7e:	83 ec 0c             	sub    $0xc,%esp
  803a81:	ff 75 0c             	pushl  0xc(%ebp)
  803a84:	e8 57 f6 ff ff       	call   8030e0 <alloc_block>
  803a89:	83 c4 10             	add    $0x10,%esp
  803a8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803a8f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a93:	75 07                	jne    803a9c <realloc_block+0xa4>
    return NULL;
  803a95:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9a:	eb 54                	jmp    803af0 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803a9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aa2:	39 d0                	cmp    %edx,%eax
  803aa4:	76 02                	jbe    803aa8 <realloc_block+0xb0>
  803aa6:	89 d0                	mov    %edx,%eax
  803aa8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803aab:	8b 45 08             	mov    0x8(%ebp),%eax
  803aae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803ab1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803ab7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803abe:	eb 17                	jmp    803ad7 <realloc_block+0xdf>
    dst[i] = src[i];
  803ac0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac6:	01 c2                	add    %eax,%edx
  803ac8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ace:	01 c8                	add    %ecx,%eax
  803ad0:	8a 00                	mov    (%eax),%al
  803ad2:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803ad4:	ff 45 f4             	incl   -0xc(%ebp)
  803ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ada:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803add:	72 e1                	jb     803ac0 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803adf:	83 ec 0c             	sub    $0xc,%esp
  803ae2:	ff 75 08             	pushl  0x8(%ebp)
  803ae5:	e8 50 fb ff ff       	call   80363a <free_block>
  803aea:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803aed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803af0:	c9                   	leave  
  803af1:	c3                   	ret    
  803af2:	66 90                	xchg   %ax,%ax

00803af4 <__udivdi3>:
  803af4:	55                   	push   %ebp
  803af5:	57                   	push   %edi
  803af6:	56                   	push   %esi
  803af7:	53                   	push   %ebx
  803af8:	83 ec 1c             	sub    $0x1c,%esp
  803afb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803aff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b07:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b0b:	89 ca                	mov    %ecx,%edx
  803b0d:	89 f8                	mov    %edi,%eax
  803b0f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b13:	85 f6                	test   %esi,%esi
  803b15:	75 2d                	jne    803b44 <__udivdi3+0x50>
  803b17:	39 cf                	cmp    %ecx,%edi
  803b19:	77 65                	ja     803b80 <__udivdi3+0x8c>
  803b1b:	89 fd                	mov    %edi,%ebp
  803b1d:	85 ff                	test   %edi,%edi
  803b1f:	75 0b                	jne    803b2c <__udivdi3+0x38>
  803b21:	b8 01 00 00 00       	mov    $0x1,%eax
  803b26:	31 d2                	xor    %edx,%edx
  803b28:	f7 f7                	div    %edi
  803b2a:	89 c5                	mov    %eax,%ebp
  803b2c:	31 d2                	xor    %edx,%edx
  803b2e:	89 c8                	mov    %ecx,%eax
  803b30:	f7 f5                	div    %ebp
  803b32:	89 c1                	mov    %eax,%ecx
  803b34:	89 d8                	mov    %ebx,%eax
  803b36:	f7 f5                	div    %ebp
  803b38:	89 cf                	mov    %ecx,%edi
  803b3a:	89 fa                	mov    %edi,%edx
  803b3c:	83 c4 1c             	add    $0x1c,%esp
  803b3f:	5b                   	pop    %ebx
  803b40:	5e                   	pop    %esi
  803b41:	5f                   	pop    %edi
  803b42:	5d                   	pop    %ebp
  803b43:	c3                   	ret    
  803b44:	39 ce                	cmp    %ecx,%esi
  803b46:	77 28                	ja     803b70 <__udivdi3+0x7c>
  803b48:	0f bd fe             	bsr    %esi,%edi
  803b4b:	83 f7 1f             	xor    $0x1f,%edi
  803b4e:	75 40                	jne    803b90 <__udivdi3+0x9c>
  803b50:	39 ce                	cmp    %ecx,%esi
  803b52:	72 0a                	jb     803b5e <__udivdi3+0x6a>
  803b54:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b58:	0f 87 9e 00 00 00    	ja     803bfc <__udivdi3+0x108>
  803b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b63:	89 fa                	mov    %edi,%edx
  803b65:	83 c4 1c             	add    $0x1c,%esp
  803b68:	5b                   	pop    %ebx
  803b69:	5e                   	pop    %esi
  803b6a:	5f                   	pop    %edi
  803b6b:	5d                   	pop    %ebp
  803b6c:	c3                   	ret    
  803b6d:	8d 76 00             	lea    0x0(%esi),%esi
  803b70:	31 ff                	xor    %edi,%edi
  803b72:	31 c0                	xor    %eax,%eax
  803b74:	89 fa                	mov    %edi,%edx
  803b76:	83 c4 1c             	add    $0x1c,%esp
  803b79:	5b                   	pop    %ebx
  803b7a:	5e                   	pop    %esi
  803b7b:	5f                   	pop    %edi
  803b7c:	5d                   	pop    %ebp
  803b7d:	c3                   	ret    
  803b7e:	66 90                	xchg   %ax,%ax
  803b80:	89 d8                	mov    %ebx,%eax
  803b82:	f7 f7                	div    %edi
  803b84:	31 ff                	xor    %edi,%edi
  803b86:	89 fa                	mov    %edi,%edx
  803b88:	83 c4 1c             	add    $0x1c,%esp
  803b8b:	5b                   	pop    %ebx
  803b8c:	5e                   	pop    %esi
  803b8d:	5f                   	pop    %edi
  803b8e:	5d                   	pop    %ebp
  803b8f:	c3                   	ret    
  803b90:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b95:	89 eb                	mov    %ebp,%ebx
  803b97:	29 fb                	sub    %edi,%ebx
  803b99:	89 f9                	mov    %edi,%ecx
  803b9b:	d3 e6                	shl    %cl,%esi
  803b9d:	89 c5                	mov    %eax,%ebp
  803b9f:	88 d9                	mov    %bl,%cl
  803ba1:	d3 ed                	shr    %cl,%ebp
  803ba3:	89 e9                	mov    %ebp,%ecx
  803ba5:	09 f1                	or     %esi,%ecx
  803ba7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bab:	89 f9                	mov    %edi,%ecx
  803bad:	d3 e0                	shl    %cl,%eax
  803baf:	89 c5                	mov    %eax,%ebp
  803bb1:	89 d6                	mov    %edx,%esi
  803bb3:	88 d9                	mov    %bl,%cl
  803bb5:	d3 ee                	shr    %cl,%esi
  803bb7:	89 f9                	mov    %edi,%ecx
  803bb9:	d3 e2                	shl    %cl,%edx
  803bbb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bbf:	88 d9                	mov    %bl,%cl
  803bc1:	d3 e8                	shr    %cl,%eax
  803bc3:	09 c2                	or     %eax,%edx
  803bc5:	89 d0                	mov    %edx,%eax
  803bc7:	89 f2                	mov    %esi,%edx
  803bc9:	f7 74 24 0c          	divl   0xc(%esp)
  803bcd:	89 d6                	mov    %edx,%esi
  803bcf:	89 c3                	mov    %eax,%ebx
  803bd1:	f7 e5                	mul    %ebp
  803bd3:	39 d6                	cmp    %edx,%esi
  803bd5:	72 19                	jb     803bf0 <__udivdi3+0xfc>
  803bd7:	74 0b                	je     803be4 <__udivdi3+0xf0>
  803bd9:	89 d8                	mov    %ebx,%eax
  803bdb:	31 ff                	xor    %edi,%edi
  803bdd:	e9 58 ff ff ff       	jmp    803b3a <__udivdi3+0x46>
  803be2:	66 90                	xchg   %ax,%ax
  803be4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803be8:	89 f9                	mov    %edi,%ecx
  803bea:	d3 e2                	shl    %cl,%edx
  803bec:	39 c2                	cmp    %eax,%edx
  803bee:	73 e9                	jae    803bd9 <__udivdi3+0xe5>
  803bf0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bf3:	31 ff                	xor    %edi,%edi
  803bf5:	e9 40 ff ff ff       	jmp    803b3a <__udivdi3+0x46>
  803bfa:	66 90                	xchg   %ax,%ax
  803bfc:	31 c0                	xor    %eax,%eax
  803bfe:	e9 37 ff ff ff       	jmp    803b3a <__udivdi3+0x46>
  803c03:	90                   	nop

00803c04 <__umoddi3>:
  803c04:	55                   	push   %ebp
  803c05:	57                   	push   %edi
  803c06:	56                   	push   %esi
  803c07:	53                   	push   %ebx
  803c08:	83 ec 1c             	sub    $0x1c,%esp
  803c0b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c17:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c1f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c23:	89 f3                	mov    %esi,%ebx
  803c25:	89 fa                	mov    %edi,%edx
  803c27:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c2b:	89 34 24             	mov    %esi,(%esp)
  803c2e:	85 c0                	test   %eax,%eax
  803c30:	75 1a                	jne    803c4c <__umoddi3+0x48>
  803c32:	39 f7                	cmp    %esi,%edi
  803c34:	0f 86 a2 00 00 00    	jbe    803cdc <__umoddi3+0xd8>
  803c3a:	89 c8                	mov    %ecx,%eax
  803c3c:	89 f2                	mov    %esi,%edx
  803c3e:	f7 f7                	div    %edi
  803c40:	89 d0                	mov    %edx,%eax
  803c42:	31 d2                	xor    %edx,%edx
  803c44:	83 c4 1c             	add    $0x1c,%esp
  803c47:	5b                   	pop    %ebx
  803c48:	5e                   	pop    %esi
  803c49:	5f                   	pop    %edi
  803c4a:	5d                   	pop    %ebp
  803c4b:	c3                   	ret    
  803c4c:	39 f0                	cmp    %esi,%eax
  803c4e:	0f 87 ac 00 00 00    	ja     803d00 <__umoddi3+0xfc>
  803c54:	0f bd e8             	bsr    %eax,%ebp
  803c57:	83 f5 1f             	xor    $0x1f,%ebp
  803c5a:	0f 84 ac 00 00 00    	je     803d0c <__umoddi3+0x108>
  803c60:	bf 20 00 00 00       	mov    $0x20,%edi
  803c65:	29 ef                	sub    %ebp,%edi
  803c67:	89 fe                	mov    %edi,%esi
  803c69:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c6d:	89 e9                	mov    %ebp,%ecx
  803c6f:	d3 e0                	shl    %cl,%eax
  803c71:	89 d7                	mov    %edx,%edi
  803c73:	89 f1                	mov    %esi,%ecx
  803c75:	d3 ef                	shr    %cl,%edi
  803c77:	09 c7                	or     %eax,%edi
  803c79:	89 e9                	mov    %ebp,%ecx
  803c7b:	d3 e2                	shl    %cl,%edx
  803c7d:	89 14 24             	mov    %edx,(%esp)
  803c80:	89 d8                	mov    %ebx,%eax
  803c82:	d3 e0                	shl    %cl,%eax
  803c84:	89 c2                	mov    %eax,%edx
  803c86:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c8a:	d3 e0                	shl    %cl,%eax
  803c8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c90:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c94:	89 f1                	mov    %esi,%ecx
  803c96:	d3 e8                	shr    %cl,%eax
  803c98:	09 d0                	or     %edx,%eax
  803c9a:	d3 eb                	shr    %cl,%ebx
  803c9c:	89 da                	mov    %ebx,%edx
  803c9e:	f7 f7                	div    %edi
  803ca0:	89 d3                	mov    %edx,%ebx
  803ca2:	f7 24 24             	mull   (%esp)
  803ca5:	89 c6                	mov    %eax,%esi
  803ca7:	89 d1                	mov    %edx,%ecx
  803ca9:	39 d3                	cmp    %edx,%ebx
  803cab:	0f 82 87 00 00 00    	jb     803d38 <__umoddi3+0x134>
  803cb1:	0f 84 91 00 00 00    	je     803d48 <__umoddi3+0x144>
  803cb7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cbb:	29 f2                	sub    %esi,%edx
  803cbd:	19 cb                	sbb    %ecx,%ebx
  803cbf:	89 d8                	mov    %ebx,%eax
  803cc1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cc5:	d3 e0                	shl    %cl,%eax
  803cc7:	89 e9                	mov    %ebp,%ecx
  803cc9:	d3 ea                	shr    %cl,%edx
  803ccb:	09 d0                	or     %edx,%eax
  803ccd:	89 e9                	mov    %ebp,%ecx
  803ccf:	d3 eb                	shr    %cl,%ebx
  803cd1:	89 da                	mov    %ebx,%edx
  803cd3:	83 c4 1c             	add    $0x1c,%esp
  803cd6:	5b                   	pop    %ebx
  803cd7:	5e                   	pop    %esi
  803cd8:	5f                   	pop    %edi
  803cd9:	5d                   	pop    %ebp
  803cda:	c3                   	ret    
  803cdb:	90                   	nop
  803cdc:	89 fd                	mov    %edi,%ebp
  803cde:	85 ff                	test   %edi,%edi
  803ce0:	75 0b                	jne    803ced <__umoddi3+0xe9>
  803ce2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ce7:	31 d2                	xor    %edx,%edx
  803ce9:	f7 f7                	div    %edi
  803ceb:	89 c5                	mov    %eax,%ebp
  803ced:	89 f0                	mov    %esi,%eax
  803cef:	31 d2                	xor    %edx,%edx
  803cf1:	f7 f5                	div    %ebp
  803cf3:	89 c8                	mov    %ecx,%eax
  803cf5:	f7 f5                	div    %ebp
  803cf7:	89 d0                	mov    %edx,%eax
  803cf9:	e9 44 ff ff ff       	jmp    803c42 <__umoddi3+0x3e>
  803cfe:	66 90                	xchg   %ax,%ax
  803d00:	89 c8                	mov    %ecx,%eax
  803d02:	89 f2                	mov    %esi,%edx
  803d04:	83 c4 1c             	add    $0x1c,%esp
  803d07:	5b                   	pop    %ebx
  803d08:	5e                   	pop    %esi
  803d09:	5f                   	pop    %edi
  803d0a:	5d                   	pop    %ebp
  803d0b:	c3                   	ret    
  803d0c:	3b 04 24             	cmp    (%esp),%eax
  803d0f:	72 06                	jb     803d17 <__umoddi3+0x113>
  803d11:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d15:	77 0f                	ja     803d26 <__umoddi3+0x122>
  803d17:	89 f2                	mov    %esi,%edx
  803d19:	29 f9                	sub    %edi,%ecx
  803d1b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d1f:	89 14 24             	mov    %edx,(%esp)
  803d22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d26:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d2a:	8b 14 24             	mov    (%esp),%edx
  803d2d:	83 c4 1c             	add    $0x1c,%esp
  803d30:	5b                   	pop    %ebx
  803d31:	5e                   	pop    %esi
  803d32:	5f                   	pop    %edi
  803d33:	5d                   	pop    %ebp
  803d34:	c3                   	ret    
  803d35:	8d 76 00             	lea    0x0(%esi),%esi
  803d38:	2b 04 24             	sub    (%esp),%eax
  803d3b:	19 fa                	sbb    %edi,%edx
  803d3d:	89 d1                	mov    %edx,%ecx
  803d3f:	89 c6                	mov    %eax,%esi
  803d41:	e9 71 ff ff ff       	jmp    803cb7 <__umoddi3+0xb3>
  803d46:	66 90                	xchg   %ax,%ax
  803d48:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d4c:	72 ea                	jb     803d38 <__umoddi3+0x134>
  803d4e:	89 d9                	mov    %ebx,%ecx
  803d50:	e9 62 ff ff ff       	jmp    803cb7 <__umoddi3+0xb3>
