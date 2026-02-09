
obj/user/ef_mergesort_leakage:     file format elf32-i386


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
  800031:	e8 48 07 00 00       	call   80077e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	char Line[255] ;
	char Chose ;
	int numOfRep = 0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{
		numOfRep++ ;
  800048:	ff 45 f0             	incl   -0x10(%ebp)
		//2012: lock the interrupt
		sys_lock_cons();
  80004b:	e8 28 28 00 00       	call   802878 <sys_lock_cons>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 40 3d 80 00       	push   $0x803d40
  800058:	e8 bf 0b 00 00       	call   800c1c <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 42 3d 80 00       	push   $0x803d42
  800068:	e8 af 0b 00 00       	call   800c1c <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 58 3d 80 00       	push   $0x803d58
  800078:	e8 9f 0b 00 00       	call   800c1c <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 42 3d 80 00       	push   $0x803d42
  800088:	e8 8f 0b 00 00       	call   800c1c <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 40 3d 80 00       	push   $0x803d40
  800098:	e8 7f 0b 00 00       	call   800c1c <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 70 3d 80 00       	push   $0x803d70
  8000a8:	e8 6f 0b 00 00       	call   800c1c <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp

		int NumOfElements ;

		if (numOfRep == 1)
  8000b0:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  8000b4:	75 09                	jne    8000bf <_main+0x87>
			NumOfElements = 32;
  8000b6:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
  8000bd:	eb 0d                	jmp    8000cc <_main+0x94>
		else if (numOfRep == 2)
  8000bf:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8000c3:	75 07                	jne    8000cc <_main+0x94>
			NumOfElements = 32;
  8000c5:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)

		cprintf("%d\n", NumOfElements) ;
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d2:	68 8f 3d 80 00       	push   $0x803d8f
  8000d7:	e8 40 0b 00 00       	call   800c1c <cprintf>
  8000dc:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e2:	c1 e0 02             	shl    $0x2,%eax
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	50                   	push   %eax
  8000e9:	e8 59 21 00 00       	call   802247 <malloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 94 3d 80 00       	push   $0x803d94
  8000fc:	e8 1b 0b 00 00       	call   800c1c <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 b6 3d 80 00       	push   $0x803db6
  80010c:	e8 0b 0b 00 00       	call   800c1c <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 c4 3d 80 00       	push   $0x803dc4
  80011c:	e8 fb 0a 00 00       	call   800c1c <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 d3 3d 80 00       	push   $0x803dd3
  80012c:	e8 eb 0a 00 00       	call   800c1c <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 e3 3d 80 00       	push   $0x803de3
  80013c:	e8 db 0a 00 00       	call   800c1c <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  800144:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800148:	75 06                	jne    800150 <_main+0x118>
				Chose = 'a' ;
  80014a:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
  80014e:	eb 0a                	jmp    80015a <_main+0x122>
			else if (numOfRep == 2)
  800150:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800154:	75 04                	jne    80015a <_main+0x122>
				Chose = 'c' ;
  800156:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80015a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	50                   	push   %eax
  800162:	e8 db 05 00 00       	call   800742 <cputchar>
  800167:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	6a 0a                	push   $0xa
  80016f:	e8 ce 05 00 00       	call   800742 <cputchar>
  800174:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800177:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80017b:	74 0c                	je     800189 <_main+0x151>
  80017d:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800181:	74 06                	je     800189 <_main+0x151>
  800183:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800187:	75 ab                	jne    800134 <_main+0xfc>

		//2012: lock the interrupt
		sys_unlock_cons();
  800189:	e8 04 27 00 00       	call   802892 <sys_unlock_cons>

		int  i ;
		switch (Chose)
  80018e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800192:	83 f8 62             	cmp    $0x62,%eax
  800195:	74 1d                	je     8001b4 <_main+0x17c>
  800197:	83 f8 63             	cmp    $0x63,%eax
  80019a:	74 2b                	je     8001c7 <_main+0x18f>
  80019c:	83 f8 61             	cmp    $0x61,%eax
  80019f:	75 39                	jne    8001da <_main+0x1a2>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 f9 01 00 00       	call   8003a8 <InitializeAscending>
  8001af:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b2:	eb 37                	jmp    8001eb <_main+0x1b3>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8001bd:	e8 17 02 00 00       	call   8003d9 <InitializeIdentical>
  8001c2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c5:	eb 24                	jmp    8001eb <_main+0x1b3>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d0:	e8 39 02 00 00       	call   80040e <InitializeSemiRandom>
  8001d5:	83 c4 10             	add    $0x10,%esp
			break ;
  8001d8:	eb 11                	jmp    8001eb <_main+0x1b3>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e3:	e8 26 02 00 00       	call   80040e <InitializeSemiRandom>
  8001e8:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f1:	6a 01                	push   $0x1
  8001f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f6:	e8 f2 02 00 00       	call   8004ed <MSort>
  8001fb:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001fe:	e8 75 26 00 00       	call   802878 <sys_lock_cons>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 ec 3d 80 00       	push   $0x803dec
  80020b:	e8 0c 0a 00 00       	call   800c1c <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_unlock_cons();
  800213:	e8 7a 26 00 00       	call   802892 <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	ff 75 ec             	pushl  -0x14(%ebp)
  80021e:	ff 75 e8             	pushl  -0x18(%ebp)
  800221:	e8 d8 00 00 00       	call   8002fe <CheckSorted>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  80022c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800230:	75 14                	jne    800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 20 3e 80 00       	push   $0x803e20
  80023a:	6a 58                	push   $0x58
  80023c:	68 42 3e 80 00       	push   $0x803e42
  800241:	e8 e8 06 00 00       	call   80092e <_panic>
		else
		{
			sys_lock_cons();
  800246:	e8 2d 26 00 00       	call   802878 <sys_lock_cons>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 60 3e 80 00       	push   $0x803e60
  800253:	e8 c4 09 00 00       	call   800c1c <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 94 3e 80 00       	push   $0x803e94
  800263:	e8 b4 09 00 00       	call   800c1c <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 c8 3e 80 00       	push   $0x803ec8
  800273:	e8 a4 09 00 00       	call   800c1c <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  80027b:	e8 12 26 00 00       	call   802892 <sys_unlock_cons>
		}

		//free(Elements) ;

		sys_lock_cons();
  800280:	e8 f3 25 00 00       	call   802878 <sys_lock_cons>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 fa 3e 80 00       	push   $0x803efa
  800293:	e8 84 09 00 00       	call   800c1c <cprintf>
  800298:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  80029b:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80029f:	75 06                	jne    8002a7 <_main+0x26f>
				Chose = 'y' ;
  8002a1:	c6 45 f7 79          	movb   $0x79,-0x9(%ebp)
  8002a5:	eb 0a                	jmp    8002b1 <_main+0x279>
			else if (numOfRep == 2)
  8002a7:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ab:	75 04                	jne    8002b1 <_main+0x279>
				Chose = 'n' ;
  8002ad:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  8002b1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	e8 84 04 00 00       	call   800742 <cputchar>
  8002be:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 0a                	push   $0xa
  8002c6:	e8 77 04 00 00       	call   800742 <cputchar>
  8002cb:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 0a                	push   $0xa
  8002d3:	e8 6a 04 00 00       	call   800742 <cputchar>
  8002d8:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_lock_cons();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  8002db:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002df:	74 06                	je     8002e7 <_main+0x2af>
  8002e1:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002e5:	75 a4                	jne    80028b <_main+0x253>
				Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_unlock_cons();
  8002e7:	e8 a6 25 00 00       	call   802892 <sys_unlock_cons>

	} while (Chose == 'y');
  8002ec:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002f0:	0f 84 52 fd ff ff    	je     800048 <_main+0x10>

	//To indicate that it's completed successfully
	inctst();
  8002f6:	e8 34 29 00 00       	call   802c2f <inctst>

}
  8002fb:	90                   	nop
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800304:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800312:	eb 33                	jmp    800347 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800314:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800317:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	01 d0                	add    %edx,%eax
  800323:	8b 10                	mov    (%eax),%edx
  800325:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800328:	40                   	inc    %eax
  800329:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	01 c8                	add    %ecx,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	39 c2                	cmp    %eax,%edx
  800339:	7e 09                	jle    800344 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80033b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800342:	eb 0c                	jmp    800350 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800344:	ff 45 f8             	incl   -0x8(%ebp)
  800347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034a:	48                   	dec    %eax
  80034b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80034e:	7f c4                	jg     800314 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800350:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800353:	c9                   	leave  
  800354:	c3                   	ret    

00800355 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80035b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	01 d0                	add    %edx,%eax
  80036a:	8b 00                	mov    (%eax),%eax
  80036c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80036f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	01 c2                	add    %eax,%edx
  80037e:	8b 45 10             	mov    0x10(%ebp),%eax
  800381:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 c8                	add    %ecx,%eax
  80038d:	8b 00                	mov    (%eax),%eax
  80038f:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800391:	8b 45 10             	mov    0x10(%ebp),%eax
  800394:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	01 c2                	add    %eax,%edx
  8003a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a3:	89 02                	mov    %eax,(%edx)
}
  8003a5:	90                   	nop
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b5:	eb 17                	jmp    8003ce <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8003b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	01 c2                	add    %eax,%edx
  8003c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c9:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003cb:	ff 45 fc             	incl   -0x4(%ebp)
  8003ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d4:	7c e1                	jl     8003b7 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003d6:	90                   	nop
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e6:	eb 1b                	jmp    800403 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c2                	add    %eax,%edx
  8003f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fa:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003fd:	48                   	dec    %eax
  8003fe:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800400:	ff 45 fc             	incl   -0x4(%ebp)
  800403:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800406:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800409:	7c dd                	jl     8003e8 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80040b:	90                   	nop
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800414:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800417:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80041c:	f7 e9                	imul   %ecx
  80041e:	c1 f9 1f             	sar    $0x1f,%ecx
  800421:	89 d0                	mov    %edx,%eax
  800423:	29 c8                	sub    %ecx,%eax
  800425:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  800428:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80042c:	75 07                	jne    800435 <InitializeSemiRandom+0x27>
			Repetition = 3;
  80042e:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80043c:	eb 1e                	jmp    80045c <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  80043e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80044e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800451:	99                   	cltd   
  800452:	f7 7d f8             	idivl  -0x8(%ebp)
  800455:	89 d0                	mov    %edx,%eax
  800457:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800459:	ff 45 fc             	incl   -0x4(%ebp)
  80045c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80045f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800462:	7c da                	jl     80043e <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800464:	90                   	nop
  800465:	c9                   	leave  
  800466:	c3                   	ret    

00800467 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
  80046a:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80046d:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800474:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80047b:	eb 42                	jmp    8004bf <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80047d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800480:	99                   	cltd   
  800481:	f7 7d f0             	idivl  -0x10(%ebp)
  800484:	89 d0                	mov    %edx,%eax
  800486:	85 c0                	test   %eax,%eax
  800488:	75 10                	jne    80049a <PrintElements+0x33>
			cprintf("\n");
  80048a:	83 ec 0c             	sub    $0xc,%esp
  80048d:	68 40 3d 80 00       	push   $0x803d40
  800492:	e8 85 07 00 00       	call   800c1c <cprintf>
  800497:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80049a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80049d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	01 d0                	add    %edx,%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	50                   	push   %eax
  8004af:	68 18 3f 80 00       	push   $0x803f18
  8004b4:	e8 63 07 00 00       	call   800c1c <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004bc:	ff 45 f4             	incl   -0xc(%ebp)
  8004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c2:	48                   	dec    %eax
  8004c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004c6:	7f b5                	jg     80047d <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8004c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	50                   	push   %eax
  8004dd:	68 8f 3d 80 00       	push   $0x803d8f
  8004e2:	e8 35 07 00 00       	call   800c1c <cprintf>
  8004e7:	83 c4 10             	add    $0x10,%esp

}
  8004ea:	90                   	nop
  8004eb:	c9                   	leave  
  8004ec:	c3                   	ret    

008004ed <MSort>:


void MSort(int* A, int p, int r)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004f9:	7d 54                	jge    80054f <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	89 c2                	mov    %eax,%edx
  800505:	c1 ea 1f             	shr    $0x1f,%edx
  800508:	01 d0                	add    %edx,%eax
  80050a:	d1 f8                	sar    %eax
  80050c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	ff 75 f4             	pushl  -0xc(%ebp)
  800515:	ff 75 0c             	pushl  0xc(%ebp)
  800518:	ff 75 08             	pushl  0x8(%ebp)
  80051b:	e8 cd ff ff ff       	call   8004ed <MSort>
  800520:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  800523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800526:	40                   	inc    %eax
  800527:	83 ec 04             	sub    $0x4,%esp
  80052a:	ff 75 10             	pushl  0x10(%ebp)
  80052d:	50                   	push   %eax
  80052e:	ff 75 08             	pushl  0x8(%ebp)
  800531:	e8 b7 ff ff ff       	call   8004ed <MSort>
  800536:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800539:	ff 75 10             	pushl  0x10(%ebp)
  80053c:	ff 75 f4             	pushl  -0xc(%ebp)
  80053f:	ff 75 0c             	pushl  0xc(%ebp)
  800542:	ff 75 08             	pushl  0x8(%ebp)
  800545:	e8 08 00 00 00       	call   800552 <Merge>
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	eb 01                	jmp    800550 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80054f:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800550:	c9                   	leave  
  800551:	c3                   	ret    

00800552 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800558:	8b 45 10             	mov    0x10(%ebp),%eax
  80055b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80055e:	40                   	inc    %eax
  80055f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	2b 45 10             	sub    0x10(%ebp),%eax
  800568:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  80056b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800572:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800579:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057c:	c1 e0 02             	shl    $0x2,%eax
  80057f:	83 ec 0c             	sub    $0xc,%esp
  800582:	50                   	push   %eax
  800583:	e8 bf 1c 00 00       	call   802247 <malloc>
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80058e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800591:	c1 e0 02             	shl    $0x2,%eax
  800594:	83 ec 0c             	sub    $0xc,%esp
  800597:	50                   	push   %eax
  800598:	e8 aa 1c 00 00       	call   802247 <malloc>
  80059d:	83 c4 10             	add    $0x10,%esp
  8005a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8005aa:	eb 2f                	jmp    8005db <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8005ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b9:	01 c2                	add    %eax,%edx
  8005bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005c1:	01 c8                	add    %ecx,%eax
  8005c3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005c8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d2:	01 c8                	add    %ecx,%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005d8:	ff 45 ec             	incl   -0x14(%ebp)
  8005db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e1:	7c c9                	jl     8005ac <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005ea:	eb 2a                	jmp    800616 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005f9:	01 c2                	add    %eax,%edx
  8005fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800601:	01 c8                	add    %ecx,%eax
  800603:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80060a:	8b 45 08             	mov    0x8(%ebp),%eax
  80060d:	01 c8                	add    %ecx,%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800613:	ff 45 e8             	incl   -0x18(%ebp)
  800616:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800619:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80061c:	7c ce                	jl     8005ec <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80061e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800621:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800624:	e9 0a 01 00 00       	jmp    800733 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  800629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80062c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80062f:	0f 8d 95 00 00 00    	jge    8006ca <Merge+0x178>
  800635:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800638:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80063b:	0f 8d 89 00 00 00    	jge    8006ca <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800644:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	8b 10                	mov    (%eax),%edx
  800652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800655:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80065c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80065f:	01 c8                	add    %ecx,%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	39 c2                	cmp    %eax,%edx
  800665:	7d 33                	jge    80069a <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80066a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80066f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80067c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067f:	8d 50 01             	lea    0x1(%eax),%edx
  800682:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800685:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80068c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80068f:	01 d0                	add    %edx,%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800695:	e9 96 00 00 00       	jmp    800730 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  80069a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069d:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b2:	8d 50 01             	lea    0x1(%eax),%edx
  8006b5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006c2:	01 d0                	add    %edx,%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8006c8:	eb 66                	jmp    800730 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8006ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006cd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006d0:	7d 30                	jge    800702 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8006d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d5:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006ea:	8d 50 01             	lea    0x1(%eax),%edx
  8006ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006fa:	01 d0                	add    %edx,%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	89 01                	mov    %eax,(%ecx)
  800700:	eb 2e                	jmp    800730 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800705:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80070a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071a:	8d 50 01             	lea    0x1(%eax),%edx
  80071d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800720:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800727:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80072a:	01 d0                	add    %edx,%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800730:	ff 45 e4             	incl   -0x1c(%ebp)
  800733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800736:	3b 45 14             	cmp    0x14(%ebp),%eax
  800739:	0f 8e ea fe ff ff    	jle    800629 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  80073f:	90                   	nop
  800740:	c9                   	leave  
  800741:	c3                   	ret    

00800742 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80074e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800752:	83 ec 0c             	sub    $0xc,%esp
  800755:	50                   	push   %eax
  800756:	e8 65 22 00 00       	call   8029c0 <sys_cputc>
  80075b:	83 c4 10             	add    $0x10,%esp
}
  80075e:	90                   	nop
  80075f:	c9                   	leave  
  800760:	c3                   	ret    

00800761 <getchar>:


int
getchar(void)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800767:	e8 f3 20 00 00       	call   80285f <sys_cgetc>
  80076c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  80076f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800772:	c9                   	leave  
  800773:	c3                   	ret    

00800774 <iscons>:

int iscons(int fdnum)
{
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800777:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80077c:	5d                   	pop    %ebp
  80077d:	c3                   	ret    

0080077e <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	57                   	push   %edi
  800782:	56                   	push   %esi
  800783:	53                   	push   %ebx
  800784:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800787:	e8 65 23 00 00       	call   802af1 <sys_getenvindex>
  80078c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80078f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	01 c0                	add    %eax,%eax
  800796:	01 d0                	add    %edx,%eax
  800798:	c1 e0 02             	shl    $0x2,%eax
  80079b:	01 d0                	add    %edx,%eax
  80079d:	c1 e0 02             	shl    $0x2,%eax
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	c1 e0 03             	shl    $0x3,%eax
  8007a5:	01 d0                	add    %edx,%eax
  8007a7:	c1 e0 02             	shl    $0x2,%eax
  8007aa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007af:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007b4:	a1 24 50 80 00       	mov    0x805024,%eax
  8007b9:	8a 40 20             	mov    0x20(%eax),%al
  8007bc:	84 c0                	test   %al,%al
  8007be:	74 0d                	je     8007cd <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8007c0:	a1 24 50 80 00       	mov    0x805024,%eax
  8007c5:	83 c0 20             	add    $0x20,%eax
  8007c8:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007d1:	7e 0a                	jle    8007dd <libmain+0x5f>
		binaryname = argv[0];
  8007d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	ff 75 0c             	pushl  0xc(%ebp)
  8007e3:	ff 75 08             	pushl  0x8(%ebp)
  8007e6:	e8 4d f8 ff ff       	call   800038 <_main>
  8007eb:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007ee:	a1 00 50 80 00       	mov    0x805000,%eax
  8007f3:	85 c0                	test   %eax,%eax
  8007f5:	0f 84 01 01 00 00    	je     8008fc <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007fb:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800801:	bb 18 40 80 00       	mov    $0x804018,%ebx
  800806:	ba 0e 00 00 00       	mov    $0xe,%edx
  80080b:	89 c7                	mov    %eax,%edi
  80080d:	89 de                	mov    %ebx,%esi
  80080f:	89 d1                	mov    %edx,%ecx
  800811:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800813:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800816:	b9 56 00 00 00       	mov    $0x56,%ecx
  80081b:	b0 00                	mov    $0x0,%al
  80081d:	89 d7                	mov    %edx,%edi
  80081f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800821:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800828:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	50                   	push   %eax
  80082f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800835:	50                   	push   %eax
  800836:	e8 ec 24 00 00       	call   802d27 <sys_utilities>
  80083b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80083e:	e8 35 20 00 00       	call   802878 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800843:	83 ec 0c             	sub    $0xc,%esp
  800846:	68 38 3f 80 00       	push   $0x803f38
  80084b:	e8 cc 03 00 00       	call   800c1c <cprintf>
  800850:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800856:	85 c0                	test   %eax,%eax
  800858:	74 18                	je     800872 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80085a:	e8 e6 24 00 00       	call   802d45 <sys_get_optimal_num_faults>
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	50                   	push   %eax
  800863:	68 60 3f 80 00       	push   $0x803f60
  800868:	e8 af 03 00 00       	call   800c1c <cprintf>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	eb 59                	jmp    8008cb <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800872:	a1 24 50 80 00       	mov    0x805024,%eax
  800877:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80087d:	a1 24 50 80 00       	mov    0x805024,%eax
  800882:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800888:	83 ec 04             	sub    $0x4,%esp
  80088b:	52                   	push   %edx
  80088c:	50                   	push   %eax
  80088d:	68 84 3f 80 00       	push   $0x803f84
  800892:	e8 85 03 00 00       	call   800c1c <cprintf>
  800897:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80089a:	a1 24 50 80 00       	mov    0x805024,%eax
  80089f:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8008a5:	a1 24 50 80 00       	mov    0x805024,%eax
  8008aa:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8008b0:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b5:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8008bb:	51                   	push   %ecx
  8008bc:	52                   	push   %edx
  8008bd:	50                   	push   %eax
  8008be:	68 ac 3f 80 00       	push   $0x803fac
  8008c3:	e8 54 03 00 00       	call   800c1c <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008cb:	a1 24 50 80 00       	mov    0x805024,%eax
  8008d0:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8008d6:	83 ec 08             	sub    $0x8,%esp
  8008d9:	50                   	push   %eax
  8008da:	68 04 40 80 00       	push   $0x804004
  8008df:	e8 38 03 00 00       	call   800c1c <cprintf>
  8008e4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008e7:	83 ec 0c             	sub    $0xc,%esp
  8008ea:	68 38 3f 80 00       	push   $0x803f38
  8008ef:	e8 28 03 00 00       	call   800c1c <cprintf>
  8008f4:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008f7:	e8 96 1f 00 00       	call   802892 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008fc:	e8 1f 00 00 00       	call   800920 <exit>
}
  800901:	90                   	nop
  800902:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800905:	5b                   	pop    %ebx
  800906:	5e                   	pop    %esi
  800907:	5f                   	pop    %edi
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800910:	83 ec 0c             	sub    $0xc,%esp
  800913:	6a 00                	push   $0x0
  800915:	e8 a3 21 00 00       	call   802abd <sys_destroy_env>
  80091a:	83 c4 10             	add    $0x10,%esp
}
  80091d:	90                   	nop
  80091e:	c9                   	leave  
  80091f:	c3                   	ret    

00800920 <exit>:

void
exit(void)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800926:	e8 f8 21 00 00       	call   802b23 <sys_exit_env>
}
  80092b:	90                   	nop
  80092c:	c9                   	leave  
  80092d:	c3                   	ret    

0080092e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800934:	8d 45 10             	lea    0x10(%ebp),%eax
  800937:	83 c0 04             	add    $0x4,%eax
  80093a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80093d:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800942:	85 c0                	test   %eax,%eax
  800944:	74 16                	je     80095c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800946:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	50                   	push   %eax
  80094f:	68 7c 40 80 00       	push   $0x80407c
  800954:	e8 c3 02 00 00       	call   800c1c <cprintf>
  800959:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80095c:	a1 04 50 80 00       	mov    0x805004,%eax
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	ff 75 08             	pushl  0x8(%ebp)
  80096a:	50                   	push   %eax
  80096b:	68 84 40 80 00       	push   $0x804084
  800970:	6a 74                	push   $0x74
  800972:	e8 d2 02 00 00       	call   800c49 <cprintf_colored>
  800977:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80097a:	8b 45 10             	mov    0x10(%ebp),%eax
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 f4             	pushl  -0xc(%ebp)
  800983:	50                   	push   %eax
  800984:	e8 24 02 00 00       	call   800bad <vcprintf>
  800989:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	6a 00                	push   $0x0
  800991:	68 ac 40 80 00       	push   $0x8040ac
  800996:	e8 12 02 00 00       	call   800bad <vcprintf>
  80099b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80099e:	e8 7d ff ff ff       	call   800920 <exit>

	// should not return here
	while (1) ;
  8009a3:	eb fe                	jmp    8009a3 <_panic+0x75>

008009a5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	53                   	push   %ebx
  8009a9:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8009ac:	a1 24 50 80 00       	mov    0x805024,%eax
  8009b1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	39 c2                	cmp    %eax,%edx
  8009bc:	74 14                	je     8009d2 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009be:	83 ec 04             	sub    $0x4,%esp
  8009c1:	68 b0 40 80 00       	push   $0x8040b0
  8009c6:	6a 26                	push   $0x26
  8009c8:	68 fc 40 80 00       	push   $0x8040fc
  8009cd:	e8 5c ff ff ff       	call   80092e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009e0:	e9 d9 00 00 00       	jmp    800abe <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8009e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	01 d0                	add    %edx,%eax
  8009f4:	8b 00                	mov    (%eax),%eax
  8009f6:	85 c0                	test   %eax,%eax
  8009f8:	75 08                	jne    800a02 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8009fa:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009fd:	e9 b9 00 00 00       	jmp    800abb <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800a02:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a10:	eb 79                	jmp    800a8b <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a12:	a1 24 50 80 00       	mov    0x805024,%eax
  800a17:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800a1d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a20:	89 d0                	mov    %edx,%eax
  800a22:	01 c0                	add    %eax,%eax
  800a24:	01 d0                	add    %edx,%eax
  800a26:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800a2d:	01 d8                	add    %ebx,%eax
  800a2f:	01 d0                	add    %edx,%eax
  800a31:	01 c8                	add    %ecx,%eax
  800a33:	8a 40 04             	mov    0x4(%eax),%al
  800a36:	84 c0                	test   %al,%al
  800a38:	75 4e                	jne    800a88 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a3a:	a1 24 50 80 00       	mov    0x805024,%eax
  800a3f:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800a45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a48:	89 d0                	mov    %edx,%eax
  800a4a:	01 c0                	add    %eax,%eax
  800a4c:	01 d0                	add    %edx,%eax
  800a4e:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800a55:	01 d8                	add    %ebx,%eax
  800a57:	01 d0                	add    %edx,%eax
  800a59:	01 c8                	add    %ecx,%eax
  800a5b:	8b 00                	mov    (%eax),%eax
  800a5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a68:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	01 c8                	add    %ecx,%eax
  800a79:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a7b:	39 c2                	cmp    %eax,%edx
  800a7d:	75 09                	jne    800a88 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800a7f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a86:	eb 19                	jmp    800aa1 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a88:	ff 45 e8             	incl   -0x18(%ebp)
  800a8b:	a1 24 50 80 00       	mov    0x805024,%eax
  800a90:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a99:	39 c2                	cmp    %eax,%edx
  800a9b:	0f 87 71 ff ff ff    	ja     800a12 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800aa1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800aa5:	75 14                	jne    800abb <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800aa7:	83 ec 04             	sub    $0x4,%esp
  800aaa:	68 08 41 80 00       	push   $0x804108
  800aaf:	6a 3a                	push   $0x3a
  800ab1:	68 fc 40 80 00       	push   $0x8040fc
  800ab6:	e8 73 fe ff ff       	call   80092e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800abb:	ff 45 f0             	incl   -0x10(%ebp)
  800abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800ac4:	0f 8c 1b ff ff ff    	jl     8009e5 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800aca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ad1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ad8:	eb 2e                	jmp    800b08 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ada:	a1 24 50 80 00       	mov    0x805024,%eax
  800adf:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800ae5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ae8:	89 d0                	mov    %edx,%eax
  800aea:	01 c0                	add    %eax,%eax
  800aec:	01 d0                	add    %edx,%eax
  800aee:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800af5:	01 d8                	add    %ebx,%eax
  800af7:	01 d0                	add    %edx,%eax
  800af9:	01 c8                	add    %ecx,%eax
  800afb:	8a 40 04             	mov    0x4(%eax),%al
  800afe:	3c 01                	cmp    $0x1,%al
  800b00:	75 03                	jne    800b05 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800b02:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b05:	ff 45 e0             	incl   -0x20(%ebp)
  800b08:	a1 24 50 80 00       	mov    0x805024,%eax
  800b0d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b16:	39 c2                	cmp    %eax,%edx
  800b18:	77 c0                	ja     800ada <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b1d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b20:	74 14                	je     800b36 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800b22:	83 ec 04             	sub    $0x4,%esp
  800b25:	68 5c 41 80 00       	push   $0x80415c
  800b2a:	6a 44                	push   $0x44
  800b2c:	68 fc 40 80 00       	push   $0x8040fc
  800b31:	e8 f8 fd ff ff       	call   80092e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b36:	90                   	nop
  800b37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	53                   	push   %ebx
  800b40:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8b 00                	mov    (%eax),%eax
  800b48:	8d 48 01             	lea    0x1(%eax),%ecx
  800b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4e:	89 0a                	mov    %ecx,(%edx)
  800b50:	8b 55 08             	mov    0x8(%ebp),%edx
  800b53:	88 d1                	mov    %dl,%cl
  800b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b58:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b66:	75 30                	jne    800b98 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b68:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800b6e:	a0 44 50 80 00       	mov    0x805044,%al
  800b73:	0f b6 c0             	movzbl %al,%eax
  800b76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b79:	8b 09                	mov    (%ecx),%ecx
  800b7b:	89 cb                	mov    %ecx,%ebx
  800b7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b80:	83 c1 08             	add    $0x8,%ecx
  800b83:	52                   	push   %edx
  800b84:	50                   	push   %eax
  800b85:	53                   	push   %ebx
  800b86:	51                   	push   %ecx
  800b87:	e8 a8 1c 00 00       	call   802834 <sys_cputs>
  800b8c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9b:	8b 40 04             	mov    0x4(%eax),%eax
  800b9e:	8d 50 01             	lea    0x1(%eax),%edx
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ba7:	90                   	nop
  800ba8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bb6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bbd:	00 00 00 
	b.cnt = 0;
  800bc0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bc7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	ff 75 08             	pushl  0x8(%ebp)
  800bd0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bd6:	50                   	push   %eax
  800bd7:	68 3c 0b 80 00       	push   $0x800b3c
  800bdc:	e8 5a 02 00 00       	call   800e3b <vprintfmt>
  800be1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800be4:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800bea:	a0 44 50 80 00       	mov    0x805044,%al
  800bef:	0f b6 c0             	movzbl %al,%eax
  800bf2:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800bf8:	52                   	push   %edx
  800bf9:	50                   	push   %eax
  800bfa:	51                   	push   %ecx
  800bfb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c01:	83 c0 08             	add    $0x8,%eax
  800c04:	50                   	push   %eax
  800c05:	e8 2a 1c 00 00       	call   802834 <sys_cputs>
  800c0a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c0d:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800c14:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c22:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800c29:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 f4             	pushl  -0xc(%ebp)
  800c38:	50                   	push   %eax
  800c39:	e8 6f ff ff ff       	call   800bad <vcprintf>
  800c3e:	83 c4 10             	add    $0x10,%esp
  800c41:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c47:	c9                   	leave  
  800c48:	c3                   	ret    

00800c49 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c4f:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	c1 e0 08             	shl    $0x8,%eax
  800c5c:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800c61:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c64:	83 c0 04             	add    $0x4,%eax
  800c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6d:	83 ec 08             	sub    $0x8,%esp
  800c70:	ff 75 f4             	pushl  -0xc(%ebp)
  800c73:	50                   	push   %eax
  800c74:	e8 34 ff ff ff       	call   800bad <vcprintf>
  800c79:	83 c4 10             	add    $0x10,%esp
  800c7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c7f:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800c86:	07 00 00 

	return cnt;
  800c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c94:	e8 df 1b 00 00       	call   802878 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c99:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	83 ec 08             	sub    $0x8,%esp
  800ca5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca8:	50                   	push   %eax
  800ca9:	e8 ff fe ff ff       	call   800bad <vcprintf>
  800cae:	83 c4 10             	add    $0x10,%esp
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800cb4:	e8 d9 1b 00 00       	call   802892 <sys_unlock_cons>
	return cnt;
  800cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cbc:	c9                   	leave  
  800cbd:	c3                   	ret    

00800cbe <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	53                   	push   %ebx
  800cc2:	83 ec 14             	sub    $0x14,%esp
  800cc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ccb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cd1:	8b 45 18             	mov    0x18(%ebp),%eax
  800cd4:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cdc:	77 55                	ja     800d33 <printnum+0x75>
  800cde:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ce1:	72 05                	jb     800ce8 <printnum+0x2a>
  800ce3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ce6:	77 4b                	ja     800d33 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ce8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ceb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cee:	8b 45 18             	mov    0x18(%ebp),%eax
  800cf1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf6:	52                   	push   %edx
  800cf7:	50                   	push   %eax
  800cf8:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfb:	ff 75 f0             	pushl  -0x10(%ebp)
  800cfe:	e8 d5 2d 00 00       	call   803ad8 <__udivdi3>
  800d03:	83 c4 10             	add    $0x10,%esp
  800d06:	83 ec 04             	sub    $0x4,%esp
  800d09:	ff 75 20             	pushl  0x20(%ebp)
  800d0c:	53                   	push   %ebx
  800d0d:	ff 75 18             	pushl  0x18(%ebp)
  800d10:	52                   	push   %edx
  800d11:	50                   	push   %eax
  800d12:	ff 75 0c             	pushl  0xc(%ebp)
  800d15:	ff 75 08             	pushl  0x8(%ebp)
  800d18:	e8 a1 ff ff ff       	call   800cbe <printnum>
  800d1d:	83 c4 20             	add    $0x20,%esp
  800d20:	eb 1a                	jmp    800d3c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d22:	83 ec 08             	sub    $0x8,%esp
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	ff 75 20             	pushl  0x20(%ebp)
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	ff d0                	call   *%eax
  800d30:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d33:	ff 4d 1c             	decl   0x1c(%ebp)
  800d36:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d3a:	7f e6                	jg     800d22 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d3c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d4a:	53                   	push   %ebx
  800d4b:	51                   	push   %ecx
  800d4c:	52                   	push   %edx
  800d4d:	50                   	push   %eax
  800d4e:	e8 95 2e 00 00       	call   803be8 <__umoddi3>
  800d53:	83 c4 10             	add    $0x10,%esp
  800d56:	05 d4 43 80 00       	add    $0x8043d4,%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	0f be c0             	movsbl %al,%eax
  800d60:	83 ec 08             	sub    $0x8,%esp
  800d63:	ff 75 0c             	pushl  0xc(%ebp)
  800d66:	50                   	push   %eax
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	ff d0                	call   *%eax
  800d6c:	83 c4 10             	add    $0x10,%esp
}
  800d6f:	90                   	nop
  800d70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d73:	c9                   	leave  
  800d74:	c3                   	ret    

00800d75 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d78:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d7c:	7e 1c                	jle    800d9a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8b 00                	mov    (%eax),%eax
  800d83:	8d 50 08             	lea    0x8(%eax),%edx
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	89 10                	mov    %edx,(%eax)
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8b 00                	mov    (%eax),%eax
  800d90:	83 e8 08             	sub    $0x8,%eax
  800d93:	8b 50 04             	mov    0x4(%eax),%edx
  800d96:	8b 00                	mov    (%eax),%eax
  800d98:	eb 40                	jmp    800dda <getuint+0x65>
	else if (lflag)
  800d9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9e:	74 1e                	je     800dbe <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8b 00                	mov    (%eax),%eax
  800da5:	8d 50 04             	lea    0x4(%eax),%edx
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	89 10                	mov    %edx,(%eax)
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	8b 00                	mov    (%eax),%eax
  800db2:	83 e8 04             	sub    $0x4,%eax
  800db5:	8b 00                	mov    (%eax),%eax
  800db7:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbc:	eb 1c                	jmp    800dda <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8b 00                	mov    (%eax),%eax
  800dc3:	8d 50 04             	lea    0x4(%eax),%edx
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	89 10                	mov    %edx,(%eax)
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8b 00                	mov    (%eax),%eax
  800dd0:	83 e8 04             	sub    $0x4,%eax
  800dd3:	8b 00                	mov    (%eax),%eax
  800dd5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ddf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800de3:	7e 1c                	jle    800e01 <getint+0x25>
		return va_arg(*ap, long long);
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8b 00                	mov    (%eax),%eax
  800dea:	8d 50 08             	lea    0x8(%eax),%edx
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	89 10                	mov    %edx,(%eax)
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8b 00                	mov    (%eax),%eax
  800df7:	83 e8 08             	sub    $0x8,%eax
  800dfa:	8b 50 04             	mov    0x4(%eax),%edx
  800dfd:	8b 00                	mov    (%eax),%eax
  800dff:	eb 38                	jmp    800e39 <getint+0x5d>
	else if (lflag)
  800e01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e05:	74 1a                	je     800e21 <getint+0x45>
		return va_arg(*ap, long);
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8b 00                	mov    (%eax),%eax
  800e0c:	8d 50 04             	lea    0x4(%eax),%edx
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	89 10                	mov    %edx,(%eax)
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8b 00                	mov    (%eax),%eax
  800e19:	83 e8 04             	sub    $0x4,%eax
  800e1c:	8b 00                	mov    (%eax),%eax
  800e1e:	99                   	cltd   
  800e1f:	eb 18                	jmp    800e39 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8b 00                	mov    (%eax),%eax
  800e26:	8d 50 04             	lea    0x4(%eax),%edx
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	89 10                	mov    %edx,(%eax)
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8b 00                	mov    (%eax),%eax
  800e33:	83 e8 04             	sub    $0x4,%eax
  800e36:	8b 00                	mov    (%eax),%eax
  800e38:	99                   	cltd   
}
  800e39:	5d                   	pop    %ebp
  800e3a:	c3                   	ret    

00800e3b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
  800e40:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e43:	eb 17                	jmp    800e5c <vprintfmt+0x21>
			if (ch == '\0')
  800e45:	85 db                	test   %ebx,%ebx
  800e47:	0f 84 c1 03 00 00    	je     80120e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e4d:	83 ec 08             	sub    $0x8,%esp
  800e50:	ff 75 0c             	pushl  0xc(%ebp)
  800e53:	53                   	push   %ebx
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	ff d0                	call   *%eax
  800e59:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5f:	8d 50 01             	lea    0x1(%eax),%edx
  800e62:	89 55 10             	mov    %edx,0x10(%ebp)
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	0f b6 d8             	movzbl %al,%ebx
  800e6a:	83 fb 25             	cmp    $0x25,%ebx
  800e6d:	75 d6                	jne    800e45 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e6f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e73:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e7a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e81:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e88:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e92:	8d 50 01             	lea    0x1(%eax),%edx
  800e95:	89 55 10             	mov    %edx,0x10(%ebp)
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	0f b6 d8             	movzbl %al,%ebx
  800e9d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ea0:	83 f8 5b             	cmp    $0x5b,%eax
  800ea3:	0f 87 3d 03 00 00    	ja     8011e6 <vprintfmt+0x3ab>
  800ea9:	8b 04 85 f8 43 80 00 	mov    0x8043f8(,%eax,4),%eax
  800eb0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800eb2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800eb6:	eb d7                	jmp    800e8f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800eb8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ebc:	eb d1                	jmp    800e8f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ebe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ec5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ec8:	89 d0                	mov    %edx,%eax
  800eca:	c1 e0 02             	shl    $0x2,%eax
  800ecd:	01 d0                	add    %edx,%eax
  800ecf:	01 c0                	add    %eax,%eax
  800ed1:	01 d8                	add    %ebx,%eax
  800ed3:	83 e8 30             	sub    $0x30,%eax
  800ed6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ee1:	83 fb 2f             	cmp    $0x2f,%ebx
  800ee4:	7e 3e                	jle    800f24 <vprintfmt+0xe9>
  800ee6:	83 fb 39             	cmp    $0x39,%ebx
  800ee9:	7f 39                	jg     800f24 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eeb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800eee:	eb d5                	jmp    800ec5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ef0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef3:	83 c0 04             	add    $0x4,%eax
  800ef6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ef9:	8b 45 14             	mov    0x14(%ebp),%eax
  800efc:	83 e8 04             	sub    $0x4,%eax
  800eff:	8b 00                	mov    (%eax),%eax
  800f01:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f04:	eb 1f                	jmp    800f25 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0a:	79 83                	jns    800e8f <vprintfmt+0x54>
				width = 0;
  800f0c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f13:	e9 77 ff ff ff       	jmp    800e8f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f18:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f1f:	e9 6b ff ff ff       	jmp    800e8f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f24:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f29:	0f 89 60 ff ff ff    	jns    800e8f <vprintfmt+0x54>
				width = precision, precision = -1;
  800f2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f35:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f3c:	e9 4e ff ff ff       	jmp    800e8f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f41:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f44:	e9 46 ff ff ff       	jmp    800e8f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f49:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4c:	83 c0 04             	add    $0x4,%eax
  800f4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f52:	8b 45 14             	mov    0x14(%ebp),%eax
  800f55:	83 e8 04             	sub    $0x4,%eax
  800f58:	8b 00                	mov    (%eax),%eax
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	50                   	push   %eax
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	ff d0                	call   *%eax
  800f66:	83 c4 10             	add    $0x10,%esp
			break;
  800f69:	e9 9b 02 00 00       	jmp    801209 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f71:	83 c0 04             	add    $0x4,%eax
  800f74:	89 45 14             	mov    %eax,0x14(%ebp)
  800f77:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7a:	83 e8 04             	sub    $0x4,%eax
  800f7d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f7f:	85 db                	test   %ebx,%ebx
  800f81:	79 02                	jns    800f85 <vprintfmt+0x14a>
				err = -err;
  800f83:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f85:	83 fb 64             	cmp    $0x64,%ebx
  800f88:	7f 0b                	jg     800f95 <vprintfmt+0x15a>
  800f8a:	8b 34 9d 40 42 80 00 	mov    0x804240(,%ebx,4),%esi
  800f91:	85 f6                	test   %esi,%esi
  800f93:	75 19                	jne    800fae <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f95:	53                   	push   %ebx
  800f96:	68 e5 43 80 00       	push   $0x8043e5
  800f9b:	ff 75 0c             	pushl  0xc(%ebp)
  800f9e:	ff 75 08             	pushl  0x8(%ebp)
  800fa1:	e8 70 02 00 00       	call   801216 <printfmt>
  800fa6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800fa9:	e9 5b 02 00 00       	jmp    801209 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fae:	56                   	push   %esi
  800faf:	68 ee 43 80 00       	push   $0x8043ee
  800fb4:	ff 75 0c             	pushl  0xc(%ebp)
  800fb7:	ff 75 08             	pushl  0x8(%ebp)
  800fba:	e8 57 02 00 00       	call   801216 <printfmt>
  800fbf:	83 c4 10             	add    $0x10,%esp
			break;
  800fc2:	e9 42 02 00 00       	jmp    801209 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fca:	83 c0 04             	add    $0x4,%eax
  800fcd:	89 45 14             	mov    %eax,0x14(%ebp)
  800fd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd3:	83 e8 04             	sub    $0x4,%eax
  800fd6:	8b 30                	mov    (%eax),%esi
  800fd8:	85 f6                	test   %esi,%esi
  800fda:	75 05                	jne    800fe1 <vprintfmt+0x1a6>
				p = "(null)";
  800fdc:	be f1 43 80 00       	mov    $0x8043f1,%esi
			if (width > 0 && padc != '-')
  800fe1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe5:	7e 6d                	jle    801054 <vprintfmt+0x219>
  800fe7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800feb:	74 67                	je     801054 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	50                   	push   %eax
  800ff4:	56                   	push   %esi
  800ff5:	e8 1e 03 00 00       	call   801318 <strnlen>
  800ffa:	83 c4 10             	add    $0x10,%esp
  800ffd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801000:	eb 16                	jmp    801018 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801002:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	50                   	push   %eax
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	ff d0                	call   *%eax
  801012:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801015:	ff 4d e4             	decl   -0x1c(%ebp)
  801018:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80101c:	7f e4                	jg     801002 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80101e:	eb 34                	jmp    801054 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801020:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801024:	74 1c                	je     801042 <vprintfmt+0x207>
  801026:	83 fb 1f             	cmp    $0x1f,%ebx
  801029:	7e 05                	jle    801030 <vprintfmt+0x1f5>
  80102b:	83 fb 7e             	cmp    $0x7e,%ebx
  80102e:	7e 12                	jle    801042 <vprintfmt+0x207>
					putch('?', putdat);
  801030:	83 ec 08             	sub    $0x8,%esp
  801033:	ff 75 0c             	pushl  0xc(%ebp)
  801036:	6a 3f                	push   $0x3f
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	ff d0                	call   *%eax
  80103d:	83 c4 10             	add    $0x10,%esp
  801040:	eb 0f                	jmp    801051 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801042:	83 ec 08             	sub    $0x8,%esp
  801045:	ff 75 0c             	pushl  0xc(%ebp)
  801048:	53                   	push   %ebx
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	ff d0                	call   *%eax
  80104e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801051:	ff 4d e4             	decl   -0x1c(%ebp)
  801054:	89 f0                	mov    %esi,%eax
  801056:	8d 70 01             	lea    0x1(%eax),%esi
  801059:	8a 00                	mov    (%eax),%al
  80105b:	0f be d8             	movsbl %al,%ebx
  80105e:	85 db                	test   %ebx,%ebx
  801060:	74 24                	je     801086 <vprintfmt+0x24b>
  801062:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801066:	78 b8                	js     801020 <vprintfmt+0x1e5>
  801068:	ff 4d e0             	decl   -0x20(%ebp)
  80106b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80106f:	79 af                	jns    801020 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801071:	eb 13                	jmp    801086 <vprintfmt+0x24b>
				putch(' ', putdat);
  801073:	83 ec 08             	sub    $0x8,%esp
  801076:	ff 75 0c             	pushl  0xc(%ebp)
  801079:	6a 20                	push   $0x20
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	ff d0                	call   *%eax
  801080:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801083:	ff 4d e4             	decl   -0x1c(%ebp)
  801086:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80108a:	7f e7                	jg     801073 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80108c:	e9 78 01 00 00       	jmp    801209 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	ff 75 e8             	pushl  -0x18(%ebp)
  801097:	8d 45 14             	lea    0x14(%ebp),%eax
  80109a:	50                   	push   %eax
  80109b:	e8 3c fd ff ff       	call   800ddc <getint>
  8010a0:	83 c4 10             	add    $0x10,%esp
  8010a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8010a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010af:	85 d2                	test   %edx,%edx
  8010b1:	79 23                	jns    8010d6 <vprintfmt+0x29b>
				putch('-', putdat);
  8010b3:	83 ec 08             	sub    $0x8,%esp
  8010b6:	ff 75 0c             	pushl  0xc(%ebp)
  8010b9:	6a 2d                	push   $0x2d
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	ff d0                	call   *%eax
  8010c0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c9:	f7 d8                	neg    %eax
  8010cb:	83 d2 00             	adc    $0x0,%edx
  8010ce:	f7 da                	neg    %edx
  8010d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010d6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010dd:	e9 bc 00 00 00       	jmp    80119e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010e2:	83 ec 08             	sub    $0x8,%esp
  8010e5:	ff 75 e8             	pushl  -0x18(%ebp)
  8010e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8010eb:	50                   	push   %eax
  8010ec:	e8 84 fc ff ff       	call   800d75 <getuint>
  8010f1:	83 c4 10             	add    $0x10,%esp
  8010f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801101:	e9 98 00 00 00       	jmp    80119e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801106:	83 ec 08             	sub    $0x8,%esp
  801109:	ff 75 0c             	pushl  0xc(%ebp)
  80110c:	6a 58                	push   $0x58
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	ff d0                	call   *%eax
  801113:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801116:	83 ec 08             	sub    $0x8,%esp
  801119:	ff 75 0c             	pushl  0xc(%ebp)
  80111c:	6a 58                	push   $0x58
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	ff d0                	call   *%eax
  801123:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801126:	83 ec 08             	sub    $0x8,%esp
  801129:	ff 75 0c             	pushl  0xc(%ebp)
  80112c:	6a 58                	push   $0x58
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	ff d0                	call   *%eax
  801133:	83 c4 10             	add    $0x10,%esp
			break;
  801136:	e9 ce 00 00 00       	jmp    801209 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80113b:	83 ec 08             	sub    $0x8,%esp
  80113e:	ff 75 0c             	pushl  0xc(%ebp)
  801141:	6a 30                	push   $0x30
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	ff d0                	call   *%eax
  801148:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80114b:	83 ec 08             	sub    $0x8,%esp
  80114e:	ff 75 0c             	pushl  0xc(%ebp)
  801151:	6a 78                	push   $0x78
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	ff d0                	call   *%eax
  801158:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80115b:	8b 45 14             	mov    0x14(%ebp),%eax
  80115e:	83 c0 04             	add    $0x4,%eax
  801161:	89 45 14             	mov    %eax,0x14(%ebp)
  801164:	8b 45 14             	mov    0x14(%ebp),%eax
  801167:	83 e8 04             	sub    $0x4,%eax
  80116a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80116c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80116f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801176:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80117d:	eb 1f                	jmp    80119e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80117f:	83 ec 08             	sub    $0x8,%esp
  801182:	ff 75 e8             	pushl  -0x18(%ebp)
  801185:	8d 45 14             	lea    0x14(%ebp),%eax
  801188:	50                   	push   %eax
  801189:	e8 e7 fb ff ff       	call   800d75 <getuint>
  80118e:	83 c4 10             	add    $0x10,%esp
  801191:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801194:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801197:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80119e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8011a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011a5:	83 ec 04             	sub    $0x4,%esp
  8011a8:	52                   	push   %edx
  8011a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011ac:	50                   	push   %eax
  8011ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8011b3:	ff 75 0c             	pushl  0xc(%ebp)
  8011b6:	ff 75 08             	pushl  0x8(%ebp)
  8011b9:	e8 00 fb ff ff       	call   800cbe <printnum>
  8011be:	83 c4 20             	add    $0x20,%esp
			break;
  8011c1:	eb 46                	jmp    801209 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	ff 75 0c             	pushl  0xc(%ebp)
  8011c9:	53                   	push   %ebx
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	ff d0                	call   *%eax
  8011cf:	83 c4 10             	add    $0x10,%esp
			break;
  8011d2:	eb 35                	jmp    801209 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011d4:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  8011db:	eb 2c                	jmp    801209 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011dd:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  8011e4:	eb 23                	jmp    801209 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011e6:	83 ec 08             	sub    $0x8,%esp
  8011e9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ec:	6a 25                	push   $0x25
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	ff d0                	call   *%eax
  8011f3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011f6:	ff 4d 10             	decl   0x10(%ebp)
  8011f9:	eb 03                	jmp    8011fe <vprintfmt+0x3c3>
  8011fb:	ff 4d 10             	decl   0x10(%ebp)
  8011fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801201:	48                   	dec    %eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 25                	cmp    $0x25,%al
  801206:	75 f3                	jne    8011fb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801208:	90                   	nop
		}
	}
  801209:	e9 35 fc ff ff       	jmp    800e43 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80120e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80120f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801212:	5b                   	pop    %ebx
  801213:	5e                   	pop    %esi
  801214:	5d                   	pop    %ebp
  801215:	c3                   	ret    

00801216 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80121c:	8d 45 10             	lea    0x10(%ebp),%eax
  80121f:	83 c0 04             	add    $0x4,%eax
  801222:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801225:	8b 45 10             	mov    0x10(%ebp),%eax
  801228:	ff 75 f4             	pushl  -0xc(%ebp)
  80122b:	50                   	push   %eax
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	ff 75 08             	pushl  0x8(%ebp)
  801232:	e8 04 fc ff ff       	call   800e3b <vprintfmt>
  801237:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80123a:	90                   	nop
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801240:	8b 45 0c             	mov    0xc(%ebp),%eax
  801243:	8b 40 08             	mov    0x8(%eax),%eax
  801246:	8d 50 01             	lea    0x1(%eax),%edx
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80124f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801252:	8b 10                	mov    (%eax),%edx
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	8b 40 04             	mov    0x4(%eax),%eax
  80125a:	39 c2                	cmp    %eax,%edx
  80125c:	73 12                	jae    801270 <sprintputch+0x33>
		*b->buf++ = ch;
  80125e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801261:	8b 00                	mov    (%eax),%eax
  801263:	8d 48 01             	lea    0x1(%eax),%ecx
  801266:	8b 55 0c             	mov    0xc(%ebp),%edx
  801269:	89 0a                	mov    %ecx,(%edx)
  80126b:	8b 55 08             	mov    0x8(%ebp),%edx
  80126e:	88 10                	mov    %dl,(%eax)
}
  801270:	90                   	nop
  801271:	5d                   	pop    %ebp
  801272:	c3                   	ret    

00801273 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
  801276:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80127f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801282:	8d 50 ff             	lea    -0x1(%eax),%edx
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	01 d0                	add    %edx,%eax
  80128a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80128d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801294:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801298:	74 06                	je     8012a0 <vsnprintf+0x2d>
  80129a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80129e:	7f 07                	jg     8012a7 <vsnprintf+0x34>
		return -E_INVAL;
  8012a0:	b8 03 00 00 00       	mov    $0x3,%eax
  8012a5:	eb 20                	jmp    8012c7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8012a7:	ff 75 14             	pushl  0x14(%ebp)
  8012aa:	ff 75 10             	pushl  0x10(%ebp)
  8012ad:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8012b0:	50                   	push   %eax
  8012b1:	68 3d 12 80 00       	push   $0x80123d
  8012b6:	e8 80 fb ff ff       	call   800e3b <vprintfmt>
  8012bb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012c1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    

008012c9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012cf:	8d 45 10             	lea    0x10(%ebp),%eax
  8012d2:	83 c0 04             	add    $0x4,%eax
  8012d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	ff 75 f4             	pushl  -0xc(%ebp)
  8012de:	50                   	push   %eax
  8012df:	ff 75 0c             	pushl  0xc(%ebp)
  8012e2:	ff 75 08             	pushl  0x8(%ebp)
  8012e5:	e8 89 ff ff ff       	call   801273 <vsnprintf>
  8012ea:	83 c4 10             	add    $0x10,%esp
  8012ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801302:	eb 06                	jmp    80130a <strlen+0x15>
		n++;
  801304:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801307:	ff 45 08             	incl   0x8(%ebp)
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	84 c0                	test   %al,%al
  801311:	75 f1                	jne    801304 <strlen+0xf>
		n++;
	return n;
  801313:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80131e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801325:	eb 09                	jmp    801330 <strnlen+0x18>
		n++;
  801327:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80132a:	ff 45 08             	incl   0x8(%ebp)
  80132d:	ff 4d 0c             	decl   0xc(%ebp)
  801330:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801334:	74 09                	je     80133f <strnlen+0x27>
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	84 c0                	test   %al,%al
  80133d:	75 e8                	jne    801327 <strnlen+0xf>
		n++;
	return n;
  80133f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801342:	c9                   	leave  
  801343:	c3                   	ret    

00801344 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801350:	90                   	nop
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	8d 50 01             	lea    0x1(%eax),%edx
  801357:	89 55 08             	mov    %edx,0x8(%ebp)
  80135a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801360:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801363:	8a 12                	mov    (%edx),%dl
  801365:	88 10                	mov    %dl,(%eax)
  801367:	8a 00                	mov    (%eax),%al
  801369:	84 c0                	test   %al,%al
  80136b:	75 e4                	jne    801351 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80136d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801370:	c9                   	leave  
  801371:	c3                   	ret    

00801372 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
  801375:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80137e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801385:	eb 1f                	jmp    8013a6 <strncpy+0x34>
		*dst++ = *src;
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8d 50 01             	lea    0x1(%eax),%edx
  80138d:	89 55 08             	mov    %edx,0x8(%ebp)
  801390:	8b 55 0c             	mov    0xc(%ebp),%edx
  801393:	8a 12                	mov    (%edx),%dl
  801395:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	84 c0                	test   %al,%al
  80139e:	74 03                	je     8013a3 <strncpy+0x31>
			src++;
  8013a0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013a3:	ff 45 fc             	incl   -0x4(%ebp)
  8013a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013ac:	72 d9                	jb     801387 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013b1:	c9                   	leave  
  8013b2:	c3                   	ret    

008013b3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c3:	74 30                	je     8013f5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013c5:	eb 16                	jmp    8013dd <strlcpy+0x2a>
			*dst++ = *src++;
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	8d 50 01             	lea    0x1(%eax),%edx
  8013cd:	89 55 08             	mov    %edx,0x8(%ebp)
  8013d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013d6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013d9:	8a 12                	mov    (%edx),%dl
  8013db:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013dd:	ff 4d 10             	decl   0x10(%ebp)
  8013e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e4:	74 09                	je     8013ef <strlcpy+0x3c>
  8013e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	84 c0                	test   %al,%al
  8013ed:	75 d8                	jne    8013c7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013fb:	29 c2                	sub    %eax,%edx
  8013fd:	89 d0                	mov    %edx,%eax
}
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

00801401 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801404:	eb 06                	jmp    80140c <strcmp+0xb>
		p++, q++;
  801406:	ff 45 08             	incl   0x8(%ebp)
  801409:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	84 c0                	test   %al,%al
  801413:	74 0e                	je     801423 <strcmp+0x22>
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	8a 10                	mov    (%eax),%dl
  80141a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	38 c2                	cmp    %al,%dl
  801421:	74 e3                	je     801406 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	0f b6 d0             	movzbl %al,%edx
  80142b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142e:	8a 00                	mov    (%eax),%al
  801430:	0f b6 c0             	movzbl %al,%eax
  801433:	29 c2                	sub    %eax,%edx
  801435:	89 d0                	mov    %edx,%eax
}
  801437:	5d                   	pop    %ebp
  801438:	c3                   	ret    

00801439 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80143c:	eb 09                	jmp    801447 <strncmp+0xe>
		n--, p++, q++;
  80143e:	ff 4d 10             	decl   0x10(%ebp)
  801441:	ff 45 08             	incl   0x8(%ebp)
  801444:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801447:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144b:	74 17                	je     801464 <strncmp+0x2b>
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	8a 00                	mov    (%eax),%al
  801452:	84 c0                	test   %al,%al
  801454:	74 0e                	je     801464 <strncmp+0x2b>
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	8a 10                	mov    (%eax),%dl
  80145b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	38 c2                	cmp    %al,%dl
  801462:	74 da                	je     80143e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801464:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801468:	75 07                	jne    801471 <strncmp+0x38>
		return 0;
  80146a:	b8 00 00 00 00       	mov    $0x0,%eax
  80146f:	eb 14                	jmp    801485 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	8a 00                	mov    (%eax),%al
  801476:	0f b6 d0             	movzbl %al,%edx
  801479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	0f b6 c0             	movzbl %al,%eax
  801481:	29 c2                	sub    %eax,%edx
  801483:	89 d0                	mov    %edx,%eax
}
  801485:	5d                   	pop    %ebp
  801486:	c3                   	ret    

00801487 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801490:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801493:	eb 12                	jmp    8014a7 <strchr+0x20>
		if (*s == c)
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	8a 00                	mov    (%eax),%al
  80149a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80149d:	75 05                	jne    8014a4 <strchr+0x1d>
			return (char *) s;
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	eb 11                	jmp    8014b5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014a4:	ff 45 08             	incl   0x8(%ebp)
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	8a 00                	mov    (%eax),%al
  8014ac:	84 c0                	test   %al,%al
  8014ae:	75 e5                	jne    801495 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	83 ec 04             	sub    $0x4,%esp
  8014bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014c3:	eb 0d                	jmp    8014d2 <strfind+0x1b>
		if (*s == c)
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	8a 00                	mov    (%eax),%al
  8014ca:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014cd:	74 0e                	je     8014dd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014cf:	ff 45 08             	incl   0x8(%ebp)
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	8a 00                	mov    (%eax),%al
  8014d7:	84 c0                	test   %al,%al
  8014d9:	75 ea                	jne    8014c5 <strfind+0xe>
  8014db:	eb 01                	jmp    8014de <strfind+0x27>
		if (*s == c)
			break;
  8014dd:	90                   	nop
	return (char *) s;
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014ef:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014f3:	76 63                	jbe    801558 <memset+0x75>
		uint64 data_block = c;
  8014f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f8:	99                   	cltd   
  8014f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8014ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801502:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801505:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801509:	c1 e0 08             	shl    $0x8,%eax
  80150c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80150f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801515:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801518:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80151c:	c1 e0 10             	shl    $0x10,%eax
  80151f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801522:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801528:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80152b:	89 c2                	mov    %eax,%edx
  80152d:	b8 00 00 00 00       	mov    $0x0,%eax
  801532:	09 45 f0             	or     %eax,-0x10(%ebp)
  801535:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801538:	eb 18                	jmp    801552 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80153a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80153d:	8d 41 08             	lea    0x8(%ecx),%eax
  801540:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801546:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801549:	89 01                	mov    %eax,(%ecx)
  80154b:	89 51 04             	mov    %edx,0x4(%ecx)
  80154e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801552:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801556:	77 e2                	ja     80153a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801558:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80155c:	74 23                	je     801581 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80155e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801561:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801564:	eb 0e                	jmp    801574 <memset+0x91>
			*p8++ = (uint8)c;
  801566:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801569:	8d 50 01             	lea    0x1(%eax),%edx
  80156c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80156f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801572:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801574:	8b 45 10             	mov    0x10(%ebp),%eax
  801577:	8d 50 ff             	lea    -0x1(%eax),%edx
  80157a:	89 55 10             	mov    %edx,0x10(%ebp)
  80157d:	85 c0                	test   %eax,%eax
  80157f:	75 e5                	jne    801566 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80158c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801598:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80159c:	76 24                	jbe    8015c2 <memcpy+0x3c>
		while(n >= 8){
  80159e:	eb 1c                	jmp    8015bc <memcpy+0x36>
			*d64 = *s64;
  8015a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a3:	8b 50 04             	mov    0x4(%eax),%edx
  8015a6:	8b 00                	mov    (%eax),%eax
  8015a8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015ab:	89 01                	mov    %eax,(%ecx)
  8015ad:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8015b0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8015b4:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8015b8:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8015bc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015c0:	77 de                	ja     8015a0 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015c6:	74 31                	je     8015f9 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015d4:	eb 16                	jmp    8015ec <memcpy+0x66>
			*d8++ = *s8++;
  8015d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d9:	8d 50 01             	lea    0x1(%eax),%edx
  8015dc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015e5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015e8:	8a 12                	mov    (%edx),%dl
  8015ea:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	75 dd                	jne    8015d6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801604:	8b 45 0c             	mov    0xc(%ebp),%eax
  801607:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801610:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801613:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801616:	73 50                	jae    801668 <memmove+0x6a>
  801618:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161b:	8b 45 10             	mov    0x10(%ebp),%eax
  80161e:	01 d0                	add    %edx,%eax
  801620:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801623:	76 43                	jbe    801668 <memmove+0x6a>
		s += n;
  801625:	8b 45 10             	mov    0x10(%ebp),%eax
  801628:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80162b:	8b 45 10             	mov    0x10(%ebp),%eax
  80162e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801631:	eb 10                	jmp    801643 <memmove+0x45>
			*--d = *--s;
  801633:	ff 4d f8             	decl   -0x8(%ebp)
  801636:	ff 4d fc             	decl   -0x4(%ebp)
  801639:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163c:	8a 10                	mov    (%eax),%dl
  80163e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801641:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801643:	8b 45 10             	mov    0x10(%ebp),%eax
  801646:	8d 50 ff             	lea    -0x1(%eax),%edx
  801649:	89 55 10             	mov    %edx,0x10(%ebp)
  80164c:	85 c0                	test   %eax,%eax
  80164e:	75 e3                	jne    801633 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801650:	eb 23                	jmp    801675 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801652:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801655:	8d 50 01             	lea    0x1(%eax),%edx
  801658:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80165b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80165e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801661:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801664:	8a 12                	mov    (%edx),%dl
  801666:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801668:	8b 45 10             	mov    0x10(%ebp),%eax
  80166b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80166e:	89 55 10             	mov    %edx,0x10(%ebp)
  801671:	85 c0                	test   %eax,%eax
  801673:	75 dd                	jne    801652 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801686:	8b 45 0c             	mov    0xc(%ebp),%eax
  801689:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80168c:	eb 2a                	jmp    8016b8 <memcmp+0x3e>
		if (*s1 != *s2)
  80168e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801691:	8a 10                	mov    (%eax),%dl
  801693:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801696:	8a 00                	mov    (%eax),%al
  801698:	38 c2                	cmp    %al,%dl
  80169a:	74 16                	je     8016b2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80169c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80169f:	8a 00                	mov    (%eax),%al
  8016a1:	0f b6 d0             	movzbl %al,%edx
  8016a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a7:	8a 00                	mov    (%eax),%al
  8016a9:	0f b6 c0             	movzbl %al,%eax
  8016ac:	29 c2                	sub    %eax,%edx
  8016ae:	89 d0                	mov    %edx,%eax
  8016b0:	eb 18                	jmp    8016ca <memcmp+0x50>
		s1++, s2++;
  8016b2:	ff 45 fc             	incl   -0x4(%ebp)
  8016b5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016be:	89 55 10             	mov    %edx,0x10(%ebp)
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	75 c9                	jne    80168e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d8:	01 d0                	add    %edx,%eax
  8016da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016dd:	eb 15                	jmp    8016f4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	0f b6 d0             	movzbl %al,%edx
  8016e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ea:	0f b6 c0             	movzbl %al,%eax
  8016ed:	39 c2                	cmp    %eax,%edx
  8016ef:	74 0d                	je     8016fe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016fa:	72 e3                	jb     8016df <memfind+0x13>
  8016fc:	eb 01                	jmp    8016ff <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016fe:	90                   	nop
	return (void *) s;
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80170a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801711:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801718:	eb 03                	jmp    80171d <strtol+0x19>
		s++;
  80171a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	8a 00                	mov    (%eax),%al
  801722:	3c 20                	cmp    $0x20,%al
  801724:	74 f4                	je     80171a <strtol+0x16>
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8a 00                	mov    (%eax),%al
  80172b:	3c 09                	cmp    $0x9,%al
  80172d:	74 eb                	je     80171a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	8a 00                	mov    (%eax),%al
  801734:	3c 2b                	cmp    $0x2b,%al
  801736:	75 05                	jne    80173d <strtol+0x39>
		s++;
  801738:	ff 45 08             	incl   0x8(%ebp)
  80173b:	eb 13                	jmp    801750 <strtol+0x4c>
	else if (*s == '-')
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	8a 00                	mov    (%eax),%al
  801742:	3c 2d                	cmp    $0x2d,%al
  801744:	75 0a                	jne    801750 <strtol+0x4c>
		s++, neg = 1;
  801746:	ff 45 08             	incl   0x8(%ebp)
  801749:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801750:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801754:	74 06                	je     80175c <strtol+0x58>
  801756:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80175a:	75 20                	jne    80177c <strtol+0x78>
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8a 00                	mov    (%eax),%al
  801761:	3c 30                	cmp    $0x30,%al
  801763:	75 17                	jne    80177c <strtol+0x78>
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	40                   	inc    %eax
  801769:	8a 00                	mov    (%eax),%al
  80176b:	3c 78                	cmp    $0x78,%al
  80176d:	75 0d                	jne    80177c <strtol+0x78>
		s += 2, base = 16;
  80176f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801773:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80177a:	eb 28                	jmp    8017a4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80177c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801780:	75 15                	jne    801797 <strtol+0x93>
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	3c 30                	cmp    $0x30,%al
  801789:	75 0c                	jne    801797 <strtol+0x93>
		s++, base = 8;
  80178b:	ff 45 08             	incl   0x8(%ebp)
  80178e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801795:	eb 0d                	jmp    8017a4 <strtol+0xa0>
	else if (base == 0)
  801797:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80179b:	75 07                	jne    8017a4 <strtol+0xa0>
		base = 10;
  80179d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	8a 00                	mov    (%eax),%al
  8017a9:	3c 2f                	cmp    $0x2f,%al
  8017ab:	7e 19                	jle    8017c6 <strtol+0xc2>
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 39                	cmp    $0x39,%al
  8017b4:	7f 10                	jg     8017c6 <strtol+0xc2>
			dig = *s - '0';
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	0f be c0             	movsbl %al,%eax
  8017be:	83 e8 30             	sub    $0x30,%eax
  8017c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017c4:	eb 42                	jmp    801808 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	8a 00                	mov    (%eax),%al
  8017cb:	3c 60                	cmp    $0x60,%al
  8017cd:	7e 19                	jle    8017e8 <strtol+0xe4>
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	8a 00                	mov    (%eax),%al
  8017d4:	3c 7a                	cmp    $0x7a,%al
  8017d6:	7f 10                	jg     8017e8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	8a 00                	mov    (%eax),%al
  8017dd:	0f be c0             	movsbl %al,%eax
  8017e0:	83 e8 57             	sub    $0x57,%eax
  8017e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017e6:	eb 20                	jmp    801808 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	8a 00                	mov    (%eax),%al
  8017ed:	3c 40                	cmp    $0x40,%al
  8017ef:	7e 39                	jle    80182a <strtol+0x126>
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	8a 00                	mov    (%eax),%al
  8017f6:	3c 5a                	cmp    $0x5a,%al
  8017f8:	7f 30                	jg     80182a <strtol+0x126>
			dig = *s - 'A' + 10;
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8a 00                	mov    (%eax),%al
  8017ff:	0f be c0             	movsbl %al,%eax
  801802:	83 e8 37             	sub    $0x37,%eax
  801805:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80180e:	7d 19                	jge    801829 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801810:	ff 45 08             	incl   0x8(%ebp)
  801813:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801816:	0f af 45 10          	imul   0x10(%ebp),%eax
  80181a:	89 c2                	mov    %eax,%edx
  80181c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181f:	01 d0                	add    %edx,%eax
  801821:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801824:	e9 7b ff ff ff       	jmp    8017a4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801829:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80182a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80182e:	74 08                	je     801838 <strtol+0x134>
		*endptr = (char *) s;
  801830:	8b 45 0c             	mov    0xc(%ebp),%eax
  801833:	8b 55 08             	mov    0x8(%ebp),%edx
  801836:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801838:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80183c:	74 07                	je     801845 <strtol+0x141>
  80183e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801841:	f7 d8                	neg    %eax
  801843:	eb 03                	jmp    801848 <strtol+0x144>
  801845:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <ltostr>:

void
ltostr(long value, char *str)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801850:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801857:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80185e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801862:	79 13                	jns    801877 <ltostr+0x2d>
	{
		neg = 1;
  801864:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80186b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801871:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801874:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80187f:	99                   	cltd   
  801880:	f7 f9                	idiv   %ecx
  801882:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801885:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801888:	8d 50 01             	lea    0x1(%eax),%edx
  80188b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80188e:	89 c2                	mov    %eax,%edx
  801890:	8b 45 0c             	mov    0xc(%ebp),%eax
  801893:	01 d0                	add    %edx,%eax
  801895:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801898:	83 c2 30             	add    $0x30,%edx
  80189b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80189d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018a5:	f7 e9                	imul   %ecx
  8018a7:	c1 fa 02             	sar    $0x2,%edx
  8018aa:	89 c8                	mov    %ecx,%eax
  8018ac:	c1 f8 1f             	sar    $0x1f,%eax
  8018af:	29 c2                	sub    %eax,%edx
  8018b1:	89 d0                	mov    %edx,%eax
  8018b3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018ba:	75 bb                	jne    801877 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c6:	48                   	dec    %eax
  8018c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ce:	74 3d                	je     80190d <ltostr+0xc3>
		start = 1 ;
  8018d0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018d7:	eb 34                	jmp    80190d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018df:	01 d0                	add    %edx,%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ec:	01 c2                	add    %eax,%edx
  8018ee:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f4:	01 c8                	add    %ecx,%eax
  8018f6:	8a 00                	mov    (%eax),%al
  8018f8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801900:	01 c2                	add    %eax,%edx
  801902:	8a 45 eb             	mov    -0x15(%ebp),%al
  801905:	88 02                	mov    %al,(%edx)
		start++ ;
  801907:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80190a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80190d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801910:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801913:	7c c4                	jl     8018d9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801915:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191b:	01 d0                	add    %edx,%eax
  80191d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801920:	90                   	nop
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801929:	ff 75 08             	pushl  0x8(%ebp)
  80192c:	e8 c4 f9 ff ff       	call   8012f5 <strlen>
  801931:	83 c4 04             	add    $0x4,%esp
  801934:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	e8 b6 f9 ff ff       	call   8012f5 <strlen>
  80193f:	83 c4 04             	add    $0x4,%esp
  801942:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801945:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80194c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801953:	eb 17                	jmp    80196c <strcconcat+0x49>
		final[s] = str1[s] ;
  801955:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801958:	8b 45 10             	mov    0x10(%ebp),%eax
  80195b:	01 c2                	add    %eax,%edx
  80195d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	01 c8                	add    %ecx,%eax
  801965:	8a 00                	mov    (%eax),%al
  801967:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801969:	ff 45 fc             	incl   -0x4(%ebp)
  80196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80196f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801972:	7c e1                	jl     801955 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801974:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80197b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801982:	eb 1f                	jmp    8019a3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801984:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801987:	8d 50 01             	lea    0x1(%eax),%edx
  80198a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80198d:	89 c2                	mov    %eax,%edx
  80198f:	8b 45 10             	mov    0x10(%ebp),%eax
  801992:	01 c2                	add    %eax,%edx
  801994:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801997:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199a:	01 c8                	add    %ecx,%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019a0:	ff 45 f8             	incl   -0x8(%ebp)
  8019a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a9:	7c d9                	jl     801984 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b1:	01 d0                	add    %edx,%eax
  8019b3:	c6 00 00             	movb   $0x0,(%eax)
}
  8019b6:	90                   	nop
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c8:	8b 00                	mov    (%eax),%eax
  8019ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d4:	01 d0                	add    %edx,%eax
  8019d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019dc:	eb 0c                	jmp    8019ea <strsplit+0x31>
			*string++ = 0;
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	8d 50 01             	lea    0x1(%eax),%edx
  8019e4:	89 55 08             	mov    %edx,0x8(%ebp)
  8019e7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	8a 00                	mov    (%eax),%al
  8019ef:	84 c0                	test   %al,%al
  8019f1:	74 18                	je     801a0b <strsplit+0x52>
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	8a 00                	mov    (%eax),%al
  8019f8:	0f be c0             	movsbl %al,%eax
  8019fb:	50                   	push   %eax
  8019fc:	ff 75 0c             	pushl  0xc(%ebp)
  8019ff:	e8 83 fa ff ff       	call   801487 <strchr>
  801a04:	83 c4 08             	add    $0x8,%esp
  801a07:	85 c0                	test   %eax,%eax
  801a09:	75 d3                	jne    8019de <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	8a 00                	mov    (%eax),%al
  801a10:	84 c0                	test   %al,%al
  801a12:	74 5a                	je     801a6e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a14:	8b 45 14             	mov    0x14(%ebp),%eax
  801a17:	8b 00                	mov    (%eax),%eax
  801a19:	83 f8 0f             	cmp    $0xf,%eax
  801a1c:	75 07                	jne    801a25 <strsplit+0x6c>
		{
			return 0;
  801a1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a23:	eb 66                	jmp    801a8b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a25:	8b 45 14             	mov    0x14(%ebp),%eax
  801a28:	8b 00                	mov    (%eax),%eax
  801a2a:	8d 48 01             	lea    0x1(%eax),%ecx
  801a2d:	8b 55 14             	mov    0x14(%ebp),%edx
  801a30:	89 0a                	mov    %ecx,(%edx)
  801a32:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a39:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3c:	01 c2                	add    %eax,%edx
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a43:	eb 03                	jmp    801a48 <strsplit+0x8f>
			string++;
  801a45:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	8a 00                	mov    (%eax),%al
  801a4d:	84 c0                	test   %al,%al
  801a4f:	74 8b                	je     8019dc <strsplit+0x23>
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	8a 00                	mov    (%eax),%al
  801a56:	0f be c0             	movsbl %al,%eax
  801a59:	50                   	push   %eax
  801a5a:	ff 75 0c             	pushl  0xc(%ebp)
  801a5d:	e8 25 fa ff ff       	call   801487 <strchr>
  801a62:	83 c4 08             	add    $0x8,%esp
  801a65:	85 c0                	test   %eax,%eax
  801a67:	74 dc                	je     801a45 <strsplit+0x8c>
			string++;
	}
  801a69:	e9 6e ff ff ff       	jmp    8019dc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a6e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a72:	8b 00                	mov    (%eax),%eax
  801a74:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7e:	01 d0                	add    %edx,%eax
  801a80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a86:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801aa0:	eb 4a                	jmp    801aec <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801aa2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	01 c2                	add    %eax,%edx
  801aaa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab0:	01 c8                	add    %ecx,%eax
  801ab2:	8a 00                	mov    (%eax),%al
  801ab4:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801ab6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abc:	01 d0                	add    %edx,%eax
  801abe:	8a 00                	mov    (%eax),%al
  801ac0:	3c 40                	cmp    $0x40,%al
  801ac2:	7e 25                	jle    801ae9 <str2lower+0x5c>
  801ac4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aca:	01 d0                	add    %edx,%eax
  801acc:	8a 00                	mov    (%eax),%al
  801ace:	3c 5a                	cmp    $0x5a,%al
  801ad0:	7f 17                	jg     801ae9 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801ad2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	01 d0                	add    %edx,%eax
  801ada:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801add:	8b 55 08             	mov    0x8(%ebp),%edx
  801ae0:	01 ca                	add    %ecx,%edx
  801ae2:	8a 12                	mov    (%edx),%dl
  801ae4:	83 c2 20             	add    $0x20,%edx
  801ae7:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801ae9:	ff 45 fc             	incl   -0x4(%ebp)
  801aec:	ff 75 0c             	pushl  0xc(%ebp)
  801aef:	e8 01 f8 ff ff       	call   8012f5 <strlen>
  801af4:	83 c4 04             	add    $0x4,%esp
  801af7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801afa:	7f a6                	jg     801aa2 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801afc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801b07:	83 ec 0c             	sub    $0xc,%esp
  801b0a:	6a 10                	push   $0x10
  801b0c:	e8 b2 15 00 00       	call   8030c3 <alloc_block>
  801b11:	83 c4 10             	add    $0x10,%esp
  801b14:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801b17:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b1b:	75 14                	jne    801b31 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801b1d:	83 ec 04             	sub    $0x4,%esp
  801b20:	68 68 45 80 00       	push   $0x804568
  801b25:	6a 14                	push   $0x14
  801b27:	68 91 45 80 00       	push   $0x804591
  801b2c:	e8 fd ed ff ff       	call   80092e <_panic>

	node->start = start;
  801b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b34:	8b 55 08             	mov    0x8(%ebp),%edx
  801b37:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3f:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801b42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801b49:	a1 28 50 80 00       	mov    0x805028,%eax
  801b4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b51:	eb 18                	jmp    801b6b <insert_page_alloc+0x6a>
		if (start < it->start)
  801b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b56:	8b 00                	mov    (%eax),%eax
  801b58:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b5b:	77 37                	ja     801b94 <insert_page_alloc+0x93>
			break;
		prev = it;
  801b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b60:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801b63:	a1 30 50 80 00       	mov    0x805030,%eax
  801b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b6f:	74 08                	je     801b79 <insert_page_alloc+0x78>
  801b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b74:	8b 40 08             	mov    0x8(%eax),%eax
  801b77:	eb 05                	jmp    801b7e <insert_page_alloc+0x7d>
  801b79:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7e:	a3 30 50 80 00       	mov    %eax,0x805030
  801b83:	a1 30 50 80 00       	mov    0x805030,%eax
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	75 c7                	jne    801b53 <insert_page_alloc+0x52>
  801b8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b90:	75 c1                	jne    801b53 <insert_page_alloc+0x52>
  801b92:	eb 01                	jmp    801b95 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801b94:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801b95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b99:	75 64                	jne    801bff <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801b9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b9f:	75 14                	jne    801bb5 <insert_page_alloc+0xb4>
  801ba1:	83 ec 04             	sub    $0x4,%esp
  801ba4:	68 a0 45 80 00       	push   $0x8045a0
  801ba9:	6a 21                	push   $0x21
  801bab:	68 91 45 80 00       	push   $0x804591
  801bb0:	e8 79 ed ff ff       	call   80092e <_panic>
  801bb5:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801bbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bbe:	89 50 08             	mov    %edx,0x8(%eax)
  801bc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc4:	8b 40 08             	mov    0x8(%eax),%eax
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	74 0d                	je     801bd8 <insert_page_alloc+0xd7>
  801bcb:	a1 28 50 80 00       	mov    0x805028,%eax
  801bd0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bd3:	89 50 0c             	mov    %edx,0xc(%eax)
  801bd6:	eb 08                	jmp    801be0 <insert_page_alloc+0xdf>
  801bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bdb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801be0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be3:	a3 28 50 80 00       	mov    %eax,0x805028
  801be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801beb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801bf2:	a1 34 50 80 00       	mov    0x805034,%eax
  801bf7:	40                   	inc    %eax
  801bf8:	a3 34 50 80 00       	mov    %eax,0x805034
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801bfd:	eb 71                	jmp    801c70 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801bff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c03:	74 06                	je     801c0b <insert_page_alloc+0x10a>
  801c05:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c09:	75 14                	jne    801c1f <insert_page_alloc+0x11e>
  801c0b:	83 ec 04             	sub    $0x4,%esp
  801c0e:	68 c4 45 80 00       	push   $0x8045c4
  801c13:	6a 23                	push   $0x23
  801c15:	68 91 45 80 00       	push   $0x804591
  801c1a:	e8 0f ed ff ff       	call   80092e <_panic>
  801c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c22:	8b 50 08             	mov    0x8(%eax),%edx
  801c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c28:	89 50 08             	mov    %edx,0x8(%eax)
  801c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c2e:	8b 40 08             	mov    0x8(%eax),%eax
  801c31:	85 c0                	test   %eax,%eax
  801c33:	74 0c                	je     801c41 <insert_page_alloc+0x140>
  801c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c38:	8b 40 08             	mov    0x8(%eax),%eax
  801c3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c3e:	89 50 0c             	mov    %edx,0xc(%eax)
  801c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c44:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c47:	89 50 08             	mov    %edx,0x8(%eax)
  801c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c50:	89 50 0c             	mov    %edx,0xc(%eax)
  801c53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c56:	8b 40 08             	mov    0x8(%eax),%eax
  801c59:	85 c0                	test   %eax,%eax
  801c5b:	75 08                	jne    801c65 <insert_page_alloc+0x164>
  801c5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c60:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801c65:	a1 34 50 80 00       	mov    0x805034,%eax
  801c6a:	40                   	inc    %eax
  801c6b:	a3 34 50 80 00       	mov    %eax,0x805034
}
  801c70:	90                   	nop
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801c79:	a1 28 50 80 00       	mov    0x805028,%eax
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	75 0c                	jne    801c8e <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801c82:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c87:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801c8c:	eb 67                	jmp    801cf5 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801c8e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801c96:	a1 28 50 80 00       	mov    0x805028,%eax
  801c9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801c9e:	eb 26                	jmp    801cc6 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801ca0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ca3:	8b 10                	mov    (%eax),%edx
  801ca5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ca8:	8b 40 04             	mov    0x4(%eax),%eax
  801cab:	01 d0                	add    %edx,%eax
  801cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801cb6:	76 06                	jbe    801cbe <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801cbe:	a1 30 50 80 00       	mov    0x805030,%eax
  801cc3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801cc6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801cca:	74 08                	je     801cd4 <recompute_page_alloc_break+0x61>
  801ccc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ccf:	8b 40 08             	mov    0x8(%eax),%eax
  801cd2:	eb 05                	jmp    801cd9 <recompute_page_alloc_break+0x66>
  801cd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd9:	a3 30 50 80 00       	mov    %eax,0x805030
  801cde:	a1 30 50 80 00       	mov    0x805030,%eax
  801ce3:	85 c0                	test   %eax,%eax
  801ce5:	75 b9                	jne    801ca0 <recompute_page_alloc_break+0x2d>
  801ce7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ceb:	75 b3                	jne    801ca0 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801ced:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cf0:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801cfd:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801d04:	8b 55 08             	mov    0x8(%ebp),%edx
  801d07:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d0a:	01 d0                	add    %edx,%eax
  801d0c:	48                   	dec    %eax
  801d0d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801d10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d13:	ba 00 00 00 00       	mov    $0x0,%edx
  801d18:	f7 75 d8             	divl   -0x28(%ebp)
  801d1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d1e:	29 d0                	sub    %edx,%eax
  801d20:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801d23:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801d27:	75 0a                	jne    801d33 <alloc_pages_custom_fit+0x3c>
		return NULL;
  801d29:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2e:	e9 7e 01 00 00       	jmp    801eb1 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801d33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801d3a:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801d3e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801d45:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801d4c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801d54:	a1 28 50 80 00       	mov    0x805028,%eax
  801d59:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d5c:	eb 69                	jmp    801dc7 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d61:	8b 00                	mov    (%eax),%eax
  801d63:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d66:	76 47                	jbe    801daf <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801d68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d6b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801d6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d71:	8b 00                	mov    (%eax),%eax
  801d73:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801d76:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801d79:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d7c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801d7f:	72 2e                	jb     801daf <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801d81:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801d85:	75 14                	jne    801d9b <alloc_pages_custom_fit+0xa4>
  801d87:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d8a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801d8d:	75 0c                	jne    801d9b <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801d8f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801d95:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801d99:	eb 14                	jmp    801daf <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801d9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d9e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801da1:	76 0c                	jbe    801daf <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801da3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801da6:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801da9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801dac:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801daf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801db2:	8b 10                	mov    (%eax),%edx
  801db4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801db7:	8b 40 04             	mov    0x4(%eax),%eax
  801dba:	01 d0                	add    %edx,%eax
  801dbc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801dbf:	a1 30 50 80 00       	mov    0x805030,%eax
  801dc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801dc7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dcb:	74 08                	je     801dd5 <alloc_pages_custom_fit+0xde>
  801dcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dd0:	8b 40 08             	mov    0x8(%eax),%eax
  801dd3:	eb 05                	jmp    801dda <alloc_pages_custom_fit+0xe3>
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dda:	a3 30 50 80 00       	mov    %eax,0x805030
  801ddf:	a1 30 50 80 00       	mov    0x805030,%eax
  801de4:	85 c0                	test   %eax,%eax
  801de6:	0f 85 72 ff ff ff    	jne    801d5e <alloc_pages_custom_fit+0x67>
  801dec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801df0:	0f 85 68 ff ff ff    	jne    801d5e <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801df6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801dfb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801dfe:	76 47                	jbe    801e47 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e03:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801e06:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e0b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801e0e:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801e11:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e14:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e17:	72 2e                	jb     801e47 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801e19:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801e1d:	75 14                	jne    801e33 <alloc_pages_custom_fit+0x13c>
  801e1f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e22:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e25:	75 0c                	jne    801e33 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801e27:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801e2d:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801e31:	eb 14                	jmp    801e47 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801e33:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e36:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e39:	76 0c                	jbe    801e47 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801e3b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801e41:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e44:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801e47:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801e4e:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801e52:	74 08                	je     801e5c <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e57:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e5a:	eb 40                	jmp    801e9c <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801e5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e60:	74 08                	je     801e6a <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801e62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e65:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e68:	eb 32                	jmp    801e9c <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801e6a:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801e6f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801e72:	89 c2                	mov    %eax,%edx
  801e74:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e79:	39 c2                	cmp    %eax,%edx
  801e7b:	73 07                	jae    801e84 <alloc_pages_custom_fit+0x18d>
			return NULL;
  801e7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e82:	eb 2d                	jmp    801eb1 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801e84:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e89:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801e8c:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801e92:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e95:	01 d0                	add    %edx,%eax
  801e97:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801e9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e9f:	83 ec 08             	sub    $0x8,%esp
  801ea2:	ff 75 d0             	pushl  -0x30(%ebp)
  801ea5:	50                   	push   %eax
  801ea6:	e8 56 fc ff ff       	call   801b01 <insert_page_alloc>
  801eab:	83 c4 10             	add    $0x10,%esp

	return result;
  801eae:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801ebf:	a1 28 50 80 00       	mov    0x805028,%eax
  801ec4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ec7:	eb 1a                	jmp    801ee3 <find_allocated_size+0x30>
		if (it->start == va)
  801ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ecc:	8b 00                	mov    (%eax),%eax
  801ece:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801ed1:	75 08                	jne    801edb <find_allocated_size+0x28>
			return it->size;
  801ed3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ed6:	8b 40 04             	mov    0x4(%eax),%eax
  801ed9:	eb 34                	jmp    801f0f <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801edb:	a1 30 50 80 00       	mov    0x805030,%eax
  801ee0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ee3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ee7:	74 08                	je     801ef1 <find_allocated_size+0x3e>
  801ee9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eec:	8b 40 08             	mov    0x8(%eax),%eax
  801eef:	eb 05                	jmp    801ef6 <find_allocated_size+0x43>
  801ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef6:	a3 30 50 80 00       	mov    %eax,0x805030
  801efb:	a1 30 50 80 00       	mov    0x805030,%eax
  801f00:	85 c0                	test   %eax,%eax
  801f02:	75 c5                	jne    801ec9 <find_allocated_size+0x16>
  801f04:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f08:	75 bf                	jne    801ec9 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801f0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f1d:	a1 28 50 80 00       	mov    0x805028,%eax
  801f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f25:	e9 e1 01 00 00       	jmp    80210b <free_pages+0x1fa>
		if (it->start == va) {
  801f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2d:	8b 00                	mov    (%eax),%eax
  801f2f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f32:	0f 85 cb 01 00 00    	jne    802103 <free_pages+0x1f2>

			uint32 start = it->start;
  801f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3b:	8b 00                	mov    (%eax),%eax
  801f3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f43:	8b 40 04             	mov    0x4(%eax),%eax
  801f46:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801f49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f4c:	f7 d0                	not    %eax
  801f4e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f51:	73 1d                	jae    801f70 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801f53:	83 ec 0c             	sub    $0xc,%esp
  801f56:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f59:	ff 75 e8             	pushl  -0x18(%ebp)
  801f5c:	68 f8 45 80 00       	push   $0x8045f8
  801f61:	68 a5 00 00 00       	push   $0xa5
  801f66:	68 91 45 80 00       	push   $0x804591
  801f6b:	e8 be e9 ff ff       	call   80092e <_panic>
			}

			uint32 start_end = start + size;
  801f70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f76:	01 d0                	add    %edx,%eax
  801f78:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801f7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	79 19                	jns    801f9b <free_pages+0x8a>
  801f82:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801f89:	77 10                	ja     801f9b <free_pages+0x8a>
  801f8b:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801f92:	77 07                	ja     801f9b <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801f94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f97:	85 c0                	test   %eax,%eax
  801f99:	78 2c                	js     801fc7 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801f9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f9e:	83 ec 0c             	sub    $0xc,%esp
  801fa1:	68 00 00 00 a0       	push   $0xa0000000
  801fa6:	ff 75 e0             	pushl  -0x20(%ebp)
  801fa9:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fac:	ff 75 e8             	pushl  -0x18(%ebp)
  801faf:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fb2:	50                   	push   %eax
  801fb3:	68 3c 46 80 00       	push   $0x80463c
  801fb8:	68 ad 00 00 00       	push   $0xad
  801fbd:	68 91 45 80 00       	push   $0x804591
  801fc2:	e8 67 e9 ff ff       	call   80092e <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801fc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fcd:	e9 88 00 00 00       	jmp    80205a <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801fd2:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801fd9:	76 17                	jbe    801ff2 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801fdb:	ff 75 f0             	pushl  -0x10(%ebp)
  801fde:	68 a0 46 80 00       	push   $0x8046a0
  801fe3:	68 b4 00 00 00       	push   $0xb4
  801fe8:	68 91 45 80 00       	push   $0x804591
  801fed:	e8 3c e9 ff ff       	call   80092e <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff5:	05 00 10 00 00       	add    $0x1000,%eax
  801ffa:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802000:	85 c0                	test   %eax,%eax
  802002:	79 2e                	jns    802032 <free_pages+0x121>
  802004:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80200b:	77 25                	ja     802032 <free_pages+0x121>
  80200d:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802014:	77 1c                	ja     802032 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  802016:	83 ec 08             	sub    $0x8,%esp
  802019:	68 00 10 00 00       	push   $0x1000
  80201e:	ff 75 f0             	pushl  -0x10(%ebp)
  802021:	e8 38 0d 00 00       	call   802d5e <sys_free_user_mem>
  802026:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802029:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802030:	eb 28                	jmp    80205a <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  802032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802035:	68 00 00 00 a0       	push   $0xa0000000
  80203a:	ff 75 dc             	pushl  -0x24(%ebp)
  80203d:	68 00 10 00 00       	push   $0x1000
  802042:	ff 75 f0             	pushl  -0x10(%ebp)
  802045:	50                   	push   %eax
  802046:	68 e0 46 80 00       	push   $0x8046e0
  80204b:	68 bd 00 00 00       	push   $0xbd
  802050:	68 91 45 80 00       	push   $0x804591
  802055:	e8 d4 e8 ff ff       	call   80092e <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  80205a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802060:	0f 82 6c ff ff ff    	jb     801fd2 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802066:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80206a:	75 17                	jne    802083 <free_pages+0x172>
  80206c:	83 ec 04             	sub    $0x4,%esp
  80206f:	68 42 47 80 00       	push   $0x804742
  802074:	68 c1 00 00 00       	push   $0xc1
  802079:	68 91 45 80 00       	push   $0x804591
  80207e:	e8 ab e8 ff ff       	call   80092e <_panic>
  802083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802086:	8b 40 08             	mov    0x8(%eax),%eax
  802089:	85 c0                	test   %eax,%eax
  80208b:	74 11                	je     80209e <free_pages+0x18d>
  80208d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802090:	8b 40 08             	mov    0x8(%eax),%eax
  802093:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802096:	8b 52 0c             	mov    0xc(%edx),%edx
  802099:	89 50 0c             	mov    %edx,0xc(%eax)
  80209c:	eb 0b                	jmp    8020a9 <free_pages+0x198>
  80209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	74 11                	je     8020c4 <free_pages+0x1b3>
  8020b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bc:	8b 52 08             	mov    0x8(%edx),%edx
  8020bf:	89 50 08             	mov    %edx,0x8(%eax)
  8020c2:	eb 0b                	jmp    8020cf <free_pages+0x1be>
  8020c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c7:	8b 40 08             	mov    0x8(%eax),%eax
  8020ca:	a3 28 50 80 00       	mov    %eax,0x805028
  8020cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8020e3:	a1 34 50 80 00       	mov    0x805034,%eax
  8020e8:	48                   	dec    %eax
  8020e9:	a3 34 50 80 00       	mov    %eax,0x805034
			free_block(it);
  8020ee:	83 ec 0c             	sub    $0xc,%esp
  8020f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f4:	e8 24 15 00 00       	call   80361d <free_block>
  8020f9:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  8020fc:	e8 72 fb ff ff       	call   801c73 <recompute_page_alloc_break>

			return;
  802101:	eb 37                	jmp    80213a <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802103:	a1 30 50 80 00       	mov    0x805030,%eax
  802108:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80210b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80210f:	74 08                	je     802119 <free_pages+0x208>
  802111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802114:	8b 40 08             	mov    0x8(%eax),%eax
  802117:	eb 05                	jmp    80211e <free_pages+0x20d>
  802119:	b8 00 00 00 00       	mov    $0x0,%eax
  80211e:	a3 30 50 80 00       	mov    %eax,0x805030
  802123:	a1 30 50 80 00       	mov    0x805030,%eax
  802128:	85 c0                	test   %eax,%eax
  80212a:	0f 85 fa fd ff ff    	jne    801f2a <free_pages+0x19>
  802130:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802134:	0f 85 f0 fd ff ff    	jne    801f2a <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  80213f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802144:	5d                   	pop    %ebp
  802145:	c3                   	ret    

00802146 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80214c:	a1 08 50 80 00       	mov    0x805008,%eax
  802151:	85 c0                	test   %eax,%eax
  802153:	74 60                	je     8021b5 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802155:	83 ec 08             	sub    $0x8,%esp
  802158:	68 00 00 00 82       	push   $0x82000000
  80215d:	68 00 00 00 80       	push   $0x80000000
  802162:	e8 0d 0d 00 00       	call   802e74 <initialize_dynamic_allocator>
  802167:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80216a:	e8 f3 0a 00 00       	call   802c62 <sys_get_uheap_strategy>
  80216f:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802174:	a1 40 50 80 00       	mov    0x805040,%eax
  802179:	05 00 10 00 00       	add    $0x1000,%eax
  80217e:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  802183:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802188:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  80218d:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  802194:	00 00 00 
  802197:	c7 05 2c 50 80 00 00 	movl   $0x0,0x80502c
  80219e:	00 00 00 
  8021a1:	c7 05 34 50 80 00 00 	movl   $0x0,0x805034
  8021a8:	00 00 00 

		__firstTimeFlag = 0;
  8021ab:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8021b2:	00 00 00 
	}
}
  8021b5:	90                   	nop
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8021cc:	83 ec 08             	sub    $0x8,%esp
  8021cf:	68 06 04 00 00       	push   $0x406
  8021d4:	50                   	push   %eax
  8021d5:	e8 d2 06 00 00       	call   8028ac <__sys_allocate_page>
  8021da:	83 c4 10             	add    $0x10,%esp
  8021dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8021e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021e4:	79 17                	jns    8021fd <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  8021e6:	83 ec 04             	sub    $0x4,%esp
  8021e9:	68 60 47 80 00       	push   $0x804760
  8021ee:	68 ea 00 00 00       	push   $0xea
  8021f3:	68 91 45 80 00       	push   $0x804591
  8021f8:	e8 31 e7 ff ff       	call   80092e <_panic>
	return 0;
  8021fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802213:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802218:	83 ec 0c             	sub    $0xc,%esp
  80221b:	50                   	push   %eax
  80221c:	e8 d2 06 00 00       	call   8028f3 <__sys_unmap_frame>
  802221:	83 c4 10             	add    $0x10,%esp
  802224:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802227:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80222b:	79 17                	jns    802244 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  80222d:	83 ec 04             	sub    $0x4,%esp
  802230:	68 9c 47 80 00       	push   $0x80479c
  802235:	68 f5 00 00 00       	push   $0xf5
  80223a:	68 91 45 80 00       	push   $0x804591
  80223f:	e8 ea e6 ff ff       	call   80092e <_panic>
}
  802244:	90                   	nop
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
  80224a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80224d:	e8 f4 fe ff ff       	call   802146 <uheap_init>
	if (size == 0) return NULL ;
  802252:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802256:	75 0a                	jne    802262 <malloc+0x1b>
  802258:	b8 00 00 00 00       	mov    $0x0,%eax
  80225d:	e9 67 01 00 00       	jmp    8023c9 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  802262:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  802269:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802270:	77 16                	ja     802288 <malloc+0x41>
		result = alloc_block(size);
  802272:	83 ec 0c             	sub    $0xc,%esp
  802275:	ff 75 08             	pushl  0x8(%ebp)
  802278:	e8 46 0e 00 00       	call   8030c3 <alloc_block>
  80227d:	83 c4 10             	add    $0x10,%esp
  802280:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802283:	e9 3e 01 00 00       	jmp    8023c6 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802288:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80228f:	8b 55 08             	mov    0x8(%ebp),%edx
  802292:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802295:	01 d0                	add    %edx,%eax
  802297:	48                   	dec    %eax
  802298:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80229b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229e:	ba 00 00 00 00       	mov    $0x0,%edx
  8022a3:	f7 75 f0             	divl   -0x10(%ebp)
  8022a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a9:	29 d0                	sub    %edx,%eax
  8022ab:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  8022ae:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	75 0a                	jne    8022c1 <malloc+0x7a>
			return NULL;
  8022b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bc:	e9 08 01 00 00       	jmp    8023c9 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  8022c1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	74 0f                	je     8022d9 <malloc+0x92>
  8022ca:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8022d0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022d5:	39 c2                	cmp    %eax,%edx
  8022d7:	73 0a                	jae    8022e3 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  8022d9:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022de:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8022e3:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8022e8:	83 f8 05             	cmp    $0x5,%eax
  8022eb:	75 11                	jne    8022fe <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  8022ed:	83 ec 0c             	sub    $0xc,%esp
  8022f0:	ff 75 e8             	pushl  -0x18(%ebp)
  8022f3:	e8 ff f9 ff ff       	call   801cf7 <alloc_pages_custom_fit>
  8022f8:	83 c4 10             	add    $0x10,%esp
  8022fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  8022fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802302:	0f 84 be 00 00 00    	je     8023c6 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  80230e:	83 ec 0c             	sub    $0xc,%esp
  802311:	ff 75 f4             	pushl  -0xc(%ebp)
  802314:	e8 9a fb ff ff       	call   801eb3 <find_allocated_size>
  802319:	83 c4 10             	add    $0x10,%esp
  80231c:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  80231f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802323:	75 17                	jne    80233c <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802325:	ff 75 f4             	pushl  -0xc(%ebp)
  802328:	68 dc 47 80 00       	push   $0x8047dc
  80232d:	68 24 01 00 00       	push   $0x124
  802332:	68 91 45 80 00       	push   $0x804591
  802337:	e8 f2 e5 ff ff       	call   80092e <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  80233c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80233f:	f7 d0                	not    %eax
  802341:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802344:	73 1d                	jae    802363 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  802346:	83 ec 0c             	sub    $0xc,%esp
  802349:	ff 75 e0             	pushl  -0x20(%ebp)
  80234c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80234f:	68 24 48 80 00       	push   $0x804824
  802354:	68 29 01 00 00       	push   $0x129
  802359:	68 91 45 80 00       	push   $0x804591
  80235e:	e8 cb e5 ff ff       	call   80092e <_panic>
			}

			uint32 result_end = result_va + actual_size;
  802363:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802366:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802369:	01 d0                	add    %edx,%eax
  80236b:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  80236e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802371:	85 c0                	test   %eax,%eax
  802373:	79 2c                	jns    8023a1 <malloc+0x15a>
  802375:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  80237c:	77 23                	ja     8023a1 <malloc+0x15a>
  80237e:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802385:	77 1a                	ja     8023a1 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  802387:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80238a:	85 c0                	test   %eax,%eax
  80238c:	79 13                	jns    8023a1 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  80238e:	83 ec 08             	sub    $0x8,%esp
  802391:	ff 75 e0             	pushl  -0x20(%ebp)
  802394:	ff 75 e4             	pushl  -0x1c(%ebp)
  802397:	e8 de 09 00 00       	call   802d7a <sys_allocate_user_mem>
  80239c:	83 c4 10             	add    $0x10,%esp
  80239f:	eb 25                	jmp    8023c6 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  8023a1:	68 00 00 00 a0       	push   $0xa0000000
  8023a6:	ff 75 dc             	pushl  -0x24(%ebp)
  8023a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8023ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023af:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b2:	68 60 48 80 00       	push   $0x804860
  8023b7:	68 33 01 00 00       	push   $0x133
  8023bc:	68 91 45 80 00       	push   $0x804591
  8023c1:	e8 68 e5 ff ff       	call   80092e <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  8023c9:	c9                   	leave  
  8023ca:	c3                   	ret    

008023cb <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
  8023ce:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8023d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d5:	0f 84 26 01 00 00    	je     802501 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	79 1c                	jns    802404 <free+0x39>
  8023e8:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  8023ef:	77 13                	ja     802404 <free+0x39>
		free_block(virtual_address);
  8023f1:	83 ec 0c             	sub    $0xc,%esp
  8023f4:	ff 75 08             	pushl  0x8(%ebp)
  8023f7:	e8 21 12 00 00       	call   80361d <free_block>
  8023fc:	83 c4 10             	add    $0x10,%esp
		return;
  8023ff:	e9 01 01 00 00       	jmp    802505 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  802404:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802409:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80240c:	0f 82 d8 00 00 00    	jb     8024ea <free+0x11f>
  802412:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  802419:	0f 87 cb 00 00 00    	ja     8024ea <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	25 ff 0f 00 00       	and    $0xfff,%eax
  802427:	85 c0                	test   %eax,%eax
  802429:	74 17                	je     802442 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  80242b:	ff 75 08             	pushl  0x8(%ebp)
  80242e:	68 d0 48 80 00       	push   $0x8048d0
  802433:	68 57 01 00 00       	push   $0x157
  802438:	68 91 45 80 00       	push   $0x804591
  80243d:	e8 ec e4 ff ff       	call   80092e <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  802442:	83 ec 0c             	sub    $0xc,%esp
  802445:	ff 75 08             	pushl  0x8(%ebp)
  802448:	e8 66 fa ff ff       	call   801eb3 <find_allocated_size>
  80244d:	83 c4 10             	add    $0x10,%esp
  802450:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  802453:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802457:	0f 84 a7 00 00 00    	je     802504 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  80245d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802460:	f7 d0                	not    %eax
  802462:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802465:	73 1d                	jae    802484 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  802467:	83 ec 0c             	sub    $0xc,%esp
  80246a:	ff 75 f0             	pushl  -0x10(%ebp)
  80246d:	ff 75 f4             	pushl  -0xc(%ebp)
  802470:	68 f8 48 80 00       	push   $0x8048f8
  802475:	68 61 01 00 00       	push   $0x161
  80247a:	68 91 45 80 00       	push   $0x804591
  80247f:	e8 aa e4 ff ff       	call   80092e <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  802484:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248a:	01 d0                	add    %edx,%eax
  80248c:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	85 c0                	test   %eax,%eax
  802494:	79 19                	jns    8024af <free+0xe4>
  802496:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  80249d:	77 10                	ja     8024af <free+0xe4>
  80249f:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  8024a6:	77 07                	ja     8024af <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  8024a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	78 2b                	js     8024da <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  8024af:	83 ec 0c             	sub    $0xc,%esp
  8024b2:	68 00 00 00 a0       	push   $0xa0000000
  8024b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8024ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8024bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8024c3:	ff 75 08             	pushl  0x8(%ebp)
  8024c6:	68 34 49 80 00       	push   $0x804934
  8024cb:	68 69 01 00 00       	push   $0x169
  8024d0:	68 91 45 80 00       	push   $0x804591
  8024d5:	e8 54 e4 ff ff       	call   80092e <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  8024da:	83 ec 0c             	sub    $0xc,%esp
  8024dd:	ff 75 08             	pushl  0x8(%ebp)
  8024e0:	e8 2c fa ff ff       	call   801f11 <free_pages>
  8024e5:	83 c4 10             	add    $0x10,%esp
		return;
  8024e8:	eb 1b                	jmp    802505 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  8024ea:	ff 75 08             	pushl  0x8(%ebp)
  8024ed:	68 90 49 80 00       	push   $0x804990
  8024f2:	68 70 01 00 00       	push   $0x170
  8024f7:	68 91 45 80 00       	push   $0x804591
  8024fc:	e8 2d e4 ff ff       	call   80092e <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802501:	90                   	nop
  802502:	eb 01                	jmp    802505 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  802504:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	83 ec 38             	sub    $0x38,%esp
  80250d:	8b 45 10             	mov    0x10(%ebp),%eax
  802510:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802513:	e8 2e fc ff ff       	call   802146 <uheap_init>
	if (size == 0) return NULL ;
  802518:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80251c:	75 0a                	jne    802528 <smalloc+0x21>
  80251e:	b8 00 00 00 00       	mov    $0x0,%eax
  802523:	e9 3d 01 00 00       	jmp    802665 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  802528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80252b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  80252e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802531:	25 ff 0f 00 00       	and    $0xfff,%eax
  802536:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  802539:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80253d:	74 0e                	je     80254d <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802545:	05 00 10 00 00       	add    $0x1000,%eax
  80254a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	c1 e8 0c             	shr    $0xc,%eax
  802553:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802556:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80255b:	85 c0                	test   %eax,%eax
  80255d:	75 0a                	jne    802569 <smalloc+0x62>
		return NULL;
  80255f:	b8 00 00 00 00       	mov    $0x0,%eax
  802564:	e9 fc 00 00 00       	jmp    802665 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802569:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80256e:	85 c0                	test   %eax,%eax
  802570:	74 0f                	je     802581 <smalloc+0x7a>
  802572:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802578:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80257d:	39 c2                	cmp    %eax,%edx
  80257f:	73 0a                	jae    80258b <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  802581:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802586:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80258b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802590:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802595:	29 c2                	sub    %eax,%edx
  802597:	89 d0                	mov    %edx,%eax
  802599:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80259c:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8025a2:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025a7:	29 c2                	sub    %eax,%edx
  8025a9:	89 d0                	mov    %edx,%eax
  8025ab:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8025b4:	77 13                	ja     8025c9 <smalloc+0xc2>
  8025b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8025bc:	77 0b                	ja     8025c9 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  8025be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c1:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8025c4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8025c7:	73 0a                	jae    8025d3 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  8025c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ce:	e9 92 00 00 00       	jmp    802665 <smalloc+0x15e>
	}

	void *va = NULL;
  8025d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8025da:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8025df:	83 f8 05             	cmp    $0x5,%eax
  8025e2:	75 11                	jne    8025f5 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  8025e4:	83 ec 0c             	sub    $0xc,%esp
  8025e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ea:	e8 08 f7 ff ff       	call   801cf7 <alloc_pages_custom_fit>
  8025ef:	83 c4 10             	add    $0x10,%esp
  8025f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  8025f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025f9:	75 27                	jne    802622 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8025fb:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  802602:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802605:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802608:	89 c2                	mov    %eax,%edx
  80260a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80260f:	39 c2                	cmp    %eax,%edx
  802611:	73 07                	jae    80261a <smalloc+0x113>
			return NULL;}
  802613:	b8 00 00 00 00       	mov    $0x0,%eax
  802618:	eb 4b                	jmp    802665 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  80261a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80261f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  802622:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802626:	ff 75 f0             	pushl  -0x10(%ebp)
  802629:	50                   	push   %eax
  80262a:	ff 75 0c             	pushl  0xc(%ebp)
  80262d:	ff 75 08             	pushl  0x8(%ebp)
  802630:	e8 cb 03 00 00       	call   802a00 <sys_create_shared_object>
  802635:	83 c4 10             	add    $0x10,%esp
  802638:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80263b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80263f:	79 07                	jns    802648 <smalloc+0x141>
		return NULL;
  802641:	b8 00 00 00 00       	mov    $0x0,%eax
  802646:	eb 1d                	jmp    802665 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802648:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80264d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802650:	75 10                	jne    802662 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802652:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	01 d0                	add    %edx,%eax
  80265d:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  802662:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802665:	c9                   	leave  
  802666:	c3                   	ret    

00802667 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802667:	55                   	push   %ebp
  802668:	89 e5                	mov    %esp,%ebp
  80266a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80266d:	e8 d4 fa ff ff       	call   802146 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802672:	83 ec 08             	sub    $0x8,%esp
  802675:	ff 75 0c             	pushl  0xc(%ebp)
  802678:	ff 75 08             	pushl  0x8(%ebp)
  80267b:	e8 aa 03 00 00       	call   802a2a <sys_size_of_shared_object>
  802680:	83 c4 10             	add    $0x10,%esp
  802683:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802686:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80268a:	7f 0a                	jg     802696 <sget+0x2f>
		return NULL;
  80268c:	b8 00 00 00 00       	mov    $0x0,%eax
  802691:	e9 32 01 00 00       	jmp    8027c8 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  802696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802699:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  80269c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269f:	25 ff 0f 00 00       	and    $0xfff,%eax
  8026a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8026a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026ab:	74 0e                	je     8026bb <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8026b3:	05 00 10 00 00       	add    $0x1000,%eax
  8026b8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8026bb:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026c0:	85 c0                	test   %eax,%eax
  8026c2:	75 0a                	jne    8026ce <sget+0x67>
		return NULL;
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c9:	e9 fa 00 00 00       	jmp    8027c8 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8026ce:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	74 0f                	je     8026e6 <sget+0x7f>
  8026d7:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8026dd:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026e2:	39 c2                	cmp    %eax,%edx
  8026e4:	73 0a                	jae    8026f0 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8026e6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026eb:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8026f0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026f5:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8026fa:	29 c2                	sub    %eax,%edx
  8026fc:	89 d0                	mov    %edx,%eax
  8026fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802701:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802707:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80270c:	29 c2                	sub    %eax,%edx
  80270e:	89 d0                	mov    %edx,%eax
  802710:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802719:	77 13                	ja     80272e <sget+0xc7>
  80271b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80271e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802721:	77 0b                	ja     80272e <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802726:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802729:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80272c:	73 0a                	jae    802738 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  80272e:	b8 00 00 00 00       	mov    $0x0,%eax
  802733:	e9 90 00 00 00       	jmp    8027c8 <sget+0x161>

	void *va = NULL;
  802738:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  80273f:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802744:	83 f8 05             	cmp    $0x5,%eax
  802747:	75 11                	jne    80275a <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802749:	83 ec 0c             	sub    $0xc,%esp
  80274c:	ff 75 f4             	pushl  -0xc(%ebp)
  80274f:	e8 a3 f5 ff ff       	call   801cf7 <alloc_pages_custom_fit>
  802754:	83 c4 10             	add    $0x10,%esp
  802757:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  80275a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80275e:	75 27                	jne    802787 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802760:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802767:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80276a:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80276d:	89 c2                	mov    %eax,%edx
  80276f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802774:	39 c2                	cmp    %eax,%edx
  802776:	73 07                	jae    80277f <sget+0x118>
			return NULL;
  802778:	b8 00 00 00 00       	mov    $0x0,%eax
  80277d:	eb 49                	jmp    8027c8 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  80277f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802784:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802787:	83 ec 04             	sub    $0x4,%esp
  80278a:	ff 75 f0             	pushl  -0x10(%ebp)
  80278d:	ff 75 0c             	pushl  0xc(%ebp)
  802790:	ff 75 08             	pushl  0x8(%ebp)
  802793:	e8 af 02 00 00       	call   802a47 <sys_get_shared_object>
  802798:	83 c4 10             	add    $0x10,%esp
  80279b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  80279e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8027a2:	79 07                	jns    8027ab <sget+0x144>
		return NULL;
  8027a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a9:	eb 1d                	jmp    8027c8 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8027ab:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8027b0:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8027b3:	75 10                	jne    8027c5 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8027b5:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	01 d0                	add    %edx,%eax
  8027c0:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8027c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8027c8:	c9                   	leave  
  8027c9:	c3                   	ret    

008027ca <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8027ca:	55                   	push   %ebp
  8027cb:	89 e5                	mov    %esp,%ebp
  8027cd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8027d0:	e8 71 f9 ff ff       	call   802146 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8027d5:	83 ec 04             	sub    $0x4,%esp
  8027d8:	68 b4 49 80 00       	push   $0x8049b4
  8027dd:	68 19 02 00 00       	push   $0x219
  8027e2:	68 91 45 80 00       	push   $0x804591
  8027e7:	e8 42 e1 ff ff       	call   80092e <_panic>

008027ec <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
  8027ef:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8027f2:	83 ec 04             	sub    $0x4,%esp
  8027f5:	68 dc 49 80 00       	push   $0x8049dc
  8027fa:	68 2b 02 00 00       	push   $0x22b
  8027ff:	68 91 45 80 00       	push   $0x804591
  802804:	e8 25 e1 ff ff       	call   80092e <_panic>

00802809 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802809:	55                   	push   %ebp
  80280a:	89 e5                	mov    %esp,%ebp
  80280c:	57                   	push   %edi
  80280d:	56                   	push   %esi
  80280e:	53                   	push   %ebx
  80280f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802812:	8b 45 08             	mov    0x8(%ebp),%eax
  802815:	8b 55 0c             	mov    0xc(%ebp),%edx
  802818:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80281b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80281e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802821:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802824:	cd 30                	int    $0x30
  802826:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802829:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80282c:	83 c4 10             	add    $0x10,%esp
  80282f:	5b                   	pop    %ebx
  802830:	5e                   	pop    %esi
  802831:	5f                   	pop    %edi
  802832:	5d                   	pop    %ebp
  802833:	c3                   	ret    

00802834 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802834:	55                   	push   %ebp
  802835:	89 e5                	mov    %esp,%ebp
  802837:	83 ec 04             	sub    $0x4,%esp
  80283a:	8b 45 10             	mov    0x10(%ebp),%eax
  80283d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802840:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802843:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802847:	8b 45 08             	mov    0x8(%ebp),%eax
  80284a:	6a 00                	push   $0x0
  80284c:	51                   	push   %ecx
  80284d:	52                   	push   %edx
  80284e:	ff 75 0c             	pushl  0xc(%ebp)
  802851:	50                   	push   %eax
  802852:	6a 00                	push   $0x0
  802854:	e8 b0 ff ff ff       	call   802809 <syscall>
  802859:	83 c4 18             	add    $0x18,%esp
}
  80285c:	90                   	nop
  80285d:	c9                   	leave  
  80285e:	c3                   	ret    

0080285f <sys_cgetc>:

int
sys_cgetc(void)
{
  80285f:	55                   	push   %ebp
  802860:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802862:	6a 00                	push   $0x0
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	6a 00                	push   $0x0
  80286a:	6a 00                	push   $0x0
  80286c:	6a 02                	push   $0x2
  80286e:	e8 96 ff ff ff       	call   802809 <syscall>
  802873:	83 c4 18             	add    $0x18,%esp
}
  802876:	c9                   	leave  
  802877:	c3                   	ret    

00802878 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802878:	55                   	push   %ebp
  802879:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80287b:	6a 00                	push   $0x0
  80287d:	6a 00                	push   $0x0
  80287f:	6a 00                	push   $0x0
  802881:	6a 00                	push   $0x0
  802883:	6a 00                	push   $0x0
  802885:	6a 03                	push   $0x3
  802887:	e8 7d ff ff ff       	call   802809 <syscall>
  80288c:	83 c4 18             	add    $0x18,%esp
}
  80288f:	90                   	nop
  802890:	c9                   	leave  
  802891:	c3                   	ret    

00802892 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802892:	55                   	push   %ebp
  802893:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802895:	6a 00                	push   $0x0
  802897:	6a 00                	push   $0x0
  802899:	6a 00                	push   $0x0
  80289b:	6a 00                	push   $0x0
  80289d:	6a 00                	push   $0x0
  80289f:	6a 04                	push   $0x4
  8028a1:	e8 63 ff ff ff       	call   802809 <syscall>
  8028a6:	83 c4 18             	add    $0x18,%esp
}
  8028a9:	90                   	nop
  8028aa:	c9                   	leave  
  8028ab:	c3                   	ret    

008028ac <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8028ac:	55                   	push   %ebp
  8028ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8028af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	6a 00                	push   $0x0
  8028b7:	6a 00                	push   $0x0
  8028b9:	6a 00                	push   $0x0
  8028bb:	52                   	push   %edx
  8028bc:	50                   	push   %eax
  8028bd:	6a 08                	push   $0x8
  8028bf:	e8 45 ff ff ff       	call   802809 <syscall>
  8028c4:	83 c4 18             	add    $0x18,%esp
}
  8028c7:	c9                   	leave  
  8028c8:	c3                   	ret    

008028c9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8028c9:	55                   	push   %ebp
  8028ca:	89 e5                	mov    %esp,%ebp
  8028cc:	56                   	push   %esi
  8028cd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8028ce:	8b 75 18             	mov    0x18(%ebp),%esi
  8028d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028da:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dd:	56                   	push   %esi
  8028de:	53                   	push   %ebx
  8028df:	51                   	push   %ecx
  8028e0:	52                   	push   %edx
  8028e1:	50                   	push   %eax
  8028e2:	6a 09                	push   $0x9
  8028e4:	e8 20 ff ff ff       	call   802809 <syscall>
  8028e9:	83 c4 18             	add    $0x18,%esp
}
  8028ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028ef:	5b                   	pop    %ebx
  8028f0:	5e                   	pop    %esi
  8028f1:	5d                   	pop    %ebp
  8028f2:	c3                   	ret    

008028f3 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8028f3:	55                   	push   %ebp
  8028f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8028f6:	6a 00                	push   $0x0
  8028f8:	6a 00                	push   $0x0
  8028fa:	6a 00                	push   $0x0
  8028fc:	6a 00                	push   $0x0
  8028fe:	ff 75 08             	pushl  0x8(%ebp)
  802901:	6a 0a                	push   $0xa
  802903:	e8 01 ff ff ff       	call   802809 <syscall>
  802908:	83 c4 18             	add    $0x18,%esp
}
  80290b:	c9                   	leave  
  80290c:	c3                   	ret    

0080290d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80290d:	55                   	push   %ebp
  80290e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802910:	6a 00                	push   $0x0
  802912:	6a 00                	push   $0x0
  802914:	6a 00                	push   $0x0
  802916:	ff 75 0c             	pushl  0xc(%ebp)
  802919:	ff 75 08             	pushl  0x8(%ebp)
  80291c:	6a 0b                	push   $0xb
  80291e:	e8 e6 fe ff ff       	call   802809 <syscall>
  802923:	83 c4 18             	add    $0x18,%esp
}
  802926:	c9                   	leave  
  802927:	c3                   	ret    

00802928 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802928:	55                   	push   %ebp
  802929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80292b:	6a 00                	push   $0x0
  80292d:	6a 00                	push   $0x0
  80292f:	6a 00                	push   $0x0
  802931:	6a 00                	push   $0x0
  802933:	6a 00                	push   $0x0
  802935:	6a 0c                	push   $0xc
  802937:	e8 cd fe ff ff       	call   802809 <syscall>
  80293c:	83 c4 18             	add    $0x18,%esp
}
  80293f:	c9                   	leave  
  802940:	c3                   	ret    

00802941 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802941:	55                   	push   %ebp
  802942:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802944:	6a 00                	push   $0x0
  802946:	6a 00                	push   $0x0
  802948:	6a 00                	push   $0x0
  80294a:	6a 00                	push   $0x0
  80294c:	6a 00                	push   $0x0
  80294e:	6a 0d                	push   $0xd
  802950:	e8 b4 fe ff ff       	call   802809 <syscall>
  802955:	83 c4 18             	add    $0x18,%esp
}
  802958:	c9                   	leave  
  802959:	c3                   	ret    

0080295a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80295a:	55                   	push   %ebp
  80295b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	6a 00                	push   $0x0
  802965:	6a 00                	push   $0x0
  802967:	6a 0e                	push   $0xe
  802969:	e8 9b fe ff ff       	call   802809 <syscall>
  80296e:	83 c4 18             	add    $0x18,%esp
}
  802971:	c9                   	leave  
  802972:	c3                   	ret    

00802973 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802973:	55                   	push   %ebp
  802974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802976:	6a 00                	push   $0x0
  802978:	6a 00                	push   $0x0
  80297a:	6a 00                	push   $0x0
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	6a 0f                	push   $0xf
  802982:	e8 82 fe ff ff       	call   802809 <syscall>
  802987:	83 c4 18             	add    $0x18,%esp
}
  80298a:	c9                   	leave  
  80298b:	c3                   	ret    

0080298c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80298c:	55                   	push   %ebp
  80298d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80298f:	6a 00                	push   $0x0
  802991:	6a 00                	push   $0x0
  802993:	6a 00                	push   $0x0
  802995:	6a 00                	push   $0x0
  802997:	ff 75 08             	pushl  0x8(%ebp)
  80299a:	6a 10                	push   $0x10
  80299c:	e8 68 fe ff ff       	call   802809 <syscall>
  8029a1:	83 c4 18             	add    $0x18,%esp
}
  8029a4:	c9                   	leave  
  8029a5:	c3                   	ret    

008029a6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8029a6:	55                   	push   %ebp
  8029a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8029a9:	6a 00                	push   $0x0
  8029ab:	6a 00                	push   $0x0
  8029ad:	6a 00                	push   $0x0
  8029af:	6a 00                	push   $0x0
  8029b1:	6a 00                	push   $0x0
  8029b3:	6a 11                	push   $0x11
  8029b5:	e8 4f fe ff ff       	call   802809 <syscall>
  8029ba:	83 c4 18             	add    $0x18,%esp
}
  8029bd:	90                   	nop
  8029be:	c9                   	leave  
  8029bf:	c3                   	ret    

008029c0 <sys_cputc>:

void
sys_cputc(const char c)
{
  8029c0:	55                   	push   %ebp
  8029c1:	89 e5                	mov    %esp,%ebp
  8029c3:	83 ec 04             	sub    $0x4,%esp
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8029cc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	50                   	push   %eax
  8029d9:	6a 01                	push   $0x1
  8029db:	e8 29 fe ff ff       	call   802809 <syscall>
  8029e0:	83 c4 18             	add    $0x18,%esp
}
  8029e3:	90                   	nop
  8029e4:	c9                   	leave  
  8029e5:	c3                   	ret    

008029e6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8029e6:	55                   	push   %ebp
  8029e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8029e9:	6a 00                	push   $0x0
  8029eb:	6a 00                	push   $0x0
  8029ed:	6a 00                	push   $0x0
  8029ef:	6a 00                	push   $0x0
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 14                	push   $0x14
  8029f5:	e8 0f fe ff ff       	call   802809 <syscall>
  8029fa:	83 c4 18             	add    $0x18,%esp
}
  8029fd:	90                   	nop
  8029fe:	c9                   	leave  
  8029ff:	c3                   	ret    

00802a00 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
  802a03:	83 ec 04             	sub    $0x4,%esp
  802a06:	8b 45 10             	mov    0x10(%ebp),%eax
  802a09:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802a0c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a0f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	6a 00                	push   $0x0
  802a18:	51                   	push   %ecx
  802a19:	52                   	push   %edx
  802a1a:	ff 75 0c             	pushl  0xc(%ebp)
  802a1d:	50                   	push   %eax
  802a1e:	6a 15                	push   $0x15
  802a20:	e8 e4 fd ff ff       	call   802809 <syscall>
  802a25:	83 c4 18             	add    $0x18,%esp
}
  802a28:	c9                   	leave  
  802a29:	c3                   	ret    

00802a2a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802a2a:	55                   	push   %ebp
  802a2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	6a 00                	push   $0x0
  802a35:	6a 00                	push   $0x0
  802a37:	6a 00                	push   $0x0
  802a39:	52                   	push   %edx
  802a3a:	50                   	push   %eax
  802a3b:	6a 16                	push   $0x16
  802a3d:	e8 c7 fd ff ff       	call   802809 <syscall>
  802a42:	83 c4 18             	add    $0x18,%esp
}
  802a45:	c9                   	leave  
  802a46:	c3                   	ret    

00802a47 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802a47:	55                   	push   %ebp
  802a48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802a4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a50:	8b 45 08             	mov    0x8(%ebp),%eax
  802a53:	6a 00                	push   $0x0
  802a55:	6a 00                	push   $0x0
  802a57:	51                   	push   %ecx
  802a58:	52                   	push   %edx
  802a59:	50                   	push   %eax
  802a5a:	6a 17                	push   $0x17
  802a5c:	e8 a8 fd ff ff       	call   802809 <syscall>
  802a61:	83 c4 18             	add    $0x18,%esp
}
  802a64:	c9                   	leave  
  802a65:	c3                   	ret    

00802a66 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802a66:	55                   	push   %ebp
  802a67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802a69:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6f:	6a 00                	push   $0x0
  802a71:	6a 00                	push   $0x0
  802a73:	6a 00                	push   $0x0
  802a75:	52                   	push   %edx
  802a76:	50                   	push   %eax
  802a77:	6a 18                	push   $0x18
  802a79:	e8 8b fd ff ff       	call   802809 <syscall>
  802a7e:	83 c4 18             	add    $0x18,%esp
}
  802a81:	c9                   	leave  
  802a82:	c3                   	ret    

00802a83 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802a83:	55                   	push   %ebp
  802a84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802a86:	8b 45 08             	mov    0x8(%ebp),%eax
  802a89:	6a 00                	push   $0x0
  802a8b:	ff 75 14             	pushl  0x14(%ebp)
  802a8e:	ff 75 10             	pushl  0x10(%ebp)
  802a91:	ff 75 0c             	pushl  0xc(%ebp)
  802a94:	50                   	push   %eax
  802a95:	6a 19                	push   $0x19
  802a97:	e8 6d fd ff ff       	call   802809 <syscall>
  802a9c:	83 c4 18             	add    $0x18,%esp
}
  802a9f:	c9                   	leave  
  802aa0:	c3                   	ret    

00802aa1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802aa1:	55                   	push   %ebp
  802aa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa7:	6a 00                	push   $0x0
  802aa9:	6a 00                	push   $0x0
  802aab:	6a 00                	push   $0x0
  802aad:	6a 00                	push   $0x0
  802aaf:	50                   	push   %eax
  802ab0:	6a 1a                	push   $0x1a
  802ab2:	e8 52 fd ff ff       	call   802809 <syscall>
  802ab7:	83 c4 18             	add    $0x18,%esp
}
  802aba:	90                   	nop
  802abb:	c9                   	leave  
  802abc:	c3                   	ret    

00802abd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802abd:	55                   	push   %ebp
  802abe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac3:	6a 00                	push   $0x0
  802ac5:	6a 00                	push   $0x0
  802ac7:	6a 00                	push   $0x0
  802ac9:	6a 00                	push   $0x0
  802acb:	50                   	push   %eax
  802acc:	6a 1b                	push   $0x1b
  802ace:	e8 36 fd ff ff       	call   802809 <syscall>
  802ad3:	83 c4 18             	add    $0x18,%esp
}
  802ad6:	c9                   	leave  
  802ad7:	c3                   	ret    

00802ad8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802ad8:	55                   	push   %ebp
  802ad9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802adb:	6a 00                	push   $0x0
  802add:	6a 00                	push   $0x0
  802adf:	6a 00                	push   $0x0
  802ae1:	6a 00                	push   $0x0
  802ae3:	6a 00                	push   $0x0
  802ae5:	6a 05                	push   $0x5
  802ae7:	e8 1d fd ff ff       	call   802809 <syscall>
  802aec:	83 c4 18             	add    $0x18,%esp
}
  802aef:	c9                   	leave  
  802af0:	c3                   	ret    

00802af1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802af1:	55                   	push   %ebp
  802af2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802af4:	6a 00                	push   $0x0
  802af6:	6a 00                	push   $0x0
  802af8:	6a 00                	push   $0x0
  802afa:	6a 00                	push   $0x0
  802afc:	6a 00                	push   $0x0
  802afe:	6a 06                	push   $0x6
  802b00:	e8 04 fd ff ff       	call   802809 <syscall>
  802b05:	83 c4 18             	add    $0x18,%esp
}
  802b08:	c9                   	leave  
  802b09:	c3                   	ret    

00802b0a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802b0a:	55                   	push   %ebp
  802b0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802b0d:	6a 00                	push   $0x0
  802b0f:	6a 00                	push   $0x0
  802b11:	6a 00                	push   $0x0
  802b13:	6a 00                	push   $0x0
  802b15:	6a 00                	push   $0x0
  802b17:	6a 07                	push   $0x7
  802b19:	e8 eb fc ff ff       	call   802809 <syscall>
  802b1e:	83 c4 18             	add    $0x18,%esp
}
  802b21:	c9                   	leave  
  802b22:	c3                   	ret    

00802b23 <sys_exit_env>:


void sys_exit_env(void)
{
  802b23:	55                   	push   %ebp
  802b24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802b26:	6a 00                	push   $0x0
  802b28:	6a 00                	push   $0x0
  802b2a:	6a 00                	push   $0x0
  802b2c:	6a 00                	push   $0x0
  802b2e:	6a 00                	push   $0x0
  802b30:	6a 1c                	push   $0x1c
  802b32:	e8 d2 fc ff ff       	call   802809 <syscall>
  802b37:	83 c4 18             	add    $0x18,%esp
}
  802b3a:	90                   	nop
  802b3b:	c9                   	leave  
  802b3c:	c3                   	ret    

00802b3d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802b3d:	55                   	push   %ebp
  802b3e:	89 e5                	mov    %esp,%ebp
  802b40:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802b43:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b46:	8d 50 04             	lea    0x4(%eax),%edx
  802b49:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b4c:	6a 00                	push   $0x0
  802b4e:	6a 00                	push   $0x0
  802b50:	6a 00                	push   $0x0
  802b52:	52                   	push   %edx
  802b53:	50                   	push   %eax
  802b54:	6a 1d                	push   $0x1d
  802b56:	e8 ae fc ff ff       	call   802809 <syscall>
  802b5b:	83 c4 18             	add    $0x18,%esp
	return result;
  802b5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b64:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802b67:	89 01                	mov    %eax,(%ecx)
  802b69:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	c9                   	leave  
  802b70:	c2 04 00             	ret    $0x4

00802b73 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802b73:	55                   	push   %ebp
  802b74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802b76:	6a 00                	push   $0x0
  802b78:	6a 00                	push   $0x0
  802b7a:	ff 75 10             	pushl  0x10(%ebp)
  802b7d:	ff 75 0c             	pushl  0xc(%ebp)
  802b80:	ff 75 08             	pushl  0x8(%ebp)
  802b83:	6a 13                	push   $0x13
  802b85:	e8 7f fc ff ff       	call   802809 <syscall>
  802b8a:	83 c4 18             	add    $0x18,%esp
	return ;
  802b8d:	90                   	nop
}
  802b8e:	c9                   	leave  
  802b8f:	c3                   	ret    

00802b90 <sys_rcr2>:
uint32 sys_rcr2()
{
  802b90:	55                   	push   %ebp
  802b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802b93:	6a 00                	push   $0x0
  802b95:	6a 00                	push   $0x0
  802b97:	6a 00                	push   $0x0
  802b99:	6a 00                	push   $0x0
  802b9b:	6a 00                	push   $0x0
  802b9d:	6a 1e                	push   $0x1e
  802b9f:	e8 65 fc ff ff       	call   802809 <syscall>
  802ba4:	83 c4 18             	add    $0x18,%esp
}
  802ba7:	c9                   	leave  
  802ba8:	c3                   	ret    

00802ba9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802ba9:	55                   	push   %ebp
  802baa:	89 e5                	mov    %esp,%ebp
  802bac:	83 ec 04             	sub    $0x4,%esp
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802bb5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802bb9:	6a 00                	push   $0x0
  802bbb:	6a 00                	push   $0x0
  802bbd:	6a 00                	push   $0x0
  802bbf:	6a 00                	push   $0x0
  802bc1:	50                   	push   %eax
  802bc2:	6a 1f                	push   $0x1f
  802bc4:	e8 40 fc ff ff       	call   802809 <syscall>
  802bc9:	83 c4 18             	add    $0x18,%esp
	return ;
  802bcc:	90                   	nop
}
  802bcd:	c9                   	leave  
  802bce:	c3                   	ret    

00802bcf <rsttst>:
void rsttst()
{
  802bcf:	55                   	push   %ebp
  802bd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802bd2:	6a 00                	push   $0x0
  802bd4:	6a 00                	push   $0x0
  802bd6:	6a 00                	push   $0x0
  802bd8:	6a 00                	push   $0x0
  802bda:	6a 00                	push   $0x0
  802bdc:	6a 21                	push   $0x21
  802bde:	e8 26 fc ff ff       	call   802809 <syscall>
  802be3:	83 c4 18             	add    $0x18,%esp
	return ;
  802be6:	90                   	nop
}
  802be7:	c9                   	leave  
  802be8:	c3                   	ret    

00802be9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802be9:	55                   	push   %ebp
  802bea:	89 e5                	mov    %esp,%ebp
  802bec:	83 ec 04             	sub    $0x4,%esp
  802bef:	8b 45 14             	mov    0x14(%ebp),%eax
  802bf2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802bf5:	8b 55 18             	mov    0x18(%ebp),%edx
  802bf8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802bfc:	52                   	push   %edx
  802bfd:	50                   	push   %eax
  802bfe:	ff 75 10             	pushl  0x10(%ebp)
  802c01:	ff 75 0c             	pushl  0xc(%ebp)
  802c04:	ff 75 08             	pushl  0x8(%ebp)
  802c07:	6a 20                	push   $0x20
  802c09:	e8 fb fb ff ff       	call   802809 <syscall>
  802c0e:	83 c4 18             	add    $0x18,%esp
	return ;
  802c11:	90                   	nop
}
  802c12:	c9                   	leave  
  802c13:	c3                   	ret    

00802c14 <chktst>:
void chktst(uint32 n)
{
  802c14:	55                   	push   %ebp
  802c15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802c17:	6a 00                	push   $0x0
  802c19:	6a 00                	push   $0x0
  802c1b:	6a 00                	push   $0x0
  802c1d:	6a 00                	push   $0x0
  802c1f:	ff 75 08             	pushl  0x8(%ebp)
  802c22:	6a 22                	push   $0x22
  802c24:	e8 e0 fb ff ff       	call   802809 <syscall>
  802c29:	83 c4 18             	add    $0x18,%esp
	return ;
  802c2c:	90                   	nop
}
  802c2d:	c9                   	leave  
  802c2e:	c3                   	ret    

00802c2f <inctst>:

void inctst()
{
  802c2f:	55                   	push   %ebp
  802c30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802c32:	6a 00                	push   $0x0
  802c34:	6a 00                	push   $0x0
  802c36:	6a 00                	push   $0x0
  802c38:	6a 00                	push   $0x0
  802c3a:	6a 00                	push   $0x0
  802c3c:	6a 23                	push   $0x23
  802c3e:	e8 c6 fb ff ff       	call   802809 <syscall>
  802c43:	83 c4 18             	add    $0x18,%esp
	return ;
  802c46:	90                   	nop
}
  802c47:	c9                   	leave  
  802c48:	c3                   	ret    

00802c49 <gettst>:
uint32 gettst()
{
  802c49:	55                   	push   %ebp
  802c4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802c4c:	6a 00                	push   $0x0
  802c4e:	6a 00                	push   $0x0
  802c50:	6a 00                	push   $0x0
  802c52:	6a 00                	push   $0x0
  802c54:	6a 00                	push   $0x0
  802c56:	6a 24                	push   $0x24
  802c58:	e8 ac fb ff ff       	call   802809 <syscall>
  802c5d:	83 c4 18             	add    $0x18,%esp
}
  802c60:	c9                   	leave  
  802c61:	c3                   	ret    

00802c62 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802c62:	55                   	push   %ebp
  802c63:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c65:	6a 00                	push   $0x0
  802c67:	6a 00                	push   $0x0
  802c69:	6a 00                	push   $0x0
  802c6b:	6a 00                	push   $0x0
  802c6d:	6a 00                	push   $0x0
  802c6f:	6a 25                	push   $0x25
  802c71:	e8 93 fb ff ff       	call   802809 <syscall>
  802c76:	83 c4 18             	add    $0x18,%esp
  802c79:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802c7e:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802c83:	c9                   	leave  
  802c84:	c3                   	ret    

00802c85 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802c85:	55                   	push   %ebp
  802c86:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802c90:	6a 00                	push   $0x0
  802c92:	6a 00                	push   $0x0
  802c94:	6a 00                	push   $0x0
  802c96:	6a 00                	push   $0x0
  802c98:	ff 75 08             	pushl  0x8(%ebp)
  802c9b:	6a 26                	push   $0x26
  802c9d:	e8 67 fb ff ff       	call   802809 <syscall>
  802ca2:	83 c4 18             	add    $0x18,%esp
	return ;
  802ca5:	90                   	nop
}
  802ca6:	c9                   	leave  
  802ca7:	c3                   	ret    

00802ca8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802ca8:	55                   	push   %ebp
  802ca9:	89 e5                	mov    %esp,%ebp
  802cab:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802cac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802caf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	6a 00                	push   $0x0
  802cba:	53                   	push   %ebx
  802cbb:	51                   	push   %ecx
  802cbc:	52                   	push   %edx
  802cbd:	50                   	push   %eax
  802cbe:	6a 27                	push   $0x27
  802cc0:	e8 44 fb ff ff       	call   802809 <syscall>
  802cc5:	83 c4 18             	add    $0x18,%esp
}
  802cc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ccb:	c9                   	leave  
  802ccc:	c3                   	ret    

00802ccd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802ccd:	55                   	push   %ebp
  802cce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	6a 00                	push   $0x0
  802cd8:	6a 00                	push   $0x0
  802cda:	6a 00                	push   $0x0
  802cdc:	52                   	push   %edx
  802cdd:	50                   	push   %eax
  802cde:	6a 28                	push   $0x28
  802ce0:	e8 24 fb ff ff       	call   802809 <syscall>
  802ce5:	83 c4 18             	add    $0x18,%esp
}
  802ce8:	c9                   	leave  
  802ce9:	c3                   	ret    

00802cea <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802cea:	55                   	push   %ebp
  802ceb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802ced:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802cf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf6:	6a 00                	push   $0x0
  802cf8:	51                   	push   %ecx
  802cf9:	ff 75 10             	pushl  0x10(%ebp)
  802cfc:	52                   	push   %edx
  802cfd:	50                   	push   %eax
  802cfe:	6a 29                	push   $0x29
  802d00:	e8 04 fb ff ff       	call   802809 <syscall>
  802d05:	83 c4 18             	add    $0x18,%esp
}
  802d08:	c9                   	leave  
  802d09:	c3                   	ret    

00802d0a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802d0a:	55                   	push   %ebp
  802d0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802d0d:	6a 00                	push   $0x0
  802d0f:	6a 00                	push   $0x0
  802d11:	ff 75 10             	pushl  0x10(%ebp)
  802d14:	ff 75 0c             	pushl  0xc(%ebp)
  802d17:	ff 75 08             	pushl  0x8(%ebp)
  802d1a:	6a 12                	push   $0x12
  802d1c:	e8 e8 fa ff ff       	call   802809 <syscall>
  802d21:	83 c4 18             	add    $0x18,%esp
	return ;
  802d24:	90                   	nop
}
  802d25:	c9                   	leave  
  802d26:	c3                   	ret    

00802d27 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802d27:	55                   	push   %ebp
  802d28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	6a 00                	push   $0x0
  802d32:	6a 00                	push   $0x0
  802d34:	6a 00                	push   $0x0
  802d36:	52                   	push   %edx
  802d37:	50                   	push   %eax
  802d38:	6a 2a                	push   $0x2a
  802d3a:	e8 ca fa ff ff       	call   802809 <syscall>
  802d3f:	83 c4 18             	add    $0x18,%esp
	return;
  802d42:	90                   	nop
}
  802d43:	c9                   	leave  
  802d44:	c3                   	ret    

00802d45 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802d45:	55                   	push   %ebp
  802d46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802d48:	6a 00                	push   $0x0
  802d4a:	6a 00                	push   $0x0
  802d4c:	6a 00                	push   $0x0
  802d4e:	6a 00                	push   $0x0
  802d50:	6a 00                	push   $0x0
  802d52:	6a 2b                	push   $0x2b
  802d54:	e8 b0 fa ff ff       	call   802809 <syscall>
  802d59:	83 c4 18             	add    $0x18,%esp
}
  802d5c:	c9                   	leave  
  802d5d:	c3                   	ret    

00802d5e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802d5e:	55                   	push   %ebp
  802d5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802d61:	6a 00                	push   $0x0
  802d63:	6a 00                	push   $0x0
  802d65:	6a 00                	push   $0x0
  802d67:	ff 75 0c             	pushl  0xc(%ebp)
  802d6a:	ff 75 08             	pushl  0x8(%ebp)
  802d6d:	6a 2d                	push   $0x2d
  802d6f:	e8 95 fa ff ff       	call   802809 <syscall>
  802d74:	83 c4 18             	add    $0x18,%esp
	return;
  802d77:	90                   	nop
}
  802d78:	c9                   	leave  
  802d79:	c3                   	ret    

00802d7a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802d7a:	55                   	push   %ebp
  802d7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802d7d:	6a 00                	push   $0x0
  802d7f:	6a 00                	push   $0x0
  802d81:	6a 00                	push   $0x0
  802d83:	ff 75 0c             	pushl  0xc(%ebp)
  802d86:	ff 75 08             	pushl  0x8(%ebp)
  802d89:	6a 2c                	push   $0x2c
  802d8b:	e8 79 fa ff ff       	call   802809 <syscall>
  802d90:	83 c4 18             	add    $0x18,%esp
	return ;
  802d93:	90                   	nop
}
  802d94:	c9                   	leave  
  802d95:	c3                   	ret    

00802d96 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802d96:	55                   	push   %ebp
  802d97:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9f:	6a 00                	push   $0x0
  802da1:	6a 00                	push   $0x0
  802da3:	6a 00                	push   $0x0
  802da5:	52                   	push   %edx
  802da6:	50                   	push   %eax
  802da7:	6a 2e                	push   $0x2e
  802da9:	e8 5b fa ff ff       	call   802809 <syscall>
  802dae:	83 c4 18             	add    $0x18,%esp
	return ;
  802db1:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802db2:	c9                   	leave  
  802db3:	c3                   	ret    

00802db4 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802db4:	55                   	push   %ebp
  802db5:	89 e5                	mov    %esp,%ebp
  802db7:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802dba:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802dc1:	72 09                	jb     802dcc <to_page_va+0x18>
  802dc3:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802dca:	72 14                	jb     802de0 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802dcc:	83 ec 04             	sub    $0x4,%esp
  802dcf:	68 00 4a 80 00       	push   $0x804a00
  802dd4:	6a 15                	push   $0x15
  802dd6:	68 2b 4a 80 00       	push   $0x804a2b
  802ddb:	e8 4e db ff ff       	call   80092e <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	ba 60 50 80 00       	mov    $0x805060,%edx
  802de8:	29 d0                	sub    %edx,%eax
  802dea:	c1 f8 02             	sar    $0x2,%eax
  802ded:	89 c2                	mov    %eax,%edx
  802def:	89 d0                	mov    %edx,%eax
  802df1:	c1 e0 02             	shl    $0x2,%eax
  802df4:	01 d0                	add    %edx,%eax
  802df6:	c1 e0 02             	shl    $0x2,%eax
  802df9:	01 d0                	add    %edx,%eax
  802dfb:	c1 e0 02             	shl    $0x2,%eax
  802dfe:	01 d0                	add    %edx,%eax
  802e00:	89 c1                	mov    %eax,%ecx
  802e02:	c1 e1 08             	shl    $0x8,%ecx
  802e05:	01 c8                	add    %ecx,%eax
  802e07:	89 c1                	mov    %eax,%ecx
  802e09:	c1 e1 10             	shl    $0x10,%ecx
  802e0c:	01 c8                	add    %ecx,%eax
  802e0e:	01 c0                	add    %eax,%eax
  802e10:	01 d0                	add    %edx,%eax
  802e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	c1 e0 0c             	shl    $0xc,%eax
  802e1b:	89 c2                	mov    %eax,%edx
  802e1d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802e22:	01 d0                	add    %edx,%eax
}
  802e24:	c9                   	leave  
  802e25:	c3                   	ret    

00802e26 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802e26:	55                   	push   %ebp
  802e27:	89 e5                	mov    %esp,%ebp
  802e29:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802e2c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802e31:	8b 55 08             	mov    0x8(%ebp),%edx
  802e34:	29 c2                	sub    %eax,%edx
  802e36:	89 d0                	mov    %edx,%eax
  802e38:	c1 e8 0c             	shr    $0xc,%eax
  802e3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802e3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e42:	78 09                	js     802e4d <to_page_info+0x27>
  802e44:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802e4b:	7e 14                	jle    802e61 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802e4d:	83 ec 04             	sub    $0x4,%esp
  802e50:	68 44 4a 80 00       	push   $0x804a44
  802e55:	6a 22                	push   $0x22
  802e57:	68 2b 4a 80 00       	push   $0x804a2b
  802e5c:	e8 cd da ff ff       	call   80092e <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802e61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e64:	89 d0                	mov    %edx,%eax
  802e66:	01 c0                	add    %eax,%eax
  802e68:	01 d0                	add    %edx,%eax
  802e6a:	c1 e0 02             	shl    $0x2,%eax
  802e6d:	05 60 50 80 00       	add    $0x805060,%eax
}
  802e72:	c9                   	leave  
  802e73:	c3                   	ret    

00802e74 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802e74:	55                   	push   %ebp
  802e75:	89 e5                	mov    %esp,%ebp
  802e77:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	05 00 00 00 02       	add    $0x2000000,%eax
  802e82:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e85:	73 16                	jae    802e9d <initialize_dynamic_allocator+0x29>
  802e87:	68 68 4a 80 00       	push   $0x804a68
  802e8c:	68 8e 4a 80 00       	push   $0x804a8e
  802e91:	6a 34                	push   $0x34
  802e93:	68 2b 4a 80 00       	push   $0x804a2b
  802e98:	e8 91 da ff ff       	call   80092e <_panic>
		is_initialized = 1;
  802e9d:	c7 05 38 50 80 00 01 	movl   $0x1,0x805038
  802ea4:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb2:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802eb7:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802ebe:	00 00 00 
  802ec1:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802ec8:	00 00 00 
  802ecb:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802ed2:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802ed5:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802edc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ee3:	eb 36                	jmp    802f1b <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee8:	c1 e0 04             	shl    $0x4,%eax
  802eeb:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ef0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	c1 e0 04             	shl    $0x4,%eax
  802efc:	05 84 d0 81 00       	add    $0x81d084,%eax
  802f01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	c1 e0 04             	shl    $0x4,%eax
  802f0d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802f18:	ff 45 f4             	incl   -0xc(%ebp)
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802f21:	72 c2                	jb     802ee5 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802f23:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802f29:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802f2e:	29 c2                	sub    %eax,%edx
  802f30:	89 d0                	mov    %edx,%eax
  802f32:	c1 e8 0c             	shr    $0xc,%eax
  802f35:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802f38:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802f3f:	e9 c8 00 00 00       	jmp    80300c <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802f44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f47:	89 d0                	mov    %edx,%eax
  802f49:	01 c0                	add    %eax,%eax
  802f4b:	01 d0                	add    %edx,%eax
  802f4d:	c1 e0 02             	shl    $0x2,%eax
  802f50:	05 68 50 80 00       	add    $0x805068,%eax
  802f55:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802f5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f5d:	89 d0                	mov    %edx,%eax
  802f5f:	01 c0                	add    %eax,%eax
  802f61:	01 d0                	add    %edx,%eax
  802f63:	c1 e0 02             	shl    $0x2,%eax
  802f66:	05 6a 50 80 00       	add    $0x80506a,%eax
  802f6b:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802f70:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802f76:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802f79:	89 c8                	mov    %ecx,%eax
  802f7b:	01 c0                	add    %eax,%eax
  802f7d:	01 c8                	add    %ecx,%eax
  802f7f:	c1 e0 02             	shl    $0x2,%eax
  802f82:	05 64 50 80 00       	add    $0x805064,%eax
  802f87:	89 10                	mov    %edx,(%eax)
  802f89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f8c:	89 d0                	mov    %edx,%eax
  802f8e:	01 c0                	add    %eax,%eax
  802f90:	01 d0                	add    %edx,%eax
  802f92:	c1 e0 02             	shl    $0x2,%eax
  802f95:	05 64 50 80 00       	add    $0x805064,%eax
  802f9a:	8b 00                	mov    (%eax),%eax
  802f9c:	85 c0                	test   %eax,%eax
  802f9e:	74 1b                	je     802fbb <initialize_dynamic_allocator+0x147>
  802fa0:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802fa6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802fa9:	89 c8                	mov    %ecx,%eax
  802fab:	01 c0                	add    %eax,%eax
  802fad:	01 c8                	add    %ecx,%eax
  802faf:	c1 e0 02             	shl    $0x2,%eax
  802fb2:	05 60 50 80 00       	add    $0x805060,%eax
  802fb7:	89 02                	mov    %eax,(%edx)
  802fb9:	eb 16                	jmp    802fd1 <initialize_dynamic_allocator+0x15d>
  802fbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fbe:	89 d0                	mov    %edx,%eax
  802fc0:	01 c0                	add    %eax,%eax
  802fc2:	01 d0                	add    %edx,%eax
  802fc4:	c1 e0 02             	shl    $0x2,%eax
  802fc7:	05 60 50 80 00       	add    $0x805060,%eax
  802fcc:	a3 48 50 80 00       	mov    %eax,0x805048
  802fd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fd4:	89 d0                	mov    %edx,%eax
  802fd6:	01 c0                	add    %eax,%eax
  802fd8:	01 d0                	add    %edx,%eax
  802fda:	c1 e0 02             	shl    $0x2,%eax
  802fdd:	05 60 50 80 00       	add    $0x805060,%eax
  802fe2:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802fe7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fea:	89 d0                	mov    %edx,%eax
  802fec:	01 c0                	add    %eax,%eax
  802fee:	01 d0                	add    %edx,%eax
  802ff0:	c1 e0 02             	shl    $0x2,%eax
  802ff3:	05 60 50 80 00       	add    $0x805060,%eax
  802ff8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffe:	a1 54 50 80 00       	mov    0x805054,%eax
  803003:	40                   	inc    %eax
  803004:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803009:	ff 45 f0             	incl   -0x10(%ebp)
  80300c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803012:	0f 82 2c ff ff ff    	jb     802f44 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803018:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80301e:	eb 2f                	jmp    80304f <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  803020:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803023:	89 d0                	mov    %edx,%eax
  803025:	01 c0                	add    %eax,%eax
  803027:	01 d0                	add    %edx,%eax
  803029:	c1 e0 02             	shl    $0x2,%eax
  80302c:	05 68 50 80 00       	add    $0x805068,%eax
  803031:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803036:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803039:	89 d0                	mov    %edx,%eax
  80303b:	01 c0                	add    %eax,%eax
  80303d:	01 d0                	add    %edx,%eax
  80303f:	c1 e0 02             	shl    $0x2,%eax
  803042:	05 6a 50 80 00       	add    $0x80506a,%eax
  803047:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  80304c:	ff 45 ec             	incl   -0x14(%ebp)
  80304f:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803056:	76 c8                	jbe    803020 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803058:	90                   	nop
  803059:	c9                   	leave  
  80305a:	c3                   	ret    

0080305b <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80305b:	55                   	push   %ebp
  80305c:	89 e5                	mov    %esp,%ebp
  80305e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  803061:	8b 55 08             	mov    0x8(%ebp),%edx
  803064:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803069:	29 c2                	sub    %eax,%edx
  80306b:	89 d0                	mov    %edx,%eax
  80306d:	c1 e8 0c             	shr    $0xc,%eax
  803070:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803073:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803076:	89 d0                	mov    %edx,%eax
  803078:	01 c0                	add    %eax,%eax
  80307a:	01 d0                	add    %edx,%eax
  80307c:	c1 e0 02             	shl    $0x2,%eax
  80307f:	05 68 50 80 00       	add    $0x805068,%eax
  803084:	8b 00                	mov    (%eax),%eax
  803086:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803089:	c9                   	leave  
  80308a:	c3                   	ret    

0080308b <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  80308b:	55                   	push   %ebp
  80308c:	89 e5                	mov    %esp,%ebp
  80308e:	83 ec 14             	sub    $0x14,%esp
  803091:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  803094:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803098:	77 07                	ja     8030a1 <nearest_pow2_ceil.1513+0x16>
  80309a:	b8 01 00 00 00       	mov    $0x1,%eax
  80309f:	eb 20                	jmp    8030c1 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  8030a1:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  8030a8:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  8030ab:	eb 08                	jmp    8030b5 <nearest_pow2_ceil.1513+0x2a>
  8030ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030b0:	01 c0                	add    %eax,%eax
  8030b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8030b5:	d1 6d 08             	shrl   0x8(%ebp)
  8030b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030bc:	75 ef                	jne    8030ad <nearest_pow2_ceil.1513+0x22>
        return power;
  8030be:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8030c1:	c9                   	leave  
  8030c2:	c3                   	ret    

008030c3 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8030c3:	55                   	push   %ebp
  8030c4:	89 e5                	mov    %esp,%ebp
  8030c6:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8030c9:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8030d0:	76 16                	jbe    8030e8 <alloc_block+0x25>
  8030d2:	68 a4 4a 80 00       	push   $0x804aa4
  8030d7:	68 8e 4a 80 00       	push   $0x804a8e
  8030dc:	6a 72                	push   $0x72
  8030de:	68 2b 4a 80 00       	push   $0x804a2b
  8030e3:	e8 46 d8 ff ff       	call   80092e <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  8030e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ec:	75 0a                	jne    8030f8 <alloc_block+0x35>
  8030ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f3:	e9 bd 04 00 00       	jmp    8035b5 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8030f8:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  8030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803102:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803105:	73 06                	jae    80310d <alloc_block+0x4a>
        size = min_block_size;
  803107:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310a:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  80310d:	83 ec 0c             	sub    $0xc,%esp
  803110:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803113:	ff 75 08             	pushl  0x8(%ebp)
  803116:	89 c1                	mov    %eax,%ecx
  803118:	e8 6e ff ff ff       	call   80308b <nearest_pow2_ceil.1513>
  80311d:	83 c4 10             	add    $0x10,%esp
  803120:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  803123:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803126:	83 ec 0c             	sub    $0xc,%esp
  803129:	8d 45 cc             	lea    -0x34(%ebp),%eax
  80312c:	52                   	push   %edx
  80312d:	89 c1                	mov    %eax,%ecx
  80312f:	e8 83 04 00 00       	call   8035b7 <log2_ceil.1520>
  803134:	83 c4 10             	add    $0x10,%esp
  803137:	83 e8 03             	sub    $0x3,%eax
  80313a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  80313d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803140:	c1 e0 04             	shl    $0x4,%eax
  803143:	05 80 d0 81 00       	add    $0x81d080,%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	85 c0                	test   %eax,%eax
  80314c:	0f 84 d8 00 00 00    	je     80322a <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803152:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803155:	c1 e0 04             	shl    $0x4,%eax
  803158:	05 80 d0 81 00       	add    $0x81d080,%eax
  80315d:	8b 00                	mov    (%eax),%eax
  80315f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803162:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803166:	75 17                	jne    80317f <alloc_block+0xbc>
  803168:	83 ec 04             	sub    $0x4,%esp
  80316b:	68 c5 4a 80 00       	push   $0x804ac5
  803170:	68 98 00 00 00       	push   $0x98
  803175:	68 2b 4a 80 00       	push   $0x804a2b
  80317a:	e8 af d7 ff ff       	call   80092e <_panic>
  80317f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803182:	8b 00                	mov    (%eax),%eax
  803184:	85 c0                	test   %eax,%eax
  803186:	74 10                	je     803198 <alloc_block+0xd5>
  803188:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80318b:	8b 00                	mov    (%eax),%eax
  80318d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803190:	8b 52 04             	mov    0x4(%edx),%edx
  803193:	89 50 04             	mov    %edx,0x4(%eax)
  803196:	eb 14                	jmp    8031ac <alloc_block+0xe9>
  803198:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80319b:	8b 40 04             	mov    0x4(%eax),%eax
  80319e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031a1:	c1 e2 04             	shl    $0x4,%edx
  8031a4:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8031aa:	89 02                	mov    %eax,(%edx)
  8031ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031af:	8b 40 04             	mov    0x4(%eax),%eax
  8031b2:	85 c0                	test   %eax,%eax
  8031b4:	74 0f                	je     8031c5 <alloc_block+0x102>
  8031b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031b9:	8b 40 04             	mov    0x4(%eax),%eax
  8031bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031bf:	8b 12                	mov    (%edx),%edx
  8031c1:	89 10                	mov    %edx,(%eax)
  8031c3:	eb 13                	jmp    8031d8 <alloc_block+0x115>
  8031c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031c8:	8b 00                	mov    (%eax),%eax
  8031ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031cd:	c1 e2 04             	shl    $0x4,%edx
  8031d0:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8031d6:	89 02                	mov    %eax,(%edx)
  8031d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ee:	c1 e0 04             	shl    $0x4,%eax
  8031f1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031f6:	8b 00                	mov    (%eax),%eax
  8031f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8031fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031fe:	c1 e0 04             	shl    $0x4,%eax
  803201:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803206:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803208:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80320b:	83 ec 0c             	sub    $0xc,%esp
  80320e:	50                   	push   %eax
  80320f:	e8 12 fc ff ff       	call   802e26 <to_page_info>
  803214:	83 c4 10             	add    $0x10,%esp
  803217:	89 c2                	mov    %eax,%edx
  803219:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80321d:	48                   	dec    %eax
  80321e:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  803222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803225:	e9 8b 03 00 00       	jmp    8035b5 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  80322a:	a1 48 50 80 00       	mov    0x805048,%eax
  80322f:	85 c0                	test   %eax,%eax
  803231:	0f 84 64 02 00 00    	je     80349b <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803237:	a1 48 50 80 00       	mov    0x805048,%eax
  80323c:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  80323f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803243:	75 17                	jne    80325c <alloc_block+0x199>
  803245:	83 ec 04             	sub    $0x4,%esp
  803248:	68 c5 4a 80 00       	push   $0x804ac5
  80324d:	68 a0 00 00 00       	push   $0xa0
  803252:	68 2b 4a 80 00       	push   $0x804a2b
  803257:	e8 d2 d6 ff ff       	call   80092e <_panic>
  80325c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325f:	8b 00                	mov    (%eax),%eax
  803261:	85 c0                	test   %eax,%eax
  803263:	74 10                	je     803275 <alloc_block+0x1b2>
  803265:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803268:	8b 00                	mov    (%eax),%eax
  80326a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80326d:	8b 52 04             	mov    0x4(%edx),%edx
  803270:	89 50 04             	mov    %edx,0x4(%eax)
  803273:	eb 0b                	jmp    803280 <alloc_block+0x1bd>
  803275:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803278:	8b 40 04             	mov    0x4(%eax),%eax
  80327b:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803280:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803283:	8b 40 04             	mov    0x4(%eax),%eax
  803286:	85 c0                	test   %eax,%eax
  803288:	74 0f                	je     803299 <alloc_block+0x1d6>
  80328a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328d:	8b 40 04             	mov    0x4(%eax),%eax
  803290:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803293:	8b 12                	mov    (%edx),%edx
  803295:	89 10                	mov    %edx,(%eax)
  803297:	eb 0a                	jmp    8032a3 <alloc_block+0x1e0>
  803299:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80329c:	8b 00                	mov    (%eax),%eax
  80329e:	a3 48 50 80 00       	mov    %eax,0x805048
  8032a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b6:	a1 54 50 80 00       	mov    0x805054,%eax
  8032bb:	48                   	dec    %eax
  8032bc:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  8032c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032c7:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  8032cb:	b8 00 10 00 00       	mov    $0x1000,%eax
  8032d0:	99                   	cltd   
  8032d1:	f7 7d e8             	idivl  -0x18(%ebp)
  8032d4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032d7:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  8032db:	83 ec 0c             	sub    $0xc,%esp
  8032de:	ff 75 dc             	pushl  -0x24(%ebp)
  8032e1:	e8 ce fa ff ff       	call   802db4 <to_page_va>
  8032e6:	83 c4 10             	add    $0x10,%esp
  8032e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  8032ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032ef:	83 ec 0c             	sub    $0xc,%esp
  8032f2:	50                   	push   %eax
  8032f3:	e8 c0 ee ff ff       	call   8021b8 <get_page>
  8032f8:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8032fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803302:	e9 aa 00 00 00       	jmp    8033b1 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330a:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  80330e:	89 c2                	mov    %eax,%edx
  803310:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803313:	01 d0                	add    %edx,%eax
  803315:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  803318:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80331c:	75 17                	jne    803335 <alloc_block+0x272>
  80331e:	83 ec 04             	sub    $0x4,%esp
  803321:	68 e4 4a 80 00       	push   $0x804ae4
  803326:	68 aa 00 00 00       	push   $0xaa
  80332b:	68 2b 4a 80 00       	push   $0x804a2b
  803330:	e8 f9 d5 ff ff       	call   80092e <_panic>
  803335:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803338:	c1 e0 04             	shl    $0x4,%eax
  80333b:	05 84 d0 81 00       	add    $0x81d084,%eax
  803340:	8b 10                	mov    (%eax),%edx
  803342:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803345:	89 50 04             	mov    %edx,0x4(%eax)
  803348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80334b:	8b 40 04             	mov    0x4(%eax),%eax
  80334e:	85 c0                	test   %eax,%eax
  803350:	74 14                	je     803366 <alloc_block+0x2a3>
  803352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803355:	c1 e0 04             	shl    $0x4,%eax
  803358:	05 84 d0 81 00       	add    $0x81d084,%eax
  80335d:	8b 00                	mov    (%eax),%eax
  80335f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803362:	89 10                	mov    %edx,(%eax)
  803364:	eb 11                	jmp    803377 <alloc_block+0x2b4>
  803366:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803369:	c1 e0 04             	shl    $0x4,%eax
  80336c:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803372:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803375:	89 02                	mov    %eax,(%edx)
  803377:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337a:	c1 e0 04             	shl    $0x4,%eax
  80337d:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803383:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803386:	89 02                	mov    %eax,(%edx)
  803388:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80338b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803391:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803394:	c1 e0 04             	shl    $0x4,%eax
  803397:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80339c:	8b 00                	mov    (%eax),%eax
  80339e:	8d 50 01             	lea    0x1(%eax),%edx
  8033a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a4:	c1 e0 04             	shl    $0x4,%eax
  8033a7:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033ac:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8033ae:	ff 45 f4             	incl   -0xc(%ebp)
  8033b1:	b8 00 10 00 00       	mov    $0x1000,%eax
  8033b6:	99                   	cltd   
  8033b7:	f7 7d e8             	idivl  -0x18(%ebp)
  8033ba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8033bd:	0f 8f 44 ff ff ff    	jg     803307 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8033c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c6:	c1 e0 04             	shl    $0x4,%eax
  8033c9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033ce:	8b 00                	mov    (%eax),%eax
  8033d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  8033d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033d7:	75 17                	jne    8033f0 <alloc_block+0x32d>
  8033d9:	83 ec 04             	sub    $0x4,%esp
  8033dc:	68 c5 4a 80 00       	push   $0x804ac5
  8033e1:	68 ae 00 00 00       	push   $0xae
  8033e6:	68 2b 4a 80 00       	push   $0x804a2b
  8033eb:	e8 3e d5 ff ff       	call   80092e <_panic>
  8033f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033f3:	8b 00                	mov    (%eax),%eax
  8033f5:	85 c0                	test   %eax,%eax
  8033f7:	74 10                	je     803409 <alloc_block+0x346>
  8033f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033fc:	8b 00                	mov    (%eax),%eax
  8033fe:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803401:	8b 52 04             	mov    0x4(%edx),%edx
  803404:	89 50 04             	mov    %edx,0x4(%eax)
  803407:	eb 14                	jmp    80341d <alloc_block+0x35a>
  803409:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80340c:	8b 40 04             	mov    0x4(%eax),%eax
  80340f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803412:	c1 e2 04             	shl    $0x4,%edx
  803415:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80341b:	89 02                	mov    %eax,(%edx)
  80341d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803420:	8b 40 04             	mov    0x4(%eax),%eax
  803423:	85 c0                	test   %eax,%eax
  803425:	74 0f                	je     803436 <alloc_block+0x373>
  803427:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80342a:	8b 40 04             	mov    0x4(%eax),%eax
  80342d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803430:	8b 12                	mov    (%edx),%edx
  803432:	89 10                	mov    %edx,(%eax)
  803434:	eb 13                	jmp    803449 <alloc_block+0x386>
  803436:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803439:	8b 00                	mov    (%eax),%eax
  80343b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80343e:	c1 e2 04             	shl    $0x4,%edx
  803441:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803447:	89 02                	mov    %eax,(%edx)
  803449:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80344c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803452:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803455:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345f:	c1 e0 04             	shl    $0x4,%eax
  803462:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803467:	8b 00                	mov    (%eax),%eax
  803469:	8d 50 ff             	lea    -0x1(%eax),%edx
  80346c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346f:	c1 e0 04             	shl    $0x4,%eax
  803472:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803477:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803479:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80347c:	83 ec 0c             	sub    $0xc,%esp
  80347f:	50                   	push   %eax
  803480:	e8 a1 f9 ff ff       	call   802e26 <to_page_info>
  803485:	83 c4 10             	add    $0x10,%esp
  803488:	89 c2                	mov    %eax,%edx
  80348a:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80348e:	48                   	dec    %eax
  80348f:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  803493:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803496:	e9 1a 01 00 00       	jmp    8035b5 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  80349b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80349e:	40                   	inc    %eax
  80349f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8034a2:	e9 ed 00 00 00       	jmp    803594 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  8034a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034aa:	c1 e0 04             	shl    $0x4,%eax
  8034ad:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034b2:	8b 00                	mov    (%eax),%eax
  8034b4:	85 c0                	test   %eax,%eax
  8034b6:	0f 84 d5 00 00 00    	je     803591 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  8034bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bf:	c1 e0 04             	shl    $0x4,%eax
  8034c2:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034c7:	8b 00                	mov    (%eax),%eax
  8034c9:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  8034cc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8034d0:	75 17                	jne    8034e9 <alloc_block+0x426>
  8034d2:	83 ec 04             	sub    $0x4,%esp
  8034d5:	68 c5 4a 80 00       	push   $0x804ac5
  8034da:	68 b8 00 00 00       	push   $0xb8
  8034df:	68 2b 4a 80 00       	push   $0x804a2b
  8034e4:	e8 45 d4 ff ff       	call   80092e <_panic>
  8034e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034ec:	8b 00                	mov    (%eax),%eax
  8034ee:	85 c0                	test   %eax,%eax
  8034f0:	74 10                	je     803502 <alloc_block+0x43f>
  8034f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034f5:	8b 00                	mov    (%eax),%eax
  8034f7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8034fa:	8b 52 04             	mov    0x4(%edx),%edx
  8034fd:	89 50 04             	mov    %edx,0x4(%eax)
  803500:	eb 14                	jmp    803516 <alloc_block+0x453>
  803502:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803505:	8b 40 04             	mov    0x4(%eax),%eax
  803508:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80350b:	c1 e2 04             	shl    $0x4,%edx
  80350e:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803514:	89 02                	mov    %eax,(%edx)
  803516:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803519:	8b 40 04             	mov    0x4(%eax),%eax
  80351c:	85 c0                	test   %eax,%eax
  80351e:	74 0f                	je     80352f <alloc_block+0x46c>
  803520:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803523:	8b 40 04             	mov    0x4(%eax),%eax
  803526:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803529:	8b 12                	mov    (%edx),%edx
  80352b:	89 10                	mov    %edx,(%eax)
  80352d:	eb 13                	jmp    803542 <alloc_block+0x47f>
  80352f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803532:	8b 00                	mov    (%eax),%eax
  803534:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803537:	c1 e2 04             	shl    $0x4,%edx
  80353a:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803540:	89 02                	mov    %eax,(%edx)
  803542:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803545:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80354b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80354e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803558:	c1 e0 04             	shl    $0x4,%eax
  80355b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803560:	8b 00                	mov    (%eax),%eax
  803562:	8d 50 ff             	lea    -0x1(%eax),%edx
  803565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803568:	c1 e0 04             	shl    $0x4,%eax
  80356b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803570:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  803572:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803575:	83 ec 0c             	sub    $0xc,%esp
  803578:	50                   	push   %eax
  803579:	e8 a8 f8 ff ff       	call   802e26 <to_page_info>
  80357e:	83 c4 10             	add    $0x10,%esp
  803581:	89 c2                	mov    %eax,%edx
  803583:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803587:	48                   	dec    %eax
  803588:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  80358c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80358f:	eb 24                	jmp    8035b5 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803591:	ff 45 f0             	incl   -0x10(%ebp)
  803594:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803598:	0f 8e 09 ff ff ff    	jle    8034a7 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  80359e:	83 ec 04             	sub    $0x4,%esp
  8035a1:	68 07 4b 80 00       	push   $0x804b07
  8035a6:	68 bf 00 00 00       	push   $0xbf
  8035ab:	68 2b 4a 80 00       	push   $0x804a2b
  8035b0:	e8 79 d3 ff ff       	call   80092e <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8035b5:	c9                   	leave  
  8035b6:	c3                   	ret    

008035b7 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  8035b7:	55                   	push   %ebp
  8035b8:	89 e5                	mov    %esp,%ebp
  8035ba:	83 ec 14             	sub    $0x14,%esp
  8035bd:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  8035c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035c4:	75 07                	jne    8035cd <log2_ceil.1520+0x16>
  8035c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035cb:	eb 1b                	jmp    8035e8 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  8035cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  8035d4:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  8035d7:	eb 06                	jmp    8035df <log2_ceil.1520+0x28>
            x >>= 1;
  8035d9:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  8035dc:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8035df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e3:	75 f4                	jne    8035d9 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  8035e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8035e8:	c9                   	leave  
  8035e9:	c3                   	ret    

008035ea <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  8035ea:	55                   	push   %ebp
  8035eb:	89 e5                	mov    %esp,%ebp
  8035ed:	83 ec 14             	sub    $0x14,%esp
  8035f0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  8035f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f7:	75 07                	jne    803600 <log2_ceil.1547+0x16>
  8035f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035fe:	eb 1b                	jmp    80361b <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  803600:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803607:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  80360a:	eb 06                	jmp    803612 <log2_ceil.1547+0x28>
			x >>= 1;
  80360c:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  80360f:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  803612:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803616:	75 f4                	jne    80360c <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  803618:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80361b:	c9                   	leave  
  80361c:	c3                   	ret    

0080361d <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80361d:	55                   	push   %ebp
  80361e:	89 e5                	mov    %esp,%ebp
  803620:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803623:	8b 55 08             	mov    0x8(%ebp),%edx
  803626:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80362b:	39 c2                	cmp    %eax,%edx
  80362d:	72 0c                	jb     80363b <free_block+0x1e>
  80362f:	8b 55 08             	mov    0x8(%ebp),%edx
  803632:	a1 40 50 80 00       	mov    0x805040,%eax
  803637:	39 c2                	cmp    %eax,%edx
  803639:	72 19                	jb     803654 <free_block+0x37>
  80363b:	68 0c 4b 80 00       	push   $0x804b0c
  803640:	68 8e 4a 80 00       	push   $0x804a8e
  803645:	68 d0 00 00 00       	push   $0xd0
  80364a:	68 2b 4a 80 00       	push   $0x804a2b
  80364f:	e8 da d2 ff ff       	call   80092e <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803654:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803658:	0f 84 42 03 00 00    	je     8039a0 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  80365e:	8b 55 08             	mov    0x8(%ebp),%edx
  803661:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803666:	39 c2                	cmp    %eax,%edx
  803668:	72 0c                	jb     803676 <free_block+0x59>
  80366a:	8b 55 08             	mov    0x8(%ebp),%edx
  80366d:	a1 40 50 80 00       	mov    0x805040,%eax
  803672:	39 c2                	cmp    %eax,%edx
  803674:	72 17                	jb     80368d <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803676:	83 ec 04             	sub    $0x4,%esp
  803679:	68 44 4b 80 00       	push   $0x804b44
  80367e:	68 e6 00 00 00       	push   $0xe6
  803683:	68 2b 4a 80 00       	push   $0x804a2b
  803688:	e8 a1 d2 ff ff       	call   80092e <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  80368d:	8b 55 08             	mov    0x8(%ebp),%edx
  803690:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803695:	29 c2                	sub    %eax,%edx
  803697:	89 d0                	mov    %edx,%eax
  803699:	83 e0 07             	and    $0x7,%eax
  80369c:	85 c0                	test   %eax,%eax
  80369e:	74 17                	je     8036b7 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8036a0:	83 ec 04             	sub    $0x4,%esp
  8036a3:	68 78 4b 80 00       	push   $0x804b78
  8036a8:	68 ea 00 00 00       	push   $0xea
  8036ad:	68 2b 4a 80 00       	push   $0x804a2b
  8036b2:	e8 77 d2 ff ff       	call   80092e <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8036b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ba:	83 ec 0c             	sub    $0xc,%esp
  8036bd:	50                   	push   %eax
  8036be:	e8 63 f7 ff ff       	call   802e26 <to_page_info>
  8036c3:	83 c4 10             	add    $0x10,%esp
  8036c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8036c9:	83 ec 0c             	sub    $0xc,%esp
  8036cc:	ff 75 08             	pushl  0x8(%ebp)
  8036cf:	e8 87 f9 ff ff       	call   80305b <get_block_size>
  8036d4:	83 c4 10             	add    $0x10,%esp
  8036d7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8036da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036de:	75 17                	jne    8036f7 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8036e0:	83 ec 04             	sub    $0x4,%esp
  8036e3:	68 a4 4b 80 00       	push   $0x804ba4
  8036e8:	68 f1 00 00 00       	push   $0xf1
  8036ed:	68 2b 4a 80 00       	push   $0x804a2b
  8036f2:	e8 37 d2 ff ff       	call   80092e <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8036f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036fa:	83 ec 0c             	sub    $0xc,%esp
  8036fd:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803700:	52                   	push   %edx
  803701:	89 c1                	mov    %eax,%ecx
  803703:	e8 e2 fe ff ff       	call   8035ea <log2_ceil.1547>
  803708:	83 c4 10             	add    $0x10,%esp
  80370b:	83 e8 03             	sub    $0x3,%eax
  80370e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803711:	8b 45 08             	mov    0x8(%ebp),%eax
  803714:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  803717:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80371b:	75 17                	jne    803734 <free_block+0x117>
  80371d:	83 ec 04             	sub    $0x4,%esp
  803720:	68 f0 4b 80 00       	push   $0x804bf0
  803725:	68 f6 00 00 00       	push   $0xf6
  80372a:	68 2b 4a 80 00       	push   $0x804a2b
  80372f:	e8 fa d1 ff ff       	call   80092e <_panic>
  803734:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803737:	c1 e0 04             	shl    $0x4,%eax
  80373a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80373f:	8b 10                	mov    (%eax),%edx
  803741:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803744:	89 10                	mov    %edx,(%eax)
  803746:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803749:	8b 00                	mov    (%eax),%eax
  80374b:	85 c0                	test   %eax,%eax
  80374d:	74 15                	je     803764 <free_block+0x147>
  80374f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803752:	c1 e0 04             	shl    $0x4,%eax
  803755:	05 80 d0 81 00       	add    $0x81d080,%eax
  80375a:	8b 00                	mov    (%eax),%eax
  80375c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80375f:	89 50 04             	mov    %edx,0x4(%eax)
  803762:	eb 11                	jmp    803775 <free_block+0x158>
  803764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803767:	c1 e0 04             	shl    $0x4,%eax
  80376a:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803770:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803773:	89 02                	mov    %eax,(%edx)
  803775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803778:	c1 e0 04             	shl    $0x4,%eax
  80377b:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803781:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803784:	89 02                	mov    %eax,(%edx)
  803786:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803789:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803793:	c1 e0 04             	shl    $0x4,%eax
  803796:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80379b:	8b 00                	mov    (%eax),%eax
  80379d:	8d 50 01             	lea    0x1(%eax),%edx
  8037a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a3:	c1 e0 04             	shl    $0x4,%eax
  8037a6:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8037ab:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8037ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8037b4:	40                   	inc    %eax
  8037b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037b8:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8037bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8037bf:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8037c4:	29 c2                	sub    %eax,%edx
  8037c6:	89 d0                	mov    %edx,%eax
  8037c8:	c1 e8 0c             	shr    $0xc,%eax
  8037cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8037ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d1:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8037d5:	0f b7 c8             	movzwl %ax,%ecx
  8037d8:	b8 00 10 00 00       	mov    $0x1000,%eax
  8037dd:	99                   	cltd   
  8037de:	f7 7d e8             	idivl  -0x18(%ebp)
  8037e1:	39 c1                	cmp    %eax,%ecx
  8037e3:	0f 85 b8 01 00 00    	jne    8039a1 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8037e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8037f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f3:	c1 e0 04             	shl    $0x4,%eax
  8037f6:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037fb:	8b 00                	mov    (%eax),%eax
  8037fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803800:	e9 d5 00 00 00       	jmp    8038da <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803808:	8b 00                	mov    (%eax),%eax
  80380a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  80380d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803810:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803815:	29 c2                	sub    %eax,%edx
  803817:	89 d0                	mov    %edx,%eax
  803819:	c1 e8 0c             	shr    $0xc,%eax
  80381c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  80381f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803822:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803825:	0f 85 a9 00 00 00    	jne    8038d4 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  80382b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80382f:	75 17                	jne    803848 <free_block+0x22b>
  803831:	83 ec 04             	sub    $0x4,%esp
  803834:	68 c5 4a 80 00       	push   $0x804ac5
  803839:	68 04 01 00 00       	push   $0x104
  80383e:	68 2b 4a 80 00       	push   $0x804a2b
  803843:	e8 e6 d0 ff ff       	call   80092e <_panic>
  803848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384b:	8b 00                	mov    (%eax),%eax
  80384d:	85 c0                	test   %eax,%eax
  80384f:	74 10                	je     803861 <free_block+0x244>
  803851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803854:	8b 00                	mov    (%eax),%eax
  803856:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803859:	8b 52 04             	mov    0x4(%edx),%edx
  80385c:	89 50 04             	mov    %edx,0x4(%eax)
  80385f:	eb 14                	jmp    803875 <free_block+0x258>
  803861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803864:	8b 40 04             	mov    0x4(%eax),%eax
  803867:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80386a:	c1 e2 04             	shl    $0x4,%edx
  80386d:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803873:	89 02                	mov    %eax,(%edx)
  803875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803878:	8b 40 04             	mov    0x4(%eax),%eax
  80387b:	85 c0                	test   %eax,%eax
  80387d:	74 0f                	je     80388e <free_block+0x271>
  80387f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803882:	8b 40 04             	mov    0x4(%eax),%eax
  803885:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803888:	8b 12                	mov    (%edx),%edx
  80388a:	89 10                	mov    %edx,(%eax)
  80388c:	eb 13                	jmp    8038a1 <free_block+0x284>
  80388e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803891:	8b 00                	mov    (%eax),%eax
  803893:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803896:	c1 e2 04             	shl    $0x4,%edx
  803899:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80389f:	89 02                	mov    %eax,(%edx)
  8038a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b7:	c1 e0 04             	shl    $0x4,%eax
  8038ba:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8038bf:	8b 00                	mov    (%eax),%eax
  8038c1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c7:	c1 e0 04             	shl    $0x4,%eax
  8038ca:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8038cf:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8038d1:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8038d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8038da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038de:	0f 85 21 ff ff ff    	jne    803805 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8038e4:	b8 00 10 00 00       	mov    $0x1000,%eax
  8038e9:	99                   	cltd   
  8038ea:	f7 7d e8             	idivl  -0x18(%ebp)
  8038ed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8038f0:	74 17                	je     803909 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8038f2:	83 ec 04             	sub    $0x4,%esp
  8038f5:	68 14 4c 80 00       	push   $0x804c14
  8038fa:	68 0c 01 00 00       	push   $0x10c
  8038ff:	68 2b 4a 80 00       	push   $0x804a2b
  803904:	e8 25 d0 ff ff       	call   80092e <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803909:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80390c:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803912:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803915:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  80391b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80391f:	75 17                	jne    803938 <free_block+0x31b>
  803921:	83 ec 04             	sub    $0x4,%esp
  803924:	68 e4 4a 80 00       	push   $0x804ae4
  803929:	68 11 01 00 00       	push   $0x111
  80392e:	68 2b 4a 80 00       	push   $0x804a2b
  803933:	e8 f6 cf ff ff       	call   80092e <_panic>
  803938:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80393e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803941:	89 50 04             	mov    %edx,0x4(%eax)
  803944:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803947:	8b 40 04             	mov    0x4(%eax),%eax
  80394a:	85 c0                	test   %eax,%eax
  80394c:	74 0c                	je     80395a <free_block+0x33d>
  80394e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803953:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803956:	89 10                	mov    %edx,(%eax)
  803958:	eb 08                	jmp    803962 <free_block+0x345>
  80395a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80395d:	a3 48 50 80 00       	mov    %eax,0x805048
  803962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803965:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80396a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80396d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803973:	a1 54 50 80 00       	mov    0x805054,%eax
  803978:	40                   	inc    %eax
  803979:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  80397e:	83 ec 0c             	sub    $0xc,%esp
  803981:	ff 75 ec             	pushl  -0x14(%ebp)
  803984:	e8 2b f4 ff ff       	call   802db4 <to_page_va>
  803989:	83 c4 10             	add    $0x10,%esp
  80398c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  80398f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803992:	83 ec 0c             	sub    $0xc,%esp
  803995:	50                   	push   %eax
  803996:	e8 69 e8 ff ff       	call   802204 <return_page>
  80399b:	83 c4 10             	add    $0x10,%esp
  80399e:	eb 01                	jmp    8039a1 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8039a0:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8039a1:	c9                   	leave  
  8039a2:	c3                   	ret    

008039a3 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8039a3:	55                   	push   %ebp
  8039a4:	89 e5                	mov    %esp,%ebp
  8039a6:	83 ec 14             	sub    $0x14,%esp
  8039a9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8039ac:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8039b0:	77 07                	ja     8039b9 <nearest_pow2_ceil.1572+0x16>
      return 1;
  8039b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8039b7:	eb 20                	jmp    8039d9 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8039b9:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8039c0:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8039c3:	eb 08                	jmp    8039cd <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8039c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8039c8:	01 c0                	add    %eax,%eax
  8039ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8039cd:	d1 6d 08             	shrl   0x8(%ebp)
  8039d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039d4:	75 ef                	jne    8039c5 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8039d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8039d9:	c9                   	leave  
  8039da:	c3                   	ret    

008039db <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8039db:	55                   	push   %ebp
  8039dc:	89 e5                	mov    %esp,%ebp
  8039de:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8039e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039e5:	75 13                	jne    8039fa <realloc_block+0x1f>
    return alloc_block(new_size);
  8039e7:	83 ec 0c             	sub    $0xc,%esp
  8039ea:	ff 75 0c             	pushl  0xc(%ebp)
  8039ed:	e8 d1 f6 ff ff       	call   8030c3 <alloc_block>
  8039f2:	83 c4 10             	add    $0x10,%esp
  8039f5:	e9 d9 00 00 00       	jmp    803ad3 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  8039fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039fe:	75 18                	jne    803a18 <realloc_block+0x3d>
    free_block(va);
  803a00:	83 ec 0c             	sub    $0xc,%esp
  803a03:	ff 75 08             	pushl  0x8(%ebp)
  803a06:	e8 12 fc ff ff       	call   80361d <free_block>
  803a0b:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803a0e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a13:	e9 bb 00 00 00       	jmp    803ad3 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803a18:	83 ec 0c             	sub    $0xc,%esp
  803a1b:	ff 75 08             	pushl  0x8(%ebp)
  803a1e:	e8 38 f6 ff ff       	call   80305b <get_block_size>
  803a23:	83 c4 10             	add    $0x10,%esp
  803a26:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803a29:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a33:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803a36:	73 06                	jae    803a3e <realloc_block+0x63>
    new_size = min_block_size;
  803a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a3b:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803a3e:	83 ec 0c             	sub    $0xc,%esp
  803a41:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803a44:	ff 75 0c             	pushl  0xc(%ebp)
  803a47:	89 c1                	mov    %eax,%ecx
  803a49:	e8 55 ff ff ff       	call   8039a3 <nearest_pow2_ceil.1572>
  803a4e:	83 c4 10             	add    $0x10,%esp
  803a51:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803a54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a57:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803a5a:	75 05                	jne    803a61 <realloc_block+0x86>
    return va;
  803a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5f:	eb 72                	jmp    803ad3 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803a61:	83 ec 0c             	sub    $0xc,%esp
  803a64:	ff 75 0c             	pushl  0xc(%ebp)
  803a67:	e8 57 f6 ff ff       	call   8030c3 <alloc_block>
  803a6c:	83 c4 10             	add    $0x10,%esp
  803a6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803a72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a76:	75 07                	jne    803a7f <realloc_block+0xa4>
    return NULL;
  803a78:	b8 00 00 00 00       	mov    $0x0,%eax
  803a7d:	eb 54                	jmp    803ad3 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803a7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a82:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a85:	39 d0                	cmp    %edx,%eax
  803a87:	76 02                	jbe    803a8b <realloc_block+0xb0>
  803a89:	89 d0                	mov    %edx,%eax
  803a8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a91:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803a94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a97:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803a9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803aa1:	eb 17                	jmp    803aba <realloc_block+0xdf>
    dst[i] = src[i];
  803aa3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa9:	01 c2                	add    %eax,%edx
  803aab:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab1:	01 c8                	add    %ecx,%eax
  803ab3:	8a 00                	mov    (%eax),%al
  803ab5:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803ab7:	ff 45 f4             	incl   -0xc(%ebp)
  803aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803ac0:	72 e1                	jb     803aa3 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803ac2:	83 ec 0c             	sub    $0xc,%esp
  803ac5:	ff 75 08             	pushl  0x8(%ebp)
  803ac8:	e8 50 fb ff ff       	call   80361d <free_block>
  803acd:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803ad3:	c9                   	leave  
  803ad4:	c3                   	ret    
  803ad5:	66 90                	xchg   %ax,%ax
  803ad7:	90                   	nop

00803ad8 <__udivdi3>:
  803ad8:	55                   	push   %ebp
  803ad9:	57                   	push   %edi
  803ada:	56                   	push   %esi
  803adb:	53                   	push   %ebx
  803adc:	83 ec 1c             	sub    $0x1c,%esp
  803adf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ae3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ae7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803aeb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803aef:	89 ca                	mov    %ecx,%edx
  803af1:	89 f8                	mov    %edi,%eax
  803af3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803af7:	85 f6                	test   %esi,%esi
  803af9:	75 2d                	jne    803b28 <__udivdi3+0x50>
  803afb:	39 cf                	cmp    %ecx,%edi
  803afd:	77 65                	ja     803b64 <__udivdi3+0x8c>
  803aff:	89 fd                	mov    %edi,%ebp
  803b01:	85 ff                	test   %edi,%edi
  803b03:	75 0b                	jne    803b10 <__udivdi3+0x38>
  803b05:	b8 01 00 00 00       	mov    $0x1,%eax
  803b0a:	31 d2                	xor    %edx,%edx
  803b0c:	f7 f7                	div    %edi
  803b0e:	89 c5                	mov    %eax,%ebp
  803b10:	31 d2                	xor    %edx,%edx
  803b12:	89 c8                	mov    %ecx,%eax
  803b14:	f7 f5                	div    %ebp
  803b16:	89 c1                	mov    %eax,%ecx
  803b18:	89 d8                	mov    %ebx,%eax
  803b1a:	f7 f5                	div    %ebp
  803b1c:	89 cf                	mov    %ecx,%edi
  803b1e:	89 fa                	mov    %edi,%edx
  803b20:	83 c4 1c             	add    $0x1c,%esp
  803b23:	5b                   	pop    %ebx
  803b24:	5e                   	pop    %esi
  803b25:	5f                   	pop    %edi
  803b26:	5d                   	pop    %ebp
  803b27:	c3                   	ret    
  803b28:	39 ce                	cmp    %ecx,%esi
  803b2a:	77 28                	ja     803b54 <__udivdi3+0x7c>
  803b2c:	0f bd fe             	bsr    %esi,%edi
  803b2f:	83 f7 1f             	xor    $0x1f,%edi
  803b32:	75 40                	jne    803b74 <__udivdi3+0x9c>
  803b34:	39 ce                	cmp    %ecx,%esi
  803b36:	72 0a                	jb     803b42 <__udivdi3+0x6a>
  803b38:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b3c:	0f 87 9e 00 00 00    	ja     803be0 <__udivdi3+0x108>
  803b42:	b8 01 00 00 00       	mov    $0x1,%eax
  803b47:	89 fa                	mov    %edi,%edx
  803b49:	83 c4 1c             	add    $0x1c,%esp
  803b4c:	5b                   	pop    %ebx
  803b4d:	5e                   	pop    %esi
  803b4e:	5f                   	pop    %edi
  803b4f:	5d                   	pop    %ebp
  803b50:	c3                   	ret    
  803b51:	8d 76 00             	lea    0x0(%esi),%esi
  803b54:	31 ff                	xor    %edi,%edi
  803b56:	31 c0                	xor    %eax,%eax
  803b58:	89 fa                	mov    %edi,%edx
  803b5a:	83 c4 1c             	add    $0x1c,%esp
  803b5d:	5b                   	pop    %ebx
  803b5e:	5e                   	pop    %esi
  803b5f:	5f                   	pop    %edi
  803b60:	5d                   	pop    %ebp
  803b61:	c3                   	ret    
  803b62:	66 90                	xchg   %ax,%ax
  803b64:	89 d8                	mov    %ebx,%eax
  803b66:	f7 f7                	div    %edi
  803b68:	31 ff                	xor    %edi,%edi
  803b6a:	89 fa                	mov    %edi,%edx
  803b6c:	83 c4 1c             	add    $0x1c,%esp
  803b6f:	5b                   	pop    %ebx
  803b70:	5e                   	pop    %esi
  803b71:	5f                   	pop    %edi
  803b72:	5d                   	pop    %ebp
  803b73:	c3                   	ret    
  803b74:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b79:	89 eb                	mov    %ebp,%ebx
  803b7b:	29 fb                	sub    %edi,%ebx
  803b7d:	89 f9                	mov    %edi,%ecx
  803b7f:	d3 e6                	shl    %cl,%esi
  803b81:	89 c5                	mov    %eax,%ebp
  803b83:	88 d9                	mov    %bl,%cl
  803b85:	d3 ed                	shr    %cl,%ebp
  803b87:	89 e9                	mov    %ebp,%ecx
  803b89:	09 f1                	or     %esi,%ecx
  803b8b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b8f:	89 f9                	mov    %edi,%ecx
  803b91:	d3 e0                	shl    %cl,%eax
  803b93:	89 c5                	mov    %eax,%ebp
  803b95:	89 d6                	mov    %edx,%esi
  803b97:	88 d9                	mov    %bl,%cl
  803b99:	d3 ee                	shr    %cl,%esi
  803b9b:	89 f9                	mov    %edi,%ecx
  803b9d:	d3 e2                	shl    %cl,%edx
  803b9f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ba3:	88 d9                	mov    %bl,%cl
  803ba5:	d3 e8                	shr    %cl,%eax
  803ba7:	09 c2                	or     %eax,%edx
  803ba9:	89 d0                	mov    %edx,%eax
  803bab:	89 f2                	mov    %esi,%edx
  803bad:	f7 74 24 0c          	divl   0xc(%esp)
  803bb1:	89 d6                	mov    %edx,%esi
  803bb3:	89 c3                	mov    %eax,%ebx
  803bb5:	f7 e5                	mul    %ebp
  803bb7:	39 d6                	cmp    %edx,%esi
  803bb9:	72 19                	jb     803bd4 <__udivdi3+0xfc>
  803bbb:	74 0b                	je     803bc8 <__udivdi3+0xf0>
  803bbd:	89 d8                	mov    %ebx,%eax
  803bbf:	31 ff                	xor    %edi,%edi
  803bc1:	e9 58 ff ff ff       	jmp    803b1e <__udivdi3+0x46>
  803bc6:	66 90                	xchg   %ax,%ax
  803bc8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bcc:	89 f9                	mov    %edi,%ecx
  803bce:	d3 e2                	shl    %cl,%edx
  803bd0:	39 c2                	cmp    %eax,%edx
  803bd2:	73 e9                	jae    803bbd <__udivdi3+0xe5>
  803bd4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bd7:	31 ff                	xor    %edi,%edi
  803bd9:	e9 40 ff ff ff       	jmp    803b1e <__udivdi3+0x46>
  803bde:	66 90                	xchg   %ax,%ax
  803be0:	31 c0                	xor    %eax,%eax
  803be2:	e9 37 ff ff ff       	jmp    803b1e <__udivdi3+0x46>
  803be7:	90                   	nop

00803be8 <__umoddi3>:
  803be8:	55                   	push   %ebp
  803be9:	57                   	push   %edi
  803bea:	56                   	push   %esi
  803beb:	53                   	push   %ebx
  803bec:	83 ec 1c             	sub    $0x1c,%esp
  803bef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bf3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bf7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bfb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803bff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c07:	89 f3                	mov    %esi,%ebx
  803c09:	89 fa                	mov    %edi,%edx
  803c0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c0f:	89 34 24             	mov    %esi,(%esp)
  803c12:	85 c0                	test   %eax,%eax
  803c14:	75 1a                	jne    803c30 <__umoddi3+0x48>
  803c16:	39 f7                	cmp    %esi,%edi
  803c18:	0f 86 a2 00 00 00    	jbe    803cc0 <__umoddi3+0xd8>
  803c1e:	89 c8                	mov    %ecx,%eax
  803c20:	89 f2                	mov    %esi,%edx
  803c22:	f7 f7                	div    %edi
  803c24:	89 d0                	mov    %edx,%eax
  803c26:	31 d2                	xor    %edx,%edx
  803c28:	83 c4 1c             	add    $0x1c,%esp
  803c2b:	5b                   	pop    %ebx
  803c2c:	5e                   	pop    %esi
  803c2d:	5f                   	pop    %edi
  803c2e:	5d                   	pop    %ebp
  803c2f:	c3                   	ret    
  803c30:	39 f0                	cmp    %esi,%eax
  803c32:	0f 87 ac 00 00 00    	ja     803ce4 <__umoddi3+0xfc>
  803c38:	0f bd e8             	bsr    %eax,%ebp
  803c3b:	83 f5 1f             	xor    $0x1f,%ebp
  803c3e:	0f 84 ac 00 00 00    	je     803cf0 <__umoddi3+0x108>
  803c44:	bf 20 00 00 00       	mov    $0x20,%edi
  803c49:	29 ef                	sub    %ebp,%edi
  803c4b:	89 fe                	mov    %edi,%esi
  803c4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c51:	89 e9                	mov    %ebp,%ecx
  803c53:	d3 e0                	shl    %cl,%eax
  803c55:	89 d7                	mov    %edx,%edi
  803c57:	89 f1                	mov    %esi,%ecx
  803c59:	d3 ef                	shr    %cl,%edi
  803c5b:	09 c7                	or     %eax,%edi
  803c5d:	89 e9                	mov    %ebp,%ecx
  803c5f:	d3 e2                	shl    %cl,%edx
  803c61:	89 14 24             	mov    %edx,(%esp)
  803c64:	89 d8                	mov    %ebx,%eax
  803c66:	d3 e0                	shl    %cl,%eax
  803c68:	89 c2                	mov    %eax,%edx
  803c6a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c6e:	d3 e0                	shl    %cl,%eax
  803c70:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c74:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c78:	89 f1                	mov    %esi,%ecx
  803c7a:	d3 e8                	shr    %cl,%eax
  803c7c:	09 d0                	or     %edx,%eax
  803c7e:	d3 eb                	shr    %cl,%ebx
  803c80:	89 da                	mov    %ebx,%edx
  803c82:	f7 f7                	div    %edi
  803c84:	89 d3                	mov    %edx,%ebx
  803c86:	f7 24 24             	mull   (%esp)
  803c89:	89 c6                	mov    %eax,%esi
  803c8b:	89 d1                	mov    %edx,%ecx
  803c8d:	39 d3                	cmp    %edx,%ebx
  803c8f:	0f 82 87 00 00 00    	jb     803d1c <__umoddi3+0x134>
  803c95:	0f 84 91 00 00 00    	je     803d2c <__umoddi3+0x144>
  803c9b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c9f:	29 f2                	sub    %esi,%edx
  803ca1:	19 cb                	sbb    %ecx,%ebx
  803ca3:	89 d8                	mov    %ebx,%eax
  803ca5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ca9:	d3 e0                	shl    %cl,%eax
  803cab:	89 e9                	mov    %ebp,%ecx
  803cad:	d3 ea                	shr    %cl,%edx
  803caf:	09 d0                	or     %edx,%eax
  803cb1:	89 e9                	mov    %ebp,%ecx
  803cb3:	d3 eb                	shr    %cl,%ebx
  803cb5:	89 da                	mov    %ebx,%edx
  803cb7:	83 c4 1c             	add    $0x1c,%esp
  803cba:	5b                   	pop    %ebx
  803cbb:	5e                   	pop    %esi
  803cbc:	5f                   	pop    %edi
  803cbd:	5d                   	pop    %ebp
  803cbe:	c3                   	ret    
  803cbf:	90                   	nop
  803cc0:	89 fd                	mov    %edi,%ebp
  803cc2:	85 ff                	test   %edi,%edi
  803cc4:	75 0b                	jne    803cd1 <__umoddi3+0xe9>
  803cc6:	b8 01 00 00 00       	mov    $0x1,%eax
  803ccb:	31 d2                	xor    %edx,%edx
  803ccd:	f7 f7                	div    %edi
  803ccf:	89 c5                	mov    %eax,%ebp
  803cd1:	89 f0                	mov    %esi,%eax
  803cd3:	31 d2                	xor    %edx,%edx
  803cd5:	f7 f5                	div    %ebp
  803cd7:	89 c8                	mov    %ecx,%eax
  803cd9:	f7 f5                	div    %ebp
  803cdb:	89 d0                	mov    %edx,%eax
  803cdd:	e9 44 ff ff ff       	jmp    803c26 <__umoddi3+0x3e>
  803ce2:	66 90                	xchg   %ax,%ax
  803ce4:	89 c8                	mov    %ecx,%eax
  803ce6:	89 f2                	mov    %esi,%edx
  803ce8:	83 c4 1c             	add    $0x1c,%esp
  803ceb:	5b                   	pop    %ebx
  803cec:	5e                   	pop    %esi
  803ced:	5f                   	pop    %edi
  803cee:	5d                   	pop    %ebp
  803cef:	c3                   	ret    
  803cf0:	3b 04 24             	cmp    (%esp),%eax
  803cf3:	72 06                	jb     803cfb <__umoddi3+0x113>
  803cf5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cf9:	77 0f                	ja     803d0a <__umoddi3+0x122>
  803cfb:	89 f2                	mov    %esi,%edx
  803cfd:	29 f9                	sub    %edi,%ecx
  803cff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d03:	89 14 24             	mov    %edx,(%esp)
  803d06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d0e:	8b 14 24             	mov    (%esp),%edx
  803d11:	83 c4 1c             	add    $0x1c,%esp
  803d14:	5b                   	pop    %ebx
  803d15:	5e                   	pop    %esi
  803d16:	5f                   	pop    %edi
  803d17:	5d                   	pop    %ebp
  803d18:	c3                   	ret    
  803d19:	8d 76 00             	lea    0x0(%esi),%esi
  803d1c:	2b 04 24             	sub    (%esp),%eax
  803d1f:	19 fa                	sbb    %edi,%edx
  803d21:	89 d1                	mov    %edx,%ecx
  803d23:	89 c6                	mov    %eax,%esi
  803d25:	e9 71 ff ff ff       	jmp    803c9b <__umoddi3+0xb3>
  803d2a:	66 90                	xchg   %ax,%ax
  803d2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d30:	72 ea                	jb     803d1c <__umoddi3+0x134>
  803d32:	89 d9                	mov    %ebx,%ecx
  803d34:	e9 62 ff ff ff       	jmp    803c9b <__umoddi3+0xb3>
