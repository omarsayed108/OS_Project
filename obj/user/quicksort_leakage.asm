
obj/user/quicksort_leakage:     file format elf32-i386


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
  800031:	e8 c8 05 00 00       	call   8005fe <libmain>
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
  800041:	e8 ba 28 00 00       	call   802900 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 3d 80 00       	push   $0x803de0
  80004e:	e8 49 0a 00 00       	call   800a9c <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 3d 80 00       	push   $0x803de2
  80005e:	e8 39 0a 00 00       	call   800a9c <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 fb 3d 80 00       	push   $0x803dfb
  80006e:	e8 29 0a 00 00       	call   800a9c <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 3d 80 00       	push   $0x803de2
  80007e:	e8 19 0a 00 00       	call   800a9c <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 3d 80 00       	push   $0x803de0
  80008e:	e8 09 0a 00 00       	call   800a9c <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 14 3e 80 00       	push   $0x803e14
  8000a5:	e8 cb 10 00 00       	call   801175 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 cc 16 00 00       	call   80178c <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 34 3e 80 00       	push   $0x803e34
  8000ce:	e8 c9 09 00 00       	call   800a9c <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 56 3e 80 00       	push   $0x803e56
  8000de:	e8 b9 09 00 00       	call   800a9c <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 64 3e 80 00       	push   $0x803e64
  8000ee:	e8 a9 09 00 00       	call   800a9c <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 73 3e 80 00       	push   $0x803e73
  8000fe:	e8 99 09 00 00       	call   800a9c <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 83 3e 80 00       	push   $0x803e83
  80010e:	e8 89 09 00 00       	call   800a9c <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800116:	e8 c6 04 00 00       	call   8005e1 <getchar>
  80011b:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80011e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 97 04 00 00       	call   8005c2 <cputchar>
  80012b:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	6a 0a                	push   $0xa
  800133:	e8 8a 04 00 00       	call   8005c2 <cputchar>
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
  80014d:	e8 c8 27 00 00       	call   80291a <sys_unlock_cons>

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 6e 21 00 00       	call   8022cf <malloc>
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
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001d5:	e8 26 27 00 00       	call   802900 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 8c 3e 80 00       	push   $0x803e8c
  8001e2:	e8 b5 08 00 00       	call   800a9c <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 2b 27 00 00       	call   80291a <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 c0 3e 80 00       	push   $0x803ec0
  800211:	6a 51                	push   $0x51
  800213:	68 e2 3e 80 00       	push   $0x803ee2
  800218:	e8 91 05 00 00       	call   8007ae <_panic>
		else
		{
			sys_lock_cons();
  80021d:	e8 de 26 00 00       	call   802900 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 fc 3e 80 00       	push   $0x803efc
  80022a:	e8 6d 08 00 00       	call   800a9c <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 30 3f 80 00       	push   $0x803f30
  80023a:	e8 5d 08 00 00       	call   800a9c <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 64 3f 80 00       	push   $0x803f64
  80024a:	e8 4d 08 00 00       	call   800a9c <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 c3 26 00 00       	call   80291a <sys_unlock_cons>
		}

		sys_lock_cons();
  800257:	e8 a4 26 00 00       	call   802900 <sys_lock_cons>
		{
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 96 3f 80 00       	push   $0x803f96
  80026a:	e8 2d 08 00 00       	call   800a9c <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 6a 03 00 00       	call   8005e1 <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 3b 03 00 00       	call   8005c2 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 2e 03 00 00       	call   8005c2 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 21 03 00 00       	call   8005c2 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp
		}

		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b0:	e8 65 26 00 00       	call   80291a <sys_unlock_cons>

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8004fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800501:	75 07                	jne    80050a <InitializeSemiRandom+0x27>
			Repetition = 3;
  800503:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80050a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800511:	eb 1e                	jmp    800531 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800523:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800526:	99                   	cltd   
  800527:	f7 7d f8             	idivl  -0x8(%ebp)
  80052a:	89 d0                	mov    %edx,%eax
  80052c:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  80052e:	ff 45 fc             	incl   -0x4(%ebp)
  800531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800534:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800537:	7c da                	jl     800513 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800539:	90                   	nop
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800542:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800549:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800550:	eb 42                	jmp    800594 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800555:	99                   	cltd   
  800556:	f7 7d f0             	idivl  -0x10(%ebp)
  800559:	89 d0                	mov    %edx,%eax
  80055b:	85 c0                	test   %eax,%eax
  80055d:	75 10                	jne    80056f <PrintElements+0x33>
			cprintf("\n");
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 e0 3d 80 00       	push   $0x803de0
  800567:	e8 30 05 00 00       	call   800a9c <cprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80056f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800572:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	01 d0                	add    %edx,%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	50                   	push   %eax
  800584:	68 b4 3f 80 00       	push   $0x803fb4
  800589:	e8 0e 05 00 00       	call   800a9c <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800591:	ff 45 f4             	incl   -0xc(%ebp)
  800594:	8b 45 0c             	mov    0xc(%ebp),%eax
  800597:	48                   	dec    %eax
  800598:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80059b:	7f b5                	jg     800552 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	01 d0                	add    %edx,%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	50                   	push   %eax
  8005b2:	68 b9 3f 80 00       	push   $0x803fb9
  8005b7:	e8 e0 04 00 00       	call   800a9c <cprintf>
  8005bc:	83 c4 10             	add    $0x10,%esp

}
  8005bf:	90                   	nop
  8005c0:	c9                   	leave  
  8005c1:	c3                   	ret    

008005c2 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005c2:	55                   	push   %ebp
  8005c3:	89 e5                	mov    %esp,%ebp
  8005c5:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005ce:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d2:	83 ec 0c             	sub    $0xc,%esp
  8005d5:	50                   	push   %eax
  8005d6:	e8 6d 24 00 00       	call   802a48 <sys_cputc>
  8005db:	83 c4 10             	add    $0x10,%esp
}
  8005de:	90                   	nop
  8005df:	c9                   	leave  
  8005e0:	c3                   	ret    

008005e1 <getchar>:


int
getchar(void)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005e7:	e8 fb 22 00 00       	call   8028e7 <sys_cgetc>
  8005ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005f2:	c9                   	leave  
  8005f3:	c3                   	ret    

008005f4 <iscons>:

int iscons(int fdnum)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005fc:	5d                   	pop    %ebp
  8005fd:	c3                   	ret    

008005fe <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	57                   	push   %edi
  800602:	56                   	push   %esi
  800603:	53                   	push   %ebx
  800604:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800607:	e8 6d 25 00 00       	call   802b79 <sys_getenvindex>
  80060c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80060f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800612:	89 d0                	mov    %edx,%eax
  800614:	01 c0                	add    %eax,%eax
  800616:	01 d0                	add    %edx,%eax
  800618:	c1 e0 02             	shl    $0x2,%eax
  80061b:	01 d0                	add    %edx,%eax
  80061d:	c1 e0 02             	shl    $0x2,%eax
  800620:	01 d0                	add    %edx,%eax
  800622:	c1 e0 03             	shl    $0x3,%eax
  800625:	01 d0                	add    %edx,%eax
  800627:	c1 e0 02             	shl    $0x2,%eax
  80062a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80062f:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800634:	a1 24 50 80 00       	mov    0x805024,%eax
  800639:	8a 40 20             	mov    0x20(%eax),%al
  80063c:	84 c0                	test   %al,%al
  80063e:	74 0d                	je     80064d <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800640:	a1 24 50 80 00       	mov    0x805024,%eax
  800645:	83 c0 20             	add    $0x20,%eax
  800648:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80064d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800651:	7e 0a                	jle    80065d <libmain+0x5f>
		binaryname = argv[0];
  800653:	8b 45 0c             	mov    0xc(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	ff 75 08             	pushl  0x8(%ebp)
  800666:	e8 cd f9 ff ff       	call   800038 <_main>
  80066b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80066e:	a1 00 50 80 00       	mov    0x805000,%eax
  800673:	85 c0                	test   %eax,%eax
  800675:	0f 84 01 01 00 00    	je     80077c <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80067b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800681:	bb b8 40 80 00       	mov    $0x8040b8,%ebx
  800686:	ba 0e 00 00 00       	mov    $0xe,%edx
  80068b:	89 c7                	mov    %eax,%edi
  80068d:	89 de                	mov    %ebx,%esi
  80068f:	89 d1                	mov    %edx,%ecx
  800691:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800693:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800696:	b9 56 00 00 00       	mov    $0x56,%ecx
  80069b:	b0 00                	mov    $0x0,%al
  80069d:	89 d7                	mov    %edx,%edi
  80069f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8006a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8006a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	50                   	push   %eax
  8006af:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006b5:	50                   	push   %eax
  8006b6:	e8 f4 26 00 00       	call   802daf <sys_utilities>
  8006bb:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8006be:	e8 3d 22 00 00       	call   802900 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8006c3:	83 ec 0c             	sub    $0xc,%esp
  8006c6:	68 d8 3f 80 00       	push   $0x803fd8
  8006cb:	e8 cc 03 00 00       	call   800a9c <cprintf>
  8006d0:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d6:	85 c0                	test   %eax,%eax
  8006d8:	74 18                	je     8006f2 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006da:	e8 ee 26 00 00       	call   802dcd <sys_get_optimal_num_faults>
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	50                   	push   %eax
  8006e3:	68 00 40 80 00       	push   $0x804000
  8006e8:	e8 af 03 00 00       	call   800a9c <cprintf>
  8006ed:	83 c4 10             	add    $0x10,%esp
  8006f0:	eb 59                	jmp    80074b <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006f2:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f7:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8006fd:	a1 24 50 80 00       	mov    0x805024,%eax
  800702:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800708:	83 ec 04             	sub    $0x4,%esp
  80070b:	52                   	push   %edx
  80070c:	50                   	push   %eax
  80070d:	68 24 40 80 00       	push   $0x804024
  800712:	e8 85 03 00 00       	call   800a9c <cprintf>
  800717:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80071a:	a1 24 50 80 00       	mov    0x805024,%eax
  80071f:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800725:	a1 24 50 80 00       	mov    0x805024,%eax
  80072a:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800730:	a1 24 50 80 00       	mov    0x805024,%eax
  800735:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80073b:	51                   	push   %ecx
  80073c:	52                   	push   %edx
  80073d:	50                   	push   %eax
  80073e:	68 4c 40 80 00       	push   $0x80404c
  800743:	e8 54 03 00 00       	call   800a9c <cprintf>
  800748:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80074b:	a1 24 50 80 00       	mov    0x805024,%eax
  800750:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	50                   	push   %eax
  80075a:	68 a4 40 80 00       	push   $0x8040a4
  80075f:	e8 38 03 00 00       	call   800a9c <cprintf>
  800764:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800767:	83 ec 0c             	sub    $0xc,%esp
  80076a:	68 d8 3f 80 00       	push   $0x803fd8
  80076f:	e8 28 03 00 00       	call   800a9c <cprintf>
  800774:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800777:	e8 9e 21 00 00       	call   80291a <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80077c:	e8 1f 00 00 00       	call   8007a0 <exit>
}
  800781:	90                   	nop
  800782:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800785:	5b                   	pop    %ebx
  800786:	5e                   	pop    %esi
  800787:	5f                   	pop    %edi
  800788:	5d                   	pop    %ebp
  800789:	c3                   	ret    

0080078a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800790:	83 ec 0c             	sub    $0xc,%esp
  800793:	6a 00                	push   $0x0
  800795:	e8 ab 23 00 00       	call   802b45 <sys_destroy_env>
  80079a:	83 c4 10             	add    $0x10,%esp
}
  80079d:	90                   	nop
  80079e:	c9                   	leave  
  80079f:	c3                   	ret    

008007a0 <exit>:

void
exit(void)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007a6:	e8 00 24 00 00       	call   802bab <sys_exit_env>
}
  8007ab:	90                   	nop
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007b4:	8d 45 10             	lea    0x10(%ebp),%eax
  8007b7:	83 c0 04             	add    $0x4,%eax
  8007ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007bd:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	74 16                	je     8007dc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007c6:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	50                   	push   %eax
  8007cf:	68 1c 41 80 00       	push   $0x80411c
  8007d4:	e8 c3 02 00 00       	call   800a9c <cprintf>
  8007d9:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007dc:	a1 04 50 80 00       	mov    0x805004,%eax
  8007e1:	83 ec 0c             	sub    $0xc,%esp
  8007e4:	ff 75 0c             	pushl  0xc(%ebp)
  8007e7:	ff 75 08             	pushl  0x8(%ebp)
  8007ea:	50                   	push   %eax
  8007eb:	68 24 41 80 00       	push   $0x804124
  8007f0:	6a 74                	push   $0x74
  8007f2:	e8 d2 02 00 00       	call   800ac9 <cprintf_colored>
  8007f7:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8007fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 f4             	pushl  -0xc(%ebp)
  800803:	50                   	push   %eax
  800804:	e8 24 02 00 00       	call   800a2d <vcprintf>
  800809:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	6a 00                	push   $0x0
  800811:	68 4c 41 80 00       	push   $0x80414c
  800816:	e8 12 02 00 00       	call   800a2d <vcprintf>
  80081b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80081e:	e8 7d ff ff ff       	call   8007a0 <exit>

	// should not return here
	while (1) ;
  800823:	eb fe                	jmp    800823 <_panic+0x75>

00800825 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800825:	55                   	push   %ebp
  800826:	89 e5                	mov    %esp,%ebp
  800828:	53                   	push   %ebx
  800829:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80082c:	a1 24 50 80 00       	mov    0x805024,%eax
  800831:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800837:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083a:	39 c2                	cmp    %eax,%edx
  80083c:	74 14                	je     800852 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80083e:	83 ec 04             	sub    $0x4,%esp
  800841:	68 50 41 80 00       	push   $0x804150
  800846:	6a 26                	push   $0x26
  800848:	68 9c 41 80 00       	push   $0x80419c
  80084d:	e8 5c ff ff ff       	call   8007ae <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800852:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800859:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800860:	e9 d9 00 00 00       	jmp    80093e <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800868:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	01 d0                	add    %edx,%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	85 c0                	test   %eax,%eax
  800878:	75 08                	jne    800882 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80087a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80087d:	e9 b9 00 00 00       	jmp    80093b <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800882:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800889:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800890:	eb 79                	jmp    80090b <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800892:	a1 24 50 80 00       	mov    0x805024,%eax
  800897:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80089d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a0:	89 d0                	mov    %edx,%eax
  8008a2:	01 c0                	add    %eax,%eax
  8008a4:	01 d0                	add    %edx,%eax
  8008a6:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8008ad:	01 d8                	add    %ebx,%eax
  8008af:	01 d0                	add    %edx,%eax
  8008b1:	01 c8                	add    %ecx,%eax
  8008b3:	8a 40 04             	mov    0x4(%eax),%al
  8008b6:	84 c0                	test   %al,%al
  8008b8:	75 4e                	jne    800908 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008ba:	a1 24 50 80 00       	mov    0x805024,%eax
  8008bf:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8008c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c8:	89 d0                	mov    %edx,%eax
  8008ca:	01 c0                	add    %eax,%eax
  8008cc:	01 d0                	add    %edx,%eax
  8008ce:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8008d5:	01 d8                	add    %ebx,%eax
  8008d7:	01 d0                	add    %edx,%eax
  8008d9:	01 c8                	add    %ecx,%eax
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008e8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	01 c8                	add    %ecx,%eax
  8008f9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008fb:	39 c2                	cmp    %eax,%edx
  8008fd:	75 09                	jne    800908 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8008ff:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800906:	eb 19                	jmp    800921 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800908:	ff 45 e8             	incl   -0x18(%ebp)
  80090b:	a1 24 50 80 00       	mov    0x805024,%eax
  800910:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800916:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800919:	39 c2                	cmp    %eax,%edx
  80091b:	0f 87 71 ff ff ff    	ja     800892 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800921:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800925:	75 14                	jne    80093b <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800927:	83 ec 04             	sub    $0x4,%esp
  80092a:	68 a8 41 80 00       	push   $0x8041a8
  80092f:	6a 3a                	push   $0x3a
  800931:	68 9c 41 80 00       	push   $0x80419c
  800936:	e8 73 fe ff ff       	call   8007ae <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80093b:	ff 45 f0             	incl   -0x10(%ebp)
  80093e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800941:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800944:	0f 8c 1b ff ff ff    	jl     800865 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80094a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800951:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800958:	eb 2e                	jmp    800988 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80095a:	a1 24 50 80 00       	mov    0x805024,%eax
  80095f:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800965:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800968:	89 d0                	mov    %edx,%eax
  80096a:	01 c0                	add    %eax,%eax
  80096c:	01 d0                	add    %edx,%eax
  80096e:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800975:	01 d8                	add    %ebx,%eax
  800977:	01 d0                	add    %edx,%eax
  800979:	01 c8                	add    %ecx,%eax
  80097b:	8a 40 04             	mov    0x4(%eax),%al
  80097e:	3c 01                	cmp    $0x1,%al
  800980:	75 03                	jne    800985 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800982:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800985:	ff 45 e0             	incl   -0x20(%ebp)
  800988:	a1 24 50 80 00       	mov    0x805024,%eax
  80098d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800993:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800996:	39 c2                	cmp    %eax,%edx
  800998:	77 c0                	ja     80095a <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80099a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80099d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009a0:	74 14                	je     8009b6 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 fc 41 80 00       	push   $0x8041fc
  8009aa:	6a 44                	push   $0x44
  8009ac:	68 9c 41 80 00       	push   $0x80419c
  8009b1:	e8 f8 fd ff ff       	call   8007ae <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009b6:	90                   	nop
  8009b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    

008009bc <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	53                   	push   %ebx
  8009c0:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8009c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c6:	8b 00                	mov    (%eax),%eax
  8009c8:	8d 48 01             	lea    0x1(%eax),%ecx
  8009cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ce:	89 0a                	mov    %ecx,(%edx)
  8009d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8009d3:	88 d1                	mov    %dl,%cl
  8009d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009df:	8b 00                	mov    (%eax),%eax
  8009e1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009e6:	75 30                	jne    800a18 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009e8:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8009ee:	a0 44 50 80 00       	mov    0x805044,%al
  8009f3:	0f b6 c0             	movzbl %al,%eax
  8009f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f9:	8b 09                	mov    (%ecx),%ecx
  8009fb:	89 cb                	mov    %ecx,%ebx
  8009fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a00:	83 c1 08             	add    $0x8,%ecx
  800a03:	52                   	push   %edx
  800a04:	50                   	push   %eax
  800a05:	53                   	push   %ebx
  800a06:	51                   	push   %ecx
  800a07:	e8 b0 1e 00 00       	call   8028bc <sys_cputs>
  800a0c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1b:	8b 40 04             	mov    0x4(%eax),%eax
  800a1e:	8d 50 01             	lea    0x1(%eax),%edx
  800a21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a24:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a27:	90                   	nop
  800a28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a2b:	c9                   	leave  
  800a2c:	c3                   	ret    

00800a2d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a36:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a3d:	00 00 00 
	b.cnt = 0;
  800a40:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a47:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	ff 75 08             	pushl  0x8(%ebp)
  800a50:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a56:	50                   	push   %eax
  800a57:	68 bc 09 80 00       	push   $0x8009bc
  800a5c:	e8 5a 02 00 00       	call   800cbb <vprintfmt>
  800a61:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a64:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800a6a:	a0 44 50 80 00       	mov    0x805044,%al
  800a6f:	0f b6 c0             	movzbl %al,%eax
  800a72:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a78:	52                   	push   %edx
  800a79:	50                   	push   %eax
  800a7a:	51                   	push   %ecx
  800a7b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a81:	83 c0 08             	add    $0x8,%eax
  800a84:	50                   	push   %eax
  800a85:	e8 32 1e 00 00       	call   8028bc <sys_cputs>
  800a8a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a8d:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800a94:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a9a:	c9                   	leave  
  800a9b:	c3                   	ret    

00800a9c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800aa2:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800aa9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab8:	50                   	push   %eax
  800ab9:	e8 6f ff ff ff       	call   800a2d <vcprintf>
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ac7:	c9                   	leave  
  800ac8:	c3                   	ret    

00800ac9 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800acf:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	c1 e0 08             	shl    $0x8,%eax
  800adc:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800ae1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ae4:	83 c0 04             	add    $0x4,%eax
  800ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aed:	83 ec 08             	sub    $0x8,%esp
  800af0:	ff 75 f4             	pushl  -0xc(%ebp)
  800af3:	50                   	push   %eax
  800af4:	e8 34 ff ff ff       	call   800a2d <vcprintf>
  800af9:	83 c4 10             	add    $0x10,%esp
  800afc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800aff:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800b06:	07 00 00 

	return cnt;
  800b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b0c:	c9                   	leave  
  800b0d:	c3                   	ret    

00800b0e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b14:	e8 e7 1d 00 00       	call   802900 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b19:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	83 ec 08             	sub    $0x8,%esp
  800b25:	ff 75 f4             	pushl  -0xc(%ebp)
  800b28:	50                   	push   %eax
  800b29:	e8 ff fe ff ff       	call   800a2d <vcprintf>
  800b2e:	83 c4 10             	add    $0x10,%esp
  800b31:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b34:	e8 e1 1d 00 00       	call   80291a <sys_unlock_cons>
	return cnt;
  800b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b3c:	c9                   	leave  
  800b3d:	c3                   	ret    

00800b3e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	53                   	push   %ebx
  800b42:	83 ec 14             	sub    $0x14,%esp
  800b45:	8b 45 10             	mov    0x10(%ebp),%eax
  800b48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b51:	8b 45 18             	mov    0x18(%ebp),%eax
  800b54:	ba 00 00 00 00       	mov    $0x0,%edx
  800b59:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b5c:	77 55                	ja     800bb3 <printnum+0x75>
  800b5e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b61:	72 05                	jb     800b68 <printnum+0x2a>
  800b63:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b66:	77 4b                	ja     800bb3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b68:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b6b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b6e:	8b 45 18             	mov    0x18(%ebp),%eax
  800b71:	ba 00 00 00 00       	mov    $0x0,%edx
  800b76:	52                   	push   %edx
  800b77:	50                   	push   %eax
  800b78:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7b:	ff 75 f0             	pushl  -0x10(%ebp)
  800b7e:	e8 dd 2f 00 00       	call   803b60 <__udivdi3>
  800b83:	83 c4 10             	add    $0x10,%esp
  800b86:	83 ec 04             	sub    $0x4,%esp
  800b89:	ff 75 20             	pushl  0x20(%ebp)
  800b8c:	53                   	push   %ebx
  800b8d:	ff 75 18             	pushl  0x18(%ebp)
  800b90:	52                   	push   %edx
  800b91:	50                   	push   %eax
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	ff 75 08             	pushl  0x8(%ebp)
  800b98:	e8 a1 ff ff ff       	call   800b3e <printnum>
  800b9d:	83 c4 20             	add    $0x20,%esp
  800ba0:	eb 1a                	jmp    800bbc <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ba2:	83 ec 08             	sub    $0x8,%esp
  800ba5:	ff 75 0c             	pushl  0xc(%ebp)
  800ba8:	ff 75 20             	pushl  0x20(%ebp)
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	ff d0                	call   *%eax
  800bb0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bb3:	ff 4d 1c             	decl   0x1c(%ebp)
  800bb6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bba:	7f e6                	jg     800ba2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bbc:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bca:	53                   	push   %ebx
  800bcb:	51                   	push   %ecx
  800bcc:	52                   	push   %edx
  800bcd:	50                   	push   %eax
  800bce:	e8 9d 30 00 00       	call   803c70 <__umoddi3>
  800bd3:	83 c4 10             	add    $0x10,%esp
  800bd6:	05 74 44 80 00       	add    $0x804474,%eax
  800bdb:	8a 00                	mov    (%eax),%al
  800bdd:	0f be c0             	movsbl %al,%eax
  800be0:	83 ec 08             	sub    $0x8,%esp
  800be3:	ff 75 0c             	pushl  0xc(%ebp)
  800be6:	50                   	push   %eax
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	ff d0                	call   *%eax
  800bec:	83 c4 10             	add    $0x10,%esp
}
  800bef:	90                   	nop
  800bf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bf3:	c9                   	leave  
  800bf4:	c3                   	ret    

00800bf5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bf8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bfc:	7e 1c                	jle    800c1a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	8b 00                	mov    (%eax),%eax
  800c03:	8d 50 08             	lea    0x8(%eax),%edx
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	89 10                	mov    %edx,(%eax)
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	8b 00                	mov    (%eax),%eax
  800c10:	83 e8 08             	sub    $0x8,%eax
  800c13:	8b 50 04             	mov    0x4(%eax),%edx
  800c16:	8b 00                	mov    (%eax),%eax
  800c18:	eb 40                	jmp    800c5a <getuint+0x65>
	else if (lflag)
  800c1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1e:	74 1e                	je     800c3e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	8b 00                	mov    (%eax),%eax
  800c25:	8d 50 04             	lea    0x4(%eax),%edx
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 10                	mov    %edx,(%eax)
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8b 00                	mov    (%eax),%eax
  800c32:	83 e8 04             	sub    $0x4,%eax
  800c35:	8b 00                	mov    (%eax),%eax
  800c37:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3c:	eb 1c                	jmp    800c5a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	8b 00                	mov    (%eax),%eax
  800c43:	8d 50 04             	lea    0x4(%eax),%edx
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	89 10                	mov    %edx,(%eax)
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	8b 00                	mov    (%eax),%eax
  800c50:	83 e8 04             	sub    $0x4,%eax
  800c53:	8b 00                	mov    (%eax),%eax
  800c55:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    

00800c5c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c5f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c63:	7e 1c                	jle    800c81 <getint+0x25>
		return va_arg(*ap, long long);
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	8b 00                	mov    (%eax),%eax
  800c6a:	8d 50 08             	lea    0x8(%eax),%edx
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	89 10                	mov    %edx,(%eax)
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8b 00                	mov    (%eax),%eax
  800c77:	83 e8 08             	sub    $0x8,%eax
  800c7a:	8b 50 04             	mov    0x4(%eax),%edx
  800c7d:	8b 00                	mov    (%eax),%eax
  800c7f:	eb 38                	jmp    800cb9 <getint+0x5d>
	else if (lflag)
  800c81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c85:	74 1a                	je     800ca1 <getint+0x45>
		return va_arg(*ap, long);
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8b 00                	mov    (%eax),%eax
  800c8c:	8d 50 04             	lea    0x4(%eax),%edx
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	89 10                	mov    %edx,(%eax)
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	8b 00                	mov    (%eax),%eax
  800c99:	83 e8 04             	sub    $0x4,%eax
  800c9c:	8b 00                	mov    (%eax),%eax
  800c9e:	99                   	cltd   
  800c9f:	eb 18                	jmp    800cb9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	8b 00                	mov    (%eax),%eax
  800ca6:	8d 50 04             	lea    0x4(%eax),%edx
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	89 10                	mov    %edx,(%eax)
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8b 00                	mov    (%eax),%eax
  800cb3:	83 e8 04             	sub    $0x4,%eax
  800cb6:	8b 00                	mov    (%eax),%eax
  800cb8:	99                   	cltd   
}
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	56                   	push   %esi
  800cbf:	53                   	push   %ebx
  800cc0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cc3:	eb 17                	jmp    800cdc <vprintfmt+0x21>
			if (ch == '\0')
  800cc5:	85 db                	test   %ebx,%ebx
  800cc7:	0f 84 c1 03 00 00    	je     80108e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800ccd:	83 ec 08             	sub    $0x8,%esp
  800cd0:	ff 75 0c             	pushl  0xc(%ebp)
  800cd3:	53                   	push   %ebx
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	ff d0                	call   *%eax
  800cd9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdf:	8d 50 01             	lea    0x1(%eax),%edx
  800ce2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	0f b6 d8             	movzbl %al,%ebx
  800cea:	83 fb 25             	cmp    $0x25,%ebx
  800ced:	75 d6                	jne    800cc5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cef:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cf3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cfa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d01:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d08:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d12:	8d 50 01             	lea    0x1(%eax),%edx
  800d15:	89 55 10             	mov    %edx,0x10(%ebp)
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	0f b6 d8             	movzbl %al,%ebx
  800d1d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d20:	83 f8 5b             	cmp    $0x5b,%eax
  800d23:	0f 87 3d 03 00 00    	ja     801066 <vprintfmt+0x3ab>
  800d29:	8b 04 85 98 44 80 00 	mov    0x804498(,%eax,4),%eax
  800d30:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d32:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d36:	eb d7                	jmp    800d0f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d38:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d3c:	eb d1                	jmp    800d0f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d3e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d45:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d48:	89 d0                	mov    %edx,%eax
  800d4a:	c1 e0 02             	shl    $0x2,%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	01 c0                	add    %eax,%eax
  800d51:	01 d8                	add    %ebx,%eax
  800d53:	83 e8 30             	sub    $0x30,%eax
  800d56:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d59:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d61:	83 fb 2f             	cmp    $0x2f,%ebx
  800d64:	7e 3e                	jle    800da4 <vprintfmt+0xe9>
  800d66:	83 fb 39             	cmp    $0x39,%ebx
  800d69:	7f 39                	jg     800da4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d6b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d6e:	eb d5                	jmp    800d45 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d70:	8b 45 14             	mov    0x14(%ebp),%eax
  800d73:	83 c0 04             	add    $0x4,%eax
  800d76:	89 45 14             	mov    %eax,0x14(%ebp)
  800d79:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7c:	83 e8 04             	sub    $0x4,%eax
  800d7f:	8b 00                	mov    (%eax),%eax
  800d81:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d84:	eb 1f                	jmp    800da5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8a:	79 83                	jns    800d0f <vprintfmt+0x54>
				width = 0;
  800d8c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d93:	e9 77 ff ff ff       	jmp    800d0f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d98:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d9f:	e9 6b ff ff ff       	jmp    800d0f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800da4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800da5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800da9:	0f 89 60 ff ff ff    	jns    800d0f <vprintfmt+0x54>
				width = precision, precision = -1;
  800daf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800db2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800db5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800dbc:	e9 4e ff ff ff       	jmp    800d0f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dc1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800dc4:	e9 46 ff ff ff       	jmp    800d0f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800dc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcc:	83 c0 04             	add    $0x4,%eax
  800dcf:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd5:	83 e8 04             	sub    $0x4,%eax
  800dd8:	8b 00                	mov    (%eax),%eax
  800dda:	83 ec 08             	sub    $0x8,%esp
  800ddd:	ff 75 0c             	pushl  0xc(%ebp)
  800de0:	50                   	push   %eax
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	ff d0                	call   *%eax
  800de6:	83 c4 10             	add    $0x10,%esp
			break;
  800de9:	e9 9b 02 00 00       	jmp    801089 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800dee:	8b 45 14             	mov    0x14(%ebp),%eax
  800df1:	83 c0 04             	add    $0x4,%eax
  800df4:	89 45 14             	mov    %eax,0x14(%ebp)
  800df7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfa:	83 e8 04             	sub    $0x4,%eax
  800dfd:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800dff:	85 db                	test   %ebx,%ebx
  800e01:	79 02                	jns    800e05 <vprintfmt+0x14a>
				err = -err;
  800e03:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e05:	83 fb 64             	cmp    $0x64,%ebx
  800e08:	7f 0b                	jg     800e15 <vprintfmt+0x15a>
  800e0a:	8b 34 9d e0 42 80 00 	mov    0x8042e0(,%ebx,4),%esi
  800e11:	85 f6                	test   %esi,%esi
  800e13:	75 19                	jne    800e2e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e15:	53                   	push   %ebx
  800e16:	68 85 44 80 00       	push   $0x804485
  800e1b:	ff 75 0c             	pushl  0xc(%ebp)
  800e1e:	ff 75 08             	pushl  0x8(%ebp)
  800e21:	e8 70 02 00 00       	call   801096 <printfmt>
  800e26:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e29:	e9 5b 02 00 00       	jmp    801089 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e2e:	56                   	push   %esi
  800e2f:	68 8e 44 80 00       	push   $0x80448e
  800e34:	ff 75 0c             	pushl  0xc(%ebp)
  800e37:	ff 75 08             	pushl  0x8(%ebp)
  800e3a:	e8 57 02 00 00       	call   801096 <printfmt>
  800e3f:	83 c4 10             	add    $0x10,%esp
			break;
  800e42:	e9 42 02 00 00       	jmp    801089 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e47:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4a:	83 c0 04             	add    $0x4,%eax
  800e4d:	89 45 14             	mov    %eax,0x14(%ebp)
  800e50:	8b 45 14             	mov    0x14(%ebp),%eax
  800e53:	83 e8 04             	sub    $0x4,%eax
  800e56:	8b 30                	mov    (%eax),%esi
  800e58:	85 f6                	test   %esi,%esi
  800e5a:	75 05                	jne    800e61 <vprintfmt+0x1a6>
				p = "(null)";
  800e5c:	be 91 44 80 00       	mov    $0x804491,%esi
			if (width > 0 && padc != '-')
  800e61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e65:	7e 6d                	jle    800ed4 <vprintfmt+0x219>
  800e67:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e6b:	74 67                	je     800ed4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	50                   	push   %eax
  800e74:	56                   	push   %esi
  800e75:	e8 26 05 00 00       	call   8013a0 <strnlen>
  800e7a:	83 c4 10             	add    $0x10,%esp
  800e7d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e80:	eb 16                	jmp    800e98 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e82:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	ff 75 0c             	pushl  0xc(%ebp)
  800e8c:	50                   	push   %eax
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	ff d0                	call   *%eax
  800e92:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e95:	ff 4d e4             	decl   -0x1c(%ebp)
  800e98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e9c:	7f e4                	jg     800e82 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e9e:	eb 34                	jmp    800ed4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ea0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ea4:	74 1c                	je     800ec2 <vprintfmt+0x207>
  800ea6:	83 fb 1f             	cmp    $0x1f,%ebx
  800ea9:	7e 05                	jle    800eb0 <vprintfmt+0x1f5>
  800eab:	83 fb 7e             	cmp    $0x7e,%ebx
  800eae:	7e 12                	jle    800ec2 <vprintfmt+0x207>
					putch('?', putdat);
  800eb0:	83 ec 08             	sub    $0x8,%esp
  800eb3:	ff 75 0c             	pushl  0xc(%ebp)
  800eb6:	6a 3f                	push   $0x3f
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	ff d0                	call   *%eax
  800ebd:	83 c4 10             	add    $0x10,%esp
  800ec0:	eb 0f                	jmp    800ed1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	53                   	push   %ebx
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	ff d0                	call   *%eax
  800ece:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ed1:	ff 4d e4             	decl   -0x1c(%ebp)
  800ed4:	89 f0                	mov    %esi,%eax
  800ed6:	8d 70 01             	lea    0x1(%eax),%esi
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	0f be d8             	movsbl %al,%ebx
  800ede:	85 db                	test   %ebx,%ebx
  800ee0:	74 24                	je     800f06 <vprintfmt+0x24b>
  800ee2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ee6:	78 b8                	js     800ea0 <vprintfmt+0x1e5>
  800ee8:	ff 4d e0             	decl   -0x20(%ebp)
  800eeb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800eef:	79 af                	jns    800ea0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ef1:	eb 13                	jmp    800f06 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ef3:	83 ec 08             	sub    $0x8,%esp
  800ef6:	ff 75 0c             	pushl  0xc(%ebp)
  800ef9:	6a 20                	push   $0x20
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	ff d0                	call   *%eax
  800f00:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f03:	ff 4d e4             	decl   -0x1c(%ebp)
  800f06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0a:	7f e7                	jg     800ef3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f0c:	e9 78 01 00 00       	jmp    801089 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f11:	83 ec 08             	sub    $0x8,%esp
  800f14:	ff 75 e8             	pushl  -0x18(%ebp)
  800f17:	8d 45 14             	lea    0x14(%ebp),%eax
  800f1a:	50                   	push   %eax
  800f1b:	e8 3c fd ff ff       	call   800c5c <getint>
  800f20:	83 c4 10             	add    $0x10,%esp
  800f23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f26:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2f:	85 d2                	test   %edx,%edx
  800f31:	79 23                	jns    800f56 <vprintfmt+0x29b>
				putch('-', putdat);
  800f33:	83 ec 08             	sub    $0x8,%esp
  800f36:	ff 75 0c             	pushl  0xc(%ebp)
  800f39:	6a 2d                	push   $0x2d
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	ff d0                	call   *%eax
  800f40:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f49:	f7 d8                	neg    %eax
  800f4b:	83 d2 00             	adc    $0x0,%edx
  800f4e:	f7 da                	neg    %edx
  800f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f53:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f56:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f5d:	e9 bc 00 00 00       	jmp    80101e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f62:	83 ec 08             	sub    $0x8,%esp
  800f65:	ff 75 e8             	pushl  -0x18(%ebp)
  800f68:	8d 45 14             	lea    0x14(%ebp),%eax
  800f6b:	50                   	push   %eax
  800f6c:	e8 84 fc ff ff       	call   800bf5 <getuint>
  800f71:	83 c4 10             	add    $0x10,%esp
  800f74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f7a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f81:	e9 98 00 00 00       	jmp    80101e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f86:	83 ec 08             	sub    $0x8,%esp
  800f89:	ff 75 0c             	pushl  0xc(%ebp)
  800f8c:	6a 58                	push   $0x58
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	ff d0                	call   *%eax
  800f93:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	6a 58                	push   $0x58
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	ff d0                	call   *%eax
  800fa3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fa6:	83 ec 08             	sub    $0x8,%esp
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	6a 58                	push   $0x58
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	ff d0                	call   *%eax
  800fb3:	83 c4 10             	add    $0x10,%esp
			break;
  800fb6:	e9 ce 00 00 00       	jmp    801089 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fbb:	83 ec 08             	sub    $0x8,%esp
  800fbe:	ff 75 0c             	pushl  0xc(%ebp)
  800fc1:	6a 30                	push   $0x30
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	ff d0                	call   *%eax
  800fc8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fcb:	83 ec 08             	sub    $0x8,%esp
  800fce:	ff 75 0c             	pushl  0xc(%ebp)
  800fd1:	6a 78                	push   $0x78
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	ff d0                	call   *%eax
  800fd8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fdb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fde:	83 c0 04             	add    $0x4,%eax
  800fe1:	89 45 14             	mov    %eax,0x14(%ebp)
  800fe4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe7:	83 e8 04             	sub    $0x4,%eax
  800fea:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ff6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ffd:	eb 1f                	jmp    80101e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fff:	83 ec 08             	sub    $0x8,%esp
  801002:	ff 75 e8             	pushl  -0x18(%ebp)
  801005:	8d 45 14             	lea    0x14(%ebp),%eax
  801008:	50                   	push   %eax
  801009:	e8 e7 fb ff ff       	call   800bf5 <getuint>
  80100e:	83 c4 10             	add    $0x10,%esp
  801011:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801014:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801017:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80101e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801022:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801025:	83 ec 04             	sub    $0x4,%esp
  801028:	52                   	push   %edx
  801029:	ff 75 e4             	pushl  -0x1c(%ebp)
  80102c:	50                   	push   %eax
  80102d:	ff 75 f4             	pushl  -0xc(%ebp)
  801030:	ff 75 f0             	pushl  -0x10(%ebp)
  801033:	ff 75 0c             	pushl  0xc(%ebp)
  801036:	ff 75 08             	pushl  0x8(%ebp)
  801039:	e8 00 fb ff ff       	call   800b3e <printnum>
  80103e:	83 c4 20             	add    $0x20,%esp
			break;
  801041:	eb 46                	jmp    801089 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801043:	83 ec 08             	sub    $0x8,%esp
  801046:	ff 75 0c             	pushl  0xc(%ebp)
  801049:	53                   	push   %ebx
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	ff d0                	call   *%eax
  80104f:	83 c4 10             	add    $0x10,%esp
			break;
  801052:	eb 35                	jmp    801089 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801054:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  80105b:	eb 2c                	jmp    801089 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80105d:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  801064:	eb 23                	jmp    801089 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801066:	83 ec 08             	sub    $0x8,%esp
  801069:	ff 75 0c             	pushl  0xc(%ebp)
  80106c:	6a 25                	push   $0x25
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	ff d0                	call   *%eax
  801073:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801076:	ff 4d 10             	decl   0x10(%ebp)
  801079:	eb 03                	jmp    80107e <vprintfmt+0x3c3>
  80107b:	ff 4d 10             	decl   0x10(%ebp)
  80107e:	8b 45 10             	mov    0x10(%ebp),%eax
  801081:	48                   	dec    %eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	3c 25                	cmp    $0x25,%al
  801086:	75 f3                	jne    80107b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801088:	90                   	nop
		}
	}
  801089:	e9 35 fc ff ff       	jmp    800cc3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80108e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80108f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801092:	5b                   	pop    %ebx
  801093:	5e                   	pop    %esi
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    

00801096 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80109c:	8d 45 10             	lea    0x10(%ebp),%eax
  80109f:	83 c0 04             	add    $0x4,%eax
  8010a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ab:	50                   	push   %eax
  8010ac:	ff 75 0c             	pushl  0xc(%ebp)
  8010af:	ff 75 08             	pushl  0x8(%ebp)
  8010b2:	e8 04 fc ff ff       	call   800cbb <vprintfmt>
  8010b7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010ba:	90                   	nop
  8010bb:	c9                   	leave  
  8010bc:	c3                   	ret    

008010bd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010bd:	55                   	push   %ebp
  8010be:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c3:	8b 40 08             	mov    0x8(%eax),%eax
  8010c6:	8d 50 01             	lea    0x1(%eax),%edx
  8010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cc:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d2:	8b 10                	mov    (%eax),%edx
  8010d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d7:	8b 40 04             	mov    0x4(%eax),%eax
  8010da:	39 c2                	cmp    %eax,%edx
  8010dc:	73 12                	jae    8010f0 <sprintputch+0x33>
		*b->buf++ = ch;
  8010de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e1:	8b 00                	mov    (%eax),%eax
  8010e3:	8d 48 01             	lea    0x1(%eax),%ecx
  8010e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e9:	89 0a                	mov    %ecx,(%edx)
  8010eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ee:	88 10                	mov    %dl,(%eax)
}
  8010f0:	90                   	nop
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    

008010f3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801102:	8d 50 ff             	lea    -0x1(%eax),%edx
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	01 d0                	add    %edx,%eax
  80110a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80110d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801114:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801118:	74 06                	je     801120 <vsnprintf+0x2d>
  80111a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80111e:	7f 07                	jg     801127 <vsnprintf+0x34>
		return -E_INVAL;
  801120:	b8 03 00 00 00       	mov    $0x3,%eax
  801125:	eb 20                	jmp    801147 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801127:	ff 75 14             	pushl  0x14(%ebp)
  80112a:	ff 75 10             	pushl  0x10(%ebp)
  80112d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801130:	50                   	push   %eax
  801131:	68 bd 10 80 00       	push   $0x8010bd
  801136:	e8 80 fb ff ff       	call   800cbb <vprintfmt>
  80113b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80113e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801141:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801144:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801147:	c9                   	leave  
  801148:	c3                   	ret    

00801149 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80114f:	8d 45 10             	lea    0x10(%ebp),%eax
  801152:	83 c0 04             	add    $0x4,%eax
  801155:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801158:	8b 45 10             	mov    0x10(%ebp),%eax
  80115b:	ff 75 f4             	pushl  -0xc(%ebp)
  80115e:	50                   	push   %eax
  80115f:	ff 75 0c             	pushl  0xc(%ebp)
  801162:	ff 75 08             	pushl  0x8(%ebp)
  801165:	e8 89 ff ff ff       	call   8010f3 <vsnprintf>
  80116a:	83 c4 10             	add    $0x10,%esp
  80116d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801170:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801173:	c9                   	leave  
  801174:	c3                   	ret    

00801175 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80117b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80117f:	74 13                	je     801194 <readline+0x1f>
		cprintf("%s", prompt);
  801181:	83 ec 08             	sub    $0x8,%esp
  801184:	ff 75 08             	pushl  0x8(%ebp)
  801187:	68 08 46 80 00       	push   $0x804608
  80118c:	e8 0b f9 ff ff       	call   800a9c <cprintf>
  801191:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801194:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80119b:	83 ec 0c             	sub    $0xc,%esp
  80119e:	6a 00                	push   $0x0
  8011a0:	e8 4f f4 ff ff       	call   8005f4 <iscons>
  8011a5:	83 c4 10             	add    $0x10,%esp
  8011a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011ab:	e8 31 f4 ff ff       	call   8005e1 <getchar>
  8011b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011b7:	79 22                	jns    8011db <readline+0x66>
			if (c != -E_EOF)
  8011b9:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011bd:	0f 84 ad 00 00 00    	je     801270 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8011c9:	68 0b 46 80 00       	push   $0x80460b
  8011ce:	e8 c9 f8 ff ff       	call   800a9c <cprintf>
  8011d3:	83 c4 10             	add    $0x10,%esp
			break;
  8011d6:	e9 95 00 00 00       	jmp    801270 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011db:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011df:	7e 34                	jle    801215 <readline+0xa0>
  8011e1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011e8:	7f 2b                	jg     801215 <readline+0xa0>
			if (echoing)
  8011ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011ee:	74 0e                	je     8011fe <readline+0x89>
				cputchar(c);
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	ff 75 ec             	pushl  -0x14(%ebp)
  8011f6:	e8 c7 f3 ff ff       	call   8005c2 <cputchar>
  8011fb:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801201:	8d 50 01             	lea    0x1(%eax),%edx
  801204:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801207:	89 c2                	mov    %eax,%edx
  801209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120c:	01 d0                	add    %edx,%eax
  80120e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801211:	88 10                	mov    %dl,(%eax)
  801213:	eb 56                	jmp    80126b <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801215:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801219:	75 1f                	jne    80123a <readline+0xc5>
  80121b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80121f:	7e 19                	jle    80123a <readline+0xc5>
			if (echoing)
  801221:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801225:	74 0e                	je     801235 <readline+0xc0>
				cputchar(c);
  801227:	83 ec 0c             	sub    $0xc,%esp
  80122a:	ff 75 ec             	pushl  -0x14(%ebp)
  80122d:	e8 90 f3 ff ff       	call   8005c2 <cputchar>
  801232:	83 c4 10             	add    $0x10,%esp

			i--;
  801235:	ff 4d f4             	decl   -0xc(%ebp)
  801238:	eb 31                	jmp    80126b <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80123a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80123e:	74 0a                	je     80124a <readline+0xd5>
  801240:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801244:	0f 85 61 ff ff ff    	jne    8011ab <readline+0x36>
			if (echoing)
  80124a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80124e:	74 0e                	je     80125e <readline+0xe9>
				cputchar(c);
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	ff 75 ec             	pushl  -0x14(%ebp)
  801256:	e8 67 f3 ff ff       	call   8005c2 <cputchar>
  80125b:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80125e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	01 d0                	add    %edx,%eax
  801266:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801269:	eb 06                	jmp    801271 <readline+0xfc>
		}
	}
  80126b:	e9 3b ff ff ff       	jmp    8011ab <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801270:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801271:	90                   	nop
  801272:	c9                   	leave  
  801273:	c3                   	ret    

00801274 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  80127a:	e8 81 16 00 00       	call   802900 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80127f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801283:	74 13                	je     801298 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	ff 75 08             	pushl  0x8(%ebp)
  80128b:	68 08 46 80 00       	push   $0x804608
  801290:	e8 07 f8 ff ff       	call   800a9c <cprintf>
  801295:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801298:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  80129f:	83 ec 0c             	sub    $0xc,%esp
  8012a2:	6a 00                	push   $0x0
  8012a4:	e8 4b f3 ff ff       	call   8005f4 <iscons>
  8012a9:	83 c4 10             	add    $0x10,%esp
  8012ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8012af:	e8 2d f3 ff ff       	call   8005e1 <getchar>
  8012b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8012b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012bb:	79 22                	jns    8012df <atomic_readline+0x6b>
				if (c != -E_EOF)
  8012bd:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012c1:	0f 84 ad 00 00 00    	je     801374 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8012cd:	68 0b 46 80 00       	push   $0x80460b
  8012d2:	e8 c5 f7 ff ff       	call   800a9c <cprintf>
  8012d7:	83 c4 10             	add    $0x10,%esp
				break;
  8012da:	e9 95 00 00 00       	jmp    801374 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8012df:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012e3:	7e 34                	jle    801319 <atomic_readline+0xa5>
  8012e5:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012ec:	7f 2b                	jg     801319 <atomic_readline+0xa5>
				if (echoing)
  8012ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012f2:	74 0e                	je     801302 <atomic_readline+0x8e>
					cputchar(c);
  8012f4:	83 ec 0c             	sub    $0xc,%esp
  8012f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8012fa:	e8 c3 f2 ff ff       	call   8005c2 <cputchar>
  8012ff:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801305:	8d 50 01             	lea    0x1(%eax),%edx
  801308:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80130b:	89 c2                	mov    %eax,%edx
  80130d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801315:	88 10                	mov    %dl,(%eax)
  801317:	eb 56                	jmp    80136f <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801319:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80131d:	75 1f                	jne    80133e <atomic_readline+0xca>
  80131f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801323:	7e 19                	jle    80133e <atomic_readline+0xca>
				if (echoing)
  801325:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801329:	74 0e                	je     801339 <atomic_readline+0xc5>
					cputchar(c);
  80132b:	83 ec 0c             	sub    $0xc,%esp
  80132e:	ff 75 ec             	pushl  -0x14(%ebp)
  801331:	e8 8c f2 ff ff       	call   8005c2 <cputchar>
  801336:	83 c4 10             	add    $0x10,%esp
				i--;
  801339:	ff 4d f4             	decl   -0xc(%ebp)
  80133c:	eb 31                	jmp    80136f <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80133e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801342:	74 0a                	je     80134e <atomic_readline+0xda>
  801344:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801348:	0f 85 61 ff ff ff    	jne    8012af <atomic_readline+0x3b>
				if (echoing)
  80134e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801352:	74 0e                	je     801362 <atomic_readline+0xee>
					cputchar(c);
  801354:	83 ec 0c             	sub    $0xc,%esp
  801357:	ff 75 ec             	pushl  -0x14(%ebp)
  80135a:	e8 63 f2 ff ff       	call   8005c2 <cputchar>
  80135f:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801362:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801365:	8b 45 0c             	mov    0xc(%ebp),%eax
  801368:	01 d0                	add    %edx,%eax
  80136a:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80136d:	eb 06                	jmp    801375 <atomic_readline+0x101>
			}
		}
  80136f:	e9 3b ff ff ff       	jmp    8012af <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801374:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801375:	e8 a0 15 00 00       	call   80291a <sys_unlock_cons>
}
  80137a:	90                   	nop
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801383:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138a:	eb 06                	jmp    801392 <strlen+0x15>
		n++;
  80138c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80138f:	ff 45 08             	incl   0x8(%ebp)
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	84 c0                	test   %al,%al
  801399:	75 f1                	jne    80138c <strlen+0xf>
		n++;
	return n;
  80139b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    

008013a0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ad:	eb 09                	jmp    8013b8 <strnlen+0x18>
		n++;
  8013af:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013b2:	ff 45 08             	incl   0x8(%ebp)
  8013b5:	ff 4d 0c             	decl   0xc(%ebp)
  8013b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013bc:	74 09                	je     8013c7 <strnlen+0x27>
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	84 c0                	test   %al,%al
  8013c5:	75 e8                	jne    8013af <strnlen+0xf>
		n++;
	return n;
  8013c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    

008013cc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013d8:	90                   	nop
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dc:	8d 50 01             	lea    0x1(%eax),%edx
  8013df:	89 55 08             	mov    %edx,0x8(%ebp)
  8013e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013e8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013eb:	8a 12                	mov    (%edx),%dl
  8013ed:	88 10                	mov    %dl,(%eax)
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	84 c0                	test   %al,%al
  8013f3:	75 e4                	jne    8013d9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    

008013fa <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801406:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80140d:	eb 1f                	jmp    80142e <strncpy+0x34>
		*dst++ = *src;
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	8d 50 01             	lea    0x1(%eax),%edx
  801415:	89 55 08             	mov    %edx,0x8(%ebp)
  801418:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141b:	8a 12                	mov    (%edx),%dl
  80141d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80141f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	84 c0                	test   %al,%al
  801426:	74 03                	je     80142b <strncpy+0x31>
			src++;
  801428:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80142b:	ff 45 fc             	incl   -0x4(%ebp)
  80142e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801431:	3b 45 10             	cmp    0x10(%ebp),%eax
  801434:	72 d9                	jb     80140f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801436:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
  80143e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801447:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144b:	74 30                	je     80147d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80144d:	eb 16                	jmp    801465 <strlcpy+0x2a>
			*dst++ = *src++;
  80144f:	8b 45 08             	mov    0x8(%ebp),%eax
  801452:	8d 50 01             	lea    0x1(%eax),%edx
  801455:	89 55 08             	mov    %edx,0x8(%ebp)
  801458:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80145e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801461:	8a 12                	mov    (%edx),%dl
  801463:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801465:	ff 4d 10             	decl   0x10(%ebp)
  801468:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80146c:	74 09                	je     801477 <strlcpy+0x3c>
  80146e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	84 c0                	test   %al,%al
  801475:	75 d8                	jne    80144f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80147d:	8b 55 08             	mov    0x8(%ebp),%edx
  801480:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801483:	29 c2                	sub    %eax,%edx
  801485:	89 d0                	mov    %edx,%eax
}
  801487:	c9                   	leave  
  801488:	c3                   	ret    

00801489 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80148c:	eb 06                	jmp    801494 <strcmp+0xb>
		p++, q++;
  80148e:	ff 45 08             	incl   0x8(%ebp)
  801491:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	84 c0                	test   %al,%al
  80149b:	74 0e                	je     8014ab <strcmp+0x22>
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 10                	mov    (%eax),%dl
  8014a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a5:	8a 00                	mov    (%eax),%al
  8014a7:	38 c2                	cmp    %al,%dl
  8014a9:	74 e3                	je     80148e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8a 00                	mov    (%eax),%al
  8014b0:	0f b6 d0             	movzbl %al,%edx
  8014b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	0f b6 c0             	movzbl %al,%eax
  8014bb:	29 c2                	sub    %eax,%edx
  8014bd:	89 d0                	mov    %edx,%eax
}
  8014bf:	5d                   	pop    %ebp
  8014c0:	c3                   	ret    

008014c1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014c4:	eb 09                	jmp    8014cf <strncmp+0xe>
		n--, p++, q++;
  8014c6:	ff 4d 10             	decl   0x10(%ebp)
  8014c9:	ff 45 08             	incl   0x8(%ebp)
  8014cc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d3:	74 17                	je     8014ec <strncmp+0x2b>
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	84 c0                	test   %al,%al
  8014dc:	74 0e                	je     8014ec <strncmp+0x2b>
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 10                	mov    (%eax),%dl
  8014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	38 c2                	cmp    %al,%dl
  8014ea:	74 da                	je     8014c6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014f0:	75 07                	jne    8014f9 <strncmp+0x38>
		return 0;
  8014f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f7:	eb 14                	jmp    80150d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	0f b6 d0             	movzbl %al,%edx
  801501:	8b 45 0c             	mov    0xc(%ebp),%eax
  801504:	8a 00                	mov    (%eax),%al
  801506:	0f b6 c0             	movzbl %al,%eax
  801509:	29 c2                	sub    %eax,%edx
  80150b:	89 d0                	mov    %edx,%eax
}
  80150d:	5d                   	pop    %ebp
  80150e:	c3                   	ret    

0080150f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	83 ec 04             	sub    $0x4,%esp
  801515:	8b 45 0c             	mov    0xc(%ebp),%eax
  801518:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80151b:	eb 12                	jmp    80152f <strchr+0x20>
		if (*s == c)
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801525:	75 05                	jne    80152c <strchr+0x1d>
			return (char *) s;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	eb 11                	jmp    80153d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80152c:	ff 45 08             	incl   0x8(%ebp)
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8a 00                	mov    (%eax),%al
  801534:	84 c0                	test   %al,%al
  801536:	75 e5                	jne    80151d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801538:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	83 ec 04             	sub    $0x4,%esp
  801545:	8b 45 0c             	mov    0xc(%ebp),%eax
  801548:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80154b:	eb 0d                	jmp    80155a <strfind+0x1b>
		if (*s == c)
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	8a 00                	mov    (%eax),%al
  801552:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801555:	74 0e                	je     801565 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801557:	ff 45 08             	incl   0x8(%ebp)
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	8a 00                	mov    (%eax),%al
  80155f:	84 c0                	test   %al,%al
  801561:	75 ea                	jne    80154d <strfind+0xe>
  801563:	eb 01                	jmp    801566 <strfind+0x27>
		if (*s == c)
			break;
  801565:	90                   	nop
	return (char *) s;
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801577:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80157b:	76 63                	jbe    8015e0 <memset+0x75>
		uint64 data_block = c;
  80157d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801580:	99                   	cltd   
  801581:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801584:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801591:	c1 e0 08             	shl    $0x8,%eax
  801594:	09 45 f0             	or     %eax,-0x10(%ebp)
  801597:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80159a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a0:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8015a4:	c1 e0 10             	shl    $0x10,%eax
  8015a7:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015aa:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b3:	89 c2                	mov    %eax,%edx
  8015b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ba:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015bd:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8015c0:	eb 18                	jmp    8015da <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8015c2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015c5:	8d 41 08             	lea    0x8(%ecx),%eax
  8015c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8015cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d1:	89 01                	mov    %eax,(%ecx)
  8015d3:	89 51 04             	mov    %edx,0x4(%ecx)
  8015d6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8015da:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015de:	77 e2                	ja     8015c2 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8015e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015e4:	74 23                	je     801609 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8015e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015ec:	eb 0e                	jmp    8015fc <memset+0x91>
			*p8++ = (uint8)c;
  8015ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f1:	8d 50 01             	lea    0x1(%eax),%edx
  8015f4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fa:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801602:	89 55 10             	mov    %edx,0x10(%ebp)
  801605:	85 c0                	test   %eax,%eax
  801607:	75 e5                	jne    8015ee <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801614:	8b 45 0c             	mov    0xc(%ebp),%eax
  801617:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801620:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801624:	76 24                	jbe    80164a <memcpy+0x3c>
		while(n >= 8){
  801626:	eb 1c                	jmp    801644 <memcpy+0x36>
			*d64 = *s64;
  801628:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162b:	8b 50 04             	mov    0x4(%eax),%edx
  80162e:	8b 00                	mov    (%eax),%eax
  801630:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801633:	89 01                	mov    %eax,(%ecx)
  801635:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801638:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80163c:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801640:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801644:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801648:	77 de                	ja     801628 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80164a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80164e:	74 31                	je     801681 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801650:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801653:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801656:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801659:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80165c:	eb 16                	jmp    801674 <memcpy+0x66>
			*d8++ = *s8++;
  80165e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801661:	8d 50 01             	lea    0x1(%eax),%edx
  801664:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80166d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801670:	8a 12                	mov    (%edx),%dl
  801672:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801674:	8b 45 10             	mov    0x10(%ebp),%eax
  801677:	8d 50 ff             	lea    -0x1(%eax),%edx
  80167a:	89 55 10             	mov    %edx,0x10(%ebp)
  80167d:	85 c0                	test   %eax,%eax
  80167f:	75 dd                	jne    80165e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80168c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801698:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80169b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80169e:	73 50                	jae    8016f0 <memmove+0x6a>
  8016a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a6:	01 d0                	add    %edx,%eax
  8016a8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016ab:	76 43                	jbe    8016f0 <memmove+0x6a>
		s += n;
  8016ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016b9:	eb 10                	jmp    8016cb <memmove+0x45>
			*--d = *--s;
  8016bb:	ff 4d f8             	decl   -0x8(%ebp)
  8016be:	ff 4d fc             	decl   -0x4(%ebp)
  8016c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c4:	8a 10                	mov    (%eax),%dl
  8016c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8016d4:	85 c0                	test   %eax,%eax
  8016d6:	75 e3                	jne    8016bb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016d8:	eb 23                	jmp    8016fd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dd:	8d 50 01             	lea    0x1(%eax),%edx
  8016e0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016e9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016ec:	8a 12                	mov    (%edx),%dl
  8016ee:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	75 dd                	jne    8016da <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80170e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801711:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801714:	eb 2a                	jmp    801740 <memcmp+0x3e>
		if (*s1 != *s2)
  801716:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801719:	8a 10                	mov    (%eax),%dl
  80171b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80171e:	8a 00                	mov    (%eax),%al
  801720:	38 c2                	cmp    %al,%dl
  801722:	74 16                	je     80173a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801724:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801727:	8a 00                	mov    (%eax),%al
  801729:	0f b6 d0             	movzbl %al,%edx
  80172c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	0f b6 c0             	movzbl %al,%eax
  801734:	29 c2                	sub    %eax,%edx
  801736:	89 d0                	mov    %edx,%eax
  801738:	eb 18                	jmp    801752 <memcmp+0x50>
		s1++, s2++;
  80173a:	ff 45 fc             	incl   -0x4(%ebp)
  80173d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801740:	8b 45 10             	mov    0x10(%ebp),%eax
  801743:	8d 50 ff             	lea    -0x1(%eax),%edx
  801746:	89 55 10             	mov    %edx,0x10(%ebp)
  801749:	85 c0                	test   %eax,%eax
  80174b:	75 c9                	jne    801716 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80174d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80175a:	8b 55 08             	mov    0x8(%ebp),%edx
  80175d:	8b 45 10             	mov    0x10(%ebp),%eax
  801760:	01 d0                	add    %edx,%eax
  801762:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801765:	eb 15                	jmp    80177c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	8a 00                	mov    (%eax),%al
  80176c:	0f b6 d0             	movzbl %al,%edx
  80176f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801772:	0f b6 c0             	movzbl %al,%eax
  801775:	39 c2                	cmp    %eax,%edx
  801777:	74 0d                	je     801786 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801779:	ff 45 08             	incl   0x8(%ebp)
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801782:	72 e3                	jb     801767 <memfind+0x13>
  801784:	eb 01                	jmp    801787 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801786:	90                   	nop
	return (void *) s;
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801792:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801799:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017a0:	eb 03                	jmp    8017a5 <strtol+0x19>
		s++;
  8017a2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	8a 00                	mov    (%eax),%al
  8017aa:	3c 20                	cmp    $0x20,%al
  8017ac:	74 f4                	je     8017a2 <strtol+0x16>
  8017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b1:	8a 00                	mov    (%eax),%al
  8017b3:	3c 09                	cmp    $0x9,%al
  8017b5:	74 eb                	je     8017a2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	8a 00                	mov    (%eax),%al
  8017bc:	3c 2b                	cmp    $0x2b,%al
  8017be:	75 05                	jne    8017c5 <strtol+0x39>
		s++;
  8017c0:	ff 45 08             	incl   0x8(%ebp)
  8017c3:	eb 13                	jmp    8017d8 <strtol+0x4c>
	else if (*s == '-')
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	8a 00                	mov    (%eax),%al
  8017ca:	3c 2d                	cmp    $0x2d,%al
  8017cc:	75 0a                	jne    8017d8 <strtol+0x4c>
		s++, neg = 1;
  8017ce:	ff 45 08             	incl   0x8(%ebp)
  8017d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017dc:	74 06                	je     8017e4 <strtol+0x58>
  8017de:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017e2:	75 20                	jne    801804 <strtol+0x78>
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	8a 00                	mov    (%eax),%al
  8017e9:	3c 30                	cmp    $0x30,%al
  8017eb:	75 17                	jne    801804 <strtol+0x78>
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	40                   	inc    %eax
  8017f1:	8a 00                	mov    (%eax),%al
  8017f3:	3c 78                	cmp    $0x78,%al
  8017f5:	75 0d                	jne    801804 <strtol+0x78>
		s += 2, base = 16;
  8017f7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017fb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801802:	eb 28                	jmp    80182c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801804:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801808:	75 15                	jne    80181f <strtol+0x93>
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	8a 00                	mov    (%eax),%al
  80180f:	3c 30                	cmp    $0x30,%al
  801811:	75 0c                	jne    80181f <strtol+0x93>
		s++, base = 8;
  801813:	ff 45 08             	incl   0x8(%ebp)
  801816:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80181d:	eb 0d                	jmp    80182c <strtol+0xa0>
	else if (base == 0)
  80181f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801823:	75 07                	jne    80182c <strtol+0xa0>
		base = 10;
  801825:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	8a 00                	mov    (%eax),%al
  801831:	3c 2f                	cmp    $0x2f,%al
  801833:	7e 19                	jle    80184e <strtol+0xc2>
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	8a 00                	mov    (%eax),%al
  80183a:	3c 39                	cmp    $0x39,%al
  80183c:	7f 10                	jg     80184e <strtol+0xc2>
			dig = *s - '0';
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8a 00                	mov    (%eax),%al
  801843:	0f be c0             	movsbl %al,%eax
  801846:	83 e8 30             	sub    $0x30,%eax
  801849:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80184c:	eb 42                	jmp    801890 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	3c 60                	cmp    $0x60,%al
  801855:	7e 19                	jle    801870 <strtol+0xe4>
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 7a                	cmp    $0x7a,%al
  80185e:	7f 10                	jg     801870 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	0f be c0             	movsbl %al,%eax
  801868:	83 e8 57             	sub    $0x57,%eax
  80186b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80186e:	eb 20                	jmp    801890 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	8a 00                	mov    (%eax),%al
  801875:	3c 40                	cmp    $0x40,%al
  801877:	7e 39                	jle    8018b2 <strtol+0x126>
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	8a 00                	mov    (%eax),%al
  80187e:	3c 5a                	cmp    $0x5a,%al
  801880:	7f 30                	jg     8018b2 <strtol+0x126>
			dig = *s - 'A' + 10;
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	8a 00                	mov    (%eax),%al
  801887:	0f be c0             	movsbl %al,%eax
  80188a:	83 e8 37             	sub    $0x37,%eax
  80188d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801893:	3b 45 10             	cmp    0x10(%ebp),%eax
  801896:	7d 19                	jge    8018b1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801898:	ff 45 08             	incl   0x8(%ebp)
  80189b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189e:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018a2:	89 c2                	mov    %eax,%edx
  8018a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a7:	01 d0                	add    %edx,%eax
  8018a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018ac:	e9 7b ff ff ff       	jmp    80182c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018b1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018b6:	74 08                	je     8018c0 <strtol+0x134>
		*endptr = (char *) s;
  8018b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8018be:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018c4:	74 07                	je     8018cd <strtol+0x141>
  8018c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c9:	f7 d8                	neg    %eax
  8018cb:	eb 03                	jmp    8018d0 <strtol+0x144>
  8018cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <ltostr>:

void
ltostr(long value, char *str)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018ea:	79 13                	jns    8018ff <ltostr+0x2d>
	{
		neg = 1;
  8018ec:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018f9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018fc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801907:	99                   	cltd   
  801908:	f7 f9                	idiv   %ecx
  80190a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80190d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801910:	8d 50 01             	lea    0x1(%eax),%edx
  801913:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801916:	89 c2                	mov    %eax,%edx
  801918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191b:	01 d0                	add    %edx,%eax
  80191d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801920:	83 c2 30             	add    $0x30,%edx
  801923:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801925:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801928:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80192d:	f7 e9                	imul   %ecx
  80192f:	c1 fa 02             	sar    $0x2,%edx
  801932:	89 c8                	mov    %ecx,%eax
  801934:	c1 f8 1f             	sar    $0x1f,%eax
  801937:	29 c2                	sub    %eax,%edx
  801939:	89 d0                	mov    %edx,%eax
  80193b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80193e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801942:	75 bb                	jne    8018ff <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801944:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80194b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80194e:	48                   	dec    %eax
  80194f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801952:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801956:	74 3d                	je     801995 <ltostr+0xc3>
		start = 1 ;
  801958:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80195f:	eb 34                	jmp    801995 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801961:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801964:	8b 45 0c             	mov    0xc(%ebp),%eax
  801967:	01 d0                	add    %edx,%eax
  801969:	8a 00                	mov    (%eax),%al
  80196b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80196e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801971:	8b 45 0c             	mov    0xc(%ebp),%eax
  801974:	01 c2                	add    %eax,%edx
  801976:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801979:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197c:	01 c8                	add    %ecx,%eax
  80197e:	8a 00                	mov    (%eax),%al
  801980:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801982:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801985:	8b 45 0c             	mov    0xc(%ebp),%eax
  801988:	01 c2                	add    %eax,%edx
  80198a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80198d:	88 02                	mov    %al,(%edx)
		start++ ;
  80198f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801992:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801998:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80199b:	7c c4                	jl     801961 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80199d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a3:	01 d0                	add    %edx,%eax
  8019a5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019a8:	90                   	nop
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019b1:	ff 75 08             	pushl  0x8(%ebp)
  8019b4:	e8 c4 f9 ff ff       	call   80137d <strlen>
  8019b9:	83 c4 04             	add    $0x4,%esp
  8019bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019bf:	ff 75 0c             	pushl  0xc(%ebp)
  8019c2:	e8 b6 f9 ff ff       	call   80137d <strlen>
  8019c7:	83 c4 04             	add    $0x4,%esp
  8019ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019db:	eb 17                	jmp    8019f4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e3:	01 c2                	add    %eax,%edx
  8019e5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	01 c8                	add    %ecx,%eax
  8019ed:	8a 00                	mov    (%eax),%al
  8019ef:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019f1:	ff 45 fc             	incl   -0x4(%ebp)
  8019f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019fa:	7c e1                	jl     8019dd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a03:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a0a:	eb 1f                	jmp    801a2b <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a0f:	8d 50 01             	lea    0x1(%eax),%edx
  801a12:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a15:	89 c2                	mov    %eax,%edx
  801a17:	8b 45 10             	mov    0x10(%ebp),%eax
  801a1a:	01 c2                	add    %eax,%edx
  801a1c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a22:	01 c8                	add    %ecx,%eax
  801a24:	8a 00                	mov    (%eax),%al
  801a26:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a28:	ff 45 f8             	incl   -0x8(%ebp)
  801a2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a31:	7c d9                	jl     801a0c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a36:	8b 45 10             	mov    0x10(%ebp),%eax
  801a39:	01 d0                	add    %edx,%eax
  801a3b:	c6 00 00             	movb   $0x0,(%eax)
}
  801a3e:	90                   	nop
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a44:	8b 45 14             	mov    0x14(%ebp),%eax
  801a47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a50:	8b 00                	mov    (%eax),%eax
  801a52:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a59:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5c:	01 d0                	add    %edx,%eax
  801a5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a64:	eb 0c                	jmp    801a72 <strsplit+0x31>
			*string++ = 0;
  801a66:	8b 45 08             	mov    0x8(%ebp),%eax
  801a69:	8d 50 01             	lea    0x1(%eax),%edx
  801a6c:	89 55 08             	mov    %edx,0x8(%ebp)
  801a6f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	8a 00                	mov    (%eax),%al
  801a77:	84 c0                	test   %al,%al
  801a79:	74 18                	je     801a93 <strsplit+0x52>
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	8a 00                	mov    (%eax),%al
  801a80:	0f be c0             	movsbl %al,%eax
  801a83:	50                   	push   %eax
  801a84:	ff 75 0c             	pushl  0xc(%ebp)
  801a87:	e8 83 fa ff ff       	call   80150f <strchr>
  801a8c:	83 c4 08             	add    $0x8,%esp
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	75 d3                	jne    801a66 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	8a 00                	mov    (%eax),%al
  801a98:	84 c0                	test   %al,%al
  801a9a:	74 5a                	je     801af6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a9c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9f:	8b 00                	mov    (%eax),%eax
  801aa1:	83 f8 0f             	cmp    $0xf,%eax
  801aa4:	75 07                	jne    801aad <strsplit+0x6c>
		{
			return 0;
  801aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  801aab:	eb 66                	jmp    801b13 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801aad:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab0:	8b 00                	mov    (%eax),%eax
  801ab2:	8d 48 01             	lea    0x1(%eax),%ecx
  801ab5:	8b 55 14             	mov    0x14(%ebp),%edx
  801ab8:	89 0a                	mov    %ecx,(%edx)
  801aba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac4:	01 c2                	add    %eax,%edx
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801acb:	eb 03                	jmp    801ad0 <strsplit+0x8f>
			string++;
  801acd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	8a 00                	mov    (%eax),%al
  801ad5:	84 c0                	test   %al,%al
  801ad7:	74 8b                	je     801a64 <strsplit+0x23>
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	8a 00                	mov    (%eax),%al
  801ade:	0f be c0             	movsbl %al,%eax
  801ae1:	50                   	push   %eax
  801ae2:	ff 75 0c             	pushl  0xc(%ebp)
  801ae5:	e8 25 fa ff ff       	call   80150f <strchr>
  801aea:	83 c4 08             	add    $0x8,%esp
  801aed:	85 c0                	test   %eax,%eax
  801aef:	74 dc                	je     801acd <strsplit+0x8c>
			string++;
	}
  801af1:	e9 6e ff ff ff       	jmp    801a64 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801af6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801af7:	8b 45 14             	mov    0x14(%ebp),%eax
  801afa:	8b 00                	mov    (%eax),%eax
  801afc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b03:	8b 45 10             	mov    0x10(%ebp),%eax
  801b06:	01 d0                	add    %edx,%eax
  801b08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b0e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801b21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b28:	eb 4a                	jmp    801b74 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801b2a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	01 c2                	add    %eax,%edx
  801b32:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b38:	01 c8                	add    %ecx,%eax
  801b3a:	8a 00                	mov    (%eax),%al
  801b3c:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801b3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b44:	01 d0                	add    %edx,%eax
  801b46:	8a 00                	mov    (%eax),%al
  801b48:	3c 40                	cmp    $0x40,%al
  801b4a:	7e 25                	jle    801b71 <str2lower+0x5c>
  801b4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b52:	01 d0                	add    %edx,%eax
  801b54:	8a 00                	mov    (%eax),%al
  801b56:	3c 5a                	cmp    $0x5a,%al
  801b58:	7f 17                	jg     801b71 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801b5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	01 d0                	add    %edx,%eax
  801b62:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b65:	8b 55 08             	mov    0x8(%ebp),%edx
  801b68:	01 ca                	add    %ecx,%edx
  801b6a:	8a 12                	mov    (%edx),%dl
  801b6c:	83 c2 20             	add    $0x20,%edx
  801b6f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801b71:	ff 45 fc             	incl   -0x4(%ebp)
  801b74:	ff 75 0c             	pushl  0xc(%ebp)
  801b77:	e8 01 f8 ff ff       	call   80137d <strlen>
  801b7c:	83 c4 04             	add    $0x4,%esp
  801b7f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b82:	7f a6                	jg     801b2a <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b84:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801b8f:	83 ec 0c             	sub    $0xc,%esp
  801b92:	6a 10                	push   $0x10
  801b94:	e8 b2 15 00 00       	call   80314b <alloc_block>
  801b99:	83 c4 10             	add    $0x10,%esp
  801b9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801b9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ba3:	75 14                	jne    801bb9 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801ba5:	83 ec 04             	sub    $0x4,%esp
  801ba8:	68 1c 46 80 00       	push   $0x80461c
  801bad:	6a 14                	push   $0x14
  801baf:	68 45 46 80 00       	push   $0x804645
  801bb4:	e8 f5 eb ff ff       	call   8007ae <_panic>

	node->start = start;
  801bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bbc:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbf:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801bc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc7:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801bca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801bd1:	a1 28 50 80 00       	mov    0x805028,%eax
  801bd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bd9:	eb 18                	jmp    801bf3 <insert_page_alloc+0x6a>
		if (start < it->start)
  801bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bde:	8b 00                	mov    (%eax),%eax
  801be0:	3b 45 08             	cmp    0x8(%ebp),%eax
  801be3:	77 37                	ja     801c1c <insert_page_alloc+0x93>
			break;
		prev = it;
  801be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801beb:	a1 30 50 80 00       	mov    0x805030,%eax
  801bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bf7:	74 08                	je     801c01 <insert_page_alloc+0x78>
  801bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfc:	8b 40 08             	mov    0x8(%eax),%eax
  801bff:	eb 05                	jmp    801c06 <insert_page_alloc+0x7d>
  801c01:	b8 00 00 00 00       	mov    $0x0,%eax
  801c06:	a3 30 50 80 00       	mov    %eax,0x805030
  801c0b:	a1 30 50 80 00       	mov    0x805030,%eax
  801c10:	85 c0                	test   %eax,%eax
  801c12:	75 c7                	jne    801bdb <insert_page_alloc+0x52>
  801c14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c18:	75 c1                	jne    801bdb <insert_page_alloc+0x52>
  801c1a:	eb 01                	jmp    801c1d <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801c1c:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801c1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c21:	75 64                	jne    801c87 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801c23:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c27:	75 14                	jne    801c3d <insert_page_alloc+0xb4>
  801c29:	83 ec 04             	sub    $0x4,%esp
  801c2c:	68 54 46 80 00       	push   $0x804654
  801c31:	6a 21                	push   $0x21
  801c33:	68 45 46 80 00       	push   $0x804645
  801c38:	e8 71 eb ff ff       	call   8007ae <_panic>
  801c3d:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801c43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c46:	89 50 08             	mov    %edx,0x8(%eax)
  801c49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c4c:	8b 40 08             	mov    0x8(%eax),%eax
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	74 0d                	je     801c60 <insert_page_alloc+0xd7>
  801c53:	a1 28 50 80 00       	mov    0x805028,%eax
  801c58:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c5b:	89 50 0c             	mov    %edx,0xc(%eax)
  801c5e:	eb 08                	jmp    801c68 <insert_page_alloc+0xdf>
  801c60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c63:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c6b:	a3 28 50 80 00       	mov    %eax,0x805028
  801c70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c73:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c7a:	a1 34 50 80 00       	mov    0x805034,%eax
  801c7f:	40                   	inc    %eax
  801c80:	a3 34 50 80 00       	mov    %eax,0x805034
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801c85:	eb 71                	jmp    801cf8 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801c87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c8b:	74 06                	je     801c93 <insert_page_alloc+0x10a>
  801c8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c91:	75 14                	jne    801ca7 <insert_page_alloc+0x11e>
  801c93:	83 ec 04             	sub    $0x4,%esp
  801c96:	68 78 46 80 00       	push   $0x804678
  801c9b:	6a 23                	push   $0x23
  801c9d:	68 45 46 80 00       	push   $0x804645
  801ca2:	e8 07 eb ff ff       	call   8007ae <_panic>
  801ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801caa:	8b 50 08             	mov    0x8(%eax),%edx
  801cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb0:	89 50 08             	mov    %edx,0x8(%eax)
  801cb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb6:	8b 40 08             	mov    0x8(%eax),%eax
  801cb9:	85 c0                	test   %eax,%eax
  801cbb:	74 0c                	je     801cc9 <insert_page_alloc+0x140>
  801cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc0:	8b 40 08             	mov    0x8(%eax),%eax
  801cc3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cc6:	89 50 0c             	mov    %edx,0xc(%eax)
  801cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ccf:	89 50 08             	mov    %edx,0x8(%eax)
  801cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cd8:	89 50 0c             	mov    %edx,0xc(%eax)
  801cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cde:	8b 40 08             	mov    0x8(%eax),%eax
  801ce1:	85 c0                	test   %eax,%eax
  801ce3:	75 08                	jne    801ced <insert_page_alloc+0x164>
  801ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ce8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801ced:	a1 34 50 80 00       	mov    0x805034,%eax
  801cf2:	40                   	inc    %eax
  801cf3:	a3 34 50 80 00       	mov    %eax,0x805034
}
  801cf8:	90                   	nop
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801d01:	a1 28 50 80 00       	mov    0x805028,%eax
  801d06:	85 c0                	test   %eax,%eax
  801d08:	75 0c                	jne    801d16 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801d0a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d0f:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801d14:	eb 67                	jmp    801d7d <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801d16:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801d1e:	a1 28 50 80 00       	mov    0x805028,%eax
  801d23:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801d26:	eb 26                	jmp    801d4e <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801d28:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d2b:	8b 10                	mov    (%eax),%edx
  801d2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d30:	8b 40 04             	mov    0x4(%eax),%eax
  801d33:	01 d0                	add    %edx,%eax
  801d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801d3e:	76 06                	jbe    801d46 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d43:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801d46:	a1 30 50 80 00       	mov    0x805030,%eax
  801d4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801d4e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801d52:	74 08                	je     801d5c <recompute_page_alloc_break+0x61>
  801d54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d57:	8b 40 08             	mov    0x8(%eax),%eax
  801d5a:	eb 05                	jmp    801d61 <recompute_page_alloc_break+0x66>
  801d5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d61:	a3 30 50 80 00       	mov    %eax,0x805030
  801d66:	a1 30 50 80 00       	mov    0x805030,%eax
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	75 b9                	jne    801d28 <recompute_page_alloc_break+0x2d>
  801d6f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801d73:	75 b3                	jne    801d28 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801d75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d78:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801d85:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801d8c:	8b 55 08             	mov    0x8(%ebp),%edx
  801d8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d92:	01 d0                	add    %edx,%eax
  801d94:	48                   	dec    %eax
  801d95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801d98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801da0:	f7 75 d8             	divl   -0x28(%ebp)
  801da3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801da6:	29 d0                	sub    %edx,%eax
  801da8:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801dab:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801daf:	75 0a                	jne    801dbb <alloc_pages_custom_fit+0x3c>
		return NULL;
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax
  801db6:	e9 7e 01 00 00       	jmp    801f39 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801dbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801dc2:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801dc6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801dcd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801dd4:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801dd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801ddc:	a1 28 50 80 00       	mov    0x805028,%eax
  801de1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801de4:	eb 69                	jmp    801e4f <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801de6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de9:	8b 00                	mov    (%eax),%eax
  801deb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801dee:	76 47                	jbe    801e37 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801df0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801df3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801df6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801df9:	8b 00                	mov    (%eax),%eax
  801dfb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801dfe:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801e01:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e04:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e07:	72 2e                	jb     801e37 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801e09:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801e0d:	75 14                	jne    801e23 <alloc_pages_custom_fit+0xa4>
  801e0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e12:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e15:	75 0c                	jne    801e23 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801e17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801e1d:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801e21:	eb 14                	jmp    801e37 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801e23:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e26:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e29:	76 0c                	jbe    801e37 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801e2b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801e31:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e34:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801e37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e3a:	8b 10                	mov    (%eax),%edx
  801e3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e3f:	8b 40 04             	mov    0x4(%eax),%eax
  801e42:	01 d0                	add    %edx,%eax
  801e44:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801e47:	a1 30 50 80 00       	mov    0x805030,%eax
  801e4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e4f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e53:	74 08                	je     801e5d <alloc_pages_custom_fit+0xde>
  801e55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e58:	8b 40 08             	mov    0x8(%eax),%eax
  801e5b:	eb 05                	jmp    801e62 <alloc_pages_custom_fit+0xe3>
  801e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e62:	a3 30 50 80 00       	mov    %eax,0x805030
  801e67:	a1 30 50 80 00       	mov    0x805030,%eax
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	0f 85 72 ff ff ff    	jne    801de6 <alloc_pages_custom_fit+0x67>
  801e74:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e78:	0f 85 68 ff ff ff    	jne    801de6 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801e7e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e83:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e86:	76 47                	jbe    801ecf <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801e88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e8b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801e8e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e93:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801e96:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801e99:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e9c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e9f:	72 2e                	jb     801ecf <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801ea1:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801ea5:	75 14                	jne    801ebb <alloc_pages_custom_fit+0x13c>
  801ea7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801eaa:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801ead:	75 0c                	jne    801ebb <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801eaf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801eb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801eb5:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801eb9:	eb 14                	jmp    801ecf <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801ebb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ebe:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ec1:	76 0c                	jbe    801ecf <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801ec3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ec6:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801ec9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ecc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801ecf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801ed6:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801eda:	74 08                	je     801ee4 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ee2:	eb 40                	jmp    801f24 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801ee4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ee8:	74 08                	je     801ef2 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801eea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ef0:	eb 32                	jmp    801f24 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801ef2:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801ef7:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801efa:	89 c2                	mov    %eax,%edx
  801efc:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f01:	39 c2                	cmp    %eax,%edx
  801f03:	73 07                	jae    801f0c <alloc_pages_custom_fit+0x18d>
			return NULL;
  801f05:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0a:	eb 2d                	jmp    801f39 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801f0c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f11:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801f14:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f1a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f1d:	01 d0                	add    %edx,%eax
  801f1f:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801f24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f27:	83 ec 08             	sub    $0x8,%esp
  801f2a:	ff 75 d0             	pushl  -0x30(%ebp)
  801f2d:	50                   	push   %eax
  801f2e:	e8 56 fc ff ff       	call   801b89 <insert_page_alloc>
  801f33:	83 c4 10             	add    $0x10,%esp

	return result;
  801f36:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801f41:	8b 45 08             	mov    0x8(%ebp),%eax
  801f44:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f47:	a1 28 50 80 00       	mov    0x805028,%eax
  801f4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f4f:	eb 1a                	jmp    801f6b <find_allocated_size+0x30>
		if (it->start == va)
  801f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f54:	8b 00                	mov    (%eax),%eax
  801f56:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f59:	75 08                	jne    801f63 <find_allocated_size+0x28>
			return it->size;
  801f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f5e:	8b 40 04             	mov    0x4(%eax),%eax
  801f61:	eb 34                	jmp    801f97 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f63:	a1 30 50 80 00       	mov    0x805030,%eax
  801f68:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f6f:	74 08                	je     801f79 <find_allocated_size+0x3e>
  801f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f74:	8b 40 08             	mov    0x8(%eax),%eax
  801f77:	eb 05                	jmp    801f7e <find_allocated_size+0x43>
  801f79:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7e:	a3 30 50 80 00       	mov    %eax,0x805030
  801f83:	a1 30 50 80 00       	mov    0x805030,%eax
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	75 c5                	jne    801f51 <find_allocated_size+0x16>
  801f8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f90:	75 bf                	jne    801f51 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801f92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801fa5:	a1 28 50 80 00       	mov    0x805028,%eax
  801faa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fad:	e9 e1 01 00 00       	jmp    802193 <free_pages+0x1fa>
		if (it->start == va) {
  801fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb5:	8b 00                	mov    (%eax),%eax
  801fb7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fba:	0f 85 cb 01 00 00    	jne    80218b <free_pages+0x1f2>

			uint32 start = it->start;
  801fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc3:	8b 00                	mov    (%eax),%eax
  801fc5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcb:	8b 40 04             	mov    0x4(%eax),%eax
  801fce:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801fd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fd4:	f7 d0                	not    %eax
  801fd6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801fd9:	73 1d                	jae    801ff8 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801fdb:	83 ec 0c             	sub    $0xc,%esp
  801fde:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fe1:	ff 75 e8             	pushl  -0x18(%ebp)
  801fe4:	68 ac 46 80 00       	push   $0x8046ac
  801fe9:	68 a5 00 00 00       	push   $0xa5
  801fee:	68 45 46 80 00       	push   $0x804645
  801ff3:	e8 b6 e7 ff ff       	call   8007ae <_panic>
			}

			uint32 start_end = start + size;
  801ff8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ffb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ffe:	01 d0                	add    %edx,%eax
  802000:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  802003:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802006:	85 c0                	test   %eax,%eax
  802008:	79 19                	jns    802023 <free_pages+0x8a>
  80200a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802011:	77 10                	ja     802023 <free_pages+0x8a>
  802013:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  80201a:	77 07                	ja     802023 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  80201c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80201f:	85 c0                	test   %eax,%eax
  802021:	78 2c                	js     80204f <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  802023:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802026:	83 ec 0c             	sub    $0xc,%esp
  802029:	68 00 00 00 a0       	push   $0xa0000000
  80202e:	ff 75 e0             	pushl  -0x20(%ebp)
  802031:	ff 75 e4             	pushl  -0x1c(%ebp)
  802034:	ff 75 e8             	pushl  -0x18(%ebp)
  802037:	ff 75 e4             	pushl  -0x1c(%ebp)
  80203a:	50                   	push   %eax
  80203b:	68 f0 46 80 00       	push   $0x8046f0
  802040:	68 ad 00 00 00       	push   $0xad
  802045:	68 45 46 80 00       	push   $0x804645
  80204a:	e8 5f e7 ff ff       	call   8007ae <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  80204f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802052:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802055:	e9 88 00 00 00       	jmp    8020e2 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  80205a:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  802061:	76 17                	jbe    80207a <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  802063:	ff 75 f0             	pushl  -0x10(%ebp)
  802066:	68 54 47 80 00       	push   $0x804754
  80206b:	68 b4 00 00 00       	push   $0xb4
  802070:	68 45 46 80 00       	push   $0x804645
  802075:	e8 34 e7 ff ff       	call   8007ae <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  80207a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207d:	05 00 10 00 00       	add    $0x1000,%eax
  802082:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  802085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802088:	85 c0                	test   %eax,%eax
  80208a:	79 2e                	jns    8020ba <free_pages+0x121>
  80208c:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802093:	77 25                	ja     8020ba <free_pages+0x121>
  802095:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  80209c:	77 1c                	ja     8020ba <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  80209e:	83 ec 08             	sub    $0x8,%esp
  8020a1:	68 00 10 00 00       	push   $0x1000
  8020a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8020a9:	e8 38 0d 00 00       	call   802de6 <sys_free_user_mem>
  8020ae:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8020b1:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8020b8:	eb 28                	jmp    8020e2 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  8020ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bd:	68 00 00 00 a0       	push   $0xa0000000
  8020c2:	ff 75 dc             	pushl  -0x24(%ebp)
  8020c5:	68 00 10 00 00       	push   $0x1000
  8020ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8020cd:	50                   	push   %eax
  8020ce:	68 94 47 80 00       	push   $0x804794
  8020d3:	68 bd 00 00 00       	push   $0xbd
  8020d8:	68 45 46 80 00       	push   $0x804645
  8020dd:	e8 cc e6 ff ff       	call   8007ae <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8020e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8020e8:	0f 82 6c ff ff ff    	jb     80205a <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  8020ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f2:	75 17                	jne    80210b <free_pages+0x172>
  8020f4:	83 ec 04             	sub    $0x4,%esp
  8020f7:	68 f6 47 80 00       	push   $0x8047f6
  8020fc:	68 c1 00 00 00       	push   $0xc1
  802101:	68 45 46 80 00       	push   $0x804645
  802106:	e8 a3 e6 ff ff       	call   8007ae <_panic>
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210e:	8b 40 08             	mov    0x8(%eax),%eax
  802111:	85 c0                	test   %eax,%eax
  802113:	74 11                	je     802126 <free_pages+0x18d>
  802115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802118:	8b 40 08             	mov    0x8(%eax),%eax
  80211b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211e:	8b 52 0c             	mov    0xc(%edx),%edx
  802121:	89 50 0c             	mov    %edx,0xc(%eax)
  802124:	eb 0b                	jmp    802131 <free_pages+0x198>
  802126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802129:	8b 40 0c             	mov    0xc(%eax),%eax
  80212c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802134:	8b 40 0c             	mov    0xc(%eax),%eax
  802137:	85 c0                	test   %eax,%eax
  802139:	74 11                	je     80214c <free_pages+0x1b3>
  80213b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213e:	8b 40 0c             	mov    0xc(%eax),%eax
  802141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802144:	8b 52 08             	mov    0x8(%edx),%edx
  802147:	89 50 08             	mov    %edx,0x8(%eax)
  80214a:	eb 0b                	jmp    802157 <free_pages+0x1be>
  80214c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214f:	8b 40 08             	mov    0x8(%eax),%eax
  802152:	a3 28 50 80 00       	mov    %eax,0x805028
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802164:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80216b:	a1 34 50 80 00       	mov    0x805034,%eax
  802170:	48                   	dec    %eax
  802171:	a3 34 50 80 00       	mov    %eax,0x805034
			free_block(it);
  802176:	83 ec 0c             	sub    $0xc,%esp
  802179:	ff 75 f4             	pushl  -0xc(%ebp)
  80217c:	e8 24 15 00 00       	call   8036a5 <free_block>
  802181:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  802184:	e8 72 fb ff ff       	call   801cfb <recompute_page_alloc_break>

			return;
  802189:	eb 37                	jmp    8021c2 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80218b:	a1 30 50 80 00       	mov    0x805030,%eax
  802190:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802193:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802197:	74 08                	je     8021a1 <free_pages+0x208>
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 40 08             	mov    0x8(%eax),%eax
  80219f:	eb 05                	jmp    8021a6 <free_pages+0x20d>
  8021a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a6:	a3 30 50 80 00       	mov    %eax,0x805030
  8021ab:	a1 30 50 80 00       	mov    0x805030,%eax
  8021b0:	85 c0                	test   %eax,%eax
  8021b2:	0f 85 fa fd ff ff    	jne    801fb2 <free_pages+0x19>
  8021b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bc:	0f 85 f0 fd ff ff    	jne    801fb2 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  8021c2:	c9                   	leave  
  8021c3:	c3                   	ret    

008021c4 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  8021c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021cc:	5d                   	pop    %ebp
  8021cd:	c3                   	ret    

008021ce <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8021d4:	a1 08 50 80 00       	mov    0x805008,%eax
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	74 60                	je     80223d <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8021dd:	83 ec 08             	sub    $0x8,%esp
  8021e0:	68 00 00 00 82       	push   $0x82000000
  8021e5:	68 00 00 00 80       	push   $0x80000000
  8021ea:	e8 0d 0d 00 00       	call   802efc <initialize_dynamic_allocator>
  8021ef:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8021f2:	e8 f3 0a 00 00       	call   802cea <sys_get_uheap_strategy>
  8021f7:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8021fc:	a1 40 50 80 00       	mov    0x805040,%eax
  802201:	05 00 10 00 00       	add    $0x1000,%eax
  802206:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  80220b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802210:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  802215:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  80221c:	00 00 00 
  80221f:	c7 05 2c 50 80 00 00 	movl   $0x0,0x80502c
  802226:	00 00 00 
  802229:	c7 05 34 50 80 00 00 	movl   $0x0,0x805034
  802230:	00 00 00 

		__firstTimeFlag = 0;
  802233:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80223a:	00 00 00 
	}
}
  80223d:	90                   	nop
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
  802243:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802254:	83 ec 08             	sub    $0x8,%esp
  802257:	68 06 04 00 00       	push   $0x406
  80225c:	50                   	push   %eax
  80225d:	e8 d2 06 00 00       	call   802934 <__sys_allocate_page>
  802262:	83 c4 10             	add    $0x10,%esp
  802265:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802268:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80226c:	79 17                	jns    802285 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  80226e:	83 ec 04             	sub    $0x4,%esp
  802271:	68 14 48 80 00       	push   $0x804814
  802276:	68 ea 00 00 00       	push   $0xea
  80227b:	68 45 46 80 00       	push   $0x804645
  802280:	e8 29 e5 ff ff       	call   8007ae <_panic>
	return 0;
  802285:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
  80228f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8022a0:	83 ec 0c             	sub    $0xc,%esp
  8022a3:	50                   	push   %eax
  8022a4:	e8 d2 06 00 00       	call   80297b <__sys_unmap_frame>
  8022a9:	83 c4 10             	add    $0x10,%esp
  8022ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8022af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022b3:	79 17                	jns    8022cc <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  8022b5:	83 ec 04             	sub    $0x4,%esp
  8022b8:	68 50 48 80 00       	push   $0x804850
  8022bd:	68 f5 00 00 00       	push   $0xf5
  8022c2:	68 45 46 80 00       	push   $0x804645
  8022c7:	e8 e2 e4 ff ff       	call   8007ae <_panic>
}
  8022cc:	90                   	nop
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
  8022d2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8022d5:	e8 f4 fe ff ff       	call   8021ce <uheap_init>
	if (size == 0) return NULL ;
  8022da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022de:	75 0a                	jne    8022ea <malloc+0x1b>
  8022e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e5:	e9 67 01 00 00       	jmp    802451 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  8022ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8022f1:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8022f8:	77 16                	ja     802310 <malloc+0x41>
		result = alloc_block(size);
  8022fa:	83 ec 0c             	sub    $0xc,%esp
  8022fd:	ff 75 08             	pushl  0x8(%ebp)
  802300:	e8 46 0e 00 00       	call   80314b <alloc_block>
  802305:	83 c4 10             	add    $0x10,%esp
  802308:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230b:	e9 3e 01 00 00       	jmp    80244e <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802310:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802317:	8b 55 08             	mov    0x8(%ebp),%edx
  80231a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231d:	01 d0                	add    %edx,%eax
  80231f:	48                   	dec    %eax
  802320:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802323:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802326:	ba 00 00 00 00       	mov    $0x0,%edx
  80232b:	f7 75 f0             	divl   -0x10(%ebp)
  80232e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802331:	29 d0                	sub    %edx,%eax
  802333:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  802336:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80233b:	85 c0                	test   %eax,%eax
  80233d:	75 0a                	jne    802349 <malloc+0x7a>
			return NULL;
  80233f:	b8 00 00 00 00       	mov    $0x0,%eax
  802344:	e9 08 01 00 00       	jmp    802451 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  802349:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80234e:	85 c0                	test   %eax,%eax
  802350:	74 0f                	je     802361 <malloc+0x92>
  802352:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802358:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80235d:	39 c2                	cmp    %eax,%edx
  80235f:	73 0a                	jae    80236b <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  802361:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802366:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  80236b:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802370:	83 f8 05             	cmp    $0x5,%eax
  802373:	75 11                	jne    802386 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  802375:	83 ec 0c             	sub    $0xc,%esp
  802378:	ff 75 e8             	pushl  -0x18(%ebp)
  80237b:	e8 ff f9 ff ff       	call   801d7f <alloc_pages_custom_fit>
  802380:	83 c4 10             	add    $0x10,%esp
  802383:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  802386:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238a:	0f 84 be 00 00 00    	je     80244e <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802393:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  802396:	83 ec 0c             	sub    $0xc,%esp
  802399:	ff 75 f4             	pushl  -0xc(%ebp)
  80239c:	e8 9a fb ff ff       	call   801f3b <find_allocated_size>
  8023a1:	83 c4 10             	add    $0x10,%esp
  8023a4:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  8023a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8023ab:	75 17                	jne    8023c4 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  8023ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b0:	68 90 48 80 00       	push   $0x804890
  8023b5:	68 24 01 00 00       	push   $0x124
  8023ba:	68 45 46 80 00       	push   $0x804645
  8023bf:	e8 ea e3 ff ff       	call   8007ae <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  8023c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023c7:	f7 d0                	not    %eax
  8023c9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8023cc:	73 1d                	jae    8023eb <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  8023ce:	83 ec 0c             	sub    $0xc,%esp
  8023d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8023d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023d7:	68 d8 48 80 00       	push   $0x8048d8
  8023dc:	68 29 01 00 00       	push   $0x129
  8023e1:	68 45 46 80 00       	push   $0x804645
  8023e6:	e8 c3 e3 ff ff       	call   8007ae <_panic>
			}

			uint32 result_end = result_va + actual_size;
  8023eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023f1:	01 d0                	add    %edx,%eax
  8023f3:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  8023f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	79 2c                	jns    802429 <malloc+0x15a>
  8023fd:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802404:	77 23                	ja     802429 <malloc+0x15a>
  802406:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  80240d:	77 1a                	ja     802429 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  80240f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802412:	85 c0                	test   %eax,%eax
  802414:	79 13                	jns    802429 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  802416:	83 ec 08             	sub    $0x8,%esp
  802419:	ff 75 e0             	pushl  -0x20(%ebp)
  80241c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80241f:	e8 de 09 00 00       	call   802e02 <sys_allocate_user_mem>
  802424:	83 c4 10             	add    $0x10,%esp
  802427:	eb 25                	jmp    80244e <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  802429:	68 00 00 00 a0       	push   $0xa0000000
  80242e:	ff 75 dc             	pushl  -0x24(%ebp)
  802431:	ff 75 e0             	pushl  -0x20(%ebp)
  802434:	ff 75 e4             	pushl  -0x1c(%ebp)
  802437:	ff 75 f4             	pushl  -0xc(%ebp)
  80243a:	68 14 49 80 00       	push   $0x804914
  80243f:	68 33 01 00 00       	push   $0x133
  802444:	68 45 46 80 00       	push   $0x804645
  802449:	e8 60 e3 ff ff       	call   8007ae <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  802451:	c9                   	leave  
  802452:	c3                   	ret    

00802453 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802453:	55                   	push   %ebp
  802454:	89 e5                	mov    %esp,%ebp
  802456:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802459:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80245d:	0f 84 26 01 00 00    	je     802589 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	85 c0                	test   %eax,%eax
  80246e:	79 1c                	jns    80248c <free+0x39>
  802470:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  802477:	77 13                	ja     80248c <free+0x39>
		free_block(virtual_address);
  802479:	83 ec 0c             	sub    $0xc,%esp
  80247c:	ff 75 08             	pushl  0x8(%ebp)
  80247f:	e8 21 12 00 00       	call   8036a5 <free_block>
  802484:	83 c4 10             	add    $0x10,%esp
		return;
  802487:	e9 01 01 00 00       	jmp    80258d <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  80248c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802491:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802494:	0f 82 d8 00 00 00    	jb     802572 <free+0x11f>
  80249a:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  8024a1:	0f 87 cb 00 00 00    	ja     802572 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	25 ff 0f 00 00       	and    $0xfff,%eax
  8024af:	85 c0                	test   %eax,%eax
  8024b1:	74 17                	je     8024ca <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  8024b3:	ff 75 08             	pushl  0x8(%ebp)
  8024b6:	68 84 49 80 00       	push   $0x804984
  8024bb:	68 57 01 00 00       	push   $0x157
  8024c0:	68 45 46 80 00       	push   $0x804645
  8024c5:	e8 e4 e2 ff ff       	call   8007ae <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  8024ca:	83 ec 0c             	sub    $0xc,%esp
  8024cd:	ff 75 08             	pushl  0x8(%ebp)
  8024d0:	e8 66 fa ff ff       	call   801f3b <find_allocated_size>
  8024d5:	83 c4 10             	add    $0x10,%esp
  8024d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  8024db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024df:	0f 84 a7 00 00 00    	je     80258c <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  8024e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e8:	f7 d0                	not    %eax
  8024ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024ed:	73 1d                	jae    80250c <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  8024ef:	83 ec 0c             	sub    $0xc,%esp
  8024f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8024f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8024f8:	68 ac 49 80 00       	push   $0x8049ac
  8024fd:	68 61 01 00 00       	push   $0x161
  802502:	68 45 46 80 00       	push   $0x804645
  802507:	e8 a2 e2 ff ff       	call   8007ae <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  80250c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802512:	01 d0                	add    %edx,%eax
  802514:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	85 c0                	test   %eax,%eax
  80251c:	79 19                	jns    802537 <free+0xe4>
  80251e:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  802525:	77 10                	ja     802537 <free+0xe4>
  802527:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  80252e:	77 07                	ja     802537 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  802530:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802533:	85 c0                	test   %eax,%eax
  802535:	78 2b                	js     802562 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  802537:	83 ec 0c             	sub    $0xc,%esp
  80253a:	68 00 00 00 a0       	push   $0xa0000000
  80253f:	ff 75 ec             	pushl  -0x14(%ebp)
  802542:	ff 75 f0             	pushl  -0x10(%ebp)
  802545:	ff 75 f4             	pushl  -0xc(%ebp)
  802548:	ff 75 f0             	pushl  -0x10(%ebp)
  80254b:	ff 75 08             	pushl  0x8(%ebp)
  80254e:	68 e8 49 80 00       	push   $0x8049e8
  802553:	68 69 01 00 00       	push   $0x169
  802558:	68 45 46 80 00       	push   $0x804645
  80255d:	e8 4c e2 ff ff       	call   8007ae <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  802562:	83 ec 0c             	sub    $0xc,%esp
  802565:	ff 75 08             	pushl  0x8(%ebp)
  802568:	e8 2c fa ff ff       	call   801f99 <free_pages>
  80256d:	83 c4 10             	add    $0x10,%esp
		return;
  802570:	eb 1b                	jmp    80258d <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  802572:	ff 75 08             	pushl  0x8(%ebp)
  802575:	68 44 4a 80 00       	push   $0x804a44
  80257a:	68 70 01 00 00       	push   $0x170
  80257f:	68 45 46 80 00       	push   $0x804645
  802584:	e8 25 e2 ff ff       	call   8007ae <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802589:	90                   	nop
  80258a:	eb 01                	jmp    80258d <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  80258c:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
  802592:	83 ec 38             	sub    $0x38,%esp
  802595:	8b 45 10             	mov    0x10(%ebp),%eax
  802598:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80259b:	e8 2e fc ff ff       	call   8021ce <uheap_init>
	if (size == 0) return NULL ;
  8025a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025a4:	75 0a                	jne    8025b0 <smalloc+0x21>
  8025a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ab:	e9 3d 01 00 00       	jmp    8026ed <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  8025b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  8025b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b9:	25 ff 0f 00 00       	and    $0xfff,%eax
  8025be:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  8025c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025c5:	74 0e                	je     8025d5 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8025cd:	05 00 10 00 00       	add    $0x1000,%eax
  8025d2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	c1 e8 0c             	shr    $0xc,%eax
  8025db:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8025de:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025e3:	85 c0                	test   %eax,%eax
  8025e5:	75 0a                	jne    8025f1 <smalloc+0x62>
		return NULL;
  8025e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ec:	e9 fc 00 00 00       	jmp    8026ed <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8025f1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	74 0f                	je     802609 <smalloc+0x7a>
  8025fa:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802600:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802605:	39 c2                	cmp    %eax,%edx
  802607:	73 0a                	jae    802613 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  802609:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80260e:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802613:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802618:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80261d:	29 c2                	sub    %eax,%edx
  80261f:	89 d0                	mov    %edx,%eax
  802621:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802624:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80262a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80262f:	29 c2                	sub    %eax,%edx
  802631:	89 d0                	mov    %edx,%eax
  802633:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802639:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80263c:	77 13                	ja     802651 <smalloc+0xc2>
  80263e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802641:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802644:	77 0b                	ja     802651 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  802646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802649:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80264c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80264f:	73 0a                	jae    80265b <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  802651:	b8 00 00 00 00       	mov    $0x0,%eax
  802656:	e9 92 00 00 00       	jmp    8026ed <smalloc+0x15e>
	}

	void *va = NULL;
  80265b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802662:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802667:	83 f8 05             	cmp    $0x5,%eax
  80266a:	75 11                	jne    80267d <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  80266c:	83 ec 0c             	sub    $0xc,%esp
  80266f:	ff 75 f4             	pushl  -0xc(%ebp)
  802672:	e8 08 f7 ff ff       	call   801d7f <alloc_pages_custom_fit>
  802677:	83 c4 10             	add    $0x10,%esp
  80267a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  80267d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802681:	75 27                	jne    8026aa <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802683:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  80268a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80268d:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802690:	89 c2                	mov    %eax,%edx
  802692:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802697:	39 c2                	cmp    %eax,%edx
  802699:	73 07                	jae    8026a2 <smalloc+0x113>
			return NULL;}
  80269b:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a0:	eb 4b                	jmp    8026ed <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  8026a2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8026a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  8026aa:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8026ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8026b1:	50                   	push   %eax
  8026b2:	ff 75 0c             	pushl  0xc(%ebp)
  8026b5:	ff 75 08             	pushl  0x8(%ebp)
  8026b8:	e8 cb 03 00 00       	call   802a88 <sys_create_shared_object>
  8026bd:	83 c4 10             	add    $0x10,%esp
  8026c0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  8026c3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8026c7:	79 07                	jns    8026d0 <smalloc+0x141>
		return NULL;
  8026c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ce:	eb 1d                	jmp    8026ed <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  8026d0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8026d5:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8026d8:	75 10                	jne    8026ea <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8026da:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	01 d0                	add    %edx,%eax
  8026e5:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  8026ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    

008026ef <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
  8026f2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8026f5:	e8 d4 fa ff ff       	call   8021ce <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8026fa:	83 ec 08             	sub    $0x8,%esp
  8026fd:	ff 75 0c             	pushl  0xc(%ebp)
  802700:	ff 75 08             	pushl  0x8(%ebp)
  802703:	e8 aa 03 00 00       	call   802ab2 <sys_size_of_shared_object>
  802708:	83 c4 10             	add    $0x10,%esp
  80270b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  80270e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802712:	7f 0a                	jg     80271e <sget+0x2f>
		return NULL;
  802714:	b8 00 00 00 00       	mov    $0x0,%eax
  802719:	e9 32 01 00 00       	jmp    802850 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  80271e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802721:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  802724:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802727:	25 ff 0f 00 00       	and    $0xfff,%eax
  80272c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  80272f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802733:	74 0e                	je     802743 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80273b:	05 00 10 00 00       	add    $0x1000,%eax
  802740:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  802743:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802748:	85 c0                	test   %eax,%eax
  80274a:	75 0a                	jne    802756 <sget+0x67>
		return NULL;
  80274c:	b8 00 00 00 00       	mov    $0x0,%eax
  802751:	e9 fa 00 00 00       	jmp    802850 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802756:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80275b:	85 c0                	test   %eax,%eax
  80275d:	74 0f                	je     80276e <sget+0x7f>
  80275f:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802765:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80276a:	39 c2                	cmp    %eax,%edx
  80276c:	73 0a                	jae    802778 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  80276e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802773:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802778:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80277d:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802782:	29 c2                	sub    %eax,%edx
  802784:	89 d0                	mov    %edx,%eax
  802786:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802789:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80278f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802794:	29 c2                	sub    %eax,%edx
  802796:	89 d0                	mov    %edx,%eax
  802798:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8027a1:	77 13                	ja     8027b6 <sget+0xc7>
  8027a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8027a9:	77 0b                	ja     8027b6 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8027ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ae:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8027b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8027b4:	73 0a                	jae    8027c0 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bb:	e9 90 00 00 00       	jmp    802850 <sget+0x161>

	void *va = NULL;
  8027c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  8027c7:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8027cc:	83 f8 05             	cmp    $0x5,%eax
  8027cf:	75 11                	jne    8027e2 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  8027d1:	83 ec 0c             	sub    $0xc,%esp
  8027d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8027d7:	e8 a3 f5 ff ff       	call   801d7f <alloc_pages_custom_fit>
  8027dc:	83 c4 10             	add    $0x10,%esp
  8027df:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8027e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027e6:	75 27                	jne    80280f <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8027e8:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8027ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027f2:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8027f5:	89 c2                	mov    %eax,%edx
  8027f7:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8027fc:	39 c2                	cmp    %eax,%edx
  8027fe:	73 07                	jae    802807 <sget+0x118>
			return NULL;
  802800:	b8 00 00 00 00       	mov    $0x0,%eax
  802805:	eb 49                	jmp    802850 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802807:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80280c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  80280f:	83 ec 04             	sub    $0x4,%esp
  802812:	ff 75 f0             	pushl  -0x10(%ebp)
  802815:	ff 75 0c             	pushl  0xc(%ebp)
  802818:	ff 75 08             	pushl  0x8(%ebp)
  80281b:	e8 af 02 00 00       	call   802acf <sys_get_shared_object>
  802820:	83 c4 10             	add    $0x10,%esp
  802823:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  802826:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80282a:	79 07                	jns    802833 <sget+0x144>
		return NULL;
  80282c:	b8 00 00 00 00       	mov    $0x0,%eax
  802831:	eb 1d                	jmp    802850 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  802833:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802838:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80283b:	75 10                	jne    80284d <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  80283d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	01 d0                	add    %edx,%eax
  802848:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  80284d:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  802850:	c9                   	leave  
  802851:	c3                   	ret    

00802852 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802852:	55                   	push   %ebp
  802853:	89 e5                	mov    %esp,%ebp
  802855:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802858:	e8 71 f9 ff ff       	call   8021ce <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80285d:	83 ec 04             	sub    $0x4,%esp
  802860:	68 68 4a 80 00       	push   $0x804a68
  802865:	68 19 02 00 00       	push   $0x219
  80286a:	68 45 46 80 00       	push   $0x804645
  80286f:	e8 3a df ff ff       	call   8007ae <_panic>

00802874 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
  802877:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80287a:	83 ec 04             	sub    $0x4,%esp
  80287d:	68 90 4a 80 00       	push   $0x804a90
  802882:	68 2b 02 00 00       	push   $0x22b
  802887:	68 45 46 80 00       	push   $0x804645
  80288c:	e8 1d df ff ff       	call   8007ae <_panic>

00802891 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802891:	55                   	push   %ebp
  802892:	89 e5                	mov    %esp,%ebp
  802894:	57                   	push   %edi
  802895:	56                   	push   %esi
  802896:	53                   	push   %ebx
  802897:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80289a:	8b 45 08             	mov    0x8(%ebp),%eax
  80289d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028a3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028a6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8028a9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8028ac:	cd 30                	int    $0x30
  8028ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8028b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8028b4:	83 c4 10             	add    $0x10,%esp
  8028b7:	5b                   	pop    %ebx
  8028b8:	5e                   	pop    %esi
  8028b9:	5f                   	pop    %edi
  8028ba:	5d                   	pop    %ebp
  8028bb:	c3                   	ret    

008028bc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8028bc:	55                   	push   %ebp
  8028bd:	89 e5                	mov    %esp,%ebp
  8028bf:	83 ec 04             	sub    $0x4,%esp
  8028c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8028c8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8028cb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d2:	6a 00                	push   $0x0
  8028d4:	51                   	push   %ecx
  8028d5:	52                   	push   %edx
  8028d6:	ff 75 0c             	pushl  0xc(%ebp)
  8028d9:	50                   	push   %eax
  8028da:	6a 00                	push   $0x0
  8028dc:	e8 b0 ff ff ff       	call   802891 <syscall>
  8028e1:	83 c4 18             	add    $0x18,%esp
}
  8028e4:	90                   	nop
  8028e5:	c9                   	leave  
  8028e6:	c3                   	ret    

008028e7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8028e7:	55                   	push   %ebp
  8028e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8028ea:	6a 00                	push   $0x0
  8028ec:	6a 00                	push   $0x0
  8028ee:	6a 00                	push   $0x0
  8028f0:	6a 00                	push   $0x0
  8028f2:	6a 00                	push   $0x0
  8028f4:	6a 02                	push   $0x2
  8028f6:	e8 96 ff ff ff       	call   802891 <syscall>
  8028fb:	83 c4 18             	add    $0x18,%esp
}
  8028fe:	c9                   	leave  
  8028ff:	c3                   	ret    

00802900 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802903:	6a 00                	push   $0x0
  802905:	6a 00                	push   $0x0
  802907:	6a 00                	push   $0x0
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 03                	push   $0x3
  80290f:	e8 7d ff ff ff       	call   802891 <syscall>
  802914:	83 c4 18             	add    $0x18,%esp
}
  802917:	90                   	nop
  802918:	c9                   	leave  
  802919:	c3                   	ret    

0080291a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80291a:	55                   	push   %ebp
  80291b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80291d:	6a 00                	push   $0x0
  80291f:	6a 00                	push   $0x0
  802921:	6a 00                	push   $0x0
  802923:	6a 00                	push   $0x0
  802925:	6a 00                	push   $0x0
  802927:	6a 04                	push   $0x4
  802929:	e8 63 ff ff ff       	call   802891 <syscall>
  80292e:	83 c4 18             	add    $0x18,%esp
}
  802931:	90                   	nop
  802932:	c9                   	leave  
  802933:	c3                   	ret    

00802934 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802934:	55                   	push   %ebp
  802935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80293a:	8b 45 08             	mov    0x8(%ebp),%eax
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	6a 00                	push   $0x0
  802943:	52                   	push   %edx
  802944:	50                   	push   %eax
  802945:	6a 08                	push   $0x8
  802947:	e8 45 ff ff ff       	call   802891 <syscall>
  80294c:	83 c4 18             	add    $0x18,%esp
}
  80294f:	c9                   	leave  
  802950:	c3                   	ret    

00802951 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802951:	55                   	push   %ebp
  802952:	89 e5                	mov    %esp,%ebp
  802954:	56                   	push   %esi
  802955:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802956:	8b 75 18             	mov    0x18(%ebp),%esi
  802959:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80295c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80295f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802962:	8b 45 08             	mov    0x8(%ebp),%eax
  802965:	56                   	push   %esi
  802966:	53                   	push   %ebx
  802967:	51                   	push   %ecx
  802968:	52                   	push   %edx
  802969:	50                   	push   %eax
  80296a:	6a 09                	push   $0x9
  80296c:	e8 20 ff ff ff       	call   802891 <syscall>
  802971:	83 c4 18             	add    $0x18,%esp
}
  802974:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802977:	5b                   	pop    %ebx
  802978:	5e                   	pop    %esi
  802979:	5d                   	pop    %ebp
  80297a:	c3                   	ret    

0080297b <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80297b:	55                   	push   %ebp
  80297c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80297e:	6a 00                	push   $0x0
  802980:	6a 00                	push   $0x0
  802982:	6a 00                	push   $0x0
  802984:	6a 00                	push   $0x0
  802986:	ff 75 08             	pushl  0x8(%ebp)
  802989:	6a 0a                	push   $0xa
  80298b:	e8 01 ff ff ff       	call   802891 <syscall>
  802990:	83 c4 18             	add    $0x18,%esp
}
  802993:	c9                   	leave  
  802994:	c3                   	ret    

00802995 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802995:	55                   	push   %ebp
  802996:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802998:	6a 00                	push   $0x0
  80299a:	6a 00                	push   $0x0
  80299c:	6a 00                	push   $0x0
  80299e:	ff 75 0c             	pushl  0xc(%ebp)
  8029a1:	ff 75 08             	pushl  0x8(%ebp)
  8029a4:	6a 0b                	push   $0xb
  8029a6:	e8 e6 fe ff ff       	call   802891 <syscall>
  8029ab:	83 c4 18             	add    $0x18,%esp
}
  8029ae:	c9                   	leave  
  8029af:	c3                   	ret    

008029b0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8029b0:	55                   	push   %ebp
  8029b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8029b3:	6a 00                	push   $0x0
  8029b5:	6a 00                	push   $0x0
  8029b7:	6a 00                	push   $0x0
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 00                	push   $0x0
  8029bd:	6a 0c                	push   $0xc
  8029bf:	e8 cd fe ff ff       	call   802891 <syscall>
  8029c4:	83 c4 18             	add    $0x18,%esp
}
  8029c7:	c9                   	leave  
  8029c8:	c3                   	ret    

008029c9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8029c9:	55                   	push   %ebp
  8029ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8029cc:	6a 00                	push   $0x0
  8029ce:	6a 00                	push   $0x0
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 0d                	push   $0xd
  8029d8:	e8 b4 fe ff ff       	call   802891 <syscall>
  8029dd:	83 c4 18             	add    $0x18,%esp
}
  8029e0:	c9                   	leave  
  8029e1:	c3                   	ret    

008029e2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8029e2:	55                   	push   %ebp
  8029e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8029e5:	6a 00                	push   $0x0
  8029e7:	6a 00                	push   $0x0
  8029e9:	6a 00                	push   $0x0
  8029eb:	6a 00                	push   $0x0
  8029ed:	6a 00                	push   $0x0
  8029ef:	6a 0e                	push   $0xe
  8029f1:	e8 9b fe ff ff       	call   802891 <syscall>
  8029f6:	83 c4 18             	add    $0x18,%esp
}
  8029f9:	c9                   	leave  
  8029fa:	c3                   	ret    

008029fb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8029fb:	55                   	push   %ebp
  8029fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 00                	push   $0x0
  802a02:	6a 00                	push   $0x0
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	6a 0f                	push   $0xf
  802a0a:	e8 82 fe ff ff       	call   802891 <syscall>
  802a0f:	83 c4 18             	add    $0x18,%esp
}
  802a12:	c9                   	leave  
  802a13:	c3                   	ret    

00802a14 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802a14:	55                   	push   %ebp
  802a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802a17:	6a 00                	push   $0x0
  802a19:	6a 00                	push   $0x0
  802a1b:	6a 00                	push   $0x0
  802a1d:	6a 00                	push   $0x0
  802a1f:	ff 75 08             	pushl  0x8(%ebp)
  802a22:	6a 10                	push   $0x10
  802a24:	e8 68 fe ff ff       	call   802891 <syscall>
  802a29:	83 c4 18             	add    $0x18,%esp
}
  802a2c:	c9                   	leave  
  802a2d:	c3                   	ret    

00802a2e <sys_scarce_memory>:

void sys_scarce_memory()
{
  802a2e:	55                   	push   %ebp
  802a2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802a31:	6a 00                	push   $0x0
  802a33:	6a 00                	push   $0x0
  802a35:	6a 00                	push   $0x0
  802a37:	6a 00                	push   $0x0
  802a39:	6a 00                	push   $0x0
  802a3b:	6a 11                	push   $0x11
  802a3d:	e8 4f fe ff ff       	call   802891 <syscall>
  802a42:	83 c4 18             	add    $0x18,%esp
}
  802a45:	90                   	nop
  802a46:	c9                   	leave  
  802a47:	c3                   	ret    

00802a48 <sys_cputc>:

void
sys_cputc(const char c)
{
  802a48:	55                   	push   %ebp
  802a49:	89 e5                	mov    %esp,%ebp
  802a4b:	83 ec 04             	sub    $0x4,%esp
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802a54:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a58:	6a 00                	push   $0x0
  802a5a:	6a 00                	push   $0x0
  802a5c:	6a 00                	push   $0x0
  802a5e:	6a 00                	push   $0x0
  802a60:	50                   	push   %eax
  802a61:	6a 01                	push   $0x1
  802a63:	e8 29 fe ff ff       	call   802891 <syscall>
  802a68:	83 c4 18             	add    $0x18,%esp
}
  802a6b:	90                   	nop
  802a6c:	c9                   	leave  
  802a6d:	c3                   	ret    

00802a6e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802a6e:	55                   	push   %ebp
  802a6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802a71:	6a 00                	push   $0x0
  802a73:	6a 00                	push   $0x0
  802a75:	6a 00                	push   $0x0
  802a77:	6a 00                	push   $0x0
  802a79:	6a 00                	push   $0x0
  802a7b:	6a 14                	push   $0x14
  802a7d:	e8 0f fe ff ff       	call   802891 <syscall>
  802a82:	83 c4 18             	add    $0x18,%esp
}
  802a85:	90                   	nop
  802a86:	c9                   	leave  
  802a87:	c3                   	ret    

00802a88 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802a88:	55                   	push   %ebp
  802a89:	89 e5                	mov    %esp,%ebp
  802a8b:	83 ec 04             	sub    $0x4,%esp
  802a8e:	8b 45 10             	mov    0x10(%ebp),%eax
  802a91:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802a94:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a97:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	6a 00                	push   $0x0
  802aa0:	51                   	push   %ecx
  802aa1:	52                   	push   %edx
  802aa2:	ff 75 0c             	pushl  0xc(%ebp)
  802aa5:	50                   	push   %eax
  802aa6:	6a 15                	push   $0x15
  802aa8:	e8 e4 fd ff ff       	call   802891 <syscall>
  802aad:	83 c4 18             	add    $0x18,%esp
}
  802ab0:	c9                   	leave  
  802ab1:	c3                   	ret    

00802ab2 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802ab2:	55                   	push   %ebp
  802ab3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	6a 00                	push   $0x0
  802abd:	6a 00                	push   $0x0
  802abf:	6a 00                	push   $0x0
  802ac1:	52                   	push   %edx
  802ac2:	50                   	push   %eax
  802ac3:	6a 16                	push   $0x16
  802ac5:	e8 c7 fd ff ff       	call   802891 <syscall>
  802aca:	83 c4 18             	add    $0x18,%esp
}
  802acd:	c9                   	leave  
  802ace:	c3                   	ret    

00802acf <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802acf:	55                   	push   %ebp
  802ad0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802ad2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  802adb:	6a 00                	push   $0x0
  802add:	6a 00                	push   $0x0
  802adf:	51                   	push   %ecx
  802ae0:	52                   	push   %edx
  802ae1:	50                   	push   %eax
  802ae2:	6a 17                	push   $0x17
  802ae4:	e8 a8 fd ff ff       	call   802891 <syscall>
  802ae9:	83 c4 18             	add    $0x18,%esp
}
  802aec:	c9                   	leave  
  802aed:	c3                   	ret    

00802aee <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802aee:	55                   	push   %ebp
  802aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	6a 00                	push   $0x0
  802af9:	6a 00                	push   $0x0
  802afb:	6a 00                	push   $0x0
  802afd:	52                   	push   %edx
  802afe:	50                   	push   %eax
  802aff:	6a 18                	push   $0x18
  802b01:	e8 8b fd ff ff       	call   802891 <syscall>
  802b06:	83 c4 18             	add    $0x18,%esp
}
  802b09:	c9                   	leave  
  802b0a:	c3                   	ret    

00802b0b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802b0b:	55                   	push   %ebp
  802b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	6a 00                	push   $0x0
  802b13:	ff 75 14             	pushl  0x14(%ebp)
  802b16:	ff 75 10             	pushl  0x10(%ebp)
  802b19:	ff 75 0c             	pushl  0xc(%ebp)
  802b1c:	50                   	push   %eax
  802b1d:	6a 19                	push   $0x19
  802b1f:	e8 6d fd ff ff       	call   802891 <syscall>
  802b24:	83 c4 18             	add    $0x18,%esp
}
  802b27:	c9                   	leave  
  802b28:	c3                   	ret    

00802b29 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802b29:	55                   	push   %ebp
  802b2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	6a 00                	push   $0x0
  802b31:	6a 00                	push   $0x0
  802b33:	6a 00                	push   $0x0
  802b35:	6a 00                	push   $0x0
  802b37:	50                   	push   %eax
  802b38:	6a 1a                	push   $0x1a
  802b3a:	e8 52 fd ff ff       	call   802891 <syscall>
  802b3f:	83 c4 18             	add    $0x18,%esp
}
  802b42:	90                   	nop
  802b43:	c9                   	leave  
  802b44:	c3                   	ret    

00802b45 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802b45:	55                   	push   %ebp
  802b46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	6a 00                	push   $0x0
  802b4d:	6a 00                	push   $0x0
  802b4f:	6a 00                	push   $0x0
  802b51:	6a 00                	push   $0x0
  802b53:	50                   	push   %eax
  802b54:	6a 1b                	push   $0x1b
  802b56:	e8 36 fd ff ff       	call   802891 <syscall>
  802b5b:	83 c4 18             	add    $0x18,%esp
}
  802b5e:	c9                   	leave  
  802b5f:	c3                   	ret    

00802b60 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802b60:	55                   	push   %ebp
  802b61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802b63:	6a 00                	push   $0x0
  802b65:	6a 00                	push   $0x0
  802b67:	6a 00                	push   $0x0
  802b69:	6a 00                	push   $0x0
  802b6b:	6a 00                	push   $0x0
  802b6d:	6a 05                	push   $0x5
  802b6f:	e8 1d fd ff ff       	call   802891 <syscall>
  802b74:	83 c4 18             	add    $0x18,%esp
}
  802b77:	c9                   	leave  
  802b78:	c3                   	ret    

00802b79 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802b79:	55                   	push   %ebp
  802b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802b7c:	6a 00                	push   $0x0
  802b7e:	6a 00                	push   $0x0
  802b80:	6a 00                	push   $0x0
  802b82:	6a 00                	push   $0x0
  802b84:	6a 00                	push   $0x0
  802b86:	6a 06                	push   $0x6
  802b88:	e8 04 fd ff ff       	call   802891 <syscall>
  802b8d:	83 c4 18             	add    $0x18,%esp
}
  802b90:	c9                   	leave  
  802b91:	c3                   	ret    

00802b92 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802b92:	55                   	push   %ebp
  802b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802b95:	6a 00                	push   $0x0
  802b97:	6a 00                	push   $0x0
  802b99:	6a 00                	push   $0x0
  802b9b:	6a 00                	push   $0x0
  802b9d:	6a 00                	push   $0x0
  802b9f:	6a 07                	push   $0x7
  802ba1:	e8 eb fc ff ff       	call   802891 <syscall>
  802ba6:	83 c4 18             	add    $0x18,%esp
}
  802ba9:	c9                   	leave  
  802baa:	c3                   	ret    

00802bab <sys_exit_env>:


void sys_exit_env(void)
{
  802bab:	55                   	push   %ebp
  802bac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802bae:	6a 00                	push   $0x0
  802bb0:	6a 00                	push   $0x0
  802bb2:	6a 00                	push   $0x0
  802bb4:	6a 00                	push   $0x0
  802bb6:	6a 00                	push   $0x0
  802bb8:	6a 1c                	push   $0x1c
  802bba:	e8 d2 fc ff ff       	call   802891 <syscall>
  802bbf:	83 c4 18             	add    $0x18,%esp
}
  802bc2:	90                   	nop
  802bc3:	c9                   	leave  
  802bc4:	c3                   	ret    

00802bc5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802bc5:	55                   	push   %ebp
  802bc6:	89 e5                	mov    %esp,%ebp
  802bc8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802bcb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802bce:	8d 50 04             	lea    0x4(%eax),%edx
  802bd1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802bd4:	6a 00                	push   $0x0
  802bd6:	6a 00                	push   $0x0
  802bd8:	6a 00                	push   $0x0
  802bda:	52                   	push   %edx
  802bdb:	50                   	push   %eax
  802bdc:	6a 1d                	push   $0x1d
  802bde:	e8 ae fc ff ff       	call   802891 <syscall>
  802be3:	83 c4 18             	add    $0x18,%esp
	return result;
  802be6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802be9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802bec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802bef:	89 01                	mov    %eax,(%ecx)
  802bf1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	c9                   	leave  
  802bf8:	c2 04 00             	ret    $0x4

00802bfb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802bfb:	55                   	push   %ebp
  802bfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802bfe:	6a 00                	push   $0x0
  802c00:	6a 00                	push   $0x0
  802c02:	ff 75 10             	pushl  0x10(%ebp)
  802c05:	ff 75 0c             	pushl  0xc(%ebp)
  802c08:	ff 75 08             	pushl  0x8(%ebp)
  802c0b:	6a 13                	push   $0x13
  802c0d:	e8 7f fc ff ff       	call   802891 <syscall>
  802c12:	83 c4 18             	add    $0x18,%esp
	return ;
  802c15:	90                   	nop
}
  802c16:	c9                   	leave  
  802c17:	c3                   	ret    

00802c18 <sys_rcr2>:
uint32 sys_rcr2()
{
  802c18:	55                   	push   %ebp
  802c19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802c1b:	6a 00                	push   $0x0
  802c1d:	6a 00                	push   $0x0
  802c1f:	6a 00                	push   $0x0
  802c21:	6a 00                	push   $0x0
  802c23:	6a 00                	push   $0x0
  802c25:	6a 1e                	push   $0x1e
  802c27:	e8 65 fc ff ff       	call   802891 <syscall>
  802c2c:	83 c4 18             	add    $0x18,%esp
}
  802c2f:	c9                   	leave  
  802c30:	c3                   	ret    

00802c31 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802c31:	55                   	push   %ebp
  802c32:	89 e5                	mov    %esp,%ebp
  802c34:	83 ec 04             	sub    $0x4,%esp
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802c3d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802c41:	6a 00                	push   $0x0
  802c43:	6a 00                	push   $0x0
  802c45:	6a 00                	push   $0x0
  802c47:	6a 00                	push   $0x0
  802c49:	50                   	push   %eax
  802c4a:	6a 1f                	push   $0x1f
  802c4c:	e8 40 fc ff ff       	call   802891 <syscall>
  802c51:	83 c4 18             	add    $0x18,%esp
	return ;
  802c54:	90                   	nop
}
  802c55:	c9                   	leave  
  802c56:	c3                   	ret    

00802c57 <rsttst>:
void rsttst()
{
  802c57:	55                   	push   %ebp
  802c58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802c5a:	6a 00                	push   $0x0
  802c5c:	6a 00                	push   $0x0
  802c5e:	6a 00                	push   $0x0
  802c60:	6a 00                	push   $0x0
  802c62:	6a 00                	push   $0x0
  802c64:	6a 21                	push   $0x21
  802c66:	e8 26 fc ff ff       	call   802891 <syscall>
  802c6b:	83 c4 18             	add    $0x18,%esp
	return ;
  802c6e:	90                   	nop
}
  802c6f:	c9                   	leave  
  802c70:	c3                   	ret    

00802c71 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802c71:	55                   	push   %ebp
  802c72:	89 e5                	mov    %esp,%ebp
  802c74:	83 ec 04             	sub    $0x4,%esp
  802c77:	8b 45 14             	mov    0x14(%ebp),%eax
  802c7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802c7d:	8b 55 18             	mov    0x18(%ebp),%edx
  802c80:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c84:	52                   	push   %edx
  802c85:	50                   	push   %eax
  802c86:	ff 75 10             	pushl  0x10(%ebp)
  802c89:	ff 75 0c             	pushl  0xc(%ebp)
  802c8c:	ff 75 08             	pushl  0x8(%ebp)
  802c8f:	6a 20                	push   $0x20
  802c91:	e8 fb fb ff ff       	call   802891 <syscall>
  802c96:	83 c4 18             	add    $0x18,%esp
	return ;
  802c99:	90                   	nop
}
  802c9a:	c9                   	leave  
  802c9b:	c3                   	ret    

00802c9c <chktst>:
void chktst(uint32 n)
{
  802c9c:	55                   	push   %ebp
  802c9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802c9f:	6a 00                	push   $0x0
  802ca1:	6a 00                	push   $0x0
  802ca3:	6a 00                	push   $0x0
  802ca5:	6a 00                	push   $0x0
  802ca7:	ff 75 08             	pushl  0x8(%ebp)
  802caa:	6a 22                	push   $0x22
  802cac:	e8 e0 fb ff ff       	call   802891 <syscall>
  802cb1:	83 c4 18             	add    $0x18,%esp
	return ;
  802cb4:	90                   	nop
}
  802cb5:	c9                   	leave  
  802cb6:	c3                   	ret    

00802cb7 <inctst>:

void inctst()
{
  802cb7:	55                   	push   %ebp
  802cb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802cba:	6a 00                	push   $0x0
  802cbc:	6a 00                	push   $0x0
  802cbe:	6a 00                	push   $0x0
  802cc0:	6a 00                	push   $0x0
  802cc2:	6a 00                	push   $0x0
  802cc4:	6a 23                	push   $0x23
  802cc6:	e8 c6 fb ff ff       	call   802891 <syscall>
  802ccb:	83 c4 18             	add    $0x18,%esp
	return ;
  802cce:	90                   	nop
}
  802ccf:	c9                   	leave  
  802cd0:	c3                   	ret    

00802cd1 <gettst>:
uint32 gettst()
{
  802cd1:	55                   	push   %ebp
  802cd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802cd4:	6a 00                	push   $0x0
  802cd6:	6a 00                	push   $0x0
  802cd8:	6a 00                	push   $0x0
  802cda:	6a 00                	push   $0x0
  802cdc:	6a 00                	push   $0x0
  802cde:	6a 24                	push   $0x24
  802ce0:	e8 ac fb ff ff       	call   802891 <syscall>
  802ce5:	83 c4 18             	add    $0x18,%esp
}
  802ce8:	c9                   	leave  
  802ce9:	c3                   	ret    

00802cea <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802cea:	55                   	push   %ebp
  802ceb:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ced:	6a 00                	push   $0x0
  802cef:	6a 00                	push   $0x0
  802cf1:	6a 00                	push   $0x0
  802cf3:	6a 00                	push   $0x0
  802cf5:	6a 00                	push   $0x0
  802cf7:	6a 25                	push   $0x25
  802cf9:	e8 93 fb ff ff       	call   802891 <syscall>
  802cfe:	83 c4 18             	add    $0x18,%esp
  802d01:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802d06:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802d0b:	c9                   	leave  
  802d0c:	c3                   	ret    

00802d0d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802d0d:	55                   	push   %ebp
  802d0e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802d18:	6a 00                	push   $0x0
  802d1a:	6a 00                	push   $0x0
  802d1c:	6a 00                	push   $0x0
  802d1e:	6a 00                	push   $0x0
  802d20:	ff 75 08             	pushl  0x8(%ebp)
  802d23:	6a 26                	push   $0x26
  802d25:	e8 67 fb ff ff       	call   802891 <syscall>
  802d2a:	83 c4 18             	add    $0x18,%esp
	return ;
  802d2d:	90                   	nop
}
  802d2e:	c9                   	leave  
  802d2f:	c3                   	ret    

00802d30 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802d30:	55                   	push   %ebp
  802d31:	89 e5                	mov    %esp,%ebp
  802d33:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802d34:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d37:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d40:	6a 00                	push   $0x0
  802d42:	53                   	push   %ebx
  802d43:	51                   	push   %ecx
  802d44:	52                   	push   %edx
  802d45:	50                   	push   %eax
  802d46:	6a 27                	push   $0x27
  802d48:	e8 44 fb ff ff       	call   802891 <syscall>
  802d4d:	83 c4 18             	add    $0x18,%esp
}
  802d50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d53:	c9                   	leave  
  802d54:	c3                   	ret    

00802d55 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802d55:	55                   	push   %ebp
  802d56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802d58:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	6a 00                	push   $0x0
  802d60:	6a 00                	push   $0x0
  802d62:	6a 00                	push   $0x0
  802d64:	52                   	push   %edx
  802d65:	50                   	push   %eax
  802d66:	6a 28                	push   $0x28
  802d68:	e8 24 fb ff ff       	call   802891 <syscall>
  802d6d:	83 c4 18             	add    $0x18,%esp
}
  802d70:	c9                   	leave  
  802d71:	c3                   	ret    

00802d72 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802d72:	55                   	push   %ebp
  802d73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802d75:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d78:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7e:	6a 00                	push   $0x0
  802d80:	51                   	push   %ecx
  802d81:	ff 75 10             	pushl  0x10(%ebp)
  802d84:	52                   	push   %edx
  802d85:	50                   	push   %eax
  802d86:	6a 29                	push   $0x29
  802d88:	e8 04 fb ff ff       	call   802891 <syscall>
  802d8d:	83 c4 18             	add    $0x18,%esp
}
  802d90:	c9                   	leave  
  802d91:	c3                   	ret    

00802d92 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802d92:	55                   	push   %ebp
  802d93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802d95:	6a 00                	push   $0x0
  802d97:	6a 00                	push   $0x0
  802d99:	ff 75 10             	pushl  0x10(%ebp)
  802d9c:	ff 75 0c             	pushl  0xc(%ebp)
  802d9f:	ff 75 08             	pushl  0x8(%ebp)
  802da2:	6a 12                	push   $0x12
  802da4:	e8 e8 fa ff ff       	call   802891 <syscall>
  802da9:	83 c4 18             	add    $0x18,%esp
	return ;
  802dac:	90                   	nop
}
  802dad:	c9                   	leave  
  802dae:	c3                   	ret    

00802daf <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802daf:	55                   	push   %ebp
  802db0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802db2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	6a 00                	push   $0x0
  802dba:	6a 00                	push   $0x0
  802dbc:	6a 00                	push   $0x0
  802dbe:	52                   	push   %edx
  802dbf:	50                   	push   %eax
  802dc0:	6a 2a                	push   $0x2a
  802dc2:	e8 ca fa ff ff       	call   802891 <syscall>
  802dc7:	83 c4 18             	add    $0x18,%esp
	return;
  802dca:	90                   	nop
}
  802dcb:	c9                   	leave  
  802dcc:	c3                   	ret    

00802dcd <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802dcd:	55                   	push   %ebp
  802dce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802dd0:	6a 00                	push   $0x0
  802dd2:	6a 00                	push   $0x0
  802dd4:	6a 00                	push   $0x0
  802dd6:	6a 00                	push   $0x0
  802dd8:	6a 00                	push   $0x0
  802dda:	6a 2b                	push   $0x2b
  802ddc:	e8 b0 fa ff ff       	call   802891 <syscall>
  802de1:	83 c4 18             	add    $0x18,%esp
}
  802de4:	c9                   	leave  
  802de5:	c3                   	ret    

00802de6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802de6:	55                   	push   %ebp
  802de7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802de9:	6a 00                	push   $0x0
  802deb:	6a 00                	push   $0x0
  802ded:	6a 00                	push   $0x0
  802def:	ff 75 0c             	pushl  0xc(%ebp)
  802df2:	ff 75 08             	pushl  0x8(%ebp)
  802df5:	6a 2d                	push   $0x2d
  802df7:	e8 95 fa ff ff       	call   802891 <syscall>
  802dfc:	83 c4 18             	add    $0x18,%esp
	return;
  802dff:	90                   	nop
}
  802e00:	c9                   	leave  
  802e01:	c3                   	ret    

00802e02 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802e02:	55                   	push   %ebp
  802e03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802e05:	6a 00                	push   $0x0
  802e07:	6a 00                	push   $0x0
  802e09:	6a 00                	push   $0x0
  802e0b:	ff 75 0c             	pushl  0xc(%ebp)
  802e0e:	ff 75 08             	pushl  0x8(%ebp)
  802e11:	6a 2c                	push   $0x2c
  802e13:	e8 79 fa ff ff       	call   802891 <syscall>
  802e18:	83 c4 18             	add    $0x18,%esp
	return ;
  802e1b:	90                   	nop
}
  802e1c:	c9                   	leave  
  802e1d:	c3                   	ret    

00802e1e <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802e1e:	55                   	push   %ebp
  802e1f:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802e21:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e24:	8b 45 08             	mov    0x8(%ebp),%eax
  802e27:	6a 00                	push   $0x0
  802e29:	6a 00                	push   $0x0
  802e2b:	6a 00                	push   $0x0
  802e2d:	52                   	push   %edx
  802e2e:	50                   	push   %eax
  802e2f:	6a 2e                	push   $0x2e
  802e31:	e8 5b fa ff ff       	call   802891 <syscall>
  802e36:	83 c4 18             	add    $0x18,%esp
	return ;
  802e39:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802e3a:	c9                   	leave  
  802e3b:	c3                   	ret    

00802e3c <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802e3c:	55                   	push   %ebp
  802e3d:	89 e5                	mov    %esp,%ebp
  802e3f:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802e42:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802e49:	72 09                	jb     802e54 <to_page_va+0x18>
  802e4b:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802e52:	72 14                	jb     802e68 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802e54:	83 ec 04             	sub    $0x4,%esp
  802e57:	68 b4 4a 80 00       	push   $0x804ab4
  802e5c:	6a 15                	push   $0x15
  802e5e:	68 df 4a 80 00       	push   $0x804adf
  802e63:	e8 46 d9 ff ff       	call   8007ae <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	ba 60 50 80 00       	mov    $0x805060,%edx
  802e70:	29 d0                	sub    %edx,%eax
  802e72:	c1 f8 02             	sar    $0x2,%eax
  802e75:	89 c2                	mov    %eax,%edx
  802e77:	89 d0                	mov    %edx,%eax
  802e79:	c1 e0 02             	shl    $0x2,%eax
  802e7c:	01 d0                	add    %edx,%eax
  802e7e:	c1 e0 02             	shl    $0x2,%eax
  802e81:	01 d0                	add    %edx,%eax
  802e83:	c1 e0 02             	shl    $0x2,%eax
  802e86:	01 d0                	add    %edx,%eax
  802e88:	89 c1                	mov    %eax,%ecx
  802e8a:	c1 e1 08             	shl    $0x8,%ecx
  802e8d:	01 c8                	add    %ecx,%eax
  802e8f:	89 c1                	mov    %eax,%ecx
  802e91:	c1 e1 10             	shl    $0x10,%ecx
  802e94:	01 c8                	add    %ecx,%eax
  802e96:	01 c0                	add    %eax,%eax
  802e98:	01 d0                	add    %edx,%eax
  802e9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	c1 e0 0c             	shl    $0xc,%eax
  802ea3:	89 c2                	mov    %eax,%edx
  802ea5:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802eaa:	01 d0                	add    %edx,%eax
}
  802eac:	c9                   	leave  
  802ead:	c3                   	ret    

00802eae <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802eae:	55                   	push   %ebp
  802eaf:	89 e5                	mov    %esp,%ebp
  802eb1:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802eb4:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ebc:	29 c2                	sub    %eax,%edx
  802ebe:	89 d0                	mov    %edx,%eax
  802ec0:	c1 e8 0c             	shr    $0xc,%eax
  802ec3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802ec6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eca:	78 09                	js     802ed5 <to_page_info+0x27>
  802ecc:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802ed3:	7e 14                	jle    802ee9 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802ed5:	83 ec 04             	sub    $0x4,%esp
  802ed8:	68 f8 4a 80 00       	push   $0x804af8
  802edd:	6a 22                	push   $0x22
  802edf:	68 df 4a 80 00       	push   $0x804adf
  802ee4:	e8 c5 d8 ff ff       	call   8007ae <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802ee9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eec:	89 d0                	mov    %edx,%eax
  802eee:	01 c0                	add    %eax,%eax
  802ef0:	01 d0                	add    %edx,%eax
  802ef2:	c1 e0 02             	shl    $0x2,%eax
  802ef5:	05 60 50 80 00       	add    $0x805060,%eax
}
  802efa:	c9                   	leave  
  802efb:	c3                   	ret    

00802efc <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802efc:	55                   	push   %ebp
  802efd:	89 e5                	mov    %esp,%ebp
  802eff:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802f02:	8b 45 08             	mov    0x8(%ebp),%eax
  802f05:	05 00 00 00 02       	add    $0x2000000,%eax
  802f0a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f0d:	73 16                	jae    802f25 <initialize_dynamic_allocator+0x29>
  802f0f:	68 1c 4b 80 00       	push   $0x804b1c
  802f14:	68 42 4b 80 00       	push   $0x804b42
  802f19:	6a 34                	push   $0x34
  802f1b:	68 df 4a 80 00       	push   $0x804adf
  802f20:	e8 89 d8 ff ff       	call   8007ae <_panic>
		is_initialized = 1;
  802f25:	c7 05 38 50 80 00 01 	movl   $0x1,0x805038
  802f2c:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3a:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802f3f:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802f46:	00 00 00 
  802f49:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802f50:	00 00 00 
  802f53:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802f5a:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802f5d:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802f64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f6b:	eb 36                	jmp    802fa3 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	c1 e0 04             	shl    $0x4,%eax
  802f73:	05 80 d0 81 00       	add    $0x81d080,%eax
  802f78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	c1 e0 04             	shl    $0x4,%eax
  802f84:	05 84 d0 81 00       	add    $0x81d084,%eax
  802f89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	c1 e0 04             	shl    $0x4,%eax
  802f95:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802fa0:	ff 45 f4             	incl   -0xc(%ebp)
  802fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802fa9:	72 c2                	jb     802f6d <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802fab:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802fb1:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802fb6:	29 c2                	sub    %eax,%edx
  802fb8:	89 d0                	mov    %edx,%eax
  802fba:	c1 e8 0c             	shr    $0xc,%eax
  802fbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802fc0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802fc7:	e9 c8 00 00 00       	jmp    803094 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802fcc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fcf:	89 d0                	mov    %edx,%eax
  802fd1:	01 c0                	add    %eax,%eax
  802fd3:	01 d0                	add    %edx,%eax
  802fd5:	c1 e0 02             	shl    $0x2,%eax
  802fd8:	05 68 50 80 00       	add    $0x805068,%eax
  802fdd:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802fe2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fe5:	89 d0                	mov    %edx,%eax
  802fe7:	01 c0                	add    %eax,%eax
  802fe9:	01 d0                	add    %edx,%eax
  802feb:	c1 e0 02             	shl    $0x2,%eax
  802fee:	05 6a 50 80 00       	add    $0x80506a,%eax
  802ff3:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802ff8:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802ffe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803001:	89 c8                	mov    %ecx,%eax
  803003:	01 c0                	add    %eax,%eax
  803005:	01 c8                	add    %ecx,%eax
  803007:	c1 e0 02             	shl    $0x2,%eax
  80300a:	05 64 50 80 00       	add    $0x805064,%eax
  80300f:	89 10                	mov    %edx,(%eax)
  803011:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803014:	89 d0                	mov    %edx,%eax
  803016:	01 c0                	add    %eax,%eax
  803018:	01 d0                	add    %edx,%eax
  80301a:	c1 e0 02             	shl    $0x2,%eax
  80301d:	05 64 50 80 00       	add    $0x805064,%eax
  803022:	8b 00                	mov    (%eax),%eax
  803024:	85 c0                	test   %eax,%eax
  803026:	74 1b                	je     803043 <initialize_dynamic_allocator+0x147>
  803028:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80302e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803031:	89 c8                	mov    %ecx,%eax
  803033:	01 c0                	add    %eax,%eax
  803035:	01 c8                	add    %ecx,%eax
  803037:	c1 e0 02             	shl    $0x2,%eax
  80303a:	05 60 50 80 00       	add    $0x805060,%eax
  80303f:	89 02                	mov    %eax,(%edx)
  803041:	eb 16                	jmp    803059 <initialize_dynamic_allocator+0x15d>
  803043:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803046:	89 d0                	mov    %edx,%eax
  803048:	01 c0                	add    %eax,%eax
  80304a:	01 d0                	add    %edx,%eax
  80304c:	c1 e0 02             	shl    $0x2,%eax
  80304f:	05 60 50 80 00       	add    $0x805060,%eax
  803054:	a3 48 50 80 00       	mov    %eax,0x805048
  803059:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80305c:	89 d0                	mov    %edx,%eax
  80305e:	01 c0                	add    %eax,%eax
  803060:	01 d0                	add    %edx,%eax
  803062:	c1 e0 02             	shl    $0x2,%eax
  803065:	05 60 50 80 00       	add    $0x805060,%eax
  80306a:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80306f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803072:	89 d0                	mov    %edx,%eax
  803074:	01 c0                	add    %eax,%eax
  803076:	01 d0                	add    %edx,%eax
  803078:	c1 e0 02             	shl    $0x2,%eax
  80307b:	05 60 50 80 00       	add    $0x805060,%eax
  803080:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803086:	a1 54 50 80 00       	mov    0x805054,%eax
  80308b:	40                   	inc    %eax
  80308c:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803091:	ff 45 f0             	incl   -0x10(%ebp)
  803094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803097:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80309a:	0f 82 2c ff ff ff    	jb     802fcc <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8030a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8030a6:	eb 2f                	jmp    8030d7 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  8030a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030ab:	89 d0                	mov    %edx,%eax
  8030ad:	01 c0                	add    %eax,%eax
  8030af:	01 d0                	add    %edx,%eax
  8030b1:	c1 e0 02             	shl    $0x2,%eax
  8030b4:	05 68 50 80 00       	add    $0x805068,%eax
  8030b9:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  8030be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030c1:	89 d0                	mov    %edx,%eax
  8030c3:	01 c0                	add    %eax,%eax
  8030c5:	01 d0                	add    %edx,%eax
  8030c7:	c1 e0 02             	shl    $0x2,%eax
  8030ca:	05 6a 50 80 00       	add    $0x80506a,%eax
  8030cf:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8030d4:	ff 45 ec             	incl   -0x14(%ebp)
  8030d7:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  8030de:	76 c8                	jbe    8030a8 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8030e0:	90                   	nop
  8030e1:	c9                   	leave  
  8030e2:	c3                   	ret    

008030e3 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8030e3:	55                   	push   %ebp
  8030e4:	89 e5                	mov    %esp,%ebp
  8030e6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  8030e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ec:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8030f1:	29 c2                	sub    %eax,%edx
  8030f3:	89 d0                	mov    %edx,%eax
  8030f5:	c1 e8 0c             	shr    $0xc,%eax
  8030f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  8030fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030fe:	89 d0                	mov    %edx,%eax
  803100:	01 c0                	add    %eax,%eax
  803102:	01 d0                	add    %edx,%eax
  803104:	c1 e0 02             	shl    $0x2,%eax
  803107:	05 68 50 80 00       	add    $0x805068,%eax
  80310c:	8b 00                	mov    (%eax),%eax
  80310e:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803111:	c9                   	leave  
  803112:	c3                   	ret    

00803113 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803113:	55                   	push   %ebp
  803114:	89 e5                	mov    %esp,%ebp
  803116:	83 ec 14             	sub    $0x14,%esp
  803119:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  80311c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803120:	77 07                	ja     803129 <nearest_pow2_ceil.1513+0x16>
  803122:	b8 01 00 00 00       	mov    $0x1,%eax
  803127:	eb 20                	jmp    803149 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803129:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  803130:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  803133:	eb 08                	jmp    80313d <nearest_pow2_ceil.1513+0x2a>
  803135:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803138:	01 c0                	add    %eax,%eax
  80313a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80313d:	d1 6d 08             	shrl   0x8(%ebp)
  803140:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803144:	75 ef                	jne    803135 <nearest_pow2_ceil.1513+0x22>
        return power;
  803146:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803149:	c9                   	leave  
  80314a:	c3                   	ret    

0080314b <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80314b:	55                   	push   %ebp
  80314c:	89 e5                	mov    %esp,%ebp
  80314e:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803151:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803158:	76 16                	jbe    803170 <alloc_block+0x25>
  80315a:	68 58 4b 80 00       	push   $0x804b58
  80315f:	68 42 4b 80 00       	push   $0x804b42
  803164:	6a 72                	push   $0x72
  803166:	68 df 4a 80 00       	push   $0x804adf
  80316b:	e8 3e d6 ff ff       	call   8007ae <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  803170:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803174:	75 0a                	jne    803180 <alloc_block+0x35>
  803176:	b8 00 00 00 00       	mov    $0x0,%eax
  80317b:	e9 bd 04 00 00       	jmp    80363d <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803180:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80318d:	73 06                	jae    803195 <alloc_block+0x4a>
        size = min_block_size;
  80318f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803192:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  803195:	83 ec 0c             	sub    $0xc,%esp
  803198:	8d 45 cc             	lea    -0x34(%ebp),%eax
  80319b:	ff 75 08             	pushl  0x8(%ebp)
  80319e:	89 c1                	mov    %eax,%ecx
  8031a0:	e8 6e ff ff ff       	call   803113 <nearest_pow2_ceil.1513>
  8031a5:	83 c4 10             	add    $0x10,%esp
  8031a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  8031ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ae:	83 ec 0c             	sub    $0xc,%esp
  8031b1:	8d 45 cc             	lea    -0x34(%ebp),%eax
  8031b4:	52                   	push   %edx
  8031b5:	89 c1                	mov    %eax,%ecx
  8031b7:	e8 83 04 00 00       	call   80363f <log2_ceil.1520>
  8031bc:	83 c4 10             	add    $0x10,%esp
  8031bf:	83 e8 03             	sub    $0x3,%eax
  8031c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  8031c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c8:	c1 e0 04             	shl    $0x4,%eax
  8031cb:	05 80 d0 81 00       	add    $0x81d080,%eax
  8031d0:	8b 00                	mov    (%eax),%eax
  8031d2:	85 c0                	test   %eax,%eax
  8031d4:	0f 84 d8 00 00 00    	je     8032b2 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8031da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031dd:	c1 e0 04             	shl    $0x4,%eax
  8031e0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8031e5:	8b 00                	mov    (%eax),%eax
  8031e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  8031ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031ee:	75 17                	jne    803207 <alloc_block+0xbc>
  8031f0:	83 ec 04             	sub    $0x4,%esp
  8031f3:	68 79 4b 80 00       	push   $0x804b79
  8031f8:	68 98 00 00 00       	push   $0x98
  8031fd:	68 df 4a 80 00       	push   $0x804adf
  803202:	e8 a7 d5 ff ff       	call   8007ae <_panic>
  803207:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	85 c0                	test   %eax,%eax
  80320e:	74 10                	je     803220 <alloc_block+0xd5>
  803210:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803218:	8b 52 04             	mov    0x4(%edx),%edx
  80321b:	89 50 04             	mov    %edx,0x4(%eax)
  80321e:	eb 14                	jmp    803234 <alloc_block+0xe9>
  803220:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803223:	8b 40 04             	mov    0x4(%eax),%eax
  803226:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803229:	c1 e2 04             	shl    $0x4,%edx
  80322c:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803232:	89 02                	mov    %eax,(%edx)
  803234:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803237:	8b 40 04             	mov    0x4(%eax),%eax
  80323a:	85 c0                	test   %eax,%eax
  80323c:	74 0f                	je     80324d <alloc_block+0x102>
  80323e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803241:	8b 40 04             	mov    0x4(%eax),%eax
  803244:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803247:	8b 12                	mov    (%edx),%edx
  803249:	89 10                	mov    %edx,(%eax)
  80324b:	eb 13                	jmp    803260 <alloc_block+0x115>
  80324d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803255:	c1 e2 04             	shl    $0x4,%edx
  803258:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80325e:	89 02                	mov    %eax,(%edx)
  803260:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803263:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803269:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80326c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803276:	c1 e0 04             	shl    $0x4,%eax
  803279:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80327e:	8b 00                	mov    (%eax),%eax
  803280:	8d 50 ff             	lea    -0x1(%eax),%edx
  803283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803286:	c1 e0 04             	shl    $0x4,%eax
  803289:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80328e:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803290:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803293:	83 ec 0c             	sub    $0xc,%esp
  803296:	50                   	push   %eax
  803297:	e8 12 fc ff ff       	call   802eae <to_page_info>
  80329c:	83 c4 10             	add    $0x10,%esp
  80329f:	89 c2                	mov    %eax,%edx
  8032a1:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8032a5:	48                   	dec    %eax
  8032a6:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  8032aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ad:	e9 8b 03 00 00       	jmp    80363d <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  8032b2:	a1 48 50 80 00       	mov    0x805048,%eax
  8032b7:	85 c0                	test   %eax,%eax
  8032b9:	0f 84 64 02 00 00    	je     803523 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  8032bf:	a1 48 50 80 00       	mov    0x805048,%eax
  8032c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  8032c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032cb:	75 17                	jne    8032e4 <alloc_block+0x199>
  8032cd:	83 ec 04             	sub    $0x4,%esp
  8032d0:	68 79 4b 80 00       	push   $0x804b79
  8032d5:	68 a0 00 00 00       	push   $0xa0
  8032da:	68 df 4a 80 00       	push   $0x804adf
  8032df:	e8 ca d4 ff ff       	call   8007ae <_panic>
  8032e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032e7:	8b 00                	mov    (%eax),%eax
  8032e9:	85 c0                	test   %eax,%eax
  8032eb:	74 10                	je     8032fd <alloc_block+0x1b2>
  8032ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f0:	8b 00                	mov    (%eax),%eax
  8032f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032f5:	8b 52 04             	mov    0x4(%edx),%edx
  8032f8:	89 50 04             	mov    %edx,0x4(%eax)
  8032fb:	eb 0b                	jmp    803308 <alloc_block+0x1bd>
  8032fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803300:	8b 40 04             	mov    0x4(%eax),%eax
  803303:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803308:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80330b:	8b 40 04             	mov    0x4(%eax),%eax
  80330e:	85 c0                	test   %eax,%eax
  803310:	74 0f                	je     803321 <alloc_block+0x1d6>
  803312:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803315:	8b 40 04             	mov    0x4(%eax),%eax
  803318:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80331b:	8b 12                	mov    (%edx),%edx
  80331d:	89 10                	mov    %edx,(%eax)
  80331f:	eb 0a                	jmp    80332b <alloc_block+0x1e0>
  803321:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803324:	8b 00                	mov    (%eax),%eax
  803326:	a3 48 50 80 00       	mov    %eax,0x805048
  80332b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80332e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803334:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803337:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333e:	a1 54 50 80 00       	mov    0x805054,%eax
  803343:	48                   	dec    %eax
  803344:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  803349:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80334f:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  803353:	b8 00 10 00 00       	mov    $0x1000,%eax
  803358:	99                   	cltd   
  803359:	f7 7d e8             	idivl  -0x18(%ebp)
  80335c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80335f:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  803363:	83 ec 0c             	sub    $0xc,%esp
  803366:	ff 75 dc             	pushl  -0x24(%ebp)
  803369:	e8 ce fa ff ff       	call   802e3c <to_page_va>
  80336e:	83 c4 10             	add    $0x10,%esp
  803371:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  803374:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803377:	83 ec 0c             	sub    $0xc,%esp
  80337a:	50                   	push   %eax
  80337b:	e8 c0 ee ff ff       	call   802240 <get_page>
  803380:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80338a:	e9 aa 00 00 00       	jmp    803439 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  80338f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803392:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  803396:	89 c2                	mov    %eax,%edx
  803398:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80339b:	01 d0                	add    %edx,%eax
  80339d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  8033a0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033a4:	75 17                	jne    8033bd <alloc_block+0x272>
  8033a6:	83 ec 04             	sub    $0x4,%esp
  8033a9:	68 98 4b 80 00       	push   $0x804b98
  8033ae:	68 aa 00 00 00       	push   $0xaa
  8033b3:	68 df 4a 80 00       	push   $0x804adf
  8033b8:	e8 f1 d3 ff ff       	call   8007ae <_panic>
  8033bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c0:	c1 e0 04             	shl    $0x4,%eax
  8033c3:	05 84 d0 81 00       	add    $0x81d084,%eax
  8033c8:	8b 10                	mov    (%eax),%edx
  8033ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033cd:	89 50 04             	mov    %edx,0x4(%eax)
  8033d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d3:	8b 40 04             	mov    0x4(%eax),%eax
  8033d6:	85 c0                	test   %eax,%eax
  8033d8:	74 14                	je     8033ee <alloc_block+0x2a3>
  8033da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033dd:	c1 e0 04             	shl    $0x4,%eax
  8033e0:	05 84 d0 81 00       	add    $0x81d084,%eax
  8033e5:	8b 00                	mov    (%eax),%eax
  8033e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033ea:	89 10                	mov    %edx,(%eax)
  8033ec:	eb 11                	jmp    8033ff <alloc_block+0x2b4>
  8033ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f1:	c1 e0 04             	shl    $0x4,%eax
  8033f4:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  8033fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033fd:	89 02                	mov    %eax,(%edx)
  8033ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803402:	c1 e0 04             	shl    $0x4,%eax
  803405:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  80340b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340e:	89 02                	mov    %eax,(%edx)
  803410:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803413:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803419:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341c:	c1 e0 04             	shl    $0x4,%eax
  80341f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803424:	8b 00                	mov    (%eax),%eax
  803426:	8d 50 01             	lea    0x1(%eax),%edx
  803429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342c:	c1 e0 04             	shl    $0x4,%eax
  80342f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803434:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803436:	ff 45 f4             	incl   -0xc(%ebp)
  803439:	b8 00 10 00 00       	mov    $0x1000,%eax
  80343e:	99                   	cltd   
  80343f:	f7 7d e8             	idivl  -0x18(%ebp)
  803442:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803445:	0f 8f 44 ff ff ff    	jg     80338f <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  80344b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80344e:	c1 e0 04             	shl    $0x4,%eax
  803451:	05 80 d0 81 00       	add    $0x81d080,%eax
  803456:	8b 00                	mov    (%eax),%eax
  803458:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  80345b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80345f:	75 17                	jne    803478 <alloc_block+0x32d>
  803461:	83 ec 04             	sub    $0x4,%esp
  803464:	68 79 4b 80 00       	push   $0x804b79
  803469:	68 ae 00 00 00       	push   $0xae
  80346e:	68 df 4a 80 00       	push   $0x804adf
  803473:	e8 36 d3 ff ff       	call   8007ae <_panic>
  803478:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80347b:	8b 00                	mov    (%eax),%eax
  80347d:	85 c0                	test   %eax,%eax
  80347f:	74 10                	je     803491 <alloc_block+0x346>
  803481:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803484:	8b 00                	mov    (%eax),%eax
  803486:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803489:	8b 52 04             	mov    0x4(%edx),%edx
  80348c:	89 50 04             	mov    %edx,0x4(%eax)
  80348f:	eb 14                	jmp    8034a5 <alloc_block+0x35a>
  803491:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803494:	8b 40 04             	mov    0x4(%eax),%eax
  803497:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80349a:	c1 e2 04             	shl    $0x4,%edx
  80349d:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8034a3:	89 02                	mov    %eax,(%edx)
  8034a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034a8:	8b 40 04             	mov    0x4(%eax),%eax
  8034ab:	85 c0                	test   %eax,%eax
  8034ad:	74 0f                	je     8034be <alloc_block+0x373>
  8034af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034b2:	8b 40 04             	mov    0x4(%eax),%eax
  8034b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8034b8:	8b 12                	mov    (%edx),%edx
  8034ba:	89 10                	mov    %edx,(%eax)
  8034bc:	eb 13                	jmp    8034d1 <alloc_block+0x386>
  8034be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034c1:	8b 00                	mov    (%eax),%eax
  8034c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034c6:	c1 e2 04             	shl    $0x4,%edx
  8034c9:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8034cf:	89 02                	mov    %eax,(%edx)
  8034d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e7:	c1 e0 04             	shl    $0x4,%eax
  8034ea:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8034ef:	8b 00                	mov    (%eax),%eax
  8034f1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8034f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f7:	c1 e0 04             	shl    $0x4,%eax
  8034fa:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8034ff:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803501:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803504:	83 ec 0c             	sub    $0xc,%esp
  803507:	50                   	push   %eax
  803508:	e8 a1 f9 ff ff       	call   802eae <to_page_info>
  80350d:	83 c4 10             	add    $0x10,%esp
  803510:	89 c2                	mov    %eax,%edx
  803512:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803516:	48                   	dec    %eax
  803517:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  80351b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80351e:	e9 1a 01 00 00       	jmp    80363d <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803523:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803526:	40                   	inc    %eax
  803527:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80352a:	e9 ed 00 00 00       	jmp    80361c <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  80352f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803532:	c1 e0 04             	shl    $0x4,%eax
  803535:	05 80 d0 81 00       	add    $0x81d080,%eax
  80353a:	8b 00                	mov    (%eax),%eax
  80353c:	85 c0                	test   %eax,%eax
  80353e:	0f 84 d5 00 00 00    	je     803619 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  803544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803547:	c1 e0 04             	shl    $0x4,%eax
  80354a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80354f:	8b 00                	mov    (%eax),%eax
  803551:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  803554:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803558:	75 17                	jne    803571 <alloc_block+0x426>
  80355a:	83 ec 04             	sub    $0x4,%esp
  80355d:	68 79 4b 80 00       	push   $0x804b79
  803562:	68 b8 00 00 00       	push   $0xb8
  803567:	68 df 4a 80 00       	push   $0x804adf
  80356c:	e8 3d d2 ff ff       	call   8007ae <_panic>
  803571:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803574:	8b 00                	mov    (%eax),%eax
  803576:	85 c0                	test   %eax,%eax
  803578:	74 10                	je     80358a <alloc_block+0x43f>
  80357a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80357d:	8b 00                	mov    (%eax),%eax
  80357f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803582:	8b 52 04             	mov    0x4(%edx),%edx
  803585:	89 50 04             	mov    %edx,0x4(%eax)
  803588:	eb 14                	jmp    80359e <alloc_block+0x453>
  80358a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80358d:	8b 40 04             	mov    0x4(%eax),%eax
  803590:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803593:	c1 e2 04             	shl    $0x4,%edx
  803596:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80359c:	89 02                	mov    %eax,(%edx)
  80359e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035a1:	8b 40 04             	mov    0x4(%eax),%eax
  8035a4:	85 c0                	test   %eax,%eax
  8035a6:	74 0f                	je     8035b7 <alloc_block+0x46c>
  8035a8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035ab:	8b 40 04             	mov    0x4(%eax),%eax
  8035ae:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8035b1:	8b 12                	mov    (%edx),%edx
  8035b3:	89 10                	mov    %edx,(%eax)
  8035b5:	eb 13                	jmp    8035ca <alloc_block+0x47f>
  8035b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035ba:	8b 00                	mov    (%eax),%eax
  8035bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035bf:	c1 e2 04             	shl    $0x4,%edx
  8035c2:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8035c8:	89 02                	mov    %eax,(%edx)
  8035ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e0:	c1 e0 04             	shl    $0x4,%eax
  8035e3:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8035e8:	8b 00                	mov    (%eax),%eax
  8035ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8035ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f0:	c1 e0 04             	shl    $0x4,%eax
  8035f3:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8035f8:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8035fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035fd:	83 ec 0c             	sub    $0xc,%esp
  803600:	50                   	push   %eax
  803601:	e8 a8 f8 ff ff       	call   802eae <to_page_info>
  803606:	83 c4 10             	add    $0x10,%esp
  803609:	89 c2                	mov    %eax,%edx
  80360b:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80360f:	48                   	dec    %eax
  803610:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  803614:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803617:	eb 24                	jmp    80363d <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803619:	ff 45 f0             	incl   -0x10(%ebp)
  80361c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803620:	0f 8e 09 ff ff ff    	jle    80352f <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  803626:	83 ec 04             	sub    $0x4,%esp
  803629:	68 bb 4b 80 00       	push   $0x804bbb
  80362e:	68 bf 00 00 00       	push   $0xbf
  803633:	68 df 4a 80 00       	push   $0x804adf
  803638:	e8 71 d1 ff ff       	call   8007ae <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  80363d:	c9                   	leave  
  80363e:	c3                   	ret    

0080363f <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  80363f:	55                   	push   %ebp
  803640:	89 e5                	mov    %esp,%ebp
  803642:	83 ec 14             	sub    $0x14,%esp
  803645:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  803648:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80364c:	75 07                	jne    803655 <log2_ceil.1520+0x16>
  80364e:	b8 00 00 00 00       	mov    $0x0,%eax
  803653:	eb 1b                	jmp    803670 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  803655:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  80365c:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  80365f:	eb 06                	jmp    803667 <log2_ceil.1520+0x28>
            x >>= 1;
  803661:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  803664:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  803667:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80366b:	75 f4                	jne    803661 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  80366d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803670:	c9                   	leave  
  803671:	c3                   	ret    

00803672 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  803672:	55                   	push   %ebp
  803673:	89 e5                	mov    %esp,%ebp
  803675:	83 ec 14             	sub    $0x14,%esp
  803678:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  80367b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80367f:	75 07                	jne    803688 <log2_ceil.1547+0x16>
  803681:	b8 00 00 00 00       	mov    $0x0,%eax
  803686:	eb 1b                	jmp    8036a3 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  803688:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  80368f:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  803692:	eb 06                	jmp    80369a <log2_ceil.1547+0x28>
			x >>= 1;
  803694:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  803697:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  80369a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80369e:	75 f4                	jne    803694 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8036a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8036a3:	c9                   	leave  
  8036a4:	c3                   	ret    

008036a5 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8036a5:	55                   	push   %ebp
  8036a6:	89 e5                	mov    %esp,%ebp
  8036a8:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8036ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ae:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8036b3:	39 c2                	cmp    %eax,%edx
  8036b5:	72 0c                	jb     8036c3 <free_block+0x1e>
  8036b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ba:	a1 40 50 80 00       	mov    0x805040,%eax
  8036bf:	39 c2                	cmp    %eax,%edx
  8036c1:	72 19                	jb     8036dc <free_block+0x37>
  8036c3:	68 c0 4b 80 00       	push   $0x804bc0
  8036c8:	68 42 4b 80 00       	push   $0x804b42
  8036cd:	68 d0 00 00 00       	push   $0xd0
  8036d2:	68 df 4a 80 00       	push   $0x804adf
  8036d7:	e8 d2 d0 ff ff       	call   8007ae <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8036dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e0:	0f 84 42 03 00 00    	je     803a28 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8036e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8036e9:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8036ee:	39 c2                	cmp    %eax,%edx
  8036f0:	72 0c                	jb     8036fe <free_block+0x59>
  8036f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f5:	a1 40 50 80 00       	mov    0x805040,%eax
  8036fa:	39 c2                	cmp    %eax,%edx
  8036fc:	72 17                	jb     803715 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8036fe:	83 ec 04             	sub    $0x4,%esp
  803701:	68 f8 4b 80 00       	push   $0x804bf8
  803706:	68 e6 00 00 00       	push   $0xe6
  80370b:	68 df 4a 80 00       	push   $0x804adf
  803710:	e8 99 d0 ff ff       	call   8007ae <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  803715:	8b 55 08             	mov    0x8(%ebp),%edx
  803718:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80371d:	29 c2                	sub    %eax,%edx
  80371f:	89 d0                	mov    %edx,%eax
  803721:	83 e0 07             	and    $0x7,%eax
  803724:	85 c0                	test   %eax,%eax
  803726:	74 17                	je     80373f <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803728:	83 ec 04             	sub    $0x4,%esp
  80372b:	68 2c 4c 80 00       	push   $0x804c2c
  803730:	68 ea 00 00 00       	push   $0xea
  803735:	68 df 4a 80 00       	push   $0x804adf
  80373a:	e8 6f d0 ff ff       	call   8007ae <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  80373f:	8b 45 08             	mov    0x8(%ebp),%eax
  803742:	83 ec 0c             	sub    $0xc,%esp
  803745:	50                   	push   %eax
  803746:	e8 63 f7 ff ff       	call   802eae <to_page_info>
  80374b:	83 c4 10             	add    $0x10,%esp
  80374e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  803751:	83 ec 0c             	sub    $0xc,%esp
  803754:	ff 75 08             	pushl  0x8(%ebp)
  803757:	e8 87 f9 ff ff       	call   8030e3 <get_block_size>
  80375c:	83 c4 10             	add    $0x10,%esp
  80375f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  803762:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803766:	75 17                	jne    80377f <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  803768:	83 ec 04             	sub    $0x4,%esp
  80376b:	68 58 4c 80 00       	push   $0x804c58
  803770:	68 f1 00 00 00       	push   $0xf1
  803775:	68 df 4a 80 00       	push   $0x804adf
  80377a:	e8 2f d0 ff ff       	call   8007ae <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  80377f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803782:	83 ec 0c             	sub    $0xc,%esp
  803785:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803788:	52                   	push   %edx
  803789:	89 c1                	mov    %eax,%ecx
  80378b:	e8 e2 fe ff ff       	call   803672 <log2_ceil.1547>
  803790:	83 c4 10             	add    $0x10,%esp
  803793:	83 e8 03             	sub    $0x3,%eax
  803796:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803799:	8b 45 08             	mov    0x8(%ebp),%eax
  80379c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  80379f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8037a3:	75 17                	jne    8037bc <free_block+0x117>
  8037a5:	83 ec 04             	sub    $0x4,%esp
  8037a8:	68 a4 4c 80 00       	push   $0x804ca4
  8037ad:	68 f6 00 00 00       	push   $0xf6
  8037b2:	68 df 4a 80 00       	push   $0x804adf
  8037b7:	e8 f2 cf ff ff       	call   8007ae <_panic>
  8037bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bf:	c1 e0 04             	shl    $0x4,%eax
  8037c2:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037c7:	8b 10                	mov    (%eax),%edx
  8037c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037cc:	89 10                	mov    %edx,(%eax)
  8037ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d1:	8b 00                	mov    (%eax),%eax
  8037d3:	85 c0                	test   %eax,%eax
  8037d5:	74 15                	je     8037ec <free_block+0x147>
  8037d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037da:	c1 e0 04             	shl    $0x4,%eax
  8037dd:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037e2:	8b 00                	mov    (%eax),%eax
  8037e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037e7:	89 50 04             	mov    %edx,0x4(%eax)
  8037ea:	eb 11                	jmp    8037fd <free_block+0x158>
  8037ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ef:	c1 e0 04             	shl    $0x4,%eax
  8037f2:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  8037f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037fb:	89 02                	mov    %eax,(%edx)
  8037fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803800:	c1 e0 04             	shl    $0x4,%eax
  803803:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803809:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80380c:	89 02                	mov    %eax,(%edx)
  80380e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803811:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803818:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381b:	c1 e0 04             	shl    $0x4,%eax
  80381e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803823:	8b 00                	mov    (%eax),%eax
  803825:	8d 50 01             	lea    0x1(%eax),%edx
  803828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382b:	c1 e0 04             	shl    $0x4,%eax
  80382e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803833:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  803835:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803838:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80383c:	40                   	inc    %eax
  80383d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803840:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  803844:	8b 55 08             	mov    0x8(%ebp),%edx
  803847:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80384c:	29 c2                	sub    %eax,%edx
  80384e:	89 d0                	mov    %edx,%eax
  803850:	c1 e8 0c             	shr    $0xc,%eax
  803853:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  803856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803859:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80385d:	0f b7 c8             	movzwl %ax,%ecx
  803860:	b8 00 10 00 00       	mov    $0x1000,%eax
  803865:	99                   	cltd   
  803866:	f7 7d e8             	idivl  -0x18(%ebp)
  803869:	39 c1                	cmp    %eax,%ecx
  80386b:	0f 85 b8 01 00 00    	jne    803a29 <free_block+0x384>
    	uint32 blocks_removed = 0;
  803871:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387b:	c1 e0 04             	shl    $0x4,%eax
  80387e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803883:	8b 00                	mov    (%eax),%eax
  803885:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803888:	e9 d5 00 00 00       	jmp    803962 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  80388d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803890:	8b 00                	mov    (%eax),%eax
  803892:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803895:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803898:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80389d:	29 c2                	sub    %eax,%edx
  80389f:	89 d0                	mov    %edx,%eax
  8038a1:	c1 e8 0c             	shr    $0xc,%eax
  8038a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  8038a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038aa:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8038ad:	0f 85 a9 00 00 00    	jne    80395c <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  8038b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038b7:	75 17                	jne    8038d0 <free_block+0x22b>
  8038b9:	83 ec 04             	sub    $0x4,%esp
  8038bc:	68 79 4b 80 00       	push   $0x804b79
  8038c1:	68 04 01 00 00       	push   $0x104
  8038c6:	68 df 4a 80 00       	push   $0x804adf
  8038cb:	e8 de ce ff ff       	call   8007ae <_panic>
  8038d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d3:	8b 00                	mov    (%eax),%eax
  8038d5:	85 c0                	test   %eax,%eax
  8038d7:	74 10                	je     8038e9 <free_block+0x244>
  8038d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038dc:	8b 00                	mov    (%eax),%eax
  8038de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038e1:	8b 52 04             	mov    0x4(%edx),%edx
  8038e4:	89 50 04             	mov    %edx,0x4(%eax)
  8038e7:	eb 14                	jmp    8038fd <free_block+0x258>
  8038e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ec:	8b 40 04             	mov    0x4(%eax),%eax
  8038ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038f2:	c1 e2 04             	shl    $0x4,%edx
  8038f5:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8038fb:	89 02                	mov    %eax,(%edx)
  8038fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803900:	8b 40 04             	mov    0x4(%eax),%eax
  803903:	85 c0                	test   %eax,%eax
  803905:	74 0f                	je     803916 <free_block+0x271>
  803907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80390a:	8b 40 04             	mov    0x4(%eax),%eax
  80390d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803910:	8b 12                	mov    (%edx),%edx
  803912:	89 10                	mov    %edx,(%eax)
  803914:	eb 13                	jmp    803929 <free_block+0x284>
  803916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803919:	8b 00                	mov    (%eax),%eax
  80391b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80391e:	c1 e2 04             	shl    $0x4,%edx
  803921:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803927:	89 02                	mov    %eax,(%edx)
  803929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80392c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803935:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80393c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393f:	c1 e0 04             	shl    $0x4,%eax
  803942:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803947:	8b 00                	mov    (%eax),%eax
  803949:	8d 50 ff             	lea    -0x1(%eax),%edx
  80394c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394f:	c1 e0 04             	shl    $0x4,%eax
  803952:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803957:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803959:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  80395c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80395f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803962:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803966:	0f 85 21 ff ff ff    	jne    80388d <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  80396c:	b8 00 10 00 00       	mov    $0x1000,%eax
  803971:	99                   	cltd   
  803972:	f7 7d e8             	idivl  -0x18(%ebp)
  803975:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803978:	74 17                	je     803991 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  80397a:	83 ec 04             	sub    $0x4,%esp
  80397d:	68 c8 4c 80 00       	push   $0x804cc8
  803982:	68 0c 01 00 00       	push   $0x10c
  803987:	68 df 4a 80 00       	push   $0x804adf
  80398c:	e8 1d ce ff ff       	call   8007ae <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803991:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803994:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  80399a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80399d:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8039a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8039a7:	75 17                	jne    8039c0 <free_block+0x31b>
  8039a9:	83 ec 04             	sub    $0x4,%esp
  8039ac:	68 98 4b 80 00       	push   $0x804b98
  8039b1:	68 11 01 00 00       	push   $0x111
  8039b6:	68 df 4a 80 00       	push   $0x804adf
  8039bb:	e8 ee cd ff ff       	call   8007ae <_panic>
  8039c0:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8039c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039c9:	89 50 04             	mov    %edx,0x4(%eax)
  8039cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039cf:	8b 40 04             	mov    0x4(%eax),%eax
  8039d2:	85 c0                	test   %eax,%eax
  8039d4:	74 0c                	je     8039e2 <free_block+0x33d>
  8039d6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8039db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039de:	89 10                	mov    %edx,(%eax)
  8039e0:	eb 08                	jmp    8039ea <free_block+0x345>
  8039e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039e5:	a3 48 50 80 00       	mov    %eax,0x805048
  8039ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039ed:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8039f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039fb:	a1 54 50 80 00       	mov    0x805054,%eax
  803a00:	40                   	inc    %eax
  803a01:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803a06:	83 ec 0c             	sub    $0xc,%esp
  803a09:	ff 75 ec             	pushl  -0x14(%ebp)
  803a0c:	e8 2b f4 ff ff       	call   802e3c <to_page_va>
  803a11:	83 c4 10             	add    $0x10,%esp
  803a14:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803a17:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a1a:	83 ec 0c             	sub    $0xc,%esp
  803a1d:	50                   	push   %eax
  803a1e:	e8 69 e8 ff ff       	call   80228c <return_page>
  803a23:	83 c4 10             	add    $0x10,%esp
  803a26:	eb 01                	jmp    803a29 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803a28:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803a29:	c9                   	leave  
  803a2a:	c3                   	ret    

00803a2b <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803a2b:	55                   	push   %ebp
  803a2c:	89 e5                	mov    %esp,%ebp
  803a2e:	83 ec 14             	sub    $0x14,%esp
  803a31:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803a34:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803a38:	77 07                	ja     803a41 <nearest_pow2_ceil.1572+0x16>
      return 1;
  803a3a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a3f:	eb 20                	jmp    803a61 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803a41:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803a48:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803a4b:	eb 08                	jmp    803a55 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a50:	01 c0                	add    %eax,%eax
  803a52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803a55:	d1 6d 08             	shrl   0x8(%ebp)
  803a58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a5c:	75 ef                	jne    803a4d <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803a5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803a61:	c9                   	leave  
  803a62:	c3                   	ret    

00803a63 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803a63:	55                   	push   %ebp
  803a64:	89 e5                	mov    %esp,%ebp
  803a66:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803a69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a6d:	75 13                	jne    803a82 <realloc_block+0x1f>
    return alloc_block(new_size);
  803a6f:	83 ec 0c             	sub    $0xc,%esp
  803a72:	ff 75 0c             	pushl  0xc(%ebp)
  803a75:	e8 d1 f6 ff ff       	call   80314b <alloc_block>
  803a7a:	83 c4 10             	add    $0x10,%esp
  803a7d:	e9 d9 00 00 00       	jmp    803b5b <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803a82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a86:	75 18                	jne    803aa0 <realloc_block+0x3d>
    free_block(va);
  803a88:	83 ec 0c             	sub    $0xc,%esp
  803a8b:	ff 75 08             	pushl  0x8(%ebp)
  803a8e:	e8 12 fc ff ff       	call   8036a5 <free_block>
  803a93:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803a96:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9b:	e9 bb 00 00 00       	jmp    803b5b <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803aa0:	83 ec 0c             	sub    $0xc,%esp
  803aa3:	ff 75 08             	pushl  0x8(%ebp)
  803aa6:	e8 38 f6 ff ff       	call   8030e3 <get_block_size>
  803aab:	83 c4 10             	add    $0x10,%esp
  803aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803ab1:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803abb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803abe:	73 06                	jae    803ac6 <realloc_block+0x63>
    new_size = min_block_size;
  803ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ac3:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803ac6:	83 ec 0c             	sub    $0xc,%esp
  803ac9:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803acc:	ff 75 0c             	pushl  0xc(%ebp)
  803acf:	89 c1                	mov    %eax,%ecx
  803ad1:	e8 55 ff ff ff       	call   803a2b <nearest_pow2_ceil.1572>
  803ad6:	83 c4 10             	add    $0x10,%esp
  803ad9:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803adc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803adf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803ae2:	75 05                	jne    803ae9 <realloc_block+0x86>
    return va;
  803ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae7:	eb 72                	jmp    803b5b <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803ae9:	83 ec 0c             	sub    $0xc,%esp
  803aec:	ff 75 0c             	pushl  0xc(%ebp)
  803aef:	e8 57 f6 ff ff       	call   80314b <alloc_block>
  803af4:	83 c4 10             	add    $0x10,%esp
  803af7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803afa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803afe:	75 07                	jne    803b07 <realloc_block+0xa4>
    return NULL;
  803b00:	b8 00 00 00 00       	mov    $0x0,%eax
  803b05:	eb 54                	jmp    803b5b <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803b07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b0d:	39 d0                	cmp    %edx,%eax
  803b0f:	76 02                	jbe    803b13 <realloc_block+0xb0>
  803b11:	89 d0                	mov    %edx,%eax
  803b13:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803b16:	8b 45 08             	mov    0x8(%ebp),%eax
  803b19:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803b22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803b29:	eb 17                	jmp    803b42 <realloc_block+0xdf>
    dst[i] = src[i];
  803b2b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b31:	01 c2                	add    %eax,%edx
  803b33:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b39:	01 c8                	add    %ecx,%eax
  803b3b:	8a 00                	mov    (%eax),%al
  803b3d:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803b3f:	ff 45 f4             	incl   -0xc(%ebp)
  803b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b45:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803b48:	72 e1                	jb     803b2b <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803b4a:	83 ec 0c             	sub    $0xc,%esp
  803b4d:	ff 75 08             	pushl  0x8(%ebp)
  803b50:	e8 50 fb ff ff       	call   8036a5 <free_block>
  803b55:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803b58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803b5b:	c9                   	leave  
  803b5c:	c3                   	ret    
  803b5d:	66 90                	xchg   %ax,%ax
  803b5f:	90                   	nop

00803b60 <__udivdi3>:
  803b60:	55                   	push   %ebp
  803b61:	57                   	push   %edi
  803b62:	56                   	push   %esi
  803b63:	53                   	push   %ebx
  803b64:	83 ec 1c             	sub    $0x1c,%esp
  803b67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b77:	89 ca                	mov    %ecx,%edx
  803b79:	89 f8                	mov    %edi,%eax
  803b7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b7f:	85 f6                	test   %esi,%esi
  803b81:	75 2d                	jne    803bb0 <__udivdi3+0x50>
  803b83:	39 cf                	cmp    %ecx,%edi
  803b85:	77 65                	ja     803bec <__udivdi3+0x8c>
  803b87:	89 fd                	mov    %edi,%ebp
  803b89:	85 ff                	test   %edi,%edi
  803b8b:	75 0b                	jne    803b98 <__udivdi3+0x38>
  803b8d:	b8 01 00 00 00       	mov    $0x1,%eax
  803b92:	31 d2                	xor    %edx,%edx
  803b94:	f7 f7                	div    %edi
  803b96:	89 c5                	mov    %eax,%ebp
  803b98:	31 d2                	xor    %edx,%edx
  803b9a:	89 c8                	mov    %ecx,%eax
  803b9c:	f7 f5                	div    %ebp
  803b9e:	89 c1                	mov    %eax,%ecx
  803ba0:	89 d8                	mov    %ebx,%eax
  803ba2:	f7 f5                	div    %ebp
  803ba4:	89 cf                	mov    %ecx,%edi
  803ba6:	89 fa                	mov    %edi,%edx
  803ba8:	83 c4 1c             	add    $0x1c,%esp
  803bab:	5b                   	pop    %ebx
  803bac:	5e                   	pop    %esi
  803bad:	5f                   	pop    %edi
  803bae:	5d                   	pop    %ebp
  803baf:	c3                   	ret    
  803bb0:	39 ce                	cmp    %ecx,%esi
  803bb2:	77 28                	ja     803bdc <__udivdi3+0x7c>
  803bb4:	0f bd fe             	bsr    %esi,%edi
  803bb7:	83 f7 1f             	xor    $0x1f,%edi
  803bba:	75 40                	jne    803bfc <__udivdi3+0x9c>
  803bbc:	39 ce                	cmp    %ecx,%esi
  803bbe:	72 0a                	jb     803bca <__udivdi3+0x6a>
  803bc0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bc4:	0f 87 9e 00 00 00    	ja     803c68 <__udivdi3+0x108>
  803bca:	b8 01 00 00 00       	mov    $0x1,%eax
  803bcf:	89 fa                	mov    %edi,%edx
  803bd1:	83 c4 1c             	add    $0x1c,%esp
  803bd4:	5b                   	pop    %ebx
  803bd5:	5e                   	pop    %esi
  803bd6:	5f                   	pop    %edi
  803bd7:	5d                   	pop    %ebp
  803bd8:	c3                   	ret    
  803bd9:	8d 76 00             	lea    0x0(%esi),%esi
  803bdc:	31 ff                	xor    %edi,%edi
  803bde:	31 c0                	xor    %eax,%eax
  803be0:	89 fa                	mov    %edi,%edx
  803be2:	83 c4 1c             	add    $0x1c,%esp
  803be5:	5b                   	pop    %ebx
  803be6:	5e                   	pop    %esi
  803be7:	5f                   	pop    %edi
  803be8:	5d                   	pop    %ebp
  803be9:	c3                   	ret    
  803bea:	66 90                	xchg   %ax,%ax
  803bec:	89 d8                	mov    %ebx,%eax
  803bee:	f7 f7                	div    %edi
  803bf0:	31 ff                	xor    %edi,%edi
  803bf2:	89 fa                	mov    %edi,%edx
  803bf4:	83 c4 1c             	add    $0x1c,%esp
  803bf7:	5b                   	pop    %ebx
  803bf8:	5e                   	pop    %esi
  803bf9:	5f                   	pop    %edi
  803bfa:	5d                   	pop    %ebp
  803bfb:	c3                   	ret    
  803bfc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c01:	89 eb                	mov    %ebp,%ebx
  803c03:	29 fb                	sub    %edi,%ebx
  803c05:	89 f9                	mov    %edi,%ecx
  803c07:	d3 e6                	shl    %cl,%esi
  803c09:	89 c5                	mov    %eax,%ebp
  803c0b:	88 d9                	mov    %bl,%cl
  803c0d:	d3 ed                	shr    %cl,%ebp
  803c0f:	89 e9                	mov    %ebp,%ecx
  803c11:	09 f1                	or     %esi,%ecx
  803c13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c17:	89 f9                	mov    %edi,%ecx
  803c19:	d3 e0                	shl    %cl,%eax
  803c1b:	89 c5                	mov    %eax,%ebp
  803c1d:	89 d6                	mov    %edx,%esi
  803c1f:	88 d9                	mov    %bl,%cl
  803c21:	d3 ee                	shr    %cl,%esi
  803c23:	89 f9                	mov    %edi,%ecx
  803c25:	d3 e2                	shl    %cl,%edx
  803c27:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c2b:	88 d9                	mov    %bl,%cl
  803c2d:	d3 e8                	shr    %cl,%eax
  803c2f:	09 c2                	or     %eax,%edx
  803c31:	89 d0                	mov    %edx,%eax
  803c33:	89 f2                	mov    %esi,%edx
  803c35:	f7 74 24 0c          	divl   0xc(%esp)
  803c39:	89 d6                	mov    %edx,%esi
  803c3b:	89 c3                	mov    %eax,%ebx
  803c3d:	f7 e5                	mul    %ebp
  803c3f:	39 d6                	cmp    %edx,%esi
  803c41:	72 19                	jb     803c5c <__udivdi3+0xfc>
  803c43:	74 0b                	je     803c50 <__udivdi3+0xf0>
  803c45:	89 d8                	mov    %ebx,%eax
  803c47:	31 ff                	xor    %edi,%edi
  803c49:	e9 58 ff ff ff       	jmp    803ba6 <__udivdi3+0x46>
  803c4e:	66 90                	xchg   %ax,%ax
  803c50:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c54:	89 f9                	mov    %edi,%ecx
  803c56:	d3 e2                	shl    %cl,%edx
  803c58:	39 c2                	cmp    %eax,%edx
  803c5a:	73 e9                	jae    803c45 <__udivdi3+0xe5>
  803c5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c5f:	31 ff                	xor    %edi,%edi
  803c61:	e9 40 ff ff ff       	jmp    803ba6 <__udivdi3+0x46>
  803c66:	66 90                	xchg   %ax,%ax
  803c68:	31 c0                	xor    %eax,%eax
  803c6a:	e9 37 ff ff ff       	jmp    803ba6 <__udivdi3+0x46>
  803c6f:	90                   	nop

00803c70 <__umoddi3>:
  803c70:	55                   	push   %ebp
  803c71:	57                   	push   %edi
  803c72:	56                   	push   %esi
  803c73:	53                   	push   %ebx
  803c74:	83 ec 1c             	sub    $0x1c,%esp
  803c77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c8f:	89 f3                	mov    %esi,%ebx
  803c91:	89 fa                	mov    %edi,%edx
  803c93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c97:	89 34 24             	mov    %esi,(%esp)
  803c9a:	85 c0                	test   %eax,%eax
  803c9c:	75 1a                	jne    803cb8 <__umoddi3+0x48>
  803c9e:	39 f7                	cmp    %esi,%edi
  803ca0:	0f 86 a2 00 00 00    	jbe    803d48 <__umoddi3+0xd8>
  803ca6:	89 c8                	mov    %ecx,%eax
  803ca8:	89 f2                	mov    %esi,%edx
  803caa:	f7 f7                	div    %edi
  803cac:	89 d0                	mov    %edx,%eax
  803cae:	31 d2                	xor    %edx,%edx
  803cb0:	83 c4 1c             	add    $0x1c,%esp
  803cb3:	5b                   	pop    %ebx
  803cb4:	5e                   	pop    %esi
  803cb5:	5f                   	pop    %edi
  803cb6:	5d                   	pop    %ebp
  803cb7:	c3                   	ret    
  803cb8:	39 f0                	cmp    %esi,%eax
  803cba:	0f 87 ac 00 00 00    	ja     803d6c <__umoddi3+0xfc>
  803cc0:	0f bd e8             	bsr    %eax,%ebp
  803cc3:	83 f5 1f             	xor    $0x1f,%ebp
  803cc6:	0f 84 ac 00 00 00    	je     803d78 <__umoddi3+0x108>
  803ccc:	bf 20 00 00 00       	mov    $0x20,%edi
  803cd1:	29 ef                	sub    %ebp,%edi
  803cd3:	89 fe                	mov    %edi,%esi
  803cd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cd9:	89 e9                	mov    %ebp,%ecx
  803cdb:	d3 e0                	shl    %cl,%eax
  803cdd:	89 d7                	mov    %edx,%edi
  803cdf:	89 f1                	mov    %esi,%ecx
  803ce1:	d3 ef                	shr    %cl,%edi
  803ce3:	09 c7                	or     %eax,%edi
  803ce5:	89 e9                	mov    %ebp,%ecx
  803ce7:	d3 e2                	shl    %cl,%edx
  803ce9:	89 14 24             	mov    %edx,(%esp)
  803cec:	89 d8                	mov    %ebx,%eax
  803cee:	d3 e0                	shl    %cl,%eax
  803cf0:	89 c2                	mov    %eax,%edx
  803cf2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cf6:	d3 e0                	shl    %cl,%eax
  803cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cfc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d00:	89 f1                	mov    %esi,%ecx
  803d02:	d3 e8                	shr    %cl,%eax
  803d04:	09 d0                	or     %edx,%eax
  803d06:	d3 eb                	shr    %cl,%ebx
  803d08:	89 da                	mov    %ebx,%edx
  803d0a:	f7 f7                	div    %edi
  803d0c:	89 d3                	mov    %edx,%ebx
  803d0e:	f7 24 24             	mull   (%esp)
  803d11:	89 c6                	mov    %eax,%esi
  803d13:	89 d1                	mov    %edx,%ecx
  803d15:	39 d3                	cmp    %edx,%ebx
  803d17:	0f 82 87 00 00 00    	jb     803da4 <__umoddi3+0x134>
  803d1d:	0f 84 91 00 00 00    	je     803db4 <__umoddi3+0x144>
  803d23:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d27:	29 f2                	sub    %esi,%edx
  803d29:	19 cb                	sbb    %ecx,%ebx
  803d2b:	89 d8                	mov    %ebx,%eax
  803d2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d31:	d3 e0                	shl    %cl,%eax
  803d33:	89 e9                	mov    %ebp,%ecx
  803d35:	d3 ea                	shr    %cl,%edx
  803d37:	09 d0                	or     %edx,%eax
  803d39:	89 e9                	mov    %ebp,%ecx
  803d3b:	d3 eb                	shr    %cl,%ebx
  803d3d:	89 da                	mov    %ebx,%edx
  803d3f:	83 c4 1c             	add    $0x1c,%esp
  803d42:	5b                   	pop    %ebx
  803d43:	5e                   	pop    %esi
  803d44:	5f                   	pop    %edi
  803d45:	5d                   	pop    %ebp
  803d46:	c3                   	ret    
  803d47:	90                   	nop
  803d48:	89 fd                	mov    %edi,%ebp
  803d4a:	85 ff                	test   %edi,%edi
  803d4c:	75 0b                	jne    803d59 <__umoddi3+0xe9>
  803d4e:	b8 01 00 00 00       	mov    $0x1,%eax
  803d53:	31 d2                	xor    %edx,%edx
  803d55:	f7 f7                	div    %edi
  803d57:	89 c5                	mov    %eax,%ebp
  803d59:	89 f0                	mov    %esi,%eax
  803d5b:	31 d2                	xor    %edx,%edx
  803d5d:	f7 f5                	div    %ebp
  803d5f:	89 c8                	mov    %ecx,%eax
  803d61:	f7 f5                	div    %ebp
  803d63:	89 d0                	mov    %edx,%eax
  803d65:	e9 44 ff ff ff       	jmp    803cae <__umoddi3+0x3e>
  803d6a:	66 90                	xchg   %ax,%ax
  803d6c:	89 c8                	mov    %ecx,%eax
  803d6e:	89 f2                	mov    %esi,%edx
  803d70:	83 c4 1c             	add    $0x1c,%esp
  803d73:	5b                   	pop    %ebx
  803d74:	5e                   	pop    %esi
  803d75:	5f                   	pop    %edi
  803d76:	5d                   	pop    %ebp
  803d77:	c3                   	ret    
  803d78:	3b 04 24             	cmp    (%esp),%eax
  803d7b:	72 06                	jb     803d83 <__umoddi3+0x113>
  803d7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d81:	77 0f                	ja     803d92 <__umoddi3+0x122>
  803d83:	89 f2                	mov    %esi,%edx
  803d85:	29 f9                	sub    %edi,%ecx
  803d87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d8b:	89 14 24             	mov    %edx,(%esp)
  803d8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d92:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d96:	8b 14 24             	mov    (%esp),%edx
  803d99:	83 c4 1c             	add    $0x1c,%esp
  803d9c:	5b                   	pop    %ebx
  803d9d:	5e                   	pop    %esi
  803d9e:	5f                   	pop    %edi
  803d9f:	5d                   	pop    %ebp
  803da0:	c3                   	ret    
  803da1:	8d 76 00             	lea    0x0(%esi),%esi
  803da4:	2b 04 24             	sub    (%esp),%eax
  803da7:	19 fa                	sbb    %edi,%edx
  803da9:	89 d1                	mov    %edx,%ecx
  803dab:	89 c6                	mov    %eax,%esi
  803dad:	e9 71 ff ff ff       	jmp    803d23 <__umoddi3+0xb3>
  803db2:	66 90                	xchg   %ax,%ax
  803db4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803db8:	72 ea                	jb     803da4 <__umoddi3+0x134>
  803dba:	89 d9                	mov    %ebx,%ecx
  803dbc:	e9 62 ff ff ff       	jmp    803d23 <__umoddi3+0xb3>
