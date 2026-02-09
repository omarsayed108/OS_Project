
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 21 07 00 00       	call   800757 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp

	do
	{
		//2012: lock the interrupt
		//sys_lock_cons();
		sys_lock_cons();
  800041:	e8 13 2a 00 00       	call   802a59 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 3f 80 00       	push   $0x803f20
  80004e:	e8 a2 0b 00 00       	call   800bf5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 3f 80 00       	push   $0x803f22
  80005e:	e8 92 0b 00 00       	call   800bf5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 38 3f 80 00       	push   $0x803f38
  80006e:	e8 82 0b 00 00       	call   800bf5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 3f 80 00       	push   $0x803f22
  80007e:	e8 72 0b 00 00       	call   800bf5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 3f 80 00       	push   $0x803f20
  80008e:	e8 62 0b 00 00       	call   800bf5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 50 3f 80 00       	push   $0x803f50
  8000a5:	e8 24 12 00 00       	call   8012ce <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			cprintf("Chose the initialization method:\n") ;
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 70 3f 80 00       	push   $0x803f70
  8000b5:	e8 3b 0b 00 00       	call   800bf5 <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	68 92 3f 80 00       	push   $0x803f92
  8000c5:	e8 2b 0b 00 00       	call   800bf5 <cprintf>
  8000ca:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	68 a0 3f 80 00       	push   $0x803fa0
  8000d5:	e8 1b 0b 00 00       	call   800bf5 <cprintf>
  8000da:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	68 af 3f 80 00       	push   $0x803faf
  8000e5:	e8 0b 0b 00 00       	call   800bf5 <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 bf 3f 80 00       	push   $0x803fbf
  8000f5:	e8 fb 0a 00 00       	call   800bf5 <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  8000fd:	e8 38 06 00 00       	call   80073a <getchar>
  800102:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800105:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	50                   	push   %eax
  80010d:	e8 09 06 00 00       	call   80071b <cputchar>
  800112:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	6a 0a                	push   $0xa
  80011a:	e8 fc 05 00 00       	call   80071b <cputchar>
  80011f:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800122:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800126:	74 0c                	je     800134 <_main+0xfc>
  800128:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80012c:	74 06                	je     800134 <_main+0xfc>
  80012e:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800132:	75 b9                	jne    8000ed <_main+0xb5>
		}
		sys_unlock_cons();
  800134:	e8 3a 29 00 00       	call   802a73 <sys_unlock_cons>
		//sys_unlock_cons();

		NumOfElements = strtol(Line, NULL, 10) ;
  800139:	83 ec 04             	sub    $0x4,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	6a 00                	push   $0x0
  800140:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800146:	50                   	push   %eax
  800147:	e8 99 17 00 00       	call   8018e5 <strtol>
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 c7 22 00 00       	call   802428 <malloc>
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
  800183:	e8 ea 01 00 00       	call   800372 <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 08 02 00 00       	call   8003a3 <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 2a 02 00 00       	call   8003d8 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 17 02 00 00       	call   8003d8 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d6 02 00 00       	call   8004aa <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		atomic_cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 c8 3f 80 00       	push   $0x803fc8
  8001df:	e8 83 0a 00 00       	call   800c67 <atomic_cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 d3 00 00 00       	call   8002c8 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 fc 3f 80 00       	push   $0x803ffc
  800209:	6a 4d                	push   $0x4d
  80020b:	68 1e 40 80 00       	push   $0x80401e
  800210:	e8 f2 06 00 00       	call   800907 <_panic>
		else
		{
			//sys_lock_cons();
			sys_lock_cons();
  800215:	e8 3f 28 00 00       	call   802a59 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 3c 40 80 00       	push   $0x80403c
  800222:	e8 ce 09 00 00       	call   800bf5 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 70 40 80 00       	push   $0x804070
  800232:	e8 be 09 00 00       	call   800bf5 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 a4 40 80 00       	push   $0x8040a4
  800242:	e8 ae 09 00 00       	call   800bf5 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  80024a:	e8 24 28 00 00       	call   802a73 <sys_unlock_cons>
			//sys_unlock_cons();
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 52 23 00 00       	call   8025ac <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  80025d:	e8 f7 27 00 00       	call   802a59 <sys_lock_cons>
		{
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 42                	jmp    8002aa <_main+0x272>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 d6 40 80 00       	push   $0x8040d6
  800270:	e8 80 09 00 00       	call   800bf5 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800278:	e8 bd 04 00 00       	call   80073a <getchar>
  80027d:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800280:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800284:	83 ec 0c             	sub    $0xc,%esp
  800287:	50                   	push   %eax
  800288:	e8 8e 04 00 00       	call   80071b <cputchar>
  80028d:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	6a 0a                	push   $0xa
  800295:	e8 81 04 00 00       	call   80071b <cputchar>
  80029a:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	6a 0a                	push   $0xa
  8002a2:	e8 74 04 00 00       	call   80071b <cputchar>
  8002a7:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002aa:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002ae:	74 06                	je     8002b6 <_main+0x27e>
  8002b0:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b4:	75 b2                	jne    800268 <_main+0x230>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b6:	e8 b8 27 00 00       	call   802a73 <sys_unlock_cons>
		//sys_unlock_cons();

	} while (Chose == 'y');
  8002bb:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bf:	0f 84 7c fd ff ff    	je     800041 <_main+0x9>

}
  8002c5:	90                   	nop
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002dc:	eb 33                	jmp    800311 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	8b 10                	mov    (%eax),%edx
  8002ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002f2:	40                   	inc    %eax
  8002f3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fd:	01 c8                	add    %ecx,%eax
  8002ff:	8b 00                	mov    (%eax),%eax
  800301:	39 c2                	cmp    %eax,%edx
  800303:	7e 09                	jle    80030e <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800305:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80030c:	eb 0c                	jmp    80031a <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030e:	ff 45 f8             	incl   -0x8(%ebp)
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	48                   	dec    %eax
  800315:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800318:	7f c4                	jg     8002de <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80031a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800325:	8b 45 0c             	mov    0xc(%ebp),%eax
  800328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 d0                	add    %edx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800343:	8b 45 08             	mov    0x8(%ebp),%eax
  800346:	01 c2                	add    %eax,%edx
  800348:	8b 45 10             	mov    0x10(%ebp),%eax
  80034b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	01 c8                	add    %ecx,%eax
  800357:	8b 00                	mov    (%eax),%eax
  800359:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80035b:	8b 45 10             	mov    0x10(%ebp),%eax
  80035e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	01 c2                	add    %eax,%edx
  80036a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80036d:	89 02                	mov    %eax,(%edx)
}
  80036f:	90                   	nop
  800370:	c9                   	leave  
  800371:	c3                   	ret    

00800372 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800378:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037f:	eb 17                	jmp    800398 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800381:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	01 c2                	add    %eax,%edx
  800390:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800393:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800395:	ff 45 fc             	incl   -0x4(%ebp)
  800398:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039e:	7c e1                	jl     800381 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003a0:	90                   	nop
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b0:	eb 1b                	jmp    8003cd <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	01 c2                	add    %eax,%edx
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c7:	48                   	dec    %eax
  8003c8:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003ca:	ff 45 fc             	incl   -0x4(%ebp)
  8003cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d3:	7c dd                	jl     8003b2 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d5:	90                   	nop
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003e1:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e6:	f7 e9                	imul   %ecx
  8003e8:	c1 f9 1f             	sar    $0x1f,%ecx
  8003eb:	89 d0                	mov    %edx,%eax
  8003ed:	29 c8                	sub    %ecx,%eax
  8003ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f9:	eb 1e                	jmp    800419 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80040b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040e:	99                   	cltd   
  80040f:	f7 7d f8             	idivl  -0x8(%ebp)
  800412:	89 d0                	mov    %edx,%eax
  800414:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800416:	ff 45 fc             	incl   -0x4(%ebp)
  800419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80041c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041f:	7c da                	jl     8003fb <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("i=%d\n",i);
	}

}
  800421:	90                   	nop
  800422:	c9                   	leave  
  800423:	c3                   	ret    

00800424 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80042a:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800431:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800438:	eb 42                	jmp    80047c <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80043a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043d:	99                   	cltd   
  80043e:	f7 7d f0             	idivl  -0x10(%ebp)
  800441:	89 d0                	mov    %edx,%eax
  800443:	85 c0                	test   %eax,%eax
  800445:	75 10                	jne    800457 <PrintElements+0x33>
			cprintf("\n");
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	68 20 3f 80 00       	push   $0x803f20
  80044f:	e8 a1 07 00 00       	call   800bf5 <cprintf>
  800454:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80045a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	01 d0                	add    %edx,%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	50                   	push   %eax
  80046c:	68 f4 40 80 00       	push   $0x8040f4
  800471:	e8 7f 07 00 00       	call   800bf5 <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800479:	ff 45 f4             	incl   -0xc(%ebp)
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	48                   	dec    %eax
  800480:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800483:	7f b5                	jg     80043a <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800488:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	01 d0                	add    %edx,%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	50                   	push   %eax
  80049a:	68 f9 40 80 00       	push   $0x8040f9
  80049f:	e8 51 07 00 00       	call   800bf5 <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp

}
  8004a7:	90                   	nop
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    

008004aa <MSort>:


void MSort(int* A, int p, int r)
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b6:	7d 54                	jge    80050c <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004be:	01 d0                	add    %edx,%eax
  8004c0:	89 c2                	mov    %eax,%edx
  8004c2:	c1 ea 1f             	shr    $0x1f,%edx
  8004c5:	01 d0                	add    %edx,%eax
  8004c7:	d1 f8                	sar    %eax
  8004c9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004cc:	83 ec 04             	sub    $0x4,%esp
  8004cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	e8 cd ff ff ff       	call   8004aa <MSort>
  8004dd:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e3:	40                   	inc    %eax
  8004e4:	83 ec 04             	sub    $0x4,%esp
  8004e7:	ff 75 10             	pushl  0x10(%ebp)
  8004ea:	50                   	push   %eax
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	e8 b7 ff ff ff       	call   8004aa <MSort>
  8004f3:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f6:	ff 75 10             	pushl  0x10(%ebp)
  8004f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fc:	ff 75 0c             	pushl  0xc(%ebp)
  8004ff:	ff 75 08             	pushl  0x8(%ebp)
  800502:	e8 08 00 00 00       	call   80050f <Merge>
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	eb 01                	jmp    80050d <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80050c:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800515:	8b 45 10             	mov    0x10(%ebp),%eax
  800518:	2b 45 0c             	sub    0xc(%ebp),%eax
  80051b:	40                   	inc    %eax
  80051c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	2b 45 10             	sub    0x10(%ebp),%eax
  800525:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800528:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800536:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800539:	c1 e0 02             	shl    $0x2,%eax
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	50                   	push   %eax
  800540:	e8 e3 1e 00 00       	call   802428 <malloc>
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  80054b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054e:	c1 e0 02             	shl    $0x2,%eax
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	50                   	push   %eax
  800555:	e8 ce 1e 00 00       	call   802428 <malloc>
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800560:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800567:	eb 2f                	jmp    800598 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800569:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80056c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800573:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800576:	01 c2                	add    %eax,%edx
  800578:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80057b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057e:	01 c8                	add    %ecx,%eax
  800580:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800585:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	01 c8                	add    %ecx,%eax
  800591:	8b 00                	mov    (%eax),%eax
  800593:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800595:	ff 45 ec             	incl   -0x14(%ebp)
  800598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059e:	7c c9                	jl     800569 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a7:	eb 2a                	jmp    8005d3 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b6:	01 c2                	add    %eax,%edx
  8005b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005be:	01 c8                	add    %ecx,%eax
  8005c0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ca:	01 c8                	add    %ecx,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005d0:	ff 45 e8             	incl   -0x18(%ebp)
  8005d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d9:	7c ce                	jl     8005a9 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e1:	e9 0a 01 00 00       	jmp    8006f0 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005ec:	0f 8d 95 00 00 00    	jge    800687 <Merge+0x178>
  8005f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f8:	0f 8d 89 00 00 00    	jge    800687 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800601:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800608:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	8b 10                	mov    (%eax),%edx
  80060f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800612:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800619:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80061c:	01 c8                	add    %ecx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	39 c2                	cmp    %eax,%edx
  800622:	7d 33                	jge    800657 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800627:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80062c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80063c:	8d 50 01             	lea    0x1(%eax),%edx
  80063f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800642:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800649:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80064c:	01 d0                	add    %edx,%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800652:	e9 96 00 00 00       	jmp    8006ed <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80065a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066f:	8d 50 01             	lea    0x1(%eax),%edx
  800672:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800675:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067f:	01 d0                	add    %edx,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800685:	eb 66                	jmp    8006ed <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80068d:	7d 30                	jge    8006bf <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800692:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800697:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a7:	8d 50 01             	lea    0x1(%eax),%edx
  8006aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b7:	01 d0                	add    %edx,%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	89 01                	mov    %eax,(%ecx)
  8006bd:	eb 2e                	jmp    8006ed <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d7:	8d 50 01             	lea    0x1(%eax),%edx
  8006da:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006ed:	ff 45 e4             	incl   -0x1c(%ebp)
  8006f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f3:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f6:	0f 8e ea fe ff ff    	jle    8005e6 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800702:	e8 a5 1e 00 00       	call   8025ac <free>
  800707:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800710:	e8 97 1e 00 00       	call   8025ac <free>
  800715:	83 c4 10             	add    $0x10,%esp

}
  800718:	90                   	nop
  800719:	c9                   	leave  
  80071a:	c3                   	ret    

0080071b <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
  80071e:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800727:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072b:	83 ec 0c             	sub    $0xc,%esp
  80072e:	50                   	push   %eax
  80072f:	e8 6d 24 00 00       	call   802ba1 <sys_cputc>
  800734:	83 c4 10             	add    $0x10,%esp
}
  800737:	90                   	nop
  800738:	c9                   	leave  
  800739:	c3                   	ret    

0080073a <getchar>:


int
getchar(void)
{
  80073a:	55                   	push   %ebp
  80073b:	89 e5                	mov    %esp,%ebp
  80073d:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800740:	e8 fb 22 00 00       	call   802a40 <sys_cgetc>
  800745:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800748:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <iscons>:

int iscons(int fdnum)
{
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800750:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800755:	5d                   	pop    %ebp
  800756:	c3                   	ret    

00800757 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	57                   	push   %edi
  80075b:	56                   	push   %esi
  80075c:	53                   	push   %ebx
  80075d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800760:	e8 6d 25 00 00       	call   802cd2 <sys_getenvindex>
  800765:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800768:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80076b:	89 d0                	mov    %edx,%eax
  80076d:	01 c0                	add    %eax,%eax
  80076f:	01 d0                	add    %edx,%eax
  800771:	c1 e0 02             	shl    $0x2,%eax
  800774:	01 d0                	add    %edx,%eax
  800776:	c1 e0 02             	shl    $0x2,%eax
  800779:	01 d0                	add    %edx,%eax
  80077b:	c1 e0 03             	shl    $0x3,%eax
  80077e:	01 d0                	add    %edx,%eax
  800780:	c1 e0 02             	shl    $0x2,%eax
  800783:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800788:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80078d:	a1 24 50 80 00       	mov    0x805024,%eax
  800792:	8a 40 20             	mov    0x20(%eax),%al
  800795:	84 c0                	test   %al,%al
  800797:	74 0d                	je     8007a6 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800799:	a1 24 50 80 00       	mov    0x805024,%eax
  80079e:	83 c0 20             	add    $0x20,%eax
  8007a1:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007aa:	7e 0a                	jle    8007b6 <libmain+0x5f>
		binaryname = argv[0];
  8007ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 0c             	pushl  0xc(%ebp)
  8007bc:	ff 75 08             	pushl  0x8(%ebp)
  8007bf:	e8 74 f8 ff ff       	call   800038 <_main>
  8007c4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007c7:	a1 00 50 80 00       	mov    0x805000,%eax
  8007cc:	85 c0                	test   %eax,%eax
  8007ce:	0f 84 01 01 00 00    	je     8008d5 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007d4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007da:	bb f8 41 80 00       	mov    $0x8041f8,%ebx
  8007df:	ba 0e 00 00 00       	mov    $0xe,%edx
  8007e4:	89 c7                	mov    %eax,%edi
  8007e6:	89 de                	mov    %ebx,%esi
  8007e8:	89 d1                	mov    %edx,%ecx
  8007ea:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8007ec:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8007ef:	b9 56 00 00 00       	mov    $0x56,%ecx
  8007f4:	b0 00                	mov    $0x0,%al
  8007f6:	89 d7                	mov    %edx,%edi
  8007f8:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8007fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800801:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800804:	83 ec 08             	sub    $0x8,%esp
  800807:	50                   	push   %eax
  800808:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80080e:	50                   	push   %eax
  80080f:	e8 f4 26 00 00       	call   802f08 <sys_utilities>
  800814:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800817:	e8 3d 22 00 00       	call   802a59 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80081c:	83 ec 0c             	sub    $0xc,%esp
  80081f:	68 18 41 80 00       	push   $0x804118
  800824:	e8 cc 03 00 00       	call   800bf5 <cprintf>
  800829:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80082c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80082f:	85 c0                	test   %eax,%eax
  800831:	74 18                	je     80084b <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800833:	e8 ee 26 00 00       	call   802f26 <sys_get_optimal_num_faults>
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	50                   	push   %eax
  80083c:	68 40 41 80 00       	push   $0x804140
  800841:	e8 af 03 00 00       	call   800bf5 <cprintf>
  800846:	83 c4 10             	add    $0x10,%esp
  800849:	eb 59                	jmp    8008a4 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80084b:	a1 24 50 80 00       	mov    0x805024,%eax
  800850:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800856:	a1 24 50 80 00       	mov    0x805024,%eax
  80085b:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800861:	83 ec 04             	sub    $0x4,%esp
  800864:	52                   	push   %edx
  800865:	50                   	push   %eax
  800866:	68 64 41 80 00       	push   $0x804164
  80086b:	e8 85 03 00 00       	call   800bf5 <cprintf>
  800870:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800873:	a1 24 50 80 00       	mov    0x805024,%eax
  800878:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  80087e:	a1 24 50 80 00       	mov    0x805024,%eax
  800883:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800889:	a1 24 50 80 00       	mov    0x805024,%eax
  80088e:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800894:	51                   	push   %ecx
  800895:	52                   	push   %edx
  800896:	50                   	push   %eax
  800897:	68 8c 41 80 00       	push   $0x80418c
  80089c:	e8 54 03 00 00       	call   800bf5 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008a9:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	50                   	push   %eax
  8008b3:	68 e4 41 80 00       	push   $0x8041e4
  8008b8:	e8 38 03 00 00       	call   800bf5 <cprintf>
  8008bd:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	68 18 41 80 00       	push   $0x804118
  8008c8:	e8 28 03 00 00       	call   800bf5 <cprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008d0:	e8 9e 21 00 00       	call   802a73 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008d5:	e8 1f 00 00 00       	call   8008f9 <exit>
}
  8008da:	90                   	nop
  8008db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008de:	5b                   	pop    %ebx
  8008df:	5e                   	pop    %esi
  8008e0:	5f                   	pop    %edi
  8008e1:	5d                   	pop    %ebp
  8008e2:	c3                   	ret    

008008e3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008e9:	83 ec 0c             	sub    $0xc,%esp
  8008ec:	6a 00                	push   $0x0
  8008ee:	e8 ab 23 00 00       	call   802c9e <sys_destroy_env>
  8008f3:	83 c4 10             	add    $0x10,%esp
}
  8008f6:	90                   	nop
  8008f7:	c9                   	leave  
  8008f8:	c3                   	ret    

008008f9 <exit>:

void
exit(void)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008ff:	e8 00 24 00 00       	call   802d04 <sys_exit_env>
}
  800904:	90                   	nop
  800905:	c9                   	leave  
  800906:	c3                   	ret    

00800907 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80090d:	8d 45 10             	lea    0x10(%ebp),%eax
  800910:	83 c0 04             	add    $0x4,%eax
  800913:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800916:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80091b:	85 c0                	test   %eax,%eax
  80091d:	74 16                	je     800935 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80091f:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	50                   	push   %eax
  800928:	68 5c 42 80 00       	push   $0x80425c
  80092d:	e8 c3 02 00 00       	call   800bf5 <cprintf>
  800932:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800935:	a1 04 50 80 00       	mov    0x805004,%eax
  80093a:	83 ec 0c             	sub    $0xc,%esp
  80093d:	ff 75 0c             	pushl  0xc(%ebp)
  800940:	ff 75 08             	pushl  0x8(%ebp)
  800943:	50                   	push   %eax
  800944:	68 64 42 80 00       	push   $0x804264
  800949:	6a 74                	push   $0x74
  80094b:	e8 d2 02 00 00       	call   800c22 <cprintf_colored>
  800950:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800953:	8b 45 10             	mov    0x10(%ebp),%eax
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 f4             	pushl  -0xc(%ebp)
  80095c:	50                   	push   %eax
  80095d:	e8 24 02 00 00       	call   800b86 <vcprintf>
  800962:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	6a 00                	push   $0x0
  80096a:	68 8c 42 80 00       	push   $0x80428c
  80096f:	e8 12 02 00 00       	call   800b86 <vcprintf>
  800974:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800977:	e8 7d ff ff ff       	call   8008f9 <exit>

	// should not return here
	while (1) ;
  80097c:	eb fe                	jmp    80097c <_panic+0x75>

0080097e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	53                   	push   %ebx
  800982:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800985:	a1 24 50 80 00       	mov    0x805024,%eax
  80098a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	39 c2                	cmp    %eax,%edx
  800995:	74 14                	je     8009ab <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800997:	83 ec 04             	sub    $0x4,%esp
  80099a:	68 90 42 80 00       	push   $0x804290
  80099f:	6a 26                	push   $0x26
  8009a1:	68 dc 42 80 00       	push   $0x8042dc
  8009a6:	e8 5c ff ff ff       	call   800907 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b9:	e9 d9 00 00 00       	jmp    800a97 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8009be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	01 d0                	add    %edx,%eax
  8009cd:	8b 00                	mov    (%eax),%eax
  8009cf:	85 c0                	test   %eax,%eax
  8009d1:	75 08                	jne    8009db <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8009d3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009d6:	e9 b9 00 00 00       	jmp    800a94 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8009db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009e9:	eb 79                	jmp    800a64 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009eb:	a1 24 50 80 00       	mov    0x805024,%eax
  8009f0:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8009f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f9:	89 d0                	mov    %edx,%eax
  8009fb:	01 c0                	add    %eax,%eax
  8009fd:	01 d0                	add    %edx,%eax
  8009ff:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800a06:	01 d8                	add    %ebx,%eax
  800a08:	01 d0                	add    %edx,%eax
  800a0a:	01 c8                	add    %ecx,%eax
  800a0c:	8a 40 04             	mov    0x4(%eax),%al
  800a0f:	84 c0                	test   %al,%al
  800a11:	75 4e                	jne    800a61 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a13:	a1 24 50 80 00       	mov    0x805024,%eax
  800a18:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800a1e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a21:	89 d0                	mov    %edx,%eax
  800a23:	01 c0                	add    %eax,%eax
  800a25:	01 d0                	add    %edx,%eax
  800a27:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800a2e:	01 d8                	add    %ebx,%eax
  800a30:	01 d0                	add    %edx,%eax
  800a32:	01 c8                	add    %ecx,%eax
  800a34:	8b 00                	mov    (%eax),%eax
  800a36:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a3c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a41:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a46:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	01 c8                	add    %ecx,%eax
  800a52:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a54:	39 c2                	cmp    %eax,%edx
  800a56:	75 09                	jne    800a61 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800a58:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a5f:	eb 19                	jmp    800a7a <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a61:	ff 45 e8             	incl   -0x18(%ebp)
  800a64:	a1 24 50 80 00       	mov    0x805024,%eax
  800a69:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a72:	39 c2                	cmp    %eax,%edx
  800a74:	0f 87 71 ff ff ff    	ja     8009eb <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a7e:	75 14                	jne    800a94 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800a80:	83 ec 04             	sub    $0x4,%esp
  800a83:	68 e8 42 80 00       	push   $0x8042e8
  800a88:	6a 3a                	push   $0x3a
  800a8a:	68 dc 42 80 00       	push   $0x8042dc
  800a8f:	e8 73 fe ff ff       	call   800907 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a94:	ff 45 f0             	incl   -0x10(%ebp)
  800a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a9d:	0f 8c 1b ff ff ff    	jl     8009be <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800aa3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aaa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ab1:	eb 2e                	jmp    800ae1 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ab3:	a1 24 50 80 00       	mov    0x805024,%eax
  800ab8:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800abe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ac1:	89 d0                	mov    %edx,%eax
  800ac3:	01 c0                	add    %eax,%eax
  800ac5:	01 d0                	add    %edx,%eax
  800ac7:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800ace:	01 d8                	add    %ebx,%eax
  800ad0:	01 d0                	add    %edx,%eax
  800ad2:	01 c8                	add    %ecx,%eax
  800ad4:	8a 40 04             	mov    0x4(%eax),%al
  800ad7:	3c 01                	cmp    $0x1,%al
  800ad9:	75 03                	jne    800ade <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800adb:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ade:	ff 45 e0             	incl   -0x20(%ebp)
  800ae1:	a1 24 50 80 00       	mov    0x805024,%eax
  800ae6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800aec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aef:	39 c2                	cmp    %eax,%edx
  800af1:	77 c0                	ja     800ab3 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800af6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800af9:	74 14                	je     800b0f <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	68 3c 43 80 00       	push   $0x80433c
  800b03:	6a 44                	push   $0x44
  800b05:	68 dc 42 80 00       	push   $0x8042dc
  800b0a:	e8 f8 fd ff ff       	call   800907 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b0f:	90                   	nop
  800b10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b13:	c9                   	leave  
  800b14:	c3                   	ret    

00800b15 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	53                   	push   %ebx
  800b19:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1f:	8b 00                	mov    (%eax),%eax
  800b21:	8d 48 01             	lea    0x1(%eax),%ecx
  800b24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b27:	89 0a                	mov    %ecx,(%edx)
  800b29:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2c:	88 d1                	mov    %dl,%cl
  800b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b31:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b38:	8b 00                	mov    (%eax),%eax
  800b3a:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b3f:	75 30                	jne    800b71 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b41:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800b47:	a0 44 50 80 00       	mov    0x805044,%al
  800b4c:	0f b6 c0             	movzbl %al,%eax
  800b4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b52:	8b 09                	mov    (%ecx),%ecx
  800b54:	89 cb                	mov    %ecx,%ebx
  800b56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b59:	83 c1 08             	add    $0x8,%ecx
  800b5c:	52                   	push   %edx
  800b5d:	50                   	push   %eax
  800b5e:	53                   	push   %ebx
  800b5f:	51                   	push   %ecx
  800b60:	e8 b0 1e 00 00       	call   802a15 <sys_cputs>
  800b65:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b74:	8b 40 04             	mov    0x4(%eax),%eax
  800b77:	8d 50 01             	lea    0x1(%eax),%edx
  800b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b80:	90                   	nop
  800b81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b84:	c9                   	leave  
  800b85:	c3                   	ret    

00800b86 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b8f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b96:	00 00 00 
	b.cnt = 0;
  800b99:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ba0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ba3:	ff 75 0c             	pushl  0xc(%ebp)
  800ba6:	ff 75 08             	pushl  0x8(%ebp)
  800ba9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800baf:	50                   	push   %eax
  800bb0:	68 15 0b 80 00       	push   $0x800b15
  800bb5:	e8 5a 02 00 00       	call   800e14 <vprintfmt>
  800bba:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800bbd:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800bc3:	a0 44 50 80 00       	mov    0x805044,%al
  800bc8:	0f b6 c0             	movzbl %al,%eax
  800bcb:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800bd1:	52                   	push   %edx
  800bd2:	50                   	push   %eax
  800bd3:	51                   	push   %ecx
  800bd4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bda:	83 c0 08             	add    $0x8,%eax
  800bdd:	50                   	push   %eax
  800bde:	e8 32 1e 00 00       	call   802a15 <sys_cputs>
  800be3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800be6:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800bed:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bf3:	c9                   	leave  
  800bf4:	c3                   	ret    

00800bf5 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bfb:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800c02:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c11:	50                   	push   %eax
  800c12:	e8 6f ff ff ff       	call   800b86 <vcprintf>
  800c17:	83 c4 10             	add    $0x10,%esp
  800c1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c20:	c9                   	leave  
  800c21:	c3                   	ret    

00800c22 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c28:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	c1 e0 08             	shl    $0x8,%eax
  800c35:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800c3a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c3d:	83 c0 04             	add    $0x4,%eax
  800c40:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c46:	83 ec 08             	sub    $0x8,%esp
  800c49:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4c:	50                   	push   %eax
  800c4d:	e8 34 ff ff ff       	call   800b86 <vcprintf>
  800c52:	83 c4 10             	add    $0x10,%esp
  800c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c58:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800c5f:	07 00 00 

	return cnt;
  800c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c65:	c9                   	leave  
  800c66:	c3                   	ret    

00800c67 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c6d:	e8 e7 1d 00 00       	call   802a59 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c72:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c75:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	83 ec 08             	sub    $0x8,%esp
  800c7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c81:	50                   	push   %eax
  800c82:	e8 ff fe ff ff       	call   800b86 <vcprintf>
  800c87:	83 c4 10             	add    $0x10,%esp
  800c8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c8d:	e8 e1 1d 00 00       	call   802a73 <sys_unlock_cons>
	return cnt;
  800c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c95:	c9                   	leave  
  800c96:	c3                   	ret    

00800c97 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	53                   	push   %ebx
  800c9b:	83 ec 14             	sub    $0x14,%esp
  800c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800caa:	8b 45 18             	mov    0x18(%ebp),%eax
  800cad:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cb5:	77 55                	ja     800d0c <printnum+0x75>
  800cb7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cba:	72 05                	jb     800cc1 <printnum+0x2a>
  800cbc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cbf:	77 4b                	ja     800d0c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cc1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cc4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cc7:	8b 45 18             	mov    0x18(%ebp),%eax
  800cca:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccf:	52                   	push   %edx
  800cd0:	50                   	push   %eax
  800cd1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd4:	ff 75 f0             	pushl  -0x10(%ebp)
  800cd7:	e8 dc 2f 00 00       	call   803cb8 <__udivdi3>
  800cdc:	83 c4 10             	add    $0x10,%esp
  800cdf:	83 ec 04             	sub    $0x4,%esp
  800ce2:	ff 75 20             	pushl  0x20(%ebp)
  800ce5:	53                   	push   %ebx
  800ce6:	ff 75 18             	pushl  0x18(%ebp)
  800ce9:	52                   	push   %edx
  800cea:	50                   	push   %eax
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	ff 75 08             	pushl  0x8(%ebp)
  800cf1:	e8 a1 ff ff ff       	call   800c97 <printnum>
  800cf6:	83 c4 20             	add    $0x20,%esp
  800cf9:	eb 1a                	jmp    800d15 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cfb:	83 ec 08             	sub    $0x8,%esp
  800cfe:	ff 75 0c             	pushl  0xc(%ebp)
  800d01:	ff 75 20             	pushl  0x20(%ebp)
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	ff d0                	call   *%eax
  800d09:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d0c:	ff 4d 1c             	decl   0x1c(%ebp)
  800d0f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d13:	7f e6                	jg     800cfb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d15:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d23:	53                   	push   %ebx
  800d24:	51                   	push   %ecx
  800d25:	52                   	push   %edx
  800d26:	50                   	push   %eax
  800d27:	e8 9c 30 00 00       	call   803dc8 <__umoddi3>
  800d2c:	83 c4 10             	add    $0x10,%esp
  800d2f:	05 b4 45 80 00       	add    $0x8045b4,%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f be c0             	movsbl %al,%eax
  800d39:	83 ec 08             	sub    $0x8,%esp
  800d3c:	ff 75 0c             	pushl  0xc(%ebp)
  800d3f:	50                   	push   %eax
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	ff d0                	call   *%eax
  800d45:	83 c4 10             	add    $0x10,%esp
}
  800d48:	90                   	nop
  800d49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d4c:	c9                   	leave  
  800d4d:	c3                   	ret    

00800d4e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d51:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d55:	7e 1c                	jle    800d73 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8b 00                	mov    (%eax),%eax
  800d5c:	8d 50 08             	lea    0x8(%eax),%edx
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	89 10                	mov    %edx,(%eax)
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	83 e8 08             	sub    $0x8,%eax
  800d6c:	8b 50 04             	mov    0x4(%eax),%edx
  800d6f:	8b 00                	mov    (%eax),%eax
  800d71:	eb 40                	jmp    800db3 <getuint+0x65>
	else if (lflag)
  800d73:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d77:	74 1e                	je     800d97 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	8d 50 04             	lea    0x4(%eax),%edx
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	89 10                	mov    %edx,(%eax)
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8b 00                	mov    (%eax),%eax
  800d8b:	83 e8 04             	sub    $0x4,%eax
  800d8e:	8b 00                	mov    (%eax),%eax
  800d90:	ba 00 00 00 00       	mov    $0x0,%edx
  800d95:	eb 1c                	jmp    800db3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8b 00                	mov    (%eax),%eax
  800d9c:	8d 50 04             	lea    0x4(%eax),%edx
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	89 10                	mov    %edx,(%eax)
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8b 00                	mov    (%eax),%eax
  800da9:	83 e8 04             	sub    $0x4,%eax
  800dac:	8b 00                	mov    (%eax),%eax
  800dae:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800db8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dbc:	7e 1c                	jle    800dda <getint+0x25>
		return va_arg(*ap, long long);
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8b 00                	mov    (%eax),%eax
  800dc3:	8d 50 08             	lea    0x8(%eax),%edx
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	89 10                	mov    %edx,(%eax)
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8b 00                	mov    (%eax),%eax
  800dd0:	83 e8 08             	sub    $0x8,%eax
  800dd3:	8b 50 04             	mov    0x4(%eax),%edx
  800dd6:	8b 00                	mov    (%eax),%eax
  800dd8:	eb 38                	jmp    800e12 <getint+0x5d>
	else if (lflag)
  800dda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dde:	74 1a                	je     800dfa <getint+0x45>
		return va_arg(*ap, long);
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8b 00                	mov    (%eax),%eax
  800de5:	8d 50 04             	lea    0x4(%eax),%edx
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	89 10                	mov    %edx,(%eax)
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	8b 00                	mov    (%eax),%eax
  800df2:	83 e8 04             	sub    $0x4,%eax
  800df5:	8b 00                	mov    (%eax),%eax
  800df7:	99                   	cltd   
  800df8:	eb 18                	jmp    800e12 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8b 00                	mov    (%eax),%eax
  800dff:	8d 50 04             	lea    0x4(%eax),%edx
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	89 10                	mov    %edx,(%eax)
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8b 00                	mov    (%eax),%eax
  800e0c:	83 e8 04             	sub    $0x4,%eax
  800e0f:	8b 00                	mov    (%eax),%eax
  800e11:	99                   	cltd   
}
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    

00800e14 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	56                   	push   %esi
  800e18:	53                   	push   %ebx
  800e19:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e1c:	eb 17                	jmp    800e35 <vprintfmt+0x21>
			if (ch == '\0')
  800e1e:	85 db                	test   %ebx,%ebx
  800e20:	0f 84 c1 03 00 00    	je     8011e7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e26:	83 ec 08             	sub    $0x8,%esp
  800e29:	ff 75 0c             	pushl  0xc(%ebp)
  800e2c:	53                   	push   %ebx
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	ff d0                	call   *%eax
  800e32:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e35:	8b 45 10             	mov    0x10(%ebp),%eax
  800e38:	8d 50 01             	lea    0x1(%eax),%edx
  800e3b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	0f b6 d8             	movzbl %al,%ebx
  800e43:	83 fb 25             	cmp    $0x25,%ebx
  800e46:	75 d6                	jne    800e1e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e48:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e4c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e53:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e5a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e61:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e68:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6b:	8d 50 01             	lea    0x1(%eax),%edx
  800e6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e71:	8a 00                	mov    (%eax),%al
  800e73:	0f b6 d8             	movzbl %al,%ebx
  800e76:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e79:	83 f8 5b             	cmp    $0x5b,%eax
  800e7c:	0f 87 3d 03 00 00    	ja     8011bf <vprintfmt+0x3ab>
  800e82:	8b 04 85 d8 45 80 00 	mov    0x8045d8(,%eax,4),%eax
  800e89:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e8b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e8f:	eb d7                	jmp    800e68 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e91:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e95:	eb d1                	jmp    800e68 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e97:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ea1:	89 d0                	mov    %edx,%eax
  800ea3:	c1 e0 02             	shl    $0x2,%eax
  800ea6:	01 d0                	add    %edx,%eax
  800ea8:	01 c0                	add    %eax,%eax
  800eaa:	01 d8                	add    %ebx,%eax
  800eac:	83 e8 30             	sub    $0x30,%eax
  800eaf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800eba:	83 fb 2f             	cmp    $0x2f,%ebx
  800ebd:	7e 3e                	jle    800efd <vprintfmt+0xe9>
  800ebf:	83 fb 39             	cmp    $0x39,%ebx
  800ec2:	7f 39                	jg     800efd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ec4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ec7:	eb d5                	jmp    800e9e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ec9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecc:	83 c0 04             	add    $0x4,%eax
  800ecf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed5:	83 e8 04             	sub    $0x4,%eax
  800ed8:	8b 00                	mov    (%eax),%eax
  800eda:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800edd:	eb 1f                	jmp    800efe <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800edf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ee3:	79 83                	jns    800e68 <vprintfmt+0x54>
				width = 0;
  800ee5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800eec:	e9 77 ff ff ff       	jmp    800e68 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ef1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ef8:	e9 6b ff ff ff       	jmp    800e68 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800efd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800efe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f02:	0f 89 60 ff ff ff    	jns    800e68 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f0e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f15:	e9 4e ff ff ff       	jmp    800e68 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f1a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f1d:	e9 46 ff ff ff       	jmp    800e68 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f22:	8b 45 14             	mov    0x14(%ebp),%eax
  800f25:	83 c0 04             	add    $0x4,%eax
  800f28:	89 45 14             	mov    %eax,0x14(%ebp)
  800f2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2e:	83 e8 04             	sub    $0x4,%eax
  800f31:	8b 00                	mov    (%eax),%eax
  800f33:	83 ec 08             	sub    $0x8,%esp
  800f36:	ff 75 0c             	pushl  0xc(%ebp)
  800f39:	50                   	push   %eax
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	ff d0                	call   *%eax
  800f3f:	83 c4 10             	add    $0x10,%esp
			break;
  800f42:	e9 9b 02 00 00       	jmp    8011e2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f47:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4a:	83 c0 04             	add    $0x4,%eax
  800f4d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f50:	8b 45 14             	mov    0x14(%ebp),%eax
  800f53:	83 e8 04             	sub    $0x4,%eax
  800f56:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f58:	85 db                	test   %ebx,%ebx
  800f5a:	79 02                	jns    800f5e <vprintfmt+0x14a>
				err = -err;
  800f5c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f5e:	83 fb 64             	cmp    $0x64,%ebx
  800f61:	7f 0b                	jg     800f6e <vprintfmt+0x15a>
  800f63:	8b 34 9d 20 44 80 00 	mov    0x804420(,%ebx,4),%esi
  800f6a:	85 f6                	test   %esi,%esi
  800f6c:	75 19                	jne    800f87 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f6e:	53                   	push   %ebx
  800f6f:	68 c5 45 80 00       	push   $0x8045c5
  800f74:	ff 75 0c             	pushl  0xc(%ebp)
  800f77:	ff 75 08             	pushl  0x8(%ebp)
  800f7a:	e8 70 02 00 00       	call   8011ef <printfmt>
  800f7f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f82:	e9 5b 02 00 00       	jmp    8011e2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f87:	56                   	push   %esi
  800f88:	68 ce 45 80 00       	push   $0x8045ce
  800f8d:	ff 75 0c             	pushl  0xc(%ebp)
  800f90:	ff 75 08             	pushl  0x8(%ebp)
  800f93:	e8 57 02 00 00       	call   8011ef <printfmt>
  800f98:	83 c4 10             	add    $0x10,%esp
			break;
  800f9b:	e9 42 02 00 00       	jmp    8011e2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa3:	83 c0 04             	add    $0x4,%eax
  800fa6:	89 45 14             	mov    %eax,0x14(%ebp)
  800fa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fac:	83 e8 04             	sub    $0x4,%eax
  800faf:	8b 30                	mov    (%eax),%esi
  800fb1:	85 f6                	test   %esi,%esi
  800fb3:	75 05                	jne    800fba <vprintfmt+0x1a6>
				p = "(null)";
  800fb5:	be d1 45 80 00       	mov    $0x8045d1,%esi
			if (width > 0 && padc != '-')
  800fba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fbe:	7e 6d                	jle    80102d <vprintfmt+0x219>
  800fc0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fc4:	74 67                	je     80102d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fc9:	83 ec 08             	sub    $0x8,%esp
  800fcc:	50                   	push   %eax
  800fcd:	56                   	push   %esi
  800fce:	e8 26 05 00 00       	call   8014f9 <strnlen>
  800fd3:	83 c4 10             	add    $0x10,%esp
  800fd6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fd9:	eb 16                	jmp    800ff1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fdb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fdf:	83 ec 08             	sub    $0x8,%esp
  800fe2:	ff 75 0c             	pushl  0xc(%ebp)
  800fe5:	50                   	push   %eax
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	ff d0                	call   *%eax
  800feb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fee:	ff 4d e4             	decl   -0x1c(%ebp)
  800ff1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ff5:	7f e4                	jg     800fdb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ff7:	eb 34                	jmp    80102d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ff9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ffd:	74 1c                	je     80101b <vprintfmt+0x207>
  800fff:	83 fb 1f             	cmp    $0x1f,%ebx
  801002:	7e 05                	jle    801009 <vprintfmt+0x1f5>
  801004:	83 fb 7e             	cmp    $0x7e,%ebx
  801007:	7e 12                	jle    80101b <vprintfmt+0x207>
					putch('?', putdat);
  801009:	83 ec 08             	sub    $0x8,%esp
  80100c:	ff 75 0c             	pushl  0xc(%ebp)
  80100f:	6a 3f                	push   $0x3f
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	ff d0                	call   *%eax
  801016:	83 c4 10             	add    $0x10,%esp
  801019:	eb 0f                	jmp    80102a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80101b:	83 ec 08             	sub    $0x8,%esp
  80101e:	ff 75 0c             	pushl  0xc(%ebp)
  801021:	53                   	push   %ebx
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	ff d0                	call   *%eax
  801027:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80102a:	ff 4d e4             	decl   -0x1c(%ebp)
  80102d:	89 f0                	mov    %esi,%eax
  80102f:	8d 70 01             	lea    0x1(%eax),%esi
  801032:	8a 00                	mov    (%eax),%al
  801034:	0f be d8             	movsbl %al,%ebx
  801037:	85 db                	test   %ebx,%ebx
  801039:	74 24                	je     80105f <vprintfmt+0x24b>
  80103b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80103f:	78 b8                	js     800ff9 <vprintfmt+0x1e5>
  801041:	ff 4d e0             	decl   -0x20(%ebp)
  801044:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801048:	79 af                	jns    800ff9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80104a:	eb 13                	jmp    80105f <vprintfmt+0x24b>
				putch(' ', putdat);
  80104c:	83 ec 08             	sub    $0x8,%esp
  80104f:	ff 75 0c             	pushl  0xc(%ebp)
  801052:	6a 20                	push   $0x20
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	ff d0                	call   *%eax
  801059:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80105c:	ff 4d e4             	decl   -0x1c(%ebp)
  80105f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801063:	7f e7                	jg     80104c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801065:	e9 78 01 00 00       	jmp    8011e2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	ff 75 e8             	pushl  -0x18(%ebp)
  801070:	8d 45 14             	lea    0x14(%ebp),%eax
  801073:	50                   	push   %eax
  801074:	e8 3c fd ff ff       	call   800db5 <getint>
  801079:	83 c4 10             	add    $0x10,%esp
  80107c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80107f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801085:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801088:	85 d2                	test   %edx,%edx
  80108a:	79 23                	jns    8010af <vprintfmt+0x29b>
				putch('-', putdat);
  80108c:	83 ec 08             	sub    $0x8,%esp
  80108f:	ff 75 0c             	pushl  0xc(%ebp)
  801092:	6a 2d                	push   $0x2d
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	ff d0                	call   *%eax
  801099:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80109c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80109f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a2:	f7 d8                	neg    %eax
  8010a4:	83 d2 00             	adc    $0x0,%edx
  8010a7:	f7 da                	neg    %edx
  8010a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010af:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010b6:	e9 bc 00 00 00       	jmp    801177 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010bb:	83 ec 08             	sub    $0x8,%esp
  8010be:	ff 75 e8             	pushl  -0x18(%ebp)
  8010c1:	8d 45 14             	lea    0x14(%ebp),%eax
  8010c4:	50                   	push   %eax
  8010c5:	e8 84 fc ff ff       	call   800d4e <getuint>
  8010ca:	83 c4 10             	add    $0x10,%esp
  8010cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010da:	e9 98 00 00 00       	jmp    801177 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010df:	83 ec 08             	sub    $0x8,%esp
  8010e2:	ff 75 0c             	pushl  0xc(%ebp)
  8010e5:	6a 58                	push   $0x58
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	ff d0                	call   *%eax
  8010ec:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010ef:	83 ec 08             	sub    $0x8,%esp
  8010f2:	ff 75 0c             	pushl  0xc(%ebp)
  8010f5:	6a 58                	push   $0x58
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	ff d0                	call   *%eax
  8010fc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010ff:	83 ec 08             	sub    $0x8,%esp
  801102:	ff 75 0c             	pushl  0xc(%ebp)
  801105:	6a 58                	push   $0x58
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	ff d0                	call   *%eax
  80110c:	83 c4 10             	add    $0x10,%esp
			break;
  80110f:	e9 ce 00 00 00       	jmp    8011e2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801114:	83 ec 08             	sub    $0x8,%esp
  801117:	ff 75 0c             	pushl  0xc(%ebp)
  80111a:	6a 30                	push   $0x30
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	ff d0                	call   *%eax
  801121:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801124:	83 ec 08             	sub    $0x8,%esp
  801127:	ff 75 0c             	pushl  0xc(%ebp)
  80112a:	6a 78                	push   $0x78
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	ff d0                	call   *%eax
  801131:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801134:	8b 45 14             	mov    0x14(%ebp),%eax
  801137:	83 c0 04             	add    $0x4,%eax
  80113a:	89 45 14             	mov    %eax,0x14(%ebp)
  80113d:	8b 45 14             	mov    0x14(%ebp),%eax
  801140:	83 e8 04             	sub    $0x4,%eax
  801143:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801145:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801148:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80114f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801156:	eb 1f                	jmp    801177 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801158:	83 ec 08             	sub    $0x8,%esp
  80115b:	ff 75 e8             	pushl  -0x18(%ebp)
  80115e:	8d 45 14             	lea    0x14(%ebp),%eax
  801161:	50                   	push   %eax
  801162:	e8 e7 fb ff ff       	call   800d4e <getuint>
  801167:	83 c4 10             	add    $0x10,%esp
  80116a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80116d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801170:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801177:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80117b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	52                   	push   %edx
  801182:	ff 75 e4             	pushl  -0x1c(%ebp)
  801185:	50                   	push   %eax
  801186:	ff 75 f4             	pushl  -0xc(%ebp)
  801189:	ff 75 f0             	pushl  -0x10(%ebp)
  80118c:	ff 75 0c             	pushl  0xc(%ebp)
  80118f:	ff 75 08             	pushl  0x8(%ebp)
  801192:	e8 00 fb ff ff       	call   800c97 <printnum>
  801197:	83 c4 20             	add    $0x20,%esp
			break;
  80119a:	eb 46                	jmp    8011e2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80119c:	83 ec 08             	sub    $0x8,%esp
  80119f:	ff 75 0c             	pushl  0xc(%ebp)
  8011a2:	53                   	push   %ebx
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	ff d0                	call   *%eax
  8011a8:	83 c4 10             	add    $0x10,%esp
			break;
  8011ab:	eb 35                	jmp    8011e2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011ad:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  8011b4:	eb 2c                	jmp    8011e2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011b6:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  8011bd:	eb 23                	jmp    8011e2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011bf:	83 ec 08             	sub    $0x8,%esp
  8011c2:	ff 75 0c             	pushl  0xc(%ebp)
  8011c5:	6a 25                	push   $0x25
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	ff d0                	call   *%eax
  8011cc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011cf:	ff 4d 10             	decl   0x10(%ebp)
  8011d2:	eb 03                	jmp    8011d7 <vprintfmt+0x3c3>
  8011d4:	ff 4d 10             	decl   0x10(%ebp)
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	48                   	dec    %eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 25                	cmp    $0x25,%al
  8011df:	75 f3                	jne    8011d4 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011e1:	90                   	nop
		}
	}
  8011e2:	e9 35 fc ff ff       	jmp    800e1c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011e7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011eb:	5b                   	pop    %ebx
  8011ec:	5e                   	pop    %esi
  8011ed:	5d                   	pop    %ebp
  8011ee:	c3                   	ret    

008011ef <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011f5:	8d 45 10             	lea    0x10(%ebp),%eax
  8011f8:	83 c0 04             	add    $0x4,%eax
  8011fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801201:	ff 75 f4             	pushl  -0xc(%ebp)
  801204:	50                   	push   %eax
  801205:	ff 75 0c             	pushl  0xc(%ebp)
  801208:	ff 75 08             	pushl  0x8(%ebp)
  80120b:	e8 04 fc ff ff       	call   800e14 <vprintfmt>
  801210:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801213:	90                   	nop
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	8b 40 08             	mov    0x8(%eax),%eax
  80121f:	8d 50 01             	lea    0x1(%eax),%edx
  801222:	8b 45 0c             	mov    0xc(%ebp),%eax
  801225:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	8b 10                	mov    (%eax),%edx
  80122d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801230:	8b 40 04             	mov    0x4(%eax),%eax
  801233:	39 c2                	cmp    %eax,%edx
  801235:	73 12                	jae    801249 <sprintputch+0x33>
		*b->buf++ = ch;
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8b 00                	mov    (%eax),%eax
  80123c:	8d 48 01             	lea    0x1(%eax),%ecx
  80123f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801242:	89 0a                	mov    %ecx,(%edx)
  801244:	8b 55 08             	mov    0x8(%ebp),%edx
  801247:	88 10                	mov    %dl,(%eax)
}
  801249:	90                   	nop
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	01 d0                	add    %edx,%eax
  801263:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801266:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80126d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801271:	74 06                	je     801279 <vsnprintf+0x2d>
  801273:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801277:	7f 07                	jg     801280 <vsnprintf+0x34>
		return -E_INVAL;
  801279:	b8 03 00 00 00       	mov    $0x3,%eax
  80127e:	eb 20                	jmp    8012a0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801280:	ff 75 14             	pushl  0x14(%ebp)
  801283:	ff 75 10             	pushl  0x10(%ebp)
  801286:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801289:	50                   	push   %eax
  80128a:	68 16 12 80 00       	push   $0x801216
  80128f:	e8 80 fb ff ff       	call   800e14 <vprintfmt>
  801294:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801297:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80129a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80129d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    

008012a2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012a8:	8d 45 10             	lea    0x10(%ebp),%eax
  8012ab:	83 c0 04             	add    $0x4,%eax
  8012ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b7:	50                   	push   %eax
  8012b8:	ff 75 0c             	pushl  0xc(%ebp)
  8012bb:	ff 75 08             	pushl  0x8(%ebp)
  8012be:	e8 89 ff ff ff       	call   80124c <vsnprintf>
  8012c3:	83 c4 10             	add    $0x10,%esp
  8012c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8012d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d8:	74 13                	je     8012ed <readline+0x1f>
		cprintf("%s", prompt);
  8012da:	83 ec 08             	sub    $0x8,%esp
  8012dd:	ff 75 08             	pushl  0x8(%ebp)
  8012e0:	68 48 47 80 00       	push   $0x804748
  8012e5:	e8 0b f9 ff ff       	call   800bf5 <cprintf>
  8012ea:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012f4:	83 ec 0c             	sub    $0xc,%esp
  8012f7:	6a 00                	push   $0x0
  8012f9:	e8 4f f4 ff ff       	call   80074d <iscons>
  8012fe:	83 c4 10             	add    $0x10,%esp
  801301:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801304:	e8 31 f4 ff ff       	call   80073a <getchar>
  801309:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80130c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801310:	79 22                	jns    801334 <readline+0x66>
			if (c != -E_EOF)
  801312:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801316:	0f 84 ad 00 00 00    	je     8013c9 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 ec             	pushl  -0x14(%ebp)
  801322:	68 4b 47 80 00       	push   $0x80474b
  801327:	e8 c9 f8 ff ff       	call   800bf5 <cprintf>
  80132c:	83 c4 10             	add    $0x10,%esp
			break;
  80132f:	e9 95 00 00 00       	jmp    8013c9 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801334:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801338:	7e 34                	jle    80136e <readline+0xa0>
  80133a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801341:	7f 2b                	jg     80136e <readline+0xa0>
			if (echoing)
  801343:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801347:	74 0e                	je     801357 <readline+0x89>
				cputchar(c);
  801349:	83 ec 0c             	sub    $0xc,%esp
  80134c:	ff 75 ec             	pushl  -0x14(%ebp)
  80134f:	e8 c7 f3 ff ff       	call   80071b <cputchar>
  801354:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	8d 50 01             	lea    0x1(%eax),%edx
  80135d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801360:	89 c2                	mov    %eax,%edx
  801362:	8b 45 0c             	mov    0xc(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80136a:	88 10                	mov    %dl,(%eax)
  80136c:	eb 56                	jmp    8013c4 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80136e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801372:	75 1f                	jne    801393 <readline+0xc5>
  801374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801378:	7e 19                	jle    801393 <readline+0xc5>
			if (echoing)
  80137a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80137e:	74 0e                	je     80138e <readline+0xc0>
				cputchar(c);
  801380:	83 ec 0c             	sub    $0xc,%esp
  801383:	ff 75 ec             	pushl  -0x14(%ebp)
  801386:	e8 90 f3 ff ff       	call   80071b <cputchar>
  80138b:	83 c4 10             	add    $0x10,%esp

			i--;
  80138e:	ff 4d f4             	decl   -0xc(%ebp)
  801391:	eb 31                	jmp    8013c4 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801393:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801397:	74 0a                	je     8013a3 <readline+0xd5>
  801399:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80139d:	0f 85 61 ff ff ff    	jne    801304 <readline+0x36>
			if (echoing)
  8013a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013a7:	74 0e                	je     8013b7 <readline+0xe9>
				cputchar(c);
  8013a9:	83 ec 0c             	sub    $0xc,%esp
  8013ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8013af:	e8 67 f3 ff ff       	call   80071b <cputchar>
  8013b4:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8013b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bd:	01 d0                	add    %edx,%eax
  8013bf:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8013c2:	eb 06                	jmp    8013ca <readline+0xfc>
		}
	}
  8013c4:	e9 3b ff ff ff       	jmp    801304 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8013c9:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8013ca:	90                   	nop
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8013d3:	e8 81 16 00 00       	call   802a59 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013dc:	74 13                	je     8013f1 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013de:	83 ec 08             	sub    $0x8,%esp
  8013e1:	ff 75 08             	pushl  0x8(%ebp)
  8013e4:	68 48 47 80 00       	push   $0x804748
  8013e9:	e8 07 f8 ff ff       	call   800bf5 <cprintf>
  8013ee:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8013f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8013f8:	83 ec 0c             	sub    $0xc,%esp
  8013fb:	6a 00                	push   $0x0
  8013fd:	e8 4b f3 ff ff       	call   80074d <iscons>
  801402:	83 c4 10             	add    $0x10,%esp
  801405:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801408:	e8 2d f3 ff ff       	call   80073a <getchar>
  80140d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801410:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801414:	79 22                	jns    801438 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801416:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80141a:	0f 84 ad 00 00 00    	je     8014cd <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801420:	83 ec 08             	sub    $0x8,%esp
  801423:	ff 75 ec             	pushl  -0x14(%ebp)
  801426:	68 4b 47 80 00       	push   $0x80474b
  80142b:	e8 c5 f7 ff ff       	call   800bf5 <cprintf>
  801430:	83 c4 10             	add    $0x10,%esp
				break;
  801433:	e9 95 00 00 00       	jmp    8014cd <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801438:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80143c:	7e 34                	jle    801472 <atomic_readline+0xa5>
  80143e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801445:	7f 2b                	jg     801472 <atomic_readline+0xa5>
				if (echoing)
  801447:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80144b:	74 0e                	je     80145b <atomic_readline+0x8e>
					cputchar(c);
  80144d:	83 ec 0c             	sub    $0xc,%esp
  801450:	ff 75 ec             	pushl  -0x14(%ebp)
  801453:	e8 c3 f2 ff ff       	call   80071b <cputchar>
  801458:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80145b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145e:	8d 50 01             	lea    0x1(%eax),%edx
  801461:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801464:	89 c2                	mov    %eax,%edx
  801466:	8b 45 0c             	mov    0xc(%ebp),%eax
  801469:	01 d0                	add    %edx,%eax
  80146b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80146e:	88 10                	mov    %dl,(%eax)
  801470:	eb 56                	jmp    8014c8 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801472:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801476:	75 1f                	jne    801497 <atomic_readline+0xca>
  801478:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80147c:	7e 19                	jle    801497 <atomic_readline+0xca>
				if (echoing)
  80147e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801482:	74 0e                	je     801492 <atomic_readline+0xc5>
					cputchar(c);
  801484:	83 ec 0c             	sub    $0xc,%esp
  801487:	ff 75 ec             	pushl  -0x14(%ebp)
  80148a:	e8 8c f2 ff ff       	call   80071b <cputchar>
  80148f:	83 c4 10             	add    $0x10,%esp
				i--;
  801492:	ff 4d f4             	decl   -0xc(%ebp)
  801495:	eb 31                	jmp    8014c8 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801497:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80149b:	74 0a                	je     8014a7 <atomic_readline+0xda>
  80149d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8014a1:	0f 85 61 ff ff ff    	jne    801408 <atomic_readline+0x3b>
				if (echoing)
  8014a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014ab:	74 0e                	je     8014bb <atomic_readline+0xee>
					cputchar(c);
  8014ad:	83 ec 0c             	sub    $0xc,%esp
  8014b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8014b3:	e8 63 f2 ff ff       	call   80071b <cputchar>
  8014b8:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8014bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c1:	01 d0                	add    %edx,%eax
  8014c3:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8014c6:	eb 06                	jmp    8014ce <atomic_readline+0x101>
			}
		}
  8014c8:	e9 3b ff ff ff       	jmp    801408 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8014cd:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8014ce:	e8 a0 15 00 00       	call   802a73 <sys_unlock_cons>
}
  8014d3:	90                   	nop
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014e3:	eb 06                	jmp    8014eb <strlen+0x15>
		n++;
  8014e5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014e8:	ff 45 08             	incl   0x8(%ebp)
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	84 c0                	test   %al,%al
  8014f2:	75 f1                	jne    8014e5 <strlen+0xf>
		n++;
	return n;
  8014f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801506:	eb 09                	jmp    801511 <strnlen+0x18>
		n++;
  801508:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80150b:	ff 45 08             	incl   0x8(%ebp)
  80150e:	ff 4d 0c             	decl   0xc(%ebp)
  801511:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801515:	74 09                	je     801520 <strnlen+0x27>
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	8a 00                	mov    (%eax),%al
  80151c:	84 c0                	test   %al,%al
  80151e:	75 e8                	jne    801508 <strnlen+0xf>
		n++;
	return n;
  801520:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801531:	90                   	nop
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	8d 50 01             	lea    0x1(%eax),%edx
  801538:	89 55 08             	mov    %edx,0x8(%ebp)
  80153b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801541:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801544:	8a 12                	mov    (%edx),%dl
  801546:	88 10                	mov    %dl,(%eax)
  801548:	8a 00                	mov    (%eax),%al
  80154a:	84 c0                	test   %al,%al
  80154c:	75 e4                	jne    801532 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80154e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80155f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801566:	eb 1f                	jmp    801587 <strncpy+0x34>
		*dst++ = *src;
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	8d 50 01             	lea    0x1(%eax),%edx
  80156e:	89 55 08             	mov    %edx,0x8(%ebp)
  801571:	8b 55 0c             	mov    0xc(%ebp),%edx
  801574:	8a 12                	mov    (%edx),%dl
  801576:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801578:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157b:	8a 00                	mov    (%eax),%al
  80157d:	84 c0                	test   %al,%al
  80157f:	74 03                	je     801584 <strncpy+0x31>
			src++;
  801581:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801584:	ff 45 fc             	incl   -0x4(%ebp)
  801587:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80158a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80158d:	72 d9                	jb     801568 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80158f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8015a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015a4:	74 30                	je     8015d6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8015a6:	eb 16                	jmp    8015be <strlcpy+0x2a>
			*dst++ = *src++;
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	8d 50 01             	lea    0x1(%eax),%edx
  8015ae:	89 55 08             	mov    %edx,0x8(%ebp)
  8015b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015b7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015ba:	8a 12                	mov    (%edx),%dl
  8015bc:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015be:	ff 4d 10             	decl   0x10(%ebp)
  8015c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015c5:	74 09                	je     8015d0 <strlcpy+0x3c>
  8015c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ca:	8a 00                	mov    (%eax),%al
  8015cc:	84 c0                	test   %al,%al
  8015ce:	75 d8                	jne    8015a8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015dc:	29 c2                	sub    %eax,%edx
  8015de:	89 d0                	mov    %edx,%eax
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015e5:	eb 06                	jmp    8015ed <strcmp+0xb>
		p++, q++;
  8015e7:	ff 45 08             	incl   0x8(%ebp)
  8015ea:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	8a 00                	mov    (%eax),%al
  8015f2:	84 c0                	test   %al,%al
  8015f4:	74 0e                	je     801604 <strcmp+0x22>
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	8a 10                	mov    (%eax),%dl
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	8a 00                	mov    (%eax),%al
  801600:	38 c2                	cmp    %al,%dl
  801602:	74 e3                	je     8015e7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	0f b6 d0             	movzbl %al,%edx
  80160c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160f:	8a 00                	mov    (%eax),%al
  801611:	0f b6 c0             	movzbl %al,%eax
  801614:	29 c2                	sub    %eax,%edx
  801616:	89 d0                	mov    %edx,%eax
}
  801618:	5d                   	pop    %ebp
  801619:	c3                   	ret    

0080161a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80161d:	eb 09                	jmp    801628 <strncmp+0xe>
		n--, p++, q++;
  80161f:	ff 4d 10             	decl   0x10(%ebp)
  801622:	ff 45 08             	incl   0x8(%ebp)
  801625:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801628:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80162c:	74 17                	je     801645 <strncmp+0x2b>
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
  801631:	8a 00                	mov    (%eax),%al
  801633:	84 c0                	test   %al,%al
  801635:	74 0e                	je     801645 <strncmp+0x2b>
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	8a 10                	mov    (%eax),%dl
  80163c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163f:	8a 00                	mov    (%eax),%al
  801641:	38 c2                	cmp    %al,%dl
  801643:	74 da                	je     80161f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801645:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801649:	75 07                	jne    801652 <strncmp+0x38>
		return 0;
  80164b:	b8 00 00 00 00       	mov    $0x0,%eax
  801650:	eb 14                	jmp    801666 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	8a 00                	mov    (%eax),%al
  801657:	0f b6 d0             	movzbl %al,%edx
  80165a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165d:	8a 00                	mov    (%eax),%al
  80165f:	0f b6 c0             	movzbl %al,%eax
  801662:	29 c2                	sub    %eax,%edx
  801664:	89 d0                	mov    %edx,%eax
}
  801666:	5d                   	pop    %ebp
  801667:	c3                   	ret    

00801668 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	83 ec 04             	sub    $0x4,%esp
  80166e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801671:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801674:	eb 12                	jmp    801688 <strchr+0x20>
		if (*s == c)
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80167e:	75 05                	jne    801685 <strchr+0x1d>
			return (char *) s;
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	eb 11                	jmp    801696 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801685:	ff 45 08             	incl   0x8(%ebp)
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8a 00                	mov    (%eax),%al
  80168d:	84 c0                	test   %al,%al
  80168f:	75 e5                	jne    801676 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801691:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 04             	sub    $0x4,%esp
  80169e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8016a4:	eb 0d                	jmp    8016b3 <strfind+0x1b>
		if (*s == c)
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	8a 00                	mov    (%eax),%al
  8016ab:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8016ae:	74 0e                	je     8016be <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016b0:	ff 45 08             	incl   0x8(%ebp)
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	8a 00                	mov    (%eax),%al
  8016b8:	84 c0                	test   %al,%al
  8016ba:	75 ea                	jne    8016a6 <strfind+0xe>
  8016bc:	eb 01                	jmp    8016bf <strfind+0x27>
		if (*s == c)
			break;
  8016be:	90                   	nop
	return (char *) s;
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
  8016c7:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8016d0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8016d4:	76 63                	jbe    801739 <memset+0x75>
		uint64 data_block = c;
  8016d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d9:	99                   	cltd   
  8016da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8016e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e6:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8016ea:	c1 e0 08             	shl    $0x8,%eax
  8016ed:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016f0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8016f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f9:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8016fd:	c1 e0 10             	shl    $0x10,%eax
  801700:	09 45 f0             	or     %eax,-0x10(%ebp)
  801703:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801706:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801709:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170c:	89 c2                	mov    %eax,%edx
  80170e:	b8 00 00 00 00       	mov    $0x0,%eax
  801713:	09 45 f0             	or     %eax,-0x10(%ebp)
  801716:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801719:	eb 18                	jmp    801733 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80171b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80171e:	8d 41 08             	lea    0x8(%ecx),%eax
  801721:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801727:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80172a:	89 01                	mov    %eax,(%ecx)
  80172c:	89 51 04             	mov    %edx,0x4(%ecx)
  80172f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801733:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801737:	77 e2                	ja     80171b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801739:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80173d:	74 23                	je     801762 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80173f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801742:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801745:	eb 0e                	jmp    801755 <memset+0x91>
			*p8++ = (uint8)c;
  801747:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80174a:	8d 50 01             	lea    0x1(%eax),%edx
  80174d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801750:	8b 55 0c             	mov    0xc(%ebp),%edx
  801753:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801755:	8b 45 10             	mov    0x10(%ebp),%eax
  801758:	8d 50 ff             	lea    -0x1(%eax),%edx
  80175b:	89 55 10             	mov    %edx,0x10(%ebp)
  80175e:	85 c0                	test   %eax,%eax
  801760:	75 e5                	jne    801747 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80176d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801770:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801779:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80177d:	76 24                	jbe    8017a3 <memcpy+0x3c>
		while(n >= 8){
  80177f:	eb 1c                	jmp    80179d <memcpy+0x36>
			*d64 = *s64;
  801781:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801784:	8b 50 04             	mov    0x4(%eax),%edx
  801787:	8b 00                	mov    (%eax),%eax
  801789:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80178c:	89 01                	mov    %eax,(%ecx)
  80178e:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801791:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801795:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801799:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80179d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8017a1:	77 de                	ja     801781 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8017a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017a7:	74 31                	je     8017da <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8017a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8017af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8017b5:	eb 16                	jmp    8017cd <memcpy+0x66>
			*d8++ = *s8++;
  8017b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ba:	8d 50 01             	lea    0x1(%eax),%edx
  8017bd:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8017c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017c6:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8017c9:	8a 12                	mov    (%edx),%dl
  8017cb:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8017cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017d3:	89 55 10             	mov    %edx,0x10(%ebp)
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	75 dd                	jne    8017b7 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017f7:	73 50                	jae    801849 <memmove+0x6a>
  8017f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	01 d0                	add    %edx,%eax
  801801:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801804:	76 43                	jbe    801849 <memmove+0x6a>
		s += n;
  801806:	8b 45 10             	mov    0x10(%ebp),%eax
  801809:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80180c:	8b 45 10             	mov    0x10(%ebp),%eax
  80180f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801812:	eb 10                	jmp    801824 <memmove+0x45>
			*--d = *--s;
  801814:	ff 4d f8             	decl   -0x8(%ebp)
  801817:	ff 4d fc             	decl   -0x4(%ebp)
  80181a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80181d:	8a 10                	mov    (%eax),%dl
  80181f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801822:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801824:	8b 45 10             	mov    0x10(%ebp),%eax
  801827:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182a:	89 55 10             	mov    %edx,0x10(%ebp)
  80182d:	85 c0                	test   %eax,%eax
  80182f:	75 e3                	jne    801814 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801831:	eb 23                	jmp    801856 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801833:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801836:	8d 50 01             	lea    0x1(%eax),%edx
  801839:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80183c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80183f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801842:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801845:	8a 12                	mov    (%edx),%dl
  801847:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801849:	8b 45 10             	mov    0x10(%ebp),%eax
  80184c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80184f:	89 55 10             	mov    %edx,0x10(%ebp)
  801852:	85 c0                	test   %eax,%eax
  801854:	75 dd                	jne    801833 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801867:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80186d:	eb 2a                	jmp    801899 <memcmp+0x3e>
		if (*s1 != *s2)
  80186f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801872:	8a 10                	mov    (%eax),%dl
  801874:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801877:	8a 00                	mov    (%eax),%al
  801879:	38 c2                	cmp    %al,%dl
  80187b:	74 16                	je     801893 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80187d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801880:	8a 00                	mov    (%eax),%al
  801882:	0f b6 d0             	movzbl %al,%edx
  801885:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801888:	8a 00                	mov    (%eax),%al
  80188a:	0f b6 c0             	movzbl %al,%eax
  80188d:	29 c2                	sub    %eax,%edx
  80188f:	89 d0                	mov    %edx,%eax
  801891:	eb 18                	jmp    8018ab <memcmp+0x50>
		s1++, s2++;
  801893:	ff 45 fc             	incl   -0x4(%ebp)
  801896:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801899:	8b 45 10             	mov    0x10(%ebp),%eax
  80189c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80189f:	89 55 10             	mov    %edx,0x10(%ebp)
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	75 c9                	jne    80186f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b9:	01 d0                	add    %edx,%eax
  8018bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018be:	eb 15                	jmp    8018d5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	8a 00                	mov    (%eax),%al
  8018c5:	0f b6 d0             	movzbl %al,%edx
  8018c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cb:	0f b6 c0             	movzbl %al,%eax
  8018ce:	39 c2                	cmp    %eax,%edx
  8018d0:	74 0d                	je     8018df <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018d2:	ff 45 08             	incl   0x8(%ebp)
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018db:	72 e3                	jb     8018c0 <memfind+0x13>
  8018dd:	eb 01                	jmp    8018e0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018df:	90                   	nop
	return (void *) s;
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f9:	eb 03                	jmp    8018fe <strtol+0x19>
		s++;
  8018fb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	8a 00                	mov    (%eax),%al
  801903:	3c 20                	cmp    $0x20,%al
  801905:	74 f4                	je     8018fb <strtol+0x16>
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	8a 00                	mov    (%eax),%al
  80190c:	3c 09                	cmp    $0x9,%al
  80190e:	74 eb                	je     8018fb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	8a 00                	mov    (%eax),%al
  801915:	3c 2b                	cmp    $0x2b,%al
  801917:	75 05                	jne    80191e <strtol+0x39>
		s++;
  801919:	ff 45 08             	incl   0x8(%ebp)
  80191c:	eb 13                	jmp    801931 <strtol+0x4c>
	else if (*s == '-')
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	8a 00                	mov    (%eax),%al
  801923:	3c 2d                	cmp    $0x2d,%al
  801925:	75 0a                	jne    801931 <strtol+0x4c>
		s++, neg = 1;
  801927:	ff 45 08             	incl   0x8(%ebp)
  80192a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801931:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801935:	74 06                	je     80193d <strtol+0x58>
  801937:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80193b:	75 20                	jne    80195d <strtol+0x78>
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	8a 00                	mov    (%eax),%al
  801942:	3c 30                	cmp    $0x30,%al
  801944:	75 17                	jne    80195d <strtol+0x78>
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	40                   	inc    %eax
  80194a:	8a 00                	mov    (%eax),%al
  80194c:	3c 78                	cmp    $0x78,%al
  80194e:	75 0d                	jne    80195d <strtol+0x78>
		s += 2, base = 16;
  801950:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801954:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80195b:	eb 28                	jmp    801985 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80195d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801961:	75 15                	jne    801978 <strtol+0x93>
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	8a 00                	mov    (%eax),%al
  801968:	3c 30                	cmp    $0x30,%al
  80196a:	75 0c                	jne    801978 <strtol+0x93>
		s++, base = 8;
  80196c:	ff 45 08             	incl   0x8(%ebp)
  80196f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801976:	eb 0d                	jmp    801985 <strtol+0xa0>
	else if (base == 0)
  801978:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80197c:	75 07                	jne    801985 <strtol+0xa0>
		base = 10;
  80197e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	8a 00                	mov    (%eax),%al
  80198a:	3c 2f                	cmp    $0x2f,%al
  80198c:	7e 19                	jle    8019a7 <strtol+0xc2>
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	8a 00                	mov    (%eax),%al
  801993:	3c 39                	cmp    $0x39,%al
  801995:	7f 10                	jg     8019a7 <strtol+0xc2>
			dig = *s - '0';
  801997:	8b 45 08             	mov    0x8(%ebp),%eax
  80199a:	8a 00                	mov    (%eax),%al
  80199c:	0f be c0             	movsbl %al,%eax
  80199f:	83 e8 30             	sub    $0x30,%eax
  8019a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019a5:	eb 42                	jmp    8019e9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	8a 00                	mov    (%eax),%al
  8019ac:	3c 60                	cmp    $0x60,%al
  8019ae:	7e 19                	jle    8019c9 <strtol+0xe4>
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	8a 00                	mov    (%eax),%al
  8019b5:	3c 7a                	cmp    $0x7a,%al
  8019b7:	7f 10                	jg     8019c9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	8a 00                	mov    (%eax),%al
  8019be:	0f be c0             	movsbl %al,%eax
  8019c1:	83 e8 57             	sub    $0x57,%eax
  8019c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019c7:	eb 20                	jmp    8019e9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	8a 00                	mov    (%eax),%al
  8019ce:	3c 40                	cmp    $0x40,%al
  8019d0:	7e 39                	jle    801a0b <strtol+0x126>
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	8a 00                	mov    (%eax),%al
  8019d7:	3c 5a                	cmp    $0x5a,%al
  8019d9:	7f 30                	jg     801a0b <strtol+0x126>
			dig = *s - 'A' + 10;
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	8a 00                	mov    (%eax),%al
  8019e0:	0f be c0             	movsbl %al,%eax
  8019e3:	83 e8 37             	sub    $0x37,%eax
  8019e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ec:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019ef:	7d 19                	jge    801a0a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019f1:	ff 45 08             	incl   0x8(%ebp)
  8019f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019f7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019fb:	89 c2                	mov    %eax,%edx
  8019fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a00:	01 d0                	add    %edx,%eax
  801a02:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a05:	e9 7b ff ff ff       	jmp    801985 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a0a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a0f:	74 08                	je     801a19 <strtol+0x134>
		*endptr = (char *) s;
  801a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a14:	8b 55 08             	mov    0x8(%ebp),%edx
  801a17:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a19:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a1d:	74 07                	je     801a26 <strtol+0x141>
  801a1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a22:	f7 d8                	neg    %eax
  801a24:	eb 03                	jmp    801a29 <strtol+0x144>
  801a26:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <ltostr>:

void
ltostr(long value, char *str)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a38:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a43:	79 13                	jns    801a58 <ltostr+0x2d>
	{
		neg = 1;
  801a45:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a52:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a55:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a60:	99                   	cltd   
  801a61:	f7 f9                	idiv   %ecx
  801a63:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a69:	8d 50 01             	lea    0x1(%eax),%edx
  801a6c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a6f:	89 c2                	mov    %eax,%edx
  801a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a74:	01 d0                	add    %edx,%eax
  801a76:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a79:	83 c2 30             	add    $0x30,%edx
  801a7c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a81:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a86:	f7 e9                	imul   %ecx
  801a88:	c1 fa 02             	sar    $0x2,%edx
  801a8b:	89 c8                	mov    %ecx,%eax
  801a8d:	c1 f8 1f             	sar    $0x1f,%eax
  801a90:	29 c2                	sub    %eax,%edx
  801a92:	89 d0                	mov    %edx,%eax
  801a94:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801a97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a9b:	75 bb                	jne    801a58 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801aa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa7:	48                   	dec    %eax
  801aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801aab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801aaf:	74 3d                	je     801aee <ltostr+0xc3>
		start = 1 ;
  801ab1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801ab8:	eb 34                	jmp    801aee <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac0:	01 d0                	add    %edx,%eax
  801ac2:	8a 00                	mov    (%eax),%al
  801ac4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801ac7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acd:	01 c2                	add    %eax,%edx
  801acf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad5:	01 c8                	add    %ecx,%eax
  801ad7:	8a 00                	mov    (%eax),%al
  801ad9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801adb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae1:	01 c2                	add    %eax,%edx
  801ae3:	8a 45 eb             	mov    -0x15(%ebp),%al
  801ae6:	88 02                	mov    %al,(%edx)
		start++ ;
  801ae8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801aeb:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801af4:	7c c4                	jl     801aba <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801af6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afc:	01 d0                	add    %edx,%eax
  801afe:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b01:	90                   	nop
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b0a:	ff 75 08             	pushl  0x8(%ebp)
  801b0d:	e8 c4 f9 ff ff       	call   8014d6 <strlen>
  801b12:	83 c4 04             	add    $0x4,%esp
  801b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b18:	ff 75 0c             	pushl  0xc(%ebp)
  801b1b:	e8 b6 f9 ff ff       	call   8014d6 <strlen>
  801b20:	83 c4 04             	add    $0x4,%esp
  801b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b34:	eb 17                	jmp    801b4d <strcconcat+0x49>
		final[s] = str1[s] ;
  801b36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b39:	8b 45 10             	mov    0x10(%ebp),%eax
  801b3c:	01 c2                	add    %eax,%edx
  801b3e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	01 c8                	add    %ecx,%eax
  801b46:	8a 00                	mov    (%eax),%al
  801b48:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b4a:	ff 45 fc             	incl   -0x4(%ebp)
  801b4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b50:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b53:	7c e1                	jl     801b36 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b55:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b5c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b63:	eb 1f                	jmp    801b84 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b68:	8d 50 01             	lea    0x1(%eax),%edx
  801b6b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b6e:	89 c2                	mov    %eax,%edx
  801b70:	8b 45 10             	mov    0x10(%ebp),%eax
  801b73:	01 c2                	add    %eax,%edx
  801b75:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7b:	01 c8                	add    %ecx,%eax
  801b7d:	8a 00                	mov    (%eax),%al
  801b7f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b81:	ff 45 f8             	incl   -0x8(%ebp)
  801b84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b87:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b8a:	7c d9                	jl     801b65 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b8c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b92:	01 d0                	add    %edx,%eax
  801b94:	c6 00 00             	movb   $0x0,(%eax)
}
  801b97:	90                   	nop
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ba6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba9:	8b 00                	mov    (%eax),%eax
  801bab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb5:	01 d0                	add    %edx,%eax
  801bb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bbd:	eb 0c                	jmp    801bcb <strsplit+0x31>
			*string++ = 0;
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	8d 50 01             	lea    0x1(%eax),%edx
  801bc5:	89 55 08             	mov    %edx,0x8(%ebp)
  801bc8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	8a 00                	mov    (%eax),%al
  801bd0:	84 c0                	test   %al,%al
  801bd2:	74 18                	je     801bec <strsplit+0x52>
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	8a 00                	mov    (%eax),%al
  801bd9:	0f be c0             	movsbl %al,%eax
  801bdc:	50                   	push   %eax
  801bdd:	ff 75 0c             	pushl  0xc(%ebp)
  801be0:	e8 83 fa ff ff       	call   801668 <strchr>
  801be5:	83 c4 08             	add    $0x8,%esp
  801be8:	85 c0                	test   %eax,%eax
  801bea:	75 d3                	jne    801bbf <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	8a 00                	mov    (%eax),%al
  801bf1:	84 c0                	test   %al,%al
  801bf3:	74 5a                	je     801c4f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801bf5:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf8:	8b 00                	mov    (%eax),%eax
  801bfa:	83 f8 0f             	cmp    $0xf,%eax
  801bfd:	75 07                	jne    801c06 <strsplit+0x6c>
		{
			return 0;
  801bff:	b8 00 00 00 00       	mov    $0x0,%eax
  801c04:	eb 66                	jmp    801c6c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c06:	8b 45 14             	mov    0x14(%ebp),%eax
  801c09:	8b 00                	mov    (%eax),%eax
  801c0b:	8d 48 01             	lea    0x1(%eax),%ecx
  801c0e:	8b 55 14             	mov    0x14(%ebp),%edx
  801c11:	89 0a                	mov    %ecx,(%edx)
  801c13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1d:	01 c2                	add    %eax,%edx
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c24:	eb 03                	jmp    801c29 <strsplit+0x8f>
			string++;
  801c26:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8a 00                	mov    (%eax),%al
  801c2e:	84 c0                	test   %al,%al
  801c30:	74 8b                	je     801bbd <strsplit+0x23>
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	8a 00                	mov    (%eax),%al
  801c37:	0f be c0             	movsbl %al,%eax
  801c3a:	50                   	push   %eax
  801c3b:	ff 75 0c             	pushl  0xc(%ebp)
  801c3e:	e8 25 fa ff ff       	call   801668 <strchr>
  801c43:	83 c4 08             	add    $0x8,%esp
  801c46:	85 c0                	test   %eax,%eax
  801c48:	74 dc                	je     801c26 <strsplit+0x8c>
			string++;
	}
  801c4a:	e9 6e ff ff ff       	jmp    801bbd <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c4f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c50:	8b 45 14             	mov    0x14(%ebp),%eax
  801c53:	8b 00                	mov    (%eax),%eax
  801c55:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5f:	01 d0                	add    %edx,%eax
  801c61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c67:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801c7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c81:	eb 4a                	jmp    801ccd <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801c83:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	01 c2                	add    %eax,%edx
  801c8b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c91:	01 c8                	add    %ecx,%eax
  801c93:	8a 00                	mov    (%eax),%al
  801c95:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801c97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9d:	01 d0                	add    %edx,%eax
  801c9f:	8a 00                	mov    (%eax),%al
  801ca1:	3c 40                	cmp    $0x40,%al
  801ca3:	7e 25                	jle    801cca <str2lower+0x5c>
  801ca5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cab:	01 d0                	add    %edx,%eax
  801cad:	8a 00                	mov    (%eax),%al
  801caf:	3c 5a                	cmp    $0x5a,%al
  801cb1:	7f 17                	jg     801cca <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801cb3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	01 d0                	add    %edx,%eax
  801cbb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  801cc1:	01 ca                	add    %ecx,%edx
  801cc3:	8a 12                	mov    (%edx),%dl
  801cc5:	83 c2 20             	add    $0x20,%edx
  801cc8:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801cca:	ff 45 fc             	incl   -0x4(%ebp)
  801ccd:	ff 75 0c             	pushl  0xc(%ebp)
  801cd0:	e8 01 f8 ff ff       	call   8014d6 <strlen>
  801cd5:	83 c4 04             	add    $0x4,%esp
  801cd8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801cdb:	7f a6                	jg     801c83 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801cdd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801ce8:	83 ec 0c             	sub    $0xc,%esp
  801ceb:	6a 10                	push   $0x10
  801ced:	e8 b2 15 00 00       	call   8032a4 <alloc_block>
  801cf2:	83 c4 10             	add    $0x10,%esp
  801cf5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801cf8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cfc:	75 14                	jne    801d12 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801cfe:	83 ec 04             	sub    $0x4,%esp
  801d01:	68 5c 47 80 00       	push   $0x80475c
  801d06:	6a 14                	push   $0x14
  801d08:	68 85 47 80 00       	push   $0x804785
  801d0d:	e8 f5 eb ff ff       	call   800907 <_panic>

	node->start = start;
  801d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d15:	8b 55 08             	mov    0x8(%ebp),%edx
  801d18:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801d1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d20:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801d23:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801d2a:	a1 28 50 80 00       	mov    0x805028,%eax
  801d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d32:	eb 18                	jmp    801d4c <insert_page_alloc+0x6a>
		if (start < it->start)
  801d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d37:	8b 00                	mov    (%eax),%eax
  801d39:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d3c:	77 37                	ja     801d75 <insert_page_alloc+0x93>
			break;
		prev = it;
  801d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d41:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801d44:	a1 30 50 80 00       	mov    0x805030,%eax
  801d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d50:	74 08                	je     801d5a <insert_page_alloc+0x78>
  801d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d55:	8b 40 08             	mov    0x8(%eax),%eax
  801d58:	eb 05                	jmp    801d5f <insert_page_alloc+0x7d>
  801d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5f:	a3 30 50 80 00       	mov    %eax,0x805030
  801d64:	a1 30 50 80 00       	mov    0x805030,%eax
  801d69:	85 c0                	test   %eax,%eax
  801d6b:	75 c7                	jne    801d34 <insert_page_alloc+0x52>
  801d6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d71:	75 c1                	jne    801d34 <insert_page_alloc+0x52>
  801d73:	eb 01                	jmp    801d76 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801d75:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801d76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d7a:	75 64                	jne    801de0 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801d7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d80:	75 14                	jne    801d96 <insert_page_alloc+0xb4>
  801d82:	83 ec 04             	sub    $0x4,%esp
  801d85:	68 94 47 80 00       	push   $0x804794
  801d8a:	6a 21                	push   $0x21
  801d8c:	68 85 47 80 00       	push   $0x804785
  801d91:	e8 71 eb ff ff       	call   800907 <_panic>
  801d96:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801d9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9f:	89 50 08             	mov    %edx,0x8(%eax)
  801da2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da5:	8b 40 08             	mov    0x8(%eax),%eax
  801da8:	85 c0                	test   %eax,%eax
  801daa:	74 0d                	je     801db9 <insert_page_alloc+0xd7>
  801dac:	a1 28 50 80 00       	mov    0x805028,%eax
  801db1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801db4:	89 50 0c             	mov    %edx,0xc(%eax)
  801db7:	eb 08                	jmp    801dc1 <insert_page_alloc+0xdf>
  801db9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dbc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801dc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc4:	a3 28 50 80 00       	mov    %eax,0x805028
  801dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dcc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801dd3:	a1 34 50 80 00       	mov    0x805034,%eax
  801dd8:	40                   	inc    %eax
  801dd9:	a3 34 50 80 00       	mov    %eax,0x805034
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801dde:	eb 71                	jmp    801e51 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801de0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801de4:	74 06                	je     801dec <insert_page_alloc+0x10a>
  801de6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801dea:	75 14                	jne    801e00 <insert_page_alloc+0x11e>
  801dec:	83 ec 04             	sub    $0x4,%esp
  801def:	68 b8 47 80 00       	push   $0x8047b8
  801df4:	6a 23                	push   $0x23
  801df6:	68 85 47 80 00       	push   $0x804785
  801dfb:	e8 07 eb ff ff       	call   800907 <_panic>
  801e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e03:	8b 50 08             	mov    0x8(%eax),%edx
  801e06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e09:	89 50 08             	mov    %edx,0x8(%eax)
  801e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e0f:	8b 40 08             	mov    0x8(%eax),%eax
  801e12:	85 c0                	test   %eax,%eax
  801e14:	74 0c                	je     801e22 <insert_page_alloc+0x140>
  801e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e19:	8b 40 08             	mov    0x8(%eax),%eax
  801e1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e1f:	89 50 0c             	mov    %edx,0xc(%eax)
  801e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e25:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e28:	89 50 08             	mov    %edx,0x8(%eax)
  801e2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e31:	89 50 0c             	mov    %edx,0xc(%eax)
  801e34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e37:	8b 40 08             	mov    0x8(%eax),%eax
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	75 08                	jne    801e46 <insert_page_alloc+0x164>
  801e3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e41:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801e46:	a1 34 50 80 00       	mov    0x805034,%eax
  801e4b:	40                   	inc    %eax
  801e4c:	a3 34 50 80 00       	mov    %eax,0x805034
}
  801e51:	90                   	nop
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801e5a:	a1 28 50 80 00       	mov    0x805028,%eax
  801e5f:	85 c0                	test   %eax,%eax
  801e61:	75 0c                	jne    801e6f <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801e63:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e68:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801e6d:	eb 67                	jmp    801ed6 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801e6f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801e77:	a1 28 50 80 00       	mov    0x805028,%eax
  801e7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801e7f:	eb 26                	jmp    801ea7 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e84:	8b 10                	mov    (%eax),%edx
  801e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e89:	8b 40 04             	mov    0x4(%eax),%eax
  801e8c:	01 d0                	add    %edx,%eax
  801e8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e94:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801e97:	76 06                	jbe    801e9f <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801e9f:	a1 30 50 80 00       	mov    0x805030,%eax
  801ea4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801ea7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801eab:	74 08                	je     801eb5 <recompute_page_alloc_break+0x61>
  801ead:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eb0:	8b 40 08             	mov    0x8(%eax),%eax
  801eb3:	eb 05                	jmp    801eba <recompute_page_alloc_break+0x66>
  801eb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eba:	a3 30 50 80 00       	mov    %eax,0x805030
  801ebf:	a1 30 50 80 00       	mov    0x805030,%eax
  801ec4:	85 c0                	test   %eax,%eax
  801ec6:	75 b9                	jne    801e81 <recompute_page_alloc_break+0x2d>
  801ec8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ecc:	75 b3                	jne    801e81 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801ece:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ed1:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801ede:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  801ee8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801eeb:	01 d0                	add    %edx,%eax
  801eed:	48                   	dec    %eax
  801eee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801ef1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ef4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef9:	f7 75 d8             	divl   -0x28(%ebp)
  801efc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801eff:	29 d0                	sub    %edx,%eax
  801f01:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801f04:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801f08:	75 0a                	jne    801f14 <alloc_pages_custom_fit+0x3c>
		return NULL;
  801f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0f:	e9 7e 01 00 00       	jmp    802092 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801f14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801f1b:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801f1f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801f26:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801f2d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801f35:	a1 28 50 80 00       	mov    0x805028,%eax
  801f3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801f3d:	eb 69                	jmp    801fa8 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801f3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f42:	8b 00                	mov    (%eax),%eax
  801f44:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f47:	76 47                	jbe    801f90 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801f49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f4c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801f4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f52:	8b 00                	mov    (%eax),%eax
  801f54:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801f57:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801f5a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f5d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801f60:	72 2e                	jb     801f90 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801f62:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801f66:	75 14                	jne    801f7c <alloc_pages_custom_fit+0xa4>
  801f68:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f6b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801f6e:	75 0c                	jne    801f7c <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801f70:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f73:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801f76:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801f7a:	eb 14                	jmp    801f90 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801f7c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f7f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f82:	76 0c                	jbe    801f90 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801f84:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f87:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801f8a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f8d:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801f90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f93:	8b 10                	mov    (%eax),%edx
  801f95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f98:	8b 40 04             	mov    0x4(%eax),%eax
  801f9b:	01 d0                	add    %edx,%eax
  801f9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801fa0:	a1 30 50 80 00       	mov    0x805030,%eax
  801fa5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801fa8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fac:	74 08                	je     801fb6 <alloc_pages_custom_fit+0xde>
  801fae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fb1:	8b 40 08             	mov    0x8(%eax),%eax
  801fb4:	eb 05                	jmp    801fbb <alloc_pages_custom_fit+0xe3>
  801fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbb:	a3 30 50 80 00       	mov    %eax,0x805030
  801fc0:	a1 30 50 80 00       	mov    0x805030,%eax
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	0f 85 72 ff ff ff    	jne    801f3f <alloc_pages_custom_fit+0x67>
  801fcd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fd1:	0f 85 68 ff ff ff    	jne    801f3f <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801fd7:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fdc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801fdf:	76 47                	jbe    802028 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801fe1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fe4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801fe7:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fec:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801fef:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801ff2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ff5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801ff8:	72 2e                	jb     802028 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801ffa:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801ffe:	75 14                	jne    802014 <alloc_pages_custom_fit+0x13c>
  802000:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802003:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802006:	75 0c                	jne    802014 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  802008:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80200b:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  80200e:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802012:	eb 14                	jmp    802028 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  802014:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802017:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80201a:	76 0c                	jbe    802028 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  80201c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80201f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  802022:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802025:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  802028:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  80202f:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802033:	74 08                	je     80203d <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  802035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802038:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80203b:	eb 40                	jmp    80207d <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  80203d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802041:	74 08                	je     80204b <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  802043:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802046:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802049:	eb 32                	jmp    80207d <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  80204b:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802050:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802053:	89 c2                	mov    %eax,%edx
  802055:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80205a:	39 c2                	cmp    %eax,%edx
  80205c:	73 07                	jae    802065 <alloc_pages_custom_fit+0x18d>
			return NULL;
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
  802063:	eb 2d                	jmp    802092 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  802065:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80206a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  80206d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802073:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802076:	01 d0                	add    %edx,%eax
  802078:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  80207d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802080:	83 ec 08             	sub    $0x8,%esp
  802083:	ff 75 d0             	pushl  -0x30(%ebp)
  802086:	50                   	push   %eax
  802087:	e8 56 fc ff ff       	call   801ce2 <insert_page_alloc>
  80208c:	83 c4 10             	add    $0x10,%esp

	return result;
  80208f:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8020a0:	a1 28 50 80 00       	mov    0x805028,%eax
  8020a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020a8:	eb 1a                	jmp    8020c4 <find_allocated_size+0x30>
		if (it->start == va)
  8020aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ad:	8b 00                	mov    (%eax),%eax
  8020af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8020b2:	75 08                	jne    8020bc <find_allocated_size+0x28>
			return it->size;
  8020b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020b7:	8b 40 04             	mov    0x4(%eax),%eax
  8020ba:	eb 34                	jmp    8020f0 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8020bc:	a1 30 50 80 00       	mov    0x805030,%eax
  8020c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020c8:	74 08                	je     8020d2 <find_allocated_size+0x3e>
  8020ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020cd:	8b 40 08             	mov    0x8(%eax),%eax
  8020d0:	eb 05                	jmp    8020d7 <find_allocated_size+0x43>
  8020d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d7:	a3 30 50 80 00       	mov    %eax,0x805030
  8020dc:	a1 30 50 80 00       	mov    0x805030,%eax
  8020e1:	85 c0                	test   %eax,%eax
  8020e3:	75 c5                	jne    8020aa <find_allocated_size+0x16>
  8020e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020e9:	75 bf                	jne    8020aa <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  8020eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8020fe:	a1 28 50 80 00       	mov    0x805028,%eax
  802103:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802106:	e9 e1 01 00 00       	jmp    8022ec <free_pages+0x1fa>
		if (it->start == va) {
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210e:	8b 00                	mov    (%eax),%eax
  802110:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802113:	0f 85 cb 01 00 00    	jne    8022e4 <free_pages+0x1f2>

			uint32 start = it->start;
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211c:	8b 00                	mov    (%eax),%eax
  80211e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  802121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802124:	8b 40 04             	mov    0x4(%eax),%eax
  802127:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  80212a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80212d:	f7 d0                	not    %eax
  80212f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802132:	73 1d                	jae    802151 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  802134:	83 ec 0c             	sub    $0xc,%esp
  802137:	ff 75 e4             	pushl  -0x1c(%ebp)
  80213a:	ff 75 e8             	pushl  -0x18(%ebp)
  80213d:	68 ec 47 80 00       	push   $0x8047ec
  802142:	68 a5 00 00 00       	push   $0xa5
  802147:	68 85 47 80 00       	push   $0x804785
  80214c:	e8 b6 e7 ff ff       	call   800907 <_panic>
			}

			uint32 start_end = start + size;
  802151:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802157:	01 d0                	add    %edx,%eax
  802159:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  80215c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80215f:	85 c0                	test   %eax,%eax
  802161:	79 19                	jns    80217c <free_pages+0x8a>
  802163:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80216a:	77 10                	ja     80217c <free_pages+0x8a>
  80216c:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  802173:	77 07                	ja     80217c <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  802175:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802178:	85 c0                	test   %eax,%eax
  80217a:	78 2c                	js     8021a8 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  80217c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80217f:	83 ec 0c             	sub    $0xc,%esp
  802182:	68 00 00 00 a0       	push   $0xa0000000
  802187:	ff 75 e0             	pushl  -0x20(%ebp)
  80218a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80218d:	ff 75 e8             	pushl  -0x18(%ebp)
  802190:	ff 75 e4             	pushl  -0x1c(%ebp)
  802193:	50                   	push   %eax
  802194:	68 30 48 80 00       	push   $0x804830
  802199:	68 ad 00 00 00       	push   $0xad
  80219e:	68 85 47 80 00       	push   $0x804785
  8021a3:	e8 5f e7 ff ff       	call   800907 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8021a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021ae:	e9 88 00 00 00       	jmp    80223b <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  8021b3:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  8021ba:	76 17                	jbe    8021d3 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  8021bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8021bf:	68 94 48 80 00       	push   $0x804894
  8021c4:	68 b4 00 00 00       	push   $0xb4
  8021c9:	68 85 47 80 00       	push   $0x804785
  8021ce:	e8 34 e7 ff ff       	call   800907 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  8021d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d6:	05 00 10 00 00       	add    $0x1000,%eax
  8021db:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  8021de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	79 2e                	jns    802213 <free_pages+0x121>
  8021e5:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8021ec:	77 25                	ja     802213 <free_pages+0x121>
  8021ee:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8021f5:	77 1c                	ja     802213 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  8021f7:	83 ec 08             	sub    $0x8,%esp
  8021fa:	68 00 10 00 00       	push   $0x1000
  8021ff:	ff 75 f0             	pushl  -0x10(%ebp)
  802202:	e8 38 0d 00 00       	call   802f3f <sys_free_user_mem>
  802207:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  80220a:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802211:	eb 28                	jmp    80223b <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  802213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802216:	68 00 00 00 a0       	push   $0xa0000000
  80221b:	ff 75 dc             	pushl  -0x24(%ebp)
  80221e:	68 00 10 00 00       	push   $0x1000
  802223:	ff 75 f0             	pushl  -0x10(%ebp)
  802226:	50                   	push   %eax
  802227:	68 d4 48 80 00       	push   $0x8048d4
  80222c:	68 bd 00 00 00       	push   $0xbd
  802231:	68 85 47 80 00       	push   $0x804785
  802236:	e8 cc e6 ff ff       	call   800907 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  80223b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802241:	0f 82 6c ff ff ff    	jb     8021b3 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802247:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80224b:	75 17                	jne    802264 <free_pages+0x172>
  80224d:	83 ec 04             	sub    $0x4,%esp
  802250:	68 36 49 80 00       	push   $0x804936
  802255:	68 c1 00 00 00       	push   $0xc1
  80225a:	68 85 47 80 00       	push   $0x804785
  80225f:	e8 a3 e6 ff ff       	call   800907 <_panic>
  802264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802267:	8b 40 08             	mov    0x8(%eax),%eax
  80226a:	85 c0                	test   %eax,%eax
  80226c:	74 11                	je     80227f <free_pages+0x18d>
  80226e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802271:	8b 40 08             	mov    0x8(%eax),%eax
  802274:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802277:	8b 52 0c             	mov    0xc(%edx),%edx
  80227a:	89 50 0c             	mov    %edx,0xc(%eax)
  80227d:	eb 0b                	jmp    80228a <free_pages+0x198>
  80227f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802282:	8b 40 0c             	mov    0xc(%eax),%eax
  802285:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	8b 40 0c             	mov    0xc(%eax),%eax
  802290:	85 c0                	test   %eax,%eax
  802292:	74 11                	je     8022a5 <free_pages+0x1b3>
  802294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802297:	8b 40 0c             	mov    0xc(%eax),%eax
  80229a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229d:	8b 52 08             	mov    0x8(%edx),%edx
  8022a0:	89 50 08             	mov    %edx,0x8(%eax)
  8022a3:	eb 0b                	jmp    8022b0 <free_pages+0x1be>
  8022a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a8:	8b 40 08             	mov    0x8(%eax),%eax
  8022ab:	a3 28 50 80 00       	mov    %eax,0x805028
  8022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8022c4:	a1 34 50 80 00       	mov    0x805034,%eax
  8022c9:	48                   	dec    %eax
  8022ca:	a3 34 50 80 00       	mov    %eax,0x805034
			free_block(it);
  8022cf:	83 ec 0c             	sub    $0xc,%esp
  8022d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d5:	e8 24 15 00 00       	call   8037fe <free_block>
  8022da:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  8022dd:	e8 72 fb ff ff       	call   801e54 <recompute_page_alloc_break>

			return;
  8022e2:	eb 37                	jmp    80231b <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8022e4:	a1 30 50 80 00       	mov    0x805030,%eax
  8022e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f0:	74 08                	je     8022fa <free_pages+0x208>
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	8b 40 08             	mov    0x8(%eax),%eax
  8022f8:	eb 05                	jmp    8022ff <free_pages+0x20d>
  8022fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ff:	a3 30 50 80 00       	mov    %eax,0x805030
  802304:	a1 30 50 80 00       	mov    0x805030,%eax
  802309:	85 c0                	test   %eax,%eax
  80230b:	0f 85 fa fd ff ff    	jne    80210b <free_pages+0x19>
  802311:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802315:	0f 85 f0 fd ff ff    	jne    80210b <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  802320:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802325:	5d                   	pop    %ebp
  802326:	c3                   	ret    

00802327 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80232d:	a1 08 50 80 00       	mov    0x805008,%eax
  802332:	85 c0                	test   %eax,%eax
  802334:	74 60                	je     802396 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802336:	83 ec 08             	sub    $0x8,%esp
  802339:	68 00 00 00 82       	push   $0x82000000
  80233e:	68 00 00 00 80       	push   $0x80000000
  802343:	e8 0d 0d 00 00       	call   803055 <initialize_dynamic_allocator>
  802348:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80234b:	e8 f3 0a 00 00       	call   802e43 <sys_get_uheap_strategy>
  802350:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802355:	a1 40 50 80 00       	mov    0x805040,%eax
  80235a:	05 00 10 00 00       	add    $0x1000,%eax
  80235f:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  802364:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802369:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  80236e:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  802375:	00 00 00 
  802378:	c7 05 2c 50 80 00 00 	movl   $0x0,0x80502c
  80237f:	00 00 00 
  802382:	c7 05 34 50 80 00 00 	movl   $0x0,0x805034
  802389:	00 00 00 

		__firstTimeFlag = 0;
  80238c:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  802393:	00 00 00 
	}
}
  802396:	90                   	nop
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80239f:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8023ad:	83 ec 08             	sub    $0x8,%esp
  8023b0:	68 06 04 00 00       	push   $0x406
  8023b5:	50                   	push   %eax
  8023b6:	e8 d2 06 00 00       	call   802a8d <__sys_allocate_page>
  8023bb:	83 c4 10             	add    $0x10,%esp
  8023be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8023c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023c5:	79 17                	jns    8023de <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  8023c7:	83 ec 04             	sub    $0x4,%esp
  8023ca:	68 54 49 80 00       	push   $0x804954
  8023cf:	68 ea 00 00 00       	push   $0xea
  8023d4:	68 85 47 80 00       	push   $0x804785
  8023d9:	e8 29 e5 ff ff       	call   800907 <_panic>
	return 0;
  8023de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
  8023e8:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8023f9:	83 ec 0c             	sub    $0xc,%esp
  8023fc:	50                   	push   %eax
  8023fd:	e8 d2 06 00 00       	call   802ad4 <__sys_unmap_frame>
  802402:	83 c4 10             	add    $0x10,%esp
  802405:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802408:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80240c:	79 17                	jns    802425 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  80240e:	83 ec 04             	sub    $0x4,%esp
  802411:	68 90 49 80 00       	push   $0x804990
  802416:	68 f5 00 00 00       	push   $0xf5
  80241b:	68 85 47 80 00       	push   $0x804785
  802420:	e8 e2 e4 ff ff       	call   800907 <_panic>
}
  802425:	90                   	nop
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80242e:	e8 f4 fe ff ff       	call   802327 <uheap_init>
	if (size == 0) return NULL ;
  802433:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802437:	75 0a                	jne    802443 <malloc+0x1b>
  802439:	b8 00 00 00 00       	mov    $0x0,%eax
  80243e:	e9 67 01 00 00       	jmp    8025aa <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  802443:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80244a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802451:	77 16                	ja     802469 <malloc+0x41>
		result = alloc_block(size);
  802453:	83 ec 0c             	sub    $0xc,%esp
  802456:	ff 75 08             	pushl  0x8(%ebp)
  802459:	e8 46 0e 00 00       	call   8032a4 <alloc_block>
  80245e:	83 c4 10             	add    $0x10,%esp
  802461:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802464:	e9 3e 01 00 00       	jmp    8025a7 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802469:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802470:	8b 55 08             	mov    0x8(%ebp),%edx
  802473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802476:	01 d0                	add    %edx,%eax
  802478:	48                   	dec    %eax
  802479:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80247c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247f:	ba 00 00 00 00       	mov    $0x0,%edx
  802484:	f7 75 f0             	divl   -0x10(%ebp)
  802487:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248a:	29 d0                	sub    %edx,%eax
  80248c:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  80248f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	75 0a                	jne    8024a2 <malloc+0x7a>
			return NULL;
  802498:	b8 00 00 00 00       	mov    $0x0,%eax
  80249d:	e9 08 01 00 00       	jmp    8025aa <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  8024a2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	74 0f                	je     8024ba <malloc+0x92>
  8024ab:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8024b1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8024b6:	39 c2                	cmp    %eax,%edx
  8024b8:	73 0a                	jae    8024c4 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  8024ba:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8024bf:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8024c4:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8024c9:	83 f8 05             	cmp    $0x5,%eax
  8024cc:	75 11                	jne    8024df <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  8024ce:	83 ec 0c             	sub    $0xc,%esp
  8024d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8024d4:	e8 ff f9 ff ff       	call   801ed8 <alloc_pages_custom_fit>
  8024d9:	83 c4 10             	add    $0x10,%esp
  8024dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  8024df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e3:	0f 84 be 00 00 00    	je     8025a7 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  8024ef:	83 ec 0c             	sub    $0xc,%esp
  8024f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8024f5:	e8 9a fb ff ff       	call   802094 <find_allocated_size>
  8024fa:	83 c4 10             	add    $0x10,%esp
  8024fd:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  802500:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802504:	75 17                	jne    80251d <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802506:	ff 75 f4             	pushl  -0xc(%ebp)
  802509:	68 d0 49 80 00       	push   $0x8049d0
  80250e:	68 24 01 00 00       	push   $0x124
  802513:	68 85 47 80 00       	push   $0x804785
  802518:	e8 ea e3 ff ff       	call   800907 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  80251d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802520:	f7 d0                	not    %eax
  802522:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802525:	73 1d                	jae    802544 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  802527:	83 ec 0c             	sub    $0xc,%esp
  80252a:	ff 75 e0             	pushl  -0x20(%ebp)
  80252d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802530:	68 18 4a 80 00       	push   $0x804a18
  802535:	68 29 01 00 00       	push   $0x129
  80253a:	68 85 47 80 00       	push   $0x804785
  80253f:	e8 c3 e3 ff ff       	call   800907 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  802544:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802547:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80254a:	01 d0                	add    %edx,%eax
  80254c:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  80254f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802552:	85 c0                	test   %eax,%eax
  802554:	79 2c                	jns    802582 <malloc+0x15a>
  802556:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  80255d:	77 23                	ja     802582 <malloc+0x15a>
  80255f:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802566:	77 1a                	ja     802582 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  802568:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	79 13                	jns    802582 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  80256f:	83 ec 08             	sub    $0x8,%esp
  802572:	ff 75 e0             	pushl  -0x20(%ebp)
  802575:	ff 75 e4             	pushl  -0x1c(%ebp)
  802578:	e8 de 09 00 00       	call   802f5b <sys_allocate_user_mem>
  80257d:	83 c4 10             	add    $0x10,%esp
  802580:	eb 25                	jmp    8025a7 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  802582:	68 00 00 00 a0       	push   $0xa0000000
  802587:	ff 75 dc             	pushl  -0x24(%ebp)
  80258a:	ff 75 e0             	pushl  -0x20(%ebp)
  80258d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802590:	ff 75 f4             	pushl  -0xc(%ebp)
  802593:	68 54 4a 80 00       	push   $0x804a54
  802598:	68 33 01 00 00       	push   $0x133
  80259d:	68 85 47 80 00       	push   $0x804785
  8025a2:	e8 60 e3 ff ff       	call   800907 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  8025aa:	c9                   	leave  
  8025ab:	c3                   	ret    

008025ac <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8025ac:	55                   	push   %ebp
  8025ad:	89 e5                	mov    %esp,%ebp
  8025af:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8025b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025b6:	0f 84 26 01 00 00    	je     8026e2 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  8025bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bf:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	79 1c                	jns    8025e5 <free+0x39>
  8025c9:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  8025d0:	77 13                	ja     8025e5 <free+0x39>
		free_block(virtual_address);
  8025d2:	83 ec 0c             	sub    $0xc,%esp
  8025d5:	ff 75 08             	pushl  0x8(%ebp)
  8025d8:	e8 21 12 00 00       	call   8037fe <free_block>
  8025dd:	83 c4 10             	add    $0x10,%esp
		return;
  8025e0:	e9 01 01 00 00       	jmp    8026e6 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  8025e5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025ea:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8025ed:	0f 82 d8 00 00 00    	jb     8026cb <free+0x11f>
  8025f3:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  8025fa:	0f 87 cb 00 00 00    	ja     8026cb <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	25 ff 0f 00 00       	and    $0xfff,%eax
  802608:	85 c0                	test   %eax,%eax
  80260a:	74 17                	je     802623 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  80260c:	ff 75 08             	pushl  0x8(%ebp)
  80260f:	68 c4 4a 80 00       	push   $0x804ac4
  802614:	68 57 01 00 00       	push   $0x157
  802619:	68 85 47 80 00       	push   $0x804785
  80261e:	e8 e4 e2 ff ff       	call   800907 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  802623:	83 ec 0c             	sub    $0xc,%esp
  802626:	ff 75 08             	pushl  0x8(%ebp)
  802629:	e8 66 fa ff ff       	call   802094 <find_allocated_size>
  80262e:	83 c4 10             	add    $0x10,%esp
  802631:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  802634:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802638:	0f 84 a7 00 00 00    	je     8026e5 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  80263e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802641:	f7 d0                	not    %eax
  802643:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802646:	73 1d                	jae    802665 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  802648:	83 ec 0c             	sub    $0xc,%esp
  80264b:	ff 75 f0             	pushl  -0x10(%ebp)
  80264e:	ff 75 f4             	pushl  -0xc(%ebp)
  802651:	68 ec 4a 80 00       	push   $0x804aec
  802656:	68 61 01 00 00       	push   $0x161
  80265b:	68 85 47 80 00       	push   $0x804785
  802660:	e8 a2 e2 ff ff       	call   800907 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  802665:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266b:	01 d0                	add    %edx,%eax
  80266d:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	85 c0                	test   %eax,%eax
  802675:	79 19                	jns    802690 <free+0xe4>
  802677:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  80267e:	77 10                	ja     802690 <free+0xe4>
  802680:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  802687:	77 07                	ja     802690 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  802689:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268c:	85 c0                	test   %eax,%eax
  80268e:	78 2b                	js     8026bb <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  802690:	83 ec 0c             	sub    $0xc,%esp
  802693:	68 00 00 00 a0       	push   $0xa0000000
  802698:	ff 75 ec             	pushl  -0x14(%ebp)
  80269b:	ff 75 f0             	pushl  -0x10(%ebp)
  80269e:	ff 75 f4             	pushl  -0xc(%ebp)
  8026a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8026a4:	ff 75 08             	pushl  0x8(%ebp)
  8026a7:	68 28 4b 80 00       	push   $0x804b28
  8026ac:	68 69 01 00 00       	push   $0x169
  8026b1:	68 85 47 80 00       	push   $0x804785
  8026b6:	e8 4c e2 ff ff       	call   800907 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  8026bb:	83 ec 0c             	sub    $0xc,%esp
  8026be:	ff 75 08             	pushl  0x8(%ebp)
  8026c1:	e8 2c fa ff ff       	call   8020f2 <free_pages>
  8026c6:	83 c4 10             	add    $0x10,%esp
		return;
  8026c9:	eb 1b                	jmp    8026e6 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  8026cb:	ff 75 08             	pushl  0x8(%ebp)
  8026ce:	68 84 4b 80 00       	push   $0x804b84
  8026d3:	68 70 01 00 00       	push   $0x170
  8026d8:	68 85 47 80 00       	push   $0x804785
  8026dd:	e8 25 e2 ff ff       	call   800907 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8026e2:	90                   	nop
  8026e3:	eb 01                	jmp    8026e6 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  8026e5:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
  8026eb:	83 ec 38             	sub    $0x38,%esp
  8026ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8026f1:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8026f4:	e8 2e fc ff ff       	call   802327 <uheap_init>
	if (size == 0) return NULL ;
  8026f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026fd:	75 0a                	jne    802709 <smalloc+0x21>
  8026ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802704:	e9 3d 01 00 00       	jmp    802846 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  802709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80270c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  80270f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802712:	25 ff 0f 00 00       	and    $0xfff,%eax
  802717:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  80271a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80271e:	74 0e                	je     80272e <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802726:	05 00 10 00 00       	add    $0x1000,%eax
  80272b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	c1 e8 0c             	shr    $0xc,%eax
  802734:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802737:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80273c:	85 c0                	test   %eax,%eax
  80273e:	75 0a                	jne    80274a <smalloc+0x62>
		return NULL;
  802740:	b8 00 00 00 00       	mov    $0x0,%eax
  802745:	e9 fc 00 00 00       	jmp    802846 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80274a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80274f:	85 c0                	test   %eax,%eax
  802751:	74 0f                	je     802762 <smalloc+0x7a>
  802753:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802759:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80275e:	39 c2                	cmp    %eax,%edx
  802760:	73 0a                	jae    80276c <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  802762:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802767:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80276c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802771:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802776:	29 c2                	sub    %eax,%edx
  802778:	89 d0                	mov    %edx,%eax
  80277a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80277d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802783:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802788:	29 c2                	sub    %eax,%edx
  80278a:	89 d0                	mov    %edx,%eax
  80278c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802795:	77 13                	ja     8027aa <smalloc+0xc2>
  802797:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80279d:	77 0b                	ja     8027aa <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  80279f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a2:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8027a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8027a8:	73 0a                	jae    8027b4 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  8027aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8027af:	e9 92 00 00 00       	jmp    802846 <smalloc+0x15e>
	}

	void *va = NULL;
  8027b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8027bb:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8027c0:	83 f8 05             	cmp    $0x5,%eax
  8027c3:	75 11                	jne    8027d6 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  8027c5:	83 ec 0c             	sub    $0xc,%esp
  8027c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8027cb:	e8 08 f7 ff ff       	call   801ed8 <alloc_pages_custom_fit>
  8027d0:	83 c4 10             	add    $0x10,%esp
  8027d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  8027d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027da:	75 27                	jne    802803 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8027dc:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  8027e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027e6:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8027e9:	89 c2                	mov    %eax,%edx
  8027eb:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8027f0:	39 c2                	cmp    %eax,%edx
  8027f2:	73 07                	jae    8027fb <smalloc+0x113>
			return NULL;}
  8027f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f9:	eb 4b                	jmp    802846 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  8027fb:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802800:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  802803:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802807:	ff 75 f0             	pushl  -0x10(%ebp)
  80280a:	50                   	push   %eax
  80280b:	ff 75 0c             	pushl  0xc(%ebp)
  80280e:	ff 75 08             	pushl  0x8(%ebp)
  802811:	e8 cb 03 00 00       	call   802be1 <sys_create_shared_object>
  802816:	83 c4 10             	add    $0x10,%esp
  802819:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80281c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802820:	79 07                	jns    802829 <smalloc+0x141>
		return NULL;
  802822:	b8 00 00 00 00       	mov    $0x0,%eax
  802827:	eb 1d                	jmp    802846 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802829:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80282e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802831:	75 10                	jne    802843 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802833:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	01 d0                	add    %edx,%eax
  80283e:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  802843:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802846:	c9                   	leave  
  802847:	c3                   	ret    

00802848 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802848:	55                   	push   %ebp
  802849:	89 e5                	mov    %esp,%ebp
  80284b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80284e:	e8 d4 fa ff ff       	call   802327 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802853:	83 ec 08             	sub    $0x8,%esp
  802856:	ff 75 0c             	pushl  0xc(%ebp)
  802859:	ff 75 08             	pushl  0x8(%ebp)
  80285c:	e8 aa 03 00 00       	call   802c0b <sys_size_of_shared_object>
  802861:	83 c4 10             	add    $0x10,%esp
  802864:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802867:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80286b:	7f 0a                	jg     802877 <sget+0x2f>
		return NULL;
  80286d:	b8 00 00 00 00       	mov    $0x0,%eax
  802872:	e9 32 01 00 00       	jmp    8029a9 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  802877:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  80287d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802880:	25 ff 0f 00 00       	and    $0xfff,%eax
  802885:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  802888:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80288c:	74 0e                	je     80289c <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802894:	05 00 10 00 00       	add    $0x1000,%eax
  802899:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  80289c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8028a1:	85 c0                	test   %eax,%eax
  8028a3:	75 0a                	jne    8028af <sget+0x67>
		return NULL;
  8028a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028aa:	e9 fa 00 00 00       	jmp    8029a9 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8028af:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8028b4:	85 c0                	test   %eax,%eax
  8028b6:	74 0f                	je     8028c7 <sget+0x7f>
  8028b8:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8028be:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8028c3:	39 c2                	cmp    %eax,%edx
  8028c5:	73 0a                	jae    8028d1 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8028c7:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8028cc:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8028d1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8028d6:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8028db:	29 c2                	sub    %eax,%edx
  8028dd:	89 d0                	mov    %edx,%eax
  8028df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8028e2:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8028e8:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8028ed:	29 c2                	sub    %eax,%edx
  8028ef:	89 d0                	mov    %edx,%eax
  8028f1:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8028fa:	77 13                	ja     80290f <sget+0xc7>
  8028fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ff:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802902:	77 0b                	ja     80290f <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802904:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802907:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80290a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80290d:	73 0a                	jae    802919 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  80290f:	b8 00 00 00 00       	mov    $0x0,%eax
  802914:	e9 90 00 00 00       	jmp    8029a9 <sget+0x161>

	void *va = NULL;
  802919:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802920:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802925:	83 f8 05             	cmp    $0x5,%eax
  802928:	75 11                	jne    80293b <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80292a:	83 ec 0c             	sub    $0xc,%esp
  80292d:	ff 75 f4             	pushl  -0xc(%ebp)
  802930:	e8 a3 f5 ff ff       	call   801ed8 <alloc_pages_custom_fit>
  802935:	83 c4 10             	add    $0x10,%esp
  802938:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  80293b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80293f:	75 27                	jne    802968 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802941:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802948:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80294b:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80294e:	89 c2                	mov    %eax,%edx
  802950:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802955:	39 c2                	cmp    %eax,%edx
  802957:	73 07                	jae    802960 <sget+0x118>
			return NULL;
  802959:	b8 00 00 00 00       	mov    $0x0,%eax
  80295e:	eb 49                	jmp    8029a9 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802960:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802965:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802968:	83 ec 04             	sub    $0x4,%esp
  80296b:	ff 75 f0             	pushl  -0x10(%ebp)
  80296e:	ff 75 0c             	pushl  0xc(%ebp)
  802971:	ff 75 08             	pushl  0x8(%ebp)
  802974:	e8 af 02 00 00       	call   802c28 <sys_get_shared_object>
  802979:	83 c4 10             	add    $0x10,%esp
  80297c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  80297f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802983:	79 07                	jns    80298c <sget+0x144>
		return NULL;
  802985:	b8 00 00 00 00       	mov    $0x0,%eax
  80298a:	eb 1d                	jmp    8029a9 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  80298c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802991:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802994:	75 10                	jne    8029a6 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802996:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	01 d0                	add    %edx,%eax
  8029a1:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8029a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8029a9:	c9                   	leave  
  8029aa:	c3                   	ret    

008029ab <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8029ab:	55                   	push   %ebp
  8029ac:	89 e5                	mov    %esp,%ebp
  8029ae:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8029b1:	e8 71 f9 ff ff       	call   802327 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8029b6:	83 ec 04             	sub    $0x4,%esp
  8029b9:	68 a8 4b 80 00       	push   $0x804ba8
  8029be:	68 19 02 00 00       	push   $0x219
  8029c3:	68 85 47 80 00       	push   $0x804785
  8029c8:	e8 3a df ff ff       	call   800907 <_panic>

008029cd <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8029cd:	55                   	push   %ebp
  8029ce:	89 e5                	mov    %esp,%ebp
  8029d0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8029d3:	83 ec 04             	sub    $0x4,%esp
  8029d6:	68 d0 4b 80 00       	push   $0x804bd0
  8029db:	68 2b 02 00 00       	push   $0x22b
  8029e0:	68 85 47 80 00       	push   $0x804785
  8029e5:	e8 1d df ff ff       	call   800907 <_panic>

008029ea <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8029ea:	55                   	push   %ebp
  8029eb:	89 e5                	mov    %esp,%ebp
  8029ed:	57                   	push   %edi
  8029ee:	56                   	push   %esi
  8029ef:	53                   	push   %ebx
  8029f0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8029ff:	8b 7d 18             	mov    0x18(%ebp),%edi
  802a02:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802a05:	cd 30                	int    $0x30
  802a07:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802a0d:	83 c4 10             	add    $0x10,%esp
  802a10:	5b                   	pop    %ebx
  802a11:	5e                   	pop    %esi
  802a12:	5f                   	pop    %edi
  802a13:	5d                   	pop    %ebp
  802a14:	c3                   	ret    

00802a15 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802a15:	55                   	push   %ebp
  802a16:	89 e5                	mov    %esp,%ebp
  802a18:	83 ec 04             	sub    $0x4,%esp
  802a1b:	8b 45 10             	mov    0x10(%ebp),%eax
  802a1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802a21:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a24:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	6a 00                	push   $0x0
  802a2d:	51                   	push   %ecx
  802a2e:	52                   	push   %edx
  802a2f:	ff 75 0c             	pushl  0xc(%ebp)
  802a32:	50                   	push   %eax
  802a33:	6a 00                	push   $0x0
  802a35:	e8 b0 ff ff ff       	call   8029ea <syscall>
  802a3a:	83 c4 18             	add    $0x18,%esp
}
  802a3d:	90                   	nop
  802a3e:	c9                   	leave  
  802a3f:	c3                   	ret    

00802a40 <sys_cgetc>:

int
sys_cgetc(void)
{
  802a40:	55                   	push   %ebp
  802a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802a43:	6a 00                	push   $0x0
  802a45:	6a 00                	push   $0x0
  802a47:	6a 00                	push   $0x0
  802a49:	6a 00                	push   $0x0
  802a4b:	6a 00                	push   $0x0
  802a4d:	6a 02                	push   $0x2
  802a4f:	e8 96 ff ff ff       	call   8029ea <syscall>
  802a54:	83 c4 18             	add    $0x18,%esp
}
  802a57:	c9                   	leave  
  802a58:	c3                   	ret    

00802a59 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802a59:	55                   	push   %ebp
  802a5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802a5c:	6a 00                	push   $0x0
  802a5e:	6a 00                	push   $0x0
  802a60:	6a 00                	push   $0x0
  802a62:	6a 00                	push   $0x0
  802a64:	6a 00                	push   $0x0
  802a66:	6a 03                	push   $0x3
  802a68:	e8 7d ff ff ff       	call   8029ea <syscall>
  802a6d:	83 c4 18             	add    $0x18,%esp
}
  802a70:	90                   	nop
  802a71:	c9                   	leave  
  802a72:	c3                   	ret    

00802a73 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802a73:	55                   	push   %ebp
  802a74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802a76:	6a 00                	push   $0x0
  802a78:	6a 00                	push   $0x0
  802a7a:	6a 00                	push   $0x0
  802a7c:	6a 00                	push   $0x0
  802a7e:	6a 00                	push   $0x0
  802a80:	6a 04                	push   $0x4
  802a82:	e8 63 ff ff ff       	call   8029ea <syscall>
  802a87:	83 c4 18             	add    $0x18,%esp
}
  802a8a:	90                   	nop
  802a8b:	c9                   	leave  
  802a8c:	c3                   	ret    

00802a8d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802a8d:	55                   	push   %ebp
  802a8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802a90:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	6a 00                	push   $0x0
  802a98:	6a 00                	push   $0x0
  802a9a:	6a 00                	push   $0x0
  802a9c:	52                   	push   %edx
  802a9d:	50                   	push   %eax
  802a9e:	6a 08                	push   $0x8
  802aa0:	e8 45 ff ff ff       	call   8029ea <syscall>
  802aa5:	83 c4 18             	add    $0x18,%esp
}
  802aa8:	c9                   	leave  
  802aa9:	c3                   	ret    

00802aaa <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802aaa:	55                   	push   %ebp
  802aab:	89 e5                	mov    %esp,%ebp
  802aad:	56                   	push   %esi
  802aae:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802aaf:	8b 75 18             	mov    0x18(%ebp),%esi
  802ab2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ab5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	56                   	push   %esi
  802abf:	53                   	push   %ebx
  802ac0:	51                   	push   %ecx
  802ac1:	52                   	push   %edx
  802ac2:	50                   	push   %eax
  802ac3:	6a 09                	push   $0x9
  802ac5:	e8 20 ff ff ff       	call   8029ea <syscall>
  802aca:	83 c4 18             	add    $0x18,%esp
}
  802acd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ad0:	5b                   	pop    %ebx
  802ad1:	5e                   	pop    %esi
  802ad2:	5d                   	pop    %ebp
  802ad3:	c3                   	ret    

00802ad4 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802ad4:	55                   	push   %ebp
  802ad5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802ad7:	6a 00                	push   $0x0
  802ad9:	6a 00                	push   $0x0
  802adb:	6a 00                	push   $0x0
  802add:	6a 00                	push   $0x0
  802adf:	ff 75 08             	pushl  0x8(%ebp)
  802ae2:	6a 0a                	push   $0xa
  802ae4:	e8 01 ff ff ff       	call   8029ea <syscall>
  802ae9:	83 c4 18             	add    $0x18,%esp
}
  802aec:	c9                   	leave  
  802aed:	c3                   	ret    

00802aee <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802aee:	55                   	push   %ebp
  802aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802af1:	6a 00                	push   $0x0
  802af3:	6a 00                	push   $0x0
  802af5:	6a 00                	push   $0x0
  802af7:	ff 75 0c             	pushl  0xc(%ebp)
  802afa:	ff 75 08             	pushl  0x8(%ebp)
  802afd:	6a 0b                	push   $0xb
  802aff:	e8 e6 fe ff ff       	call   8029ea <syscall>
  802b04:	83 c4 18             	add    $0x18,%esp
}
  802b07:	c9                   	leave  
  802b08:	c3                   	ret    

00802b09 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802b09:	55                   	push   %ebp
  802b0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802b0c:	6a 00                	push   $0x0
  802b0e:	6a 00                	push   $0x0
  802b10:	6a 00                	push   $0x0
  802b12:	6a 00                	push   $0x0
  802b14:	6a 00                	push   $0x0
  802b16:	6a 0c                	push   $0xc
  802b18:	e8 cd fe ff ff       	call   8029ea <syscall>
  802b1d:	83 c4 18             	add    $0x18,%esp
}
  802b20:	c9                   	leave  
  802b21:	c3                   	ret    

00802b22 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802b22:	55                   	push   %ebp
  802b23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802b25:	6a 00                	push   $0x0
  802b27:	6a 00                	push   $0x0
  802b29:	6a 00                	push   $0x0
  802b2b:	6a 00                	push   $0x0
  802b2d:	6a 00                	push   $0x0
  802b2f:	6a 0d                	push   $0xd
  802b31:	e8 b4 fe ff ff       	call   8029ea <syscall>
  802b36:	83 c4 18             	add    $0x18,%esp
}
  802b39:	c9                   	leave  
  802b3a:	c3                   	ret    

00802b3b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802b3b:	55                   	push   %ebp
  802b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802b3e:	6a 00                	push   $0x0
  802b40:	6a 00                	push   $0x0
  802b42:	6a 00                	push   $0x0
  802b44:	6a 00                	push   $0x0
  802b46:	6a 00                	push   $0x0
  802b48:	6a 0e                	push   $0xe
  802b4a:	e8 9b fe ff ff       	call   8029ea <syscall>
  802b4f:	83 c4 18             	add    $0x18,%esp
}
  802b52:	c9                   	leave  
  802b53:	c3                   	ret    

00802b54 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802b54:	55                   	push   %ebp
  802b55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802b57:	6a 00                	push   $0x0
  802b59:	6a 00                	push   $0x0
  802b5b:	6a 00                	push   $0x0
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 00                	push   $0x0
  802b61:	6a 0f                	push   $0xf
  802b63:	e8 82 fe ff ff       	call   8029ea <syscall>
  802b68:	83 c4 18             	add    $0x18,%esp
}
  802b6b:	c9                   	leave  
  802b6c:	c3                   	ret    

00802b6d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802b6d:	55                   	push   %ebp
  802b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	6a 00                	push   $0x0
  802b78:	ff 75 08             	pushl  0x8(%ebp)
  802b7b:	6a 10                	push   $0x10
  802b7d:	e8 68 fe ff ff       	call   8029ea <syscall>
  802b82:	83 c4 18             	add    $0x18,%esp
}
  802b85:	c9                   	leave  
  802b86:	c3                   	ret    

00802b87 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802b87:	55                   	push   %ebp
  802b88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802b8a:	6a 00                	push   $0x0
  802b8c:	6a 00                	push   $0x0
  802b8e:	6a 00                	push   $0x0
  802b90:	6a 00                	push   $0x0
  802b92:	6a 00                	push   $0x0
  802b94:	6a 11                	push   $0x11
  802b96:	e8 4f fe ff ff       	call   8029ea <syscall>
  802b9b:	83 c4 18             	add    $0x18,%esp
}
  802b9e:	90                   	nop
  802b9f:	c9                   	leave  
  802ba0:	c3                   	ret    

00802ba1 <sys_cputc>:

void
sys_cputc(const char c)
{
  802ba1:	55                   	push   %ebp
  802ba2:	89 e5                	mov    %esp,%ebp
  802ba4:	83 ec 04             	sub    $0x4,%esp
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802bad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802bb1:	6a 00                	push   $0x0
  802bb3:	6a 00                	push   $0x0
  802bb5:	6a 00                	push   $0x0
  802bb7:	6a 00                	push   $0x0
  802bb9:	50                   	push   %eax
  802bba:	6a 01                	push   $0x1
  802bbc:	e8 29 fe ff ff       	call   8029ea <syscall>
  802bc1:	83 c4 18             	add    $0x18,%esp
}
  802bc4:	90                   	nop
  802bc5:	c9                   	leave  
  802bc6:	c3                   	ret    

00802bc7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802bc7:	55                   	push   %ebp
  802bc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802bca:	6a 00                	push   $0x0
  802bcc:	6a 00                	push   $0x0
  802bce:	6a 00                	push   $0x0
  802bd0:	6a 00                	push   $0x0
  802bd2:	6a 00                	push   $0x0
  802bd4:	6a 14                	push   $0x14
  802bd6:	e8 0f fe ff ff       	call   8029ea <syscall>
  802bdb:	83 c4 18             	add    $0x18,%esp
}
  802bde:	90                   	nop
  802bdf:	c9                   	leave  
  802be0:	c3                   	ret    

00802be1 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802be1:	55                   	push   %ebp
  802be2:	89 e5                	mov    %esp,%ebp
  802be4:	83 ec 04             	sub    $0x4,%esp
  802be7:	8b 45 10             	mov    0x10(%ebp),%eax
  802bea:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802bed:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802bf0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	6a 00                	push   $0x0
  802bf9:	51                   	push   %ecx
  802bfa:	52                   	push   %edx
  802bfb:	ff 75 0c             	pushl  0xc(%ebp)
  802bfe:	50                   	push   %eax
  802bff:	6a 15                	push   $0x15
  802c01:	e8 e4 fd ff ff       	call   8029ea <syscall>
  802c06:	83 c4 18             	add    $0x18,%esp
}
  802c09:	c9                   	leave  
  802c0a:	c3                   	ret    

00802c0b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802c0b:	55                   	push   %ebp
  802c0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	6a 00                	push   $0x0
  802c16:	6a 00                	push   $0x0
  802c18:	6a 00                	push   $0x0
  802c1a:	52                   	push   %edx
  802c1b:	50                   	push   %eax
  802c1c:	6a 16                	push   $0x16
  802c1e:	e8 c7 fd ff ff       	call   8029ea <syscall>
  802c23:	83 c4 18             	add    $0x18,%esp
}
  802c26:	c9                   	leave  
  802c27:	c3                   	ret    

00802c28 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802c28:	55                   	push   %ebp
  802c29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802c2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	6a 00                	push   $0x0
  802c36:	6a 00                	push   $0x0
  802c38:	51                   	push   %ecx
  802c39:	52                   	push   %edx
  802c3a:	50                   	push   %eax
  802c3b:	6a 17                	push   $0x17
  802c3d:	e8 a8 fd ff ff       	call   8029ea <syscall>
  802c42:	83 c4 18             	add    $0x18,%esp
}
  802c45:	c9                   	leave  
  802c46:	c3                   	ret    

00802c47 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802c47:	55                   	push   %ebp
  802c48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	6a 00                	push   $0x0
  802c52:	6a 00                	push   $0x0
  802c54:	6a 00                	push   $0x0
  802c56:	52                   	push   %edx
  802c57:	50                   	push   %eax
  802c58:	6a 18                	push   $0x18
  802c5a:	e8 8b fd ff ff       	call   8029ea <syscall>
  802c5f:	83 c4 18             	add    $0x18,%esp
}
  802c62:	c9                   	leave  
  802c63:	c3                   	ret    

00802c64 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802c64:	55                   	push   %ebp
  802c65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	6a 00                	push   $0x0
  802c6c:	ff 75 14             	pushl  0x14(%ebp)
  802c6f:	ff 75 10             	pushl  0x10(%ebp)
  802c72:	ff 75 0c             	pushl  0xc(%ebp)
  802c75:	50                   	push   %eax
  802c76:	6a 19                	push   $0x19
  802c78:	e8 6d fd ff ff       	call   8029ea <syscall>
  802c7d:	83 c4 18             	add    $0x18,%esp
}
  802c80:	c9                   	leave  
  802c81:	c3                   	ret    

00802c82 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802c82:	55                   	push   %ebp
  802c83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802c85:	8b 45 08             	mov    0x8(%ebp),%eax
  802c88:	6a 00                	push   $0x0
  802c8a:	6a 00                	push   $0x0
  802c8c:	6a 00                	push   $0x0
  802c8e:	6a 00                	push   $0x0
  802c90:	50                   	push   %eax
  802c91:	6a 1a                	push   $0x1a
  802c93:	e8 52 fd ff ff       	call   8029ea <syscall>
  802c98:	83 c4 18             	add    $0x18,%esp
}
  802c9b:	90                   	nop
  802c9c:	c9                   	leave  
  802c9d:	c3                   	ret    

00802c9e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802c9e:	55                   	push   %ebp
  802c9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca4:	6a 00                	push   $0x0
  802ca6:	6a 00                	push   $0x0
  802ca8:	6a 00                	push   $0x0
  802caa:	6a 00                	push   $0x0
  802cac:	50                   	push   %eax
  802cad:	6a 1b                	push   $0x1b
  802caf:	e8 36 fd ff ff       	call   8029ea <syscall>
  802cb4:	83 c4 18             	add    $0x18,%esp
}
  802cb7:	c9                   	leave  
  802cb8:	c3                   	ret    

00802cb9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802cb9:	55                   	push   %ebp
  802cba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802cbc:	6a 00                	push   $0x0
  802cbe:	6a 00                	push   $0x0
  802cc0:	6a 00                	push   $0x0
  802cc2:	6a 00                	push   $0x0
  802cc4:	6a 00                	push   $0x0
  802cc6:	6a 05                	push   $0x5
  802cc8:	e8 1d fd ff ff       	call   8029ea <syscall>
  802ccd:	83 c4 18             	add    $0x18,%esp
}
  802cd0:	c9                   	leave  
  802cd1:	c3                   	ret    

00802cd2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802cd2:	55                   	push   %ebp
  802cd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802cd5:	6a 00                	push   $0x0
  802cd7:	6a 00                	push   $0x0
  802cd9:	6a 00                	push   $0x0
  802cdb:	6a 00                	push   $0x0
  802cdd:	6a 00                	push   $0x0
  802cdf:	6a 06                	push   $0x6
  802ce1:	e8 04 fd ff ff       	call   8029ea <syscall>
  802ce6:	83 c4 18             	add    $0x18,%esp
}
  802ce9:	c9                   	leave  
  802cea:	c3                   	ret    

00802ceb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802ceb:	55                   	push   %ebp
  802cec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802cee:	6a 00                	push   $0x0
  802cf0:	6a 00                	push   $0x0
  802cf2:	6a 00                	push   $0x0
  802cf4:	6a 00                	push   $0x0
  802cf6:	6a 00                	push   $0x0
  802cf8:	6a 07                	push   $0x7
  802cfa:	e8 eb fc ff ff       	call   8029ea <syscall>
  802cff:	83 c4 18             	add    $0x18,%esp
}
  802d02:	c9                   	leave  
  802d03:	c3                   	ret    

00802d04 <sys_exit_env>:


void sys_exit_env(void)
{
  802d04:	55                   	push   %ebp
  802d05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802d07:	6a 00                	push   $0x0
  802d09:	6a 00                	push   $0x0
  802d0b:	6a 00                	push   $0x0
  802d0d:	6a 00                	push   $0x0
  802d0f:	6a 00                	push   $0x0
  802d11:	6a 1c                	push   $0x1c
  802d13:	e8 d2 fc ff ff       	call   8029ea <syscall>
  802d18:	83 c4 18             	add    $0x18,%esp
}
  802d1b:	90                   	nop
  802d1c:	c9                   	leave  
  802d1d:	c3                   	ret    

00802d1e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802d1e:	55                   	push   %ebp
  802d1f:	89 e5                	mov    %esp,%ebp
  802d21:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802d24:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802d27:	8d 50 04             	lea    0x4(%eax),%edx
  802d2a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802d2d:	6a 00                	push   $0x0
  802d2f:	6a 00                	push   $0x0
  802d31:	6a 00                	push   $0x0
  802d33:	52                   	push   %edx
  802d34:	50                   	push   %eax
  802d35:	6a 1d                	push   $0x1d
  802d37:	e8 ae fc ff ff       	call   8029ea <syscall>
  802d3c:	83 c4 18             	add    $0x18,%esp
	return result;
  802d3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802d45:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802d48:	89 01                	mov    %eax,(%ecx)
  802d4a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	c9                   	leave  
  802d51:	c2 04 00             	ret    $0x4

00802d54 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802d54:	55                   	push   %ebp
  802d55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802d57:	6a 00                	push   $0x0
  802d59:	6a 00                	push   $0x0
  802d5b:	ff 75 10             	pushl  0x10(%ebp)
  802d5e:	ff 75 0c             	pushl  0xc(%ebp)
  802d61:	ff 75 08             	pushl  0x8(%ebp)
  802d64:	6a 13                	push   $0x13
  802d66:	e8 7f fc ff ff       	call   8029ea <syscall>
  802d6b:	83 c4 18             	add    $0x18,%esp
	return ;
  802d6e:	90                   	nop
}
  802d6f:	c9                   	leave  
  802d70:	c3                   	ret    

00802d71 <sys_rcr2>:
uint32 sys_rcr2()
{
  802d71:	55                   	push   %ebp
  802d72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802d74:	6a 00                	push   $0x0
  802d76:	6a 00                	push   $0x0
  802d78:	6a 00                	push   $0x0
  802d7a:	6a 00                	push   $0x0
  802d7c:	6a 00                	push   $0x0
  802d7e:	6a 1e                	push   $0x1e
  802d80:	e8 65 fc ff ff       	call   8029ea <syscall>
  802d85:	83 c4 18             	add    $0x18,%esp
}
  802d88:	c9                   	leave  
  802d89:	c3                   	ret    

00802d8a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802d8a:	55                   	push   %ebp
  802d8b:	89 e5                	mov    %esp,%ebp
  802d8d:	83 ec 04             	sub    $0x4,%esp
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802d96:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802d9a:	6a 00                	push   $0x0
  802d9c:	6a 00                	push   $0x0
  802d9e:	6a 00                	push   $0x0
  802da0:	6a 00                	push   $0x0
  802da2:	50                   	push   %eax
  802da3:	6a 1f                	push   $0x1f
  802da5:	e8 40 fc ff ff       	call   8029ea <syscall>
  802daa:	83 c4 18             	add    $0x18,%esp
	return ;
  802dad:	90                   	nop
}
  802dae:	c9                   	leave  
  802daf:	c3                   	ret    

00802db0 <rsttst>:
void rsttst()
{
  802db0:	55                   	push   %ebp
  802db1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802db3:	6a 00                	push   $0x0
  802db5:	6a 00                	push   $0x0
  802db7:	6a 00                	push   $0x0
  802db9:	6a 00                	push   $0x0
  802dbb:	6a 00                	push   $0x0
  802dbd:	6a 21                	push   $0x21
  802dbf:	e8 26 fc ff ff       	call   8029ea <syscall>
  802dc4:	83 c4 18             	add    $0x18,%esp
	return ;
  802dc7:	90                   	nop
}
  802dc8:	c9                   	leave  
  802dc9:	c3                   	ret    

00802dca <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802dca:	55                   	push   %ebp
  802dcb:	89 e5                	mov    %esp,%ebp
  802dcd:	83 ec 04             	sub    $0x4,%esp
  802dd0:	8b 45 14             	mov    0x14(%ebp),%eax
  802dd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802dd6:	8b 55 18             	mov    0x18(%ebp),%edx
  802dd9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802ddd:	52                   	push   %edx
  802dde:	50                   	push   %eax
  802ddf:	ff 75 10             	pushl  0x10(%ebp)
  802de2:	ff 75 0c             	pushl  0xc(%ebp)
  802de5:	ff 75 08             	pushl  0x8(%ebp)
  802de8:	6a 20                	push   $0x20
  802dea:	e8 fb fb ff ff       	call   8029ea <syscall>
  802def:	83 c4 18             	add    $0x18,%esp
	return ;
  802df2:	90                   	nop
}
  802df3:	c9                   	leave  
  802df4:	c3                   	ret    

00802df5 <chktst>:
void chktst(uint32 n)
{
  802df5:	55                   	push   %ebp
  802df6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802df8:	6a 00                	push   $0x0
  802dfa:	6a 00                	push   $0x0
  802dfc:	6a 00                	push   $0x0
  802dfe:	6a 00                	push   $0x0
  802e00:	ff 75 08             	pushl  0x8(%ebp)
  802e03:	6a 22                	push   $0x22
  802e05:	e8 e0 fb ff ff       	call   8029ea <syscall>
  802e0a:	83 c4 18             	add    $0x18,%esp
	return ;
  802e0d:	90                   	nop
}
  802e0e:	c9                   	leave  
  802e0f:	c3                   	ret    

00802e10 <inctst>:

void inctst()
{
  802e10:	55                   	push   %ebp
  802e11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802e13:	6a 00                	push   $0x0
  802e15:	6a 00                	push   $0x0
  802e17:	6a 00                	push   $0x0
  802e19:	6a 00                	push   $0x0
  802e1b:	6a 00                	push   $0x0
  802e1d:	6a 23                	push   $0x23
  802e1f:	e8 c6 fb ff ff       	call   8029ea <syscall>
  802e24:	83 c4 18             	add    $0x18,%esp
	return ;
  802e27:	90                   	nop
}
  802e28:	c9                   	leave  
  802e29:	c3                   	ret    

00802e2a <gettst>:
uint32 gettst()
{
  802e2a:	55                   	push   %ebp
  802e2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802e2d:	6a 00                	push   $0x0
  802e2f:	6a 00                	push   $0x0
  802e31:	6a 00                	push   $0x0
  802e33:	6a 00                	push   $0x0
  802e35:	6a 00                	push   $0x0
  802e37:	6a 24                	push   $0x24
  802e39:	e8 ac fb ff ff       	call   8029ea <syscall>
  802e3e:	83 c4 18             	add    $0x18,%esp
}
  802e41:	c9                   	leave  
  802e42:	c3                   	ret    

00802e43 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802e43:	55                   	push   %ebp
  802e44:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e46:	6a 00                	push   $0x0
  802e48:	6a 00                	push   $0x0
  802e4a:	6a 00                	push   $0x0
  802e4c:	6a 00                	push   $0x0
  802e4e:	6a 00                	push   $0x0
  802e50:	6a 25                	push   $0x25
  802e52:	e8 93 fb ff ff       	call   8029ea <syscall>
  802e57:	83 c4 18             	add    $0x18,%esp
  802e5a:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802e5f:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802e64:	c9                   	leave  
  802e65:	c3                   	ret    

00802e66 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802e66:	55                   	push   %ebp
  802e67:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802e69:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6c:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802e71:	6a 00                	push   $0x0
  802e73:	6a 00                	push   $0x0
  802e75:	6a 00                	push   $0x0
  802e77:	6a 00                	push   $0x0
  802e79:	ff 75 08             	pushl  0x8(%ebp)
  802e7c:	6a 26                	push   $0x26
  802e7e:	e8 67 fb ff ff       	call   8029ea <syscall>
  802e83:	83 c4 18             	add    $0x18,%esp
	return ;
  802e86:	90                   	nop
}
  802e87:	c9                   	leave  
  802e88:	c3                   	ret    

00802e89 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802e89:	55                   	push   %ebp
  802e8a:	89 e5                	mov    %esp,%ebp
  802e8c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802e8d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e90:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e93:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	6a 00                	push   $0x0
  802e9b:	53                   	push   %ebx
  802e9c:	51                   	push   %ecx
  802e9d:	52                   	push   %edx
  802e9e:	50                   	push   %eax
  802e9f:	6a 27                	push   $0x27
  802ea1:	e8 44 fb ff ff       	call   8029ea <syscall>
  802ea6:	83 c4 18             	add    $0x18,%esp
}
  802ea9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802eac:	c9                   	leave  
  802ead:	c3                   	ret    

00802eae <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802eae:	55                   	push   %ebp
  802eaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802eb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	6a 00                	push   $0x0
  802eb9:	6a 00                	push   $0x0
  802ebb:	6a 00                	push   $0x0
  802ebd:	52                   	push   %edx
  802ebe:	50                   	push   %eax
  802ebf:	6a 28                	push   $0x28
  802ec1:	e8 24 fb ff ff       	call   8029ea <syscall>
  802ec6:	83 c4 18             	add    $0x18,%esp
}
  802ec9:	c9                   	leave  
  802eca:	c3                   	ret    

00802ecb <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802ecb:	55                   	push   %ebp
  802ecc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802ece:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ed1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	6a 00                	push   $0x0
  802ed9:	51                   	push   %ecx
  802eda:	ff 75 10             	pushl  0x10(%ebp)
  802edd:	52                   	push   %edx
  802ede:	50                   	push   %eax
  802edf:	6a 29                	push   $0x29
  802ee1:	e8 04 fb ff ff       	call   8029ea <syscall>
  802ee6:	83 c4 18             	add    $0x18,%esp
}
  802ee9:	c9                   	leave  
  802eea:	c3                   	ret    

00802eeb <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802eeb:	55                   	push   %ebp
  802eec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802eee:	6a 00                	push   $0x0
  802ef0:	6a 00                	push   $0x0
  802ef2:	ff 75 10             	pushl  0x10(%ebp)
  802ef5:	ff 75 0c             	pushl  0xc(%ebp)
  802ef8:	ff 75 08             	pushl  0x8(%ebp)
  802efb:	6a 12                	push   $0x12
  802efd:	e8 e8 fa ff ff       	call   8029ea <syscall>
  802f02:	83 c4 18             	add    $0x18,%esp
	return ;
  802f05:	90                   	nop
}
  802f06:	c9                   	leave  
  802f07:	c3                   	ret    

00802f08 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802f08:	55                   	push   %ebp
  802f09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	6a 00                	push   $0x0
  802f13:	6a 00                	push   $0x0
  802f15:	6a 00                	push   $0x0
  802f17:	52                   	push   %edx
  802f18:	50                   	push   %eax
  802f19:	6a 2a                	push   $0x2a
  802f1b:	e8 ca fa ff ff       	call   8029ea <syscall>
  802f20:	83 c4 18             	add    $0x18,%esp
	return;
  802f23:	90                   	nop
}
  802f24:	c9                   	leave  
  802f25:	c3                   	ret    

00802f26 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802f26:	55                   	push   %ebp
  802f27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802f29:	6a 00                	push   $0x0
  802f2b:	6a 00                	push   $0x0
  802f2d:	6a 00                	push   $0x0
  802f2f:	6a 00                	push   $0x0
  802f31:	6a 00                	push   $0x0
  802f33:	6a 2b                	push   $0x2b
  802f35:	e8 b0 fa ff ff       	call   8029ea <syscall>
  802f3a:	83 c4 18             	add    $0x18,%esp
}
  802f3d:	c9                   	leave  
  802f3e:	c3                   	ret    

00802f3f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802f3f:	55                   	push   %ebp
  802f40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802f42:	6a 00                	push   $0x0
  802f44:	6a 00                	push   $0x0
  802f46:	6a 00                	push   $0x0
  802f48:	ff 75 0c             	pushl  0xc(%ebp)
  802f4b:	ff 75 08             	pushl  0x8(%ebp)
  802f4e:	6a 2d                	push   $0x2d
  802f50:	e8 95 fa ff ff       	call   8029ea <syscall>
  802f55:	83 c4 18             	add    $0x18,%esp
	return;
  802f58:	90                   	nop
}
  802f59:	c9                   	leave  
  802f5a:	c3                   	ret    

00802f5b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802f5b:	55                   	push   %ebp
  802f5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802f5e:	6a 00                	push   $0x0
  802f60:	6a 00                	push   $0x0
  802f62:	6a 00                	push   $0x0
  802f64:	ff 75 0c             	pushl  0xc(%ebp)
  802f67:	ff 75 08             	pushl  0x8(%ebp)
  802f6a:	6a 2c                	push   $0x2c
  802f6c:	e8 79 fa ff ff       	call   8029ea <syscall>
  802f71:	83 c4 18             	add    $0x18,%esp
	return ;
  802f74:	90                   	nop
}
  802f75:	c9                   	leave  
  802f76:	c3                   	ret    

00802f77 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802f77:	55                   	push   %ebp
  802f78:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802f7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	6a 00                	push   $0x0
  802f82:	6a 00                	push   $0x0
  802f84:	6a 00                	push   $0x0
  802f86:	52                   	push   %edx
  802f87:	50                   	push   %eax
  802f88:	6a 2e                	push   $0x2e
  802f8a:	e8 5b fa ff ff       	call   8029ea <syscall>
  802f8f:	83 c4 18             	add    $0x18,%esp
	return ;
  802f92:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802f93:	c9                   	leave  
  802f94:	c3                   	ret    

00802f95 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802f95:	55                   	push   %ebp
  802f96:	89 e5                	mov    %esp,%ebp
  802f98:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802f9b:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802fa2:	72 09                	jb     802fad <to_page_va+0x18>
  802fa4:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802fab:	72 14                	jb     802fc1 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802fad:	83 ec 04             	sub    $0x4,%esp
  802fb0:	68 f4 4b 80 00       	push   $0x804bf4
  802fb5:	6a 15                	push   $0x15
  802fb7:	68 1f 4c 80 00       	push   $0x804c1f
  802fbc:	e8 46 d9 ff ff       	call   800907 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc4:	ba 60 50 80 00       	mov    $0x805060,%edx
  802fc9:	29 d0                	sub    %edx,%eax
  802fcb:	c1 f8 02             	sar    $0x2,%eax
  802fce:	89 c2                	mov    %eax,%edx
  802fd0:	89 d0                	mov    %edx,%eax
  802fd2:	c1 e0 02             	shl    $0x2,%eax
  802fd5:	01 d0                	add    %edx,%eax
  802fd7:	c1 e0 02             	shl    $0x2,%eax
  802fda:	01 d0                	add    %edx,%eax
  802fdc:	c1 e0 02             	shl    $0x2,%eax
  802fdf:	01 d0                	add    %edx,%eax
  802fe1:	89 c1                	mov    %eax,%ecx
  802fe3:	c1 e1 08             	shl    $0x8,%ecx
  802fe6:	01 c8                	add    %ecx,%eax
  802fe8:	89 c1                	mov    %eax,%ecx
  802fea:	c1 e1 10             	shl    $0x10,%ecx
  802fed:	01 c8                	add    %ecx,%eax
  802fef:	01 c0                	add    %eax,%eax
  802ff1:	01 d0                	add    %edx,%eax
  802ff3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	c1 e0 0c             	shl    $0xc,%eax
  802ffc:	89 c2                	mov    %eax,%edx
  802ffe:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803003:	01 d0                	add    %edx,%eax
}
  803005:	c9                   	leave  
  803006:	c3                   	ret    

00803007 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803007:	55                   	push   %ebp
  803008:	89 e5                	mov    %esp,%ebp
  80300a:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80300d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803012:	8b 55 08             	mov    0x8(%ebp),%edx
  803015:	29 c2                	sub    %eax,%edx
  803017:	89 d0                	mov    %edx,%eax
  803019:	c1 e8 0c             	shr    $0xc,%eax
  80301c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80301f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803023:	78 09                	js     80302e <to_page_info+0x27>
  803025:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80302c:	7e 14                	jle    803042 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  80302e:	83 ec 04             	sub    $0x4,%esp
  803031:	68 38 4c 80 00       	push   $0x804c38
  803036:	6a 22                	push   $0x22
  803038:	68 1f 4c 80 00       	push   $0x804c1f
  80303d:	e8 c5 d8 ff ff       	call   800907 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803042:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803045:	89 d0                	mov    %edx,%eax
  803047:	01 c0                	add    %eax,%eax
  803049:	01 d0                	add    %edx,%eax
  80304b:	c1 e0 02             	shl    $0x2,%eax
  80304e:	05 60 50 80 00       	add    $0x805060,%eax
}
  803053:	c9                   	leave  
  803054:	c3                   	ret    

00803055 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803055:	55                   	push   %ebp
  803056:	89 e5                	mov    %esp,%ebp
  803058:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80305b:	8b 45 08             	mov    0x8(%ebp),%eax
  80305e:	05 00 00 00 02       	add    $0x2000000,%eax
  803063:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803066:	73 16                	jae    80307e <initialize_dynamic_allocator+0x29>
  803068:	68 5c 4c 80 00       	push   $0x804c5c
  80306d:	68 82 4c 80 00       	push   $0x804c82
  803072:	6a 34                	push   $0x34
  803074:	68 1f 4c 80 00       	push   $0x804c1f
  803079:	e8 89 d8 ff ff       	call   800907 <_panic>
		is_initialized = 1;
  80307e:	c7 05 38 50 80 00 01 	movl   $0x1,0x805038
  803085:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  803090:	8b 45 0c             	mov    0xc(%ebp),%eax
  803093:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  803098:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  80309f:	00 00 00 
  8030a2:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8030a9:	00 00 00 
  8030ac:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  8030b3:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  8030b6:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  8030bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8030c4:	eb 36                	jmp    8030fc <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	c1 e0 04             	shl    $0x4,%eax
  8030cc:	05 80 d0 81 00       	add    $0x81d080,%eax
  8030d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030da:	c1 e0 04             	shl    $0x4,%eax
  8030dd:	05 84 d0 81 00       	add    $0x81d084,%eax
  8030e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030eb:	c1 e0 04             	shl    $0x4,%eax
  8030ee:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  8030f9:	ff 45 f4             	incl   -0xc(%ebp)
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803102:	72 c2                	jb     8030c6 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  803104:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80310a:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80310f:	29 c2                	sub    %eax,%edx
  803111:	89 d0                	mov    %edx,%eax
  803113:	c1 e8 0c             	shr    $0xc,%eax
  803116:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  803119:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803120:	e9 c8 00 00 00       	jmp    8031ed <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  803125:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803128:	89 d0                	mov    %edx,%eax
  80312a:	01 c0                	add    %eax,%eax
  80312c:	01 d0                	add    %edx,%eax
  80312e:	c1 e0 02             	shl    $0x2,%eax
  803131:	05 68 50 80 00       	add    $0x805068,%eax
  803136:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  80313b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80313e:	89 d0                	mov    %edx,%eax
  803140:	01 c0                	add    %eax,%eax
  803142:	01 d0                	add    %edx,%eax
  803144:	c1 e0 02             	shl    $0x2,%eax
  803147:	05 6a 50 80 00       	add    $0x80506a,%eax
  80314c:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803151:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803157:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80315a:	89 c8                	mov    %ecx,%eax
  80315c:	01 c0                	add    %eax,%eax
  80315e:	01 c8                	add    %ecx,%eax
  803160:	c1 e0 02             	shl    $0x2,%eax
  803163:	05 64 50 80 00       	add    $0x805064,%eax
  803168:	89 10                	mov    %edx,(%eax)
  80316a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80316d:	89 d0                	mov    %edx,%eax
  80316f:	01 c0                	add    %eax,%eax
  803171:	01 d0                	add    %edx,%eax
  803173:	c1 e0 02             	shl    $0x2,%eax
  803176:	05 64 50 80 00       	add    $0x805064,%eax
  80317b:	8b 00                	mov    (%eax),%eax
  80317d:	85 c0                	test   %eax,%eax
  80317f:	74 1b                	je     80319c <initialize_dynamic_allocator+0x147>
  803181:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803187:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80318a:	89 c8                	mov    %ecx,%eax
  80318c:	01 c0                	add    %eax,%eax
  80318e:	01 c8                	add    %ecx,%eax
  803190:	c1 e0 02             	shl    $0x2,%eax
  803193:	05 60 50 80 00       	add    $0x805060,%eax
  803198:	89 02                	mov    %eax,(%edx)
  80319a:	eb 16                	jmp    8031b2 <initialize_dynamic_allocator+0x15d>
  80319c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80319f:	89 d0                	mov    %edx,%eax
  8031a1:	01 c0                	add    %eax,%eax
  8031a3:	01 d0                	add    %edx,%eax
  8031a5:	c1 e0 02             	shl    $0x2,%eax
  8031a8:	05 60 50 80 00       	add    $0x805060,%eax
  8031ad:	a3 48 50 80 00       	mov    %eax,0x805048
  8031b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031b5:	89 d0                	mov    %edx,%eax
  8031b7:	01 c0                	add    %eax,%eax
  8031b9:	01 d0                	add    %edx,%eax
  8031bb:	c1 e0 02             	shl    $0x2,%eax
  8031be:	05 60 50 80 00       	add    $0x805060,%eax
  8031c3:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8031c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031cb:	89 d0                	mov    %edx,%eax
  8031cd:	01 c0                	add    %eax,%eax
  8031cf:	01 d0                	add    %edx,%eax
  8031d1:	c1 e0 02             	shl    $0x2,%eax
  8031d4:	05 60 50 80 00       	add    $0x805060,%eax
  8031d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031df:	a1 54 50 80 00       	mov    0x805054,%eax
  8031e4:	40                   	inc    %eax
  8031e5:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  8031ea:	ff 45 f0             	incl   -0x10(%ebp)
  8031ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8031f3:	0f 82 2c ff ff ff    	jb     803125 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8031f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8031ff:	eb 2f                	jmp    803230 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  803201:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803204:	89 d0                	mov    %edx,%eax
  803206:	01 c0                	add    %eax,%eax
  803208:	01 d0                	add    %edx,%eax
  80320a:	c1 e0 02             	shl    $0x2,%eax
  80320d:	05 68 50 80 00       	add    $0x805068,%eax
  803212:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803217:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80321a:	89 d0                	mov    %edx,%eax
  80321c:	01 c0                	add    %eax,%eax
  80321e:	01 d0                	add    %edx,%eax
  803220:	c1 e0 02             	shl    $0x2,%eax
  803223:	05 6a 50 80 00       	add    $0x80506a,%eax
  803228:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  80322d:	ff 45 ec             	incl   -0x14(%ebp)
  803230:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803237:	76 c8                	jbe    803201 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803239:	90                   	nop
  80323a:	c9                   	leave  
  80323b:	c3                   	ret    

0080323c <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80323c:	55                   	push   %ebp
  80323d:	89 e5                	mov    %esp,%ebp
  80323f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  803242:	8b 55 08             	mov    0x8(%ebp),%edx
  803245:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80324a:	29 c2                	sub    %eax,%edx
  80324c:	89 d0                	mov    %edx,%eax
  80324e:	c1 e8 0c             	shr    $0xc,%eax
  803251:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803254:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803257:	89 d0                	mov    %edx,%eax
  803259:	01 c0                	add    %eax,%eax
  80325b:	01 d0                	add    %edx,%eax
  80325d:	c1 e0 02             	shl    $0x2,%eax
  803260:	05 68 50 80 00       	add    $0x805068,%eax
  803265:	8b 00                	mov    (%eax),%eax
  803267:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80326a:	c9                   	leave  
  80326b:	c3                   	ret    

0080326c <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  80326c:	55                   	push   %ebp
  80326d:	89 e5                	mov    %esp,%ebp
  80326f:	83 ec 14             	sub    $0x14,%esp
  803272:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  803275:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803279:	77 07                	ja     803282 <nearest_pow2_ceil.1513+0x16>
  80327b:	b8 01 00 00 00       	mov    $0x1,%eax
  803280:	eb 20                	jmp    8032a2 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803282:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  803289:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  80328c:	eb 08                	jmp    803296 <nearest_pow2_ceil.1513+0x2a>
  80328e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803291:	01 c0                	add    %eax,%eax
  803293:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803296:	d1 6d 08             	shrl   0x8(%ebp)
  803299:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80329d:	75 ef                	jne    80328e <nearest_pow2_ceil.1513+0x22>
        return power;
  80329f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8032a2:	c9                   	leave  
  8032a3:	c3                   	ret    

008032a4 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8032a4:	55                   	push   %ebp
  8032a5:	89 e5                	mov    %esp,%ebp
  8032a7:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8032aa:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8032b1:	76 16                	jbe    8032c9 <alloc_block+0x25>
  8032b3:	68 98 4c 80 00       	push   $0x804c98
  8032b8:	68 82 4c 80 00       	push   $0x804c82
  8032bd:	6a 72                	push   $0x72
  8032bf:	68 1f 4c 80 00       	push   $0x804c1f
  8032c4:	e8 3e d6 ff ff       	call   800907 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  8032c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032cd:	75 0a                	jne    8032d9 <alloc_block+0x35>
  8032cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d4:	e9 bd 04 00 00       	jmp    803796 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8032d9:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  8032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8032e6:	73 06                	jae    8032ee <alloc_block+0x4a>
        size = min_block_size;
  8032e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032eb:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  8032ee:	83 ec 0c             	sub    $0xc,%esp
  8032f1:	8d 45 cc             	lea    -0x34(%ebp),%eax
  8032f4:	ff 75 08             	pushl  0x8(%ebp)
  8032f7:	89 c1                	mov    %eax,%ecx
  8032f9:	e8 6e ff ff ff       	call   80326c <nearest_pow2_ceil.1513>
  8032fe:	83 c4 10             	add    $0x10,%esp
  803301:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  803304:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803307:	83 ec 0c             	sub    $0xc,%esp
  80330a:	8d 45 cc             	lea    -0x34(%ebp),%eax
  80330d:	52                   	push   %edx
  80330e:	89 c1                	mov    %eax,%ecx
  803310:	e8 83 04 00 00       	call   803798 <log2_ceil.1520>
  803315:	83 c4 10             	add    $0x10,%esp
  803318:	83 e8 03             	sub    $0x3,%eax
  80331b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  80331e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803321:	c1 e0 04             	shl    $0x4,%eax
  803324:	05 80 d0 81 00       	add    $0x81d080,%eax
  803329:	8b 00                	mov    (%eax),%eax
  80332b:	85 c0                	test   %eax,%eax
  80332d:	0f 84 d8 00 00 00    	je     80340b <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803336:	c1 e0 04             	shl    $0x4,%eax
  803339:	05 80 d0 81 00       	add    $0x81d080,%eax
  80333e:	8b 00                	mov    (%eax),%eax
  803340:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803343:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803347:	75 17                	jne    803360 <alloc_block+0xbc>
  803349:	83 ec 04             	sub    $0x4,%esp
  80334c:	68 b9 4c 80 00       	push   $0x804cb9
  803351:	68 98 00 00 00       	push   $0x98
  803356:	68 1f 4c 80 00       	push   $0x804c1f
  80335b:	e8 a7 d5 ff ff       	call   800907 <_panic>
  803360:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803363:	8b 00                	mov    (%eax),%eax
  803365:	85 c0                	test   %eax,%eax
  803367:	74 10                	je     803379 <alloc_block+0xd5>
  803369:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80336c:	8b 00                	mov    (%eax),%eax
  80336e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803371:	8b 52 04             	mov    0x4(%edx),%edx
  803374:	89 50 04             	mov    %edx,0x4(%eax)
  803377:	eb 14                	jmp    80338d <alloc_block+0xe9>
  803379:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80337c:	8b 40 04             	mov    0x4(%eax),%eax
  80337f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803382:	c1 e2 04             	shl    $0x4,%edx
  803385:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80338b:	89 02                	mov    %eax,(%edx)
  80338d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803390:	8b 40 04             	mov    0x4(%eax),%eax
  803393:	85 c0                	test   %eax,%eax
  803395:	74 0f                	je     8033a6 <alloc_block+0x102>
  803397:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80339a:	8b 40 04             	mov    0x4(%eax),%eax
  80339d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033a0:	8b 12                	mov    (%edx),%edx
  8033a2:	89 10                	mov    %edx,(%eax)
  8033a4:	eb 13                	jmp    8033b9 <alloc_block+0x115>
  8033a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033a9:	8b 00                	mov    (%eax),%eax
  8033ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033ae:	c1 e2 04             	shl    $0x4,%edx
  8033b1:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8033b7:	89 02                	mov    %eax,(%edx)
  8033b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033cf:	c1 e0 04             	shl    $0x4,%eax
  8033d2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033d7:	8b 00                	mov    (%eax),%eax
  8033d9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8033dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033df:	c1 e0 04             	shl    $0x4,%eax
  8033e2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033e7:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  8033e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033ec:	83 ec 0c             	sub    $0xc,%esp
  8033ef:	50                   	push   %eax
  8033f0:	e8 12 fc ff ff       	call   803007 <to_page_info>
  8033f5:	83 c4 10             	add    $0x10,%esp
  8033f8:	89 c2                	mov    %eax,%edx
  8033fa:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8033fe:	48                   	dec    %eax
  8033ff:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  803403:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803406:	e9 8b 03 00 00       	jmp    803796 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  80340b:	a1 48 50 80 00       	mov    0x805048,%eax
  803410:	85 c0                	test   %eax,%eax
  803412:	0f 84 64 02 00 00    	je     80367c <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803418:	a1 48 50 80 00       	mov    0x805048,%eax
  80341d:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  803420:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803424:	75 17                	jne    80343d <alloc_block+0x199>
  803426:	83 ec 04             	sub    $0x4,%esp
  803429:	68 b9 4c 80 00       	push   $0x804cb9
  80342e:	68 a0 00 00 00       	push   $0xa0
  803433:	68 1f 4c 80 00       	push   $0x804c1f
  803438:	e8 ca d4 ff ff       	call   800907 <_panic>
  80343d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803440:	8b 00                	mov    (%eax),%eax
  803442:	85 c0                	test   %eax,%eax
  803444:	74 10                	je     803456 <alloc_block+0x1b2>
  803446:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803449:	8b 00                	mov    (%eax),%eax
  80344b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80344e:	8b 52 04             	mov    0x4(%edx),%edx
  803451:	89 50 04             	mov    %edx,0x4(%eax)
  803454:	eb 0b                	jmp    803461 <alloc_block+0x1bd>
  803456:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803459:	8b 40 04             	mov    0x4(%eax),%eax
  80345c:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803461:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803464:	8b 40 04             	mov    0x4(%eax),%eax
  803467:	85 c0                	test   %eax,%eax
  803469:	74 0f                	je     80347a <alloc_block+0x1d6>
  80346b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80346e:	8b 40 04             	mov    0x4(%eax),%eax
  803471:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803474:	8b 12                	mov    (%edx),%edx
  803476:	89 10                	mov    %edx,(%eax)
  803478:	eb 0a                	jmp    803484 <alloc_block+0x1e0>
  80347a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80347d:	8b 00                	mov    (%eax),%eax
  80347f:	a3 48 50 80 00       	mov    %eax,0x805048
  803484:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803487:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80348d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803490:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803497:	a1 54 50 80 00       	mov    0x805054,%eax
  80349c:	48                   	dec    %eax
  80349d:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  8034a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034a8:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  8034ac:	b8 00 10 00 00       	mov    $0x1000,%eax
  8034b1:	99                   	cltd   
  8034b2:	f7 7d e8             	idivl  -0x18(%ebp)
  8034b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034b8:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  8034bc:	83 ec 0c             	sub    $0xc,%esp
  8034bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8034c2:	e8 ce fa ff ff       	call   802f95 <to_page_va>
  8034c7:	83 c4 10             	add    $0x10,%esp
  8034ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  8034cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034d0:	83 ec 0c             	sub    $0xc,%esp
  8034d3:	50                   	push   %eax
  8034d4:	e8 c0 ee ff ff       	call   802399 <get_page>
  8034d9:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8034dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8034e3:	e9 aa 00 00 00       	jmp    803592 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  8034e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034eb:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  8034ef:	89 c2                	mov    %eax,%edx
  8034f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034f4:	01 d0                	add    %edx,%eax
  8034f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  8034f9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034fd:	75 17                	jne    803516 <alloc_block+0x272>
  8034ff:	83 ec 04             	sub    $0x4,%esp
  803502:	68 d8 4c 80 00       	push   $0x804cd8
  803507:	68 aa 00 00 00       	push   $0xaa
  80350c:	68 1f 4c 80 00       	push   $0x804c1f
  803511:	e8 f1 d3 ff ff       	call   800907 <_panic>
  803516:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803519:	c1 e0 04             	shl    $0x4,%eax
  80351c:	05 84 d0 81 00       	add    $0x81d084,%eax
  803521:	8b 10                	mov    (%eax),%edx
  803523:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803526:	89 50 04             	mov    %edx,0x4(%eax)
  803529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352c:	8b 40 04             	mov    0x4(%eax),%eax
  80352f:	85 c0                	test   %eax,%eax
  803531:	74 14                	je     803547 <alloc_block+0x2a3>
  803533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803536:	c1 e0 04             	shl    $0x4,%eax
  803539:	05 84 d0 81 00       	add    $0x81d084,%eax
  80353e:	8b 00                	mov    (%eax),%eax
  803540:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803543:	89 10                	mov    %edx,(%eax)
  803545:	eb 11                	jmp    803558 <alloc_block+0x2b4>
  803547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80354a:	c1 e0 04             	shl    $0x4,%eax
  80354d:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803553:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803556:	89 02                	mov    %eax,(%edx)
  803558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80355b:	c1 e0 04             	shl    $0x4,%eax
  80355e:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803564:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803567:	89 02                	mov    %eax,(%edx)
  803569:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803575:	c1 e0 04             	shl    $0x4,%eax
  803578:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80357d:	8b 00                	mov    (%eax),%eax
  80357f:	8d 50 01             	lea    0x1(%eax),%edx
  803582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803585:	c1 e0 04             	shl    $0x4,%eax
  803588:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80358d:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  80358f:	ff 45 f4             	incl   -0xc(%ebp)
  803592:	b8 00 10 00 00       	mov    $0x1000,%eax
  803597:	99                   	cltd   
  803598:	f7 7d e8             	idivl  -0x18(%ebp)
  80359b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80359e:	0f 8f 44 ff ff ff    	jg     8034e8 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8035a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a7:	c1 e0 04             	shl    $0x4,%eax
  8035aa:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035af:	8b 00                	mov    (%eax),%eax
  8035b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  8035b4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8035b8:	75 17                	jne    8035d1 <alloc_block+0x32d>
  8035ba:	83 ec 04             	sub    $0x4,%esp
  8035bd:	68 b9 4c 80 00       	push   $0x804cb9
  8035c2:	68 ae 00 00 00       	push   $0xae
  8035c7:	68 1f 4c 80 00       	push   $0x804c1f
  8035cc:	e8 36 d3 ff ff       	call   800907 <_panic>
  8035d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035d4:	8b 00                	mov    (%eax),%eax
  8035d6:	85 c0                	test   %eax,%eax
  8035d8:	74 10                	je     8035ea <alloc_block+0x346>
  8035da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035dd:	8b 00                	mov    (%eax),%eax
  8035df:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8035e2:	8b 52 04             	mov    0x4(%edx),%edx
  8035e5:	89 50 04             	mov    %edx,0x4(%eax)
  8035e8:	eb 14                	jmp    8035fe <alloc_block+0x35a>
  8035ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035ed:	8b 40 04             	mov    0x4(%eax),%eax
  8035f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035f3:	c1 e2 04             	shl    $0x4,%edx
  8035f6:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8035fc:	89 02                	mov    %eax,(%edx)
  8035fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803601:	8b 40 04             	mov    0x4(%eax),%eax
  803604:	85 c0                	test   %eax,%eax
  803606:	74 0f                	je     803617 <alloc_block+0x373>
  803608:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80360b:	8b 40 04             	mov    0x4(%eax),%eax
  80360e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803611:	8b 12                	mov    (%edx),%edx
  803613:	89 10                	mov    %edx,(%eax)
  803615:	eb 13                	jmp    80362a <alloc_block+0x386>
  803617:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80361a:	8b 00                	mov    (%eax),%eax
  80361c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80361f:	c1 e2 04             	shl    $0x4,%edx
  803622:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803628:	89 02                	mov    %eax,(%edx)
  80362a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80362d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803633:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803636:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803640:	c1 e0 04             	shl    $0x4,%eax
  803643:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803648:	8b 00                	mov    (%eax),%eax
  80364a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80364d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803650:	c1 e0 04             	shl    $0x4,%eax
  803653:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803658:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  80365a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80365d:	83 ec 0c             	sub    $0xc,%esp
  803660:	50                   	push   %eax
  803661:	e8 a1 f9 ff ff       	call   803007 <to_page_info>
  803666:	83 c4 10             	add    $0x10,%esp
  803669:	89 c2                	mov    %eax,%edx
  80366b:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80366f:	48                   	dec    %eax
  803670:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  803674:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803677:	e9 1a 01 00 00       	jmp    803796 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  80367c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367f:	40                   	inc    %eax
  803680:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803683:	e9 ed 00 00 00       	jmp    803775 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  803688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80368b:	c1 e0 04             	shl    $0x4,%eax
  80368e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803693:	8b 00                	mov    (%eax),%eax
  803695:	85 c0                	test   %eax,%eax
  803697:	0f 84 d5 00 00 00    	je     803772 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  80369d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a0:	c1 e0 04             	shl    $0x4,%eax
  8036a3:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036a8:	8b 00                	mov    (%eax),%eax
  8036aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  8036ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8036b1:	75 17                	jne    8036ca <alloc_block+0x426>
  8036b3:	83 ec 04             	sub    $0x4,%esp
  8036b6:	68 b9 4c 80 00       	push   $0x804cb9
  8036bb:	68 b8 00 00 00       	push   $0xb8
  8036c0:	68 1f 4c 80 00       	push   $0x804c1f
  8036c5:	e8 3d d2 ff ff       	call   800907 <_panic>
  8036ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036cd:	8b 00                	mov    (%eax),%eax
  8036cf:	85 c0                	test   %eax,%eax
  8036d1:	74 10                	je     8036e3 <alloc_block+0x43f>
  8036d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036d6:	8b 00                	mov    (%eax),%eax
  8036d8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8036db:	8b 52 04             	mov    0x4(%edx),%edx
  8036de:	89 50 04             	mov    %edx,0x4(%eax)
  8036e1:	eb 14                	jmp    8036f7 <alloc_block+0x453>
  8036e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036e6:	8b 40 04             	mov    0x4(%eax),%eax
  8036e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036ec:	c1 e2 04             	shl    $0x4,%edx
  8036ef:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8036f5:	89 02                	mov    %eax,(%edx)
  8036f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036fa:	8b 40 04             	mov    0x4(%eax),%eax
  8036fd:	85 c0                	test   %eax,%eax
  8036ff:	74 0f                	je     803710 <alloc_block+0x46c>
  803701:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803704:	8b 40 04             	mov    0x4(%eax),%eax
  803707:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80370a:	8b 12                	mov    (%edx),%edx
  80370c:	89 10                	mov    %edx,(%eax)
  80370e:	eb 13                	jmp    803723 <alloc_block+0x47f>
  803710:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803713:	8b 00                	mov    (%eax),%eax
  803715:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803718:	c1 e2 04             	shl    $0x4,%edx
  80371b:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803721:	89 02                	mov    %eax,(%edx)
  803723:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803726:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80372c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80372f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803739:	c1 e0 04             	shl    $0x4,%eax
  80373c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803741:	8b 00                	mov    (%eax),%eax
  803743:	8d 50 ff             	lea    -0x1(%eax),%edx
  803746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803749:	c1 e0 04             	shl    $0x4,%eax
  80374c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803751:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  803753:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803756:	83 ec 0c             	sub    $0xc,%esp
  803759:	50                   	push   %eax
  80375a:	e8 a8 f8 ff ff       	call   803007 <to_page_info>
  80375f:	83 c4 10             	add    $0x10,%esp
  803762:	89 c2                	mov    %eax,%edx
  803764:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803768:	48                   	dec    %eax
  803769:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  80376d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803770:	eb 24                	jmp    803796 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803772:	ff 45 f0             	incl   -0x10(%ebp)
  803775:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803779:	0f 8e 09 ff ff ff    	jle    803688 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  80377f:	83 ec 04             	sub    $0x4,%esp
  803782:	68 fb 4c 80 00       	push   $0x804cfb
  803787:	68 bf 00 00 00       	push   $0xbf
  80378c:	68 1f 4c 80 00       	push   $0x804c1f
  803791:	e8 71 d1 ff ff       	call   800907 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803796:	c9                   	leave  
  803797:	c3                   	ret    

00803798 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  803798:	55                   	push   %ebp
  803799:	89 e5                	mov    %esp,%ebp
  80379b:	83 ec 14             	sub    $0x14,%esp
  80379e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  8037a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037a5:	75 07                	jne    8037ae <log2_ceil.1520+0x16>
  8037a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ac:	eb 1b                	jmp    8037c9 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  8037ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  8037b5:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  8037b8:	eb 06                	jmp    8037c0 <log2_ceil.1520+0x28>
            x >>= 1;
  8037ba:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  8037bd:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8037c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037c4:	75 f4                	jne    8037ba <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  8037c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8037c9:	c9                   	leave  
  8037ca:	c3                   	ret    

008037cb <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  8037cb:	55                   	push   %ebp
  8037cc:	89 e5                	mov    %esp,%ebp
  8037ce:	83 ec 14             	sub    $0x14,%esp
  8037d1:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  8037d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037d8:	75 07                	jne    8037e1 <log2_ceil.1547+0x16>
  8037da:	b8 00 00 00 00       	mov    $0x0,%eax
  8037df:	eb 1b                	jmp    8037fc <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  8037e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  8037e8:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  8037eb:	eb 06                	jmp    8037f3 <log2_ceil.1547+0x28>
			x >>= 1;
  8037ed:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  8037f0:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  8037f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037f7:	75 f4                	jne    8037ed <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8037f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8037fc:	c9                   	leave  
  8037fd:	c3                   	ret    

008037fe <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8037fe:	55                   	push   %ebp
  8037ff:	89 e5                	mov    %esp,%ebp
  803801:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803804:	8b 55 08             	mov    0x8(%ebp),%edx
  803807:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80380c:	39 c2                	cmp    %eax,%edx
  80380e:	72 0c                	jb     80381c <free_block+0x1e>
  803810:	8b 55 08             	mov    0x8(%ebp),%edx
  803813:	a1 40 50 80 00       	mov    0x805040,%eax
  803818:	39 c2                	cmp    %eax,%edx
  80381a:	72 19                	jb     803835 <free_block+0x37>
  80381c:	68 00 4d 80 00       	push   $0x804d00
  803821:	68 82 4c 80 00       	push   $0x804c82
  803826:	68 d0 00 00 00       	push   $0xd0
  80382b:	68 1f 4c 80 00       	push   $0x804c1f
  803830:	e8 d2 d0 ff ff       	call   800907 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803835:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803839:	0f 84 42 03 00 00    	je     803b81 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  80383f:	8b 55 08             	mov    0x8(%ebp),%edx
  803842:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803847:	39 c2                	cmp    %eax,%edx
  803849:	72 0c                	jb     803857 <free_block+0x59>
  80384b:	8b 55 08             	mov    0x8(%ebp),%edx
  80384e:	a1 40 50 80 00       	mov    0x805040,%eax
  803853:	39 c2                	cmp    %eax,%edx
  803855:	72 17                	jb     80386e <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803857:	83 ec 04             	sub    $0x4,%esp
  80385a:	68 38 4d 80 00       	push   $0x804d38
  80385f:	68 e6 00 00 00       	push   $0xe6
  803864:	68 1f 4c 80 00       	push   $0x804c1f
  803869:	e8 99 d0 ff ff       	call   800907 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  80386e:	8b 55 08             	mov    0x8(%ebp),%edx
  803871:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803876:	29 c2                	sub    %eax,%edx
  803878:	89 d0                	mov    %edx,%eax
  80387a:	83 e0 07             	and    $0x7,%eax
  80387d:	85 c0                	test   %eax,%eax
  80387f:	74 17                	je     803898 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803881:	83 ec 04             	sub    $0x4,%esp
  803884:	68 6c 4d 80 00       	push   $0x804d6c
  803889:	68 ea 00 00 00       	push   $0xea
  80388e:	68 1f 4c 80 00       	push   $0x804c1f
  803893:	e8 6f d0 ff ff       	call   800907 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  803898:	8b 45 08             	mov    0x8(%ebp),%eax
  80389b:	83 ec 0c             	sub    $0xc,%esp
  80389e:	50                   	push   %eax
  80389f:	e8 63 f7 ff ff       	call   803007 <to_page_info>
  8038a4:	83 c4 10             	add    $0x10,%esp
  8038a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8038aa:	83 ec 0c             	sub    $0xc,%esp
  8038ad:	ff 75 08             	pushl  0x8(%ebp)
  8038b0:	e8 87 f9 ff ff       	call   80323c <get_block_size>
  8038b5:	83 c4 10             	add    $0x10,%esp
  8038b8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8038bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038bf:	75 17                	jne    8038d8 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8038c1:	83 ec 04             	sub    $0x4,%esp
  8038c4:	68 98 4d 80 00       	push   $0x804d98
  8038c9:	68 f1 00 00 00       	push   $0xf1
  8038ce:	68 1f 4c 80 00       	push   $0x804c1f
  8038d3:	e8 2f d0 ff ff       	call   800907 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8038d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038db:	83 ec 0c             	sub    $0xc,%esp
  8038de:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8038e1:	52                   	push   %edx
  8038e2:	89 c1                	mov    %eax,%ecx
  8038e4:	e8 e2 fe ff ff       	call   8037cb <log2_ceil.1547>
  8038e9:	83 c4 10             	add    $0x10,%esp
  8038ec:	83 e8 03             	sub    $0x3,%eax
  8038ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8038f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8038f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8038fc:	75 17                	jne    803915 <free_block+0x117>
  8038fe:	83 ec 04             	sub    $0x4,%esp
  803901:	68 e4 4d 80 00       	push   $0x804de4
  803906:	68 f6 00 00 00       	push   $0xf6
  80390b:	68 1f 4c 80 00       	push   $0x804c1f
  803910:	e8 f2 cf ff ff       	call   800907 <_panic>
  803915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803918:	c1 e0 04             	shl    $0x4,%eax
  80391b:	05 80 d0 81 00       	add    $0x81d080,%eax
  803920:	8b 10                	mov    (%eax),%edx
  803922:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803925:	89 10                	mov    %edx,(%eax)
  803927:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80392a:	8b 00                	mov    (%eax),%eax
  80392c:	85 c0                	test   %eax,%eax
  80392e:	74 15                	je     803945 <free_block+0x147>
  803930:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803933:	c1 e0 04             	shl    $0x4,%eax
  803936:	05 80 d0 81 00       	add    $0x81d080,%eax
  80393b:	8b 00                	mov    (%eax),%eax
  80393d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803940:	89 50 04             	mov    %edx,0x4(%eax)
  803943:	eb 11                	jmp    803956 <free_block+0x158>
  803945:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803948:	c1 e0 04             	shl    $0x4,%eax
  80394b:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803954:	89 02                	mov    %eax,(%edx)
  803956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803959:	c1 e0 04             	shl    $0x4,%eax
  80395c:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803962:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803965:	89 02                	mov    %eax,(%edx)
  803967:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80396a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803971:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803974:	c1 e0 04             	shl    $0x4,%eax
  803977:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80397c:	8b 00                	mov    (%eax),%eax
  80397e:	8d 50 01             	lea    0x1(%eax),%edx
  803981:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803984:	c1 e0 04             	shl    $0x4,%eax
  803987:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80398c:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  80398e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803991:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803995:	40                   	inc    %eax
  803996:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803999:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  80399d:	8b 55 08             	mov    0x8(%ebp),%edx
  8039a0:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8039a5:	29 c2                	sub    %eax,%edx
  8039a7:	89 d0                	mov    %edx,%eax
  8039a9:	c1 e8 0c             	shr    $0xc,%eax
  8039ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8039af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039b2:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8039b6:	0f b7 c8             	movzwl %ax,%ecx
  8039b9:	b8 00 10 00 00       	mov    $0x1000,%eax
  8039be:	99                   	cltd   
  8039bf:	f7 7d e8             	idivl  -0x18(%ebp)
  8039c2:	39 c1                	cmp    %eax,%ecx
  8039c4:	0f 85 b8 01 00 00    	jne    803b82 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8039ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8039d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d4:	c1 e0 04             	shl    $0x4,%eax
  8039d7:	05 80 d0 81 00       	add    $0x81d080,%eax
  8039dc:	8b 00                	mov    (%eax),%eax
  8039de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8039e1:	e9 d5 00 00 00       	jmp    803abb <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  8039e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e9:	8b 00                	mov    (%eax),%eax
  8039eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  8039ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039f1:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8039f6:	29 c2                	sub    %eax,%edx
  8039f8:	89 d0                	mov    %edx,%eax
  8039fa:	c1 e8 0c             	shr    $0xc,%eax
  8039fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803a00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a03:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803a06:	0f 85 a9 00 00 00    	jne    803ab5 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  803a0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a10:	75 17                	jne    803a29 <free_block+0x22b>
  803a12:	83 ec 04             	sub    $0x4,%esp
  803a15:	68 b9 4c 80 00       	push   $0x804cb9
  803a1a:	68 04 01 00 00       	push   $0x104
  803a1f:	68 1f 4c 80 00       	push   $0x804c1f
  803a24:	e8 de ce ff ff       	call   800907 <_panic>
  803a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a2c:	8b 00                	mov    (%eax),%eax
  803a2e:	85 c0                	test   %eax,%eax
  803a30:	74 10                	je     803a42 <free_block+0x244>
  803a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a35:	8b 00                	mov    (%eax),%eax
  803a37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a3a:	8b 52 04             	mov    0x4(%edx),%edx
  803a3d:	89 50 04             	mov    %edx,0x4(%eax)
  803a40:	eb 14                	jmp    803a56 <free_block+0x258>
  803a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a45:	8b 40 04             	mov    0x4(%eax),%eax
  803a48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a4b:	c1 e2 04             	shl    $0x4,%edx
  803a4e:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803a54:	89 02                	mov    %eax,(%edx)
  803a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a59:	8b 40 04             	mov    0x4(%eax),%eax
  803a5c:	85 c0                	test   %eax,%eax
  803a5e:	74 0f                	je     803a6f <free_block+0x271>
  803a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a63:	8b 40 04             	mov    0x4(%eax),%eax
  803a66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a69:	8b 12                	mov    (%edx),%edx
  803a6b:	89 10                	mov    %edx,(%eax)
  803a6d:	eb 13                	jmp    803a82 <free_block+0x284>
  803a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a72:	8b 00                	mov    (%eax),%eax
  803a74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a77:	c1 e2 04             	shl    $0x4,%edx
  803a7a:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803a80:	89 02                	mov    %eax,(%edx)
  803a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a98:	c1 e0 04             	shl    $0x4,%eax
  803a9b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803aa0:	8b 00                	mov    (%eax),%eax
  803aa2:	8d 50 ff             	lea    -0x1(%eax),%edx
  803aa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa8:	c1 e0 04             	shl    $0x4,%eax
  803aab:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803ab0:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803ab2:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803ab5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803abb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803abf:	0f 85 21 ff ff ff    	jne    8039e6 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803ac5:	b8 00 10 00 00       	mov    $0x1000,%eax
  803aca:	99                   	cltd   
  803acb:	f7 7d e8             	idivl  -0x18(%ebp)
  803ace:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803ad1:	74 17                	je     803aea <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803ad3:	83 ec 04             	sub    $0x4,%esp
  803ad6:	68 08 4e 80 00       	push   $0x804e08
  803adb:	68 0c 01 00 00       	push   $0x10c
  803ae0:	68 1f 4c 80 00       	push   $0x804c1f
  803ae5:	e8 1d ce ff ff       	call   800907 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803aea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aed:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803af6:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803afc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b00:	75 17                	jne    803b19 <free_block+0x31b>
  803b02:	83 ec 04             	sub    $0x4,%esp
  803b05:	68 d8 4c 80 00       	push   $0x804cd8
  803b0a:	68 11 01 00 00       	push   $0x111
  803b0f:	68 1f 4c 80 00       	push   $0x804c1f
  803b14:	e8 ee cd ff ff       	call   800907 <_panic>
  803b19:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b22:	89 50 04             	mov    %edx,0x4(%eax)
  803b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b28:	8b 40 04             	mov    0x4(%eax),%eax
  803b2b:	85 c0                	test   %eax,%eax
  803b2d:	74 0c                	je     803b3b <free_block+0x33d>
  803b2f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803b34:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b37:	89 10                	mov    %edx,(%eax)
  803b39:	eb 08                	jmp    803b43 <free_block+0x345>
  803b3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b3e:	a3 48 50 80 00       	mov    %eax,0x805048
  803b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b46:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b54:	a1 54 50 80 00       	mov    0x805054,%eax
  803b59:	40                   	inc    %eax
  803b5a:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803b5f:	83 ec 0c             	sub    $0xc,%esp
  803b62:	ff 75 ec             	pushl  -0x14(%ebp)
  803b65:	e8 2b f4 ff ff       	call   802f95 <to_page_va>
  803b6a:	83 c4 10             	add    $0x10,%esp
  803b6d:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803b70:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b73:	83 ec 0c             	sub    $0xc,%esp
  803b76:	50                   	push   %eax
  803b77:	e8 69 e8 ff ff       	call   8023e5 <return_page>
  803b7c:	83 c4 10             	add    $0x10,%esp
  803b7f:	eb 01                	jmp    803b82 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803b81:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803b82:	c9                   	leave  
  803b83:	c3                   	ret    

00803b84 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803b84:	55                   	push   %ebp
  803b85:	89 e5                	mov    %esp,%ebp
  803b87:	83 ec 14             	sub    $0x14,%esp
  803b8a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803b8d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803b91:	77 07                	ja     803b9a <nearest_pow2_ceil.1572+0x16>
      return 1;
  803b93:	b8 01 00 00 00       	mov    $0x1,%eax
  803b98:	eb 20                	jmp    803bba <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803b9a:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803ba1:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803ba4:	eb 08                	jmp    803bae <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803ba6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803ba9:	01 c0                	add    %eax,%eax
  803bab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803bae:	d1 6d 08             	shrl   0x8(%ebp)
  803bb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bb5:	75 ef                	jne    803ba6 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803bb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803bba:	c9                   	leave  
  803bbb:	c3                   	ret    

00803bbc <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803bbc:	55                   	push   %ebp
  803bbd:	89 e5                	mov    %esp,%ebp
  803bbf:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803bc2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bc6:	75 13                	jne    803bdb <realloc_block+0x1f>
    return alloc_block(new_size);
  803bc8:	83 ec 0c             	sub    $0xc,%esp
  803bcb:	ff 75 0c             	pushl  0xc(%ebp)
  803bce:	e8 d1 f6 ff ff       	call   8032a4 <alloc_block>
  803bd3:	83 c4 10             	add    $0x10,%esp
  803bd6:	e9 d9 00 00 00       	jmp    803cb4 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803bdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803bdf:	75 18                	jne    803bf9 <realloc_block+0x3d>
    free_block(va);
  803be1:	83 ec 0c             	sub    $0xc,%esp
  803be4:	ff 75 08             	pushl  0x8(%ebp)
  803be7:	e8 12 fc ff ff       	call   8037fe <free_block>
  803bec:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803bef:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf4:	e9 bb 00 00 00       	jmp    803cb4 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803bf9:	83 ec 0c             	sub    $0xc,%esp
  803bfc:	ff 75 08             	pushl  0x8(%ebp)
  803bff:	e8 38 f6 ff ff       	call   80323c <get_block_size>
  803c04:	83 c4 10             	add    $0x10,%esp
  803c07:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803c0a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c14:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803c17:	73 06                	jae    803c1f <realloc_block+0x63>
    new_size = min_block_size;
  803c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c1c:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803c1f:	83 ec 0c             	sub    $0xc,%esp
  803c22:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803c25:	ff 75 0c             	pushl  0xc(%ebp)
  803c28:	89 c1                	mov    %eax,%ecx
  803c2a:	e8 55 ff ff ff       	call   803b84 <nearest_pow2_ceil.1572>
  803c2f:	83 c4 10             	add    $0x10,%esp
  803c32:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803c35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c38:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803c3b:	75 05                	jne    803c42 <realloc_block+0x86>
    return va;
  803c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c40:	eb 72                	jmp    803cb4 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803c42:	83 ec 0c             	sub    $0xc,%esp
  803c45:	ff 75 0c             	pushl  0xc(%ebp)
  803c48:	e8 57 f6 ff ff       	call   8032a4 <alloc_block>
  803c4d:	83 c4 10             	add    $0x10,%esp
  803c50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803c53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c57:	75 07                	jne    803c60 <realloc_block+0xa4>
    return NULL;
  803c59:	b8 00 00 00 00       	mov    $0x0,%eax
  803c5e:	eb 54                	jmp    803cb4 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803c60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c66:	39 d0                	cmp    %edx,%eax
  803c68:	76 02                	jbe    803c6c <realloc_block+0xb0>
  803c6a:	89 d0                	mov    %edx,%eax
  803c6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c72:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803c75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c78:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803c7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803c82:	eb 17                	jmp    803c9b <realloc_block+0xdf>
    dst[i] = src[i];
  803c84:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c8a:	01 c2                	add    %eax,%edx
  803c8c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c92:	01 c8                	add    %ecx,%eax
  803c94:	8a 00                	mov    (%eax),%al
  803c96:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803c98:	ff 45 f4             	incl   -0xc(%ebp)
  803c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803ca1:	72 e1                	jb     803c84 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803ca3:	83 ec 0c             	sub    $0xc,%esp
  803ca6:	ff 75 08             	pushl  0x8(%ebp)
  803ca9:	e8 50 fb ff ff       	call   8037fe <free_block>
  803cae:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803cb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803cb4:	c9                   	leave  
  803cb5:	c3                   	ret    
  803cb6:	66 90                	xchg   %ax,%ax

00803cb8 <__udivdi3>:
  803cb8:	55                   	push   %ebp
  803cb9:	57                   	push   %edi
  803cba:	56                   	push   %esi
  803cbb:	53                   	push   %ebx
  803cbc:	83 ec 1c             	sub    $0x1c,%esp
  803cbf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803cc3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803cc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ccb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ccf:	89 ca                	mov    %ecx,%edx
  803cd1:	89 f8                	mov    %edi,%eax
  803cd3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803cd7:	85 f6                	test   %esi,%esi
  803cd9:	75 2d                	jne    803d08 <__udivdi3+0x50>
  803cdb:	39 cf                	cmp    %ecx,%edi
  803cdd:	77 65                	ja     803d44 <__udivdi3+0x8c>
  803cdf:	89 fd                	mov    %edi,%ebp
  803ce1:	85 ff                	test   %edi,%edi
  803ce3:	75 0b                	jne    803cf0 <__udivdi3+0x38>
  803ce5:	b8 01 00 00 00       	mov    $0x1,%eax
  803cea:	31 d2                	xor    %edx,%edx
  803cec:	f7 f7                	div    %edi
  803cee:	89 c5                	mov    %eax,%ebp
  803cf0:	31 d2                	xor    %edx,%edx
  803cf2:	89 c8                	mov    %ecx,%eax
  803cf4:	f7 f5                	div    %ebp
  803cf6:	89 c1                	mov    %eax,%ecx
  803cf8:	89 d8                	mov    %ebx,%eax
  803cfa:	f7 f5                	div    %ebp
  803cfc:	89 cf                	mov    %ecx,%edi
  803cfe:	89 fa                	mov    %edi,%edx
  803d00:	83 c4 1c             	add    $0x1c,%esp
  803d03:	5b                   	pop    %ebx
  803d04:	5e                   	pop    %esi
  803d05:	5f                   	pop    %edi
  803d06:	5d                   	pop    %ebp
  803d07:	c3                   	ret    
  803d08:	39 ce                	cmp    %ecx,%esi
  803d0a:	77 28                	ja     803d34 <__udivdi3+0x7c>
  803d0c:	0f bd fe             	bsr    %esi,%edi
  803d0f:	83 f7 1f             	xor    $0x1f,%edi
  803d12:	75 40                	jne    803d54 <__udivdi3+0x9c>
  803d14:	39 ce                	cmp    %ecx,%esi
  803d16:	72 0a                	jb     803d22 <__udivdi3+0x6a>
  803d18:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d1c:	0f 87 9e 00 00 00    	ja     803dc0 <__udivdi3+0x108>
  803d22:	b8 01 00 00 00       	mov    $0x1,%eax
  803d27:	89 fa                	mov    %edi,%edx
  803d29:	83 c4 1c             	add    $0x1c,%esp
  803d2c:	5b                   	pop    %ebx
  803d2d:	5e                   	pop    %esi
  803d2e:	5f                   	pop    %edi
  803d2f:	5d                   	pop    %ebp
  803d30:	c3                   	ret    
  803d31:	8d 76 00             	lea    0x0(%esi),%esi
  803d34:	31 ff                	xor    %edi,%edi
  803d36:	31 c0                	xor    %eax,%eax
  803d38:	89 fa                	mov    %edi,%edx
  803d3a:	83 c4 1c             	add    $0x1c,%esp
  803d3d:	5b                   	pop    %ebx
  803d3e:	5e                   	pop    %esi
  803d3f:	5f                   	pop    %edi
  803d40:	5d                   	pop    %ebp
  803d41:	c3                   	ret    
  803d42:	66 90                	xchg   %ax,%ax
  803d44:	89 d8                	mov    %ebx,%eax
  803d46:	f7 f7                	div    %edi
  803d48:	31 ff                	xor    %edi,%edi
  803d4a:	89 fa                	mov    %edi,%edx
  803d4c:	83 c4 1c             	add    $0x1c,%esp
  803d4f:	5b                   	pop    %ebx
  803d50:	5e                   	pop    %esi
  803d51:	5f                   	pop    %edi
  803d52:	5d                   	pop    %ebp
  803d53:	c3                   	ret    
  803d54:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d59:	89 eb                	mov    %ebp,%ebx
  803d5b:	29 fb                	sub    %edi,%ebx
  803d5d:	89 f9                	mov    %edi,%ecx
  803d5f:	d3 e6                	shl    %cl,%esi
  803d61:	89 c5                	mov    %eax,%ebp
  803d63:	88 d9                	mov    %bl,%cl
  803d65:	d3 ed                	shr    %cl,%ebp
  803d67:	89 e9                	mov    %ebp,%ecx
  803d69:	09 f1                	or     %esi,%ecx
  803d6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d6f:	89 f9                	mov    %edi,%ecx
  803d71:	d3 e0                	shl    %cl,%eax
  803d73:	89 c5                	mov    %eax,%ebp
  803d75:	89 d6                	mov    %edx,%esi
  803d77:	88 d9                	mov    %bl,%cl
  803d79:	d3 ee                	shr    %cl,%esi
  803d7b:	89 f9                	mov    %edi,%ecx
  803d7d:	d3 e2                	shl    %cl,%edx
  803d7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d83:	88 d9                	mov    %bl,%cl
  803d85:	d3 e8                	shr    %cl,%eax
  803d87:	09 c2                	or     %eax,%edx
  803d89:	89 d0                	mov    %edx,%eax
  803d8b:	89 f2                	mov    %esi,%edx
  803d8d:	f7 74 24 0c          	divl   0xc(%esp)
  803d91:	89 d6                	mov    %edx,%esi
  803d93:	89 c3                	mov    %eax,%ebx
  803d95:	f7 e5                	mul    %ebp
  803d97:	39 d6                	cmp    %edx,%esi
  803d99:	72 19                	jb     803db4 <__udivdi3+0xfc>
  803d9b:	74 0b                	je     803da8 <__udivdi3+0xf0>
  803d9d:	89 d8                	mov    %ebx,%eax
  803d9f:	31 ff                	xor    %edi,%edi
  803da1:	e9 58 ff ff ff       	jmp    803cfe <__udivdi3+0x46>
  803da6:	66 90                	xchg   %ax,%ax
  803da8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803dac:	89 f9                	mov    %edi,%ecx
  803dae:	d3 e2                	shl    %cl,%edx
  803db0:	39 c2                	cmp    %eax,%edx
  803db2:	73 e9                	jae    803d9d <__udivdi3+0xe5>
  803db4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803db7:	31 ff                	xor    %edi,%edi
  803db9:	e9 40 ff ff ff       	jmp    803cfe <__udivdi3+0x46>
  803dbe:	66 90                	xchg   %ax,%ax
  803dc0:	31 c0                	xor    %eax,%eax
  803dc2:	e9 37 ff ff ff       	jmp    803cfe <__udivdi3+0x46>
  803dc7:	90                   	nop

00803dc8 <__umoddi3>:
  803dc8:	55                   	push   %ebp
  803dc9:	57                   	push   %edi
  803dca:	56                   	push   %esi
  803dcb:	53                   	push   %ebx
  803dcc:	83 ec 1c             	sub    $0x1c,%esp
  803dcf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803dd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803dd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ddb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ddf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803de3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803de7:	89 f3                	mov    %esi,%ebx
  803de9:	89 fa                	mov    %edi,%edx
  803deb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803def:	89 34 24             	mov    %esi,(%esp)
  803df2:	85 c0                	test   %eax,%eax
  803df4:	75 1a                	jne    803e10 <__umoddi3+0x48>
  803df6:	39 f7                	cmp    %esi,%edi
  803df8:	0f 86 a2 00 00 00    	jbe    803ea0 <__umoddi3+0xd8>
  803dfe:	89 c8                	mov    %ecx,%eax
  803e00:	89 f2                	mov    %esi,%edx
  803e02:	f7 f7                	div    %edi
  803e04:	89 d0                	mov    %edx,%eax
  803e06:	31 d2                	xor    %edx,%edx
  803e08:	83 c4 1c             	add    $0x1c,%esp
  803e0b:	5b                   	pop    %ebx
  803e0c:	5e                   	pop    %esi
  803e0d:	5f                   	pop    %edi
  803e0e:	5d                   	pop    %ebp
  803e0f:	c3                   	ret    
  803e10:	39 f0                	cmp    %esi,%eax
  803e12:	0f 87 ac 00 00 00    	ja     803ec4 <__umoddi3+0xfc>
  803e18:	0f bd e8             	bsr    %eax,%ebp
  803e1b:	83 f5 1f             	xor    $0x1f,%ebp
  803e1e:	0f 84 ac 00 00 00    	je     803ed0 <__umoddi3+0x108>
  803e24:	bf 20 00 00 00       	mov    $0x20,%edi
  803e29:	29 ef                	sub    %ebp,%edi
  803e2b:	89 fe                	mov    %edi,%esi
  803e2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e31:	89 e9                	mov    %ebp,%ecx
  803e33:	d3 e0                	shl    %cl,%eax
  803e35:	89 d7                	mov    %edx,%edi
  803e37:	89 f1                	mov    %esi,%ecx
  803e39:	d3 ef                	shr    %cl,%edi
  803e3b:	09 c7                	or     %eax,%edi
  803e3d:	89 e9                	mov    %ebp,%ecx
  803e3f:	d3 e2                	shl    %cl,%edx
  803e41:	89 14 24             	mov    %edx,(%esp)
  803e44:	89 d8                	mov    %ebx,%eax
  803e46:	d3 e0                	shl    %cl,%eax
  803e48:	89 c2                	mov    %eax,%edx
  803e4a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e4e:	d3 e0                	shl    %cl,%eax
  803e50:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e54:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e58:	89 f1                	mov    %esi,%ecx
  803e5a:	d3 e8                	shr    %cl,%eax
  803e5c:	09 d0                	or     %edx,%eax
  803e5e:	d3 eb                	shr    %cl,%ebx
  803e60:	89 da                	mov    %ebx,%edx
  803e62:	f7 f7                	div    %edi
  803e64:	89 d3                	mov    %edx,%ebx
  803e66:	f7 24 24             	mull   (%esp)
  803e69:	89 c6                	mov    %eax,%esi
  803e6b:	89 d1                	mov    %edx,%ecx
  803e6d:	39 d3                	cmp    %edx,%ebx
  803e6f:	0f 82 87 00 00 00    	jb     803efc <__umoddi3+0x134>
  803e75:	0f 84 91 00 00 00    	je     803f0c <__umoddi3+0x144>
  803e7b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e7f:	29 f2                	sub    %esi,%edx
  803e81:	19 cb                	sbb    %ecx,%ebx
  803e83:	89 d8                	mov    %ebx,%eax
  803e85:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e89:	d3 e0                	shl    %cl,%eax
  803e8b:	89 e9                	mov    %ebp,%ecx
  803e8d:	d3 ea                	shr    %cl,%edx
  803e8f:	09 d0                	or     %edx,%eax
  803e91:	89 e9                	mov    %ebp,%ecx
  803e93:	d3 eb                	shr    %cl,%ebx
  803e95:	89 da                	mov    %ebx,%edx
  803e97:	83 c4 1c             	add    $0x1c,%esp
  803e9a:	5b                   	pop    %ebx
  803e9b:	5e                   	pop    %esi
  803e9c:	5f                   	pop    %edi
  803e9d:	5d                   	pop    %ebp
  803e9e:	c3                   	ret    
  803e9f:	90                   	nop
  803ea0:	89 fd                	mov    %edi,%ebp
  803ea2:	85 ff                	test   %edi,%edi
  803ea4:	75 0b                	jne    803eb1 <__umoddi3+0xe9>
  803ea6:	b8 01 00 00 00       	mov    $0x1,%eax
  803eab:	31 d2                	xor    %edx,%edx
  803ead:	f7 f7                	div    %edi
  803eaf:	89 c5                	mov    %eax,%ebp
  803eb1:	89 f0                	mov    %esi,%eax
  803eb3:	31 d2                	xor    %edx,%edx
  803eb5:	f7 f5                	div    %ebp
  803eb7:	89 c8                	mov    %ecx,%eax
  803eb9:	f7 f5                	div    %ebp
  803ebb:	89 d0                	mov    %edx,%eax
  803ebd:	e9 44 ff ff ff       	jmp    803e06 <__umoddi3+0x3e>
  803ec2:	66 90                	xchg   %ax,%ax
  803ec4:	89 c8                	mov    %ecx,%eax
  803ec6:	89 f2                	mov    %esi,%edx
  803ec8:	83 c4 1c             	add    $0x1c,%esp
  803ecb:	5b                   	pop    %ebx
  803ecc:	5e                   	pop    %esi
  803ecd:	5f                   	pop    %edi
  803ece:	5d                   	pop    %ebp
  803ecf:	c3                   	ret    
  803ed0:	3b 04 24             	cmp    (%esp),%eax
  803ed3:	72 06                	jb     803edb <__umoddi3+0x113>
  803ed5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ed9:	77 0f                	ja     803eea <__umoddi3+0x122>
  803edb:	89 f2                	mov    %esi,%edx
  803edd:	29 f9                	sub    %edi,%ecx
  803edf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ee3:	89 14 24             	mov    %edx,(%esp)
  803ee6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803eea:	8b 44 24 04          	mov    0x4(%esp),%eax
  803eee:	8b 14 24             	mov    (%esp),%edx
  803ef1:	83 c4 1c             	add    $0x1c,%esp
  803ef4:	5b                   	pop    %ebx
  803ef5:	5e                   	pop    %esi
  803ef6:	5f                   	pop    %edi
  803ef7:	5d                   	pop    %ebp
  803ef8:	c3                   	ret    
  803ef9:	8d 76 00             	lea    0x0(%esi),%esi
  803efc:	2b 04 24             	sub    (%esp),%eax
  803eff:	19 fa                	sbb    %edi,%edx
  803f01:	89 d1                	mov    %edx,%ecx
  803f03:	89 c6                	mov    %eax,%esi
  803f05:	e9 71 ff ff ff       	jmp    803e7b <__umoddi3+0xb3>
  803f0a:	66 90                	xchg   %ax,%ax
  803f0c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f10:	72 ea                	jb     803efc <__umoddi3+0x134>
  803f12:	89 d9                	mov    %ebx,%ecx
  803f14:	e9 62 ff ff ff       	jmp    803e7b <__umoddi3+0xb3>
