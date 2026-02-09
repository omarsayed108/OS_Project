
obj/user/quicksort_interrupt:     file format elf32-i386


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
  800031:	e8 8f 05 00 00       	call   8005c5 <libmain>
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
  800049:	e8 29 29 00 00       	call   802977 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 3b 29 00 00       	call   802990 <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_lock_cons();

		sys_lock_cons();
  80005d:	e8 65 28 00 00       	call   8028c7 <sys_lock_cons>
			readline("Enter the number of elements: ", Line);
  800062:	83 ec 08             	sub    $0x8,%esp
  800065:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  80006b:	50                   	push   %eax
  80006c:	68 a0 3d 80 00       	push   $0x803da0
  800071:	e8 c6 10 00 00       	call   80113c <readline>
  800076:	83 c4 10             	add    $0x10,%esp
			int NumOfElements = strtol(Line, NULL, 10) ;
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	6a 0a                	push   $0xa
  80007e:	6a 00                	push   $0x0
  800080:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800086:	50                   	push   %eax
  800087:	e8 c7 16 00 00       	call   801753 <strtol>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800095:	c1 e0 02             	shl    $0x2,%eax
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	50                   	push   %eax
  80009c:	e8 f5 21 00 00       	call   802296 <malloc>
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000a7:	83 ec 0c             	sub    $0xc,%esp
  8000aa:	68 c0 3d 80 00       	push   $0x803dc0
  8000af:	e8 af 09 00 00       	call   800a63 <cprintf>
  8000b4:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	68 e3 3d 80 00       	push   $0x803de3
  8000bf:	e8 9f 09 00 00       	call   800a63 <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	68 f1 3d 80 00       	push   $0x803df1
  8000cf:	e8 8f 09 00 00       	call   800a63 <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	68 00 3e 80 00       	push   $0x803e00
  8000df:	e8 7f 09 00 00       	call   800a63 <cprintf>
  8000e4:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  8000e7:	83 ec 0c             	sub    $0xc,%esp
  8000ea:	68 10 3e 80 00       	push   $0x803e10
  8000ef:	e8 6f 09 00 00       	call   800a63 <cprintf>
  8000f4:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  8000f7:	e8 ac 04 00 00       	call   8005a8 <getchar>
  8000fc:	88 45 e7             	mov    %al,-0x19(%ebp)
				cputchar(Chose);
  8000ff:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	50                   	push   %eax
  800107:	e8 7d 04 00 00       	call   800589 <cputchar>
  80010c:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	6a 0a                	push   $0xa
  800114:	e8 70 04 00 00       	call   800589 <cputchar>
  800119:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80011c:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  800120:	74 0c                	je     80012e <_main+0xf6>
  800122:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800126:	74 06                	je     80012e <_main+0xf6>
  800128:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  80012c:	75 b9                	jne    8000e7 <_main+0xaf>
		sys_unlock_cons();
  80012e:	e8 ae 27 00 00       	call   8028e1 <sys_unlock_cons>
			//sys_unlock_cons();
			int  i ;
		switch (Chose)
  800133:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800137:	83 f8 62             	cmp    $0x62,%eax
  80013a:	74 1d                	je     800159 <_main+0x121>
  80013c:	83 f8 63             	cmp    $0x63,%eax
  80013f:	74 2b                	je     80016c <_main+0x134>
  800141:	83 f8 61             	cmp    $0x61,%eax
  800144:	75 39                	jne    80017f <_main+0x147>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800146:	83 ec 08             	sub    $0x8,%esp
  800149:	ff 75 ec             	pushl  -0x14(%ebp)
  80014c:	ff 75 e8             	pushl  -0x18(%ebp)
  80014f:	e8 e6 02 00 00       	call   80043a <InitializeAscending>
  800154:	83 c4 10             	add    $0x10,%esp
			break ;
  800157:	eb 37                	jmp    800190 <_main+0x158>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  800159:	83 ec 08             	sub    $0x8,%esp
  80015c:	ff 75 ec             	pushl  -0x14(%ebp)
  80015f:	ff 75 e8             	pushl  -0x18(%ebp)
  800162:	e8 04 03 00 00       	call   80046b <InitializeIdentical>
  800167:	83 c4 10             	add    $0x10,%esp
			break ;
  80016a:	eb 24                	jmp    800190 <_main+0x158>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 ec             	pushl  -0x14(%ebp)
  800172:	ff 75 e8             	pushl  -0x18(%ebp)
  800175:	e8 26 03 00 00       	call   8004a0 <InitializeSemiRandom>
  80017a:	83 c4 10             	add    $0x10,%esp
			break ;
  80017d:	eb 11                	jmp    800190 <_main+0x158>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	ff 75 ec             	pushl  -0x14(%ebp)
  800185:	ff 75 e8             	pushl  -0x18(%ebp)
  800188:	e8 13 03 00 00       	call   8004a0 <InitializeSemiRandom>
  80018d:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	ff 75 e8             	pushl  -0x18(%ebp)
  800199:	e8 e1 00 00 00       	call   80027f <QuickSort>
  80019e:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 e1 01 00 00       	call   800390 <CheckSorted>
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001b9:	75 14                	jne    8001cf <_main+0x197>
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	68 1c 3e 80 00       	push   $0x803e1c
  8001c3:	6a 46                	push   $0x46
  8001c5:	68 3e 3e 80 00       	push   $0x803e3e
  8001ca:	e8 a6 05 00 00       	call   800775 <_panic>
		else
		{
			sys_lock_cons();
  8001cf:	e8 f3 26 00 00       	call   8028c7 <sys_lock_cons>
				cprintf("\n===============================================\n") ;
  8001d4:	83 ec 0c             	sub    $0xc,%esp
  8001d7:	68 5c 3e 80 00       	push   $0x803e5c
  8001dc:	e8 82 08 00 00       	call   800a63 <cprintf>
  8001e1:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	68 90 3e 80 00       	push   $0x803e90
  8001ec:	e8 72 08 00 00       	call   800a63 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 c4 3e 80 00       	push   $0x803ec4
  8001fc:	e8 62 08 00 00       	call   800a63 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  800204:	e8 d8 26 00 00       	call   8028e1 <sys_unlock_cons>
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		sys_lock_cons();
  800209:	e8 b9 26 00 00       	call   8028c7 <sys_lock_cons>
			cprintf("Freeing the Heap...\n\n") ;
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	68 f6 3e 80 00       	push   $0x803ef6
  800216:	e8 48 08 00 00       	call   800a63 <cprintf>
  80021b:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  80021e:	e8 be 26 00 00       	call   8028e1 <sys_unlock_cons>

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		sys_lock_cons();
  800223:	e8 9f 26 00 00       	call   8028c7 <sys_lock_cons>
			cprintf("Do you want to repeat (y/n): ") ;
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	68 0c 3f 80 00       	push   $0x803f0c
  800230:	e8 2e 08 00 00       	call   800a63 <cprintf>
  800235:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800238:	e8 6b 03 00 00       	call   8005a8 <getchar>
  80023d:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  800240:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	50                   	push   %eax
  800248:	e8 3c 03 00 00       	call   800589 <cputchar>
  80024d:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	6a 0a                	push   $0xa
  800255:	e8 2f 03 00 00       	call   800589 <cputchar>
  80025a:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80025d:	83 ec 0c             	sub    $0xc,%esp
  800260:	6a 0a                	push   $0xa
  800262:	e8 22 03 00 00       	call   800589 <cputchar>
  800267:	83 c4 10             	add    $0x10,%esp
	//sys_unlock_cons();
		sys_unlock_cons();
  80026a:	e8 72 26 00 00       	call   8028e1 <sys_unlock_cons>

	} while (Chose == 'y');
  80026f:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  800273:	0f 84 d0 fd ff ff    	je     800049 <_main+0x11>

}
  800279:	90                   	nop
  80027a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800285:	8b 45 0c             	mov    0xc(%ebp),%eax
  800288:	48                   	dec    %eax
  800289:	50                   	push   %eax
  80028a:	6a 00                	push   $0x0
  80028c:	ff 75 0c             	pushl  0xc(%ebp)
  80028f:	ff 75 08             	pushl  0x8(%ebp)
  800292:	e8 06 00 00 00       	call   80029d <QSort>
  800297:	83 c4 10             	add    $0x10,%esp
}
  80029a:	90                   	nop
  80029b:	c9                   	leave  
  80029c:	c3                   	ret    

0080029d <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a6:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a9:	0f 8d de 00 00 00    	jge    80038d <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002af:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b2:	40                   	inc    %eax
  8002b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8002b9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002bc:	e9 80 00 00 00       	jmp    800341 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002c1:	ff 45 f4             	incl   -0xc(%ebp)
  8002c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c7:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ca:	7f 2b                	jg     8002f7 <QSort+0x5a>
  8002cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	8b 10                	mov    (%eax),%edx
  8002dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ea:	01 c8                	add    %ecx,%eax
  8002ec:	8b 00                	mov    (%eax),%eax
  8002ee:	39 c2                	cmp    %eax,%edx
  8002f0:	7d cf                	jge    8002c1 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002f2:	eb 03                	jmp    8002f7 <QSort+0x5a>
  8002f4:	ff 4d f0             	decl   -0x10(%ebp)
  8002f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002fa:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002fd:	7e 26                	jle    800325 <QSort+0x88>
  8002ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800302:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800309:	8b 45 08             	mov    0x8(%ebp),%eax
  80030c:	01 d0                	add    %edx,%eax
  80030e:	8b 10                	mov    (%eax),%edx
  800310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800313:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031a:	8b 45 08             	mov    0x8(%ebp),%eax
  80031d:	01 c8                	add    %ecx,%eax
  80031f:	8b 00                	mov    (%eax),%eax
  800321:	39 c2                	cmp    %eax,%edx
  800323:	7e cf                	jle    8002f4 <QSort+0x57>

		if (i <= j)
  800325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800328:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80032b:	7f 14                	jg     800341 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80032d:	83 ec 04             	sub    $0x4,%esp
  800330:	ff 75 f0             	pushl  -0x10(%ebp)
  800333:	ff 75 f4             	pushl  -0xc(%ebp)
  800336:	ff 75 08             	pushl  0x8(%ebp)
  800339:	e8 a9 00 00 00       	call   8003e7 <Swap>
  80033e:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800344:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800347:	0f 8e 77 ff ff ff    	jle    8002c4 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	ff 75 f0             	pushl  -0x10(%ebp)
  800353:	ff 75 10             	pushl  0x10(%ebp)
  800356:	ff 75 08             	pushl  0x8(%ebp)
  800359:	e8 89 00 00 00       	call   8003e7 <Swap>
  80035e:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800364:	48                   	dec    %eax
  800365:	50                   	push   %eax
  800366:	ff 75 10             	pushl  0x10(%ebp)
  800369:	ff 75 0c             	pushl  0xc(%ebp)
  80036c:	ff 75 08             	pushl  0x8(%ebp)
  80036f:	e8 29 ff ff ff       	call   80029d <QSort>
  800374:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800377:	ff 75 14             	pushl  0x14(%ebp)
  80037a:	ff 75 f4             	pushl  -0xc(%ebp)
  80037d:	ff 75 0c             	pushl  0xc(%ebp)
  800380:	ff 75 08             	pushl  0x8(%ebp)
  800383:	e8 15 ff ff ff       	call   80029d <QSort>
  800388:	83 c4 10             	add    $0x10,%esp
  80038b:	eb 01                	jmp    80038e <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80038d:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800396:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80039d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003a4:	eb 33                	jmp    8003d9 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	01 d0                	add    %edx,%eax
  8003b5:	8b 10                	mov    (%eax),%edx
  8003b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ba:	40                   	inc    %eax
  8003bb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	01 c8                	add    %ecx,%eax
  8003c7:	8b 00                	mov    (%eax),%eax
  8003c9:	39 c2                	cmp    %eax,%edx
  8003cb:	7e 09                	jle    8003d6 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003d4:	eb 0c                	jmp    8003e2 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003d6:	ff 45 f8             	incl   -0x8(%ebp)
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	48                   	dec    %eax
  8003dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003e0:	7f c4                	jg     8003a6 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fa:	01 d0                	add    %edx,%eax
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800401:	8b 45 0c             	mov    0xc(%ebp),%eax
  800404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	01 c2                	add    %eax,%edx
  800410:	8b 45 10             	mov    0x10(%ebp),%eax
  800413:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	01 c8                	add    %ecx,%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800423:	8b 45 10             	mov    0x10(%ebp),%eax
  800426:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	01 c2                	add    %eax,%edx
  800432:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800435:	89 02                	mov    %eax,(%edx)
}
  800437:	90                   	nop
  800438:	c9                   	leave  
  800439:	c3                   	ret    

0080043a <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
  80043d:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800447:	eb 17                	jmp    800460 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800449:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80044c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	01 c2                	add    %eax,%edx
  800458:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80045b:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80045d:	ff 45 fc             	incl   -0x4(%ebp)
  800460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800463:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800466:	7c e1                	jl     800449 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800468:	90                   	nop
  800469:	c9                   	leave  
  80046a:	c3                   	ret    

0080046b <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  80046b:	55                   	push   %ebp
  80046c:	89 e5                	mov    %esp,%ebp
  80046e:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800471:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800478:	eb 1b                	jmp    800495 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  80047a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	01 c2                	add    %eax,%edx
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80048f:	48                   	dec    %eax
  800490:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800492:	ff 45 fc             	incl   -0x4(%ebp)
  800495:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800498:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049b:	7c dd                	jl     80047a <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80049d:	90                   	nop
  80049e:	c9                   	leave  
  80049f:	c3                   	ret    

008004a0 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004a9:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004ae:	f7 e9                	imul   %ecx
  8004b0:	c1 f9 1f             	sar    $0x1f,%ecx
  8004b3:	89 d0                	mov    %edx,%eax
  8004b5:	29 c8                	sub    %ecx,%eax
  8004b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8004ba:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8004be:	75 07                	jne    8004c7 <InitializeSemiRandom+0x27>
			Repetition = 3;
  8004c0:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004ce:	eb 1e                	jmp    8004ee <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  8004d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004da:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e3:	99                   	cltd   
  8004e4:	f7 7d f8             	idivl  -0x8(%ebp)
  8004e7:	89 d0                	mov    %edx,%eax
  8004e9:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  8004eb:	ff 45 fc             	incl   -0x4(%ebp)
  8004ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f4:	7c da                	jl     8004d0 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004f6:	90                   	nop
  8004f7:	c9                   	leave  
  8004f8:	c3                   	ret    

008004f9 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8004ff:	e8 c3 23 00 00       	call   8028c7 <sys_lock_cons>
		int i ;
		int NumsPerLine = 20 ;
  800504:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
		for (i = 0 ; i < NumOfElements-1 ; i++)
  80050b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800512:	eb 42                	jmp    800556 <PrintElements+0x5d>
		{
			if (i%NumsPerLine == 0)
  800514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800517:	99                   	cltd   
  800518:	f7 7d f0             	idivl  -0x10(%ebp)
  80051b:	89 d0                	mov    %edx,%eax
  80051d:	85 c0                	test   %eax,%eax
  80051f:	75 10                	jne    800531 <PrintElements+0x38>
				cprintf("\n");
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	68 2a 3f 80 00       	push   $0x803f2a
  800529:	e8 35 05 00 00       	call   800a63 <cprintf>
  80052e:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  800531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800534:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	01 d0                	add    %edx,%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	50                   	push   %eax
  800546:	68 2c 3f 80 00       	push   $0x803f2c
  80054b:	e8 13 05 00 00       	call   800a63 <cprintf>
  800550:	83 c4 10             	add    $0x10,%esp
void PrintElements(int *Elements, int NumOfElements)
{
	sys_lock_cons();
		int i ;
		int NumsPerLine = 20 ;
		for (i = 0 ; i < NumOfElements-1 ; i++)
  800553:	ff 45 f4             	incl   -0xc(%ebp)
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	48                   	dec    %eax
  80055a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80055d:	7f b5                	jg     800514 <PrintElements+0x1b>
		{
			if (i%NumsPerLine == 0)
				cprintf("\n");
			cprintf("%d, ",Elements[i]);
		}
		cprintf("%d\n",Elements[i]);
  80055f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800562:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	01 d0                	add    %edx,%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	50                   	push   %eax
  800574:	68 31 3f 80 00       	push   $0x803f31
  800579:	e8 e5 04 00 00       	call   800a63 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	sys_unlock_cons();
  800581:	e8 5b 23 00 00       	call   8028e1 <sys_unlock_cons>
}
  800586:	90                   	nop
  800587:	c9                   	leave  
  800588:	c3                   	ret    

00800589 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800589:	55                   	push   %ebp
  80058a:	89 e5                	mov    %esp,%ebp
  80058c:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80058f:	8b 45 08             	mov    0x8(%ebp),%eax
  800592:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800595:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800599:	83 ec 0c             	sub    $0xc,%esp
  80059c:	50                   	push   %eax
  80059d:	e8 6d 24 00 00       	call   802a0f <sys_cputc>
  8005a2:	83 c4 10             	add    $0x10,%esp
}
  8005a5:	90                   	nop
  8005a6:	c9                   	leave  
  8005a7:	c3                   	ret    

008005a8 <getchar>:


int
getchar(void)
{
  8005a8:	55                   	push   %ebp
  8005a9:	89 e5                	mov    %esp,%ebp
  8005ab:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005ae:	e8 fb 22 00 00       	call   8028ae <sys_cgetc>
  8005b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005b9:	c9                   	leave  
  8005ba:	c3                   	ret    

008005bb <iscons>:

int iscons(int fdnum)
{
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005c3:	5d                   	pop    %ebp
  8005c4:	c3                   	ret    

008005c5 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005c5:	55                   	push   %ebp
  8005c6:	89 e5                	mov    %esp,%ebp
  8005c8:	57                   	push   %edi
  8005c9:	56                   	push   %esi
  8005ca:	53                   	push   %ebx
  8005cb:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8005ce:	e8 6d 25 00 00       	call   802b40 <sys_getenvindex>
  8005d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8005d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d9:	89 d0                	mov    %edx,%eax
  8005db:	01 c0                	add    %eax,%eax
  8005dd:	01 d0                	add    %edx,%eax
  8005df:	c1 e0 02             	shl    $0x2,%eax
  8005e2:	01 d0                	add    %edx,%eax
  8005e4:	c1 e0 02             	shl    $0x2,%eax
  8005e7:	01 d0                	add    %edx,%eax
  8005e9:	c1 e0 03             	shl    $0x3,%eax
  8005ec:	01 d0                	add    %edx,%eax
  8005ee:	c1 e0 02             	shl    $0x2,%eax
  8005f1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005f6:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005fb:	a1 24 50 80 00       	mov    0x805024,%eax
  800600:	8a 40 20             	mov    0x20(%eax),%al
  800603:	84 c0                	test   %al,%al
  800605:	74 0d                	je     800614 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800607:	a1 24 50 80 00       	mov    0x805024,%eax
  80060c:	83 c0 20             	add    $0x20,%eax
  80060f:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800614:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800618:	7e 0a                	jle    800624 <libmain+0x5f>
		binaryname = argv[0];
  80061a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	ff 75 0c             	pushl  0xc(%ebp)
  80062a:	ff 75 08             	pushl  0x8(%ebp)
  80062d:	e8 06 fa ff ff       	call   800038 <_main>
  800632:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800635:	a1 00 50 80 00       	mov    0x805000,%eax
  80063a:	85 c0                	test   %eax,%eax
  80063c:	0f 84 01 01 00 00    	je     800743 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800642:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800648:	bb 30 40 80 00       	mov    $0x804030,%ebx
  80064d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800652:	89 c7                	mov    %eax,%edi
  800654:	89 de                	mov    %ebx,%esi
  800656:	89 d1                	mov    %edx,%ecx
  800658:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80065a:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80065d:	b9 56 00 00 00       	mov    $0x56,%ecx
  800662:	b0 00                	mov    $0x0,%al
  800664:	89 d7                	mov    %edx,%edi
  800666:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800668:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80066f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	50                   	push   %eax
  800676:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80067c:	50                   	push   %eax
  80067d:	e8 f4 26 00 00       	call   802d76 <sys_utilities>
  800682:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800685:	e8 3d 22 00 00       	call   8028c7 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80068a:	83 ec 0c             	sub    $0xc,%esp
  80068d:	68 50 3f 80 00       	push   $0x803f50
  800692:	e8 cc 03 00 00       	call   800a63 <cprintf>
  800697:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80069a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069d:	85 c0                	test   %eax,%eax
  80069f:	74 18                	je     8006b9 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006a1:	e8 ee 26 00 00       	call   802d94 <sys_get_optimal_num_faults>
  8006a6:	83 ec 08             	sub    $0x8,%esp
  8006a9:	50                   	push   %eax
  8006aa:	68 78 3f 80 00       	push   $0x803f78
  8006af:	e8 af 03 00 00       	call   800a63 <cprintf>
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	eb 59                	jmp    800712 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006b9:	a1 24 50 80 00       	mov    0x805024,%eax
  8006be:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8006c4:	a1 24 50 80 00       	mov    0x805024,%eax
  8006c9:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8006cf:	83 ec 04             	sub    $0x4,%esp
  8006d2:	52                   	push   %edx
  8006d3:	50                   	push   %eax
  8006d4:	68 9c 3f 80 00       	push   $0x803f9c
  8006d9:	e8 85 03 00 00       	call   800a63 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006e1:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e6:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8006ec:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f1:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8006f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8006fc:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800702:	51                   	push   %ecx
  800703:	52                   	push   %edx
  800704:	50                   	push   %eax
  800705:	68 c4 3f 80 00       	push   $0x803fc4
  80070a:	e8 54 03 00 00       	call   800a63 <cprintf>
  80070f:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800712:	a1 24 50 80 00       	mov    0x805024,%eax
  800717:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	50                   	push   %eax
  800721:	68 1c 40 80 00       	push   $0x80401c
  800726:	e8 38 03 00 00       	call   800a63 <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80072e:	83 ec 0c             	sub    $0xc,%esp
  800731:	68 50 3f 80 00       	push   $0x803f50
  800736:	e8 28 03 00 00       	call   800a63 <cprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80073e:	e8 9e 21 00 00       	call   8028e1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800743:	e8 1f 00 00 00       	call   800767 <exit>
}
  800748:	90                   	nop
  800749:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80074c:	5b                   	pop    %ebx
  80074d:	5e                   	pop    %esi
  80074e:	5f                   	pop    %edi
  80074f:	5d                   	pop    %ebp
  800750:	c3                   	ret    

00800751 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800757:	83 ec 0c             	sub    $0xc,%esp
  80075a:	6a 00                	push   $0x0
  80075c:	e8 ab 23 00 00       	call   802b0c <sys_destroy_env>
  800761:	83 c4 10             	add    $0x10,%esp
}
  800764:	90                   	nop
  800765:	c9                   	leave  
  800766:	c3                   	ret    

00800767 <exit>:

void
exit(void)
{
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80076d:	e8 00 24 00 00       	call   802b72 <sys_exit_env>
}
  800772:	90                   	nop
  800773:	c9                   	leave  
  800774:	c3                   	ret    

00800775 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80077b:	8d 45 10             	lea    0x10(%ebp),%eax
  80077e:	83 c0 04             	add    $0x4,%eax
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800784:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800789:	85 c0                	test   %eax,%eax
  80078b:	74 16                	je     8007a3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80078d:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	50                   	push   %eax
  800796:	68 94 40 80 00       	push   $0x804094
  80079b:	e8 c3 02 00 00       	call   800a63 <cprintf>
  8007a0:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007a3:	a1 04 50 80 00       	mov    0x805004,%eax
  8007a8:	83 ec 0c             	sub    $0xc,%esp
  8007ab:	ff 75 0c             	pushl  0xc(%ebp)
  8007ae:	ff 75 08             	pushl  0x8(%ebp)
  8007b1:	50                   	push   %eax
  8007b2:	68 9c 40 80 00       	push   $0x80409c
  8007b7:	6a 74                	push   $0x74
  8007b9:	e8 d2 02 00 00       	call   800a90 <cprintf_colored>
  8007be:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8007c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	e8 24 02 00 00       	call   8009f4 <vcprintf>
  8007d0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	6a 00                	push   $0x0
  8007d8:	68 c4 40 80 00       	push   $0x8040c4
  8007dd:	e8 12 02 00 00       	call   8009f4 <vcprintf>
  8007e2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007e5:	e8 7d ff ff ff       	call   800767 <exit>

	// should not return here
	while (1) ;
  8007ea:	eb fe                	jmp    8007ea <_panic+0x75>

008007ec <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	53                   	push   %ebx
  8007f0:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007f3:	a1 24 50 80 00       	mov    0x805024,%eax
  8007f8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8007fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800801:	39 c2                	cmp    %eax,%edx
  800803:	74 14                	je     800819 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800805:	83 ec 04             	sub    $0x4,%esp
  800808:	68 c8 40 80 00       	push   $0x8040c8
  80080d:	6a 26                	push   $0x26
  80080f:	68 14 41 80 00       	push   $0x804114
  800814:	e8 5c ff ff ff       	call   800775 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800819:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800820:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800827:	e9 d9 00 00 00       	jmp    800905 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  80082c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	01 d0                	add    %edx,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	85 c0                	test   %eax,%eax
  80083f:	75 08                	jne    800849 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800841:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800844:	e9 b9 00 00 00       	jmp    800902 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800849:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800850:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800857:	eb 79                	jmp    8008d2 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800859:	a1 24 50 80 00       	mov    0x805024,%eax
  80085e:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800864:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800867:	89 d0                	mov    %edx,%eax
  800869:	01 c0                	add    %eax,%eax
  80086b:	01 d0                	add    %edx,%eax
  80086d:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800874:	01 d8                	add    %ebx,%eax
  800876:	01 d0                	add    %edx,%eax
  800878:	01 c8                	add    %ecx,%eax
  80087a:	8a 40 04             	mov    0x4(%eax),%al
  80087d:	84 c0                	test   %al,%al
  80087f:	75 4e                	jne    8008cf <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800881:	a1 24 50 80 00       	mov    0x805024,%eax
  800886:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80088c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80088f:	89 d0                	mov    %edx,%eax
  800891:	01 c0                	add    %eax,%eax
  800893:	01 d0                	add    %edx,%eax
  800895:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80089c:	01 d8                	add    %ebx,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	01 c8                	add    %ecx,%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008af:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	01 c8                	add    %ecx,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c2:	39 c2                	cmp    %eax,%edx
  8008c4:	75 09                	jne    8008cf <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8008c6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008cd:	eb 19                	jmp    8008e8 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008cf:	ff 45 e8             	incl   -0x18(%ebp)
  8008d2:	a1 24 50 80 00       	mov    0x805024,%eax
  8008d7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e0:	39 c2                	cmp    %eax,%edx
  8008e2:	0f 87 71 ff ff ff    	ja     800859 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008ec:	75 14                	jne    800902 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8008ee:	83 ec 04             	sub    $0x4,%esp
  8008f1:	68 20 41 80 00       	push   $0x804120
  8008f6:	6a 3a                	push   $0x3a
  8008f8:	68 14 41 80 00       	push   $0x804114
  8008fd:	e8 73 fe ff ff       	call   800775 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800902:	ff 45 f0             	incl   -0x10(%ebp)
  800905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800908:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80090b:	0f 8c 1b ff ff ff    	jl     80082c <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800911:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800918:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80091f:	eb 2e                	jmp    80094f <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800921:	a1 24 50 80 00       	mov    0x805024,%eax
  800926:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80092c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80092f:	89 d0                	mov    %edx,%eax
  800931:	01 c0                	add    %eax,%eax
  800933:	01 d0                	add    %edx,%eax
  800935:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80093c:	01 d8                	add    %ebx,%eax
  80093e:	01 d0                	add    %edx,%eax
  800940:	01 c8                	add    %ecx,%eax
  800942:	8a 40 04             	mov    0x4(%eax),%al
  800945:	3c 01                	cmp    $0x1,%al
  800947:	75 03                	jne    80094c <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800949:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80094c:	ff 45 e0             	incl   -0x20(%ebp)
  80094f:	a1 24 50 80 00       	mov    0x805024,%eax
  800954:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80095a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80095d:	39 c2                	cmp    %eax,%edx
  80095f:	77 c0                	ja     800921 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800964:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800967:	74 14                	je     80097d <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800969:	83 ec 04             	sub    $0x4,%esp
  80096c:	68 74 41 80 00       	push   $0x804174
  800971:	6a 44                	push   $0x44
  800973:	68 14 41 80 00       	push   $0x804114
  800978:	e8 f8 fd ff ff       	call   800775 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80097d:	90                   	nop
  80097e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	53                   	push   %ebx
  800987:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80098a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098d:	8b 00                	mov    (%eax),%eax
  80098f:	8d 48 01             	lea    0x1(%eax),%ecx
  800992:	8b 55 0c             	mov    0xc(%ebp),%edx
  800995:	89 0a                	mov    %ecx,(%edx)
  800997:	8b 55 08             	mov    0x8(%ebp),%edx
  80099a:	88 d1                	mov    %dl,%cl
  80099c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a6:	8b 00                	mov    (%eax),%eax
  8009a8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009ad:	75 30                	jne    8009df <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009af:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8009b5:	a0 44 50 80 00       	mov    0x805044,%al
  8009ba:	0f b6 c0             	movzbl %al,%eax
  8009bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c0:	8b 09                	mov    (%ecx),%ecx
  8009c2:	89 cb                	mov    %ecx,%ebx
  8009c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c7:	83 c1 08             	add    $0x8,%ecx
  8009ca:	52                   	push   %edx
  8009cb:	50                   	push   %eax
  8009cc:	53                   	push   %ebx
  8009cd:	51                   	push   %ecx
  8009ce:	e8 b0 1e 00 00       	call   802883 <sys_cputs>
  8009d3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e2:	8b 40 04             	mov    0x4(%eax),%eax
  8009e5:	8d 50 01             	lea    0x1(%eax),%edx
  8009e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009eb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009ee:	90                   	nop
  8009ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f2:	c9                   	leave  
  8009f3:	c3                   	ret    

008009f4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a04:	00 00 00 
	b.cnt = 0;
  800a07:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a0e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	ff 75 08             	pushl  0x8(%ebp)
  800a17:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a1d:	50                   	push   %eax
  800a1e:	68 83 09 80 00       	push   $0x800983
  800a23:	e8 5a 02 00 00       	call   800c82 <vprintfmt>
  800a28:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a2b:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800a31:	a0 44 50 80 00       	mov    0x805044,%al
  800a36:	0f b6 c0             	movzbl %al,%eax
  800a39:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a3f:	52                   	push   %edx
  800a40:	50                   	push   %eax
  800a41:	51                   	push   %ecx
  800a42:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a48:	83 c0 08             	add    $0x8,%eax
  800a4b:	50                   	push   %eax
  800a4c:	e8 32 1e 00 00       	call   802883 <sys_cputs>
  800a51:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a54:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800a5b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a61:	c9                   	leave  
  800a62:	c3                   	ret    

00800a63 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a69:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800a70:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a73:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	83 ec 08             	sub    $0x8,%esp
  800a7c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7f:	50                   	push   %eax
  800a80:	e8 6f ff ff ff       	call   8009f4 <vcprintf>
  800a85:	83 c4 10             	add    $0x10,%esp
  800a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a8e:	c9                   	leave  
  800a8f:	c3                   	ret    

00800a90 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a96:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	c1 e0 08             	shl    $0x8,%eax
  800aa3:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800aa8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aab:	83 c0 04             	add    $0x4,%eax
  800aae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 f4             	pushl  -0xc(%ebp)
  800aba:	50                   	push   %eax
  800abb:	e8 34 ff ff ff       	call   8009f4 <vcprintf>
  800ac0:	83 c4 10             	add    $0x10,%esp
  800ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800ac6:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800acd:	07 00 00 

	return cnt;
  800ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ad3:	c9                   	leave  
  800ad4:	c3                   	ret    

00800ad5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800adb:	e8 e7 1d 00 00       	call   8028c7 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800ae0:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ae3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	ff 75 f4             	pushl  -0xc(%ebp)
  800aef:	50                   	push   %eax
  800af0:	e8 ff fe ff ff       	call   8009f4 <vcprintf>
  800af5:	83 c4 10             	add    $0x10,%esp
  800af8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800afb:	e8 e1 1d 00 00       	call   8028e1 <sys_unlock_cons>
	return cnt;
  800b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b03:	c9                   	leave  
  800b04:	c3                   	ret    

00800b05 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	53                   	push   %ebx
  800b09:	83 ec 14             	sub    $0x14,%esp
  800b0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b12:	8b 45 14             	mov    0x14(%ebp),%eax
  800b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b18:	8b 45 18             	mov    0x18(%ebp),%eax
  800b1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b20:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b23:	77 55                	ja     800b7a <printnum+0x75>
  800b25:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b28:	72 05                	jb     800b2f <printnum+0x2a>
  800b2a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b2d:	77 4b                	ja     800b7a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b2f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b32:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b35:	8b 45 18             	mov    0x18(%ebp),%eax
  800b38:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3d:	52                   	push   %edx
  800b3e:	50                   	push   %eax
  800b3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b42:	ff 75 f0             	pushl  -0x10(%ebp)
  800b45:	e8 da 2f 00 00       	call   803b24 <__udivdi3>
  800b4a:	83 c4 10             	add    $0x10,%esp
  800b4d:	83 ec 04             	sub    $0x4,%esp
  800b50:	ff 75 20             	pushl  0x20(%ebp)
  800b53:	53                   	push   %ebx
  800b54:	ff 75 18             	pushl  0x18(%ebp)
  800b57:	52                   	push   %edx
  800b58:	50                   	push   %eax
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	ff 75 08             	pushl  0x8(%ebp)
  800b5f:	e8 a1 ff ff ff       	call   800b05 <printnum>
  800b64:	83 c4 20             	add    $0x20,%esp
  800b67:	eb 1a                	jmp    800b83 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b69:	83 ec 08             	sub    $0x8,%esp
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	ff 75 20             	pushl  0x20(%ebp)
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	ff d0                	call   *%eax
  800b77:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b7a:	ff 4d 1c             	decl   0x1c(%ebp)
  800b7d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b81:	7f e6                	jg     800b69 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b83:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b91:	53                   	push   %ebx
  800b92:	51                   	push   %ecx
  800b93:	52                   	push   %edx
  800b94:	50                   	push   %eax
  800b95:	e8 9a 30 00 00       	call   803c34 <__umoddi3>
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	05 d4 43 80 00       	add    $0x8043d4,%eax
  800ba2:	8a 00                	mov    (%eax),%al
  800ba4:	0f be c0             	movsbl %al,%eax
  800ba7:	83 ec 08             	sub    $0x8,%esp
  800baa:	ff 75 0c             	pushl  0xc(%ebp)
  800bad:	50                   	push   %eax
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	ff d0                	call   *%eax
  800bb3:	83 c4 10             	add    $0x10,%esp
}
  800bb6:	90                   	nop
  800bb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bbf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bc3:	7e 1c                	jle    800be1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	8d 50 08             	lea    0x8(%eax),%edx
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	89 10                	mov    %edx,(%eax)
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8b 00                	mov    (%eax),%eax
  800bd7:	83 e8 08             	sub    $0x8,%eax
  800bda:	8b 50 04             	mov    0x4(%eax),%edx
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	eb 40                	jmp    800c21 <getuint+0x65>
	else if (lflag)
  800be1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be5:	74 1e                	je     800c05 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8b 00                	mov    (%eax),%eax
  800bec:	8d 50 04             	lea    0x4(%eax),%edx
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	89 10                	mov    %edx,(%eax)
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	83 e8 04             	sub    $0x4,%eax
  800bfc:	8b 00                	mov    (%eax),%eax
  800bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800c03:	eb 1c                	jmp    800c21 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8b 00                	mov    (%eax),%eax
  800c0a:	8d 50 04             	lea    0x4(%eax),%edx
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 10                	mov    %edx,(%eax)
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	8b 00                	mov    (%eax),%eax
  800c17:	83 e8 04             	sub    $0x4,%eax
  800c1a:	8b 00                	mov    (%eax),%eax
  800c1c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c26:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c2a:	7e 1c                	jle    800c48 <getint+0x25>
		return va_arg(*ap, long long);
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	8b 00                	mov    (%eax),%eax
  800c31:	8d 50 08             	lea    0x8(%eax),%edx
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	89 10                	mov    %edx,(%eax)
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8b 00                	mov    (%eax),%eax
  800c3e:	83 e8 08             	sub    $0x8,%eax
  800c41:	8b 50 04             	mov    0x4(%eax),%edx
  800c44:	8b 00                	mov    (%eax),%eax
  800c46:	eb 38                	jmp    800c80 <getint+0x5d>
	else if (lflag)
  800c48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4c:	74 1a                	je     800c68 <getint+0x45>
		return va_arg(*ap, long);
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	8b 00                	mov    (%eax),%eax
  800c53:	8d 50 04             	lea    0x4(%eax),%edx
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	89 10                	mov    %edx,(%eax)
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8b 00                	mov    (%eax),%eax
  800c60:	83 e8 04             	sub    $0x4,%eax
  800c63:	8b 00                	mov    (%eax),%eax
  800c65:	99                   	cltd   
  800c66:	eb 18                	jmp    800c80 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8b 00                	mov    (%eax),%eax
  800c6d:	8d 50 04             	lea    0x4(%eax),%edx
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	89 10                	mov    %edx,(%eax)
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8b 00                	mov    (%eax),%eax
  800c7a:	83 e8 04             	sub    $0x4,%eax
  800c7d:	8b 00                	mov    (%eax),%eax
  800c7f:	99                   	cltd   
}
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
  800c87:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c8a:	eb 17                	jmp    800ca3 <vprintfmt+0x21>
			if (ch == '\0')
  800c8c:	85 db                	test   %ebx,%ebx
  800c8e:	0f 84 c1 03 00 00    	je     801055 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c94:	83 ec 08             	sub    $0x8,%esp
  800c97:	ff 75 0c             	pushl  0xc(%ebp)
  800c9a:	53                   	push   %ebx
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	ff d0                	call   *%eax
  800ca0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ca3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca6:	8d 50 01             	lea    0x1(%eax),%edx
  800ca9:	89 55 10             	mov    %edx,0x10(%ebp)
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	0f b6 d8             	movzbl %al,%ebx
  800cb1:	83 fb 25             	cmp    $0x25,%ebx
  800cb4:	75 d6                	jne    800c8c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cb6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cc1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cc8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ccf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd9:	8d 50 01             	lea    0x1(%eax),%edx
  800cdc:	89 55 10             	mov    %edx,0x10(%ebp)
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	0f b6 d8             	movzbl %al,%ebx
  800ce4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ce7:	83 f8 5b             	cmp    $0x5b,%eax
  800cea:	0f 87 3d 03 00 00    	ja     80102d <vprintfmt+0x3ab>
  800cf0:	8b 04 85 f8 43 80 00 	mov    0x8043f8(,%eax,4),%eax
  800cf7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cf9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cfd:	eb d7                	jmp    800cd6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cff:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d03:	eb d1                	jmp    800cd6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d05:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d0f:	89 d0                	mov    %edx,%eax
  800d11:	c1 e0 02             	shl    $0x2,%eax
  800d14:	01 d0                	add    %edx,%eax
  800d16:	01 c0                	add    %eax,%eax
  800d18:	01 d8                	add    %ebx,%eax
  800d1a:	83 e8 30             	sub    $0x30,%eax
  800d1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d20:	8b 45 10             	mov    0x10(%ebp),%eax
  800d23:	8a 00                	mov    (%eax),%al
  800d25:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d28:	83 fb 2f             	cmp    $0x2f,%ebx
  800d2b:	7e 3e                	jle    800d6b <vprintfmt+0xe9>
  800d2d:	83 fb 39             	cmp    $0x39,%ebx
  800d30:	7f 39                	jg     800d6b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d32:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d35:	eb d5                	jmp    800d0c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d37:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3a:	83 c0 04             	add    $0x4,%eax
  800d3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 e8 04             	sub    $0x4,%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d4b:	eb 1f                	jmp    800d6c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d51:	79 83                	jns    800cd6 <vprintfmt+0x54>
				width = 0;
  800d53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d5a:	e9 77 ff ff ff       	jmp    800cd6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d5f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d66:	e9 6b ff ff ff       	jmp    800cd6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d6b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d70:	0f 89 60 ff ff ff    	jns    800cd6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d7c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d83:	e9 4e ff ff ff       	jmp    800cd6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d88:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d8b:	e9 46 ff ff ff       	jmp    800cd6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d90:	8b 45 14             	mov    0x14(%ebp),%eax
  800d93:	83 c0 04             	add    $0x4,%eax
  800d96:	89 45 14             	mov    %eax,0x14(%ebp)
  800d99:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9c:	83 e8 04             	sub    $0x4,%eax
  800d9f:	8b 00                	mov    (%eax),%eax
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	50                   	push   %eax
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	ff d0                	call   *%eax
  800dad:	83 c4 10             	add    $0x10,%esp
			break;
  800db0:	e9 9b 02 00 00       	jmp    801050 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800db5:	8b 45 14             	mov    0x14(%ebp),%eax
  800db8:	83 c0 04             	add    $0x4,%eax
  800dbb:	89 45 14             	mov    %eax,0x14(%ebp)
  800dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc1:	83 e8 04             	sub    $0x4,%eax
  800dc4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800dc6:	85 db                	test   %ebx,%ebx
  800dc8:	79 02                	jns    800dcc <vprintfmt+0x14a>
				err = -err;
  800dca:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dcc:	83 fb 64             	cmp    $0x64,%ebx
  800dcf:	7f 0b                	jg     800ddc <vprintfmt+0x15a>
  800dd1:	8b 34 9d 40 42 80 00 	mov    0x804240(,%ebx,4),%esi
  800dd8:	85 f6                	test   %esi,%esi
  800dda:	75 19                	jne    800df5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ddc:	53                   	push   %ebx
  800ddd:	68 e5 43 80 00       	push   $0x8043e5
  800de2:	ff 75 0c             	pushl  0xc(%ebp)
  800de5:	ff 75 08             	pushl  0x8(%ebp)
  800de8:	e8 70 02 00 00       	call   80105d <printfmt>
  800ded:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800df0:	e9 5b 02 00 00       	jmp    801050 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800df5:	56                   	push   %esi
  800df6:	68 ee 43 80 00       	push   $0x8043ee
  800dfb:	ff 75 0c             	pushl  0xc(%ebp)
  800dfe:	ff 75 08             	pushl  0x8(%ebp)
  800e01:	e8 57 02 00 00       	call   80105d <printfmt>
  800e06:	83 c4 10             	add    $0x10,%esp
			break;
  800e09:	e9 42 02 00 00       	jmp    801050 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e11:	83 c0 04             	add    $0x4,%eax
  800e14:	89 45 14             	mov    %eax,0x14(%ebp)
  800e17:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1a:	83 e8 04             	sub    $0x4,%eax
  800e1d:	8b 30                	mov    (%eax),%esi
  800e1f:	85 f6                	test   %esi,%esi
  800e21:	75 05                	jne    800e28 <vprintfmt+0x1a6>
				p = "(null)";
  800e23:	be f1 43 80 00       	mov    $0x8043f1,%esi
			if (width > 0 && padc != '-')
  800e28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e2c:	7e 6d                	jle    800e9b <vprintfmt+0x219>
  800e2e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e32:	74 67                	je     800e9b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e37:	83 ec 08             	sub    $0x8,%esp
  800e3a:	50                   	push   %eax
  800e3b:	56                   	push   %esi
  800e3c:	e8 26 05 00 00       	call   801367 <strnlen>
  800e41:	83 c4 10             	add    $0x10,%esp
  800e44:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e47:	eb 16                	jmp    800e5f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e49:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e4d:	83 ec 08             	sub    $0x8,%esp
  800e50:	ff 75 0c             	pushl  0xc(%ebp)
  800e53:	50                   	push   %eax
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	ff d0                	call   *%eax
  800e59:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e5c:	ff 4d e4             	decl   -0x1c(%ebp)
  800e5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e63:	7f e4                	jg     800e49 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e65:	eb 34                	jmp    800e9b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e6b:	74 1c                	je     800e89 <vprintfmt+0x207>
  800e6d:	83 fb 1f             	cmp    $0x1f,%ebx
  800e70:	7e 05                	jle    800e77 <vprintfmt+0x1f5>
  800e72:	83 fb 7e             	cmp    $0x7e,%ebx
  800e75:	7e 12                	jle    800e89 <vprintfmt+0x207>
					putch('?', putdat);
  800e77:	83 ec 08             	sub    $0x8,%esp
  800e7a:	ff 75 0c             	pushl  0xc(%ebp)
  800e7d:	6a 3f                	push   $0x3f
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	ff d0                	call   *%eax
  800e84:	83 c4 10             	add    $0x10,%esp
  800e87:	eb 0f                	jmp    800e98 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	ff 75 0c             	pushl  0xc(%ebp)
  800e8f:	53                   	push   %ebx
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	ff d0                	call   *%eax
  800e95:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e98:	ff 4d e4             	decl   -0x1c(%ebp)
  800e9b:	89 f0                	mov    %esi,%eax
  800e9d:	8d 70 01             	lea    0x1(%eax),%esi
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	0f be d8             	movsbl %al,%ebx
  800ea5:	85 db                	test   %ebx,%ebx
  800ea7:	74 24                	je     800ecd <vprintfmt+0x24b>
  800ea9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ead:	78 b8                	js     800e67 <vprintfmt+0x1e5>
  800eaf:	ff 4d e0             	decl   -0x20(%ebp)
  800eb2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800eb6:	79 af                	jns    800e67 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eb8:	eb 13                	jmp    800ecd <vprintfmt+0x24b>
				putch(' ', putdat);
  800eba:	83 ec 08             	sub    $0x8,%esp
  800ebd:	ff 75 0c             	pushl  0xc(%ebp)
  800ec0:	6a 20                	push   $0x20
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	ff d0                	call   *%eax
  800ec7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eca:	ff 4d e4             	decl   -0x1c(%ebp)
  800ecd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed1:	7f e7                	jg     800eba <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ed3:	e9 78 01 00 00       	jmp    801050 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ed8:	83 ec 08             	sub    $0x8,%esp
  800edb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ede:	8d 45 14             	lea    0x14(%ebp),%eax
  800ee1:	50                   	push   %eax
  800ee2:	e8 3c fd ff ff       	call   800c23 <getint>
  800ee7:	83 c4 10             	add    $0x10,%esp
  800eea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef6:	85 d2                	test   %edx,%edx
  800ef8:	79 23                	jns    800f1d <vprintfmt+0x29b>
				putch('-', putdat);
  800efa:	83 ec 08             	sub    $0x8,%esp
  800efd:	ff 75 0c             	pushl  0xc(%ebp)
  800f00:	6a 2d                	push   $0x2d
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	ff d0                	call   *%eax
  800f07:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f10:	f7 d8                	neg    %eax
  800f12:	83 d2 00             	adc    $0x0,%edx
  800f15:	f7 da                	neg    %edx
  800f17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f1d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f24:	e9 bc 00 00 00       	jmp    800fe5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f29:	83 ec 08             	sub    $0x8,%esp
  800f2c:	ff 75 e8             	pushl  -0x18(%ebp)
  800f2f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f32:	50                   	push   %eax
  800f33:	e8 84 fc ff ff       	call   800bbc <getuint>
  800f38:	83 c4 10             	add    $0x10,%esp
  800f3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f41:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f48:	e9 98 00 00 00       	jmp    800fe5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	6a 58                	push   $0x58
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	ff d0                	call   *%eax
  800f5a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f5d:	83 ec 08             	sub    $0x8,%esp
  800f60:	ff 75 0c             	pushl  0xc(%ebp)
  800f63:	6a 58                	push   $0x58
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	ff d0                	call   *%eax
  800f6a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f6d:	83 ec 08             	sub    $0x8,%esp
  800f70:	ff 75 0c             	pushl  0xc(%ebp)
  800f73:	6a 58                	push   $0x58
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	ff d0                	call   *%eax
  800f7a:	83 c4 10             	add    $0x10,%esp
			break;
  800f7d:	e9 ce 00 00 00       	jmp    801050 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f82:	83 ec 08             	sub    $0x8,%esp
  800f85:	ff 75 0c             	pushl  0xc(%ebp)
  800f88:	6a 30                	push   $0x30
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	ff d0                	call   *%eax
  800f8f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f92:	83 ec 08             	sub    $0x8,%esp
  800f95:	ff 75 0c             	pushl  0xc(%ebp)
  800f98:	6a 78                	push   $0x78
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	ff d0                	call   *%eax
  800f9f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa5:	83 c0 04             	add    $0x4,%eax
  800fa8:	89 45 14             	mov    %eax,0x14(%ebp)
  800fab:	8b 45 14             	mov    0x14(%ebp),%eax
  800fae:	83 e8 04             	sub    $0x4,%eax
  800fb1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fbd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fc4:	eb 1f                	jmp    800fe5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fc6:	83 ec 08             	sub    $0x8,%esp
  800fc9:	ff 75 e8             	pushl  -0x18(%ebp)
  800fcc:	8d 45 14             	lea    0x14(%ebp),%eax
  800fcf:	50                   	push   %eax
  800fd0:	e8 e7 fb ff ff       	call   800bbc <getuint>
  800fd5:	83 c4 10             	add    $0x10,%esp
  800fd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fdb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fde:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fe5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fec:	83 ec 04             	sub    $0x4,%esp
  800fef:	52                   	push   %edx
  800ff0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ff3:	50                   	push   %eax
  800ff4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff7:	ff 75 f0             	pushl  -0x10(%ebp)
  800ffa:	ff 75 0c             	pushl  0xc(%ebp)
  800ffd:	ff 75 08             	pushl  0x8(%ebp)
  801000:	e8 00 fb ff ff       	call   800b05 <printnum>
  801005:	83 c4 20             	add    $0x20,%esp
			break;
  801008:	eb 46                	jmp    801050 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80100a:	83 ec 08             	sub    $0x8,%esp
  80100d:	ff 75 0c             	pushl  0xc(%ebp)
  801010:	53                   	push   %ebx
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	ff d0                	call   *%eax
  801016:	83 c4 10             	add    $0x10,%esp
			break;
  801019:	eb 35                	jmp    801050 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80101b:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  801022:	eb 2c                	jmp    801050 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801024:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  80102b:	eb 23                	jmp    801050 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80102d:	83 ec 08             	sub    $0x8,%esp
  801030:	ff 75 0c             	pushl  0xc(%ebp)
  801033:	6a 25                	push   $0x25
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	ff d0                	call   *%eax
  80103a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80103d:	ff 4d 10             	decl   0x10(%ebp)
  801040:	eb 03                	jmp    801045 <vprintfmt+0x3c3>
  801042:	ff 4d 10             	decl   0x10(%ebp)
  801045:	8b 45 10             	mov    0x10(%ebp),%eax
  801048:	48                   	dec    %eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	3c 25                	cmp    $0x25,%al
  80104d:	75 f3                	jne    801042 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80104f:	90                   	nop
		}
	}
  801050:	e9 35 fc ff ff       	jmp    800c8a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801055:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801056:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801059:	5b                   	pop    %ebx
  80105a:	5e                   	pop    %esi
  80105b:	5d                   	pop    %ebp
  80105c:	c3                   	ret    

0080105d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801063:	8d 45 10             	lea    0x10(%ebp),%eax
  801066:	83 c0 04             	add    $0x4,%eax
  801069:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80106c:	8b 45 10             	mov    0x10(%ebp),%eax
  80106f:	ff 75 f4             	pushl  -0xc(%ebp)
  801072:	50                   	push   %eax
  801073:	ff 75 0c             	pushl  0xc(%ebp)
  801076:	ff 75 08             	pushl  0x8(%ebp)
  801079:	e8 04 fc ff ff       	call   800c82 <vprintfmt>
  80107e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801081:	90                   	nop
  801082:	c9                   	leave  
  801083:	c3                   	ret    

00801084 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108a:	8b 40 08             	mov    0x8(%eax),%eax
  80108d:	8d 50 01             	lea    0x1(%eax),%edx
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801096:	8b 45 0c             	mov    0xc(%ebp),%eax
  801099:	8b 10                	mov    (%eax),%edx
  80109b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109e:	8b 40 04             	mov    0x4(%eax),%eax
  8010a1:	39 c2                	cmp    %eax,%edx
  8010a3:	73 12                	jae    8010b7 <sprintputch+0x33>
		*b->buf++ = ch;
  8010a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a8:	8b 00                	mov    (%eax),%eax
  8010aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8010ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b0:	89 0a                	mov    %ecx,(%edx)
  8010b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b5:	88 10                	mov    %dl,(%eax)
}
  8010b7:	90                   	nop
  8010b8:	5d                   	pop    %ebp
  8010b9:	c3                   	ret    

008010ba <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	01 d0                	add    %edx,%eax
  8010d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010df:	74 06                	je     8010e7 <vsnprintf+0x2d>
  8010e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e5:	7f 07                	jg     8010ee <vsnprintf+0x34>
		return -E_INVAL;
  8010e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8010ec:	eb 20                	jmp    80110e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010ee:	ff 75 14             	pushl  0x14(%ebp)
  8010f1:	ff 75 10             	pushl  0x10(%ebp)
  8010f4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010f7:	50                   	push   %eax
  8010f8:	68 84 10 80 00       	push   $0x801084
  8010fd:	e8 80 fb ff ff       	call   800c82 <vprintfmt>
  801102:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801105:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801108:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80110b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801116:	8d 45 10             	lea    0x10(%ebp),%eax
  801119:	83 c0 04             	add    $0x4,%eax
  80111c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80111f:	8b 45 10             	mov    0x10(%ebp),%eax
  801122:	ff 75 f4             	pushl  -0xc(%ebp)
  801125:	50                   	push   %eax
  801126:	ff 75 0c             	pushl  0xc(%ebp)
  801129:	ff 75 08             	pushl  0x8(%ebp)
  80112c:	e8 89 ff ff ff       	call   8010ba <vsnprintf>
  801131:	83 c4 10             	add    $0x10,%esp
  801134:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801137:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80113a:	c9                   	leave  
  80113b:	c3                   	ret    

0080113c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801142:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801146:	74 13                	je     80115b <readline+0x1f>
		cprintf("%s", prompt);
  801148:	83 ec 08             	sub    $0x8,%esp
  80114b:	ff 75 08             	pushl  0x8(%ebp)
  80114e:	68 68 45 80 00       	push   $0x804568
  801153:	e8 0b f9 ff ff       	call   800a63 <cprintf>
  801158:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80115b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801162:	83 ec 0c             	sub    $0xc,%esp
  801165:	6a 00                	push   $0x0
  801167:	e8 4f f4 ff ff       	call   8005bb <iscons>
  80116c:	83 c4 10             	add    $0x10,%esp
  80116f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801172:	e8 31 f4 ff ff       	call   8005a8 <getchar>
  801177:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80117a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80117e:	79 22                	jns    8011a2 <readline+0x66>
			if (c != -E_EOF)
  801180:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801184:	0f 84 ad 00 00 00    	je     801237 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80118a:	83 ec 08             	sub    $0x8,%esp
  80118d:	ff 75 ec             	pushl  -0x14(%ebp)
  801190:	68 6b 45 80 00       	push   $0x80456b
  801195:	e8 c9 f8 ff ff       	call   800a63 <cprintf>
  80119a:	83 c4 10             	add    $0x10,%esp
			break;
  80119d:	e9 95 00 00 00       	jmp    801237 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011a2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011a6:	7e 34                	jle    8011dc <readline+0xa0>
  8011a8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011af:	7f 2b                	jg     8011dc <readline+0xa0>
			if (echoing)
  8011b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011b5:	74 0e                	je     8011c5 <readline+0x89>
				cputchar(c);
  8011b7:	83 ec 0c             	sub    $0xc,%esp
  8011ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8011bd:	e8 c7 f3 ff ff       	call   800589 <cputchar>
  8011c2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c8:	8d 50 01             	lea    0x1(%eax),%edx
  8011cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	01 d0                	add    %edx,%eax
  8011d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011d8:	88 10                	mov    %dl,(%eax)
  8011da:	eb 56                	jmp    801232 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8011dc:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8011e0:	75 1f                	jne    801201 <readline+0xc5>
  8011e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011e6:	7e 19                	jle    801201 <readline+0xc5>
			if (echoing)
  8011e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011ec:	74 0e                	je     8011fc <readline+0xc0>
				cputchar(c);
  8011ee:	83 ec 0c             	sub    $0xc,%esp
  8011f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8011f4:	e8 90 f3 ff ff       	call   800589 <cputchar>
  8011f9:	83 c4 10             	add    $0x10,%esp

			i--;
  8011fc:	ff 4d f4             	decl   -0xc(%ebp)
  8011ff:	eb 31                	jmp    801232 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801201:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801205:	74 0a                	je     801211 <readline+0xd5>
  801207:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80120b:	0f 85 61 ff ff ff    	jne    801172 <readline+0x36>
			if (echoing)
  801211:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801215:	74 0e                	je     801225 <readline+0xe9>
				cputchar(c);
  801217:	83 ec 0c             	sub    $0xc,%esp
  80121a:	ff 75 ec             	pushl  -0x14(%ebp)
  80121d:	e8 67 f3 ff ff       	call   800589 <cputchar>
  801222:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801225:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	01 d0                	add    %edx,%eax
  80122d:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801230:	eb 06                	jmp    801238 <readline+0xfc>
		}
	}
  801232:	e9 3b ff ff ff       	jmp    801172 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801237:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801238:	90                   	nop
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801241:	e8 81 16 00 00       	call   8028c7 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801246:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80124a:	74 13                	je     80125f <atomic_readline+0x24>
			cprintf("%s", prompt);
  80124c:	83 ec 08             	sub    $0x8,%esp
  80124f:	ff 75 08             	pushl  0x8(%ebp)
  801252:	68 68 45 80 00       	push   $0x804568
  801257:	e8 07 f8 ff ff       	call   800a63 <cprintf>
  80125c:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80125f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801266:	83 ec 0c             	sub    $0xc,%esp
  801269:	6a 00                	push   $0x0
  80126b:	e8 4b f3 ff ff       	call   8005bb <iscons>
  801270:	83 c4 10             	add    $0x10,%esp
  801273:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801276:	e8 2d f3 ff ff       	call   8005a8 <getchar>
  80127b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80127e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801282:	79 22                	jns    8012a6 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801284:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801288:	0f 84 ad 00 00 00    	je     80133b <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  80128e:	83 ec 08             	sub    $0x8,%esp
  801291:	ff 75 ec             	pushl  -0x14(%ebp)
  801294:	68 6b 45 80 00       	push   $0x80456b
  801299:	e8 c5 f7 ff ff       	call   800a63 <cprintf>
  80129e:	83 c4 10             	add    $0x10,%esp
				break;
  8012a1:	e9 95 00 00 00       	jmp    80133b <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8012a6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012aa:	7e 34                	jle    8012e0 <atomic_readline+0xa5>
  8012ac:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012b3:	7f 2b                	jg     8012e0 <atomic_readline+0xa5>
				if (echoing)
  8012b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012b9:	74 0e                	je     8012c9 <atomic_readline+0x8e>
					cputchar(c);
  8012bb:	83 ec 0c             	sub    $0xc,%esp
  8012be:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c1:	e8 c3 f2 ff ff       	call   800589 <cputchar>
  8012c6:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8012c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cc:	8d 50 01             	lea    0x1(%eax),%edx
  8012cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012d2:	89 c2                	mov    %eax,%edx
  8012d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d7:	01 d0                	add    %edx,%eax
  8012d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012dc:	88 10                	mov    %dl,(%eax)
  8012de:	eb 56                	jmp    801336 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  8012e0:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012e4:	75 1f                	jne    801305 <atomic_readline+0xca>
  8012e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012ea:	7e 19                	jle    801305 <atomic_readline+0xca>
				if (echoing)
  8012ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012f0:	74 0e                	je     801300 <atomic_readline+0xc5>
					cputchar(c);
  8012f2:	83 ec 0c             	sub    $0xc,%esp
  8012f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012f8:	e8 8c f2 ff ff       	call   800589 <cputchar>
  8012fd:	83 c4 10             	add    $0x10,%esp
				i--;
  801300:	ff 4d f4             	decl   -0xc(%ebp)
  801303:	eb 31                	jmp    801336 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801305:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801309:	74 0a                	je     801315 <atomic_readline+0xda>
  80130b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80130f:	0f 85 61 ff ff ff    	jne    801276 <atomic_readline+0x3b>
				if (echoing)
  801315:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801319:	74 0e                	je     801329 <atomic_readline+0xee>
					cputchar(c);
  80131b:	83 ec 0c             	sub    $0xc,%esp
  80131e:	ff 75 ec             	pushl  -0x14(%ebp)
  801321:	e8 63 f2 ff ff       	call   800589 <cputchar>
  801326:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	01 d0                	add    %edx,%eax
  801331:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801334:	eb 06                	jmp    80133c <atomic_readline+0x101>
			}
		}
  801336:	e9 3b ff ff ff       	jmp    801276 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80133b:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80133c:	e8 a0 15 00 00       	call   8028e1 <sys_unlock_cons>
}
  801341:	90                   	nop
  801342:	c9                   	leave  
  801343:	c3                   	ret    

00801344 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80134a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801351:	eb 06                	jmp    801359 <strlen+0x15>
		n++;
  801353:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801356:	ff 45 08             	incl   0x8(%ebp)
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	75 f1                	jne    801353 <strlen+0xf>
		n++;
	return n;
  801362:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80136d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801374:	eb 09                	jmp    80137f <strnlen+0x18>
		n++;
  801376:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801379:	ff 45 08             	incl   0x8(%ebp)
  80137c:	ff 4d 0c             	decl   0xc(%ebp)
  80137f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801383:	74 09                	je     80138e <strnlen+0x27>
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	8a 00                	mov    (%eax),%al
  80138a:	84 c0                	test   %al,%al
  80138c:	75 e8                	jne    801376 <strnlen+0xf>
		n++;
	return n;
  80138e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80139f:	90                   	nop
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8d 50 01             	lea    0x1(%eax),%edx
  8013a6:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013af:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013b2:	8a 12                	mov    (%edx),%dl
  8013b4:	88 10                	mov    %dl,(%eax)
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	84 c0                	test   %al,%al
  8013ba:	75 e4                	jne    8013a0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013d4:	eb 1f                	jmp    8013f5 <strncpy+0x34>
		*dst++ = *src;
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8d 50 01             	lea    0x1(%eax),%edx
  8013dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8013df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e2:	8a 12                	mov    (%edx),%dl
  8013e4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	84 c0                	test   %al,%al
  8013ed:	74 03                	je     8013f2 <strncpy+0x31>
			src++;
  8013ef:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013f2:	ff 45 fc             	incl   -0x4(%ebp)
  8013f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013fb:	72 d9                	jb     8013d6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801400:	c9                   	leave  
  801401:	c3                   	ret    

00801402 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80140e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801412:	74 30                	je     801444 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801414:	eb 16                	jmp    80142c <strlcpy+0x2a>
			*dst++ = *src++;
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	8d 50 01             	lea    0x1(%eax),%edx
  80141c:	89 55 08             	mov    %edx,0x8(%ebp)
  80141f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801422:	8d 4a 01             	lea    0x1(%edx),%ecx
  801425:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801428:	8a 12                	mov    (%edx),%dl
  80142a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80142c:	ff 4d 10             	decl   0x10(%ebp)
  80142f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801433:	74 09                	je     80143e <strlcpy+0x3c>
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	84 c0                	test   %al,%al
  80143c:	75 d8                	jne    801416 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801444:	8b 55 08             	mov    0x8(%ebp),%edx
  801447:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80144a:	29 c2                	sub    %eax,%edx
  80144c:	89 d0                	mov    %edx,%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801453:	eb 06                	jmp    80145b <strcmp+0xb>
		p++, q++;
  801455:	ff 45 08             	incl   0x8(%ebp)
  801458:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	84 c0                	test   %al,%al
  801462:	74 0e                	je     801472 <strcmp+0x22>
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 10                	mov    (%eax),%dl
  801469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	38 c2                	cmp    %al,%dl
  801470:	74 e3                	je     801455 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	0f b6 d0             	movzbl %al,%edx
  80147a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	0f b6 c0             	movzbl %al,%eax
  801482:	29 c2                	sub    %eax,%edx
  801484:	89 d0                	mov    %edx,%eax
}
  801486:	5d                   	pop    %ebp
  801487:	c3                   	ret    

00801488 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80148b:	eb 09                	jmp    801496 <strncmp+0xe>
		n--, p++, q++;
  80148d:	ff 4d 10             	decl   0x10(%ebp)
  801490:	ff 45 08             	incl   0x8(%ebp)
  801493:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801496:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80149a:	74 17                	je     8014b3 <strncmp+0x2b>
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	8a 00                	mov    (%eax),%al
  8014a1:	84 c0                	test   %al,%al
  8014a3:	74 0e                	je     8014b3 <strncmp+0x2b>
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8a 10                	mov    (%eax),%dl
  8014aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	38 c2                	cmp    %al,%dl
  8014b1:	74 da                	je     80148d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b7:	75 07                	jne    8014c0 <strncmp+0x38>
		return 0;
  8014b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014be:	eb 14                	jmp    8014d4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	8a 00                	mov    (%eax),%al
  8014c5:	0f b6 d0             	movzbl %al,%edx
  8014c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cb:	8a 00                	mov    (%eax),%al
  8014cd:	0f b6 c0             	movzbl %al,%eax
  8014d0:	29 c2                	sub    %eax,%edx
  8014d2:	89 d0                	mov    %edx,%eax
}
  8014d4:	5d                   	pop    %ebp
  8014d5:	c3                   	ret    

008014d6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	83 ec 04             	sub    $0x4,%esp
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014e2:	eb 12                	jmp    8014f6 <strchr+0x20>
		if (*s == c)
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e7:	8a 00                	mov    (%eax),%al
  8014e9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014ec:	75 05                	jne    8014f3 <strchr+0x1d>
			return (char *) s;
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	eb 11                	jmp    801504 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014f3:	ff 45 08             	incl   0x8(%ebp)
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	8a 00                	mov    (%eax),%al
  8014fb:	84 c0                	test   %al,%al
  8014fd:	75 e5                	jne    8014e4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	83 ec 04             	sub    $0x4,%esp
  80150c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801512:	eb 0d                	jmp    801521 <strfind+0x1b>
		if (*s == c)
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	8a 00                	mov    (%eax),%al
  801519:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80151c:	74 0e                	je     80152c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80151e:	ff 45 08             	incl   0x8(%ebp)
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	84 c0                	test   %al,%al
  801528:	75 ea                	jne    801514 <strfind+0xe>
  80152a:	eb 01                	jmp    80152d <strfind+0x27>
		if (*s == c)
			break;
  80152c:	90                   	nop
	return (char *) s;
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80153e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801542:	76 63                	jbe    8015a7 <memset+0x75>
		uint64 data_block = c;
  801544:	8b 45 0c             	mov    0xc(%ebp),%eax
  801547:	99                   	cltd   
  801548:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80154b:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80154e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801551:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801554:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801558:	c1 e0 08             	shl    $0x8,%eax
  80155b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80155e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801564:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801567:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80156b:	c1 e0 10             	shl    $0x10,%eax
  80156e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801571:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801577:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157a:	89 c2                	mov    %eax,%edx
  80157c:	b8 00 00 00 00       	mov    $0x0,%eax
  801581:	09 45 f0             	or     %eax,-0x10(%ebp)
  801584:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801587:	eb 18                	jmp    8015a1 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801589:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80158c:	8d 41 08             	lea    0x8(%ecx),%eax
  80158f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801595:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801598:	89 01                	mov    %eax,(%ecx)
  80159a:	89 51 04             	mov    %edx,0x4(%ecx)
  80159d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8015a1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015a5:	77 e2                	ja     801589 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8015a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ab:	74 23                	je     8015d0 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8015ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015b3:	eb 0e                	jmp    8015c3 <memset+0x91>
			*p8++ = (uint8)c;
  8015b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b8:	8d 50 01             	lea    0x1(%eax),%edx
  8015bb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c1:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8015c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	75 e5                	jne    8015b5 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8015db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8015e7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015eb:	76 24                	jbe    801611 <memcpy+0x3c>
		while(n >= 8){
  8015ed:	eb 1c                	jmp    80160b <memcpy+0x36>
			*d64 = *s64;
  8015ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f2:	8b 50 04             	mov    0x4(%eax),%edx
  8015f5:	8b 00                	mov    (%eax),%eax
  8015f7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015fa:	89 01                	mov    %eax,(%ecx)
  8015fc:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8015ff:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801603:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801607:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80160b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80160f:	77 de                	ja     8015ef <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801611:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801615:	74 31                	je     801648 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801617:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80161a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80161d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801620:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801623:	eb 16                	jmp    80163b <memcpy+0x66>
			*d8++ = *s8++;
  801625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801628:	8d 50 01             	lea    0x1(%eax),%edx
  80162b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80162e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801631:	8d 4a 01             	lea    0x1(%edx),%ecx
  801634:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801637:	8a 12                	mov    (%edx),%dl
  801639:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80163b:	8b 45 10             	mov    0x10(%ebp),%eax
  80163e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801641:	89 55 10             	mov    %edx,0x10(%ebp)
  801644:	85 c0                	test   %eax,%eax
  801646:	75 dd                	jne    801625 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801653:	8b 45 0c             	mov    0xc(%ebp),%eax
  801656:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80165f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801662:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801665:	73 50                	jae    8016b7 <memmove+0x6a>
  801667:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80166a:	8b 45 10             	mov    0x10(%ebp),%eax
  80166d:	01 d0                	add    %edx,%eax
  80166f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801672:	76 43                	jbe    8016b7 <memmove+0x6a>
		s += n;
  801674:	8b 45 10             	mov    0x10(%ebp),%eax
  801677:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80167a:	8b 45 10             	mov    0x10(%ebp),%eax
  80167d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801680:	eb 10                	jmp    801692 <memmove+0x45>
			*--d = *--s;
  801682:	ff 4d f8             	decl   -0x8(%ebp)
  801685:	ff 4d fc             	decl   -0x4(%ebp)
  801688:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168b:	8a 10                	mov    (%eax),%dl
  80168d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801690:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801692:	8b 45 10             	mov    0x10(%ebp),%eax
  801695:	8d 50 ff             	lea    -0x1(%eax),%edx
  801698:	89 55 10             	mov    %edx,0x10(%ebp)
  80169b:	85 c0                	test   %eax,%eax
  80169d:	75 e3                	jne    801682 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80169f:	eb 23                	jmp    8016c4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a4:	8d 50 01             	lea    0x1(%eax),%edx
  8016a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ad:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016b0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016b3:	8a 12                	mov    (%edx),%dl
  8016b5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ba:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	75 dd                	jne    8016a1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016db:	eb 2a                	jmp    801707 <memcmp+0x3e>
		if (*s1 != *s2)
  8016dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e0:	8a 10                	mov    (%eax),%dl
  8016e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e5:	8a 00                	mov    (%eax),%al
  8016e7:	38 c2                	cmp    %al,%dl
  8016e9:	74 16                	je     801701 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f b6 d0             	movzbl %al,%edx
  8016f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f6:	8a 00                	mov    (%eax),%al
  8016f8:	0f b6 c0             	movzbl %al,%eax
  8016fb:	29 c2                	sub    %eax,%edx
  8016fd:	89 d0                	mov    %edx,%eax
  8016ff:	eb 18                	jmp    801719 <memcmp+0x50>
		s1++, s2++;
  801701:	ff 45 fc             	incl   -0x4(%ebp)
  801704:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801707:	8b 45 10             	mov    0x10(%ebp),%eax
  80170a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80170d:	89 55 10             	mov    %edx,0x10(%ebp)
  801710:	85 c0                	test   %eax,%eax
  801712:	75 c9                	jne    8016dd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801721:	8b 55 08             	mov    0x8(%ebp),%edx
  801724:	8b 45 10             	mov    0x10(%ebp),%eax
  801727:	01 d0                	add    %edx,%eax
  801729:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80172c:	eb 15                	jmp    801743 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
  801731:	8a 00                	mov    (%eax),%al
  801733:	0f b6 d0             	movzbl %al,%edx
  801736:	8b 45 0c             	mov    0xc(%ebp),%eax
  801739:	0f b6 c0             	movzbl %al,%eax
  80173c:	39 c2                	cmp    %eax,%edx
  80173e:	74 0d                	je     80174d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801740:	ff 45 08             	incl   0x8(%ebp)
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801749:	72 e3                	jb     80172e <memfind+0x13>
  80174b:	eb 01                	jmp    80174e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80174d:	90                   	nop
	return (void *) s;
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801759:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801760:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801767:	eb 03                	jmp    80176c <strtol+0x19>
		s++;
  801769:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	8a 00                	mov    (%eax),%al
  801771:	3c 20                	cmp    $0x20,%al
  801773:	74 f4                	je     801769 <strtol+0x16>
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8a 00                	mov    (%eax),%al
  80177a:	3c 09                	cmp    $0x9,%al
  80177c:	74 eb                	je     801769 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	8a 00                	mov    (%eax),%al
  801783:	3c 2b                	cmp    $0x2b,%al
  801785:	75 05                	jne    80178c <strtol+0x39>
		s++;
  801787:	ff 45 08             	incl   0x8(%ebp)
  80178a:	eb 13                	jmp    80179f <strtol+0x4c>
	else if (*s == '-')
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	3c 2d                	cmp    $0x2d,%al
  801793:	75 0a                	jne    80179f <strtol+0x4c>
		s++, neg = 1;
  801795:	ff 45 08             	incl   0x8(%ebp)
  801798:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80179f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017a3:	74 06                	je     8017ab <strtol+0x58>
  8017a5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017a9:	75 20                	jne    8017cb <strtol+0x78>
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	8a 00                	mov    (%eax),%al
  8017b0:	3c 30                	cmp    $0x30,%al
  8017b2:	75 17                	jne    8017cb <strtol+0x78>
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	40                   	inc    %eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	3c 78                	cmp    $0x78,%al
  8017bc:	75 0d                	jne    8017cb <strtol+0x78>
		s += 2, base = 16;
  8017be:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017c2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017c9:	eb 28                	jmp    8017f3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017cf:	75 15                	jne    8017e6 <strtol+0x93>
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	8a 00                	mov    (%eax),%al
  8017d6:	3c 30                	cmp    $0x30,%al
  8017d8:	75 0c                	jne    8017e6 <strtol+0x93>
		s++, base = 8;
  8017da:	ff 45 08             	incl   0x8(%ebp)
  8017dd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017e4:	eb 0d                	jmp    8017f3 <strtol+0xa0>
	else if (base == 0)
  8017e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ea:	75 07                	jne    8017f3 <strtol+0xa0>
		base = 10;
  8017ec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	8a 00                	mov    (%eax),%al
  8017f8:	3c 2f                	cmp    $0x2f,%al
  8017fa:	7e 19                	jle    801815 <strtol+0xc2>
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	8a 00                	mov    (%eax),%al
  801801:	3c 39                	cmp    $0x39,%al
  801803:	7f 10                	jg     801815 <strtol+0xc2>
			dig = *s - '0';
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	8a 00                	mov    (%eax),%al
  80180a:	0f be c0             	movsbl %al,%eax
  80180d:	83 e8 30             	sub    $0x30,%eax
  801810:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801813:	eb 42                	jmp    801857 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	3c 60                	cmp    $0x60,%al
  80181c:	7e 19                	jle    801837 <strtol+0xe4>
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	8a 00                	mov    (%eax),%al
  801823:	3c 7a                	cmp    $0x7a,%al
  801825:	7f 10                	jg     801837 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	8a 00                	mov    (%eax),%al
  80182c:	0f be c0             	movsbl %al,%eax
  80182f:	83 e8 57             	sub    $0x57,%eax
  801832:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801835:	eb 20                	jmp    801857 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8a 00                	mov    (%eax),%al
  80183c:	3c 40                	cmp    $0x40,%al
  80183e:	7e 39                	jle    801879 <strtol+0x126>
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	3c 5a                	cmp    $0x5a,%al
  801847:	7f 30                	jg     801879 <strtol+0x126>
			dig = *s - 'A' + 10;
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	8a 00                	mov    (%eax),%al
  80184e:	0f be c0             	movsbl %al,%eax
  801851:	83 e8 37             	sub    $0x37,%eax
  801854:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80185d:	7d 19                	jge    801878 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80185f:	ff 45 08             	incl   0x8(%ebp)
  801862:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801865:	0f af 45 10          	imul   0x10(%ebp),%eax
  801869:	89 c2                	mov    %eax,%edx
  80186b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186e:	01 d0                	add    %edx,%eax
  801870:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801873:	e9 7b ff ff ff       	jmp    8017f3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801878:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801879:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80187d:	74 08                	je     801887 <strtol+0x134>
		*endptr = (char *) s;
  80187f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801882:	8b 55 08             	mov    0x8(%ebp),%edx
  801885:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801887:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80188b:	74 07                	je     801894 <strtol+0x141>
  80188d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801890:	f7 d8                	neg    %eax
  801892:	eb 03                	jmp    801897 <strtol+0x144>
  801894:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <ltostr>:

void
ltostr(long value, char *str)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80189f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018b1:	79 13                	jns    8018c6 <ltostr+0x2d>
	{
		neg = 1;
  8018b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018c0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018c3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018ce:	99                   	cltd   
  8018cf:	f7 f9                	idiv   %ecx
  8018d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d7:	8d 50 01             	lea    0x1(%eax),%edx
  8018da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018dd:	89 c2                	mov    %eax,%edx
  8018df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e2:	01 d0                	add    %edx,%eax
  8018e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018e7:	83 c2 30             	add    $0x30,%edx
  8018ea:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ef:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018f4:	f7 e9                	imul   %ecx
  8018f6:	c1 fa 02             	sar    $0x2,%edx
  8018f9:	89 c8                	mov    %ecx,%eax
  8018fb:	c1 f8 1f             	sar    $0x1f,%eax
  8018fe:	29 c2                	sub    %eax,%edx
  801900:	89 d0                	mov    %edx,%eax
  801902:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801905:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801909:	75 bb                	jne    8018c6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80190b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801912:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801915:	48                   	dec    %eax
  801916:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801919:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80191d:	74 3d                	je     80195c <ltostr+0xc3>
		start = 1 ;
  80191f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801926:	eb 34                	jmp    80195c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801928:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80192b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192e:	01 d0                	add    %edx,%eax
  801930:	8a 00                	mov    (%eax),%al
  801932:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801935:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193b:	01 c2                	add    %eax,%edx
  80193d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	01 c8                	add    %ecx,%eax
  801945:	8a 00                	mov    (%eax),%al
  801947:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801949:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80194c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194f:	01 c2                	add    %eax,%edx
  801951:	8a 45 eb             	mov    -0x15(%ebp),%al
  801954:	88 02                	mov    %al,(%edx)
		start++ ;
  801956:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801959:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80195c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801962:	7c c4                	jl     801928 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801964:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196a:	01 d0                	add    %edx,%eax
  80196c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80196f:	90                   	nop
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801978:	ff 75 08             	pushl  0x8(%ebp)
  80197b:	e8 c4 f9 ff ff       	call   801344 <strlen>
  801980:	83 c4 04             	add    $0x4,%esp
  801983:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801986:	ff 75 0c             	pushl  0xc(%ebp)
  801989:	e8 b6 f9 ff ff       	call   801344 <strlen>
  80198e:	83 c4 04             	add    $0x4,%esp
  801991:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801994:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80199b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019a2:	eb 17                	jmp    8019bb <strcconcat+0x49>
		final[s] = str1[s] ;
  8019a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019aa:	01 c2                	add    %eax,%edx
  8019ac:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	01 c8                	add    %ecx,%eax
  8019b4:	8a 00                	mov    (%eax),%al
  8019b6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019b8:	ff 45 fc             	incl   -0x4(%ebp)
  8019bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019c1:	7c e1                	jl     8019a4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019d1:	eb 1f                	jmp    8019f2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d6:	8d 50 01             	lea    0x1(%eax),%edx
  8019d9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019dc:	89 c2                	mov    %eax,%edx
  8019de:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e1:	01 c2                	add    %eax,%edx
  8019e3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e9:	01 c8                	add    %ecx,%eax
  8019eb:	8a 00                	mov    (%eax),%al
  8019ed:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019ef:	ff 45 f8             	incl   -0x8(%ebp)
  8019f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019f5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019f8:	7c d9                	jl     8019d3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801a00:	01 d0                	add    %edx,%eax
  801a02:	c6 00 00             	movb   $0x0,(%eax)
}
  801a05:	90                   	nop
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a14:	8b 45 14             	mov    0x14(%ebp),%eax
  801a17:	8b 00                	mov    (%eax),%eax
  801a19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a20:	8b 45 10             	mov    0x10(%ebp),%eax
  801a23:	01 d0                	add    %edx,%eax
  801a25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a2b:	eb 0c                	jmp    801a39 <strsplit+0x31>
			*string++ = 0;
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	8d 50 01             	lea    0x1(%eax),%edx
  801a33:	89 55 08             	mov    %edx,0x8(%ebp)
  801a36:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	8a 00                	mov    (%eax),%al
  801a3e:	84 c0                	test   %al,%al
  801a40:	74 18                	je     801a5a <strsplit+0x52>
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	8a 00                	mov    (%eax),%al
  801a47:	0f be c0             	movsbl %al,%eax
  801a4a:	50                   	push   %eax
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	e8 83 fa ff ff       	call   8014d6 <strchr>
  801a53:	83 c4 08             	add    $0x8,%esp
  801a56:	85 c0                	test   %eax,%eax
  801a58:	75 d3                	jne    801a2d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	8a 00                	mov    (%eax),%al
  801a5f:	84 c0                	test   %al,%al
  801a61:	74 5a                	je     801abd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a63:	8b 45 14             	mov    0x14(%ebp),%eax
  801a66:	8b 00                	mov    (%eax),%eax
  801a68:	83 f8 0f             	cmp    $0xf,%eax
  801a6b:	75 07                	jne    801a74 <strsplit+0x6c>
		{
			return 0;
  801a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a72:	eb 66                	jmp    801ada <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a74:	8b 45 14             	mov    0x14(%ebp),%eax
  801a77:	8b 00                	mov    (%eax),%eax
  801a79:	8d 48 01             	lea    0x1(%eax),%ecx
  801a7c:	8b 55 14             	mov    0x14(%ebp),%edx
  801a7f:	89 0a                	mov    %ecx,(%edx)
  801a81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a88:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8b:	01 c2                	add    %eax,%edx
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a92:	eb 03                	jmp    801a97 <strsplit+0x8f>
			string++;
  801a94:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	8a 00                	mov    (%eax),%al
  801a9c:	84 c0                	test   %al,%al
  801a9e:	74 8b                	je     801a2b <strsplit+0x23>
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	8a 00                	mov    (%eax),%al
  801aa5:	0f be c0             	movsbl %al,%eax
  801aa8:	50                   	push   %eax
  801aa9:	ff 75 0c             	pushl  0xc(%ebp)
  801aac:	e8 25 fa ff ff       	call   8014d6 <strchr>
  801ab1:	83 c4 08             	add    $0x8,%esp
  801ab4:	85 c0                	test   %eax,%eax
  801ab6:	74 dc                	je     801a94 <strsplit+0x8c>
			string++;
	}
  801ab8:	e9 6e ff ff ff       	jmp    801a2b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801abd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801abe:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac1:	8b 00                	mov    (%eax),%eax
  801ac3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aca:	8b 45 10             	mov    0x10(%ebp),%eax
  801acd:	01 d0                	add    %edx,%eax
  801acf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ad5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801ae8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801aef:	eb 4a                	jmp    801b3b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801af1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	01 c2                	add    %eax,%edx
  801af9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aff:	01 c8                	add    %ecx,%eax
  801b01:	8a 00                	mov    (%eax),%al
  801b03:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801b05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0b:	01 d0                	add    %edx,%eax
  801b0d:	8a 00                	mov    (%eax),%al
  801b0f:	3c 40                	cmp    $0x40,%al
  801b11:	7e 25                	jle    801b38 <str2lower+0x5c>
  801b13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b19:	01 d0                	add    %edx,%eax
  801b1b:	8a 00                	mov    (%eax),%al
  801b1d:	3c 5a                	cmp    $0x5a,%al
  801b1f:	7f 17                	jg     801b38 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801b21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	01 d0                	add    %edx,%eax
  801b29:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  801b2f:	01 ca                	add    %ecx,%edx
  801b31:	8a 12                	mov    (%edx),%dl
  801b33:	83 c2 20             	add    $0x20,%edx
  801b36:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801b38:	ff 45 fc             	incl   -0x4(%ebp)
  801b3b:	ff 75 0c             	pushl  0xc(%ebp)
  801b3e:	e8 01 f8 ff ff       	call   801344 <strlen>
  801b43:	83 c4 04             	add    $0x4,%esp
  801b46:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b49:	7f a6                	jg     801af1 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801b56:	83 ec 0c             	sub    $0xc,%esp
  801b59:	6a 10                	push   $0x10
  801b5b:	e8 b2 15 00 00       	call   803112 <alloc_block>
  801b60:	83 c4 10             	add    $0x10,%esp
  801b63:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801b66:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b6a:	75 14                	jne    801b80 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801b6c:	83 ec 04             	sub    $0x4,%esp
  801b6f:	68 7c 45 80 00       	push   $0x80457c
  801b74:	6a 14                	push   $0x14
  801b76:	68 a5 45 80 00       	push   $0x8045a5
  801b7b:	e8 f5 eb ff ff       	call   800775 <_panic>

	node->start = start;
  801b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b83:	8b 55 08             	mov    0x8(%ebp),%edx
  801b86:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801b88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8e:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801b91:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801b98:	a1 28 50 80 00       	mov    0x805028,%eax
  801b9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ba0:	eb 18                	jmp    801bba <insert_page_alloc+0x6a>
		if (start < it->start)
  801ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba5:	8b 00                	mov    (%eax),%eax
  801ba7:	3b 45 08             	cmp    0x8(%ebp),%eax
  801baa:	77 37                	ja     801be3 <insert_page_alloc+0x93>
			break;
		prev = it;
  801bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801baf:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801bb2:	a1 30 50 80 00       	mov    0x805030,%eax
  801bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bbe:	74 08                	je     801bc8 <insert_page_alloc+0x78>
  801bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc3:	8b 40 08             	mov    0x8(%eax),%eax
  801bc6:	eb 05                	jmp    801bcd <insert_page_alloc+0x7d>
  801bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcd:	a3 30 50 80 00       	mov    %eax,0x805030
  801bd2:	a1 30 50 80 00       	mov    0x805030,%eax
  801bd7:	85 c0                	test   %eax,%eax
  801bd9:	75 c7                	jne    801ba2 <insert_page_alloc+0x52>
  801bdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bdf:	75 c1                	jne    801ba2 <insert_page_alloc+0x52>
  801be1:	eb 01                	jmp    801be4 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801be3:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801be4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801be8:	75 64                	jne    801c4e <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801bea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bee:	75 14                	jne    801c04 <insert_page_alloc+0xb4>
  801bf0:	83 ec 04             	sub    $0x4,%esp
  801bf3:	68 b4 45 80 00       	push   $0x8045b4
  801bf8:	6a 21                	push   $0x21
  801bfa:	68 a5 45 80 00       	push   $0x8045a5
  801bff:	e8 71 eb ff ff       	call   800775 <_panic>
  801c04:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801c0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c0d:	89 50 08             	mov    %edx,0x8(%eax)
  801c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c13:	8b 40 08             	mov    0x8(%eax),%eax
  801c16:	85 c0                	test   %eax,%eax
  801c18:	74 0d                	je     801c27 <insert_page_alloc+0xd7>
  801c1a:	a1 28 50 80 00       	mov    0x805028,%eax
  801c1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c22:	89 50 0c             	mov    %edx,0xc(%eax)
  801c25:	eb 08                	jmp    801c2f <insert_page_alloc+0xdf>
  801c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c2a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801c2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c32:	a3 28 50 80 00       	mov    %eax,0x805028
  801c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c3a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c41:	a1 34 50 80 00       	mov    0x805034,%eax
  801c46:	40                   	inc    %eax
  801c47:	a3 34 50 80 00       	mov    %eax,0x805034
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801c4c:	eb 71                	jmp    801cbf <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801c4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c52:	74 06                	je     801c5a <insert_page_alloc+0x10a>
  801c54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c58:	75 14                	jne    801c6e <insert_page_alloc+0x11e>
  801c5a:	83 ec 04             	sub    $0x4,%esp
  801c5d:	68 d8 45 80 00       	push   $0x8045d8
  801c62:	6a 23                	push   $0x23
  801c64:	68 a5 45 80 00       	push   $0x8045a5
  801c69:	e8 07 eb ff ff       	call   800775 <_panic>
  801c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c71:	8b 50 08             	mov    0x8(%eax),%edx
  801c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c77:	89 50 08             	mov    %edx,0x8(%eax)
  801c7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c7d:	8b 40 08             	mov    0x8(%eax),%eax
  801c80:	85 c0                	test   %eax,%eax
  801c82:	74 0c                	je     801c90 <insert_page_alloc+0x140>
  801c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c87:	8b 40 08             	mov    0x8(%eax),%eax
  801c8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c8d:	89 50 0c             	mov    %edx,0xc(%eax)
  801c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c93:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c96:	89 50 08             	mov    %edx,0x8(%eax)
  801c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c9f:	89 50 0c             	mov    %edx,0xc(%eax)
  801ca2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ca5:	8b 40 08             	mov    0x8(%eax),%eax
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	75 08                	jne    801cb4 <insert_page_alloc+0x164>
  801cac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801caf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801cb4:	a1 34 50 80 00       	mov    0x805034,%eax
  801cb9:	40                   	inc    %eax
  801cba:	a3 34 50 80 00       	mov    %eax,0x805034
}
  801cbf:	90                   	nop
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801cc8:	a1 28 50 80 00       	mov    0x805028,%eax
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	75 0c                	jne    801cdd <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801cd1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801cd6:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801cdb:	eb 67                	jmp    801d44 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801cdd:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ce2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801ce5:	a1 28 50 80 00       	mov    0x805028,%eax
  801cea:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801ced:	eb 26                	jmp    801d15 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801cef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cf2:	8b 10                	mov    (%eax),%edx
  801cf4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cf7:	8b 40 04             	mov    0x4(%eax),%eax
  801cfa:	01 d0                	add    %edx,%eax
  801cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d02:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801d05:	76 06                	jbe    801d0d <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801d0d:	a1 30 50 80 00       	mov    0x805030,%eax
  801d12:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801d15:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801d19:	74 08                	je     801d23 <recompute_page_alloc_break+0x61>
  801d1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d1e:	8b 40 08             	mov    0x8(%eax),%eax
  801d21:	eb 05                	jmp    801d28 <recompute_page_alloc_break+0x66>
  801d23:	b8 00 00 00 00       	mov    $0x0,%eax
  801d28:	a3 30 50 80 00       	mov    %eax,0x805030
  801d2d:	a1 30 50 80 00       	mov    0x805030,%eax
  801d32:	85 c0                	test   %eax,%eax
  801d34:	75 b9                	jne    801cef <recompute_page_alloc_break+0x2d>
  801d36:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801d3a:	75 b3                	jne    801cef <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801d3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d3f:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801d4c:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801d53:	8b 55 08             	mov    0x8(%ebp),%edx
  801d56:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d59:	01 d0                	add    %edx,%eax
  801d5b:	48                   	dec    %eax
  801d5c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801d5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d62:	ba 00 00 00 00       	mov    $0x0,%edx
  801d67:	f7 75 d8             	divl   -0x28(%ebp)
  801d6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d6d:	29 d0                	sub    %edx,%eax
  801d6f:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801d72:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801d76:	75 0a                	jne    801d82 <alloc_pages_custom_fit+0x3c>
		return NULL;
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7d:	e9 7e 01 00 00       	jmp    801f00 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801d82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801d89:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801d8d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801d94:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801d9b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801da0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801da3:	a1 28 50 80 00       	mov    0x805028,%eax
  801da8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801dab:	eb 69                	jmp    801e16 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801dad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801db0:	8b 00                	mov    (%eax),%eax
  801db2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801db5:	76 47                	jbe    801dfe <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dba:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801dbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dc0:	8b 00                	mov    (%eax),%eax
  801dc2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801dc5:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801dc8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801dcb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801dce:	72 2e                	jb     801dfe <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801dd0:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801dd4:	75 14                	jne    801dea <alloc_pages_custom_fit+0xa4>
  801dd6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801dd9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801ddc:	75 0c                	jne    801dea <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801dde:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801de4:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801de8:	eb 14                	jmp    801dfe <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801dea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ded:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801df0:	76 0c                	jbe    801dfe <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801df2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801df5:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801df8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801dfb:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e01:	8b 10                	mov    (%eax),%edx
  801e03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e06:	8b 40 04             	mov    0x4(%eax),%eax
  801e09:	01 d0                	add    %edx,%eax
  801e0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801e0e:	a1 30 50 80 00       	mov    0x805030,%eax
  801e13:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e16:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e1a:	74 08                	je     801e24 <alloc_pages_custom_fit+0xde>
  801e1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e1f:	8b 40 08             	mov    0x8(%eax),%eax
  801e22:	eb 05                	jmp    801e29 <alloc_pages_custom_fit+0xe3>
  801e24:	b8 00 00 00 00       	mov    $0x0,%eax
  801e29:	a3 30 50 80 00       	mov    %eax,0x805030
  801e2e:	a1 30 50 80 00       	mov    0x805030,%eax
  801e33:	85 c0                	test   %eax,%eax
  801e35:	0f 85 72 ff ff ff    	jne    801dad <alloc_pages_custom_fit+0x67>
  801e3b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e3f:	0f 85 68 ff ff ff    	jne    801dad <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801e45:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e4a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e4d:	76 47                	jbe    801e96 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801e4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e52:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801e55:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e5a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801e5d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801e60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e63:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e66:	72 2e                	jb     801e96 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801e68:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801e6c:	75 14                	jne    801e82 <alloc_pages_custom_fit+0x13c>
  801e6e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e71:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e74:	75 0c                	jne    801e82 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801e76:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e79:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801e7c:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801e80:	eb 14                	jmp    801e96 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801e82:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e85:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e88:	76 0c                	jbe    801e96 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801e8a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801e90:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e93:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801e96:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801e9d:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801ea1:	74 08                	je     801eab <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ea9:	eb 40                	jmp    801eeb <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801eab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801eaf:	74 08                	je     801eb9 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801eb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801eb7:	eb 32                	jmp    801eeb <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801eb9:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801ebe:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801ec1:	89 c2                	mov    %eax,%edx
  801ec3:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801ec8:	39 c2                	cmp    %eax,%edx
  801eca:	73 07                	jae    801ed3 <alloc_pages_custom_fit+0x18d>
			return NULL;
  801ecc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed1:	eb 2d                	jmp    801f00 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801ed3:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801ed8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801edb:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801ee1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ee4:	01 d0                	add    %edx,%eax
  801ee6:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801eeb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eee:	83 ec 08             	sub    $0x8,%esp
  801ef1:	ff 75 d0             	pushl  -0x30(%ebp)
  801ef4:	50                   	push   %eax
  801ef5:	e8 56 fc ff ff       	call   801b50 <insert_page_alloc>
  801efa:	83 c4 10             	add    $0x10,%esp

	return result;
  801efd:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f0e:	a1 28 50 80 00       	mov    0x805028,%eax
  801f13:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f16:	eb 1a                	jmp    801f32 <find_allocated_size+0x30>
		if (it->start == va)
  801f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f1b:	8b 00                	mov    (%eax),%eax
  801f1d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f20:	75 08                	jne    801f2a <find_allocated_size+0x28>
			return it->size;
  801f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f25:	8b 40 04             	mov    0x4(%eax),%eax
  801f28:	eb 34                	jmp    801f5e <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f2a:	a1 30 50 80 00       	mov    0x805030,%eax
  801f2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f32:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f36:	74 08                	je     801f40 <find_allocated_size+0x3e>
  801f38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f3b:	8b 40 08             	mov    0x8(%eax),%eax
  801f3e:	eb 05                	jmp    801f45 <find_allocated_size+0x43>
  801f40:	b8 00 00 00 00       	mov    $0x0,%eax
  801f45:	a3 30 50 80 00       	mov    %eax,0x805030
  801f4a:	a1 30 50 80 00       	mov    0x805030,%eax
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	75 c5                	jne    801f18 <find_allocated_size+0x16>
  801f53:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f57:	75 bf                	jne    801f18 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801f59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f6c:	a1 28 50 80 00       	mov    0x805028,%eax
  801f71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f74:	e9 e1 01 00 00       	jmp    80215a <free_pages+0x1fa>
		if (it->start == va) {
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	8b 00                	mov    (%eax),%eax
  801f7e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f81:	0f 85 cb 01 00 00    	jne    802152 <free_pages+0x1f2>

			uint32 start = it->start;
  801f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8a:	8b 00                	mov    (%eax),%eax
  801f8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	8b 40 04             	mov    0x4(%eax),%eax
  801f95:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801f98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f9b:	f7 d0                	not    %eax
  801f9d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801fa0:	73 1d                	jae    801fbf <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801fa2:	83 ec 0c             	sub    $0xc,%esp
  801fa5:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fa8:	ff 75 e8             	pushl  -0x18(%ebp)
  801fab:	68 0c 46 80 00       	push   $0x80460c
  801fb0:	68 a5 00 00 00       	push   $0xa5
  801fb5:	68 a5 45 80 00       	push   $0x8045a5
  801fba:	e8 b6 e7 ff ff       	call   800775 <_panic>
			}

			uint32 start_end = start + size;
  801fbf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fc5:	01 d0                	add    %edx,%eax
  801fc7:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801fca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	79 19                	jns    801fea <free_pages+0x8a>
  801fd1:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801fd8:	77 10                	ja     801fea <free_pages+0x8a>
  801fda:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801fe1:	77 07                	ja     801fea <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801fe3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	78 2c                	js     802016 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801fea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fed:	83 ec 0c             	sub    $0xc,%esp
  801ff0:	68 00 00 00 a0       	push   $0xa0000000
  801ff5:	ff 75 e0             	pushl  -0x20(%ebp)
  801ff8:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ffb:	ff 75 e8             	pushl  -0x18(%ebp)
  801ffe:	ff 75 e4             	pushl  -0x1c(%ebp)
  802001:	50                   	push   %eax
  802002:	68 50 46 80 00       	push   $0x804650
  802007:	68 ad 00 00 00       	push   $0xad
  80200c:	68 a5 45 80 00       	push   $0x8045a5
  802011:	e8 5f e7 ff ff       	call   800775 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802016:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802019:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80201c:	e9 88 00 00 00       	jmp    8020a9 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  802021:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  802028:	76 17                	jbe    802041 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  80202a:	ff 75 f0             	pushl  -0x10(%ebp)
  80202d:	68 b4 46 80 00       	push   $0x8046b4
  802032:	68 b4 00 00 00       	push   $0xb4
  802037:	68 a5 45 80 00       	push   $0x8045a5
  80203c:	e8 34 e7 ff ff       	call   800775 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  802041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802044:	05 00 10 00 00       	add    $0x1000,%eax
  802049:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  80204c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204f:	85 c0                	test   %eax,%eax
  802051:	79 2e                	jns    802081 <free_pages+0x121>
  802053:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80205a:	77 25                	ja     802081 <free_pages+0x121>
  80205c:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802063:	77 1c                	ja     802081 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  802065:	83 ec 08             	sub    $0x8,%esp
  802068:	68 00 10 00 00       	push   $0x1000
  80206d:	ff 75 f0             	pushl  -0x10(%ebp)
  802070:	e8 38 0d 00 00       	call   802dad <sys_free_user_mem>
  802075:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802078:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80207f:	eb 28                	jmp    8020a9 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  802081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802084:	68 00 00 00 a0       	push   $0xa0000000
  802089:	ff 75 dc             	pushl  -0x24(%ebp)
  80208c:	68 00 10 00 00       	push   $0x1000
  802091:	ff 75 f0             	pushl  -0x10(%ebp)
  802094:	50                   	push   %eax
  802095:	68 f4 46 80 00       	push   $0x8046f4
  80209a:	68 bd 00 00 00       	push   $0xbd
  80209f:	68 a5 45 80 00       	push   $0x8045a5
  8020a4:	e8 cc e6 ff ff       	call   800775 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8020a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ac:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8020af:	0f 82 6c ff ff ff    	jb     802021 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  8020b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b9:	75 17                	jne    8020d2 <free_pages+0x172>
  8020bb:	83 ec 04             	sub    $0x4,%esp
  8020be:	68 56 47 80 00       	push   $0x804756
  8020c3:	68 c1 00 00 00       	push   $0xc1
  8020c8:	68 a5 45 80 00       	push   $0x8045a5
  8020cd:	e8 a3 e6 ff ff       	call   800775 <_panic>
  8020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d5:	8b 40 08             	mov    0x8(%eax),%eax
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	74 11                	je     8020ed <free_pages+0x18d>
  8020dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020df:	8b 40 08             	mov    0x8(%eax),%eax
  8020e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e5:	8b 52 0c             	mov    0xc(%edx),%edx
  8020e8:	89 50 0c             	mov    %edx,0xc(%eax)
  8020eb:	eb 0b                	jmp    8020f8 <free_pages+0x198>
  8020ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8020fe:	85 c0                	test   %eax,%eax
  802100:	74 11                	je     802113 <free_pages+0x1b3>
  802102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802105:	8b 40 0c             	mov    0xc(%eax),%eax
  802108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210b:	8b 52 08             	mov    0x8(%edx),%edx
  80210e:	89 50 08             	mov    %edx,0x8(%eax)
  802111:	eb 0b                	jmp    80211e <free_pages+0x1be>
  802113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802116:	8b 40 08             	mov    0x8(%eax),%eax
  802119:	a3 28 50 80 00       	mov    %eax,0x805028
  80211e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802121:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802132:	a1 34 50 80 00       	mov    0x805034,%eax
  802137:	48                   	dec    %eax
  802138:	a3 34 50 80 00       	mov    %eax,0x805034
			free_block(it);
  80213d:	83 ec 0c             	sub    $0xc,%esp
  802140:	ff 75 f4             	pushl  -0xc(%ebp)
  802143:	e8 24 15 00 00       	call   80366c <free_block>
  802148:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  80214b:	e8 72 fb ff ff       	call   801cc2 <recompute_page_alloc_break>

			return;
  802150:	eb 37                	jmp    802189 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802152:	a1 30 50 80 00       	mov    0x805030,%eax
  802157:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80215a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80215e:	74 08                	je     802168 <free_pages+0x208>
  802160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802163:	8b 40 08             	mov    0x8(%eax),%eax
  802166:	eb 05                	jmp    80216d <free_pages+0x20d>
  802168:	b8 00 00 00 00       	mov    $0x0,%eax
  80216d:	a3 30 50 80 00       	mov    %eax,0x805030
  802172:	a1 30 50 80 00       	mov    0x805030,%eax
  802177:	85 c0                	test   %eax,%eax
  802179:	0f 85 fa fd ff ff    	jne    801f79 <free_pages+0x19>
  80217f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802183:	0f 85 f0 fd ff ff    	jne    801f79 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  80218e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802193:	5d                   	pop    %ebp
  802194:	c3                   	ret    

00802195 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
  802198:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80219b:	a1 08 50 80 00       	mov    0x805008,%eax
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	74 60                	je     802204 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8021a4:	83 ec 08             	sub    $0x8,%esp
  8021a7:	68 00 00 00 82       	push   $0x82000000
  8021ac:	68 00 00 00 80       	push   $0x80000000
  8021b1:	e8 0d 0d 00 00       	call   802ec3 <initialize_dynamic_allocator>
  8021b6:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8021b9:	e8 f3 0a 00 00       	call   802cb1 <sys_get_uheap_strategy>
  8021be:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8021c3:	a1 40 50 80 00       	mov    0x805040,%eax
  8021c8:	05 00 10 00 00       	add    $0x1000,%eax
  8021cd:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  8021d2:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021d7:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  8021dc:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  8021e3:	00 00 00 
  8021e6:	c7 05 2c 50 80 00 00 	movl   $0x0,0x80502c
  8021ed:	00 00 00 
  8021f0:	c7 05 34 50 80 00 00 	movl   $0x0,0x805034
  8021f7:	00 00 00 

		__firstTimeFlag = 0;
  8021fa:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  802201:	00 00 00 
	}
}
  802204:	90                   	nop
  802205:	c9                   	leave  
  802206:	c3                   	ret    

00802207 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
  80220a:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802216:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80221b:	83 ec 08             	sub    $0x8,%esp
  80221e:	68 06 04 00 00       	push   $0x406
  802223:	50                   	push   %eax
  802224:	e8 d2 06 00 00       	call   8028fb <__sys_allocate_page>
  802229:	83 c4 10             	add    $0x10,%esp
  80222c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80222f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802233:	79 17                	jns    80224c <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  802235:	83 ec 04             	sub    $0x4,%esp
  802238:	68 74 47 80 00       	push   $0x804774
  80223d:	68 ea 00 00 00       	push   $0xea
  802242:	68 a5 45 80 00       	push   $0x8045a5
  802247:	e8 29 e5 ff ff       	call   800775 <_panic>
	return 0;
  80224c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802262:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802267:	83 ec 0c             	sub    $0xc,%esp
  80226a:	50                   	push   %eax
  80226b:	e8 d2 06 00 00       	call   802942 <__sys_unmap_frame>
  802270:	83 c4 10             	add    $0x10,%esp
  802273:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802276:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80227a:	79 17                	jns    802293 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  80227c:	83 ec 04             	sub    $0x4,%esp
  80227f:	68 b0 47 80 00       	push   $0x8047b0
  802284:	68 f5 00 00 00       	push   $0xf5
  802289:	68 a5 45 80 00       	push   $0x8045a5
  80228e:	e8 e2 e4 ff ff       	call   800775 <_panic>
}
  802293:	90                   	nop
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80229c:	e8 f4 fe ff ff       	call   802195 <uheap_init>
	if (size == 0) return NULL ;
  8022a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a5:	75 0a                	jne    8022b1 <malloc+0x1b>
  8022a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ac:	e9 67 01 00 00       	jmp    802418 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  8022b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8022b8:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8022bf:	77 16                	ja     8022d7 <malloc+0x41>
		result = alloc_block(size);
  8022c1:	83 ec 0c             	sub    $0xc,%esp
  8022c4:	ff 75 08             	pushl  0x8(%ebp)
  8022c7:	e8 46 0e 00 00       	call   803112 <alloc_block>
  8022cc:	83 c4 10             	add    $0x10,%esp
  8022cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d2:	e9 3e 01 00 00       	jmp    802415 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  8022d7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8022de:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e4:	01 d0                	add    %edx,%eax
  8022e6:	48                   	dec    %eax
  8022e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8022ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8022f2:	f7 75 f0             	divl   -0x10(%ebp)
  8022f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f8:	29 d0                	sub    %edx,%eax
  8022fa:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  8022fd:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802302:	85 c0                	test   %eax,%eax
  802304:	75 0a                	jne    802310 <malloc+0x7a>
			return NULL;
  802306:	b8 00 00 00 00       	mov    $0x0,%eax
  80230b:	e9 08 01 00 00       	jmp    802418 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  802310:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802315:	85 c0                	test   %eax,%eax
  802317:	74 0f                	je     802328 <malloc+0x92>
  802319:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80231f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802324:	39 c2                	cmp    %eax,%edx
  802326:	73 0a                	jae    802332 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  802328:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80232d:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802332:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802337:	83 f8 05             	cmp    $0x5,%eax
  80233a:	75 11                	jne    80234d <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  80233c:	83 ec 0c             	sub    $0xc,%esp
  80233f:	ff 75 e8             	pushl  -0x18(%ebp)
  802342:	e8 ff f9 ff ff       	call   801d46 <alloc_pages_custom_fit>
  802347:	83 c4 10             	add    $0x10,%esp
  80234a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  80234d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802351:	0f 84 be 00 00 00    	je     802415 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  80235d:	83 ec 0c             	sub    $0xc,%esp
  802360:	ff 75 f4             	pushl  -0xc(%ebp)
  802363:	e8 9a fb ff ff       	call   801f02 <find_allocated_size>
  802368:	83 c4 10             	add    $0x10,%esp
  80236b:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  80236e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802372:	75 17                	jne    80238b <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802374:	ff 75 f4             	pushl  -0xc(%ebp)
  802377:	68 f0 47 80 00       	push   $0x8047f0
  80237c:	68 24 01 00 00       	push   $0x124
  802381:	68 a5 45 80 00       	push   $0x8045a5
  802386:	e8 ea e3 ff ff       	call   800775 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  80238b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80238e:	f7 d0                	not    %eax
  802390:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802393:	73 1d                	jae    8023b2 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  802395:	83 ec 0c             	sub    $0xc,%esp
  802398:	ff 75 e0             	pushl  -0x20(%ebp)
  80239b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80239e:	68 38 48 80 00       	push   $0x804838
  8023a3:	68 29 01 00 00       	push   $0x129
  8023a8:	68 a5 45 80 00       	push   $0x8045a5
  8023ad:	e8 c3 e3 ff ff       	call   800775 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  8023b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b8:	01 d0                	add    %edx,%eax
  8023ba:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  8023bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	79 2c                	jns    8023f0 <malloc+0x15a>
  8023c4:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  8023cb:	77 23                	ja     8023f0 <malloc+0x15a>
  8023cd:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8023d4:	77 1a                	ja     8023f0 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  8023d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	79 13                	jns    8023f0 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  8023dd:	83 ec 08             	sub    $0x8,%esp
  8023e0:	ff 75 e0             	pushl  -0x20(%ebp)
  8023e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023e6:	e8 de 09 00 00       	call   802dc9 <sys_allocate_user_mem>
  8023eb:	83 c4 10             	add    $0x10,%esp
  8023ee:	eb 25                	jmp    802415 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  8023f0:	68 00 00 00 a0       	push   $0xa0000000
  8023f5:	ff 75 dc             	pushl  -0x24(%ebp)
  8023f8:	ff 75 e0             	pushl  -0x20(%ebp)
  8023fb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023fe:	ff 75 f4             	pushl  -0xc(%ebp)
  802401:	68 74 48 80 00       	push   $0x804874
  802406:	68 33 01 00 00       	push   $0x133
  80240b:	68 a5 45 80 00       	push   $0x8045a5
  802410:	e8 60 e3 ff ff       	call   800775 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
  80241d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802420:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802424:	0f 84 26 01 00 00    	je     802550 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	85 c0                	test   %eax,%eax
  802435:	79 1c                	jns    802453 <free+0x39>
  802437:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  80243e:	77 13                	ja     802453 <free+0x39>
		free_block(virtual_address);
  802440:	83 ec 0c             	sub    $0xc,%esp
  802443:	ff 75 08             	pushl  0x8(%ebp)
  802446:	e8 21 12 00 00       	call   80366c <free_block>
  80244b:	83 c4 10             	add    $0x10,%esp
		return;
  80244e:	e9 01 01 00 00       	jmp    802554 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  802453:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802458:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80245b:	0f 82 d8 00 00 00    	jb     802539 <free+0x11f>
  802461:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  802468:	0f 87 cb 00 00 00    	ja     802539 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	25 ff 0f 00 00       	and    $0xfff,%eax
  802476:	85 c0                	test   %eax,%eax
  802478:	74 17                	je     802491 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  80247a:	ff 75 08             	pushl  0x8(%ebp)
  80247d:	68 e4 48 80 00       	push   $0x8048e4
  802482:	68 57 01 00 00       	push   $0x157
  802487:	68 a5 45 80 00       	push   $0x8045a5
  80248c:	e8 e4 e2 ff ff       	call   800775 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  802491:	83 ec 0c             	sub    $0xc,%esp
  802494:	ff 75 08             	pushl  0x8(%ebp)
  802497:	e8 66 fa ff ff       	call   801f02 <find_allocated_size>
  80249c:	83 c4 10             	add    $0x10,%esp
  80249f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  8024a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024a6:	0f 84 a7 00 00 00    	je     802553 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  8024ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024af:	f7 d0                	not    %eax
  8024b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024b4:	73 1d                	jae    8024d3 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  8024b6:	83 ec 0c             	sub    $0xc,%esp
  8024b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8024bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8024bf:	68 0c 49 80 00       	push   $0x80490c
  8024c4:	68 61 01 00 00       	push   $0x161
  8024c9:	68 a5 45 80 00       	push   $0x8045a5
  8024ce:	e8 a2 e2 ff ff       	call   800775 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  8024d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d9:	01 d0                	add    %edx,%eax
  8024db:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	85 c0                	test   %eax,%eax
  8024e3:	79 19                	jns    8024fe <free+0xe4>
  8024e5:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  8024ec:	77 10                	ja     8024fe <free+0xe4>
  8024ee:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  8024f5:	77 07                	ja     8024fe <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  8024f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fa:	85 c0                	test   %eax,%eax
  8024fc:	78 2b                	js     802529 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  8024fe:	83 ec 0c             	sub    $0xc,%esp
  802501:	68 00 00 00 a0       	push   $0xa0000000
  802506:	ff 75 ec             	pushl  -0x14(%ebp)
  802509:	ff 75 f0             	pushl  -0x10(%ebp)
  80250c:	ff 75 f4             	pushl  -0xc(%ebp)
  80250f:	ff 75 f0             	pushl  -0x10(%ebp)
  802512:	ff 75 08             	pushl  0x8(%ebp)
  802515:	68 48 49 80 00       	push   $0x804948
  80251a:	68 69 01 00 00       	push   $0x169
  80251f:	68 a5 45 80 00       	push   $0x8045a5
  802524:	e8 4c e2 ff ff       	call   800775 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  802529:	83 ec 0c             	sub    $0xc,%esp
  80252c:	ff 75 08             	pushl  0x8(%ebp)
  80252f:	e8 2c fa ff ff       	call   801f60 <free_pages>
  802534:	83 c4 10             	add    $0x10,%esp
		return;
  802537:	eb 1b                	jmp    802554 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  802539:	ff 75 08             	pushl  0x8(%ebp)
  80253c:	68 a4 49 80 00       	push   $0x8049a4
  802541:	68 70 01 00 00       	push   $0x170
  802546:	68 a5 45 80 00       	push   $0x8045a5
  80254b:	e8 25 e2 ff ff       	call   800775 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802550:	90                   	nop
  802551:	eb 01                	jmp    802554 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  802553:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
  802559:	83 ec 38             	sub    $0x38,%esp
  80255c:	8b 45 10             	mov    0x10(%ebp),%eax
  80255f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802562:	e8 2e fc ff ff       	call   802195 <uheap_init>
	if (size == 0) return NULL ;
  802567:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80256b:	75 0a                	jne    802577 <smalloc+0x21>
  80256d:	b8 00 00 00 00       	mov    $0x0,%eax
  802572:	e9 3d 01 00 00       	jmp    8026b4 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  802577:	8b 45 0c             	mov    0xc(%ebp),%eax
  80257a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  80257d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802580:	25 ff 0f 00 00       	and    $0xfff,%eax
  802585:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  802588:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80258c:	74 0e                	je     80259c <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802594:	05 00 10 00 00       	add    $0x1000,%eax
  802599:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	c1 e8 0c             	shr    $0xc,%eax
  8025a2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8025a5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025aa:	85 c0                	test   %eax,%eax
  8025ac:	75 0a                	jne    8025b8 <smalloc+0x62>
		return NULL;
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b3:	e9 fc 00 00 00       	jmp    8026b4 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8025b8:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	74 0f                	je     8025d0 <smalloc+0x7a>
  8025c1:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8025c7:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025cc:	39 c2                	cmp    %eax,%edx
  8025ce:	73 0a                	jae    8025da <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  8025d0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025d5:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8025da:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025df:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8025e4:	29 c2                	sub    %eax,%edx
  8025e6:	89 d0                	mov    %edx,%eax
  8025e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8025eb:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8025f1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025f6:	29 c2                	sub    %eax,%edx
  8025f8:	89 d0                	mov    %edx,%eax
  8025fa:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802603:	77 13                	ja     802618 <smalloc+0xc2>
  802605:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802608:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80260b:	77 0b                	ja     802618 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  80260d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802610:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802613:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802616:	73 0a                	jae    802622 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
  80261d:	e9 92 00 00 00       	jmp    8026b4 <smalloc+0x15e>
	}

	void *va = NULL;
  802622:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802629:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80262e:	83 f8 05             	cmp    $0x5,%eax
  802631:	75 11                	jne    802644 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  802633:	83 ec 0c             	sub    $0xc,%esp
  802636:	ff 75 f4             	pushl  -0xc(%ebp)
  802639:	e8 08 f7 ff ff       	call   801d46 <alloc_pages_custom_fit>
  80263e:	83 c4 10             	add    $0x10,%esp
  802641:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802644:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802648:	75 27                	jne    802671 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80264a:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  802651:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802654:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802657:	89 c2                	mov    %eax,%edx
  802659:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80265e:	39 c2                	cmp    %eax,%edx
  802660:	73 07                	jae    802669 <smalloc+0x113>
			return NULL;}
  802662:	b8 00 00 00 00       	mov    $0x0,%eax
  802667:	eb 4b                	jmp    8026b4 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  802669:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80266e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  802671:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802675:	ff 75 f0             	pushl  -0x10(%ebp)
  802678:	50                   	push   %eax
  802679:	ff 75 0c             	pushl  0xc(%ebp)
  80267c:	ff 75 08             	pushl  0x8(%ebp)
  80267f:	e8 cb 03 00 00       	call   802a4f <sys_create_shared_object>
  802684:	83 c4 10             	add    $0x10,%esp
  802687:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80268a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80268e:	79 07                	jns    802697 <smalloc+0x141>
		return NULL;
  802690:	b8 00 00 00 00       	mov    $0x0,%eax
  802695:	eb 1d                	jmp    8026b4 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802697:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80269c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80269f:	75 10                	jne    8026b1 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8026a1:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	01 d0                	add    %edx,%eax
  8026ac:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  8026b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8026b4:	c9                   	leave  
  8026b5:	c3                   	ret    

008026b6 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8026b6:	55                   	push   %ebp
  8026b7:	89 e5                	mov    %esp,%ebp
  8026b9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8026bc:	e8 d4 fa ff ff       	call   802195 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8026c1:	83 ec 08             	sub    $0x8,%esp
  8026c4:	ff 75 0c             	pushl  0xc(%ebp)
  8026c7:	ff 75 08             	pushl  0x8(%ebp)
  8026ca:	e8 aa 03 00 00       	call   802a79 <sys_size_of_shared_object>
  8026cf:	83 c4 10             	add    $0x10,%esp
  8026d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8026d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026d9:	7f 0a                	jg     8026e5 <sget+0x2f>
		return NULL;
  8026db:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e0:	e9 32 01 00 00       	jmp    802817 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8026e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8026eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ee:	25 ff 0f 00 00       	and    $0xfff,%eax
  8026f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8026f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026fa:	74 0e                	je     80270a <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802702:	05 00 10 00 00       	add    $0x1000,%eax
  802707:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  80270a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80270f:	85 c0                	test   %eax,%eax
  802711:	75 0a                	jne    80271d <sget+0x67>
		return NULL;
  802713:	b8 00 00 00 00       	mov    $0x0,%eax
  802718:	e9 fa 00 00 00       	jmp    802817 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80271d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802722:	85 c0                	test   %eax,%eax
  802724:	74 0f                	je     802735 <sget+0x7f>
  802726:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80272c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802731:	39 c2                	cmp    %eax,%edx
  802733:	73 0a                	jae    80273f <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  802735:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80273a:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80273f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802744:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802749:	29 c2                	sub    %eax,%edx
  80274b:	89 d0                	mov    %edx,%eax
  80274d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802750:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802756:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80275b:	29 c2                	sub    %eax,%edx
  80275d:	89 d0                	mov    %edx,%eax
  80275f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802768:	77 13                	ja     80277d <sget+0xc7>
  80276a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802770:	77 0b                	ja     80277d <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802772:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802775:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802778:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80277b:	73 0a                	jae    802787 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  80277d:	b8 00 00 00 00       	mov    $0x0,%eax
  802782:	e9 90 00 00 00       	jmp    802817 <sget+0x161>

	void *va = NULL;
  802787:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  80278e:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802793:	83 f8 05             	cmp    $0x5,%eax
  802796:	75 11                	jne    8027a9 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802798:	83 ec 0c             	sub    $0xc,%esp
  80279b:	ff 75 f4             	pushl  -0xc(%ebp)
  80279e:	e8 a3 f5 ff ff       	call   801d46 <alloc_pages_custom_fit>
  8027a3:	83 c4 10             	add    $0x10,%esp
  8027a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8027a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ad:	75 27                	jne    8027d6 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8027af:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8027b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027b9:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8027bc:	89 c2                	mov    %eax,%edx
  8027be:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8027c3:	39 c2                	cmp    %eax,%edx
  8027c5:	73 07                	jae    8027ce <sget+0x118>
			return NULL;
  8027c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cc:	eb 49                	jmp    802817 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8027ce:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8027d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8027d6:	83 ec 04             	sub    $0x4,%esp
  8027d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8027dc:	ff 75 0c             	pushl  0xc(%ebp)
  8027df:	ff 75 08             	pushl  0x8(%ebp)
  8027e2:	e8 af 02 00 00       	call   802a96 <sys_get_shared_object>
  8027e7:	83 c4 10             	add    $0x10,%esp
  8027ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8027ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8027f1:	79 07                	jns    8027fa <sget+0x144>
		return NULL;
  8027f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f8:	eb 1d                	jmp    802817 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8027fa:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8027ff:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802802:	75 10                	jne    802814 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802804:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	01 d0                	add    %edx,%eax
  80280f:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  802814:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  802817:	c9                   	leave  
  802818:	c3                   	ret    

00802819 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802819:	55                   	push   %ebp
  80281a:	89 e5                	mov    %esp,%ebp
  80281c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80281f:	e8 71 f9 ff ff       	call   802195 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802824:	83 ec 04             	sub    $0x4,%esp
  802827:	68 c8 49 80 00       	push   $0x8049c8
  80282c:	68 19 02 00 00       	push   $0x219
  802831:	68 a5 45 80 00       	push   $0x8045a5
  802836:	e8 3a df ff ff       	call   800775 <_panic>

0080283b <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80283b:	55                   	push   %ebp
  80283c:	89 e5                	mov    %esp,%ebp
  80283e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802841:	83 ec 04             	sub    $0x4,%esp
  802844:	68 f0 49 80 00       	push   $0x8049f0
  802849:	68 2b 02 00 00       	push   $0x22b
  80284e:	68 a5 45 80 00       	push   $0x8045a5
  802853:	e8 1d df ff ff       	call   800775 <_panic>

00802858 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802858:	55                   	push   %ebp
  802859:	89 e5                	mov    %esp,%ebp
  80285b:	57                   	push   %edi
  80285c:	56                   	push   %esi
  80285d:	53                   	push   %ebx
  80285e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	8b 55 0c             	mov    0xc(%ebp),%edx
  802867:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80286a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80286d:	8b 7d 18             	mov    0x18(%ebp),%edi
  802870:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802873:	cd 30                	int    $0x30
  802875:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802878:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80287b:	83 c4 10             	add    $0x10,%esp
  80287e:	5b                   	pop    %ebx
  80287f:	5e                   	pop    %esi
  802880:	5f                   	pop    %edi
  802881:	5d                   	pop    %ebp
  802882:	c3                   	ret    

00802883 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802883:	55                   	push   %ebp
  802884:	89 e5                	mov    %esp,%ebp
  802886:	83 ec 04             	sub    $0x4,%esp
  802889:	8b 45 10             	mov    0x10(%ebp),%eax
  80288c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80288f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802892:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802896:	8b 45 08             	mov    0x8(%ebp),%eax
  802899:	6a 00                	push   $0x0
  80289b:	51                   	push   %ecx
  80289c:	52                   	push   %edx
  80289d:	ff 75 0c             	pushl  0xc(%ebp)
  8028a0:	50                   	push   %eax
  8028a1:	6a 00                	push   $0x0
  8028a3:	e8 b0 ff ff ff       	call   802858 <syscall>
  8028a8:	83 c4 18             	add    $0x18,%esp
}
  8028ab:	90                   	nop
  8028ac:	c9                   	leave  
  8028ad:	c3                   	ret    

008028ae <sys_cgetc>:

int
sys_cgetc(void)
{
  8028ae:	55                   	push   %ebp
  8028af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8028b1:	6a 00                	push   $0x0
  8028b3:	6a 00                	push   $0x0
  8028b5:	6a 00                	push   $0x0
  8028b7:	6a 00                	push   $0x0
  8028b9:	6a 00                	push   $0x0
  8028bb:	6a 02                	push   $0x2
  8028bd:	e8 96 ff ff ff       	call   802858 <syscall>
  8028c2:	83 c4 18             	add    $0x18,%esp
}
  8028c5:	c9                   	leave  
  8028c6:	c3                   	ret    

008028c7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8028c7:	55                   	push   %ebp
  8028c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8028ca:	6a 00                	push   $0x0
  8028cc:	6a 00                	push   $0x0
  8028ce:	6a 00                	push   $0x0
  8028d0:	6a 00                	push   $0x0
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 03                	push   $0x3
  8028d6:	e8 7d ff ff ff       	call   802858 <syscall>
  8028db:	83 c4 18             	add    $0x18,%esp
}
  8028de:	90                   	nop
  8028df:	c9                   	leave  
  8028e0:	c3                   	ret    

008028e1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8028e1:	55                   	push   %ebp
  8028e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 00                	push   $0x0
  8028e8:	6a 00                	push   $0x0
  8028ea:	6a 00                	push   $0x0
  8028ec:	6a 00                	push   $0x0
  8028ee:	6a 04                	push   $0x4
  8028f0:	e8 63 ff ff ff       	call   802858 <syscall>
  8028f5:	83 c4 18             	add    $0x18,%esp
}
  8028f8:	90                   	nop
  8028f9:	c9                   	leave  
  8028fa:	c3                   	ret    

008028fb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8028fb:	55                   	push   %ebp
  8028fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8028fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802901:	8b 45 08             	mov    0x8(%ebp),%eax
  802904:	6a 00                	push   $0x0
  802906:	6a 00                	push   $0x0
  802908:	6a 00                	push   $0x0
  80290a:	52                   	push   %edx
  80290b:	50                   	push   %eax
  80290c:	6a 08                	push   $0x8
  80290e:	e8 45 ff ff ff       	call   802858 <syscall>
  802913:	83 c4 18             	add    $0x18,%esp
}
  802916:	c9                   	leave  
  802917:	c3                   	ret    

00802918 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802918:	55                   	push   %ebp
  802919:	89 e5                	mov    %esp,%ebp
  80291b:	56                   	push   %esi
  80291c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80291d:	8b 75 18             	mov    0x18(%ebp),%esi
  802920:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802923:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802926:	8b 55 0c             	mov    0xc(%ebp),%edx
  802929:	8b 45 08             	mov    0x8(%ebp),%eax
  80292c:	56                   	push   %esi
  80292d:	53                   	push   %ebx
  80292e:	51                   	push   %ecx
  80292f:	52                   	push   %edx
  802930:	50                   	push   %eax
  802931:	6a 09                	push   $0x9
  802933:	e8 20 ff ff ff       	call   802858 <syscall>
  802938:	83 c4 18             	add    $0x18,%esp
}
  80293b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80293e:	5b                   	pop    %ebx
  80293f:	5e                   	pop    %esi
  802940:	5d                   	pop    %ebp
  802941:	c3                   	ret    

00802942 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802942:	55                   	push   %ebp
  802943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802945:	6a 00                	push   $0x0
  802947:	6a 00                	push   $0x0
  802949:	6a 00                	push   $0x0
  80294b:	6a 00                	push   $0x0
  80294d:	ff 75 08             	pushl  0x8(%ebp)
  802950:	6a 0a                	push   $0xa
  802952:	e8 01 ff ff ff       	call   802858 <syscall>
  802957:	83 c4 18             	add    $0x18,%esp
}
  80295a:	c9                   	leave  
  80295b:	c3                   	ret    

0080295c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80295c:	55                   	push   %ebp
  80295d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	6a 00                	push   $0x0
  802965:	ff 75 0c             	pushl  0xc(%ebp)
  802968:	ff 75 08             	pushl  0x8(%ebp)
  80296b:	6a 0b                	push   $0xb
  80296d:	e8 e6 fe ff ff       	call   802858 <syscall>
  802972:	83 c4 18             	add    $0x18,%esp
}
  802975:	c9                   	leave  
  802976:	c3                   	ret    

00802977 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802977:	55                   	push   %ebp
  802978:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80297a:	6a 00                	push   $0x0
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	6a 00                	push   $0x0
  802982:	6a 00                	push   $0x0
  802984:	6a 0c                	push   $0xc
  802986:	e8 cd fe ff ff       	call   802858 <syscall>
  80298b:	83 c4 18             	add    $0x18,%esp
}
  80298e:	c9                   	leave  
  80298f:	c3                   	ret    

00802990 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802993:	6a 00                	push   $0x0
  802995:	6a 00                	push   $0x0
  802997:	6a 00                	push   $0x0
  802999:	6a 00                	push   $0x0
  80299b:	6a 00                	push   $0x0
  80299d:	6a 0d                	push   $0xd
  80299f:	e8 b4 fe ff ff       	call   802858 <syscall>
  8029a4:	83 c4 18             	add    $0x18,%esp
}
  8029a7:	c9                   	leave  
  8029a8:	c3                   	ret    

008029a9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8029a9:	55                   	push   %ebp
  8029aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8029ac:	6a 00                	push   $0x0
  8029ae:	6a 00                	push   $0x0
  8029b0:	6a 00                	push   $0x0
  8029b2:	6a 00                	push   $0x0
  8029b4:	6a 00                	push   $0x0
  8029b6:	6a 0e                	push   $0xe
  8029b8:	e8 9b fe ff ff       	call   802858 <syscall>
  8029bd:	83 c4 18             	add    $0x18,%esp
}
  8029c0:	c9                   	leave  
  8029c1:	c3                   	ret    

008029c2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8029c2:	55                   	push   %ebp
  8029c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8029c5:	6a 00                	push   $0x0
  8029c7:	6a 00                	push   $0x0
  8029c9:	6a 00                	push   $0x0
  8029cb:	6a 00                	push   $0x0
  8029cd:	6a 00                	push   $0x0
  8029cf:	6a 0f                	push   $0xf
  8029d1:	e8 82 fe ff ff       	call   802858 <syscall>
  8029d6:	83 c4 18             	add    $0x18,%esp
}
  8029d9:	c9                   	leave  
  8029da:	c3                   	ret    

008029db <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8029db:	55                   	push   %ebp
  8029dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8029de:	6a 00                	push   $0x0
  8029e0:	6a 00                	push   $0x0
  8029e2:	6a 00                	push   $0x0
  8029e4:	6a 00                	push   $0x0
  8029e6:	ff 75 08             	pushl  0x8(%ebp)
  8029e9:	6a 10                	push   $0x10
  8029eb:	e8 68 fe ff ff       	call   802858 <syscall>
  8029f0:	83 c4 18             	add    $0x18,%esp
}
  8029f3:	c9                   	leave  
  8029f4:	c3                   	ret    

008029f5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8029f5:	55                   	push   %ebp
  8029f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8029f8:	6a 00                	push   $0x0
  8029fa:	6a 00                	push   $0x0
  8029fc:	6a 00                	push   $0x0
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 00                	push   $0x0
  802a02:	6a 11                	push   $0x11
  802a04:	e8 4f fe ff ff       	call   802858 <syscall>
  802a09:	83 c4 18             	add    $0x18,%esp
}
  802a0c:	90                   	nop
  802a0d:	c9                   	leave  
  802a0e:	c3                   	ret    

00802a0f <sys_cputc>:

void
sys_cputc(const char c)
{
  802a0f:	55                   	push   %ebp
  802a10:	89 e5                	mov    %esp,%ebp
  802a12:	83 ec 04             	sub    $0x4,%esp
  802a15:	8b 45 08             	mov    0x8(%ebp),%eax
  802a18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802a1b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a1f:	6a 00                	push   $0x0
  802a21:	6a 00                	push   $0x0
  802a23:	6a 00                	push   $0x0
  802a25:	6a 00                	push   $0x0
  802a27:	50                   	push   %eax
  802a28:	6a 01                	push   $0x1
  802a2a:	e8 29 fe ff ff       	call   802858 <syscall>
  802a2f:	83 c4 18             	add    $0x18,%esp
}
  802a32:	90                   	nop
  802a33:	c9                   	leave  
  802a34:	c3                   	ret    

00802a35 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802a35:	55                   	push   %ebp
  802a36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802a38:	6a 00                	push   $0x0
  802a3a:	6a 00                	push   $0x0
  802a3c:	6a 00                	push   $0x0
  802a3e:	6a 00                	push   $0x0
  802a40:	6a 00                	push   $0x0
  802a42:	6a 14                	push   $0x14
  802a44:	e8 0f fe ff ff       	call   802858 <syscall>
  802a49:	83 c4 18             	add    $0x18,%esp
}
  802a4c:	90                   	nop
  802a4d:	c9                   	leave  
  802a4e:	c3                   	ret    

00802a4f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802a4f:	55                   	push   %ebp
  802a50:	89 e5                	mov    %esp,%ebp
  802a52:	83 ec 04             	sub    $0x4,%esp
  802a55:	8b 45 10             	mov    0x10(%ebp),%eax
  802a58:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802a5b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a5e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802a62:	8b 45 08             	mov    0x8(%ebp),%eax
  802a65:	6a 00                	push   $0x0
  802a67:	51                   	push   %ecx
  802a68:	52                   	push   %edx
  802a69:	ff 75 0c             	pushl  0xc(%ebp)
  802a6c:	50                   	push   %eax
  802a6d:	6a 15                	push   $0x15
  802a6f:	e8 e4 fd ff ff       	call   802858 <syscall>
  802a74:	83 c4 18             	add    $0x18,%esp
}
  802a77:	c9                   	leave  
  802a78:	c3                   	ret    

00802a79 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802a79:	55                   	push   %ebp
  802a7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	6a 00                	push   $0x0
  802a84:	6a 00                	push   $0x0
  802a86:	6a 00                	push   $0x0
  802a88:	52                   	push   %edx
  802a89:	50                   	push   %eax
  802a8a:	6a 16                	push   $0x16
  802a8c:	e8 c7 fd ff ff       	call   802858 <syscall>
  802a91:	83 c4 18             	add    $0x18,%esp
}
  802a94:	c9                   	leave  
  802a95:	c3                   	ret    

00802a96 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802a96:	55                   	push   %ebp
  802a97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802a99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa2:	6a 00                	push   $0x0
  802aa4:	6a 00                	push   $0x0
  802aa6:	51                   	push   %ecx
  802aa7:	52                   	push   %edx
  802aa8:	50                   	push   %eax
  802aa9:	6a 17                	push   $0x17
  802aab:	e8 a8 fd ff ff       	call   802858 <syscall>
  802ab0:	83 c4 18             	add    $0x18,%esp
}
  802ab3:	c9                   	leave  
  802ab4:	c3                   	ret    

00802ab5 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802ab5:	55                   	push   %ebp
  802ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	6a 00                	push   $0x0
  802ac0:	6a 00                	push   $0x0
  802ac2:	6a 00                	push   $0x0
  802ac4:	52                   	push   %edx
  802ac5:	50                   	push   %eax
  802ac6:	6a 18                	push   $0x18
  802ac8:	e8 8b fd ff ff       	call   802858 <syscall>
  802acd:	83 c4 18             	add    $0x18,%esp
}
  802ad0:	c9                   	leave  
  802ad1:	c3                   	ret    

00802ad2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802ad2:	55                   	push   %ebp
  802ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	6a 00                	push   $0x0
  802ada:	ff 75 14             	pushl  0x14(%ebp)
  802add:	ff 75 10             	pushl  0x10(%ebp)
  802ae0:	ff 75 0c             	pushl  0xc(%ebp)
  802ae3:	50                   	push   %eax
  802ae4:	6a 19                	push   $0x19
  802ae6:	e8 6d fd ff ff       	call   802858 <syscall>
  802aeb:	83 c4 18             	add    $0x18,%esp
}
  802aee:	c9                   	leave  
  802aef:	c3                   	ret    

00802af0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802af0:	55                   	push   %ebp
  802af1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	6a 00                	push   $0x0
  802af8:	6a 00                	push   $0x0
  802afa:	6a 00                	push   $0x0
  802afc:	6a 00                	push   $0x0
  802afe:	50                   	push   %eax
  802aff:	6a 1a                	push   $0x1a
  802b01:	e8 52 fd ff ff       	call   802858 <syscall>
  802b06:	83 c4 18             	add    $0x18,%esp
}
  802b09:	90                   	nop
  802b0a:	c9                   	leave  
  802b0b:	c3                   	ret    

00802b0c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802b0c:	55                   	push   %ebp
  802b0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b12:	6a 00                	push   $0x0
  802b14:	6a 00                	push   $0x0
  802b16:	6a 00                	push   $0x0
  802b18:	6a 00                	push   $0x0
  802b1a:	50                   	push   %eax
  802b1b:	6a 1b                	push   $0x1b
  802b1d:	e8 36 fd ff ff       	call   802858 <syscall>
  802b22:	83 c4 18             	add    $0x18,%esp
}
  802b25:	c9                   	leave  
  802b26:	c3                   	ret    

00802b27 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802b27:	55                   	push   %ebp
  802b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802b2a:	6a 00                	push   $0x0
  802b2c:	6a 00                	push   $0x0
  802b2e:	6a 00                	push   $0x0
  802b30:	6a 00                	push   $0x0
  802b32:	6a 00                	push   $0x0
  802b34:	6a 05                	push   $0x5
  802b36:	e8 1d fd ff ff       	call   802858 <syscall>
  802b3b:	83 c4 18             	add    $0x18,%esp
}
  802b3e:	c9                   	leave  
  802b3f:	c3                   	ret    

00802b40 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802b40:	55                   	push   %ebp
  802b41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802b43:	6a 00                	push   $0x0
  802b45:	6a 00                	push   $0x0
  802b47:	6a 00                	push   $0x0
  802b49:	6a 00                	push   $0x0
  802b4b:	6a 00                	push   $0x0
  802b4d:	6a 06                	push   $0x6
  802b4f:	e8 04 fd ff ff       	call   802858 <syscall>
  802b54:	83 c4 18             	add    $0x18,%esp
}
  802b57:	c9                   	leave  
  802b58:	c3                   	ret    

00802b59 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802b59:	55                   	push   %ebp
  802b5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802b5c:	6a 00                	push   $0x0
  802b5e:	6a 00                	push   $0x0
  802b60:	6a 00                	push   $0x0
  802b62:	6a 00                	push   $0x0
  802b64:	6a 00                	push   $0x0
  802b66:	6a 07                	push   $0x7
  802b68:	e8 eb fc ff ff       	call   802858 <syscall>
  802b6d:	83 c4 18             	add    $0x18,%esp
}
  802b70:	c9                   	leave  
  802b71:	c3                   	ret    

00802b72 <sys_exit_env>:


void sys_exit_env(void)
{
  802b72:	55                   	push   %ebp
  802b73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802b75:	6a 00                	push   $0x0
  802b77:	6a 00                	push   $0x0
  802b79:	6a 00                	push   $0x0
  802b7b:	6a 00                	push   $0x0
  802b7d:	6a 00                	push   $0x0
  802b7f:	6a 1c                	push   $0x1c
  802b81:	e8 d2 fc ff ff       	call   802858 <syscall>
  802b86:	83 c4 18             	add    $0x18,%esp
}
  802b89:	90                   	nop
  802b8a:	c9                   	leave  
  802b8b:	c3                   	ret    

00802b8c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802b8c:	55                   	push   %ebp
  802b8d:	89 e5                	mov    %esp,%ebp
  802b8f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802b92:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b95:	8d 50 04             	lea    0x4(%eax),%edx
  802b98:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b9b:	6a 00                	push   $0x0
  802b9d:	6a 00                	push   $0x0
  802b9f:	6a 00                	push   $0x0
  802ba1:	52                   	push   %edx
  802ba2:	50                   	push   %eax
  802ba3:	6a 1d                	push   $0x1d
  802ba5:	e8 ae fc ff ff       	call   802858 <syscall>
  802baa:	83 c4 18             	add    $0x18,%esp
	return result;
  802bad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802bb3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802bb6:	89 01                	mov    %eax,(%ecx)
  802bb8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	c9                   	leave  
  802bbf:	c2 04 00             	ret    $0x4

00802bc2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802bc2:	55                   	push   %ebp
  802bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 00                	push   $0x0
  802bc9:	ff 75 10             	pushl  0x10(%ebp)
  802bcc:	ff 75 0c             	pushl  0xc(%ebp)
  802bcf:	ff 75 08             	pushl  0x8(%ebp)
  802bd2:	6a 13                	push   $0x13
  802bd4:	e8 7f fc ff ff       	call   802858 <syscall>
  802bd9:	83 c4 18             	add    $0x18,%esp
	return ;
  802bdc:	90                   	nop
}
  802bdd:	c9                   	leave  
  802bde:	c3                   	ret    

00802bdf <sys_rcr2>:
uint32 sys_rcr2()
{
  802bdf:	55                   	push   %ebp
  802be0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802be2:	6a 00                	push   $0x0
  802be4:	6a 00                	push   $0x0
  802be6:	6a 00                	push   $0x0
  802be8:	6a 00                	push   $0x0
  802bea:	6a 00                	push   $0x0
  802bec:	6a 1e                	push   $0x1e
  802bee:	e8 65 fc ff ff       	call   802858 <syscall>
  802bf3:	83 c4 18             	add    $0x18,%esp
}
  802bf6:	c9                   	leave  
  802bf7:	c3                   	ret    

00802bf8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802bf8:	55                   	push   %ebp
  802bf9:	89 e5                	mov    %esp,%ebp
  802bfb:	83 ec 04             	sub    $0x4,%esp
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802c04:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802c08:	6a 00                	push   $0x0
  802c0a:	6a 00                	push   $0x0
  802c0c:	6a 00                	push   $0x0
  802c0e:	6a 00                	push   $0x0
  802c10:	50                   	push   %eax
  802c11:	6a 1f                	push   $0x1f
  802c13:	e8 40 fc ff ff       	call   802858 <syscall>
  802c18:	83 c4 18             	add    $0x18,%esp
	return ;
  802c1b:	90                   	nop
}
  802c1c:	c9                   	leave  
  802c1d:	c3                   	ret    

00802c1e <rsttst>:
void rsttst()
{
  802c1e:	55                   	push   %ebp
  802c1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802c21:	6a 00                	push   $0x0
  802c23:	6a 00                	push   $0x0
  802c25:	6a 00                	push   $0x0
  802c27:	6a 00                	push   $0x0
  802c29:	6a 00                	push   $0x0
  802c2b:	6a 21                	push   $0x21
  802c2d:	e8 26 fc ff ff       	call   802858 <syscall>
  802c32:	83 c4 18             	add    $0x18,%esp
	return ;
  802c35:	90                   	nop
}
  802c36:	c9                   	leave  
  802c37:	c3                   	ret    

00802c38 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802c38:	55                   	push   %ebp
  802c39:	89 e5                	mov    %esp,%ebp
  802c3b:	83 ec 04             	sub    $0x4,%esp
  802c3e:	8b 45 14             	mov    0x14(%ebp),%eax
  802c41:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802c44:	8b 55 18             	mov    0x18(%ebp),%edx
  802c47:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c4b:	52                   	push   %edx
  802c4c:	50                   	push   %eax
  802c4d:	ff 75 10             	pushl  0x10(%ebp)
  802c50:	ff 75 0c             	pushl  0xc(%ebp)
  802c53:	ff 75 08             	pushl  0x8(%ebp)
  802c56:	6a 20                	push   $0x20
  802c58:	e8 fb fb ff ff       	call   802858 <syscall>
  802c5d:	83 c4 18             	add    $0x18,%esp
	return ;
  802c60:	90                   	nop
}
  802c61:	c9                   	leave  
  802c62:	c3                   	ret    

00802c63 <chktst>:
void chktst(uint32 n)
{
  802c63:	55                   	push   %ebp
  802c64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802c66:	6a 00                	push   $0x0
  802c68:	6a 00                	push   $0x0
  802c6a:	6a 00                	push   $0x0
  802c6c:	6a 00                	push   $0x0
  802c6e:	ff 75 08             	pushl  0x8(%ebp)
  802c71:	6a 22                	push   $0x22
  802c73:	e8 e0 fb ff ff       	call   802858 <syscall>
  802c78:	83 c4 18             	add    $0x18,%esp
	return ;
  802c7b:	90                   	nop
}
  802c7c:	c9                   	leave  
  802c7d:	c3                   	ret    

00802c7e <inctst>:

void inctst()
{
  802c7e:	55                   	push   %ebp
  802c7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802c81:	6a 00                	push   $0x0
  802c83:	6a 00                	push   $0x0
  802c85:	6a 00                	push   $0x0
  802c87:	6a 00                	push   $0x0
  802c89:	6a 00                	push   $0x0
  802c8b:	6a 23                	push   $0x23
  802c8d:	e8 c6 fb ff ff       	call   802858 <syscall>
  802c92:	83 c4 18             	add    $0x18,%esp
	return ;
  802c95:	90                   	nop
}
  802c96:	c9                   	leave  
  802c97:	c3                   	ret    

00802c98 <gettst>:
uint32 gettst()
{
  802c98:	55                   	push   %ebp
  802c99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802c9b:	6a 00                	push   $0x0
  802c9d:	6a 00                	push   $0x0
  802c9f:	6a 00                	push   $0x0
  802ca1:	6a 00                	push   $0x0
  802ca3:	6a 00                	push   $0x0
  802ca5:	6a 24                	push   $0x24
  802ca7:	e8 ac fb ff ff       	call   802858 <syscall>
  802cac:	83 c4 18             	add    $0x18,%esp
}
  802caf:	c9                   	leave  
  802cb0:	c3                   	ret    

00802cb1 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802cb1:	55                   	push   %ebp
  802cb2:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802cb4:	6a 00                	push   $0x0
  802cb6:	6a 00                	push   $0x0
  802cb8:	6a 00                	push   $0x0
  802cba:	6a 00                	push   $0x0
  802cbc:	6a 00                	push   $0x0
  802cbe:	6a 25                	push   $0x25
  802cc0:	e8 93 fb ff ff       	call   802858 <syscall>
  802cc5:	83 c4 18             	add    $0x18,%esp
  802cc8:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802ccd:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802cd2:	c9                   	leave  
  802cd3:	c3                   	ret    

00802cd4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802cd4:	55                   	push   %ebp
  802cd5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802cdf:	6a 00                	push   $0x0
  802ce1:	6a 00                	push   $0x0
  802ce3:	6a 00                	push   $0x0
  802ce5:	6a 00                	push   $0x0
  802ce7:	ff 75 08             	pushl  0x8(%ebp)
  802cea:	6a 26                	push   $0x26
  802cec:	e8 67 fb ff ff       	call   802858 <syscall>
  802cf1:	83 c4 18             	add    $0x18,%esp
	return ;
  802cf4:	90                   	nop
}
  802cf5:	c9                   	leave  
  802cf6:	c3                   	ret    

00802cf7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802cf7:	55                   	push   %ebp
  802cf8:	89 e5                	mov    %esp,%ebp
  802cfa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802cfb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802cfe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d01:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	6a 00                	push   $0x0
  802d09:	53                   	push   %ebx
  802d0a:	51                   	push   %ecx
  802d0b:	52                   	push   %edx
  802d0c:	50                   	push   %eax
  802d0d:	6a 27                	push   $0x27
  802d0f:	e8 44 fb ff ff       	call   802858 <syscall>
  802d14:	83 c4 18             	add    $0x18,%esp
}
  802d17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d1a:	c9                   	leave  
  802d1b:	c3                   	ret    

00802d1c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802d1c:	55                   	push   %ebp
  802d1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802d1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d22:	8b 45 08             	mov    0x8(%ebp),%eax
  802d25:	6a 00                	push   $0x0
  802d27:	6a 00                	push   $0x0
  802d29:	6a 00                	push   $0x0
  802d2b:	52                   	push   %edx
  802d2c:	50                   	push   %eax
  802d2d:	6a 28                	push   $0x28
  802d2f:	e8 24 fb ff ff       	call   802858 <syscall>
  802d34:	83 c4 18             	add    $0x18,%esp
}
  802d37:	c9                   	leave  
  802d38:	c3                   	ret    

00802d39 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802d39:	55                   	push   %ebp
  802d3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802d3c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	6a 00                	push   $0x0
  802d47:	51                   	push   %ecx
  802d48:	ff 75 10             	pushl  0x10(%ebp)
  802d4b:	52                   	push   %edx
  802d4c:	50                   	push   %eax
  802d4d:	6a 29                	push   $0x29
  802d4f:	e8 04 fb ff ff       	call   802858 <syscall>
  802d54:	83 c4 18             	add    $0x18,%esp
}
  802d57:	c9                   	leave  
  802d58:	c3                   	ret    

00802d59 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802d59:	55                   	push   %ebp
  802d5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802d5c:	6a 00                	push   $0x0
  802d5e:	6a 00                	push   $0x0
  802d60:	ff 75 10             	pushl  0x10(%ebp)
  802d63:	ff 75 0c             	pushl  0xc(%ebp)
  802d66:	ff 75 08             	pushl  0x8(%ebp)
  802d69:	6a 12                	push   $0x12
  802d6b:	e8 e8 fa ff ff       	call   802858 <syscall>
  802d70:	83 c4 18             	add    $0x18,%esp
	return ;
  802d73:	90                   	nop
}
  802d74:	c9                   	leave  
  802d75:	c3                   	ret    

00802d76 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802d76:	55                   	push   %ebp
  802d77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	6a 00                	push   $0x0
  802d81:	6a 00                	push   $0x0
  802d83:	6a 00                	push   $0x0
  802d85:	52                   	push   %edx
  802d86:	50                   	push   %eax
  802d87:	6a 2a                	push   $0x2a
  802d89:	e8 ca fa ff ff       	call   802858 <syscall>
  802d8e:	83 c4 18             	add    $0x18,%esp
	return;
  802d91:	90                   	nop
}
  802d92:	c9                   	leave  
  802d93:	c3                   	ret    

00802d94 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802d94:	55                   	push   %ebp
  802d95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802d97:	6a 00                	push   $0x0
  802d99:	6a 00                	push   $0x0
  802d9b:	6a 00                	push   $0x0
  802d9d:	6a 00                	push   $0x0
  802d9f:	6a 00                	push   $0x0
  802da1:	6a 2b                	push   $0x2b
  802da3:	e8 b0 fa ff ff       	call   802858 <syscall>
  802da8:	83 c4 18             	add    $0x18,%esp
}
  802dab:	c9                   	leave  
  802dac:	c3                   	ret    

00802dad <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802dad:	55                   	push   %ebp
  802dae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802db0:	6a 00                	push   $0x0
  802db2:	6a 00                	push   $0x0
  802db4:	6a 00                	push   $0x0
  802db6:	ff 75 0c             	pushl  0xc(%ebp)
  802db9:	ff 75 08             	pushl  0x8(%ebp)
  802dbc:	6a 2d                	push   $0x2d
  802dbe:	e8 95 fa ff ff       	call   802858 <syscall>
  802dc3:	83 c4 18             	add    $0x18,%esp
	return;
  802dc6:	90                   	nop
}
  802dc7:	c9                   	leave  
  802dc8:	c3                   	ret    

00802dc9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802dc9:	55                   	push   %ebp
  802dca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802dcc:	6a 00                	push   $0x0
  802dce:	6a 00                	push   $0x0
  802dd0:	6a 00                	push   $0x0
  802dd2:	ff 75 0c             	pushl  0xc(%ebp)
  802dd5:	ff 75 08             	pushl  0x8(%ebp)
  802dd8:	6a 2c                	push   $0x2c
  802dda:	e8 79 fa ff ff       	call   802858 <syscall>
  802ddf:	83 c4 18             	add    $0x18,%esp
	return ;
  802de2:	90                   	nop
}
  802de3:	c9                   	leave  
  802de4:	c3                   	ret    

00802de5 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802de5:	55                   	push   %ebp
  802de6:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802de8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	6a 00                	push   $0x0
  802df0:	6a 00                	push   $0x0
  802df2:	6a 00                	push   $0x0
  802df4:	52                   	push   %edx
  802df5:	50                   	push   %eax
  802df6:	6a 2e                	push   $0x2e
  802df8:	e8 5b fa ff ff       	call   802858 <syscall>
  802dfd:	83 c4 18             	add    $0x18,%esp
	return ;
  802e00:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802e01:	c9                   	leave  
  802e02:	c3                   	ret    

00802e03 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802e03:	55                   	push   %ebp
  802e04:	89 e5                	mov    %esp,%ebp
  802e06:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802e09:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802e10:	72 09                	jb     802e1b <to_page_va+0x18>
  802e12:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802e19:	72 14                	jb     802e2f <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802e1b:	83 ec 04             	sub    $0x4,%esp
  802e1e:	68 14 4a 80 00       	push   $0x804a14
  802e23:	6a 15                	push   $0x15
  802e25:	68 3f 4a 80 00       	push   $0x804a3f
  802e2a:	e8 46 d9 ff ff       	call   800775 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	ba 60 50 80 00       	mov    $0x805060,%edx
  802e37:	29 d0                	sub    %edx,%eax
  802e39:	c1 f8 02             	sar    $0x2,%eax
  802e3c:	89 c2                	mov    %eax,%edx
  802e3e:	89 d0                	mov    %edx,%eax
  802e40:	c1 e0 02             	shl    $0x2,%eax
  802e43:	01 d0                	add    %edx,%eax
  802e45:	c1 e0 02             	shl    $0x2,%eax
  802e48:	01 d0                	add    %edx,%eax
  802e4a:	c1 e0 02             	shl    $0x2,%eax
  802e4d:	01 d0                	add    %edx,%eax
  802e4f:	89 c1                	mov    %eax,%ecx
  802e51:	c1 e1 08             	shl    $0x8,%ecx
  802e54:	01 c8                	add    %ecx,%eax
  802e56:	89 c1                	mov    %eax,%ecx
  802e58:	c1 e1 10             	shl    $0x10,%ecx
  802e5b:	01 c8                	add    %ecx,%eax
  802e5d:	01 c0                	add    %eax,%eax
  802e5f:	01 d0                	add    %edx,%eax
  802e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	c1 e0 0c             	shl    $0xc,%eax
  802e6a:	89 c2                	mov    %eax,%edx
  802e6c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802e71:	01 d0                	add    %edx,%eax
}
  802e73:	c9                   	leave  
  802e74:	c3                   	ret    

00802e75 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802e75:	55                   	push   %ebp
  802e76:	89 e5                	mov    %esp,%ebp
  802e78:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802e7b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802e80:	8b 55 08             	mov    0x8(%ebp),%edx
  802e83:	29 c2                	sub    %eax,%edx
  802e85:	89 d0                	mov    %edx,%eax
  802e87:	c1 e8 0c             	shr    $0xc,%eax
  802e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802e8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e91:	78 09                	js     802e9c <to_page_info+0x27>
  802e93:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802e9a:	7e 14                	jle    802eb0 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802e9c:	83 ec 04             	sub    $0x4,%esp
  802e9f:	68 58 4a 80 00       	push   $0x804a58
  802ea4:	6a 22                	push   $0x22
  802ea6:	68 3f 4a 80 00       	push   $0x804a3f
  802eab:	e8 c5 d8 ff ff       	call   800775 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802eb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb3:	89 d0                	mov    %edx,%eax
  802eb5:	01 c0                	add    %eax,%eax
  802eb7:	01 d0                	add    %edx,%eax
  802eb9:	c1 e0 02             	shl    $0x2,%eax
  802ebc:	05 60 50 80 00       	add    $0x805060,%eax
}
  802ec1:	c9                   	leave  
  802ec2:	c3                   	ret    

00802ec3 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802ec3:	55                   	push   %ebp
  802ec4:	89 e5                	mov    %esp,%ebp
  802ec6:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	05 00 00 00 02       	add    $0x2000000,%eax
  802ed1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ed4:	73 16                	jae    802eec <initialize_dynamic_allocator+0x29>
  802ed6:	68 7c 4a 80 00       	push   $0x804a7c
  802edb:	68 a2 4a 80 00       	push   $0x804aa2
  802ee0:	6a 34                	push   $0x34
  802ee2:	68 3f 4a 80 00       	push   $0x804a3f
  802ee7:	e8 89 d8 ff ff       	call   800775 <_panic>
		is_initialized = 1;
  802eec:	c7 05 38 50 80 00 01 	movl   $0x1,0x805038
  802ef3:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f01:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802f06:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802f0d:	00 00 00 
  802f10:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802f17:	00 00 00 
  802f1a:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802f21:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802f24:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802f2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f32:	eb 36                	jmp    802f6a <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	c1 e0 04             	shl    $0x4,%eax
  802f3a:	05 80 d0 81 00       	add    $0x81d080,%eax
  802f3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	c1 e0 04             	shl    $0x4,%eax
  802f4b:	05 84 d0 81 00       	add    $0x81d084,%eax
  802f50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	c1 e0 04             	shl    $0x4,%eax
  802f5c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802f67:	ff 45 f4             	incl   -0xc(%ebp)
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802f70:	72 c2                	jb     802f34 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802f72:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802f78:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802f7d:	29 c2                	sub    %eax,%edx
  802f7f:	89 d0                	mov    %edx,%eax
  802f81:	c1 e8 0c             	shr    $0xc,%eax
  802f84:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802f87:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802f8e:	e9 c8 00 00 00       	jmp    80305b <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802f93:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f96:	89 d0                	mov    %edx,%eax
  802f98:	01 c0                	add    %eax,%eax
  802f9a:	01 d0                	add    %edx,%eax
  802f9c:	c1 e0 02             	shl    $0x2,%eax
  802f9f:	05 68 50 80 00       	add    $0x805068,%eax
  802fa4:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802fa9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fac:	89 d0                	mov    %edx,%eax
  802fae:	01 c0                	add    %eax,%eax
  802fb0:	01 d0                	add    %edx,%eax
  802fb2:	c1 e0 02             	shl    $0x2,%eax
  802fb5:	05 6a 50 80 00       	add    $0x80506a,%eax
  802fba:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802fbf:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802fc5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802fc8:	89 c8                	mov    %ecx,%eax
  802fca:	01 c0                	add    %eax,%eax
  802fcc:	01 c8                	add    %ecx,%eax
  802fce:	c1 e0 02             	shl    $0x2,%eax
  802fd1:	05 64 50 80 00       	add    $0x805064,%eax
  802fd6:	89 10                	mov    %edx,(%eax)
  802fd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fdb:	89 d0                	mov    %edx,%eax
  802fdd:	01 c0                	add    %eax,%eax
  802fdf:	01 d0                	add    %edx,%eax
  802fe1:	c1 e0 02             	shl    $0x2,%eax
  802fe4:	05 64 50 80 00       	add    $0x805064,%eax
  802fe9:	8b 00                	mov    (%eax),%eax
  802feb:	85 c0                	test   %eax,%eax
  802fed:	74 1b                	je     80300a <initialize_dynamic_allocator+0x147>
  802fef:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802ff5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ff8:	89 c8                	mov    %ecx,%eax
  802ffa:	01 c0                	add    %eax,%eax
  802ffc:	01 c8                	add    %ecx,%eax
  802ffe:	c1 e0 02             	shl    $0x2,%eax
  803001:	05 60 50 80 00       	add    $0x805060,%eax
  803006:	89 02                	mov    %eax,(%edx)
  803008:	eb 16                	jmp    803020 <initialize_dynamic_allocator+0x15d>
  80300a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80300d:	89 d0                	mov    %edx,%eax
  80300f:	01 c0                	add    %eax,%eax
  803011:	01 d0                	add    %edx,%eax
  803013:	c1 e0 02             	shl    $0x2,%eax
  803016:	05 60 50 80 00       	add    $0x805060,%eax
  80301b:	a3 48 50 80 00       	mov    %eax,0x805048
  803020:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803023:	89 d0                	mov    %edx,%eax
  803025:	01 c0                	add    %eax,%eax
  803027:	01 d0                	add    %edx,%eax
  803029:	c1 e0 02             	shl    $0x2,%eax
  80302c:	05 60 50 80 00       	add    $0x805060,%eax
  803031:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803036:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803039:	89 d0                	mov    %edx,%eax
  80303b:	01 c0                	add    %eax,%eax
  80303d:	01 d0                	add    %edx,%eax
  80303f:	c1 e0 02             	shl    $0x2,%eax
  803042:	05 60 50 80 00       	add    $0x805060,%eax
  803047:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80304d:	a1 54 50 80 00       	mov    0x805054,%eax
  803052:	40                   	inc    %eax
  803053:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803058:	ff 45 f0             	incl   -0x10(%ebp)
  80305b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803061:	0f 82 2c ff ff ff    	jb     802f93 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803067:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80306d:	eb 2f                	jmp    80309e <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  80306f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803072:	89 d0                	mov    %edx,%eax
  803074:	01 c0                	add    %eax,%eax
  803076:	01 d0                	add    %edx,%eax
  803078:	c1 e0 02             	shl    $0x2,%eax
  80307b:	05 68 50 80 00       	add    $0x805068,%eax
  803080:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803085:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803088:	89 d0                	mov    %edx,%eax
  80308a:	01 c0                	add    %eax,%eax
  80308c:	01 d0                	add    %edx,%eax
  80308e:	c1 e0 02             	shl    $0x2,%eax
  803091:	05 6a 50 80 00       	add    $0x80506a,%eax
  803096:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  80309b:	ff 45 ec             	incl   -0x14(%ebp)
  80309e:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  8030a5:	76 c8                	jbe    80306f <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8030a7:	90                   	nop
  8030a8:	c9                   	leave  
  8030a9:	c3                   	ret    

008030aa <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8030aa:	55                   	push   %ebp
  8030ab:	89 e5                	mov    %esp,%ebp
  8030ad:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  8030b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b3:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8030b8:	29 c2                	sub    %eax,%edx
  8030ba:	89 d0                	mov    %edx,%eax
  8030bc:	c1 e8 0c             	shr    $0xc,%eax
  8030bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  8030c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030c5:	89 d0                	mov    %edx,%eax
  8030c7:	01 c0                	add    %eax,%eax
  8030c9:	01 d0                	add    %edx,%eax
  8030cb:	c1 e0 02             	shl    $0x2,%eax
  8030ce:	05 68 50 80 00       	add    $0x805068,%eax
  8030d3:	8b 00                	mov    (%eax),%eax
  8030d5:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8030d8:	c9                   	leave  
  8030d9:	c3                   	ret    

008030da <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8030da:	55                   	push   %ebp
  8030db:	89 e5                	mov    %esp,%ebp
  8030dd:	83 ec 14             	sub    $0x14,%esp
  8030e0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  8030e3:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8030e7:	77 07                	ja     8030f0 <nearest_pow2_ceil.1513+0x16>
  8030e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ee:	eb 20                	jmp    803110 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  8030f0:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  8030f7:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  8030fa:	eb 08                	jmp    803104 <nearest_pow2_ceil.1513+0x2a>
  8030fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030ff:	01 c0                	add    %eax,%eax
  803101:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803104:	d1 6d 08             	shrl   0x8(%ebp)
  803107:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310b:	75 ef                	jne    8030fc <nearest_pow2_ceil.1513+0x22>
        return power;
  80310d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803110:	c9                   	leave  
  803111:	c3                   	ret    

00803112 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803112:	55                   	push   %ebp
  803113:	89 e5                	mov    %esp,%ebp
  803115:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803118:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80311f:	76 16                	jbe    803137 <alloc_block+0x25>
  803121:	68 b8 4a 80 00       	push   $0x804ab8
  803126:	68 a2 4a 80 00       	push   $0x804aa2
  80312b:	6a 72                	push   $0x72
  80312d:	68 3f 4a 80 00       	push   $0x804a3f
  803132:	e8 3e d6 ff ff       	call   800775 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  803137:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313b:	75 0a                	jne    803147 <alloc_block+0x35>
  80313d:	b8 00 00 00 00       	mov    $0x0,%eax
  803142:	e9 bd 04 00 00       	jmp    803604 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803147:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  80314e:	8b 45 08             	mov    0x8(%ebp),%eax
  803151:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803154:	73 06                	jae    80315c <alloc_block+0x4a>
        size = min_block_size;
  803156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803159:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  80315c:	83 ec 0c             	sub    $0xc,%esp
  80315f:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803162:	ff 75 08             	pushl  0x8(%ebp)
  803165:	89 c1                	mov    %eax,%ecx
  803167:	e8 6e ff ff ff       	call   8030da <nearest_pow2_ceil.1513>
  80316c:	83 c4 10             	add    $0x10,%esp
  80316f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  803172:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803175:	83 ec 0c             	sub    $0xc,%esp
  803178:	8d 45 cc             	lea    -0x34(%ebp),%eax
  80317b:	52                   	push   %edx
  80317c:	89 c1                	mov    %eax,%ecx
  80317e:	e8 83 04 00 00       	call   803606 <log2_ceil.1520>
  803183:	83 c4 10             	add    $0x10,%esp
  803186:	83 e8 03             	sub    $0x3,%eax
  803189:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  80318c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80318f:	c1 e0 04             	shl    $0x4,%eax
  803192:	05 80 d0 81 00       	add    $0x81d080,%eax
  803197:	8b 00                	mov    (%eax),%eax
  803199:	85 c0                	test   %eax,%eax
  80319b:	0f 84 d8 00 00 00    	je     803279 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8031a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a4:	c1 e0 04             	shl    $0x4,%eax
  8031a7:	05 80 d0 81 00       	add    $0x81d080,%eax
  8031ac:	8b 00                	mov    (%eax),%eax
  8031ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  8031b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031b5:	75 17                	jne    8031ce <alloc_block+0xbc>
  8031b7:	83 ec 04             	sub    $0x4,%esp
  8031ba:	68 d9 4a 80 00       	push   $0x804ad9
  8031bf:	68 98 00 00 00       	push   $0x98
  8031c4:	68 3f 4a 80 00       	push   $0x804a3f
  8031c9:	e8 a7 d5 ff ff       	call   800775 <_panic>
  8031ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031d1:	8b 00                	mov    (%eax),%eax
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	74 10                	je     8031e7 <alloc_block+0xd5>
  8031d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031da:	8b 00                	mov    (%eax),%eax
  8031dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031df:	8b 52 04             	mov    0x4(%edx),%edx
  8031e2:	89 50 04             	mov    %edx,0x4(%eax)
  8031e5:	eb 14                	jmp    8031fb <alloc_block+0xe9>
  8031e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ea:	8b 40 04             	mov    0x4(%eax),%eax
  8031ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031f0:	c1 e2 04             	shl    $0x4,%edx
  8031f3:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8031f9:	89 02                	mov    %eax,(%edx)
  8031fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031fe:	8b 40 04             	mov    0x4(%eax),%eax
  803201:	85 c0                	test   %eax,%eax
  803203:	74 0f                	je     803214 <alloc_block+0x102>
  803205:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803208:	8b 40 04             	mov    0x4(%eax),%eax
  80320b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80320e:	8b 12                	mov    (%edx),%edx
  803210:	89 10                	mov    %edx,(%eax)
  803212:	eb 13                	jmp    803227 <alloc_block+0x115>
  803214:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803217:	8b 00                	mov    (%eax),%eax
  803219:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80321c:	c1 e2 04             	shl    $0x4,%edx
  80321f:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803225:	89 02                	mov    %eax,(%edx)
  803227:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80322a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803230:	8b 45 e0             	mov    -0x20(%ebp),%eax
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
        to_page_info((uint32) e)->num_of_free_blocks--;
  803257:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80325a:	83 ec 0c             	sub    $0xc,%esp
  80325d:	50                   	push   %eax
  80325e:	e8 12 fc ff ff       	call   802e75 <to_page_info>
  803263:	83 c4 10             	add    $0x10,%esp
  803266:	89 c2                	mov    %eax,%edx
  803268:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80326c:	48                   	dec    %eax
  80326d:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  803271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803274:	e9 8b 03 00 00       	jmp    803604 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  803279:	a1 48 50 80 00       	mov    0x805048,%eax
  80327e:	85 c0                	test   %eax,%eax
  803280:	0f 84 64 02 00 00    	je     8034ea <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803286:	a1 48 50 80 00       	mov    0x805048,%eax
  80328b:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  80328e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803292:	75 17                	jne    8032ab <alloc_block+0x199>
  803294:	83 ec 04             	sub    $0x4,%esp
  803297:	68 d9 4a 80 00       	push   $0x804ad9
  80329c:	68 a0 00 00 00       	push   $0xa0
  8032a1:	68 3f 4a 80 00       	push   $0x804a3f
  8032a6:	e8 ca d4 ff ff       	call   800775 <_panic>
  8032ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ae:	8b 00                	mov    (%eax),%eax
  8032b0:	85 c0                	test   %eax,%eax
  8032b2:	74 10                	je     8032c4 <alloc_block+0x1b2>
  8032b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032bc:	8b 52 04             	mov    0x4(%edx),%edx
  8032bf:	89 50 04             	mov    %edx,0x4(%eax)
  8032c2:	eb 0b                	jmp    8032cf <alloc_block+0x1bd>
  8032c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c7:	8b 40 04             	mov    0x4(%eax),%eax
  8032ca:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8032cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032d2:	8b 40 04             	mov    0x4(%eax),%eax
  8032d5:	85 c0                	test   %eax,%eax
  8032d7:	74 0f                	je     8032e8 <alloc_block+0x1d6>
  8032d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032dc:	8b 40 04             	mov    0x4(%eax),%eax
  8032df:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032e2:	8b 12                	mov    (%edx),%edx
  8032e4:	89 10                	mov    %edx,(%eax)
  8032e6:	eb 0a                	jmp    8032f2 <alloc_block+0x1e0>
  8032e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032eb:	8b 00                	mov    (%eax),%eax
  8032ed:	a3 48 50 80 00       	mov    %eax,0x805048
  8032f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803305:	a1 54 50 80 00       	mov    0x805054,%eax
  80330a:	48                   	dec    %eax
  80330b:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  803310:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803313:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803316:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  80331a:	b8 00 10 00 00       	mov    $0x1000,%eax
  80331f:	99                   	cltd   
  803320:	f7 7d e8             	idivl  -0x18(%ebp)
  803323:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803326:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  80332a:	83 ec 0c             	sub    $0xc,%esp
  80332d:	ff 75 dc             	pushl  -0x24(%ebp)
  803330:	e8 ce fa ff ff       	call   802e03 <to_page_va>
  803335:	83 c4 10             	add    $0x10,%esp
  803338:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  80333b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80333e:	83 ec 0c             	sub    $0xc,%esp
  803341:	50                   	push   %eax
  803342:	e8 c0 ee ff ff       	call   802207 <get_page>
  803347:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  80334a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803351:	e9 aa 00 00 00       	jmp    803400 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803359:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  80335d:	89 c2                	mov    %eax,%edx
  80335f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803362:	01 d0                	add    %edx,%eax
  803364:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  803367:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80336b:	75 17                	jne    803384 <alloc_block+0x272>
  80336d:	83 ec 04             	sub    $0x4,%esp
  803370:	68 f8 4a 80 00       	push   $0x804af8
  803375:	68 aa 00 00 00       	push   $0xaa
  80337a:	68 3f 4a 80 00       	push   $0x804a3f
  80337f:	e8 f1 d3 ff ff       	call   800775 <_panic>
  803384:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803387:	c1 e0 04             	shl    $0x4,%eax
  80338a:	05 84 d0 81 00       	add    $0x81d084,%eax
  80338f:	8b 10                	mov    (%eax),%edx
  803391:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803394:	89 50 04             	mov    %edx,0x4(%eax)
  803397:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80339a:	8b 40 04             	mov    0x4(%eax),%eax
  80339d:	85 c0                	test   %eax,%eax
  80339f:	74 14                	je     8033b5 <alloc_block+0x2a3>
  8033a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a4:	c1 e0 04             	shl    $0x4,%eax
  8033a7:	05 84 d0 81 00       	add    $0x81d084,%eax
  8033ac:	8b 00                	mov    (%eax),%eax
  8033ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033b1:	89 10                	mov    %edx,(%eax)
  8033b3:	eb 11                	jmp    8033c6 <alloc_block+0x2b4>
  8033b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b8:	c1 e0 04             	shl    $0x4,%eax
  8033bb:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  8033c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c4:	89 02                	mov    %eax,(%edx)
  8033c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c9:	c1 e0 04             	shl    $0x4,%eax
  8033cc:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  8033d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d5:	89 02                	mov    %eax,(%edx)
  8033d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e3:	c1 e0 04             	shl    $0x4,%eax
  8033e6:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033eb:	8b 00                	mov    (%eax),%eax
  8033ed:	8d 50 01             	lea    0x1(%eax),%edx
  8033f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f3:	c1 e0 04             	shl    $0x4,%eax
  8033f6:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033fb:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8033fd:	ff 45 f4             	incl   -0xc(%ebp)
  803400:	b8 00 10 00 00       	mov    $0x1000,%eax
  803405:	99                   	cltd   
  803406:	f7 7d e8             	idivl  -0x18(%ebp)
  803409:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80340c:	0f 8f 44 ff ff ff    	jg     803356 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803412:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803415:	c1 e0 04             	shl    $0x4,%eax
  803418:	05 80 d0 81 00       	add    $0x81d080,%eax
  80341d:	8b 00                	mov    (%eax),%eax
  80341f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803422:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803426:	75 17                	jne    80343f <alloc_block+0x32d>
  803428:	83 ec 04             	sub    $0x4,%esp
  80342b:	68 d9 4a 80 00       	push   $0x804ad9
  803430:	68 ae 00 00 00       	push   $0xae
  803435:	68 3f 4a 80 00       	push   $0x804a3f
  80343a:	e8 36 d3 ff ff       	call   800775 <_panic>
  80343f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803442:	8b 00                	mov    (%eax),%eax
  803444:	85 c0                	test   %eax,%eax
  803446:	74 10                	je     803458 <alloc_block+0x346>
  803448:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80344b:	8b 00                	mov    (%eax),%eax
  80344d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803450:	8b 52 04             	mov    0x4(%edx),%edx
  803453:	89 50 04             	mov    %edx,0x4(%eax)
  803456:	eb 14                	jmp    80346c <alloc_block+0x35a>
  803458:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80345b:	8b 40 04             	mov    0x4(%eax),%eax
  80345e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803461:	c1 e2 04             	shl    $0x4,%edx
  803464:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80346a:	89 02                	mov    %eax,(%edx)
  80346c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80346f:	8b 40 04             	mov    0x4(%eax),%eax
  803472:	85 c0                	test   %eax,%eax
  803474:	74 0f                	je     803485 <alloc_block+0x373>
  803476:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803479:	8b 40 04             	mov    0x4(%eax),%eax
  80347c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80347f:	8b 12                	mov    (%edx),%edx
  803481:	89 10                	mov    %edx,(%eax)
  803483:	eb 13                	jmp    803498 <alloc_block+0x386>
  803485:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803488:	8b 00                	mov    (%eax),%eax
  80348a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80348d:	c1 e2 04             	shl    $0x4,%edx
  803490:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803496:	89 02                	mov    %eax,(%edx)
  803498:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80349b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ae:	c1 e0 04             	shl    $0x4,%eax
  8034b1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8034b6:	8b 00                	mov    (%eax),%eax
  8034b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8034bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034be:	c1 e0 04             	shl    $0x4,%eax
  8034c1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8034c6:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  8034c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034cb:	83 ec 0c             	sub    $0xc,%esp
  8034ce:	50                   	push   %eax
  8034cf:	e8 a1 f9 ff ff       	call   802e75 <to_page_info>
  8034d4:	83 c4 10             	add    $0x10,%esp
  8034d7:	89 c2                	mov    %eax,%edx
  8034d9:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8034dd:	48                   	dec    %eax
  8034de:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  8034e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034e5:	e9 1a 01 00 00       	jmp    803604 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8034ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ed:	40                   	inc    %eax
  8034ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8034f1:	e9 ed 00 00 00       	jmp    8035e3 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  8034f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f9:	c1 e0 04             	shl    $0x4,%eax
  8034fc:	05 80 d0 81 00       	add    $0x81d080,%eax
  803501:	8b 00                	mov    (%eax),%eax
  803503:	85 c0                	test   %eax,%eax
  803505:	0f 84 d5 00 00 00    	je     8035e0 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  80350b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350e:	c1 e0 04             	shl    $0x4,%eax
  803511:	05 80 d0 81 00       	add    $0x81d080,%eax
  803516:	8b 00                	mov    (%eax),%eax
  803518:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  80351b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80351f:	75 17                	jne    803538 <alloc_block+0x426>
  803521:	83 ec 04             	sub    $0x4,%esp
  803524:	68 d9 4a 80 00       	push   $0x804ad9
  803529:	68 b8 00 00 00       	push   $0xb8
  80352e:	68 3f 4a 80 00       	push   $0x804a3f
  803533:	e8 3d d2 ff ff       	call   800775 <_panic>
  803538:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80353b:	8b 00                	mov    (%eax),%eax
  80353d:	85 c0                	test   %eax,%eax
  80353f:	74 10                	je     803551 <alloc_block+0x43f>
  803541:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803544:	8b 00                	mov    (%eax),%eax
  803546:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803549:	8b 52 04             	mov    0x4(%edx),%edx
  80354c:	89 50 04             	mov    %edx,0x4(%eax)
  80354f:	eb 14                	jmp    803565 <alloc_block+0x453>
  803551:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803554:	8b 40 04             	mov    0x4(%eax),%eax
  803557:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80355a:	c1 e2 04             	shl    $0x4,%edx
  80355d:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803563:	89 02                	mov    %eax,(%edx)
  803565:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803568:	8b 40 04             	mov    0x4(%eax),%eax
  80356b:	85 c0                	test   %eax,%eax
  80356d:	74 0f                	je     80357e <alloc_block+0x46c>
  80356f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803572:	8b 40 04             	mov    0x4(%eax),%eax
  803575:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803578:	8b 12                	mov    (%edx),%edx
  80357a:	89 10                	mov    %edx,(%eax)
  80357c:	eb 13                	jmp    803591 <alloc_block+0x47f>
  80357e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803581:	8b 00                	mov    (%eax),%eax
  803583:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803586:	c1 e2 04             	shl    $0x4,%edx
  803589:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80358f:	89 02                	mov    %eax,(%edx)
  803591:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803594:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80359a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80359d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a7:	c1 e0 04             	shl    $0x4,%eax
  8035aa:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8035af:	8b 00                	mov    (%eax),%eax
  8035b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8035b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b7:	c1 e0 04             	shl    $0x4,%eax
  8035ba:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8035bf:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8035c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035c4:	83 ec 0c             	sub    $0xc,%esp
  8035c7:	50                   	push   %eax
  8035c8:	e8 a8 f8 ff ff       	call   802e75 <to_page_info>
  8035cd:	83 c4 10             	add    $0x10,%esp
  8035d0:	89 c2                	mov    %eax,%edx
  8035d2:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8035d6:	48                   	dec    %eax
  8035d7:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  8035db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035de:	eb 24                	jmp    803604 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8035e0:	ff 45 f0             	incl   -0x10(%ebp)
  8035e3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8035e7:	0f 8e 09 ff ff ff    	jle    8034f6 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8035ed:	83 ec 04             	sub    $0x4,%esp
  8035f0:	68 1b 4b 80 00       	push   $0x804b1b
  8035f5:	68 bf 00 00 00       	push   $0xbf
  8035fa:	68 3f 4a 80 00       	push   $0x804a3f
  8035ff:	e8 71 d1 ff ff       	call   800775 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803604:	c9                   	leave  
  803605:	c3                   	ret    

00803606 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  803606:	55                   	push   %ebp
  803607:	89 e5                	mov    %esp,%ebp
  803609:	83 ec 14             	sub    $0x14,%esp
  80360c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  80360f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803613:	75 07                	jne    80361c <log2_ceil.1520+0x16>
  803615:	b8 00 00 00 00       	mov    $0x0,%eax
  80361a:	eb 1b                	jmp    803637 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  80361c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  803623:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  803626:	eb 06                	jmp    80362e <log2_ceil.1520+0x28>
            x >>= 1;
  803628:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  80362b:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  80362e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803632:	75 f4                	jne    803628 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  803634:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803637:	c9                   	leave  
  803638:	c3                   	ret    

00803639 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  803639:	55                   	push   %ebp
  80363a:	89 e5                	mov    %esp,%ebp
  80363c:	83 ec 14             	sub    $0x14,%esp
  80363f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803642:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803646:	75 07                	jne    80364f <log2_ceil.1547+0x16>
  803648:	b8 00 00 00 00       	mov    $0x0,%eax
  80364d:	eb 1b                	jmp    80366a <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  80364f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803656:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  803659:	eb 06                	jmp    803661 <log2_ceil.1547+0x28>
			x >>= 1;
  80365b:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  80365e:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  803661:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803665:	75 f4                	jne    80365b <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  803667:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80366a:	c9                   	leave  
  80366b:	c3                   	ret    

0080366c <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80366c:	55                   	push   %ebp
  80366d:	89 e5                	mov    %esp,%ebp
  80366f:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803672:	8b 55 08             	mov    0x8(%ebp),%edx
  803675:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80367a:	39 c2                	cmp    %eax,%edx
  80367c:	72 0c                	jb     80368a <free_block+0x1e>
  80367e:	8b 55 08             	mov    0x8(%ebp),%edx
  803681:	a1 40 50 80 00       	mov    0x805040,%eax
  803686:	39 c2                	cmp    %eax,%edx
  803688:	72 19                	jb     8036a3 <free_block+0x37>
  80368a:	68 20 4b 80 00       	push   $0x804b20
  80368f:	68 a2 4a 80 00       	push   $0x804aa2
  803694:	68 d0 00 00 00       	push   $0xd0
  803699:	68 3f 4a 80 00       	push   $0x804a3f
  80369e:	e8 d2 d0 ff ff       	call   800775 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8036a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036a7:	0f 84 42 03 00 00    	je     8039ef <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8036ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8036b0:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8036b5:	39 c2                	cmp    %eax,%edx
  8036b7:	72 0c                	jb     8036c5 <free_block+0x59>
  8036b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8036bc:	a1 40 50 80 00       	mov    0x805040,%eax
  8036c1:	39 c2                	cmp    %eax,%edx
  8036c3:	72 17                	jb     8036dc <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8036c5:	83 ec 04             	sub    $0x4,%esp
  8036c8:	68 58 4b 80 00       	push   $0x804b58
  8036cd:	68 e6 00 00 00       	push   $0xe6
  8036d2:	68 3f 4a 80 00       	push   $0x804a3f
  8036d7:	e8 99 d0 ff ff       	call   800775 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8036dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8036df:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8036e4:	29 c2                	sub    %eax,%edx
  8036e6:	89 d0                	mov    %edx,%eax
  8036e8:	83 e0 07             	and    $0x7,%eax
  8036eb:	85 c0                	test   %eax,%eax
  8036ed:	74 17                	je     803706 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8036ef:	83 ec 04             	sub    $0x4,%esp
  8036f2:	68 8c 4b 80 00       	push   $0x804b8c
  8036f7:	68 ea 00 00 00       	push   $0xea
  8036fc:	68 3f 4a 80 00       	push   $0x804a3f
  803701:	e8 6f d0 ff ff       	call   800775 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  803706:	8b 45 08             	mov    0x8(%ebp),%eax
  803709:	83 ec 0c             	sub    $0xc,%esp
  80370c:	50                   	push   %eax
  80370d:	e8 63 f7 ff ff       	call   802e75 <to_page_info>
  803712:	83 c4 10             	add    $0x10,%esp
  803715:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  803718:	83 ec 0c             	sub    $0xc,%esp
  80371b:	ff 75 08             	pushl  0x8(%ebp)
  80371e:	e8 87 f9 ff ff       	call   8030aa <get_block_size>
  803723:	83 c4 10             	add    $0x10,%esp
  803726:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  803729:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80372d:	75 17                	jne    803746 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  80372f:	83 ec 04             	sub    $0x4,%esp
  803732:	68 b8 4b 80 00       	push   $0x804bb8
  803737:	68 f1 00 00 00       	push   $0xf1
  80373c:	68 3f 4a 80 00       	push   $0x804a3f
  803741:	e8 2f d0 ff ff       	call   800775 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  803746:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803749:	83 ec 0c             	sub    $0xc,%esp
  80374c:	8d 45 d0             	lea    -0x30(%ebp),%eax
  80374f:	52                   	push   %edx
  803750:	89 c1                	mov    %eax,%ecx
  803752:	e8 e2 fe ff ff       	call   803639 <log2_ceil.1547>
  803757:	83 c4 10             	add    $0x10,%esp
  80375a:	83 e8 03             	sub    $0x3,%eax
  80375d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803760:	8b 45 08             	mov    0x8(%ebp),%eax
  803763:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  803766:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80376a:	75 17                	jne    803783 <free_block+0x117>
  80376c:	83 ec 04             	sub    $0x4,%esp
  80376f:	68 04 4c 80 00       	push   $0x804c04
  803774:	68 f6 00 00 00       	push   $0xf6
  803779:	68 3f 4a 80 00       	push   $0x804a3f
  80377e:	e8 f2 cf ff ff       	call   800775 <_panic>
  803783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803786:	c1 e0 04             	shl    $0x4,%eax
  803789:	05 80 d0 81 00       	add    $0x81d080,%eax
  80378e:	8b 10                	mov    (%eax),%edx
  803790:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803793:	89 10                	mov    %edx,(%eax)
  803795:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803798:	8b 00                	mov    (%eax),%eax
  80379a:	85 c0                	test   %eax,%eax
  80379c:	74 15                	je     8037b3 <free_block+0x147>
  80379e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a1:	c1 e0 04             	shl    $0x4,%eax
  8037a4:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037a9:	8b 00                	mov    (%eax),%eax
  8037ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037ae:	89 50 04             	mov    %edx,0x4(%eax)
  8037b1:	eb 11                	jmp    8037c4 <free_block+0x158>
  8037b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b6:	c1 e0 04             	shl    $0x4,%eax
  8037b9:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  8037bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037c2:	89 02                	mov    %eax,(%edx)
  8037c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c7:	c1 e0 04             	shl    $0x4,%eax
  8037ca:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  8037d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d3:	89 02                	mov    %eax,(%edx)
  8037d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e2:	c1 e0 04             	shl    $0x4,%eax
  8037e5:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8037ea:	8b 00                	mov    (%eax),%eax
  8037ec:	8d 50 01             	lea    0x1(%eax),%edx
  8037ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f2:	c1 e0 04             	shl    $0x4,%eax
  8037f5:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8037fa:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8037fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ff:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803803:	40                   	inc    %eax
  803804:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803807:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  80380b:	8b 55 08             	mov    0x8(%ebp),%edx
  80380e:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803813:	29 c2                	sub    %eax,%edx
  803815:	89 d0                	mov    %edx,%eax
  803817:	c1 e8 0c             	shr    $0xc,%eax
  80381a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  80381d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803820:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803824:	0f b7 c8             	movzwl %ax,%ecx
  803827:	b8 00 10 00 00       	mov    $0x1000,%eax
  80382c:	99                   	cltd   
  80382d:	f7 7d e8             	idivl  -0x18(%ebp)
  803830:	39 c1                	cmp    %eax,%ecx
  803832:	0f 85 b8 01 00 00    	jne    8039f0 <free_block+0x384>
    	uint32 blocks_removed = 0;
  803838:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  80383f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803842:	c1 e0 04             	shl    $0x4,%eax
  803845:	05 80 d0 81 00       	add    $0x81d080,%eax
  80384a:	8b 00                	mov    (%eax),%eax
  80384c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80384f:	e9 d5 00 00 00       	jmp    803929 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803857:	8b 00                	mov    (%eax),%eax
  803859:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  80385c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80385f:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803864:	29 c2                	sub    %eax,%edx
  803866:	89 d0                	mov    %edx,%eax
  803868:	c1 e8 0c             	shr    $0xc,%eax
  80386b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  80386e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803871:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803874:	0f 85 a9 00 00 00    	jne    803923 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  80387a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80387e:	75 17                	jne    803897 <free_block+0x22b>
  803880:	83 ec 04             	sub    $0x4,%esp
  803883:	68 d9 4a 80 00       	push   $0x804ad9
  803888:	68 04 01 00 00       	push   $0x104
  80388d:	68 3f 4a 80 00       	push   $0x804a3f
  803892:	e8 de ce ff ff       	call   800775 <_panic>
  803897:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80389a:	8b 00                	mov    (%eax),%eax
  80389c:	85 c0                	test   %eax,%eax
  80389e:	74 10                	je     8038b0 <free_block+0x244>
  8038a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a3:	8b 00                	mov    (%eax),%eax
  8038a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038a8:	8b 52 04             	mov    0x4(%edx),%edx
  8038ab:	89 50 04             	mov    %edx,0x4(%eax)
  8038ae:	eb 14                	jmp    8038c4 <free_block+0x258>
  8038b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b3:	8b 40 04             	mov    0x4(%eax),%eax
  8038b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038b9:	c1 e2 04             	shl    $0x4,%edx
  8038bc:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8038c2:	89 02                	mov    %eax,(%edx)
  8038c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c7:	8b 40 04             	mov    0x4(%eax),%eax
  8038ca:	85 c0                	test   %eax,%eax
  8038cc:	74 0f                	je     8038dd <free_block+0x271>
  8038ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d1:	8b 40 04             	mov    0x4(%eax),%eax
  8038d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038d7:	8b 12                	mov    (%edx),%edx
  8038d9:	89 10                	mov    %edx,(%eax)
  8038db:	eb 13                	jmp    8038f0 <free_block+0x284>
  8038dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e0:	8b 00                	mov    (%eax),%eax
  8038e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038e5:	c1 e2 04             	shl    $0x4,%edx
  8038e8:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8038ee:	89 02                	mov    %eax,(%edx)
  8038f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803906:	c1 e0 04             	shl    $0x4,%eax
  803909:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80390e:	8b 00                	mov    (%eax),%eax
  803910:	8d 50 ff             	lea    -0x1(%eax),%edx
  803913:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803916:	c1 e0 04             	shl    $0x4,%eax
  803919:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80391e:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803920:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803923:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803926:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803929:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80392d:	0f 85 21 ff ff ff    	jne    803854 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803933:	b8 00 10 00 00       	mov    $0x1000,%eax
  803938:	99                   	cltd   
  803939:	f7 7d e8             	idivl  -0x18(%ebp)
  80393c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80393f:	74 17                	je     803958 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803941:	83 ec 04             	sub    $0x4,%esp
  803944:	68 28 4c 80 00       	push   $0x804c28
  803949:	68 0c 01 00 00       	push   $0x10c
  80394e:	68 3f 4a 80 00       	push   $0x804a3f
  803953:	e8 1d ce ff ff       	call   800775 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803958:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80395b:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803961:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803964:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  80396a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80396e:	75 17                	jne    803987 <free_block+0x31b>
  803970:	83 ec 04             	sub    $0x4,%esp
  803973:	68 f8 4a 80 00       	push   $0x804af8
  803978:	68 11 01 00 00       	push   $0x111
  80397d:	68 3f 4a 80 00       	push   $0x804a3f
  803982:	e8 ee cd ff ff       	call   800775 <_panic>
  803987:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80398d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803990:	89 50 04             	mov    %edx,0x4(%eax)
  803993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803996:	8b 40 04             	mov    0x4(%eax),%eax
  803999:	85 c0                	test   %eax,%eax
  80399b:	74 0c                	je     8039a9 <free_block+0x33d>
  80399d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8039a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039a5:	89 10                	mov    %edx,(%eax)
  8039a7:	eb 08                	jmp    8039b1 <free_block+0x345>
  8039a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039ac:	a3 48 50 80 00       	mov    %eax,0x805048
  8039b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039b4:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8039b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039c2:	a1 54 50 80 00       	mov    0x805054,%eax
  8039c7:	40                   	inc    %eax
  8039c8:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  8039cd:	83 ec 0c             	sub    $0xc,%esp
  8039d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8039d3:	e8 2b f4 ff ff       	call   802e03 <to_page_va>
  8039d8:	83 c4 10             	add    $0x10,%esp
  8039db:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8039de:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039e1:	83 ec 0c             	sub    $0xc,%esp
  8039e4:	50                   	push   %eax
  8039e5:	e8 69 e8 ff ff       	call   802253 <return_page>
  8039ea:	83 c4 10             	add    $0x10,%esp
  8039ed:	eb 01                	jmp    8039f0 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8039ef:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8039f0:	c9                   	leave  
  8039f1:	c3                   	ret    

008039f2 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8039f2:	55                   	push   %ebp
  8039f3:	89 e5                	mov    %esp,%ebp
  8039f5:	83 ec 14             	sub    $0x14,%esp
  8039f8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8039fb:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8039ff:	77 07                	ja     803a08 <nearest_pow2_ceil.1572+0x16>
      return 1;
  803a01:	b8 01 00 00 00       	mov    $0x1,%eax
  803a06:	eb 20                	jmp    803a28 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803a08:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803a0f:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803a12:	eb 08                	jmp    803a1c <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803a14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a17:	01 c0                	add    %eax,%eax
  803a19:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803a1c:	d1 6d 08             	shrl   0x8(%ebp)
  803a1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a23:	75 ef                	jne    803a14 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803a25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803a28:	c9                   	leave  
  803a29:	c3                   	ret    

00803a2a <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803a2a:	55                   	push   %ebp
  803a2b:	89 e5                	mov    %esp,%ebp
  803a2d:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803a30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a34:	75 13                	jne    803a49 <realloc_block+0x1f>
    return alloc_block(new_size);
  803a36:	83 ec 0c             	sub    $0xc,%esp
  803a39:	ff 75 0c             	pushl  0xc(%ebp)
  803a3c:	e8 d1 f6 ff ff       	call   803112 <alloc_block>
  803a41:	83 c4 10             	add    $0x10,%esp
  803a44:	e9 d9 00 00 00       	jmp    803b22 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803a49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a4d:	75 18                	jne    803a67 <realloc_block+0x3d>
    free_block(va);
  803a4f:	83 ec 0c             	sub    $0xc,%esp
  803a52:	ff 75 08             	pushl  0x8(%ebp)
  803a55:	e8 12 fc ff ff       	call   80366c <free_block>
  803a5a:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803a5d:	b8 00 00 00 00       	mov    $0x0,%eax
  803a62:	e9 bb 00 00 00       	jmp    803b22 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803a67:	83 ec 0c             	sub    $0xc,%esp
  803a6a:	ff 75 08             	pushl  0x8(%ebp)
  803a6d:	e8 38 f6 ff ff       	call   8030aa <get_block_size>
  803a72:	83 c4 10             	add    $0x10,%esp
  803a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803a78:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803a7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a82:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803a85:	73 06                	jae    803a8d <realloc_block+0x63>
    new_size = min_block_size;
  803a87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a8a:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803a8d:	83 ec 0c             	sub    $0xc,%esp
  803a90:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803a93:	ff 75 0c             	pushl  0xc(%ebp)
  803a96:	89 c1                	mov    %eax,%ecx
  803a98:	e8 55 ff ff ff       	call   8039f2 <nearest_pow2_ceil.1572>
  803a9d:	83 c4 10             	add    $0x10,%esp
  803aa0:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803aa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803aa9:	75 05                	jne    803ab0 <realloc_block+0x86>
    return va;
  803aab:	8b 45 08             	mov    0x8(%ebp),%eax
  803aae:	eb 72                	jmp    803b22 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803ab0:	83 ec 0c             	sub    $0xc,%esp
  803ab3:	ff 75 0c             	pushl  0xc(%ebp)
  803ab6:	e8 57 f6 ff ff       	call   803112 <alloc_block>
  803abb:	83 c4 10             	add    $0x10,%esp
  803abe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803ac1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ac5:	75 07                	jne    803ace <realloc_block+0xa4>
    return NULL;
  803ac7:	b8 00 00 00 00       	mov    $0x0,%eax
  803acc:	eb 54                	jmp    803b22 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803ace:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ad4:	39 d0                	cmp    %edx,%eax
  803ad6:	76 02                	jbe    803ada <realloc_block+0xb0>
  803ad8:	89 d0                	mov    %edx,%eax
  803ada:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803add:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803ae3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803ae9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803af0:	eb 17                	jmp    803b09 <realloc_block+0xdf>
    dst[i] = src[i];
  803af2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af8:	01 c2                	add    %eax,%edx
  803afa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b00:	01 c8                	add    %ecx,%eax
  803b02:	8a 00                	mov    (%eax),%al
  803b04:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803b06:	ff 45 f4             	incl   -0xc(%ebp)
  803b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803b0f:	72 e1                	jb     803af2 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803b11:	83 ec 0c             	sub    $0xc,%esp
  803b14:	ff 75 08             	pushl  0x8(%ebp)
  803b17:	e8 50 fb ff ff       	call   80366c <free_block>
  803b1c:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803b1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803b22:	c9                   	leave  
  803b23:	c3                   	ret    

00803b24 <__udivdi3>:
  803b24:	55                   	push   %ebp
  803b25:	57                   	push   %edi
  803b26:	56                   	push   %esi
  803b27:	53                   	push   %ebx
  803b28:	83 ec 1c             	sub    $0x1c,%esp
  803b2b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b2f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b3b:	89 ca                	mov    %ecx,%edx
  803b3d:	89 f8                	mov    %edi,%eax
  803b3f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b43:	85 f6                	test   %esi,%esi
  803b45:	75 2d                	jne    803b74 <__udivdi3+0x50>
  803b47:	39 cf                	cmp    %ecx,%edi
  803b49:	77 65                	ja     803bb0 <__udivdi3+0x8c>
  803b4b:	89 fd                	mov    %edi,%ebp
  803b4d:	85 ff                	test   %edi,%edi
  803b4f:	75 0b                	jne    803b5c <__udivdi3+0x38>
  803b51:	b8 01 00 00 00       	mov    $0x1,%eax
  803b56:	31 d2                	xor    %edx,%edx
  803b58:	f7 f7                	div    %edi
  803b5a:	89 c5                	mov    %eax,%ebp
  803b5c:	31 d2                	xor    %edx,%edx
  803b5e:	89 c8                	mov    %ecx,%eax
  803b60:	f7 f5                	div    %ebp
  803b62:	89 c1                	mov    %eax,%ecx
  803b64:	89 d8                	mov    %ebx,%eax
  803b66:	f7 f5                	div    %ebp
  803b68:	89 cf                	mov    %ecx,%edi
  803b6a:	89 fa                	mov    %edi,%edx
  803b6c:	83 c4 1c             	add    $0x1c,%esp
  803b6f:	5b                   	pop    %ebx
  803b70:	5e                   	pop    %esi
  803b71:	5f                   	pop    %edi
  803b72:	5d                   	pop    %ebp
  803b73:	c3                   	ret    
  803b74:	39 ce                	cmp    %ecx,%esi
  803b76:	77 28                	ja     803ba0 <__udivdi3+0x7c>
  803b78:	0f bd fe             	bsr    %esi,%edi
  803b7b:	83 f7 1f             	xor    $0x1f,%edi
  803b7e:	75 40                	jne    803bc0 <__udivdi3+0x9c>
  803b80:	39 ce                	cmp    %ecx,%esi
  803b82:	72 0a                	jb     803b8e <__udivdi3+0x6a>
  803b84:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b88:	0f 87 9e 00 00 00    	ja     803c2c <__udivdi3+0x108>
  803b8e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b93:	89 fa                	mov    %edi,%edx
  803b95:	83 c4 1c             	add    $0x1c,%esp
  803b98:	5b                   	pop    %ebx
  803b99:	5e                   	pop    %esi
  803b9a:	5f                   	pop    %edi
  803b9b:	5d                   	pop    %ebp
  803b9c:	c3                   	ret    
  803b9d:	8d 76 00             	lea    0x0(%esi),%esi
  803ba0:	31 ff                	xor    %edi,%edi
  803ba2:	31 c0                	xor    %eax,%eax
  803ba4:	89 fa                	mov    %edi,%edx
  803ba6:	83 c4 1c             	add    $0x1c,%esp
  803ba9:	5b                   	pop    %ebx
  803baa:	5e                   	pop    %esi
  803bab:	5f                   	pop    %edi
  803bac:	5d                   	pop    %ebp
  803bad:	c3                   	ret    
  803bae:	66 90                	xchg   %ax,%ax
  803bb0:	89 d8                	mov    %ebx,%eax
  803bb2:	f7 f7                	div    %edi
  803bb4:	31 ff                	xor    %edi,%edi
  803bb6:	89 fa                	mov    %edi,%edx
  803bb8:	83 c4 1c             	add    $0x1c,%esp
  803bbb:	5b                   	pop    %ebx
  803bbc:	5e                   	pop    %esi
  803bbd:	5f                   	pop    %edi
  803bbe:	5d                   	pop    %ebp
  803bbf:	c3                   	ret    
  803bc0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bc5:	89 eb                	mov    %ebp,%ebx
  803bc7:	29 fb                	sub    %edi,%ebx
  803bc9:	89 f9                	mov    %edi,%ecx
  803bcb:	d3 e6                	shl    %cl,%esi
  803bcd:	89 c5                	mov    %eax,%ebp
  803bcf:	88 d9                	mov    %bl,%cl
  803bd1:	d3 ed                	shr    %cl,%ebp
  803bd3:	89 e9                	mov    %ebp,%ecx
  803bd5:	09 f1                	or     %esi,%ecx
  803bd7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bdb:	89 f9                	mov    %edi,%ecx
  803bdd:	d3 e0                	shl    %cl,%eax
  803bdf:	89 c5                	mov    %eax,%ebp
  803be1:	89 d6                	mov    %edx,%esi
  803be3:	88 d9                	mov    %bl,%cl
  803be5:	d3 ee                	shr    %cl,%esi
  803be7:	89 f9                	mov    %edi,%ecx
  803be9:	d3 e2                	shl    %cl,%edx
  803beb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bef:	88 d9                	mov    %bl,%cl
  803bf1:	d3 e8                	shr    %cl,%eax
  803bf3:	09 c2                	or     %eax,%edx
  803bf5:	89 d0                	mov    %edx,%eax
  803bf7:	89 f2                	mov    %esi,%edx
  803bf9:	f7 74 24 0c          	divl   0xc(%esp)
  803bfd:	89 d6                	mov    %edx,%esi
  803bff:	89 c3                	mov    %eax,%ebx
  803c01:	f7 e5                	mul    %ebp
  803c03:	39 d6                	cmp    %edx,%esi
  803c05:	72 19                	jb     803c20 <__udivdi3+0xfc>
  803c07:	74 0b                	je     803c14 <__udivdi3+0xf0>
  803c09:	89 d8                	mov    %ebx,%eax
  803c0b:	31 ff                	xor    %edi,%edi
  803c0d:	e9 58 ff ff ff       	jmp    803b6a <__udivdi3+0x46>
  803c12:	66 90                	xchg   %ax,%ax
  803c14:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c18:	89 f9                	mov    %edi,%ecx
  803c1a:	d3 e2                	shl    %cl,%edx
  803c1c:	39 c2                	cmp    %eax,%edx
  803c1e:	73 e9                	jae    803c09 <__udivdi3+0xe5>
  803c20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c23:	31 ff                	xor    %edi,%edi
  803c25:	e9 40 ff ff ff       	jmp    803b6a <__udivdi3+0x46>
  803c2a:	66 90                	xchg   %ax,%ax
  803c2c:	31 c0                	xor    %eax,%eax
  803c2e:	e9 37 ff ff ff       	jmp    803b6a <__udivdi3+0x46>
  803c33:	90                   	nop

00803c34 <__umoddi3>:
  803c34:	55                   	push   %ebp
  803c35:	57                   	push   %edi
  803c36:	56                   	push   %esi
  803c37:	53                   	push   %ebx
  803c38:	83 ec 1c             	sub    $0x1c,%esp
  803c3b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c47:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c4f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c53:	89 f3                	mov    %esi,%ebx
  803c55:	89 fa                	mov    %edi,%edx
  803c57:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c5b:	89 34 24             	mov    %esi,(%esp)
  803c5e:	85 c0                	test   %eax,%eax
  803c60:	75 1a                	jne    803c7c <__umoddi3+0x48>
  803c62:	39 f7                	cmp    %esi,%edi
  803c64:	0f 86 a2 00 00 00    	jbe    803d0c <__umoddi3+0xd8>
  803c6a:	89 c8                	mov    %ecx,%eax
  803c6c:	89 f2                	mov    %esi,%edx
  803c6e:	f7 f7                	div    %edi
  803c70:	89 d0                	mov    %edx,%eax
  803c72:	31 d2                	xor    %edx,%edx
  803c74:	83 c4 1c             	add    $0x1c,%esp
  803c77:	5b                   	pop    %ebx
  803c78:	5e                   	pop    %esi
  803c79:	5f                   	pop    %edi
  803c7a:	5d                   	pop    %ebp
  803c7b:	c3                   	ret    
  803c7c:	39 f0                	cmp    %esi,%eax
  803c7e:	0f 87 ac 00 00 00    	ja     803d30 <__umoddi3+0xfc>
  803c84:	0f bd e8             	bsr    %eax,%ebp
  803c87:	83 f5 1f             	xor    $0x1f,%ebp
  803c8a:	0f 84 ac 00 00 00    	je     803d3c <__umoddi3+0x108>
  803c90:	bf 20 00 00 00       	mov    $0x20,%edi
  803c95:	29 ef                	sub    %ebp,%edi
  803c97:	89 fe                	mov    %edi,%esi
  803c99:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c9d:	89 e9                	mov    %ebp,%ecx
  803c9f:	d3 e0                	shl    %cl,%eax
  803ca1:	89 d7                	mov    %edx,%edi
  803ca3:	89 f1                	mov    %esi,%ecx
  803ca5:	d3 ef                	shr    %cl,%edi
  803ca7:	09 c7                	or     %eax,%edi
  803ca9:	89 e9                	mov    %ebp,%ecx
  803cab:	d3 e2                	shl    %cl,%edx
  803cad:	89 14 24             	mov    %edx,(%esp)
  803cb0:	89 d8                	mov    %ebx,%eax
  803cb2:	d3 e0                	shl    %cl,%eax
  803cb4:	89 c2                	mov    %eax,%edx
  803cb6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cba:	d3 e0                	shl    %cl,%eax
  803cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cc0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cc4:	89 f1                	mov    %esi,%ecx
  803cc6:	d3 e8                	shr    %cl,%eax
  803cc8:	09 d0                	or     %edx,%eax
  803cca:	d3 eb                	shr    %cl,%ebx
  803ccc:	89 da                	mov    %ebx,%edx
  803cce:	f7 f7                	div    %edi
  803cd0:	89 d3                	mov    %edx,%ebx
  803cd2:	f7 24 24             	mull   (%esp)
  803cd5:	89 c6                	mov    %eax,%esi
  803cd7:	89 d1                	mov    %edx,%ecx
  803cd9:	39 d3                	cmp    %edx,%ebx
  803cdb:	0f 82 87 00 00 00    	jb     803d68 <__umoddi3+0x134>
  803ce1:	0f 84 91 00 00 00    	je     803d78 <__umoddi3+0x144>
  803ce7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ceb:	29 f2                	sub    %esi,%edx
  803ced:	19 cb                	sbb    %ecx,%ebx
  803cef:	89 d8                	mov    %ebx,%eax
  803cf1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cf5:	d3 e0                	shl    %cl,%eax
  803cf7:	89 e9                	mov    %ebp,%ecx
  803cf9:	d3 ea                	shr    %cl,%edx
  803cfb:	09 d0                	or     %edx,%eax
  803cfd:	89 e9                	mov    %ebp,%ecx
  803cff:	d3 eb                	shr    %cl,%ebx
  803d01:	89 da                	mov    %ebx,%edx
  803d03:	83 c4 1c             	add    $0x1c,%esp
  803d06:	5b                   	pop    %ebx
  803d07:	5e                   	pop    %esi
  803d08:	5f                   	pop    %edi
  803d09:	5d                   	pop    %ebp
  803d0a:	c3                   	ret    
  803d0b:	90                   	nop
  803d0c:	89 fd                	mov    %edi,%ebp
  803d0e:	85 ff                	test   %edi,%edi
  803d10:	75 0b                	jne    803d1d <__umoddi3+0xe9>
  803d12:	b8 01 00 00 00       	mov    $0x1,%eax
  803d17:	31 d2                	xor    %edx,%edx
  803d19:	f7 f7                	div    %edi
  803d1b:	89 c5                	mov    %eax,%ebp
  803d1d:	89 f0                	mov    %esi,%eax
  803d1f:	31 d2                	xor    %edx,%edx
  803d21:	f7 f5                	div    %ebp
  803d23:	89 c8                	mov    %ecx,%eax
  803d25:	f7 f5                	div    %ebp
  803d27:	89 d0                	mov    %edx,%eax
  803d29:	e9 44 ff ff ff       	jmp    803c72 <__umoddi3+0x3e>
  803d2e:	66 90                	xchg   %ax,%ax
  803d30:	89 c8                	mov    %ecx,%eax
  803d32:	89 f2                	mov    %esi,%edx
  803d34:	83 c4 1c             	add    $0x1c,%esp
  803d37:	5b                   	pop    %ebx
  803d38:	5e                   	pop    %esi
  803d39:	5f                   	pop    %edi
  803d3a:	5d                   	pop    %ebp
  803d3b:	c3                   	ret    
  803d3c:	3b 04 24             	cmp    (%esp),%eax
  803d3f:	72 06                	jb     803d47 <__umoddi3+0x113>
  803d41:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d45:	77 0f                	ja     803d56 <__umoddi3+0x122>
  803d47:	89 f2                	mov    %esi,%edx
  803d49:	29 f9                	sub    %edi,%ecx
  803d4b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d4f:	89 14 24             	mov    %edx,(%esp)
  803d52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d56:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d5a:	8b 14 24             	mov    (%esp),%edx
  803d5d:	83 c4 1c             	add    $0x1c,%esp
  803d60:	5b                   	pop    %ebx
  803d61:	5e                   	pop    %esi
  803d62:	5f                   	pop    %edi
  803d63:	5d                   	pop    %ebp
  803d64:	c3                   	ret    
  803d65:	8d 76 00             	lea    0x0(%esi),%esi
  803d68:	2b 04 24             	sub    (%esp),%eax
  803d6b:	19 fa                	sbb    %edi,%edx
  803d6d:	89 d1                	mov    %edx,%ecx
  803d6f:	89 c6                	mov    %eax,%esi
  803d71:	e9 71 ff ff ff       	jmp    803ce7 <__umoddi3+0xb3>
  803d76:	66 90                	xchg   %ax,%ax
  803d78:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d7c:	72 ea                	jb     803d68 <__umoddi3+0x134>
  803d7e:	89 d9                	mov    %ebx,%ecx
  803d80:	e9 62 ff ff ff       	jmp    803ce7 <__umoddi3+0xb3>
