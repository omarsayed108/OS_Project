
obj/user/quicksort_semaphore:     file format elf32-i386


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
  800031:	e8 3b 06 00 00       	call   800671 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);
struct semaphore IO_CS ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 34 01 00 00    	sub    $0x134,%esp
	int envID = sys_getenvid();
  800042:	e8 8c 2b 00 00       	call   802bd3 <sys_getenvid>
  800047:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  80004a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	IO_CS = create_semaphore("IO.CS", 1);
  800051:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	6a 01                	push   $0x1
  80005c:	68 c0 3e 80 00       	push   $0x803ec0
  800061:	50                   	push   %eax
  800062:	e8 69 3b 00 00       	call   803bd0 <create_semaphore>
  800067:	83 c4 0c             	add    $0xc,%esp
  80006a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800070:	a3 60 d0 81 00       	mov    %eax,0x81d060
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800075:	e8 a9 29 00 00       	call   802a23 <sys_calculate_free_frames>
  80007a:	89 c3                	mov    %eax,%ebx
  80007c:	e8 bb 29 00 00       	call   802a3c <sys_calculate_modified_frames>
  800081:	01 d8                	add    %ebx,%eax
  800083:	89 45 ec             	mov    %eax,-0x14(%ebp)

		Iteration++ ;
  800086:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_lock_cons();
		int NumOfElements, *Elements;
		wait_semaphore(IO_CS);
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	ff 35 60 d0 81 00    	pushl  0x81d060
  800092:	e8 6d 3b 00 00       	call   803c04 <wait_semaphore>
  800097:	83 c4 10             	add    $0x10,%esp
		{
			readline("Enter the number of elements: ", Line);
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000a3:	50                   	push   %eax
  8000a4:	68 c8 3e 80 00       	push   $0x803ec8
  8000a9:	e8 3a 11 00 00       	call   8011e8 <readline>
  8000ae:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000b1:	83 ec 04             	sub    $0x4,%esp
  8000b4:	6a 0a                	push   $0xa
  8000b6:	6a 00                	push   $0x0
  8000b8:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 3b 17 00 00       	call   8017ff <strtol>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c1 e0 02             	shl    $0x2,%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 69 22 00 00       	call   802342 <malloc>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 e8 3e 80 00       	push   $0x803ee8
  8000e7:	e8 23 0a 00 00       	call   800b0f <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 0b 3f 80 00       	push   $0x803f0b
  8000f7:	e8 13 0a 00 00       	call   800b0f <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 19 3f 80 00       	push   $0x803f19
  800107:	e8 03 0a 00 00       	call   800b0f <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 28 3f 80 00       	push   $0x803f28
  800117:	e8 f3 09 00 00       	call   800b0f <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 38 3f 80 00       	push   $0x803f38
  800127:	e8 e3 09 00 00       	call   800b0f <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  80012f:	e8 20 05 00 00       	call   800654 <getchar>
  800134:	88 45 e3             	mov    %al,-0x1d(%ebp)
				cputchar(Chose);
  800137:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 f1 04 00 00       	call   800635 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 e4 04 00 00       	call   800635 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>

		}
		signal_semaphore(IO_CS);
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	ff 35 60 d0 81 00    	pushl  0x81d060
  80016f:	e8 aa 3a 00 00       	call   803c1e <signal_semaphore>
  800174:	83 c4 10             	add    $0x10,%esp

		//sys_unlock_cons();
		int  i ;
		switch (Chose)
  800177:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80017b:	83 f8 62             	cmp    $0x62,%eax
  80017e:	74 1d                	je     80019d <_main+0x165>
  800180:	83 f8 63             	cmp    $0x63,%eax
  800183:	74 2b                	je     8001b0 <_main+0x178>
  800185:	83 f8 61             	cmp    $0x61,%eax
  800188:	75 39                	jne    8001c3 <_main+0x18b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	ff 75 e8             	pushl  -0x18(%ebp)
  800190:	ff 75 e4             	pushl  -0x1c(%ebp)
  800193:	e8 2e 03 00 00       	call   8004c6 <InitializeAscending>
  800198:	83 c4 10             	add    $0x10,%esp
			break ;
  80019b:	eb 37                	jmp    8001d4 <_main+0x19c>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  80019d:	83 ec 08             	sub    $0x8,%esp
  8001a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001a6:	e8 4c 03 00 00       	call   8004f7 <InitializeIdentical>
  8001ab:	83 c4 10             	add    $0x10,%esp
			break ;
  8001ae:	eb 24                	jmp    8001d4 <_main+0x19c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b9:	e8 6e 03 00 00       	call   80052c <InitializeSemiRandom>
  8001be:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c1:	eb 11                	jmp    8001d4 <_main+0x19c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001c3:	83 ec 08             	sub    $0x8,%esp
  8001c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001cc:	e8 5b 03 00 00       	call   80052c <InitializeSemiRandom>
  8001d1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001dd:	e8 29 01 00 00       	call   80030b <QuickSort>
  8001e2:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8001eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ee:	e8 29 02 00 00       	call   80041c <CheckSorted>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001fd:	75 14                	jne    800213 <_main+0x1db>
  8001ff:	83 ec 04             	sub    $0x4,%esp
  800202:	68 44 3f 80 00       	push   $0x803f44
  800207:	6a 4d                	push   $0x4d
  800209:	68 66 3f 80 00       	push   $0x803f66
  80020e:	e8 0e 06 00 00       	call   800821 <_panic>
		else
		{
			wait_semaphore(IO_CS);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	ff 35 60 d0 81 00    	pushl  0x81d060
  80021c:	e8 e3 39 00 00       	call   803c04 <wait_semaphore>
  800221:	83 c4 10             	add    $0x10,%esp
				cprintf("\n===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 84 3f 80 00       	push   $0x803f84
  80022c:	e8 de 08 00 00       	call   800b0f <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 b8 3f 80 00       	push   $0x803fb8
  80023c:	e8 ce 08 00 00       	call   800b0f <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 ec 3f 80 00       	push   $0x803fec
  80024c:	e8 be 08 00 00       	call   800b0f <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			signal_semaphore(IO_CS);
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	ff 35 60 d0 81 00    	pushl  0x81d060
  80025d:	e8 bc 39 00 00       	call   803c1e <signal_semaphore>
  800262:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		wait_semaphore(IO_CS);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	ff 35 60 d0 81 00    	pushl  0x81d060
  80026e:	e8 91 39 00 00       	call   803c04 <wait_semaphore>
  800273:	83 c4 10             	add    $0x10,%esp
			cprintf("Freeing the Heap...\n\n") ;
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	68 1e 40 80 00       	push   $0x80401e
  80027e:	e8 8c 08 00 00       	call   800b0f <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp
		signal_semaphore(IO_CS);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 35 60 d0 81 00    	pushl  0x81d060
  80028f:	e8 8a 39 00 00       	call   803c1e <signal_semaphore>
  800294:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		wait_semaphore(IO_CS);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 35 60 d0 81 00    	pushl  0x81d060
  8002a0:	e8 5f 39 00 00       	call   803c04 <wait_semaphore>
  8002a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Do you want to repeat (y/n): ") ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 34 40 80 00       	push   $0x804034
  8002b0:	e8 5a 08 00 00       	call   800b0f <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8002b8:	e8 97 03 00 00       	call   800654 <getchar>
  8002bd:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  8002c0:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  8002c4:	83 ec 0c             	sub    $0xc,%esp
  8002c7:	50                   	push   %eax
  8002c8:	e8 68 03 00 00       	call   800635 <cputchar>
  8002cd:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	6a 0a                	push   $0xa
  8002d5:	e8 5b 03 00 00       	call   800635 <cputchar>
  8002da:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002dd:	83 ec 0c             	sub    $0xc,%esp
  8002e0:	6a 0a                	push   $0xa
  8002e2:	e8 4e 03 00 00       	call   800635 <cputchar>
  8002e7:	83 c4 10             	add    $0x10,%esp
	//sys_unlock_cons();
		signal_semaphore(IO_CS);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 35 60 d0 81 00    	pushl  0x81d060
  8002f3:	e8 26 39 00 00       	call   803c1e <signal_semaphore>
  8002f8:	83 c4 10             	add    $0x10,%esp

	} while (Chose == 'y');
  8002fb:	80 7d e3 79          	cmpb   $0x79,-0x1d(%ebp)
  8002ff:	0f 84 70 fd ff ff    	je     800075 <_main+0x3d>

}
  800305:	90                   	nop
  800306:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800309:	c9                   	leave  
  80030a:	c3                   	ret    

0080030b <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	48                   	dec    %eax
  800315:	50                   	push   %eax
  800316:	6a 00                	push   $0x0
  800318:	ff 75 0c             	pushl  0xc(%ebp)
  80031b:	ff 75 08             	pushl  0x8(%ebp)
  80031e:	e8 06 00 00 00       	call   800329 <QSort>
  800323:	83 c4 10             	add    $0x10,%esp
}
  800326:	90                   	nop
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80032f:	8b 45 10             	mov    0x10(%ebp),%eax
  800332:	3b 45 14             	cmp    0x14(%ebp),%eax
  800335:	0f 8d de 00 00 00    	jge    800419 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  80033b:	8b 45 10             	mov    0x10(%ebp),%eax
  80033e:	40                   	inc    %eax
  80033f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800342:	8b 45 14             	mov    0x14(%ebp),%eax
  800345:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800348:	e9 80 00 00 00       	jmp    8003cd <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80034d:	ff 45 f4             	incl   -0xc(%ebp)
  800350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800353:	3b 45 14             	cmp    0x14(%ebp),%eax
  800356:	7f 2b                	jg     800383 <QSort+0x5a>
  800358:	8b 45 10             	mov    0x10(%ebp),%eax
  80035b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	01 d0                	add    %edx,%eax
  800367:	8b 10                	mov    (%eax),%edx
  800369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	01 c8                	add    %ecx,%eax
  800378:	8b 00                	mov    (%eax),%eax
  80037a:	39 c2                	cmp    %eax,%edx
  80037c:	7d cf                	jge    80034d <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  80037e:	eb 03                	jmp    800383 <QSort+0x5a>
  800380:	ff 4d f0             	decl   -0x10(%ebp)
  800383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800386:	3b 45 10             	cmp    0x10(%ebp),%eax
  800389:	7e 26                	jle    8003b1 <QSort+0x88>
  80038b:	8b 45 10             	mov    0x10(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 d0                	add    %edx,%eax
  80039a:	8b 10                	mov    (%eax),%edx
  80039c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a9:	01 c8                	add    %ecx,%eax
  8003ab:	8b 00                	mov    (%eax),%eax
  8003ad:	39 c2                	cmp    %eax,%edx
  8003af:	7e cf                	jle    800380 <QSort+0x57>

		if (i <= j)
  8003b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003b7:	7f 14                	jg     8003cd <QSort+0xa4>
		{
			Swap(Elements, i, j);
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	ff 75 08             	pushl  0x8(%ebp)
  8003c5:	e8 a9 00 00 00       	call   800473 <Swap>
  8003ca:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8003cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d3:	0f 8e 77 ff ff ff    	jle    800350 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8003df:	ff 75 10             	pushl  0x10(%ebp)
  8003e2:	ff 75 08             	pushl  0x8(%ebp)
  8003e5:	e8 89 00 00 00       	call   800473 <Swap>
  8003ea:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f0:	48                   	dec    %eax
  8003f1:	50                   	push   %eax
  8003f2:	ff 75 10             	pushl  0x10(%ebp)
  8003f5:	ff 75 0c             	pushl  0xc(%ebp)
  8003f8:	ff 75 08             	pushl  0x8(%ebp)
  8003fb:	e8 29 ff ff ff       	call   800329 <QSort>
  800400:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800403:	ff 75 14             	pushl  0x14(%ebp)
  800406:	ff 75 f4             	pushl  -0xc(%ebp)
  800409:	ff 75 0c             	pushl  0xc(%ebp)
  80040c:	ff 75 08             	pushl  0x8(%ebp)
  80040f:	e8 15 ff ff ff       	call   800329 <QSort>
  800414:	83 c4 10             	add    $0x10,%esp
  800417:	eb 01                	jmp    80041a <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800419:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  80041a:	c9                   	leave  
  80041b:	c3                   	ret    

0080041c <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800422:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800429:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800430:	eb 33                	jmp    800465 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800432:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 08             	mov    0x8(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 10                	mov    (%eax),%edx
  800443:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800446:	40                   	inc    %eax
  800447:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c8                	add    %ecx,%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	39 c2                	cmp    %eax,%edx
  800457:	7e 09                	jle    800462 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800459:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800460:	eb 0c                	jmp    80046e <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800462:	ff 45 f8             	incl   -0x8(%ebp)
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	48                   	dec    %eax
  800469:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80046c:	7f c4                	jg     800432 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80046e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80048d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800490:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	01 c2                	add    %eax,%edx
  80049c:	8b 45 10             	mov    0x10(%ebp),%eax
  80049f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	01 c8                	add    %ecx,%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8004af:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	01 c2                	add    %eax,%edx
  8004be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c1:	89 02                	mov    %eax,(%edx)
}
  8004c3:	90                   	nop
  8004c4:	c9                   	leave  
  8004c5:	c3                   	ret    

008004c6 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004d3:	eb 17                	jmp    8004ec <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8004d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	01 c2                	add    %eax,%edx
  8004e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e7:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004e9:	ff 45 fc             	incl   -0x4(%ebp)
  8004ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f2:	7c e1                	jl     8004d5 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004f4:	90                   	nop
  8004f5:	c9                   	leave  
  8004f6:	c3                   	ret    

008004f7 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
  8004fa:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800504:	eb 1b                	jmp    800521 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	01 c2                	add    %eax,%edx
  800515:	8b 45 0c             	mov    0xc(%ebp),%eax
  800518:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80051b:	48                   	dec    %eax
  80051c:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80051e:	ff 45 fc             	incl   -0x4(%ebp)
  800521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800524:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800527:	7c dd                	jl     800506 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800529:	90                   	nop
  80052a:	c9                   	leave  
  80052b:	c3                   	ret    

0080052c <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800532:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800535:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80053a:	f7 e9                	imul   %ecx
  80053c:	c1 f9 1f             	sar    $0x1f,%ecx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	29 c8                	sub    %ecx,%eax
  800543:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  800546:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80054a:	75 07                	jne    800553 <InitializeSemiRandom+0x27>
			Repetition = 3;
  80054c:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800553:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80055a:	eb 1e                	jmp    80057a <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  80055c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80055f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80056c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80056f:	99                   	cltd   
  800570:	f7 7d f8             	idivl  -0x8(%ebp)
  800573:	89 d0                	mov    %edx,%eax
  800575:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800577:	ff 45 fc             	incl   -0x4(%ebp)
  80057a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80057d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800580:	7c da                	jl     80055c <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
	}

}
  800582:	90                   	nop
  800583:	c9                   	leave  
  800584:	c3                   	ret    

00800585 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 18             	sub    $0x18,%esp
	int envID = sys_getenvid();
  80058b:	e8 43 26 00 00       	call   802bd3 <sys_getenvid>
  800590:	89 45 f0             	mov    %eax,-0x10(%ebp)
	wait_semaphore(IO_CS);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	ff 35 60 d0 81 00    	pushl  0x81d060
  80059c:	e8 63 36 00 00       	call   803c04 <wait_semaphore>
  8005a1:	83 c4 10             	add    $0x10,%esp
		int i ;
		int NumsPerLine = 20 ;
  8005a4:	c7 45 ec 14 00 00 00 	movl   $0x14,-0x14(%ebp)
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8005ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005b2:	eb 42                	jmp    8005f6 <PrintElements+0x71>
		{
			if (i%NumsPerLine == 0)
  8005b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b7:	99                   	cltd   
  8005b8:	f7 7d ec             	idivl  -0x14(%ebp)
  8005bb:	89 d0                	mov    %edx,%eax
  8005bd:	85 c0                	test   %eax,%eax
  8005bf:	75 10                	jne    8005d1 <PrintElements+0x4c>
				cprintf("\n");
  8005c1:	83 ec 0c             	sub    $0xc,%esp
  8005c4:	68 52 40 80 00       	push   $0x804052
  8005c9:	e8 41 05 00 00       	call   800b0f <cprintf>
  8005ce:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  8005d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	01 d0                	add    %edx,%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	50                   	push   %eax
  8005e6:	68 54 40 80 00       	push   $0x804054
  8005eb:	e8 1f 05 00 00       	call   800b0f <cprintf>
  8005f0:	83 c4 10             	add    $0x10,%esp
{
	int envID = sys_getenvid();
	wait_semaphore(IO_CS);
		int i ;
		int NumsPerLine = 20 ;
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8005f3:	ff 45 f4             	incl   -0xc(%ebp)
  8005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f9:	48                   	dec    %eax
  8005fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005fd:	7f b5                	jg     8005b4 <PrintElements+0x2f>
		{
			if (i%NumsPerLine == 0)
				cprintf("\n");
			cprintf("%d, ",Elements[i]);
		}
		cprintf("%d\n",Elements[i]);
  8005ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800602:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	01 d0                	add    %edx,%eax
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	50                   	push   %eax
  800614:	68 59 40 80 00       	push   $0x804059
  800619:	e8 f1 04 00 00       	call   800b0f <cprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(IO_CS);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	ff 35 60 d0 81 00    	pushl  0x81d060
  80062a:	e8 ef 35 00 00       	call   803c1e <signal_semaphore>
  80062f:	83 c4 10             	add    $0x10,%esp
}
  800632:	90                   	nop
  800633:	c9                   	leave  
  800634:	c3                   	ret    

00800635 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
  800638:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800641:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	50                   	push   %eax
  800649:	e8 6d 24 00 00       	call   802abb <sys_cputc>
  80064e:	83 c4 10             	add    $0x10,%esp
}
  800651:	90                   	nop
  800652:	c9                   	leave  
  800653:	c3                   	ret    

00800654 <getchar>:


int
getchar(void)
{
  800654:	55                   	push   %ebp
  800655:	89 e5                	mov    %esp,%ebp
  800657:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80065a:	e8 fb 22 00 00       	call   80295a <sys_cgetc>
  80065f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800662:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <iscons>:

int iscons(int fdnum)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80066a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80066f:	5d                   	pop    %ebp
  800670:	c3                   	ret    

00800671 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	57                   	push   %edi
  800675:	56                   	push   %esi
  800676:	53                   	push   %ebx
  800677:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80067a:	e8 6d 25 00 00       	call   802bec <sys_getenvindex>
  80067f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800682:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800685:	89 d0                	mov    %edx,%eax
  800687:	01 c0                	add    %eax,%eax
  800689:	01 d0                	add    %edx,%eax
  80068b:	c1 e0 02             	shl    $0x2,%eax
  80068e:	01 d0                	add    %edx,%eax
  800690:	c1 e0 02             	shl    $0x2,%eax
  800693:	01 d0                	add    %edx,%eax
  800695:	c1 e0 03             	shl    $0x3,%eax
  800698:	01 d0                	add    %edx,%eax
  80069a:	c1 e0 02             	shl    $0x2,%eax
  80069d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006a2:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006a7:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ac:	8a 40 20             	mov    0x20(%eax),%al
  8006af:	84 c0                	test   %al,%al
  8006b1:	74 0d                	je     8006c0 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8006b3:	a1 24 50 80 00       	mov    0x805024,%eax
  8006b8:	83 c0 20             	add    $0x20,%eax
  8006bb:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006c4:	7e 0a                	jle    8006d0 <libmain+0x5f>
		binaryname = argv[0];
  8006c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	ff 75 08             	pushl  0x8(%ebp)
  8006d9:	e8 5a f9 ff ff       	call   800038 <_main>
  8006de:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006e1:	a1 00 50 80 00       	mov    0x805000,%eax
  8006e6:	85 c0                	test   %eax,%eax
  8006e8:	0f 84 01 01 00 00    	je     8007ef <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8006ee:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006f4:	bb 58 41 80 00       	mov    $0x804158,%ebx
  8006f9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006fe:	89 c7                	mov    %eax,%edi
  800700:	89 de                	mov    %ebx,%esi
  800702:	89 d1                	mov    %edx,%ecx
  800704:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800706:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800709:	b9 56 00 00 00       	mov    $0x56,%ecx
  80070e:	b0 00                	mov    $0x0,%al
  800710:	89 d7                	mov    %edx,%edi
  800712:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800714:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80071b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	50                   	push   %eax
  800722:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800728:	50                   	push   %eax
  800729:	e8 f4 26 00 00       	call   802e22 <sys_utilities>
  80072e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800731:	e8 3d 22 00 00       	call   802973 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800736:	83 ec 0c             	sub    $0xc,%esp
  800739:	68 78 40 80 00       	push   $0x804078
  80073e:	e8 cc 03 00 00       	call   800b0f <cprintf>
  800743:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800746:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800749:	85 c0                	test   %eax,%eax
  80074b:	74 18                	je     800765 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80074d:	e8 ee 26 00 00       	call   802e40 <sys_get_optimal_num_faults>
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	50                   	push   %eax
  800756:	68 a0 40 80 00       	push   $0x8040a0
  80075b:	e8 af 03 00 00       	call   800b0f <cprintf>
  800760:	83 c4 10             	add    $0x10,%esp
  800763:	eb 59                	jmp    8007be <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800765:	a1 24 50 80 00       	mov    0x805024,%eax
  80076a:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800770:	a1 24 50 80 00       	mov    0x805024,%eax
  800775:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80077b:	83 ec 04             	sub    $0x4,%esp
  80077e:	52                   	push   %edx
  80077f:	50                   	push   %eax
  800780:	68 c4 40 80 00       	push   $0x8040c4
  800785:	e8 85 03 00 00       	call   800b0f <cprintf>
  80078a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80078d:	a1 24 50 80 00       	mov    0x805024,%eax
  800792:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800798:	a1 24 50 80 00       	mov    0x805024,%eax
  80079d:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8007a3:	a1 24 50 80 00       	mov    0x805024,%eax
  8007a8:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8007ae:	51                   	push   %ecx
  8007af:	52                   	push   %edx
  8007b0:	50                   	push   %eax
  8007b1:	68 ec 40 80 00       	push   $0x8040ec
  8007b6:	e8 54 03 00 00       	call   800b0f <cprintf>
  8007bb:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007be:	a1 24 50 80 00       	mov    0x805024,%eax
  8007c3:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	50                   	push   %eax
  8007cd:	68 44 41 80 00       	push   $0x804144
  8007d2:	e8 38 03 00 00       	call   800b0f <cprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007da:	83 ec 0c             	sub    $0xc,%esp
  8007dd:	68 78 40 80 00       	push   $0x804078
  8007e2:	e8 28 03 00 00       	call   800b0f <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8007ea:	e8 9e 21 00 00       	call   80298d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8007ef:	e8 1f 00 00 00       	call   800813 <exit>
}
  8007f4:	90                   	nop
  8007f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f8:	5b                   	pop    %ebx
  8007f9:	5e                   	pop    %esi
  8007fa:	5f                   	pop    %edi
  8007fb:	5d                   	pop    %ebp
  8007fc:	c3                   	ret    

008007fd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800803:	83 ec 0c             	sub    $0xc,%esp
  800806:	6a 00                	push   $0x0
  800808:	e8 ab 23 00 00       	call   802bb8 <sys_destroy_env>
  80080d:	83 c4 10             	add    $0x10,%esp
}
  800810:	90                   	nop
  800811:	c9                   	leave  
  800812:	c3                   	ret    

00800813 <exit>:

void
exit(void)
{
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800819:	e8 00 24 00 00       	call   802c1e <sys_exit_env>
}
  80081e:	90                   	nop
  80081f:	c9                   	leave  
  800820:	c3                   	ret    

00800821 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800827:	8d 45 10             	lea    0x10(%ebp),%eax
  80082a:	83 c0 04             	add    $0x4,%eax
  80082d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800830:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800835:	85 c0                	test   %eax,%eax
  800837:	74 16                	je     80084f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800839:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	50                   	push   %eax
  800842:	68 bc 41 80 00       	push   $0x8041bc
  800847:	e8 c3 02 00 00       	call   800b0f <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80084f:	a1 04 50 80 00       	mov    0x805004,%eax
  800854:	83 ec 0c             	sub    $0xc,%esp
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	50                   	push   %eax
  80085e:	68 c4 41 80 00       	push   $0x8041c4
  800863:	6a 74                	push   $0x74
  800865:	e8 d2 02 00 00       	call   800b3c <cprintf_colored>
  80086a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80086d:	8b 45 10             	mov    0x10(%ebp),%eax
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	ff 75 f4             	pushl  -0xc(%ebp)
  800876:	50                   	push   %eax
  800877:	e8 24 02 00 00       	call   800aa0 <vcprintf>
  80087c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80087f:	83 ec 08             	sub    $0x8,%esp
  800882:	6a 00                	push   $0x0
  800884:	68 ec 41 80 00       	push   $0x8041ec
  800889:	e8 12 02 00 00       	call   800aa0 <vcprintf>
  80088e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800891:	e8 7d ff ff ff       	call   800813 <exit>

	// should not return here
	while (1) ;
  800896:	eb fe                	jmp    800896 <_panic+0x75>

00800898 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	53                   	push   %ebx
  80089c:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80089f:	a1 24 50 80 00       	mov    0x805024,%eax
  8008a4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ad:	39 c2                	cmp    %eax,%edx
  8008af:	74 14                	je     8008c5 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008b1:	83 ec 04             	sub    $0x4,%esp
  8008b4:	68 f0 41 80 00       	push   $0x8041f0
  8008b9:	6a 26                	push   $0x26
  8008bb:	68 3c 42 80 00       	push   $0x80423c
  8008c0:	e8 5c ff ff ff       	call   800821 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d3:	e9 d9 00 00 00       	jmp    8009b1 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8008d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	01 d0                	add    %edx,%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	85 c0                	test   %eax,%eax
  8008eb:	75 08                	jne    8008f5 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8008ed:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8008f0:	e9 b9 00 00 00       	jmp    8009ae <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8008f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800903:	eb 79                	jmp    80097e <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800905:	a1 24 50 80 00       	mov    0x805024,%eax
  80090a:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800910:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800913:	89 d0                	mov    %edx,%eax
  800915:	01 c0                	add    %eax,%eax
  800917:	01 d0                	add    %edx,%eax
  800919:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800920:	01 d8                	add    %ebx,%eax
  800922:	01 d0                	add    %edx,%eax
  800924:	01 c8                	add    %ecx,%eax
  800926:	8a 40 04             	mov    0x4(%eax),%al
  800929:	84 c0                	test   %al,%al
  80092b:	75 4e                	jne    80097b <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80092d:	a1 24 50 80 00       	mov    0x805024,%eax
  800932:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800938:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80093b:	89 d0                	mov    %edx,%eax
  80093d:	01 c0                	add    %eax,%eax
  80093f:	01 d0                	add    %edx,%eax
  800941:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800948:	01 d8                	add    %ebx,%eax
  80094a:	01 d0                	add    %edx,%eax
  80094c:	01 c8                	add    %ecx,%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800953:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800956:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80095b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80095d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800960:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	01 c8                	add    %ecx,%eax
  80096c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80096e:	39 c2                	cmp    %eax,%edx
  800970:	75 09                	jne    80097b <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800972:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800979:	eb 19                	jmp    800994 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80097b:	ff 45 e8             	incl   -0x18(%ebp)
  80097e:	a1 24 50 80 00       	mov    0x805024,%eax
  800983:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800989:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80098c:	39 c2                	cmp    %eax,%edx
  80098e:	0f 87 71 ff ff ff    	ja     800905 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800994:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800998:	75 14                	jne    8009ae <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80099a:	83 ec 04             	sub    $0x4,%esp
  80099d:	68 48 42 80 00       	push   $0x804248
  8009a2:	6a 3a                	push   $0x3a
  8009a4:	68 3c 42 80 00       	push   $0x80423c
  8009a9:	e8 73 fe ff ff       	call   800821 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009ae:	ff 45 f0             	incl   -0x10(%ebp)
  8009b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009b7:	0f 8c 1b ff ff ff    	jl     8008d8 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009cb:	eb 2e                	jmp    8009fb <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009cd:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d2:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8009d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009db:	89 d0                	mov    %edx,%eax
  8009dd:	01 c0                	add    %eax,%eax
  8009df:	01 d0                	add    %edx,%eax
  8009e1:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8009e8:	01 d8                	add    %ebx,%eax
  8009ea:	01 d0                	add    %edx,%eax
  8009ec:	01 c8                	add    %ecx,%eax
  8009ee:	8a 40 04             	mov    0x4(%eax),%al
  8009f1:	3c 01                	cmp    $0x1,%al
  8009f3:	75 03                	jne    8009f8 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8009f5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009f8:	ff 45 e0             	incl   -0x20(%ebp)
  8009fb:	a1 24 50 80 00       	mov    0x805024,%eax
  800a00:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a09:	39 c2                	cmp    %eax,%edx
  800a0b:	77 c0                	ja     8009cd <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a10:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a13:	74 14                	je     800a29 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	68 9c 42 80 00       	push   $0x80429c
  800a1d:	6a 44                	push   $0x44
  800a1f:	68 3c 42 80 00       	push   $0x80423c
  800a24:	e8 f8 fd ff ff       	call   800821 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a29:	90                   	nop
  800a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	53                   	push   %ebx
  800a33:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a39:	8b 00                	mov    (%eax),%eax
  800a3b:	8d 48 01             	lea    0x1(%eax),%ecx
  800a3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a41:	89 0a                	mov    %ecx,(%edx)
  800a43:	8b 55 08             	mov    0x8(%ebp),%edx
  800a46:	88 d1                	mov    %dl,%cl
  800a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a52:	8b 00                	mov    (%eax),%eax
  800a54:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a59:	75 30                	jne    800a8b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800a5b:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800a61:	a0 44 50 80 00       	mov    0x805044,%al
  800a66:	0f b6 c0             	movzbl %al,%eax
  800a69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a6c:	8b 09                	mov    (%ecx),%ecx
  800a6e:	89 cb                	mov    %ecx,%ebx
  800a70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a73:	83 c1 08             	add    $0x8,%ecx
  800a76:	52                   	push   %edx
  800a77:	50                   	push   %eax
  800a78:	53                   	push   %ebx
  800a79:	51                   	push   %ecx
  800a7a:	e8 b0 1e 00 00       	call   80292f <sys_cputs>
  800a7f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8e:	8b 40 04             	mov    0x4(%eax),%eax
  800a91:	8d 50 01             	lea    0x1(%eax),%edx
  800a94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a97:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a9a:	90                   	nop
  800a9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a9e:	c9                   	leave  
  800a9f:	c3                   	ret    

00800aa0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aa9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ab0:	00 00 00 
	b.cnt = 0;
  800ab3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800aba:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	ff 75 08             	pushl  0x8(%ebp)
  800ac3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ac9:	50                   	push   %eax
  800aca:	68 2f 0a 80 00       	push   $0x800a2f
  800acf:	e8 5a 02 00 00       	call   800d2e <vprintfmt>
  800ad4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800ad7:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800add:	a0 44 50 80 00       	mov    0x805044,%al
  800ae2:	0f b6 c0             	movzbl %al,%eax
  800ae5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800aeb:	52                   	push   %edx
  800aec:	50                   	push   %eax
  800aed:	51                   	push   %ecx
  800aee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800af4:	83 c0 08             	add    $0x8,%eax
  800af7:	50                   	push   %eax
  800af8:	e8 32 1e 00 00       	call   80292f <sys_cputs>
  800afd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b00:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800b07:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b0d:	c9                   	leave  
  800b0e:	c3                   	ret    

00800b0f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b15:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800b1c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 f4             	pushl  -0xc(%ebp)
  800b2b:	50                   	push   %eax
  800b2c:	e8 6f ff ff ff       	call   800aa0 <vcprintf>
  800b31:	83 c4 10             	add    $0x10,%esp
  800b34:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b42:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	c1 e0 08             	shl    $0x8,%eax
  800b4f:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800b54:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b57:	83 c0 04             	add    $0x4,%eax
  800b5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	83 ec 08             	sub    $0x8,%esp
  800b63:	ff 75 f4             	pushl  -0xc(%ebp)
  800b66:	50                   	push   %eax
  800b67:	e8 34 ff ff ff       	call   800aa0 <vcprintf>
  800b6c:	83 c4 10             	add    $0x10,%esp
  800b6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800b72:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800b79:	07 00 00 

	return cnt;
  800b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b87:	e8 e7 1d 00 00       	call   802973 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b8c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9b:	50                   	push   %eax
  800b9c:	e8 ff fe ff ff       	call   800aa0 <vcprintf>
  800ba1:	83 c4 10             	add    $0x10,%esp
  800ba4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800ba7:	e8 e1 1d 00 00       	call   80298d <sys_unlock_cons>
	return cnt;
  800bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800baf:	c9                   	leave  
  800bb0:	c3                   	ret    

00800bb1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	53                   	push   %ebx
  800bb5:	83 ec 14             	sub    $0x14,%esp
  800bb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc4:	8b 45 18             	mov    0x18(%ebp),%eax
  800bc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bcf:	77 55                	ja     800c26 <printnum+0x75>
  800bd1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bd4:	72 05                	jb     800bdb <printnum+0x2a>
  800bd6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bd9:	77 4b                	ja     800c26 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bdb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bde:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800be1:	8b 45 18             	mov    0x18(%ebp),%eax
  800be4:	ba 00 00 00 00       	mov    $0x0,%edx
  800be9:	52                   	push   %edx
  800bea:	50                   	push   %eax
  800beb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bee:	ff 75 f0             	pushl  -0x10(%ebp)
  800bf1:	e8 4e 30 00 00       	call   803c44 <__udivdi3>
  800bf6:	83 c4 10             	add    $0x10,%esp
  800bf9:	83 ec 04             	sub    $0x4,%esp
  800bfc:	ff 75 20             	pushl  0x20(%ebp)
  800bff:	53                   	push   %ebx
  800c00:	ff 75 18             	pushl  0x18(%ebp)
  800c03:	52                   	push   %edx
  800c04:	50                   	push   %eax
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	ff 75 08             	pushl  0x8(%ebp)
  800c0b:	e8 a1 ff ff ff       	call   800bb1 <printnum>
  800c10:	83 c4 20             	add    $0x20,%esp
  800c13:	eb 1a                	jmp    800c2f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c15:	83 ec 08             	sub    $0x8,%esp
  800c18:	ff 75 0c             	pushl  0xc(%ebp)
  800c1b:	ff 75 20             	pushl  0x20(%ebp)
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	ff d0                	call   *%eax
  800c23:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c26:	ff 4d 1c             	decl   0x1c(%ebp)
  800c29:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c2d:	7f e6                	jg     800c15 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c2f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c32:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3d:	53                   	push   %ebx
  800c3e:	51                   	push   %ecx
  800c3f:	52                   	push   %edx
  800c40:	50                   	push   %eax
  800c41:	e8 0e 31 00 00       	call   803d54 <__umoddi3>
  800c46:	83 c4 10             	add    $0x10,%esp
  800c49:	05 14 45 80 00       	add    $0x804514,%eax
  800c4e:	8a 00                	mov    (%eax),%al
  800c50:	0f be c0             	movsbl %al,%eax
  800c53:	83 ec 08             	sub    $0x8,%esp
  800c56:	ff 75 0c             	pushl  0xc(%ebp)
  800c59:	50                   	push   %eax
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	ff d0                	call   *%eax
  800c5f:	83 c4 10             	add    $0x10,%esp
}
  800c62:	90                   	nop
  800c63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c66:	c9                   	leave  
  800c67:	c3                   	ret    

00800c68 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c6b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c6f:	7e 1c                	jle    800c8d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8b 00                	mov    (%eax),%eax
  800c76:	8d 50 08             	lea    0x8(%eax),%edx
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	89 10                	mov    %edx,(%eax)
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8b 00                	mov    (%eax),%eax
  800c83:	83 e8 08             	sub    $0x8,%eax
  800c86:	8b 50 04             	mov    0x4(%eax),%edx
  800c89:	8b 00                	mov    (%eax),%eax
  800c8b:	eb 40                	jmp    800ccd <getuint+0x65>
	else if (lflag)
  800c8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c91:	74 1e                	je     800cb1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	8d 50 04             	lea    0x4(%eax),%edx
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	89 10                	mov    %edx,(%eax)
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	8b 00                	mov    (%eax),%eax
  800ca5:	83 e8 04             	sub    $0x4,%eax
  800ca8:	8b 00                	mov    (%eax),%eax
  800caa:	ba 00 00 00 00       	mov    $0x0,%edx
  800caf:	eb 1c                	jmp    800ccd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8b 00                	mov    (%eax),%eax
  800cb6:	8d 50 04             	lea    0x4(%eax),%edx
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	89 10                	mov    %edx,(%eax)
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8b 00                	mov    (%eax),%eax
  800cc3:	83 e8 04             	sub    $0x4,%eax
  800cc6:	8b 00                	mov    (%eax),%eax
  800cc8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ccd:	5d                   	pop    %ebp
  800cce:	c3                   	ret    

00800ccf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cd2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd6:	7e 1c                	jle    800cf4 <getint+0x25>
		return va_arg(*ap, long long);
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8b 00                	mov    (%eax),%eax
  800cdd:	8d 50 08             	lea    0x8(%eax),%edx
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	89 10                	mov    %edx,(%eax)
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8b 00                	mov    (%eax),%eax
  800cea:	83 e8 08             	sub    $0x8,%eax
  800ced:	8b 50 04             	mov    0x4(%eax),%edx
  800cf0:	8b 00                	mov    (%eax),%eax
  800cf2:	eb 38                	jmp    800d2c <getint+0x5d>
	else if (lflag)
  800cf4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf8:	74 1a                	je     800d14 <getint+0x45>
		return va_arg(*ap, long);
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	8b 00                	mov    (%eax),%eax
  800cff:	8d 50 04             	lea    0x4(%eax),%edx
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	89 10                	mov    %edx,(%eax)
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8b 00                	mov    (%eax),%eax
  800d0c:	83 e8 04             	sub    $0x4,%eax
  800d0f:	8b 00                	mov    (%eax),%eax
  800d11:	99                   	cltd   
  800d12:	eb 18                	jmp    800d2c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8b 00                	mov    (%eax),%eax
  800d19:	8d 50 04             	lea    0x4(%eax),%edx
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	89 10                	mov    %edx,(%eax)
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8b 00                	mov    (%eax),%eax
  800d26:	83 e8 04             	sub    $0x4,%eax
  800d29:	8b 00                	mov    (%eax),%eax
  800d2b:	99                   	cltd   
}
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    

00800d2e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	56                   	push   %esi
  800d32:	53                   	push   %ebx
  800d33:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d36:	eb 17                	jmp    800d4f <vprintfmt+0x21>
			if (ch == '\0')
  800d38:	85 db                	test   %ebx,%ebx
  800d3a:	0f 84 c1 03 00 00    	je     801101 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d40:	83 ec 08             	sub    $0x8,%esp
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	53                   	push   %ebx
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	ff d0                	call   *%eax
  800d4c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d52:	8d 50 01             	lea    0x1(%eax),%edx
  800d55:	89 55 10             	mov    %edx,0x10(%ebp)
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	0f b6 d8             	movzbl %al,%ebx
  800d5d:	83 fb 25             	cmp    $0x25,%ebx
  800d60:	75 d6                	jne    800d38 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d62:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d66:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d6d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d7b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d82:	8b 45 10             	mov    0x10(%ebp),%eax
  800d85:	8d 50 01             	lea    0x1(%eax),%edx
  800d88:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	0f b6 d8             	movzbl %al,%ebx
  800d90:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d93:	83 f8 5b             	cmp    $0x5b,%eax
  800d96:	0f 87 3d 03 00 00    	ja     8010d9 <vprintfmt+0x3ab>
  800d9c:	8b 04 85 38 45 80 00 	mov    0x804538(,%eax,4),%eax
  800da3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800da5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800da9:	eb d7                	jmp    800d82 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800dab:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800daf:	eb d1                	jmp    800d82 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800db1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800db8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dbb:	89 d0                	mov    %edx,%eax
  800dbd:	c1 e0 02             	shl    $0x2,%eax
  800dc0:	01 d0                	add    %edx,%eax
  800dc2:	01 c0                	add    %eax,%eax
  800dc4:	01 d8                	add    %ebx,%eax
  800dc6:	83 e8 30             	sub    $0x30,%eax
  800dc9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dd4:	83 fb 2f             	cmp    $0x2f,%ebx
  800dd7:	7e 3e                	jle    800e17 <vprintfmt+0xe9>
  800dd9:	83 fb 39             	cmp    $0x39,%ebx
  800ddc:	7f 39                	jg     800e17 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dde:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800de1:	eb d5                	jmp    800db8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800de3:	8b 45 14             	mov    0x14(%ebp),%eax
  800de6:	83 c0 04             	add    $0x4,%eax
  800de9:	89 45 14             	mov    %eax,0x14(%ebp)
  800dec:	8b 45 14             	mov    0x14(%ebp),%eax
  800def:	83 e8 04             	sub    $0x4,%eax
  800df2:	8b 00                	mov    (%eax),%eax
  800df4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800df7:	eb 1f                	jmp    800e18 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800df9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfd:	79 83                	jns    800d82 <vprintfmt+0x54>
				width = 0;
  800dff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e06:	e9 77 ff ff ff       	jmp    800d82 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e0b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e12:	e9 6b ff ff ff       	jmp    800d82 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e17:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e1c:	0f 89 60 ff ff ff    	jns    800d82 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e28:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e2f:	e9 4e ff ff ff       	jmp    800d82 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e34:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e37:	e9 46 ff ff ff       	jmp    800d82 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3f:	83 c0 04             	add    $0x4,%eax
  800e42:	89 45 14             	mov    %eax,0x14(%ebp)
  800e45:	8b 45 14             	mov    0x14(%ebp),%eax
  800e48:	83 e8 04             	sub    $0x4,%eax
  800e4b:	8b 00                	mov    (%eax),%eax
  800e4d:	83 ec 08             	sub    $0x8,%esp
  800e50:	ff 75 0c             	pushl  0xc(%ebp)
  800e53:	50                   	push   %eax
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	ff d0                	call   *%eax
  800e59:	83 c4 10             	add    $0x10,%esp
			break;
  800e5c:	e9 9b 02 00 00       	jmp    8010fc <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e61:	8b 45 14             	mov    0x14(%ebp),%eax
  800e64:	83 c0 04             	add    $0x4,%eax
  800e67:	89 45 14             	mov    %eax,0x14(%ebp)
  800e6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6d:	83 e8 04             	sub    $0x4,%eax
  800e70:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e72:	85 db                	test   %ebx,%ebx
  800e74:	79 02                	jns    800e78 <vprintfmt+0x14a>
				err = -err;
  800e76:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e78:	83 fb 64             	cmp    $0x64,%ebx
  800e7b:	7f 0b                	jg     800e88 <vprintfmt+0x15a>
  800e7d:	8b 34 9d 80 43 80 00 	mov    0x804380(,%ebx,4),%esi
  800e84:	85 f6                	test   %esi,%esi
  800e86:	75 19                	jne    800ea1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e88:	53                   	push   %ebx
  800e89:	68 25 45 80 00       	push   $0x804525
  800e8e:	ff 75 0c             	pushl  0xc(%ebp)
  800e91:	ff 75 08             	pushl  0x8(%ebp)
  800e94:	e8 70 02 00 00       	call   801109 <printfmt>
  800e99:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e9c:	e9 5b 02 00 00       	jmp    8010fc <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ea1:	56                   	push   %esi
  800ea2:	68 2e 45 80 00       	push   $0x80452e
  800ea7:	ff 75 0c             	pushl  0xc(%ebp)
  800eaa:	ff 75 08             	pushl  0x8(%ebp)
  800ead:	e8 57 02 00 00       	call   801109 <printfmt>
  800eb2:	83 c4 10             	add    $0x10,%esp
			break;
  800eb5:	e9 42 02 00 00       	jmp    8010fc <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800eba:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebd:	83 c0 04             	add    $0x4,%eax
  800ec0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec6:	83 e8 04             	sub    $0x4,%eax
  800ec9:	8b 30                	mov    (%eax),%esi
  800ecb:	85 f6                	test   %esi,%esi
  800ecd:	75 05                	jne    800ed4 <vprintfmt+0x1a6>
				p = "(null)";
  800ecf:	be 31 45 80 00       	mov    $0x804531,%esi
			if (width > 0 && padc != '-')
  800ed4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed8:	7e 6d                	jle    800f47 <vprintfmt+0x219>
  800eda:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ede:	74 67                	je     800f47 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ee0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee3:	83 ec 08             	sub    $0x8,%esp
  800ee6:	50                   	push   %eax
  800ee7:	56                   	push   %esi
  800ee8:	e8 26 05 00 00       	call   801413 <strnlen>
  800eed:	83 c4 10             	add    $0x10,%esp
  800ef0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ef3:	eb 16                	jmp    800f0b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ef5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ef9:	83 ec 08             	sub    $0x8,%esp
  800efc:	ff 75 0c             	pushl  0xc(%ebp)
  800eff:	50                   	push   %eax
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	ff d0                	call   *%eax
  800f05:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f08:	ff 4d e4             	decl   -0x1c(%ebp)
  800f0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0f:	7f e4                	jg     800ef5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f11:	eb 34                	jmp    800f47 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f13:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f17:	74 1c                	je     800f35 <vprintfmt+0x207>
  800f19:	83 fb 1f             	cmp    $0x1f,%ebx
  800f1c:	7e 05                	jle    800f23 <vprintfmt+0x1f5>
  800f1e:	83 fb 7e             	cmp    $0x7e,%ebx
  800f21:	7e 12                	jle    800f35 <vprintfmt+0x207>
					putch('?', putdat);
  800f23:	83 ec 08             	sub    $0x8,%esp
  800f26:	ff 75 0c             	pushl  0xc(%ebp)
  800f29:	6a 3f                	push   $0x3f
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	ff d0                	call   *%eax
  800f30:	83 c4 10             	add    $0x10,%esp
  800f33:	eb 0f                	jmp    800f44 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f35:	83 ec 08             	sub    $0x8,%esp
  800f38:	ff 75 0c             	pushl  0xc(%ebp)
  800f3b:	53                   	push   %ebx
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	ff d0                	call   *%eax
  800f41:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f44:	ff 4d e4             	decl   -0x1c(%ebp)
  800f47:	89 f0                	mov    %esi,%eax
  800f49:	8d 70 01             	lea    0x1(%eax),%esi
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	0f be d8             	movsbl %al,%ebx
  800f51:	85 db                	test   %ebx,%ebx
  800f53:	74 24                	je     800f79 <vprintfmt+0x24b>
  800f55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f59:	78 b8                	js     800f13 <vprintfmt+0x1e5>
  800f5b:	ff 4d e0             	decl   -0x20(%ebp)
  800f5e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f62:	79 af                	jns    800f13 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f64:	eb 13                	jmp    800f79 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f66:	83 ec 08             	sub    $0x8,%esp
  800f69:	ff 75 0c             	pushl  0xc(%ebp)
  800f6c:	6a 20                	push   $0x20
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	ff d0                	call   *%eax
  800f73:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f76:	ff 4d e4             	decl   -0x1c(%ebp)
  800f79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7d:	7f e7                	jg     800f66 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f7f:	e9 78 01 00 00       	jmp    8010fc <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f84:	83 ec 08             	sub    $0x8,%esp
  800f87:	ff 75 e8             	pushl  -0x18(%ebp)
  800f8a:	8d 45 14             	lea    0x14(%ebp),%eax
  800f8d:	50                   	push   %eax
  800f8e:	e8 3c fd ff ff       	call   800ccf <getint>
  800f93:	83 c4 10             	add    $0x10,%esp
  800f96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa2:	85 d2                	test   %edx,%edx
  800fa4:	79 23                	jns    800fc9 <vprintfmt+0x29b>
				putch('-', putdat);
  800fa6:	83 ec 08             	sub    $0x8,%esp
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	6a 2d                	push   $0x2d
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	ff d0                	call   *%eax
  800fb3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fbc:	f7 d8                	neg    %eax
  800fbe:	83 d2 00             	adc    $0x0,%edx
  800fc1:	f7 da                	neg    %edx
  800fc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fc9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fd0:	e9 bc 00 00 00       	jmp    801091 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fd5:	83 ec 08             	sub    $0x8,%esp
  800fd8:	ff 75 e8             	pushl  -0x18(%ebp)
  800fdb:	8d 45 14             	lea    0x14(%ebp),%eax
  800fde:	50                   	push   %eax
  800fdf:	e8 84 fc ff ff       	call   800c68 <getuint>
  800fe4:	83 c4 10             	add    $0x10,%esp
  800fe7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fed:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ff4:	e9 98 00 00 00       	jmp    801091 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	ff 75 0c             	pushl  0xc(%ebp)
  800fff:	6a 58                	push   $0x58
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	ff d0                	call   *%eax
  801006:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801009:	83 ec 08             	sub    $0x8,%esp
  80100c:	ff 75 0c             	pushl  0xc(%ebp)
  80100f:	6a 58                	push   $0x58
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	ff d0                	call   *%eax
  801016:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801019:	83 ec 08             	sub    $0x8,%esp
  80101c:	ff 75 0c             	pushl  0xc(%ebp)
  80101f:	6a 58                	push   $0x58
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	ff d0                	call   *%eax
  801026:	83 c4 10             	add    $0x10,%esp
			break;
  801029:	e9 ce 00 00 00       	jmp    8010fc <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80102e:	83 ec 08             	sub    $0x8,%esp
  801031:	ff 75 0c             	pushl  0xc(%ebp)
  801034:	6a 30                	push   $0x30
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	ff d0                	call   *%eax
  80103b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80103e:	83 ec 08             	sub    $0x8,%esp
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	6a 78                	push   $0x78
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	ff d0                	call   *%eax
  80104b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80104e:	8b 45 14             	mov    0x14(%ebp),%eax
  801051:	83 c0 04             	add    $0x4,%eax
  801054:	89 45 14             	mov    %eax,0x14(%ebp)
  801057:	8b 45 14             	mov    0x14(%ebp),%eax
  80105a:	83 e8 04             	sub    $0x4,%eax
  80105d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80105f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801062:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801069:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801070:	eb 1f                	jmp    801091 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801072:	83 ec 08             	sub    $0x8,%esp
  801075:	ff 75 e8             	pushl  -0x18(%ebp)
  801078:	8d 45 14             	lea    0x14(%ebp),%eax
  80107b:	50                   	push   %eax
  80107c:	e8 e7 fb ff ff       	call   800c68 <getuint>
  801081:	83 c4 10             	add    $0x10,%esp
  801084:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801087:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80108a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801091:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801095:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801098:	83 ec 04             	sub    $0x4,%esp
  80109b:	52                   	push   %edx
  80109c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80109f:	50                   	push   %eax
  8010a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8010a6:	ff 75 0c             	pushl  0xc(%ebp)
  8010a9:	ff 75 08             	pushl  0x8(%ebp)
  8010ac:	e8 00 fb ff ff       	call   800bb1 <printnum>
  8010b1:	83 c4 20             	add    $0x20,%esp
			break;
  8010b4:	eb 46                	jmp    8010fc <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010b6:	83 ec 08             	sub    $0x8,%esp
  8010b9:	ff 75 0c             	pushl  0xc(%ebp)
  8010bc:	53                   	push   %ebx
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	ff d0                	call   *%eax
  8010c2:	83 c4 10             	add    $0x10,%esp
			break;
  8010c5:	eb 35                	jmp    8010fc <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010c7:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  8010ce:	eb 2c                	jmp    8010fc <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010d0:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  8010d7:	eb 23                	jmp    8010fc <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010d9:	83 ec 08             	sub    $0x8,%esp
  8010dc:	ff 75 0c             	pushl  0xc(%ebp)
  8010df:	6a 25                	push   $0x25
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	ff d0                	call   *%eax
  8010e6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010e9:	ff 4d 10             	decl   0x10(%ebp)
  8010ec:	eb 03                	jmp    8010f1 <vprintfmt+0x3c3>
  8010ee:	ff 4d 10             	decl   0x10(%ebp)
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	48                   	dec    %eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	3c 25                	cmp    $0x25,%al
  8010f9:	75 f3                	jne    8010ee <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010fb:	90                   	nop
		}
	}
  8010fc:	e9 35 fc ff ff       	jmp    800d36 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801101:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801102:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801105:	5b                   	pop    %ebx
  801106:	5e                   	pop    %esi
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    

00801109 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80110f:	8d 45 10             	lea    0x10(%ebp),%eax
  801112:	83 c0 04             	add    $0x4,%eax
  801115:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801118:	8b 45 10             	mov    0x10(%ebp),%eax
  80111b:	ff 75 f4             	pushl  -0xc(%ebp)
  80111e:	50                   	push   %eax
  80111f:	ff 75 0c             	pushl  0xc(%ebp)
  801122:	ff 75 08             	pushl  0x8(%ebp)
  801125:	e8 04 fc ff ff       	call   800d2e <vprintfmt>
  80112a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80112d:	90                   	nop
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801133:	8b 45 0c             	mov    0xc(%ebp),%eax
  801136:	8b 40 08             	mov    0x8(%eax),%eax
  801139:	8d 50 01             	lea    0x1(%eax),%edx
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	8b 10                	mov    (%eax),%edx
  801147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114a:	8b 40 04             	mov    0x4(%eax),%eax
  80114d:	39 c2                	cmp    %eax,%edx
  80114f:	73 12                	jae    801163 <sprintputch+0x33>
		*b->buf++ = ch;
  801151:	8b 45 0c             	mov    0xc(%ebp),%eax
  801154:	8b 00                	mov    (%eax),%eax
  801156:	8d 48 01             	lea    0x1(%eax),%ecx
  801159:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115c:	89 0a                	mov    %ecx,(%edx)
  80115e:	8b 55 08             	mov    0x8(%ebp),%edx
  801161:	88 10                	mov    %dl,(%eax)
}
  801163:	90                   	nop
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    

00801166 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	8d 50 ff             	lea    -0x1(%eax),%edx
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	01 d0                	add    %edx,%eax
  80117d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801180:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801187:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80118b:	74 06                	je     801193 <vsnprintf+0x2d>
  80118d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801191:	7f 07                	jg     80119a <vsnprintf+0x34>
		return -E_INVAL;
  801193:	b8 03 00 00 00       	mov    $0x3,%eax
  801198:	eb 20                	jmp    8011ba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80119a:	ff 75 14             	pushl  0x14(%ebp)
  80119d:	ff 75 10             	pushl  0x10(%ebp)
  8011a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011a3:	50                   	push   %eax
  8011a4:	68 30 11 80 00       	push   $0x801130
  8011a9:	e8 80 fb ff ff       	call   800d2e <vprintfmt>
  8011ae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8011c5:	83 c0 04             	add    $0x4,%eax
  8011c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8011d1:	50                   	push   %eax
  8011d2:	ff 75 0c             	pushl  0xc(%ebp)
  8011d5:	ff 75 08             	pushl  0x8(%ebp)
  8011d8:	e8 89 ff ff ff       	call   801166 <vsnprintf>
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    

008011e8 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8011ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f2:	74 13                	je     801207 <readline+0x1f>
		cprintf("%s", prompt);
  8011f4:	83 ec 08             	sub    $0x8,%esp
  8011f7:	ff 75 08             	pushl  0x8(%ebp)
  8011fa:	68 a8 46 80 00       	push   $0x8046a8
  8011ff:	e8 0b f9 ff ff       	call   800b0f <cprintf>
  801204:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801207:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80120e:	83 ec 0c             	sub    $0xc,%esp
  801211:	6a 00                	push   $0x0
  801213:	e8 4f f4 ff ff       	call   800667 <iscons>
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80121e:	e8 31 f4 ff ff       	call   800654 <getchar>
  801223:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801226:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80122a:	79 22                	jns    80124e <readline+0x66>
			if (c != -E_EOF)
  80122c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801230:	0f 84 ad 00 00 00    	je     8012e3 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801236:	83 ec 08             	sub    $0x8,%esp
  801239:	ff 75 ec             	pushl  -0x14(%ebp)
  80123c:	68 ab 46 80 00       	push   $0x8046ab
  801241:	e8 c9 f8 ff ff       	call   800b0f <cprintf>
  801246:	83 c4 10             	add    $0x10,%esp
			break;
  801249:	e9 95 00 00 00       	jmp    8012e3 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80124e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801252:	7e 34                	jle    801288 <readline+0xa0>
  801254:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80125b:	7f 2b                	jg     801288 <readline+0xa0>
			if (echoing)
  80125d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801261:	74 0e                	je     801271 <readline+0x89>
				cputchar(c);
  801263:	83 ec 0c             	sub    $0xc,%esp
  801266:	ff 75 ec             	pushl  -0x14(%ebp)
  801269:	e8 c7 f3 ff ff       	call   800635 <cputchar>
  80126e:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801274:	8d 50 01             	lea    0x1(%eax),%edx
  801277:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80127a:	89 c2                	mov    %eax,%edx
  80127c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127f:	01 d0                	add    %edx,%eax
  801281:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801284:	88 10                	mov    %dl,(%eax)
  801286:	eb 56                	jmp    8012de <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801288:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80128c:	75 1f                	jne    8012ad <readline+0xc5>
  80128e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801292:	7e 19                	jle    8012ad <readline+0xc5>
			if (echoing)
  801294:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801298:	74 0e                	je     8012a8 <readline+0xc0>
				cputchar(c);
  80129a:	83 ec 0c             	sub    $0xc,%esp
  80129d:	ff 75 ec             	pushl  -0x14(%ebp)
  8012a0:	e8 90 f3 ff ff       	call   800635 <cputchar>
  8012a5:	83 c4 10             	add    $0x10,%esp

			i--;
  8012a8:	ff 4d f4             	decl   -0xc(%ebp)
  8012ab:	eb 31                	jmp    8012de <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012ad:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012b1:	74 0a                	je     8012bd <readline+0xd5>
  8012b3:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012b7:	0f 85 61 ff ff ff    	jne    80121e <readline+0x36>
			if (echoing)
  8012bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012c1:	74 0e                	je     8012d1 <readline+0xe9>
				cputchar(c);
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c9:	e8 67 f3 ff ff       	call   800635 <cputchar>
  8012ce:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d7:	01 d0                	add    %edx,%eax
  8012d9:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8012dc:	eb 06                	jmp    8012e4 <readline+0xfc>
		}
	}
  8012de:	e9 3b ff ff ff       	jmp    80121e <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8012e3:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8012e4:	90                   	nop
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8012ed:	e8 81 16 00 00       	call   802973 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f6:	74 13                	je     80130b <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012f8:	83 ec 08             	sub    $0x8,%esp
  8012fb:	ff 75 08             	pushl  0x8(%ebp)
  8012fe:	68 a8 46 80 00       	push   $0x8046a8
  801303:	e8 07 f8 ff ff       	call   800b0f <cprintf>
  801308:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80130b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	6a 00                	push   $0x0
  801317:	e8 4b f3 ff ff       	call   800667 <iscons>
  80131c:	83 c4 10             	add    $0x10,%esp
  80131f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801322:	e8 2d f3 ff ff       	call   800654 <getchar>
  801327:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80132a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80132e:	79 22                	jns    801352 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801330:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801334:	0f 84 ad 00 00 00    	je     8013e7 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  80133a:	83 ec 08             	sub    $0x8,%esp
  80133d:	ff 75 ec             	pushl  -0x14(%ebp)
  801340:	68 ab 46 80 00       	push   $0x8046ab
  801345:	e8 c5 f7 ff ff       	call   800b0f <cprintf>
  80134a:	83 c4 10             	add    $0x10,%esp
				break;
  80134d:	e9 95 00 00 00       	jmp    8013e7 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801352:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801356:	7e 34                	jle    80138c <atomic_readline+0xa5>
  801358:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80135f:	7f 2b                	jg     80138c <atomic_readline+0xa5>
				if (echoing)
  801361:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801365:	74 0e                	je     801375 <atomic_readline+0x8e>
					cputchar(c);
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	ff 75 ec             	pushl  -0x14(%ebp)
  80136d:	e8 c3 f2 ff ff       	call   800635 <cputchar>
  801372:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801378:	8d 50 01             	lea    0x1(%eax),%edx
  80137b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80137e:	89 c2                	mov    %eax,%edx
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	01 d0                	add    %edx,%eax
  801385:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801388:	88 10                	mov    %dl,(%eax)
  80138a:	eb 56                	jmp    8013e2 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80138c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801390:	75 1f                	jne    8013b1 <atomic_readline+0xca>
  801392:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801396:	7e 19                	jle    8013b1 <atomic_readline+0xca>
				if (echoing)
  801398:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80139c:	74 0e                	je     8013ac <atomic_readline+0xc5>
					cputchar(c);
  80139e:	83 ec 0c             	sub    $0xc,%esp
  8013a1:	ff 75 ec             	pushl  -0x14(%ebp)
  8013a4:	e8 8c f2 ff ff       	call   800635 <cputchar>
  8013a9:	83 c4 10             	add    $0x10,%esp
				i--;
  8013ac:	ff 4d f4             	decl   -0xc(%ebp)
  8013af:	eb 31                	jmp    8013e2 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8013b1:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013b5:	74 0a                	je     8013c1 <atomic_readline+0xda>
  8013b7:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013bb:	0f 85 61 ff ff ff    	jne    801322 <atomic_readline+0x3b>
				if (echoing)
  8013c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013c5:	74 0e                	je     8013d5 <atomic_readline+0xee>
					cputchar(c);
  8013c7:	83 ec 0c             	sub    $0xc,%esp
  8013ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8013cd:	e8 63 f2 ff ff       	call   800635 <cputchar>
  8013d2:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8013d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013db:	01 d0                	add    %edx,%eax
  8013dd:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8013e0:	eb 06                	jmp    8013e8 <atomic_readline+0x101>
			}
		}
  8013e2:	e9 3b ff ff ff       	jmp    801322 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8013e7:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8013e8:	e8 a0 15 00 00       	call   80298d <sys_unlock_cons>
}
  8013ed:	90                   	nop
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013fd:	eb 06                	jmp    801405 <strlen+0x15>
		n++;
  8013ff:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801402:	ff 45 08             	incl   0x8(%ebp)
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	84 c0                	test   %al,%al
  80140c:	75 f1                	jne    8013ff <strlen+0xf>
		n++;
	return n;
  80140e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801419:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801420:	eb 09                	jmp    80142b <strnlen+0x18>
		n++;
  801422:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801425:	ff 45 08             	incl   0x8(%ebp)
  801428:	ff 4d 0c             	decl   0xc(%ebp)
  80142b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80142f:	74 09                	je     80143a <strnlen+0x27>
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8a 00                	mov    (%eax),%al
  801436:	84 c0                	test   %al,%al
  801438:	75 e8                	jne    801422 <strnlen+0xf>
		n++;
	return n;
  80143a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80143d:	c9                   	leave  
  80143e:	c3                   	ret    

0080143f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80144b:	90                   	nop
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	8d 50 01             	lea    0x1(%eax),%edx
  801452:	89 55 08             	mov    %edx,0x8(%ebp)
  801455:	8b 55 0c             	mov    0xc(%ebp),%edx
  801458:	8d 4a 01             	lea    0x1(%edx),%ecx
  80145b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80145e:	8a 12                	mov    (%edx),%dl
  801460:	88 10                	mov    %dl,(%eax)
  801462:	8a 00                	mov    (%eax),%al
  801464:	84 c0                	test   %al,%al
  801466:	75 e4                	jne    80144c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801468:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801479:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801480:	eb 1f                	jmp    8014a1 <strncpy+0x34>
		*dst++ = *src;
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8d 50 01             	lea    0x1(%eax),%edx
  801488:	89 55 08             	mov    %edx,0x8(%ebp)
  80148b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148e:	8a 12                	mov    (%edx),%dl
  801490:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801492:	8b 45 0c             	mov    0xc(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 03                	je     80149e <strncpy+0x31>
			src++;
  80149b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80149e:	ff 45 fc             	incl   -0x4(%ebp)
  8014a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014a7:	72 d9                	jb     801482 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014be:	74 30                	je     8014f0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014c0:	eb 16                	jmp    8014d8 <strlcpy+0x2a>
			*dst++ = *src++;
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	8d 50 01             	lea    0x1(%eax),%edx
  8014c8:	89 55 08             	mov    %edx,0x8(%ebp)
  8014cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014d4:	8a 12                	mov    (%edx),%dl
  8014d6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014d8:	ff 4d 10             	decl   0x10(%ebp)
  8014db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014df:	74 09                	je     8014ea <strlcpy+0x3c>
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	84 c0                	test   %al,%al
  8014e8:	75 d8                	jne    8014c2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f6:	29 c2                	sub    %eax,%edx
  8014f8:	89 d0                	mov    %edx,%eax
}
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014ff:	eb 06                	jmp    801507 <strcmp+0xb>
		p++, q++;
  801501:	ff 45 08             	incl   0x8(%ebp)
  801504:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	84 c0                	test   %al,%al
  80150e:	74 0e                	je     80151e <strcmp+0x22>
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	8a 10                	mov    (%eax),%dl
  801515:	8b 45 0c             	mov    0xc(%ebp),%eax
  801518:	8a 00                	mov    (%eax),%al
  80151a:	38 c2                	cmp    %al,%dl
  80151c:	74 e3                	je     801501 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	0f b6 d0             	movzbl %al,%edx
  801526:	8b 45 0c             	mov    0xc(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	0f b6 c0             	movzbl %al,%eax
  80152e:	29 c2                	sub    %eax,%edx
  801530:	89 d0                	mov    %edx,%eax
}
  801532:	5d                   	pop    %ebp
  801533:	c3                   	ret    

00801534 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801537:	eb 09                	jmp    801542 <strncmp+0xe>
		n--, p++, q++;
  801539:	ff 4d 10             	decl   0x10(%ebp)
  80153c:	ff 45 08             	incl   0x8(%ebp)
  80153f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801542:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801546:	74 17                	je     80155f <strncmp+0x2b>
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	84 c0                	test   %al,%al
  80154f:	74 0e                	je     80155f <strncmp+0x2b>
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	8a 10                	mov    (%eax),%dl
  801556:	8b 45 0c             	mov    0xc(%ebp),%eax
  801559:	8a 00                	mov    (%eax),%al
  80155b:	38 c2                	cmp    %al,%dl
  80155d:	74 da                	je     801539 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80155f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801563:	75 07                	jne    80156c <strncmp+0x38>
		return 0;
  801565:	b8 00 00 00 00       	mov    $0x0,%eax
  80156a:	eb 14                	jmp    801580 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	8a 00                	mov    (%eax),%al
  801571:	0f b6 d0             	movzbl %al,%edx
  801574:	8b 45 0c             	mov    0xc(%ebp),%eax
  801577:	8a 00                	mov    (%eax),%al
  801579:	0f b6 c0             	movzbl %al,%eax
  80157c:	29 c2                	sub    %eax,%edx
  80157e:	89 d0                	mov    %edx,%eax
}
  801580:	5d                   	pop    %ebp
  801581:	c3                   	ret    

00801582 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	83 ec 04             	sub    $0x4,%esp
  801588:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80158e:	eb 12                	jmp    8015a2 <strchr+0x20>
		if (*s == c)
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	8a 00                	mov    (%eax),%al
  801595:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801598:	75 05                	jne    80159f <strchr+0x1d>
			return (char *) s;
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	eb 11                	jmp    8015b0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80159f:	ff 45 08             	incl   0x8(%ebp)
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	84 c0                	test   %al,%al
  8015a9:	75 e5                	jne    801590 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	83 ec 04             	sub    $0x4,%esp
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015be:	eb 0d                	jmp    8015cd <strfind+0x1b>
		if (*s == c)
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	8a 00                	mov    (%eax),%al
  8015c5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015c8:	74 0e                	je     8015d8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015ca:	ff 45 08             	incl   0x8(%ebp)
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	84 c0                	test   %al,%al
  8015d4:	75 ea                	jne    8015c0 <strfind+0xe>
  8015d6:	eb 01                	jmp    8015d9 <strfind+0x27>
		if (*s == c)
			break;
  8015d8:	90                   	nop
	return (char *) s;
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8015ea:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015ee:	76 63                	jbe    801653 <memset+0x75>
		uint64 data_block = c;
  8015f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f3:	99                   	cltd   
  8015f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8015fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801600:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801604:	c1 e0 08             	shl    $0x8,%eax
  801607:	09 45 f0             	or     %eax,-0x10(%ebp)
  80160a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80160d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801610:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801613:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801617:	c1 e0 10             	shl    $0x10,%eax
  80161a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80161d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801623:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801626:	89 c2                	mov    %eax,%edx
  801628:	b8 00 00 00 00       	mov    $0x0,%eax
  80162d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801630:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801633:	eb 18                	jmp    80164d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801635:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801638:	8d 41 08             	lea    0x8(%ecx),%eax
  80163b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80163e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801641:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801644:	89 01                	mov    %eax,(%ecx)
  801646:	89 51 04             	mov    %edx,0x4(%ecx)
  801649:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80164d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801651:	77 e2                	ja     801635 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801653:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801657:	74 23                	je     80167c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801659:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80165c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80165f:	eb 0e                	jmp    80166f <memset+0x91>
			*p8++ = (uint8)c;
  801661:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801664:	8d 50 01             	lea    0x1(%eax),%edx
  801667:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80166a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80166f:	8b 45 10             	mov    0x10(%ebp),%eax
  801672:	8d 50 ff             	lea    -0x1(%eax),%edx
  801675:	89 55 10             	mov    %edx,0x10(%ebp)
  801678:	85 c0                	test   %eax,%eax
  80167a:	75 e5                	jne    801661 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801693:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801697:	76 24                	jbe    8016bd <memcpy+0x3c>
		while(n >= 8){
  801699:	eb 1c                	jmp    8016b7 <memcpy+0x36>
			*d64 = *s64;
  80169b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80169e:	8b 50 04             	mov    0x4(%eax),%edx
  8016a1:	8b 00                	mov    (%eax),%eax
  8016a3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016a6:	89 01                	mov    %eax,(%ecx)
  8016a8:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8016ab:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8016af:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8016b3:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8016b7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8016bb:	77 de                	ja     80169b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8016bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c1:	74 31                	je     8016f4 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8016c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8016c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8016cf:	eb 16                	jmp    8016e7 <memcpy+0x66>
			*d8++ = *s8++;
  8016d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d4:	8d 50 01             	lea    0x1(%eax),%edx
  8016d7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8016da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016dd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016e0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8016e3:	8a 12                	mov    (%edx),%dl
  8016e5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8016e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016ed:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	75 dd                	jne    8016d1 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801702:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
  801708:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80170b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80170e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801711:	73 50                	jae    801763 <memmove+0x6a>
  801713:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801716:	8b 45 10             	mov    0x10(%ebp),%eax
  801719:	01 d0                	add    %edx,%eax
  80171b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80171e:	76 43                	jbe    801763 <memmove+0x6a>
		s += n;
  801720:	8b 45 10             	mov    0x10(%ebp),%eax
  801723:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801726:	8b 45 10             	mov    0x10(%ebp),%eax
  801729:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80172c:	eb 10                	jmp    80173e <memmove+0x45>
			*--d = *--s;
  80172e:	ff 4d f8             	decl   -0x8(%ebp)
  801731:	ff 4d fc             	decl   -0x4(%ebp)
  801734:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801737:	8a 10                	mov    (%eax),%dl
  801739:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80173e:	8b 45 10             	mov    0x10(%ebp),%eax
  801741:	8d 50 ff             	lea    -0x1(%eax),%edx
  801744:	89 55 10             	mov    %edx,0x10(%ebp)
  801747:	85 c0                	test   %eax,%eax
  801749:	75 e3                	jne    80172e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80174b:	eb 23                	jmp    801770 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80174d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801750:	8d 50 01             	lea    0x1(%eax),%edx
  801753:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801756:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801759:	8d 4a 01             	lea    0x1(%edx),%ecx
  80175c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80175f:	8a 12                	mov    (%edx),%dl
  801761:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801763:	8b 45 10             	mov    0x10(%ebp),%eax
  801766:	8d 50 ff             	lea    -0x1(%eax),%edx
  801769:	89 55 10             	mov    %edx,0x10(%ebp)
  80176c:	85 c0                	test   %eax,%eax
  80176e:	75 dd                	jne    80174d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801781:	8b 45 0c             	mov    0xc(%ebp),%eax
  801784:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801787:	eb 2a                	jmp    8017b3 <memcmp+0x3e>
		if (*s1 != *s2)
  801789:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80178c:	8a 10                	mov    (%eax),%dl
  80178e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801791:	8a 00                	mov    (%eax),%al
  801793:	38 c2                	cmp    %al,%dl
  801795:	74 16                	je     8017ad <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801797:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	0f b6 d0             	movzbl %al,%edx
  80179f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	0f b6 c0             	movzbl %al,%eax
  8017a7:	29 c2                	sub    %eax,%edx
  8017a9:	89 d0                	mov    %edx,%eax
  8017ab:	eb 18                	jmp    8017c5 <memcmp+0x50>
		s1++, s2++;
  8017ad:	ff 45 fc             	incl   -0x4(%ebp)
  8017b0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8017bc:	85 c0                	test   %eax,%eax
  8017be:	75 c9                	jne    801789 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8017cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d3:	01 d0                	add    %edx,%eax
  8017d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8017d8:	eb 15                	jmp    8017ef <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8a 00                	mov    (%eax),%al
  8017df:	0f b6 d0             	movzbl %al,%edx
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	0f b6 c0             	movzbl %al,%eax
  8017e8:	39 c2                	cmp    %eax,%edx
  8017ea:	74 0d                	je     8017f9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017ec:	ff 45 08             	incl   0x8(%ebp)
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017f5:	72 e3                	jb     8017da <memfind+0x13>
  8017f7:	eb 01                	jmp    8017fa <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8017f9:	90                   	nop
	return (void *) s;
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801805:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80180c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801813:	eb 03                	jmp    801818 <strtol+0x19>
		s++;
  801815:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	8a 00                	mov    (%eax),%al
  80181d:	3c 20                	cmp    $0x20,%al
  80181f:	74 f4                	je     801815 <strtol+0x16>
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	8a 00                	mov    (%eax),%al
  801826:	3c 09                	cmp    $0x9,%al
  801828:	74 eb                	je     801815 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	8a 00                	mov    (%eax),%al
  80182f:	3c 2b                	cmp    $0x2b,%al
  801831:	75 05                	jne    801838 <strtol+0x39>
		s++;
  801833:	ff 45 08             	incl   0x8(%ebp)
  801836:	eb 13                	jmp    80184b <strtol+0x4c>
	else if (*s == '-')
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8a 00                	mov    (%eax),%al
  80183d:	3c 2d                	cmp    $0x2d,%al
  80183f:	75 0a                	jne    80184b <strtol+0x4c>
		s++, neg = 1;
  801841:	ff 45 08             	incl   0x8(%ebp)
  801844:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80184b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80184f:	74 06                	je     801857 <strtol+0x58>
  801851:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801855:	75 20                	jne    801877 <strtol+0x78>
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 30                	cmp    $0x30,%al
  80185e:	75 17                	jne    801877 <strtol+0x78>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	40                   	inc    %eax
  801864:	8a 00                	mov    (%eax),%al
  801866:	3c 78                	cmp    $0x78,%al
  801868:	75 0d                	jne    801877 <strtol+0x78>
		s += 2, base = 16;
  80186a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80186e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801875:	eb 28                	jmp    80189f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801877:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80187b:	75 15                	jne    801892 <strtol+0x93>
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	8a 00                	mov    (%eax),%al
  801882:	3c 30                	cmp    $0x30,%al
  801884:	75 0c                	jne    801892 <strtol+0x93>
		s++, base = 8;
  801886:	ff 45 08             	incl   0x8(%ebp)
  801889:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801890:	eb 0d                	jmp    80189f <strtol+0xa0>
	else if (base == 0)
  801892:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801896:	75 07                	jne    80189f <strtol+0xa0>
		base = 10;
  801898:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	8a 00                	mov    (%eax),%al
  8018a4:	3c 2f                	cmp    $0x2f,%al
  8018a6:	7e 19                	jle    8018c1 <strtol+0xc2>
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	8a 00                	mov    (%eax),%al
  8018ad:	3c 39                	cmp    $0x39,%al
  8018af:	7f 10                	jg     8018c1 <strtol+0xc2>
			dig = *s - '0';
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	8a 00                	mov    (%eax),%al
  8018b6:	0f be c0             	movsbl %al,%eax
  8018b9:	83 e8 30             	sub    $0x30,%eax
  8018bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018bf:	eb 42                	jmp    801903 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	8a 00                	mov    (%eax),%al
  8018c6:	3c 60                	cmp    $0x60,%al
  8018c8:	7e 19                	jle    8018e3 <strtol+0xe4>
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	8a 00                	mov    (%eax),%al
  8018cf:	3c 7a                	cmp    $0x7a,%al
  8018d1:	7f 10                	jg     8018e3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	8a 00                	mov    (%eax),%al
  8018d8:	0f be c0             	movsbl %al,%eax
  8018db:	83 e8 57             	sub    $0x57,%eax
  8018de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018e1:	eb 20                	jmp    801903 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	8a 00                	mov    (%eax),%al
  8018e8:	3c 40                	cmp    $0x40,%al
  8018ea:	7e 39                	jle    801925 <strtol+0x126>
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	8a 00                	mov    (%eax),%al
  8018f1:	3c 5a                	cmp    $0x5a,%al
  8018f3:	7f 30                	jg     801925 <strtol+0x126>
			dig = *s - 'A' + 10;
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	8a 00                	mov    (%eax),%al
  8018fa:	0f be c0             	movsbl %al,%eax
  8018fd:	83 e8 37             	sub    $0x37,%eax
  801900:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801906:	3b 45 10             	cmp    0x10(%ebp),%eax
  801909:	7d 19                	jge    801924 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80190b:	ff 45 08             	incl   0x8(%ebp)
  80190e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801911:	0f af 45 10          	imul   0x10(%ebp),%eax
  801915:	89 c2                	mov    %eax,%edx
  801917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191a:	01 d0                	add    %edx,%eax
  80191c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80191f:	e9 7b ff ff ff       	jmp    80189f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801924:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801925:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801929:	74 08                	je     801933 <strtol+0x134>
		*endptr = (char *) s;
  80192b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192e:	8b 55 08             	mov    0x8(%ebp),%edx
  801931:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801933:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801937:	74 07                	je     801940 <strtol+0x141>
  801939:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80193c:	f7 d8                	neg    %eax
  80193e:	eb 03                	jmp    801943 <strtol+0x144>
  801940:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <ltostr>:

void
ltostr(long value, char *str)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80194b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801952:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801959:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80195d:	79 13                	jns    801972 <ltostr+0x2d>
	{
		neg = 1;
  80195f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801966:	8b 45 0c             	mov    0xc(%ebp),%eax
  801969:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80196c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80196f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80197a:	99                   	cltd   
  80197b:	f7 f9                	idiv   %ecx
  80197d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801980:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801983:	8d 50 01             	lea    0x1(%eax),%edx
  801986:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801989:	89 c2                	mov    %eax,%edx
  80198b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198e:	01 d0                	add    %edx,%eax
  801990:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801993:	83 c2 30             	add    $0x30,%edx
  801996:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801998:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80199b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019a0:	f7 e9                	imul   %ecx
  8019a2:	c1 fa 02             	sar    $0x2,%edx
  8019a5:	89 c8                	mov    %ecx,%eax
  8019a7:	c1 f8 1f             	sar    $0x1f,%eax
  8019aa:	29 c2                	sub    %eax,%edx
  8019ac:	89 d0                	mov    %edx,%eax
  8019ae:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8019b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019b5:	75 bb                	jne    801972 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8019b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8019be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c1:	48                   	dec    %eax
  8019c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8019c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019c9:	74 3d                	je     801a08 <ltostr+0xc3>
		start = 1 ;
  8019cb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8019d2:	eb 34                	jmp    801a08 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8019d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019da:	01 d0                	add    %edx,%eax
  8019dc:	8a 00                	mov    (%eax),%al
  8019de:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8019e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e7:	01 c2                	add    %eax,%edx
  8019e9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ef:	01 c8                	add    %ecx,%eax
  8019f1:	8a 00                	mov    (%eax),%al
  8019f3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fb:	01 c2                	add    %eax,%edx
  8019fd:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a00:	88 02                	mov    %al,(%edx)
		start++ ;
  801a02:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a05:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a0e:	7c c4                	jl     8019d4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a10:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a16:	01 d0                	add    %edx,%eax
  801a18:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a1b:	90                   	nop
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a24:	ff 75 08             	pushl  0x8(%ebp)
  801a27:	e8 c4 f9 ff ff       	call   8013f0 <strlen>
  801a2c:	83 c4 04             	add    $0x4,%esp
  801a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	e8 b6 f9 ff ff       	call   8013f0 <strlen>
  801a3a:	83 c4 04             	add    $0x4,%esp
  801a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a4e:	eb 17                	jmp    801a67 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a50:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a53:	8b 45 10             	mov    0x10(%ebp),%eax
  801a56:	01 c2                	add    %eax,%edx
  801a58:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	01 c8                	add    %ecx,%eax
  801a60:	8a 00                	mov    (%eax),%al
  801a62:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a64:	ff 45 fc             	incl   -0x4(%ebp)
  801a67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a6a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a6d:	7c e1                	jl     801a50 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a6f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a76:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a7d:	eb 1f                	jmp    801a9e <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a82:	8d 50 01             	lea    0x1(%eax),%edx
  801a85:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a88:	89 c2                	mov    %eax,%edx
  801a8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8d:	01 c2                	add    %eax,%edx
  801a8f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a95:	01 c8                	add    %ecx,%eax
  801a97:	8a 00                	mov    (%eax),%al
  801a99:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a9b:	ff 45 f8             	incl   -0x8(%ebp)
  801a9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801aa4:	7c d9                	jl     801a7f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801aa6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa9:	8b 45 10             	mov    0x10(%ebp),%eax
  801aac:	01 d0                	add    %edx,%eax
  801aae:	c6 00 00             	movb   $0x0,(%eax)
}
  801ab1:	90                   	nop
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac3:	8b 00                	mov    (%eax),%eax
  801ac5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801acc:	8b 45 10             	mov    0x10(%ebp),%eax
  801acf:	01 d0                	add    %edx,%eax
  801ad1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ad7:	eb 0c                	jmp    801ae5 <strsplit+0x31>
			*string++ = 0;
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	8d 50 01             	lea    0x1(%eax),%edx
  801adf:	89 55 08             	mov    %edx,0x8(%ebp)
  801ae2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	8a 00                	mov    (%eax),%al
  801aea:	84 c0                	test   %al,%al
  801aec:	74 18                	je     801b06 <strsplit+0x52>
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	8a 00                	mov    (%eax),%al
  801af3:	0f be c0             	movsbl %al,%eax
  801af6:	50                   	push   %eax
  801af7:	ff 75 0c             	pushl  0xc(%ebp)
  801afa:	e8 83 fa ff ff       	call   801582 <strchr>
  801aff:	83 c4 08             	add    $0x8,%esp
  801b02:	85 c0                	test   %eax,%eax
  801b04:	75 d3                	jne    801ad9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	8a 00                	mov    (%eax),%al
  801b0b:	84 c0                	test   %al,%al
  801b0d:	74 5a                	je     801b69 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b0f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b12:	8b 00                	mov    (%eax),%eax
  801b14:	83 f8 0f             	cmp    $0xf,%eax
  801b17:	75 07                	jne    801b20 <strsplit+0x6c>
		{
			return 0;
  801b19:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1e:	eb 66                	jmp    801b86 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b20:	8b 45 14             	mov    0x14(%ebp),%eax
  801b23:	8b 00                	mov    (%eax),%eax
  801b25:	8d 48 01             	lea    0x1(%eax),%ecx
  801b28:	8b 55 14             	mov    0x14(%ebp),%edx
  801b2b:	89 0a                	mov    %ecx,(%edx)
  801b2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b34:	8b 45 10             	mov    0x10(%ebp),%eax
  801b37:	01 c2                	add    %eax,%edx
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b3e:	eb 03                	jmp    801b43 <strsplit+0x8f>
			string++;
  801b40:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	8a 00                	mov    (%eax),%al
  801b48:	84 c0                	test   %al,%al
  801b4a:	74 8b                	je     801ad7 <strsplit+0x23>
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	8a 00                	mov    (%eax),%al
  801b51:	0f be c0             	movsbl %al,%eax
  801b54:	50                   	push   %eax
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	e8 25 fa ff ff       	call   801582 <strchr>
  801b5d:	83 c4 08             	add    $0x8,%esp
  801b60:	85 c0                	test   %eax,%eax
  801b62:	74 dc                	je     801b40 <strsplit+0x8c>
			string++;
	}
  801b64:	e9 6e ff ff ff       	jmp    801ad7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b69:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6d:	8b 00                	mov    (%eax),%eax
  801b6f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b76:	8b 45 10             	mov    0x10(%ebp),%eax
  801b79:	01 d0                	add    %edx,%eax
  801b7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b81:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801b94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b9b:	eb 4a                	jmp    801be7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801b9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	01 c2                	add    %eax,%edx
  801ba5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bab:	01 c8                	add    %ecx,%eax
  801bad:	8a 00                	mov    (%eax),%al
  801baf:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801bb1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb7:	01 d0                	add    %edx,%eax
  801bb9:	8a 00                	mov    (%eax),%al
  801bbb:	3c 40                	cmp    $0x40,%al
  801bbd:	7e 25                	jle    801be4 <str2lower+0x5c>
  801bbf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc5:	01 d0                	add    %edx,%eax
  801bc7:	8a 00                	mov    (%eax),%al
  801bc9:	3c 5a                	cmp    $0x5a,%al
  801bcb:	7f 17                	jg     801be4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801bcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	01 d0                	add    %edx,%eax
  801bd5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  801bdb:	01 ca                	add    %ecx,%edx
  801bdd:	8a 12                	mov    (%edx),%dl
  801bdf:	83 c2 20             	add    $0x20,%edx
  801be2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801be4:	ff 45 fc             	incl   -0x4(%ebp)
  801be7:	ff 75 0c             	pushl  0xc(%ebp)
  801bea:	e8 01 f8 ff ff       	call   8013f0 <strlen>
  801bef:	83 c4 04             	add    $0x4,%esp
  801bf2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bf5:	7f a6                	jg     801b9d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801bf7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801c02:	83 ec 0c             	sub    $0xc,%esp
  801c05:	6a 10                	push   $0x10
  801c07:	e8 b2 15 00 00       	call   8031be <alloc_block>
  801c0c:	83 c4 10             	add    $0x10,%esp
  801c0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801c12:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c16:	75 14                	jne    801c2c <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801c18:	83 ec 04             	sub    $0x4,%esp
  801c1b:	68 bc 46 80 00       	push   $0x8046bc
  801c20:	6a 14                	push   $0x14
  801c22:	68 e5 46 80 00       	push   $0x8046e5
  801c27:	e8 f5 eb ff ff       	call   800821 <_panic>

	node->start = start;
  801c2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c2f:	8b 55 08             	mov    0x8(%ebp),%edx
  801c32:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3a:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801c3d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801c44:	a1 28 50 80 00       	mov    0x805028,%eax
  801c49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c4c:	eb 18                	jmp    801c66 <insert_page_alloc+0x6a>
		if (start < it->start)
  801c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c51:	8b 00                	mov    (%eax),%eax
  801c53:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c56:	77 37                	ja     801c8f <insert_page_alloc+0x93>
			break;
		prev = it;
  801c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801c5e:	a1 30 50 80 00       	mov    0x805030,%eax
  801c63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c6a:	74 08                	je     801c74 <insert_page_alloc+0x78>
  801c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6f:	8b 40 08             	mov    0x8(%eax),%eax
  801c72:	eb 05                	jmp    801c79 <insert_page_alloc+0x7d>
  801c74:	b8 00 00 00 00       	mov    $0x0,%eax
  801c79:	a3 30 50 80 00       	mov    %eax,0x805030
  801c7e:	a1 30 50 80 00       	mov    0x805030,%eax
  801c83:	85 c0                	test   %eax,%eax
  801c85:	75 c7                	jne    801c4e <insert_page_alloc+0x52>
  801c87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c8b:	75 c1                	jne    801c4e <insert_page_alloc+0x52>
  801c8d:	eb 01                	jmp    801c90 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801c8f:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801c90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c94:	75 64                	jne    801cfa <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801c96:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c9a:	75 14                	jne    801cb0 <insert_page_alloc+0xb4>
  801c9c:	83 ec 04             	sub    $0x4,%esp
  801c9f:	68 f4 46 80 00       	push   $0x8046f4
  801ca4:	6a 21                	push   $0x21
  801ca6:	68 e5 46 80 00       	push   $0x8046e5
  801cab:	e8 71 eb ff ff       	call   800821 <_panic>
  801cb0:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb9:	89 50 08             	mov    %edx,0x8(%eax)
  801cbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cbf:	8b 40 08             	mov    0x8(%eax),%eax
  801cc2:	85 c0                	test   %eax,%eax
  801cc4:	74 0d                	je     801cd3 <insert_page_alloc+0xd7>
  801cc6:	a1 28 50 80 00       	mov    0x805028,%eax
  801ccb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cce:	89 50 0c             	mov    %edx,0xc(%eax)
  801cd1:	eb 08                	jmp    801cdb <insert_page_alloc+0xdf>
  801cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cde:	a3 28 50 80 00       	mov    %eax,0x805028
  801ce3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ce6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801ced:	a1 34 50 80 00       	mov    0x805034,%eax
  801cf2:	40                   	inc    %eax
  801cf3:	a3 34 50 80 00       	mov    %eax,0x805034
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801cf8:	eb 71                	jmp    801d6b <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801cfa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cfe:	74 06                	je     801d06 <insert_page_alloc+0x10a>
  801d00:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d04:	75 14                	jne    801d1a <insert_page_alloc+0x11e>
  801d06:	83 ec 04             	sub    $0x4,%esp
  801d09:	68 18 47 80 00       	push   $0x804718
  801d0e:	6a 23                	push   $0x23
  801d10:	68 e5 46 80 00       	push   $0x8046e5
  801d15:	e8 07 eb ff ff       	call   800821 <_panic>
  801d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1d:	8b 50 08             	mov    0x8(%eax),%edx
  801d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d23:	89 50 08             	mov    %edx,0x8(%eax)
  801d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d29:	8b 40 08             	mov    0x8(%eax),%eax
  801d2c:	85 c0                	test   %eax,%eax
  801d2e:	74 0c                	je     801d3c <insert_page_alloc+0x140>
  801d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d33:	8b 40 08             	mov    0x8(%eax),%eax
  801d36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d39:	89 50 0c             	mov    %edx,0xc(%eax)
  801d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d42:	89 50 08             	mov    %edx,0x8(%eax)
  801d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d4b:	89 50 0c             	mov    %edx,0xc(%eax)
  801d4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d51:	8b 40 08             	mov    0x8(%eax),%eax
  801d54:	85 c0                	test   %eax,%eax
  801d56:	75 08                	jne    801d60 <insert_page_alloc+0x164>
  801d58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d5b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801d60:	a1 34 50 80 00       	mov    0x805034,%eax
  801d65:	40                   	inc    %eax
  801d66:	a3 34 50 80 00       	mov    %eax,0x805034
}
  801d6b:	90                   	nop
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801d74:	a1 28 50 80 00       	mov    0x805028,%eax
  801d79:	85 c0                	test   %eax,%eax
  801d7b:	75 0c                	jne    801d89 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801d7d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d82:	a3 6c d0 81 00       	mov    %eax,0x81d06c
		return;
  801d87:	eb 67                	jmp    801df0 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801d89:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801d91:	a1 28 50 80 00       	mov    0x805028,%eax
  801d96:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801d99:	eb 26                	jmp    801dc1 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801d9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d9e:	8b 10                	mov    (%eax),%edx
  801da0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801da3:	8b 40 04             	mov    0x4(%eax),%eax
  801da6:	01 d0                	add    %edx,%eax
  801da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801db1:	76 06                	jbe    801db9 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801db9:	a1 30 50 80 00       	mov    0x805030,%eax
  801dbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801dc1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801dc5:	74 08                	je     801dcf <recompute_page_alloc_break+0x61>
  801dc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dca:	8b 40 08             	mov    0x8(%eax),%eax
  801dcd:	eb 05                	jmp    801dd4 <recompute_page_alloc_break+0x66>
  801dcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd4:	a3 30 50 80 00       	mov    %eax,0x805030
  801dd9:	a1 30 50 80 00       	mov    0x805030,%eax
  801dde:	85 c0                	test   %eax,%eax
  801de0:	75 b9                	jne    801d9b <recompute_page_alloc_break+0x2d>
  801de2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801de6:	75 b3                	jne    801d9b <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801de8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801deb:	a3 6c d0 81 00       	mov    %eax,0x81d06c
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801df8:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801dff:	8b 55 08             	mov    0x8(%ebp),%edx
  801e02:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e05:	01 d0                	add    %edx,%eax
  801e07:	48                   	dec    %eax
  801e08:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801e0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e13:	f7 75 d8             	divl   -0x28(%ebp)
  801e16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e19:	29 d0                	sub    %edx,%eax
  801e1b:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801e1e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801e22:	75 0a                	jne    801e2e <alloc_pages_custom_fit+0x3c>
		return NULL;
  801e24:	b8 00 00 00 00       	mov    $0x0,%eax
  801e29:	e9 7e 01 00 00       	jmp    801fac <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801e2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801e35:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801e39:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801e40:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801e47:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801e4f:	a1 28 50 80 00       	mov    0x805028,%eax
  801e54:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e57:	eb 69                	jmp    801ec2 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801e59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e5c:	8b 00                	mov    (%eax),%eax
  801e5e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e61:	76 47                	jbe    801eaa <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e66:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801e69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e6c:	8b 00                	mov    (%eax),%eax
  801e6e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801e71:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801e74:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e77:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e7a:	72 2e                	jb     801eaa <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801e7c:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801e80:	75 14                	jne    801e96 <alloc_pages_custom_fit+0xa4>
  801e82:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e85:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e88:	75 0c                	jne    801e96 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801e8a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801e90:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801e94:	eb 14                	jmp    801eaa <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801e96:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e99:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e9c:	76 0c                	jbe    801eaa <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801e9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ea1:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801ea4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ea7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801eaa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ead:	8b 10                	mov    (%eax),%edx
  801eaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eb2:	8b 40 04             	mov    0x4(%eax),%eax
  801eb5:	01 d0                	add    %edx,%eax
  801eb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801eba:	a1 30 50 80 00       	mov    0x805030,%eax
  801ebf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801ec2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ec6:	74 08                	je     801ed0 <alloc_pages_custom_fit+0xde>
  801ec8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ecb:	8b 40 08             	mov    0x8(%eax),%eax
  801ece:	eb 05                	jmp    801ed5 <alloc_pages_custom_fit+0xe3>
  801ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed5:	a3 30 50 80 00       	mov    %eax,0x805030
  801eda:	a1 30 50 80 00       	mov    0x805030,%eax
  801edf:	85 c0                	test   %eax,%eax
  801ee1:	0f 85 72 ff ff ff    	jne    801e59 <alloc_pages_custom_fit+0x67>
  801ee7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801eeb:	0f 85 68 ff ff ff    	jne    801e59 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801ef1:	a1 6c d0 81 00       	mov    0x81d06c,%eax
  801ef6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ef9:	76 47                	jbe    801f42 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801efb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801efe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801f01:	a1 6c d0 81 00       	mov    0x81d06c,%eax
  801f06:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801f09:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801f0c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f0f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801f12:	72 2e                	jb     801f42 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801f14:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801f18:	75 14                	jne    801f2e <alloc_pages_custom_fit+0x13c>
  801f1a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f1d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801f20:	75 0c                	jne    801f2e <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801f22:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801f28:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801f2c:	eb 14                	jmp    801f42 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801f2e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f31:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f34:	76 0c                	jbe    801f42 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801f36:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f39:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801f3c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801f42:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801f49:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801f4d:	74 08                	je     801f57 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f52:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801f55:	eb 40                	jmp    801f97 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801f57:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f5b:	74 08                	je     801f65 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f60:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801f63:	eb 32                	jmp    801f97 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801f65:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801f6a:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801f6d:	89 c2                	mov    %eax,%edx
  801f6f:	a1 6c d0 81 00       	mov    0x81d06c,%eax
  801f74:	39 c2                	cmp    %eax,%edx
  801f76:	73 07                	jae    801f7f <alloc_pages_custom_fit+0x18d>
			return NULL;
  801f78:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7d:	eb 2d                	jmp    801fac <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801f7f:	a1 6c d0 81 00       	mov    0x81d06c,%eax
  801f84:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801f87:	8b 15 6c d0 81 00    	mov    0x81d06c,%edx
  801f8d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f90:	01 d0                	add    %edx,%eax
  801f92:	a3 6c d0 81 00       	mov    %eax,0x81d06c
	}


	insert_page_alloc((uint32)result, required_size);
  801f97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f9a:	83 ec 08             	sub    $0x8,%esp
  801f9d:	ff 75 d0             	pushl  -0x30(%ebp)
  801fa0:	50                   	push   %eax
  801fa1:	e8 56 fc ff ff       	call   801bfc <insert_page_alloc>
  801fa6:	83 c4 10             	add    $0x10,%esp

	return result;
  801fa9:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801fba:	a1 28 50 80 00       	mov    0x805028,%eax
  801fbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fc2:	eb 1a                	jmp    801fde <find_allocated_size+0x30>
		if (it->start == va)
  801fc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc7:	8b 00                	mov    (%eax),%eax
  801fc9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fcc:	75 08                	jne    801fd6 <find_allocated_size+0x28>
			return it->size;
  801fce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fd1:	8b 40 04             	mov    0x4(%eax),%eax
  801fd4:	eb 34                	jmp    80200a <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801fd6:	a1 30 50 80 00       	mov    0x805030,%eax
  801fdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fde:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fe2:	74 08                	je     801fec <find_allocated_size+0x3e>
  801fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe7:	8b 40 08             	mov    0x8(%eax),%eax
  801fea:	eb 05                	jmp    801ff1 <find_allocated_size+0x43>
  801fec:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff1:	a3 30 50 80 00       	mov    %eax,0x805030
  801ff6:	a1 30 50 80 00       	mov    0x805030,%eax
  801ffb:	85 c0                	test   %eax,%eax
  801ffd:	75 c5                	jne    801fc4 <find_allocated_size+0x16>
  801fff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802003:	75 bf                	jne    801fc4 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802018:	a1 28 50 80 00       	mov    0x805028,%eax
  80201d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802020:	e9 e1 01 00 00       	jmp    802206 <free_pages+0x1fa>
		if (it->start == va) {
  802025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802028:	8b 00                	mov    (%eax),%eax
  80202a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80202d:	0f 85 cb 01 00 00    	jne    8021fe <free_pages+0x1f2>

			uint32 start = it->start;
  802033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802036:	8b 00                	mov    (%eax),%eax
  802038:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  80203b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203e:	8b 40 04             	mov    0x4(%eax),%eax
  802041:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  802044:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802047:	f7 d0                	not    %eax
  802049:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80204c:	73 1d                	jae    80206b <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  80204e:	83 ec 0c             	sub    $0xc,%esp
  802051:	ff 75 e4             	pushl  -0x1c(%ebp)
  802054:	ff 75 e8             	pushl  -0x18(%ebp)
  802057:	68 4c 47 80 00       	push   $0x80474c
  80205c:	68 a5 00 00 00       	push   $0xa5
  802061:	68 e5 46 80 00       	push   $0x8046e5
  802066:	e8 b6 e7 ff ff       	call   800821 <_panic>
			}

			uint32 start_end = start + size;
  80206b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80206e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802071:	01 d0                	add    %edx,%eax
  802073:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  802076:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802079:	85 c0                	test   %eax,%eax
  80207b:	79 19                	jns    802096 <free_pages+0x8a>
  80207d:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802084:	77 10                	ja     802096 <free_pages+0x8a>
  802086:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  80208d:	77 07                	ja     802096 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  80208f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802092:	85 c0                	test   %eax,%eax
  802094:	78 2c                	js     8020c2 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  802096:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802099:	83 ec 0c             	sub    $0xc,%esp
  80209c:	68 00 00 00 a0       	push   $0xa0000000
  8020a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8020a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8020aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020ad:	50                   	push   %eax
  8020ae:	68 90 47 80 00       	push   $0x804790
  8020b3:	68 ad 00 00 00       	push   $0xad
  8020b8:	68 e5 46 80 00       	push   $0x8046e5
  8020bd:	e8 5f e7 ff ff       	call   800821 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8020c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020c8:	e9 88 00 00 00       	jmp    802155 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  8020cd:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  8020d4:	76 17                	jbe    8020ed <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  8020d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8020d9:	68 f4 47 80 00       	push   $0x8047f4
  8020de:	68 b4 00 00 00       	push   $0xb4
  8020e3:	68 e5 46 80 00       	push   $0x8046e5
  8020e8:	e8 34 e7 ff ff       	call   800821 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  8020ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f0:	05 00 10 00 00       	add    $0x1000,%eax
  8020f5:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  8020f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fb:	85 c0                	test   %eax,%eax
  8020fd:	79 2e                	jns    80212d <free_pages+0x121>
  8020ff:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802106:	77 25                	ja     80212d <free_pages+0x121>
  802108:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  80210f:	77 1c                	ja     80212d <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  802111:	83 ec 08             	sub    $0x8,%esp
  802114:	68 00 10 00 00       	push   $0x1000
  802119:	ff 75 f0             	pushl  -0x10(%ebp)
  80211c:	e8 38 0d 00 00       	call   802e59 <sys_free_user_mem>
  802121:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802124:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80212b:	eb 28                	jmp    802155 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  80212d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802130:	68 00 00 00 a0       	push   $0xa0000000
  802135:	ff 75 dc             	pushl  -0x24(%ebp)
  802138:	68 00 10 00 00       	push   $0x1000
  80213d:	ff 75 f0             	pushl  -0x10(%ebp)
  802140:	50                   	push   %eax
  802141:	68 34 48 80 00       	push   $0x804834
  802146:	68 bd 00 00 00       	push   $0xbd
  80214b:	68 e5 46 80 00       	push   $0x8046e5
  802150:	e8 cc e6 ff ff       	call   800821 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802158:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80215b:	0f 82 6c ff ff ff    	jb     8020cd <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802161:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802165:	75 17                	jne    80217e <free_pages+0x172>
  802167:	83 ec 04             	sub    $0x4,%esp
  80216a:	68 96 48 80 00       	push   $0x804896
  80216f:	68 c1 00 00 00       	push   $0xc1
  802174:	68 e5 46 80 00       	push   $0x8046e5
  802179:	e8 a3 e6 ff ff       	call   800821 <_panic>
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	8b 40 08             	mov    0x8(%eax),%eax
  802184:	85 c0                	test   %eax,%eax
  802186:	74 11                	je     802199 <free_pages+0x18d>
  802188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218b:	8b 40 08             	mov    0x8(%eax),%eax
  80218e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802191:	8b 52 0c             	mov    0xc(%edx),%edx
  802194:	89 50 0c             	mov    %edx,0xc(%eax)
  802197:	eb 0b                	jmp    8021a4 <free_pages+0x198>
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 40 0c             	mov    0xc(%eax),%eax
  80219f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	74 11                	je     8021bf <free_pages+0x1b3>
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b7:	8b 52 08             	mov    0x8(%edx),%edx
  8021ba:	89 50 08             	mov    %edx,0x8(%eax)
  8021bd:	eb 0b                	jmp    8021ca <free_pages+0x1be>
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	8b 40 08             	mov    0x8(%eax),%eax
  8021c5:	a3 28 50 80 00       	mov    %eax,0x805028
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8021d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8021de:	a1 34 50 80 00       	mov    0x805034,%eax
  8021e3:	48                   	dec    %eax
  8021e4:	a3 34 50 80 00       	mov    %eax,0x805034
			free_block(it);
  8021e9:	83 ec 0c             	sub    $0xc,%esp
  8021ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ef:	e8 24 15 00 00       	call   803718 <free_block>
  8021f4:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  8021f7:	e8 72 fb ff ff       	call   801d6e <recompute_page_alloc_break>

			return;
  8021fc:	eb 37                	jmp    802235 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8021fe:	a1 30 50 80 00       	mov    0x805030,%eax
  802203:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220a:	74 08                	je     802214 <free_pages+0x208>
  80220c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220f:	8b 40 08             	mov    0x8(%eax),%eax
  802212:	eb 05                	jmp    802219 <free_pages+0x20d>
  802214:	b8 00 00 00 00       	mov    $0x0,%eax
  802219:	a3 30 50 80 00       	mov    %eax,0x805030
  80221e:	a1 30 50 80 00       	mov    0x805030,%eax
  802223:	85 c0                	test   %eax,%eax
  802225:	0f 85 fa fd ff ff    	jne    802025 <free_pages+0x19>
  80222b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222f:	0f 85 f0 fd ff ff    	jne    802025 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  80223a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80223f:	5d                   	pop    %ebp
  802240:	c3                   	ret    

00802241 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802247:	a1 08 50 80 00       	mov    0x805008,%eax
  80224c:	85 c0                	test   %eax,%eax
  80224e:	74 60                	je     8022b0 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802250:	83 ec 08             	sub    $0x8,%esp
  802253:	68 00 00 00 82       	push   $0x82000000
  802258:	68 00 00 00 80       	push   $0x80000000
  80225d:	e8 0d 0d 00 00       	call   802f6f <initialize_dynamic_allocator>
  802262:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802265:	e8 f3 0a 00 00       	call   802d5d <sys_get_uheap_strategy>
  80226a:	a3 64 d0 81 00       	mov    %eax,0x81d064
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80226f:	a1 40 50 80 00       	mov    0x805040,%eax
  802274:	05 00 10 00 00       	add    $0x1000,%eax
  802279:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  80227e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802283:	a3 6c d0 81 00       	mov    %eax,0x81d06c

		LIST_INIT(&page_alloc_list);
  802288:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  80228f:	00 00 00 
  802292:	c7 05 2c 50 80 00 00 	movl   $0x0,0x80502c
  802299:	00 00 00 
  80229c:	c7 05 34 50 80 00 00 	movl   $0x0,0x805034
  8022a3:	00 00 00 

		__firstTimeFlag = 0;
  8022a6:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8022ad:	00 00 00 
	}
}
  8022b0:	90                   	nop
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
  8022b6:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8022c7:	83 ec 08             	sub    $0x8,%esp
  8022ca:	68 06 04 00 00       	push   $0x406
  8022cf:	50                   	push   %eax
  8022d0:	e8 d2 06 00 00       	call   8029a7 <__sys_allocate_page>
  8022d5:	83 c4 10             	add    $0x10,%esp
  8022d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8022db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022df:	79 17                	jns    8022f8 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  8022e1:	83 ec 04             	sub    $0x4,%esp
  8022e4:	68 b4 48 80 00       	push   $0x8048b4
  8022e9:	68 ea 00 00 00       	push   $0xea
  8022ee:	68 e5 46 80 00       	push   $0x8046e5
  8022f3:	e8 29 e5 ff ff       	call   800821 <_panic>
	return 0;
  8022f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802313:	83 ec 0c             	sub    $0xc,%esp
  802316:	50                   	push   %eax
  802317:	e8 d2 06 00 00       	call   8029ee <__sys_unmap_frame>
  80231c:	83 c4 10             	add    $0x10,%esp
  80231f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802322:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802326:	79 17                	jns    80233f <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  802328:	83 ec 04             	sub    $0x4,%esp
  80232b:	68 f0 48 80 00       	push   $0x8048f0
  802330:	68 f5 00 00 00       	push   $0xf5
  802335:	68 e5 46 80 00       	push   $0x8046e5
  80233a:	e8 e2 e4 ff ff       	call   800821 <_panic>
}
  80233f:	90                   	nop
  802340:	c9                   	leave  
  802341:	c3                   	ret    

00802342 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
  802345:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802348:	e8 f4 fe ff ff       	call   802241 <uheap_init>
	if (size == 0) return NULL ;
  80234d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802351:	75 0a                	jne    80235d <malloc+0x1b>
  802353:	b8 00 00 00 00       	mov    $0x0,%eax
  802358:	e9 67 01 00 00       	jmp    8024c4 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  80235d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  802364:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80236b:	77 16                	ja     802383 <malloc+0x41>
		result = alloc_block(size);
  80236d:	83 ec 0c             	sub    $0xc,%esp
  802370:	ff 75 08             	pushl  0x8(%ebp)
  802373:	e8 46 0e 00 00       	call   8031be <alloc_block>
  802378:	83 c4 10             	add    $0x10,%esp
  80237b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237e:	e9 3e 01 00 00       	jmp    8024c1 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802383:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80238a:	8b 55 08             	mov    0x8(%ebp),%edx
  80238d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802390:	01 d0                	add    %edx,%eax
  802392:	48                   	dec    %eax
  802393:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802399:	ba 00 00 00 00       	mov    $0x0,%edx
  80239e:	f7 75 f0             	divl   -0x10(%ebp)
  8023a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a4:	29 d0                	sub    %edx,%eax
  8023a6:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  8023a9:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8023ae:	85 c0                	test   %eax,%eax
  8023b0:	75 0a                	jne    8023bc <malloc+0x7a>
			return NULL;
  8023b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b7:	e9 08 01 00 00       	jmp    8024c4 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  8023bc:	a1 6c d0 81 00       	mov    0x81d06c,%eax
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	74 0f                	je     8023d4 <malloc+0x92>
  8023c5:	8b 15 6c d0 81 00    	mov    0x81d06c,%edx
  8023cb:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8023d0:	39 c2                	cmp    %eax,%edx
  8023d2:	73 0a                	jae    8023de <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  8023d4:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8023d9:	a3 6c d0 81 00       	mov    %eax,0x81d06c
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8023de:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8023e3:	83 f8 05             	cmp    $0x5,%eax
  8023e6:	75 11                	jne    8023f9 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  8023e8:	83 ec 0c             	sub    $0xc,%esp
  8023eb:	ff 75 e8             	pushl  -0x18(%ebp)
  8023ee:	e8 ff f9 ff ff       	call   801df2 <alloc_pages_custom_fit>
  8023f3:	83 c4 10             	add    $0x10,%esp
  8023f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  8023f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fd:	0f 84 be 00 00 00    	je     8024c1 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802406:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  802409:	83 ec 0c             	sub    $0xc,%esp
  80240c:	ff 75 f4             	pushl  -0xc(%ebp)
  80240f:	e8 9a fb ff ff       	call   801fae <find_allocated_size>
  802414:	83 c4 10             	add    $0x10,%esp
  802417:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  80241a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80241e:	75 17                	jne    802437 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802420:	ff 75 f4             	pushl  -0xc(%ebp)
  802423:	68 30 49 80 00       	push   $0x804930
  802428:	68 24 01 00 00       	push   $0x124
  80242d:	68 e5 46 80 00       	push   $0x8046e5
  802432:	e8 ea e3 ff ff       	call   800821 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  802437:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80243a:	f7 d0                	not    %eax
  80243c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80243f:	73 1d                	jae    80245e <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  802441:	83 ec 0c             	sub    $0xc,%esp
  802444:	ff 75 e0             	pushl  -0x20(%ebp)
  802447:	ff 75 e4             	pushl  -0x1c(%ebp)
  80244a:	68 78 49 80 00       	push   $0x804978
  80244f:	68 29 01 00 00       	push   $0x129
  802454:	68 e5 46 80 00       	push   $0x8046e5
  802459:	e8 c3 e3 ff ff       	call   800821 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  80245e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802461:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802464:	01 d0                	add    %edx,%eax
  802466:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  802469:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246c:	85 c0                	test   %eax,%eax
  80246e:	79 2c                	jns    80249c <malloc+0x15a>
  802470:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802477:	77 23                	ja     80249c <malloc+0x15a>
  802479:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802480:	77 1a                	ja     80249c <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  802482:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802485:	85 c0                	test   %eax,%eax
  802487:	79 13                	jns    80249c <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  802489:	83 ec 08             	sub    $0x8,%esp
  80248c:	ff 75 e0             	pushl  -0x20(%ebp)
  80248f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802492:	e8 de 09 00 00       	call   802e75 <sys_allocate_user_mem>
  802497:	83 c4 10             	add    $0x10,%esp
  80249a:	eb 25                	jmp    8024c1 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  80249c:	68 00 00 00 a0       	push   $0xa0000000
  8024a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8024a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8024a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8024aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8024ad:	68 b4 49 80 00       	push   $0x8049b4
  8024b2:	68 33 01 00 00       	push   $0x133
  8024b7:	68 e5 46 80 00       	push   $0x8046e5
  8024bc:	e8 60 e3 ff ff       	call   800821 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  8024c4:	c9                   	leave  
  8024c5:	c3                   	ret    

008024c6 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
  8024c9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8024cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024d0:	0f 84 26 01 00 00    	je     8025fc <free+0x136>

	uint32 addr = (uint32)virtual_address;
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	79 1c                	jns    8024ff <free+0x39>
  8024e3:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  8024ea:	77 13                	ja     8024ff <free+0x39>
		free_block(virtual_address);
  8024ec:	83 ec 0c             	sub    $0xc,%esp
  8024ef:	ff 75 08             	pushl  0x8(%ebp)
  8024f2:	e8 21 12 00 00       	call   803718 <free_block>
  8024f7:	83 c4 10             	add    $0x10,%esp
		return;
  8024fa:	e9 01 01 00 00       	jmp    802600 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  8024ff:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802504:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802507:	0f 82 d8 00 00 00    	jb     8025e5 <free+0x11f>
  80250d:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  802514:	0f 87 cb 00 00 00    	ja     8025e5 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	25 ff 0f 00 00       	and    $0xfff,%eax
  802522:	85 c0                	test   %eax,%eax
  802524:	74 17                	je     80253d <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  802526:	ff 75 08             	pushl  0x8(%ebp)
  802529:	68 24 4a 80 00       	push   $0x804a24
  80252e:	68 57 01 00 00       	push   $0x157
  802533:	68 e5 46 80 00       	push   $0x8046e5
  802538:	e8 e4 e2 ff ff       	call   800821 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  80253d:	83 ec 0c             	sub    $0xc,%esp
  802540:	ff 75 08             	pushl  0x8(%ebp)
  802543:	e8 66 fa ff ff       	call   801fae <find_allocated_size>
  802548:	83 c4 10             	add    $0x10,%esp
  80254b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  80254e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802552:	0f 84 a7 00 00 00    	je     8025ff <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  802558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255b:	f7 d0                	not    %eax
  80255d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802560:	73 1d                	jae    80257f <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  802562:	83 ec 0c             	sub    $0xc,%esp
  802565:	ff 75 f0             	pushl  -0x10(%ebp)
  802568:	ff 75 f4             	pushl  -0xc(%ebp)
  80256b:	68 4c 4a 80 00       	push   $0x804a4c
  802570:	68 61 01 00 00       	push   $0x161
  802575:	68 e5 46 80 00       	push   $0x8046e5
  80257a:	e8 a2 e2 ff ff       	call   800821 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  80257f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802585:	01 d0                	add    %edx,%eax
  802587:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	85 c0                	test   %eax,%eax
  80258f:	79 19                	jns    8025aa <free+0xe4>
  802591:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  802598:	77 10                	ja     8025aa <free+0xe4>
  80259a:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  8025a1:	77 07                	ja     8025aa <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  8025a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	78 2b                	js     8025d5 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  8025aa:	83 ec 0c             	sub    $0xc,%esp
  8025ad:	68 00 00 00 a0       	push   $0xa0000000
  8025b2:	ff 75 ec             	pushl  -0x14(%ebp)
  8025b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8025b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8025bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8025be:	ff 75 08             	pushl  0x8(%ebp)
  8025c1:	68 88 4a 80 00       	push   $0x804a88
  8025c6:	68 69 01 00 00       	push   $0x169
  8025cb:	68 e5 46 80 00       	push   $0x8046e5
  8025d0:	e8 4c e2 ff ff       	call   800821 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  8025d5:	83 ec 0c             	sub    $0xc,%esp
  8025d8:	ff 75 08             	pushl  0x8(%ebp)
  8025db:	e8 2c fa ff ff       	call   80200c <free_pages>
  8025e0:	83 c4 10             	add    $0x10,%esp
		return;
  8025e3:	eb 1b                	jmp    802600 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  8025e5:	ff 75 08             	pushl  0x8(%ebp)
  8025e8:	68 e4 4a 80 00       	push   $0x804ae4
  8025ed:	68 70 01 00 00       	push   $0x170
  8025f2:	68 e5 46 80 00       	push   $0x8046e5
  8025f7:	e8 25 e2 ff ff       	call   800821 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8025fc:	90                   	nop
  8025fd:	eb 01                	jmp    802600 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  8025ff:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802600:	c9                   	leave  
  802601:	c3                   	ret    

00802602 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
  802605:	83 ec 38             	sub    $0x38,%esp
  802608:	8b 45 10             	mov    0x10(%ebp),%eax
  80260b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80260e:	e8 2e fc ff ff       	call   802241 <uheap_init>
	if (size == 0) return NULL ;
  802613:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802617:	75 0a                	jne    802623 <smalloc+0x21>
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
  80261e:	e9 3d 01 00 00       	jmp    802760 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  802623:	8b 45 0c             	mov    0xc(%ebp),%eax
  802626:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  802629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80262c:	25 ff 0f 00 00       	and    $0xfff,%eax
  802631:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  802634:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802638:	74 0e                	je     802648 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802640:	05 00 10 00 00       	add    $0x1000,%eax
  802645:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	c1 e8 0c             	shr    $0xc,%eax
  80264e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802651:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802656:	85 c0                	test   %eax,%eax
  802658:	75 0a                	jne    802664 <smalloc+0x62>
		return NULL;
  80265a:	b8 00 00 00 00       	mov    $0x0,%eax
  80265f:	e9 fc 00 00 00       	jmp    802760 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802664:	a1 6c d0 81 00       	mov    0x81d06c,%eax
  802669:	85 c0                	test   %eax,%eax
  80266b:	74 0f                	je     80267c <smalloc+0x7a>
  80266d:	8b 15 6c d0 81 00    	mov    0x81d06c,%edx
  802673:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802678:	39 c2                	cmp    %eax,%edx
  80267a:	73 0a                	jae    802686 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  80267c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802681:	a3 6c d0 81 00       	mov    %eax,0x81d06c

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802686:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80268b:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802690:	29 c2                	sub    %eax,%edx
  802692:	89 d0                	mov    %edx,%eax
  802694:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802697:	8b 15 6c d0 81 00    	mov    0x81d06c,%edx
  80269d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026a2:	29 c2                	sub    %eax,%edx
  8026a4:	89 d0                	mov    %edx,%eax
  8026a6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8026af:	77 13                	ja     8026c4 <smalloc+0xc2>
  8026b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8026b7:	77 0b                	ja     8026c4 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  8026b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026bc:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8026bf:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8026c2:	73 0a                	jae    8026ce <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c9:	e9 92 00 00 00       	jmp    802760 <smalloc+0x15e>
	}

	void *va = NULL;
  8026ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8026d5:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8026da:	83 f8 05             	cmp    $0x5,%eax
  8026dd:	75 11                	jne    8026f0 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  8026df:	83 ec 0c             	sub    $0xc,%esp
  8026e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8026e5:	e8 08 f7 ff ff       	call   801df2 <alloc_pages_custom_fit>
  8026ea:	83 c4 10             	add    $0x10,%esp
  8026ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  8026f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f4:	75 27                	jne    80271d <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8026f6:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  8026fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802700:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802703:	89 c2                	mov    %eax,%edx
  802705:	a1 6c d0 81 00       	mov    0x81d06c,%eax
  80270a:	39 c2                	cmp    %eax,%edx
  80270c:	73 07                	jae    802715 <smalloc+0x113>
			return NULL;}
  80270e:	b8 00 00 00 00       	mov    $0x0,%eax
  802713:	eb 4b                	jmp    802760 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  802715:	a1 6c d0 81 00       	mov    0x81d06c,%eax
  80271a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  80271d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802721:	ff 75 f0             	pushl  -0x10(%ebp)
  802724:	50                   	push   %eax
  802725:	ff 75 0c             	pushl  0xc(%ebp)
  802728:	ff 75 08             	pushl  0x8(%ebp)
  80272b:	e8 cb 03 00 00       	call   802afb <sys_create_shared_object>
  802730:	83 c4 10             	add    $0x10,%esp
  802733:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  802736:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80273a:	79 07                	jns    802743 <smalloc+0x141>
		return NULL;
  80273c:	b8 00 00 00 00       	mov    $0x0,%eax
  802741:	eb 1d                	jmp    802760 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802743:	a1 6c d0 81 00       	mov    0x81d06c,%eax
  802748:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80274b:	75 10                	jne    80275d <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  80274d:	8b 15 6c d0 81 00    	mov    0x81d06c,%edx
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	01 d0                	add    %edx,%eax
  802758:	a3 6c d0 81 00       	mov    %eax,0x81d06c
	}

	return va;
  80275d:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802760:	c9                   	leave  
  802761:	c3                   	ret    

00802762 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802762:	55                   	push   %ebp
  802763:	89 e5                	mov    %esp,%ebp
  802765:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802768:	e8 d4 fa ff ff       	call   802241 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80276d:	83 ec 08             	sub    $0x8,%esp
  802770:	ff 75 0c             	pushl  0xc(%ebp)
  802773:	ff 75 08             	pushl  0x8(%ebp)
  802776:	e8 aa 03 00 00       	call   802b25 <sys_size_of_shared_object>
  80277b:	83 c4 10             	add    $0x10,%esp
  80277e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802781:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802785:	7f 0a                	jg     802791 <sget+0x2f>
		return NULL;
  802787:	b8 00 00 00 00       	mov    $0x0,%eax
  80278c:	e9 32 01 00 00       	jmp    8028c3 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  802791:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802794:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  802797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279a:	25 ff 0f 00 00       	and    $0xfff,%eax
  80279f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8027a2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027a6:	74 0e                	je     8027b6 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8027ae:	05 00 10 00 00       	add    $0x1000,%eax
  8027b3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8027b6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8027bb:	85 c0                	test   %eax,%eax
  8027bd:	75 0a                	jne    8027c9 <sget+0x67>
		return NULL;
  8027bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c4:	e9 fa 00 00 00       	jmp    8028c3 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8027c9:	a1 6c d0 81 00       	mov    0x81d06c,%eax
  8027ce:	85 c0                	test   %eax,%eax
  8027d0:	74 0f                	je     8027e1 <sget+0x7f>
  8027d2:	8b 15 6c d0 81 00    	mov    0x81d06c,%edx
  8027d8:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8027dd:	39 c2                	cmp    %eax,%edx
  8027df:	73 0a                	jae    8027eb <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8027e1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8027e6:	a3 6c d0 81 00       	mov    %eax,0x81d06c

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8027eb:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8027f0:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8027f5:	29 c2                	sub    %eax,%edx
  8027f7:	89 d0                	mov    %edx,%eax
  8027f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8027fc:	8b 15 6c d0 81 00    	mov    0x81d06c,%edx
  802802:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802807:	29 c2                	sub    %eax,%edx
  802809:	89 d0                	mov    %edx,%eax
  80280b:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802814:	77 13                	ja     802829 <sget+0xc7>
  802816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802819:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80281c:	77 0b                	ja     802829 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  80281e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802821:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802824:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802827:	73 0a                	jae    802833 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802829:	b8 00 00 00 00       	mov    $0x0,%eax
  80282e:	e9 90 00 00 00       	jmp    8028c3 <sget+0x161>

	void *va = NULL;
  802833:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  80283a:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80283f:	83 f8 05             	cmp    $0x5,%eax
  802842:	75 11                	jne    802855 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802844:	83 ec 0c             	sub    $0xc,%esp
  802847:	ff 75 f4             	pushl  -0xc(%ebp)
  80284a:	e8 a3 f5 ff ff       	call   801df2 <alloc_pages_custom_fit>
  80284f:	83 c4 10             	add    $0x10,%esp
  802852:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  802855:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802859:	75 27                	jne    802882 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80285b:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802862:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802865:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802868:	89 c2                	mov    %eax,%edx
  80286a:	a1 6c d0 81 00       	mov    0x81d06c,%eax
  80286f:	39 c2                	cmp    %eax,%edx
  802871:	73 07                	jae    80287a <sget+0x118>
			return NULL;
  802873:	b8 00 00 00 00       	mov    $0x0,%eax
  802878:	eb 49                	jmp    8028c3 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  80287a:	a1 6c d0 81 00       	mov    0x81d06c,%eax
  80287f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802882:	83 ec 04             	sub    $0x4,%esp
  802885:	ff 75 f0             	pushl  -0x10(%ebp)
  802888:	ff 75 0c             	pushl  0xc(%ebp)
  80288b:	ff 75 08             	pushl  0x8(%ebp)
  80288e:	e8 af 02 00 00       	call   802b42 <sys_get_shared_object>
  802893:	83 c4 10             	add    $0x10,%esp
  802896:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  802899:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80289d:	79 07                	jns    8028a6 <sget+0x144>
		return NULL;
  80289f:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a4:	eb 1d                	jmp    8028c3 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8028a6:	a1 6c d0 81 00       	mov    0x81d06c,%eax
  8028ab:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8028ae:	75 10                	jne    8028c0 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8028b0:	8b 15 6c d0 81 00    	mov    0x81d06c,%edx
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	01 d0                	add    %edx,%eax
  8028bb:	a3 6c d0 81 00       	mov    %eax,0x81d06c

	return va;
  8028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8028c3:	c9                   	leave  
  8028c4:	c3                   	ret    

008028c5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8028c5:	55                   	push   %ebp
  8028c6:	89 e5                	mov    %esp,%ebp
  8028c8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8028cb:	e8 71 f9 ff ff       	call   802241 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8028d0:	83 ec 04             	sub    $0x4,%esp
  8028d3:	68 08 4b 80 00       	push   $0x804b08
  8028d8:	68 19 02 00 00       	push   $0x219
  8028dd:	68 e5 46 80 00       	push   $0x8046e5
  8028e2:	e8 3a df ff ff       	call   800821 <_panic>

008028e7 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8028e7:	55                   	push   %ebp
  8028e8:	89 e5                	mov    %esp,%ebp
  8028ea:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8028ed:	83 ec 04             	sub    $0x4,%esp
  8028f0:	68 30 4b 80 00       	push   $0x804b30
  8028f5:	68 2b 02 00 00       	push   $0x22b
  8028fa:	68 e5 46 80 00       	push   $0x8046e5
  8028ff:	e8 1d df ff ff       	call   800821 <_panic>

00802904 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802904:	55                   	push   %ebp
  802905:	89 e5                	mov    %esp,%ebp
  802907:	57                   	push   %edi
  802908:	56                   	push   %esi
  802909:	53                   	push   %ebx
  80290a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80290d:	8b 45 08             	mov    0x8(%ebp),%eax
  802910:	8b 55 0c             	mov    0xc(%ebp),%edx
  802913:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802916:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802919:	8b 7d 18             	mov    0x18(%ebp),%edi
  80291c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80291f:	cd 30                	int    $0x30
  802921:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802924:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802927:	83 c4 10             	add    $0x10,%esp
  80292a:	5b                   	pop    %ebx
  80292b:	5e                   	pop    %esi
  80292c:	5f                   	pop    %edi
  80292d:	5d                   	pop    %ebp
  80292e:	c3                   	ret    

0080292f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80292f:	55                   	push   %ebp
  802930:	89 e5                	mov    %esp,%ebp
  802932:	83 ec 04             	sub    $0x4,%esp
  802935:	8b 45 10             	mov    0x10(%ebp),%eax
  802938:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80293b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80293e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802942:	8b 45 08             	mov    0x8(%ebp),%eax
  802945:	6a 00                	push   $0x0
  802947:	51                   	push   %ecx
  802948:	52                   	push   %edx
  802949:	ff 75 0c             	pushl  0xc(%ebp)
  80294c:	50                   	push   %eax
  80294d:	6a 00                	push   $0x0
  80294f:	e8 b0 ff ff ff       	call   802904 <syscall>
  802954:	83 c4 18             	add    $0x18,%esp
}
  802957:	90                   	nop
  802958:	c9                   	leave  
  802959:	c3                   	ret    

0080295a <sys_cgetc>:

int
sys_cgetc(void)
{
  80295a:	55                   	push   %ebp
  80295b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	6a 00                	push   $0x0
  802965:	6a 00                	push   $0x0
  802967:	6a 02                	push   $0x2
  802969:	e8 96 ff ff ff       	call   802904 <syscall>
  80296e:	83 c4 18             	add    $0x18,%esp
}
  802971:	c9                   	leave  
  802972:	c3                   	ret    

00802973 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802973:	55                   	push   %ebp
  802974:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802976:	6a 00                	push   $0x0
  802978:	6a 00                	push   $0x0
  80297a:	6a 00                	push   $0x0
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	6a 03                	push   $0x3
  802982:	e8 7d ff ff ff       	call   802904 <syscall>
  802987:	83 c4 18             	add    $0x18,%esp
}
  80298a:	90                   	nop
  80298b:	c9                   	leave  
  80298c:	c3                   	ret    

0080298d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80298d:	55                   	push   %ebp
  80298e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802990:	6a 00                	push   $0x0
  802992:	6a 00                	push   $0x0
  802994:	6a 00                	push   $0x0
  802996:	6a 00                	push   $0x0
  802998:	6a 00                	push   $0x0
  80299a:	6a 04                	push   $0x4
  80299c:	e8 63 ff ff ff       	call   802904 <syscall>
  8029a1:	83 c4 18             	add    $0x18,%esp
}
  8029a4:	90                   	nop
  8029a5:	c9                   	leave  
  8029a6:	c3                   	ret    

008029a7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8029a7:	55                   	push   %ebp
  8029a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8029aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	6a 00                	push   $0x0
  8029b2:	6a 00                	push   $0x0
  8029b4:	6a 00                	push   $0x0
  8029b6:	52                   	push   %edx
  8029b7:	50                   	push   %eax
  8029b8:	6a 08                	push   $0x8
  8029ba:	e8 45 ff ff ff       	call   802904 <syscall>
  8029bf:	83 c4 18             	add    $0x18,%esp
}
  8029c2:	c9                   	leave  
  8029c3:	c3                   	ret    

008029c4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8029c4:	55                   	push   %ebp
  8029c5:	89 e5                	mov    %esp,%ebp
  8029c7:	56                   	push   %esi
  8029c8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8029c9:	8b 75 18             	mov    0x18(%ebp),%esi
  8029cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8029cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	56                   	push   %esi
  8029d9:	53                   	push   %ebx
  8029da:	51                   	push   %ecx
  8029db:	52                   	push   %edx
  8029dc:	50                   	push   %eax
  8029dd:	6a 09                	push   $0x9
  8029df:	e8 20 ff ff ff       	call   802904 <syscall>
  8029e4:	83 c4 18             	add    $0x18,%esp
}
  8029e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029ea:	5b                   	pop    %ebx
  8029eb:	5e                   	pop    %esi
  8029ec:	5d                   	pop    %ebp
  8029ed:	c3                   	ret    

008029ee <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8029ee:	55                   	push   %ebp
  8029ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	ff 75 08             	pushl  0x8(%ebp)
  8029fc:	6a 0a                	push   $0xa
  8029fe:	e8 01 ff ff ff       	call   802904 <syscall>
  802a03:	83 c4 18             	add    $0x18,%esp
}
  802a06:	c9                   	leave  
  802a07:	c3                   	ret    

00802a08 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802a08:	55                   	push   %ebp
  802a09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802a0b:	6a 00                	push   $0x0
  802a0d:	6a 00                	push   $0x0
  802a0f:	6a 00                	push   $0x0
  802a11:	ff 75 0c             	pushl  0xc(%ebp)
  802a14:	ff 75 08             	pushl  0x8(%ebp)
  802a17:	6a 0b                	push   $0xb
  802a19:	e8 e6 fe ff ff       	call   802904 <syscall>
  802a1e:	83 c4 18             	add    $0x18,%esp
}
  802a21:	c9                   	leave  
  802a22:	c3                   	ret    

00802a23 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802a23:	55                   	push   %ebp
  802a24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802a26:	6a 00                	push   $0x0
  802a28:	6a 00                	push   $0x0
  802a2a:	6a 00                	push   $0x0
  802a2c:	6a 00                	push   $0x0
  802a2e:	6a 00                	push   $0x0
  802a30:	6a 0c                	push   $0xc
  802a32:	e8 cd fe ff ff       	call   802904 <syscall>
  802a37:	83 c4 18             	add    $0x18,%esp
}
  802a3a:	c9                   	leave  
  802a3b:	c3                   	ret    

00802a3c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802a3c:	55                   	push   %ebp
  802a3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802a3f:	6a 00                	push   $0x0
  802a41:	6a 00                	push   $0x0
  802a43:	6a 00                	push   $0x0
  802a45:	6a 00                	push   $0x0
  802a47:	6a 00                	push   $0x0
  802a49:	6a 0d                	push   $0xd
  802a4b:	e8 b4 fe ff ff       	call   802904 <syscall>
  802a50:	83 c4 18             	add    $0x18,%esp
}
  802a53:	c9                   	leave  
  802a54:	c3                   	ret    

00802a55 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802a55:	55                   	push   %ebp
  802a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802a58:	6a 00                	push   $0x0
  802a5a:	6a 00                	push   $0x0
  802a5c:	6a 00                	push   $0x0
  802a5e:	6a 00                	push   $0x0
  802a60:	6a 00                	push   $0x0
  802a62:	6a 0e                	push   $0xe
  802a64:	e8 9b fe ff ff       	call   802904 <syscall>
  802a69:	83 c4 18             	add    $0x18,%esp
}
  802a6c:	c9                   	leave  
  802a6d:	c3                   	ret    

00802a6e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802a6e:	55                   	push   %ebp
  802a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802a71:	6a 00                	push   $0x0
  802a73:	6a 00                	push   $0x0
  802a75:	6a 00                	push   $0x0
  802a77:	6a 00                	push   $0x0
  802a79:	6a 00                	push   $0x0
  802a7b:	6a 0f                	push   $0xf
  802a7d:	e8 82 fe ff ff       	call   802904 <syscall>
  802a82:	83 c4 18             	add    $0x18,%esp
}
  802a85:	c9                   	leave  
  802a86:	c3                   	ret    

00802a87 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802a87:	55                   	push   %ebp
  802a88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802a8a:	6a 00                	push   $0x0
  802a8c:	6a 00                	push   $0x0
  802a8e:	6a 00                	push   $0x0
  802a90:	6a 00                	push   $0x0
  802a92:	ff 75 08             	pushl  0x8(%ebp)
  802a95:	6a 10                	push   $0x10
  802a97:	e8 68 fe ff ff       	call   802904 <syscall>
  802a9c:	83 c4 18             	add    $0x18,%esp
}
  802a9f:	c9                   	leave  
  802aa0:	c3                   	ret    

00802aa1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802aa1:	55                   	push   %ebp
  802aa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802aa4:	6a 00                	push   $0x0
  802aa6:	6a 00                	push   $0x0
  802aa8:	6a 00                	push   $0x0
  802aaa:	6a 00                	push   $0x0
  802aac:	6a 00                	push   $0x0
  802aae:	6a 11                	push   $0x11
  802ab0:	e8 4f fe ff ff       	call   802904 <syscall>
  802ab5:	83 c4 18             	add    $0x18,%esp
}
  802ab8:	90                   	nop
  802ab9:	c9                   	leave  
  802aba:	c3                   	ret    

00802abb <sys_cputc>:

void
sys_cputc(const char c)
{
  802abb:	55                   	push   %ebp
  802abc:	89 e5                	mov    %esp,%ebp
  802abe:	83 ec 04             	sub    $0x4,%esp
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802ac7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802acb:	6a 00                	push   $0x0
  802acd:	6a 00                	push   $0x0
  802acf:	6a 00                	push   $0x0
  802ad1:	6a 00                	push   $0x0
  802ad3:	50                   	push   %eax
  802ad4:	6a 01                	push   $0x1
  802ad6:	e8 29 fe ff ff       	call   802904 <syscall>
  802adb:	83 c4 18             	add    $0x18,%esp
}
  802ade:	90                   	nop
  802adf:	c9                   	leave  
  802ae0:	c3                   	ret    

00802ae1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802ae1:	55                   	push   %ebp
  802ae2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802ae4:	6a 00                	push   $0x0
  802ae6:	6a 00                	push   $0x0
  802ae8:	6a 00                	push   $0x0
  802aea:	6a 00                	push   $0x0
  802aec:	6a 00                	push   $0x0
  802aee:	6a 14                	push   $0x14
  802af0:	e8 0f fe ff ff       	call   802904 <syscall>
  802af5:	83 c4 18             	add    $0x18,%esp
}
  802af8:	90                   	nop
  802af9:	c9                   	leave  
  802afa:	c3                   	ret    

00802afb <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802afb:	55                   	push   %ebp
  802afc:	89 e5                	mov    %esp,%ebp
  802afe:	83 ec 04             	sub    $0x4,%esp
  802b01:	8b 45 10             	mov    0x10(%ebp),%eax
  802b04:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802b07:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b0a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	6a 00                	push   $0x0
  802b13:	51                   	push   %ecx
  802b14:	52                   	push   %edx
  802b15:	ff 75 0c             	pushl  0xc(%ebp)
  802b18:	50                   	push   %eax
  802b19:	6a 15                	push   $0x15
  802b1b:	e8 e4 fd ff ff       	call   802904 <syscall>
  802b20:	83 c4 18             	add    $0x18,%esp
}
  802b23:	c9                   	leave  
  802b24:	c3                   	ret    

00802b25 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802b25:	55                   	push   %ebp
  802b26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802b28:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2e:	6a 00                	push   $0x0
  802b30:	6a 00                	push   $0x0
  802b32:	6a 00                	push   $0x0
  802b34:	52                   	push   %edx
  802b35:	50                   	push   %eax
  802b36:	6a 16                	push   $0x16
  802b38:	e8 c7 fd ff ff       	call   802904 <syscall>
  802b3d:	83 c4 18             	add    $0x18,%esp
}
  802b40:	c9                   	leave  
  802b41:	c3                   	ret    

00802b42 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802b42:	55                   	push   %ebp
  802b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802b45:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	6a 00                	push   $0x0
  802b50:	6a 00                	push   $0x0
  802b52:	51                   	push   %ecx
  802b53:	52                   	push   %edx
  802b54:	50                   	push   %eax
  802b55:	6a 17                	push   $0x17
  802b57:	e8 a8 fd ff ff       	call   802904 <syscall>
  802b5c:	83 c4 18             	add    $0x18,%esp
}
  802b5f:	c9                   	leave  
  802b60:	c3                   	ret    

00802b61 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802b61:	55                   	push   %ebp
  802b62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b67:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6a:	6a 00                	push   $0x0
  802b6c:	6a 00                	push   $0x0
  802b6e:	6a 00                	push   $0x0
  802b70:	52                   	push   %edx
  802b71:	50                   	push   %eax
  802b72:	6a 18                	push   $0x18
  802b74:	e8 8b fd ff ff       	call   802904 <syscall>
  802b79:	83 c4 18             	add    $0x18,%esp
}
  802b7c:	c9                   	leave  
  802b7d:	c3                   	ret    

00802b7e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802b7e:	55                   	push   %ebp
  802b7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802b81:	8b 45 08             	mov    0x8(%ebp),%eax
  802b84:	6a 00                	push   $0x0
  802b86:	ff 75 14             	pushl  0x14(%ebp)
  802b89:	ff 75 10             	pushl  0x10(%ebp)
  802b8c:	ff 75 0c             	pushl  0xc(%ebp)
  802b8f:	50                   	push   %eax
  802b90:	6a 19                	push   $0x19
  802b92:	e8 6d fd ff ff       	call   802904 <syscall>
  802b97:	83 c4 18             	add    $0x18,%esp
}
  802b9a:	c9                   	leave  
  802b9b:	c3                   	ret    

00802b9c <sys_run_env>:

void sys_run_env(int32 envId)
{
  802b9c:	55                   	push   %ebp
  802b9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	6a 00                	push   $0x0
  802ba4:	6a 00                	push   $0x0
  802ba6:	6a 00                	push   $0x0
  802ba8:	6a 00                	push   $0x0
  802baa:	50                   	push   %eax
  802bab:	6a 1a                	push   $0x1a
  802bad:	e8 52 fd ff ff       	call   802904 <syscall>
  802bb2:	83 c4 18             	add    $0x18,%esp
}
  802bb5:	90                   	nop
  802bb6:	c9                   	leave  
  802bb7:	c3                   	ret    

00802bb8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802bb8:	55                   	push   %ebp
  802bb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	6a 00                	push   $0x0
  802bc0:	6a 00                	push   $0x0
  802bc2:	6a 00                	push   $0x0
  802bc4:	6a 00                	push   $0x0
  802bc6:	50                   	push   %eax
  802bc7:	6a 1b                	push   $0x1b
  802bc9:	e8 36 fd ff ff       	call   802904 <syscall>
  802bce:	83 c4 18             	add    $0x18,%esp
}
  802bd1:	c9                   	leave  
  802bd2:	c3                   	ret    

00802bd3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802bd3:	55                   	push   %ebp
  802bd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802bd6:	6a 00                	push   $0x0
  802bd8:	6a 00                	push   $0x0
  802bda:	6a 00                	push   $0x0
  802bdc:	6a 00                	push   $0x0
  802bde:	6a 00                	push   $0x0
  802be0:	6a 05                	push   $0x5
  802be2:	e8 1d fd ff ff       	call   802904 <syscall>
  802be7:	83 c4 18             	add    $0x18,%esp
}
  802bea:	c9                   	leave  
  802beb:	c3                   	ret    

00802bec <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802bec:	55                   	push   %ebp
  802bed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802bef:	6a 00                	push   $0x0
  802bf1:	6a 00                	push   $0x0
  802bf3:	6a 00                	push   $0x0
  802bf5:	6a 00                	push   $0x0
  802bf7:	6a 00                	push   $0x0
  802bf9:	6a 06                	push   $0x6
  802bfb:	e8 04 fd ff ff       	call   802904 <syscall>
  802c00:	83 c4 18             	add    $0x18,%esp
}
  802c03:	c9                   	leave  
  802c04:	c3                   	ret    

00802c05 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802c05:	55                   	push   %ebp
  802c06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802c08:	6a 00                	push   $0x0
  802c0a:	6a 00                	push   $0x0
  802c0c:	6a 00                	push   $0x0
  802c0e:	6a 00                	push   $0x0
  802c10:	6a 00                	push   $0x0
  802c12:	6a 07                	push   $0x7
  802c14:	e8 eb fc ff ff       	call   802904 <syscall>
  802c19:	83 c4 18             	add    $0x18,%esp
}
  802c1c:	c9                   	leave  
  802c1d:	c3                   	ret    

00802c1e <sys_exit_env>:


void sys_exit_env(void)
{
  802c1e:	55                   	push   %ebp
  802c1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802c21:	6a 00                	push   $0x0
  802c23:	6a 00                	push   $0x0
  802c25:	6a 00                	push   $0x0
  802c27:	6a 00                	push   $0x0
  802c29:	6a 00                	push   $0x0
  802c2b:	6a 1c                	push   $0x1c
  802c2d:	e8 d2 fc ff ff       	call   802904 <syscall>
  802c32:	83 c4 18             	add    $0x18,%esp
}
  802c35:	90                   	nop
  802c36:	c9                   	leave  
  802c37:	c3                   	ret    

00802c38 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802c38:	55                   	push   %ebp
  802c39:	89 e5                	mov    %esp,%ebp
  802c3b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802c3e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c41:	8d 50 04             	lea    0x4(%eax),%edx
  802c44:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c47:	6a 00                	push   $0x0
  802c49:	6a 00                	push   $0x0
  802c4b:	6a 00                	push   $0x0
  802c4d:	52                   	push   %edx
  802c4e:	50                   	push   %eax
  802c4f:	6a 1d                	push   $0x1d
  802c51:	e8 ae fc ff ff       	call   802904 <syscall>
  802c56:	83 c4 18             	add    $0x18,%esp
	return result;
  802c59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802c5f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c62:	89 01                	mov    %eax,(%ecx)
  802c64:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	c9                   	leave  
  802c6b:	c2 04 00             	ret    $0x4

00802c6e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802c6e:	55                   	push   %ebp
  802c6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802c71:	6a 00                	push   $0x0
  802c73:	6a 00                	push   $0x0
  802c75:	ff 75 10             	pushl  0x10(%ebp)
  802c78:	ff 75 0c             	pushl  0xc(%ebp)
  802c7b:	ff 75 08             	pushl  0x8(%ebp)
  802c7e:	6a 13                	push   $0x13
  802c80:	e8 7f fc ff ff       	call   802904 <syscall>
  802c85:	83 c4 18             	add    $0x18,%esp
	return ;
  802c88:	90                   	nop
}
  802c89:	c9                   	leave  
  802c8a:	c3                   	ret    

00802c8b <sys_rcr2>:
uint32 sys_rcr2()
{
  802c8b:	55                   	push   %ebp
  802c8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802c8e:	6a 00                	push   $0x0
  802c90:	6a 00                	push   $0x0
  802c92:	6a 00                	push   $0x0
  802c94:	6a 00                	push   $0x0
  802c96:	6a 00                	push   $0x0
  802c98:	6a 1e                	push   $0x1e
  802c9a:	e8 65 fc ff ff       	call   802904 <syscall>
  802c9f:	83 c4 18             	add    $0x18,%esp
}
  802ca2:	c9                   	leave  
  802ca3:	c3                   	ret    

00802ca4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802ca4:	55                   	push   %ebp
  802ca5:	89 e5                	mov    %esp,%ebp
  802ca7:	83 ec 04             	sub    $0x4,%esp
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802cb0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802cb4:	6a 00                	push   $0x0
  802cb6:	6a 00                	push   $0x0
  802cb8:	6a 00                	push   $0x0
  802cba:	6a 00                	push   $0x0
  802cbc:	50                   	push   %eax
  802cbd:	6a 1f                	push   $0x1f
  802cbf:	e8 40 fc ff ff       	call   802904 <syscall>
  802cc4:	83 c4 18             	add    $0x18,%esp
	return ;
  802cc7:	90                   	nop
}
  802cc8:	c9                   	leave  
  802cc9:	c3                   	ret    

00802cca <rsttst>:
void rsttst()
{
  802cca:	55                   	push   %ebp
  802ccb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802ccd:	6a 00                	push   $0x0
  802ccf:	6a 00                	push   $0x0
  802cd1:	6a 00                	push   $0x0
  802cd3:	6a 00                	push   $0x0
  802cd5:	6a 00                	push   $0x0
  802cd7:	6a 21                	push   $0x21
  802cd9:	e8 26 fc ff ff       	call   802904 <syscall>
  802cde:	83 c4 18             	add    $0x18,%esp
	return ;
  802ce1:	90                   	nop
}
  802ce2:	c9                   	leave  
  802ce3:	c3                   	ret    

00802ce4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802ce4:	55                   	push   %ebp
  802ce5:	89 e5                	mov    %esp,%ebp
  802ce7:	83 ec 04             	sub    $0x4,%esp
  802cea:	8b 45 14             	mov    0x14(%ebp),%eax
  802ced:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802cf0:	8b 55 18             	mov    0x18(%ebp),%edx
  802cf3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802cf7:	52                   	push   %edx
  802cf8:	50                   	push   %eax
  802cf9:	ff 75 10             	pushl  0x10(%ebp)
  802cfc:	ff 75 0c             	pushl  0xc(%ebp)
  802cff:	ff 75 08             	pushl  0x8(%ebp)
  802d02:	6a 20                	push   $0x20
  802d04:	e8 fb fb ff ff       	call   802904 <syscall>
  802d09:	83 c4 18             	add    $0x18,%esp
	return ;
  802d0c:	90                   	nop
}
  802d0d:	c9                   	leave  
  802d0e:	c3                   	ret    

00802d0f <chktst>:
void chktst(uint32 n)
{
  802d0f:	55                   	push   %ebp
  802d10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802d12:	6a 00                	push   $0x0
  802d14:	6a 00                	push   $0x0
  802d16:	6a 00                	push   $0x0
  802d18:	6a 00                	push   $0x0
  802d1a:	ff 75 08             	pushl  0x8(%ebp)
  802d1d:	6a 22                	push   $0x22
  802d1f:	e8 e0 fb ff ff       	call   802904 <syscall>
  802d24:	83 c4 18             	add    $0x18,%esp
	return ;
  802d27:	90                   	nop
}
  802d28:	c9                   	leave  
  802d29:	c3                   	ret    

00802d2a <inctst>:

void inctst()
{
  802d2a:	55                   	push   %ebp
  802d2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802d2d:	6a 00                	push   $0x0
  802d2f:	6a 00                	push   $0x0
  802d31:	6a 00                	push   $0x0
  802d33:	6a 00                	push   $0x0
  802d35:	6a 00                	push   $0x0
  802d37:	6a 23                	push   $0x23
  802d39:	e8 c6 fb ff ff       	call   802904 <syscall>
  802d3e:	83 c4 18             	add    $0x18,%esp
	return ;
  802d41:	90                   	nop
}
  802d42:	c9                   	leave  
  802d43:	c3                   	ret    

00802d44 <gettst>:
uint32 gettst()
{
  802d44:	55                   	push   %ebp
  802d45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802d47:	6a 00                	push   $0x0
  802d49:	6a 00                	push   $0x0
  802d4b:	6a 00                	push   $0x0
  802d4d:	6a 00                	push   $0x0
  802d4f:	6a 00                	push   $0x0
  802d51:	6a 24                	push   $0x24
  802d53:	e8 ac fb ff ff       	call   802904 <syscall>
  802d58:	83 c4 18             	add    $0x18,%esp
}
  802d5b:	c9                   	leave  
  802d5c:	c3                   	ret    

00802d5d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802d5d:	55                   	push   %ebp
  802d5e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d60:	6a 00                	push   $0x0
  802d62:	6a 00                	push   $0x0
  802d64:	6a 00                	push   $0x0
  802d66:	6a 00                	push   $0x0
  802d68:	6a 00                	push   $0x0
  802d6a:	6a 25                	push   $0x25
  802d6c:	e8 93 fb ff ff       	call   802904 <syscall>
  802d71:	83 c4 18             	add    $0x18,%esp
  802d74:	a3 64 d0 81 00       	mov    %eax,0x81d064
	return uheapPlaceStrategy ;
  802d79:	a1 64 d0 81 00       	mov    0x81d064,%eax
}
  802d7e:	c9                   	leave  
  802d7f:	c3                   	ret    

00802d80 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802d80:	55                   	push   %ebp
  802d81:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	a3 64 d0 81 00       	mov    %eax,0x81d064
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802d8b:	6a 00                	push   $0x0
  802d8d:	6a 00                	push   $0x0
  802d8f:	6a 00                	push   $0x0
  802d91:	6a 00                	push   $0x0
  802d93:	ff 75 08             	pushl  0x8(%ebp)
  802d96:	6a 26                	push   $0x26
  802d98:	e8 67 fb ff ff       	call   802904 <syscall>
  802d9d:	83 c4 18             	add    $0x18,%esp
	return ;
  802da0:	90                   	nop
}
  802da1:	c9                   	leave  
  802da2:	c3                   	ret    

00802da3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802da3:	55                   	push   %ebp
  802da4:	89 e5                	mov    %esp,%ebp
  802da6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802da7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802daa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  802db0:	8b 45 08             	mov    0x8(%ebp),%eax
  802db3:	6a 00                	push   $0x0
  802db5:	53                   	push   %ebx
  802db6:	51                   	push   %ecx
  802db7:	52                   	push   %edx
  802db8:	50                   	push   %eax
  802db9:	6a 27                	push   $0x27
  802dbb:	e8 44 fb ff ff       	call   802904 <syscall>
  802dc0:	83 c4 18             	add    $0x18,%esp
}
  802dc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802dc6:	c9                   	leave  
  802dc7:	c3                   	ret    

00802dc8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802dc8:	55                   	push   %ebp
  802dc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802dcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	6a 00                	push   $0x0
  802dd3:	6a 00                	push   $0x0
  802dd5:	6a 00                	push   $0x0
  802dd7:	52                   	push   %edx
  802dd8:	50                   	push   %eax
  802dd9:	6a 28                	push   $0x28
  802ddb:	e8 24 fb ff ff       	call   802904 <syscall>
  802de0:	83 c4 18             	add    $0x18,%esp
}
  802de3:	c9                   	leave  
  802de4:	c3                   	ret    

00802de5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802de5:	55                   	push   %ebp
  802de6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802de8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	6a 00                	push   $0x0
  802df3:	51                   	push   %ecx
  802df4:	ff 75 10             	pushl  0x10(%ebp)
  802df7:	52                   	push   %edx
  802df8:	50                   	push   %eax
  802df9:	6a 29                	push   $0x29
  802dfb:	e8 04 fb ff ff       	call   802904 <syscall>
  802e00:	83 c4 18             	add    $0x18,%esp
}
  802e03:	c9                   	leave  
  802e04:	c3                   	ret    

00802e05 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802e05:	55                   	push   %ebp
  802e06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802e08:	6a 00                	push   $0x0
  802e0a:	6a 00                	push   $0x0
  802e0c:	ff 75 10             	pushl  0x10(%ebp)
  802e0f:	ff 75 0c             	pushl  0xc(%ebp)
  802e12:	ff 75 08             	pushl  0x8(%ebp)
  802e15:	6a 12                	push   $0x12
  802e17:	e8 e8 fa ff ff       	call   802904 <syscall>
  802e1c:	83 c4 18             	add    $0x18,%esp
	return ;
  802e1f:	90                   	nop
}
  802e20:	c9                   	leave  
  802e21:	c3                   	ret    

00802e22 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802e22:	55                   	push   %ebp
  802e23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802e25:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	6a 00                	push   $0x0
  802e2d:	6a 00                	push   $0x0
  802e2f:	6a 00                	push   $0x0
  802e31:	52                   	push   %edx
  802e32:	50                   	push   %eax
  802e33:	6a 2a                	push   $0x2a
  802e35:	e8 ca fa ff ff       	call   802904 <syscall>
  802e3a:	83 c4 18             	add    $0x18,%esp
	return;
  802e3d:	90                   	nop
}
  802e3e:	c9                   	leave  
  802e3f:	c3                   	ret    

00802e40 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802e40:	55                   	push   %ebp
  802e41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802e43:	6a 00                	push   $0x0
  802e45:	6a 00                	push   $0x0
  802e47:	6a 00                	push   $0x0
  802e49:	6a 00                	push   $0x0
  802e4b:	6a 00                	push   $0x0
  802e4d:	6a 2b                	push   $0x2b
  802e4f:	e8 b0 fa ff ff       	call   802904 <syscall>
  802e54:	83 c4 18             	add    $0x18,%esp
}
  802e57:	c9                   	leave  
  802e58:	c3                   	ret    

00802e59 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802e59:	55                   	push   %ebp
  802e5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802e5c:	6a 00                	push   $0x0
  802e5e:	6a 00                	push   $0x0
  802e60:	6a 00                	push   $0x0
  802e62:	ff 75 0c             	pushl  0xc(%ebp)
  802e65:	ff 75 08             	pushl  0x8(%ebp)
  802e68:	6a 2d                	push   $0x2d
  802e6a:	e8 95 fa ff ff       	call   802904 <syscall>
  802e6f:	83 c4 18             	add    $0x18,%esp
	return;
  802e72:	90                   	nop
}
  802e73:	c9                   	leave  
  802e74:	c3                   	ret    

00802e75 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802e75:	55                   	push   %ebp
  802e76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802e78:	6a 00                	push   $0x0
  802e7a:	6a 00                	push   $0x0
  802e7c:	6a 00                	push   $0x0
  802e7e:	ff 75 0c             	pushl  0xc(%ebp)
  802e81:	ff 75 08             	pushl  0x8(%ebp)
  802e84:	6a 2c                	push   $0x2c
  802e86:	e8 79 fa ff ff       	call   802904 <syscall>
  802e8b:	83 c4 18             	add    $0x18,%esp
	return ;
  802e8e:	90                   	nop
}
  802e8f:	c9                   	leave  
  802e90:	c3                   	ret    

00802e91 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802e91:	55                   	push   %ebp
  802e92:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802e94:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	6a 00                	push   $0x0
  802e9c:	6a 00                	push   $0x0
  802e9e:	6a 00                	push   $0x0
  802ea0:	52                   	push   %edx
  802ea1:	50                   	push   %eax
  802ea2:	6a 2e                	push   $0x2e
  802ea4:	e8 5b fa ff ff       	call   802904 <syscall>
  802ea9:	83 c4 18             	add    $0x18,%esp
	return ;
  802eac:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802ead:	c9                   	leave  
  802eae:	c3                   	ret    

00802eaf <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802eaf:	55                   	push   %ebp
  802eb0:	89 e5                	mov    %esp,%ebp
  802eb2:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802eb5:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802ebc:	72 09                	jb     802ec7 <to_page_va+0x18>
  802ebe:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802ec5:	72 14                	jb     802edb <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802ec7:	83 ec 04             	sub    $0x4,%esp
  802eca:	68 54 4b 80 00       	push   $0x804b54
  802ecf:	6a 15                	push   $0x15
  802ed1:	68 7f 4b 80 00       	push   $0x804b7f
  802ed6:	e8 46 d9 ff ff       	call   800821 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	ba 60 50 80 00       	mov    $0x805060,%edx
  802ee3:	29 d0                	sub    %edx,%eax
  802ee5:	c1 f8 02             	sar    $0x2,%eax
  802ee8:	89 c2                	mov    %eax,%edx
  802eea:	89 d0                	mov    %edx,%eax
  802eec:	c1 e0 02             	shl    $0x2,%eax
  802eef:	01 d0                	add    %edx,%eax
  802ef1:	c1 e0 02             	shl    $0x2,%eax
  802ef4:	01 d0                	add    %edx,%eax
  802ef6:	c1 e0 02             	shl    $0x2,%eax
  802ef9:	01 d0                	add    %edx,%eax
  802efb:	89 c1                	mov    %eax,%ecx
  802efd:	c1 e1 08             	shl    $0x8,%ecx
  802f00:	01 c8                	add    %ecx,%eax
  802f02:	89 c1                	mov    %eax,%ecx
  802f04:	c1 e1 10             	shl    $0x10,%ecx
  802f07:	01 c8                	add    %ecx,%eax
  802f09:	01 c0                	add    %eax,%eax
  802f0b:	01 d0                	add    %edx,%eax
  802f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	c1 e0 0c             	shl    $0xc,%eax
  802f16:	89 c2                	mov    %eax,%edx
  802f18:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802f1d:	01 d0                	add    %edx,%eax
}
  802f1f:	c9                   	leave  
  802f20:	c3                   	ret    

00802f21 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802f21:	55                   	push   %ebp
  802f22:	89 e5                	mov    %esp,%ebp
  802f24:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802f27:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2f:	29 c2                	sub    %eax,%edx
  802f31:	89 d0                	mov    %edx,%eax
  802f33:	c1 e8 0c             	shr    $0xc,%eax
  802f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802f39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3d:	78 09                	js     802f48 <to_page_info+0x27>
  802f3f:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802f46:	7e 14                	jle    802f5c <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802f48:	83 ec 04             	sub    $0x4,%esp
  802f4b:	68 98 4b 80 00       	push   $0x804b98
  802f50:	6a 22                	push   $0x22
  802f52:	68 7f 4b 80 00       	push   $0x804b7f
  802f57:	e8 c5 d8 ff ff       	call   800821 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802f5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5f:	89 d0                	mov    %edx,%eax
  802f61:	01 c0                	add    %eax,%eax
  802f63:	01 d0                	add    %edx,%eax
  802f65:	c1 e0 02             	shl    $0x2,%eax
  802f68:	05 60 50 80 00       	add    $0x805060,%eax
}
  802f6d:	c9                   	leave  
  802f6e:	c3                   	ret    

00802f6f <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802f6f:	55                   	push   %ebp
  802f70:	89 e5                	mov    %esp,%ebp
  802f72:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	05 00 00 00 02       	add    $0x2000000,%eax
  802f7d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f80:	73 16                	jae    802f98 <initialize_dynamic_allocator+0x29>
  802f82:	68 bc 4b 80 00       	push   $0x804bbc
  802f87:	68 e2 4b 80 00       	push   $0x804be2
  802f8c:	6a 34                	push   $0x34
  802f8e:	68 7f 4b 80 00       	push   $0x804b7f
  802f93:	e8 89 d8 ff ff       	call   800821 <_panic>
		is_initialized = 1;
  802f98:	c7 05 38 50 80 00 01 	movl   $0x1,0x805038
  802f9f:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	a3 68 d0 81 00       	mov    %eax,0x81d068
	dynAllocEnd = daEnd;
  802faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fad:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802fb2:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802fb9:	00 00 00 
  802fbc:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802fc3:	00 00 00 
  802fc6:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802fcd:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802fd0:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802fd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802fde:	eb 36                	jmp    803016 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	c1 e0 04             	shl    $0x4,%eax
  802fe6:	05 80 d0 81 00       	add    $0x81d080,%eax
  802feb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff4:	c1 e0 04             	shl    $0x4,%eax
  802ff7:	05 84 d0 81 00       	add    $0x81d084,%eax
  802ffc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	c1 e0 04             	shl    $0x4,%eax
  803008:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80300d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  803013:	ff 45 f4             	incl   -0xc(%ebp)
  803016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803019:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80301c:	72 c2                	jb     802fe0 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  80301e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  803024:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803029:	29 c2                	sub    %eax,%edx
  80302b:	89 d0                	mov    %edx,%eax
  80302d:	c1 e8 0c             	shr    $0xc,%eax
  803030:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  803033:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80303a:	e9 c8 00 00 00       	jmp    803107 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  80303f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803042:	89 d0                	mov    %edx,%eax
  803044:	01 c0                	add    %eax,%eax
  803046:	01 d0                	add    %edx,%eax
  803048:	c1 e0 02             	shl    $0x2,%eax
  80304b:	05 68 50 80 00       	add    $0x805068,%eax
  803050:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  803055:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803058:	89 d0                	mov    %edx,%eax
  80305a:	01 c0                	add    %eax,%eax
  80305c:	01 d0                	add    %edx,%eax
  80305e:	c1 e0 02             	shl    $0x2,%eax
  803061:	05 6a 50 80 00       	add    $0x80506a,%eax
  803066:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80306b:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803071:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803074:	89 c8                	mov    %ecx,%eax
  803076:	01 c0                	add    %eax,%eax
  803078:	01 c8                	add    %ecx,%eax
  80307a:	c1 e0 02             	shl    $0x2,%eax
  80307d:	05 64 50 80 00       	add    $0x805064,%eax
  803082:	89 10                	mov    %edx,(%eax)
  803084:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803087:	89 d0                	mov    %edx,%eax
  803089:	01 c0                	add    %eax,%eax
  80308b:	01 d0                	add    %edx,%eax
  80308d:	c1 e0 02             	shl    $0x2,%eax
  803090:	05 64 50 80 00       	add    $0x805064,%eax
  803095:	8b 00                	mov    (%eax),%eax
  803097:	85 c0                	test   %eax,%eax
  803099:	74 1b                	je     8030b6 <initialize_dynamic_allocator+0x147>
  80309b:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8030a1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8030a4:	89 c8                	mov    %ecx,%eax
  8030a6:	01 c0                	add    %eax,%eax
  8030a8:	01 c8                	add    %ecx,%eax
  8030aa:	c1 e0 02             	shl    $0x2,%eax
  8030ad:	05 60 50 80 00       	add    $0x805060,%eax
  8030b2:	89 02                	mov    %eax,(%edx)
  8030b4:	eb 16                	jmp    8030cc <initialize_dynamic_allocator+0x15d>
  8030b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030b9:	89 d0                	mov    %edx,%eax
  8030bb:	01 c0                	add    %eax,%eax
  8030bd:	01 d0                	add    %edx,%eax
  8030bf:	c1 e0 02             	shl    $0x2,%eax
  8030c2:	05 60 50 80 00       	add    $0x805060,%eax
  8030c7:	a3 48 50 80 00       	mov    %eax,0x805048
  8030cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030cf:	89 d0                	mov    %edx,%eax
  8030d1:	01 c0                	add    %eax,%eax
  8030d3:	01 d0                	add    %edx,%eax
  8030d5:	c1 e0 02             	shl    $0x2,%eax
  8030d8:	05 60 50 80 00       	add    $0x805060,%eax
  8030dd:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8030e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030e5:	89 d0                	mov    %edx,%eax
  8030e7:	01 c0                	add    %eax,%eax
  8030e9:	01 d0                	add    %edx,%eax
  8030eb:	c1 e0 02             	shl    $0x2,%eax
  8030ee:	05 60 50 80 00       	add    $0x805060,%eax
  8030f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f9:	a1 54 50 80 00       	mov    0x805054,%eax
  8030fe:	40                   	inc    %eax
  8030ff:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803104:	ff 45 f0             	incl   -0x10(%ebp)
  803107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80310d:	0f 82 2c ff ff ff    	jb     80303f <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803116:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803119:	eb 2f                	jmp    80314a <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  80311b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80311e:	89 d0                	mov    %edx,%eax
  803120:	01 c0                	add    %eax,%eax
  803122:	01 d0                	add    %edx,%eax
  803124:	c1 e0 02             	shl    $0x2,%eax
  803127:	05 68 50 80 00       	add    $0x805068,%eax
  80312c:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803131:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803134:	89 d0                	mov    %edx,%eax
  803136:	01 c0                	add    %eax,%eax
  803138:	01 d0                	add    %edx,%eax
  80313a:	c1 e0 02             	shl    $0x2,%eax
  80313d:	05 6a 50 80 00       	add    $0x80506a,%eax
  803142:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803147:	ff 45 ec             	incl   -0x14(%ebp)
  80314a:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803151:	76 c8                	jbe    80311b <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803153:	90                   	nop
  803154:	c9                   	leave  
  803155:	c3                   	ret    

00803156 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803156:	55                   	push   %ebp
  803157:	89 e5                	mov    %esp,%ebp
  803159:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  80315c:	8b 55 08             	mov    0x8(%ebp),%edx
  80315f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803164:	29 c2                	sub    %eax,%edx
  803166:	89 d0                	mov    %edx,%eax
  803168:	c1 e8 0c             	shr    $0xc,%eax
  80316b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  80316e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803171:	89 d0                	mov    %edx,%eax
  803173:	01 c0                	add    %eax,%eax
  803175:	01 d0                	add    %edx,%eax
  803177:	c1 e0 02             	shl    $0x2,%eax
  80317a:	05 68 50 80 00       	add    $0x805068,%eax
  80317f:	8b 00                	mov    (%eax),%eax
  803181:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803184:	c9                   	leave  
  803185:	c3                   	ret    

00803186 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803186:	55                   	push   %ebp
  803187:	89 e5                	mov    %esp,%ebp
  803189:	83 ec 14             	sub    $0x14,%esp
  80318c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  80318f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803193:	77 07                	ja     80319c <nearest_pow2_ceil.1513+0x16>
  803195:	b8 01 00 00 00       	mov    $0x1,%eax
  80319a:	eb 20                	jmp    8031bc <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  80319c:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  8031a3:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  8031a6:	eb 08                	jmp    8031b0 <nearest_pow2_ceil.1513+0x2a>
  8031a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031ab:	01 c0                	add    %eax,%eax
  8031ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8031b0:	d1 6d 08             	shrl   0x8(%ebp)
  8031b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b7:	75 ef                	jne    8031a8 <nearest_pow2_ceil.1513+0x22>
        return power;
  8031b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8031bc:	c9                   	leave  
  8031bd:	c3                   	ret    

008031be <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8031be:	55                   	push   %ebp
  8031bf:	89 e5                	mov    %esp,%ebp
  8031c1:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8031c4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8031cb:	76 16                	jbe    8031e3 <alloc_block+0x25>
  8031cd:	68 f8 4b 80 00       	push   $0x804bf8
  8031d2:	68 e2 4b 80 00       	push   $0x804be2
  8031d7:	6a 72                	push   $0x72
  8031d9:	68 7f 4b 80 00       	push   $0x804b7f
  8031de:	e8 3e d6 ff ff       	call   800821 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  8031e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e7:	75 0a                	jne    8031f3 <alloc_block+0x35>
  8031e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ee:	e9 bd 04 00 00       	jmp    8036b0 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8031f3:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803200:	73 06                	jae    803208 <alloc_block+0x4a>
        size = min_block_size;
  803202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803205:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  803208:	83 ec 0c             	sub    $0xc,%esp
  80320b:	8d 45 cc             	lea    -0x34(%ebp),%eax
  80320e:	ff 75 08             	pushl  0x8(%ebp)
  803211:	89 c1                	mov    %eax,%ecx
  803213:	e8 6e ff ff ff       	call   803186 <nearest_pow2_ceil.1513>
  803218:	83 c4 10             	add    $0x10,%esp
  80321b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  80321e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803221:	83 ec 0c             	sub    $0xc,%esp
  803224:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803227:	52                   	push   %edx
  803228:	89 c1                	mov    %eax,%ecx
  80322a:	e8 83 04 00 00       	call   8036b2 <log2_ceil.1520>
  80322f:	83 c4 10             	add    $0x10,%esp
  803232:	83 e8 03             	sub    $0x3,%eax
  803235:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  803238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323b:	c1 e0 04             	shl    $0x4,%eax
  80323e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803243:	8b 00                	mov    (%eax),%eax
  803245:	85 c0                	test   %eax,%eax
  803247:	0f 84 d8 00 00 00    	je     803325 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  80324d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803250:	c1 e0 04             	shl    $0x4,%eax
  803253:	05 80 d0 81 00       	add    $0x81d080,%eax
  803258:	8b 00                	mov    (%eax),%eax
  80325a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  80325d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803261:	75 17                	jne    80327a <alloc_block+0xbc>
  803263:	83 ec 04             	sub    $0x4,%esp
  803266:	68 19 4c 80 00       	push   $0x804c19
  80326b:	68 98 00 00 00       	push   $0x98
  803270:	68 7f 4b 80 00       	push   $0x804b7f
  803275:	e8 a7 d5 ff ff       	call   800821 <_panic>
  80327a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80327d:	8b 00                	mov    (%eax),%eax
  80327f:	85 c0                	test   %eax,%eax
  803281:	74 10                	je     803293 <alloc_block+0xd5>
  803283:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803286:	8b 00                	mov    (%eax),%eax
  803288:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80328b:	8b 52 04             	mov    0x4(%edx),%edx
  80328e:	89 50 04             	mov    %edx,0x4(%eax)
  803291:	eb 14                	jmp    8032a7 <alloc_block+0xe9>
  803293:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803296:	8b 40 04             	mov    0x4(%eax),%eax
  803299:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80329c:	c1 e2 04             	shl    $0x4,%edx
  80329f:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8032a5:	89 02                	mov    %eax,(%edx)
  8032a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032aa:	8b 40 04             	mov    0x4(%eax),%eax
  8032ad:	85 c0                	test   %eax,%eax
  8032af:	74 0f                	je     8032c0 <alloc_block+0x102>
  8032b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032b4:	8b 40 04             	mov    0x4(%eax),%eax
  8032b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032ba:	8b 12                	mov    (%edx),%edx
  8032bc:	89 10                	mov    %edx,(%eax)
  8032be:	eb 13                	jmp    8032d3 <alloc_block+0x115>
  8032c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c3:	8b 00                	mov    (%eax),%eax
  8032c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032c8:	c1 e2 04             	shl    $0x4,%edx
  8032cb:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8032d1:	89 02                	mov    %eax,(%edx)
  8032d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e9:	c1 e0 04             	shl    $0x4,%eax
  8032ec:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032f1:	8b 00                	mov    (%eax),%eax
  8032f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8032f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f9:	c1 e0 04             	shl    $0x4,%eax
  8032fc:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803301:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803303:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803306:	83 ec 0c             	sub    $0xc,%esp
  803309:	50                   	push   %eax
  80330a:	e8 12 fc ff ff       	call   802f21 <to_page_info>
  80330f:	83 c4 10             	add    $0x10,%esp
  803312:	89 c2                	mov    %eax,%edx
  803314:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803318:	48                   	dec    %eax
  803319:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  80331d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803320:	e9 8b 03 00 00       	jmp    8036b0 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  803325:	a1 48 50 80 00       	mov    0x805048,%eax
  80332a:	85 c0                	test   %eax,%eax
  80332c:	0f 84 64 02 00 00    	je     803596 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803332:	a1 48 50 80 00       	mov    0x805048,%eax
  803337:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  80333a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80333e:	75 17                	jne    803357 <alloc_block+0x199>
  803340:	83 ec 04             	sub    $0x4,%esp
  803343:	68 19 4c 80 00       	push   $0x804c19
  803348:	68 a0 00 00 00       	push   $0xa0
  80334d:	68 7f 4b 80 00       	push   $0x804b7f
  803352:	e8 ca d4 ff ff       	call   800821 <_panic>
  803357:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80335a:	8b 00                	mov    (%eax),%eax
  80335c:	85 c0                	test   %eax,%eax
  80335e:	74 10                	je     803370 <alloc_block+0x1b2>
  803360:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803363:	8b 00                	mov    (%eax),%eax
  803365:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803368:	8b 52 04             	mov    0x4(%edx),%edx
  80336b:	89 50 04             	mov    %edx,0x4(%eax)
  80336e:	eb 0b                	jmp    80337b <alloc_block+0x1bd>
  803370:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803373:	8b 40 04             	mov    0x4(%eax),%eax
  803376:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80337b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80337e:	8b 40 04             	mov    0x4(%eax),%eax
  803381:	85 c0                	test   %eax,%eax
  803383:	74 0f                	je     803394 <alloc_block+0x1d6>
  803385:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803388:	8b 40 04             	mov    0x4(%eax),%eax
  80338b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80338e:	8b 12                	mov    (%edx),%edx
  803390:	89 10                	mov    %edx,(%eax)
  803392:	eb 0a                	jmp    80339e <alloc_block+0x1e0>
  803394:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803397:	8b 00                	mov    (%eax),%eax
  803399:	a3 48 50 80 00       	mov    %eax,0x805048
  80339e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b1:	a1 54 50 80 00       	mov    0x805054,%eax
  8033b6:	48                   	dec    %eax
  8033b7:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  8033bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033c2:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  8033c6:	b8 00 10 00 00       	mov    $0x1000,%eax
  8033cb:	99                   	cltd   
  8033cc:	f7 7d e8             	idivl  -0x18(%ebp)
  8033cf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033d2:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  8033d6:	83 ec 0c             	sub    $0xc,%esp
  8033d9:	ff 75 dc             	pushl  -0x24(%ebp)
  8033dc:	e8 ce fa ff ff       	call   802eaf <to_page_va>
  8033e1:	83 c4 10             	add    $0x10,%esp
  8033e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  8033e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033ea:	83 ec 0c             	sub    $0xc,%esp
  8033ed:	50                   	push   %eax
  8033ee:	e8 c0 ee ff ff       	call   8022b3 <get_page>
  8033f3:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8033f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8033fd:	e9 aa 00 00 00       	jmp    8034ac <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803405:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  803409:	89 c2                	mov    %eax,%edx
  80340b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80340e:	01 d0                	add    %edx,%eax
  803410:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  803413:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803417:	75 17                	jne    803430 <alloc_block+0x272>
  803419:	83 ec 04             	sub    $0x4,%esp
  80341c:	68 38 4c 80 00       	push   $0x804c38
  803421:	68 aa 00 00 00       	push   $0xaa
  803426:	68 7f 4b 80 00       	push   $0x804b7f
  80342b:	e8 f1 d3 ff ff       	call   800821 <_panic>
  803430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803433:	c1 e0 04             	shl    $0x4,%eax
  803436:	05 84 d0 81 00       	add    $0x81d084,%eax
  80343b:	8b 10                	mov    (%eax),%edx
  80343d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803440:	89 50 04             	mov    %edx,0x4(%eax)
  803443:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803446:	8b 40 04             	mov    0x4(%eax),%eax
  803449:	85 c0                	test   %eax,%eax
  80344b:	74 14                	je     803461 <alloc_block+0x2a3>
  80344d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803450:	c1 e0 04             	shl    $0x4,%eax
  803453:	05 84 d0 81 00       	add    $0x81d084,%eax
  803458:	8b 00                	mov    (%eax),%eax
  80345a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80345d:	89 10                	mov    %edx,(%eax)
  80345f:	eb 11                	jmp    803472 <alloc_block+0x2b4>
  803461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803464:	c1 e0 04             	shl    $0x4,%eax
  803467:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  80346d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803470:	89 02                	mov    %eax,(%edx)
  803472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803475:	c1 e0 04             	shl    $0x4,%eax
  803478:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  80347e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803481:	89 02                	mov    %eax,(%edx)
  803483:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803486:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80348c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348f:	c1 e0 04             	shl    $0x4,%eax
  803492:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803497:	8b 00                	mov    (%eax),%eax
  803499:	8d 50 01             	lea    0x1(%eax),%edx
  80349c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80349f:	c1 e0 04             	shl    $0x4,%eax
  8034a2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8034a7:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8034a9:	ff 45 f4             	incl   -0xc(%ebp)
  8034ac:	b8 00 10 00 00       	mov    $0x1000,%eax
  8034b1:	99                   	cltd   
  8034b2:	f7 7d e8             	idivl  -0x18(%ebp)
  8034b5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8034b8:	0f 8f 44 ff ff ff    	jg     803402 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8034be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c1:	c1 e0 04             	shl    $0x4,%eax
  8034c4:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034c9:	8b 00                	mov    (%eax),%eax
  8034cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  8034ce:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034d2:	75 17                	jne    8034eb <alloc_block+0x32d>
  8034d4:	83 ec 04             	sub    $0x4,%esp
  8034d7:	68 19 4c 80 00       	push   $0x804c19
  8034dc:	68 ae 00 00 00       	push   $0xae
  8034e1:	68 7f 4b 80 00       	push   $0x804b7f
  8034e6:	e8 36 d3 ff ff       	call   800821 <_panic>
  8034eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034ee:	8b 00                	mov    (%eax),%eax
  8034f0:	85 c0                	test   %eax,%eax
  8034f2:	74 10                	je     803504 <alloc_block+0x346>
  8034f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034f7:	8b 00                	mov    (%eax),%eax
  8034f9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8034fc:	8b 52 04             	mov    0x4(%edx),%edx
  8034ff:	89 50 04             	mov    %edx,0x4(%eax)
  803502:	eb 14                	jmp    803518 <alloc_block+0x35a>
  803504:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803507:	8b 40 04             	mov    0x4(%eax),%eax
  80350a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80350d:	c1 e2 04             	shl    $0x4,%edx
  803510:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803516:	89 02                	mov    %eax,(%edx)
  803518:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80351b:	8b 40 04             	mov    0x4(%eax),%eax
  80351e:	85 c0                	test   %eax,%eax
  803520:	74 0f                	je     803531 <alloc_block+0x373>
  803522:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803525:	8b 40 04             	mov    0x4(%eax),%eax
  803528:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80352b:	8b 12                	mov    (%edx),%edx
  80352d:	89 10                	mov    %edx,(%eax)
  80352f:	eb 13                	jmp    803544 <alloc_block+0x386>
  803531:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803534:	8b 00                	mov    (%eax),%eax
  803536:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803539:	c1 e2 04             	shl    $0x4,%edx
  80353c:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803542:	89 02                	mov    %eax,(%edx)
  803544:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803547:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80354d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803550:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803557:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80355a:	c1 e0 04             	shl    $0x4,%eax
  80355d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803562:	8b 00                	mov    (%eax),%eax
  803564:	8d 50 ff             	lea    -0x1(%eax),%edx
  803567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356a:	c1 e0 04             	shl    $0x4,%eax
  80356d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803572:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803574:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803577:	83 ec 0c             	sub    $0xc,%esp
  80357a:	50                   	push   %eax
  80357b:	e8 a1 f9 ff ff       	call   802f21 <to_page_info>
  803580:	83 c4 10             	add    $0x10,%esp
  803583:	89 c2                	mov    %eax,%edx
  803585:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803589:	48                   	dec    %eax
  80358a:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  80358e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803591:	e9 1a 01 00 00       	jmp    8036b0 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803599:	40                   	inc    %eax
  80359a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80359d:	e9 ed 00 00 00       	jmp    80368f <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  8035a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a5:	c1 e0 04             	shl    $0x4,%eax
  8035a8:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035ad:	8b 00                	mov    (%eax),%eax
  8035af:	85 c0                	test   %eax,%eax
  8035b1:	0f 84 d5 00 00 00    	je     80368c <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  8035b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ba:	c1 e0 04             	shl    $0x4,%eax
  8035bd:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035c2:	8b 00                	mov    (%eax),%eax
  8035c4:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  8035c7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8035cb:	75 17                	jne    8035e4 <alloc_block+0x426>
  8035cd:	83 ec 04             	sub    $0x4,%esp
  8035d0:	68 19 4c 80 00       	push   $0x804c19
  8035d5:	68 b8 00 00 00       	push   $0xb8
  8035da:	68 7f 4b 80 00       	push   $0x804b7f
  8035df:	e8 3d d2 ff ff       	call   800821 <_panic>
  8035e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035e7:	8b 00                	mov    (%eax),%eax
  8035e9:	85 c0                	test   %eax,%eax
  8035eb:	74 10                	je     8035fd <alloc_block+0x43f>
  8035ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035f0:	8b 00                	mov    (%eax),%eax
  8035f2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8035f5:	8b 52 04             	mov    0x4(%edx),%edx
  8035f8:	89 50 04             	mov    %edx,0x4(%eax)
  8035fb:	eb 14                	jmp    803611 <alloc_block+0x453>
  8035fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803600:	8b 40 04             	mov    0x4(%eax),%eax
  803603:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803606:	c1 e2 04             	shl    $0x4,%edx
  803609:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80360f:	89 02                	mov    %eax,(%edx)
  803611:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803614:	8b 40 04             	mov    0x4(%eax),%eax
  803617:	85 c0                	test   %eax,%eax
  803619:	74 0f                	je     80362a <alloc_block+0x46c>
  80361b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80361e:	8b 40 04             	mov    0x4(%eax),%eax
  803621:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803624:	8b 12                	mov    (%edx),%edx
  803626:	89 10                	mov    %edx,(%eax)
  803628:	eb 13                	jmp    80363d <alloc_block+0x47f>
  80362a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80362d:	8b 00                	mov    (%eax),%eax
  80362f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803632:	c1 e2 04             	shl    $0x4,%edx
  803635:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80363b:	89 02                	mov    %eax,(%edx)
  80363d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803646:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803649:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803650:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803653:	c1 e0 04             	shl    $0x4,%eax
  803656:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80365b:	8b 00                	mov    (%eax),%eax
  80365d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803663:	c1 e0 04             	shl    $0x4,%eax
  803666:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80366b:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  80366d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803670:	83 ec 0c             	sub    $0xc,%esp
  803673:	50                   	push   %eax
  803674:	e8 a8 f8 ff ff       	call   802f21 <to_page_info>
  803679:	83 c4 10             	add    $0x10,%esp
  80367c:	89 c2                	mov    %eax,%edx
  80367e:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803682:	48                   	dec    %eax
  803683:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  803687:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80368a:	eb 24                	jmp    8036b0 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  80368c:	ff 45 f0             	incl   -0x10(%ebp)
  80368f:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803693:	0f 8e 09 ff ff ff    	jle    8035a2 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  803699:	83 ec 04             	sub    $0x4,%esp
  80369c:	68 5b 4c 80 00       	push   $0x804c5b
  8036a1:	68 bf 00 00 00       	push   $0xbf
  8036a6:	68 7f 4b 80 00       	push   $0x804b7f
  8036ab:	e8 71 d1 ff ff       	call   800821 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8036b0:	c9                   	leave  
  8036b1:	c3                   	ret    

008036b2 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  8036b2:	55                   	push   %ebp
  8036b3:	89 e5                	mov    %esp,%ebp
  8036b5:	83 ec 14             	sub    $0x14,%esp
  8036b8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  8036bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036bf:	75 07                	jne    8036c8 <log2_ceil.1520+0x16>
  8036c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c6:	eb 1b                	jmp    8036e3 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  8036c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  8036cf:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  8036d2:	eb 06                	jmp    8036da <log2_ceil.1520+0x28>
            x >>= 1;
  8036d4:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  8036d7:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8036da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036de:	75 f4                	jne    8036d4 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  8036e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8036e3:	c9                   	leave  
  8036e4:	c3                   	ret    

008036e5 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  8036e5:	55                   	push   %ebp
  8036e6:	89 e5                	mov    %esp,%ebp
  8036e8:	83 ec 14             	sub    $0x14,%esp
  8036eb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  8036ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f2:	75 07                	jne    8036fb <log2_ceil.1547+0x16>
  8036f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f9:	eb 1b                	jmp    803716 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  8036fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803702:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  803705:	eb 06                	jmp    80370d <log2_ceil.1547+0x28>
			x >>= 1;
  803707:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  80370a:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  80370d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803711:	75 f4                	jne    803707 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  803713:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803716:	c9                   	leave  
  803717:	c3                   	ret    

00803718 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803718:	55                   	push   %ebp
  803719:	89 e5                	mov    %esp,%ebp
  80371b:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80371e:	8b 55 08             	mov    0x8(%ebp),%edx
  803721:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803726:	39 c2                	cmp    %eax,%edx
  803728:	72 0c                	jb     803736 <free_block+0x1e>
  80372a:	8b 55 08             	mov    0x8(%ebp),%edx
  80372d:	a1 40 50 80 00       	mov    0x805040,%eax
  803732:	39 c2                	cmp    %eax,%edx
  803734:	72 19                	jb     80374f <free_block+0x37>
  803736:	68 60 4c 80 00       	push   $0x804c60
  80373b:	68 e2 4b 80 00       	push   $0x804be2
  803740:	68 d0 00 00 00       	push   $0xd0
  803745:	68 7f 4b 80 00       	push   $0x804b7f
  80374a:	e8 d2 d0 ff ff       	call   800821 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80374f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803753:	0f 84 42 03 00 00    	je     803a9b <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  803759:	8b 55 08             	mov    0x8(%ebp),%edx
  80375c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803761:	39 c2                	cmp    %eax,%edx
  803763:	72 0c                	jb     803771 <free_block+0x59>
  803765:	8b 55 08             	mov    0x8(%ebp),%edx
  803768:	a1 40 50 80 00       	mov    0x805040,%eax
  80376d:	39 c2                	cmp    %eax,%edx
  80376f:	72 17                	jb     803788 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803771:	83 ec 04             	sub    $0x4,%esp
  803774:	68 98 4c 80 00       	push   $0x804c98
  803779:	68 e6 00 00 00       	push   $0xe6
  80377e:	68 7f 4b 80 00       	push   $0x804b7f
  803783:	e8 99 d0 ff ff       	call   800821 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  803788:	8b 55 08             	mov    0x8(%ebp),%edx
  80378b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803790:	29 c2                	sub    %eax,%edx
  803792:	89 d0                	mov    %edx,%eax
  803794:	83 e0 07             	and    $0x7,%eax
  803797:	85 c0                	test   %eax,%eax
  803799:	74 17                	je     8037b2 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  80379b:	83 ec 04             	sub    $0x4,%esp
  80379e:	68 cc 4c 80 00       	push   $0x804ccc
  8037a3:	68 ea 00 00 00       	push   $0xea
  8037a8:	68 7f 4b 80 00       	push   $0x804b7f
  8037ad:	e8 6f d0 ff ff       	call   800821 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8037b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b5:	83 ec 0c             	sub    $0xc,%esp
  8037b8:	50                   	push   %eax
  8037b9:	e8 63 f7 ff ff       	call   802f21 <to_page_info>
  8037be:	83 c4 10             	add    $0x10,%esp
  8037c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8037c4:	83 ec 0c             	sub    $0xc,%esp
  8037c7:	ff 75 08             	pushl  0x8(%ebp)
  8037ca:	e8 87 f9 ff ff       	call   803156 <get_block_size>
  8037cf:	83 c4 10             	add    $0x10,%esp
  8037d2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8037d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037d9:	75 17                	jne    8037f2 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8037db:	83 ec 04             	sub    $0x4,%esp
  8037de:	68 f8 4c 80 00       	push   $0x804cf8
  8037e3:	68 f1 00 00 00       	push   $0xf1
  8037e8:	68 7f 4b 80 00       	push   $0x804b7f
  8037ed:	e8 2f d0 ff ff       	call   800821 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8037f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037f5:	83 ec 0c             	sub    $0xc,%esp
  8037f8:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8037fb:	52                   	push   %edx
  8037fc:	89 c1                	mov    %eax,%ecx
  8037fe:	e8 e2 fe ff ff       	call   8036e5 <log2_ceil.1547>
  803803:	83 c4 10             	add    $0x10,%esp
  803806:	83 e8 03             	sub    $0x3,%eax
  803809:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  80380c:	8b 45 08             	mov    0x8(%ebp),%eax
  80380f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  803812:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803816:	75 17                	jne    80382f <free_block+0x117>
  803818:	83 ec 04             	sub    $0x4,%esp
  80381b:	68 44 4d 80 00       	push   $0x804d44
  803820:	68 f6 00 00 00       	push   $0xf6
  803825:	68 7f 4b 80 00       	push   $0x804b7f
  80382a:	e8 f2 cf ff ff       	call   800821 <_panic>
  80382f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803832:	c1 e0 04             	shl    $0x4,%eax
  803835:	05 80 d0 81 00       	add    $0x81d080,%eax
  80383a:	8b 10                	mov    (%eax),%edx
  80383c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80383f:	89 10                	mov    %edx,(%eax)
  803841:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803844:	8b 00                	mov    (%eax),%eax
  803846:	85 c0                	test   %eax,%eax
  803848:	74 15                	je     80385f <free_block+0x147>
  80384a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384d:	c1 e0 04             	shl    $0x4,%eax
  803850:	05 80 d0 81 00       	add    $0x81d080,%eax
  803855:	8b 00                	mov    (%eax),%eax
  803857:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80385a:	89 50 04             	mov    %edx,0x4(%eax)
  80385d:	eb 11                	jmp    803870 <free_block+0x158>
  80385f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803862:	c1 e0 04             	shl    $0x4,%eax
  803865:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  80386b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80386e:	89 02                	mov    %eax,(%edx)
  803870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803873:	c1 e0 04             	shl    $0x4,%eax
  803876:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  80387c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80387f:	89 02                	mov    %eax,(%edx)
  803881:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803884:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80388b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388e:	c1 e0 04             	shl    $0x4,%eax
  803891:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803896:	8b 00                	mov    (%eax),%eax
  803898:	8d 50 01             	lea    0x1(%eax),%edx
  80389b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389e:	c1 e0 04             	shl    $0x4,%eax
  8038a1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8038a6:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8038a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ab:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8038af:	40                   	inc    %eax
  8038b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038b3:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8038b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8038ba:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8038bf:	29 c2                	sub    %eax,%edx
  8038c1:	89 d0                	mov    %edx,%eax
  8038c3:	c1 e8 0c             	shr    $0xc,%eax
  8038c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8038c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038cc:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8038d0:	0f b7 c8             	movzwl %ax,%ecx
  8038d3:	b8 00 10 00 00       	mov    $0x1000,%eax
  8038d8:	99                   	cltd   
  8038d9:	f7 7d e8             	idivl  -0x18(%ebp)
  8038dc:	39 c1                	cmp    %eax,%ecx
  8038de:	0f 85 b8 01 00 00    	jne    803a9c <free_block+0x384>
    	uint32 blocks_removed = 0;
  8038e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8038eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ee:	c1 e0 04             	shl    $0x4,%eax
  8038f1:	05 80 d0 81 00       	add    $0x81d080,%eax
  8038f6:	8b 00                	mov    (%eax),%eax
  8038f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8038fb:	e9 d5 00 00 00       	jmp    8039d5 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803903:	8b 00                	mov    (%eax),%eax
  803905:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803908:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80390b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803910:	29 c2                	sub    %eax,%edx
  803912:	89 d0                	mov    %edx,%eax
  803914:	c1 e8 0c             	shr    $0xc,%eax
  803917:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  80391a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80391d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803920:	0f 85 a9 00 00 00    	jne    8039cf <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  803926:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80392a:	75 17                	jne    803943 <free_block+0x22b>
  80392c:	83 ec 04             	sub    $0x4,%esp
  80392f:	68 19 4c 80 00       	push   $0x804c19
  803934:	68 04 01 00 00       	push   $0x104
  803939:	68 7f 4b 80 00       	push   $0x804b7f
  80393e:	e8 de ce ff ff       	call   800821 <_panic>
  803943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803946:	8b 00                	mov    (%eax),%eax
  803948:	85 c0                	test   %eax,%eax
  80394a:	74 10                	je     80395c <free_block+0x244>
  80394c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80394f:	8b 00                	mov    (%eax),%eax
  803951:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803954:	8b 52 04             	mov    0x4(%edx),%edx
  803957:	89 50 04             	mov    %edx,0x4(%eax)
  80395a:	eb 14                	jmp    803970 <free_block+0x258>
  80395c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80395f:	8b 40 04             	mov    0x4(%eax),%eax
  803962:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803965:	c1 e2 04             	shl    $0x4,%edx
  803968:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80396e:	89 02                	mov    %eax,(%edx)
  803970:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803973:	8b 40 04             	mov    0x4(%eax),%eax
  803976:	85 c0                	test   %eax,%eax
  803978:	74 0f                	je     803989 <free_block+0x271>
  80397a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80397d:	8b 40 04             	mov    0x4(%eax),%eax
  803980:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803983:	8b 12                	mov    (%edx),%edx
  803985:	89 10                	mov    %edx,(%eax)
  803987:	eb 13                	jmp    80399c <free_block+0x284>
  803989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80398c:	8b 00                	mov    (%eax),%eax
  80398e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803991:	c1 e2 04             	shl    $0x4,%edx
  803994:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80399a:	89 02                	mov    %eax,(%edx)
  80399c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80399f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b2:	c1 e0 04             	shl    $0x4,%eax
  8039b5:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8039ba:	8b 00                	mov    (%eax),%eax
  8039bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8039bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c2:	c1 e0 04             	shl    $0x4,%eax
  8039c5:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8039ca:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8039cc:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8039cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8039d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039d9:	0f 85 21 ff ff ff    	jne    803900 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8039df:	b8 00 10 00 00       	mov    $0x1000,%eax
  8039e4:	99                   	cltd   
  8039e5:	f7 7d e8             	idivl  -0x18(%ebp)
  8039e8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8039eb:	74 17                	je     803a04 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8039ed:	83 ec 04             	sub    $0x4,%esp
  8039f0:	68 68 4d 80 00       	push   $0x804d68
  8039f5:	68 0c 01 00 00       	push   $0x10c
  8039fa:	68 7f 4b 80 00       	push   $0x804b7f
  8039ff:	e8 1d ce ff ff       	call   800821 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a07:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a10:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803a16:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a1a:	75 17                	jne    803a33 <free_block+0x31b>
  803a1c:	83 ec 04             	sub    $0x4,%esp
  803a1f:	68 38 4c 80 00       	push   $0x804c38
  803a24:	68 11 01 00 00       	push   $0x111
  803a29:	68 7f 4b 80 00       	push   $0x804b7f
  803a2e:	e8 ee cd ff ff       	call   800821 <_panic>
  803a33:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803a39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a3c:	89 50 04             	mov    %edx,0x4(%eax)
  803a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a42:	8b 40 04             	mov    0x4(%eax),%eax
  803a45:	85 c0                	test   %eax,%eax
  803a47:	74 0c                	je     803a55 <free_block+0x33d>
  803a49:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803a4e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a51:	89 10                	mov    %edx,(%eax)
  803a53:	eb 08                	jmp    803a5d <free_block+0x345>
  803a55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a58:	a3 48 50 80 00       	mov    %eax,0x805048
  803a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a60:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a6e:	a1 54 50 80 00       	mov    0x805054,%eax
  803a73:	40                   	inc    %eax
  803a74:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803a79:	83 ec 0c             	sub    $0xc,%esp
  803a7c:	ff 75 ec             	pushl  -0x14(%ebp)
  803a7f:	e8 2b f4 ff ff       	call   802eaf <to_page_va>
  803a84:	83 c4 10             	add    $0x10,%esp
  803a87:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803a8a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a8d:	83 ec 0c             	sub    $0xc,%esp
  803a90:	50                   	push   %eax
  803a91:	e8 69 e8 ff ff       	call   8022ff <return_page>
  803a96:	83 c4 10             	add    $0x10,%esp
  803a99:	eb 01                	jmp    803a9c <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803a9b:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803a9c:	c9                   	leave  
  803a9d:	c3                   	ret    

00803a9e <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803a9e:	55                   	push   %ebp
  803a9f:	89 e5                	mov    %esp,%ebp
  803aa1:	83 ec 14             	sub    $0x14,%esp
  803aa4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803aa7:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803aab:	77 07                	ja     803ab4 <nearest_pow2_ceil.1572+0x16>
      return 1;
  803aad:	b8 01 00 00 00       	mov    $0x1,%eax
  803ab2:	eb 20                	jmp    803ad4 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803ab4:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803abb:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803abe:	eb 08                	jmp    803ac8 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803ac0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803ac3:	01 c0                	add    %eax,%eax
  803ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803ac8:	d1 6d 08             	shrl   0x8(%ebp)
  803acb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803acf:	75 ef                	jne    803ac0 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803ad1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803ad4:	c9                   	leave  
  803ad5:	c3                   	ret    

00803ad6 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803ad6:	55                   	push   %ebp
  803ad7:	89 e5                	mov    %esp,%ebp
  803ad9:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803adc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ae0:	75 13                	jne    803af5 <realloc_block+0x1f>
    return alloc_block(new_size);
  803ae2:	83 ec 0c             	sub    $0xc,%esp
  803ae5:	ff 75 0c             	pushl  0xc(%ebp)
  803ae8:	e8 d1 f6 ff ff       	call   8031be <alloc_block>
  803aed:	83 c4 10             	add    $0x10,%esp
  803af0:	e9 d9 00 00 00       	jmp    803bce <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803af5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803af9:	75 18                	jne    803b13 <realloc_block+0x3d>
    free_block(va);
  803afb:	83 ec 0c             	sub    $0xc,%esp
  803afe:	ff 75 08             	pushl  0x8(%ebp)
  803b01:	e8 12 fc ff ff       	call   803718 <free_block>
  803b06:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803b09:	b8 00 00 00 00       	mov    $0x0,%eax
  803b0e:	e9 bb 00 00 00       	jmp    803bce <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803b13:	83 ec 0c             	sub    $0xc,%esp
  803b16:	ff 75 08             	pushl  0x8(%ebp)
  803b19:	e8 38 f6 ff ff       	call   803156 <get_block_size>
  803b1e:	83 c4 10             	add    $0x10,%esp
  803b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803b24:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b2e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803b31:	73 06                	jae    803b39 <realloc_block+0x63>
    new_size = min_block_size;
  803b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b36:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803b39:	83 ec 0c             	sub    $0xc,%esp
  803b3c:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803b3f:	ff 75 0c             	pushl  0xc(%ebp)
  803b42:	89 c1                	mov    %eax,%ecx
  803b44:	e8 55 ff ff ff       	call   803a9e <nearest_pow2_ceil.1572>
  803b49:	83 c4 10             	add    $0x10,%esp
  803b4c:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803b4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803b55:	75 05                	jne    803b5c <realloc_block+0x86>
    return va;
  803b57:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5a:	eb 72                	jmp    803bce <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803b5c:	83 ec 0c             	sub    $0xc,%esp
  803b5f:	ff 75 0c             	pushl  0xc(%ebp)
  803b62:	e8 57 f6 ff ff       	call   8031be <alloc_block>
  803b67:	83 c4 10             	add    $0x10,%esp
  803b6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803b6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b71:	75 07                	jne    803b7a <realloc_block+0xa4>
    return NULL;
  803b73:	b8 00 00 00 00       	mov    $0x0,%eax
  803b78:	eb 54                	jmp    803bce <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803b7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b80:	39 d0                	cmp    %edx,%eax
  803b82:	76 02                	jbe    803b86 <realloc_block+0xb0>
  803b84:	89 d0                	mov    %edx,%eax
  803b86:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803b89:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803b8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b92:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803b9c:	eb 17                	jmp    803bb5 <realloc_block+0xdf>
    dst[i] = src[i];
  803b9e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba4:	01 c2                	add    %eax,%edx
  803ba6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bac:	01 c8                	add    %ecx,%eax
  803bae:	8a 00                	mov    (%eax),%al
  803bb0:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803bb2:	ff 45 f4             	incl   -0xc(%ebp)
  803bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803bbb:	72 e1                	jb     803b9e <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803bbd:	83 ec 0c             	sub    $0xc,%esp
  803bc0:	ff 75 08             	pushl  0x8(%ebp)
  803bc3:	e8 50 fb ff ff       	call   803718 <free_block>
  803bc8:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803bcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803bce:	c9                   	leave  
  803bcf:	c3                   	ret    

00803bd0 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803bd0:	55                   	push   %ebp
  803bd1:	89 e5                	mov    %esp,%ebp
  803bd3:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  803bd6:	83 ec 04             	sub    $0x4,%esp
  803bd9:	68 9c 4d 80 00       	push   $0x804d9c
  803bde:	6a 07                	push   $0x7
  803be0:	68 cb 4d 80 00       	push   $0x804dcb
  803be5:	e8 37 cc ff ff       	call   800821 <_panic>

00803bea <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803bea:	55                   	push   %ebp
  803beb:	89 e5                	mov    %esp,%ebp
  803bed:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  803bf0:	83 ec 04             	sub    $0x4,%esp
  803bf3:	68 dc 4d 80 00       	push   $0x804ddc
  803bf8:	6a 0b                	push   $0xb
  803bfa:	68 cb 4d 80 00       	push   $0x804dcb
  803bff:	e8 1d cc ff ff       	call   800821 <_panic>

00803c04 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  803c04:	55                   	push   %ebp
  803c05:	89 e5                	mov    %esp,%ebp
  803c07:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803c0a:	83 ec 04             	sub    $0x4,%esp
  803c0d:	68 08 4e 80 00       	push   $0x804e08
  803c12:	6a 10                	push   $0x10
  803c14:	68 cb 4d 80 00       	push   $0x804dcb
  803c19:	e8 03 cc ff ff       	call   800821 <_panic>

00803c1e <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  803c1e:	55                   	push   %ebp
  803c1f:	89 e5                	mov    %esp,%ebp
  803c21:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  803c24:	83 ec 04             	sub    $0x4,%esp
  803c27:	68 38 4e 80 00       	push   $0x804e38
  803c2c:	6a 15                	push   $0x15
  803c2e:	68 cb 4d 80 00       	push   $0x804dcb
  803c33:	e8 e9 cb ff ff       	call   800821 <_panic>

00803c38 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  803c38:	55                   	push   %ebp
  803c39:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3e:	8b 40 10             	mov    0x10(%eax),%eax
}
  803c41:	5d                   	pop    %ebp
  803c42:	c3                   	ret    
  803c43:	90                   	nop

00803c44 <__udivdi3>:
  803c44:	55                   	push   %ebp
  803c45:	57                   	push   %edi
  803c46:	56                   	push   %esi
  803c47:	53                   	push   %ebx
  803c48:	83 ec 1c             	sub    $0x1c,%esp
  803c4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c5b:	89 ca                	mov    %ecx,%edx
  803c5d:	89 f8                	mov    %edi,%eax
  803c5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c63:	85 f6                	test   %esi,%esi
  803c65:	75 2d                	jne    803c94 <__udivdi3+0x50>
  803c67:	39 cf                	cmp    %ecx,%edi
  803c69:	77 65                	ja     803cd0 <__udivdi3+0x8c>
  803c6b:	89 fd                	mov    %edi,%ebp
  803c6d:	85 ff                	test   %edi,%edi
  803c6f:	75 0b                	jne    803c7c <__udivdi3+0x38>
  803c71:	b8 01 00 00 00       	mov    $0x1,%eax
  803c76:	31 d2                	xor    %edx,%edx
  803c78:	f7 f7                	div    %edi
  803c7a:	89 c5                	mov    %eax,%ebp
  803c7c:	31 d2                	xor    %edx,%edx
  803c7e:	89 c8                	mov    %ecx,%eax
  803c80:	f7 f5                	div    %ebp
  803c82:	89 c1                	mov    %eax,%ecx
  803c84:	89 d8                	mov    %ebx,%eax
  803c86:	f7 f5                	div    %ebp
  803c88:	89 cf                	mov    %ecx,%edi
  803c8a:	89 fa                	mov    %edi,%edx
  803c8c:	83 c4 1c             	add    $0x1c,%esp
  803c8f:	5b                   	pop    %ebx
  803c90:	5e                   	pop    %esi
  803c91:	5f                   	pop    %edi
  803c92:	5d                   	pop    %ebp
  803c93:	c3                   	ret    
  803c94:	39 ce                	cmp    %ecx,%esi
  803c96:	77 28                	ja     803cc0 <__udivdi3+0x7c>
  803c98:	0f bd fe             	bsr    %esi,%edi
  803c9b:	83 f7 1f             	xor    $0x1f,%edi
  803c9e:	75 40                	jne    803ce0 <__udivdi3+0x9c>
  803ca0:	39 ce                	cmp    %ecx,%esi
  803ca2:	72 0a                	jb     803cae <__udivdi3+0x6a>
  803ca4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ca8:	0f 87 9e 00 00 00    	ja     803d4c <__udivdi3+0x108>
  803cae:	b8 01 00 00 00       	mov    $0x1,%eax
  803cb3:	89 fa                	mov    %edi,%edx
  803cb5:	83 c4 1c             	add    $0x1c,%esp
  803cb8:	5b                   	pop    %ebx
  803cb9:	5e                   	pop    %esi
  803cba:	5f                   	pop    %edi
  803cbb:	5d                   	pop    %ebp
  803cbc:	c3                   	ret    
  803cbd:	8d 76 00             	lea    0x0(%esi),%esi
  803cc0:	31 ff                	xor    %edi,%edi
  803cc2:	31 c0                	xor    %eax,%eax
  803cc4:	89 fa                	mov    %edi,%edx
  803cc6:	83 c4 1c             	add    $0x1c,%esp
  803cc9:	5b                   	pop    %ebx
  803cca:	5e                   	pop    %esi
  803ccb:	5f                   	pop    %edi
  803ccc:	5d                   	pop    %ebp
  803ccd:	c3                   	ret    
  803cce:	66 90                	xchg   %ax,%ax
  803cd0:	89 d8                	mov    %ebx,%eax
  803cd2:	f7 f7                	div    %edi
  803cd4:	31 ff                	xor    %edi,%edi
  803cd6:	89 fa                	mov    %edi,%edx
  803cd8:	83 c4 1c             	add    $0x1c,%esp
  803cdb:	5b                   	pop    %ebx
  803cdc:	5e                   	pop    %esi
  803cdd:	5f                   	pop    %edi
  803cde:	5d                   	pop    %ebp
  803cdf:	c3                   	ret    
  803ce0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ce5:	89 eb                	mov    %ebp,%ebx
  803ce7:	29 fb                	sub    %edi,%ebx
  803ce9:	89 f9                	mov    %edi,%ecx
  803ceb:	d3 e6                	shl    %cl,%esi
  803ced:	89 c5                	mov    %eax,%ebp
  803cef:	88 d9                	mov    %bl,%cl
  803cf1:	d3 ed                	shr    %cl,%ebp
  803cf3:	89 e9                	mov    %ebp,%ecx
  803cf5:	09 f1                	or     %esi,%ecx
  803cf7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803cfb:	89 f9                	mov    %edi,%ecx
  803cfd:	d3 e0                	shl    %cl,%eax
  803cff:	89 c5                	mov    %eax,%ebp
  803d01:	89 d6                	mov    %edx,%esi
  803d03:	88 d9                	mov    %bl,%cl
  803d05:	d3 ee                	shr    %cl,%esi
  803d07:	89 f9                	mov    %edi,%ecx
  803d09:	d3 e2                	shl    %cl,%edx
  803d0b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d0f:	88 d9                	mov    %bl,%cl
  803d11:	d3 e8                	shr    %cl,%eax
  803d13:	09 c2                	or     %eax,%edx
  803d15:	89 d0                	mov    %edx,%eax
  803d17:	89 f2                	mov    %esi,%edx
  803d19:	f7 74 24 0c          	divl   0xc(%esp)
  803d1d:	89 d6                	mov    %edx,%esi
  803d1f:	89 c3                	mov    %eax,%ebx
  803d21:	f7 e5                	mul    %ebp
  803d23:	39 d6                	cmp    %edx,%esi
  803d25:	72 19                	jb     803d40 <__udivdi3+0xfc>
  803d27:	74 0b                	je     803d34 <__udivdi3+0xf0>
  803d29:	89 d8                	mov    %ebx,%eax
  803d2b:	31 ff                	xor    %edi,%edi
  803d2d:	e9 58 ff ff ff       	jmp    803c8a <__udivdi3+0x46>
  803d32:	66 90                	xchg   %ax,%ax
  803d34:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d38:	89 f9                	mov    %edi,%ecx
  803d3a:	d3 e2                	shl    %cl,%edx
  803d3c:	39 c2                	cmp    %eax,%edx
  803d3e:	73 e9                	jae    803d29 <__udivdi3+0xe5>
  803d40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d43:	31 ff                	xor    %edi,%edi
  803d45:	e9 40 ff ff ff       	jmp    803c8a <__udivdi3+0x46>
  803d4a:	66 90                	xchg   %ax,%ax
  803d4c:	31 c0                	xor    %eax,%eax
  803d4e:	e9 37 ff ff ff       	jmp    803c8a <__udivdi3+0x46>
  803d53:	90                   	nop

00803d54 <__umoddi3>:
  803d54:	55                   	push   %ebp
  803d55:	57                   	push   %edi
  803d56:	56                   	push   %esi
  803d57:	53                   	push   %ebx
  803d58:	83 ec 1c             	sub    $0x1c,%esp
  803d5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d73:	89 f3                	mov    %esi,%ebx
  803d75:	89 fa                	mov    %edi,%edx
  803d77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d7b:	89 34 24             	mov    %esi,(%esp)
  803d7e:	85 c0                	test   %eax,%eax
  803d80:	75 1a                	jne    803d9c <__umoddi3+0x48>
  803d82:	39 f7                	cmp    %esi,%edi
  803d84:	0f 86 a2 00 00 00    	jbe    803e2c <__umoddi3+0xd8>
  803d8a:	89 c8                	mov    %ecx,%eax
  803d8c:	89 f2                	mov    %esi,%edx
  803d8e:	f7 f7                	div    %edi
  803d90:	89 d0                	mov    %edx,%eax
  803d92:	31 d2                	xor    %edx,%edx
  803d94:	83 c4 1c             	add    $0x1c,%esp
  803d97:	5b                   	pop    %ebx
  803d98:	5e                   	pop    %esi
  803d99:	5f                   	pop    %edi
  803d9a:	5d                   	pop    %ebp
  803d9b:	c3                   	ret    
  803d9c:	39 f0                	cmp    %esi,%eax
  803d9e:	0f 87 ac 00 00 00    	ja     803e50 <__umoddi3+0xfc>
  803da4:	0f bd e8             	bsr    %eax,%ebp
  803da7:	83 f5 1f             	xor    $0x1f,%ebp
  803daa:	0f 84 ac 00 00 00    	je     803e5c <__umoddi3+0x108>
  803db0:	bf 20 00 00 00       	mov    $0x20,%edi
  803db5:	29 ef                	sub    %ebp,%edi
  803db7:	89 fe                	mov    %edi,%esi
  803db9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803dbd:	89 e9                	mov    %ebp,%ecx
  803dbf:	d3 e0                	shl    %cl,%eax
  803dc1:	89 d7                	mov    %edx,%edi
  803dc3:	89 f1                	mov    %esi,%ecx
  803dc5:	d3 ef                	shr    %cl,%edi
  803dc7:	09 c7                	or     %eax,%edi
  803dc9:	89 e9                	mov    %ebp,%ecx
  803dcb:	d3 e2                	shl    %cl,%edx
  803dcd:	89 14 24             	mov    %edx,(%esp)
  803dd0:	89 d8                	mov    %ebx,%eax
  803dd2:	d3 e0                	shl    %cl,%eax
  803dd4:	89 c2                	mov    %eax,%edx
  803dd6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dda:	d3 e0                	shl    %cl,%eax
  803ddc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803de0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803de4:	89 f1                	mov    %esi,%ecx
  803de6:	d3 e8                	shr    %cl,%eax
  803de8:	09 d0                	or     %edx,%eax
  803dea:	d3 eb                	shr    %cl,%ebx
  803dec:	89 da                	mov    %ebx,%edx
  803dee:	f7 f7                	div    %edi
  803df0:	89 d3                	mov    %edx,%ebx
  803df2:	f7 24 24             	mull   (%esp)
  803df5:	89 c6                	mov    %eax,%esi
  803df7:	89 d1                	mov    %edx,%ecx
  803df9:	39 d3                	cmp    %edx,%ebx
  803dfb:	0f 82 87 00 00 00    	jb     803e88 <__umoddi3+0x134>
  803e01:	0f 84 91 00 00 00    	je     803e98 <__umoddi3+0x144>
  803e07:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e0b:	29 f2                	sub    %esi,%edx
  803e0d:	19 cb                	sbb    %ecx,%ebx
  803e0f:	89 d8                	mov    %ebx,%eax
  803e11:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e15:	d3 e0                	shl    %cl,%eax
  803e17:	89 e9                	mov    %ebp,%ecx
  803e19:	d3 ea                	shr    %cl,%edx
  803e1b:	09 d0                	or     %edx,%eax
  803e1d:	89 e9                	mov    %ebp,%ecx
  803e1f:	d3 eb                	shr    %cl,%ebx
  803e21:	89 da                	mov    %ebx,%edx
  803e23:	83 c4 1c             	add    $0x1c,%esp
  803e26:	5b                   	pop    %ebx
  803e27:	5e                   	pop    %esi
  803e28:	5f                   	pop    %edi
  803e29:	5d                   	pop    %ebp
  803e2a:	c3                   	ret    
  803e2b:	90                   	nop
  803e2c:	89 fd                	mov    %edi,%ebp
  803e2e:	85 ff                	test   %edi,%edi
  803e30:	75 0b                	jne    803e3d <__umoddi3+0xe9>
  803e32:	b8 01 00 00 00       	mov    $0x1,%eax
  803e37:	31 d2                	xor    %edx,%edx
  803e39:	f7 f7                	div    %edi
  803e3b:	89 c5                	mov    %eax,%ebp
  803e3d:	89 f0                	mov    %esi,%eax
  803e3f:	31 d2                	xor    %edx,%edx
  803e41:	f7 f5                	div    %ebp
  803e43:	89 c8                	mov    %ecx,%eax
  803e45:	f7 f5                	div    %ebp
  803e47:	89 d0                	mov    %edx,%eax
  803e49:	e9 44 ff ff ff       	jmp    803d92 <__umoddi3+0x3e>
  803e4e:	66 90                	xchg   %ax,%ax
  803e50:	89 c8                	mov    %ecx,%eax
  803e52:	89 f2                	mov    %esi,%edx
  803e54:	83 c4 1c             	add    $0x1c,%esp
  803e57:	5b                   	pop    %ebx
  803e58:	5e                   	pop    %esi
  803e59:	5f                   	pop    %edi
  803e5a:	5d                   	pop    %ebp
  803e5b:	c3                   	ret    
  803e5c:	3b 04 24             	cmp    (%esp),%eax
  803e5f:	72 06                	jb     803e67 <__umoddi3+0x113>
  803e61:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e65:	77 0f                	ja     803e76 <__umoddi3+0x122>
  803e67:	89 f2                	mov    %esi,%edx
  803e69:	29 f9                	sub    %edi,%ecx
  803e6b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e6f:	89 14 24             	mov    %edx,(%esp)
  803e72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e76:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e7a:	8b 14 24             	mov    (%esp),%edx
  803e7d:	83 c4 1c             	add    $0x1c,%esp
  803e80:	5b                   	pop    %ebx
  803e81:	5e                   	pop    %esi
  803e82:	5f                   	pop    %edi
  803e83:	5d                   	pop    %ebp
  803e84:	c3                   	ret    
  803e85:	8d 76 00             	lea    0x0(%esi),%esi
  803e88:	2b 04 24             	sub    (%esp),%eax
  803e8b:	19 fa                	sbb    %edi,%edx
  803e8d:	89 d1                	mov    %edx,%ecx
  803e8f:	89 c6                	mov    %eax,%esi
  803e91:	e9 71 ff ff ff       	jmp    803e07 <__umoddi3+0xb3>
  803e96:	66 90                	xchg   %ax,%ax
  803e98:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e9c:	72 ea                	jb     803e88 <__umoddi3+0x134>
  803e9e:	89 d9                	mov    %ebx,%ecx
  803ea0:	e9 62 ff ff ff       	jmp    803e07 <__umoddi3+0xb3>
