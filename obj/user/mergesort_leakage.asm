
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 01 07 00 00       	call   800737 <libmain>
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
	{
		//2012: lock the interrupt
//		sys_lock_cons();
		int NumOfElements;
		int *Elements;
		sys_lock_cons();
  800041:	e8 f3 29 00 00       	call   802a39 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 3f 80 00       	push   $0x803f00
  80004e:	e8 82 0b 00 00       	call   800bd5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 3f 80 00       	push   $0x803f02
  80005e:	e8 72 0b 00 00       	call   800bd5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 18 3f 80 00       	push   $0x803f18
  80006e:	e8 62 0b 00 00       	call   800bd5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 3f 80 00       	push   $0x803f02
  80007e:	e8 52 0b 00 00       	call   800bd5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 3f 80 00       	push   $0x803f00
  80008e:	e8 42 0b 00 00       	call   800bd5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 30 3f 80 00       	push   $0x803f30
  8000a5:	e8 04 12 00 00       	call   8012ae <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 05 18 00 00       	call   8018c5 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 33 23 00 00       	call   802408 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 50 3f 80 00       	push   $0x803f50
  8000e3:	e8 ed 0a 00 00       	call   800bd5 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 72 3f 80 00       	push   $0x803f72
  8000f3:	e8 dd 0a 00 00       	call   800bd5 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 80 3f 80 00       	push   $0x803f80
  800103:	e8 cd 0a 00 00       	call   800bd5 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 8f 3f 80 00       	push   $0x803f8f
  800113:	e8 bd 0a 00 00       	call   800bd5 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 9f 3f 80 00       	push   $0x803f9f
  800123:	e8 ad 0a 00 00       	call   800bd5 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  80012b:	e8 ea 05 00 00       	call   80071a <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>
		}
		sys_unlock_cons();
  800162:	e8 ec 28 00 00       	call   802a53 <sys_unlock_cons>
//		sys_unlock_cons();

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

//		sys_lock_cons();
		sys_lock_cons();
  8001d7:	e8 5d 28 00 00       	call   802a39 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 a8 3f 80 00       	push   $0x803fa8
  8001e4:	e8 ec 09 00 00       	call   800bd5 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
			//PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ec:	e8 62 28 00 00       	call   802a53 <sys_unlock_cons>
//		sys_unlock_cons();

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 dc 3f 80 00       	push   $0x803fdc
  800213:	6a 51                	push   $0x51
  800215:	68 fe 3f 80 00       	push   $0x803ffe
  80021a:	e8 c8 06 00 00       	call   8008e7 <_panic>
		else
		{
//			sys_lock_cons();
			sys_lock_cons();
  80021f:	e8 15 28 00 00       	call   802a39 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 18 40 80 00       	push   $0x804018
  80022c:	e8 a4 09 00 00       	call   800bd5 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 4c 40 80 00       	push   $0x80404c
  80023c:	e8 94 09 00 00       	call   800bd5 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 80 40 80 00       	push   $0x804080
  80024c:	e8 84 09 00 00       	call   800bd5 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800254:	e8 fa 27 00 00       	call   802a53 <sys_unlock_cons>
		}

		//free(Elements) ;

//		sys_lock_cons();
		sys_lock_cons();
  800259:	e8 db 27 00 00       	call   802a39 <sys_lock_cons>
		{
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 b2 40 80 00       	push   $0x8040b2
  80026c:	e8 64 09 00 00       	call   800bd5 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 a1 04 00 00       	call   80071a <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

//		sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b2:	e8 9c 27 00 00       	call   802a53 <sys_unlock_cons>
//		sys_unlock_cons();

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 00 3f 80 00       	push   $0x803f00
  80044b:	e8 85 07 00 00       	call   800bd5 <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 d0 40 80 00       	push   $0x8040d0
  80046d:	e8 63 07 00 00       	call   800bd5 <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 d5 40 80 00       	push   $0x8040d5
  80049b:	e8 35 07 00 00       	call   800bd5 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 c7 1e 00 00       	call   802408 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 b2 1e 00 00       	call   802408 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 6d 24 00 00       	call   802b81 <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <getchar>:


int
getchar(void)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800720:	e8 fb 22 00 00       	call   802a20 <sys_cgetc>
  800725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800728:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80072b:	c9                   	leave  
  80072c:	c3                   	ret    

0080072d <iscons>:

int iscons(int fdnum)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800730:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800735:	5d                   	pop    %ebp
  800736:	c3                   	ret    

00800737 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800737:	55                   	push   %ebp
  800738:	89 e5                	mov    %esp,%ebp
  80073a:	57                   	push   %edi
  80073b:	56                   	push   %esi
  80073c:	53                   	push   %ebx
  80073d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800740:	e8 6d 25 00 00       	call   802cb2 <sys_getenvindex>
  800745:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800748:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80074b:	89 d0                	mov    %edx,%eax
  80074d:	01 c0                	add    %eax,%eax
  80074f:	01 d0                	add    %edx,%eax
  800751:	c1 e0 02             	shl    $0x2,%eax
  800754:	01 d0                	add    %edx,%eax
  800756:	c1 e0 02             	shl    $0x2,%eax
  800759:	01 d0                	add    %edx,%eax
  80075b:	c1 e0 03             	shl    $0x3,%eax
  80075e:	01 d0                	add    %edx,%eax
  800760:	c1 e0 02             	shl    $0x2,%eax
  800763:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800768:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80076d:	a1 24 50 80 00       	mov    0x805024,%eax
  800772:	8a 40 20             	mov    0x20(%eax),%al
  800775:	84 c0                	test   %al,%al
  800777:	74 0d                	je     800786 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800779:	a1 24 50 80 00       	mov    0x805024,%eax
  80077e:	83 c0 20             	add    $0x20,%eax
  800781:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800786:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80078a:	7e 0a                	jle    800796 <libmain+0x5f>
		binaryname = argv[0];
  80078c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	ff 75 0c             	pushl  0xc(%ebp)
  80079c:	ff 75 08             	pushl  0x8(%ebp)
  80079f:	e8 94 f8 ff ff       	call   800038 <_main>
  8007a4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007a7:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ac:	85 c0                	test   %eax,%eax
  8007ae:	0f 84 01 01 00 00    	je     8008b5 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007b4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007ba:	bb d4 41 80 00       	mov    $0x8041d4,%ebx
  8007bf:	ba 0e 00 00 00       	mov    $0xe,%edx
  8007c4:	89 c7                	mov    %eax,%edi
  8007c6:	89 de                	mov    %ebx,%esi
  8007c8:	89 d1                	mov    %edx,%ecx
  8007ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8007cc:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8007cf:	b9 56 00 00 00       	mov    $0x56,%ecx
  8007d4:	b0 00                	mov    $0x0,%al
  8007d6:	89 d7                	mov    %edx,%edi
  8007d8:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8007da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8007e1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	50                   	push   %eax
  8007e8:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007ee:	50                   	push   %eax
  8007ef:	e8 f4 26 00 00       	call   802ee8 <sys_utilities>
  8007f4:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8007f7:	e8 3d 22 00 00       	call   802a39 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8007fc:	83 ec 0c             	sub    $0xc,%esp
  8007ff:	68 f4 40 80 00       	push   $0x8040f4
  800804:	e8 cc 03 00 00       	call   800bd5 <cprintf>
  800809:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80080c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80080f:	85 c0                	test   %eax,%eax
  800811:	74 18                	je     80082b <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800813:	e8 ee 26 00 00       	call   802f06 <sys_get_optimal_num_faults>
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	50                   	push   %eax
  80081c:	68 1c 41 80 00       	push   $0x80411c
  800821:	e8 af 03 00 00       	call   800bd5 <cprintf>
  800826:	83 c4 10             	add    $0x10,%esp
  800829:	eb 59                	jmp    800884 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80082b:	a1 24 50 80 00       	mov    0x805024,%eax
  800830:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800836:	a1 24 50 80 00       	mov    0x805024,%eax
  80083b:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800841:	83 ec 04             	sub    $0x4,%esp
  800844:	52                   	push   %edx
  800845:	50                   	push   %eax
  800846:	68 40 41 80 00       	push   $0x804140
  80084b:	e8 85 03 00 00       	call   800bd5 <cprintf>
  800850:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800853:	a1 24 50 80 00       	mov    0x805024,%eax
  800858:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  80085e:	a1 24 50 80 00       	mov    0x805024,%eax
  800863:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800869:	a1 24 50 80 00       	mov    0x805024,%eax
  80086e:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800874:	51                   	push   %ecx
  800875:	52                   	push   %edx
  800876:	50                   	push   %eax
  800877:	68 68 41 80 00       	push   $0x804168
  80087c:	e8 54 03 00 00       	call   800bd5 <cprintf>
  800881:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800884:	a1 24 50 80 00       	mov    0x805024,%eax
  800889:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	50                   	push   %eax
  800893:	68 c0 41 80 00       	push   $0x8041c0
  800898:	e8 38 03 00 00       	call   800bd5 <cprintf>
  80089d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	68 f4 40 80 00       	push   $0x8040f4
  8008a8:	e8 28 03 00 00       	call   800bd5 <cprintf>
  8008ad:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008b0:	e8 9e 21 00 00       	call   802a53 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008b5:	e8 1f 00 00 00       	call   8008d9 <exit>
}
  8008ba:	90                   	nop
  8008bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008be:	5b                   	pop    %ebx
  8008bf:	5e                   	pop    %esi
  8008c0:	5f                   	pop    %edi
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008c9:	83 ec 0c             	sub    $0xc,%esp
  8008cc:	6a 00                	push   $0x0
  8008ce:	e8 ab 23 00 00       	call   802c7e <sys_destroy_env>
  8008d3:	83 c4 10             	add    $0x10,%esp
}
  8008d6:	90                   	nop
  8008d7:	c9                   	leave  
  8008d8:	c3                   	ret    

008008d9 <exit>:

void
exit(void)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008df:	e8 00 24 00 00       	call   802ce4 <sys_exit_env>
}
  8008e4:	90                   	nop
  8008e5:	c9                   	leave  
  8008e6:	c3                   	ret    

008008e7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008ed:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f0:	83 c0 04             	add    $0x4,%eax
  8008f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008f6:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8008fb:	85 c0                	test   %eax,%eax
  8008fd:	74 16                	je     800915 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008ff:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	50                   	push   %eax
  800908:	68 38 42 80 00       	push   $0x804238
  80090d:	e8 c3 02 00 00       	call   800bd5 <cprintf>
  800912:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800915:	a1 04 50 80 00       	mov    0x805004,%eax
  80091a:	83 ec 0c             	sub    $0xc,%esp
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	ff 75 08             	pushl  0x8(%ebp)
  800923:	50                   	push   %eax
  800924:	68 40 42 80 00       	push   $0x804240
  800929:	6a 74                	push   $0x74
  80092b:	e8 d2 02 00 00       	call   800c02 <cprintf_colored>
  800930:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800933:	8b 45 10             	mov    0x10(%ebp),%eax
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 f4             	pushl  -0xc(%ebp)
  80093c:	50                   	push   %eax
  80093d:	e8 24 02 00 00       	call   800b66 <vcprintf>
  800942:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	6a 00                	push   $0x0
  80094a:	68 68 42 80 00       	push   $0x804268
  80094f:	e8 12 02 00 00       	call   800b66 <vcprintf>
  800954:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800957:	e8 7d ff ff ff       	call   8008d9 <exit>

	// should not return here
	while (1) ;
  80095c:	eb fe                	jmp    80095c <_panic+0x75>

0080095e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	53                   	push   %ebx
  800962:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800965:	a1 24 50 80 00       	mov    0x805024,%eax
  80096a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800970:	8b 45 0c             	mov    0xc(%ebp),%eax
  800973:	39 c2                	cmp    %eax,%edx
  800975:	74 14                	je     80098b <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800977:	83 ec 04             	sub    $0x4,%esp
  80097a:	68 6c 42 80 00       	push   $0x80426c
  80097f:	6a 26                	push   $0x26
  800981:	68 b8 42 80 00       	push   $0x8042b8
  800986:	e8 5c ff ff ff       	call   8008e7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80098b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800992:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800999:	e9 d9 00 00 00       	jmp    800a77 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  80099e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	01 d0                	add    %edx,%eax
  8009ad:	8b 00                	mov    (%eax),%eax
  8009af:	85 c0                	test   %eax,%eax
  8009b1:	75 08                	jne    8009bb <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8009b3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009b6:	e9 b9 00 00 00       	jmp    800a74 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8009bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009c9:	eb 79                	jmp    800a44 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009cb:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d0:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8009d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009d9:	89 d0                	mov    %edx,%eax
  8009db:	01 c0                	add    %eax,%eax
  8009dd:	01 d0                	add    %edx,%eax
  8009df:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8009e6:	01 d8                	add    %ebx,%eax
  8009e8:	01 d0                	add    %edx,%eax
  8009ea:	01 c8                	add    %ecx,%eax
  8009ec:	8a 40 04             	mov    0x4(%eax),%al
  8009ef:	84 c0                	test   %al,%al
  8009f1:	75 4e                	jne    800a41 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009f3:	a1 24 50 80 00       	mov    0x805024,%eax
  8009f8:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8009fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a01:	89 d0                	mov    %edx,%eax
  800a03:	01 c0                	add    %eax,%eax
  800a05:	01 d0                	add    %edx,%eax
  800a07:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800a0e:	01 d8                	add    %ebx,%eax
  800a10:	01 d0                	add    %edx,%eax
  800a12:	01 c8                	add    %ecx,%eax
  800a14:	8b 00                	mov    (%eax),%eax
  800a16:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a1c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a21:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a26:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	01 c8                	add    %ecx,%eax
  800a32:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a34:	39 c2                	cmp    %eax,%edx
  800a36:	75 09                	jne    800a41 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800a38:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a3f:	eb 19                	jmp    800a5a <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a41:	ff 45 e8             	incl   -0x18(%ebp)
  800a44:	a1 24 50 80 00       	mov    0x805024,%eax
  800a49:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	0f 87 71 ff ff ff    	ja     8009cb <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a5e:	75 14                	jne    800a74 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800a60:	83 ec 04             	sub    $0x4,%esp
  800a63:	68 c4 42 80 00       	push   $0x8042c4
  800a68:	6a 3a                	push   $0x3a
  800a6a:	68 b8 42 80 00       	push   $0x8042b8
  800a6f:	e8 73 fe ff ff       	call   8008e7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a74:	ff 45 f0             	incl   -0x10(%ebp)
  800a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a7d:	0f 8c 1b ff ff ff    	jl     80099e <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a83:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a91:	eb 2e                	jmp    800ac1 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a93:	a1 24 50 80 00       	mov    0x805024,%eax
  800a98:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800a9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aa1:	89 d0                	mov    %edx,%eax
  800aa3:	01 c0                	add    %eax,%eax
  800aa5:	01 d0                	add    %edx,%eax
  800aa7:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800aae:	01 d8                	add    %ebx,%eax
  800ab0:	01 d0                	add    %edx,%eax
  800ab2:	01 c8                	add    %ecx,%eax
  800ab4:	8a 40 04             	mov    0x4(%eax),%al
  800ab7:	3c 01                	cmp    $0x1,%al
  800ab9:	75 03                	jne    800abe <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800abb:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800abe:	ff 45 e0             	incl   -0x20(%ebp)
  800ac1:	a1 24 50 80 00       	mov    0x805024,%eax
  800ac6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acf:	39 c2                	cmp    %eax,%edx
  800ad1:	77 c0                	ja     800a93 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ad9:	74 14                	je     800aef <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800adb:	83 ec 04             	sub    $0x4,%esp
  800ade:	68 18 43 80 00       	push   $0x804318
  800ae3:	6a 44                	push   $0x44
  800ae5:	68 b8 42 80 00       	push   $0x8042b8
  800aea:	e8 f8 fd ff ff       	call   8008e7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800aef:	90                   	nop
  800af0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	53                   	push   %ebx
  800af9:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	8d 48 01             	lea    0x1(%eax),%ecx
  800b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b07:	89 0a                	mov    %ecx,(%edx)
  800b09:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0c:	88 d1                	mov    %dl,%cl
  800b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b11:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b18:	8b 00                	mov    (%eax),%eax
  800b1a:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b1f:	75 30                	jne    800b51 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b21:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800b27:	a0 44 50 80 00       	mov    0x805044,%al
  800b2c:	0f b6 c0             	movzbl %al,%eax
  800b2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b32:	8b 09                	mov    (%ecx),%ecx
  800b34:	89 cb                	mov    %ecx,%ebx
  800b36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b39:	83 c1 08             	add    $0x8,%ecx
  800b3c:	52                   	push   %edx
  800b3d:	50                   	push   %eax
  800b3e:	53                   	push   %ebx
  800b3f:	51                   	push   %ecx
  800b40:	e8 b0 1e 00 00       	call   8029f5 <sys_cputs>
  800b45:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8b 40 04             	mov    0x4(%eax),%eax
  800b57:	8d 50 01             	lea    0x1(%eax),%edx
  800b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b60:	90                   	nop
  800b61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b64:	c9                   	leave  
  800b65:	c3                   	ret    

00800b66 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b6f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b76:	00 00 00 
	b.cnt = 0;
  800b79:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b80:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	ff 75 08             	pushl  0x8(%ebp)
  800b89:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b8f:	50                   	push   %eax
  800b90:	68 f5 0a 80 00       	push   $0x800af5
  800b95:	e8 5a 02 00 00       	call   800df4 <vprintfmt>
  800b9a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800b9d:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800ba3:	a0 44 50 80 00       	mov    0x805044,%al
  800ba8:	0f b6 c0             	movzbl %al,%eax
  800bab:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800bb1:	52                   	push   %edx
  800bb2:	50                   	push   %eax
  800bb3:	51                   	push   %ecx
  800bb4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bba:	83 c0 08             	add    $0x8,%eax
  800bbd:	50                   	push   %eax
  800bbe:	e8 32 1e 00 00       	call   8029f5 <sys_cputs>
  800bc3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bc6:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800bcd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bd3:	c9                   	leave  
  800bd4:	c3                   	ret    

00800bd5 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bdb:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800be2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	83 ec 08             	sub    $0x8,%esp
  800bee:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf1:	50                   	push   %eax
  800bf2:	e8 6f ff ff ff       	call   800b66 <vcprintf>
  800bf7:	83 c4 10             	add    $0x10,%esp
  800bfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c00:	c9                   	leave  
  800c01:	c3                   	ret    

00800c02 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c08:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	c1 e0 08             	shl    $0x8,%eax
  800c15:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800c1a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c1d:	83 c0 04             	add    $0x4,%eax
  800c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c26:	83 ec 08             	sub    $0x8,%esp
  800c29:	ff 75 f4             	pushl  -0xc(%ebp)
  800c2c:	50                   	push   %eax
  800c2d:	e8 34 ff ff ff       	call   800b66 <vcprintf>
  800c32:	83 c4 10             	add    $0x10,%esp
  800c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c38:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800c3f:	07 00 00 

	return cnt;
  800c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c45:	c9                   	leave  
  800c46:	c3                   	ret    

00800c47 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c4d:	e8 e7 1d 00 00       	call   802a39 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c52:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c61:	50                   	push   %eax
  800c62:	e8 ff fe ff ff       	call   800b66 <vcprintf>
  800c67:	83 c4 10             	add    $0x10,%esp
  800c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c6d:	e8 e1 1d 00 00       	call   802a53 <sys_unlock_cons>
	return cnt;
  800c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c75:	c9                   	leave  
  800c76:	c3                   	ret    

00800c77 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	53                   	push   %ebx
  800c7b:	83 ec 14             	sub    $0x14,%esp
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c8a:	8b 45 18             	mov    0x18(%ebp),%eax
  800c8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c92:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c95:	77 55                	ja     800cec <printnum+0x75>
  800c97:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c9a:	72 05                	jb     800ca1 <printnum+0x2a>
  800c9c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c9f:	77 4b                	ja     800cec <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ca1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ca4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ca7:	8b 45 18             	mov    0x18(%ebp),%eax
  800caa:	ba 00 00 00 00       	mov    $0x0,%edx
  800caf:	52                   	push   %edx
  800cb0:	50                   	push   %eax
  800cb1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb4:	ff 75 f0             	pushl  -0x10(%ebp)
  800cb7:	e8 dc 2f 00 00       	call   803c98 <__udivdi3>
  800cbc:	83 c4 10             	add    $0x10,%esp
  800cbf:	83 ec 04             	sub    $0x4,%esp
  800cc2:	ff 75 20             	pushl  0x20(%ebp)
  800cc5:	53                   	push   %ebx
  800cc6:	ff 75 18             	pushl  0x18(%ebp)
  800cc9:	52                   	push   %edx
  800cca:	50                   	push   %eax
  800ccb:	ff 75 0c             	pushl  0xc(%ebp)
  800cce:	ff 75 08             	pushl  0x8(%ebp)
  800cd1:	e8 a1 ff ff ff       	call   800c77 <printnum>
  800cd6:	83 c4 20             	add    $0x20,%esp
  800cd9:	eb 1a                	jmp    800cf5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cdb:	83 ec 08             	sub    $0x8,%esp
  800cde:	ff 75 0c             	pushl  0xc(%ebp)
  800ce1:	ff 75 20             	pushl  0x20(%ebp)
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	ff d0                	call   *%eax
  800ce9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cec:	ff 4d 1c             	decl   0x1c(%ebp)
  800cef:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800cf3:	7f e6                	jg     800cdb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cf5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800cf8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d03:	53                   	push   %ebx
  800d04:	51                   	push   %ecx
  800d05:	52                   	push   %edx
  800d06:	50                   	push   %eax
  800d07:	e8 9c 30 00 00       	call   803da8 <__umoddi3>
  800d0c:	83 c4 10             	add    $0x10,%esp
  800d0f:	05 94 45 80 00       	add    $0x804594,%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	0f be c0             	movsbl %al,%eax
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	50                   	push   %eax
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
}
  800d28:	90                   	nop
  800d29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d2c:	c9                   	leave  
  800d2d:	c3                   	ret    

00800d2e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d31:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d35:	7e 1c                	jle    800d53 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	8b 00                	mov    (%eax),%eax
  800d3c:	8d 50 08             	lea    0x8(%eax),%edx
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	89 10                	mov    %edx,(%eax)
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 00                	mov    (%eax),%eax
  800d49:	83 e8 08             	sub    $0x8,%eax
  800d4c:	8b 50 04             	mov    0x4(%eax),%edx
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	eb 40                	jmp    800d93 <getuint+0x65>
	else if (lflag)
  800d53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d57:	74 1e                	je     800d77 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	8d 50 04             	lea    0x4(%eax),%edx
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	89 10                	mov    %edx,(%eax)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8b 00                	mov    (%eax),%eax
  800d6b:	83 e8 04             	sub    $0x4,%eax
  800d6e:	8b 00                	mov    (%eax),%eax
  800d70:	ba 00 00 00 00       	mov    $0x0,%edx
  800d75:	eb 1c                	jmp    800d93 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8b 00                	mov    (%eax),%eax
  800d7c:	8d 50 04             	lea    0x4(%eax),%edx
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	89 10                	mov    %edx,(%eax)
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8b 00                	mov    (%eax),%eax
  800d89:	83 e8 04             	sub    $0x4,%eax
  800d8c:	8b 00                	mov    (%eax),%eax
  800d8e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    

00800d95 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d98:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d9c:	7e 1c                	jle    800dba <getint+0x25>
		return va_arg(*ap, long long);
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8b 00                	mov    (%eax),%eax
  800da3:	8d 50 08             	lea    0x8(%eax),%edx
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	89 10                	mov    %edx,(%eax)
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8b 00                	mov    (%eax),%eax
  800db0:	83 e8 08             	sub    $0x8,%eax
  800db3:	8b 50 04             	mov    0x4(%eax),%edx
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	eb 38                	jmp    800df2 <getint+0x5d>
	else if (lflag)
  800dba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dbe:	74 1a                	je     800dda <getint+0x45>
		return va_arg(*ap, long);
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	8d 50 04             	lea    0x4(%eax),%edx
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	89 10                	mov    %edx,(%eax)
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8b 00                	mov    (%eax),%eax
  800dd2:	83 e8 04             	sub    $0x4,%eax
  800dd5:	8b 00                	mov    (%eax),%eax
  800dd7:	99                   	cltd   
  800dd8:	eb 18                	jmp    800df2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8b 00                	mov    (%eax),%eax
  800ddf:	8d 50 04             	lea    0x4(%eax),%edx
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 10                	mov    %edx,(%eax)
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	83 e8 04             	sub    $0x4,%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	99                   	cltd   
}
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dfc:	eb 17                	jmp    800e15 <vprintfmt+0x21>
			if (ch == '\0')
  800dfe:	85 db                	test   %ebx,%ebx
  800e00:	0f 84 c1 03 00 00    	je     8011c7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e06:	83 ec 08             	sub    $0x8,%esp
  800e09:	ff 75 0c             	pushl  0xc(%ebp)
  800e0c:	53                   	push   %ebx
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	ff d0                	call   *%eax
  800e12:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	8d 50 01             	lea    0x1(%eax),%edx
  800e1b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	0f b6 d8             	movzbl %al,%ebx
  800e23:	83 fb 25             	cmp    $0x25,%ebx
  800e26:	75 d6                	jne    800dfe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e28:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e2c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e33:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e3a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e41:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e48:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4b:	8d 50 01             	lea    0x1(%eax),%edx
  800e4e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	0f b6 d8             	movzbl %al,%ebx
  800e56:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e59:	83 f8 5b             	cmp    $0x5b,%eax
  800e5c:	0f 87 3d 03 00 00    	ja     80119f <vprintfmt+0x3ab>
  800e62:	8b 04 85 b8 45 80 00 	mov    0x8045b8(,%eax,4),%eax
  800e69:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e6b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e6f:	eb d7                	jmp    800e48 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e71:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e75:	eb d1                	jmp    800e48 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e77:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e81:	89 d0                	mov    %edx,%eax
  800e83:	c1 e0 02             	shl    $0x2,%eax
  800e86:	01 d0                	add    %edx,%eax
  800e88:	01 c0                	add    %eax,%eax
  800e8a:	01 d8                	add    %ebx,%eax
  800e8c:	83 e8 30             	sub    $0x30,%eax
  800e8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e9a:	83 fb 2f             	cmp    $0x2f,%ebx
  800e9d:	7e 3e                	jle    800edd <vprintfmt+0xe9>
  800e9f:	83 fb 39             	cmp    $0x39,%ebx
  800ea2:	7f 39                	jg     800edd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ea4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ea7:	eb d5                	jmp    800e7e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ea9:	8b 45 14             	mov    0x14(%ebp),%eax
  800eac:	83 c0 04             	add    $0x4,%eax
  800eaf:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb5:	83 e8 04             	sub    $0x4,%eax
  800eb8:	8b 00                	mov    (%eax),%eax
  800eba:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ebd:	eb 1f                	jmp    800ede <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ebf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ec3:	79 83                	jns    800e48 <vprintfmt+0x54>
				width = 0;
  800ec5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ecc:	e9 77 ff ff ff       	jmp    800e48 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ed1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ed8:	e9 6b ff ff ff       	jmp    800e48 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800edd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ede:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ee2:	0f 89 60 ff ff ff    	jns    800e48 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ee8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eeb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800eee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ef5:	e9 4e ff ff ff       	jmp    800e48 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800efa:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800efd:	e9 46 ff ff ff       	jmp    800e48 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f02:	8b 45 14             	mov    0x14(%ebp),%eax
  800f05:	83 c0 04             	add    $0x4,%eax
  800f08:	89 45 14             	mov    %eax,0x14(%ebp)
  800f0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0e:	83 e8 04             	sub    $0x4,%eax
  800f11:	8b 00                	mov    (%eax),%eax
  800f13:	83 ec 08             	sub    $0x8,%esp
  800f16:	ff 75 0c             	pushl  0xc(%ebp)
  800f19:	50                   	push   %eax
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	ff d0                	call   *%eax
  800f1f:	83 c4 10             	add    $0x10,%esp
			break;
  800f22:	e9 9b 02 00 00       	jmp    8011c2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f27:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2a:	83 c0 04             	add    $0x4,%eax
  800f2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f30:	8b 45 14             	mov    0x14(%ebp),%eax
  800f33:	83 e8 04             	sub    $0x4,%eax
  800f36:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f38:	85 db                	test   %ebx,%ebx
  800f3a:	79 02                	jns    800f3e <vprintfmt+0x14a>
				err = -err;
  800f3c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f3e:	83 fb 64             	cmp    $0x64,%ebx
  800f41:	7f 0b                	jg     800f4e <vprintfmt+0x15a>
  800f43:	8b 34 9d 00 44 80 00 	mov    0x804400(,%ebx,4),%esi
  800f4a:	85 f6                	test   %esi,%esi
  800f4c:	75 19                	jne    800f67 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f4e:	53                   	push   %ebx
  800f4f:	68 a5 45 80 00       	push   $0x8045a5
  800f54:	ff 75 0c             	pushl  0xc(%ebp)
  800f57:	ff 75 08             	pushl  0x8(%ebp)
  800f5a:	e8 70 02 00 00       	call   8011cf <printfmt>
  800f5f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f62:	e9 5b 02 00 00       	jmp    8011c2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f67:	56                   	push   %esi
  800f68:	68 ae 45 80 00       	push   $0x8045ae
  800f6d:	ff 75 0c             	pushl  0xc(%ebp)
  800f70:	ff 75 08             	pushl  0x8(%ebp)
  800f73:	e8 57 02 00 00       	call   8011cf <printfmt>
  800f78:	83 c4 10             	add    $0x10,%esp
			break;
  800f7b:	e9 42 02 00 00       	jmp    8011c2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f80:	8b 45 14             	mov    0x14(%ebp),%eax
  800f83:	83 c0 04             	add    $0x4,%eax
  800f86:	89 45 14             	mov    %eax,0x14(%ebp)
  800f89:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8c:	83 e8 04             	sub    $0x4,%eax
  800f8f:	8b 30                	mov    (%eax),%esi
  800f91:	85 f6                	test   %esi,%esi
  800f93:	75 05                	jne    800f9a <vprintfmt+0x1a6>
				p = "(null)";
  800f95:	be b1 45 80 00       	mov    $0x8045b1,%esi
			if (width > 0 && padc != '-')
  800f9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f9e:	7e 6d                	jle    80100d <vprintfmt+0x219>
  800fa0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fa4:	74 67                	je     80100d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fa6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fa9:	83 ec 08             	sub    $0x8,%esp
  800fac:	50                   	push   %eax
  800fad:	56                   	push   %esi
  800fae:	e8 26 05 00 00       	call   8014d9 <strnlen>
  800fb3:	83 c4 10             	add    $0x10,%esp
  800fb6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fb9:	eb 16                	jmp    800fd1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fbb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fbf:	83 ec 08             	sub    $0x8,%esp
  800fc2:	ff 75 0c             	pushl  0xc(%ebp)
  800fc5:	50                   	push   %eax
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	ff d0                	call   *%eax
  800fcb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fce:	ff 4d e4             	decl   -0x1c(%ebp)
  800fd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd5:	7f e4                	jg     800fbb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fd7:	eb 34                	jmp    80100d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fd9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fdd:	74 1c                	je     800ffb <vprintfmt+0x207>
  800fdf:	83 fb 1f             	cmp    $0x1f,%ebx
  800fe2:	7e 05                	jle    800fe9 <vprintfmt+0x1f5>
  800fe4:	83 fb 7e             	cmp    $0x7e,%ebx
  800fe7:	7e 12                	jle    800ffb <vprintfmt+0x207>
					putch('?', putdat);
  800fe9:	83 ec 08             	sub    $0x8,%esp
  800fec:	ff 75 0c             	pushl  0xc(%ebp)
  800fef:	6a 3f                	push   $0x3f
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	ff d0                	call   *%eax
  800ff6:	83 c4 10             	add    $0x10,%esp
  800ff9:	eb 0f                	jmp    80100a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ffb:	83 ec 08             	sub    $0x8,%esp
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	53                   	push   %ebx
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	ff d0                	call   *%eax
  801007:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80100a:	ff 4d e4             	decl   -0x1c(%ebp)
  80100d:	89 f0                	mov    %esi,%eax
  80100f:	8d 70 01             	lea    0x1(%eax),%esi
  801012:	8a 00                	mov    (%eax),%al
  801014:	0f be d8             	movsbl %al,%ebx
  801017:	85 db                	test   %ebx,%ebx
  801019:	74 24                	je     80103f <vprintfmt+0x24b>
  80101b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80101f:	78 b8                	js     800fd9 <vprintfmt+0x1e5>
  801021:	ff 4d e0             	decl   -0x20(%ebp)
  801024:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801028:	79 af                	jns    800fd9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80102a:	eb 13                	jmp    80103f <vprintfmt+0x24b>
				putch(' ', putdat);
  80102c:	83 ec 08             	sub    $0x8,%esp
  80102f:	ff 75 0c             	pushl  0xc(%ebp)
  801032:	6a 20                	push   $0x20
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	ff d0                	call   *%eax
  801039:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80103c:	ff 4d e4             	decl   -0x1c(%ebp)
  80103f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801043:	7f e7                	jg     80102c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801045:	e9 78 01 00 00       	jmp    8011c2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80104a:	83 ec 08             	sub    $0x8,%esp
  80104d:	ff 75 e8             	pushl  -0x18(%ebp)
  801050:	8d 45 14             	lea    0x14(%ebp),%eax
  801053:	50                   	push   %eax
  801054:	e8 3c fd ff ff       	call   800d95 <getint>
  801059:	83 c4 10             	add    $0x10,%esp
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801068:	85 d2                	test   %edx,%edx
  80106a:	79 23                	jns    80108f <vprintfmt+0x29b>
				putch('-', putdat);
  80106c:	83 ec 08             	sub    $0x8,%esp
  80106f:	ff 75 0c             	pushl  0xc(%ebp)
  801072:	6a 2d                	push   $0x2d
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	ff d0                	call   *%eax
  801079:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80107c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801082:	f7 d8                	neg    %eax
  801084:	83 d2 00             	adc    $0x0,%edx
  801087:	f7 da                	neg    %edx
  801089:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80108f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801096:	e9 bc 00 00 00       	jmp    801157 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80109b:	83 ec 08             	sub    $0x8,%esp
  80109e:	ff 75 e8             	pushl  -0x18(%ebp)
  8010a1:	8d 45 14             	lea    0x14(%ebp),%eax
  8010a4:	50                   	push   %eax
  8010a5:	e8 84 fc ff ff       	call   800d2e <getuint>
  8010aa:	83 c4 10             	add    $0x10,%esp
  8010ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010b3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010ba:	e9 98 00 00 00       	jmp    801157 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010bf:	83 ec 08             	sub    $0x8,%esp
  8010c2:	ff 75 0c             	pushl  0xc(%ebp)
  8010c5:	6a 58                	push   $0x58
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	ff d0                	call   *%eax
  8010cc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010cf:	83 ec 08             	sub    $0x8,%esp
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	6a 58                	push   $0x58
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	ff d0                	call   *%eax
  8010dc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010df:	83 ec 08             	sub    $0x8,%esp
  8010e2:	ff 75 0c             	pushl  0xc(%ebp)
  8010e5:	6a 58                	push   $0x58
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	ff d0                	call   *%eax
  8010ec:	83 c4 10             	add    $0x10,%esp
			break;
  8010ef:	e9 ce 00 00 00       	jmp    8011c2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8010f4:	83 ec 08             	sub    $0x8,%esp
  8010f7:	ff 75 0c             	pushl  0xc(%ebp)
  8010fa:	6a 30                	push   $0x30
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	ff d0                	call   *%eax
  801101:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801104:	83 ec 08             	sub    $0x8,%esp
  801107:	ff 75 0c             	pushl  0xc(%ebp)
  80110a:	6a 78                	push   $0x78
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	ff d0                	call   *%eax
  801111:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801114:	8b 45 14             	mov    0x14(%ebp),%eax
  801117:	83 c0 04             	add    $0x4,%eax
  80111a:	89 45 14             	mov    %eax,0x14(%ebp)
  80111d:	8b 45 14             	mov    0x14(%ebp),%eax
  801120:	83 e8 04             	sub    $0x4,%eax
  801123:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801125:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801128:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80112f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801136:	eb 1f                	jmp    801157 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801138:	83 ec 08             	sub    $0x8,%esp
  80113b:	ff 75 e8             	pushl  -0x18(%ebp)
  80113e:	8d 45 14             	lea    0x14(%ebp),%eax
  801141:	50                   	push   %eax
  801142:	e8 e7 fb ff ff       	call   800d2e <getuint>
  801147:	83 c4 10             	add    $0x10,%esp
  80114a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80114d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801150:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801157:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80115b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80115e:	83 ec 04             	sub    $0x4,%esp
  801161:	52                   	push   %edx
  801162:	ff 75 e4             	pushl  -0x1c(%ebp)
  801165:	50                   	push   %eax
  801166:	ff 75 f4             	pushl  -0xc(%ebp)
  801169:	ff 75 f0             	pushl  -0x10(%ebp)
  80116c:	ff 75 0c             	pushl  0xc(%ebp)
  80116f:	ff 75 08             	pushl  0x8(%ebp)
  801172:	e8 00 fb ff ff       	call   800c77 <printnum>
  801177:	83 c4 20             	add    $0x20,%esp
			break;
  80117a:	eb 46                	jmp    8011c2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80117c:	83 ec 08             	sub    $0x8,%esp
  80117f:	ff 75 0c             	pushl  0xc(%ebp)
  801182:	53                   	push   %ebx
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	ff d0                	call   *%eax
  801188:	83 c4 10             	add    $0x10,%esp
			break;
  80118b:	eb 35                	jmp    8011c2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80118d:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  801194:	eb 2c                	jmp    8011c2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801196:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  80119d:	eb 23                	jmp    8011c2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80119f:	83 ec 08             	sub    $0x8,%esp
  8011a2:	ff 75 0c             	pushl  0xc(%ebp)
  8011a5:	6a 25                	push   $0x25
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	ff d0                	call   *%eax
  8011ac:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011af:	ff 4d 10             	decl   0x10(%ebp)
  8011b2:	eb 03                	jmp    8011b7 <vprintfmt+0x3c3>
  8011b4:	ff 4d 10             	decl   0x10(%ebp)
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	48                   	dec    %eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	3c 25                	cmp    $0x25,%al
  8011bf:	75 f3                	jne    8011b4 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011c1:	90                   	nop
		}
	}
  8011c2:	e9 35 fc ff ff       	jmp    800dfc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011c7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011cb:	5b                   	pop    %ebx
  8011cc:	5e                   	pop    %esi
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    

008011cf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8011d8:	83 c0 04             	add    $0x4,%eax
  8011db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8011e4:	50                   	push   %eax
  8011e5:	ff 75 0c             	pushl  0xc(%ebp)
  8011e8:	ff 75 08             	pushl  0x8(%ebp)
  8011eb:	e8 04 fc ff ff       	call   800df4 <vprintfmt>
  8011f0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8011f3:	90                   	nop
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	8b 40 08             	mov    0x8(%eax),%eax
  8011ff:	8d 50 01             	lea    0x1(%eax),%edx
  801202:	8b 45 0c             	mov    0xc(%ebp),%eax
  801205:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	8b 10                	mov    (%eax),%edx
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	8b 40 04             	mov    0x4(%eax),%eax
  801213:	39 c2                	cmp    %eax,%edx
  801215:	73 12                	jae    801229 <sprintputch+0x33>
		*b->buf++ = ch;
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	8b 00                	mov    (%eax),%eax
  80121c:	8d 48 01             	lea    0x1(%eax),%ecx
  80121f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801222:	89 0a                	mov    %ecx,(%edx)
  801224:	8b 55 08             	mov    0x8(%ebp),%edx
  801227:	88 10                	mov    %dl,(%eax)
}
  801229:	90                   	nop
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    

0080122c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	01 d0                	add    %edx,%eax
  801243:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801246:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80124d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801251:	74 06                	je     801259 <vsnprintf+0x2d>
  801253:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801257:	7f 07                	jg     801260 <vsnprintf+0x34>
		return -E_INVAL;
  801259:	b8 03 00 00 00       	mov    $0x3,%eax
  80125e:	eb 20                	jmp    801280 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801260:	ff 75 14             	pushl  0x14(%ebp)
  801263:	ff 75 10             	pushl  0x10(%ebp)
  801266:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801269:	50                   	push   %eax
  80126a:	68 f6 11 80 00       	push   $0x8011f6
  80126f:	e8 80 fb ff ff       	call   800df4 <vprintfmt>
  801274:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801277:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80127a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80127d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801288:	8d 45 10             	lea    0x10(%ebp),%eax
  80128b:	83 c0 04             	add    $0x4,%eax
  80128e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801291:	8b 45 10             	mov    0x10(%ebp),%eax
  801294:	ff 75 f4             	pushl  -0xc(%ebp)
  801297:	50                   	push   %eax
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	ff 75 08             	pushl  0x8(%ebp)
  80129e:	e8 89 ff ff ff       	call   80122c <vsnprintf>
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8012b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b8:	74 13                	je     8012cd <readline+0x1f>
		cprintf("%s", prompt);
  8012ba:	83 ec 08             	sub    $0x8,%esp
  8012bd:	ff 75 08             	pushl  0x8(%ebp)
  8012c0:	68 28 47 80 00       	push   $0x804728
  8012c5:	e8 0b f9 ff ff       	call   800bd5 <cprintf>
  8012ca:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	6a 00                	push   $0x0
  8012d9:	e8 4f f4 ff ff       	call   80072d <iscons>
  8012de:	83 c4 10             	add    $0x10,%esp
  8012e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8012e4:	e8 31 f4 ff ff       	call   80071a <getchar>
  8012e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8012ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012f0:	79 22                	jns    801314 <readline+0x66>
			if (c != -E_EOF)
  8012f2:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012f6:	0f 84 ad 00 00 00    	je     8013a9 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8012fc:	83 ec 08             	sub    $0x8,%esp
  8012ff:	ff 75 ec             	pushl  -0x14(%ebp)
  801302:	68 2b 47 80 00       	push   $0x80472b
  801307:	e8 c9 f8 ff ff       	call   800bd5 <cprintf>
  80130c:	83 c4 10             	add    $0x10,%esp
			break;
  80130f:	e9 95 00 00 00       	jmp    8013a9 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801314:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801318:	7e 34                	jle    80134e <readline+0xa0>
  80131a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801321:	7f 2b                	jg     80134e <readline+0xa0>
			if (echoing)
  801323:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801327:	74 0e                	je     801337 <readline+0x89>
				cputchar(c);
  801329:	83 ec 0c             	sub    $0xc,%esp
  80132c:	ff 75 ec             	pushl  -0x14(%ebp)
  80132f:	e8 c7 f3 ff ff       	call   8006fb <cputchar>
  801334:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133a:	8d 50 01             	lea    0x1(%eax),%edx
  80133d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801340:	89 c2                	mov    %eax,%edx
  801342:	8b 45 0c             	mov    0xc(%ebp),%eax
  801345:	01 d0                	add    %edx,%eax
  801347:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80134a:	88 10                	mov    %dl,(%eax)
  80134c:	eb 56                	jmp    8013a4 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80134e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801352:	75 1f                	jne    801373 <readline+0xc5>
  801354:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801358:	7e 19                	jle    801373 <readline+0xc5>
			if (echoing)
  80135a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80135e:	74 0e                	je     80136e <readline+0xc0>
				cputchar(c);
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	ff 75 ec             	pushl  -0x14(%ebp)
  801366:	e8 90 f3 ff ff       	call   8006fb <cputchar>
  80136b:	83 c4 10             	add    $0x10,%esp

			i--;
  80136e:	ff 4d f4             	decl   -0xc(%ebp)
  801371:	eb 31                	jmp    8013a4 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801373:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801377:	74 0a                	je     801383 <readline+0xd5>
  801379:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80137d:	0f 85 61 ff ff ff    	jne    8012e4 <readline+0x36>
			if (echoing)
  801383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801387:	74 0e                	je     801397 <readline+0xe9>
				cputchar(c);
  801389:	83 ec 0c             	sub    $0xc,%esp
  80138c:	ff 75 ec             	pushl  -0x14(%ebp)
  80138f:	e8 67 f3 ff ff       	call   8006fb <cputchar>
  801394:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801397:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139d:	01 d0                	add    %edx,%eax
  80139f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8013a2:	eb 06                	jmp    8013aa <readline+0xfc>
		}
	}
  8013a4:	e9 3b ff ff ff       	jmp    8012e4 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8013a9:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8013aa:	90                   	nop
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    

008013ad <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8013b3:	e8 81 16 00 00       	call   802a39 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013bc:	74 13                	je     8013d1 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013be:	83 ec 08             	sub    $0x8,%esp
  8013c1:	ff 75 08             	pushl  0x8(%ebp)
  8013c4:	68 28 47 80 00       	push   $0x804728
  8013c9:	e8 07 f8 ff ff       	call   800bd5 <cprintf>
  8013ce:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8013d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8013d8:	83 ec 0c             	sub    $0xc,%esp
  8013db:	6a 00                	push   $0x0
  8013dd:	e8 4b f3 ff ff       	call   80072d <iscons>
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8013e8:	e8 2d f3 ff ff       	call   80071a <getchar>
  8013ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8013f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013f4:	79 22                	jns    801418 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8013f6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013fa:	0f 84 ad 00 00 00    	je     8014ad <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	ff 75 ec             	pushl  -0x14(%ebp)
  801406:	68 2b 47 80 00       	push   $0x80472b
  80140b:	e8 c5 f7 ff ff       	call   800bd5 <cprintf>
  801410:	83 c4 10             	add    $0x10,%esp
				break;
  801413:	e9 95 00 00 00       	jmp    8014ad <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801418:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80141c:	7e 34                	jle    801452 <atomic_readline+0xa5>
  80141e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801425:	7f 2b                	jg     801452 <atomic_readline+0xa5>
				if (echoing)
  801427:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80142b:	74 0e                	je     80143b <atomic_readline+0x8e>
					cputchar(c);
  80142d:	83 ec 0c             	sub    $0xc,%esp
  801430:	ff 75 ec             	pushl  -0x14(%ebp)
  801433:	e8 c3 f2 ff ff       	call   8006fb <cputchar>
  801438:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80143b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143e:	8d 50 01             	lea    0x1(%eax),%edx
  801441:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801444:	89 c2                	mov    %eax,%edx
  801446:	8b 45 0c             	mov    0xc(%ebp),%eax
  801449:	01 d0                	add    %edx,%eax
  80144b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80144e:	88 10                	mov    %dl,(%eax)
  801450:	eb 56                	jmp    8014a8 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801452:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801456:	75 1f                	jne    801477 <atomic_readline+0xca>
  801458:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80145c:	7e 19                	jle    801477 <atomic_readline+0xca>
				if (echoing)
  80145e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801462:	74 0e                	je     801472 <atomic_readline+0xc5>
					cputchar(c);
  801464:	83 ec 0c             	sub    $0xc,%esp
  801467:	ff 75 ec             	pushl  -0x14(%ebp)
  80146a:	e8 8c f2 ff ff       	call   8006fb <cputchar>
  80146f:	83 c4 10             	add    $0x10,%esp
				i--;
  801472:	ff 4d f4             	decl   -0xc(%ebp)
  801475:	eb 31                	jmp    8014a8 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801477:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80147b:	74 0a                	je     801487 <atomic_readline+0xda>
  80147d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801481:	0f 85 61 ff ff ff    	jne    8013e8 <atomic_readline+0x3b>
				if (echoing)
  801487:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80148b:	74 0e                	je     80149b <atomic_readline+0xee>
					cputchar(c);
  80148d:	83 ec 0c             	sub    $0xc,%esp
  801490:	ff 75 ec             	pushl  -0x14(%ebp)
  801493:	e8 63 f2 ff ff       	call   8006fb <cputchar>
  801498:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80149b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a1:	01 d0                	add    %edx,%eax
  8014a3:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8014a6:	eb 06                	jmp    8014ae <atomic_readline+0x101>
			}
		}
  8014a8:	e9 3b ff ff ff       	jmp    8013e8 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8014ad:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8014ae:	e8 a0 15 00 00       	call   802a53 <sys_unlock_cons>
}
  8014b3:	90                   	nop
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014c3:	eb 06                	jmp    8014cb <strlen+0x15>
		n++;
  8014c5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014c8:	ff 45 08             	incl   0x8(%ebp)
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	8a 00                	mov    (%eax),%al
  8014d0:	84 c0                	test   %al,%al
  8014d2:	75 f1                	jne    8014c5 <strlen+0xf>
		n++;
	return n;
  8014d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014e6:	eb 09                	jmp    8014f1 <strnlen+0x18>
		n++;
  8014e8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014eb:	ff 45 08             	incl   0x8(%ebp)
  8014ee:	ff 4d 0c             	decl   0xc(%ebp)
  8014f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014f5:	74 09                	je     801500 <strnlen+0x27>
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	8a 00                	mov    (%eax),%al
  8014fc:	84 c0                	test   %al,%al
  8014fe:	75 e8                	jne    8014e8 <strnlen+0xf>
		n++;
	return n;
  801500:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801511:	90                   	nop
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	8d 50 01             	lea    0x1(%eax),%edx
  801518:	89 55 08             	mov    %edx,0x8(%ebp)
  80151b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801521:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801524:	8a 12                	mov    (%edx),%dl
  801526:	88 10                	mov    %dl,(%eax)
  801528:	8a 00                	mov    (%eax),%al
  80152a:	84 c0                	test   %al,%al
  80152c:	75 e4                	jne    801512 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80152e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801531:	c9                   	leave  
  801532:	c3                   	ret    

00801533 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80153f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801546:	eb 1f                	jmp    801567 <strncpy+0x34>
		*dst++ = *src;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8d 50 01             	lea    0x1(%eax),%edx
  80154e:	89 55 08             	mov    %edx,0x8(%ebp)
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	8a 12                	mov    (%edx),%dl
  801556:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155b:	8a 00                	mov    (%eax),%al
  80155d:	84 c0                	test   %al,%al
  80155f:	74 03                	je     801564 <strncpy+0x31>
			src++;
  801561:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801564:	ff 45 fc             	incl   -0x4(%ebp)
  801567:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80156a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80156d:	72 d9                	jb     801548 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80156f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801580:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801584:	74 30                	je     8015b6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801586:	eb 16                	jmp    80159e <strlcpy+0x2a>
			*dst++ = *src++;
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	8d 50 01             	lea    0x1(%eax),%edx
  80158e:	89 55 08             	mov    %edx,0x8(%ebp)
  801591:	8b 55 0c             	mov    0xc(%ebp),%edx
  801594:	8d 4a 01             	lea    0x1(%edx),%ecx
  801597:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80159a:	8a 12                	mov    (%edx),%dl
  80159c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80159e:	ff 4d 10             	decl   0x10(%ebp)
  8015a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015a5:	74 09                	je     8015b0 <strlcpy+0x3c>
  8015a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015aa:	8a 00                	mov    (%eax),%al
  8015ac:	84 c0                	test   %al,%al
  8015ae:	75 d8                	jne    801588 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015bc:	29 c2                	sub    %eax,%edx
  8015be:	89 d0                	mov    %edx,%eax
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015c5:	eb 06                	jmp    8015cd <strcmp+0xb>
		p++, q++;
  8015c7:	ff 45 08             	incl   0x8(%ebp)
  8015ca:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	84 c0                	test   %al,%al
  8015d4:	74 0e                	je     8015e4 <strcmp+0x22>
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	8a 10                	mov    (%eax),%dl
  8015db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	38 c2                	cmp    %al,%dl
  8015e2:	74 e3                	je     8015c7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	8a 00                	mov    (%eax),%al
  8015e9:	0f b6 d0             	movzbl %al,%edx
  8015ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ef:	8a 00                	mov    (%eax),%al
  8015f1:	0f b6 c0             	movzbl %al,%eax
  8015f4:	29 c2                	sub    %eax,%edx
  8015f6:	89 d0                	mov    %edx,%eax
}
  8015f8:	5d                   	pop    %ebp
  8015f9:	c3                   	ret    

008015fa <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8015fd:	eb 09                	jmp    801608 <strncmp+0xe>
		n--, p++, q++;
  8015ff:	ff 4d 10             	decl   0x10(%ebp)
  801602:	ff 45 08             	incl   0x8(%ebp)
  801605:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801608:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80160c:	74 17                	je     801625 <strncmp+0x2b>
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
  801611:	8a 00                	mov    (%eax),%al
  801613:	84 c0                	test   %al,%al
  801615:	74 0e                	je     801625 <strncmp+0x2b>
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	8a 10                	mov    (%eax),%dl
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	8a 00                	mov    (%eax),%al
  801621:	38 c2                	cmp    %al,%dl
  801623:	74 da                	je     8015ff <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801625:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801629:	75 07                	jne    801632 <strncmp+0x38>
		return 0;
  80162b:	b8 00 00 00 00       	mov    $0x0,%eax
  801630:	eb 14                	jmp    801646 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8a 00                	mov    (%eax),%al
  801637:	0f b6 d0             	movzbl %al,%edx
  80163a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163d:	8a 00                	mov    (%eax),%al
  80163f:	0f b6 c0             	movzbl %al,%eax
  801642:	29 c2                	sub    %eax,%edx
  801644:	89 d0                	mov    %edx,%eax
}
  801646:	5d                   	pop    %ebp
  801647:	c3                   	ret    

00801648 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	83 ec 04             	sub    $0x4,%esp
  80164e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801651:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801654:	eb 12                	jmp    801668 <strchr+0x20>
		if (*s == c)
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	8a 00                	mov    (%eax),%al
  80165b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80165e:	75 05                	jne    801665 <strchr+0x1d>
			return (char *) s;
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	eb 11                	jmp    801676 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801665:	ff 45 08             	incl   0x8(%ebp)
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	84 c0                	test   %al,%al
  80166f:	75 e5                	jne    801656 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801671:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	83 ec 04             	sub    $0x4,%esp
  80167e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801681:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801684:	eb 0d                	jmp    801693 <strfind+0x1b>
		if (*s == c)
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	8a 00                	mov    (%eax),%al
  80168b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80168e:	74 0e                	je     80169e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801690:	ff 45 08             	incl   0x8(%ebp)
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	8a 00                	mov    (%eax),%al
  801698:	84 c0                	test   %al,%al
  80169a:	75 ea                	jne    801686 <strfind+0xe>
  80169c:	eb 01                	jmp    80169f <strfind+0x27>
		if (*s == c)
			break;
  80169e:	90                   	nop
	return (char *) s;
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8016b0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8016b4:	76 63                	jbe    801719 <memset+0x75>
		uint64 data_block = c;
  8016b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b9:	99                   	cltd   
  8016ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8016c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c6:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8016ca:	c1 e0 08             	shl    $0x8,%eax
  8016cd:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016d0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8016d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d9:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8016dd:	c1 e0 10             	shl    $0x10,%eax
  8016e0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016e3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8016e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ec:	89 c2                	mov    %eax,%edx
  8016ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016f6:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8016f9:	eb 18                	jmp    801713 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8016fb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016fe:	8d 41 08             	lea    0x8(%ecx),%eax
  801701:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801707:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170a:	89 01                	mov    %eax,(%ecx)
  80170c:	89 51 04             	mov    %edx,0x4(%ecx)
  80170f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801713:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801717:	77 e2                	ja     8016fb <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801719:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80171d:	74 23                	je     801742 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80171f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801722:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801725:	eb 0e                	jmp    801735 <memset+0x91>
			*p8++ = (uint8)c;
  801727:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172a:	8d 50 01             	lea    0x1(%eax),%edx
  80172d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801730:	8b 55 0c             	mov    0xc(%ebp),%edx
  801733:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801735:	8b 45 10             	mov    0x10(%ebp),%eax
  801738:	8d 50 ff             	lea    -0x1(%eax),%edx
  80173b:	89 55 10             	mov    %edx,0x10(%ebp)
  80173e:	85 c0                	test   %eax,%eax
  801740:	75 e5                	jne    801727 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80174d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801750:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801759:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80175d:	76 24                	jbe    801783 <memcpy+0x3c>
		while(n >= 8){
  80175f:	eb 1c                	jmp    80177d <memcpy+0x36>
			*d64 = *s64;
  801761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801764:	8b 50 04             	mov    0x4(%eax),%edx
  801767:	8b 00                	mov    (%eax),%eax
  801769:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80176c:	89 01                	mov    %eax,(%ecx)
  80176e:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801771:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801775:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801779:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80177d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801781:	77 de                	ja     801761 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801783:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801787:	74 31                	je     8017ba <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801789:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80178c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80178f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801792:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801795:	eb 16                	jmp    8017ad <memcpy+0x66>
			*d8++ = *s8++;
  801797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179a:	8d 50 01             	lea    0x1(%eax),%edx
  80179d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8017a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017a6:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8017a9:	8a 12                	mov    (%edx),%dl
  8017ab:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8017ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	75 dd                	jne    801797 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017d7:	73 50                	jae    801829 <memmove+0x6a>
  8017d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017df:	01 d0                	add    %edx,%eax
  8017e1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017e4:	76 43                	jbe    801829 <memmove+0x6a>
		s += n;
  8017e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8017ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ef:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017f2:	eb 10                	jmp    801804 <memmove+0x45>
			*--d = *--s;
  8017f4:	ff 4d f8             	decl   -0x8(%ebp)
  8017f7:	ff 4d fc             	decl   -0x4(%ebp)
  8017fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017fd:	8a 10                	mov    (%eax),%dl
  8017ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801802:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801804:	8b 45 10             	mov    0x10(%ebp),%eax
  801807:	8d 50 ff             	lea    -0x1(%eax),%edx
  80180a:	89 55 10             	mov    %edx,0x10(%ebp)
  80180d:	85 c0                	test   %eax,%eax
  80180f:	75 e3                	jne    8017f4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801811:	eb 23                	jmp    801836 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801813:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801816:	8d 50 01             	lea    0x1(%eax),%edx
  801819:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80181c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801822:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801825:	8a 12                	mov    (%edx),%dl
  801827:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801829:	8b 45 10             	mov    0x10(%ebp),%eax
  80182c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182f:	89 55 10             	mov    %edx,0x10(%ebp)
  801832:	85 c0                	test   %eax,%eax
  801834:	75 dd                	jne    801813 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801847:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80184d:	eb 2a                	jmp    801879 <memcmp+0x3e>
		if (*s1 != *s2)
  80184f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801852:	8a 10                	mov    (%eax),%dl
  801854:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801857:	8a 00                	mov    (%eax),%al
  801859:	38 c2                	cmp    %al,%dl
  80185b:	74 16                	je     801873 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80185d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801860:	8a 00                	mov    (%eax),%al
  801862:	0f b6 d0             	movzbl %al,%edx
  801865:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801868:	8a 00                	mov    (%eax),%al
  80186a:	0f b6 c0             	movzbl %al,%eax
  80186d:	29 c2                	sub    %eax,%edx
  80186f:	89 d0                	mov    %edx,%eax
  801871:	eb 18                	jmp    80188b <memcmp+0x50>
		s1++, s2++;
  801873:	ff 45 fc             	incl   -0x4(%ebp)
  801876:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801879:	8b 45 10             	mov    0x10(%ebp),%eax
  80187c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80187f:	89 55 10             	mov    %edx,0x10(%ebp)
  801882:	85 c0                	test   %eax,%eax
  801884:	75 c9                	jne    80184f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801886:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801893:	8b 55 08             	mov    0x8(%ebp),%edx
  801896:	8b 45 10             	mov    0x10(%ebp),%eax
  801899:	01 d0                	add    %edx,%eax
  80189b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80189e:	eb 15                	jmp    8018b5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	8a 00                	mov    (%eax),%al
  8018a5:	0f b6 d0             	movzbl %al,%edx
  8018a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ab:	0f b6 c0             	movzbl %al,%eax
  8018ae:	39 c2                	cmp    %eax,%edx
  8018b0:	74 0d                	je     8018bf <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018b2:	ff 45 08             	incl   0x8(%ebp)
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018bb:	72 e3                	jb     8018a0 <memfind+0x13>
  8018bd:	eb 01                	jmp    8018c0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018bf:	90                   	nop
	return (void *) s;
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018d9:	eb 03                	jmp    8018de <strtol+0x19>
		s++;
  8018db:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	3c 20                	cmp    $0x20,%al
  8018e5:	74 f4                	je     8018db <strtol+0x16>
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	8a 00                	mov    (%eax),%al
  8018ec:	3c 09                	cmp    $0x9,%al
  8018ee:	74 eb                	je     8018db <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	3c 2b                	cmp    $0x2b,%al
  8018f7:	75 05                	jne    8018fe <strtol+0x39>
		s++;
  8018f9:	ff 45 08             	incl   0x8(%ebp)
  8018fc:	eb 13                	jmp    801911 <strtol+0x4c>
	else if (*s == '-')
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	8a 00                	mov    (%eax),%al
  801903:	3c 2d                	cmp    $0x2d,%al
  801905:	75 0a                	jne    801911 <strtol+0x4c>
		s++, neg = 1;
  801907:	ff 45 08             	incl   0x8(%ebp)
  80190a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801911:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801915:	74 06                	je     80191d <strtol+0x58>
  801917:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80191b:	75 20                	jne    80193d <strtol+0x78>
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	8a 00                	mov    (%eax),%al
  801922:	3c 30                	cmp    $0x30,%al
  801924:	75 17                	jne    80193d <strtol+0x78>
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	40                   	inc    %eax
  80192a:	8a 00                	mov    (%eax),%al
  80192c:	3c 78                	cmp    $0x78,%al
  80192e:	75 0d                	jne    80193d <strtol+0x78>
		s += 2, base = 16;
  801930:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801934:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80193b:	eb 28                	jmp    801965 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80193d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801941:	75 15                	jne    801958 <strtol+0x93>
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	8a 00                	mov    (%eax),%al
  801948:	3c 30                	cmp    $0x30,%al
  80194a:	75 0c                	jne    801958 <strtol+0x93>
		s++, base = 8;
  80194c:	ff 45 08             	incl   0x8(%ebp)
  80194f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801956:	eb 0d                	jmp    801965 <strtol+0xa0>
	else if (base == 0)
  801958:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80195c:	75 07                	jne    801965 <strtol+0xa0>
		base = 10;
  80195e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	8a 00                	mov    (%eax),%al
  80196a:	3c 2f                	cmp    $0x2f,%al
  80196c:	7e 19                	jle    801987 <strtol+0xc2>
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	8a 00                	mov    (%eax),%al
  801973:	3c 39                	cmp    $0x39,%al
  801975:	7f 10                	jg     801987 <strtol+0xc2>
			dig = *s - '0';
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	8a 00                	mov    (%eax),%al
  80197c:	0f be c0             	movsbl %al,%eax
  80197f:	83 e8 30             	sub    $0x30,%eax
  801982:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801985:	eb 42                	jmp    8019c9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	8a 00                	mov    (%eax),%al
  80198c:	3c 60                	cmp    $0x60,%al
  80198e:	7e 19                	jle    8019a9 <strtol+0xe4>
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8a 00                	mov    (%eax),%al
  801995:	3c 7a                	cmp    $0x7a,%al
  801997:	7f 10                	jg     8019a9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f be c0             	movsbl %al,%eax
  8019a1:	83 e8 57             	sub    $0x57,%eax
  8019a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019a7:	eb 20                	jmp    8019c9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	8a 00                	mov    (%eax),%al
  8019ae:	3c 40                	cmp    $0x40,%al
  8019b0:	7e 39                	jle    8019eb <strtol+0x126>
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	8a 00                	mov    (%eax),%al
  8019b7:	3c 5a                	cmp    $0x5a,%al
  8019b9:	7f 30                	jg     8019eb <strtol+0x126>
			dig = *s - 'A' + 10;
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	8a 00                	mov    (%eax),%al
  8019c0:	0f be c0             	movsbl %al,%eax
  8019c3:	83 e8 37             	sub    $0x37,%eax
  8019c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019cf:	7d 19                	jge    8019ea <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019d1:	ff 45 08             	incl   0x8(%ebp)
  8019d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019d7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019db:	89 c2                	mov    %eax,%edx
  8019dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e0:	01 d0                	add    %edx,%eax
  8019e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019e5:	e9 7b ff ff ff       	jmp    801965 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019ea:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8019eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019ef:	74 08                	je     8019f9 <strtol+0x134>
		*endptr = (char *) s;
  8019f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8019f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019fd:	74 07                	je     801a06 <strtol+0x141>
  8019ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a02:	f7 d8                	neg    %eax
  801a04:	eb 03                	jmp    801a09 <strtol+0x144>
  801a06:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <ltostr>:

void
ltostr(long value, char *str)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a18:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a23:	79 13                	jns    801a38 <ltostr+0x2d>
	{
		neg = 1;
  801a25:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a32:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a35:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a40:	99                   	cltd   
  801a41:	f7 f9                	idiv   %ecx
  801a43:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a49:	8d 50 01             	lea    0x1(%eax),%edx
  801a4c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a4f:	89 c2                	mov    %eax,%edx
  801a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a54:	01 d0                	add    %edx,%eax
  801a56:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a59:	83 c2 30             	add    $0x30,%edx
  801a5c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a61:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a66:	f7 e9                	imul   %ecx
  801a68:	c1 fa 02             	sar    $0x2,%edx
  801a6b:	89 c8                	mov    %ecx,%eax
  801a6d:	c1 f8 1f             	sar    $0x1f,%eax
  801a70:	29 c2                	sub    %eax,%edx
  801a72:	89 d0                	mov    %edx,%eax
  801a74:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801a77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a7b:	75 bb                	jne    801a38 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a87:	48                   	dec    %eax
  801a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a8f:	74 3d                	je     801ace <ltostr+0xc3>
		start = 1 ;
  801a91:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a98:	eb 34                	jmp    801ace <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa0:	01 d0                	add    %edx,%eax
  801aa2:	8a 00                	mov    (%eax),%al
  801aa4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801aa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aad:	01 c2                	add    %eax,%edx
  801aaf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab5:	01 c8                	add    %ecx,%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801abb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801abe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac1:	01 c2                	add    %eax,%edx
  801ac3:	8a 45 eb             	mov    -0x15(%ebp),%al
  801ac6:	88 02                	mov    %al,(%edx)
		start++ ;
  801ac8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801acb:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ad4:	7c c4                	jl     801a9a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801ad6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adc:	01 d0                	add    %edx,%eax
  801ade:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801ae1:	90                   	nop
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801aea:	ff 75 08             	pushl  0x8(%ebp)
  801aed:	e8 c4 f9 ff ff       	call   8014b6 <strlen>
  801af2:	83 c4 04             	add    $0x4,%esp
  801af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801af8:	ff 75 0c             	pushl  0xc(%ebp)
  801afb:	e8 b6 f9 ff ff       	call   8014b6 <strlen>
  801b00:	83 c4 04             	add    $0x4,%esp
  801b03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b14:	eb 17                	jmp    801b2d <strcconcat+0x49>
		final[s] = str1[s] ;
  801b16:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b19:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1c:	01 c2                	add    %eax,%edx
  801b1e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	01 c8                	add    %ecx,%eax
  801b26:	8a 00                	mov    (%eax),%al
  801b28:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b2a:	ff 45 fc             	incl   -0x4(%ebp)
  801b2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b30:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b33:	7c e1                	jl     801b16 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b35:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b3c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b43:	eb 1f                	jmp    801b64 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b48:	8d 50 01             	lea    0x1(%eax),%edx
  801b4b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b4e:	89 c2                	mov    %eax,%edx
  801b50:	8b 45 10             	mov    0x10(%ebp),%eax
  801b53:	01 c2                	add    %eax,%edx
  801b55:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	01 c8                	add    %ecx,%eax
  801b5d:	8a 00                	mov    (%eax),%al
  801b5f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b61:	ff 45 f8             	incl   -0x8(%ebp)
  801b64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b67:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b6a:	7c d9                	jl     801b45 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b72:	01 d0                	add    %edx,%eax
  801b74:	c6 00 00             	movb   $0x0,(%eax)
}
  801b77:	90                   	nop
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b86:	8b 45 14             	mov    0x14(%ebp),%eax
  801b89:	8b 00                	mov    (%eax),%eax
  801b8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b92:	8b 45 10             	mov    0x10(%ebp),%eax
  801b95:	01 d0                	add    %edx,%eax
  801b97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b9d:	eb 0c                	jmp    801bab <strsplit+0x31>
			*string++ = 0;
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	8d 50 01             	lea    0x1(%eax),%edx
  801ba5:	89 55 08             	mov    %edx,0x8(%ebp)
  801ba8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	8a 00                	mov    (%eax),%al
  801bb0:	84 c0                	test   %al,%al
  801bb2:	74 18                	je     801bcc <strsplit+0x52>
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	8a 00                	mov    (%eax),%al
  801bb9:	0f be c0             	movsbl %al,%eax
  801bbc:	50                   	push   %eax
  801bbd:	ff 75 0c             	pushl  0xc(%ebp)
  801bc0:	e8 83 fa ff ff       	call   801648 <strchr>
  801bc5:	83 c4 08             	add    $0x8,%esp
  801bc8:	85 c0                	test   %eax,%eax
  801bca:	75 d3                	jne    801b9f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	8a 00                	mov    (%eax),%al
  801bd1:	84 c0                	test   %al,%al
  801bd3:	74 5a                	je     801c2f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801bd5:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd8:	8b 00                	mov    (%eax),%eax
  801bda:	83 f8 0f             	cmp    $0xf,%eax
  801bdd:	75 07                	jne    801be6 <strsplit+0x6c>
		{
			return 0;
  801bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801be4:	eb 66                	jmp    801c4c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801be6:	8b 45 14             	mov    0x14(%ebp),%eax
  801be9:	8b 00                	mov    (%eax),%eax
  801beb:	8d 48 01             	lea    0x1(%eax),%ecx
  801bee:	8b 55 14             	mov    0x14(%ebp),%edx
  801bf1:	89 0a                	mov    %ecx,(%edx)
  801bf3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bfa:	8b 45 10             	mov    0x10(%ebp),%eax
  801bfd:	01 c2                	add    %eax,%edx
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c04:	eb 03                	jmp    801c09 <strsplit+0x8f>
			string++;
  801c06:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	8a 00                	mov    (%eax),%al
  801c0e:	84 c0                	test   %al,%al
  801c10:	74 8b                	je     801b9d <strsplit+0x23>
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	8a 00                	mov    (%eax),%al
  801c17:	0f be c0             	movsbl %al,%eax
  801c1a:	50                   	push   %eax
  801c1b:	ff 75 0c             	pushl  0xc(%ebp)
  801c1e:	e8 25 fa ff ff       	call   801648 <strchr>
  801c23:	83 c4 08             	add    $0x8,%esp
  801c26:	85 c0                	test   %eax,%eax
  801c28:	74 dc                	je     801c06 <strsplit+0x8c>
			string++;
	}
  801c2a:	e9 6e ff ff ff       	jmp    801b9d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c2f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c30:	8b 45 14             	mov    0x14(%ebp),%eax
  801c33:	8b 00                	mov    (%eax),%eax
  801c35:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3f:	01 d0                	add    %edx,%eax
  801c41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c47:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801c5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c61:	eb 4a                	jmp    801cad <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801c63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	01 c2                	add    %eax,%edx
  801c6b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c71:	01 c8                	add    %ecx,%eax
  801c73:	8a 00                	mov    (%eax),%al
  801c75:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801c77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7d:	01 d0                	add    %edx,%eax
  801c7f:	8a 00                	mov    (%eax),%al
  801c81:	3c 40                	cmp    $0x40,%al
  801c83:	7e 25                	jle    801caa <str2lower+0x5c>
  801c85:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8b:	01 d0                	add    %edx,%eax
  801c8d:	8a 00                	mov    (%eax),%al
  801c8f:	3c 5a                	cmp    $0x5a,%al
  801c91:	7f 17                	jg     801caa <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801c93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	01 d0                	add    %edx,%eax
  801c9b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c9e:	8b 55 08             	mov    0x8(%ebp),%edx
  801ca1:	01 ca                	add    %ecx,%edx
  801ca3:	8a 12                	mov    (%edx),%dl
  801ca5:	83 c2 20             	add    $0x20,%edx
  801ca8:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801caa:	ff 45 fc             	incl   -0x4(%ebp)
  801cad:	ff 75 0c             	pushl  0xc(%ebp)
  801cb0:	e8 01 f8 ff ff       	call   8014b6 <strlen>
  801cb5:	83 c4 04             	add    $0x4,%esp
  801cb8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801cbb:	7f a6                	jg     801c63 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801cbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801cc8:	83 ec 0c             	sub    $0xc,%esp
  801ccb:	6a 10                	push   $0x10
  801ccd:	e8 b2 15 00 00       	call   803284 <alloc_block>
  801cd2:	83 c4 10             	add    $0x10,%esp
  801cd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801cd8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cdc:	75 14                	jne    801cf2 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801cde:	83 ec 04             	sub    $0x4,%esp
  801ce1:	68 3c 47 80 00       	push   $0x80473c
  801ce6:	6a 14                	push   $0x14
  801ce8:	68 65 47 80 00       	push   $0x804765
  801ced:	e8 f5 eb ff ff       	call   8008e7 <_panic>

	node->start = start;
  801cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf5:	8b 55 08             	mov    0x8(%ebp),%edx
  801cf8:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801cfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d00:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801d03:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801d0a:	a1 28 50 80 00       	mov    0x805028,%eax
  801d0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d12:	eb 18                	jmp    801d2c <insert_page_alloc+0x6a>
		if (start < it->start)
  801d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d17:	8b 00                	mov    (%eax),%eax
  801d19:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d1c:	77 37                	ja     801d55 <insert_page_alloc+0x93>
			break;
		prev = it;
  801d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d21:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801d24:	a1 30 50 80 00       	mov    0x805030,%eax
  801d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d30:	74 08                	je     801d3a <insert_page_alloc+0x78>
  801d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d35:	8b 40 08             	mov    0x8(%eax),%eax
  801d38:	eb 05                	jmp    801d3f <insert_page_alloc+0x7d>
  801d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3f:	a3 30 50 80 00       	mov    %eax,0x805030
  801d44:	a1 30 50 80 00       	mov    0x805030,%eax
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	75 c7                	jne    801d14 <insert_page_alloc+0x52>
  801d4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d51:	75 c1                	jne    801d14 <insert_page_alloc+0x52>
  801d53:	eb 01                	jmp    801d56 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801d55:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801d56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d5a:	75 64                	jne    801dc0 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801d5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d60:	75 14                	jne    801d76 <insert_page_alloc+0xb4>
  801d62:	83 ec 04             	sub    $0x4,%esp
  801d65:	68 74 47 80 00       	push   $0x804774
  801d6a:	6a 21                	push   $0x21
  801d6c:	68 65 47 80 00       	push   $0x804765
  801d71:	e8 71 eb ff ff       	call   8008e7 <_panic>
  801d76:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801d7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7f:	89 50 08             	mov    %edx,0x8(%eax)
  801d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d85:	8b 40 08             	mov    0x8(%eax),%eax
  801d88:	85 c0                	test   %eax,%eax
  801d8a:	74 0d                	je     801d99 <insert_page_alloc+0xd7>
  801d8c:	a1 28 50 80 00       	mov    0x805028,%eax
  801d91:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d94:	89 50 0c             	mov    %edx,0xc(%eax)
  801d97:	eb 08                	jmp    801da1 <insert_page_alloc+0xdf>
  801d99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da4:	a3 28 50 80 00       	mov    %eax,0x805028
  801da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dac:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801db3:	a1 34 50 80 00       	mov    0x805034,%eax
  801db8:	40                   	inc    %eax
  801db9:	a3 34 50 80 00       	mov    %eax,0x805034
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801dbe:	eb 71                	jmp    801e31 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801dc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dc4:	74 06                	je     801dcc <insert_page_alloc+0x10a>
  801dc6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801dca:	75 14                	jne    801de0 <insert_page_alloc+0x11e>
  801dcc:	83 ec 04             	sub    $0x4,%esp
  801dcf:	68 98 47 80 00       	push   $0x804798
  801dd4:	6a 23                	push   $0x23
  801dd6:	68 65 47 80 00       	push   $0x804765
  801ddb:	e8 07 eb ff ff       	call   8008e7 <_panic>
  801de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de3:	8b 50 08             	mov    0x8(%eax),%edx
  801de6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de9:	89 50 08             	mov    %edx,0x8(%eax)
  801dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801def:	8b 40 08             	mov    0x8(%eax),%eax
  801df2:	85 c0                	test   %eax,%eax
  801df4:	74 0c                	je     801e02 <insert_page_alloc+0x140>
  801df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df9:	8b 40 08             	mov    0x8(%eax),%eax
  801dfc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dff:	89 50 0c             	mov    %edx,0xc(%eax)
  801e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e08:	89 50 08             	mov    %edx,0x8(%eax)
  801e0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e11:	89 50 0c             	mov    %edx,0xc(%eax)
  801e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e17:	8b 40 08             	mov    0x8(%eax),%eax
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	75 08                	jne    801e26 <insert_page_alloc+0x164>
  801e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e21:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801e26:	a1 34 50 80 00       	mov    0x805034,%eax
  801e2b:	40                   	inc    %eax
  801e2c:	a3 34 50 80 00       	mov    %eax,0x805034
}
  801e31:	90                   	nop
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801e3a:	a1 28 50 80 00       	mov    0x805028,%eax
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	75 0c                	jne    801e4f <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801e43:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e48:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801e4d:	eb 67                	jmp    801eb6 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801e4f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801e57:	a1 28 50 80 00       	mov    0x805028,%eax
  801e5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801e5f:	eb 26                	jmp    801e87 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801e61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e64:	8b 10                	mov    (%eax),%edx
  801e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e69:	8b 40 04             	mov    0x4(%eax),%eax
  801e6c:	01 d0                	add    %edx,%eax
  801e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e74:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801e77:	76 06                	jbe    801e7f <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801e7f:	a1 30 50 80 00       	mov    0x805030,%eax
  801e84:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801e87:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801e8b:	74 08                	je     801e95 <recompute_page_alloc_break+0x61>
  801e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e90:	8b 40 08             	mov    0x8(%eax),%eax
  801e93:	eb 05                	jmp    801e9a <recompute_page_alloc_break+0x66>
  801e95:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9a:	a3 30 50 80 00       	mov    %eax,0x805030
  801e9f:	a1 30 50 80 00       	mov    0x805030,%eax
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	75 b9                	jne    801e61 <recompute_page_alloc_break+0x2d>
  801ea8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801eac:	75 b3                	jne    801e61 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eb1:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801ebe:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  801ec8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ecb:	01 d0                	add    %edx,%eax
  801ecd:	48                   	dec    %eax
  801ece:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801ed1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ed4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed9:	f7 75 d8             	divl   -0x28(%ebp)
  801edc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801edf:	29 d0                	sub    %edx,%eax
  801ee1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801ee4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801ee8:	75 0a                	jne    801ef4 <alloc_pages_custom_fit+0x3c>
		return NULL;
  801eea:	b8 00 00 00 00       	mov    $0x0,%eax
  801eef:	e9 7e 01 00 00       	jmp    802072 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801ef4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801efb:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801eff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801f06:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801f0d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801f15:	a1 28 50 80 00       	mov    0x805028,%eax
  801f1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801f1d:	eb 69                	jmp    801f88 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801f1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f22:	8b 00                	mov    (%eax),%eax
  801f24:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f27:	76 47                	jbe    801f70 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801f29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f2c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801f2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f32:	8b 00                	mov    (%eax),%eax
  801f34:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801f37:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801f3a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f3d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801f40:	72 2e                	jb     801f70 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801f42:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801f46:	75 14                	jne    801f5c <alloc_pages_custom_fit+0xa4>
  801f48:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f4b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801f4e:	75 0c                	jne    801f5c <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801f50:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f53:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801f56:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801f5a:	eb 14                	jmp    801f70 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801f5c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f5f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f62:	76 0c                	jbe    801f70 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801f64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f67:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801f6a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801f70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f73:	8b 10                	mov    (%eax),%edx
  801f75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f78:	8b 40 04             	mov    0x4(%eax),%eax
  801f7b:	01 d0                	add    %edx,%eax
  801f7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801f80:	a1 30 50 80 00       	mov    0x805030,%eax
  801f85:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801f88:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f8c:	74 08                	je     801f96 <alloc_pages_custom_fit+0xde>
  801f8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f91:	8b 40 08             	mov    0x8(%eax),%eax
  801f94:	eb 05                	jmp    801f9b <alloc_pages_custom_fit+0xe3>
  801f96:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9b:	a3 30 50 80 00       	mov    %eax,0x805030
  801fa0:	a1 30 50 80 00       	mov    0x805030,%eax
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	0f 85 72 ff ff ff    	jne    801f1f <alloc_pages_custom_fit+0x67>
  801fad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fb1:	0f 85 68 ff ff ff    	jne    801f1f <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801fb7:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fbc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801fbf:	76 47                	jbe    802008 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801fc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fc4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801fc7:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fcc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801fcf:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801fd2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801fd5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801fd8:	72 2e                	jb     802008 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801fda:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801fde:	75 14                	jne    801ff4 <alloc_pages_custom_fit+0x13c>
  801fe0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801fe3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801fe6:	75 0c                	jne    801ff4 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801fe8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801feb:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801fee:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801ff2:	eb 14                	jmp    802008 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801ff4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ff7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ffa:	76 0c                	jbe    802008 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801ffc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801fff:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  802002:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802005:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  802008:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  80200f:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802013:	74 08                	je     80201d <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  802015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802018:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80201b:	eb 40                	jmp    80205d <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  80201d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802021:	74 08                	je     80202b <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  802023:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802026:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802029:	eb 32                	jmp    80205d <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  80202b:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802030:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802033:	89 c2                	mov    %eax,%edx
  802035:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80203a:	39 c2                	cmp    %eax,%edx
  80203c:	73 07                	jae    802045 <alloc_pages_custom_fit+0x18d>
			return NULL;
  80203e:	b8 00 00 00 00       	mov    $0x0,%eax
  802043:	eb 2d                	jmp    802072 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  802045:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80204a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  80204d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802053:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802056:	01 d0                	add    %edx,%eax
  802058:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  80205d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802060:	83 ec 08             	sub    $0x8,%esp
  802063:	ff 75 d0             	pushl  -0x30(%ebp)
  802066:	50                   	push   %eax
  802067:	e8 56 fc ff ff       	call   801cc2 <insert_page_alloc>
  80206c:	83 c4 10             	add    $0x10,%esp

	return result;
  80206f:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  80207a:	8b 45 08             	mov    0x8(%ebp),%eax
  80207d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802080:	a1 28 50 80 00       	mov    0x805028,%eax
  802085:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802088:	eb 1a                	jmp    8020a4 <find_allocated_size+0x30>
		if (it->start == va)
  80208a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80208d:	8b 00                	mov    (%eax),%eax
  80208f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802092:	75 08                	jne    80209c <find_allocated_size+0x28>
			return it->size;
  802094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802097:	8b 40 04             	mov    0x4(%eax),%eax
  80209a:	eb 34                	jmp    8020d0 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80209c:	a1 30 50 80 00       	mov    0x805030,%eax
  8020a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020a8:	74 08                	je     8020b2 <find_allocated_size+0x3e>
  8020aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ad:	8b 40 08             	mov    0x8(%eax),%eax
  8020b0:	eb 05                	jmp    8020b7 <find_allocated_size+0x43>
  8020b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8020bc:	a1 30 50 80 00       	mov    0x805030,%eax
  8020c1:	85 c0                	test   %eax,%eax
  8020c3:	75 c5                	jne    80208a <find_allocated_size+0x16>
  8020c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020c9:	75 bf                	jne    80208a <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  8020cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8020de:	a1 28 50 80 00       	mov    0x805028,%eax
  8020e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e6:	e9 e1 01 00 00       	jmp    8022cc <free_pages+0x1fa>
		if (it->start == va) {
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	8b 00                	mov    (%eax),%eax
  8020f0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020f3:	0f 85 cb 01 00 00    	jne    8022c4 <free_pages+0x1f2>

			uint32 start = it->start;
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	8b 00                	mov    (%eax),%eax
  8020fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  802101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802104:	8b 40 04             	mov    0x4(%eax),%eax
  802107:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  80210a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80210d:	f7 d0                	not    %eax
  80210f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802112:	73 1d                	jae    802131 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  802114:	83 ec 0c             	sub    $0xc,%esp
  802117:	ff 75 e4             	pushl  -0x1c(%ebp)
  80211a:	ff 75 e8             	pushl  -0x18(%ebp)
  80211d:	68 cc 47 80 00       	push   $0x8047cc
  802122:	68 a5 00 00 00       	push   $0xa5
  802127:	68 65 47 80 00       	push   $0x804765
  80212c:	e8 b6 e7 ff ff       	call   8008e7 <_panic>
			}

			uint32 start_end = start + size;
  802131:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802134:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802137:	01 d0                	add    %edx,%eax
  802139:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  80213c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80213f:	85 c0                	test   %eax,%eax
  802141:	79 19                	jns    80215c <free_pages+0x8a>
  802143:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80214a:	77 10                	ja     80215c <free_pages+0x8a>
  80214c:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  802153:	77 07                	ja     80215c <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  802155:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802158:	85 c0                	test   %eax,%eax
  80215a:	78 2c                	js     802188 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  80215c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80215f:	83 ec 0c             	sub    $0xc,%esp
  802162:	68 00 00 00 a0       	push   $0xa0000000
  802167:	ff 75 e0             	pushl  -0x20(%ebp)
  80216a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80216d:	ff 75 e8             	pushl  -0x18(%ebp)
  802170:	ff 75 e4             	pushl  -0x1c(%ebp)
  802173:	50                   	push   %eax
  802174:	68 10 48 80 00       	push   $0x804810
  802179:	68 ad 00 00 00       	push   $0xad
  80217e:	68 65 47 80 00       	push   $0x804765
  802183:	e8 5f e7 ff ff       	call   8008e7 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802188:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80218b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80218e:	e9 88 00 00 00       	jmp    80221b <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  802193:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  80219a:	76 17                	jbe    8021b3 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  80219c:	ff 75 f0             	pushl  -0x10(%ebp)
  80219f:	68 74 48 80 00       	push   $0x804874
  8021a4:	68 b4 00 00 00       	push   $0xb4
  8021a9:	68 65 47 80 00       	push   $0x804765
  8021ae:	e8 34 e7 ff ff       	call   8008e7 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  8021b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b6:	05 00 10 00 00       	add    $0x1000,%eax
  8021bb:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  8021be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c1:	85 c0                	test   %eax,%eax
  8021c3:	79 2e                	jns    8021f3 <free_pages+0x121>
  8021c5:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8021cc:	77 25                	ja     8021f3 <free_pages+0x121>
  8021ce:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8021d5:	77 1c                	ja     8021f3 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  8021d7:	83 ec 08             	sub    $0x8,%esp
  8021da:	68 00 10 00 00       	push   $0x1000
  8021df:	ff 75 f0             	pushl  -0x10(%ebp)
  8021e2:	e8 38 0d 00 00       	call   802f1f <sys_free_user_mem>
  8021e7:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8021ea:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8021f1:	eb 28                	jmp    80221b <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  8021f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f6:	68 00 00 00 a0       	push   $0xa0000000
  8021fb:	ff 75 dc             	pushl  -0x24(%ebp)
  8021fe:	68 00 10 00 00       	push   $0x1000
  802203:	ff 75 f0             	pushl  -0x10(%ebp)
  802206:	50                   	push   %eax
  802207:	68 b4 48 80 00       	push   $0x8048b4
  80220c:	68 bd 00 00 00       	push   $0xbd
  802211:	68 65 47 80 00       	push   $0x804765
  802216:	e8 cc e6 ff ff       	call   8008e7 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  80221b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802221:	0f 82 6c ff ff ff    	jb     802193 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802227:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222b:	75 17                	jne    802244 <free_pages+0x172>
  80222d:	83 ec 04             	sub    $0x4,%esp
  802230:	68 16 49 80 00       	push   $0x804916
  802235:	68 c1 00 00 00       	push   $0xc1
  80223a:	68 65 47 80 00       	push   $0x804765
  80223f:	e8 a3 e6 ff ff       	call   8008e7 <_panic>
  802244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802247:	8b 40 08             	mov    0x8(%eax),%eax
  80224a:	85 c0                	test   %eax,%eax
  80224c:	74 11                	je     80225f <free_pages+0x18d>
  80224e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802251:	8b 40 08             	mov    0x8(%eax),%eax
  802254:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802257:	8b 52 0c             	mov    0xc(%edx),%edx
  80225a:	89 50 0c             	mov    %edx,0xc(%eax)
  80225d:	eb 0b                	jmp    80226a <free_pages+0x198>
  80225f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802262:	8b 40 0c             	mov    0xc(%eax),%eax
  802265:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226d:	8b 40 0c             	mov    0xc(%eax),%eax
  802270:	85 c0                	test   %eax,%eax
  802272:	74 11                	je     802285 <free_pages+0x1b3>
  802274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802277:	8b 40 0c             	mov    0xc(%eax),%eax
  80227a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227d:	8b 52 08             	mov    0x8(%edx),%edx
  802280:	89 50 08             	mov    %edx,0x8(%eax)
  802283:	eb 0b                	jmp    802290 <free_pages+0x1be>
  802285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802288:	8b 40 08             	mov    0x8(%eax),%eax
  80228b:	a3 28 50 80 00       	mov    %eax,0x805028
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8022a4:	a1 34 50 80 00       	mov    0x805034,%eax
  8022a9:	48                   	dec    %eax
  8022aa:	a3 34 50 80 00       	mov    %eax,0x805034
			free_block(it);
  8022af:	83 ec 0c             	sub    $0xc,%esp
  8022b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8022b5:	e8 24 15 00 00       	call   8037de <free_block>
  8022ba:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  8022bd:	e8 72 fb ff ff       	call   801e34 <recompute_page_alloc_break>

			return;
  8022c2:	eb 37                	jmp    8022fb <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8022c4:	a1 30 50 80 00       	mov    0x805030,%eax
  8022c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d0:	74 08                	je     8022da <free_pages+0x208>
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 40 08             	mov    0x8(%eax),%eax
  8022d8:	eb 05                	jmp    8022df <free_pages+0x20d>
  8022da:	b8 00 00 00 00       	mov    $0x0,%eax
  8022df:	a3 30 50 80 00       	mov    %eax,0x805030
  8022e4:	a1 30 50 80 00       	mov    0x805030,%eax
  8022e9:	85 c0                	test   %eax,%eax
  8022eb:	0f 85 fa fd ff ff    	jne    8020eb <free_pages+0x19>
  8022f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f5:	0f 85 f0 fd ff ff    	jne    8020eb <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  802300:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802305:	5d                   	pop    %ebp
  802306:	c3                   	ret    

00802307 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80230d:	a1 08 50 80 00       	mov    0x805008,%eax
  802312:	85 c0                	test   %eax,%eax
  802314:	74 60                	je     802376 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802316:	83 ec 08             	sub    $0x8,%esp
  802319:	68 00 00 00 82       	push   $0x82000000
  80231e:	68 00 00 00 80       	push   $0x80000000
  802323:	e8 0d 0d 00 00       	call   803035 <initialize_dynamic_allocator>
  802328:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80232b:	e8 f3 0a 00 00       	call   802e23 <sys_get_uheap_strategy>
  802330:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802335:	a1 40 50 80 00       	mov    0x805040,%eax
  80233a:	05 00 10 00 00       	add    $0x1000,%eax
  80233f:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  802344:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802349:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  80234e:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  802355:	00 00 00 
  802358:	c7 05 2c 50 80 00 00 	movl   $0x0,0x80502c
  80235f:	00 00 00 
  802362:	c7 05 34 50 80 00 00 	movl   $0x0,0x805034
  802369:	00 00 00 

		__firstTimeFlag = 0;
  80236c:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  802373:	00 00 00 
	}
}
  802376:	90                   	nop
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80238d:	83 ec 08             	sub    $0x8,%esp
  802390:	68 06 04 00 00       	push   $0x406
  802395:	50                   	push   %eax
  802396:	e8 d2 06 00 00       	call   802a6d <__sys_allocate_page>
  80239b:	83 c4 10             	add    $0x10,%esp
  80239e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8023a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023a5:	79 17                	jns    8023be <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  8023a7:	83 ec 04             	sub    $0x4,%esp
  8023aa:	68 34 49 80 00       	push   $0x804934
  8023af:	68 ea 00 00 00       	push   $0xea
  8023b4:	68 65 47 80 00       	push   $0x804765
  8023b9:	e8 29 e5 ff ff       	call   8008e7 <_panic>
	return 0;
  8023be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
  8023c8:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8023d9:	83 ec 0c             	sub    $0xc,%esp
  8023dc:	50                   	push   %eax
  8023dd:	e8 d2 06 00 00       	call   802ab4 <__sys_unmap_frame>
  8023e2:	83 c4 10             	add    $0x10,%esp
  8023e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8023e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023ec:	79 17                	jns    802405 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  8023ee:	83 ec 04             	sub    $0x4,%esp
  8023f1:	68 70 49 80 00       	push   $0x804970
  8023f6:	68 f5 00 00 00       	push   $0xf5
  8023fb:	68 65 47 80 00       	push   $0x804765
  802400:	e8 e2 e4 ff ff       	call   8008e7 <_panic>
}
  802405:	90                   	nop
  802406:	c9                   	leave  
  802407:	c3                   	ret    

00802408 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802408:	55                   	push   %ebp
  802409:	89 e5                	mov    %esp,%ebp
  80240b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80240e:	e8 f4 fe ff ff       	call   802307 <uheap_init>
	if (size == 0) return NULL ;
  802413:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802417:	75 0a                	jne    802423 <malloc+0x1b>
  802419:	b8 00 00 00 00       	mov    $0x0,%eax
  80241e:	e9 67 01 00 00       	jmp    80258a <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  802423:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80242a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802431:	77 16                	ja     802449 <malloc+0x41>
		result = alloc_block(size);
  802433:	83 ec 0c             	sub    $0xc,%esp
  802436:	ff 75 08             	pushl  0x8(%ebp)
  802439:	e8 46 0e 00 00       	call   803284 <alloc_block>
  80243e:	83 c4 10             	add    $0x10,%esp
  802441:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802444:	e9 3e 01 00 00       	jmp    802587 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802449:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802450:	8b 55 08             	mov    0x8(%ebp),%edx
  802453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802456:	01 d0                	add    %edx,%eax
  802458:	48                   	dec    %eax
  802459:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80245c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245f:	ba 00 00 00 00       	mov    $0x0,%edx
  802464:	f7 75 f0             	divl   -0x10(%ebp)
  802467:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80246a:	29 d0                	sub    %edx,%eax
  80246c:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  80246f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802474:	85 c0                	test   %eax,%eax
  802476:	75 0a                	jne    802482 <malloc+0x7a>
			return NULL;
  802478:	b8 00 00 00 00       	mov    $0x0,%eax
  80247d:	e9 08 01 00 00       	jmp    80258a <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  802482:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802487:	85 c0                	test   %eax,%eax
  802489:	74 0f                	je     80249a <malloc+0x92>
  80248b:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802491:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802496:	39 c2                	cmp    %eax,%edx
  802498:	73 0a                	jae    8024a4 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  80249a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80249f:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8024a4:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8024a9:	83 f8 05             	cmp    $0x5,%eax
  8024ac:	75 11                	jne    8024bf <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  8024ae:	83 ec 0c             	sub    $0xc,%esp
  8024b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8024b4:	e8 ff f9 ff ff       	call   801eb8 <alloc_pages_custom_fit>
  8024b9:	83 c4 10             	add    $0x10,%esp
  8024bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  8024bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c3:	0f 84 be 00 00 00    	je     802587 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  8024cf:	83 ec 0c             	sub    $0xc,%esp
  8024d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8024d5:	e8 9a fb ff ff       	call   802074 <find_allocated_size>
  8024da:	83 c4 10             	add    $0x10,%esp
  8024dd:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  8024e0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8024e4:	75 17                	jne    8024fd <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  8024e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8024e9:	68 b0 49 80 00       	push   $0x8049b0
  8024ee:	68 24 01 00 00       	push   $0x124
  8024f3:	68 65 47 80 00       	push   $0x804765
  8024f8:	e8 ea e3 ff ff       	call   8008e7 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  8024fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802500:	f7 d0                	not    %eax
  802502:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802505:	73 1d                	jae    802524 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  802507:	83 ec 0c             	sub    $0xc,%esp
  80250a:	ff 75 e0             	pushl  -0x20(%ebp)
  80250d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802510:	68 f8 49 80 00       	push   $0x8049f8
  802515:	68 29 01 00 00       	push   $0x129
  80251a:	68 65 47 80 00       	push   $0x804765
  80251f:	e8 c3 e3 ff ff       	call   8008e7 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  802524:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802527:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80252a:	01 d0                	add    %edx,%eax
  80252c:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  80252f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802532:	85 c0                	test   %eax,%eax
  802534:	79 2c                	jns    802562 <malloc+0x15a>
  802536:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  80253d:	77 23                	ja     802562 <malloc+0x15a>
  80253f:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802546:	77 1a                	ja     802562 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  802548:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80254b:	85 c0                	test   %eax,%eax
  80254d:	79 13                	jns    802562 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  80254f:	83 ec 08             	sub    $0x8,%esp
  802552:	ff 75 e0             	pushl  -0x20(%ebp)
  802555:	ff 75 e4             	pushl  -0x1c(%ebp)
  802558:	e8 de 09 00 00       	call   802f3b <sys_allocate_user_mem>
  80255d:	83 c4 10             	add    $0x10,%esp
  802560:	eb 25                	jmp    802587 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  802562:	68 00 00 00 a0       	push   $0xa0000000
  802567:	ff 75 dc             	pushl  -0x24(%ebp)
  80256a:	ff 75 e0             	pushl  -0x20(%ebp)
  80256d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802570:	ff 75 f4             	pushl  -0xc(%ebp)
  802573:	68 34 4a 80 00       	push   $0x804a34
  802578:	68 33 01 00 00       	push   $0x133
  80257d:	68 65 47 80 00       	push   $0x804765
  802582:	e8 60 e3 ff ff       	call   8008e7 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  80258a:	c9                   	leave  
  80258b:	c3                   	ret    

0080258c <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
  80258f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802592:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802596:	0f 84 26 01 00 00    	je     8026c2 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  80259c:	8b 45 08             	mov    0x8(%ebp),%eax
  80259f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	79 1c                	jns    8025c5 <free+0x39>
  8025a9:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  8025b0:	77 13                	ja     8025c5 <free+0x39>
		free_block(virtual_address);
  8025b2:	83 ec 0c             	sub    $0xc,%esp
  8025b5:	ff 75 08             	pushl  0x8(%ebp)
  8025b8:	e8 21 12 00 00       	call   8037de <free_block>
  8025bd:	83 c4 10             	add    $0x10,%esp
		return;
  8025c0:	e9 01 01 00 00       	jmp    8026c6 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  8025c5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025ca:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8025cd:	0f 82 d8 00 00 00    	jb     8026ab <free+0x11f>
  8025d3:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  8025da:	0f 87 cb 00 00 00    	ja     8026ab <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	25 ff 0f 00 00       	and    $0xfff,%eax
  8025e8:	85 c0                	test   %eax,%eax
  8025ea:	74 17                	je     802603 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  8025ec:	ff 75 08             	pushl  0x8(%ebp)
  8025ef:	68 a4 4a 80 00       	push   $0x804aa4
  8025f4:	68 57 01 00 00       	push   $0x157
  8025f9:	68 65 47 80 00       	push   $0x804765
  8025fe:	e8 e4 e2 ff ff       	call   8008e7 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  802603:	83 ec 0c             	sub    $0xc,%esp
  802606:	ff 75 08             	pushl  0x8(%ebp)
  802609:	e8 66 fa ff ff       	call   802074 <find_allocated_size>
  80260e:	83 c4 10             	add    $0x10,%esp
  802611:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  802614:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802618:	0f 84 a7 00 00 00    	je     8026c5 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  80261e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802621:	f7 d0                	not    %eax
  802623:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802626:	73 1d                	jae    802645 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  802628:	83 ec 0c             	sub    $0xc,%esp
  80262b:	ff 75 f0             	pushl  -0x10(%ebp)
  80262e:	ff 75 f4             	pushl  -0xc(%ebp)
  802631:	68 cc 4a 80 00       	push   $0x804acc
  802636:	68 61 01 00 00       	push   $0x161
  80263b:	68 65 47 80 00       	push   $0x804765
  802640:	e8 a2 e2 ff ff       	call   8008e7 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  802645:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264b:	01 d0                	add    %edx,%eax
  80264d:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	85 c0                	test   %eax,%eax
  802655:	79 19                	jns    802670 <free+0xe4>
  802657:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  80265e:	77 10                	ja     802670 <free+0xe4>
  802660:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  802667:	77 07                	ja     802670 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  802669:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	78 2b                	js     80269b <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  802670:	83 ec 0c             	sub    $0xc,%esp
  802673:	68 00 00 00 a0       	push   $0xa0000000
  802678:	ff 75 ec             	pushl  -0x14(%ebp)
  80267b:	ff 75 f0             	pushl  -0x10(%ebp)
  80267e:	ff 75 f4             	pushl  -0xc(%ebp)
  802681:	ff 75 f0             	pushl  -0x10(%ebp)
  802684:	ff 75 08             	pushl  0x8(%ebp)
  802687:	68 08 4b 80 00       	push   $0x804b08
  80268c:	68 69 01 00 00       	push   $0x169
  802691:	68 65 47 80 00       	push   $0x804765
  802696:	e8 4c e2 ff ff       	call   8008e7 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  80269b:	83 ec 0c             	sub    $0xc,%esp
  80269e:	ff 75 08             	pushl  0x8(%ebp)
  8026a1:	e8 2c fa ff ff       	call   8020d2 <free_pages>
  8026a6:	83 c4 10             	add    $0x10,%esp
		return;
  8026a9:	eb 1b                	jmp    8026c6 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  8026ab:	ff 75 08             	pushl  0x8(%ebp)
  8026ae:	68 64 4b 80 00       	push   $0x804b64
  8026b3:	68 70 01 00 00       	push   $0x170
  8026b8:	68 65 47 80 00       	push   $0x804765
  8026bd:	e8 25 e2 ff ff       	call   8008e7 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8026c2:	90                   	nop
  8026c3:	eb 01                	jmp    8026c6 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  8026c5:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  8026c6:	c9                   	leave  
  8026c7:	c3                   	ret    

008026c8 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
  8026cb:	83 ec 38             	sub    $0x38,%esp
  8026ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8026d1:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8026d4:	e8 2e fc ff ff       	call   802307 <uheap_init>
	if (size == 0) return NULL ;
  8026d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026dd:	75 0a                	jne    8026e9 <smalloc+0x21>
  8026df:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e4:	e9 3d 01 00 00       	jmp    802826 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  8026e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  8026ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f2:	25 ff 0f 00 00       	and    $0xfff,%eax
  8026f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  8026fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026fe:	74 0e                	je     80270e <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802706:	05 00 10 00 00       	add    $0x1000,%eax
  80270b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	c1 e8 0c             	shr    $0xc,%eax
  802714:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802717:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80271c:	85 c0                	test   %eax,%eax
  80271e:	75 0a                	jne    80272a <smalloc+0x62>
		return NULL;
  802720:	b8 00 00 00 00       	mov    $0x0,%eax
  802725:	e9 fc 00 00 00       	jmp    802826 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80272a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80272f:	85 c0                	test   %eax,%eax
  802731:	74 0f                	je     802742 <smalloc+0x7a>
  802733:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802739:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80273e:	39 c2                	cmp    %eax,%edx
  802740:	73 0a                	jae    80274c <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  802742:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802747:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80274c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802751:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802756:	29 c2                	sub    %eax,%edx
  802758:	89 d0                	mov    %edx,%eax
  80275a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80275d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802763:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802768:	29 c2                	sub    %eax,%edx
  80276a:	89 d0                	mov    %edx,%eax
  80276c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802775:	77 13                	ja     80278a <smalloc+0xc2>
  802777:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80277d:	77 0b                	ja     80278a <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  80277f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802782:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802785:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802788:	73 0a                	jae    802794 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  80278a:	b8 00 00 00 00       	mov    $0x0,%eax
  80278f:	e9 92 00 00 00       	jmp    802826 <smalloc+0x15e>
	}

	void *va = NULL;
  802794:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  80279b:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8027a0:	83 f8 05             	cmp    $0x5,%eax
  8027a3:	75 11                	jne    8027b6 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  8027a5:	83 ec 0c             	sub    $0xc,%esp
  8027a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8027ab:	e8 08 f7 ff ff       	call   801eb8 <alloc_pages_custom_fit>
  8027b0:	83 c4 10             	add    $0x10,%esp
  8027b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  8027b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ba:	75 27                	jne    8027e3 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8027bc:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  8027c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027c6:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8027c9:	89 c2                	mov    %eax,%edx
  8027cb:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8027d0:	39 c2                	cmp    %eax,%edx
  8027d2:	73 07                	jae    8027db <smalloc+0x113>
			return NULL;}
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d9:	eb 4b                	jmp    802826 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  8027db:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8027e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  8027e3:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8027e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8027ea:	50                   	push   %eax
  8027eb:	ff 75 0c             	pushl  0xc(%ebp)
  8027ee:	ff 75 08             	pushl  0x8(%ebp)
  8027f1:	e8 cb 03 00 00       	call   802bc1 <sys_create_shared_object>
  8027f6:	83 c4 10             	add    $0x10,%esp
  8027f9:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  8027fc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802800:	79 07                	jns    802809 <smalloc+0x141>
		return NULL;
  802802:	b8 00 00 00 00       	mov    $0x0,%eax
  802807:	eb 1d                	jmp    802826 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802809:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80280e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802811:	75 10                	jne    802823 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802813:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	01 d0                	add    %edx,%eax
  80281e:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  802823:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802826:	c9                   	leave  
  802827:	c3                   	ret    

00802828 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802828:	55                   	push   %ebp
  802829:	89 e5                	mov    %esp,%ebp
  80282b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80282e:	e8 d4 fa ff ff       	call   802307 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802833:	83 ec 08             	sub    $0x8,%esp
  802836:	ff 75 0c             	pushl  0xc(%ebp)
  802839:	ff 75 08             	pushl  0x8(%ebp)
  80283c:	e8 aa 03 00 00       	call   802beb <sys_size_of_shared_object>
  802841:	83 c4 10             	add    $0x10,%esp
  802844:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802847:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80284b:	7f 0a                	jg     802857 <sget+0x2f>
		return NULL;
  80284d:	b8 00 00 00 00       	mov    $0x0,%eax
  802852:	e9 32 01 00 00       	jmp    802989 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  802857:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  80285d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802860:	25 ff 0f 00 00       	and    $0xfff,%eax
  802865:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  802868:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80286c:	74 0e                	je     80287c <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802874:	05 00 10 00 00       	add    $0x1000,%eax
  802879:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  80287c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802881:	85 c0                	test   %eax,%eax
  802883:	75 0a                	jne    80288f <sget+0x67>
		return NULL;
  802885:	b8 00 00 00 00       	mov    $0x0,%eax
  80288a:	e9 fa 00 00 00       	jmp    802989 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80288f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802894:	85 c0                	test   %eax,%eax
  802896:	74 0f                	je     8028a7 <sget+0x7f>
  802898:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80289e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8028a3:	39 c2                	cmp    %eax,%edx
  8028a5:	73 0a                	jae    8028b1 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8028a7:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8028ac:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8028b1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8028b6:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8028bb:	29 c2                	sub    %eax,%edx
  8028bd:	89 d0                	mov    %edx,%eax
  8028bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8028c2:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8028c8:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8028cd:	29 c2                	sub    %eax,%edx
  8028cf:	89 d0                	mov    %edx,%eax
  8028d1:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8028da:	77 13                	ja     8028ef <sget+0xc7>
  8028dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028df:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8028e2:	77 0b                	ja     8028ef <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8028e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028e7:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8028ea:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8028ed:	73 0a                	jae    8028f9 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8028ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f4:	e9 90 00 00 00       	jmp    802989 <sget+0x161>

	void *va = NULL;
  8028f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802900:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802905:	83 f8 05             	cmp    $0x5,%eax
  802908:	75 11                	jne    80291b <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80290a:	83 ec 0c             	sub    $0xc,%esp
  80290d:	ff 75 f4             	pushl  -0xc(%ebp)
  802910:	e8 a3 f5 ff ff       	call   801eb8 <alloc_pages_custom_fit>
  802915:	83 c4 10             	add    $0x10,%esp
  802918:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  80291b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80291f:	75 27                	jne    802948 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802921:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802928:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80292b:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80292e:	89 c2                	mov    %eax,%edx
  802930:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802935:	39 c2                	cmp    %eax,%edx
  802937:	73 07                	jae    802940 <sget+0x118>
			return NULL;
  802939:	b8 00 00 00 00       	mov    $0x0,%eax
  80293e:	eb 49                	jmp    802989 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802940:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802945:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802948:	83 ec 04             	sub    $0x4,%esp
  80294b:	ff 75 f0             	pushl  -0x10(%ebp)
  80294e:	ff 75 0c             	pushl  0xc(%ebp)
  802951:	ff 75 08             	pushl  0x8(%ebp)
  802954:	e8 af 02 00 00       	call   802c08 <sys_get_shared_object>
  802959:	83 c4 10             	add    $0x10,%esp
  80295c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  80295f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802963:	79 07                	jns    80296c <sget+0x144>
		return NULL;
  802965:	b8 00 00 00 00       	mov    $0x0,%eax
  80296a:	eb 1d                	jmp    802989 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  80296c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802971:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802974:	75 10                	jne    802986 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802976:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	01 d0                	add    %edx,%eax
  802981:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  802986:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  802989:	c9                   	leave  
  80298a:	c3                   	ret    

0080298b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80298b:	55                   	push   %ebp
  80298c:	89 e5                	mov    %esp,%ebp
  80298e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802991:	e8 71 f9 ff ff       	call   802307 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802996:	83 ec 04             	sub    $0x4,%esp
  802999:	68 88 4b 80 00       	push   $0x804b88
  80299e:	68 19 02 00 00       	push   $0x219
  8029a3:	68 65 47 80 00       	push   $0x804765
  8029a8:	e8 3a df ff ff       	call   8008e7 <_panic>

008029ad <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8029ad:	55                   	push   %ebp
  8029ae:	89 e5                	mov    %esp,%ebp
  8029b0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8029b3:	83 ec 04             	sub    $0x4,%esp
  8029b6:	68 b0 4b 80 00       	push   $0x804bb0
  8029bb:	68 2b 02 00 00       	push   $0x22b
  8029c0:	68 65 47 80 00       	push   $0x804765
  8029c5:	e8 1d df ff ff       	call   8008e7 <_panic>

008029ca <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8029ca:	55                   	push   %ebp
  8029cb:	89 e5                	mov    %esp,%ebp
  8029cd:	57                   	push   %edi
  8029ce:	56                   	push   %esi
  8029cf:	53                   	push   %ebx
  8029d0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8029df:	8b 7d 18             	mov    0x18(%ebp),%edi
  8029e2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8029e5:	cd 30                	int    $0x30
  8029e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8029ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8029ed:	83 c4 10             	add    $0x10,%esp
  8029f0:	5b                   	pop    %ebx
  8029f1:	5e                   	pop    %esi
  8029f2:	5f                   	pop    %edi
  8029f3:	5d                   	pop    %ebp
  8029f4:	c3                   	ret    

008029f5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8029f5:	55                   	push   %ebp
  8029f6:	89 e5                	mov    %esp,%ebp
  8029f8:	83 ec 04             	sub    $0x4,%esp
  8029fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8029fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802a01:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a04:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	6a 00                	push   $0x0
  802a0d:	51                   	push   %ecx
  802a0e:	52                   	push   %edx
  802a0f:	ff 75 0c             	pushl  0xc(%ebp)
  802a12:	50                   	push   %eax
  802a13:	6a 00                	push   $0x0
  802a15:	e8 b0 ff ff ff       	call   8029ca <syscall>
  802a1a:	83 c4 18             	add    $0x18,%esp
}
  802a1d:	90                   	nop
  802a1e:	c9                   	leave  
  802a1f:	c3                   	ret    

00802a20 <sys_cgetc>:

int
sys_cgetc(void)
{
  802a20:	55                   	push   %ebp
  802a21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802a23:	6a 00                	push   $0x0
  802a25:	6a 00                	push   $0x0
  802a27:	6a 00                	push   $0x0
  802a29:	6a 00                	push   $0x0
  802a2b:	6a 00                	push   $0x0
  802a2d:	6a 02                	push   $0x2
  802a2f:	e8 96 ff ff ff       	call   8029ca <syscall>
  802a34:	83 c4 18             	add    $0x18,%esp
}
  802a37:	c9                   	leave  
  802a38:	c3                   	ret    

00802a39 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802a39:	55                   	push   %ebp
  802a3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802a3c:	6a 00                	push   $0x0
  802a3e:	6a 00                	push   $0x0
  802a40:	6a 00                	push   $0x0
  802a42:	6a 00                	push   $0x0
  802a44:	6a 00                	push   $0x0
  802a46:	6a 03                	push   $0x3
  802a48:	e8 7d ff ff ff       	call   8029ca <syscall>
  802a4d:	83 c4 18             	add    $0x18,%esp
}
  802a50:	90                   	nop
  802a51:	c9                   	leave  
  802a52:	c3                   	ret    

00802a53 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802a53:	55                   	push   %ebp
  802a54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802a56:	6a 00                	push   $0x0
  802a58:	6a 00                	push   $0x0
  802a5a:	6a 00                	push   $0x0
  802a5c:	6a 00                	push   $0x0
  802a5e:	6a 00                	push   $0x0
  802a60:	6a 04                	push   $0x4
  802a62:	e8 63 ff ff ff       	call   8029ca <syscall>
  802a67:	83 c4 18             	add    $0x18,%esp
}
  802a6a:	90                   	nop
  802a6b:	c9                   	leave  
  802a6c:	c3                   	ret    

00802a6d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802a6d:	55                   	push   %ebp
  802a6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802a70:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	6a 00                	push   $0x0
  802a78:	6a 00                	push   $0x0
  802a7a:	6a 00                	push   $0x0
  802a7c:	52                   	push   %edx
  802a7d:	50                   	push   %eax
  802a7e:	6a 08                	push   $0x8
  802a80:	e8 45 ff ff ff       	call   8029ca <syscall>
  802a85:	83 c4 18             	add    $0x18,%esp
}
  802a88:	c9                   	leave  
  802a89:	c3                   	ret    

00802a8a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802a8a:	55                   	push   %ebp
  802a8b:	89 e5                	mov    %esp,%ebp
  802a8d:	56                   	push   %esi
  802a8e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802a8f:	8b 75 18             	mov    0x18(%ebp),%esi
  802a92:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a95:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	56                   	push   %esi
  802a9f:	53                   	push   %ebx
  802aa0:	51                   	push   %ecx
  802aa1:	52                   	push   %edx
  802aa2:	50                   	push   %eax
  802aa3:	6a 09                	push   $0x9
  802aa5:	e8 20 ff ff ff       	call   8029ca <syscall>
  802aaa:	83 c4 18             	add    $0x18,%esp
}
  802aad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ab0:	5b                   	pop    %ebx
  802ab1:	5e                   	pop    %esi
  802ab2:	5d                   	pop    %ebp
  802ab3:	c3                   	ret    

00802ab4 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802ab7:	6a 00                	push   $0x0
  802ab9:	6a 00                	push   $0x0
  802abb:	6a 00                	push   $0x0
  802abd:	6a 00                	push   $0x0
  802abf:	ff 75 08             	pushl  0x8(%ebp)
  802ac2:	6a 0a                	push   $0xa
  802ac4:	e8 01 ff ff ff       	call   8029ca <syscall>
  802ac9:	83 c4 18             	add    $0x18,%esp
}
  802acc:	c9                   	leave  
  802acd:	c3                   	ret    

00802ace <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802ace:	55                   	push   %ebp
  802acf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802ad1:	6a 00                	push   $0x0
  802ad3:	6a 00                	push   $0x0
  802ad5:	6a 00                	push   $0x0
  802ad7:	ff 75 0c             	pushl  0xc(%ebp)
  802ada:	ff 75 08             	pushl  0x8(%ebp)
  802add:	6a 0b                	push   $0xb
  802adf:	e8 e6 fe ff ff       	call   8029ca <syscall>
  802ae4:	83 c4 18             	add    $0x18,%esp
}
  802ae7:	c9                   	leave  
  802ae8:	c3                   	ret    

00802ae9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802ae9:	55                   	push   %ebp
  802aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802aec:	6a 00                	push   $0x0
  802aee:	6a 00                	push   $0x0
  802af0:	6a 00                	push   $0x0
  802af2:	6a 00                	push   $0x0
  802af4:	6a 00                	push   $0x0
  802af6:	6a 0c                	push   $0xc
  802af8:	e8 cd fe ff ff       	call   8029ca <syscall>
  802afd:	83 c4 18             	add    $0x18,%esp
}
  802b00:	c9                   	leave  
  802b01:	c3                   	ret    

00802b02 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802b02:	55                   	push   %ebp
  802b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802b05:	6a 00                	push   $0x0
  802b07:	6a 00                	push   $0x0
  802b09:	6a 00                	push   $0x0
  802b0b:	6a 00                	push   $0x0
  802b0d:	6a 00                	push   $0x0
  802b0f:	6a 0d                	push   $0xd
  802b11:	e8 b4 fe ff ff       	call   8029ca <syscall>
  802b16:	83 c4 18             	add    $0x18,%esp
}
  802b19:	c9                   	leave  
  802b1a:	c3                   	ret    

00802b1b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802b1b:	55                   	push   %ebp
  802b1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802b1e:	6a 00                	push   $0x0
  802b20:	6a 00                	push   $0x0
  802b22:	6a 00                	push   $0x0
  802b24:	6a 00                	push   $0x0
  802b26:	6a 00                	push   $0x0
  802b28:	6a 0e                	push   $0xe
  802b2a:	e8 9b fe ff ff       	call   8029ca <syscall>
  802b2f:	83 c4 18             	add    $0x18,%esp
}
  802b32:	c9                   	leave  
  802b33:	c3                   	ret    

00802b34 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802b34:	55                   	push   %ebp
  802b35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802b37:	6a 00                	push   $0x0
  802b39:	6a 00                	push   $0x0
  802b3b:	6a 00                	push   $0x0
  802b3d:	6a 00                	push   $0x0
  802b3f:	6a 00                	push   $0x0
  802b41:	6a 0f                	push   $0xf
  802b43:	e8 82 fe ff ff       	call   8029ca <syscall>
  802b48:	83 c4 18             	add    $0x18,%esp
}
  802b4b:	c9                   	leave  
  802b4c:	c3                   	ret    

00802b4d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802b4d:	55                   	push   %ebp
  802b4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802b50:	6a 00                	push   $0x0
  802b52:	6a 00                	push   $0x0
  802b54:	6a 00                	push   $0x0
  802b56:	6a 00                	push   $0x0
  802b58:	ff 75 08             	pushl  0x8(%ebp)
  802b5b:	6a 10                	push   $0x10
  802b5d:	e8 68 fe ff ff       	call   8029ca <syscall>
  802b62:	83 c4 18             	add    $0x18,%esp
}
  802b65:	c9                   	leave  
  802b66:	c3                   	ret    

00802b67 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802b67:	55                   	push   %ebp
  802b68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802b6a:	6a 00                	push   $0x0
  802b6c:	6a 00                	push   $0x0
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	6a 11                	push   $0x11
  802b76:	e8 4f fe ff ff       	call   8029ca <syscall>
  802b7b:	83 c4 18             	add    $0x18,%esp
}
  802b7e:	90                   	nop
  802b7f:	c9                   	leave  
  802b80:	c3                   	ret    

00802b81 <sys_cputc>:

void
sys_cputc(const char c)
{
  802b81:	55                   	push   %ebp
  802b82:	89 e5                	mov    %esp,%ebp
  802b84:	83 ec 04             	sub    $0x4,%esp
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802b8d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b91:	6a 00                	push   $0x0
  802b93:	6a 00                	push   $0x0
  802b95:	6a 00                	push   $0x0
  802b97:	6a 00                	push   $0x0
  802b99:	50                   	push   %eax
  802b9a:	6a 01                	push   $0x1
  802b9c:	e8 29 fe ff ff       	call   8029ca <syscall>
  802ba1:	83 c4 18             	add    $0x18,%esp
}
  802ba4:	90                   	nop
  802ba5:	c9                   	leave  
  802ba6:	c3                   	ret    

00802ba7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802ba7:	55                   	push   %ebp
  802ba8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802baa:	6a 00                	push   $0x0
  802bac:	6a 00                	push   $0x0
  802bae:	6a 00                	push   $0x0
  802bb0:	6a 00                	push   $0x0
  802bb2:	6a 00                	push   $0x0
  802bb4:	6a 14                	push   $0x14
  802bb6:	e8 0f fe ff ff       	call   8029ca <syscall>
  802bbb:	83 c4 18             	add    $0x18,%esp
}
  802bbe:	90                   	nop
  802bbf:	c9                   	leave  
  802bc0:	c3                   	ret    

00802bc1 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802bc1:	55                   	push   %ebp
  802bc2:	89 e5                	mov    %esp,%ebp
  802bc4:	83 ec 04             	sub    $0x4,%esp
  802bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  802bca:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802bcd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802bd0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	6a 00                	push   $0x0
  802bd9:	51                   	push   %ecx
  802bda:	52                   	push   %edx
  802bdb:	ff 75 0c             	pushl  0xc(%ebp)
  802bde:	50                   	push   %eax
  802bdf:	6a 15                	push   $0x15
  802be1:	e8 e4 fd ff ff       	call   8029ca <syscall>
  802be6:	83 c4 18             	add    $0x18,%esp
}
  802be9:	c9                   	leave  
  802bea:	c3                   	ret    

00802beb <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802beb:	55                   	push   %ebp
  802bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	6a 00                	push   $0x0
  802bf6:	6a 00                	push   $0x0
  802bf8:	6a 00                	push   $0x0
  802bfa:	52                   	push   %edx
  802bfb:	50                   	push   %eax
  802bfc:	6a 16                	push   $0x16
  802bfe:	e8 c7 fd ff ff       	call   8029ca <syscall>
  802c03:	83 c4 18             	add    $0x18,%esp
}
  802c06:	c9                   	leave  
  802c07:	c3                   	ret    

00802c08 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802c08:	55                   	push   %ebp
  802c09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802c0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	6a 00                	push   $0x0
  802c16:	6a 00                	push   $0x0
  802c18:	51                   	push   %ecx
  802c19:	52                   	push   %edx
  802c1a:	50                   	push   %eax
  802c1b:	6a 17                	push   $0x17
  802c1d:	e8 a8 fd ff ff       	call   8029ca <syscall>
  802c22:	83 c4 18             	add    $0x18,%esp
}
  802c25:	c9                   	leave  
  802c26:	c3                   	ret    

00802c27 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802c27:	55                   	push   %ebp
  802c28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802c2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	6a 00                	push   $0x0
  802c32:	6a 00                	push   $0x0
  802c34:	6a 00                	push   $0x0
  802c36:	52                   	push   %edx
  802c37:	50                   	push   %eax
  802c38:	6a 18                	push   $0x18
  802c3a:	e8 8b fd ff ff       	call   8029ca <syscall>
  802c3f:	83 c4 18             	add    $0x18,%esp
}
  802c42:	c9                   	leave  
  802c43:	c3                   	ret    

00802c44 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802c44:	55                   	push   %ebp
  802c45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	6a 00                	push   $0x0
  802c4c:	ff 75 14             	pushl  0x14(%ebp)
  802c4f:	ff 75 10             	pushl  0x10(%ebp)
  802c52:	ff 75 0c             	pushl  0xc(%ebp)
  802c55:	50                   	push   %eax
  802c56:	6a 19                	push   $0x19
  802c58:	e8 6d fd ff ff       	call   8029ca <syscall>
  802c5d:	83 c4 18             	add    $0x18,%esp
}
  802c60:	c9                   	leave  
  802c61:	c3                   	ret    

00802c62 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802c62:	55                   	push   %ebp
  802c63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	6a 00                	push   $0x0
  802c6a:	6a 00                	push   $0x0
  802c6c:	6a 00                	push   $0x0
  802c6e:	6a 00                	push   $0x0
  802c70:	50                   	push   %eax
  802c71:	6a 1a                	push   $0x1a
  802c73:	e8 52 fd ff ff       	call   8029ca <syscall>
  802c78:	83 c4 18             	add    $0x18,%esp
}
  802c7b:	90                   	nop
  802c7c:	c9                   	leave  
  802c7d:	c3                   	ret    

00802c7e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802c7e:	55                   	push   %ebp
  802c7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	6a 00                	push   $0x0
  802c86:	6a 00                	push   $0x0
  802c88:	6a 00                	push   $0x0
  802c8a:	6a 00                	push   $0x0
  802c8c:	50                   	push   %eax
  802c8d:	6a 1b                	push   $0x1b
  802c8f:	e8 36 fd ff ff       	call   8029ca <syscall>
  802c94:	83 c4 18             	add    $0x18,%esp
}
  802c97:	c9                   	leave  
  802c98:	c3                   	ret    

00802c99 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802c99:	55                   	push   %ebp
  802c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802c9c:	6a 00                	push   $0x0
  802c9e:	6a 00                	push   $0x0
  802ca0:	6a 00                	push   $0x0
  802ca2:	6a 00                	push   $0x0
  802ca4:	6a 00                	push   $0x0
  802ca6:	6a 05                	push   $0x5
  802ca8:	e8 1d fd ff ff       	call   8029ca <syscall>
  802cad:	83 c4 18             	add    $0x18,%esp
}
  802cb0:	c9                   	leave  
  802cb1:	c3                   	ret    

00802cb2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802cb2:	55                   	push   %ebp
  802cb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802cb5:	6a 00                	push   $0x0
  802cb7:	6a 00                	push   $0x0
  802cb9:	6a 00                	push   $0x0
  802cbb:	6a 00                	push   $0x0
  802cbd:	6a 00                	push   $0x0
  802cbf:	6a 06                	push   $0x6
  802cc1:	e8 04 fd ff ff       	call   8029ca <syscall>
  802cc6:	83 c4 18             	add    $0x18,%esp
}
  802cc9:	c9                   	leave  
  802cca:	c3                   	ret    

00802ccb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802ccb:	55                   	push   %ebp
  802ccc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802cce:	6a 00                	push   $0x0
  802cd0:	6a 00                	push   $0x0
  802cd2:	6a 00                	push   $0x0
  802cd4:	6a 00                	push   $0x0
  802cd6:	6a 00                	push   $0x0
  802cd8:	6a 07                	push   $0x7
  802cda:	e8 eb fc ff ff       	call   8029ca <syscall>
  802cdf:	83 c4 18             	add    $0x18,%esp
}
  802ce2:	c9                   	leave  
  802ce3:	c3                   	ret    

00802ce4 <sys_exit_env>:


void sys_exit_env(void)
{
  802ce4:	55                   	push   %ebp
  802ce5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802ce7:	6a 00                	push   $0x0
  802ce9:	6a 00                	push   $0x0
  802ceb:	6a 00                	push   $0x0
  802ced:	6a 00                	push   $0x0
  802cef:	6a 00                	push   $0x0
  802cf1:	6a 1c                	push   $0x1c
  802cf3:	e8 d2 fc ff ff       	call   8029ca <syscall>
  802cf8:	83 c4 18             	add    $0x18,%esp
}
  802cfb:	90                   	nop
  802cfc:	c9                   	leave  
  802cfd:	c3                   	ret    

00802cfe <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802cfe:	55                   	push   %ebp
  802cff:	89 e5                	mov    %esp,%ebp
  802d01:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802d04:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802d07:	8d 50 04             	lea    0x4(%eax),%edx
  802d0a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802d0d:	6a 00                	push   $0x0
  802d0f:	6a 00                	push   $0x0
  802d11:	6a 00                	push   $0x0
  802d13:	52                   	push   %edx
  802d14:	50                   	push   %eax
  802d15:	6a 1d                	push   $0x1d
  802d17:	e8 ae fc ff ff       	call   8029ca <syscall>
  802d1c:	83 c4 18             	add    $0x18,%esp
	return result;
  802d1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802d25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802d28:	89 01                	mov    %eax,(%ecx)
  802d2a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	c9                   	leave  
  802d31:	c2 04 00             	ret    $0x4

00802d34 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802d34:	55                   	push   %ebp
  802d35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802d37:	6a 00                	push   $0x0
  802d39:	6a 00                	push   $0x0
  802d3b:	ff 75 10             	pushl  0x10(%ebp)
  802d3e:	ff 75 0c             	pushl  0xc(%ebp)
  802d41:	ff 75 08             	pushl  0x8(%ebp)
  802d44:	6a 13                	push   $0x13
  802d46:	e8 7f fc ff ff       	call   8029ca <syscall>
  802d4b:	83 c4 18             	add    $0x18,%esp
	return ;
  802d4e:	90                   	nop
}
  802d4f:	c9                   	leave  
  802d50:	c3                   	ret    

00802d51 <sys_rcr2>:
uint32 sys_rcr2()
{
  802d51:	55                   	push   %ebp
  802d52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802d54:	6a 00                	push   $0x0
  802d56:	6a 00                	push   $0x0
  802d58:	6a 00                	push   $0x0
  802d5a:	6a 00                	push   $0x0
  802d5c:	6a 00                	push   $0x0
  802d5e:	6a 1e                	push   $0x1e
  802d60:	e8 65 fc ff ff       	call   8029ca <syscall>
  802d65:	83 c4 18             	add    $0x18,%esp
}
  802d68:	c9                   	leave  
  802d69:	c3                   	ret    

00802d6a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802d6a:	55                   	push   %ebp
  802d6b:	89 e5                	mov    %esp,%ebp
  802d6d:	83 ec 04             	sub    $0x4,%esp
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802d76:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802d7a:	6a 00                	push   $0x0
  802d7c:	6a 00                	push   $0x0
  802d7e:	6a 00                	push   $0x0
  802d80:	6a 00                	push   $0x0
  802d82:	50                   	push   %eax
  802d83:	6a 1f                	push   $0x1f
  802d85:	e8 40 fc ff ff       	call   8029ca <syscall>
  802d8a:	83 c4 18             	add    $0x18,%esp
	return ;
  802d8d:	90                   	nop
}
  802d8e:	c9                   	leave  
  802d8f:	c3                   	ret    

00802d90 <rsttst>:
void rsttst()
{
  802d90:	55                   	push   %ebp
  802d91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802d93:	6a 00                	push   $0x0
  802d95:	6a 00                	push   $0x0
  802d97:	6a 00                	push   $0x0
  802d99:	6a 00                	push   $0x0
  802d9b:	6a 00                	push   $0x0
  802d9d:	6a 21                	push   $0x21
  802d9f:	e8 26 fc ff ff       	call   8029ca <syscall>
  802da4:	83 c4 18             	add    $0x18,%esp
	return ;
  802da7:	90                   	nop
}
  802da8:	c9                   	leave  
  802da9:	c3                   	ret    

00802daa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802daa:	55                   	push   %ebp
  802dab:	89 e5                	mov    %esp,%ebp
  802dad:	83 ec 04             	sub    $0x4,%esp
  802db0:	8b 45 14             	mov    0x14(%ebp),%eax
  802db3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802db6:	8b 55 18             	mov    0x18(%ebp),%edx
  802db9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802dbd:	52                   	push   %edx
  802dbe:	50                   	push   %eax
  802dbf:	ff 75 10             	pushl  0x10(%ebp)
  802dc2:	ff 75 0c             	pushl  0xc(%ebp)
  802dc5:	ff 75 08             	pushl  0x8(%ebp)
  802dc8:	6a 20                	push   $0x20
  802dca:	e8 fb fb ff ff       	call   8029ca <syscall>
  802dcf:	83 c4 18             	add    $0x18,%esp
	return ;
  802dd2:	90                   	nop
}
  802dd3:	c9                   	leave  
  802dd4:	c3                   	ret    

00802dd5 <chktst>:
void chktst(uint32 n)
{
  802dd5:	55                   	push   %ebp
  802dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802dd8:	6a 00                	push   $0x0
  802dda:	6a 00                	push   $0x0
  802ddc:	6a 00                	push   $0x0
  802dde:	6a 00                	push   $0x0
  802de0:	ff 75 08             	pushl  0x8(%ebp)
  802de3:	6a 22                	push   $0x22
  802de5:	e8 e0 fb ff ff       	call   8029ca <syscall>
  802dea:	83 c4 18             	add    $0x18,%esp
	return ;
  802ded:	90                   	nop
}
  802dee:	c9                   	leave  
  802def:	c3                   	ret    

00802df0 <inctst>:

void inctst()
{
  802df0:	55                   	push   %ebp
  802df1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802df3:	6a 00                	push   $0x0
  802df5:	6a 00                	push   $0x0
  802df7:	6a 00                	push   $0x0
  802df9:	6a 00                	push   $0x0
  802dfb:	6a 00                	push   $0x0
  802dfd:	6a 23                	push   $0x23
  802dff:	e8 c6 fb ff ff       	call   8029ca <syscall>
  802e04:	83 c4 18             	add    $0x18,%esp
	return ;
  802e07:	90                   	nop
}
  802e08:	c9                   	leave  
  802e09:	c3                   	ret    

00802e0a <gettst>:
uint32 gettst()
{
  802e0a:	55                   	push   %ebp
  802e0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802e0d:	6a 00                	push   $0x0
  802e0f:	6a 00                	push   $0x0
  802e11:	6a 00                	push   $0x0
  802e13:	6a 00                	push   $0x0
  802e15:	6a 00                	push   $0x0
  802e17:	6a 24                	push   $0x24
  802e19:	e8 ac fb ff ff       	call   8029ca <syscall>
  802e1e:	83 c4 18             	add    $0x18,%esp
}
  802e21:	c9                   	leave  
  802e22:	c3                   	ret    

00802e23 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802e23:	55                   	push   %ebp
  802e24:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e26:	6a 00                	push   $0x0
  802e28:	6a 00                	push   $0x0
  802e2a:	6a 00                	push   $0x0
  802e2c:	6a 00                	push   $0x0
  802e2e:	6a 00                	push   $0x0
  802e30:	6a 25                	push   $0x25
  802e32:	e8 93 fb ff ff       	call   8029ca <syscall>
  802e37:	83 c4 18             	add    $0x18,%esp
  802e3a:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802e3f:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802e44:	c9                   	leave  
  802e45:	c3                   	ret    

00802e46 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802e46:	55                   	push   %ebp
  802e47:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802e49:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4c:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802e51:	6a 00                	push   $0x0
  802e53:	6a 00                	push   $0x0
  802e55:	6a 00                	push   $0x0
  802e57:	6a 00                	push   $0x0
  802e59:	ff 75 08             	pushl  0x8(%ebp)
  802e5c:	6a 26                	push   $0x26
  802e5e:	e8 67 fb ff ff       	call   8029ca <syscall>
  802e63:	83 c4 18             	add    $0x18,%esp
	return ;
  802e66:	90                   	nop
}
  802e67:	c9                   	leave  
  802e68:	c3                   	ret    

00802e69 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802e69:	55                   	push   %ebp
  802e6a:	89 e5                	mov    %esp,%ebp
  802e6c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802e6d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e70:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e73:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	6a 00                	push   $0x0
  802e7b:	53                   	push   %ebx
  802e7c:	51                   	push   %ecx
  802e7d:	52                   	push   %edx
  802e7e:	50                   	push   %eax
  802e7f:	6a 27                	push   $0x27
  802e81:	e8 44 fb ff ff       	call   8029ca <syscall>
  802e86:	83 c4 18             	add    $0x18,%esp
}
  802e89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e8c:	c9                   	leave  
  802e8d:	c3                   	ret    

00802e8e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802e8e:	55                   	push   %ebp
  802e8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802e91:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	6a 00                	push   $0x0
  802e99:	6a 00                	push   $0x0
  802e9b:	6a 00                	push   $0x0
  802e9d:	52                   	push   %edx
  802e9e:	50                   	push   %eax
  802e9f:	6a 28                	push   $0x28
  802ea1:	e8 24 fb ff ff       	call   8029ca <syscall>
  802ea6:	83 c4 18             	add    $0x18,%esp
}
  802ea9:	c9                   	leave  
  802eaa:	c3                   	ret    

00802eab <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802eab:	55                   	push   %ebp
  802eac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802eae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802eb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	6a 00                	push   $0x0
  802eb9:	51                   	push   %ecx
  802eba:	ff 75 10             	pushl  0x10(%ebp)
  802ebd:	52                   	push   %edx
  802ebe:	50                   	push   %eax
  802ebf:	6a 29                	push   $0x29
  802ec1:	e8 04 fb ff ff       	call   8029ca <syscall>
  802ec6:	83 c4 18             	add    $0x18,%esp
}
  802ec9:	c9                   	leave  
  802eca:	c3                   	ret    

00802ecb <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802ecb:	55                   	push   %ebp
  802ecc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802ece:	6a 00                	push   $0x0
  802ed0:	6a 00                	push   $0x0
  802ed2:	ff 75 10             	pushl  0x10(%ebp)
  802ed5:	ff 75 0c             	pushl  0xc(%ebp)
  802ed8:	ff 75 08             	pushl  0x8(%ebp)
  802edb:	6a 12                	push   $0x12
  802edd:	e8 e8 fa ff ff       	call   8029ca <syscall>
  802ee2:	83 c4 18             	add    $0x18,%esp
	return ;
  802ee5:	90                   	nop
}
  802ee6:	c9                   	leave  
  802ee7:	c3                   	ret    

00802ee8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802ee8:	55                   	push   %ebp
  802ee9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	6a 00                	push   $0x0
  802ef3:	6a 00                	push   $0x0
  802ef5:	6a 00                	push   $0x0
  802ef7:	52                   	push   %edx
  802ef8:	50                   	push   %eax
  802ef9:	6a 2a                	push   $0x2a
  802efb:	e8 ca fa ff ff       	call   8029ca <syscall>
  802f00:	83 c4 18             	add    $0x18,%esp
	return;
  802f03:	90                   	nop
}
  802f04:	c9                   	leave  
  802f05:	c3                   	ret    

00802f06 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802f06:	55                   	push   %ebp
  802f07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802f09:	6a 00                	push   $0x0
  802f0b:	6a 00                	push   $0x0
  802f0d:	6a 00                	push   $0x0
  802f0f:	6a 00                	push   $0x0
  802f11:	6a 00                	push   $0x0
  802f13:	6a 2b                	push   $0x2b
  802f15:	e8 b0 fa ff ff       	call   8029ca <syscall>
  802f1a:	83 c4 18             	add    $0x18,%esp
}
  802f1d:	c9                   	leave  
  802f1e:	c3                   	ret    

00802f1f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802f1f:	55                   	push   %ebp
  802f20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802f22:	6a 00                	push   $0x0
  802f24:	6a 00                	push   $0x0
  802f26:	6a 00                	push   $0x0
  802f28:	ff 75 0c             	pushl  0xc(%ebp)
  802f2b:	ff 75 08             	pushl  0x8(%ebp)
  802f2e:	6a 2d                	push   $0x2d
  802f30:	e8 95 fa ff ff       	call   8029ca <syscall>
  802f35:	83 c4 18             	add    $0x18,%esp
	return;
  802f38:	90                   	nop
}
  802f39:	c9                   	leave  
  802f3a:	c3                   	ret    

00802f3b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802f3b:	55                   	push   %ebp
  802f3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802f3e:	6a 00                	push   $0x0
  802f40:	6a 00                	push   $0x0
  802f42:	6a 00                	push   $0x0
  802f44:	ff 75 0c             	pushl  0xc(%ebp)
  802f47:	ff 75 08             	pushl  0x8(%ebp)
  802f4a:	6a 2c                	push   $0x2c
  802f4c:	e8 79 fa ff ff       	call   8029ca <syscall>
  802f51:	83 c4 18             	add    $0x18,%esp
	return ;
  802f54:	90                   	nop
}
  802f55:	c9                   	leave  
  802f56:	c3                   	ret    

00802f57 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802f57:	55                   	push   %ebp
  802f58:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	6a 00                	push   $0x0
  802f62:	6a 00                	push   $0x0
  802f64:	6a 00                	push   $0x0
  802f66:	52                   	push   %edx
  802f67:	50                   	push   %eax
  802f68:	6a 2e                	push   $0x2e
  802f6a:	e8 5b fa ff ff       	call   8029ca <syscall>
  802f6f:	83 c4 18             	add    $0x18,%esp
	return ;
  802f72:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802f73:	c9                   	leave  
  802f74:	c3                   	ret    

00802f75 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802f75:	55                   	push   %ebp
  802f76:	89 e5                	mov    %esp,%ebp
  802f78:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802f7b:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802f82:	72 09                	jb     802f8d <to_page_va+0x18>
  802f84:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802f8b:	72 14                	jb     802fa1 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802f8d:	83 ec 04             	sub    $0x4,%esp
  802f90:	68 d4 4b 80 00       	push   $0x804bd4
  802f95:	6a 15                	push   $0x15
  802f97:	68 ff 4b 80 00       	push   $0x804bff
  802f9c:	e8 46 d9 ff ff       	call   8008e7 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	ba 60 50 80 00       	mov    $0x805060,%edx
  802fa9:	29 d0                	sub    %edx,%eax
  802fab:	c1 f8 02             	sar    $0x2,%eax
  802fae:	89 c2                	mov    %eax,%edx
  802fb0:	89 d0                	mov    %edx,%eax
  802fb2:	c1 e0 02             	shl    $0x2,%eax
  802fb5:	01 d0                	add    %edx,%eax
  802fb7:	c1 e0 02             	shl    $0x2,%eax
  802fba:	01 d0                	add    %edx,%eax
  802fbc:	c1 e0 02             	shl    $0x2,%eax
  802fbf:	01 d0                	add    %edx,%eax
  802fc1:	89 c1                	mov    %eax,%ecx
  802fc3:	c1 e1 08             	shl    $0x8,%ecx
  802fc6:	01 c8                	add    %ecx,%eax
  802fc8:	89 c1                	mov    %eax,%ecx
  802fca:	c1 e1 10             	shl    $0x10,%ecx
  802fcd:	01 c8                	add    %ecx,%eax
  802fcf:	01 c0                	add    %eax,%eax
  802fd1:	01 d0                	add    %edx,%eax
  802fd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	c1 e0 0c             	shl    $0xc,%eax
  802fdc:	89 c2                	mov    %eax,%edx
  802fde:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802fe3:	01 d0                	add    %edx,%eax
}
  802fe5:	c9                   	leave  
  802fe6:	c3                   	ret    

00802fe7 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802fe7:	55                   	push   %ebp
  802fe8:	89 e5                	mov    %esp,%ebp
  802fea:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802fed:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff5:	29 c2                	sub    %eax,%edx
  802ff7:	89 d0                	mov    %edx,%eax
  802ff9:	c1 e8 0c             	shr    $0xc,%eax
  802ffc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802fff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803003:	78 09                	js     80300e <to_page_info+0x27>
  803005:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80300c:	7e 14                	jle    803022 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  80300e:	83 ec 04             	sub    $0x4,%esp
  803011:	68 18 4c 80 00       	push   $0x804c18
  803016:	6a 22                	push   $0x22
  803018:	68 ff 4b 80 00       	push   $0x804bff
  80301d:	e8 c5 d8 ff ff       	call   8008e7 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803022:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803025:	89 d0                	mov    %edx,%eax
  803027:	01 c0                	add    %eax,%eax
  803029:	01 d0                	add    %edx,%eax
  80302b:	c1 e0 02             	shl    $0x2,%eax
  80302e:	05 60 50 80 00       	add    $0x805060,%eax
}
  803033:	c9                   	leave  
  803034:	c3                   	ret    

00803035 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803035:	55                   	push   %ebp
  803036:	89 e5                	mov    %esp,%ebp
  803038:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80303b:	8b 45 08             	mov    0x8(%ebp),%eax
  80303e:	05 00 00 00 02       	add    $0x2000000,%eax
  803043:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803046:	73 16                	jae    80305e <initialize_dynamic_allocator+0x29>
  803048:	68 3c 4c 80 00       	push   $0x804c3c
  80304d:	68 62 4c 80 00       	push   $0x804c62
  803052:	6a 34                	push   $0x34
  803054:	68 ff 4b 80 00       	push   $0x804bff
  803059:	e8 89 d8 ff ff       	call   8008e7 <_panic>
		is_initialized = 1;
  80305e:	c7 05 38 50 80 00 01 	movl   $0x1,0x805038
  803065:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  803068:	8b 45 08             	mov    0x8(%ebp),%eax
  80306b:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  803070:	8b 45 0c             	mov    0xc(%ebp),%eax
  803073:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  803078:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  80307f:	00 00 00 
  803082:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  803089:	00 00 00 
  80308c:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  803093:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  803096:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  80309d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8030a4:	eb 36                	jmp    8030dc <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  8030a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a9:	c1 e0 04             	shl    $0x4,%eax
  8030ac:	05 80 d0 81 00       	add    $0x81d080,%eax
  8030b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	c1 e0 04             	shl    $0x4,%eax
  8030bd:	05 84 d0 81 00       	add    $0x81d084,%eax
  8030c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	c1 e0 04             	shl    $0x4,%eax
  8030ce:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  8030d9:	ff 45 f4             	incl   -0xc(%ebp)
  8030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030df:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8030e2:	72 c2                	jb     8030a6 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  8030e4:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8030ea:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8030ef:	29 c2                	sub    %eax,%edx
  8030f1:	89 d0                	mov    %edx,%eax
  8030f3:	c1 e8 0c             	shr    $0xc,%eax
  8030f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  8030f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803100:	e9 c8 00 00 00       	jmp    8031cd <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  803105:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803108:	89 d0                	mov    %edx,%eax
  80310a:	01 c0                	add    %eax,%eax
  80310c:	01 d0                	add    %edx,%eax
  80310e:	c1 e0 02             	shl    $0x2,%eax
  803111:	05 68 50 80 00       	add    $0x805068,%eax
  803116:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  80311b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80311e:	89 d0                	mov    %edx,%eax
  803120:	01 c0                	add    %eax,%eax
  803122:	01 d0                	add    %edx,%eax
  803124:	c1 e0 02             	shl    $0x2,%eax
  803127:	05 6a 50 80 00       	add    $0x80506a,%eax
  80312c:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803131:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803137:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80313a:	89 c8                	mov    %ecx,%eax
  80313c:	01 c0                	add    %eax,%eax
  80313e:	01 c8                	add    %ecx,%eax
  803140:	c1 e0 02             	shl    $0x2,%eax
  803143:	05 64 50 80 00       	add    $0x805064,%eax
  803148:	89 10                	mov    %edx,(%eax)
  80314a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80314d:	89 d0                	mov    %edx,%eax
  80314f:	01 c0                	add    %eax,%eax
  803151:	01 d0                	add    %edx,%eax
  803153:	c1 e0 02             	shl    $0x2,%eax
  803156:	05 64 50 80 00       	add    $0x805064,%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	74 1b                	je     80317c <initialize_dynamic_allocator+0x147>
  803161:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803167:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80316a:	89 c8                	mov    %ecx,%eax
  80316c:	01 c0                	add    %eax,%eax
  80316e:	01 c8                	add    %ecx,%eax
  803170:	c1 e0 02             	shl    $0x2,%eax
  803173:	05 60 50 80 00       	add    $0x805060,%eax
  803178:	89 02                	mov    %eax,(%edx)
  80317a:	eb 16                	jmp    803192 <initialize_dynamic_allocator+0x15d>
  80317c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80317f:	89 d0                	mov    %edx,%eax
  803181:	01 c0                	add    %eax,%eax
  803183:	01 d0                	add    %edx,%eax
  803185:	c1 e0 02             	shl    $0x2,%eax
  803188:	05 60 50 80 00       	add    $0x805060,%eax
  80318d:	a3 48 50 80 00       	mov    %eax,0x805048
  803192:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803195:	89 d0                	mov    %edx,%eax
  803197:	01 c0                	add    %eax,%eax
  803199:	01 d0                	add    %edx,%eax
  80319b:	c1 e0 02             	shl    $0x2,%eax
  80319e:	05 60 50 80 00       	add    $0x805060,%eax
  8031a3:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8031a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ab:	89 d0                	mov    %edx,%eax
  8031ad:	01 c0                	add    %eax,%eax
  8031af:	01 d0                	add    %edx,%eax
  8031b1:	c1 e0 02             	shl    $0x2,%eax
  8031b4:	05 60 50 80 00       	add    $0x805060,%eax
  8031b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031bf:	a1 54 50 80 00       	mov    0x805054,%eax
  8031c4:	40                   	inc    %eax
  8031c5:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  8031ca:	ff 45 f0             	incl   -0x10(%ebp)
  8031cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8031d3:	0f 82 2c ff ff ff    	jb     803105 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8031d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8031df:	eb 2f                	jmp    803210 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  8031e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031e4:	89 d0                	mov    %edx,%eax
  8031e6:	01 c0                	add    %eax,%eax
  8031e8:	01 d0                	add    %edx,%eax
  8031ea:	c1 e0 02             	shl    $0x2,%eax
  8031ed:	05 68 50 80 00       	add    $0x805068,%eax
  8031f2:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  8031f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031fa:	89 d0                	mov    %edx,%eax
  8031fc:	01 c0                	add    %eax,%eax
  8031fe:	01 d0                	add    %edx,%eax
  803200:	c1 e0 02             	shl    $0x2,%eax
  803203:	05 6a 50 80 00       	add    $0x80506a,%eax
  803208:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  80320d:	ff 45 ec             	incl   -0x14(%ebp)
  803210:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803217:	76 c8                	jbe    8031e1 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803219:	90                   	nop
  80321a:	c9                   	leave  
  80321b:	c3                   	ret    

0080321c <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80321c:	55                   	push   %ebp
  80321d:	89 e5                	mov    %esp,%ebp
  80321f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  803222:	8b 55 08             	mov    0x8(%ebp),%edx
  803225:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80322a:	29 c2                	sub    %eax,%edx
  80322c:	89 d0                	mov    %edx,%eax
  80322e:	c1 e8 0c             	shr    $0xc,%eax
  803231:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803234:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803237:	89 d0                	mov    %edx,%eax
  803239:	01 c0                	add    %eax,%eax
  80323b:	01 d0                	add    %edx,%eax
  80323d:	c1 e0 02             	shl    $0x2,%eax
  803240:	05 68 50 80 00       	add    $0x805068,%eax
  803245:	8b 00                	mov    (%eax),%eax
  803247:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80324a:	c9                   	leave  
  80324b:	c3                   	ret    

0080324c <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  80324c:	55                   	push   %ebp
  80324d:	89 e5                	mov    %esp,%ebp
  80324f:	83 ec 14             	sub    $0x14,%esp
  803252:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  803255:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803259:	77 07                	ja     803262 <nearest_pow2_ceil.1513+0x16>
  80325b:	b8 01 00 00 00       	mov    $0x1,%eax
  803260:	eb 20                	jmp    803282 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803262:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  803269:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  80326c:	eb 08                	jmp    803276 <nearest_pow2_ceil.1513+0x2a>
  80326e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803271:	01 c0                	add    %eax,%eax
  803273:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803276:	d1 6d 08             	shrl   0x8(%ebp)
  803279:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80327d:	75 ef                	jne    80326e <nearest_pow2_ceil.1513+0x22>
        return power;
  80327f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803282:	c9                   	leave  
  803283:	c3                   	ret    

00803284 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803284:	55                   	push   %ebp
  803285:	89 e5                	mov    %esp,%ebp
  803287:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80328a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803291:	76 16                	jbe    8032a9 <alloc_block+0x25>
  803293:	68 78 4c 80 00       	push   $0x804c78
  803298:	68 62 4c 80 00       	push   $0x804c62
  80329d:	6a 72                	push   $0x72
  80329f:	68 ff 4b 80 00       	push   $0x804bff
  8032a4:	e8 3e d6 ff ff       	call   8008e7 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  8032a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ad:	75 0a                	jne    8032b9 <alloc_block+0x35>
  8032af:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b4:	e9 bd 04 00 00       	jmp    803776 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8032b9:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8032c6:	73 06                	jae    8032ce <alloc_block+0x4a>
        size = min_block_size;
  8032c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032cb:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  8032ce:	83 ec 0c             	sub    $0xc,%esp
  8032d1:	8d 45 cc             	lea    -0x34(%ebp),%eax
  8032d4:	ff 75 08             	pushl  0x8(%ebp)
  8032d7:	89 c1                	mov    %eax,%ecx
  8032d9:	e8 6e ff ff ff       	call   80324c <nearest_pow2_ceil.1513>
  8032de:	83 c4 10             	add    $0x10,%esp
  8032e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  8032e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e7:	83 ec 0c             	sub    $0xc,%esp
  8032ea:	8d 45 cc             	lea    -0x34(%ebp),%eax
  8032ed:	52                   	push   %edx
  8032ee:	89 c1                	mov    %eax,%ecx
  8032f0:	e8 83 04 00 00       	call   803778 <log2_ceil.1520>
  8032f5:	83 c4 10             	add    $0x10,%esp
  8032f8:	83 e8 03             	sub    $0x3,%eax
  8032fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  8032fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803301:	c1 e0 04             	shl    $0x4,%eax
  803304:	05 80 d0 81 00       	add    $0x81d080,%eax
  803309:	8b 00                	mov    (%eax),%eax
  80330b:	85 c0                	test   %eax,%eax
  80330d:	0f 84 d8 00 00 00    	je     8033eb <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803313:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803316:	c1 e0 04             	shl    $0x4,%eax
  803319:	05 80 d0 81 00       	add    $0x81d080,%eax
  80331e:	8b 00                	mov    (%eax),%eax
  803320:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803323:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803327:	75 17                	jne    803340 <alloc_block+0xbc>
  803329:	83 ec 04             	sub    $0x4,%esp
  80332c:	68 99 4c 80 00       	push   $0x804c99
  803331:	68 98 00 00 00       	push   $0x98
  803336:	68 ff 4b 80 00       	push   $0x804bff
  80333b:	e8 a7 d5 ff ff       	call   8008e7 <_panic>
  803340:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803343:	8b 00                	mov    (%eax),%eax
  803345:	85 c0                	test   %eax,%eax
  803347:	74 10                	je     803359 <alloc_block+0xd5>
  803349:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80334c:	8b 00                	mov    (%eax),%eax
  80334e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803351:	8b 52 04             	mov    0x4(%edx),%edx
  803354:	89 50 04             	mov    %edx,0x4(%eax)
  803357:	eb 14                	jmp    80336d <alloc_block+0xe9>
  803359:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80335c:	8b 40 04             	mov    0x4(%eax),%eax
  80335f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803362:	c1 e2 04             	shl    $0x4,%edx
  803365:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80336b:	89 02                	mov    %eax,(%edx)
  80336d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803370:	8b 40 04             	mov    0x4(%eax),%eax
  803373:	85 c0                	test   %eax,%eax
  803375:	74 0f                	je     803386 <alloc_block+0x102>
  803377:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80337a:	8b 40 04             	mov    0x4(%eax),%eax
  80337d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803380:	8b 12                	mov    (%edx),%edx
  803382:	89 10                	mov    %edx,(%eax)
  803384:	eb 13                	jmp    803399 <alloc_block+0x115>
  803386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803389:	8b 00                	mov    (%eax),%eax
  80338b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80338e:	c1 e2 04             	shl    $0x4,%edx
  803391:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803397:	89 02                	mov    %eax,(%edx)
  803399:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80339c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033af:	c1 e0 04             	shl    $0x4,%eax
  8033b2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033b7:	8b 00                	mov    (%eax),%eax
  8033b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8033bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033bf:	c1 e0 04             	shl    $0x4,%eax
  8033c2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033c7:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  8033c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033cc:	83 ec 0c             	sub    $0xc,%esp
  8033cf:	50                   	push   %eax
  8033d0:	e8 12 fc ff ff       	call   802fe7 <to_page_info>
  8033d5:	83 c4 10             	add    $0x10,%esp
  8033d8:	89 c2                	mov    %eax,%edx
  8033da:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8033de:	48                   	dec    %eax
  8033df:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  8033e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033e6:	e9 8b 03 00 00       	jmp    803776 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  8033eb:	a1 48 50 80 00       	mov    0x805048,%eax
  8033f0:	85 c0                	test   %eax,%eax
  8033f2:	0f 84 64 02 00 00    	je     80365c <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  8033f8:	a1 48 50 80 00       	mov    0x805048,%eax
  8033fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  803400:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803404:	75 17                	jne    80341d <alloc_block+0x199>
  803406:	83 ec 04             	sub    $0x4,%esp
  803409:	68 99 4c 80 00       	push   $0x804c99
  80340e:	68 a0 00 00 00       	push   $0xa0
  803413:	68 ff 4b 80 00       	push   $0x804bff
  803418:	e8 ca d4 ff ff       	call   8008e7 <_panic>
  80341d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803420:	8b 00                	mov    (%eax),%eax
  803422:	85 c0                	test   %eax,%eax
  803424:	74 10                	je     803436 <alloc_block+0x1b2>
  803426:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803429:	8b 00                	mov    (%eax),%eax
  80342b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80342e:	8b 52 04             	mov    0x4(%edx),%edx
  803431:	89 50 04             	mov    %edx,0x4(%eax)
  803434:	eb 0b                	jmp    803441 <alloc_block+0x1bd>
  803436:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803439:	8b 40 04             	mov    0x4(%eax),%eax
  80343c:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803441:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803444:	8b 40 04             	mov    0x4(%eax),%eax
  803447:	85 c0                	test   %eax,%eax
  803449:	74 0f                	je     80345a <alloc_block+0x1d6>
  80344b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80344e:	8b 40 04             	mov    0x4(%eax),%eax
  803451:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803454:	8b 12                	mov    (%edx),%edx
  803456:	89 10                	mov    %edx,(%eax)
  803458:	eb 0a                	jmp    803464 <alloc_block+0x1e0>
  80345a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80345d:	8b 00                	mov    (%eax),%eax
  80345f:	a3 48 50 80 00       	mov    %eax,0x805048
  803464:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80346d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803470:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803477:	a1 54 50 80 00       	mov    0x805054,%eax
  80347c:	48                   	dec    %eax
  80347d:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  803482:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803485:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803488:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  80348c:	b8 00 10 00 00       	mov    $0x1000,%eax
  803491:	99                   	cltd   
  803492:	f7 7d e8             	idivl  -0x18(%ebp)
  803495:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803498:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  80349c:	83 ec 0c             	sub    $0xc,%esp
  80349f:	ff 75 dc             	pushl  -0x24(%ebp)
  8034a2:	e8 ce fa ff ff       	call   802f75 <to_page_va>
  8034a7:	83 c4 10             	add    $0x10,%esp
  8034aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  8034ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034b0:	83 ec 0c             	sub    $0xc,%esp
  8034b3:	50                   	push   %eax
  8034b4:	e8 c0 ee ff ff       	call   802379 <get_page>
  8034b9:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8034bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8034c3:	e9 aa 00 00 00       	jmp    803572 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  8034c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cb:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  8034cf:	89 c2                	mov    %eax,%edx
  8034d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034d4:	01 d0                	add    %edx,%eax
  8034d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  8034d9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034dd:	75 17                	jne    8034f6 <alloc_block+0x272>
  8034df:	83 ec 04             	sub    $0x4,%esp
  8034e2:	68 b8 4c 80 00       	push   $0x804cb8
  8034e7:	68 aa 00 00 00       	push   $0xaa
  8034ec:	68 ff 4b 80 00       	push   $0x804bff
  8034f1:	e8 f1 d3 ff ff       	call   8008e7 <_panic>
  8034f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f9:	c1 e0 04             	shl    $0x4,%eax
  8034fc:	05 84 d0 81 00       	add    $0x81d084,%eax
  803501:	8b 10                	mov    (%eax),%edx
  803503:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803506:	89 50 04             	mov    %edx,0x4(%eax)
  803509:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350c:	8b 40 04             	mov    0x4(%eax),%eax
  80350f:	85 c0                	test   %eax,%eax
  803511:	74 14                	je     803527 <alloc_block+0x2a3>
  803513:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803516:	c1 e0 04             	shl    $0x4,%eax
  803519:	05 84 d0 81 00       	add    $0x81d084,%eax
  80351e:	8b 00                	mov    (%eax),%eax
  803520:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803523:	89 10                	mov    %edx,(%eax)
  803525:	eb 11                	jmp    803538 <alloc_block+0x2b4>
  803527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80352a:	c1 e0 04             	shl    $0x4,%eax
  80352d:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803533:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803536:	89 02                	mov    %eax,(%edx)
  803538:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353b:	c1 e0 04             	shl    $0x4,%eax
  80353e:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803544:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803547:	89 02                	mov    %eax,(%edx)
  803549:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803555:	c1 e0 04             	shl    $0x4,%eax
  803558:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80355d:	8b 00                	mov    (%eax),%eax
  80355f:	8d 50 01             	lea    0x1(%eax),%edx
  803562:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803565:	c1 e0 04             	shl    $0x4,%eax
  803568:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80356d:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  80356f:	ff 45 f4             	incl   -0xc(%ebp)
  803572:	b8 00 10 00 00       	mov    $0x1000,%eax
  803577:	99                   	cltd   
  803578:	f7 7d e8             	idivl  -0x18(%ebp)
  80357b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80357e:	0f 8f 44 ff ff ff    	jg     8034c8 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803587:	c1 e0 04             	shl    $0x4,%eax
  80358a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80358f:	8b 00                	mov    (%eax),%eax
  803591:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803594:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803598:	75 17                	jne    8035b1 <alloc_block+0x32d>
  80359a:	83 ec 04             	sub    $0x4,%esp
  80359d:	68 99 4c 80 00       	push   $0x804c99
  8035a2:	68 ae 00 00 00       	push   $0xae
  8035a7:	68 ff 4b 80 00       	push   $0x804bff
  8035ac:	e8 36 d3 ff ff       	call   8008e7 <_panic>
  8035b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035b4:	8b 00                	mov    (%eax),%eax
  8035b6:	85 c0                	test   %eax,%eax
  8035b8:	74 10                	je     8035ca <alloc_block+0x346>
  8035ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035bd:	8b 00                	mov    (%eax),%eax
  8035bf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8035c2:	8b 52 04             	mov    0x4(%edx),%edx
  8035c5:	89 50 04             	mov    %edx,0x4(%eax)
  8035c8:	eb 14                	jmp    8035de <alloc_block+0x35a>
  8035ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035cd:	8b 40 04             	mov    0x4(%eax),%eax
  8035d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d3:	c1 e2 04             	shl    $0x4,%edx
  8035d6:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8035dc:	89 02                	mov    %eax,(%edx)
  8035de:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035e1:	8b 40 04             	mov    0x4(%eax),%eax
  8035e4:	85 c0                	test   %eax,%eax
  8035e6:	74 0f                	je     8035f7 <alloc_block+0x373>
  8035e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035eb:	8b 40 04             	mov    0x4(%eax),%eax
  8035ee:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8035f1:	8b 12                	mov    (%edx),%edx
  8035f3:	89 10                	mov    %edx,(%eax)
  8035f5:	eb 13                	jmp    80360a <alloc_block+0x386>
  8035f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035fa:	8b 00                	mov    (%eax),%eax
  8035fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035ff:	c1 e2 04             	shl    $0x4,%edx
  803602:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803608:	89 02                	mov    %eax,(%edx)
  80360a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80360d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803613:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803616:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80361d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803620:	c1 e0 04             	shl    $0x4,%eax
  803623:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803628:	8b 00                	mov    (%eax),%eax
  80362a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80362d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803630:	c1 e0 04             	shl    $0x4,%eax
  803633:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803638:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  80363a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80363d:	83 ec 0c             	sub    $0xc,%esp
  803640:	50                   	push   %eax
  803641:	e8 a1 f9 ff ff       	call   802fe7 <to_page_info>
  803646:	83 c4 10             	add    $0x10,%esp
  803649:	89 c2                	mov    %eax,%edx
  80364b:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80364f:	48                   	dec    %eax
  803650:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  803654:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803657:	e9 1a 01 00 00       	jmp    803776 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  80365c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365f:	40                   	inc    %eax
  803660:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803663:	e9 ed 00 00 00       	jmp    803755 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  803668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80366b:	c1 e0 04             	shl    $0x4,%eax
  80366e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803673:	8b 00                	mov    (%eax),%eax
  803675:	85 c0                	test   %eax,%eax
  803677:	0f 84 d5 00 00 00    	je     803752 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  80367d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803680:	c1 e0 04             	shl    $0x4,%eax
  803683:	05 80 d0 81 00       	add    $0x81d080,%eax
  803688:	8b 00                	mov    (%eax),%eax
  80368a:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  80368d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803691:	75 17                	jne    8036aa <alloc_block+0x426>
  803693:	83 ec 04             	sub    $0x4,%esp
  803696:	68 99 4c 80 00       	push   $0x804c99
  80369b:	68 b8 00 00 00       	push   $0xb8
  8036a0:	68 ff 4b 80 00       	push   $0x804bff
  8036a5:	e8 3d d2 ff ff       	call   8008e7 <_panic>
  8036aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	85 c0                	test   %eax,%eax
  8036b1:	74 10                	je     8036c3 <alloc_block+0x43f>
  8036b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036b6:	8b 00                	mov    (%eax),%eax
  8036b8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8036bb:	8b 52 04             	mov    0x4(%edx),%edx
  8036be:	89 50 04             	mov    %edx,0x4(%eax)
  8036c1:	eb 14                	jmp    8036d7 <alloc_block+0x453>
  8036c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036c6:	8b 40 04             	mov    0x4(%eax),%eax
  8036c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036cc:	c1 e2 04             	shl    $0x4,%edx
  8036cf:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8036d5:	89 02                	mov    %eax,(%edx)
  8036d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036da:	8b 40 04             	mov    0x4(%eax),%eax
  8036dd:	85 c0                	test   %eax,%eax
  8036df:	74 0f                	je     8036f0 <alloc_block+0x46c>
  8036e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036e4:	8b 40 04             	mov    0x4(%eax),%eax
  8036e7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8036ea:	8b 12                	mov    (%edx),%edx
  8036ec:	89 10                	mov    %edx,(%eax)
  8036ee:	eb 13                	jmp    803703 <alloc_block+0x47f>
  8036f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036f3:	8b 00                	mov    (%eax),%eax
  8036f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036f8:	c1 e2 04             	shl    $0x4,%edx
  8036fb:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803701:	89 02                	mov    %eax,(%edx)
  803703:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803706:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80370f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803719:	c1 e0 04             	shl    $0x4,%eax
  80371c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803721:	8b 00                	mov    (%eax),%eax
  803723:	8d 50 ff             	lea    -0x1(%eax),%edx
  803726:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803729:	c1 e0 04             	shl    $0x4,%eax
  80372c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803731:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  803733:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803736:	83 ec 0c             	sub    $0xc,%esp
  803739:	50                   	push   %eax
  80373a:	e8 a8 f8 ff ff       	call   802fe7 <to_page_info>
  80373f:	83 c4 10             	add    $0x10,%esp
  803742:	89 c2                	mov    %eax,%edx
  803744:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803748:	48                   	dec    %eax
  803749:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  80374d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803750:	eb 24                	jmp    803776 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803752:	ff 45 f0             	incl   -0x10(%ebp)
  803755:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803759:	0f 8e 09 ff ff ff    	jle    803668 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  80375f:	83 ec 04             	sub    $0x4,%esp
  803762:	68 db 4c 80 00       	push   $0x804cdb
  803767:	68 bf 00 00 00       	push   $0xbf
  80376c:	68 ff 4b 80 00       	push   $0x804bff
  803771:	e8 71 d1 ff ff       	call   8008e7 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803776:	c9                   	leave  
  803777:	c3                   	ret    

00803778 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  803778:	55                   	push   %ebp
  803779:	89 e5                	mov    %esp,%ebp
  80377b:	83 ec 14             	sub    $0x14,%esp
  80377e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  803781:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803785:	75 07                	jne    80378e <log2_ceil.1520+0x16>
  803787:	b8 00 00 00 00       	mov    $0x0,%eax
  80378c:	eb 1b                	jmp    8037a9 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  80378e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  803795:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  803798:	eb 06                	jmp    8037a0 <log2_ceil.1520+0x28>
            x >>= 1;
  80379a:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  80379d:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8037a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037a4:	75 f4                	jne    80379a <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  8037a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8037a9:	c9                   	leave  
  8037aa:	c3                   	ret    

008037ab <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  8037ab:	55                   	push   %ebp
  8037ac:	89 e5                	mov    %esp,%ebp
  8037ae:	83 ec 14             	sub    $0x14,%esp
  8037b1:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  8037b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037b8:	75 07                	jne    8037c1 <log2_ceil.1547+0x16>
  8037ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8037bf:	eb 1b                	jmp    8037dc <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  8037c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  8037c8:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  8037cb:	eb 06                	jmp    8037d3 <log2_ceil.1547+0x28>
			x >>= 1;
  8037cd:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  8037d0:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  8037d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037d7:	75 f4                	jne    8037cd <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8037d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8037dc:	c9                   	leave  
  8037dd:	c3                   	ret    

008037de <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8037de:	55                   	push   %ebp
  8037df:	89 e5                	mov    %esp,%ebp
  8037e1:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8037e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8037e7:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8037ec:	39 c2                	cmp    %eax,%edx
  8037ee:	72 0c                	jb     8037fc <free_block+0x1e>
  8037f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8037f3:	a1 40 50 80 00       	mov    0x805040,%eax
  8037f8:	39 c2                	cmp    %eax,%edx
  8037fa:	72 19                	jb     803815 <free_block+0x37>
  8037fc:	68 e0 4c 80 00       	push   $0x804ce0
  803801:	68 62 4c 80 00       	push   $0x804c62
  803806:	68 d0 00 00 00       	push   $0xd0
  80380b:	68 ff 4b 80 00       	push   $0x804bff
  803810:	e8 d2 d0 ff ff       	call   8008e7 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803815:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803819:	0f 84 42 03 00 00    	je     803b61 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  80381f:	8b 55 08             	mov    0x8(%ebp),%edx
  803822:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803827:	39 c2                	cmp    %eax,%edx
  803829:	72 0c                	jb     803837 <free_block+0x59>
  80382b:	8b 55 08             	mov    0x8(%ebp),%edx
  80382e:	a1 40 50 80 00       	mov    0x805040,%eax
  803833:	39 c2                	cmp    %eax,%edx
  803835:	72 17                	jb     80384e <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803837:	83 ec 04             	sub    $0x4,%esp
  80383a:	68 18 4d 80 00       	push   $0x804d18
  80383f:	68 e6 00 00 00       	push   $0xe6
  803844:	68 ff 4b 80 00       	push   $0x804bff
  803849:	e8 99 d0 ff ff       	call   8008e7 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  80384e:	8b 55 08             	mov    0x8(%ebp),%edx
  803851:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803856:	29 c2                	sub    %eax,%edx
  803858:	89 d0                	mov    %edx,%eax
  80385a:	83 e0 07             	and    $0x7,%eax
  80385d:	85 c0                	test   %eax,%eax
  80385f:	74 17                	je     803878 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803861:	83 ec 04             	sub    $0x4,%esp
  803864:	68 4c 4d 80 00       	push   $0x804d4c
  803869:	68 ea 00 00 00       	push   $0xea
  80386e:	68 ff 4b 80 00       	push   $0x804bff
  803873:	e8 6f d0 ff ff       	call   8008e7 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  803878:	8b 45 08             	mov    0x8(%ebp),%eax
  80387b:	83 ec 0c             	sub    $0xc,%esp
  80387e:	50                   	push   %eax
  80387f:	e8 63 f7 ff ff       	call   802fe7 <to_page_info>
  803884:	83 c4 10             	add    $0x10,%esp
  803887:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  80388a:	83 ec 0c             	sub    $0xc,%esp
  80388d:	ff 75 08             	pushl  0x8(%ebp)
  803890:	e8 87 f9 ff ff       	call   80321c <get_block_size>
  803895:	83 c4 10             	add    $0x10,%esp
  803898:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  80389b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80389f:	75 17                	jne    8038b8 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8038a1:	83 ec 04             	sub    $0x4,%esp
  8038a4:	68 78 4d 80 00       	push   $0x804d78
  8038a9:	68 f1 00 00 00       	push   $0xf1
  8038ae:	68 ff 4b 80 00       	push   $0x804bff
  8038b3:	e8 2f d0 ff ff       	call   8008e7 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8038b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038bb:	83 ec 0c             	sub    $0xc,%esp
  8038be:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8038c1:	52                   	push   %edx
  8038c2:	89 c1                	mov    %eax,%ecx
  8038c4:	e8 e2 fe ff ff       	call   8037ab <log2_ceil.1547>
  8038c9:	83 c4 10             	add    $0x10,%esp
  8038cc:	83 e8 03             	sub    $0x3,%eax
  8038cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8038d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8038d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8038dc:	75 17                	jne    8038f5 <free_block+0x117>
  8038de:	83 ec 04             	sub    $0x4,%esp
  8038e1:	68 c4 4d 80 00       	push   $0x804dc4
  8038e6:	68 f6 00 00 00       	push   $0xf6
  8038eb:	68 ff 4b 80 00       	push   $0x804bff
  8038f0:	e8 f2 cf ff ff       	call   8008e7 <_panic>
  8038f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f8:	c1 e0 04             	shl    $0x4,%eax
  8038fb:	05 80 d0 81 00       	add    $0x81d080,%eax
  803900:	8b 10                	mov    (%eax),%edx
  803902:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803905:	89 10                	mov    %edx,(%eax)
  803907:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80390a:	8b 00                	mov    (%eax),%eax
  80390c:	85 c0                	test   %eax,%eax
  80390e:	74 15                	je     803925 <free_block+0x147>
  803910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803913:	c1 e0 04             	shl    $0x4,%eax
  803916:	05 80 d0 81 00       	add    $0x81d080,%eax
  80391b:	8b 00                	mov    (%eax),%eax
  80391d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803920:	89 50 04             	mov    %edx,0x4(%eax)
  803923:	eb 11                	jmp    803936 <free_block+0x158>
  803925:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803928:	c1 e0 04             	shl    $0x4,%eax
  80392b:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803931:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803934:	89 02                	mov    %eax,(%edx)
  803936:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803939:	c1 e0 04             	shl    $0x4,%eax
  80393c:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803942:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803945:	89 02                	mov    %eax,(%edx)
  803947:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80394a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803951:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803954:	c1 e0 04             	shl    $0x4,%eax
  803957:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80395c:	8b 00                	mov    (%eax),%eax
  80395e:	8d 50 01             	lea    0x1(%eax),%edx
  803961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803964:	c1 e0 04             	shl    $0x4,%eax
  803967:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80396c:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  80396e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803971:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803975:	40                   	inc    %eax
  803976:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803979:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  80397d:	8b 55 08             	mov    0x8(%ebp),%edx
  803980:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803985:	29 c2                	sub    %eax,%edx
  803987:	89 d0                	mov    %edx,%eax
  803989:	c1 e8 0c             	shr    $0xc,%eax
  80398c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  80398f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803992:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803996:	0f b7 c8             	movzwl %ax,%ecx
  803999:	b8 00 10 00 00       	mov    $0x1000,%eax
  80399e:	99                   	cltd   
  80399f:	f7 7d e8             	idivl  -0x18(%ebp)
  8039a2:	39 c1                	cmp    %eax,%ecx
  8039a4:	0f 85 b8 01 00 00    	jne    803b62 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8039aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8039b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b4:	c1 e0 04             	shl    $0x4,%eax
  8039b7:	05 80 d0 81 00       	add    $0x81d080,%eax
  8039bc:	8b 00                	mov    (%eax),%eax
  8039be:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8039c1:	e9 d5 00 00 00       	jmp    803a9b <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  8039c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c9:	8b 00                	mov    (%eax),%eax
  8039cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  8039ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039d1:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8039d6:	29 c2                	sub    %eax,%edx
  8039d8:	89 d0                	mov    %edx,%eax
  8039da:	c1 e8 0c             	shr    $0xc,%eax
  8039dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  8039e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039e3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8039e6:	0f 85 a9 00 00 00    	jne    803a95 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  8039ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039f0:	75 17                	jne    803a09 <free_block+0x22b>
  8039f2:	83 ec 04             	sub    $0x4,%esp
  8039f5:	68 99 4c 80 00       	push   $0x804c99
  8039fa:	68 04 01 00 00       	push   $0x104
  8039ff:	68 ff 4b 80 00       	push   $0x804bff
  803a04:	e8 de ce ff ff       	call   8008e7 <_panic>
  803a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a0c:	8b 00                	mov    (%eax),%eax
  803a0e:	85 c0                	test   %eax,%eax
  803a10:	74 10                	je     803a22 <free_block+0x244>
  803a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a15:	8b 00                	mov    (%eax),%eax
  803a17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a1a:	8b 52 04             	mov    0x4(%edx),%edx
  803a1d:	89 50 04             	mov    %edx,0x4(%eax)
  803a20:	eb 14                	jmp    803a36 <free_block+0x258>
  803a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a25:	8b 40 04             	mov    0x4(%eax),%eax
  803a28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a2b:	c1 e2 04             	shl    $0x4,%edx
  803a2e:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803a34:	89 02                	mov    %eax,(%edx)
  803a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a39:	8b 40 04             	mov    0x4(%eax),%eax
  803a3c:	85 c0                	test   %eax,%eax
  803a3e:	74 0f                	je     803a4f <free_block+0x271>
  803a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a43:	8b 40 04             	mov    0x4(%eax),%eax
  803a46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a49:	8b 12                	mov    (%edx),%edx
  803a4b:	89 10                	mov    %edx,(%eax)
  803a4d:	eb 13                	jmp    803a62 <free_block+0x284>
  803a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a52:	8b 00                	mov    (%eax),%eax
  803a54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a57:	c1 e2 04             	shl    $0x4,%edx
  803a5a:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803a60:	89 02                	mov    %eax,(%edx)
  803a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a78:	c1 e0 04             	shl    $0x4,%eax
  803a7b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803a80:	8b 00                	mov    (%eax),%eax
  803a82:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a88:	c1 e0 04             	shl    $0x4,%eax
  803a8b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803a90:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803a92:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803a95:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803a9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a9f:	0f 85 21 ff ff ff    	jne    8039c6 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803aa5:	b8 00 10 00 00       	mov    $0x1000,%eax
  803aaa:	99                   	cltd   
  803aab:	f7 7d e8             	idivl  -0x18(%ebp)
  803aae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803ab1:	74 17                	je     803aca <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803ab3:	83 ec 04             	sub    $0x4,%esp
  803ab6:	68 e8 4d 80 00       	push   $0x804de8
  803abb:	68 0c 01 00 00       	push   $0x10c
  803ac0:	68 ff 4b 80 00       	push   $0x804bff
  803ac5:	e8 1d ce ff ff       	call   8008e7 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803acd:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ad6:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803adc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ae0:	75 17                	jne    803af9 <free_block+0x31b>
  803ae2:	83 ec 04             	sub    $0x4,%esp
  803ae5:	68 b8 4c 80 00       	push   $0x804cb8
  803aea:	68 11 01 00 00       	push   $0x111
  803aef:	68 ff 4b 80 00       	push   $0x804bff
  803af4:	e8 ee cd ff ff       	call   8008e7 <_panic>
  803af9:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b02:	89 50 04             	mov    %edx,0x4(%eax)
  803b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b08:	8b 40 04             	mov    0x4(%eax),%eax
  803b0b:	85 c0                	test   %eax,%eax
  803b0d:	74 0c                	je     803b1b <free_block+0x33d>
  803b0f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803b14:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b17:	89 10                	mov    %edx,(%eax)
  803b19:	eb 08                	jmp    803b23 <free_block+0x345>
  803b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b1e:	a3 48 50 80 00       	mov    %eax,0x805048
  803b23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b26:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803b2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b34:	a1 54 50 80 00       	mov    0x805054,%eax
  803b39:	40                   	inc    %eax
  803b3a:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803b3f:	83 ec 0c             	sub    $0xc,%esp
  803b42:	ff 75 ec             	pushl  -0x14(%ebp)
  803b45:	e8 2b f4 ff ff       	call   802f75 <to_page_va>
  803b4a:	83 c4 10             	add    $0x10,%esp
  803b4d:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803b50:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b53:	83 ec 0c             	sub    $0xc,%esp
  803b56:	50                   	push   %eax
  803b57:	e8 69 e8 ff ff       	call   8023c5 <return_page>
  803b5c:	83 c4 10             	add    $0x10,%esp
  803b5f:	eb 01                	jmp    803b62 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803b61:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803b62:	c9                   	leave  
  803b63:	c3                   	ret    

00803b64 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803b64:	55                   	push   %ebp
  803b65:	89 e5                	mov    %esp,%ebp
  803b67:	83 ec 14             	sub    $0x14,%esp
  803b6a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803b6d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803b71:	77 07                	ja     803b7a <nearest_pow2_ceil.1572+0x16>
      return 1;
  803b73:	b8 01 00 00 00       	mov    $0x1,%eax
  803b78:	eb 20                	jmp    803b9a <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803b7a:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803b81:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803b84:	eb 08                	jmp    803b8e <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803b86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803b89:	01 c0                	add    %eax,%eax
  803b8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803b8e:	d1 6d 08             	shrl   0x8(%ebp)
  803b91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b95:	75 ef                	jne    803b86 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803b97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803b9a:	c9                   	leave  
  803b9b:	c3                   	ret    

00803b9c <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803b9c:	55                   	push   %ebp
  803b9d:	89 e5                	mov    %esp,%ebp
  803b9f:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803ba2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ba6:	75 13                	jne    803bbb <realloc_block+0x1f>
    return alloc_block(new_size);
  803ba8:	83 ec 0c             	sub    $0xc,%esp
  803bab:	ff 75 0c             	pushl  0xc(%ebp)
  803bae:	e8 d1 f6 ff ff       	call   803284 <alloc_block>
  803bb3:	83 c4 10             	add    $0x10,%esp
  803bb6:	e9 d9 00 00 00       	jmp    803c94 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803bbb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803bbf:	75 18                	jne    803bd9 <realloc_block+0x3d>
    free_block(va);
  803bc1:	83 ec 0c             	sub    $0xc,%esp
  803bc4:	ff 75 08             	pushl  0x8(%ebp)
  803bc7:	e8 12 fc ff ff       	call   8037de <free_block>
  803bcc:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd4:	e9 bb 00 00 00       	jmp    803c94 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803bd9:	83 ec 0c             	sub    $0xc,%esp
  803bdc:	ff 75 08             	pushl  0x8(%ebp)
  803bdf:	e8 38 f6 ff ff       	call   80321c <get_block_size>
  803be4:	83 c4 10             	add    $0x10,%esp
  803be7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803bea:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bf4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803bf7:	73 06                	jae    803bff <realloc_block+0x63>
    new_size = min_block_size;
  803bf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bfc:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803bff:	83 ec 0c             	sub    $0xc,%esp
  803c02:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803c05:	ff 75 0c             	pushl  0xc(%ebp)
  803c08:	89 c1                	mov    %eax,%ecx
  803c0a:	e8 55 ff ff ff       	call   803b64 <nearest_pow2_ceil.1572>
  803c0f:	83 c4 10             	add    $0x10,%esp
  803c12:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803c15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c18:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803c1b:	75 05                	jne    803c22 <realloc_block+0x86>
    return va;
  803c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c20:	eb 72                	jmp    803c94 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803c22:	83 ec 0c             	sub    $0xc,%esp
  803c25:	ff 75 0c             	pushl  0xc(%ebp)
  803c28:	e8 57 f6 ff ff       	call   803284 <alloc_block>
  803c2d:	83 c4 10             	add    $0x10,%esp
  803c30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803c33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c37:	75 07                	jne    803c40 <realloc_block+0xa4>
    return NULL;
  803c39:	b8 00 00 00 00       	mov    $0x0,%eax
  803c3e:	eb 54                	jmp    803c94 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803c40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c46:	39 d0                	cmp    %edx,%eax
  803c48:	76 02                	jbe    803c4c <realloc_block+0xb0>
  803c4a:	89 d0                	mov    %edx,%eax
  803c4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c52:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c58:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803c5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803c62:	eb 17                	jmp    803c7b <realloc_block+0xdf>
    dst[i] = src[i];
  803c64:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c6a:	01 c2                	add    %eax,%edx
  803c6c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c72:	01 c8                	add    %ecx,%eax
  803c74:	8a 00                	mov    (%eax),%al
  803c76:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803c78:	ff 45 f4             	incl   -0xc(%ebp)
  803c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803c81:	72 e1                	jb     803c64 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803c83:	83 ec 0c             	sub    $0xc,%esp
  803c86:	ff 75 08             	pushl  0x8(%ebp)
  803c89:	e8 50 fb ff ff       	call   8037de <free_block>
  803c8e:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803c94:	c9                   	leave  
  803c95:	c3                   	ret    
  803c96:	66 90                	xchg   %ax,%ax

00803c98 <__udivdi3>:
  803c98:	55                   	push   %ebp
  803c99:	57                   	push   %edi
  803c9a:	56                   	push   %esi
  803c9b:	53                   	push   %ebx
  803c9c:	83 ec 1c             	sub    $0x1c,%esp
  803c9f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ca3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ca7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803caf:	89 ca                	mov    %ecx,%edx
  803cb1:	89 f8                	mov    %edi,%eax
  803cb3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803cb7:	85 f6                	test   %esi,%esi
  803cb9:	75 2d                	jne    803ce8 <__udivdi3+0x50>
  803cbb:	39 cf                	cmp    %ecx,%edi
  803cbd:	77 65                	ja     803d24 <__udivdi3+0x8c>
  803cbf:	89 fd                	mov    %edi,%ebp
  803cc1:	85 ff                	test   %edi,%edi
  803cc3:	75 0b                	jne    803cd0 <__udivdi3+0x38>
  803cc5:	b8 01 00 00 00       	mov    $0x1,%eax
  803cca:	31 d2                	xor    %edx,%edx
  803ccc:	f7 f7                	div    %edi
  803cce:	89 c5                	mov    %eax,%ebp
  803cd0:	31 d2                	xor    %edx,%edx
  803cd2:	89 c8                	mov    %ecx,%eax
  803cd4:	f7 f5                	div    %ebp
  803cd6:	89 c1                	mov    %eax,%ecx
  803cd8:	89 d8                	mov    %ebx,%eax
  803cda:	f7 f5                	div    %ebp
  803cdc:	89 cf                	mov    %ecx,%edi
  803cde:	89 fa                	mov    %edi,%edx
  803ce0:	83 c4 1c             	add    $0x1c,%esp
  803ce3:	5b                   	pop    %ebx
  803ce4:	5e                   	pop    %esi
  803ce5:	5f                   	pop    %edi
  803ce6:	5d                   	pop    %ebp
  803ce7:	c3                   	ret    
  803ce8:	39 ce                	cmp    %ecx,%esi
  803cea:	77 28                	ja     803d14 <__udivdi3+0x7c>
  803cec:	0f bd fe             	bsr    %esi,%edi
  803cef:	83 f7 1f             	xor    $0x1f,%edi
  803cf2:	75 40                	jne    803d34 <__udivdi3+0x9c>
  803cf4:	39 ce                	cmp    %ecx,%esi
  803cf6:	72 0a                	jb     803d02 <__udivdi3+0x6a>
  803cf8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803cfc:	0f 87 9e 00 00 00    	ja     803da0 <__udivdi3+0x108>
  803d02:	b8 01 00 00 00       	mov    $0x1,%eax
  803d07:	89 fa                	mov    %edi,%edx
  803d09:	83 c4 1c             	add    $0x1c,%esp
  803d0c:	5b                   	pop    %ebx
  803d0d:	5e                   	pop    %esi
  803d0e:	5f                   	pop    %edi
  803d0f:	5d                   	pop    %ebp
  803d10:	c3                   	ret    
  803d11:	8d 76 00             	lea    0x0(%esi),%esi
  803d14:	31 ff                	xor    %edi,%edi
  803d16:	31 c0                	xor    %eax,%eax
  803d18:	89 fa                	mov    %edi,%edx
  803d1a:	83 c4 1c             	add    $0x1c,%esp
  803d1d:	5b                   	pop    %ebx
  803d1e:	5e                   	pop    %esi
  803d1f:	5f                   	pop    %edi
  803d20:	5d                   	pop    %ebp
  803d21:	c3                   	ret    
  803d22:	66 90                	xchg   %ax,%ax
  803d24:	89 d8                	mov    %ebx,%eax
  803d26:	f7 f7                	div    %edi
  803d28:	31 ff                	xor    %edi,%edi
  803d2a:	89 fa                	mov    %edi,%edx
  803d2c:	83 c4 1c             	add    $0x1c,%esp
  803d2f:	5b                   	pop    %ebx
  803d30:	5e                   	pop    %esi
  803d31:	5f                   	pop    %edi
  803d32:	5d                   	pop    %ebp
  803d33:	c3                   	ret    
  803d34:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d39:	89 eb                	mov    %ebp,%ebx
  803d3b:	29 fb                	sub    %edi,%ebx
  803d3d:	89 f9                	mov    %edi,%ecx
  803d3f:	d3 e6                	shl    %cl,%esi
  803d41:	89 c5                	mov    %eax,%ebp
  803d43:	88 d9                	mov    %bl,%cl
  803d45:	d3 ed                	shr    %cl,%ebp
  803d47:	89 e9                	mov    %ebp,%ecx
  803d49:	09 f1                	or     %esi,%ecx
  803d4b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d4f:	89 f9                	mov    %edi,%ecx
  803d51:	d3 e0                	shl    %cl,%eax
  803d53:	89 c5                	mov    %eax,%ebp
  803d55:	89 d6                	mov    %edx,%esi
  803d57:	88 d9                	mov    %bl,%cl
  803d59:	d3 ee                	shr    %cl,%esi
  803d5b:	89 f9                	mov    %edi,%ecx
  803d5d:	d3 e2                	shl    %cl,%edx
  803d5f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d63:	88 d9                	mov    %bl,%cl
  803d65:	d3 e8                	shr    %cl,%eax
  803d67:	09 c2                	or     %eax,%edx
  803d69:	89 d0                	mov    %edx,%eax
  803d6b:	89 f2                	mov    %esi,%edx
  803d6d:	f7 74 24 0c          	divl   0xc(%esp)
  803d71:	89 d6                	mov    %edx,%esi
  803d73:	89 c3                	mov    %eax,%ebx
  803d75:	f7 e5                	mul    %ebp
  803d77:	39 d6                	cmp    %edx,%esi
  803d79:	72 19                	jb     803d94 <__udivdi3+0xfc>
  803d7b:	74 0b                	je     803d88 <__udivdi3+0xf0>
  803d7d:	89 d8                	mov    %ebx,%eax
  803d7f:	31 ff                	xor    %edi,%edi
  803d81:	e9 58 ff ff ff       	jmp    803cde <__udivdi3+0x46>
  803d86:	66 90                	xchg   %ax,%ax
  803d88:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d8c:	89 f9                	mov    %edi,%ecx
  803d8e:	d3 e2                	shl    %cl,%edx
  803d90:	39 c2                	cmp    %eax,%edx
  803d92:	73 e9                	jae    803d7d <__udivdi3+0xe5>
  803d94:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d97:	31 ff                	xor    %edi,%edi
  803d99:	e9 40 ff ff ff       	jmp    803cde <__udivdi3+0x46>
  803d9e:	66 90                	xchg   %ax,%ax
  803da0:	31 c0                	xor    %eax,%eax
  803da2:	e9 37 ff ff ff       	jmp    803cde <__udivdi3+0x46>
  803da7:	90                   	nop

00803da8 <__umoddi3>:
  803da8:	55                   	push   %ebp
  803da9:	57                   	push   %edi
  803daa:	56                   	push   %esi
  803dab:	53                   	push   %ebx
  803dac:	83 ec 1c             	sub    $0x1c,%esp
  803daf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803db3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803db7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803dbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803dbf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803dc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803dc7:	89 f3                	mov    %esi,%ebx
  803dc9:	89 fa                	mov    %edi,%edx
  803dcb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dcf:	89 34 24             	mov    %esi,(%esp)
  803dd2:	85 c0                	test   %eax,%eax
  803dd4:	75 1a                	jne    803df0 <__umoddi3+0x48>
  803dd6:	39 f7                	cmp    %esi,%edi
  803dd8:	0f 86 a2 00 00 00    	jbe    803e80 <__umoddi3+0xd8>
  803dde:	89 c8                	mov    %ecx,%eax
  803de0:	89 f2                	mov    %esi,%edx
  803de2:	f7 f7                	div    %edi
  803de4:	89 d0                	mov    %edx,%eax
  803de6:	31 d2                	xor    %edx,%edx
  803de8:	83 c4 1c             	add    $0x1c,%esp
  803deb:	5b                   	pop    %ebx
  803dec:	5e                   	pop    %esi
  803ded:	5f                   	pop    %edi
  803dee:	5d                   	pop    %ebp
  803def:	c3                   	ret    
  803df0:	39 f0                	cmp    %esi,%eax
  803df2:	0f 87 ac 00 00 00    	ja     803ea4 <__umoddi3+0xfc>
  803df8:	0f bd e8             	bsr    %eax,%ebp
  803dfb:	83 f5 1f             	xor    $0x1f,%ebp
  803dfe:	0f 84 ac 00 00 00    	je     803eb0 <__umoddi3+0x108>
  803e04:	bf 20 00 00 00       	mov    $0x20,%edi
  803e09:	29 ef                	sub    %ebp,%edi
  803e0b:	89 fe                	mov    %edi,%esi
  803e0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e11:	89 e9                	mov    %ebp,%ecx
  803e13:	d3 e0                	shl    %cl,%eax
  803e15:	89 d7                	mov    %edx,%edi
  803e17:	89 f1                	mov    %esi,%ecx
  803e19:	d3 ef                	shr    %cl,%edi
  803e1b:	09 c7                	or     %eax,%edi
  803e1d:	89 e9                	mov    %ebp,%ecx
  803e1f:	d3 e2                	shl    %cl,%edx
  803e21:	89 14 24             	mov    %edx,(%esp)
  803e24:	89 d8                	mov    %ebx,%eax
  803e26:	d3 e0                	shl    %cl,%eax
  803e28:	89 c2                	mov    %eax,%edx
  803e2a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e2e:	d3 e0                	shl    %cl,%eax
  803e30:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e34:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e38:	89 f1                	mov    %esi,%ecx
  803e3a:	d3 e8                	shr    %cl,%eax
  803e3c:	09 d0                	or     %edx,%eax
  803e3e:	d3 eb                	shr    %cl,%ebx
  803e40:	89 da                	mov    %ebx,%edx
  803e42:	f7 f7                	div    %edi
  803e44:	89 d3                	mov    %edx,%ebx
  803e46:	f7 24 24             	mull   (%esp)
  803e49:	89 c6                	mov    %eax,%esi
  803e4b:	89 d1                	mov    %edx,%ecx
  803e4d:	39 d3                	cmp    %edx,%ebx
  803e4f:	0f 82 87 00 00 00    	jb     803edc <__umoddi3+0x134>
  803e55:	0f 84 91 00 00 00    	je     803eec <__umoddi3+0x144>
  803e5b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e5f:	29 f2                	sub    %esi,%edx
  803e61:	19 cb                	sbb    %ecx,%ebx
  803e63:	89 d8                	mov    %ebx,%eax
  803e65:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e69:	d3 e0                	shl    %cl,%eax
  803e6b:	89 e9                	mov    %ebp,%ecx
  803e6d:	d3 ea                	shr    %cl,%edx
  803e6f:	09 d0                	or     %edx,%eax
  803e71:	89 e9                	mov    %ebp,%ecx
  803e73:	d3 eb                	shr    %cl,%ebx
  803e75:	89 da                	mov    %ebx,%edx
  803e77:	83 c4 1c             	add    $0x1c,%esp
  803e7a:	5b                   	pop    %ebx
  803e7b:	5e                   	pop    %esi
  803e7c:	5f                   	pop    %edi
  803e7d:	5d                   	pop    %ebp
  803e7e:	c3                   	ret    
  803e7f:	90                   	nop
  803e80:	89 fd                	mov    %edi,%ebp
  803e82:	85 ff                	test   %edi,%edi
  803e84:	75 0b                	jne    803e91 <__umoddi3+0xe9>
  803e86:	b8 01 00 00 00       	mov    $0x1,%eax
  803e8b:	31 d2                	xor    %edx,%edx
  803e8d:	f7 f7                	div    %edi
  803e8f:	89 c5                	mov    %eax,%ebp
  803e91:	89 f0                	mov    %esi,%eax
  803e93:	31 d2                	xor    %edx,%edx
  803e95:	f7 f5                	div    %ebp
  803e97:	89 c8                	mov    %ecx,%eax
  803e99:	f7 f5                	div    %ebp
  803e9b:	89 d0                	mov    %edx,%eax
  803e9d:	e9 44 ff ff ff       	jmp    803de6 <__umoddi3+0x3e>
  803ea2:	66 90                	xchg   %ax,%ax
  803ea4:	89 c8                	mov    %ecx,%eax
  803ea6:	89 f2                	mov    %esi,%edx
  803ea8:	83 c4 1c             	add    $0x1c,%esp
  803eab:	5b                   	pop    %ebx
  803eac:	5e                   	pop    %esi
  803ead:	5f                   	pop    %edi
  803eae:	5d                   	pop    %ebp
  803eaf:	c3                   	ret    
  803eb0:	3b 04 24             	cmp    (%esp),%eax
  803eb3:	72 06                	jb     803ebb <__umoddi3+0x113>
  803eb5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803eb9:	77 0f                	ja     803eca <__umoddi3+0x122>
  803ebb:	89 f2                	mov    %esi,%edx
  803ebd:	29 f9                	sub    %edi,%ecx
  803ebf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ec3:	89 14 24             	mov    %edx,(%esp)
  803ec6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803eca:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ece:	8b 14 24             	mov    (%esp),%edx
  803ed1:	83 c4 1c             	add    $0x1c,%esp
  803ed4:	5b                   	pop    %ebx
  803ed5:	5e                   	pop    %esi
  803ed6:	5f                   	pop    %edi
  803ed7:	5d                   	pop    %ebp
  803ed8:	c3                   	ret    
  803ed9:	8d 76 00             	lea    0x0(%esi),%esi
  803edc:	2b 04 24             	sub    (%esp),%eax
  803edf:	19 fa                	sbb    %edi,%edx
  803ee1:	89 d1                	mov    %edx,%ecx
  803ee3:	89 c6                	mov    %eax,%esi
  803ee5:	e9 71 ff ff ff       	jmp    803e5b <__umoddi3+0xb3>
  803eea:	66 90                	xchg   %ax,%ax
  803eec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ef0:	72 ea                	jb     803edc <__umoddi3+0x134>
  803ef2:	89 d9                	mov    %ebx,%ecx
  803ef4:	e9 62 ff ff ff       	jmp    803e5b <__umoddi3+0xb3>
