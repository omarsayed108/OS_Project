
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 d6 05 00 00       	call   80060c <libmain>
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
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
		//2012: lock the interrupt
		//sys_lock_cons();
		//2024: lock the console only using a sleepLock
		int NumOfElements;
		int *Elements;
		sys_lock_cons();
  800041:	e8 c8 28 00 00       	call   80290e <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 3d 80 00       	push   $0x803de0
  80004e:	e8 57 0a 00 00       	call   800aaa <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 3d 80 00       	push   $0x803de2
  80005e:	e8 47 0a 00 00       	call   800aaa <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 fb 3d 80 00       	push   $0x803dfb
  80006e:	e8 37 0a 00 00       	call   800aaa <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 3d 80 00       	push   $0x803de2
  80007e:	e8 27 0a 00 00       	call   800aaa <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 3d 80 00       	push   $0x803de0
  80008e:	e8 17 0a 00 00       	call   800aaa <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 14 3e 80 00       	push   $0x803e14
  8000a5:	e8 d9 10 00 00       	call   801183 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 da 16 00 00       	call   80179a <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 34 3e 80 00       	push   $0x803e34
  8000ce:	e8 d7 09 00 00       	call   800aaa <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 56 3e 80 00       	push   $0x803e56
  8000de:	e8 c7 09 00 00       	call   800aaa <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 64 3e 80 00       	push   $0x803e64
  8000ee:	e8 b7 09 00 00       	call   800aaa <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 73 3e 80 00       	push   $0x803e73
  8000fe:	e8 a7 09 00 00       	call   800aaa <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 83 3e 80 00       	push   $0x803e83
  80010e:	e8 97 09 00 00       	call   800aaa <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800116:	e8 d4 04 00 00       	call   8005ef <getchar>
  80011b:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80011e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 a5 04 00 00       	call   8005d0 <cputchar>
  80012b:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	6a 0a                	push   $0xa
  800133:	e8 98 04 00 00       	call   8005d0 <cputchar>
  800138:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80013b:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80013f:	74 0c                	je     80014d <_main+0x115>
  800141:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800145:	74 06                	je     80014d <_main+0x115>
  800147:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  80014b:	75 b9                	jne    800106 <_main+0xce>
		}
		//2012: unlock
		sys_unlock_cons();
  80014d:	e8 d6 27 00 00       	call   802928 <sys_unlock_cons>
		//sys_unlock_cons();

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 7c 21 00 00       	call   8022dd <malloc>
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 03 03 00 00       	call   80048b <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 21 03 00 00       	call   8004bc <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 43 03 00 00       	call   8004f1 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 30 03 00 00       	call   8004f1 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 fe 00 00 00       	call   8002d0 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  8001d5:	e8 34 27 00 00       	call   80290e <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 8c 3e 80 00       	push   $0x803e8c
  8001e2:	e8 c3 08 00 00       	call   800aaa <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 39 27 00 00       	call   802928 <sys_unlock_cons>
		//sys_unlock_cons();

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 e4 01 00 00       	call   8003e1 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 c0 3e 80 00       	push   $0x803ec0
  800211:	6a 54                	push   $0x54
  800213:	68 e2 3e 80 00       	push   $0x803ee2
  800218:	e8 9f 05 00 00       	call   8007bc <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 ec 26 00 00       	call   80290e <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 00 3f 80 00       	push   $0x803f00
  80022a:	e8 7b 08 00 00       	call   800aaa <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 34 3f 80 00       	push   $0x803f34
  80023a:	e8 6b 08 00 00       	call   800aaa <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 68 3f 80 00       	push   $0x803f68
  80024a:	e8 5b 08 00 00       	call   800aaa <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 d1 26 00 00       	call   802928 <sys_unlock_cons>
			//			sys_unlock_cons();


		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 ec             	pushl  -0x14(%ebp)
  80025d:	e8 ff 21 00 00       	call   802461 <free>
  800262:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
  800265:	e8 a4 26 00 00       	call   80290e <sys_lock_cons>
		{
			Chose = 0 ;
  80026a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  80026e:	eb 42                	jmp    8002b2 <_main+0x27a>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 9a 3f 80 00       	push   $0x803f9a
  800278:	e8 2d 08 00 00       	call   800aaa <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800280:	e8 6a 03 00 00       	call   8005ef <getchar>
  800285:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800288:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 3b 03 00 00       	call   8005d0 <cputchar>
  800295:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	6a 0a                	push   $0xa
  80029d:	e8 2e 03 00 00       	call   8005d0 <cputchar>
  8002a2:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	6a 0a                	push   $0xa
  8002aa:	e8 21 03 00 00       	call   8005d0 <cputchar>
  8002af:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b2:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b6:	74 06                	je     8002be <_main+0x286>
  8002b8:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002bc:	75 b2                	jne    800270 <_main+0x238>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002be:	e8 65 26 00 00       	call   802928 <sys_unlock_cons>
		//		sys_unlock_cons();

	} while (Chose == 'y');
  8002c3:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c7:	0f 84 74 fd ff ff    	je     800041 <_main+0x9>

}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d9:	48                   	dec    %eax
  8002da:	50                   	push   %eax
  8002db:	6a 00                	push   $0x0
  8002dd:	ff 75 0c             	pushl  0xc(%ebp)
  8002e0:	ff 75 08             	pushl  0x8(%ebp)
  8002e3:	e8 06 00 00 00       	call   8002ee <QSort>
  8002e8:	83 c4 10             	add    $0x10,%esp
}
  8002eb:	90                   	nop
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f7:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fa:	0f 8d de 00 00 00    	jge    8003de <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800300:	8b 45 10             	mov    0x10(%ebp),%eax
  800303:	40                   	inc    %eax
  800304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800307:	8b 45 14             	mov    0x14(%ebp),%eax
  80030a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80030d:	e9 80 00 00 00       	jmp    800392 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800312:	ff 45 f4             	incl   -0xc(%ebp)
  800315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800318:	3b 45 14             	cmp    0x14(%ebp),%eax
  80031b:	7f 2b                	jg     800348 <QSort+0x5a>
  80031d:	8b 45 10             	mov    0x10(%ebp),%eax
  800320:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800327:	8b 45 08             	mov    0x8(%ebp),%eax
  80032a:	01 d0                	add    %edx,%eax
  80032c:	8b 10                	mov    (%eax),%edx
  80032e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800331:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800338:	8b 45 08             	mov    0x8(%ebp),%eax
  80033b:	01 c8                	add    %ecx,%eax
  80033d:	8b 00                	mov    (%eax),%eax
  80033f:	39 c2                	cmp    %eax,%edx
  800341:	7d cf                	jge    800312 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800343:	eb 03                	jmp    800348 <QSort+0x5a>
  800345:	ff 4d f0             	decl   -0x10(%ebp)
  800348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80034e:	7e 26                	jle    800376 <QSort+0x88>
  800350:	8b 45 10             	mov    0x10(%ebp),%eax
  800353:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80035a:	8b 45 08             	mov    0x8(%ebp),%eax
  80035d:	01 d0                	add    %edx,%eax
  80035f:	8b 10                	mov    (%eax),%edx
  800361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800364:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	01 c8                	add    %ecx,%eax
  800370:	8b 00                	mov    (%eax),%eax
  800372:	39 c2                	cmp    %eax,%edx
  800374:	7e cf                	jle    800345 <QSort+0x57>

		if (i <= j)
  800376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800379:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80037c:	7f 14                	jg     800392 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80037e:	83 ec 04             	sub    $0x4,%esp
  800381:	ff 75 f0             	pushl  -0x10(%ebp)
  800384:	ff 75 f4             	pushl  -0xc(%ebp)
  800387:	ff 75 08             	pushl  0x8(%ebp)
  80038a:	e8 a9 00 00 00       	call   800438 <Swap>
  80038f:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800395:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800398:	0f 8e 77 ff ff ff    	jle    800315 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80039e:	83 ec 04             	sub    $0x4,%esp
  8003a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a4:	ff 75 10             	pushl  0x10(%ebp)
  8003a7:	ff 75 08             	pushl  0x8(%ebp)
  8003aa:	e8 89 00 00 00       	call   800438 <Swap>
  8003af:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b5:	48                   	dec    %eax
  8003b6:	50                   	push   %eax
  8003b7:	ff 75 10             	pushl  0x10(%ebp)
  8003ba:	ff 75 0c             	pushl  0xc(%ebp)
  8003bd:	ff 75 08             	pushl  0x8(%ebp)
  8003c0:	e8 29 ff ff ff       	call   8002ee <QSort>
  8003c5:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003c8:	ff 75 14             	pushl  0x14(%ebp)
  8003cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ce:	ff 75 0c             	pushl  0xc(%ebp)
  8003d1:	ff 75 08             	pushl  0x8(%ebp)
  8003d4:	e8 15 ff ff ff       	call   8002ee <QSort>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	eb 01                	jmp    8003df <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003de:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003f5:	eb 33                	jmp    80042a <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	01 d0                	add    %edx,%eax
  800406:	8b 10                	mov    (%eax),%edx
  800408:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80040b:	40                   	inc    %eax
  80040c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	01 c8                	add    %ecx,%eax
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	39 c2                	cmp    %eax,%edx
  80041c:	7e 09                	jle    800427 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80041e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800425:	eb 0c                	jmp    800433 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800427:	ff 45 f8             	incl   -0x8(%ebp)
  80042a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042d:	48                   	dec    %eax
  80042e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800431:	7f c4                	jg     8003f7 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800433:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800436:	c9                   	leave  
  800437:	c3                   	ret    

00800438 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
  80043b:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80043e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800452:	8b 45 0c             	mov    0xc(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 10             	mov    0x10(%ebp),%eax
  800464:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 c8                	add    %ecx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800474:	8b 45 10             	mov    0x10(%ebp),%eax
  800477:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	01 c2                	add    %eax,%edx
  800483:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800486:	89 02                	mov    %eax,(%edx)
}
  800488:	90                   	nop
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800498:	eb 17                	jmp    8004b1 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80049a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	01 c2                	add    %eax,%edx
  8004a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ac:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004ae:	ff 45 fc             	incl   -0x4(%ebp)
  8004b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004b7:	7c e1                	jl     80049a <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004b9:	90                   	nop
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004c9:	eb 1b                	jmp    8004e6 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	01 c2                	add    %eax,%edx
  8004da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dd:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004e0:	48                   	dec    %eax
  8004e1:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004e3:	ff 45 fc             	incl   -0x4(%ebp)
  8004e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ec:	7c dd                	jl     8004cb <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004ee:	90                   	nop
  8004ef:	c9                   	leave  
  8004f0:	c3                   	ret    

008004f1 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004fa:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004ff:	f7 e9                	imul   %ecx
  800501:	c1 f9 1f             	sar    $0x1f,%ecx
  800504:	89 d0                	mov    %edx,%eax
  800506:	29 c8                	sub    %ecx,%eax
  800508:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  80050b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80050f:	75 07                	jne    800518 <InitializeSemiRandom+0x27>
		Repetition = 3;
  800511:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800518:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80051f:	eb 1e                	jmp    80053f <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800524:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800534:	99                   	cltd   
  800535:	f7 7d f8             	idivl  -0x8(%ebp)
  800538:	89 d0                	mov    %edx,%eax
  80053a:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
		Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  80053c:	ff 45 fc             	incl   -0x4(%ebp)
  80053f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800542:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800545:	7c da                	jl     800521 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800550:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800557:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80055e:	eb 42                	jmp    8005a2 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800563:	99                   	cltd   
  800564:	f7 7d f0             	idivl  -0x10(%ebp)
  800567:	89 d0                	mov    %edx,%eax
  800569:	85 c0                	test   %eax,%eax
  80056b:	75 10                	jne    80057d <PrintElements+0x33>
			cprintf("\n");
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	68 e0 3d 80 00       	push   $0x803de0
  800575:	e8 30 05 00 00       	call   800aaa <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80057d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800580:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	01 d0                	add    %edx,%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	50                   	push   %eax
  800592:	68 b8 3f 80 00       	push   $0x803fb8
  800597:	e8 0e 05 00 00       	call   800aaa <cprintf>
  80059c:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80059f:	ff 45 f4             	incl   -0xc(%ebp)
  8005a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a5:	48                   	dec    %eax
  8005a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005a9:	7f b5                	jg     800560 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8005ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	01 d0                	add    %edx,%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	50                   	push   %eax
  8005c0:	68 bd 3f 80 00       	push   $0x803fbd
  8005c5:	e8 e0 04 00 00       	call   800aaa <cprintf>
  8005ca:	83 c4 10             	add    $0x10,%esp

}
  8005cd:	90                   	nop
  8005ce:	c9                   	leave  
  8005cf:	c3                   	ret    

008005d0 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005dc:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 6d 24 00 00       	call   802a56 <sys_cputc>
  8005e9:	83 c4 10             	add    $0x10,%esp
}
  8005ec:	90                   	nop
  8005ed:	c9                   	leave  
  8005ee:	c3                   	ret    

008005ef <getchar>:


int
getchar(void)
{
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005f5:	e8 fb 22 00 00       	call   8028f5 <sys_cgetc>
  8005fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800600:	c9                   	leave  
  800601:	c3                   	ret    

00800602 <iscons>:

int iscons(int fdnum)
{
  800602:	55                   	push   %ebp
  800603:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800605:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80060a:	5d                   	pop    %ebp
  80060b:	c3                   	ret    

0080060c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	57                   	push   %edi
  800610:	56                   	push   %esi
  800611:	53                   	push   %ebx
  800612:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800615:	e8 6d 25 00 00       	call   802b87 <sys_getenvindex>
  80061a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80061d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800620:	89 d0                	mov    %edx,%eax
  800622:	01 c0                	add    %eax,%eax
  800624:	01 d0                	add    %edx,%eax
  800626:	c1 e0 02             	shl    $0x2,%eax
  800629:	01 d0                	add    %edx,%eax
  80062b:	c1 e0 02             	shl    $0x2,%eax
  80062e:	01 d0                	add    %edx,%eax
  800630:	c1 e0 03             	shl    $0x3,%eax
  800633:	01 d0                	add    %edx,%eax
  800635:	c1 e0 02             	shl    $0x2,%eax
  800638:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80063d:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800642:	a1 24 50 80 00       	mov    0x805024,%eax
  800647:	8a 40 20             	mov    0x20(%eax),%al
  80064a:	84 c0                	test   %al,%al
  80064c:	74 0d                	je     80065b <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80064e:	a1 24 50 80 00       	mov    0x805024,%eax
  800653:	83 c0 20             	add    $0x20,%eax
  800656:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80065b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80065f:	7e 0a                	jle    80066b <libmain+0x5f>
		binaryname = argv[0];
  800661:	8b 45 0c             	mov    0xc(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	ff 75 0c             	pushl  0xc(%ebp)
  800671:	ff 75 08             	pushl  0x8(%ebp)
  800674:	e8 bf f9 ff ff       	call   800038 <_main>
  800679:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80067c:	a1 00 50 80 00       	mov    0x805000,%eax
  800681:	85 c0                	test   %eax,%eax
  800683:	0f 84 01 01 00 00    	je     80078a <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800689:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80068f:	bb bc 40 80 00       	mov    $0x8040bc,%ebx
  800694:	ba 0e 00 00 00       	mov    $0xe,%edx
  800699:	89 c7                	mov    %eax,%edi
  80069b:	89 de                	mov    %ebx,%esi
  80069d:	89 d1                	mov    %edx,%ecx
  80069f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8006a1:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8006a4:	b9 56 00 00 00       	mov    $0x56,%ecx
  8006a9:	b0 00                	mov    $0x0,%al
  8006ab:	89 d7                	mov    %edx,%edi
  8006ad:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8006af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8006b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8006b9:	83 ec 08             	sub    $0x8,%esp
  8006bc:	50                   	push   %eax
  8006bd:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006c3:	50                   	push   %eax
  8006c4:	e8 f4 26 00 00       	call   802dbd <sys_utilities>
  8006c9:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8006cc:	e8 3d 22 00 00       	call   80290e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8006d1:	83 ec 0c             	sub    $0xc,%esp
  8006d4:	68 dc 3f 80 00       	push   $0x803fdc
  8006d9:	e8 cc 03 00 00       	call   800aaa <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e4:	85 c0                	test   %eax,%eax
  8006e6:	74 18                	je     800700 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006e8:	e8 ee 26 00 00       	call   802ddb <sys_get_optimal_num_faults>
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	50                   	push   %eax
  8006f1:	68 04 40 80 00       	push   $0x804004
  8006f6:	e8 af 03 00 00       	call   800aaa <cprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	eb 59                	jmp    800759 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800700:	a1 24 50 80 00       	mov    0x805024,%eax
  800705:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80070b:	a1 24 50 80 00       	mov    0x805024,%eax
  800710:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	52                   	push   %edx
  80071a:	50                   	push   %eax
  80071b:	68 28 40 80 00       	push   $0x804028
  800720:	e8 85 03 00 00       	call   800aaa <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800728:	a1 24 50 80 00       	mov    0x805024,%eax
  80072d:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800733:	a1 24 50 80 00       	mov    0x805024,%eax
  800738:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80073e:	a1 24 50 80 00       	mov    0x805024,%eax
  800743:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800749:	51                   	push   %ecx
  80074a:	52                   	push   %edx
  80074b:	50                   	push   %eax
  80074c:	68 50 40 80 00       	push   $0x804050
  800751:	e8 54 03 00 00       	call   800aaa <cprintf>
  800756:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800759:	a1 24 50 80 00       	mov    0x805024,%eax
  80075e:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	50                   	push   %eax
  800768:	68 a8 40 80 00       	push   $0x8040a8
  80076d:	e8 38 03 00 00       	call   800aaa <cprintf>
  800772:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800775:	83 ec 0c             	sub    $0xc,%esp
  800778:	68 dc 3f 80 00       	push   $0x803fdc
  80077d:	e8 28 03 00 00       	call   800aaa <cprintf>
  800782:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800785:	e8 9e 21 00 00       	call   802928 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80078a:	e8 1f 00 00 00       	call   8007ae <exit>
}
  80078f:	90                   	nop
  800790:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800793:	5b                   	pop    %ebx
  800794:	5e                   	pop    %esi
  800795:	5f                   	pop    %edi
  800796:	5d                   	pop    %ebp
  800797:	c3                   	ret    

00800798 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80079e:	83 ec 0c             	sub    $0xc,%esp
  8007a1:	6a 00                	push   $0x0
  8007a3:	e8 ab 23 00 00       	call   802b53 <sys_destroy_env>
  8007a8:	83 c4 10             	add    $0x10,%esp
}
  8007ab:	90                   	nop
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <exit>:

void
exit(void)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007b4:	e8 00 24 00 00       	call   802bb9 <sys_exit_env>
}
  8007b9:	90                   	nop
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007cb:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	74 16                	je     8007ea <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007d4:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	50                   	push   %eax
  8007dd:	68 20 41 80 00       	push   $0x804120
  8007e2:	e8 c3 02 00 00       	call   800aaa <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007ea:	a1 04 50 80 00       	mov    0x805004,%eax
  8007ef:	83 ec 0c             	sub    $0xc,%esp
  8007f2:	ff 75 0c             	pushl  0xc(%ebp)
  8007f5:	ff 75 08             	pushl  0x8(%ebp)
  8007f8:	50                   	push   %eax
  8007f9:	68 28 41 80 00       	push   $0x804128
  8007fe:	6a 74                	push   $0x74
  800800:	e8 d2 02 00 00       	call   800ad7 <cprintf_colored>
  800805:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800808:	8b 45 10             	mov    0x10(%ebp),%eax
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	ff 75 f4             	pushl  -0xc(%ebp)
  800811:	50                   	push   %eax
  800812:	e8 24 02 00 00       	call   800a3b <vcprintf>
  800817:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	6a 00                	push   $0x0
  80081f:	68 50 41 80 00       	push   $0x804150
  800824:	e8 12 02 00 00       	call   800a3b <vcprintf>
  800829:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80082c:	e8 7d ff ff ff       	call   8007ae <exit>

	// should not return here
	while (1) ;
  800831:	eb fe                	jmp    800831 <_panic+0x75>

00800833 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	53                   	push   %ebx
  800837:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80083a:	a1 24 50 80 00       	mov    0x805024,%eax
  80083f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800845:	8b 45 0c             	mov    0xc(%ebp),%eax
  800848:	39 c2                	cmp    %eax,%edx
  80084a:	74 14                	je     800860 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80084c:	83 ec 04             	sub    $0x4,%esp
  80084f:	68 54 41 80 00       	push   $0x804154
  800854:	6a 26                	push   $0x26
  800856:	68 a0 41 80 00       	push   $0x8041a0
  80085b:	e8 5c ff ff ff       	call   8007bc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800860:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800867:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80086e:	e9 d9 00 00 00       	jmp    80094c <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800876:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	01 d0                	add    %edx,%eax
  800882:	8b 00                	mov    (%eax),%eax
  800884:	85 c0                	test   %eax,%eax
  800886:	75 08                	jne    800890 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800888:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80088b:	e9 b9 00 00 00       	jmp    800949 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800890:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800897:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80089e:	eb 79                	jmp    800919 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8008a0:	a1 24 50 80 00       	mov    0x805024,%eax
  8008a5:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8008ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008ae:	89 d0                	mov    %edx,%eax
  8008b0:	01 c0                	add    %eax,%eax
  8008b2:	01 d0                	add    %edx,%eax
  8008b4:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8008bb:	01 d8                	add    %ebx,%eax
  8008bd:	01 d0                	add    %edx,%eax
  8008bf:	01 c8                	add    %ecx,%eax
  8008c1:	8a 40 04             	mov    0x4(%eax),%al
  8008c4:	84 c0                	test   %al,%al
  8008c6:	75 4e                	jne    800916 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c8:	a1 24 50 80 00       	mov    0x805024,%eax
  8008cd:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8008d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008d6:	89 d0                	mov    %edx,%eax
  8008d8:	01 c0                	add    %eax,%eax
  8008da:	01 d0                	add    %edx,%eax
  8008dc:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8008e3:	01 d8                	add    %ebx,%eax
  8008e5:	01 d0                	add    %edx,%eax
  8008e7:	01 c8                	add    %ecx,%eax
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008f6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008fb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	01 c8                	add    %ecx,%eax
  800907:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800909:	39 c2                	cmp    %eax,%edx
  80090b:	75 09                	jne    800916 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  80090d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800914:	eb 19                	jmp    80092f <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800916:	ff 45 e8             	incl   -0x18(%ebp)
  800919:	a1 24 50 80 00       	mov    0x805024,%eax
  80091e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800924:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800927:	39 c2                	cmp    %eax,%edx
  800929:	0f 87 71 ff ff ff    	ja     8008a0 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80092f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800933:	75 14                	jne    800949 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800935:	83 ec 04             	sub    $0x4,%esp
  800938:	68 ac 41 80 00       	push   $0x8041ac
  80093d:	6a 3a                	push   $0x3a
  80093f:	68 a0 41 80 00       	push   $0x8041a0
  800944:	e8 73 fe ff ff       	call   8007bc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800949:	ff 45 f0             	incl   -0x10(%ebp)
  80094c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800952:	0f 8c 1b ff ff ff    	jl     800873 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800958:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80095f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800966:	eb 2e                	jmp    800996 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800968:	a1 24 50 80 00       	mov    0x805024,%eax
  80096d:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800973:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800976:	89 d0                	mov    %edx,%eax
  800978:	01 c0                	add    %eax,%eax
  80097a:	01 d0                	add    %edx,%eax
  80097c:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800983:	01 d8                	add    %ebx,%eax
  800985:	01 d0                	add    %edx,%eax
  800987:	01 c8                	add    %ecx,%eax
  800989:	8a 40 04             	mov    0x4(%eax),%al
  80098c:	3c 01                	cmp    $0x1,%al
  80098e:	75 03                	jne    800993 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800990:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800993:	ff 45 e0             	incl   -0x20(%ebp)
  800996:	a1 24 50 80 00       	mov    0x805024,%eax
  80099b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009a4:	39 c2                	cmp    %eax,%edx
  8009a6:	77 c0                	ja     800968 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ab:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009ae:	74 14                	je     8009c4 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8009b0:	83 ec 04             	sub    $0x4,%esp
  8009b3:	68 00 42 80 00       	push   $0x804200
  8009b8:	6a 44                	push   $0x44
  8009ba:	68 a0 41 80 00       	push   $0x8041a0
  8009bf:	e8 f8 fd ff ff       	call   8007bc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009c4:	90                   	nop
  8009c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	53                   	push   %ebx
  8009ce:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8009d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d4:	8b 00                	mov    (%eax),%eax
  8009d6:	8d 48 01             	lea    0x1(%eax),%ecx
  8009d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dc:	89 0a                	mov    %ecx,(%edx)
  8009de:	8b 55 08             	mov    0x8(%ebp),%edx
  8009e1:	88 d1                	mov    %dl,%cl
  8009e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ed:	8b 00                	mov    (%eax),%eax
  8009ef:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009f4:	75 30                	jne    800a26 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009f6:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8009fc:	a0 44 50 80 00       	mov    0x805044,%al
  800a01:	0f b6 c0             	movzbl %al,%eax
  800a04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a07:	8b 09                	mov    (%ecx),%ecx
  800a09:	89 cb                	mov    %ecx,%ebx
  800a0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a0e:	83 c1 08             	add    $0x8,%ecx
  800a11:	52                   	push   %edx
  800a12:	50                   	push   %eax
  800a13:	53                   	push   %ebx
  800a14:	51                   	push   %ecx
  800a15:	e8 b0 1e 00 00       	call   8028ca <sys_cputs>
  800a1a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a29:	8b 40 04             	mov    0x4(%eax),%eax
  800a2c:	8d 50 01             	lea    0x1(%eax),%edx
  800a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a32:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a35:	90                   	nop
  800a36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a39:	c9                   	leave  
  800a3a:	c3                   	ret    

00800a3b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a44:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a4b:	00 00 00 
	b.cnt = 0;
  800a4e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a55:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	ff 75 08             	pushl  0x8(%ebp)
  800a5e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a64:	50                   	push   %eax
  800a65:	68 ca 09 80 00       	push   $0x8009ca
  800a6a:	e8 5a 02 00 00       	call   800cc9 <vprintfmt>
  800a6f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a72:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800a78:	a0 44 50 80 00       	mov    0x805044,%al
  800a7d:	0f b6 c0             	movzbl %al,%eax
  800a80:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a86:	52                   	push   %edx
  800a87:	50                   	push   %eax
  800a88:	51                   	push   %ecx
  800a89:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a8f:	83 c0 08             	add    $0x8,%eax
  800a92:	50                   	push   %eax
  800a93:	e8 32 1e 00 00       	call   8028ca <sys_cputs>
  800a98:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a9b:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800aa2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800aa8:	c9                   	leave  
  800aa9:	c3                   	ret    

00800aaa <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ab0:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800ab7:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac6:	50                   	push   %eax
  800ac7:	e8 6f ff ff ff       	call   800a3b <vcprintf>
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ad5:	c9                   	leave  
  800ad6:	c3                   	ret    

00800ad7 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800add:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	c1 e0 08             	shl    $0x8,%eax
  800aea:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800aef:	8d 45 0c             	lea    0xc(%ebp),%eax
  800af2:	83 c0 04             	add    $0x4,%eax
  800af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	ff 75 f4             	pushl  -0xc(%ebp)
  800b01:	50                   	push   %eax
  800b02:	e8 34 ff ff ff       	call   800a3b <vcprintf>
  800b07:	83 c4 10             	add    $0x10,%esp
  800b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800b0d:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800b14:	07 00 00 

	return cnt;
  800b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b22:	e8 e7 1d 00 00       	call   80290e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b27:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	83 ec 08             	sub    $0x8,%esp
  800b33:	ff 75 f4             	pushl  -0xc(%ebp)
  800b36:	50                   	push   %eax
  800b37:	e8 ff fe ff ff       	call   800a3b <vcprintf>
  800b3c:	83 c4 10             	add    $0x10,%esp
  800b3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b42:	e8 e1 1d 00 00       	call   802928 <sys_unlock_cons>
	return cnt;
  800b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	53                   	push   %ebx
  800b50:	83 ec 14             	sub    $0x14,%esp
  800b53:	8b 45 10             	mov    0x10(%ebp),%eax
  800b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b59:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b5f:	8b 45 18             	mov    0x18(%ebp),%eax
  800b62:	ba 00 00 00 00       	mov    $0x0,%edx
  800b67:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b6a:	77 55                	ja     800bc1 <printnum+0x75>
  800b6c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b6f:	72 05                	jb     800b76 <printnum+0x2a>
  800b71:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b74:	77 4b                	ja     800bc1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b76:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b79:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b7c:	8b 45 18             	mov    0x18(%ebp),%eax
  800b7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b84:	52                   	push   %edx
  800b85:	50                   	push   %eax
  800b86:	ff 75 f4             	pushl  -0xc(%ebp)
  800b89:	ff 75 f0             	pushl  -0x10(%ebp)
  800b8c:	e8 db 2f 00 00       	call   803b6c <__udivdi3>
  800b91:	83 c4 10             	add    $0x10,%esp
  800b94:	83 ec 04             	sub    $0x4,%esp
  800b97:	ff 75 20             	pushl  0x20(%ebp)
  800b9a:	53                   	push   %ebx
  800b9b:	ff 75 18             	pushl  0x18(%ebp)
  800b9e:	52                   	push   %edx
  800b9f:	50                   	push   %eax
  800ba0:	ff 75 0c             	pushl  0xc(%ebp)
  800ba3:	ff 75 08             	pushl  0x8(%ebp)
  800ba6:	e8 a1 ff ff ff       	call   800b4c <printnum>
  800bab:	83 c4 20             	add    $0x20,%esp
  800bae:	eb 1a                	jmp    800bca <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bb0:	83 ec 08             	sub    $0x8,%esp
  800bb3:	ff 75 0c             	pushl  0xc(%ebp)
  800bb6:	ff 75 20             	pushl  0x20(%ebp)
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	ff d0                	call   *%eax
  800bbe:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bc1:	ff 4d 1c             	decl   0x1c(%ebp)
  800bc4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bc8:	7f e6                	jg     800bb0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bca:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd8:	53                   	push   %ebx
  800bd9:	51                   	push   %ecx
  800bda:	52                   	push   %edx
  800bdb:	50                   	push   %eax
  800bdc:	e8 9b 30 00 00       	call   803c7c <__umoddi3>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	05 74 44 80 00       	add    $0x804474,%eax
  800be9:	8a 00                	mov    (%eax),%al
  800beb:	0f be c0             	movsbl %al,%eax
  800bee:	83 ec 08             	sub    $0x8,%esp
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	50                   	push   %eax
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	ff d0                	call   *%eax
  800bfa:	83 c4 10             	add    $0x10,%esp
}
  800bfd:	90                   	nop
  800bfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c01:	c9                   	leave  
  800c02:	c3                   	ret    

00800c03 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c06:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c0a:	7e 1c                	jle    800c28 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8b 00                	mov    (%eax),%eax
  800c11:	8d 50 08             	lea    0x8(%eax),%edx
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	89 10                	mov    %edx,(%eax)
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8b 00                	mov    (%eax),%eax
  800c1e:	83 e8 08             	sub    $0x8,%eax
  800c21:	8b 50 04             	mov    0x4(%eax),%edx
  800c24:	8b 00                	mov    (%eax),%eax
  800c26:	eb 40                	jmp    800c68 <getuint+0x65>
	else if (lflag)
  800c28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2c:	74 1e                	je     800c4c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	8b 00                	mov    (%eax),%eax
  800c33:	8d 50 04             	lea    0x4(%eax),%edx
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	89 10                	mov    %edx,(%eax)
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	8b 00                	mov    (%eax),%eax
  800c40:	83 e8 04             	sub    $0x4,%eax
  800c43:	8b 00                	mov    (%eax),%eax
  800c45:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4a:	eb 1c                	jmp    800c68 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	8b 00                	mov    (%eax),%eax
  800c51:	8d 50 04             	lea    0x4(%eax),%edx
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	89 10                	mov    %edx,(%eax)
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8b 00                	mov    (%eax),%eax
  800c5e:	83 e8 04             	sub    $0x4,%eax
  800c61:	8b 00                	mov    (%eax),%eax
  800c63:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    

00800c6a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c6d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c71:	7e 1c                	jle    800c8f <getint+0x25>
		return va_arg(*ap, long long);
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8b 00                	mov    (%eax),%eax
  800c78:	8d 50 08             	lea    0x8(%eax),%edx
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	89 10                	mov    %edx,(%eax)
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8b 00                	mov    (%eax),%eax
  800c85:	83 e8 08             	sub    $0x8,%eax
  800c88:	8b 50 04             	mov    0x4(%eax),%edx
  800c8b:	8b 00                	mov    (%eax),%eax
  800c8d:	eb 38                	jmp    800cc7 <getint+0x5d>
	else if (lflag)
  800c8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c93:	74 1a                	je     800caf <getint+0x45>
		return va_arg(*ap, long);
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	8b 00                	mov    (%eax),%eax
  800c9a:	8d 50 04             	lea    0x4(%eax),%edx
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	89 10                	mov    %edx,(%eax)
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8b 00                	mov    (%eax),%eax
  800ca7:	83 e8 04             	sub    $0x4,%eax
  800caa:	8b 00                	mov    (%eax),%eax
  800cac:	99                   	cltd   
  800cad:	eb 18                	jmp    800cc7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8b 00                	mov    (%eax),%eax
  800cb4:	8d 50 04             	lea    0x4(%eax),%edx
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 10                	mov    %edx,(%eax)
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8b 00                	mov    (%eax),%eax
  800cc1:	83 e8 04             	sub    $0x4,%eax
  800cc4:	8b 00                	mov    (%eax),%eax
  800cc6:	99                   	cltd   
}
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    

00800cc9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	56                   	push   %esi
  800ccd:	53                   	push   %ebx
  800cce:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cd1:	eb 17                	jmp    800cea <vprintfmt+0x21>
			if (ch == '\0')
  800cd3:	85 db                	test   %ebx,%ebx
  800cd5:	0f 84 c1 03 00 00    	je     80109c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cdb:	83 ec 08             	sub    $0x8,%esp
  800cde:	ff 75 0c             	pushl  0xc(%ebp)
  800ce1:	53                   	push   %ebx
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	ff d0                	call   *%eax
  800ce7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cea:	8b 45 10             	mov    0x10(%ebp),%eax
  800ced:	8d 50 01             	lea    0x1(%eax),%edx
  800cf0:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf3:	8a 00                	mov    (%eax),%al
  800cf5:	0f b6 d8             	movzbl %al,%ebx
  800cf8:	83 fb 25             	cmp    $0x25,%ebx
  800cfb:	75 d6                	jne    800cd3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cfd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d01:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d08:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d0f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d16:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d20:	8d 50 01             	lea    0x1(%eax),%edx
  800d23:	89 55 10             	mov    %edx,0x10(%ebp)
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	0f b6 d8             	movzbl %al,%ebx
  800d2b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d2e:	83 f8 5b             	cmp    $0x5b,%eax
  800d31:	0f 87 3d 03 00 00    	ja     801074 <vprintfmt+0x3ab>
  800d37:	8b 04 85 98 44 80 00 	mov    0x804498(,%eax,4),%eax
  800d3e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d40:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d44:	eb d7                	jmp    800d1d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d46:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d4a:	eb d1                	jmp    800d1d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d4c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d53:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d56:	89 d0                	mov    %edx,%eax
  800d58:	c1 e0 02             	shl    $0x2,%eax
  800d5b:	01 d0                	add    %edx,%eax
  800d5d:	01 c0                	add    %eax,%eax
  800d5f:	01 d8                	add    %ebx,%eax
  800d61:	83 e8 30             	sub    $0x30,%eax
  800d64:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d67:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d6f:	83 fb 2f             	cmp    $0x2f,%ebx
  800d72:	7e 3e                	jle    800db2 <vprintfmt+0xe9>
  800d74:	83 fb 39             	cmp    $0x39,%ebx
  800d77:	7f 39                	jg     800db2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d79:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d7c:	eb d5                	jmp    800d53 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d81:	83 c0 04             	add    $0x4,%eax
  800d84:	89 45 14             	mov    %eax,0x14(%ebp)
  800d87:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8a:	83 e8 04             	sub    $0x4,%eax
  800d8d:	8b 00                	mov    (%eax),%eax
  800d8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d92:	eb 1f                	jmp    800db3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d98:	79 83                	jns    800d1d <vprintfmt+0x54>
				width = 0;
  800d9a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800da1:	e9 77 ff ff ff       	jmp    800d1d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800da6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800dad:	e9 6b ff ff ff       	jmp    800d1d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800db2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800db3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db7:	0f 89 60 ff ff ff    	jns    800d1d <vprintfmt+0x54>
				width = precision, precision = -1;
  800dbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dc3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800dca:	e9 4e ff ff ff       	jmp    800d1d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dcf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800dd2:	e9 46 ff ff ff       	jmp    800d1d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800dd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dda:	83 c0 04             	add    $0x4,%eax
  800ddd:	89 45 14             	mov    %eax,0x14(%ebp)
  800de0:	8b 45 14             	mov    0x14(%ebp),%eax
  800de3:	83 e8 04             	sub    $0x4,%eax
  800de6:	8b 00                	mov    (%eax),%eax
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	ff 75 0c             	pushl  0xc(%ebp)
  800dee:	50                   	push   %eax
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	ff d0                	call   *%eax
  800df4:	83 c4 10             	add    $0x10,%esp
			break;
  800df7:	e9 9b 02 00 00       	jmp    801097 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800dfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800dff:	83 c0 04             	add    $0x4,%eax
  800e02:	89 45 14             	mov    %eax,0x14(%ebp)
  800e05:	8b 45 14             	mov    0x14(%ebp),%eax
  800e08:	83 e8 04             	sub    $0x4,%eax
  800e0b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e0d:	85 db                	test   %ebx,%ebx
  800e0f:	79 02                	jns    800e13 <vprintfmt+0x14a>
				err = -err;
  800e11:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e13:	83 fb 64             	cmp    $0x64,%ebx
  800e16:	7f 0b                	jg     800e23 <vprintfmt+0x15a>
  800e18:	8b 34 9d e0 42 80 00 	mov    0x8042e0(,%ebx,4),%esi
  800e1f:	85 f6                	test   %esi,%esi
  800e21:	75 19                	jne    800e3c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e23:	53                   	push   %ebx
  800e24:	68 85 44 80 00       	push   $0x804485
  800e29:	ff 75 0c             	pushl  0xc(%ebp)
  800e2c:	ff 75 08             	pushl  0x8(%ebp)
  800e2f:	e8 70 02 00 00       	call   8010a4 <printfmt>
  800e34:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e37:	e9 5b 02 00 00       	jmp    801097 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e3c:	56                   	push   %esi
  800e3d:	68 8e 44 80 00       	push   $0x80448e
  800e42:	ff 75 0c             	pushl  0xc(%ebp)
  800e45:	ff 75 08             	pushl  0x8(%ebp)
  800e48:	e8 57 02 00 00       	call   8010a4 <printfmt>
  800e4d:	83 c4 10             	add    $0x10,%esp
			break;
  800e50:	e9 42 02 00 00       	jmp    801097 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e55:	8b 45 14             	mov    0x14(%ebp),%eax
  800e58:	83 c0 04             	add    $0x4,%eax
  800e5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800e5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e61:	83 e8 04             	sub    $0x4,%eax
  800e64:	8b 30                	mov    (%eax),%esi
  800e66:	85 f6                	test   %esi,%esi
  800e68:	75 05                	jne    800e6f <vprintfmt+0x1a6>
				p = "(null)";
  800e6a:	be 91 44 80 00       	mov    $0x804491,%esi
			if (width > 0 && padc != '-')
  800e6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e73:	7e 6d                	jle    800ee2 <vprintfmt+0x219>
  800e75:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e79:	74 67                	je     800ee2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e7e:	83 ec 08             	sub    $0x8,%esp
  800e81:	50                   	push   %eax
  800e82:	56                   	push   %esi
  800e83:	e8 26 05 00 00       	call   8013ae <strnlen>
  800e88:	83 c4 10             	add    $0x10,%esp
  800e8b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e8e:	eb 16                	jmp    800ea6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e90:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e94:	83 ec 08             	sub    $0x8,%esp
  800e97:	ff 75 0c             	pushl  0xc(%ebp)
  800e9a:	50                   	push   %eax
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	ff d0                	call   *%eax
  800ea0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ea3:	ff 4d e4             	decl   -0x1c(%ebp)
  800ea6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eaa:	7f e4                	jg     800e90 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eac:	eb 34                	jmp    800ee2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800eae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800eb2:	74 1c                	je     800ed0 <vprintfmt+0x207>
  800eb4:	83 fb 1f             	cmp    $0x1f,%ebx
  800eb7:	7e 05                	jle    800ebe <vprintfmt+0x1f5>
  800eb9:	83 fb 7e             	cmp    $0x7e,%ebx
  800ebc:	7e 12                	jle    800ed0 <vprintfmt+0x207>
					putch('?', putdat);
  800ebe:	83 ec 08             	sub    $0x8,%esp
  800ec1:	ff 75 0c             	pushl  0xc(%ebp)
  800ec4:	6a 3f                	push   $0x3f
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	ff d0                	call   *%eax
  800ecb:	83 c4 10             	add    $0x10,%esp
  800ece:	eb 0f                	jmp    800edf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	ff 75 0c             	pushl  0xc(%ebp)
  800ed6:	53                   	push   %ebx
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	ff d0                	call   *%eax
  800edc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800edf:	ff 4d e4             	decl   -0x1c(%ebp)
  800ee2:	89 f0                	mov    %esi,%eax
  800ee4:	8d 70 01             	lea    0x1(%eax),%esi
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	0f be d8             	movsbl %al,%ebx
  800eec:	85 db                	test   %ebx,%ebx
  800eee:	74 24                	je     800f14 <vprintfmt+0x24b>
  800ef0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ef4:	78 b8                	js     800eae <vprintfmt+0x1e5>
  800ef6:	ff 4d e0             	decl   -0x20(%ebp)
  800ef9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800efd:	79 af                	jns    800eae <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eff:	eb 13                	jmp    800f14 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f01:	83 ec 08             	sub    $0x8,%esp
  800f04:	ff 75 0c             	pushl  0xc(%ebp)
  800f07:	6a 20                	push   $0x20
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	ff d0                	call   *%eax
  800f0e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f11:	ff 4d e4             	decl   -0x1c(%ebp)
  800f14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f18:	7f e7                	jg     800f01 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f1a:	e9 78 01 00 00       	jmp    801097 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f1f:	83 ec 08             	sub    $0x8,%esp
  800f22:	ff 75 e8             	pushl  -0x18(%ebp)
  800f25:	8d 45 14             	lea    0x14(%ebp),%eax
  800f28:	50                   	push   %eax
  800f29:	e8 3c fd ff ff       	call   800c6a <getint>
  800f2e:	83 c4 10             	add    $0x10,%esp
  800f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f34:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3d:	85 d2                	test   %edx,%edx
  800f3f:	79 23                	jns    800f64 <vprintfmt+0x29b>
				putch('-', putdat);
  800f41:	83 ec 08             	sub    $0x8,%esp
  800f44:	ff 75 0c             	pushl  0xc(%ebp)
  800f47:	6a 2d                	push   $0x2d
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	ff d0                	call   *%eax
  800f4e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f57:	f7 d8                	neg    %eax
  800f59:	83 d2 00             	adc    $0x0,%edx
  800f5c:	f7 da                	neg    %edx
  800f5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f61:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f64:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f6b:	e9 bc 00 00 00       	jmp    80102c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f70:	83 ec 08             	sub    $0x8,%esp
  800f73:	ff 75 e8             	pushl  -0x18(%ebp)
  800f76:	8d 45 14             	lea    0x14(%ebp),%eax
  800f79:	50                   	push   %eax
  800f7a:	e8 84 fc ff ff       	call   800c03 <getuint>
  800f7f:	83 c4 10             	add    $0x10,%esp
  800f82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f85:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f88:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f8f:	e9 98 00 00 00       	jmp    80102c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f94:	83 ec 08             	sub    $0x8,%esp
  800f97:	ff 75 0c             	pushl  0xc(%ebp)
  800f9a:	6a 58                	push   $0x58
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	ff d0                	call   *%eax
  800fa1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fa4:	83 ec 08             	sub    $0x8,%esp
  800fa7:	ff 75 0c             	pushl  0xc(%ebp)
  800faa:	6a 58                	push   $0x58
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	ff d0                	call   *%eax
  800fb1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fb4:	83 ec 08             	sub    $0x8,%esp
  800fb7:	ff 75 0c             	pushl  0xc(%ebp)
  800fba:	6a 58                	push   $0x58
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	ff d0                	call   *%eax
  800fc1:	83 c4 10             	add    $0x10,%esp
			break;
  800fc4:	e9 ce 00 00 00       	jmp    801097 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fc9:	83 ec 08             	sub    $0x8,%esp
  800fcc:	ff 75 0c             	pushl  0xc(%ebp)
  800fcf:	6a 30                	push   $0x30
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	ff d0                	call   *%eax
  800fd6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fd9:	83 ec 08             	sub    $0x8,%esp
  800fdc:	ff 75 0c             	pushl  0xc(%ebp)
  800fdf:	6a 78                	push   $0x78
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	ff d0                	call   *%eax
  800fe6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fe9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fec:	83 c0 04             	add    $0x4,%eax
  800fef:	89 45 14             	mov    %eax,0x14(%ebp)
  800ff2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff5:	83 e8 04             	sub    $0x4,%eax
  800ff8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801004:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80100b:	eb 1f                	jmp    80102c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80100d:	83 ec 08             	sub    $0x8,%esp
  801010:	ff 75 e8             	pushl  -0x18(%ebp)
  801013:	8d 45 14             	lea    0x14(%ebp),%eax
  801016:	50                   	push   %eax
  801017:	e8 e7 fb ff ff       	call   800c03 <getuint>
  80101c:	83 c4 10             	add    $0x10,%esp
  80101f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801022:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801025:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80102c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801030:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801033:	83 ec 04             	sub    $0x4,%esp
  801036:	52                   	push   %edx
  801037:	ff 75 e4             	pushl  -0x1c(%ebp)
  80103a:	50                   	push   %eax
  80103b:	ff 75 f4             	pushl  -0xc(%ebp)
  80103e:	ff 75 f0             	pushl  -0x10(%ebp)
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	ff 75 08             	pushl  0x8(%ebp)
  801047:	e8 00 fb ff ff       	call   800b4c <printnum>
  80104c:	83 c4 20             	add    $0x20,%esp
			break;
  80104f:	eb 46                	jmp    801097 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801051:	83 ec 08             	sub    $0x8,%esp
  801054:	ff 75 0c             	pushl  0xc(%ebp)
  801057:	53                   	push   %ebx
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	ff d0                	call   *%eax
  80105d:	83 c4 10             	add    $0x10,%esp
			break;
  801060:	eb 35                	jmp    801097 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801062:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  801069:	eb 2c                	jmp    801097 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80106b:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  801072:	eb 23                	jmp    801097 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801074:	83 ec 08             	sub    $0x8,%esp
  801077:	ff 75 0c             	pushl  0xc(%ebp)
  80107a:	6a 25                	push   $0x25
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	ff d0                	call   *%eax
  801081:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801084:	ff 4d 10             	decl   0x10(%ebp)
  801087:	eb 03                	jmp    80108c <vprintfmt+0x3c3>
  801089:	ff 4d 10             	decl   0x10(%ebp)
  80108c:	8b 45 10             	mov    0x10(%ebp),%eax
  80108f:	48                   	dec    %eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	3c 25                	cmp    $0x25,%al
  801094:	75 f3                	jne    801089 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801096:	90                   	nop
		}
	}
  801097:	e9 35 fc ff ff       	jmp    800cd1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80109c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80109d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5d                   	pop    %ebp
  8010a3:	c3                   	ret    

008010a4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010aa:	8d 45 10             	lea    0x10(%ebp),%eax
  8010ad:	83 c0 04             	add    $0x4,%eax
  8010b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b9:	50                   	push   %eax
  8010ba:	ff 75 0c             	pushl  0xc(%ebp)
  8010bd:	ff 75 08             	pushl  0x8(%ebp)
  8010c0:	e8 04 fc ff ff       	call   800cc9 <vprintfmt>
  8010c5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010c8:	90                   	nop
  8010c9:	c9                   	leave  
  8010ca:	c3                   	ret    

008010cb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	8b 40 08             	mov    0x8(%eax),%eax
  8010d4:	8d 50 01             	lea    0x1(%eax),%edx
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	8b 10                	mov    (%eax),%edx
  8010e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e5:	8b 40 04             	mov    0x4(%eax),%eax
  8010e8:	39 c2                	cmp    %eax,%edx
  8010ea:	73 12                	jae    8010fe <sprintputch+0x33>
		*b->buf++ = ch;
  8010ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ef:	8b 00                	mov    (%eax),%eax
  8010f1:	8d 48 01             	lea    0x1(%eax),%ecx
  8010f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f7:	89 0a                	mov    %ecx,(%edx)
  8010f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fc:	88 10                	mov    %dl,(%eax)
}
  8010fe:	90                   	nop
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    

00801101 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80110d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801110:	8d 50 ff             	lea    -0x1(%eax),%edx
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	01 d0                	add    %edx,%eax
  801118:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80111b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801122:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801126:	74 06                	je     80112e <vsnprintf+0x2d>
  801128:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112c:	7f 07                	jg     801135 <vsnprintf+0x34>
		return -E_INVAL;
  80112e:	b8 03 00 00 00       	mov    $0x3,%eax
  801133:	eb 20                	jmp    801155 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801135:	ff 75 14             	pushl  0x14(%ebp)
  801138:	ff 75 10             	pushl  0x10(%ebp)
  80113b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80113e:	50                   	push   %eax
  80113f:	68 cb 10 80 00       	push   $0x8010cb
  801144:	e8 80 fb ff ff       	call   800cc9 <vprintfmt>
  801149:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80114c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80114f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801152:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80115d:	8d 45 10             	lea    0x10(%ebp),%eax
  801160:	83 c0 04             	add    $0x4,%eax
  801163:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	ff 75 f4             	pushl  -0xc(%ebp)
  80116c:	50                   	push   %eax
  80116d:	ff 75 0c             	pushl  0xc(%ebp)
  801170:	ff 75 08             	pushl  0x8(%ebp)
  801173:	e8 89 ff ff ff       	call   801101 <vsnprintf>
  801178:	83 c4 10             	add    $0x10,%esp
  80117b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80117e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801181:	c9                   	leave  
  801182:	c3                   	ret    

00801183 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801189:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80118d:	74 13                	je     8011a2 <readline+0x1f>
		cprintf("%s", prompt);
  80118f:	83 ec 08             	sub    $0x8,%esp
  801192:	ff 75 08             	pushl  0x8(%ebp)
  801195:	68 08 46 80 00       	push   $0x804608
  80119a:	e8 0b f9 ff ff       	call   800aaa <cprintf>
  80119f:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011a9:	83 ec 0c             	sub    $0xc,%esp
  8011ac:	6a 00                	push   $0x0
  8011ae:	e8 4f f4 ff ff       	call   800602 <iscons>
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011b9:	e8 31 f4 ff ff       	call   8005ef <getchar>
  8011be:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011c5:	79 22                	jns    8011e9 <readline+0x66>
			if (c != -E_EOF)
  8011c7:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011cb:	0f 84 ad 00 00 00    	je     80127e <readline+0xfb>
				cprintf("read error: %e\n", c);
  8011d1:	83 ec 08             	sub    $0x8,%esp
  8011d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8011d7:	68 0b 46 80 00       	push   $0x80460b
  8011dc:	e8 c9 f8 ff ff       	call   800aaa <cprintf>
  8011e1:	83 c4 10             	add    $0x10,%esp
			break;
  8011e4:	e9 95 00 00 00       	jmp    80127e <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011e9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011ed:	7e 34                	jle    801223 <readline+0xa0>
  8011ef:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011f6:	7f 2b                	jg     801223 <readline+0xa0>
			if (echoing)
  8011f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011fc:	74 0e                	je     80120c <readline+0x89>
				cputchar(c);
  8011fe:	83 ec 0c             	sub    $0xc,%esp
  801201:	ff 75 ec             	pushl  -0x14(%ebp)
  801204:	e8 c7 f3 ff ff       	call   8005d0 <cputchar>
  801209:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80120c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80120f:	8d 50 01             	lea    0x1(%eax),%edx
  801212:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801215:	89 c2                	mov    %eax,%edx
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	01 d0                	add    %edx,%eax
  80121c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121f:	88 10                	mov    %dl,(%eax)
  801221:	eb 56                	jmp    801279 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801223:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801227:	75 1f                	jne    801248 <readline+0xc5>
  801229:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80122d:	7e 19                	jle    801248 <readline+0xc5>
			if (echoing)
  80122f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801233:	74 0e                	je     801243 <readline+0xc0>
				cputchar(c);
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	ff 75 ec             	pushl  -0x14(%ebp)
  80123b:	e8 90 f3 ff ff       	call   8005d0 <cputchar>
  801240:	83 c4 10             	add    $0x10,%esp

			i--;
  801243:	ff 4d f4             	decl   -0xc(%ebp)
  801246:	eb 31                	jmp    801279 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801248:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80124c:	74 0a                	je     801258 <readline+0xd5>
  80124e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801252:	0f 85 61 ff ff ff    	jne    8011b9 <readline+0x36>
			if (echoing)
  801258:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80125c:	74 0e                	je     80126c <readline+0xe9>
				cputchar(c);
  80125e:	83 ec 0c             	sub    $0xc,%esp
  801261:	ff 75 ec             	pushl  -0x14(%ebp)
  801264:	e8 67 f3 ff ff       	call   8005d0 <cputchar>
  801269:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80126c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	01 d0                	add    %edx,%eax
  801274:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801277:	eb 06                	jmp    80127f <readline+0xfc>
		}
	}
  801279:	e9 3b ff ff ff       	jmp    8011b9 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80127e:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80127f:	90                   	nop
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801288:	e8 81 16 00 00       	call   80290e <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80128d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801291:	74 13                	je     8012a6 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	ff 75 08             	pushl  0x8(%ebp)
  801299:	68 08 46 80 00       	push   $0x804608
  80129e:	e8 07 f8 ff ff       	call   800aaa <cprintf>
  8012a3:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8012a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	6a 00                	push   $0x0
  8012b2:	e8 4b f3 ff ff       	call   800602 <iscons>
  8012b7:	83 c4 10             	add    $0x10,%esp
  8012ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8012bd:	e8 2d f3 ff ff       	call   8005ef <getchar>
  8012c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8012c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012c9:	79 22                	jns    8012ed <atomic_readline+0x6b>
				if (c != -E_EOF)
  8012cb:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012cf:	0f 84 ad 00 00 00    	je     801382 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8012d5:	83 ec 08             	sub    $0x8,%esp
  8012d8:	ff 75 ec             	pushl  -0x14(%ebp)
  8012db:	68 0b 46 80 00       	push   $0x80460b
  8012e0:	e8 c5 f7 ff ff       	call   800aaa <cprintf>
  8012e5:	83 c4 10             	add    $0x10,%esp
				break;
  8012e8:	e9 95 00 00 00       	jmp    801382 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8012ed:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012f1:	7e 34                	jle    801327 <atomic_readline+0xa5>
  8012f3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012fa:	7f 2b                	jg     801327 <atomic_readline+0xa5>
				if (echoing)
  8012fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801300:	74 0e                	je     801310 <atomic_readline+0x8e>
					cputchar(c);
  801302:	83 ec 0c             	sub    $0xc,%esp
  801305:	ff 75 ec             	pushl  -0x14(%ebp)
  801308:	e8 c3 f2 ff ff       	call   8005d0 <cputchar>
  80130d:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801313:	8d 50 01             	lea    0x1(%eax),%edx
  801316:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801319:	89 c2                	mov    %eax,%edx
  80131b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131e:	01 d0                	add    %edx,%eax
  801320:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801323:	88 10                	mov    %dl,(%eax)
  801325:	eb 56                	jmp    80137d <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801327:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80132b:	75 1f                	jne    80134c <atomic_readline+0xca>
  80132d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801331:	7e 19                	jle    80134c <atomic_readline+0xca>
				if (echoing)
  801333:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801337:	74 0e                	je     801347 <atomic_readline+0xc5>
					cputchar(c);
  801339:	83 ec 0c             	sub    $0xc,%esp
  80133c:	ff 75 ec             	pushl  -0x14(%ebp)
  80133f:	e8 8c f2 ff ff       	call   8005d0 <cputchar>
  801344:	83 c4 10             	add    $0x10,%esp
				i--;
  801347:	ff 4d f4             	decl   -0xc(%ebp)
  80134a:	eb 31                	jmp    80137d <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80134c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801350:	74 0a                	je     80135c <atomic_readline+0xda>
  801352:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801356:	0f 85 61 ff ff ff    	jne    8012bd <atomic_readline+0x3b>
				if (echoing)
  80135c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801360:	74 0e                	je     801370 <atomic_readline+0xee>
					cputchar(c);
  801362:	83 ec 0c             	sub    $0xc,%esp
  801365:	ff 75 ec             	pushl  -0x14(%ebp)
  801368:	e8 63 f2 ff ff       	call   8005d0 <cputchar>
  80136d:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801370:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801373:	8b 45 0c             	mov    0xc(%ebp),%eax
  801376:	01 d0                	add    %edx,%eax
  801378:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80137b:	eb 06                	jmp    801383 <atomic_readline+0x101>
			}
		}
  80137d:	e9 3b ff ff ff       	jmp    8012bd <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801382:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801383:	e8 a0 15 00 00       	call   802928 <sys_unlock_cons>
}
  801388:	90                   	nop
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801391:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801398:	eb 06                	jmp    8013a0 <strlen+0x15>
		n++;
  80139a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80139d:	ff 45 08             	incl   0x8(%ebp)
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	84 c0                	test   %al,%al
  8013a7:	75 f1                	jne    80139a <strlen+0xf>
		n++;
	return n;
  8013a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013bb:	eb 09                	jmp    8013c6 <strnlen+0x18>
		n++;
  8013bd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013c0:	ff 45 08             	incl   0x8(%ebp)
  8013c3:	ff 4d 0c             	decl   0xc(%ebp)
  8013c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013ca:	74 09                	je     8013d5 <strnlen+0x27>
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	84 c0                	test   %al,%al
  8013d3:	75 e8                	jne    8013bd <strnlen+0xf>
		n++;
	return n;
  8013d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013e6:	90                   	nop
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	8d 50 01             	lea    0x1(%eax),%edx
  8013ed:	89 55 08             	mov    %edx,0x8(%ebp)
  8013f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013f6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013f9:	8a 12                	mov    (%edx),%dl
  8013fb:	88 10                	mov    %dl,(%eax)
  8013fd:	8a 00                	mov    (%eax),%al
  8013ff:	84 c0                	test   %al,%al
  801401:	75 e4                	jne    8013e7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801403:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141b:	eb 1f                	jmp    80143c <strncpy+0x34>
		*dst++ = *src;
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8d 50 01             	lea    0x1(%eax),%edx
  801423:	89 55 08             	mov    %edx,0x8(%ebp)
  801426:	8b 55 0c             	mov    0xc(%ebp),%edx
  801429:	8a 12                	mov    (%edx),%dl
  80142b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80142d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	84 c0                	test   %al,%al
  801434:	74 03                	je     801439 <strncpy+0x31>
			src++;
  801436:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801439:	ff 45 fc             	incl   -0x4(%ebp)
  80143c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80143f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801442:	72 d9                	jb     80141d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801444:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80144f:	8b 45 08             	mov    0x8(%ebp),%eax
  801452:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801455:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801459:	74 30                	je     80148b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80145b:	eb 16                	jmp    801473 <strlcpy+0x2a>
			*dst++ = *src++;
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8d 50 01             	lea    0x1(%eax),%edx
  801463:	89 55 08             	mov    %edx,0x8(%ebp)
  801466:	8b 55 0c             	mov    0xc(%ebp),%edx
  801469:	8d 4a 01             	lea    0x1(%edx),%ecx
  80146c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80146f:	8a 12                	mov    (%edx),%dl
  801471:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801473:	ff 4d 10             	decl   0x10(%ebp)
  801476:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80147a:	74 09                	je     801485 <strlcpy+0x3c>
  80147c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147f:	8a 00                	mov    (%eax),%al
  801481:	84 c0                	test   %al,%al
  801483:	75 d8                	jne    80145d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80148b:	8b 55 08             	mov    0x8(%ebp),%edx
  80148e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801491:	29 c2                	sub    %eax,%edx
  801493:	89 d0                	mov    %edx,%eax
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80149a:	eb 06                	jmp    8014a2 <strcmp+0xb>
		p++, q++;
  80149c:	ff 45 08             	incl   0x8(%ebp)
  80149f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	8a 00                	mov    (%eax),%al
  8014a7:	84 c0                	test   %al,%al
  8014a9:	74 0e                	je     8014b9 <strcmp+0x22>
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8a 10                	mov    (%eax),%dl
  8014b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b3:	8a 00                	mov    (%eax),%al
  8014b5:	38 c2                	cmp    %al,%dl
  8014b7:	74 e3                	je     80149c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	8a 00                	mov    (%eax),%al
  8014be:	0f b6 d0             	movzbl %al,%edx
  8014c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c4:	8a 00                	mov    (%eax),%al
  8014c6:	0f b6 c0             	movzbl %al,%eax
  8014c9:	29 c2                	sub    %eax,%edx
  8014cb:	89 d0                	mov    %edx,%eax
}
  8014cd:	5d                   	pop    %ebp
  8014ce:	c3                   	ret    

008014cf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014d2:	eb 09                	jmp    8014dd <strncmp+0xe>
		n--, p++, q++;
  8014d4:	ff 4d 10             	decl   0x10(%ebp)
  8014d7:	ff 45 08             	incl   0x8(%ebp)
  8014da:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e1:	74 17                	je     8014fa <strncmp+0x2b>
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	84 c0                	test   %al,%al
  8014ea:	74 0e                	je     8014fa <strncmp+0x2b>
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	8a 10                	mov    (%eax),%dl
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	8a 00                	mov    (%eax),%al
  8014f6:	38 c2                	cmp    %al,%dl
  8014f8:	74 da                	je     8014d4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014fe:	75 07                	jne    801507 <strncmp+0x38>
		return 0;
  801500:	b8 00 00 00 00       	mov    $0x0,%eax
  801505:	eb 14                	jmp    80151b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	0f b6 d0             	movzbl %al,%edx
  80150f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	0f b6 c0             	movzbl %al,%eax
  801517:	29 c2                	sub    %eax,%edx
  801519:	89 d0                	mov    %edx,%eax
}
  80151b:	5d                   	pop    %ebp
  80151c:	c3                   	ret    

0080151d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	83 ec 04             	sub    $0x4,%esp
  801523:	8b 45 0c             	mov    0xc(%ebp),%eax
  801526:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801529:	eb 12                	jmp    80153d <strchr+0x20>
		if (*s == c)
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	8a 00                	mov    (%eax),%al
  801530:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801533:	75 05                	jne    80153a <strchr+0x1d>
			return (char *) s;
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	eb 11                	jmp    80154b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80153a:	ff 45 08             	incl   0x8(%ebp)
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	8a 00                	mov    (%eax),%al
  801542:	84 c0                	test   %al,%al
  801544:	75 e5                	jne    80152b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801546:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	83 ec 04             	sub    $0x4,%esp
  801553:	8b 45 0c             	mov    0xc(%ebp),%eax
  801556:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801559:	eb 0d                	jmp    801568 <strfind+0x1b>
		if (*s == c)
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	8a 00                	mov    (%eax),%al
  801560:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801563:	74 0e                	je     801573 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801565:	ff 45 08             	incl   0x8(%ebp)
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	8a 00                	mov    (%eax),%al
  80156d:	84 c0                	test   %al,%al
  80156f:	75 ea                	jne    80155b <strfind+0xe>
  801571:	eb 01                	jmp    801574 <strfind+0x27>
		if (*s == c)
			break;
  801573:	90                   	nop
	return (char *) s;
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801585:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801589:	76 63                	jbe    8015ee <memset+0x75>
		uint64 data_block = c;
  80158b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158e:	99                   	cltd   
  80158f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801592:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801598:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80159f:	c1 e0 08             	shl    $0x8,%eax
  8015a2:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015a5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8015a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ae:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8015b2:	c1 e0 10             	shl    $0x10,%eax
  8015b5:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015b8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c1:	89 c2                	mov    %eax,%edx
  8015c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c8:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015cb:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8015ce:	eb 18                	jmp    8015e8 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8015d0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015d3:	8d 41 08             	lea    0x8(%ecx),%eax
  8015d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8015d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015df:	89 01                	mov    %eax,(%ecx)
  8015e1:	89 51 04             	mov    %edx,0x4(%ecx)
  8015e4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8015e8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015ec:	77 e2                	ja     8015d0 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8015ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015f2:	74 23                	je     801617 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8015f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015fa:	eb 0e                	jmp    80160a <memset+0x91>
			*p8++ = (uint8)c;
  8015fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ff:	8d 50 01             	lea    0x1(%eax),%edx
  801602:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801605:	8b 55 0c             	mov    0xc(%ebp),%edx
  801608:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80160a:	8b 45 10             	mov    0x10(%ebp),%eax
  80160d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801610:	89 55 10             	mov    %edx,0x10(%ebp)
  801613:	85 c0                	test   %eax,%eax
  801615:	75 e5                	jne    8015fc <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801622:	8b 45 0c             	mov    0xc(%ebp),%eax
  801625:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80162e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801632:	76 24                	jbe    801658 <memcpy+0x3c>
		while(n >= 8){
  801634:	eb 1c                	jmp    801652 <memcpy+0x36>
			*d64 = *s64;
  801636:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801639:	8b 50 04             	mov    0x4(%eax),%edx
  80163c:	8b 00                	mov    (%eax),%eax
  80163e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801641:	89 01                	mov    %eax,(%ecx)
  801643:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801646:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80164a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80164e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801652:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801656:	77 de                	ja     801636 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801658:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80165c:	74 31                	je     80168f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80165e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801661:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801664:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801667:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80166a:	eb 16                	jmp    801682 <memcpy+0x66>
			*d8++ = *s8++;
  80166c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166f:	8d 50 01             	lea    0x1(%eax),%edx
  801672:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801675:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801678:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80167e:	8a 12                	mov    (%edx),%dl
  801680:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801682:	8b 45 10             	mov    0x10(%ebp),%eax
  801685:	8d 50 ff             	lea    -0x1(%eax),%edx
  801688:	89 55 10             	mov    %edx,0x10(%ebp)
  80168b:	85 c0                	test   %eax,%eax
  80168d:	75 dd                	jne    80166c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80169a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016ac:	73 50                	jae    8016fe <memmove+0x6a>
  8016ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b4:	01 d0                	add    %edx,%eax
  8016b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016b9:	76 43                	jbe    8016fe <memmove+0x6a>
		s += n;
  8016bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016be:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016c7:	eb 10                	jmp    8016d9 <memmove+0x45>
			*--d = *--s;
  8016c9:	ff 4d f8             	decl   -0x8(%ebp)
  8016cc:	ff 4d fc             	decl   -0x4(%ebp)
  8016cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d2:	8a 10                	mov    (%eax),%dl
  8016d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016df:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e2:	85 c0                	test   %eax,%eax
  8016e4:	75 e3                	jne    8016c9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016e6:	eb 23                	jmp    80170b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016eb:	8d 50 01             	lea    0x1(%eax),%edx
  8016ee:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016f7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016fa:	8a 12                	mov    (%edx),%dl
  8016fc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801701:	8d 50 ff             	lea    -0x1(%eax),%edx
  801704:	89 55 10             	mov    %edx,0x10(%ebp)
  801707:	85 c0                	test   %eax,%eax
  801709:	75 dd                	jne    8016e8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801722:	eb 2a                	jmp    80174e <memcmp+0x3e>
		if (*s1 != *s2)
  801724:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801727:	8a 10                	mov    (%eax),%dl
  801729:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172c:	8a 00                	mov    (%eax),%al
  80172e:	38 c2                	cmp    %al,%dl
  801730:	74 16                	je     801748 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801732:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801735:	8a 00                	mov    (%eax),%al
  801737:	0f b6 d0             	movzbl %al,%edx
  80173a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173d:	8a 00                	mov    (%eax),%al
  80173f:	0f b6 c0             	movzbl %al,%eax
  801742:	29 c2                	sub    %eax,%edx
  801744:	89 d0                	mov    %edx,%eax
  801746:	eb 18                	jmp    801760 <memcmp+0x50>
		s1++, s2++;
  801748:	ff 45 fc             	incl   -0x4(%ebp)
  80174b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80174e:	8b 45 10             	mov    0x10(%ebp),%eax
  801751:	8d 50 ff             	lea    -0x1(%eax),%edx
  801754:	89 55 10             	mov    %edx,0x10(%ebp)
  801757:	85 c0                	test   %eax,%eax
  801759:	75 c9                	jne    801724 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80175b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801768:	8b 55 08             	mov    0x8(%ebp),%edx
  80176b:	8b 45 10             	mov    0x10(%ebp),%eax
  80176e:	01 d0                	add    %edx,%eax
  801770:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801773:	eb 15                	jmp    80178a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8a 00                	mov    (%eax),%al
  80177a:	0f b6 d0             	movzbl %al,%edx
  80177d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801780:	0f b6 c0             	movzbl %al,%eax
  801783:	39 c2                	cmp    %eax,%edx
  801785:	74 0d                	je     801794 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801787:	ff 45 08             	incl   0x8(%ebp)
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801790:	72 e3                	jb     801775 <memfind+0x13>
  801792:	eb 01                	jmp    801795 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801794:	90                   	nop
	return (void *) s;
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017ae:	eb 03                	jmp    8017b3 <strtol+0x19>
		s++;
  8017b0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8a 00                	mov    (%eax),%al
  8017b8:	3c 20                	cmp    $0x20,%al
  8017ba:	74 f4                	je     8017b0 <strtol+0x16>
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	8a 00                	mov    (%eax),%al
  8017c1:	3c 09                	cmp    $0x9,%al
  8017c3:	74 eb                	je     8017b0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	8a 00                	mov    (%eax),%al
  8017ca:	3c 2b                	cmp    $0x2b,%al
  8017cc:	75 05                	jne    8017d3 <strtol+0x39>
		s++;
  8017ce:	ff 45 08             	incl   0x8(%ebp)
  8017d1:	eb 13                	jmp    8017e6 <strtol+0x4c>
	else if (*s == '-')
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	8a 00                	mov    (%eax),%al
  8017d8:	3c 2d                	cmp    $0x2d,%al
  8017da:	75 0a                	jne    8017e6 <strtol+0x4c>
		s++, neg = 1;
  8017dc:	ff 45 08             	incl   0x8(%ebp)
  8017df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ea:	74 06                	je     8017f2 <strtol+0x58>
  8017ec:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017f0:	75 20                	jne    801812 <strtol+0x78>
  8017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f5:	8a 00                	mov    (%eax),%al
  8017f7:	3c 30                	cmp    $0x30,%al
  8017f9:	75 17                	jne    801812 <strtol+0x78>
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	40                   	inc    %eax
  8017ff:	8a 00                	mov    (%eax),%al
  801801:	3c 78                	cmp    $0x78,%al
  801803:	75 0d                	jne    801812 <strtol+0x78>
		s += 2, base = 16;
  801805:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801809:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801810:	eb 28                	jmp    80183a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801812:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801816:	75 15                	jne    80182d <strtol+0x93>
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	8a 00                	mov    (%eax),%al
  80181d:	3c 30                	cmp    $0x30,%al
  80181f:	75 0c                	jne    80182d <strtol+0x93>
		s++, base = 8;
  801821:	ff 45 08             	incl   0x8(%ebp)
  801824:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80182b:	eb 0d                	jmp    80183a <strtol+0xa0>
	else if (base == 0)
  80182d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801831:	75 07                	jne    80183a <strtol+0xa0>
		base = 10;
  801833:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	8a 00                	mov    (%eax),%al
  80183f:	3c 2f                	cmp    $0x2f,%al
  801841:	7e 19                	jle    80185c <strtol+0xc2>
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	8a 00                	mov    (%eax),%al
  801848:	3c 39                	cmp    $0x39,%al
  80184a:	7f 10                	jg     80185c <strtol+0xc2>
			dig = *s - '0';
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	8a 00                	mov    (%eax),%al
  801851:	0f be c0             	movsbl %al,%eax
  801854:	83 e8 30             	sub    $0x30,%eax
  801857:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185a:	eb 42                	jmp    80189e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	8a 00                	mov    (%eax),%al
  801861:	3c 60                	cmp    $0x60,%al
  801863:	7e 19                	jle    80187e <strtol+0xe4>
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	8a 00                	mov    (%eax),%al
  80186a:	3c 7a                	cmp    $0x7a,%al
  80186c:	7f 10                	jg     80187e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	8a 00                	mov    (%eax),%al
  801873:	0f be c0             	movsbl %al,%eax
  801876:	83 e8 57             	sub    $0x57,%eax
  801879:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80187c:	eb 20                	jmp    80189e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80187e:	8b 45 08             	mov    0x8(%ebp),%eax
  801881:	8a 00                	mov    (%eax),%al
  801883:	3c 40                	cmp    $0x40,%al
  801885:	7e 39                	jle    8018c0 <strtol+0x126>
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	8a 00                	mov    (%eax),%al
  80188c:	3c 5a                	cmp    $0x5a,%al
  80188e:	7f 30                	jg     8018c0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	8a 00                	mov    (%eax),%al
  801895:	0f be c0             	movsbl %al,%eax
  801898:	83 e8 37             	sub    $0x37,%eax
  80189b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80189e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018a4:	7d 19                	jge    8018bf <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018a6:	ff 45 08             	incl   0x8(%ebp)
  8018a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ac:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018b0:	89 c2                	mov    %eax,%edx
  8018b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b5:	01 d0                	add    %edx,%eax
  8018b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018ba:	e9 7b ff ff ff       	jmp    80183a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018bf:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018c4:	74 08                	je     8018ce <strtol+0x134>
		*endptr = (char *) s;
  8018c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8018cc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018d2:	74 07                	je     8018db <strtol+0x141>
  8018d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d7:	f7 d8                	neg    %eax
  8018d9:	eb 03                	jmp    8018de <strtol+0x144>
  8018db:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <ltostr>:

void
ltostr(long value, char *str)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018f8:	79 13                	jns    80190d <ltostr+0x2d>
	{
		neg = 1;
  8018fa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801901:	8b 45 0c             	mov    0xc(%ebp),%eax
  801904:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801907:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80190a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801915:	99                   	cltd   
  801916:	f7 f9                	idiv   %ecx
  801918:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80191b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191e:	8d 50 01             	lea    0x1(%eax),%edx
  801921:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801924:	89 c2                	mov    %eax,%edx
  801926:	8b 45 0c             	mov    0xc(%ebp),%eax
  801929:	01 d0                	add    %edx,%eax
  80192b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80192e:	83 c2 30             	add    $0x30,%edx
  801931:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801933:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801936:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80193b:	f7 e9                	imul   %ecx
  80193d:	c1 fa 02             	sar    $0x2,%edx
  801940:	89 c8                	mov    %ecx,%eax
  801942:	c1 f8 1f             	sar    $0x1f,%eax
  801945:	29 c2                	sub    %eax,%edx
  801947:	89 d0                	mov    %edx,%eax
  801949:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80194c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801950:	75 bb                	jne    80190d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801952:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801959:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195c:	48                   	dec    %eax
  80195d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801960:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801964:	74 3d                	je     8019a3 <ltostr+0xc3>
		start = 1 ;
  801966:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80196d:	eb 34                	jmp    8019a3 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80196f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801972:	8b 45 0c             	mov    0xc(%ebp),%eax
  801975:	01 d0                	add    %edx,%eax
  801977:	8a 00                	mov    (%eax),%al
  801979:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80197c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80197f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801982:	01 c2                	add    %eax,%edx
  801984:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198a:	01 c8                	add    %ecx,%eax
  80198c:	8a 00                	mov    (%eax),%al
  80198e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801990:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801993:	8b 45 0c             	mov    0xc(%ebp),%eax
  801996:	01 c2                	add    %eax,%edx
  801998:	8a 45 eb             	mov    -0x15(%ebp),%al
  80199b:	88 02                	mov    %al,(%edx)
		start++ ;
  80199d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019a0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a9:	7c c4                	jl     80196f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019ab:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b1:	01 d0                	add    %edx,%eax
  8019b3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019b6:	90                   	nop
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019bf:	ff 75 08             	pushl  0x8(%ebp)
  8019c2:	e8 c4 f9 ff ff       	call   80138b <strlen>
  8019c7:	83 c4 04             	add    $0x4,%esp
  8019ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019cd:	ff 75 0c             	pushl  0xc(%ebp)
  8019d0:	e8 b6 f9 ff ff       	call   80138b <strlen>
  8019d5:	83 c4 04             	add    $0x4,%esp
  8019d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019e9:	eb 17                	jmp    801a02 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f1:	01 c2                	add    %eax,%edx
  8019f3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	01 c8                	add    %ecx,%eax
  8019fb:	8a 00                	mov    (%eax),%al
  8019fd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019ff:	ff 45 fc             	incl   -0x4(%ebp)
  801a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a05:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a08:	7c e1                	jl     8019eb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a0a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a11:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a18:	eb 1f                	jmp    801a39 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a1d:	8d 50 01             	lea    0x1(%eax),%edx
  801a20:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a23:	89 c2                	mov    %eax,%edx
  801a25:	8b 45 10             	mov    0x10(%ebp),%eax
  801a28:	01 c2                	add    %eax,%edx
  801a2a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a30:	01 c8                	add    %ecx,%eax
  801a32:	8a 00                	mov    (%eax),%al
  801a34:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a36:	ff 45 f8             	incl   -0x8(%ebp)
  801a39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a3f:	7c d9                	jl     801a1a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a44:	8b 45 10             	mov    0x10(%ebp),%eax
  801a47:	01 d0                	add    %edx,%eax
  801a49:	c6 00 00             	movb   $0x0,(%eax)
}
  801a4c:	90                   	nop
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a52:	8b 45 14             	mov    0x14(%ebp),%eax
  801a55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a5b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5e:	8b 00                	mov    (%eax),%eax
  801a60:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a67:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6a:	01 d0                	add    %edx,%eax
  801a6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a72:	eb 0c                	jmp    801a80 <strsplit+0x31>
			*string++ = 0;
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	8d 50 01             	lea    0x1(%eax),%edx
  801a7a:	89 55 08             	mov    %edx,0x8(%ebp)
  801a7d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	8a 00                	mov    (%eax),%al
  801a85:	84 c0                	test   %al,%al
  801a87:	74 18                	je     801aa1 <strsplit+0x52>
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	8a 00                	mov    (%eax),%al
  801a8e:	0f be c0             	movsbl %al,%eax
  801a91:	50                   	push   %eax
  801a92:	ff 75 0c             	pushl  0xc(%ebp)
  801a95:	e8 83 fa ff ff       	call   80151d <strchr>
  801a9a:	83 c4 08             	add    $0x8,%esp
  801a9d:	85 c0                	test   %eax,%eax
  801a9f:	75 d3                	jne    801a74 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	8a 00                	mov    (%eax),%al
  801aa6:	84 c0                	test   %al,%al
  801aa8:	74 5a                	je     801b04 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  801aad:	8b 00                	mov    (%eax),%eax
  801aaf:	83 f8 0f             	cmp    $0xf,%eax
  801ab2:	75 07                	jne    801abb <strsplit+0x6c>
		{
			return 0;
  801ab4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab9:	eb 66                	jmp    801b21 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801abb:	8b 45 14             	mov    0x14(%ebp),%eax
  801abe:	8b 00                	mov    (%eax),%eax
  801ac0:	8d 48 01             	lea    0x1(%eax),%ecx
  801ac3:	8b 55 14             	mov    0x14(%ebp),%edx
  801ac6:	89 0a                	mov    %ecx,(%edx)
  801ac8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801acf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad2:	01 c2                	add    %eax,%edx
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad9:	eb 03                	jmp    801ade <strsplit+0x8f>
			string++;
  801adb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	8a 00                	mov    (%eax),%al
  801ae3:	84 c0                	test   %al,%al
  801ae5:	74 8b                	je     801a72 <strsplit+0x23>
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	8a 00                	mov    (%eax),%al
  801aec:	0f be c0             	movsbl %al,%eax
  801aef:	50                   	push   %eax
  801af0:	ff 75 0c             	pushl  0xc(%ebp)
  801af3:	e8 25 fa ff ff       	call   80151d <strchr>
  801af8:	83 c4 08             	add    $0x8,%esp
  801afb:	85 c0                	test   %eax,%eax
  801afd:	74 dc                	je     801adb <strsplit+0x8c>
			string++;
	}
  801aff:	e9 6e ff ff ff       	jmp    801a72 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b04:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b05:	8b 45 14             	mov    0x14(%ebp),%eax
  801b08:	8b 00                	mov    (%eax),%eax
  801b0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b11:	8b 45 10             	mov    0x10(%ebp),%eax
  801b14:	01 d0                	add    %edx,%eax
  801b16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b1c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
  801b26:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801b2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b36:	eb 4a                	jmp    801b82 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801b38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	01 c2                	add    %eax,%edx
  801b40:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b46:	01 c8                	add    %ecx,%eax
  801b48:	8a 00                	mov    (%eax),%al
  801b4a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801b4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b52:	01 d0                	add    %edx,%eax
  801b54:	8a 00                	mov    (%eax),%al
  801b56:	3c 40                	cmp    $0x40,%al
  801b58:	7e 25                	jle    801b7f <str2lower+0x5c>
  801b5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b60:	01 d0                	add    %edx,%eax
  801b62:	8a 00                	mov    (%eax),%al
  801b64:	3c 5a                	cmp    $0x5a,%al
  801b66:	7f 17                	jg     801b7f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801b68:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	01 d0                	add    %edx,%eax
  801b70:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b73:	8b 55 08             	mov    0x8(%ebp),%edx
  801b76:	01 ca                	add    %ecx,%edx
  801b78:	8a 12                	mov    (%edx),%dl
  801b7a:	83 c2 20             	add    $0x20,%edx
  801b7d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801b7f:	ff 45 fc             	incl   -0x4(%ebp)
  801b82:	ff 75 0c             	pushl  0xc(%ebp)
  801b85:	e8 01 f8 ff ff       	call   80138b <strlen>
  801b8a:	83 c4 04             	add    $0x4,%esp
  801b8d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b90:	7f a6                	jg     801b38 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b92:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801b9d:	83 ec 0c             	sub    $0xc,%esp
  801ba0:	6a 10                	push   $0x10
  801ba2:	e8 b2 15 00 00       	call   803159 <alloc_block>
  801ba7:	83 c4 10             	add    $0x10,%esp
  801baa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801bad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bb1:	75 14                	jne    801bc7 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801bb3:	83 ec 04             	sub    $0x4,%esp
  801bb6:	68 1c 46 80 00       	push   $0x80461c
  801bbb:	6a 14                	push   $0x14
  801bbd:	68 45 46 80 00       	push   $0x804645
  801bc2:	e8 f5 eb ff ff       	call   8007bc <_panic>

	node->start = start;
  801bc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bca:	8b 55 08             	mov    0x8(%ebp),%edx
  801bcd:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd5:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801bd8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801bdf:	a1 28 50 80 00       	mov    0x805028,%eax
  801be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801be7:	eb 18                	jmp    801c01 <insert_page_alloc+0x6a>
		if (start < it->start)
  801be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bec:	8b 00                	mov    (%eax),%eax
  801bee:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bf1:	77 37                	ja     801c2a <insert_page_alloc+0x93>
			break;
		prev = it;
  801bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801bf9:	a1 30 50 80 00       	mov    0x805030,%eax
  801bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c05:	74 08                	je     801c0f <insert_page_alloc+0x78>
  801c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0a:	8b 40 08             	mov    0x8(%eax),%eax
  801c0d:	eb 05                	jmp    801c14 <insert_page_alloc+0x7d>
  801c0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c14:	a3 30 50 80 00       	mov    %eax,0x805030
  801c19:	a1 30 50 80 00       	mov    0x805030,%eax
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	75 c7                	jne    801be9 <insert_page_alloc+0x52>
  801c22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c26:	75 c1                	jne    801be9 <insert_page_alloc+0x52>
  801c28:	eb 01                	jmp    801c2b <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801c2a:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801c2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c2f:	75 64                	jne    801c95 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801c31:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c35:	75 14                	jne    801c4b <insert_page_alloc+0xb4>
  801c37:	83 ec 04             	sub    $0x4,%esp
  801c3a:	68 54 46 80 00       	push   $0x804654
  801c3f:	6a 21                	push   $0x21
  801c41:	68 45 46 80 00       	push   $0x804645
  801c46:	e8 71 eb ff ff       	call   8007bc <_panic>
  801c4b:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801c51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c54:	89 50 08             	mov    %edx,0x8(%eax)
  801c57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c5a:	8b 40 08             	mov    0x8(%eax),%eax
  801c5d:	85 c0                	test   %eax,%eax
  801c5f:	74 0d                	je     801c6e <insert_page_alloc+0xd7>
  801c61:	a1 28 50 80 00       	mov    0x805028,%eax
  801c66:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c69:	89 50 0c             	mov    %edx,0xc(%eax)
  801c6c:	eb 08                	jmp    801c76 <insert_page_alloc+0xdf>
  801c6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c71:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801c76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c79:	a3 28 50 80 00       	mov    %eax,0x805028
  801c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c81:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c88:	a1 34 50 80 00       	mov    0x805034,%eax
  801c8d:	40                   	inc    %eax
  801c8e:	a3 34 50 80 00       	mov    %eax,0x805034
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801c93:	eb 71                	jmp    801d06 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801c95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c99:	74 06                	je     801ca1 <insert_page_alloc+0x10a>
  801c9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c9f:	75 14                	jne    801cb5 <insert_page_alloc+0x11e>
  801ca1:	83 ec 04             	sub    $0x4,%esp
  801ca4:	68 78 46 80 00       	push   $0x804678
  801ca9:	6a 23                	push   $0x23
  801cab:	68 45 46 80 00       	push   $0x804645
  801cb0:	e8 07 eb ff ff       	call   8007bc <_panic>
  801cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb8:	8b 50 08             	mov    0x8(%eax),%edx
  801cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cbe:	89 50 08             	mov    %edx,0x8(%eax)
  801cc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc4:	8b 40 08             	mov    0x8(%eax),%eax
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	74 0c                	je     801cd7 <insert_page_alloc+0x140>
  801ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cce:	8b 40 08             	mov    0x8(%eax),%eax
  801cd1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cd4:	89 50 0c             	mov    %edx,0xc(%eax)
  801cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cda:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cdd:	89 50 08             	mov    %edx,0x8(%eax)
  801ce0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ce3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ce6:	89 50 0c             	mov    %edx,0xc(%eax)
  801ce9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cec:	8b 40 08             	mov    0x8(%eax),%eax
  801cef:	85 c0                	test   %eax,%eax
  801cf1:	75 08                	jne    801cfb <insert_page_alloc+0x164>
  801cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801cfb:	a1 34 50 80 00       	mov    0x805034,%eax
  801d00:	40                   	inc    %eax
  801d01:	a3 34 50 80 00       	mov    %eax,0x805034
}
  801d06:	90                   	nop
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801d0f:	a1 28 50 80 00       	mov    0x805028,%eax
  801d14:	85 c0                	test   %eax,%eax
  801d16:	75 0c                	jne    801d24 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801d18:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d1d:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801d22:	eb 67                	jmp    801d8b <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801d24:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801d2c:	a1 28 50 80 00       	mov    0x805028,%eax
  801d31:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801d34:	eb 26                	jmp    801d5c <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801d36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d39:	8b 10                	mov    (%eax),%edx
  801d3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d3e:	8b 40 04             	mov    0x4(%eax),%eax
  801d41:	01 d0                	add    %edx,%eax
  801d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d49:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801d4c:	76 06                	jbe    801d54 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d51:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801d54:	a1 30 50 80 00       	mov    0x805030,%eax
  801d59:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801d5c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801d60:	74 08                	je     801d6a <recompute_page_alloc_break+0x61>
  801d62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d65:	8b 40 08             	mov    0x8(%eax),%eax
  801d68:	eb 05                	jmp    801d6f <recompute_page_alloc_break+0x66>
  801d6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6f:	a3 30 50 80 00       	mov    %eax,0x805030
  801d74:	a1 30 50 80 00       	mov    0x805030,%eax
  801d79:	85 c0                	test   %eax,%eax
  801d7b:	75 b9                	jne    801d36 <recompute_page_alloc_break+0x2d>
  801d7d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801d81:	75 b3                	jne    801d36 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801d83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d86:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801d93:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  801d9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801da0:	01 d0                	add    %edx,%eax
  801da2:	48                   	dec    %eax
  801da3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801da6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801da9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dae:	f7 75 d8             	divl   -0x28(%ebp)
  801db1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801db4:	29 d0                	sub    %edx,%eax
  801db6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801db9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801dbd:	75 0a                	jne    801dc9 <alloc_pages_custom_fit+0x3c>
		return NULL;
  801dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc4:	e9 7e 01 00 00       	jmp    801f47 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801dc9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801dd0:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801dd4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801ddb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801de2:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801de7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801dea:	a1 28 50 80 00       	mov    0x805028,%eax
  801def:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801df2:	eb 69                	jmp    801e5d <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801df4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801df7:	8b 00                	mov    (%eax),%eax
  801df9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801dfc:	76 47                	jbe    801e45 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801dfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e01:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801e04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e07:	8b 00                	mov    (%eax),%eax
  801e09:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801e0c:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801e0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e12:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e15:	72 2e                	jb     801e45 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801e17:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801e1b:	75 14                	jne    801e31 <alloc_pages_custom_fit+0xa4>
  801e1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e20:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e23:	75 0c                	jne    801e31 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801e25:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e28:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801e2b:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801e2f:	eb 14                	jmp    801e45 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801e31:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e34:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e37:	76 0c                	jbe    801e45 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801e39:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801e3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e42:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801e45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e48:	8b 10                	mov    (%eax),%edx
  801e4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e4d:	8b 40 04             	mov    0x4(%eax),%eax
  801e50:	01 d0                	add    %edx,%eax
  801e52:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801e55:	a1 30 50 80 00       	mov    0x805030,%eax
  801e5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e5d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e61:	74 08                	je     801e6b <alloc_pages_custom_fit+0xde>
  801e63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e66:	8b 40 08             	mov    0x8(%eax),%eax
  801e69:	eb 05                	jmp    801e70 <alloc_pages_custom_fit+0xe3>
  801e6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e70:	a3 30 50 80 00       	mov    %eax,0x805030
  801e75:	a1 30 50 80 00       	mov    0x805030,%eax
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	0f 85 72 ff ff ff    	jne    801df4 <alloc_pages_custom_fit+0x67>
  801e82:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e86:	0f 85 68 ff ff ff    	jne    801df4 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801e8c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e91:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e94:	76 47                	jbe    801edd <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801e96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e99:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801e9c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801ea1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801ea4:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801ea7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801eaa:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801ead:	72 2e                	jb     801edd <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801eaf:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801eb3:	75 14                	jne    801ec9 <alloc_pages_custom_fit+0x13c>
  801eb5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801eb8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801ebb:	75 0c                	jne    801ec9 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801ebd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ec0:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801ec3:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801ec7:	eb 14                	jmp    801edd <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801ec9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ecc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ecf:	76 0c                	jbe    801edd <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801ed1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ed4:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801ed7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801eda:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801edd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801ee4:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801ee8:	74 08                	je     801ef2 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ef0:	eb 40                	jmp    801f32 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801ef2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ef6:	74 08                	je     801f00 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801efb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801efe:	eb 32                	jmp    801f32 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801f00:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801f05:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801f08:	89 c2                	mov    %eax,%edx
  801f0a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f0f:	39 c2                	cmp    %eax,%edx
  801f11:	73 07                	jae    801f1a <alloc_pages_custom_fit+0x18d>
			return NULL;
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
  801f18:	eb 2d                	jmp    801f47 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801f1a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f1f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801f22:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f2b:	01 d0                	add    %edx,%eax
  801f2d:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801f32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f35:	83 ec 08             	sub    $0x8,%esp
  801f38:	ff 75 d0             	pushl  -0x30(%ebp)
  801f3b:	50                   	push   %eax
  801f3c:	e8 56 fc ff ff       	call   801b97 <insert_page_alloc>
  801f41:	83 c4 10             	add    $0x10,%esp

	return result;
  801f44:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f55:	a1 28 50 80 00       	mov    0x805028,%eax
  801f5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f5d:	eb 1a                	jmp    801f79 <find_allocated_size+0x30>
		if (it->start == va)
  801f5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f62:	8b 00                	mov    (%eax),%eax
  801f64:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f67:	75 08                	jne    801f71 <find_allocated_size+0x28>
			return it->size;
  801f69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f6c:	8b 40 04             	mov    0x4(%eax),%eax
  801f6f:	eb 34                	jmp    801fa5 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f71:	a1 30 50 80 00       	mov    0x805030,%eax
  801f76:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f79:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f7d:	74 08                	je     801f87 <find_allocated_size+0x3e>
  801f7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f82:	8b 40 08             	mov    0x8(%eax),%eax
  801f85:	eb 05                	jmp    801f8c <find_allocated_size+0x43>
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8c:	a3 30 50 80 00       	mov    %eax,0x805030
  801f91:	a1 30 50 80 00       	mov    0x805030,%eax
  801f96:	85 c0                	test   %eax,%eax
  801f98:	75 c5                	jne    801f5f <find_allocated_size+0x16>
  801f9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f9e:	75 bf                	jne    801f5f <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801fb3:	a1 28 50 80 00       	mov    0x805028,%eax
  801fb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fbb:	e9 e1 01 00 00       	jmp    8021a1 <free_pages+0x1fa>
		if (it->start == va) {
  801fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc3:	8b 00                	mov    (%eax),%eax
  801fc5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fc8:	0f 85 cb 01 00 00    	jne    802199 <free_pages+0x1f2>

			uint32 start = it->start;
  801fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd1:	8b 00                	mov    (%eax),%eax
  801fd3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd9:	8b 40 04             	mov    0x4(%eax),%eax
  801fdc:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801fdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fe2:	f7 d0                	not    %eax
  801fe4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801fe7:	73 1d                	jae    802006 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801fe9:	83 ec 0c             	sub    $0xc,%esp
  801fec:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fef:	ff 75 e8             	pushl  -0x18(%ebp)
  801ff2:	68 ac 46 80 00       	push   $0x8046ac
  801ff7:	68 a5 00 00 00       	push   $0xa5
  801ffc:	68 45 46 80 00       	push   $0x804645
  802001:	e8 b6 e7 ff ff       	call   8007bc <_panic>
			}

			uint32 start_end = start + size;
  802006:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802009:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80200c:	01 d0                	add    %edx,%eax
  80200e:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  802011:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802014:	85 c0                	test   %eax,%eax
  802016:	79 19                	jns    802031 <free_pages+0x8a>
  802018:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80201f:	77 10                	ja     802031 <free_pages+0x8a>
  802021:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  802028:	77 07                	ja     802031 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  80202a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80202d:	85 c0                	test   %eax,%eax
  80202f:	78 2c                	js     80205d <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  802031:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802034:	83 ec 0c             	sub    $0xc,%esp
  802037:	68 00 00 00 a0       	push   $0xa0000000
  80203c:	ff 75 e0             	pushl  -0x20(%ebp)
  80203f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802042:	ff 75 e8             	pushl  -0x18(%ebp)
  802045:	ff 75 e4             	pushl  -0x1c(%ebp)
  802048:	50                   	push   %eax
  802049:	68 f0 46 80 00       	push   $0x8046f0
  80204e:	68 ad 00 00 00       	push   $0xad
  802053:	68 45 46 80 00       	push   $0x804645
  802058:	e8 5f e7 ff ff       	call   8007bc <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  80205d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802060:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802063:	e9 88 00 00 00       	jmp    8020f0 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  802068:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  80206f:	76 17                	jbe    802088 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  802071:	ff 75 f0             	pushl  -0x10(%ebp)
  802074:	68 54 47 80 00       	push   $0x804754
  802079:	68 b4 00 00 00       	push   $0xb4
  80207e:	68 45 46 80 00       	push   $0x804645
  802083:	e8 34 e7 ff ff       	call   8007bc <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  802088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208b:	05 00 10 00 00       	add    $0x1000,%eax
  802090:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  802093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802096:	85 c0                	test   %eax,%eax
  802098:	79 2e                	jns    8020c8 <free_pages+0x121>
  80209a:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8020a1:	77 25                	ja     8020c8 <free_pages+0x121>
  8020a3:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8020aa:	77 1c                	ja     8020c8 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  8020ac:	83 ec 08             	sub    $0x8,%esp
  8020af:	68 00 10 00 00       	push   $0x1000
  8020b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8020b7:	e8 38 0d 00 00       	call   802df4 <sys_free_user_mem>
  8020bc:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8020bf:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8020c6:	eb 28                	jmp    8020f0 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  8020c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cb:	68 00 00 00 a0       	push   $0xa0000000
  8020d0:	ff 75 dc             	pushl  -0x24(%ebp)
  8020d3:	68 00 10 00 00       	push   $0x1000
  8020d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8020db:	50                   	push   %eax
  8020dc:	68 94 47 80 00       	push   $0x804794
  8020e1:	68 bd 00 00 00       	push   $0xbd
  8020e6:	68 45 46 80 00       	push   $0x804645
  8020eb:	e8 cc e6 ff ff       	call   8007bc <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8020f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8020f6:	0f 82 6c ff ff ff    	jb     802068 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  8020fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802100:	75 17                	jne    802119 <free_pages+0x172>
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	68 f6 47 80 00       	push   $0x8047f6
  80210a:	68 c1 00 00 00       	push   $0xc1
  80210f:	68 45 46 80 00       	push   $0x804645
  802114:	e8 a3 e6 ff ff       	call   8007bc <_panic>
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211c:	8b 40 08             	mov    0x8(%eax),%eax
  80211f:	85 c0                	test   %eax,%eax
  802121:	74 11                	je     802134 <free_pages+0x18d>
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	8b 40 08             	mov    0x8(%eax),%eax
  802129:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212c:	8b 52 0c             	mov    0xc(%edx),%edx
  80212f:	89 50 0c             	mov    %edx,0xc(%eax)
  802132:	eb 0b                	jmp    80213f <free_pages+0x198>
  802134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802137:	8b 40 0c             	mov    0xc(%eax),%eax
  80213a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80213f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802142:	8b 40 0c             	mov    0xc(%eax),%eax
  802145:	85 c0                	test   %eax,%eax
  802147:	74 11                	je     80215a <free_pages+0x1b3>
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	8b 40 0c             	mov    0xc(%eax),%eax
  80214f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802152:	8b 52 08             	mov    0x8(%edx),%edx
  802155:	89 50 08             	mov    %edx,0x8(%eax)
  802158:	eb 0b                	jmp    802165 <free_pages+0x1be>
  80215a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215d:	8b 40 08             	mov    0x8(%eax),%eax
  802160:	a3 28 50 80 00       	mov    %eax,0x805028
  802165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802168:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802179:	a1 34 50 80 00       	mov    0x805034,%eax
  80217e:	48                   	dec    %eax
  80217f:	a3 34 50 80 00       	mov    %eax,0x805034
			free_block(it);
  802184:	83 ec 0c             	sub    $0xc,%esp
  802187:	ff 75 f4             	pushl  -0xc(%ebp)
  80218a:	e8 24 15 00 00       	call   8036b3 <free_block>
  80218f:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  802192:	e8 72 fb ff ff       	call   801d09 <recompute_page_alloc_break>

			return;
  802197:	eb 37                	jmp    8021d0 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802199:	a1 30 50 80 00       	mov    0x805030,%eax
  80219e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a5:	74 08                	je     8021af <free_pages+0x208>
  8021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021aa:	8b 40 08             	mov    0x8(%eax),%eax
  8021ad:	eb 05                	jmp    8021b4 <free_pages+0x20d>
  8021af:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8021b9:	a1 30 50 80 00       	mov    0x805030,%eax
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	0f 85 fa fd ff ff    	jne    801fc0 <free_pages+0x19>
  8021c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ca:	0f 85 f0 fd ff ff    	jne    801fc0 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  8021d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021da:	5d                   	pop    %ebp
  8021db:	c3                   	ret    

008021dc <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8021e2:	a1 08 50 80 00       	mov    0x805008,%eax
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	74 60                	je     80224b <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8021eb:	83 ec 08             	sub    $0x8,%esp
  8021ee:	68 00 00 00 82       	push   $0x82000000
  8021f3:	68 00 00 00 80       	push   $0x80000000
  8021f8:	e8 0d 0d 00 00       	call   802f0a <initialize_dynamic_allocator>
  8021fd:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802200:	e8 f3 0a 00 00       	call   802cf8 <sys_get_uheap_strategy>
  802205:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80220a:	a1 40 50 80 00       	mov    0x805040,%eax
  80220f:	05 00 10 00 00       	add    $0x1000,%eax
  802214:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  802219:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80221e:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  802223:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  80222a:	00 00 00 
  80222d:	c7 05 2c 50 80 00 00 	movl   $0x0,0x80502c
  802234:	00 00 00 
  802237:	c7 05 34 50 80 00 00 	movl   $0x0,0x805034
  80223e:	00 00 00 

		__firstTimeFlag = 0;
  802241:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  802248:	00 00 00 
	}
}
  80224b:	90                   	nop
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802262:	83 ec 08             	sub    $0x8,%esp
  802265:	68 06 04 00 00       	push   $0x406
  80226a:	50                   	push   %eax
  80226b:	e8 d2 06 00 00       	call   802942 <__sys_allocate_page>
  802270:	83 c4 10             	add    $0x10,%esp
  802273:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802276:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80227a:	79 17                	jns    802293 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  80227c:	83 ec 04             	sub    $0x4,%esp
  80227f:	68 14 48 80 00       	push   $0x804814
  802284:	68 ea 00 00 00       	push   $0xea
  802289:	68 45 46 80 00       	push   $0x804645
  80228e:	e8 29 e5 ff ff       	call   8007bc <_panic>
	return 0;
  802293:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8022ae:	83 ec 0c             	sub    $0xc,%esp
  8022b1:	50                   	push   %eax
  8022b2:	e8 d2 06 00 00       	call   802989 <__sys_unmap_frame>
  8022b7:	83 c4 10             	add    $0x10,%esp
  8022ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8022bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022c1:	79 17                	jns    8022da <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  8022c3:	83 ec 04             	sub    $0x4,%esp
  8022c6:	68 50 48 80 00       	push   $0x804850
  8022cb:	68 f5 00 00 00       	push   $0xf5
  8022d0:	68 45 46 80 00       	push   $0x804645
  8022d5:	e8 e2 e4 ff ff       	call   8007bc <_panic>
}
  8022da:	90                   	nop
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8022e3:	e8 f4 fe ff ff       	call   8021dc <uheap_init>
	if (size == 0) return NULL ;
  8022e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ec:	75 0a                	jne    8022f8 <malloc+0x1b>
  8022ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f3:	e9 67 01 00 00       	jmp    80245f <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  8022f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8022ff:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802306:	77 16                	ja     80231e <malloc+0x41>
		result = alloc_block(size);
  802308:	83 ec 0c             	sub    $0xc,%esp
  80230b:	ff 75 08             	pushl  0x8(%ebp)
  80230e:	e8 46 0e 00 00       	call   803159 <alloc_block>
  802313:	83 c4 10             	add    $0x10,%esp
  802316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802319:	e9 3e 01 00 00       	jmp    80245c <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  80231e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802325:	8b 55 08             	mov    0x8(%ebp),%edx
  802328:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232b:	01 d0                	add    %edx,%eax
  80232d:	48                   	dec    %eax
  80232e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802331:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802334:	ba 00 00 00 00       	mov    $0x0,%edx
  802339:	f7 75 f0             	divl   -0x10(%ebp)
  80233c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233f:	29 d0                	sub    %edx,%eax
  802341:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  802344:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802349:	85 c0                	test   %eax,%eax
  80234b:	75 0a                	jne    802357 <malloc+0x7a>
			return NULL;
  80234d:	b8 00 00 00 00       	mov    $0x0,%eax
  802352:	e9 08 01 00 00       	jmp    80245f <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  802357:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80235c:	85 c0                	test   %eax,%eax
  80235e:	74 0f                	je     80236f <malloc+0x92>
  802360:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802366:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80236b:	39 c2                	cmp    %eax,%edx
  80236d:	73 0a                	jae    802379 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  80236f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802374:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802379:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80237e:	83 f8 05             	cmp    $0x5,%eax
  802381:	75 11                	jne    802394 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  802383:	83 ec 0c             	sub    $0xc,%esp
  802386:	ff 75 e8             	pushl  -0x18(%ebp)
  802389:	e8 ff f9 ff ff       	call   801d8d <alloc_pages_custom_fit>
  80238e:	83 c4 10             	add    $0x10,%esp
  802391:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  802394:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802398:	0f 84 be 00 00 00    	je     80245c <malloc+0x17f>
			uint32 result_va = (uint32)result;
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  8023a4:	83 ec 0c             	sub    $0xc,%esp
  8023a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8023aa:	e8 9a fb ff ff       	call   801f49 <find_allocated_size>
  8023af:	83 c4 10             	add    $0x10,%esp
  8023b2:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  8023b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8023b9:	75 17                	jne    8023d2 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  8023bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8023be:	68 90 48 80 00       	push   $0x804890
  8023c3:	68 24 01 00 00       	push   $0x124
  8023c8:	68 45 46 80 00       	push   $0x804645
  8023cd:	e8 ea e3 ff ff       	call   8007bc <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  8023d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023d5:	f7 d0                	not    %eax
  8023d7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8023da:	73 1d                	jae    8023f9 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  8023dc:	83 ec 0c             	sub    $0xc,%esp
  8023df:	ff 75 e0             	pushl  -0x20(%ebp)
  8023e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023e5:	68 d8 48 80 00       	push   $0x8048d8
  8023ea:	68 29 01 00 00       	push   $0x129
  8023ef:	68 45 46 80 00       	push   $0x804645
  8023f4:	e8 c3 e3 ff ff       	call   8007bc <_panic>
			}

			uint32 result_end = result_va + actual_size;
  8023f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ff:	01 d0                	add    %edx,%eax
  802401:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  802404:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	79 2c                	jns    802437 <malloc+0x15a>
  80240b:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802412:	77 23                	ja     802437 <malloc+0x15a>
  802414:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  80241b:	77 1a                	ja     802437 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  80241d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802420:	85 c0                	test   %eax,%eax
  802422:	79 13                	jns    802437 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  802424:	83 ec 08             	sub    $0x8,%esp
  802427:	ff 75 e0             	pushl  -0x20(%ebp)
  80242a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80242d:	e8 de 09 00 00       	call   802e10 <sys_allocate_user_mem>
  802432:	83 c4 10             	add    $0x10,%esp
  802435:	eb 25                	jmp    80245c <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  802437:	68 00 00 00 a0       	push   $0xa0000000
  80243c:	ff 75 dc             	pushl  -0x24(%ebp)
  80243f:	ff 75 e0             	pushl  -0x20(%ebp)
  802442:	ff 75 e4             	pushl  -0x1c(%ebp)
  802445:	ff 75 f4             	pushl  -0xc(%ebp)
  802448:	68 14 49 80 00       	push   $0x804914
  80244d:	68 33 01 00 00       	push   $0x133
  802452:	68 45 46 80 00       	push   $0x804645
  802457:	e8 60 e3 ff ff       	call   8007bc <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  80245f:	c9                   	leave  
  802460:	c3                   	ret    

00802461 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
  802464:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802467:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80246b:	0f 84 26 01 00 00    	je     802597 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  802471:	8b 45 08             	mov    0x8(%ebp),%eax
  802474:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	85 c0                	test   %eax,%eax
  80247c:	79 1c                	jns    80249a <free+0x39>
  80247e:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  802485:	77 13                	ja     80249a <free+0x39>
		free_block(virtual_address);
  802487:	83 ec 0c             	sub    $0xc,%esp
  80248a:	ff 75 08             	pushl  0x8(%ebp)
  80248d:	e8 21 12 00 00       	call   8036b3 <free_block>
  802492:	83 c4 10             	add    $0x10,%esp
		return;
  802495:	e9 01 01 00 00       	jmp    80259b <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  80249a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80249f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8024a2:	0f 82 d8 00 00 00    	jb     802580 <free+0x11f>
  8024a8:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  8024af:	0f 87 cb 00 00 00    	ja     802580 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	25 ff 0f 00 00       	and    $0xfff,%eax
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	74 17                	je     8024d8 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  8024c1:	ff 75 08             	pushl  0x8(%ebp)
  8024c4:	68 84 49 80 00       	push   $0x804984
  8024c9:	68 57 01 00 00       	push   $0x157
  8024ce:	68 45 46 80 00       	push   $0x804645
  8024d3:	e8 e4 e2 ff ff       	call   8007bc <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  8024d8:	83 ec 0c             	sub    $0xc,%esp
  8024db:	ff 75 08             	pushl  0x8(%ebp)
  8024de:	e8 66 fa ff ff       	call   801f49 <find_allocated_size>
  8024e3:	83 c4 10             	add    $0x10,%esp
  8024e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  8024e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024ed:	0f 84 a7 00 00 00    	je     80259a <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  8024f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f6:	f7 d0                	not    %eax
  8024f8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024fb:	73 1d                	jae    80251a <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  8024fd:	83 ec 0c             	sub    $0xc,%esp
  802500:	ff 75 f0             	pushl  -0x10(%ebp)
  802503:	ff 75 f4             	pushl  -0xc(%ebp)
  802506:	68 ac 49 80 00       	push   $0x8049ac
  80250b:	68 61 01 00 00       	push   $0x161
  802510:	68 45 46 80 00       	push   $0x804645
  802515:	e8 a2 e2 ff ff       	call   8007bc <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  80251a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802520:	01 d0                	add    %edx,%eax
  802522:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	85 c0                	test   %eax,%eax
  80252a:	79 19                	jns    802545 <free+0xe4>
  80252c:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  802533:	77 10                	ja     802545 <free+0xe4>
  802535:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  80253c:	77 07                	ja     802545 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  80253e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802541:	85 c0                	test   %eax,%eax
  802543:	78 2b                	js     802570 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  802545:	83 ec 0c             	sub    $0xc,%esp
  802548:	68 00 00 00 a0       	push   $0xa0000000
  80254d:	ff 75 ec             	pushl  -0x14(%ebp)
  802550:	ff 75 f0             	pushl  -0x10(%ebp)
  802553:	ff 75 f4             	pushl  -0xc(%ebp)
  802556:	ff 75 f0             	pushl  -0x10(%ebp)
  802559:	ff 75 08             	pushl  0x8(%ebp)
  80255c:	68 e8 49 80 00       	push   $0x8049e8
  802561:	68 69 01 00 00       	push   $0x169
  802566:	68 45 46 80 00       	push   $0x804645
  80256b:	e8 4c e2 ff ff       	call   8007bc <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  802570:	83 ec 0c             	sub    $0xc,%esp
  802573:	ff 75 08             	pushl  0x8(%ebp)
  802576:	e8 2c fa ff ff       	call   801fa7 <free_pages>
  80257b:	83 c4 10             	add    $0x10,%esp
		return;
  80257e:	eb 1b                	jmp    80259b <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  802580:	ff 75 08             	pushl  0x8(%ebp)
  802583:	68 44 4a 80 00       	push   $0x804a44
  802588:	68 70 01 00 00       	push   $0x170
  80258d:	68 45 46 80 00       	push   $0x804645
  802592:	e8 25 e2 ff ff       	call   8007bc <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802597:	90                   	nop
  802598:	eb 01                	jmp    80259b <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  80259a:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  80259b:	c9                   	leave  
  80259c:	c3                   	ret    

0080259d <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
  8025a0:	83 ec 38             	sub    $0x38,%esp
  8025a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8025a6:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8025a9:	e8 2e fc ff ff       	call   8021dc <uheap_init>
	if (size == 0) return NULL ;
  8025ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025b2:	75 0a                	jne    8025be <smalloc+0x21>
  8025b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b9:	e9 3d 01 00 00       	jmp    8026fb <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  8025be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  8025c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c7:	25 ff 0f 00 00       	and    $0xfff,%eax
  8025cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  8025cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025d3:	74 0e                	je     8025e3 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8025db:	05 00 10 00 00       	add    $0x1000,%eax
  8025e0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	c1 e8 0c             	shr    $0xc,%eax
  8025e9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8025ec:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	75 0a                	jne    8025ff <smalloc+0x62>
		return NULL;
  8025f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fa:	e9 fc 00 00 00       	jmp    8026fb <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8025ff:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802604:	85 c0                	test   %eax,%eax
  802606:	74 0f                	je     802617 <smalloc+0x7a>
  802608:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80260e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802613:	39 c2                	cmp    %eax,%edx
  802615:	73 0a                	jae    802621 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  802617:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80261c:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802621:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802626:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80262b:	29 c2                	sub    %eax,%edx
  80262d:	89 d0                	mov    %edx,%eax
  80262f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802632:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802638:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80263d:	29 c2                	sub    %eax,%edx
  80263f:	89 d0                	mov    %edx,%eax
  802641:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80264a:	77 13                	ja     80265f <smalloc+0xc2>
  80264c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80264f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802652:	77 0b                	ja     80265f <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  802654:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802657:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80265a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80265d:	73 0a                	jae    802669 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  80265f:	b8 00 00 00 00       	mov    $0x0,%eax
  802664:	e9 92 00 00 00       	jmp    8026fb <smalloc+0x15e>
	}

	void *va = NULL;
  802669:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802670:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802675:	83 f8 05             	cmp    $0x5,%eax
  802678:	75 11                	jne    80268b <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  80267a:	83 ec 0c             	sub    $0xc,%esp
  80267d:	ff 75 f4             	pushl  -0xc(%ebp)
  802680:	e8 08 f7 ff ff       	call   801d8d <alloc_pages_custom_fit>
  802685:	83 c4 10             	add    $0x10,%esp
  802688:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  80268b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80268f:	75 27                	jne    8026b8 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802691:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  802698:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80269b:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80269e:	89 c2                	mov    %eax,%edx
  8026a0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8026a5:	39 c2                	cmp    %eax,%edx
  8026a7:	73 07                	jae    8026b0 <smalloc+0x113>
			return NULL;}
  8026a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ae:	eb 4b                	jmp    8026fb <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  8026b0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8026b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  8026b8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8026bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8026bf:	50                   	push   %eax
  8026c0:	ff 75 0c             	pushl  0xc(%ebp)
  8026c3:	ff 75 08             	pushl  0x8(%ebp)
  8026c6:	e8 cb 03 00 00       	call   802a96 <sys_create_shared_object>
  8026cb:	83 c4 10             	add    $0x10,%esp
  8026ce:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  8026d1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8026d5:	79 07                	jns    8026de <smalloc+0x141>
		return NULL;
  8026d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026dc:	eb 1d                	jmp    8026fb <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  8026de:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8026e3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8026e6:	75 10                	jne    8026f8 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8026e8:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	01 d0                	add    %edx,%eax
  8026f3:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  8026f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8026fb:	c9                   	leave  
  8026fc:	c3                   	ret    

008026fd <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
  802700:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802703:	e8 d4 fa ff ff       	call   8021dc <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802708:	83 ec 08             	sub    $0x8,%esp
  80270b:	ff 75 0c             	pushl  0xc(%ebp)
  80270e:	ff 75 08             	pushl  0x8(%ebp)
  802711:	e8 aa 03 00 00       	call   802ac0 <sys_size_of_shared_object>
  802716:	83 c4 10             	add    $0x10,%esp
  802719:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  80271c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802720:	7f 0a                	jg     80272c <sget+0x2f>
		return NULL;
  802722:	b8 00 00 00 00       	mov    $0x0,%eax
  802727:	e9 32 01 00 00       	jmp    80285e <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  80272c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  802732:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802735:	25 ff 0f 00 00       	and    $0xfff,%eax
  80273a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  80273d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802741:	74 0e                	je     802751 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802749:	05 00 10 00 00       	add    $0x1000,%eax
  80274e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  802751:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802756:	85 c0                	test   %eax,%eax
  802758:	75 0a                	jne    802764 <sget+0x67>
		return NULL;
  80275a:	b8 00 00 00 00       	mov    $0x0,%eax
  80275f:	e9 fa 00 00 00       	jmp    80285e <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802764:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802769:	85 c0                	test   %eax,%eax
  80276b:	74 0f                	je     80277c <sget+0x7f>
  80276d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802773:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802778:	39 c2                	cmp    %eax,%edx
  80277a:	73 0a                	jae    802786 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  80277c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802781:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802786:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80278b:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802790:	29 c2                	sub    %eax,%edx
  802792:	89 d0                	mov    %edx,%eax
  802794:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802797:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80279d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8027a2:	29 c2                	sub    %eax,%edx
  8027a4:	89 d0                	mov    %edx,%eax
  8027a6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8027af:	77 13                	ja     8027c4 <sget+0xc7>
  8027b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8027b7:	77 0b                	ja     8027c4 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8027b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bc:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8027bf:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8027c2:	73 0a                	jae    8027ce <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8027c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c9:	e9 90 00 00 00       	jmp    80285e <sget+0x161>

	void *va = NULL;
  8027ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  8027d5:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8027da:	83 f8 05             	cmp    $0x5,%eax
  8027dd:	75 11                	jne    8027f0 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  8027df:	83 ec 0c             	sub    $0xc,%esp
  8027e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8027e5:	e8 a3 f5 ff ff       	call   801d8d <alloc_pages_custom_fit>
  8027ea:	83 c4 10             	add    $0x10,%esp
  8027ed:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8027f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027f4:	75 27                	jne    80281d <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8027f6:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8027fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802800:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802803:	89 c2                	mov    %eax,%edx
  802805:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80280a:	39 c2                	cmp    %eax,%edx
  80280c:	73 07                	jae    802815 <sget+0x118>
			return NULL;
  80280e:	b8 00 00 00 00       	mov    $0x0,%eax
  802813:	eb 49                	jmp    80285e <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802815:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80281a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  80281d:	83 ec 04             	sub    $0x4,%esp
  802820:	ff 75 f0             	pushl  -0x10(%ebp)
  802823:	ff 75 0c             	pushl  0xc(%ebp)
  802826:	ff 75 08             	pushl  0x8(%ebp)
  802829:	e8 af 02 00 00       	call   802add <sys_get_shared_object>
  80282e:	83 c4 10             	add    $0x10,%esp
  802831:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  802834:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802838:	79 07                	jns    802841 <sget+0x144>
		return NULL;
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
  80283f:	eb 1d                	jmp    80285e <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  802841:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802846:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802849:	75 10                	jne    80285b <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  80284b:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	01 d0                	add    %edx,%eax
  802856:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  80285b:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  80285e:	c9                   	leave  
  80285f:	c3                   	ret    

00802860 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
  802863:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802866:	e8 71 f9 ff ff       	call   8021dc <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80286b:	83 ec 04             	sub    $0x4,%esp
  80286e:	68 68 4a 80 00       	push   $0x804a68
  802873:	68 19 02 00 00       	push   $0x219
  802878:	68 45 46 80 00       	push   $0x804645
  80287d:	e8 3a df ff ff       	call   8007bc <_panic>

00802882 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802882:	55                   	push   %ebp
  802883:	89 e5                	mov    %esp,%ebp
  802885:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802888:	83 ec 04             	sub    $0x4,%esp
  80288b:	68 90 4a 80 00       	push   $0x804a90
  802890:	68 2b 02 00 00       	push   $0x22b
  802895:	68 45 46 80 00       	push   $0x804645
  80289a:	e8 1d df ff ff       	call   8007bc <_panic>

0080289f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80289f:	55                   	push   %ebp
  8028a0:	89 e5                	mov    %esp,%ebp
  8028a2:	57                   	push   %edi
  8028a3:	56                   	push   %esi
  8028a4:	53                   	push   %ebx
  8028a5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028b4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8028b7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8028ba:	cd 30                	int    $0x30
  8028bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8028bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8028c2:	83 c4 10             	add    $0x10,%esp
  8028c5:	5b                   	pop    %ebx
  8028c6:	5e                   	pop    %esi
  8028c7:	5f                   	pop    %edi
  8028c8:	5d                   	pop    %ebp
  8028c9:	c3                   	ret    

008028ca <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8028ca:	55                   	push   %ebp
  8028cb:	89 e5                	mov    %esp,%ebp
  8028cd:	83 ec 04             	sub    $0x4,%esp
  8028d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8028d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8028d6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8028d9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8028dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e0:	6a 00                	push   $0x0
  8028e2:	51                   	push   %ecx
  8028e3:	52                   	push   %edx
  8028e4:	ff 75 0c             	pushl  0xc(%ebp)
  8028e7:	50                   	push   %eax
  8028e8:	6a 00                	push   $0x0
  8028ea:	e8 b0 ff ff ff       	call   80289f <syscall>
  8028ef:	83 c4 18             	add    $0x18,%esp
}
  8028f2:	90                   	nop
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    

008028f5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8028f5:	55                   	push   %ebp
  8028f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8028f8:	6a 00                	push   $0x0
  8028fa:	6a 00                	push   $0x0
  8028fc:	6a 00                	push   $0x0
  8028fe:	6a 00                	push   $0x0
  802900:	6a 00                	push   $0x0
  802902:	6a 02                	push   $0x2
  802904:	e8 96 ff ff ff       	call   80289f <syscall>
  802909:	83 c4 18             	add    $0x18,%esp
}
  80290c:	c9                   	leave  
  80290d:	c3                   	ret    

0080290e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80290e:	55                   	push   %ebp
  80290f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	6a 00                	push   $0x0
  802917:	6a 00                	push   $0x0
  802919:	6a 00                	push   $0x0
  80291b:	6a 03                	push   $0x3
  80291d:	e8 7d ff ff ff       	call   80289f <syscall>
  802922:	83 c4 18             	add    $0x18,%esp
}
  802925:	90                   	nop
  802926:	c9                   	leave  
  802927:	c3                   	ret    

00802928 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802928:	55                   	push   %ebp
  802929:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80292b:	6a 00                	push   $0x0
  80292d:	6a 00                	push   $0x0
  80292f:	6a 00                	push   $0x0
  802931:	6a 00                	push   $0x0
  802933:	6a 00                	push   $0x0
  802935:	6a 04                	push   $0x4
  802937:	e8 63 ff ff ff       	call   80289f <syscall>
  80293c:	83 c4 18             	add    $0x18,%esp
}
  80293f:	90                   	nop
  802940:	c9                   	leave  
  802941:	c3                   	ret    

00802942 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802942:	55                   	push   %ebp
  802943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802945:	8b 55 0c             	mov    0xc(%ebp),%edx
  802948:	8b 45 08             	mov    0x8(%ebp),%eax
  80294b:	6a 00                	push   $0x0
  80294d:	6a 00                	push   $0x0
  80294f:	6a 00                	push   $0x0
  802951:	52                   	push   %edx
  802952:	50                   	push   %eax
  802953:	6a 08                	push   $0x8
  802955:	e8 45 ff ff ff       	call   80289f <syscall>
  80295a:	83 c4 18             	add    $0x18,%esp
}
  80295d:	c9                   	leave  
  80295e:	c3                   	ret    

0080295f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80295f:	55                   	push   %ebp
  802960:	89 e5                	mov    %esp,%ebp
  802962:	56                   	push   %esi
  802963:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802964:	8b 75 18             	mov    0x18(%ebp),%esi
  802967:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80296a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80296d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	56                   	push   %esi
  802974:	53                   	push   %ebx
  802975:	51                   	push   %ecx
  802976:	52                   	push   %edx
  802977:	50                   	push   %eax
  802978:	6a 09                	push   $0x9
  80297a:	e8 20 ff ff ff       	call   80289f <syscall>
  80297f:	83 c4 18             	add    $0x18,%esp
}
  802982:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802985:	5b                   	pop    %ebx
  802986:	5e                   	pop    %esi
  802987:	5d                   	pop    %ebp
  802988:	c3                   	ret    

00802989 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802989:	55                   	push   %ebp
  80298a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80298c:	6a 00                	push   $0x0
  80298e:	6a 00                	push   $0x0
  802990:	6a 00                	push   $0x0
  802992:	6a 00                	push   $0x0
  802994:	ff 75 08             	pushl  0x8(%ebp)
  802997:	6a 0a                	push   $0xa
  802999:	e8 01 ff ff ff       	call   80289f <syscall>
  80299e:	83 c4 18             	add    $0x18,%esp
}
  8029a1:	c9                   	leave  
  8029a2:	c3                   	ret    

008029a3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8029a3:	55                   	push   %ebp
  8029a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8029a6:	6a 00                	push   $0x0
  8029a8:	6a 00                	push   $0x0
  8029aa:	6a 00                	push   $0x0
  8029ac:	ff 75 0c             	pushl  0xc(%ebp)
  8029af:	ff 75 08             	pushl  0x8(%ebp)
  8029b2:	6a 0b                	push   $0xb
  8029b4:	e8 e6 fe ff ff       	call   80289f <syscall>
  8029b9:	83 c4 18             	add    $0x18,%esp
}
  8029bc:	c9                   	leave  
  8029bd:	c3                   	ret    

008029be <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8029be:	55                   	push   %ebp
  8029bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8029c1:	6a 00                	push   $0x0
  8029c3:	6a 00                	push   $0x0
  8029c5:	6a 00                	push   $0x0
  8029c7:	6a 00                	push   $0x0
  8029c9:	6a 00                	push   $0x0
  8029cb:	6a 0c                	push   $0xc
  8029cd:	e8 cd fe ff ff       	call   80289f <syscall>
  8029d2:	83 c4 18             	add    $0x18,%esp
}
  8029d5:	c9                   	leave  
  8029d6:	c3                   	ret    

008029d7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8029d7:	55                   	push   %ebp
  8029d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 00                	push   $0x0
  8029de:	6a 00                	push   $0x0
  8029e0:	6a 00                	push   $0x0
  8029e2:	6a 00                	push   $0x0
  8029e4:	6a 0d                	push   $0xd
  8029e6:	e8 b4 fe ff ff       	call   80289f <syscall>
  8029eb:	83 c4 18             	add    $0x18,%esp
}
  8029ee:	c9                   	leave  
  8029ef:	c3                   	ret    

008029f0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8029f0:	55                   	push   %ebp
  8029f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 00                	push   $0x0
  8029fb:	6a 00                	push   $0x0
  8029fd:	6a 0e                	push   $0xe
  8029ff:	e8 9b fe ff ff       	call   80289f <syscall>
  802a04:	83 c4 18             	add    $0x18,%esp
}
  802a07:	c9                   	leave  
  802a08:	c3                   	ret    

00802a09 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802a09:	55                   	push   %ebp
  802a0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802a0c:	6a 00                	push   $0x0
  802a0e:	6a 00                	push   $0x0
  802a10:	6a 00                	push   $0x0
  802a12:	6a 00                	push   $0x0
  802a14:	6a 00                	push   $0x0
  802a16:	6a 0f                	push   $0xf
  802a18:	e8 82 fe ff ff       	call   80289f <syscall>
  802a1d:	83 c4 18             	add    $0x18,%esp
}
  802a20:	c9                   	leave  
  802a21:	c3                   	ret    

00802a22 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802a22:	55                   	push   %ebp
  802a23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802a25:	6a 00                	push   $0x0
  802a27:	6a 00                	push   $0x0
  802a29:	6a 00                	push   $0x0
  802a2b:	6a 00                	push   $0x0
  802a2d:	ff 75 08             	pushl  0x8(%ebp)
  802a30:	6a 10                	push   $0x10
  802a32:	e8 68 fe ff ff       	call   80289f <syscall>
  802a37:	83 c4 18             	add    $0x18,%esp
}
  802a3a:	c9                   	leave  
  802a3b:	c3                   	ret    

00802a3c <sys_scarce_memory>:

void sys_scarce_memory()
{
  802a3c:	55                   	push   %ebp
  802a3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802a3f:	6a 00                	push   $0x0
  802a41:	6a 00                	push   $0x0
  802a43:	6a 00                	push   $0x0
  802a45:	6a 00                	push   $0x0
  802a47:	6a 00                	push   $0x0
  802a49:	6a 11                	push   $0x11
  802a4b:	e8 4f fe ff ff       	call   80289f <syscall>
  802a50:	83 c4 18             	add    $0x18,%esp
}
  802a53:	90                   	nop
  802a54:	c9                   	leave  
  802a55:	c3                   	ret    

00802a56 <sys_cputc>:

void
sys_cputc(const char c)
{
  802a56:	55                   	push   %ebp
  802a57:	89 e5                	mov    %esp,%ebp
  802a59:	83 ec 04             	sub    $0x4,%esp
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802a62:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a66:	6a 00                	push   $0x0
  802a68:	6a 00                	push   $0x0
  802a6a:	6a 00                	push   $0x0
  802a6c:	6a 00                	push   $0x0
  802a6e:	50                   	push   %eax
  802a6f:	6a 01                	push   $0x1
  802a71:	e8 29 fe ff ff       	call   80289f <syscall>
  802a76:	83 c4 18             	add    $0x18,%esp
}
  802a79:	90                   	nop
  802a7a:	c9                   	leave  
  802a7b:	c3                   	ret    

00802a7c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802a7c:	55                   	push   %ebp
  802a7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802a7f:	6a 00                	push   $0x0
  802a81:	6a 00                	push   $0x0
  802a83:	6a 00                	push   $0x0
  802a85:	6a 00                	push   $0x0
  802a87:	6a 00                	push   $0x0
  802a89:	6a 14                	push   $0x14
  802a8b:	e8 0f fe ff ff       	call   80289f <syscall>
  802a90:	83 c4 18             	add    $0x18,%esp
}
  802a93:	90                   	nop
  802a94:	c9                   	leave  
  802a95:	c3                   	ret    

00802a96 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802a96:	55                   	push   %ebp
  802a97:	89 e5                	mov    %esp,%ebp
  802a99:	83 ec 04             	sub    $0x4,%esp
  802a9c:	8b 45 10             	mov    0x10(%ebp),%eax
  802a9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802aa2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802aa5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	6a 00                	push   $0x0
  802aae:	51                   	push   %ecx
  802aaf:	52                   	push   %edx
  802ab0:	ff 75 0c             	pushl  0xc(%ebp)
  802ab3:	50                   	push   %eax
  802ab4:	6a 15                	push   $0x15
  802ab6:	e8 e4 fd ff ff       	call   80289f <syscall>
  802abb:	83 c4 18             	add    $0x18,%esp
}
  802abe:	c9                   	leave  
  802abf:	c3                   	ret    

00802ac0 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802ac0:	55                   	push   %ebp
  802ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac9:	6a 00                	push   $0x0
  802acb:	6a 00                	push   $0x0
  802acd:	6a 00                	push   $0x0
  802acf:	52                   	push   %edx
  802ad0:	50                   	push   %eax
  802ad1:	6a 16                	push   $0x16
  802ad3:	e8 c7 fd ff ff       	call   80289f <syscall>
  802ad8:	83 c4 18             	add    $0x18,%esp
}
  802adb:	c9                   	leave  
  802adc:	c3                   	ret    

00802add <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802add:	55                   	push   %ebp
  802ade:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802ae0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ae3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	6a 00                	push   $0x0
  802aeb:	6a 00                	push   $0x0
  802aed:	51                   	push   %ecx
  802aee:	52                   	push   %edx
  802aef:	50                   	push   %eax
  802af0:	6a 17                	push   $0x17
  802af2:	e8 a8 fd ff ff       	call   80289f <syscall>
  802af7:	83 c4 18             	add    $0x18,%esp
}
  802afa:	c9                   	leave  
  802afb:	c3                   	ret    

00802afc <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802afc:	55                   	push   %ebp
  802afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802aff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	6a 00                	push   $0x0
  802b07:	6a 00                	push   $0x0
  802b09:	6a 00                	push   $0x0
  802b0b:	52                   	push   %edx
  802b0c:	50                   	push   %eax
  802b0d:	6a 18                	push   $0x18
  802b0f:	e8 8b fd ff ff       	call   80289f <syscall>
  802b14:	83 c4 18             	add    $0x18,%esp
}
  802b17:	c9                   	leave  
  802b18:	c3                   	ret    

00802b19 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802b19:	55                   	push   %ebp
  802b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	6a 00                	push   $0x0
  802b21:	ff 75 14             	pushl  0x14(%ebp)
  802b24:	ff 75 10             	pushl  0x10(%ebp)
  802b27:	ff 75 0c             	pushl  0xc(%ebp)
  802b2a:	50                   	push   %eax
  802b2b:	6a 19                	push   $0x19
  802b2d:	e8 6d fd ff ff       	call   80289f <syscall>
  802b32:	83 c4 18             	add    $0x18,%esp
}
  802b35:	c9                   	leave  
  802b36:	c3                   	ret    

00802b37 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802b37:	55                   	push   %ebp
  802b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3d:	6a 00                	push   $0x0
  802b3f:	6a 00                	push   $0x0
  802b41:	6a 00                	push   $0x0
  802b43:	6a 00                	push   $0x0
  802b45:	50                   	push   %eax
  802b46:	6a 1a                	push   $0x1a
  802b48:	e8 52 fd ff ff       	call   80289f <syscall>
  802b4d:	83 c4 18             	add    $0x18,%esp
}
  802b50:	90                   	nop
  802b51:	c9                   	leave  
  802b52:	c3                   	ret    

00802b53 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802b53:	55                   	push   %ebp
  802b54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	6a 00                	push   $0x0
  802b5b:	6a 00                	push   $0x0
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 00                	push   $0x0
  802b61:	50                   	push   %eax
  802b62:	6a 1b                	push   $0x1b
  802b64:	e8 36 fd ff ff       	call   80289f <syscall>
  802b69:	83 c4 18             	add    $0x18,%esp
}
  802b6c:	c9                   	leave  
  802b6d:	c3                   	ret    

00802b6e <sys_getenvid>:

int32 sys_getenvid(void)
{
  802b6e:	55                   	push   %ebp
  802b6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802b71:	6a 00                	push   $0x0
  802b73:	6a 00                	push   $0x0
  802b75:	6a 00                	push   $0x0
  802b77:	6a 00                	push   $0x0
  802b79:	6a 00                	push   $0x0
  802b7b:	6a 05                	push   $0x5
  802b7d:	e8 1d fd ff ff       	call   80289f <syscall>
  802b82:	83 c4 18             	add    $0x18,%esp
}
  802b85:	c9                   	leave  
  802b86:	c3                   	ret    

00802b87 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802b87:	55                   	push   %ebp
  802b88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802b8a:	6a 00                	push   $0x0
  802b8c:	6a 00                	push   $0x0
  802b8e:	6a 00                	push   $0x0
  802b90:	6a 00                	push   $0x0
  802b92:	6a 00                	push   $0x0
  802b94:	6a 06                	push   $0x6
  802b96:	e8 04 fd ff ff       	call   80289f <syscall>
  802b9b:	83 c4 18             	add    $0x18,%esp
}
  802b9e:	c9                   	leave  
  802b9f:	c3                   	ret    

00802ba0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802ba0:	55                   	push   %ebp
  802ba1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802ba3:	6a 00                	push   $0x0
  802ba5:	6a 00                	push   $0x0
  802ba7:	6a 00                	push   $0x0
  802ba9:	6a 00                	push   $0x0
  802bab:	6a 00                	push   $0x0
  802bad:	6a 07                	push   $0x7
  802baf:	e8 eb fc ff ff       	call   80289f <syscall>
  802bb4:	83 c4 18             	add    $0x18,%esp
}
  802bb7:	c9                   	leave  
  802bb8:	c3                   	ret    

00802bb9 <sys_exit_env>:


void sys_exit_env(void)
{
  802bb9:	55                   	push   %ebp
  802bba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802bbc:	6a 00                	push   $0x0
  802bbe:	6a 00                	push   $0x0
  802bc0:	6a 00                	push   $0x0
  802bc2:	6a 00                	push   $0x0
  802bc4:	6a 00                	push   $0x0
  802bc6:	6a 1c                	push   $0x1c
  802bc8:	e8 d2 fc ff ff       	call   80289f <syscall>
  802bcd:	83 c4 18             	add    $0x18,%esp
}
  802bd0:	90                   	nop
  802bd1:	c9                   	leave  
  802bd2:	c3                   	ret    

00802bd3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802bd3:	55                   	push   %ebp
  802bd4:	89 e5                	mov    %esp,%ebp
  802bd6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802bd9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802bdc:	8d 50 04             	lea    0x4(%eax),%edx
  802bdf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802be2:	6a 00                	push   $0x0
  802be4:	6a 00                	push   $0x0
  802be6:	6a 00                	push   $0x0
  802be8:	52                   	push   %edx
  802be9:	50                   	push   %eax
  802bea:	6a 1d                	push   $0x1d
  802bec:	e8 ae fc ff ff       	call   80289f <syscall>
  802bf1:	83 c4 18             	add    $0x18,%esp
	return result;
  802bf4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bf7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802bfa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802bfd:	89 01                	mov    %eax,(%ecx)
  802bff:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	c9                   	leave  
  802c06:	c2 04 00             	ret    $0x4

00802c09 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802c09:	55                   	push   %ebp
  802c0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802c0c:	6a 00                	push   $0x0
  802c0e:	6a 00                	push   $0x0
  802c10:	ff 75 10             	pushl  0x10(%ebp)
  802c13:	ff 75 0c             	pushl  0xc(%ebp)
  802c16:	ff 75 08             	pushl  0x8(%ebp)
  802c19:	6a 13                	push   $0x13
  802c1b:	e8 7f fc ff ff       	call   80289f <syscall>
  802c20:	83 c4 18             	add    $0x18,%esp
	return ;
  802c23:	90                   	nop
}
  802c24:	c9                   	leave  
  802c25:	c3                   	ret    

00802c26 <sys_rcr2>:
uint32 sys_rcr2()
{
  802c26:	55                   	push   %ebp
  802c27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802c29:	6a 00                	push   $0x0
  802c2b:	6a 00                	push   $0x0
  802c2d:	6a 00                	push   $0x0
  802c2f:	6a 00                	push   $0x0
  802c31:	6a 00                	push   $0x0
  802c33:	6a 1e                	push   $0x1e
  802c35:	e8 65 fc ff ff       	call   80289f <syscall>
  802c3a:	83 c4 18             	add    $0x18,%esp
}
  802c3d:	c9                   	leave  
  802c3e:	c3                   	ret    

00802c3f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802c3f:	55                   	push   %ebp
  802c40:	89 e5                	mov    %esp,%ebp
  802c42:	83 ec 04             	sub    $0x4,%esp
  802c45:	8b 45 08             	mov    0x8(%ebp),%eax
  802c48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802c4b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802c4f:	6a 00                	push   $0x0
  802c51:	6a 00                	push   $0x0
  802c53:	6a 00                	push   $0x0
  802c55:	6a 00                	push   $0x0
  802c57:	50                   	push   %eax
  802c58:	6a 1f                	push   $0x1f
  802c5a:	e8 40 fc ff ff       	call   80289f <syscall>
  802c5f:	83 c4 18             	add    $0x18,%esp
	return ;
  802c62:	90                   	nop
}
  802c63:	c9                   	leave  
  802c64:	c3                   	ret    

00802c65 <rsttst>:
void rsttst()
{
  802c65:	55                   	push   %ebp
  802c66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802c68:	6a 00                	push   $0x0
  802c6a:	6a 00                	push   $0x0
  802c6c:	6a 00                	push   $0x0
  802c6e:	6a 00                	push   $0x0
  802c70:	6a 00                	push   $0x0
  802c72:	6a 21                	push   $0x21
  802c74:	e8 26 fc ff ff       	call   80289f <syscall>
  802c79:	83 c4 18             	add    $0x18,%esp
	return ;
  802c7c:	90                   	nop
}
  802c7d:	c9                   	leave  
  802c7e:	c3                   	ret    

00802c7f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802c7f:	55                   	push   %ebp
  802c80:	89 e5                	mov    %esp,%ebp
  802c82:	83 ec 04             	sub    $0x4,%esp
  802c85:	8b 45 14             	mov    0x14(%ebp),%eax
  802c88:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802c8b:	8b 55 18             	mov    0x18(%ebp),%edx
  802c8e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c92:	52                   	push   %edx
  802c93:	50                   	push   %eax
  802c94:	ff 75 10             	pushl  0x10(%ebp)
  802c97:	ff 75 0c             	pushl  0xc(%ebp)
  802c9a:	ff 75 08             	pushl  0x8(%ebp)
  802c9d:	6a 20                	push   $0x20
  802c9f:	e8 fb fb ff ff       	call   80289f <syscall>
  802ca4:	83 c4 18             	add    $0x18,%esp
	return ;
  802ca7:	90                   	nop
}
  802ca8:	c9                   	leave  
  802ca9:	c3                   	ret    

00802caa <chktst>:
void chktst(uint32 n)
{
  802caa:	55                   	push   %ebp
  802cab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802cad:	6a 00                	push   $0x0
  802caf:	6a 00                	push   $0x0
  802cb1:	6a 00                	push   $0x0
  802cb3:	6a 00                	push   $0x0
  802cb5:	ff 75 08             	pushl  0x8(%ebp)
  802cb8:	6a 22                	push   $0x22
  802cba:	e8 e0 fb ff ff       	call   80289f <syscall>
  802cbf:	83 c4 18             	add    $0x18,%esp
	return ;
  802cc2:	90                   	nop
}
  802cc3:	c9                   	leave  
  802cc4:	c3                   	ret    

00802cc5 <inctst>:

void inctst()
{
  802cc5:	55                   	push   %ebp
  802cc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802cc8:	6a 00                	push   $0x0
  802cca:	6a 00                	push   $0x0
  802ccc:	6a 00                	push   $0x0
  802cce:	6a 00                	push   $0x0
  802cd0:	6a 00                	push   $0x0
  802cd2:	6a 23                	push   $0x23
  802cd4:	e8 c6 fb ff ff       	call   80289f <syscall>
  802cd9:	83 c4 18             	add    $0x18,%esp
	return ;
  802cdc:	90                   	nop
}
  802cdd:	c9                   	leave  
  802cde:	c3                   	ret    

00802cdf <gettst>:
uint32 gettst()
{
  802cdf:	55                   	push   %ebp
  802ce0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802ce2:	6a 00                	push   $0x0
  802ce4:	6a 00                	push   $0x0
  802ce6:	6a 00                	push   $0x0
  802ce8:	6a 00                	push   $0x0
  802cea:	6a 00                	push   $0x0
  802cec:	6a 24                	push   $0x24
  802cee:	e8 ac fb ff ff       	call   80289f <syscall>
  802cf3:	83 c4 18             	add    $0x18,%esp
}
  802cf6:	c9                   	leave  
  802cf7:	c3                   	ret    

00802cf8 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802cf8:	55                   	push   %ebp
  802cf9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802cfb:	6a 00                	push   $0x0
  802cfd:	6a 00                	push   $0x0
  802cff:	6a 00                	push   $0x0
  802d01:	6a 00                	push   $0x0
  802d03:	6a 00                	push   $0x0
  802d05:	6a 25                	push   $0x25
  802d07:	e8 93 fb ff ff       	call   80289f <syscall>
  802d0c:	83 c4 18             	add    $0x18,%esp
  802d0f:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802d14:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802d19:	c9                   	leave  
  802d1a:	c3                   	ret    

00802d1b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802d1b:	55                   	push   %ebp
  802d1c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d21:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802d26:	6a 00                	push   $0x0
  802d28:	6a 00                	push   $0x0
  802d2a:	6a 00                	push   $0x0
  802d2c:	6a 00                	push   $0x0
  802d2e:	ff 75 08             	pushl  0x8(%ebp)
  802d31:	6a 26                	push   $0x26
  802d33:	e8 67 fb ff ff       	call   80289f <syscall>
  802d38:	83 c4 18             	add    $0x18,%esp
	return ;
  802d3b:	90                   	nop
}
  802d3c:	c9                   	leave  
  802d3d:	c3                   	ret    

00802d3e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802d3e:	55                   	push   %ebp
  802d3f:	89 e5                	mov    %esp,%ebp
  802d41:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802d42:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d45:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d48:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	6a 00                	push   $0x0
  802d50:	53                   	push   %ebx
  802d51:	51                   	push   %ecx
  802d52:	52                   	push   %edx
  802d53:	50                   	push   %eax
  802d54:	6a 27                	push   $0x27
  802d56:	e8 44 fb ff ff       	call   80289f <syscall>
  802d5b:	83 c4 18             	add    $0x18,%esp
}
  802d5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d61:	c9                   	leave  
  802d62:	c3                   	ret    

00802d63 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802d63:	55                   	push   %ebp
  802d64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802d66:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d69:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6c:	6a 00                	push   $0x0
  802d6e:	6a 00                	push   $0x0
  802d70:	6a 00                	push   $0x0
  802d72:	52                   	push   %edx
  802d73:	50                   	push   %eax
  802d74:	6a 28                	push   $0x28
  802d76:	e8 24 fb ff ff       	call   80289f <syscall>
  802d7b:	83 c4 18             	add    $0x18,%esp
}
  802d7e:	c9                   	leave  
  802d7f:	c3                   	ret    

00802d80 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802d80:	55                   	push   %ebp
  802d81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802d83:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d86:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	6a 00                	push   $0x0
  802d8e:	51                   	push   %ecx
  802d8f:	ff 75 10             	pushl  0x10(%ebp)
  802d92:	52                   	push   %edx
  802d93:	50                   	push   %eax
  802d94:	6a 29                	push   $0x29
  802d96:	e8 04 fb ff ff       	call   80289f <syscall>
  802d9b:	83 c4 18             	add    $0x18,%esp
}
  802d9e:	c9                   	leave  
  802d9f:	c3                   	ret    

00802da0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802da0:	55                   	push   %ebp
  802da1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802da3:	6a 00                	push   $0x0
  802da5:	6a 00                	push   $0x0
  802da7:	ff 75 10             	pushl  0x10(%ebp)
  802daa:	ff 75 0c             	pushl  0xc(%ebp)
  802dad:	ff 75 08             	pushl  0x8(%ebp)
  802db0:	6a 12                	push   $0x12
  802db2:	e8 e8 fa ff ff       	call   80289f <syscall>
  802db7:	83 c4 18             	add    $0x18,%esp
	return ;
  802dba:	90                   	nop
}
  802dbb:	c9                   	leave  
  802dbc:	c3                   	ret    

00802dbd <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802dbd:	55                   	push   %ebp
  802dbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	6a 00                	push   $0x0
  802dc8:	6a 00                	push   $0x0
  802dca:	6a 00                	push   $0x0
  802dcc:	52                   	push   %edx
  802dcd:	50                   	push   %eax
  802dce:	6a 2a                	push   $0x2a
  802dd0:	e8 ca fa ff ff       	call   80289f <syscall>
  802dd5:	83 c4 18             	add    $0x18,%esp
	return;
  802dd8:	90                   	nop
}
  802dd9:	c9                   	leave  
  802dda:	c3                   	ret    

00802ddb <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802ddb:	55                   	push   %ebp
  802ddc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802dde:	6a 00                	push   $0x0
  802de0:	6a 00                	push   $0x0
  802de2:	6a 00                	push   $0x0
  802de4:	6a 00                	push   $0x0
  802de6:	6a 00                	push   $0x0
  802de8:	6a 2b                	push   $0x2b
  802dea:	e8 b0 fa ff ff       	call   80289f <syscall>
  802def:	83 c4 18             	add    $0x18,%esp
}
  802df2:	c9                   	leave  
  802df3:	c3                   	ret    

00802df4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802df4:	55                   	push   %ebp
  802df5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802df7:	6a 00                	push   $0x0
  802df9:	6a 00                	push   $0x0
  802dfb:	6a 00                	push   $0x0
  802dfd:	ff 75 0c             	pushl  0xc(%ebp)
  802e00:	ff 75 08             	pushl  0x8(%ebp)
  802e03:	6a 2d                	push   $0x2d
  802e05:	e8 95 fa ff ff       	call   80289f <syscall>
  802e0a:	83 c4 18             	add    $0x18,%esp
	return;
  802e0d:	90                   	nop
}
  802e0e:	c9                   	leave  
  802e0f:	c3                   	ret    

00802e10 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802e10:	55                   	push   %ebp
  802e11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802e13:	6a 00                	push   $0x0
  802e15:	6a 00                	push   $0x0
  802e17:	6a 00                	push   $0x0
  802e19:	ff 75 0c             	pushl  0xc(%ebp)
  802e1c:	ff 75 08             	pushl  0x8(%ebp)
  802e1f:	6a 2c                	push   $0x2c
  802e21:	e8 79 fa ff ff       	call   80289f <syscall>
  802e26:	83 c4 18             	add    $0x18,%esp
	return ;
  802e29:	90                   	nop
}
  802e2a:	c9                   	leave  
  802e2b:	c3                   	ret    

00802e2c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802e2c:	55                   	push   %ebp
  802e2d:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802e2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e32:	8b 45 08             	mov    0x8(%ebp),%eax
  802e35:	6a 00                	push   $0x0
  802e37:	6a 00                	push   $0x0
  802e39:	6a 00                	push   $0x0
  802e3b:	52                   	push   %edx
  802e3c:	50                   	push   %eax
  802e3d:	6a 2e                	push   $0x2e
  802e3f:	e8 5b fa ff ff       	call   80289f <syscall>
  802e44:	83 c4 18             	add    $0x18,%esp
	return ;
  802e47:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802e48:	c9                   	leave  
  802e49:	c3                   	ret    

00802e4a <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802e4a:	55                   	push   %ebp
  802e4b:	89 e5                	mov    %esp,%ebp
  802e4d:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802e50:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802e57:	72 09                	jb     802e62 <to_page_va+0x18>
  802e59:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802e60:	72 14                	jb     802e76 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802e62:	83 ec 04             	sub    $0x4,%esp
  802e65:	68 b4 4a 80 00       	push   $0x804ab4
  802e6a:	6a 15                	push   $0x15
  802e6c:	68 df 4a 80 00       	push   $0x804adf
  802e71:	e8 46 d9 ff ff       	call   8007bc <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	ba 60 50 80 00       	mov    $0x805060,%edx
  802e7e:	29 d0                	sub    %edx,%eax
  802e80:	c1 f8 02             	sar    $0x2,%eax
  802e83:	89 c2                	mov    %eax,%edx
  802e85:	89 d0                	mov    %edx,%eax
  802e87:	c1 e0 02             	shl    $0x2,%eax
  802e8a:	01 d0                	add    %edx,%eax
  802e8c:	c1 e0 02             	shl    $0x2,%eax
  802e8f:	01 d0                	add    %edx,%eax
  802e91:	c1 e0 02             	shl    $0x2,%eax
  802e94:	01 d0                	add    %edx,%eax
  802e96:	89 c1                	mov    %eax,%ecx
  802e98:	c1 e1 08             	shl    $0x8,%ecx
  802e9b:	01 c8                	add    %ecx,%eax
  802e9d:	89 c1                	mov    %eax,%ecx
  802e9f:	c1 e1 10             	shl    $0x10,%ecx
  802ea2:	01 c8                	add    %ecx,%eax
  802ea4:	01 c0                	add    %eax,%eax
  802ea6:	01 d0                	add    %edx,%eax
  802ea8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	c1 e0 0c             	shl    $0xc,%eax
  802eb1:	89 c2                	mov    %eax,%edx
  802eb3:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802eb8:	01 d0                	add    %edx,%eax
}
  802eba:	c9                   	leave  
  802ebb:	c3                   	ret    

00802ebc <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802ebc:	55                   	push   %ebp
  802ebd:	89 e5                	mov    %esp,%ebp
  802ebf:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802ec2:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802ec7:	8b 55 08             	mov    0x8(%ebp),%edx
  802eca:	29 c2                	sub    %eax,%edx
  802ecc:	89 d0                	mov    %edx,%eax
  802ece:	c1 e8 0c             	shr    $0xc,%eax
  802ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed8:	78 09                	js     802ee3 <to_page_info+0x27>
  802eda:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802ee1:	7e 14                	jle    802ef7 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802ee3:	83 ec 04             	sub    $0x4,%esp
  802ee6:	68 f8 4a 80 00       	push   $0x804af8
  802eeb:	6a 22                	push   $0x22
  802eed:	68 df 4a 80 00       	push   $0x804adf
  802ef2:	e8 c5 d8 ff ff       	call   8007bc <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802ef7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efa:	89 d0                	mov    %edx,%eax
  802efc:	01 c0                	add    %eax,%eax
  802efe:	01 d0                	add    %edx,%eax
  802f00:	c1 e0 02             	shl    $0x2,%eax
  802f03:	05 60 50 80 00       	add    $0x805060,%eax
}
  802f08:	c9                   	leave  
  802f09:	c3                   	ret    

00802f0a <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802f0a:	55                   	push   %ebp
  802f0b:	89 e5                	mov    %esp,%ebp
  802f0d:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802f10:	8b 45 08             	mov    0x8(%ebp),%eax
  802f13:	05 00 00 00 02       	add    $0x2000000,%eax
  802f18:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f1b:	73 16                	jae    802f33 <initialize_dynamic_allocator+0x29>
  802f1d:	68 1c 4b 80 00       	push   $0x804b1c
  802f22:	68 42 4b 80 00       	push   $0x804b42
  802f27:	6a 34                	push   $0x34
  802f29:	68 df 4a 80 00       	push   $0x804adf
  802f2e:	e8 89 d8 ff ff       	call   8007bc <_panic>
		is_initialized = 1;
  802f33:	c7 05 38 50 80 00 01 	movl   $0x1,0x805038
  802f3a:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f48:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802f4d:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802f54:	00 00 00 
  802f57:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802f5e:	00 00 00 
  802f61:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802f68:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802f6b:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802f72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f79:	eb 36                	jmp    802fb1 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7e:	c1 e0 04             	shl    $0x4,%eax
  802f81:	05 80 d0 81 00       	add    $0x81d080,%eax
  802f86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	c1 e0 04             	shl    $0x4,%eax
  802f92:	05 84 d0 81 00       	add    $0x81d084,%eax
  802f97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	c1 e0 04             	shl    $0x4,%eax
  802fa3:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802fa8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802fae:	ff 45 f4             	incl   -0xc(%ebp)
  802fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802fb7:	72 c2                	jb     802f7b <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802fb9:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802fbf:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802fc4:	29 c2                	sub    %eax,%edx
  802fc6:	89 d0                	mov    %edx,%eax
  802fc8:	c1 e8 0c             	shr    $0xc,%eax
  802fcb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802fce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802fd5:	e9 c8 00 00 00       	jmp    8030a2 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802fda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fdd:	89 d0                	mov    %edx,%eax
  802fdf:	01 c0                	add    %eax,%eax
  802fe1:	01 d0                	add    %edx,%eax
  802fe3:	c1 e0 02             	shl    $0x2,%eax
  802fe6:	05 68 50 80 00       	add    $0x805068,%eax
  802feb:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802ff0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ff3:	89 d0                	mov    %edx,%eax
  802ff5:	01 c0                	add    %eax,%eax
  802ff7:	01 d0                	add    %edx,%eax
  802ff9:	c1 e0 02             	shl    $0x2,%eax
  802ffc:	05 6a 50 80 00       	add    $0x80506a,%eax
  803001:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803006:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80300c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80300f:	89 c8                	mov    %ecx,%eax
  803011:	01 c0                	add    %eax,%eax
  803013:	01 c8                	add    %ecx,%eax
  803015:	c1 e0 02             	shl    $0x2,%eax
  803018:	05 64 50 80 00       	add    $0x805064,%eax
  80301d:	89 10                	mov    %edx,(%eax)
  80301f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803022:	89 d0                	mov    %edx,%eax
  803024:	01 c0                	add    %eax,%eax
  803026:	01 d0                	add    %edx,%eax
  803028:	c1 e0 02             	shl    $0x2,%eax
  80302b:	05 64 50 80 00       	add    $0x805064,%eax
  803030:	8b 00                	mov    (%eax),%eax
  803032:	85 c0                	test   %eax,%eax
  803034:	74 1b                	je     803051 <initialize_dynamic_allocator+0x147>
  803036:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80303c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80303f:	89 c8                	mov    %ecx,%eax
  803041:	01 c0                	add    %eax,%eax
  803043:	01 c8                	add    %ecx,%eax
  803045:	c1 e0 02             	shl    $0x2,%eax
  803048:	05 60 50 80 00       	add    $0x805060,%eax
  80304d:	89 02                	mov    %eax,(%edx)
  80304f:	eb 16                	jmp    803067 <initialize_dynamic_allocator+0x15d>
  803051:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803054:	89 d0                	mov    %edx,%eax
  803056:	01 c0                	add    %eax,%eax
  803058:	01 d0                	add    %edx,%eax
  80305a:	c1 e0 02             	shl    $0x2,%eax
  80305d:	05 60 50 80 00       	add    $0x805060,%eax
  803062:	a3 48 50 80 00       	mov    %eax,0x805048
  803067:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80306a:	89 d0                	mov    %edx,%eax
  80306c:	01 c0                	add    %eax,%eax
  80306e:	01 d0                	add    %edx,%eax
  803070:	c1 e0 02             	shl    $0x2,%eax
  803073:	05 60 50 80 00       	add    $0x805060,%eax
  803078:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80307d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803080:	89 d0                	mov    %edx,%eax
  803082:	01 c0                	add    %eax,%eax
  803084:	01 d0                	add    %edx,%eax
  803086:	c1 e0 02             	shl    $0x2,%eax
  803089:	05 60 50 80 00       	add    $0x805060,%eax
  80308e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803094:	a1 54 50 80 00       	mov    0x805054,%eax
  803099:	40                   	inc    %eax
  80309a:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  80309f:	ff 45 f0             	incl   -0x10(%ebp)
  8030a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030a8:	0f 82 2c ff ff ff    	jb     802fda <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8030ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8030b4:	eb 2f                	jmp    8030e5 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  8030b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030b9:	89 d0                	mov    %edx,%eax
  8030bb:	01 c0                	add    %eax,%eax
  8030bd:	01 d0                	add    %edx,%eax
  8030bf:	c1 e0 02             	shl    $0x2,%eax
  8030c2:	05 68 50 80 00       	add    $0x805068,%eax
  8030c7:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  8030cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030cf:	89 d0                	mov    %edx,%eax
  8030d1:	01 c0                	add    %eax,%eax
  8030d3:	01 d0                	add    %edx,%eax
  8030d5:	c1 e0 02             	shl    $0x2,%eax
  8030d8:	05 6a 50 80 00       	add    $0x80506a,%eax
  8030dd:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8030e2:	ff 45 ec             	incl   -0x14(%ebp)
  8030e5:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  8030ec:	76 c8                	jbe    8030b6 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8030ee:	90                   	nop
  8030ef:	c9                   	leave  
  8030f0:	c3                   	ret    

008030f1 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8030f1:	55                   	push   %ebp
  8030f2:	89 e5                	mov    %esp,%ebp
  8030f4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  8030f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fa:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8030ff:	29 c2                	sub    %eax,%edx
  803101:	89 d0                	mov    %edx,%eax
  803103:	c1 e8 0c             	shr    $0xc,%eax
  803106:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803109:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80310c:	89 d0                	mov    %edx,%eax
  80310e:	01 c0                	add    %eax,%eax
  803110:	01 d0                	add    %edx,%eax
  803112:	c1 e0 02             	shl    $0x2,%eax
  803115:	05 68 50 80 00       	add    $0x805068,%eax
  80311a:	8b 00                	mov    (%eax),%eax
  80311c:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80311f:	c9                   	leave  
  803120:	c3                   	ret    

00803121 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803121:	55                   	push   %ebp
  803122:	89 e5                	mov    %esp,%ebp
  803124:	83 ec 14             	sub    $0x14,%esp
  803127:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  80312a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80312e:	77 07                	ja     803137 <nearest_pow2_ceil.1513+0x16>
  803130:	b8 01 00 00 00       	mov    $0x1,%eax
  803135:	eb 20                	jmp    803157 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803137:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  80313e:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  803141:	eb 08                	jmp    80314b <nearest_pow2_ceil.1513+0x2a>
  803143:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803146:	01 c0                	add    %eax,%eax
  803148:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80314b:	d1 6d 08             	shrl   0x8(%ebp)
  80314e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803152:	75 ef                	jne    803143 <nearest_pow2_ceil.1513+0x22>
        return power;
  803154:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803157:	c9                   	leave  
  803158:	c3                   	ret    

00803159 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803159:	55                   	push   %ebp
  80315a:	89 e5                	mov    %esp,%ebp
  80315c:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80315f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803166:	76 16                	jbe    80317e <alloc_block+0x25>
  803168:	68 58 4b 80 00       	push   $0x804b58
  80316d:	68 42 4b 80 00       	push   $0x804b42
  803172:	6a 72                	push   $0x72
  803174:	68 df 4a 80 00       	push   $0x804adf
  803179:	e8 3e d6 ff ff       	call   8007bc <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  80317e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803182:	75 0a                	jne    80318e <alloc_block+0x35>
  803184:	b8 00 00 00 00       	mov    $0x0,%eax
  803189:	e9 bd 04 00 00       	jmp    80364b <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  80318e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  803195:	8b 45 08             	mov    0x8(%ebp),%eax
  803198:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80319b:	73 06                	jae    8031a3 <alloc_block+0x4a>
        size = min_block_size;
  80319d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a0:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  8031a3:	83 ec 0c             	sub    $0xc,%esp
  8031a6:	8d 45 cc             	lea    -0x34(%ebp),%eax
  8031a9:	ff 75 08             	pushl  0x8(%ebp)
  8031ac:	89 c1                	mov    %eax,%ecx
  8031ae:	e8 6e ff ff ff       	call   803121 <nearest_pow2_ceil.1513>
  8031b3:	83 c4 10             	add    $0x10,%esp
  8031b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  8031b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031bc:	83 ec 0c             	sub    $0xc,%esp
  8031bf:	8d 45 cc             	lea    -0x34(%ebp),%eax
  8031c2:	52                   	push   %edx
  8031c3:	89 c1                	mov    %eax,%ecx
  8031c5:	e8 83 04 00 00       	call   80364d <log2_ceil.1520>
  8031ca:	83 c4 10             	add    $0x10,%esp
  8031cd:	83 e8 03             	sub    $0x3,%eax
  8031d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  8031d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d6:	c1 e0 04             	shl    $0x4,%eax
  8031d9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8031de:	8b 00                	mov    (%eax),%eax
  8031e0:	85 c0                	test   %eax,%eax
  8031e2:	0f 84 d8 00 00 00    	je     8032c0 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8031e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031eb:	c1 e0 04             	shl    $0x4,%eax
  8031ee:	05 80 d0 81 00       	add    $0x81d080,%eax
  8031f3:	8b 00                	mov    (%eax),%eax
  8031f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  8031f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031fc:	75 17                	jne    803215 <alloc_block+0xbc>
  8031fe:	83 ec 04             	sub    $0x4,%esp
  803201:	68 79 4b 80 00       	push   $0x804b79
  803206:	68 98 00 00 00       	push   $0x98
  80320b:	68 df 4a 80 00       	push   $0x804adf
  803210:	e8 a7 d5 ff ff       	call   8007bc <_panic>
  803215:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803218:	8b 00                	mov    (%eax),%eax
  80321a:	85 c0                	test   %eax,%eax
  80321c:	74 10                	je     80322e <alloc_block+0xd5>
  80321e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803221:	8b 00                	mov    (%eax),%eax
  803223:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803226:	8b 52 04             	mov    0x4(%edx),%edx
  803229:	89 50 04             	mov    %edx,0x4(%eax)
  80322c:	eb 14                	jmp    803242 <alloc_block+0xe9>
  80322e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803231:	8b 40 04             	mov    0x4(%eax),%eax
  803234:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803237:	c1 e2 04             	shl    $0x4,%edx
  80323a:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803240:	89 02                	mov    %eax,(%edx)
  803242:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803245:	8b 40 04             	mov    0x4(%eax),%eax
  803248:	85 c0                	test   %eax,%eax
  80324a:	74 0f                	je     80325b <alloc_block+0x102>
  80324c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80324f:	8b 40 04             	mov    0x4(%eax),%eax
  803252:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803255:	8b 12                	mov    (%edx),%edx
  803257:	89 10                	mov    %edx,(%eax)
  803259:	eb 13                	jmp    80326e <alloc_block+0x115>
  80325b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80325e:	8b 00                	mov    (%eax),%eax
  803260:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803263:	c1 e2 04             	shl    $0x4,%edx
  803266:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80326c:	89 02                	mov    %eax,(%edx)
  80326e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803271:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803277:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80327a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803281:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803284:	c1 e0 04             	shl    $0x4,%eax
  803287:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80328c:	8b 00                	mov    (%eax),%eax
  80328e:	8d 50 ff             	lea    -0x1(%eax),%edx
  803291:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803294:	c1 e0 04             	shl    $0x4,%eax
  803297:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80329c:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  80329e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032a1:	83 ec 0c             	sub    $0xc,%esp
  8032a4:	50                   	push   %eax
  8032a5:	e8 12 fc ff ff       	call   802ebc <to_page_info>
  8032aa:	83 c4 10             	add    $0x10,%esp
  8032ad:	89 c2                	mov    %eax,%edx
  8032af:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8032b3:	48                   	dec    %eax
  8032b4:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  8032b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032bb:	e9 8b 03 00 00       	jmp    80364b <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  8032c0:	a1 48 50 80 00       	mov    0x805048,%eax
  8032c5:	85 c0                	test   %eax,%eax
  8032c7:	0f 84 64 02 00 00    	je     803531 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  8032cd:	a1 48 50 80 00       	mov    0x805048,%eax
  8032d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  8032d5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032d9:	75 17                	jne    8032f2 <alloc_block+0x199>
  8032db:	83 ec 04             	sub    $0x4,%esp
  8032de:	68 79 4b 80 00       	push   $0x804b79
  8032e3:	68 a0 00 00 00       	push   $0xa0
  8032e8:	68 df 4a 80 00       	push   $0x804adf
  8032ed:	e8 ca d4 ff ff       	call   8007bc <_panic>
  8032f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f5:	8b 00                	mov    (%eax),%eax
  8032f7:	85 c0                	test   %eax,%eax
  8032f9:	74 10                	je     80330b <alloc_block+0x1b2>
  8032fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032fe:	8b 00                	mov    (%eax),%eax
  803300:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803303:	8b 52 04             	mov    0x4(%edx),%edx
  803306:	89 50 04             	mov    %edx,0x4(%eax)
  803309:	eb 0b                	jmp    803316 <alloc_block+0x1bd>
  80330b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80330e:	8b 40 04             	mov    0x4(%eax),%eax
  803311:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803316:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803319:	8b 40 04             	mov    0x4(%eax),%eax
  80331c:	85 c0                	test   %eax,%eax
  80331e:	74 0f                	je     80332f <alloc_block+0x1d6>
  803320:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803323:	8b 40 04             	mov    0x4(%eax),%eax
  803326:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803329:	8b 12                	mov    (%edx),%edx
  80332b:	89 10                	mov    %edx,(%eax)
  80332d:	eb 0a                	jmp    803339 <alloc_block+0x1e0>
  80332f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803332:	8b 00                	mov    (%eax),%eax
  803334:	a3 48 50 80 00       	mov    %eax,0x805048
  803339:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80333c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803342:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803345:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80334c:	a1 54 50 80 00       	mov    0x805054,%eax
  803351:	48                   	dec    %eax
  803352:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  803357:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80335d:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  803361:	b8 00 10 00 00       	mov    $0x1000,%eax
  803366:	99                   	cltd   
  803367:	f7 7d e8             	idivl  -0x18(%ebp)
  80336a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80336d:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  803371:	83 ec 0c             	sub    $0xc,%esp
  803374:	ff 75 dc             	pushl  -0x24(%ebp)
  803377:	e8 ce fa ff ff       	call   802e4a <to_page_va>
  80337c:	83 c4 10             	add    $0x10,%esp
  80337f:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  803382:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803385:	83 ec 0c             	sub    $0xc,%esp
  803388:	50                   	push   %eax
  803389:	e8 c0 ee ff ff       	call   80224e <get_page>
  80338e:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803391:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803398:	e9 aa 00 00 00       	jmp    803447 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  80339d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a0:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  8033a4:	89 c2                	mov    %eax,%edx
  8033a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033a9:	01 d0                	add    %edx,%eax
  8033ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  8033ae:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033b2:	75 17                	jne    8033cb <alloc_block+0x272>
  8033b4:	83 ec 04             	sub    $0x4,%esp
  8033b7:	68 98 4b 80 00       	push   $0x804b98
  8033bc:	68 aa 00 00 00       	push   $0xaa
  8033c1:	68 df 4a 80 00       	push   $0x804adf
  8033c6:	e8 f1 d3 ff ff       	call   8007bc <_panic>
  8033cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ce:	c1 e0 04             	shl    $0x4,%eax
  8033d1:	05 84 d0 81 00       	add    $0x81d084,%eax
  8033d6:	8b 10                	mov    (%eax),%edx
  8033d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033db:	89 50 04             	mov    %edx,0x4(%eax)
  8033de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e1:	8b 40 04             	mov    0x4(%eax),%eax
  8033e4:	85 c0                	test   %eax,%eax
  8033e6:	74 14                	je     8033fc <alloc_block+0x2a3>
  8033e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033eb:	c1 e0 04             	shl    $0x4,%eax
  8033ee:	05 84 d0 81 00       	add    $0x81d084,%eax
  8033f3:	8b 00                	mov    (%eax),%eax
  8033f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033f8:	89 10                	mov    %edx,(%eax)
  8033fa:	eb 11                	jmp    80340d <alloc_block+0x2b4>
  8033fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ff:	c1 e0 04             	shl    $0x4,%eax
  803402:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340b:	89 02                	mov    %eax,(%edx)
  80340d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803410:	c1 e0 04             	shl    $0x4,%eax
  803413:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803419:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80341c:	89 02                	mov    %eax,(%edx)
  80341e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803421:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342a:	c1 e0 04             	shl    $0x4,%eax
  80342d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803432:	8b 00                	mov    (%eax),%eax
  803434:	8d 50 01             	lea    0x1(%eax),%edx
  803437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343a:	c1 e0 04             	shl    $0x4,%eax
  80343d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803442:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803444:	ff 45 f4             	incl   -0xc(%ebp)
  803447:	b8 00 10 00 00       	mov    $0x1000,%eax
  80344c:	99                   	cltd   
  80344d:	f7 7d e8             	idivl  -0x18(%ebp)
  803450:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803453:	0f 8f 44 ff ff ff    	jg     80339d <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345c:	c1 e0 04             	shl    $0x4,%eax
  80345f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803464:	8b 00                	mov    (%eax),%eax
  803466:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803469:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80346d:	75 17                	jne    803486 <alloc_block+0x32d>
  80346f:	83 ec 04             	sub    $0x4,%esp
  803472:	68 79 4b 80 00       	push   $0x804b79
  803477:	68 ae 00 00 00       	push   $0xae
  80347c:	68 df 4a 80 00       	push   $0x804adf
  803481:	e8 36 d3 ff ff       	call   8007bc <_panic>
  803486:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803489:	8b 00                	mov    (%eax),%eax
  80348b:	85 c0                	test   %eax,%eax
  80348d:	74 10                	je     80349f <alloc_block+0x346>
  80348f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803492:	8b 00                	mov    (%eax),%eax
  803494:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803497:	8b 52 04             	mov    0x4(%edx),%edx
  80349a:	89 50 04             	mov    %edx,0x4(%eax)
  80349d:	eb 14                	jmp    8034b3 <alloc_block+0x35a>
  80349f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034a2:	8b 40 04             	mov    0x4(%eax),%eax
  8034a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034a8:	c1 e2 04             	shl    $0x4,%edx
  8034ab:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8034b1:	89 02                	mov    %eax,(%edx)
  8034b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034b6:	8b 40 04             	mov    0x4(%eax),%eax
  8034b9:	85 c0                	test   %eax,%eax
  8034bb:	74 0f                	je     8034cc <alloc_block+0x373>
  8034bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034c0:	8b 40 04             	mov    0x4(%eax),%eax
  8034c3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8034c6:	8b 12                	mov    (%edx),%edx
  8034c8:	89 10                	mov    %edx,(%eax)
  8034ca:	eb 13                	jmp    8034df <alloc_block+0x386>
  8034cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034cf:	8b 00                	mov    (%eax),%eax
  8034d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034d4:	c1 e2 04             	shl    $0x4,%edx
  8034d7:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8034dd:	89 02                	mov    %eax,(%edx)
  8034df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f5:	c1 e0 04             	shl    $0x4,%eax
  8034f8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8034fd:	8b 00                	mov    (%eax),%eax
  8034ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  803502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803505:	c1 e0 04             	shl    $0x4,%eax
  803508:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80350d:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  80350f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803512:	83 ec 0c             	sub    $0xc,%esp
  803515:	50                   	push   %eax
  803516:	e8 a1 f9 ff ff       	call   802ebc <to_page_info>
  80351b:	83 c4 10             	add    $0x10,%esp
  80351e:	89 c2                	mov    %eax,%edx
  803520:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803524:	48                   	dec    %eax
  803525:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  803529:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80352c:	e9 1a 01 00 00       	jmp    80364b <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803534:	40                   	inc    %eax
  803535:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803538:	e9 ed 00 00 00       	jmp    80362a <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  80353d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803540:	c1 e0 04             	shl    $0x4,%eax
  803543:	05 80 d0 81 00       	add    $0x81d080,%eax
  803548:	8b 00                	mov    (%eax),%eax
  80354a:	85 c0                	test   %eax,%eax
  80354c:	0f 84 d5 00 00 00    	je     803627 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  803552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803555:	c1 e0 04             	shl    $0x4,%eax
  803558:	05 80 d0 81 00       	add    $0x81d080,%eax
  80355d:	8b 00                	mov    (%eax),%eax
  80355f:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  803562:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803566:	75 17                	jne    80357f <alloc_block+0x426>
  803568:	83 ec 04             	sub    $0x4,%esp
  80356b:	68 79 4b 80 00       	push   $0x804b79
  803570:	68 b8 00 00 00       	push   $0xb8
  803575:	68 df 4a 80 00       	push   $0x804adf
  80357a:	e8 3d d2 ff ff       	call   8007bc <_panic>
  80357f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803582:	8b 00                	mov    (%eax),%eax
  803584:	85 c0                	test   %eax,%eax
  803586:	74 10                	je     803598 <alloc_block+0x43f>
  803588:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80358b:	8b 00                	mov    (%eax),%eax
  80358d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803590:	8b 52 04             	mov    0x4(%edx),%edx
  803593:	89 50 04             	mov    %edx,0x4(%eax)
  803596:	eb 14                	jmp    8035ac <alloc_block+0x453>
  803598:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80359b:	8b 40 04             	mov    0x4(%eax),%eax
  80359e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035a1:	c1 e2 04             	shl    $0x4,%edx
  8035a4:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8035aa:	89 02                	mov    %eax,(%edx)
  8035ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035af:	8b 40 04             	mov    0x4(%eax),%eax
  8035b2:	85 c0                	test   %eax,%eax
  8035b4:	74 0f                	je     8035c5 <alloc_block+0x46c>
  8035b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035b9:	8b 40 04             	mov    0x4(%eax),%eax
  8035bc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8035bf:	8b 12                	mov    (%edx),%edx
  8035c1:	89 10                	mov    %edx,(%eax)
  8035c3:	eb 13                	jmp    8035d8 <alloc_block+0x47f>
  8035c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035c8:	8b 00                	mov    (%eax),%eax
  8035ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035cd:	c1 e2 04             	shl    $0x4,%edx
  8035d0:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8035d6:	89 02                	mov    %eax,(%edx)
  8035d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ee:	c1 e0 04             	shl    $0x4,%eax
  8035f1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8035f6:	8b 00                	mov    (%eax),%eax
  8035f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8035fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035fe:	c1 e0 04             	shl    $0x4,%eax
  803601:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803606:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  803608:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80360b:	83 ec 0c             	sub    $0xc,%esp
  80360e:	50                   	push   %eax
  80360f:	e8 a8 f8 ff ff       	call   802ebc <to_page_info>
  803614:	83 c4 10             	add    $0x10,%esp
  803617:	89 c2                	mov    %eax,%edx
  803619:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80361d:	48                   	dec    %eax
  80361e:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  803622:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803625:	eb 24                	jmp    80364b <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803627:	ff 45 f0             	incl   -0x10(%ebp)
  80362a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  80362e:	0f 8e 09 ff ff ff    	jle    80353d <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  803634:	83 ec 04             	sub    $0x4,%esp
  803637:	68 bb 4b 80 00       	push   $0x804bbb
  80363c:	68 bf 00 00 00       	push   $0xbf
  803641:	68 df 4a 80 00       	push   $0x804adf
  803646:	e8 71 d1 ff ff       	call   8007bc <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  80364b:	c9                   	leave  
  80364c:	c3                   	ret    

0080364d <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  80364d:	55                   	push   %ebp
  80364e:	89 e5                	mov    %esp,%ebp
  803650:	83 ec 14             	sub    $0x14,%esp
  803653:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  803656:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80365a:	75 07                	jne    803663 <log2_ceil.1520+0x16>
  80365c:	b8 00 00 00 00       	mov    $0x0,%eax
  803661:	eb 1b                	jmp    80367e <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  803663:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  80366a:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  80366d:	eb 06                	jmp    803675 <log2_ceil.1520+0x28>
            x >>= 1;
  80366f:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  803672:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  803675:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803679:	75 f4                	jne    80366f <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  80367b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  80367e:	c9                   	leave  
  80367f:	c3                   	ret    

00803680 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  803680:	55                   	push   %ebp
  803681:	89 e5                	mov    %esp,%ebp
  803683:	83 ec 14             	sub    $0x14,%esp
  803686:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803689:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80368d:	75 07                	jne    803696 <log2_ceil.1547+0x16>
  80368f:	b8 00 00 00 00       	mov    $0x0,%eax
  803694:	eb 1b                	jmp    8036b1 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  803696:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  80369d:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  8036a0:	eb 06                	jmp    8036a8 <log2_ceil.1547+0x28>
			x >>= 1;
  8036a2:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  8036a5:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  8036a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036ac:	75 f4                	jne    8036a2 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8036ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8036b1:	c9                   	leave  
  8036b2:	c3                   	ret    

008036b3 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8036b3:	55                   	push   %ebp
  8036b4:	89 e5                	mov    %esp,%ebp
  8036b6:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8036b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8036bc:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8036c1:	39 c2                	cmp    %eax,%edx
  8036c3:	72 0c                	jb     8036d1 <free_block+0x1e>
  8036c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8036c8:	a1 40 50 80 00       	mov    0x805040,%eax
  8036cd:	39 c2                	cmp    %eax,%edx
  8036cf:	72 19                	jb     8036ea <free_block+0x37>
  8036d1:	68 c0 4b 80 00       	push   $0x804bc0
  8036d6:	68 42 4b 80 00       	push   $0x804b42
  8036db:	68 d0 00 00 00       	push   $0xd0
  8036e0:	68 df 4a 80 00       	push   $0x804adf
  8036e5:	e8 d2 d0 ff ff       	call   8007bc <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8036ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036ee:	0f 84 42 03 00 00    	je     803a36 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8036f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f7:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8036fc:	39 c2                	cmp    %eax,%edx
  8036fe:	72 0c                	jb     80370c <free_block+0x59>
  803700:	8b 55 08             	mov    0x8(%ebp),%edx
  803703:	a1 40 50 80 00       	mov    0x805040,%eax
  803708:	39 c2                	cmp    %eax,%edx
  80370a:	72 17                	jb     803723 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  80370c:	83 ec 04             	sub    $0x4,%esp
  80370f:	68 f8 4b 80 00       	push   $0x804bf8
  803714:	68 e6 00 00 00       	push   $0xe6
  803719:	68 df 4a 80 00       	push   $0x804adf
  80371e:	e8 99 d0 ff ff       	call   8007bc <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  803723:	8b 55 08             	mov    0x8(%ebp),%edx
  803726:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80372b:	29 c2                	sub    %eax,%edx
  80372d:	89 d0                	mov    %edx,%eax
  80372f:	83 e0 07             	and    $0x7,%eax
  803732:	85 c0                	test   %eax,%eax
  803734:	74 17                	je     80374d <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803736:	83 ec 04             	sub    $0x4,%esp
  803739:	68 2c 4c 80 00       	push   $0x804c2c
  80373e:	68 ea 00 00 00       	push   $0xea
  803743:	68 df 4a 80 00       	push   $0x804adf
  803748:	e8 6f d0 ff ff       	call   8007bc <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  80374d:	8b 45 08             	mov    0x8(%ebp),%eax
  803750:	83 ec 0c             	sub    $0xc,%esp
  803753:	50                   	push   %eax
  803754:	e8 63 f7 ff ff       	call   802ebc <to_page_info>
  803759:	83 c4 10             	add    $0x10,%esp
  80375c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  80375f:	83 ec 0c             	sub    $0xc,%esp
  803762:	ff 75 08             	pushl  0x8(%ebp)
  803765:	e8 87 f9 ff ff       	call   8030f1 <get_block_size>
  80376a:	83 c4 10             	add    $0x10,%esp
  80376d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  803770:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803774:	75 17                	jne    80378d <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  803776:	83 ec 04             	sub    $0x4,%esp
  803779:	68 58 4c 80 00       	push   $0x804c58
  80377e:	68 f1 00 00 00       	push   $0xf1
  803783:	68 df 4a 80 00       	push   $0x804adf
  803788:	e8 2f d0 ff ff       	call   8007bc <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  80378d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803790:	83 ec 0c             	sub    $0xc,%esp
  803793:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803796:	52                   	push   %edx
  803797:	89 c1                	mov    %eax,%ecx
  803799:	e8 e2 fe ff ff       	call   803680 <log2_ceil.1547>
  80379e:	83 c4 10             	add    $0x10,%esp
  8037a1:	83 e8 03             	sub    $0x3,%eax
  8037a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8037ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8037b1:	75 17                	jne    8037ca <free_block+0x117>
  8037b3:	83 ec 04             	sub    $0x4,%esp
  8037b6:	68 a4 4c 80 00       	push   $0x804ca4
  8037bb:	68 f6 00 00 00       	push   $0xf6
  8037c0:	68 df 4a 80 00       	push   $0x804adf
  8037c5:	e8 f2 cf ff ff       	call   8007bc <_panic>
  8037ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cd:	c1 e0 04             	shl    $0x4,%eax
  8037d0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037d5:	8b 10                	mov    (%eax),%edx
  8037d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037da:	89 10                	mov    %edx,(%eax)
  8037dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037df:	8b 00                	mov    (%eax),%eax
  8037e1:	85 c0                	test   %eax,%eax
  8037e3:	74 15                	je     8037fa <free_block+0x147>
  8037e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e8:	c1 e0 04             	shl    $0x4,%eax
  8037eb:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037f0:	8b 00                	mov    (%eax),%eax
  8037f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037f5:	89 50 04             	mov    %edx,0x4(%eax)
  8037f8:	eb 11                	jmp    80380b <free_block+0x158>
  8037fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fd:	c1 e0 04             	shl    $0x4,%eax
  803800:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803806:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803809:	89 02                	mov    %eax,(%edx)
  80380b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380e:	c1 e0 04             	shl    $0x4,%eax
  803811:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803817:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80381a:	89 02                	mov    %eax,(%edx)
  80381c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80381f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803829:	c1 e0 04             	shl    $0x4,%eax
  80382c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803831:	8b 00                	mov    (%eax),%eax
  803833:	8d 50 01             	lea    0x1(%eax),%edx
  803836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803839:	c1 e0 04             	shl    $0x4,%eax
  80383c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803841:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  803843:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803846:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80384a:	40                   	inc    %eax
  80384b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80384e:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  803852:	8b 55 08             	mov    0x8(%ebp),%edx
  803855:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80385a:	29 c2                	sub    %eax,%edx
  80385c:	89 d0                	mov    %edx,%eax
  80385e:	c1 e8 0c             	shr    $0xc,%eax
  803861:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  803864:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803867:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80386b:	0f b7 c8             	movzwl %ax,%ecx
  80386e:	b8 00 10 00 00       	mov    $0x1000,%eax
  803873:	99                   	cltd   
  803874:	f7 7d e8             	idivl  -0x18(%ebp)
  803877:	39 c1                	cmp    %eax,%ecx
  803879:	0f 85 b8 01 00 00    	jne    803a37 <free_block+0x384>
    	uint32 blocks_removed = 0;
  80387f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803889:	c1 e0 04             	shl    $0x4,%eax
  80388c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803891:	8b 00                	mov    (%eax),%eax
  803893:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803896:	e9 d5 00 00 00       	jmp    803970 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  80389b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80389e:	8b 00                	mov    (%eax),%eax
  8038a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  8038a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038a6:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8038ab:	29 c2                	sub    %eax,%edx
  8038ad:	89 d0                	mov    %edx,%eax
  8038af:	c1 e8 0c             	shr    $0xc,%eax
  8038b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  8038b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038b8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8038bb:	0f 85 a9 00 00 00    	jne    80396a <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  8038c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038c5:	75 17                	jne    8038de <free_block+0x22b>
  8038c7:	83 ec 04             	sub    $0x4,%esp
  8038ca:	68 79 4b 80 00       	push   $0x804b79
  8038cf:	68 04 01 00 00       	push   $0x104
  8038d4:	68 df 4a 80 00       	push   $0x804adf
  8038d9:	e8 de ce ff ff       	call   8007bc <_panic>
  8038de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e1:	8b 00                	mov    (%eax),%eax
  8038e3:	85 c0                	test   %eax,%eax
  8038e5:	74 10                	je     8038f7 <free_block+0x244>
  8038e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ea:	8b 00                	mov    (%eax),%eax
  8038ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038ef:	8b 52 04             	mov    0x4(%edx),%edx
  8038f2:	89 50 04             	mov    %edx,0x4(%eax)
  8038f5:	eb 14                	jmp    80390b <free_block+0x258>
  8038f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038fa:	8b 40 04             	mov    0x4(%eax),%eax
  8038fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803900:	c1 e2 04             	shl    $0x4,%edx
  803903:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803909:	89 02                	mov    %eax,(%edx)
  80390b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80390e:	8b 40 04             	mov    0x4(%eax),%eax
  803911:	85 c0                	test   %eax,%eax
  803913:	74 0f                	je     803924 <free_block+0x271>
  803915:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803918:	8b 40 04             	mov    0x4(%eax),%eax
  80391b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80391e:	8b 12                	mov    (%edx),%edx
  803920:	89 10                	mov    %edx,(%eax)
  803922:	eb 13                	jmp    803937 <free_block+0x284>
  803924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803927:	8b 00                	mov    (%eax),%eax
  803929:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80392c:	c1 e2 04             	shl    $0x4,%edx
  80392f:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803935:	89 02                	mov    %eax,(%edx)
  803937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803943:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80394a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394d:	c1 e0 04             	shl    $0x4,%eax
  803950:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803955:	8b 00                	mov    (%eax),%eax
  803957:	8d 50 ff             	lea    -0x1(%eax),%edx
  80395a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395d:	c1 e0 04             	shl    $0x4,%eax
  803960:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803965:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803967:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  80396a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80396d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803970:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803974:	0f 85 21 ff ff ff    	jne    80389b <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  80397a:	b8 00 10 00 00       	mov    $0x1000,%eax
  80397f:	99                   	cltd   
  803980:	f7 7d e8             	idivl  -0x18(%ebp)
  803983:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803986:	74 17                	je     80399f <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803988:	83 ec 04             	sub    $0x4,%esp
  80398b:	68 c8 4c 80 00       	push   $0x804cc8
  803990:	68 0c 01 00 00       	push   $0x10c
  803995:	68 df 4a 80 00       	push   $0x804adf
  80399a:	e8 1d ce ff ff       	call   8007bc <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  80399f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039a2:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  8039a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039ab:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8039b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8039b5:	75 17                	jne    8039ce <free_block+0x31b>
  8039b7:	83 ec 04             	sub    $0x4,%esp
  8039ba:	68 98 4b 80 00       	push   $0x804b98
  8039bf:	68 11 01 00 00       	push   $0x111
  8039c4:	68 df 4a 80 00       	push   $0x804adf
  8039c9:	e8 ee cd ff ff       	call   8007bc <_panic>
  8039ce:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8039d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039d7:	89 50 04             	mov    %edx,0x4(%eax)
  8039da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039dd:	8b 40 04             	mov    0x4(%eax),%eax
  8039e0:	85 c0                	test   %eax,%eax
  8039e2:	74 0c                	je     8039f0 <free_block+0x33d>
  8039e4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8039e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039ec:	89 10                	mov    %edx,(%eax)
  8039ee:	eb 08                	jmp    8039f8 <free_block+0x345>
  8039f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039f3:	a3 48 50 80 00       	mov    %eax,0x805048
  8039f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039fb:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803a00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a09:	a1 54 50 80 00       	mov    0x805054,%eax
  803a0e:	40                   	inc    %eax
  803a0f:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803a14:	83 ec 0c             	sub    $0xc,%esp
  803a17:	ff 75 ec             	pushl  -0x14(%ebp)
  803a1a:	e8 2b f4 ff ff       	call   802e4a <to_page_va>
  803a1f:	83 c4 10             	add    $0x10,%esp
  803a22:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803a25:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a28:	83 ec 0c             	sub    $0xc,%esp
  803a2b:	50                   	push   %eax
  803a2c:	e8 69 e8 ff ff       	call   80229a <return_page>
  803a31:	83 c4 10             	add    $0x10,%esp
  803a34:	eb 01                	jmp    803a37 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803a36:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803a37:	c9                   	leave  
  803a38:	c3                   	ret    

00803a39 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803a39:	55                   	push   %ebp
  803a3a:	89 e5                	mov    %esp,%ebp
  803a3c:	83 ec 14             	sub    $0x14,%esp
  803a3f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803a42:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803a46:	77 07                	ja     803a4f <nearest_pow2_ceil.1572+0x16>
      return 1;
  803a48:	b8 01 00 00 00       	mov    $0x1,%eax
  803a4d:	eb 20                	jmp    803a6f <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803a4f:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803a56:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803a59:	eb 08                	jmp    803a63 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803a5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a5e:	01 c0                	add    %eax,%eax
  803a60:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803a63:	d1 6d 08             	shrl   0x8(%ebp)
  803a66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a6a:	75 ef                	jne    803a5b <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803a6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803a6f:	c9                   	leave  
  803a70:	c3                   	ret    

00803a71 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803a71:	55                   	push   %ebp
  803a72:	89 e5                	mov    %esp,%ebp
  803a74:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803a77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a7b:	75 13                	jne    803a90 <realloc_block+0x1f>
    return alloc_block(new_size);
  803a7d:	83 ec 0c             	sub    $0xc,%esp
  803a80:	ff 75 0c             	pushl  0xc(%ebp)
  803a83:	e8 d1 f6 ff ff       	call   803159 <alloc_block>
  803a88:	83 c4 10             	add    $0x10,%esp
  803a8b:	e9 d9 00 00 00       	jmp    803b69 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803a90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a94:	75 18                	jne    803aae <realloc_block+0x3d>
    free_block(va);
  803a96:	83 ec 0c             	sub    $0xc,%esp
  803a99:	ff 75 08             	pushl  0x8(%ebp)
  803a9c:	e8 12 fc ff ff       	call   8036b3 <free_block>
  803aa1:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  803aa9:	e9 bb 00 00 00       	jmp    803b69 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803aae:	83 ec 0c             	sub    $0xc,%esp
  803ab1:	ff 75 08             	pushl  0x8(%ebp)
  803ab4:	e8 38 f6 ff ff       	call   8030f1 <get_block_size>
  803ab9:	83 c4 10             	add    $0x10,%esp
  803abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803abf:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ac9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803acc:	73 06                	jae    803ad4 <realloc_block+0x63>
    new_size = min_block_size;
  803ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ad1:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803ad4:	83 ec 0c             	sub    $0xc,%esp
  803ad7:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803ada:	ff 75 0c             	pushl  0xc(%ebp)
  803add:	89 c1                	mov    %eax,%ecx
  803adf:	e8 55 ff ff ff       	call   803a39 <nearest_pow2_ceil.1572>
  803ae4:	83 c4 10             	add    $0x10,%esp
  803ae7:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803aea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803af0:	75 05                	jne    803af7 <realloc_block+0x86>
    return va;
  803af2:	8b 45 08             	mov    0x8(%ebp),%eax
  803af5:	eb 72                	jmp    803b69 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803af7:	83 ec 0c             	sub    $0xc,%esp
  803afa:	ff 75 0c             	pushl  0xc(%ebp)
  803afd:	e8 57 f6 ff ff       	call   803159 <alloc_block>
  803b02:	83 c4 10             	add    $0x10,%esp
  803b05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803b08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b0c:	75 07                	jne    803b15 <realloc_block+0xa4>
    return NULL;
  803b0e:	b8 00 00 00 00       	mov    $0x0,%eax
  803b13:	eb 54                	jmp    803b69 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803b15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b1b:	39 d0                	cmp    %edx,%eax
  803b1d:	76 02                	jbe    803b21 <realloc_block+0xb0>
  803b1f:	89 d0                	mov    %edx,%eax
  803b21:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803b24:	8b 45 08             	mov    0x8(%ebp),%eax
  803b27:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803b2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b2d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803b30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803b37:	eb 17                	jmp    803b50 <realloc_block+0xdf>
    dst[i] = src[i];
  803b39:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3f:	01 c2                	add    %eax,%edx
  803b41:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b47:	01 c8                	add    %ecx,%eax
  803b49:	8a 00                	mov    (%eax),%al
  803b4b:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803b4d:	ff 45 f4             	incl   -0xc(%ebp)
  803b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b53:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803b56:	72 e1                	jb     803b39 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803b58:	83 ec 0c             	sub    $0xc,%esp
  803b5b:	ff 75 08             	pushl  0x8(%ebp)
  803b5e:	e8 50 fb ff ff       	call   8036b3 <free_block>
  803b63:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803b66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803b69:	c9                   	leave  
  803b6a:	c3                   	ret    
  803b6b:	90                   	nop

00803b6c <__udivdi3>:
  803b6c:	55                   	push   %ebp
  803b6d:	57                   	push   %edi
  803b6e:	56                   	push   %esi
  803b6f:	53                   	push   %ebx
  803b70:	83 ec 1c             	sub    $0x1c,%esp
  803b73:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b77:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b7f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b83:	89 ca                	mov    %ecx,%edx
  803b85:	89 f8                	mov    %edi,%eax
  803b87:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b8b:	85 f6                	test   %esi,%esi
  803b8d:	75 2d                	jne    803bbc <__udivdi3+0x50>
  803b8f:	39 cf                	cmp    %ecx,%edi
  803b91:	77 65                	ja     803bf8 <__udivdi3+0x8c>
  803b93:	89 fd                	mov    %edi,%ebp
  803b95:	85 ff                	test   %edi,%edi
  803b97:	75 0b                	jne    803ba4 <__udivdi3+0x38>
  803b99:	b8 01 00 00 00       	mov    $0x1,%eax
  803b9e:	31 d2                	xor    %edx,%edx
  803ba0:	f7 f7                	div    %edi
  803ba2:	89 c5                	mov    %eax,%ebp
  803ba4:	31 d2                	xor    %edx,%edx
  803ba6:	89 c8                	mov    %ecx,%eax
  803ba8:	f7 f5                	div    %ebp
  803baa:	89 c1                	mov    %eax,%ecx
  803bac:	89 d8                	mov    %ebx,%eax
  803bae:	f7 f5                	div    %ebp
  803bb0:	89 cf                	mov    %ecx,%edi
  803bb2:	89 fa                	mov    %edi,%edx
  803bb4:	83 c4 1c             	add    $0x1c,%esp
  803bb7:	5b                   	pop    %ebx
  803bb8:	5e                   	pop    %esi
  803bb9:	5f                   	pop    %edi
  803bba:	5d                   	pop    %ebp
  803bbb:	c3                   	ret    
  803bbc:	39 ce                	cmp    %ecx,%esi
  803bbe:	77 28                	ja     803be8 <__udivdi3+0x7c>
  803bc0:	0f bd fe             	bsr    %esi,%edi
  803bc3:	83 f7 1f             	xor    $0x1f,%edi
  803bc6:	75 40                	jne    803c08 <__udivdi3+0x9c>
  803bc8:	39 ce                	cmp    %ecx,%esi
  803bca:	72 0a                	jb     803bd6 <__udivdi3+0x6a>
  803bcc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bd0:	0f 87 9e 00 00 00    	ja     803c74 <__udivdi3+0x108>
  803bd6:	b8 01 00 00 00       	mov    $0x1,%eax
  803bdb:	89 fa                	mov    %edi,%edx
  803bdd:	83 c4 1c             	add    $0x1c,%esp
  803be0:	5b                   	pop    %ebx
  803be1:	5e                   	pop    %esi
  803be2:	5f                   	pop    %edi
  803be3:	5d                   	pop    %ebp
  803be4:	c3                   	ret    
  803be5:	8d 76 00             	lea    0x0(%esi),%esi
  803be8:	31 ff                	xor    %edi,%edi
  803bea:	31 c0                	xor    %eax,%eax
  803bec:	89 fa                	mov    %edi,%edx
  803bee:	83 c4 1c             	add    $0x1c,%esp
  803bf1:	5b                   	pop    %ebx
  803bf2:	5e                   	pop    %esi
  803bf3:	5f                   	pop    %edi
  803bf4:	5d                   	pop    %ebp
  803bf5:	c3                   	ret    
  803bf6:	66 90                	xchg   %ax,%ax
  803bf8:	89 d8                	mov    %ebx,%eax
  803bfa:	f7 f7                	div    %edi
  803bfc:	31 ff                	xor    %edi,%edi
  803bfe:	89 fa                	mov    %edi,%edx
  803c00:	83 c4 1c             	add    $0x1c,%esp
  803c03:	5b                   	pop    %ebx
  803c04:	5e                   	pop    %esi
  803c05:	5f                   	pop    %edi
  803c06:	5d                   	pop    %ebp
  803c07:	c3                   	ret    
  803c08:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c0d:	89 eb                	mov    %ebp,%ebx
  803c0f:	29 fb                	sub    %edi,%ebx
  803c11:	89 f9                	mov    %edi,%ecx
  803c13:	d3 e6                	shl    %cl,%esi
  803c15:	89 c5                	mov    %eax,%ebp
  803c17:	88 d9                	mov    %bl,%cl
  803c19:	d3 ed                	shr    %cl,%ebp
  803c1b:	89 e9                	mov    %ebp,%ecx
  803c1d:	09 f1                	or     %esi,%ecx
  803c1f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c23:	89 f9                	mov    %edi,%ecx
  803c25:	d3 e0                	shl    %cl,%eax
  803c27:	89 c5                	mov    %eax,%ebp
  803c29:	89 d6                	mov    %edx,%esi
  803c2b:	88 d9                	mov    %bl,%cl
  803c2d:	d3 ee                	shr    %cl,%esi
  803c2f:	89 f9                	mov    %edi,%ecx
  803c31:	d3 e2                	shl    %cl,%edx
  803c33:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c37:	88 d9                	mov    %bl,%cl
  803c39:	d3 e8                	shr    %cl,%eax
  803c3b:	09 c2                	or     %eax,%edx
  803c3d:	89 d0                	mov    %edx,%eax
  803c3f:	89 f2                	mov    %esi,%edx
  803c41:	f7 74 24 0c          	divl   0xc(%esp)
  803c45:	89 d6                	mov    %edx,%esi
  803c47:	89 c3                	mov    %eax,%ebx
  803c49:	f7 e5                	mul    %ebp
  803c4b:	39 d6                	cmp    %edx,%esi
  803c4d:	72 19                	jb     803c68 <__udivdi3+0xfc>
  803c4f:	74 0b                	je     803c5c <__udivdi3+0xf0>
  803c51:	89 d8                	mov    %ebx,%eax
  803c53:	31 ff                	xor    %edi,%edi
  803c55:	e9 58 ff ff ff       	jmp    803bb2 <__udivdi3+0x46>
  803c5a:	66 90                	xchg   %ax,%ax
  803c5c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c60:	89 f9                	mov    %edi,%ecx
  803c62:	d3 e2                	shl    %cl,%edx
  803c64:	39 c2                	cmp    %eax,%edx
  803c66:	73 e9                	jae    803c51 <__udivdi3+0xe5>
  803c68:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c6b:	31 ff                	xor    %edi,%edi
  803c6d:	e9 40 ff ff ff       	jmp    803bb2 <__udivdi3+0x46>
  803c72:	66 90                	xchg   %ax,%ax
  803c74:	31 c0                	xor    %eax,%eax
  803c76:	e9 37 ff ff ff       	jmp    803bb2 <__udivdi3+0x46>
  803c7b:	90                   	nop

00803c7c <__umoddi3>:
  803c7c:	55                   	push   %ebp
  803c7d:	57                   	push   %edi
  803c7e:	56                   	push   %esi
  803c7f:	53                   	push   %ebx
  803c80:	83 ec 1c             	sub    $0x1c,%esp
  803c83:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c87:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c8f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c9b:	89 f3                	mov    %esi,%ebx
  803c9d:	89 fa                	mov    %edi,%edx
  803c9f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ca3:	89 34 24             	mov    %esi,(%esp)
  803ca6:	85 c0                	test   %eax,%eax
  803ca8:	75 1a                	jne    803cc4 <__umoddi3+0x48>
  803caa:	39 f7                	cmp    %esi,%edi
  803cac:	0f 86 a2 00 00 00    	jbe    803d54 <__umoddi3+0xd8>
  803cb2:	89 c8                	mov    %ecx,%eax
  803cb4:	89 f2                	mov    %esi,%edx
  803cb6:	f7 f7                	div    %edi
  803cb8:	89 d0                	mov    %edx,%eax
  803cba:	31 d2                	xor    %edx,%edx
  803cbc:	83 c4 1c             	add    $0x1c,%esp
  803cbf:	5b                   	pop    %ebx
  803cc0:	5e                   	pop    %esi
  803cc1:	5f                   	pop    %edi
  803cc2:	5d                   	pop    %ebp
  803cc3:	c3                   	ret    
  803cc4:	39 f0                	cmp    %esi,%eax
  803cc6:	0f 87 ac 00 00 00    	ja     803d78 <__umoddi3+0xfc>
  803ccc:	0f bd e8             	bsr    %eax,%ebp
  803ccf:	83 f5 1f             	xor    $0x1f,%ebp
  803cd2:	0f 84 ac 00 00 00    	je     803d84 <__umoddi3+0x108>
  803cd8:	bf 20 00 00 00       	mov    $0x20,%edi
  803cdd:	29 ef                	sub    %ebp,%edi
  803cdf:	89 fe                	mov    %edi,%esi
  803ce1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ce5:	89 e9                	mov    %ebp,%ecx
  803ce7:	d3 e0                	shl    %cl,%eax
  803ce9:	89 d7                	mov    %edx,%edi
  803ceb:	89 f1                	mov    %esi,%ecx
  803ced:	d3 ef                	shr    %cl,%edi
  803cef:	09 c7                	or     %eax,%edi
  803cf1:	89 e9                	mov    %ebp,%ecx
  803cf3:	d3 e2                	shl    %cl,%edx
  803cf5:	89 14 24             	mov    %edx,(%esp)
  803cf8:	89 d8                	mov    %ebx,%eax
  803cfa:	d3 e0                	shl    %cl,%eax
  803cfc:	89 c2                	mov    %eax,%edx
  803cfe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d02:	d3 e0                	shl    %cl,%eax
  803d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d08:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d0c:	89 f1                	mov    %esi,%ecx
  803d0e:	d3 e8                	shr    %cl,%eax
  803d10:	09 d0                	or     %edx,%eax
  803d12:	d3 eb                	shr    %cl,%ebx
  803d14:	89 da                	mov    %ebx,%edx
  803d16:	f7 f7                	div    %edi
  803d18:	89 d3                	mov    %edx,%ebx
  803d1a:	f7 24 24             	mull   (%esp)
  803d1d:	89 c6                	mov    %eax,%esi
  803d1f:	89 d1                	mov    %edx,%ecx
  803d21:	39 d3                	cmp    %edx,%ebx
  803d23:	0f 82 87 00 00 00    	jb     803db0 <__umoddi3+0x134>
  803d29:	0f 84 91 00 00 00    	je     803dc0 <__umoddi3+0x144>
  803d2f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d33:	29 f2                	sub    %esi,%edx
  803d35:	19 cb                	sbb    %ecx,%ebx
  803d37:	89 d8                	mov    %ebx,%eax
  803d39:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d3d:	d3 e0                	shl    %cl,%eax
  803d3f:	89 e9                	mov    %ebp,%ecx
  803d41:	d3 ea                	shr    %cl,%edx
  803d43:	09 d0                	or     %edx,%eax
  803d45:	89 e9                	mov    %ebp,%ecx
  803d47:	d3 eb                	shr    %cl,%ebx
  803d49:	89 da                	mov    %ebx,%edx
  803d4b:	83 c4 1c             	add    $0x1c,%esp
  803d4e:	5b                   	pop    %ebx
  803d4f:	5e                   	pop    %esi
  803d50:	5f                   	pop    %edi
  803d51:	5d                   	pop    %ebp
  803d52:	c3                   	ret    
  803d53:	90                   	nop
  803d54:	89 fd                	mov    %edi,%ebp
  803d56:	85 ff                	test   %edi,%edi
  803d58:	75 0b                	jne    803d65 <__umoddi3+0xe9>
  803d5a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d5f:	31 d2                	xor    %edx,%edx
  803d61:	f7 f7                	div    %edi
  803d63:	89 c5                	mov    %eax,%ebp
  803d65:	89 f0                	mov    %esi,%eax
  803d67:	31 d2                	xor    %edx,%edx
  803d69:	f7 f5                	div    %ebp
  803d6b:	89 c8                	mov    %ecx,%eax
  803d6d:	f7 f5                	div    %ebp
  803d6f:	89 d0                	mov    %edx,%eax
  803d71:	e9 44 ff ff ff       	jmp    803cba <__umoddi3+0x3e>
  803d76:	66 90                	xchg   %ax,%ax
  803d78:	89 c8                	mov    %ecx,%eax
  803d7a:	89 f2                	mov    %esi,%edx
  803d7c:	83 c4 1c             	add    $0x1c,%esp
  803d7f:	5b                   	pop    %ebx
  803d80:	5e                   	pop    %esi
  803d81:	5f                   	pop    %edi
  803d82:	5d                   	pop    %ebp
  803d83:	c3                   	ret    
  803d84:	3b 04 24             	cmp    (%esp),%eax
  803d87:	72 06                	jb     803d8f <__umoddi3+0x113>
  803d89:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d8d:	77 0f                	ja     803d9e <__umoddi3+0x122>
  803d8f:	89 f2                	mov    %esi,%edx
  803d91:	29 f9                	sub    %edi,%ecx
  803d93:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d97:	89 14 24             	mov    %edx,(%esp)
  803d9a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d9e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803da2:	8b 14 24             	mov    (%esp),%edx
  803da5:	83 c4 1c             	add    $0x1c,%esp
  803da8:	5b                   	pop    %ebx
  803da9:	5e                   	pop    %esi
  803daa:	5f                   	pop    %edi
  803dab:	5d                   	pop    %ebp
  803dac:	c3                   	ret    
  803dad:	8d 76 00             	lea    0x0(%esi),%esi
  803db0:	2b 04 24             	sub    (%esp),%eax
  803db3:	19 fa                	sbb    %edi,%edx
  803db5:	89 d1                	mov    %edx,%ecx
  803db7:	89 c6                	mov    %eax,%esi
  803db9:	e9 71 ff ff ff       	jmp    803d2f <__umoddi3+0xb3>
  803dbe:	66 90                	xchg   %ax,%ax
  803dc0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803dc4:	72 ea                	jb     803db0 <__umoddi3+0x134>
  803dc6:	89 d9                	mov    %ebx,%ecx
  803dc8:	e9 62 ff ff ff       	jmp    803d2f <__umoddi3+0xb3>
